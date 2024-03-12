@echo off
set /p PID=<".\pid"
set PID=%PID:~3%
taskkill /F /PID %PID%