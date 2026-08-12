# -*- coding: utf-8 -*-
"""
钉钉同步 - Qt 桌面端主窗口 (Windows 11 Fluent Design)
侧边栏导航 + 四页面布局: 概览 / 同步 / 设置 / 日志
"""

import sys
import os
import json
from pathlib import Path
from datetime import datetime

from PySide6.QtWidgets import (
    QMainWindow, QWidget, QVBoxLayout, QHBoxLayout, QGridLayout,
    QLabel, QPushButton, QTextEdit,
    QProgressBar, QSystemTrayIcon, QMenu, QMessageBox,
    QComboBox, QSpinBox, QCheckBox, QApplication,
    QFrame, QStackedWidget, QScrollArea, QSizePolicy,
    QStyle,
)
from PySide6.QtCore import Qt, QTimer, Signal, Slot, QRect, QPoint
from PySide6.QtGui import (
    QIcon, QAction, QFont, QColor, QTextCursor,
    QPainter, QPen, QBrush, QPainterPath, QPixmap,
)

_PARENT = str(Path(__file__).parent.parent)
if _PARENT not in sys.path:
    sys.path.insert(0, _PARENT)

import dingtalk_sync as ds
from sync_worker import (
    AuthCheckWorker, LoginWorker, EstimateWorker, FileSyncWorker,
    CalendarSyncWorker, TodoSyncWorker, MinutesSyncWorker, ContactsSyncWorker,
    StatusWorker, RetryFailedWorker,
)

# ================================================================
# Windows 11 Fluent Design 配色
# ================================================================
C = {
    "bg": "#f3f3f3",
    "card": "#ffffff",
    "accent": "#0067c0",
    "accent_light": "#e8f0fe",
    "accent_dark": "#004a8f",
    "text": "#1a1a1a",
    "text_sec": "#616161",
    "text_muted": "#9e9e9e",
    "border": "#e5e5e5",
    "success": "#0f7b0f",
    "success_bg": "#dff6dd",
    "warning": "#9d5d00",
    "warning_bg": "#fff4ce",
    "error": "#c42b1c",
    "error_bg": "#fde7e9",
    "sidebar": "#f9f9f9",
    "sidebar_active": "#e8f0fe",
}

# ================================================================
# 全局样式表
# ================================================================
STYLE_SHEET = f"""
QMainWindow {{ background: {C["bg"]}; }}
QWidget {{ color: {C["text"]}; font-family: 'Segoe UI', system-ui, sans-serif; font-size: 13px; }}
QLabel {{ background: transparent; }}
QCheckBox {{ spacing: 6px; background: transparent; }}
QCheckBox::indicator {{
    width: 16px; height: 16px;
    border: 1.5px solid #bdc3c7; border-radius: 3px;
    background: white;
}}
QCheckBox::indicator:hover {{ border-color: {C["accent"]}; }}
QCheckBox::indicator:checked {{
    background: {C["accent"]}; border-color: {C["accent_dark"]}; image: none;
}}
QCheckBox::indicator:checked:hover {{ background: {C["accent_dark"]}; }}
QCheckBox::indicator:disabled {{ border-color: #dcdde1; background: #ecf0f1; }}
QSpinBox, QComboBox {{
    background: white; border: 1px solid {C["border"]};
    border-radius: 6px; padding: 5px 10px; font-size: 12px;
}}
QSpinBox:focus, QComboBox:focus {{ border-color: {C["accent"]}; }}
QPushButton {{
    background: {C["accent"]}; color: white; border: none; border-radius: 6px;
    padding: 8px 18px; font-size: 13px; font-weight: 600;
}}
QPushButton:hover {{ background: {C["accent_dark"]}; }}
QPushButton:pressed {{ background: #003a70; }}
QPushButton:disabled {{ background: #cccccc; color: #999999; }}
QTextEdit {{
    border: none; border-radius: 8px;
    background: #1e1e1e; color: #d4d4d4;
    font-family: 'Cascadia Code', Consolas, 'Courier New', monospace;
    font-size: 12px; padding: 10px;
}}
QProgressBar {{
    border: none; border-radius: 3px; text-align: center;
    background: #e8e8e8; font-size: 11px; height: 6px; color: transparent;
}}
QProgressBar::chunk {{ background: {C["accent"]}; border-radius: 3px; }}
QScrollArea {{ border: none; background: transparent; }}
QScrollBar:vertical {{ background: transparent; width: 8px; margin: 0; }}
QScrollBar::handle:vertical {{
    background: #c0c0c0; border-radius: 4px; min-height: 30px;
}}
QScrollBar::handle:vertical:hover {{ background: #a0a0a0; }}
QScrollBar::add-line:vertical, QScrollBar::sub-line:vertical {{ height: 0; }}
QScrollBar:horizontal {{ background: transparent; height: 8px; margin: 0; }}
QScrollBar::handle:horizontal {{
    background: #c0c0c0; border-radius: 4px; min-width: 30px;
}}
"""


# ================================================================
# 图标绘制辅助
# ================================================================
def paint_icon(p, name, rect, color):
    """用 QPainter 绘制简洁线条图标"""
    p.save()
    p.setRenderHint(QPainter.Antialiasing)
    pen = QPen(QColor(color), 1.6, Qt.SolidLine, Qt.RoundCap, Qt.RoundJoin)
    p.setPen(pen)
    p.setBrush(Qt.NoBrush)
    x, y, w, h = rect.x(), rect.y(), rect.width(), rect.height()
    cx, cy = x + w / 2, y + h / 2

    if name == "home":
        p.drawLine(x + 1, cy, cx, y + 1)
        p.drawLine(cx, y + 1, x + w - 1, cy)
        p.drawLine(x + 4, cy - 1, x + 4, y + h - 1)
        p.drawLine(x + 4, y + h - 1, x + w - 4, y + h - 1)
        p.drawLine(x + w - 4, y + h - 1, x + w - 4, cy - 1)
    elif name == "sync":
        p.drawArc(x + 2, y + 2, w - 4, h - 4, 40 * 16, 280 * 16)
        # 箭头
        ax, ay = x + w - 4, y + 5
        p.drawLine(ax, ay, ax + 3, ay + 1)
        p.drawLine(ax, ay, ax - 1, ay + 3)
    elif name == "settings":
        r = min(w, h) / 2 - 2
        p.drawEllipse(QPoint(int(cx), int(cy)), int(r * 0.55), int(r * 0.55))
        for angle in range(0, 360, 45):
            import math
            rad = math.radians(angle)
            x1 = cx + r * 0.7 * math.cos(rad)
            y1 = cy + r * 0.7 * math.sin(rad)
            x2 = cx + r * math.cos(rad)
            y2 = cy + r * math.sin(rad)
            p.drawLine(int(x1), int(y1), int(x2), int(y2))
    elif name == "log":
        p.drawLine(x + 3, y + 1, x + 3, y + h - 1)
        p.drawLine(x + 3, y + h - 1, x + w - 1, y + h - 1)
        p.drawLine(x + 7, y + 5, x + w - 3, y + 5)
        p.drawLine(x + 7, y + 9, x + w - 3, y + 9)
        p.drawLine(x + 7, y + 13, x + w - 6, y + 13)
    elif name == "file":
        p.drawRect(x + 3, y + 1, w - 6, h - 2)
        p.drawLine(x + 6, y + 5, x + w - 6, y + 5)
        p.drawLine(x + 6, y + 9, x + w - 6, y + 9)
    elif name == "image":
        p.drawRect(x + 1, y + 2, w - 2, h - 4)
        p.drawEllipse(QPoint(x + 6, y + 7), 2, 2)
        p.drawLine(x + 2, y + h - 5, x + 7, y + h - 9)
        p.drawLine(x + 7, y + h - 9, x + 11, y + h - 5)
        p.drawLine(x + 11, y + h - 5, x + w - 2, y + h - 8)
    elif name == "chat":
        p.drawRoundedRect(x + 1, y + 2, w - 2, h - 6, 4, 4)
        p.drawLine(x + 4, y + h - 4, x + 3, y + h - 1)
        p.drawLine(x + 4, y + h - 4, x + 8, y + h - 4)
    elif name == "disk":
        p.drawEllipse(QPoint(int(cx), int(y + 4)), int(w / 2 - 2), 3)
        p.drawLine(x + 2, y + 4, x + 2, y + h - 4)
        p.drawLine(x + w - 2, y + 4, x + w - 2, y + h - 4)
        p.drawArc(x + 2, y + h - 8, w - 4, 8, 180 * 16, 180 * 16)
    elif name == "shield":
        path = QPainterPath()
        path.moveTo(cx, y + 1)
        path.lineTo(x + w - 2, y + 5)
        path.lineTo(x + w - 2, cy + 2)
        path.quadTo(x + w - 2, y + h - 2, cx, y + h - 1)
        path.quadTo(x + 2, y + h - 2, x + 2, cy + 2)
        path.lineTo(x + 2, y + 5)
        path.closeSubpath()
        p.drawPath(path)
    elif name == "user":
        p.drawEllipse(QPoint(int(cx), int(y + 5)), 4, 4)
        p.drawArc(x + 3, y + h - 9, w - 6, 10, 180 * 16, 180 * 16)
    elif name == "check":
        p.drawLine(x + 3, cy, x + 7, y + h - 3)
        p.drawLine(x + 7, y + h - 3, x + w - 2, y + 3)
    elif name == "clock":
        p.drawEllipse(QPoint(int(cx), int(cy)), int(w / 2 - 2), int(h / 2 - 2))
        p.drawLine(int(cx), int(cy), int(cx), int(y + 4))
        p.drawLine(int(cx), int(cy), int(x + w - 5), int(cy))
    elif name == "folder":
        p.drawRect(x + 1, y + 5, w - 2, h - 6)
        p.drawLine(x + 1, y + 5, x + 5, y + 2)
        p.drawLine(x + 5, y + 2, x + 9, y + 2)
        p.drawLine(x + 9, y + 2, x + 10, y + 5)
    elif name == "play":
        path = QPainterPath()
        path.moveTo(x + 5, y + 2)
        path.lineTo(x + w - 2, cy)
        path.lineTo(x + 5, y + h - 2)
        path.closeSubpath()
        p.drawPath(path)
    elif name == "bell":
        p.drawArc(x + 3, y + 2, w - 6, h - 6, 0, 180 * 16)
        p.drawLine(x + 3, cy, x + 3, y + h - 5)
        p.drawLine(x + w - 3, cy, x + w - 3, y + h - 5)
        p.drawLine(x + 1, y + h - 5, x + w - 1, y + h - 5)
        p.drawLine(int(cx), y + h - 5, int(cx), y + h - 2)
    else:
        p.drawRect(x + 2, y + 2, w - 4, h - 4)
    p.restore()


def make_icon_pixmap(icon_name, color, size=32, bg_alpha=20):
    """生成带圆角背景的小图标 QPixmap"""
    pixmap = QPixmap(size, size)
    pixmap.fill(Qt.transparent)
    p = QPainter(pixmap)
    p.setRenderHint(QPainter.Antialiasing)
    bg = QColor(color)
    bg.setAlpha(bg_alpha)
    p.setBrush(bg)
    p.setPen(Qt.NoPen)
    p.drawRoundedRect(0, 0, size, size, 6, 6)
    paint_icon(p, icon_name, QRect(7, 7, size - 14, size - 14), color)
    p.end()
    return pixmap


# ================================================================
# 自定义控件
# ================================================================
class ToggleSwitch(QWidget):
    """Fluent Design 开关"""
    toggled = Signal(bool)

    def __init__(self, checked=False, parent=None):
        super().__init__(parent)
        self._checked = checked
        self.setFixedSize(40, 20)
        self.setCursor(Qt.PointingHandCursor)

    def paintEvent(self, event):
        p = QPainter(self)
        p.setRenderHint(QPainter.Antialiasing)
        track = QColor(C["accent"]) if self._checked else QColor("#cccccc")
        p.setBrush(track)
        p.setPen(Qt.NoPen)
        p.drawRoundedRect(0, 0, 40, 20, 10, 10)
        thumb_x = 23 if self._checked else 3
        p.setBrush(QColor("#ffffff"))
        p.setPen(QPen(QColor(0, 0, 0, 30), 0.5))
        p.drawEllipse(QPoint(thumb_x + 7, 10), 7, 7)

    def mousePressEvent(self, event):
        self._checked = not self._checked
        self.toggled.emit(self._checked)
        self.update()

    def isChecked(self):
        return self._checked

    def setChecked(self, v):
        if self._checked != v:
            self._checked = v
            self.update()


class NavButton(QWidget):
    """侧边栏导航按钮"""
    clicked = Signal()

    def __init__(self, text, icon_name="", parent=None):
        super().__init__(parent)
        self._text = text
        self._icon = icon_name
        self._active = False
        self.setFixedHeight(36)
        self.setCursor(Qt.PointingHandCursor)

    def set_active(self, active):
        self._active = active
        self.update()

    def paintEvent(self, event):
        p = QPainter(self)
        p.setRenderHint(QPainter.Antialiasing)
        w, h = self.width(), self.height()
        if self._active:
            p.setBrush(QColor(C["sidebar_active"]))
            p.setPen(Qt.NoPen)
            p.drawRoundedRect(0, 0, w, h, 6, 6)
            p.setBrush(QColor(C["accent"]))
            p.drawRoundedRect(0, 8, 3, h - 16, 1.5, 1.5)
        icon_color = C["accent"] if self._active else C["text_sec"]
        paint_icon(p, self._icon, QRect(12, 9, 17, 17), icon_color)
        p.setPen(QColor(C["accent"] if self._active else C["text_sec"]))
        font = p.font()
        font.setPixelSize(13)
        font.setBold(self._active)
        p.setFont(font)
        p.drawText(QRect(38, 0, w - 44, h), Qt.AlignVCenter, self._text)

    def mousePressEvent(self, event):
        self.clicked.emit()


class StatCard(QFrame):
    """Fluent 统计卡片"""

    def __init__(self, icon_name, label, value="--", sub="", color=None, parent=None):
        super().__init__(parent)
        self._color = color or C["accent"]
        self.setStyleSheet(
            f"StatCard {{ background: {C['card']}; border: 1px solid {C['border']}; border-radius: 8px; }}"
        )
        layout = QVBoxLayout(self)
        layout.setContentsMargins(14, 12, 14, 12)
        layout.setSpacing(2)

        top = QHBoxLayout()
        top.setSpacing(8)
        self._icon_lbl = QLabel()
        self._icon_lbl.setFixedSize(32, 32)
        self._icon_lbl.setPixmap(make_icon_pixmap(icon_name, self._color))
        self.lbl_label = QLabel(label)
        self.lbl_label.setStyleSheet(f"color: {C['text_sec']}; font-size: 12px;")
        top.addWidget(self._icon_lbl)
        top.addWidget(self.lbl_label)
        top.addStretch()
        layout.addLayout(top)

        self.lbl_value = QLabel(value)
        self.lbl_value.setStyleSheet(
            f"color: {C['text']}; font-size: 22px; font-weight: 700; margin-top: 4px;"
        )
        layout.addWidget(self.lbl_value)

        self.lbl_sub = QLabel(sub)
        self.lbl_sub.setStyleSheet(f"color: {C['text_muted']}; font-size: 11px;")
        layout.addWidget(self.lbl_sub)

    def set_value(self, text):
        self.lbl_value.setText(str(text))

    def set_sub(self, text):
        self.lbl_sub.setText(str(text))


class ToggleRow(QWidget):
    """设置页: 标签 + 描述 + 开关"""
    toggled = Signal(bool)

    def __init__(self, label, desc="", checked=False, parent=None):
        super().__init__(parent)
        layout = QHBoxLayout(self)
        layout.setContentsMargins(0, 8, 0, 8)
        layout.setSpacing(0)

        text_box = QVBoxLayout()
        text_box.setSpacing(2)
        lbl = QLabel(label)
        lbl.setStyleSheet(f"font-size: 13px; font-weight: 500; color: {C['text']};")
        text_box.addWidget(lbl)
        if desc:
            d = QLabel(desc)
            d.setStyleSheet(f"font-size: 11px; color: {C['text_muted']};")
            d.setWordWrap(True)
            text_box.addWidget(d)
        layout.addLayout(text_box, stretch=1)

        self.switch = ToggleSwitch(checked)
        self.switch.toggled.connect(self.toggled.emit)
        layout.addWidget(self.switch)

    def isChecked(self):
        return self.switch.isChecked()

    def setChecked(self, v):
        self.switch.setChecked(v)


class CardWidget(QFrame):
    """通用白色卡片容器"""

    def __init__(self, parent=None):
        super().__init__(parent)
        self.setStyleSheet(
            f"CardWidget {{ background: {C['card']}; border: 1px solid {C['border']}; border-radius: 8px; }}"
        )

    def title_label(self, text, color=None):
        lbl = QLabel(text)
        c = color or C["text"]
        lbl.setStyleSheet(f"font-size: 13px; font-weight: 600; color: {c}; background: transparent;")
        return lbl


# ================================================================
# 主窗口
# ================================================================
class MainWindow(QMainWindow):
    """主窗口 - Fluent Design"""

    _sig_log = Signal(str, str)
    _sig_phase = Signal(str)
    _sig_finished = Signal(bool, str)

    NAV_ITEMS = [
        ("overview", "概览", "home"),
        ("sync", "同步", "sync"),
        ("settings", "设置", "settings"),
    ]
    PAGE_SUBTITLES = {
        "overview": "同步状态总览与最近活动",
        "sync": "手动执行同步任务并查看实时进度",
        "settings": "配置同步选项、定时任务与路径",
    }

    def __init__(self):
        super().__init__()
        self.setWindowTitle("钉钉同步工具")
        self.setMinimumSize(900, 640)
        self.resize(980, 700)
        self.setStyleSheet(STYLE_SHEET)

        self._worker = None
        self._log_lines = 0
        self._nav_buttons = {}
        self._current_page = "overview"
        self._auth_prompt_shown = False

        self._init_ui()
        self._init_tray()
        self._init_timers()

        self._sig_log.connect(self._append_log)
        self._sig_phase.connect(self._on_phase)
        self._sig_finished.connect(self._on_worker_finished)

        QTimer.singleShot(500, self.refresh_status)

    # ================================================================
    # UI 构建
    # ================================================================

    def _init_ui(self):
        central = QWidget()
        self.setCentralWidget(central)
        root = QHBoxLayout(central)
        root.setContentsMargins(0, 0, 0, 0)
        root.setSpacing(0)

        # ---- 侧边栏 ----
        sidebar = QWidget()
        sidebar.setFixedWidth(200)
        sidebar.setStyleSheet(
            f"background: {C['sidebar']}; border-right: 1px solid {C['border']};"
        )
        sb_layout = QVBoxLayout(sidebar)
        sb_layout.setContentsMargins(10, 16, 10, 16)
        sb_layout.setSpacing(2)

        # Logo 区域
        logo_row = QHBoxLayout()
        logo_row.setSpacing(10)
        logo_icon = QLabel()
        logo_icon.setFixedSize(32, 32)
        logo_icon.setPixmap(make_icon_pixmap("sync", "#ffffff", 32, 255))
        # 用纯色背景替代
        logo_pm = QPixmap(32, 32)
        logo_pm.fill(Qt.transparent)
        lp = QPainter(logo_pm)
        lp.setRenderHint(QPainter.Antialiasing)
        lp.setBrush(QColor(C["accent"]))
        lp.setPen(Qt.NoPen)
        lp.drawRoundedRect(0, 0, 32, 32, 8, 8)
        paint_icon(lp, "sync", QRect(7, 7, 18, 18), "#ffffff")
        lp.end()
        logo_icon.setPixmap(logo_pm)

        logo_text = QVBoxLayout()
        logo_text.setSpacing(0)
        lt1 = QLabel("钉钉同步")
        lt1.setStyleSheet(f"font-size: 13px; font-weight: 700; color: {C['text']};")
        lt2 = QLabel("v2.4 Standalone")
        lt2.setStyleSheet(f"font-size: 10px; color: {C['text_muted']};")
        logo_text.addWidget(lt1)
        logo_text.addWidget(lt2)
        logo_row.addWidget(logo_icon)
        logo_row.addLayout(logo_text)
        logo_row.addStretch()
        sb_layout.addLayout(logo_row)
        sb_layout.addSpacing(20)

        # 导航按钮
        for page_id, label, icon in self.NAV_ITEMS:
            btn = NavButton(label, icon)
            btn.clicked.connect(lambda pid=page_id: self._switch_page(pid))
            sb_layout.addWidget(btn)
            self._nav_buttons[page_id] = btn
        self._nav_buttons["overview"].set_active(True)

        sb_layout.addStretch()

        # 用户信息卡片
        user_card = QFrame()
        user_card.setStyleSheet(
            f"background: {C['card']}; border: 1px solid {C['border']}; border-radius: 8px;"
        )
        uc_layout = QHBoxLayout(user_card)
        uc_layout.setContentsMargins(10, 10, 10, 10)
        uc_layout.setSpacing(8)
        user_avatar = QLabel()
        user_avatar.setFixedSize(30, 30)
        ua_pm = QPixmap(30, 30)
        ua_pm.fill(Qt.transparent)
        ua_p = QPainter(ua_pm)
        ua_p.setRenderHint(QPainter.Antialiasing)
        ua_p.setBrush(QColor(C["accent_light"]))
        ua_p.setPen(Qt.NoPen)
        ua_p.drawEllipse(0, 0, 30, 30)
        paint_icon(ua_p, "user", QRect(7, 7, 16, 16), C["accent"])
        ua_p.end()
        user_avatar.setPixmap(ua_pm)
        user_info = QVBoxLayout()
        user_info.setSpacing(0)
        self.lbl_user_name = QLabel("未登录")
        self.lbl_user_name.setStyleSheet(f"font-size: 12px; font-weight: 600; color: {C['text']};")
        self.lbl_user_org = QLabel("")
        self.lbl_user_org.setStyleSheet(f"font-size: 10px; color: {C['text_muted']};")
        user_info.addWidget(self.lbl_user_name)
        user_info.addWidget(self.lbl_user_org)
        uc_layout.addWidget(user_avatar)
        uc_layout.addLayout(user_info)
        sb_layout.addWidget(user_card)

        root.addWidget(sidebar)

        # ---- 右侧主区域 ----
        main_area = QWidget()
        main_area.setStyleSheet(f"background: {C['bg']};")
        main_layout = QVBoxLayout(main_area)
        main_layout.setContentsMargins(0, 0, 0, 0)
        main_layout.setSpacing(0)

        # 标题栏
        title_bar = QWidget()
        title_bar.setStyleSheet(f"background: {C['bg']};")
        tb_layout = QHBoxLayout(title_bar)
        tb_layout.setContentsMargins(24, 16, 24, 12)
        tb_layout.setSpacing(0)

        title_left = QVBoxLayout()
        title_left.setSpacing(2)
        self.lbl_page_title = QLabel("概览")
        self.lbl_page_title.setStyleSheet(f"font-size: 18px; font-weight: 700; color: {C['text']};")
        self.lbl_page_sub = QLabel(self.PAGE_SUBTITLES["overview"])
        self.lbl_page_sub.setStyleSheet(f"font-size: 11px; color: {C['text_muted']};")
        title_left.addWidget(self.lbl_page_title)
        title_left.addWidget(self.lbl_page_sub)
        tb_layout.addLayout(title_left)
        tb_layout.addStretch()

        # 连接状态徽章
        self.badge_status = QLabel("  已连接  ")
        self.badge_status.setStyleSheet(
            f"background: {C['success_bg']}; color: {C['success']}; "
            f"font-size: 11px; font-weight: 600; border-radius: 6px; padding: 4px 10px;"
        )
        tb_layout.addWidget(self.badge_status)

        main_layout.addWidget(title_bar)

        # 页面堆叠
        self.stack = QStackedWidget()
        self.stack.setStyleSheet(f"background: {C['bg']};")

        self.page_overview = self._build_overview_page()
        self.page_sync = self._build_sync_page()
        self.page_settings = self._build_settings_page()

        self.stack.addWidget(self.page_overview)
        self.stack.addWidget(self.page_sync)
        self.stack.addWidget(self.page_settings)

        main_layout.addWidget(self.stack, stretch=1)
        root.addWidget(main_area, stretch=1)

    def _switch_page(self, page_id):
        if page_id == self._current_page:
            return
        self._current_page = page_id
        idx = [n[0] for n in self.NAV_ITEMS].index(page_id)
        self.stack.setCurrentIndex(idx)
        for pid, btn in self._nav_buttons.items():
            btn.set_active(pid == page_id)
        label = [n[1] for n in self.NAV_ITEMS if n[0] == page_id][0]
        self.lbl_page_title.setText(label)
        self.lbl_page_sub.setText(self.PAGE_SUBTITLES.get(page_id, ""))

    def _wrap_scroll(self, widget):
        """将页面包裹在 QScrollArea 中"""
        scroll = QScrollArea()
        scroll.setWidgetResizable(True)
        scroll.setWidget(widget)
        scroll.setStyleSheet("background: transparent; border: none;")
        return scroll

    # ---- 概览页 ----
    def _build_overview_page(self):
        page = QWidget()
        page.setStyleSheet(f"background: {C['bg']};")
        layout = QVBoxLayout(page)
        layout.setContentsMargins(24, 0, 24, 24)
        layout.setSpacing(16)

        # 统计卡片
        cards_row = QHBoxLayout()
        cards_row.setSpacing(12)
        self.card_files = StatCard("file", "文件", "--", "", C["accent"])
        self.card_media = StatCard("image", "媒体", "--", "", "#8764b8")
        self.card_chat = StatCard("chat", "聊天记录", "--", "", C["success"])
        self.card_disk = StatCard("disk", "磁盘占用", "--", "", C["warning"])
        for c in [self.card_files, self.card_media, self.card_chat, self.card_disk]:
            c.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Preferred)
            cards_row.addWidget(c)
        layout.addLayout(cards_row)

        # 认证状态卡片
        auth_card = CardWidget()
        ac_layout = QHBoxLayout(auth_card)
        ac_layout.setContentsMargins(16, 14, 16, 14)
        ac_left = QHBoxLayout()
        ac_left.setSpacing(10)
        self.auth_icon_lbl = QLabel()
        self.auth_icon_lbl.setFixedSize(34, 34)
        self.auth_icon_lbl.setPixmap(make_icon_pixmap("shield", C["success"], 34))
        ac_text = QVBoxLayout()
        ac_text.setSpacing(1)
        self.lbl_auth_title = QLabel("认证状态检查中...")
        self.lbl_auth_title.setStyleSheet(f"font-size: 13px; font-weight: 600; color: {C['text']};")
        self.lbl_auth_detail = QLabel("")
        self.lbl_auth_detail.setStyleSheet(f"font-size: 11px; color: {C['text_muted']};")
        ac_text.addWidget(self.lbl_auth_title)
        ac_text.addWidget(self.lbl_auth_detail)
        ac_left.addWidget(self.auth_icon_lbl)
        ac_left.addLayout(ac_text)
        ac_layout.addLayout(ac_left)
        ac_layout.addStretch()
        self.lbl_auth_badge = QLabel("  检查中  ")
        self.lbl_auth_badge.setStyleSheet(
            f"background: {C['success_bg']}; color: {C['success']}; "
            f"font-size: 11px; font-weight: 600; border-radius: 6px; padding: 4px 10px;"
        )
        ac_layout.addWidget(self.lbl_auth_badge)
        layout.addWidget(auth_card)

        # 模块同步状态
        mod_card = CardWidget()
        mod_layout = QVBoxLayout(mod_card)
        mod_layout.setContentsMargins(16, 14, 16, 14)
        mod_layout.setSpacing(8)
        mod_layout.addWidget(mod_card.title_label("模块同步状态"))

        mod_grid = QGridLayout()
        mod_grid.setSpacing(8)
        headers = ["模块", "数据量", "上次同步", "操作"]
        for col, h in enumerate(headers):
            hl = QLabel(h)
            hl.setStyleSheet(f"font-size: 12px; font-weight: 600; color: {C['text_sec']};")
            mod_grid.addWidget(hl, 0, col)

        self._mod_rows = {}
        for row, (name, key) in enumerate([
            ("日程", "cal"), ("待办", "todo"), ("听记", "min"), ("通讯录", "contact")
        ], start=1):
            lbl_name = QLabel(name)
            lbl_name.setStyleSheet(f"font-size: 13px; color: {C['text']};")
            lbl_count = QLabel("--")
            lbl_count.setStyleSheet(f"font-size: 13px; color: {C['text_sec']};")
            lbl_last = QLabel("--")
            lbl_last.setStyleSheet(f"font-size: 13px; color: {C['text_sec']};")
            btn = QPushButton("同步")
            btn.setFixedWidth(64)
            btn.setFixedHeight(28)
            btn.setStyleSheet(
                f"QPushButton {{ background: {C['success']}; font-size: 12px; padding: 4px 12px; }}"
                f"QPushButton:hover {{ background: #0a5e0a; }}"
            )
            btn.clicked.connect(lambda checked, k=key: self._sync_module(k))
            mod_grid.addWidget(lbl_name, row, 0)
            mod_grid.addWidget(lbl_count, row, 1)
            mod_grid.addWidget(lbl_last, row, 2)
            mod_grid.addWidget(btn, row, 3)
            self._mod_rows[key] = (lbl_count, lbl_last, btn)
        mod_layout.addLayout(mod_grid)
        layout.addWidget(mod_card)

        # 刷新按钮
        btn_row = QHBoxLayout()
        btn_refresh = QPushButton("刷新状态")
        btn_refresh.setFixedWidth(100)
        btn_refresh.setStyleSheet(
            f"QPushButton {{ background: {C['card']}; color: {C['text_sec']}; "
            f"border: 1px solid {C['border']}; font-size: 12px; }}"
            f"QPushButton:hover {{ background: #f0f0f0; }}"
        )
        btn_refresh.clicked.connect(self.refresh_status)
        btn_row.addStretch()
        btn_row.addWidget(btn_refresh)
        layout.addLayout(btn_row)

        layout.addStretch()
        return self._wrap_scroll(page)

    # ---- 同步页 ----
    def _build_sync_page(self):
        page = QWidget()
        page.setStyleSheet(f"background: {C['bg']};")
        layout = QVBoxLayout(page)
        layout.setContentsMargins(24, 0, 24, 24)
        layout.setSpacing(16)

        # 同步控制卡片
        ctrl_card = CardWidget()
        ctrl_layout = QVBoxLayout(ctrl_card)
        ctrl_layout.setContentsMargins(18, 16, 18, 16)
        ctrl_layout.setSpacing(12)

        # 标题行
        title_row = QHBoxLayout()
        title_left = QVBoxLayout()
        title_left.setSpacing(2)
        t1 = QLabel("手动同步")
        t1.setStyleSheet(f"font-size: 14px; font-weight: 600; color: {C['text']};")
        self.lbl_sync_sub = QLabel("配置同步参数后点击开始")
        self.lbl_sync_sub.setStyleSheet(f"font-size: 11px; color: {C['text_muted']};")
        title_left.addWidget(t1)
        title_left.addWidget(self.lbl_sync_sub)
        title_row.addLayout(title_left)
        title_row.addStretch()

        self.btn_sync = QPushButton("开始同步")
        self.btn_sync.setFixedWidth(130)
        self.btn_sync.setFixedHeight(34)
        self.btn_sync.setStyleSheet(
            f"QPushButton {{ background: {C['success']}; color: white; border: none; border-radius: 6px; "
            f"font-size: 13px; font-weight: 700; padding: 6px 20px; }}"
            f"QPushButton:hover {{ background: #0a5e0a; }}"
            f"QPushButton:pressed {{ background: #084d08; }}"
            f"QPushButton:disabled {{ background: #cccccc; color: #999; font-weight: 400; }}"
        )
        self.btn_sync.clicked.connect(self.start_file_sync)
        self.btn_cancel = QPushButton("取消")
        self.btn_cancel.setFixedWidth(80)
        self.btn_cancel.setEnabled(False)
        self.btn_cancel.setStyleSheet(
            f"QPushButton {{ background: {C['error']}; }}"
            f"QPushButton:hover {{ background: #a1231b; }}"
            f"QPushButton:disabled {{ background: #cccccc; color: #999; }}"
        )
        self.btn_cancel.clicked.connect(self.cancel_sync)
        title_row.addWidget(self.btn_sync)
        title_row.addWidget(self.btn_cancel)
        ctrl_layout.addLayout(title_row)

        # 进度条
        self.progress = QProgressBar()
        self.progress.setVisible(False)
        self.progress.setFixedHeight(6)
        ctrl_layout.addWidget(self.progress)

        # 参数区域
        params_grid = QGridLayout()
        params_grid.setSpacing(10)

        params_grid.addWidget(QLabel("扫描天数:"), 0, 0)
        self.spin_days = QSpinBox()
        self.spin_days.setRange(1, 365)
        self.spin_days.setValue(7)
        self.spin_days.setFixedWidth(80)
        params_grid.addWidget(self.spin_days, 0, 1)

        self.chk_full = QCheckBox("全量扫描")
        params_grid.addWidget(self.chk_full, 0, 2)
        self.chk_csv = QCheckBox("同时导出聊天记录 CSV")
        params_grid.addWidget(self.chk_csv, 0, 3)

        self.chk_scan_only = QCheckBox("仅扫描不下载")
        params_grid.addWidget(self.chk_scan_only, 1, 0, 1, 2)
        self.chk_no_bulk = QCheckBox("禁用批量模式 (逐会话)")
        params_grid.addWidget(self.chk_no_bulk, 1, 2, 1, 2)

        self.chk_force = QCheckBox("强制覆盖已同步文件 (重新下载)")
        params_grid.addWidget(self.chk_force, 2, 0, 1, 4)

        ctrl_layout.addLayout(params_grid)
        layout.addWidget(ctrl_card)

        # 快捷操作卡片
        quick_card = CardWidget()
        qk_layout = QVBoxLayout(quick_card)
        qk_layout.setContentsMargins(18, 14, 18, 14)
        qk_layout.setSpacing(10)
        qk_layout.addWidget(quick_card.title_label("快捷操作"))
        qk_row = QHBoxLayout()
        qk_row.setSpacing(8)

        _btn_secondary = (
            f"QPushButton {{ background: {C['card']}; color: {C['text_sec']}; "
            f"border: 1px solid {C['border']}; border-radius: 6px; "
            f"font-size: 12px; font-weight: 500; padding: 7px 16px; }}"
            f"QPushButton:hover {{ background: #f0f0f0; border-color: #ccc; }}"
        )
        btn_login = QPushButton("扫码登录")
        btn_login.setStyleSheet(
            f"QPushButton {{ background: {C['accent']}; color: white; border: none; border-radius: 6px; "
            f"font-size: 12px; font-weight: 600; padding: 7px 16px; }}"
            f"QPushButton:hover {{ background: {C['accent_dark']}; }}"
        )
        btn_login.clicked.connect(self.start_login)

        btn_estimate = QPushButton("估算数据量")
        btn_estimate.setStyleSheet(_btn_secondary)
        btn_estimate.clicked.connect(self.start_estimate)

        btn_open_dir = QPushButton("打开同步目录")
        btn_open_dir.setStyleSheet(_btn_secondary)
        btn_open_dir.clicked.connect(self._open_sync_dir)

        qk_row.addWidget(btn_login)
        qk_row.addWidget(btn_estimate)
        qk_row.addWidget(btn_open_dir)
        qk_row.addStretch()
        qk_layout.addLayout(qk_row)
        layout.addWidget(quick_card)

        # 实时日志
        log_card = CardWidget()
        log_layout = QVBoxLayout(log_card)
        log_layout.setContentsMargins(0, 0, 0, 0)
        log_layout.setSpacing(0)
        log_header = QWidget()
        log_header.setStyleSheet(f"background: {C['card']}; border-bottom: 1px solid {C['border']};")
        lh_layout = QHBoxLayout(log_header)
        lh_layout.setContentsMargins(16, 10, 16, 10)
        lh_layout.addWidget(log_card.title_label("实时日志"))
        lh_layout.addStretch()
        self.lbl_phase = QLabel("")
        self.lbl_phase.setStyleSheet(f"font-size: 11px; font-weight: 600; color: {C['accent']};")
        lh_layout.addWidget(self.lbl_phase)
        log_layout.addWidget(log_header)

        self.txt_log = QTextEdit()
        self.txt_log.setReadOnly(True)
        self.txt_log.setMinimumHeight(200)
        self.txt_log.setStyleSheet(
            "QTextEdit { background: #1e1e1e; color: #d4d4d4; border: none; "
            "border-bottom-left-radius: 8px; border-bottom-right-radius: 8px; "
            "font-family: 'Cascadia Code', Consolas, monospace; font-size: 12px; padding: 10px; }"
        )
        log_layout.addWidget(self.txt_log)
        layout.addWidget(log_card, stretch=1)

        return page

    # ---- 设置页 ----
    def _build_settings_page(self):
        page = QWidget()
        page.setStyleSheet(f"background: {C['bg']};")
        layout = QVBoxLayout(page)
        layout.setContentsMargins(24, 0, 24, 24)
        layout.setSpacing(16)

        # 定时任务
        sched_card = CardWidget()
        sc_layout = QVBoxLayout(sched_card)
        sc_layout.setContentsMargins(18, 16, 18, 16)
        sc_layout.setSpacing(8)
        sc_layout.addWidget(sched_card.title_label("定时任务"))

        self.tgl_auto = ToggleRow(
            "启用每日自动同步",
            "通过 Windows 计划任务每天定时执行",
            checked=False,
        )
        sc_layout.addWidget(self.tgl_auto)

        sched_row = QHBoxLayout()
        sched_row.setSpacing(8)
        sched_row.addWidget(QLabel("每天"))
        self.combo_time = QComboBox()
        self.combo_time.addItems(["21:00", "08:00", "12:00", "18:00"])
        self.combo_time.setFixedWidth(80)
        sched_row.addWidget(self.combo_time)
        sched_row.addWidget(QLabel("同步最近"))
        self.combo_days = QComboBox()
        self.combo_days.addItems(["7 天", "14 天", "30 天"])
        self.combo_days.setFixedWidth(70)
        sched_row.addWidget(self.combo_days)
        sched_row.addWidget(QLabel("的消息"))
        sched_row.addStretch()
        sc_layout.addLayout(sched_row)
        layout.addWidget(sched_card)

        # 同步选项
        opt_card = CardWidget()
        op_layout = QVBoxLayout(opt_card)
        op_layout.setContentsMargins(18, 16, 18, 16)
        op_layout.setSpacing(0)
        op_layout.addWidget(opt_card.title_label("同步选项"))

        self.tgl_media = ToggleRow("同步图片", "下载聊天中的图片消息", checked=True)
        self.tgl_csv = ToggleRow("导出聊天记录 CSV", "每次同步时增量导出聊天记录到 _chat_export", checked=True)
        self.tgl_notify = ToggleRow("桌面通知", "认证过期或同步完成时弹出 Windows 通知", checked=True)

        op_layout.addWidget(self.tgl_media)
        sep1 = QFrame()
        sep1.setFrameShape(QFrame.HLine)
        sep1.setStyleSheet(f"color: {C['border']};")
        op_layout.addWidget(sep1)
        op_layout.addWidget(self.tgl_csv)
        sep2 = QFrame()
        sep2.setFrameShape(QFrame.HLine)
        sep2.setStyleSheet(f"color: {C['border']};")
        op_layout.addWidget(sep2)
        op_layout.addWidget(self.tgl_notify)

        # 联动: 设置页开关 -> 同步页复选框
        self.tgl_csv.toggled.connect(lambda v: self.chk_csv.setChecked(v))

        layout.addWidget(opt_card)

        # 路径配置
        path_card = CardWidget()
        pc_layout = QVBoxLayout(path_card)
        pc_layout.setContentsMargins(18, 16, 18, 16)
        pc_layout.setSpacing(10)
        pc_layout.addWidget(path_card.title_label("路径配置"))

        paths = [
            ("同步根目录", str(ds.BASE_DIR)),
            ("dws-core 路径", str(ds.DWS_CORE) if ds.DWS_CORE else "未找到"),
            ("会话列表", str(ds.CONVS_FILE)),
        ]
        for label, value in paths:
            pl = QLabel(label)
            pl.setStyleSheet(f"font-size: 11px; font-weight: 600; color: {C['text_sec']};")
            pv = QLabel(value)
            pv.setStyleSheet(
                f"font-size: 12px; color: {C['text']}; background: #f8f9fa; "
                f"border: 1px solid {C['border']}; border-radius: 6px; padding: 7px 12px; "
                f"font-family: Consolas, monospace;"
            )
            pv.setTextInteractionFlags(Qt.TextSelectableByMouse)
            pc_layout.addWidget(pl)
            pc_layout.addWidget(pv)
        layout.addWidget(path_card)

        # 高级操作
        danger_card = CardWidget()
        dg_layout = QVBoxLayout(danger_card)
        dg_layout.setContentsMargins(18, 16, 18, 16)
        dg_layout.setSpacing(10)
        dg_layout.addWidget(danger_card.title_label("高级操作", C["error"]))

        dg_row = QHBoxLayout()
        dg_row.setSpacing(8)
        btn_relogin = QPushButton("重新登录")
        btn_relogin.setStyleSheet(
            f"QPushButton {{ background: {C['card']}; color: {C['text_sec']}; "
            f"border: 1px solid {C['border']}; font-size: 12px; padding: 7px 14px; }}"
            f"QPushButton:hover {{ background: #f0f0f0; }}"
        )
        btn_relogin.clicked.connect(self.start_login)

        btn_retry_media = QPushButton("重试失败项")
        btn_retry_media.setStyleSheet(
            f"QPushButton {{ background: {C['card']}; color: {C['text_sec']}; "
            f"border: 1px solid {C['border']}; font-size: 12px; padding: 7px 14px; }}"
            f"QPushButton:hover {{ background: #f0f0f0; }}"
        )
        btn_retry_media.clicked.connect(self._retry_failed_items)

        btn_reset = QPushButton("重置同步状态")
        btn_reset.setStyleSheet(
            f"QPushButton {{ background: {C['card']}; color: {C['error']}; "
            f"border: 1px solid {C['error']}; font-size: 12px; padding: 7px 14px; }}"
            f"QPushButton:hover {{ background: {C['error_bg']}; }}"
        )
        btn_reset.clicked.connect(self._reset_sync_state)

        dg_row.addWidget(btn_relogin)
        dg_row.addWidget(btn_retry_media)
        dg_row.addWidget(btn_reset)
        dg_row.addStretch()
        dg_layout.addLayout(dg_row)
        layout.addWidget(danger_card)

        layout.addStretch()
        return self._wrap_scroll(page)

    # ---- 日志页 ----
    def _build_logs_page(self):
        page = QWidget()
        page.setStyleSheet(f"background: {C['bg']};")
        layout = QVBoxLayout(page)
        layout.setContentsMargins(24, 0, 24, 24)
        layout.setSpacing(0)

        log_card = CardWidget()
        ll = QVBoxLayout(log_card)
        ll.setContentsMargins(0, 0, 0, 0)
        ll.setSpacing(0)

        header = QWidget()
        header.setStyleSheet(f"background: {C['card']}; border-bottom: 1px solid {C['border']};")
        hl = QHBoxLayout(header)
        hl.setContentsMargins(16, 10, 16, 10)
        hl.addWidget(log_card.title_label("同步日志"))
        hl.addStretch()
        log_path_lbl = QLabel("_sync_state/sync.log")
        log_path_lbl.setStyleSheet(f"font-size: 11px; color: {C['text_muted']};")
        hl.addWidget(log_path_lbl)
        ll.addWidget(header)

        self.txt_history_log = QTextEdit()
        self.txt_history_log.setReadOnly(True)
        self.txt_history_log.setStyleSheet(
            "QTextEdit { background: #1e1e1e; color: #d4d4d4; border: none; "
            "border-bottom-left-radius: 8px; border-bottom-right-radius: 8px; "
            "font-family: 'Cascadia Code', Consolas, monospace; font-size: 12px; padding: 10px; }"
        )
        ll.addWidget(self.txt_history_log)
        layout.addWidget(log_card, stretch=1)

        btn_row = QHBoxLayout()
        btn_row.setContentsMargins(0, 8, 0, 0)
        btn_clear = QPushButton("清空日志")
        btn_clear.setFixedWidth(80)
        btn_clear.setStyleSheet(
            f"QPushButton {{ background: {C['card']}; color: {C['text_sec']}; "
            f"border: 1px solid {C['border']}; font-size: 12px; }}"
            f"QPushButton:hover {{ background: #f0f0f0; }}"
        )
        btn_clear.clicked.connect(lambda: self.txt_history_log.clear())
        btn_load = QPushButton("加载历史日志")
        btn_load.setFixedWidth(100)
        btn_load.setStyleSheet(
            f"QPushButton {{ background: {C['card']}; color: {C['text_sec']}; "
            f"border: 1px solid {C['border']}; font-size: 12px; }}"
            f"QPushButton:hover {{ background: #f0f0f0; }}"
        )
        btn_load.clicked.connect(self._load_history_log)
        btn_row.addStretch()
        btn_row.addWidget(btn_load)
        btn_row.addWidget(btn_clear)
        layout.addLayout(btn_row)

        return page

    # ================================================================
    # 系统托盘
    # ================================================================

    def _init_tray(self):
        self.tray = QSystemTrayIcon(self)
        self.tray.setIcon(self.style().standardIcon(QStyle.StandardPixmap.SP_ComputerIcon))
        self.tray.setToolTip("钉钉同步工具")

        menu = QMenu()
        act_show = QAction("显示主窗口", self)
        act_show.triggered.connect(self.show_and_activate)
        menu.addAction(act_show)

        act_sync = QAction("立即同步", self)
        act_sync.triggered.connect(self.start_file_sync)
        menu.addAction(act_sync)

        menu.addSeparator()
        act_quit = QAction("退出", self)
        act_quit.triggered.connect(self._quit)
        menu.addAction(act_quit)

        self.tray.setContextMenu(menu)
        self.tray.activated.connect(self._on_tray_activated)
        self.tray.show()

    def _on_tray_activated(self, reason):
        if reason == QSystemTrayIcon.DoubleClick:
            self.show_and_activate()

    def show_and_activate(self):
        self.showNormal()
        self.activateWindow()
        self.raise_()

    def _quit(self):
        if self._worker and self._worker.isRunning():
            self._worker.cancel()
            self._worker.wait(3000)
        self.tray.hide()
        QApplication.quit()

    # ================================================================
    # 定时器
    # ================================================================

    def _init_timers(self):
        self._auth_timer = QTimer(self)
        self._auth_timer.timeout.connect(self._check_auth_silent)
        self._auth_timer.start(5 * 60 * 1000)

        self._alert_timer = QTimer(self)
        self._alert_timer.timeout.connect(self._check_auth_alert)
        self._alert_timer.start(3000)

    def _check_auth_silent(self):
        try:
            if not ds.DWS_CORE:
                ds.find_dws_core("")
            status = ds.check_auth_status()
            if not status.get("token_valid"):
                if status.get("refresh_token_valid"):
                    ok, _ = ds.try_auth_refresh()
                    if ok:
                        return
                self._update_auth_badge(False, "Token 已过期")
                self.tray.showMessage(
                    "钉钉同步", "Token 已过期，请点击「扫码登录」重新授权",
                    QSystemTrayIcon.Warning, 5000
                )
        except Exception:
            pass

    def _check_auth_alert(self):
        try:
            if not ds.AUTH_ALERT_FILE.exists():
                return
            data = json.loads(ds.AUTH_ALERT_FILE.read_text(encoding="utf-8"))
            if data.get("resolved"):
                return
            title = data.get("title", "钉钉同步")
            msg = data.get("message", "认证已过期")
            self.tray.showMessage(title, msg, QSystemTrayIcon.Critical, 8000)
            data["_notified"] = True
            with open(ds.AUTH_ALERT_FILE, "w", encoding="utf-8") as f:
                json.dump(data, f, ensure_ascii=False, indent=2)
        except Exception:
            pass

    def _update_auth_badge(self, valid, detail=""):
        if valid:
            self.badge_status.setText("  已连接  ")
            self.badge_status.setStyleSheet(
                f"background: {C['success_bg']}; color: {C['success']}; "
                f"font-size: 11px; font-weight: 600; border-radius: 6px; padding: 4px 10px;"
            )
            self.lbl_auth_badge.setText("  已认证  ")
            self.lbl_auth_badge.setStyleSheet(
                f"background: {C['success_bg']}; color: {C['success']}; "
                f"font-size: 11px; font-weight: 600; border-radius: 6px; padding: 4px 10px;"
            )
            self.lbl_auth_title.setText("认证状态正常")
            self.auth_icon_lbl.setPixmap(make_icon_pixmap("shield", C["success"], 34))
        else:
            self.badge_status.setText("  未连接  ")
            self.badge_status.setStyleSheet(
                f"background: {C['error_bg']}; color: {C['error']}; "
                f"font-size: 11px; font-weight: 600; border-radius: 6px; padding: 4px 10px;"
            )
            self.lbl_auth_badge.setText("  已过期  ")
            self.lbl_auth_badge.setStyleSheet(
                f"background: {C['error_bg']}; color: {C['error']}; "
                f"font-size: 11px; font-weight: 600; border-radius: 6px; padding: 4px 10px;"
            )
            self.lbl_auth_title.setText("认证已过期")
            self.auth_icon_lbl.setPixmap(make_icon_pixmap("shield", C["error"], 34))
        if detail:
            self.lbl_auth_detail.setText(detail)

    # ================================================================
    # 工作线程管理
    # ================================================================

    def _start_worker(self, worker):
        if self._worker and self._worker.isRunning():
            QMessageBox.warning(self, "提示", "已有任务正在运行，请等待完成或取消。")
            return False

        self._worker = worker
        worker.sig.log.connect(lambda m, l: self._sig_log.emit(m, l))
        worker.sig.phase.connect(lambda p: self._sig_phase.emit(p))
        worker.sig.finished.connect(lambda ok, s: self._sig_finished.emit(ok, s))

        self._set_running(True)
        worker.start()
        return True

    def _set_running(self, running):
        self.btn_sync.setEnabled(not running)
        self.btn_cancel.setEnabled(running)
        self.progress.setVisible(running)
        if running:
            self.progress.setRange(0, 0)
            self.lbl_sync_sub.setText("正在同步...")
        else:
            self.lbl_sync_sub.setText("配置同步参数后点击开始")

    @Slot(str, str)
    def _append_log(self, msg, level):
        ts = datetime.now().strftime("%H:%M:%S")
        color = {"ERROR": "#f14c4c", "WARN": "#cca700"}.get(level, "#d4d4d4")
        self.txt_log.append(f'<span style="color:#666">[{ts}]</span> '
                            f'<span style="color:{color}">{msg}</span>')
        self._log_lines += 1
        cursor = self.txt_log.textCursor()
        cursor.movePosition(QTextCursor.End)
        self.txt_log.setTextCursor(cursor)
        if self._log_lines > 2000:
            self.txt_log.clear()
            self._log_lines = 0

    @Slot(str)
    def _on_phase(self, phase):
        self.lbl_phase.setText(phase)

    @Slot(bool, str)
    def _on_worker_finished(self, ok, summary):
        self._set_running(False)
        self.lbl_phase.setText("")
        level = "INFO" if ok else "WARN"
        self._append_log(f"[完成] {summary}", level)

        if ok:
            self.tray.showMessage("钉钉同步", summary, QSystemTrayIcon.Information, 3000)
        else:
            self.tray.showMessage("钉钉同步", summary, QSystemTrayIcon.Warning, 5000)

        QTimer.singleShot(1000, self.refresh_status)

    # ================================================================
    # 操作入口
    # ================================================================

    def refresh_status(self):
        worker = StatusWorker()
        worker.sig.finished.connect(self._on_status_done)
        self._worker = worker
        worker.start()

    def _on_status_done(self, ok, msg):
        if not ok or not hasattr(self._worker, 'result') or not self._worker.result:
            return
        r = self._worker.result

        self.card_files.set_value(f"{r['file_total']}")
        self.card_files.set_sub(f"已下载 {r['file_downloaded']} · 过期 {r['file_expired']}")
        self.card_media.set_value(f"{r['img_downloaded']}/{r['img_total']}")
        self.card_media.set_sub(f"待处理 {r['img_total'] - r['img_downloaded']}")
        self.card_chat.set_value(f"{r['convs']} 会话")
        self.card_disk.set_value(r['disk_size_str'])
        self.card_disk.set_sub(f"{r['disk_files']} 个文件")

        # 认证状态
        if r['auth_valid']:
            self._update_auth_badge(True, f"Token 剩余 {r['auth_hours']:.1f}h")
            user_name = r.get('auth_user', '') or '已认证用户'
        else:
            self._update_auth_badge(False, "Token 已过期，请重新登录")
            user_name = '未登录'
            # 首次检测到过期时弹窗提示登录
            if not self._auth_prompt_shown:
                self._auth_prompt_shown = True
                reply = QMessageBox.question(
                    self, "认证已过期",
                    "钉钉 Token 已过期，需要重新扫码登录。\n\n是否立即登录？",
                    QMessageBox.Yes | QMessageBox.No,
                    QMessageBox.Yes
                )
                if reply == QMessageBox.Yes:
                    self.start_login()
        self.lbl_user_name.setText(user_name)

        # 模块状态
        for key, count_field, last_field in [
            ("cal", "cal_count", "cal_last"),
            ("todo", "todo_count", "todo_last"),
            ("min", "min_count", "min_last"),
            ("contact", "contact_count", "contact_last"),
        ]:
            lbl_count, lbl_last, btn = self._mod_rows[key]
            lbl_count.setText(str(r.get(count_field, 0)))
            last = r.get(last_field, "")
            if last:
                try:
                    dt = datetime.fromisoformat(last)
                    lbl_last.setText(dt.strftime("%m-%d %H:%M"))
                except Exception:
                    lbl_last.setText(last[:16])
            else:
                lbl_last.setText("未执行")

    def start_file_sync(self):
        force = self.chk_force.isChecked()
        if force:
            reply = QMessageBox.question(
                self, "确认强制覆盖",
                "强制覆盖将重新下载所有已同步的文件和媒体，\n"
                "已下载的文件会被删除后重新获取。\n\n"
                "此操作可能耗时较长，确定继续？",
                QMessageBox.Yes | QMessageBox.No,
                QMessageBox.No
            )
            if reply != QMessageBox.Yes:
                return

        worker = FileSyncWorker(
            days=self.spin_days.value(),
            full=self.chk_full.isChecked(),
            scan_only=self.chk_scan_only.isChecked(),
            export_csv=self.chk_csv.isChecked(),
            use_bulk=not self.chk_no_bulk.isChecked(),
            force=force,
        )
        if self._start_worker(worker):
            self._switch_page("sync")

    def start_login(self):
        worker = LoginWorker()
        self._start_worker(worker)

    def start_estimate(self):
        worker = EstimateWorker(days=30)
        self._start_worker(worker)

    def _sync_module(self, key):
        if key == "cal":
            days = self.spin_days.value()
            worker = CalendarSyncWorker(days_back=days, days_forward=days)
        elif key == "todo":
            worker = TodoSyncWorker()
        elif key == "min":
            worker = MinutesSyncWorker()
        elif key == "contact":
            worker = ContactsSyncWorker()
        else:
            return
        if self._start_worker(worker):
            self._switch_page("sync")

    def cancel_sync(self):
        if self._worker and self._worker.isRunning():
            self._worker.cancel()
            self.btn_cancel.setEnabled(False)
            self._append_log("[操作] 正在取消，等待当前任务完成...", "WARN")

    def _open_sync_dir(self):
        os.startfile(str(ds.BASE_DIR))

    def _retry_failed_items(self):
        """重试失败的文件和媒体"""
        self._append_log("[操作] 重试失败的文件和媒体...", "INFO")
        worker = RetryFailedWorker()
        if self._start_worker(worker):
            self._switch_page("sync")

    def _reset_sync_state(self):
        reply = QMessageBox.question(
            self, "确认重置",
            "重置同步状态将清除所有已记录的同步清单，\n"
            "下次同步将重新扫描所有文件。\n\n"
            "已下载的文件不会被删除。确定继续？",
            QMessageBox.Yes | QMessageBox.No,
            QMessageBox.No
        )
        if reply != QMessageBox.Yes:
            return
        try:
            manifest_file = ds.BASE_DIR / "_sync_state" / "manifest.json"
            img_manifest_file = ds.BASE_DIR / "_sync_state" / "image_manifest.json"
            for f in [manifest_file, img_manifest_file]:
                if f.exists():
                    f.unlink()
            self._append_log("[操作] 同步状态已重置", "INFO")
            self.refresh_status()
        except Exception as e:
            self._append_log(f"[错误] 重置失败: {e}", "ERROR")

    def _load_history_log(self):
        """加载历史同步日志"""
        try:
            log_file = ds.BASE_DIR / "_sync_state" / "sync.log"
            if log_file.exists():
                content = log_file.read_text(encoding="utf-8", errors="replace")
                lines = content.strip().split("\n")
                # 最多显示最近 200 行
                lines = lines[-200:]
                self.txt_history_log.clear()
                for line in lines:
                    self.txt_history_log.append(line)
            else:
                self.txt_history_log.setText("日志文件不存在: " + str(log_file))
        except Exception as e:
            self.txt_history_log.setText(f"读取日志失败: {e}")

    # ================================================================
    # 窗口事件
    # ================================================================

    def closeEvent(self, event):
        if self.tray.isVisible():
            self.hide()
            self.tray.showMessage(
                "钉钉同步", "程序已最小化到系统托盘，右键可退出。",
                QSystemTrayIcon.Information, 2000
            )
            event.ignore()
        else:
            self._quit()
