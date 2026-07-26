@echo off

:: DingTalk Sync - Scheduled Task Entry Point
:: Runs daily via Windows Task Scheduler
:: Config: config.json in the same directory

:: Get this file's directory
set "TOOLS_DIR=%~dp0"
:: Sync root = parent of _tools/
for %%I in ("%TOOLS_DIR%..") do set "SYNC_DIR=%%~fI"

:: Log file
set "LOGFILE=%SYNC_DIR%\_sync_state\task_run.log"
if not exist "%SYNC_DIR%\_sync_state" mkdir "%SYNC_DIR%\_sync_state"

:: Log rotation: archive when > 1MB
for %%F in ("%LOGFILE%") do (
    if %%~zF GTR 1048576 (
        move /y "%LOGFILE%" "%SYNC_DIR%\_sync_state\task_run.log.1" >nul 2>&1
    )
)

:: Find Python: PATH > common install locations
where python >nul 2>&1
if %errorlevel%==0 (
    set "PYTHON=python"
) else if exist "%LOCALAPPDATA%\Programs\Python\Python314\python.exe" (
    set "PYTHON=%LOCALAPPDATA%\Programs\Python\Python314\python.exe"
) else if exist "%LOCALAPPDATA%\Programs\Python\Python313\python.exe" (
    set "PYTHON=%LOCALAPPDATA%\Programs\Python\Python313\python.exe"
) else if exist "%LOCALAPPDATA%\Programs\Python\Python312\python.exe" (
    set "PYTHON=%LOCALAPPDATA%\Programs\Python\Python312\python.exe"
) else (
    echo [%date% %time%] [ERROR] Python not found >> "%LOGFILE%"
    exit /b 1
)

echo [%date% %time%] ====== START ====== >> "%LOGFILE%"
"%PYTHON%" "%TOOLS_DIR%dws_sync.py" --all --days 7 >> "%LOGFILE%" 2>&1
echo [%date% %time%] ====== END (exit %errorlevel%) ====== >> "%LOGFILE%"
echo. >> "%LOGFILE%"
