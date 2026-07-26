# -*- coding: utf-8 -*-
"""
钉钉同步工具 - Qt 桌面端入口
==============================
启动主窗口，首次运行时显示设置向导。

用法:
    python main.py              正常启动
    python main.py --setup      强制显示设置向导
    python main.py --minimized  启动时最小化到托盘
"""

import sys
import os
import ctypes
from pathlib import Path

# 确保父目录在 path 中（用于导入 dingtalk_sync）
_APP_DIR = Path(__file__).parent
_PARENT = str(_APP_DIR.parent)
if _PARENT not in sys.path:
    sys.path.insert(0, _PARENT)

from PySide6.QtWidgets import QApplication, QMessageBox
from PySide6.QtCore import Qt
from PySide6.QtGui import QIcon

import dingtalk_sync as ds
import crash_handler

# 单实例互斥体名称
_MUTEX_NAME = "DingTalkSync_App_Mutex"

# 应用图标路径
_ICON_PATH = Path(__file__).parent / "resources" / "dingtalk_sync.ico"


def _acquire_mutex():
    """
    尝试获取 Windows 互斥体，确保只有一个实例运行。
    返回 (mutex_handle, is_first_instance)。
    """
    if sys.platform != "win32":
        return None, True

    kernel32 = ctypes.windll.kernel32
    mutex = kernel32.CreateMutexW(None, False, _MUTEX_NAME)
    last_error = kernel32.GetLastError()
    # ERROR_ALREADY_EXISTS = 183
    if last_error == 183:
        # 已有实例在运行
        kernel32.CloseHandle(mutex)
        return None, False
    return mutex, True


def _bring_existing_to_front():
    """尝试将已运行的实例窗口调到前台"""
    try:
        user32 = ctypes.windll.user32
        # 查找窗口
        hwnd = user32.FindWindowW(None, "钉钉同步工具")
        if hwnd:
            # SW_RESTORE = 9
            user32.ShowWindow(hwnd, 9)
            user32.SetForegroundWindow(hwnd)
            return True
    except Exception:
        pass
    return False


def main():
    # 安装崩溃捕获 (必须在最前面)
    crash_handler.install()

    # 检测上次是否异常退出
    prev_crash = crash_handler.check_previous_crash()

    # 单实例检查
    mutex, is_first = _acquire_mutex()
    if not is_first:
        _bring_existing_to_front()
        # 弹出提示（可选）
        app_tmp = QApplication(sys.argv)
        QMessageBox.information(None, "钉钉同步工具", "程序已在运行中。")
        return 0

    # 高 DPI 支持
    QApplication.setHighDpiScaleFactorRoundingPolicy(
        Qt.HighDpiScaleFactorRoundingPolicy.PassThrough)

    app = QApplication(sys.argv)
    app.setApplicationName("钉钉同步工具")
    app.setOrganizationName("DingTalkSync")
    app.setQuitOnLastWindowClosed(False)  # 关闭窗口时最小化到托盘

    # 设置应用图标（任务栏、标题栏、快捷方式）
    if getattr(sys, "frozen", False):
        _icon_file = Path(sys.executable).parent / "resources" / "dingtalk_sync.ico"
    else:
        _icon_file = _ICON_PATH
    if _icon_file.exists():
        app.setWindowIcon(QIcon(str(_icon_file)))

    # 上次异常退出提示
    if prev_crash:
        started = prev_crash.get("started_at", "未知时间")
        pid = prev_crash.get("pid", "?")
        QMessageBox.warning(
            None, "上次异常退出",
            f"程序上次运行时异常退出 (PID={pid}, 启动于 {started})。\n\n"
            f"崩溃日志已保存到:\n{crash_handler.CRASH_LOG_FILE}\n\n"
            f"如同步任务中断，可使用「断点续传」继续。"
        )

    # 初始化 dws-core
    ds.find_dws_core("")

    # 判断是否首次运行（无配置文件或无认证）
    force_setup = "--setup" in sys.argv
    first_run = force_setup or not ds.CONFIG_FILE.exists()

    if not first_run:
        # 检查是否有有效认证
        try:
            status = ds.check_auth_status()
            if not status.get("authenticated"):
                first_run = True
        except Exception:
            first_run = True

    if first_run:
        from wizard import SetupWizard
        wizard = SetupWizard()
        result = wizard.exec()
        if result != SetupWizard.Accepted:
            # 用户取消向导
            if not ds.CONFIG_FILE.exists():
                # 首次运行且取消 → 退出
                return 0
            # 非首次运行取消 → 继续打开主窗口

    from main_window import MainWindow
    window = MainWindow()

    if "--minimized" in sys.argv:
        window.hide()
    else:
        window.show()

    ret = app.exec()

    # 正常退出: 清除脏标记、恢复钩子
    crash_handler.uninstall()

    # 释放互斥体
    if mutex and sys.platform == "win32":
        ctypes.windll.kernel32.CloseHandle(mutex)

    return ret


if __name__ == "__main__":
    sys.exit(main())
