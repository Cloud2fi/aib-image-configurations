write-host 'AIB Customization: Downloading OneDrive'
New-Item -Path C:\\ -Name 'OneDrive_install' -ItemType Directory -ErrorAction SilentlyContinue
$LocalPath = 'C:\\OneDrive_install'
$OneDriveURL = 'https://go.microsoft.com/fwlink/p/?LinkID=2182910&clcid=0x409&culture=en-us&country=US'
$OneDriveInstaller = 'OneDriveSetup.exe'
$outputPath = $LocalPath + '\' + $OneDriveInstaller
Invoke-WebRequest -Uri $OneDriveURL -OutFile $outputPath
Set-Location $LocalPath
write-host 'AIB Customization: Download OneDrive installer finished'

write-host 'AIB Customization: Start OneDrive installer'
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force -Verbose
.\OneDriveSetup.exe /Uninstall /AllUsers -Verbose
.\OneDriveSetup.exe /Silent /AllUsers -Verbose 
write-host 'AIB Customization: Finished OneDrive installer' 
