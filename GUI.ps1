Add-Type -AssemblyName System.Windows.Forms

function Stop-Servers {
    $PID1 = Get-Content -Path ".\.http_server_pid"
    # Check if the process with specified PID exists and is a PowerShell terminal
    if (Get-Process -Id $PID1 -ErrorAction SilentlyContinue | Where-Object { $_.ProcessName -eq 'powershell' })
    {
        Stop-Process -Id $PID1 -Force
    }

    $PID2 = Get-Content -Path ".\.live_reload_server_pid"
    # Check if the process with specified PID exists and is a PowerShell terminal
    if (Get-Process -Id $PID2 -ErrorAction SilentlyContinue | Where-Object { $_.ProcessName -eq 'powershell' })
    {
        Stop-Process -Id $PID2 -Force
    }
}

# Create Form
$form = New-Object System.Windows.Forms.Form
$form.Text = "HT/LR Server"
$form.Size = New-Object System.Drawing.Size(300, 120)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false

# Create Status Label
$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Location = New-Object System.Drawing.Point(10, 50)
$statusLabel.Size = New-Object System.Drawing.Size(280, 30)
$statusLabel.Text = "Status: Inactive"
$statusLabel.ForeColor = "Red"

# Create Start Button
$startButton = New-Object System.Windows.Forms.Button
$startButton.Location = New-Object System.Drawing.Point(10, 10)
$startButton.Size = New-Object System.Drawing.Size(80, 30)
$startButton.Text = "Start"
$startButton.Add_Click({
    Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Unrestricted -File .\bin\HTTPServerRunner.ps1"
    Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Unrestricted -File .\bin\LiveReloadServerRunner.ps1"

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

# Show Form
$form.ShowDialog() | Out-Null
