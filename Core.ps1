. ".\Log.ps1"
. ".\Config.ps1"
. ".\Server.ps1"

$Host.UI.RawUI.WindowTitle = "Simple HTTP Server"
# Get the PID of the terminal window
$pidFilePath = ".\pid"
$PID | Out-File -FilePath $pidFilePath -Encoding UTF8

Run-Server