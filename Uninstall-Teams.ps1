# Remove WebRTC
$WebRTC = Get-WmiObject -Class Win32_Product | Where-Object{$_.Name -eq "Remote Desktop WebRTC Redirector Service"}
$WebRTC.Uninstall()
# Remove Teams
function unInstallTeams($path) {
  $clientInstaller = "$($path)\Update.exe"
   try {
        $process = Start-Process -FilePath "$clientInstaller" -ArgumentList "--uninstall /s" -PassThru -Wait -ErrorAction STOP
        if ($process.ExitCode -ne 0)
    {
      Write-Error "UnInstallation failed with exit code  $($process.ExitCode)."
        }
    }
    catch {
        Write-Error $_.Exception.Message
    }
}
$ProgramFiles = "C:\Program Files (x86)\Microsoft\Teams\"
If (Test-Path "$($ProgramFiles)\current\Teams.exe")
{
  unInstallTeams($ProgramFiles)
}else {
  Write-Warning  "Teams installation not found"
}
# Remove Teams Machine-Wide Installer
Write-Host "Removing Teams Machine-wide Installer" -ForegroundColor Yellow
$MachineWide = Get-WmiObject -Class Win32_Product | Where-Object{$_.Name -eq "Teams Machine-Wide Installer"}
$MachineWide.Uninstall()