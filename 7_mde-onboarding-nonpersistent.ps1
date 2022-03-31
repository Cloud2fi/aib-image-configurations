Write-Host "Custom script 7: Start MDE onboarding script" -ForegroundColor Yellow

  # Test file path
Write-Host "Custom script 7: Step 1: Begin test file path" -ForegroundColor Yellow
if (Test-Path -Path 'C:\Windows\System32\GroupPolicy\Machine\Scripts\Startup') {
    Write-Host "Folder exists"
} else {
    New-item -Type 'Directory' -Path "C:\Windows\System32\GroupPolicy\Machine\Scripts" -Name 'Startup'
}
Write-Host "Custom script 7: Step 1: End test file path" -ForegroundColor Yellow

  # Set up variables
Write-Host "Custom script 7: Step 2: Begin setting variables" -ForegroundColor Yellow
Set-Location -Path "C:\Windows\System32\GroupPolicy\Machine\Scripts\Startup\"
$outputPath = "C:\Windows\System32\GroupPolicy\Machine\Scripts\Startup\"
$file1_uri = "https://aibsokcustomscripts.blob.core.windows.net/aib-custom-scripts/Onboard-NonPersistentMachine.ps1"
$file2_uri = "https://aibsokcustomscripts.blob.core.windows.net/aib-custom-scripts/WindowsDefenderATPOnboardingScript.cmd"
$file1 = "Onboard-NonPersistentMachine.ps1"
$file2 = "WindowsDefenderATPOnboardingScript.cmd"
Write-Host "Custom script 7: Step 2: End setting variables" -ForegroundColor Yellow

  # File downloads
Write-Host "Custom script 7: Step 3: Begin file downloads" -ForegroundColor Yellow
Invoke-WebRequest -Uri $file1_uri -OutFile $outputPath + '\' + $file1
Invoke-WebRequest -Uri $file2_uri -OutFile $outputPath + '\' + $file2
Write-Host "Custom script 7: Step 3: End file downloads" -ForegroundColor Yellow

  # Add script to Group Policy through the Registry
Write-Host "Custom script 7: Step 4: Begin registry modification" -ForegroundColor Yellow
'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\Scripts\Startup\0\0',
'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine\Scripts\Startup\0\0' |
  ForEach-Object { 
    if (-not (Test-Path $_)) {
        New-Item -path $_ -Force
    }
  }

'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\Scripts\Startup\0',
'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine\Scripts\Startup\0' |
  ForEach-Object {
    New-ItemProperty -path "$_" -name DisplayName -propertyType String -value "Local Group Policy" 
    New-ItemProperty -path "$_" -name FileSysPath -propertyType String -value "$ENV:systemRoot\System32\GroupPolicy\Machine" 
    New-ItemProperty -path "$_" -name GPO-ID -propertyType String -value "LocalGPO"
    New-ItemProperty -path "$_" -name GPOName -propertyType String -value "Local Group Policy"
    New-ItemProperty -path "$_" -name PSScriptOrder -propertyType DWord -value 2 
    New-ItemProperty -path "$_" -name SOM-ID -propertyType String -value "Local"
  }
'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\Scripts\Startup\0\0',
'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine\Scripts\Startup\0\0' |
  ForEach-Object {
    New-ItemProperty -path "$_" -name Script -propertyType String -value $file1
    New-ItemProperty -path "$_" -name Parameters -propertyType String -value ''
    New-ItemProperty -path "$_" -name IsPowershell -propertyType DWord -value 1
    New-ItemProperty -path "$_" -name ExecTime -propertyType QWord -value 0
  }
Write-Host "Custom script 7: Step 4: End registry modification" -ForegroundColor Yellow

  # Install NuGet and psIni module
Write-Host "Custom script 7: Step 5: Begin NuGet and psIni installs" -ForegroundColor Yellow
Install-PackageProvider -Name 'NuGet' -MinimumVersion 2.8.5.201 -AllowClobber -Force
Install-Module -Name 'psIni' -MinimumVersion 3.1.2 -AllowClobber -Force
Write-Host "Custom script 7: Step 5: End NuGet and psIni installs" -ForegroundColor Yellow

  # Create ini -file
Write-Host "Custom script 7: Step 6: Begin .ini file creation" -ForegroundColor Yellow
$scriptsConfig = @{
    StartExecutePSFirst = 'true'
    EndExecutePSFirst =   'true'
}
$startup = @{
    '0CmdLine' = $file1
    '0Parameters' = ''
}
$newIniContent = [ordered] @{ 
    ScriptsConfig = $scriptsConfig
    Startup =       $startup 
}
$newIniContent | Out-IniFile -filePath 'C:\Windows\System32\GroupPolicy\Machine\Scripts\psScripts.ini' -Encoding Unicode -Force
Write-Host "Custom script 7: Step 6: End .ini file creation" -ForegroundColor Yellow

Write-Host "Custom script 7: End MDE onboarding script" -ForegroundColor Yellow