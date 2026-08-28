$ErrorActionPreference = "Stop"
Write-Host "Fetching latest CharonTool release info..." -ForegroundColor Cyan

$latestJsonUrl = "https://raw.githubusercontent.com/BlissBlender/CharonTools-Update/main/latest.json"
$latest = Invoke-RestMethod -Uri $latestJsonUrl -Headers @{"Cache-Control"="no-cache"}

$downloadUrl = $latest.downloadUrl
$version = $latest.version

Write-Host "Latest version is v$version. Downloading..." -ForegroundColor Cyan

$installDir = "$env:LOCALAPPDATA\CharonTool"
if (!(Test-Path $installDir)) {
    New-Item -ItemType Directory -Force -Path $installDir | Out-Null
}

$exePath = "$installDir\CharonTool.exe"

# If the app is currently running, we should kill it before overwriting
Get-Process -Name "CharonTool" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

Invoke-WebRequest -Uri $downloadUrl -OutFile $exePath

Write-Host "Creating Desktop Shortcut..." -ForegroundColor Cyan
$wshShell = New-Object -ComObject WScript.Shell
$shortcut = $wshShell.CreateShortcut("$env:USERPROFILE\Desktop\CharonTool.lnk")
$shortcut.TargetPath = $exePath
$shortcut.WorkingDirectory = $installDir
$shortcut.IconLocation = $exePath
$shortcut.Save()

Write-Host "Installation Complete! Launching CharonTool..." -ForegroundColor Green
Start-Process -FilePath $exePath
