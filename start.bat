@echo off

REM Start init command for HTTP Server
start "" cmd /c "powershell.exe -ExecutionPolicy Unrestricted -File .\HTTPServerRunner.ps1"

REM Start init command for HTTP Server
start "" cmd /c "powershell.exe -ExecutionPolicy Unrestricted -File .\LiveReloadServerRunner.ps1"

REM Close current terminal
exit