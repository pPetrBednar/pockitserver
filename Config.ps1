function Read-Properties-Value
{
    param (
        [string]$FilePath,
        [string]$TargetKey
    )

    # Read the YAML file content
    $YamlContent = Get-Content -Path $FilePath

    # Initialize variables
    $FoundKey = $false
    $Value = $null

    foreach ($Line in $YamlContent)
    {
        # Skip comments and empty lines
        if ($Line -match '^\s*#|^$')
        {
            continue
        }
        # Check if the line contains the target key
        if ($Line -match "^(\s*)$TargetKey\s*=\s*(.*)")
        {
            $FoundKey = $true
            $Value = $matches[2].Trim()
            break
        }
    }

    if ($FoundKey)
    {
        return $Value
    }
    else
    {
        Write-Warning "Key '$TargetKey' not found in the YAML file."
        return $null
    }
}