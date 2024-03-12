# Define the port number to listen on
$port = 8080

# Define the directory containing the HTML files
$directory = Join-Path $PWD.Path "http"
$indexPath = "index.html"

# Create the HTTP listener
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$port/")
$listener.Start()

Write-Host "Starting server at: $directory"
Write-Host "Listening for requests on port $port"


# Define a function to handle shutdown events
function HandleShutdown
{
    Write-Host "Server is down."
    # Stop the listener when done
    $listener.Stop()
}

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

        $fullPath = Join-Path $directory $filePath

        if (Test-Path $fullPath -PathType Leaf)
        {
            Write-Host "File found"
            # Serve the requested file
            $fileBytes = [System.IO.File]::ReadAllBytes($fullPath)
            $response.OutputStream.Write($fileBytes, 0, $fileBytes.Length)
        }
        else
        {
            Write-Host "File not found"
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
    HandleShutdown
}