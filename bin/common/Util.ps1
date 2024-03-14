function Set-ConsoleWindow
{
    param(
        [int]$Width,
        [int]$Height
    )

    $WindowSize = $Host.UI.RawUI.WindowSize
    $WindowSize.Width = [Math]::Min($Width, $Host.UI.RawUI.BufferSize.Width)
    $WindowSize.Height = $Height

    try
    {
        $Host.UI.RawUI.WindowSize = $WindowSize
    }
    catch [System.Management.Automation.SetValueInvocationException]
    {
        $Maxvalue = ($_.Exception.Message |Select-String "\d+").Matches[0].Value
        $WindowSize.Height = $Maxvalue
        $Host.UI.RawUI.WindowSize = $WindowSize
    }
}