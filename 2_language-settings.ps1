# Import module using Windows PowerShell mode
# powershell.exe
# Import-Module -Name 'International'
Write-Host "Custom script 2: Start language and regional settings script" -ForegroundColor Yellow

Import-Module -Name International

# Sets the Windows UI language override setting for the current user account (Log off, log on required)
Write-Host "Custom script 2: Step 1: Begin setting Windows UI language override" -ForegroundColor Yellow
Set-WinUILanguageOverride -Language 'en-FI'
Write-Host "Custom script 2: Step 1: End setting Windows UI language override" -ForegroundColor Yellow

# Sets the system locale for the current computer (restart required)
Write-Host "Custom script 2: Step 2: Begin setting Windows system locale" -ForegroundColor Yellow
Set-WinSystemLocale -SystemLocale 'en-US'
Write-Host "Custom script 2: Step 2: End setting Windows system locale" -ForegroundColor Yellow

# Sets the user culture for the current user account
Write-Host "Custom script 2: Step 3: Begin setting culture info" -ForegroundColor Yellow
Set-Culture -CultureInfo 'en-FI'
Write-Host "Custom script 2: Step 3: End setting culture info" -ForegroundColor Yellow

# Sets the home location setting for the current user account ('77' = Finland)
Write-Host "Custom script 2: Step 4: Begin setting Windows home location" -ForegroundColor Yellow
Set-WinHomeLocation -GeoId '77'
Write-Host "Custom script 2: Step 4: End setting Windows home location" -ForegroundColor Yellow

# Set additional languages
#Write-Host "Custom script 2: Step 5: Begin setting additional languages" -ForegroundColor Yellow
#$languageList = Get-WinUserLanguageList
#$languageList.add("fi-FI")
#Set-WinUserLanguageList $languageList
#Write-Host "Custom script 2: Step 5: End setting additional languages" -ForegroundColor Yellow

# Copies the current user's international settings to Welcome screen, system accounts and New user accounts (restart required)
#Write-Host "Custom script 2: Step 6: Begin copying user international settings to system: Welcome screen and New user" -ForegroundColor Yellow
#Copy-UserInternationalSettingsToSystem -WelcomeScreen $true -NewUser $true
#Write-Host "Custom script 2: Step 6: End copying user international settings to system: Welcome screen and New user" -ForegroundColor Yellow

Write-Host "Custom script 2: End language and regional settings script" -ForegroundColor Yellow