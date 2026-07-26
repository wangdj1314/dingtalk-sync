# -*- coding: utf-8 -*-
"""
崩溃日志与异常捕获模块
======================
- 全局 sys.excepthook 捕获主线程未处理异常
- Qt 消息处理器捕获 Qt 层致命错误
- QThread 工作线程异常兜底
- "脏标记"文件检测上次是否异常退出
- 崩溃报告写入 _sync_state/crash_log.txt
"""

import sys
import os
import traceback
import platform
import threading
from pathlib import Path
from datetime import datetime

# 崩溃日志路径 (与 dingtalk_sync.py 的 STATE_DIR 一致)
_BASE_DIR = Path(__file__).parent.parent.resolve()
_STATE_DIR = _BASE_DIR / "_sync_state"
CRASH_LOG_FILE = _STATE_DIR / "crash_log.txt"
DIRTY_FLAG_FILE = _STATE_DIR / ".running"

# 最大崩溃日志大小 (512 KB)，超过后截断保留后半部分
_MAX_LOG_SIZE = 512 * 1024

_installed = False


def _timestamp():
    return datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")[:-3]


def _system_info():
    """收集系统环境信息"""
    info = [
        f"Python:   {sys.version}",
        f"Platform: {platform.platform()}",
        f"Arch:     {platform.machine()}",
        f"PID:      {os.getpid()}",
        f"Thread:   {threading.current_thread().name}",
    ]
    try:
        import PySide6
        info.append(f"PySide6:  {PySide6.__version__}")
    except Exception:
        pass
    return "\n".join(info)


def _trim_log_file():
    """日志文件过大时截断，保留最后 256KB"""
    try:
        if CRASH_LOG_FILE.exists() and CRASH_LOG_FILE.stat().st_size > _MAX_LOG_SIZE:
            data = CRASH_LOG_FILE.read_bytes()
            keep = data[-(_MAX_LOG_SIZE // 2):]
            # 找到第一个完整行的开头
            nl = keep.find(b"\n")
            if nl > 0:
                keep = keep[nl + 1:]
            header = b"[... earlier entries truncated ...]\n"
            CRASH_LOG_FILE.write_bytes(header + keep)
    except Exception:
        pass


def write_crash_log(exc_type=None, exc_value=None, exc_tb=None,
                    context="main-thread", extra=""):
    """
    将崩溃信息写入 crash_log.txt。
    可在任何线程安全调用。
    """
    try:
        _STATE_DIR.mkdir(parents=True, exist_ok=True)

        lines = []
        lines.append("=" * 70)
        lines.append(f"[CRASH] {_timestamp()}  context={context}")
        lines.append("-" * 70)
        lines.append(_system_info())
        if extra:
            lines.append(f"Extra:    {extra}")
        lines.append("-" * 70)

        if exc_type is not None:
            tb_lines = traceback.format_exception(exc_type, exc_value, exc_tb)
            lines.append("".join(tb_lines).rstrip())
        else:
            lines.append("(no exception info)")

        lines.append("=" * 70)
        lines.append("")

        _trim_log_file()

        with open(CRASH_LOG_FILE, "a", encoding="utf-8") as f:
            f.write("\n".join(lines) + "\n")

    except Exception:
        # 写日志本身不能再崩
        pass


def write_info_log(message, context="info"):
    """写入一条普通信息到崩溃日志（用于记录关键生命周期事件）"""
    try:
        _STATE_DIR.mkdir(parents=True, exist_ok=True)
        _trim_log_file()
        with open(CRASH_LOG_FILE, "a", encoding="utf-8") as f:
            f.write(f"[{_timestamp()}] [{context}] {message}\n")
    except Exception:
        pass


# ---- 全局异常钩子 ----

_original_excepthook = None


def _global_excepthook(exc_type, exc_value, exc_tb):
    """sys.excepthook 替换：记录后调用原始钩子"""
    # KeyboardInterrupt 不算崩溃
    if issubclass(exc_type, KeyboardInterrupt):
        if _original_excepthook:
            _original_excepthook(exc_type, exc_value, exc_tb)
        return

    write_crash_log(exc_type, exc_value, exc_tb, context="main-thread")

    # 尝试弹出错误对话框（如果 Qt 可用）
    try:
        from PySide6.QtWidgets import QMessageBox, QApplication
        app = QApplication.instance()
        if app:
            tb_str = "".join(traceback.format_exception(exc_type, exc_value, exc_tb))
            # 只取最后几行
            short = "\n".join(tb_str.strip().split("\n")[-5:])
            QMessageBox.critical(
                None, "程序异常",
                f"发生未处理的异常，程序即将退出。\n\n"
                f"错误信息已保存到:\n{CRASH_LOG_FILE}\n\n"
                f"详情:\n{short}"
            )
    except Exception:
        pass

    if _original_excepthook:
        _original_excepthook(exc_type, exc_value, exc_tb)


# ---- Qt 消息处理器 ----

_original_qt_handler = None


def _qt_message_handler(mode, context, message):
    """捕获 Qt 层消息，Fatal 级别写入崩溃日志"""
    # mode: QtMsgType enum
    # QtDebugMsg=0, QtWarningMsg=1, QtCriticalMsg=2, QtFatalMsg=3, QtInfoMsg=4
    try:
        mode_val = int(mode)
    except Exception:
        mode_val = -1

    if mode_val >= 2:  # Critical or Fatal
        level = "FATAL" if mode_val == 3 else "CRITICAL"
        func = ""
        try:
            func = context.function or ""
        except Exception:
            pass
        write_info_log(
            f"Qt {level}: {message} (function={func})",
            context="qt-message"
        )

    # 调用原始处理器
    if _original_qt_handler:
        _original_qt_handler(mode, context, message)


# ---- 脏标记 (异常退出检测) ----

def mark_running():
    """启动时写入脏标记"""
    try:
        _STATE_DIR.mkdir(parents=True, exist_ok=True)
        info = {
            "pid": os.getpid(),
            "started_at": _timestamp(),
            "python": sys.version.split()[0],
            "platform": platform.platform(),
        }
        import json
        DIRTY_FLAG_FILE.write_text(
            json.dumps(info, ensure_ascii=False, indent=2),
            encoding="utf-8"
        )
    except Exception:
        pass


def mark_clean_shutdown():
    """正常退出时删除脏标记"""
    try:
        if DIRTY_FLAG_FILE.exists():
            DIRTY_FLAG_FILE.unlink()
    except Exception:
        pass


def check_previous_crash():
    """
    检查上次是否异常退出。
    返回 None 或 dict (包含上次运行信息)。
    """
    try:
        if DIRTY_FLAG_FILE.exists():
            import json
            info = json.loads(DIRTY_FLAG_FILE.read_text(encoding="utf-8"))
            return info
    except Exception:
        pass
    return None


# ---- 安装 ----

def install():
    """
    安装所有崩溃捕获钩子。应在 main() 最开头调用。
    """
    global _installed, _original_excepthook, _original_qt_handler
    if _installed:
        return
    _installed = True

    # 1. 全局异常钩子
    _original_excepthook = sys.excepthook
    sys.excepthook = _global_excepthook

    # 2. Qt 消息处理器
    try:
        from PySide6.QtCore import qInstallMessageHandler
        _original_qt_handler = qInstallMessageHandler(_qt_message_handler)
    except Exception:
        pass

    # 3. 写入启动记录
    write_info_log("Application starting", context="lifecycle")

    # 4. 设置脏标记
    mark_running()


def uninstall():
    """正常退出时调用，恢复钩子并清除脏标记"""
    global _installed
    if not _installed:
        return

    write_info_log("Application shutting down normally", context="lifecycle")
    mark_clean_shutdown()

    # 恢复原始钩子
    if _original_excepthook:
        sys.excepthook = _original_excepthook

    try:
        from PySide6.QtCore import qInstallMessageHandler
        if _original_qt_handler:
            qInstallMessageHandler(_original_qt_handler)
    except Exception:
        pass

    _installed = False
