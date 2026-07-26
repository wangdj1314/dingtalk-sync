@echo off
chcp 65001 >/dev/null
echo ============================================
echo   钉钉同步工具 - 一键构建脚本
echo ============================================
echo.

set PROJECT_ROOT=%~dp0..
set PACKAGING_DIR=%~dp0
set DIST_DIR=%PACKAGING_DIR%\dist
set DWS_CORE=%USERPROFILE%\.qoderworkcn\bin\dws-ext\dws-core-windows-amd64.exe

:: 检查 Python
python --version >/dev/null 2>&1
if errorlevel 1 (
    echo [错误] 未找到 Python，请先安装 Python 3.10+
    pause
    exit /b 1
)

:: 检查 PyInstaller
pip show pyinstaller >/dev/null 2>&1
if errorlevel 1 (
    echo [信息] 安装 PyInstaller...
    pip install pyinstaller --quiet
)

:: 检查 PySide6
pip show PySide6 >/dev/null 2>&1
if errorlevel 1 (
    echo [信息] 安装 PySide6...
    pip install PySide6 --quiet
)

:: 检查 dws-core
if not exist "%DWS_CORE%" (
    echo [错误] 未找到 dws-core: %DWS_CORE%
    echo        请确保 QoderWork 已安装并运行过至少一次
    pause
    exit /b 1
)

echo.
echo [1/4] 清理旧的构建产物...
if exist "%DIST_DIR%" rd /s /q "%DIST_DIR%"
if exist "%PACKAGING_DIR%\build" rd /s /q "%PACKAGING_DIR%\build"

echo [2/4] PyInstaller 打包中（约2-5分钟）...
cd /d "%PACKAGING_DIR%"
pyinstaller dingtalk_sync.spec --noconfirm --clean
if errorlevel 1 (
    echo [错误] PyInstaller 打包失败
    pause
    exit /b 1
)

echo [3/4] 复制 dws-core 到 bin/ ...
mkdir "%DIST_DIR%\DingTalkSync\bin" 2>/dev/null
copy /y "%DWS_CORE%" "%DIST_DIR%\DingTalkSync\bin\dws-core-windows-amd64.exe" >/dev/null

echo [4/4] 准备 Inno Setup 编译...
echo.

:: 检查 Inno Setup
set ISCC=
if exist "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" set ISCC=C:\Program Files (x86)\Inno Setup 6\ISCC.exe
if exist "C:\Program Files\Inno Setup 6\ISCC.exe" set ISCC=C:\Program Files\Inno Setup 6\ISCC.exe

if defined ISCC (
    echo 正在编译安装包...
    "%ISCC%" installer.iss
    if errorlevel 1 (
        echo [错误] Inno Setup 编译失败
        pause
        exit /b 1
    )
    echo.
    echo ============================================
    echo   构建完成！
    echo   安装包: %PACKAGING_DIR%\Output\DingTalkSync_Setup_v2.3.exe
    echo ============================================
) else (
    echo [提示] 未检测到 Inno Setup 6，跳过安装包编译。
    echo        请安装 Inno Setup 6: https://jrsoftware.org/isdl.php
    echo        安装后重新运行本脚本，或手动编译:
    echo        ISCC.exe installer.iss
    echo.
    echo 独立目录版已生成: %DIST_DIR%\DingTalkSync    echo 可直接复制该目录到目标机器运行 DingTalkSync.exe
)

echo.
pause
