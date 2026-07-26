# 打包部署指南 (packaging/)

## 概述

将 Python 应用打包为 Windows 安装程序（.exe），目标机器无需安装 Python 或任何依赖。

## 工具链

| 工具 | 版本 | 用途 |
|------|------|------|
| PyInstaller | 6.21+ | Python -> 独立可执行文件 |
| Inno Setup | 6.4+ | 制作 Windows 安装向导 |

## 文件说明

| 文件 | 说明 |
|------|------|
| `dingtalk_sync.spec` | PyInstaller 打包配置（onedir 模式） |
| `installer.iss` | Inno Setup 安装脚本 |
| `build.bat` | 一键构建脚本 |
| `ChineseSimplified.isl` | 安装向导中文语言文件 |

## 构建流程

### 一键构建

```bash
cd packaging
build.bat
```

### 手动构建

```bash
# 1. PyInstaller 打包
cd packaging
pyinstaller dingtalk_sync.spec --noconfirm --clean

# 2. 复制 dws-core 到 dist
mkdir dist\DingTalkSync\bin
copy "C:\Users\xxx\.qoderworkcn\bin\dws-ext\dws-core-windows-amd64.exe" dist\DingTalkSync\bin\

# 3. 复制图标
mkdir dist\DingTalkSync\resources
copy ..\app\resources\dingtalk_sync.ico dist\DingTalkSync\resources\

# 4. 编译安装程序
"C:\Program Files (x86)\Inno Setup 6\ISCC.exe" installer.iss
```

### 产出

- `packaging/dist/DingTalkSync/` — 便携版目录（可直接运行）
- `packaging/Output/DingTalkSync_Setup_v2.3.exe` — 安装程序（约 38 MB）

## 安装程序特性

- 默认安装到 `%LOCALAPPDATA%\DingTalkSync`（无需管理员权限）
- 创建桌面快捷方式（可选）
- 开机自启动（可选，最小化到托盘）
- 中文安装向导
- 卸载时保留用户数据

## PyInstaller 配置要点

- **onedir 模式**：启动快，便于调试
- **console=False**：无 CMD 窗口
- **icon**：自定义应用图标
- **excludes**：排除 tkinter/matplotlib/numpy 等无关库，减小体积
- **hiddenimports**：显式声明 PySide6.QtCore/QtGui/QtWidgets

## 打包后目录结构

```
DingTalkSync/
├── DingTalkSync.exe        # 主程序
├── _internal/              # Python 运行时 + 依赖库
│   ├── python314.dll
│   ├── PySide6/            # Qt 库
│   └── ...
├── bin/
│   └── dws-core-windows-amd64.exe  # DWS CLI
└── resources/
    └── dingtalk_sync.ico   # 运行时图标
```

## 注意事项

- 打包前确保 `app/resources/dingtalk_sync.ico` 存在
- dws-core 需要单独复制（PyInstaller 不会自动打包外部 exe）
- 首次运行需要 dws 已登录（`dws auth login`）
- 打包产物约 164 MB（未压缩），安装程序约 38 MB（LZMA2 压缩）
