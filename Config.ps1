$config = Join-Path $PWD.Path "config.properties"

function Read-Properties-Value
{
    param (
        [string]$filePath,
        [string]$targetKey
    )

    # Read the properties file content
    $content = Get-Content -Path $filePath

    # Initialize variables
    $foundKey = $false
    $value = $null

    foreach ($line in $content)
    {
        # Skip comments and empty lines
        if ($line -match '^\s*#|^$')
        {
            continue
        }
        # Check if the line contains the target key
        if ($line -match "^(\s*)$targetKey\s*=\s*(.*)")
        {
            $foundKey = $true
            $value = $matches[2].Trim()
            break
        }
    }

    if ($foundKey)
    {
        return $value
    }
    else
    {
        Log-Error "Key '$targetKey' not found in the configuration file ($config)."
        return $null
    }
}

function Get-Config
{
    param (
        [string]$targetKey
    )

    return Read-Properties-Value -filePath $config -targetKey $targetKey
}