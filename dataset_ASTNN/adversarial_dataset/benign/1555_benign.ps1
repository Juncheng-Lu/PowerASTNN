
[CmdletBinding(DefaultParameterSetName = 'name')]
[OutputType('System.Management.Automation.PSCustomObject')]
param (
	[Parameter(ParameterSetName = 'name',
		Mandatory,
		ValueFromPipeline,
		ValueFromPipelineByPropertyName)]
	[ValidateSet("Tom","Dick","Jane")]
	[ValidateRange(21,65)]
	[ValidateScript({ -||-> Test-Path $_ -PathType 'Container' <-||- })] 
	[ValidateNotNullOrEmpty()]
	[ValidateCount(1,5)]
	[ValidateLength(1,10)]
	[ValidatePattern()]
	[string]$Computername = 'DEFAULTVALUE'
)

begin {
	 -||-> $ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop <-||- 
	 -||-> Set-StrictMode -Version Latest <-||- 
	 -||-> try {
		
	} catch {
		 -||-> Write-Error $_.Exception.Message <-||- 
	} <-||- 
}

process {
	 -||-> try {
		
	} catch {
		 -||-> Write-Error $_.Exception.Message <-||- 	
	} <-||- 
}

end {
	 -||-> try {
		
	} catch {
		 -||-> Write-Error $_.Exception.Message <-||- 
	} <-||- 
}

