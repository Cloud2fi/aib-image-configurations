Write-Host "Custom script 6: Start install OneDrive script" -ForegroundColor Yellow

    # Prepare for download and installation
Write-Host "Custom script 6: Step 1: Begin file download preparations" -ForegroundColor Yellow
New-Item -Path 'C:\' -Name 'OneDrive_install' -ItemType 'Directory' -ErrorAction SilentlyContinue
$LocalPath = 'C:\OneDrive_install'
$OneDriveURL = 'https://go.microsoft.com/fwlink/p/?LinkID=2182910&clcid=0x409&culture=en-us&country=US'
$OneDriveInstaller = 'OneDriveSetup.exe'
$outputPath = $LocalPath + '\' + $OneDriveInstaller
Write-Host "Custom script 6: Step 1: End file download preparations" -ForegroundColor Yellow

    # Download OneDrive installer
Write-Host "Custom script 6: Step 2: Begin file download" -ForegroundColor Yellow
Invoke-WebRequest -Uri $OneDriveURL -OutFile $outputPath
Set-Location $LocalPath
Write-Host "Custom script 6: Step 2: End file download" -ForegroundColor Yellow

    # Install OneDrive
Write-Host "Custom script 6: Step 3: Begin OneDrive install"
Set-ExecutionPolicy -ExecutionPolicy 'RemoteSigned' -Force -Verbose
.\OneDriveSetup.exe /Uninstall /AllUsers -Verbose
.\OneDriveSetup.exe /Silent /AllUsers -Verbose 
Write-Host "Custom script 6: Step 3: End OneDrive install"

Write-Host "Custom script 6: End install OneDrive script" -ForegroundColor Yellow