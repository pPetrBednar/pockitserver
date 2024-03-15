
$config = Join-Path $PWD.Path ".\config.properties"

. ".\bin\common\Log.ps1"
. ".\bin\common\Config.ps1"
. ".\bin\server\live-reload\LiveReloadServer.ps1"

$Host.UI.RawUI.WindowTitle = "Simple Live-Reload Server"
# Get the PID of the terminal window
$pidFilePath = ".\.live_reload_server_pid"
$PID | Out-File -FilePath $pidFilePath -Encoding UTF8

Start-Live-Reload-Server
