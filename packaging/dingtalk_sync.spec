# -*- mode: python ; coding: utf-8 -*-
"""
钉钉同步工具 - PyInstaller 打包配置
====================================
用法: pyinstaller dingtalk_sync.spec
输出: dist/DingTalkSync/ 目录（onedir 模式）
"""

import os
import sys
from pathlib import Path

# 项目根目录
PROJECT_ROOT = Path(SPECPATH).parent.resolve()
APP_DIR = PROJECT_ROOT / "app"
RESOURCES_DIR = APP_DIR / "resources"

block_cipher = None

a = Analysis(
    [str(APP_DIR / "main.py")],
    pathex=[str(PROJECT_ROOT), str(APP_DIR)],
    binaries=[],
    datas=[
        # 图标资源
        (str(RESOURCES_DIR / "dingtalk_sync.ico"), "resources"),
    ],
    hiddenimports=[
        "PySide6.QtCore",
        "PySide6.QtGui",
        "PySide6.QtWidgets",
    ],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[
        "tkinter",
        "matplotlib",
        "numpy",
        "scipy",
        "pandas",
        "PIL",
        "cv2",
        "torch",
        "tensorflow",
    ],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
)

pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher)

exe = EXE(
    pyz,
    a.scripts,
    [],
    exclude_binaries=True,
    name="DingTalkSync",
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    console=False,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
    icon=str(RESOURCES_DIR / "dingtalk_sync.ico"),
)

coll = COLLECT(
    exe,
    a.binaries,
    a.zipfiles,
    a.datas,
    strip=False,
    upx=True,
    upx_exclude=[],
    name="DingTalkSync",
)
