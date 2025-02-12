














 -||-> function GetDefaultClusterProperties
{
     -||-> $orchestratorType = "Kubernetes" <-||- 
     -||-> $location = "East US 2" <-||- 
     -||-> $clusterType = "ACS" <-||- 
     -||-> $description = "Deployed from powershell" <-||- 

     -||-> $containerServiceProps =  -||-> New-Object Microsoft.Azure.Management.MachineLearningCompute.Models.AcsClusterProperties( -||-> $orchestratorType <-||- ) <-||-  <-||- 
     -||-> $cluster =  -||-> New-Object Microsoft.Azure.Management.MachineLearningCompute.Models.OperationalizationCluster `
		-Property @{Location =  -||-> $location <-||- ; ClusterType =  -||-> $clusterType <-||- ; ContainerService =  -||-> $containerServiceProps <-||- ; Description =  -||-> $description <-||- } <-||-  <-||- 

	 -||-> $psCluster =  -||-> New-Object Microsoft.Azure.Commands.MachineLearningCompute.Models.PSOperationalizationCluster( -||-> $cluster <-||- ) <-||-  <-||- 

    return  -||-> $psCluster <-||- 
} <-||- 


 -||-> function GetDefaultLocalClusterProperties
{
     -||-> $location = "East US 2" <-||- 
     -||-> $clusterType = "Local" <-||- 
     -||-> $description = "Deployed from powershell" <-||- 

     -||-> $cluster =  -||-> New-Object Microsoft.Azure.Management.MachineLearningCompute.Models.OperationalizationCluster `
		-Property @{Location =  -||-> $location <-||- ; ClusterType =  -||-> $clusterType <-||- ; Description =  -||-> $description <-||- } <-||-  <-||- 

	 -||-> $psCluster =  -||-> New-Object Microsoft.Azure.Commands.MachineLearningCompute.Models.PSOperationalizationCluster( -||-> $cluster <-||- ) <-||-  <-||- 

    return  -||-> $psCluster <-||- 
} <-||- 


 -||-> function SetupTest([String] $ResourceGroupName, [String] $Location = "East US 2")
{
     -||-> Write-Debug "Create resource group" <-||- 
     -||-> Write-Debug " Resource Group Name : $resourceGroupName" <-||- 
     -||-> New-AzResourceGroup -Name $ResourceGroupName -Location $Location -Force <-||- 
} <-||- 


 -||-> function TeardownTest([String] $ResourceGroupName, [String] $ManagedByResourceGroupName)
{
	 -||-> if ( -||-> !$ManagedByResourceGroupName <-||- )
	{
		 -||-> $ManagedByResourceGroupName =  -||-> GetManagedByResourceGroupName -ResourceGroupName $ResourceGroupName <-||-  <-||- 
	} <-||- 

     -||-> Write-Debug "Delete resource group" <-||- 
     -||-> Write-Debug " Resource Group Name : $ResourceGroupName" <-||- 
     -||-> Remove-AzResourceGroup -Name $ResourceGroupName -Force <-||- 

	 -||-> Write-Debug "Deleting managed by resource group: $ManagedByResourceGroupName" <-||- 
	 -||-> Remove-AzResourceGroup -Name $ManagedByResourceGroupName -Force <-||- 
} <-||- 


 -||-> function GetUniqueName([String] $prefix)
{
	 -||-> $suffix =  -||-> getAssetName <-||-  <-||- 
	return  -||-> "$prefix-$suffix" <-||- 
} <-||- 


 -||-> function GetManagedByResourceGroupName([String] $ResourceGroupName)
{
	 -||-> $cluster =  -||-> Get-AzMlOpCluster -ResourceGroupName $ResourceGroupName <-||-  <-||- 
	 -||-> $success = $cluster.StorageAccount.ResourceId -match "$ResourceGroupName-azureml-\w{5}" <-||- 
	 -||-> $managedByResourceGroupName = $matches[0] <-||- 
	return  -||-> $managedByResourceGroupName <-||- 
} <-||- 


 -||-> function Test-NewGetRemove
{
    
     -||-> $resourceGroupName =  -||-> GetUniqueName( -||-> "mlcrp-cmdlet-test-new" <-||- ) <-||-  <-||- 
     -||-> $clusterName =  -||-> GetUniqueName( -||-> "mlcrp-cmdlet-test-new" <-||- ) <-||-  <-||- 

     -||-> SetupTest $resourceGroupName <-||- 

    
     -||-> $result =  -||-> New-AzMlOpCluster -ResourceGroupName $resourceGroupName -Name $clusterName -Location "East US 2" `
		-ClusterType "ACS" -Description "Powershell test cluster" -OrchestratorType "Kubernetes" `
		-ClientId "00000000-0000-0000-0000-000000000000" -Secret "abcde" `
		-MasterCount 1 -AgentCount 2 -AgentVmSize Standard_D3_v2 <-||-  <-||- 

     -||-> Assert-True {  -||-> $result.ProvisioningState -eq "Succeeded" <-||-  } <-||- 

    
     -||-> $result =  -||-> Get-AzMlOpCluster -ResourceGroupName $resourceGroupName -Name $clusterName <-||-  <-||- 

     -||-> Assert-True {  -||-> $result.ProvisioningState -eq "Succeeded" <-||-  } <-||- 

    
     -||-> $result =  -||-> Get-AzMlOpCluster -ResourceGroupName $resourceGroupName <-||-  <-||- 

     -||-> Assert-NotNull {  -||-> $result <-||-  } <-||- 
     -||-> $clusterExists = $False <-||- 

     -||-> Foreach ($c in  -||-> $result <-||- )
    {
         -||-> If ( -||-> $c.Name -eq $clusterName <-||- )
        {
             -||-> $clusterExists = $True <-||- 
        } <-||- 
    } <-||- 

     -||-> Assert-True {  -||-> $clusterExists <-||-  } <-||- 

    
     -||-> $result =  -||-> Get-AzMlOpCluster <-||-  <-||- 

     -||-> $clusterExists = $False <-||- 

     -||-> Foreach ($c in  -||-> $result <-||- )
    {
         -||-> If ( -||-> $c.Name -eq $clusterName <-||- )
        {
             -||-> $clusterExists = $True <-||- 
        } <-||- 
    } <-||- 

     -||-> Assert-True {  -||-> $clusterExists <-||-  } <-||- 

	
	 -||-> $managedByResourceGroupName =  -||-> GetManagedByResourceGroupName -ResourceGroupName $resourceGroupName <-||-  <-||- 

    
     -||-> Get-AzMlOpCluster -ResourceGroupName $resourceGroupName -Name $clusterName | Remove-AzMlOpCluster <-||- 

     -||-> Assert-ThrowsContains {  -||-> Get-AzMlOpCluster -ResourceGroupName $resourceGroupName -Name $clusterName <-||-  } "NotFound" <-||- 

    
     -||-> TeardownTest -ResourceGroupName $resourceGroupName -ManagedByResourceGroupName $managedByResourceGroupName <-||- 
} <-||- 


 -||-> function Test-GetKeys
{
    
     -||-> $resourceGroupName =  -||-> GetUniqueName( -||-> "mlcrp-cmdlet-test-keys" <-||- ) <-||-  <-||- 
     -||-> $clusterName =  -||-> GetUniqueName( -||-> "mlcrp-cmdlet-test-keys" <-||- ) <-||-  <-||- 

     -||-> SetupTest $resourceGroupName <-||- 

    
     -||-> $cluster =  -||-> GetDefaultClusterProperties <-||-  <-||- 
     -||-> $result =  -||-> New-AzMlOpCluster -ResourceGroupName $resourceGroupName -Name $clusterName -Cluster $cluster <-||-  <-||- 

     -||-> Assert-True {  -||-> $result.ProvisioningState -eq "Succeeded" <-||-  } <-||- 

    
     -||-> $keys =  -||-> Get-AzMlOpClusterKey -ResourceGroupName $resourceGroupName -Name $clusterName <-||-  <-||- 

     -||-> Assert-NotNull {  -||-> $keys.StorageAccount.ResourceId <-||-  } <-||- 
     -||-> Assert-NotNull {  -||-> $keys.StorageAccount.PrimaryKey <-||-  } <-||- 
     -||-> Assert-NotNull {  -||-> $keys.StorageAccount.SecondaryKey <-||-  } <-||- 

     -||-> Assert-NotNull {  -||-> $keys.ContainerRegistry.LoginServer <-||-  } <-||- 
     -||-> Assert-NotNull {  -||-> $keys.ContainerRegistry.Password <-||-  } <-||- 
     -||-> Assert-NotNull {  -||-> $keys.ContainerRegistry.Password2 <-||-  } <-||- 
     -||-> Assert-NotNull {  -||-> $keys.ContainerRegistry.Username <-||-  } <-||- 

     -||-> Assert-NotNull {  -||-> $keys.ContainerService.AcsKubeConfig <-||-  } <-||- 
     -||-> Assert-NotNull {  -||-> $keys.ContainerService.ImagePullSecretName <-||-  } <-||- 

     -||-> Assert-NotNull {  -||-> $keys.AppInsights.AppId <-||-  } <-||- 
     -||-> Assert-NotNull {  -||-> $keys.AppInsights.InstrumentationKey <-||-  } <-||- 

    
     -||-> $keys =  -||-> Get-AzMlOpCluster -ResourceGroupName $resourceGroupName -Name $clusterName | Get-AzMlOpClusterKey <-||-  <-||- 

     -||-> Assert-NotNull {  -||-> $keys.StorageAccount.ResourceId <-||-  } <-||- 
     -||-> Assert-NotNull {  -||-> $keys.StorageAccount.PrimaryKey <-||-  } <-||- 
     -||-> Assert-NotNull {  -||-> $keys.StorageAccount.SecondaryKey <-||-  } <-||- 

     -||-> Assert-NotNull {  -||-> $keys.ContainerRegistry.LoginServer <-||-  } <-||- 
     -||-> Assert-NotNull {  -||-> $keys.ContainerRegistry.Password <-||-  } <-||- 
     -||-> Assert-NotNull {  -||-> $keys.ContainerRegistry.Password2 <-||-  } <-||- 
     -||-> Assert-NotNull {  -||-> $keys.ContainerRegistry.Username <-||-  } <-||- 

     -||-> Assert-NotNull {  -||-> $keys.ContainerService.AcsKubeConfig <-||-  } <-||- 
     -||-> Assert-NotNull {  -||-> $keys.ContainerService.ImagePullSecretName <-||-  } <-||- 

     -||-> Assert-NotNull {  -||-> $keys.AppInsights.AppId <-||-  } <-||- 
     -||-> Assert-NotNull {  -||-> $keys.AppInsights.InstrumentationKey <-||-  } <-||- 

    
     -||-> TeardownTest -ResourceGroupName $resourceGroupName <-||- 
} <-||- 


 -||-> function Test-UpdateSystemServices
{
    
     -||-> $resourceGroupName =  -||-> GetUniqueName( -||-> "mlcrp-cmdlet-test-system-update" <-||- ) <-||-  <-||- 
     -||-> $clusterName =  -||-> GetUniqueName( -||-> "mlcrp-cmdlet-test-system-update" <-||- ) <-||-  <-||- 

     -||-> SetupTest $resourceGroupName <-||- 

    
     -||-> $cluster =  -||-> GetDefaultClusterProperties <-||-  <-||- 
     -||-> $result =  -||-> New-AzMlOpCluster -ResourceGroupName $resourceGroupName -Name $clusterName -Cluster $cluster <-||-  <-||- 

	
	 -||-> $updateAvailability =  -||-> Test-AzMlOpClusterSystemServicesUpdateAvailability -ResourceGroupName $resourceGroupName -Name $clusterName <-||-  <-||- 
     -||-> Assert-NotNull {  -||-> $updateAvailability <-||-  } <-||- 

	
	 -||-> $updateAvailability =  -||-> Get-AzMlOpCluster -ResourceGroupName $resourceGroupName -Name $clusterName | Test-AzMlOpClusterSystemServicesUpdateAvailability <-||-  <-||- 
     -||-> Assert-NotNull {  -||-> $updateAvailability <-||-  } <-||- 

	
	 -||-> $updateResult =  -||-> Update-AzMlOpClusterSystemService -ResourceGroupName $resourceGroupName -Name $clusterName <-||-  <-||- 
     -||-> Assert-True {  -||-> $updateResult.UpdateStatus -eq "Succeeded" <-||-  } <-||- 
	 -||-> Assert-NotNull {  -||-> $updateResult.UpdateStartedOn <-||-  } <-||- 
	 -||-> Assert-NotNull {  -||-> $updateResult.UpdateCompletedOn <-||-  } <-||- 

	 -||-> $updateAvailability =  -||-> Test-AzMlOpClusterSystemServicesUpdateAvailability -ResourceGroupName $resourceGroupName -Name $clusterName <-||-  <-||- 
     -||-> Assert-True {  -||-> $updateAvailability.UpdatesAvailable -eq "No" <-||-  } <-||- 

    
     -||-> TeardownTest -ResourceGroupName $resourceGroupName <-||- 
} <-||- 


 -||-> function Test-Set
{
    
     -||-> $resourceGroupName =  -||-> GetUniqueName( -||-> "mlcrp-cmdlet-test-set" <-||- ) <-||-  <-||- 
     -||-> $clusterName =  -||-> GetUniqueName( -||-> "mlcrp-cmdlet-test-set" <-||- ) <-||-  <-||- 

     -||-> SetupTest $resourceGroupName <-||- 

    
     -||-> $cluster =  -||-> GetDefaultClusterProperties <-||-  <-||- 
     -||-> $createdCluster =  -||-> New-AzMlOpCluster -ResourceGroupName $resourceGroupName -Name $clusterName -Cluster $cluster <-||-  <-||- 

	
	 -||-> $newAgentCount = $createdCluster.ContainerService.AgentCount + 1 <-||- 
	 -||-> $updatedCluster =  -||-> Set-AzMlOpCluster -ResourceGroupName $resourceGroupName -Name $clusterName -AgentCount $newAgentCount <-||-  <-||- 
     -||-> Assert-True {  -||-> $updatedCluster.ProvisioningState -eq "Succeeded" <-||-  } <-||- 
	 -||-> Assert-True {  -||-> $updatedCluster.ContainerService.AgentCount -eq $newAgentCount <-||-  } <-||- 

	
	 -||-> $newAgentCount = $newAgentCount - 1 <-||- 
	 -||-> $updatedCluster.ContainerService.AgentCount = $newAgentCount <-||- 
	 -||-> $updatedCluster =  -||-> Set-AzMlOpCluster -InputObject $updatedCluster <-||-  <-||- 
     -||-> Assert-True {  -||-> $updatedCluster.ProvisioningState -eq "Succeeded" <-||-  } <-||- 
	 -||-> Assert-True {  -||-> $updatedCluster.ContainerService.AgentCount -eq $newAgentCount <-||-  } <-||- 

	
	 -||-> $newAgentCount = $newAgentCount + 1 <-||- 
	 -||-> $updatedCluster =  -||-> Set-AzMlOpCluster -ResourceId $updatedCluster.Id -AgentCount $newAgentCount <-||-  <-||- 
     -||-> Assert-True {  -||-> $updatedCluster.ProvisioningState -eq "Succeeded" <-||-  } <-||- 
	 -||-> Assert-True {  -||-> $updatedCluster.ContainerService.AgentCount -eq $newAgentCount <-||-  } <-||- 

    
     -||-> TeardownTest -ResourceGroupName $resourceGroupName <-||- 
} <-||- 

 -||-> function Test-RemoveIncludeAllResources
{
     -||-> $resourceGroupName =  -||-> GetUniqueName( -||-> "mlcrp-cmdlet-test-remove-all" <-||- ) <-||-  <-||- 
     -||-> $clusterName =  -||-> GetUniqueName( -||-> "mlcrp-cmdlet-test-remove-all" <-||- ) <-||-  <-||- 

     -||-> SetupTest $resourceGroupName <-||- 

    
     -||-> $cluster =  -||-> GetDefaultLocalClusterProperties <-||-  <-||- 
     -||-> $createdCluster =  -||-> New-AzMlOpCluster -ResourceGroupName $resourceGroupName -Name $clusterName -Cluster $cluster <-||-  <-||- 

	
	 -||-> $managedByResourceGroupName =  -||-> GetManagedByResourceGroupName -ResourceGroupName $resourceGroupName <-||-  <-||- 

	
	 -||-> Remove-AzMlOpCluster -ResourceGroupName $resourceGroupName -Name $clusterName -IncludeAllResources <-||- 

     -||-> Assert-Throws (  -||-> Get-AzResourceGroup -ResourceGroupName $managedByResourceGroupName <-||-  ) <-||- 

    
	 -||-> Remove-AzResourceGroup -ResourceGroupName $resourceGroupName -Force <-||- 
} <-||- 


