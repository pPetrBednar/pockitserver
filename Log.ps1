$logLevelDebug = "debug"
$logLevelInfo = "info"
$logLevelError = "error"
$logLevelNone = "none"

function Log-Level
{
    param (
        [string]$level
    )

    switch ($level)
    {
        $logLevelDebug {
            return 3
        }

        $logLevelInfo {
            return 2
        }

        $logLevelError {
            return 1
        }

        $logLevelNone {
            return 0
        }
    }

    return 0;
}

function Log-Level-Reverse
{
    param (
        [int]$level
    )

    switch ($level)
    {
        3 {
            return $logLevelDebug
        }

        2 {
            return $logLevelError
        }

        1 {
            return $logLevelInfo
        }
    }

    return $logLevelNone
}

function Log
{
    param (
        [int]$level,
        [string]$message
    )

    $globalLevel = Read-Properties-Value -filePath $config -targetKey "server.log.level"
    $globalLevelNum = Log-Level -level $globalLevel

    if ($level -le $globalLevelNum)
    {
        $levelText = Log-Level-Reverse -level $level
        Write-Host "$( Get-Date -Format 'yyyy-MM-dd HH:mm:ss' ) [$levelText] $message"
    }
}

function Log-Info
{
    param (
        [string]$message
    )

    Log -level 1 -message $message
}

function Log-Error
{
    param (
        [string]$message
    )

    Log -level 2 -message $message
}

function Log-Debug
{
    param (
        [string]$message
    )

    Log -level 3 -message $message
}