



param (
	[Parameter(Mandatory)]
	[ValidateNotNullOrEmpty()]
	[string]$ApplicationName,

	[Parameter(Mandatory)]
	[ValidateNotNullOrEmpty()]
	[string]$Description,

	[Parameter(Mandatory)]
	[ValidateNotNullOrEmpty()]
	[string]$EnvironmentType,

	[Parameter(Mandatory)]
	[ValidateNotNullOrEmpty()]
	[string[]]$EnvironmentName,

	[Parameter()]
	[ValidateNotNullOrEmpty()]
	[int]$WaitForEnvironmentCreation = 10 
)

 -||-> if ( -||-> -not ( -||-> $ebApp =  -||-> Get-EBApplication -ApplicationName $ApplicationName <-||-  <-||- ) <-||- ) {
	 -||-> $ebApp =  -||-> New-EBApplication -ApplicationName $ApplicationName -Description $Description <-||-  <-||- 
} else {
	 -||-> Write-Verbose -Message "The BeanStalk application [$( -||-> $ApplicationName <-||- )] already exists." <-||- 
} <-||- 

 -||-> $params = @{
	ApplicationName =  -||-> $ApplicationName <-||- 
} <-||- 
 -||-> $EnvironmentName | Where-Object {  -||-> $_ -notin ( -||-> Get-EBEnvironment -ApplicationName $ApplicationName | Select-Object -ExpandProperty EnvironmentName <-||- ) <-||-  } | ForEach-Object {
	 -||-> $null =  -||-> New-EBEnvironment @params -EnvironmentName $_ -SolutionStackName $EnvironmentType <-||-  <-||- 
} <-||- 

 -||-> $stopwatch = [system.diagnostics.stopwatch]::StartNew() <-||- 
 -||-> while ( -||-> ( -||-> $stopwatch.Elapsed.TotalMinutes -lt $WaitForEnvironmentCreation <-||- ) -and ( -||-> Get-EBEnvironment -ApplicationName MyAWSApp -EnvironmentName $EnvironmentName <-||- ).where({  -||-> $_.Health -ne 'Green' <-||- }) <-||- ) {
	 -||-> Write-Host 'Waiting for environments to be created...' <-||- 
	 -||-> Start-Sleep -Seconds 60 <-||- 
} <-||- 
 -||-> if ( -||-> $stopWatch.Elapsed.TotalMinutes -gt $WaitForEnvironmentCreation <-||- ) {
	 -||-> Write-Error -Message 'The environment creation process timed out.' <-||- 
} else {
	 -||-> Write-Verbose -Message 'Envrionment creation successful!' <-||- 
} <-||- 
 -||-> $stopwatch.Stop() <-||- 

