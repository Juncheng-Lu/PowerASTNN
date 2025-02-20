 -||-> function Import-PSFClixml
{

	[CmdletBinding(HelpUri = 'https://psframework.org/documentation/commands/PSFramework/Import-PSFClixml')]
	Param (
		[Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[Alias('FullName')]
		[string[]]
		$Path,
		
		[PSFEncoding]
		$Encoding = ( -||-> Get-PSFConfigValue -FullName 'psframework.text.encoding.defaultread' -Fallback 'utf-8' <-||- )
	)
	
	begin
	{
		 -||-> Write-PSFMessage -Level InternalComment -Message "Bound parameters: $( -||-> $PSBoundParameters.Keys -join ", " <-||- )" -Tag 'debug', 'start', 'param' <-||- 
	}
	process
	{
		 -||-> try {  -||-> $resolvedPath =  -||-> Resolve-PSFPath -Path $Path -Provider FileSystem <-||-  <-||-  }
		catch {  -||-> Stop-PSFFunction -Message "Failed to resolve path." -ErrorRecord $_ -EnableException $true -Cmdlet $PSCmdlet -Target $Path <-||-  } <-||- 
		
		 -||-> foreach ($pathItem in  -||-> $resolvedPath <-||- )
		{
			 -||-> if ( -||-> ( -||-> Get-Item $pathItem <-||- ).PSIsContainer <-||- )
			{
				 -||-> Stop-PSFFunction -Message "$pathItem is not a file" -EnableException $true -Target $pathItem <-||- 
			} <-||- 
			 -||-> Write-PSFMessage -Level Verbose -Message "Processing $( -||-> $pathItem <-||- )" -Target $pathItem <-||- 
			
			 -||-> [byte[]]$bytes = [System.IO.File]::ReadAllBytes($pathItem) <-||- 
				
			 -||-> try {  -||-> [PSFramework.Serialization.ClixmlSerializer]::FromByteCompressed($bytes) <-||-  }
			catch
			{
				 -||-> [string]$string = [System.IO.File]::ReadAllText($pathItem, $Encoding) <-||- 
				 -||-> try {  -||-> [PSFramework.Serialization.ClixmlSerializer]::FromString($string) <-||-  }
				catch
				{
					 -||-> try {  -||-> [PSFramework.Serialization.ClixmlSerializer]::FromStringCompressed($string) <-||-  }
					catch
					{
						 -||-> try {  -||-> [PSFramework.Serialization.ClixmlSerializer]::FromByte($bytes) <-||-  }
						catch
						{
							 -||-> Stop-PSFFunction -Message "Failed to convert input object" -EnableException $true -Target $pathItem -Cmdlet $PSCmdlet <-||- 
						} <-||- 
					} <-||- 
				} <-||- 
				
			} <-||- 
		} <-||- 
	}
} <-||- 

