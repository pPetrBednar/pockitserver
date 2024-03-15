$globalLogLevel = Get-Config -targetKey "live-reload-server.log.level"
$listener = $null

# Specify the file where modification times are saved
$modificationsFile = ".\.modifications"

# Function to recursively print files with modification times
function Check-Files-For-Modifications
{
    param (
        [string]$directory,
        [string]$modificationsFile
    )

    # Get all files in the directory recursively
    $files = Get-ChildItem -Path $directory -File -Recurse

    # Check if the modifications file exists
    if (Test-Path $modificationsFile)
    {
        Log-Debug $globalLogLevel "Loaded modifications file"
        $json = Get-Content $modificationsFile | ConvertFrom-Json | ConvertTo-Json
        $existingModTimes = @{ }
        (ConvertFrom-Json $json).psobject.properties | Foreach { $existingModTimes[$_.Name] = $_.Value }
    }
    else
    {
        Log-Debug $globalLogLevel "Could not find modifications file"
        $existingModTimes = @{ }
    }

    $newModTimes = @{ }

    # Flag to check if any modifications were found
    $modificationsFound = $false

    foreach ($file in $files)
    {
        # Get the last modification time of the file
        $modTime = $file.LastWriteTime

        # Get the stored modification time for this file if exists
        if ($existingModTimes.Keys -contains $file.FullName)
        {
            $storedModTime = [datetime]::ParseExact($existingModTimes[$file.FullName], "MM/dd/yyyy HH:mm:ss", [System.Globalization.CultureInfo]::InvariantCulture)
        }
        else
        {
            $storedModTime = $null
        }

        # Compare stored modification time with current modification time
        Log-Debug $globalLogLevel "Comparing $storedModTime to $modTime"
        if ("$storedModTime" -ne "$modTime")
        {
            $modificationsFound = $true
            Log-Debug $globalLogLevel "$( $file.FullName ) - Modified at $modTime"
        }
        Log-Debug $globalLogLevel "Setting index $( $file.FullName )"
        $newModTimes[$file.FullName] = "$modTime"
    }

    # Save new modification times
    Log-Debug $globalLogLevel "Saving to modifications file $modificationsFile"
    $newModTimes | ConvertTo-Json | Set-Content $modificationsFile

    return $modificationsFound
}

function Stop-Live-Reload-Server
{
    Log-Info $globalLogLevel "Server is shutting down.."
    $listener.Stop()
    Log-Info $globalLogLevel "Server shut down"
}

function Start-Live-Reload-Server
{
    # Define the port number to listen on
    $port = Get-Config -targetKey "live-reload-server.port"

    # Define the root containing the HTML files
    $useRelative = Get-Config -targetKey "server.root.relative"
    $pathToRoot = Get-Config -targetKey "server.root.path"

    if ($useRelative -eq "true")
    {
        $root = Join-Path $PWD.Path $pathToRoot
    }
    else
    {
        $root = $pathToRoot
    }

    # Create the HTTP listener
    $listener = New-Object System.Net.HttpListener
    $listener.Prefixes.Add("http://localhost:$port/")
    $listener.Start()

    Log-Info $globalLogLevel "Starting Live-Reload Server at: $root"
    Log-Info $globalLogLevel "Listening for requests on port $port"

    try
    {

        # Main loop: wait for incoming requests and serve files
        while ($listener.IsListening)
        {
            $context = $listener.GetContext()
            $response = $context.Response

            # Set CORS headers to allow requests from all origins
            $response.AppendHeader("Access-Control-Allow-Origin", "*")
            $response.AppendHeader("Access-Control-Allow-Methods", "GET, OPTIONS")

            try
            {
                # Check for modifications
                $modifications = Check-Files-For-Modifications -directory $root -modificationsFile $modificationsFile
                Log-Info $globalLogLevel "Modifications: $modifications"
                if ($modifications)
                {
                    $response.StatusCode = 200
                }
                else
                {
                    $response.StatusCode = 201
                }
            }
            catch
            {
                # Modification identification failed
                Log-Error $globalLogLevel "Modification identification failed"
                $response.StatusCode = 201
            }
            # Close the response stream
            $response.Close()
        }
    }
    finally
    {
        Stop-Live-Reload-Server
    }
}