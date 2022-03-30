# Import module using Windows PowerShell mode
Import-Module -Name International

# Sets the Windows UI language override setting for the current user account (Log off, log on required)
Set-WinUILanguageOverride -Language 'en-FI'

# Sets the system locale for the current computer (restart required)
Set-WinSystemLocale -SystemLocale 'en-US'

# Sets the user culture for the current user account
Set-Culture -CultureInfo 'en-FI'

# Sets the home location setting for the current user account ('77' = Finland)
Set-WinHomeLocation -GeoId '77'

# Set additional languages
$languageList = Get-WinUserLanguageList
$languageList.add("fi-FI")
Set-WinUserLanguageList $languageList

# Copies the current user's international settings to Welcome screen, system accounts and New user accounts (restart required)
Copy-UserInternationalSettingsToSystem -WelcomeScreen $true -NewUser $true
