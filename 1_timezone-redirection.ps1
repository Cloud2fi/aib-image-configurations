# Add registry key for time zone redirection
Write-Host "Custom script 1: Start time zone redirection script" -ForegroundColor Yellow
Write-Host "Custom script 1: Step 1: Begin enabling time zone redirection" -ForegroundColor Yellow
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v fEnableTimeZoneRedirection /t REG_DWORD /d 1 /f
Write-Host "Custom script 1: Step 1: End enabling time zone redirection" -ForegroundColor Yellow
Write-Host "Custom script 1: End time zone redirection script" -ForegroundColor Yellow