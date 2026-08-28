$ErrorActionPreference = "Stop"
Write-Host "Waiting for CharonTool.exe..."
while (!(Test-Path "e:\CharonTool\dist\CharonTool.exe") -or ((Get-Item "e:\CharonTool\dist\CharonTool.exe").LastWriteTime -lt (Get-Date).AddMinutes(-1))) {
    Start-Sleep -Seconds 5
}
# wait an extra 5 seconds for release:manifest to finish writing latest.json
Start-Sleep -Seconds 5
Write-Host "Build complete! Updating repo..."
Copy-Item "e:\CharonTool\latest.json" "E:\CharonTools-Update\latest.json" -Force
cd E:\CharonTools-Update
git add .
git commit -m "Release v4.0.0 and add install script"
git push
Write-Host "Done!"
