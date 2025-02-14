 -||-> $script:monitorServer = 'SRV1' <-||- 

 -||-> function New-AdGroupMembershipMonitor {
	[OutputType('pscustomobject')]
	[CmdletBinding(SupportsShouldProcess)]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$GroupName,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[scriptblock]$Action,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[pscustomobject]$Schedule,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$Name = ( -||-> "AD Group $GroupName Monitor" -replace ' ', '_' <-||- )
	)

	 -||-> $ErrorActionPreference = 'Stop' <-||- 

	 -||-> $monitor = @'

$monitorStateFilePath = 'C:\ADGroupMembers.csv'


$previousMembers = $null
$previousMembers = Import-Csv -Path $monitorStateFilePath | Sort-Object -Property {[datetime]$_.Time} -Descending | Select-Object -First 1 | Select-Object -ExpandProperty Members


$previousMembers = $previousMembers -split ','


$currentMembers = Get-AdGroupMember -Identity '|GroupName|' | Select-Object -ExpandProperty name


$now = Get-Date -UFormat '%m-%d-%y %H:%M'
[pscustomobject]@{
	'Time'    = $now
	'Members' = $currentMembers -join ','
} | Export-Csv -Path $monitorStateFilePath -NoTypeInformation -Append


if (Compare-Object -ReferenceObject $previousMembers -DifferenceObject $currentMembers) {
	|Action|
}
'@ <-||- 
	 -||-> $monitor = $monitor -replace '\|Action\|', $Action.ToString() -replace '\|GroupName\|', $GroupName <-||- 
	 -||-> $monitor = [scriptblock]::Create($monitor) <-||- 

	 -||-> $params = @{
		Name         =  -||-> $Name <-||- 
		Scriptblock  =  -||-> $monitor <-||- 
		Interval     =  -||-> $Schedule.Interval <-||- 
		Time         =  -||-> $Schedule.Time <-||- 
		ComputerName =  -||-> $script:monitorServer <-||- 
	} <-||- 
	 -||-> if ( -||-> $Schedule.DayOfWeek <-||- ) {
		 -||-> $params.DayOfWeek = $Schedule.DayOfWeek <-||- 
	} <-||- 
	 -||-> New-RecurringScheduledTask @params <-||- 
	
} <-||- 

 -||-> function New-RecurringScheduledTask {
	[OutputType([void])]
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$ComputerName,

		[Parameter(Mandatory)]
		[string]$Name,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[scriptblock]$Scriptblock,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[ValidateSet('Daily', 'Weekly')] 
		[string]$Interval,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$Time,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[ValidateSet('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')]
		[string]$DayOfWeek,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[pscredential]$RunAsCredential
	)

	 -||-> $createStartSb = {
		param($taskName, $command, $interval, $time, $taskUser)

		
		 -||-> $scheduledTaskScriptFolder = 'C:\ScheduledTaskScripts' <-||- 
		 -||-> if ( -||-> -not ( -||-> Test-Path -Path $scheduledTaskScriptFolder -PathType Container <-||- ) <-||- ) {
			 -||-> $null =  -||-> New-Item -Path $scheduledTaskScriptFolder -ItemType Directory <-||-  <-||- 
		} <-||- 
		 -||-> $scriptPath = "$scheduledTaskScriptFolder\$taskName.ps1" <-||- 
		 -||-> Set-Content -Path $scriptPath -Value $command <-||- 

		
		 -||-> schtasks /create /SC $interval /ST $time /TN $taskName /TR "powershell.exe -NonInteractive -NoProfile -File `"$scriptPath`"" /F /RU $taskUser /RL HIGHEST <-||- 
	} <-||- 

	 -||-> $icmParams = @{
		ComputerName =  -||-> $ComputerName <-||- 
		ScriptBlock  =  -||-> $createStartSb <-||- 
		ArgumentList =  -||-> $Name, $Scriptblock.ToString(), $Interval, $Time <-||- 
	} <-||- 
	 -||-> if ( -||-> $PSBoundParameters.ContainsKey('Credential') <-||- ) {
		 -||-> $icmParams.ArgumentList += $RunAsCredential.UserName <-||- 	
	} else {
		 -||-> $icmParams.ArgumentList += 'SYSTEM' <-||- 
	} <-||- 
	 -||-> Invoke-Command @icmParams <-||- 
	
} <-||- 

 -||-> function Get-MonitorSchedule {
	[OutputType('pscustomobject')]
	[CmdletBinding(SupportsShouldProcess)]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[ValidateSet('Daily', 'Weekly')]
		[string]$Interval,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$Time,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[ValidateSet('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')]
		[string]$DayOfWeek
	)

	 -||-> $ErrorActionPreference = 'Stop' <-||- 

	 -||-> [pscustomobject]@{
		Interval  =  -||-> $Interval <-||- 
		Time      =  -||-> $Time <-||- 
		DayOfWeek =  -||-> $DayOfWeek <-||- 
	} <-||- 
	
} <-||- 

