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
