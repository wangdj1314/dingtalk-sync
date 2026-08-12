@echo off
chcp 65001 >nul
set LOGFILE=D:\myfiles\钉钉同步\_sync_state\task_run.log
echo [%date% %time%] ====== 开始同步 ====== >> "%LOGFILE%"
"C:\Users\wangdj\AppData\Local\Programs\Python\Python314\python.exe" "D:\myfiles\钉钉同步\dws_sync.py" --all --days 2 >> "%LOGFILE%" 2>&1
echo [%date% %time%] ====== 同步结束 ====== >> "%LOGFILE%"
