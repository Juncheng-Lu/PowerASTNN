















 -||-> function NetworkRuleSetTests
{
    

	 -||-> $location =  -||-> Get-Location <-||-  <-||- 
	 -||-> $resourceGroupName =  -||-> getAssetName "RSG" <-||-  <-||- 
	 -||-> $namespaceName =  -||-> getAssetName "Eventhub-Namespace-" <-||-  <-||- 
	 -||-> $namespaceName2  =  -||-> getAssetName "Eventhub-Namespace2-" <-||-  <-||- 	
	
     -||-> Write-Debug "Create resource group" <-||- 
	 -||-> Write-Debug "ResourceGroup name : $resourceGroupName" <-||- 
	 -||-> New-AzResourceGroup -Name $resourceGroupName -Location $location -Force <-||- 	 
	
	

	 -||-> $checkNameResult =  -||-> Test-AzEventHubName -Namespace $namespaceName <-||-  <-||-  
	 -||-> Assert-True { -||-> $checkNameResult.NameAvailable <-||- } <-||- 	
     
     -||-> Write-Debug " Create new eventHub namespace" <-||- 
     -||-> Write-Debug "NamespaceName : $namespaceName" <-||-  
     -||-> $result =  -||-> New-AzEventHubNamespace -ResourceGroup $resourceGroupName -Name $namespaceName -Location $location -SkuName "Standard" <-||-  <-||- 
	
	
	 -||-> Assert-AreEqual $result.ProvisioningState "Succeeded" <-||- 

     -||-> Write-Debug "Get the created namespace within the resource group" <-||- 
     -||-> $createdNamespace =  -||-> Get-AzEventHubNamespace -ResourceGroup $resourceGroupName -Name $namespaceName <-||-  <-||- 

     -||-> Assert-AreEqual $createdNamespace.Name $namespaceName "Namespace created earlier is not found." <-||- 	  

	 -||-> Write-Debug " Create new eventHub namespace" <-||- 
     -||-> Write-Debug "NamespaceName : $namespaceName2" <-||-  
     -||-> $resultNS =  -||-> New-AzEventHubNamespace -ResourceGroup $resourceGroupName -Name $namespaceName2 -Location $location -SkuName "Standard" <-||-  <-||- 
	
	
	 -||-> Assert-AreEqual $resultNS.ProvisioningState "Succeeded" <-||- 

     -||-> Write-Debug "Get the created namespace within the resource group" <-||- 
     -||-> $createdNamespace2 =  -||-> Get-AzEventHubNamespace -ResourceGroup $resourceGroupName -Name $namespaceName2 <-||-  <-||- 
     -||-> Assert-AreEqual $createdNamespace2.Name $namespaceName2 "Namespace created earlier is not found." <-||- 	 
    
     -||-> Write-Debug "Add a new IPRule to the default NetworkRuleSet" <-||- 
     -||-> $result =   -||-> Add-AzEventHubIPRule -ResourceGroup $resourceGroupName -Name $namespaceName -IpMask "1.1.1.1" -Action "Allow" <-||-  <-||- 

	 -||-> Write-Debug "Add a new IPRule to the default NetworkRuleSet" <-||- 
     -||-> $result =   -||-> Add-AzEventHubIPRule -ResourceGroup $resourceGroupName -Name $namespaceName -IpMask "2.2.2.2" -Action "Allow" <-||-  <-||- 

	 -||-> Write-Debug "Add a new IPRule to the default NetworkRuleSet" <-||- 
     -||-> $result =   -||-> Add-AzEventHubIPRule -ResourceGroup $resourceGroupName -Name $namespaceName -IpMask "3.3.3.3" <-||-  <-||- 

	 -||-> Write-Debug "Add a new VirtualNetworkRule to the default NetworkRuleSet" <-||- 
     -||-> $result =   -||-> Add-AzEventHubVirtualNetworkRule -ResourceGroup $resourceGroupName -Name $namespaceName -SubnetId "/subscriptions/854d368f-1828-428f-8f3c-f2affa9b2f7d/resourcegroups/v-ajnavtest/providers/Microsoft.Network/virtualNetworks/sbehvnettest1/subnets/default" <-||-  <-||- 
	 -||-> $result =   -||-> Add-AzEventHubVirtualNetworkRule -ResourceGroup $resourceGroupName -Name $namespaceName -SubnetId "/subscriptions/854d368f-1828-428f-8f3c-f2affa9b2f7d/resourcegroups/v-ajnavtest/providers/Microsoft.Network/virtualNetworks/sbehvnettest1/subnets/sbdefault" <-||-  <-||- 
	 -||-> $result =   -||-> Add-AzEventHubVirtualNetworkRule -ResourceGroup $resourceGroupName -Name $namespaceName -SubnetId "/subscriptions/854d368f-1828-428f-8f3c-f2affa9b2f7d/resourcegroups/v-ajnavtest/providers/Microsoft.Network/virtualNetworks/sbehvnettest1/subnets/sbdefault01" <-||-  <-||- 

	 -||-> Write-Debug "Get NetworkRuleSet" <-||- 
	 -||-> $getResult1 =  -||-> Get-AzEventHubNetworkRuleSet -ResourceGroup $resourceGroupName -Name $namespaceName <-||-  <-||- 
	
	 -||-> Assert-AreEqual $getResult1.VirtualNetworkRules.Count 3 "VirtualNetworkRules count did not matched" <-||- 
	 -||-> Assert-AreEqual $getResult1.IpRules.Count 3 "IPRules count did not matched" <-||- 

	 -||-> Write-Debug "Remove a new IPRule to the default NetworkRuleSet" <-||- 
     -||-> $result =   -||-> Remove-AzEventHubIPRule -ResourceGroup $resourceGroupName -Name $namespaceName -IpMask "3.3.3.3" <-||-  <-||- 	

	 -||-> $getResult =  -||-> Get-AzEventHubNetworkRuleSet -ResourceGroup $resourceGroupName -Name $namespaceName <-||-  <-||- 

	 -||-> Assert-AreEqual $getResult.IpRules.Count 2 "IPRules count did not matched after deleting one IPRule" <-||- 
	 -||-> Assert-AreEqual $getResult.VirtualNetworkRules.Count 3 "VirtualNetworkRules count did not matched" <-||- 

	
	 -||-> $setResult =   -||-> Set-AzEventHubNetworkRuleSet -ResourceGroup $resourceGroupName -Name $namespaceName2 -InputObject $getResult1 <-||-  <-||- 
	 -||-> Assert-AreEqual $setResult.VirtualNetworkRules.Count 3 "Set -VirtualNetworkRules count did not matched" <-||- 
	 -||-> Assert-AreEqual $setResult.IpRules.Count 3 "Set - IPRules count did not matched" <-||- 

	
	 -||-> $setResult1 =   -||-> Set-AzEventHubNetworkRuleSet -ResourceGroup $resourceGroupName -Name $namespaceName2 -ResourceId $getResult.Id <-||-  <-||- 
	 -||-> Assert-AreEqual $setResult1.IpRules.Count 2 "Set1 - IPRules count did not matched after deleting one IPRule" <-||- 
	 -||-> Assert-AreEqual $setResult1.VirtualNetworkRules.Count 3 "Set1 - VirtualNetworkRules count did not matched" <-||- 

	 -||-> Write-Debug "Add a new VirtualNetworkRule to the default NetworkRuleSet" <-||- 
     -||-> $result =   -||-> Remove-AzEventHubVirtualNetworkRule -ResourceGroup $resourceGroupName -Name $namespaceName -SubnetId "/subscriptions/854d368f-1828-428f-8f3c-f2affa9b2f7d/resourcegroups/v-ajnavtest/providers/Microsoft.Network/virtualNetworks/sbehvnettest1/subnets/default" <-||-  <-||- 
	
	 -||-> Write-Debug "Delete NetworkRuleSet" <-||- 
     -||-> $result =   -||-> Remove-AzEventHubNetworkRuleSet -ResourceGroup $resourceGroupName -Name $namespaceName <-||-  <-||-    

     -||-> Write-Debug " Delete namespaces" <-||-     
     -||-> Remove-AzEventHubNamespace -ResourceGroup $resourceGroupName -Name $namespaceName <-||- 

	 -||-> Write-Debug " Delete resourcegroup" <-||- 
	 -||-> Remove-AzResourceGroup -Name $resourceGroupName -Force <-||- 
} <-||- 

