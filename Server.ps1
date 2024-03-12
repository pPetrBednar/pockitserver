$listener = $null

function Stop-Server
{
    Log-Info "Server is shutting down.."
    $listener.Stop()
    Log-Info "Server shut down"
}

function Run-Server
{
    # Define the port number to listen on
    $port = Get-Config -targetKey "server.port"

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

    $indexPath = Get-Config -targetKey "server.http.index"

    # Create the HTTP listener
    $listener = New-Object System.Net.HttpListener
    $listener.Prefixes.Add("http://localhost:$port/")
    $listener.Start()

    Log-Info "Starting server at: $root"
    Log-Info "Listening for requests on port $port"

    try
    {

        # Main loop: wait for incoming requests and serve files
        while ($listener.IsListening)
        {
            $context = $listener.GetContext()
            $request = $context.Request
            $response = $context.Response

            # Get the requested file path
            $filePath = $request.Url.LocalPath

            if ($filePath -eq "/")
            {
                $filePath = $indexPath
            }

            $fullPath = Join-Path $root $filePath

            if (Test-Path $fullPath -PathType Leaf)
            {
                Log-Debug "Resolved request for $filePath"
                # Serve the requested file
                $fileBytes = [System.IO.File]::ReadAllBytes($fullPath)
                $response.OutputStream.Write($fileBytes, 0, $fileBytes.Length)
            }
            else
            {
                Log-Debug "File $filePath not found"
                # File not found, return 404 error
                $errorMessage = "File not found: $filePath"
                $errorBytes = [System.Text.Encoding]::UTF8.GetBytes($errorMessage)
                $response.StatusCode = 404
                $response.StatusDescription = "Not Found"
                $response.OutputStream.Write($errorBytes, 0, $errorBytes.Length)
            }

            # Close the response stream
            $response.Close()
        }
    }
    catch
    {
        Stop-Server
    }
    finally
    {
        Stop-Server
    }
}