$globalLogLevel = Get-Config -targetKey "server.log.level"
$listener = $null

function Stop-Http-Server
{
    Log-Info $globalLogLevel "Server is shutting down.."
    $listener.Stop()
    Log-Info $globalLogLevel "Server shut down"
}

function Start-Http-Server
{
    # Define the port number to listen on
    $port = Get-Config -targetKey "server.port"

    # Define the root containing the HTML files
    $useRelative = Get-Config -targetKey "server.root.relative"
    $pathToRoot = Get-Config -targetKey "server.root.path"
    $directoryListingPath = Join-Path $PWD.Path "bin\php\directory-listing.php";

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

    Log-Info $globalLogLevel "Starting HTTP Server at: $root"
    Log-Info $globalLogLevel "Listening for requests on port $port"

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

            # If index file exists, show that
            if ($filePath -eq "/")
            {
                $indexTestPath = Join-Path $root $indexPath
                if (Test-Path $indexTestPath -PathType Leaf)
                {
                    $filePath = $indexPath
                }
            }

            $fullPath = Join-Path $root $filePath

            if (Test-Path $fullPath -PathType Container)
            {
                Log-Debug $globalLogLevel "Resolved folder request for $filePath"
                $phpOutput = .\php\php-cgi.exe -f $directoryListingPath dir="$fullPath" root="$filePath"

                $response.ContentType = "text/html"
                # Convert PHP output to bytes
                $phpBytes = [System.Text.Encoding]::UTF8.GetBytes($phpOutput)

                # Write bytes to output stream
                $response.OutputStream.Write($phpBytes, 0, $phpBytes.Length)
            }
            elseif (Test-Path $fullPath -PathType Leaf)
            {
                if ($filePath -like "*.php")
                {
                    Log-Debug $globalLogLevel "Resolved PHP request for $filePath"
                    # PHP file requested, execute it
                    $phpOutput = & .\php\php-cgi.exe -f $fullPath
                    $response.ContentType = "text/html"
                    # Convert PHP output to bytes
                    $phpBytes = [System.Text.Encoding]::UTF8.GetBytes($phpOutput)

                    # Write bytes to output stream
                    $response.OutputStream.Write($phpBytes, 0, $phpBytes.Length)
                }
                else
                {
                    Log-Debug $globalLogLevel "Resolved request for $filePath"
                    # Serve the requested file
                    $fileBytes = [System.IO.File]::ReadAllBytes($fullPath)
                    $response.OutputStream.Write($fileBytes, 0, $fileBytes.Length)
                }
            }
            else
            {
                Log-Debug $globalLogLevel "File $filePath not found"
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
    finally
    {
        Stop-Http-Server
    }
}