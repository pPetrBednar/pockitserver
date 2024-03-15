$config = Join-Path $PWD.Path ".\config.properties"

. ".\bin\common\Log.ps1"
. ".\bin\common\Config.ps1"
. ".\bin\server\http\HTTPServer.ps1"

$Host.UI.RawUI.WindowTitle = "Simple HTTP Server"
# Get the PID of the terminal window
$pidFilePath = ".\.http_server_pid"
$PID | Out-File -FilePath $pidFilePath -Encoding UTF8

Start-Http-Server
