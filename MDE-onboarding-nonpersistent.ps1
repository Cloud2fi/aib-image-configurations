if (Test-Path -Path C:\Windows\System32\GroupPolicy\Machine\Scripts\Startup) {
    Write-Host "Folder exists"
} else {
    New-item -Type Directory -Path "C:\Windows\System32\GroupPolicy\Machine\Scripts" -Name 'Startup'
}

Set-Location -Path "C:\Windows\System32\GroupPolicy\Machine\Scripts\Startup\"
$outputPath = "C:\Windows\System32\GroupPolicy\Machine\Scripts\Startup\"

$file1_uri = "https://aibsokcustomscripts.blob.core.windows.net/aib-custom-scripts/Onboard-NonPersistentMachine.ps1"
$file2_uri = "https://aibsokcustomscripts.blob.core.windows.net/aib-custom-scripts/WindowsDefenderATPOnboardingScript.cmd"
$file1 = "Onboard-NonPersistentMachine.ps1"
$file2 = "WindowsDefenderATPOnboardingScript.cmd"

Invoke-WebRequest -Uri $file1_uri -OutFile $outputPath + '\' + $file1
Invoke-WebRequest -Uri $file2_uri -OutFile $outputPath + '\' + $file2

# Add script to Group Policy through the Registry
'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\Scripts\Startup\0\0',
'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine\Scripts\Startup\0\0' |
  ForEach-Object { 
    if (-not (Test-Path $_)) {
        New-Item -path $_ -force
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
  
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Name psIni -MinimumVersion 3.1.2 -Force

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
$newIniContent | Out-IniFile -filePath C:\Windows\System32\GroupPolicy\Machine\Scripts\psScripts.ini -encoding Unicode -force
