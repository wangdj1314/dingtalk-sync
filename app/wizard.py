# -*- coding: utf-8 -*-
"""
钉钉同步 - 首次运行设置向导
流程: 欢迎 → 扫码登录 → 数据估算 → 选择同步目录 → 完成
"""

import sys
import os
import json
import shutil
from pathlib import Path

from PySide6.QtWidgets import (
    QWizard, QWizardPage, QVBoxLayout, QHBoxLayout, QLabel,
    QPushButton, QLineEdit, QFileDialog, QGroupBox, QGridLayout,
    QProgressBar, QMessageBox,
)
from PySide6.QtCore import Qt, QTimer, Slot

_PARENT = str(Path(__file__).parent.parent)
if _PARENT not in sys.path:
    sys.path.insert(0, _PARENT)

import dingtalk_sync as ds
from sync_worker import LoginWorker, EstimateWorker


class WelcomePage(QWizardPage):
    """欢迎页"""

    def __init__(self):
        super().__init__()
        self.setTitle("欢迎使用钉钉同步工具")
        self.setSubTitle("本工具将自动同步钉钉中的文件、图片、日程、待办等数据到本地。")

        layout = QVBoxLayout(self)
        layout.setSpacing(16)

        info = QLabel(
            "设置向导将引导您完成以下步骤：\n\n"
            "  1. 扫码登录钉钉账号\n"
            "  2. 估算数据量和所需磁盘空间\n"
            "  3. 选择同步目录\n\n"
            "整个过程大约需要 2-3 分钟。"
        )
        info.setWordWrap(True)
        info.setStyleSheet("font-size: 13px; color: #2c3e50;")
        layout.addWidget(info)

        # 检测 dws-core
        self.lbl_dws = QLabel("正在检测 dws-core...")
        self.lbl_dws.setStyleSheet("color: #7f8c8d; font-size: 12px;")
        layout.addWidget(self.lbl_dws)

        layout.addStretch()

    def initializePage(self):
        found = ds.find_dws_core("")
        if found:
            ver = ""
            try:
                import subprocess
                r = subprocess.run([ds.DWS_CORE, "version"], capture_output=True, timeout=5)
                ver = r.stdout.decode("utf-8", errors="replace").strip()
            except Exception:
                pass
            self.lbl_dws.setText(f"dws-core 已就绪: {ds.DWS_CORE}\n{ver}")
            self.lbl_dws.setStyleSheet("color: #27ae60; font-size: 12px;")
        else:
            self.lbl_dws.setText("未找到 dws-core，请确认 QoderWork 已安装。")
            self.lbl_dws.setStyleSheet("color: #e74c3c; font-size: 12px;")


class LoginPage(QWizardPage):
    """扫码登录页"""

    def __init__(self):
        super().__init__()
        self.setTitle("扫码登录")
        self.setSubTitle("点击下方按钮启动钉钉扫码登录，在浏览器中完成授权。")

        layout = QVBoxLayout(self)
        layout.setSpacing(12)

        self.lbl_status = QLabel("尚未登录")
        self.lbl_status.setStyleSheet("font-size: 14px; color: #7f8c8d;")
        self.lbl_status.setAlignment(Qt.AlignCenter)
        layout.addWidget(self.lbl_status)

        btn_row = QHBoxLayout()
        self.btn_login = QPushButton("启动扫码登录")
        self.btn_login.setFixedWidth(160)
        self.btn_login.clicked.connect(self._do_login)
        btn_row.addStretch()
        btn_row.addWidget(self.btn_login)
        btn_row.addStretch()
        layout.addLayout(btn_row)

        self.lbl_detail = QLabel("")
        self.lbl_detail.setWordWrap(True)
        self.lbl_detail.setStyleSheet("font-size: 12px; color: #7f8c8d;")
        self.lbl_detail.setAlignment(Qt.AlignCenter)
        layout.addWidget(self.lbl_detail)

        layout.addStretch()
        self._worker = None

    def _do_login(self):
        self.btn_login.setEnabled(False)
        self.lbl_status.setText("正在等待扫码...")
        self.lbl_status.setStyleSheet("font-size: 14px; color: #f39c12;")

        self._worker = LoginWorker()
        self._worker.sig.log.connect(self._on_log)
        self._worker.sig.finished.connect(self._on_done)
        self._worker.start()

    @Slot(str, str)
    def _on_log(self, msg, level):
        self.lbl_detail.setText(msg)

    @Slot(bool, str)
    def _on_done(self, ok, summary):
        self.btn_login.setEnabled(True)
        if ok:
            self.lbl_status.setText("登录成功！")
            self.lbl_status.setStyleSheet("font-size: 14px; color: #27ae60; font-weight: bold;")
            self.lbl_detail.setText(summary)
            self.wizard().next()
        else:
            self.lbl_status.setText("登录失败")
            self.lbl_status.setStyleSheet("font-size: 14px; color: #e74c3c;")
            self.lbl_detail.setText(summary)

    def isComplete(self):
        # 检查是否已登录
        try:
            status = ds.check_auth_status()
            return status.get("token_valid", False)
        except Exception:
            return False


class EstimatePage(QWizardPage):
    """数据估算页"""

    def __init__(self):
        super().__init__()
        self.setTitle("数据量估算")
        self.setSubTitle("正在扫描您的钉钉消息，估算文件和媒体的数量及所需空间。")

        layout = QVBoxLayout(self)
        layout.setSpacing(12)

        self.progress = QProgressBar()
        self.progress.setRange(0, 0)
        layout.addWidget(self.progress)

        self.lbl_status = QLabel("准备估算...")
        self.lbl_status.setStyleSheet("font-size: 13px; color: #2c3e50;")
        layout.addWidget(self.lbl_status)

        # 估算结果
        self.result_group = QGroupBox("估算结果")
        rg = QGridLayout(self.result_group)
        self._result_labels = {}
        for row, (key, label) in enumerate([
            ("files", "文件消息"), ("media", "图片/视频"),
            ("pending", "待下载"), ("est_size", "预估空间"),
        ]):
            rg.addWidget(QLabel(label + ":"), row, 0)
            val = QLabel("--")
            val.setStyleSheet("font-weight: bold;")
            rg.addWidget(val, row, 1)
            self._result_labels[key] = val
        self.result_group.setVisible(False)
        layout.addWidget(self.result_group)

        layout.addStretch()
        self._worker = None
        self._done = False

    def initializePage(self):
        self._done = False
        self.result_group.setVisible(False)
        self.progress.setVisible(True)
        self.lbl_status.setText("正在扫描消息，请稍候...")

        self._worker = EstimateWorker(days=30)
        self._worker.sig.log.connect(self._on_log)
        self._worker.sig.finished.connect(self._on_done)
        self._worker.start()

    @Slot(str, str)
    def _on_log(self, msg, level):
        self.lbl_status.setText(msg)

    @Slot(bool, str)
    def _on_done(self, ok, summary):
        self.progress.setVisible(False)
        self._done = True

        if ok and self._worker.result:
            est = self._worker.result
            self._result_labels["files"].setText(
                f"{est['file_count']} 个 (已下载 {est['file_downloaded']})")
            self._result_labels["media"].setText(
                f"{est['image_count'] + est['video_count']} 个 (已下载 {est['image_downloaded']})")
            self._result_labels["pending"].setText(
                f"文件 {est['file_pending']} + 媒体 {est['image_pending']}")
            self._result_labels["est_size"].setText(est['est_total_str'])
            self.result_group.setVisible(True)
            self.lbl_status.setText("估算完成！")
            self.lbl_status.setStyleSheet("font-size: 13px; color: #27ae60; font-weight: bold;")
        else:
            self.lbl_status.setText(f"估算失败: {summary}")
            self.lbl_status.setStyleSheet("font-size: 13px; color: #e74c3c;")

        self.completeChanged.emit()

    def isComplete(self):
        return self._done


class DirectoryPage(QWizardPage):
    """选择同步目录 + 磁盘空间检查"""

    def __init__(self):
        super().__init__()
        self.setTitle("选择同步目录")
        self.setSubTitle("选择文件同步的目标目录，系统将检查磁盘可用空间。")

        layout = QVBoxLayout(self)
        layout.setSpacing(12)

        # 目录选择
        dir_row = QHBoxLayout()
        self.edit_dir = QLineEdit(str(ds.BASE_DIR))
        self.edit_dir.setReadOnly(True)
        dir_row.addWidget(self.edit_dir, stretch=1)

        btn_browse = QPushButton("浏览...")
        btn_browse.setFixedWidth(80)
        btn_browse.clicked.connect(self._browse)
        dir_row.addWidget(btn_browse)
        layout.addLayout(dir_row)

        # 磁盘空间信息
        self.grp_disk = QGroupBox("磁盘空间")
        dg = QGridLayout(self.grp_disk)
        self._disk_labels = {}
        for row, (key, label) in enumerate([
            ("total", "总容量"), ("used", "已使用"),
            ("free", "可用空间"), ("status", "状态"),
        ]):
            dg.addWidget(QLabel(label + ":"), row, 0)
            val = QLabel("--")
            if key == "status":
                val.setStyleSheet("font-weight: bold;")
            dg.addWidget(val, row, 1)
            self._disk_labels[key] = val
        layout.addWidget(self.grp_disk)

        layout.addStretch()
        self.edit_dir.textChanged.connect(self._check_space)
        QTimer.singleShot(300, self._check_space)

    def _browse(self):
        d = QFileDialog.getExistingDirectory(self, "选择同步目录", str(ds.BASE_DIR))
        if d:
            self.edit_dir.setText(d)

    def _check_space(self):
        path = self.edit_dir.text().strip()
        if not path:
            return
        disk = ds.check_disk_space(path)
        if disk["ok"]:
            self._disk_labels["total"].setText(disk["total_str"])
            self._disk_labels["used"].setText(disk["used_str"])
            self._disk_labels["free"].setText(disk["free_str"])

            # 获取估算结果
            est_page = self.wizard().page(2)  # EstimatePage
            est_bytes = 0
            if hasattr(est_page, '_worker') and est_page._worker and est_page._worker.result:
                est_bytes = est_page._worker.result.get("est_total_bytes", 0)

            if est_bytes > 0 and disk["free"] > 0:
                ratio = est_bytes / disk["free"]
                if ratio > 1.0:
                    self._disk_labels["status"].setText(
                        f"空间不足！需要 {ds.format_size(est_bytes)}，"
                        f"仅有 {disk['free_str']}")
                    self._disk_labels["status"].setStyleSheet(
                        "font-weight: bold; color: #e74c3c;")
                elif ratio > 0.8:
                    self._disk_labels["status"].setText(
                        f"空间较紧张 (预估占 {ratio*100:.0f}%)")
                    self._disk_labels["status"].setStyleSheet(
                        "font-weight: bold; color: #f39c12;")
                else:
                    self._disk_labels["status"].setText("空间充足")
                    self._disk_labels["status"].setStyleSheet(
                        "font-weight: bold; color: #27ae60;")
            else:
                self._disk_labels["status"].setText("--")
                self._disk_labels["status"].setStyleSheet("font-weight: bold;")
        else:
            self._disk_labels["total"].setText("?")
            self._disk_labels["used"].setText("?")
            self._disk_labels["free"].setText("?")
            self._disk_labels["status"].setText("无法检查")
            self._disk_labels["status"].setStyleSheet("color: #e74c3c;")


class FinishPage(QWizardPage):
    """完成页"""

    def __init__(self):
        super().__init__()
        self.setTitle("设置完成")
        self.setSubTitle("恭喜！钉钉同步工具已配置完成。")

        layout = QVBoxLayout(self)
        layout.setSpacing(12)

        info = QLabel(
            "您可以：\n\n"
            "  - 在「同步操作」页面手动触发同步\n"
            "  - 在「仪表盘」查看同步状态\n"
            "  - 最小化到系统托盘后台运行\n\n"
            "建议首次运行一次完整同步（默认扫描最近 7 天）。"
        )
        info.setWordWrap(True)
        info.setStyleSheet("font-size: 13px; color: #2c3e50;")
        layout.addWidget(info)
        layout.addStretch()


class SetupWizard(QWizard):
    """设置向导"""

    def __init__(self, parent=None):
        super().__init__(parent)
        self.setWindowTitle("钉钉同步 - 设置向导")
        self.setMinimumSize(560, 440)
        self.setWizardStyle(QWizard.ModernStyle)

        self.addPage(WelcomePage())
        self.addPage(LoginPage())
        self.addPage(EstimatePage())
        self.addPage(DirectoryPage())
        self.addPage(FinishPage())

        self.setButtonText(QWizard.NextButton, "下一步")
        self.setButtonText(QWizard.BackButton, "上一步")
        self.setButtonText(QWizard.FinishButton, "完成")
        self.setButtonText(QWizard.CancelButton, "取消")

    def accept(self):
        """完成向导"""
        # 保存配置（如果用户更改了目录）
        dir_page = self.page(3)
        sync_dir = dir_page.edit_dir.text().strip()
        if sync_dir and sync_dir != str(ds.BASE_DIR):
            # 更新配置中的同步目录
            try:
                config = ds.load_json(ds.CONFIG_FILE, {})
                if not isinstance(config, dict):
                    config = {}
                config.setdefault("paths", {})
                config["paths"]["sync_dir"] = sync_dir
                with open(ds.CONFIG_FILE, "w", encoding="utf-8") as f:
                    json.dump(config, f, ensure_ascii=False, indent=2)
            except Exception:
                pass
        super().accept()
