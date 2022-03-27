# AppV fixes
# Enable 8Dot3 Creation on all Volumes (0)
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem" /v NtfsDisable8dot3NameCreation /t REG_DWORD /d 0 /f
Get-AppvClientPackage -all | Remove-AppvClientPackage
$folderPath = 'C:\ProgramData\App-V'
if (Test-Path -Path $folderPath) {
    Remove-Item -Path $folderPath
}
    # Create folder
New-Item -Path 'C:\ProgramData' -Name 'App-V' -ItemType 'Directory'
    # Disable inheritance 
$acl = Get-Acl -Path $folderPath
$acl.SetAccessRuleProtection($true, $false)
(Get-Item $folderPath).SetAccessControl($acl)
Clear-Variable -Name 'acl'

$acl = New-Object System.Security.AccessControl.DirectorySecurity
$acl.SetAccessRuleProtection($true, $false)

    # Set correct NTFS permissions and owner
    # SYSTEM
$identity = 'NT AUTHORITY\SYSTEM'
$rights = 'FullControl'
$inheritance = 'ContainerInherit, ObjectInherit'
$propagation = 'None' 
$type = 'Allow' 
$ACE = New-Object System.Security.AccessControl.FileSystemAccessRule($identity,$rights,$inheritance,$propagation,$type)
$acl.SetAccessRule($ACE)
Clear-Variable -Name 'ACE'

    # Administrators
$identity = 'BUILTIN\Administrators'
$rights = 'FullControl'
$inheritance = 'ContainerInherit, ObjectInherit' #Other options: [enum]::GetValues('System.Security.AccessControl.Inheritance')
$propagation = 'None' #Other options: [enum]::GetValues('System.Security.AccessControl.PropagationFlags')
$type = 'Allow' #Other options: [enum]::GetValues('System.Securit y.AccessControl.AccessControlType')
$ACE = New-Object System.Security.AccessControl.FileSystemAccessRule($identity,$rights,$inheritance,$propagation,$type)
$acl.SetAccessRule($ACE)
Clear-Variable -Name 'ACE'

    # TrustedInstaller
$identity = 'NT Service\TrustedInstaller'
$rights = 'FullControl'
$inheritance = 'ContainerInherit, ObjectInherit' #Other options: [enum]::GetValues('System.Security.AccessControl.Inheritance')
$propagation = 'None' #Other options: [enum]::GetValues('System.Security.AccessControl.PropagationFlags')
$type = 'Allow' #Other options: [enum]::GetValues('System.Securit y.AccessControl.AccessControlType')
$ACE = New-Object System.Security.AccessControl.FileSystemAccessRule($identity,$rights,$inheritance,$propagation,$type)
$acl.SetAccessRule($ACE)
Clear-Variable -Name 'ACE'

    # Authenticated Users
$identity = 'Authenticated Users'
$rights = 'Read'
$inheritance = 'ContainerInherit, ObjectInherit' #Other options: [enum]::GetValues('System.Security.AccessControl.Inheritance')
$propagation = 'None' #Other options: [enum]::GetValues('System.Security.AccessControl.PropagationFlags')
$type = 'Allow' #Other options: [enum]::GetValues('System.Securit y.AccessControl.AccessControlType')
$ACE = New-Object System.Security.AccessControl.FileSystemAccessRule($identity,$rights,$inheritance,$propagation,$type)
$acl.SetAccessRule($ACE)
Clear-Variable -Name 'ACE'

(Get-Item $folderPath).SetAccessControl($acl)
