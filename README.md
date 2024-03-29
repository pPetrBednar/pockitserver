<img align="left" width="100" height="100" src="icon.png" alt="Pockitserver Icon">

<h1>Pockitserver</h1>

<br>

## Pocket PowerShell WEB Server \w Live-Reload Server
Simple HTTP server implementation using PowerShell.
Server is configurable using config.properties file.
Example configuration is present in chapter below.

Server is capable of showing any file inside specified root directory.
Be aware of the fact that the server doesn't have any security measures.
Server is intended for local only use as a way how to bypass localhost CORS.

Server includes advanced logging that is stored inside specified file.

```
Log output format
yyyy-MM-dd HH:mm:ss [info|error|debug] <message>
```

## Installation

1. **Download latest release .zip file of Pockitserver.**
2. **Extract files to folder.**
3. **[recommended] Run Pockitserver.exe**
    - Start - to start both HTML and LR servers
    - Stop - to shut down both servers
    - Quit - close GUI (runs Stop before exit)
- **[optional]** *Start servers using .bat files*
    - *start.bat - to start both HTML and LR servers*
    - *stop.bat - to shut down both servers*

## Live-Reload functionality

Live-Reload is managed using separate server.
Specific JS script needs to be present in each LR enabled html file.
Script calls LR server every few seconds to check for file modifications.
If there is a change, page gets reloaded.
To set up this functionality, live-reload.js needs to be included.
Lastly the change checking interval needs to be added to body onload.

```html
<body onload="liveReload(1000)">
   <script src="./http/js/live-reload.js"></script>
</body>
```
You can manually set the live-reload interval or leave it empty to use default 1000ms / 1s interval.
```html
<body onload="liveReload()">
   <script src="./http/js/live-reload.js"></script>
</body>
```
Alternatively you can use **automatic mode** with inclusion of single script.
```html
<body>
   <script src="./http/js/live-reload-auto.js"></script>
</body>
```

## Server properties [default]

```properties
# GUI
gui.console=false

# HTTP Server
# Port
server.port=8080

# Logging [none|info|error|debug]
server.log.level=debug

# HTTP server [relative]
server.root.path=http
server.root.relative=true
server.http.index=index.html

# HTTP server [absolute]
# server.root.path=C:\server\http
# server.root.relative=false
# server.http.index=index.html

# Live Reload server
# Port
live-reload-server.port=8081

# Logging [none|info|error|debug]
live-reload-server.log.level=info
```

## Support

- HTML files
- CSS files
- JS files
- Assets / Resources*

*Any browser supported local file.

## IntelliJ IDEA configuration

### Plugins

```
Plugins -> Powershell
```

### Configurations

```
Name -> Run [http]
Path -> Script .\bin\HTMLServerRunner.ps1
Command parameters: -executionpolicy unrestricted
Working directory: this project folder

Name -> Run [live-reload]
Path -> Script .\bin\LiveReloadServerRunner.ps1
Command parameters: -executionpolicy unrestricted
Working directory: this project folder

Name -> GUI
Path -> Script .\bin\GUI.ps1
Command parameters: -executionpolicy unrestricted
Working directory: this project folder
```
