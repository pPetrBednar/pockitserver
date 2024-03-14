. ".\common\Log.ps1"
. ".\common\Config.ps1"
. ".\server\http\HTTPServer.ps1"

$Host.UI.RawUI.WindowTitle = "Simple HTTP Server"
# Get the PID of the terminal window
$pidFilePath = ".\.http_server_pid"
$PID | Out-File -FilePath $pidFilePath -Encoding UTF8

Start-Http-Server