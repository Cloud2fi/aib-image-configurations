Write-Host "Custom script 5: Start optimize Windows script" -ForegroundColor Yellow 
 
  # File download preparations
Write-Host "Custom script 5: Step 1: Begin file download preparations" -ForegroundColor Yellow
$appName = 'optimize'
$drive = 'C:\'
New-Item -Path $drive -Name $appName -ItemType 'Directory' -ErrorAction SilentlyContinue
$LocalPath = $drive + '\' + $appName 
Set-Location $LocalPath
$osOptURL = 'https://github.com/The-Virtual-Desktop-Team/Virtual-Desktop-Optimization-Tool/archive/refs/heads/main.zip'
$osOptURLexe = 'Virtual-Desktop-Optimization-Tool-main.zip'
$outputPath = $LocalPath + '\' + $osOptURLexe
Write-Host "Custom script 5: Step 1: End file download preparations" -ForegroundColor Yellow

  # File download
Write-Host "Custom script 5: Step 2: Begin file download and zip extraction" -ForegroundColor Yellow
Invoke-WebRequest -Uri $osOptURL -OutFile $outputPath
Expand-Archive -LiteralPath 'C:\Optimize\Virtual-Desktop-Optimization-Tool-main.zip' -DestinationPath $Localpath -Force -Verbose
Set-ExecutionPolicy -ExecutionPolicy 'RemoteSigned' -Force -Verbose
Set-Location -Path 'C:\Optimize\Virtual-Desktop-Optimization-Tool-main'
Write-Host "Custom script 5: Step 2: End file download and zip extraction" -ForegroundColor Yellow

  # Instrumentation script download
Write-Host "Custom script 5: Step 3: Begin script download" -ForegroundColor Yellow
$osOptURL = 'https://raw.githubusercontent.com/The-Virtual-Desktop-Team/Virtual-Desktop-Optimization-Tool/main/Win10_VirtualDesktop_Optimize.ps1'
$osOptURLexe = 'optimize.ps1'
Invoke-WebRequest -Uri $osOptURL -OutFile $osOptURLexe
Write-Host "Custom script 5: Step 3: End script download" -ForegroundColor Yellow

  # Patch: overide the Win10_VirtualDesktop_Optimize.ps1 - setting 'Set-NetAdapterAdvancedProperty'(see readme.md)
Write-Host "Custom script 5: Step 4: Begin NetAdapter patch" -ForegroundColor Yellow
Write-Host 'Patch: Disabling Set-NetAdapterAdvancedProperty'
$updatePath= "C:\optimize\Virtual-Desktop-Optimization-Tool-main\Win10_VirtualDesktop_Optimize.ps1"
((Get-Content -path $updatePath -Raw) -replace 'Set-NetAdapterAdvancedProperty -DisplayName "Send Buffer Size" -DisplayValue 4MB','#Set-NetAdapterAdvancedProperty -DisplayName "Send Buffer Size" -DisplayValue 4MB') | Set-Content -Path $updatePath
Write-Host "Custom script 5: Step 4: End NetAdapter patch" -ForegroundColor Yellow

  # Patch: overide the REG UNLOAD, needs GC before, otherwise will Access Deny unload(see readme.md)
Write-Host "Custom script 5: Step 5: Begin NetAdapter patch" -ForegroundColor Yellow
[System.Collections.ArrayList]$file = Get-Content $updatePath
$insert = @()
for ($i=0; $i -lt $file.count; $i++) {
  if ($file[$i] -like "*& REG UNLOAD HKLM\DEFAULT*") {
    $insert += $i-1 
  }
}
  # add gc and sleep
$insert | ForEach-Object { $file.insert($_,"Write-Host 'Patch closing handles and running GC before reg unload' `n `$newKey.Handle.close()` `n [gc]::collect() `n Start-Sleep -Seconds 15 ") }
Set-Content $updatePath $file 
Write-Host "Custom script 5: Step 5: End NetAdapter patch" -ForegroundColor Yellow

Write-Host "Custom script 5: Step 6: Begin run optimize script" -ForegroundColor Yellow
  # .\optimize -WindowsVersion 2004 -Verbose
.\Win10_VirtualDesktop_Optimize.ps1 -AcceptEULA -Verbose
Write-Host "Custom script 5: Step 6: End run optimize script" -ForegroundColor Yellow

Write-Host "Custom script 5: End optimize Windows script" -ForegroundColor Yellow 