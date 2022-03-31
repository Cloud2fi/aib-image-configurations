# AppV fixes
Write-Host "Custom script 4: Start enable App-V configuration script" -ForegroundColor Yellow

    # Enable 8Dot3 Creation on all Volumes (0)
Write-Host "Custom script 4: Step 1: Begin enabling NtfsDisable8dot3NameCreation" -ForegroundColor Yellow
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem" /v NtfsDisable8dot3NameCreation /t REG_DWORD /d 0 /f
Write-Host "Custom script 4: Step 1: End enabling NtfsDisable8dot3NameCreation" -ForegroundColor Yellow

    # Remove all packages if any
Write-Host "Custom script 4: Step 2: Begin removing any current AppvClientPackages" -ForegroundColor Yellow
Get-AppvClientPackage -all | Remove-AppvClientPackage
Write-Host "Custom script 4: Step 2: End removing any current AppvClientPackages" -ForegroundColor Yellow

    # Test path if exists remove
Write-Host "Custom script 4: Step 3: Begin test App-V folder path" -ForegroundColor Yellow
$folderPath = 'C:\ProgramData\App-V'
if (Test-Path -Path $folderPath) {
    Remove-Item -Path $folderPath
}
Write-Host "Custom script 4: Step 3: End test App-V folder path" -ForegroundColor Yellow

    # Create folder
Write-Host "Custom script 4: Step 4: Begin creating App-V folder path" -ForegroundColor Yellow
New-Item -Path 'C:\ProgramData' -Name 'App-V' -ItemType 'Directory'
Write-Host "Custom script 4: Step 4: End creating App-V folder path" -ForegroundColor Yellow

    # Disable inheritance 
Write-Host "Custom script 4: Step 5: Begin NTFS: Disable inheritance, Set SYSTEM as owner" -ForegroundColor Yellow
$acl = Get-Acl -Path $folderPath
$acl.SetAccessRuleProtection($true, $false)
$owner = New-Object System.Security.Principal.NTAccount("NT AUTHORITY\SYSTEM")
$acl.SetOwner($owner)
(Get-Item $folderPath).SetAccessControl($acl)
Clear-Variable -Name 'acl'
Write-Host "Custom script 4: Step 5: End NTFS: Disable inheritance, Set SYSTEM as owner" -ForegroundColor Yellow

    # Set correct NTFS permissions
Write-Host "Custom script 4: Step 6: Begin NTFS: Create empty ACL object, disable inheritance" -ForegroundColor Yellow
    # Create empty acl object and disable inheritance
$acl = New-Object System.Security.AccessControl.DirectorySecurity
$acl.SetAccessRuleProtection($true, $false)
Write-Host "Custom script 4: Step 6: End NTFS: Create empty ACL object, disable inheritance" -ForegroundColor Yellow
    # SYSTEM
Write-Host "Custom script 4: Step 7: Begin NTFS: Add Access Control Entity: SYSTEM" -ForegroundColor Yellow
$identity = 'NT AUTHORITY\SYSTEM'
$rights = 'FullControl'
$inheritance = 'ContainerInherit, ObjectInherit'
$propagation = 'None' 
$type = 'Allow' 
$ACE = New-Object System.Security.AccessControl.FileSystemAccessRule($identity,$rights,$inheritance,$propagation,$type)
$acl.SetAccessRule($ACE)
Clear-Variable -Name 'ACE'
Write-Host "Custom script 4: Step 7: End NTFS: Add Access Control Entity: SYSTEM" -ForegroundColor Yellow

    # Administrators
Write-Host "Custom script 4: Step 8: Begin NTFS: Add Access Control Entity: Administrators" -ForegroundColor Yellow
$identity = 'BUILTIN\Administrators'
$rights = 'FullControl'
$inheritance = 'ContainerInherit, ObjectInherit' #Other options: [enum]::GetValues('System.Security.AccessControl.Inheritance')
$propagation = 'None' #Other options: [enum]::GetValues('System.Security.AccessControl.PropagationFlags')
$type = 'Allow' #Other options: [enum]::GetValues('System.Securit y.AccessControl.AccessControlType')
$ACE = New-Object System.Security.AccessControl.FileSystemAccessRule($identity,$rights,$inheritance,$propagation,$type)
$acl.SetAccessRule($ACE)
Clear-Variable -Name 'ACE'
Write-Host "Custom script 4: Step 8: End NTFS: Add Access Control Entity: Administrators" -ForegroundColor Yellow

    # TrustedInstaller
Write-Host "Custom script 4: Step 9: Begin NTFS: Add Access Control Entity: TrustedInstaller" -ForegroundColor Yellow
$identity = 'NT Service\TrustedInstaller'
$rights = 'FullControl'
$inheritance = 'ContainerInherit, ObjectInherit' #Other options: [enum]::GetValues('System.Security.AccessControl.Inheritance')
$propagation = 'None' #Other options: [enum]::GetValues('System.Security.AccessControl.PropagationFlags')
$type = 'Allow' #Other options: [enum]::GetValues('System.Securit y.AccessControl.AccessControlType')
$ACE = New-Object System.Security.AccessControl.FileSystemAccessRule($identity,$rights,$inheritance,$propagation,$type)
$acl.SetAccessRule($ACE)
Clear-Variable -Name 'ACE'
Write-Host "Custom script 4: Step 9: End NTFS: Add Access Control Entity: TrustedInstaller" -ForegroundColor Yellow

    # Authenticated Users
Write-Host "Custom script 4: Step 10: Begin NTFS: Add Access Control Entity: Authenticated Users" -ForegroundColor Yellow
$identity = 'Authenticated Users'
$rights = 'Read'
$inheritance = 'ContainerInherit, ObjectInherit' #Other options: [enum]::GetValues('System.Security.AccessControl.Inheritance')
$propagation = 'None' #Other options: [enum]::GetValues('System.Security.AccessControl.PropagationFlags')
$type = 'Allow' #Other options: [enum]::GetValues('System.Securit y.AccessControl.AccessControlType')
$ACE = New-Object System.Security.AccessControl.FileSystemAccessRule($identity,$rights,$inheritance,$propagation,$type)
$acl.SetAccessRule($ACE)
Clear-Variable -Name 'ACE'
Write-Host "Custom script 4: Step 10: End NTFS: Add Access Control Entity: Authenticated Users" -ForegroundColor Yellow

Write-Host "Custom script 4: Step 11: Begin NTFS: Set access control to folder" -ForegroundColor Yellow
(Get-Item $folderPath).SetAccessControl($acl)
Write-Host "Custom script 4: Step 11: End NTFS: Set access control to folder" -ForegroundColor Yellow

Write-Host "Custom script 4: End enable App-V configuration script" -ForegroundColor Yellow