Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

. ".\bin\common\Config.ps1"

Add-Type -AssemblyName System.Windows.Forms
$showConsole = Get-Config -targetKey "gui.console"

function Stop-Servers
{
    $pid1path = ".\.http_server_pid"
    $pid2path = ".\.live_reload_server_pid"

    if (Test-Path $pid1path)
    {
        $PID1 = Get-Content -Path $pid1path
        # Check if the process with specified PID exists and is a PowerShell terminal
        if (Get-Process -Id $PID1 -ErrorAction SilentlyContinue | Where-Object { $_.ProcessName -eq 'powershell' })
        {
            Stop-Process -Id $PID1 -Force
        }
    }

    if (Test-Path $pid2path)
    {
        $PID2 = Get-Content -Path $pid2path
        # Check if the process with specified PID exists and is a PowerShell terminal
        if (Get-Process -Id $PID2 -ErrorAction SilentlyContinue | Where-Object { $_.ProcessName -eq 'powershell' })
        {
            Stop-Process -Id $PID2 -Force
        }
    }
}

# Create Form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Pockitserver"
$form.Size = New-Object System.Drawing.Size(295, 120)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false

# Load custom icon
$iconPath = Join-Path $PWD.Path "res\icon.ico"
$formIcon = New-Object System.Drawing.Icon($iconPath)

# Set form icon
$form.Icon = $formIcon

# Create Status Label
$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Location = New-Object System.Drawing.Point(10, 55)
$statusLabel.Size = New-Object System.Drawing.Size(280, 30)
$statusLabel.Text = "Status: Inactive"
$statusLabel.ForeColor = "Red"

# Create a checkbox
$checkBox = New-Object System.Windows.Forms.CheckBox
$checkBox.Text = "Show console"
$checkBox.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes
$checkBox.Location = New-Object System.Drawing.Point(160, 51)

if ($showConsole -eq "true")
{
    $checkBox.Checked = $true
}

$form.Controls.Add($checkBox)

# Create Start Button
$startButton = New-Object System.Windows.Forms.Button
$startButton.Location = New-Object System.Drawing.Point(10, 10)
$startButton.Size = New-Object System.Drawing.Size(80, 30)
$startButton.Text = "Start"
$startButton.Add_Click({
    Stop-Servers

    if ($checkBox.Checked)
    {
        Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Unrestricted -File .\bin\HTTPServerRunner.ps1"
        Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Unrestricted -File .\bin\LiveReloadServerRunner.ps1"
    }
    else
    {
        Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Unrestricted -File .\bin\HTTPServerRunner.ps1" -WindowStyle Hidden
        Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Unrestricted -File .\bin\LiveReloadServerRunner.ps1" -WindowStyle Hidden
    }

    $statusLabel.Text = "Status: Active"
    $statusLabel.ForeColor = "Green"
})

# Create Stop Button
$stopButton = New-Object System.Windows.Forms.Button
$stopButton.Location = New-Object System.Drawing.Point(100, 10)
$stopButton.Size = New-Object System.Drawing.Size(80, 30)
$stopButton.Text = "Stop"
$stopButton.Add_Click({
    Stop-Servers
    $statusLabel.Text = "Status: Inactive"
    $statusLabel.ForeColor = "Red"
})

# Create Quit Button
$quitButton = New-Object System.Windows.Forms.Button
$quitButton.Location = New-Object System.Drawing.Point(190, 10)
$quitButton.Size = New-Object System.Drawing.Size(80, 30)
$quitButton.Text = "Quit"
$quitButton.Add_Click({
    Stop-Servers
    $form.Close()
})

# Add controls to form
$form.Controls.Add($startButton)
$form.Controls.Add($stopButton)
$form.Controls.Add($quitButton)
$form.Controls.Add($statusLabel)

$form.Add_FormClosing({
    Stop-Servers
})

# Show Form
$form.ShowDialog() | Out-Null
