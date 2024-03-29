. ".\bin\common\Log.ps1"
. ".\bin\common\Config.ps1"
. ".\bin\server\live-reload\LiveReloadServer.ps1"

$Host.UI.RawUI.WindowTitle = "Pockitserver - Live-Reload Server"
# Get the PID of the terminal window
$pidFilePath = ".\.live_reload_server_pid"
$PID | Out-File -FilePath $pidFilePath -Encoding UTF8

Start-Live-Reload-Server
