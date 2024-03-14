@echo off
set /p PID1=<".\.http_server_pid"
set PID1=%PID1:~3%
taskkill /F /PID %PID1%

set /p PID2=<".\.live_reload_server_pid"
set PID2=%PID2:~3%
taskkill /F /PID %PID2%