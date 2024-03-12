# Pocket PowerShell WEB server

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

## Server properties [default]

```
# Port
server.port=8080

# Logging
server.log.level=debug # none|info|error|debug

# HTTP server [relative]
server.root.path=http
server.root.relative=true
server.http.index=index.html

# HTTP server [absolute]
server.root.path=C:\server\http
server.root.relative=false
server.http.index=index.html
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

### Configuration

```
Path -> Script core.ps1
Command parameters: -executionpolicy unrestricted
Working directory: this project folder
```