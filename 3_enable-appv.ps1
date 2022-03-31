# Enable App-V and set publishing server address
Write-Host "Custom script 3: Start enable App-V script" -ForegroundColor Yellow
Write-Host "Custom script 3: Step 1: Begin enabling App-V" -ForegroundColor Yellow
Import-Module -Name AppvClient
Enable-Appv
Add-AppvPublishingServer -Name 'appv5.sok.fi' -URL 'http://appv5.sok.fi'
Write-Host "Custom script 3: Step 1: End enabling App-V" -ForegroundColor Yellow
Write-Host "Custom script 3: End enable App-V script" -ForegroundColor Yellow
