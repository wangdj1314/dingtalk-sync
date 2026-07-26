# -*- coding: utf-8 -*-
"""
同步引擎封装 - QThread 后台工作线程
将 dingtalk_sync.py 的同步操作封装为 Qt 信号/槽机制，
供主界面调用并实时显示进度。
"""

import sys
import os
import json
import traceback
from pathlib import Path
from datetime import datetime

from PySide6.QtCore import QThread, Signal, QObject

# 将父目录加入 path 以导入 dingtalk_sync
_PARENT = str(Path(__file__).parent.parent)
if _PARENT not in sys.path:
    sys.path.insert(0, _PARENT)

import dingtalk_sync as ds
import crash_handler


class SyncSignal(QObject):
    """同步进度信号集"""
    log = Signal(str, str)          # (message, level)
    progress = Signal(int, int)     # (current, total)
    phase = Signal(str)             # 当前阶段描述
    finished = Signal(bool, str)    # (success, summary)


class BaseWorker(QThread):
    """工作线程基类"""

    def __init_subclass__(cls, **kwargs):
        """自动为子类的 run() 添加异常兜底，防止线程静默崩溃"""
        super().__init_subclass__(**kwargs)
        original_run = cls.__dict__.get("run")
        if original_run is None:
            return

        import functools

        @functools.wraps(original_run)
        def _safe_run(self):
            try:
                original_run(self)
            except InterruptedError:
                raise  # 用户取消，交给子类处理
            except Exception as e:
                crash_handler.write_crash_log(
                    *sys.exc_info(),
                    context=f"worker:{cls.__name__}",
                )
                try:
                    self._log(f"线程未捕获异常: {e}", "ERROR")
                    self._log(traceback.format_exc(), "ERROR")
                    self.sig.finished.emit(False, f"线程崩溃: {e}")
                except Exception:
                    pass

        cls.run = _safe_run

    def __init__(self, parent=None):
        super().__init__(parent)
        self.sig = SyncSignal()
        self._cancelled = False

    def cancel(self):
        self._cancelled = True
        ds.request_cancel()  # 通知底层同步引擎取消

    def _log(self, msg, level="INFO"):
        self.sig.log.emit(msg, level)

    def _check_cancel(self):
        if self._cancelled:
            raise InterruptedError("用户取消操作")


class AuthCheckWorker(BaseWorker):
    """认证检查 + 自动刷新"""

    def run(self):
        try:
            self._log("检查认证状态...")
            if not ds.DWS_CORE:
                ds.find_dws_core("")
            if not ds.DWS_CORE:
                self.sig.finished.emit(False, "未找到 dws-core")
                return

            status = ds.check_auth_status()
            if status.get("error"):
                self.sig.finished.emit(False, status["error"])
                return

            if not status.get("token_valid") and status.get("refresh_token_valid"):
                self._log("Token 已过期，尝试自动刷新...")
                ok, msg = ds.try_auth_refresh()
                if ok:
                    self._log(f"刷新成功: {msg}")
                    status = ds.check_auth_status()
                else:
                    self._log(f"刷新失败: {msg}", "WARN")

            ds.save_auth_state(status)
            valid = status.get("token_valid", False)
            hours = status.get("hours_left", 0)
            summary = f"Token {'有效' if valid else '无效'} (剩余 {hours:.1f}h)"
            self.sig.finished.emit(valid, summary)
        except Exception as e:
            self.sig.finished.emit(False, f"认证检查异常: {e}")


class LoginWorker(BaseWorker):
    """扫码登录（交互式，在子进程中运行）"""

    def run(self):
        try:
            if not ds.DWS_CORE:
                ds.find_dws_core("")
            if not ds.DWS_CORE:
                self.sig.finished.emit(False, "未找到 dws-core")
                return

            self._log("正在启动钉钉扫码登录...")
            self._log("请在弹出的浏览器中完成扫码授权")

            import subprocess
            ret = subprocess.call([ds.DWS_CORE, "auth", "login"])

            if ret == 0:
                self._log("登录成功！")
                # 清除告警标志
                try:
                    if ds.AUTH_ALERT_FILE.exists():
                        alert = json.loads(ds.AUTH_ALERT_FILE.read_text(encoding="utf-8"))
                        alert["resolved"] = True
                        alert["resolved_at"] = datetime.now().isoformat()
                        with open(ds.AUTH_ALERT_FILE, "w", encoding="utf-8") as f:
                            json.dump(alert, f, ensure_ascii=False, indent=2)
                except Exception:
                    pass
                status = ds.check_auth_status()
                ds.save_auth_state(status)
                hours = status.get("hours_left", 0)
                self.sig.finished.emit(True, f"登录成功，Token 有效 {hours:.1f}h")
            else:
                self.sig.finished.emit(False, f"登录失败 (exit code {ret})")
        except Exception as e:
            self.sig.finished.emit(False, f"登录异常: {e}")


class EstimateWorker(BaseWorker):
    """数据量估算"""

    def __init__(self, days=30, parent=None):
        super().__init__(parent)
        self.days = days
        self.result = None

    def run(self):
        try:
            if not ds.DWS_CORE:
                ds.find_dws_core("")
            ds.ensure_dirs()

            self._log(f"开始估算最近 {self.days} 天的数据量...")
            self.sig.phase.emit("正在扫描消息...")

            est = ds.estimate_sync_size(days=self.days, use_bulk=True)

            self.sig.phase.emit("估算完成")
            summary = (
                f"文件 {est['file_count']} 个 (待下载 {est['file_pending']}), "
                f"媒体 {est['image_count'] + est['video_count']} 个 (待下载 {est['image_pending']}), "
                f"预估 {est['est_total_str']}"
            )
            self._log(summary)
            self.result = est
            self.sig.finished.emit(True, summary)
        except Exception as e:
            self.result = None
            self.sig.finished.emit(False, f"估算失败: {e}")
            self._log(traceback.format_exc(), "ERROR")


class FileSyncWorker(BaseWorker):
    """文件 + 媒体同步"""

    def __init__(self, days=7, full=False, scan_only=False,
                 export_csv=False, use_bulk=True, force=False, parent=None):
        super().__init__(parent)
        self.days = days
        self.full = full
        self.scan_only = scan_only
        self.export_csv = export_csv
        self.use_bulk = use_bulk
        self.force = force

    def run(self):
        try:
            if not ds.DWS_CORE:
                ds.find_dws_core("")
            ds.ensure_dirs()
            ds.clear_cancel()

            # 构造模拟 args
            class Args:
                pass
            args = Args()
            args.full = self.full
            args.days = self.days
            args.scan_only = self.scan_only
            args.dry_run = False
            args.export_csv = self.export_csv
            args.all = self.export_csv
            args.no_bulk = not self.use_bulk
            args.force = self.force
            args.dingtalk_token = ""

            # 重定向 ds.log 到信号
            original_log = ds.log
            def _redirect_log(msg, level="INFO"):
                original_log(msg, level)
                self.sig.log.emit(msg, level)
            ds.log = _redirect_log

            try:
                self._check_cancel()
                self.sig.phase.emit("认证检查...")
                auth_ok, auth_msg = ds.ensure_auth()
                if not auth_ok:
                    self.sig.finished.emit(False, f"认证失败: {auth_msg}")
                    return

                self._check_cancel()
                self.sig.phase.emit("文件同步中...")
                ret = ds.run_sync(args)

                if ret == -1:
                    self.sig.finished.emit(False, "同步已被用户取消")
                    return

                if self.export_csv and not self.scan_only:
                    self._check_cancel()
                    self.sig.phase.emit("导出聊天记录...")
                    ds.run_export_csv(args)

                # 全量模式: 同步所有模块 (日程/待办/听记)
                if self.full and not self.scan_only:
                    self._check_cancel()
                    self.sig.phase.emit("同步日程...")
                    self._log("全量模式: 同步全部日程...")
                    ds.sync_calendar(full=True)

                    self._check_cancel()
                    self.sig.phase.emit("同步待办...")
                    self._log("全量模式: 同步待办...")
                    ds.sync_todo()

                    self._check_cancel()
                    self.sig.phase.emit("同步听记...")
                    self._log("全量模式: 同步听记...")
                    ds.sync_minutes(include_transcript=False)

                self.sig.phase.emit("同步完成")
                self.sig.finished.emit(ret == 0, f"文件同步完成 (exit={ret})")
            finally:
                ds.log = original_log

        except InterruptedError:
            self.sig.finished.emit(False, "用户取消")
        except Exception as e:
            self.sig.finished.emit(False, f"同步异常: {e}")
            self._log(traceback.format_exc(), "ERROR")


class CalendarSyncWorker(BaseWorker):
    """日程同步"""

    def __init__(self, days_back=7, days_forward=7, parent=None):
        super().__init__(parent)
        self.days_back = days_back
        self.days_forward = days_forward

    def run(self):
        try:
            if not ds.DWS_CORE:
                ds.find_dws_core("")
            ds.ensure_dirs()
            ds.clear_cancel()

            original_log = ds.log
            def _redirect_log(msg, level="INFO"):
                original_log(msg, level)
                self.sig.log.emit(msg, level)
            ds.log = _redirect_log

            try:
                self.sig.phase.emit("日程同步中...")
                ret = ds.sync_calendar(days_back=self.days_back, days_forward=self.days_forward)
                self.sig.finished.emit(ret == 0, "日程同步完成")
            finally:
                ds.log = original_log
        except Exception as e:
            self.sig.finished.emit(False, f"日程同步异常: {e}")


class TodoSyncWorker(BaseWorker):
    """待办同步"""

    def run(self):
        try:
            if not ds.DWS_CORE:
                ds.find_dws_core("")
            ds.ensure_dirs()
            ds.clear_cancel()

            original_log = ds.log
            def _redirect_log(msg, level="INFO"):
                original_log(msg, level)
                self.sig.log.emit(msg, level)
            ds.log = _redirect_log

            try:
                self.sig.phase.emit("待办同步中...")
                ret = ds.sync_todo()
                self.sig.finished.emit(ret == 0, "待办同步完成")
            finally:
                ds.log = original_log
        except Exception as e:
            self.sig.finished.emit(False, f"待办同步异常: {e}")


class MinutesSyncWorker(BaseWorker):
    """听记同步"""

    def __init__(self, include_transcript=False, parent=None):
        super().__init__(parent)
        self.include_transcript = include_transcript

    def run(self):
        try:
            if not ds.DWS_CORE:
                ds.find_dws_core("")
            ds.ensure_dirs()
            ds.clear_cancel()

            original_log = ds.log
            def _redirect_log(msg, level="INFO"):
                original_log(msg, level)
                self.sig.log.emit(msg, level)
            ds.log = _redirect_log

            try:
                self.sig.phase.emit("听记同步中...")
                ret = ds.sync_minutes(include_transcript=self.include_transcript)
                self.sig.finished.emit(ret == 0, "听记同步完成")
            finally:
                ds.log = original_log
        except Exception as e:
            self.sig.finished.emit(False, f"听记同步异常: {e}")


class ContactsSyncWorker(BaseWorker):
    """通讯录同步"""

    def run(self):
        try:
            if not ds.DWS_CORE:
                ds.find_dws_core("")
            ds.ensure_dirs()
            ds.clear_cancel()

            original_log = ds.log
            def _redirect_log(msg, level="INFO"):
                original_log(msg, level)
                self.sig.log.emit(msg, level)
            ds.log = _redirect_log

            try:
                self.sig.phase.emit("通讯录同步中...")
                ret = ds.sync_contacts()
                self.sig.finished.emit(ret == 0, "通讯录同步完成")
            finally:
                ds.log = original_log
        except Exception as e:
            self.sig.finished.emit(False, f"通讯录同步异常: {e}")


class StatusWorker(BaseWorker):
    """获取同步状态（用于刷新仪表盘）"""

    def run(self):
        try:
            if not ds.DWS_CORE:
                ds.find_dws_core("")
            ds.ensure_dirs()

            manifest = ds.load_manifest()
            image_manifest = ds.load_image_manifest()
            convs = ds.load_json(ds.CONVS_FILE)

            total = len(manifest)
            downloaded = sum(1 for r in manifest.values() if r.get("_downloaded"))
            expired = sum(1 for r in manifest.values() if r.get("_expired"))
            failed = sum(1 for r in manifest.values() if r.get("_failed"))
            pending = total - downloaded - expired - failed

            img_total = len(image_manifest)
            img_downloaded = sum(1 for r in image_manifest.values() if r.get("_downloaded"))

            # 磁盘占用
            disk_size = 0
            disk_files = 0
            for root, dirs, files in os.walk(str(ds.BASE_DIR)):
                if "_sync_state" in root:
                    continue
                for fn in files:
                    fp = os.path.join(root, fn)
                    try:
                        disk_size += os.path.getsize(fp)
                        disk_files += 1
                    except OSError:
                        pass

            # 日程/待办/听记/通讯录状态
            cal_state = ds.load_json(ds.CALENDAR_STATE_FILE, {})
            todo_state = ds.load_json(ds.TODO_STATE_FILE, {})
            min_state = ds.load_json(ds.MINUTES_STATE_FILE, {})
            contacts_state = ds.load_json(ds.CONTACTS_STATE_FILE, {})

            # 认证状态
            auth = ds.check_auth_status()

            self.result = {
                "convs": len(convs) if convs else 0,
                "file_total": total,
                "file_downloaded": downloaded,
                "file_expired": expired,
                "file_failed": failed,
                "file_pending": pending,
                "img_total": img_total,
                "img_downloaded": img_downloaded,
                "disk_files": disk_files,
                "disk_size": disk_size,
                "disk_size_str": ds.format_size(disk_size),
                "cal_count": cal_state.get("events_count", 0),
                "cal_last": cal_state.get("last_sync", ""),
                "todo_count": todo_state.get("total_count", 0),
                "todo_last": todo_state.get("last_sync", ""),
                "min_count": min_state.get("total_minutes", 0),
                "min_last": min_state.get("last_sync", ""),
                "contact_count": contacts_state.get("total_count", 0),
                "contact_last": contacts_state.get("last_sync", ""),
                "auth_valid": auth.get("token_valid", False),
                "auth_hours": auth.get("hours_left", 0),
                "auth_user": auth.get("user_name", ""),
            }
            self.sig.finished.emit(True, "状态刷新完成")
        except Exception as e:
            self.result = None
            self.sig.finished.emit(False, f"状态获取失败: {e}")


class RetryFailedWorker(BaseWorker):
    """重试失败的文件和媒体"""

    def run(self):
        try:
            if not ds.DWS_CORE:
                ds.find_dws_core("")
            ds.ensure_dirs()
            ds.clear_cancel()

            original_log = ds.log
            def _redirect_log(msg, level="INFO"):
                original_log(msg, level)
                self.sig.log.emit(msg, level)
            ds.log = _redirect_log

            try:
                self.sig.phase.emit("重试失败文件...")
                f_ok, f_fail = ds.retry_failed_files()

                self._check_cancel()
                self.sig.phase.emit("重试失败媒体...")
                m_ok, m_fail = ds.retry_failed_media()

                summary = f"重试完成: 文件 成功{f_ok}/失败{f_fail}, 媒体 成功{m_ok}/失败{m_fail}"
                self.sig.finished.emit(True, summary)
            finally:
                ds.log = original_log
        except InterruptedError:
            self.sig.finished.emit(False, "用户取消")
        except Exception as e:
            self.sig.finished.emit(False, f"重试异常: {e}")
