













		

 -||-> function ServiceBusTests {
    
     -||-> $location =  -||-> Get-Location <-||-  <-||- 
     -||-> $resourceGroupName =  -||-> getAssetName "RGName-" <-||-  <-||- 
     -||-> $namespaceName =  -||-> getAssetName "Namespace1-" <-||-  <-||- 
     -||-> $namespaceName2 =  -||-> getAssetName "Namespace2-" <-||-  <-||- 
 
     -||-> Write-Debug "Create resource group" <-||-     
     -||-> New-AzResourceGroup -Name $resourceGroupName -Location $location -Force <-||-  
     
    
     -||-> $checkNameResult =  -||-> Test-AzServiceBusName -NamespaceName $namespaceName <-||-  <-||-  
     -||-> Assert-True {  -||-> $checkNameResult.NameAvailable <-||-  } <-||- 

     -||-> Write-Debug " Create new eventHub namespace" <-||- 
     -||-> Write-Debug "NamespaceName : $namespaceName" <-||- 
     -||-> $result =  -||-> New-AzServiceBusNamespace -ResourceGroupName $resourceGroupName -Location $location  -Name $namespaceName -SkuName "Standard" <-||-  <-||- 
    
     -||-> Assert-AreEqual $result.Name $namespaceName <-||- 
     -||-> Assert-AreEqual $result.ProvisioningState "Succeeded" <-||- 
     -||-> Assert-AreEqual $result.ResourceGroup $resourceGroupName "Namespace create : ResourceGroup name matches" <-||- 
     -||-> Assert-AreEqual $result.ResourceGroupName $resourceGroupName "Namespace create : ResourceGroupName name matches" <-||- 

     -||-> Write-Debug "Get the created namespace within the resource group" <-||- 
     -||-> $getNamespace =  -||-> Get-AzServiceBusNamespace -ResourceGroupName $resourceGroupName -Name $namespaceName <-||-  <-||- 
     -||-> Assert-AreEqual $getNamespace.Name $namespaceName "Get-ServicebusName- created namespace not found" <-||- 
     -||-> Assert-AreEqual $getNamespace.ResourceGroup $resourceGroupName "Namespace get : ResourceGroup name matches" <-||- 
     -||-> Assert-AreEqual $getNamespace.ResourceGroupName $resourceGroupName "Namespace get : ResourceGroupName name matches" <-||- 
    
     -||-> $UpdatedNameSpace =  -||-> Set-AzServiceBusNamespace -ResourceGroupName $resourceGroupName -Location $location -Name $namespaceName -SkuName "Standard" -SkuCapacity 2 <-||-  <-||- 
     -||-> Assert-AreEqual $UpdatedNameSpace.Name $namespaceName <-||- 

     -||-> Write-Debug "Namespace name : $namespaceName2" <-||- 
     -||-> $result =  -||-> New-AzServiceBusNamespace -ResourceGroupName $resourceGroupName -Location $location -Name $namespaceName2 <-||-  <-||- 

     -||-> Write-Debug "Get all the namespaces created in the resourceGroup" <-||- 
     -||-> $allCreatedNamespace =  -||-> Get-AzServiceBusNamespace -ResourceGroupName $resourceGroupName <-||-  <-||- 
     -||-> Assert-True {  -||-> $allCreatedNamespace.Count -gt 1 <-||-  } <-||- 
	
     -||-> Write-Debug "Get all the namespaces created in the subscription" <-||- 
     -||-> $allCreatedNamespace =  -||-> Get-AzServiceBusNamespace <-||-  <-||- 
     -||-> Assert-True {  -||-> $allCreatedNamespace.Count -gt 1 <-||-  } <-||- 

     -||-> Write-Debug " Delete namespaces" <-||- 
     -||-> Remove-AzServiceBusNamespace -ResourceGroupName $resourceGroupName -Name $namespaceName2 <-||- 
     -||-> Remove-AzServiceBusNamespace -ResourceGroupName $resourceGroupName -Name $namespaceName <-||- 

     -||-> Write-Debug " Delete resourcegroup" <-||- 
     -||-> Remove-AzResourceGroup -Name $resourceGroupName -Force <-||- 
} <-||- 


 -||-> function ServiceBusNameSpaceAuthTests {
    
     -||-> $location =  -||-> Get-Location <-||-  <-||- 
     -||-> $resourceGroupName =  -||-> getAssetName "RGName-" <-||-  <-||- 
     -||-> $namespaceName =  -||-> getAssetName "Namespace-" <-||-  <-||- 
     -||-> $authRuleName =  -||-> getAssetName "authorule-" <-||-  <-||- 
     -||-> $authRuleNameListen =  -||-> getAssetName "authorule-" <-||-  <-||- 
     -||-> $authRuleNameSend =  -||-> getAssetName "authorule-" <-||-  <-||- 
     -||-> $authRuleNameAll =  -||-> getAssetName "authorule-" <-||-  <-||- 
     -||-> $defaultNamespaceAuthRule = "RootManageSharedAccessKey" <-||- 
	
     -||-> Write-Debug " Create resource group" <-||-     
     -||-> Write-Debug "ResourceGroup name : $resourceGroupName" <-||- 
     -||-> New-AzResourceGroup -Name $resourceGroupName -Location $location -Force <-||-     
    
     -||-> Write-Debug " Create new ServiceBus namespace" <-||- 
     -||-> Write-Debug "Namespace name : $namespaceName" <-||- 	
     -||-> $result =  -||-> New-AzServiceBusNamespace -ResourceGroupName $resourceGroupName -Location $location -Name $namespaceName <-||-  <-||- 
        
     -||-> Write-Debug " Get the created namespace within the resource group" <-||- 
     -||-> $createdNamespace =  -||-> Get-AzServiceBusNamespace -ResourceGroupName $resourceGroupName -Name $namespaceName <-||-  <-||- 
     -||-> Assert-AreEqual $createdNamespace.Name $namespaceName <-||- 

     -||-> Write-Debug "Create a Namespace Authorization Rule" <-||-     
     -||-> Write-Debug "Auth Rule name : $authRuleName" <-||- 
     -||-> $result =  -||-> New-AzServiceBusAuthorizationRule -ResourceGroupName $resourceGroupName -Namespace $namespaceName -Name $authRuleName -Rights @( -||-> "Listen", "Send" <-||- ) <-||-  <-||- 
	
     -||-> Assert-AreEqual $authRuleName $result.Name <-||- 
     -||-> Assert-AreEqual 2 $result.Rights.Count <-||- 
     -||-> Assert-True {  -||-> $result.Rights -Contains "Listen" <-||-  } <-||- 
     -||-> Assert-True {  -||-> $result.Rights -Contains "Send" <-||-  } <-||- 

     -||-> $resultListen =  -||-> New-AzServiceBusAuthorizationRule -ResourceGroupName $resourceGroupName -Namespace $namespaceName -Name $authRuleNameListen -Rights @( -||-> "Listen" <-||- ) <-||-  <-||- 
     -||-> Assert-AreEqual $authRuleNameListen $resultListen.Name <-||- 
     -||-> Assert-AreEqual 1 $resultListen.Rights.Count <-||- 
     -||-> Assert-True {  -||-> $resultListen.Rights -Contains "Listen" <-||-  } <-||- 

     -||-> $resultSend =  -||-> New-AzServiceBusAuthorizationRule -ResourceGroupName $resourceGroupName -Namespace $namespaceName -Name $authRuleNameSend -Rights @( -||-> "Send" <-||- ) <-||-  <-||- 
     -||-> Assert-AreEqual $authRuleNameSend $resultSend.Name <-||- 
     -||-> Assert-AreEqual 1 $resultSend.Rights.Count <-||- 
     -||-> Assert-True {  -||-> $resultSend.Rights -Contains "Send" <-||-  } <-||- 

     -||-> $resultAll3 =  -||-> New-AzServiceBusAuthorizationRule -ResourceGroupName $resourceGroupName -Namespace $namespaceName -Name $authRuleNameAll -Rights @( -||-> "Listen", "Send", "Manage" <-||- ) <-||-  <-||- 
     -||-> Assert-AreEqual $authRuleNameAll $resultAll3.Name <-||- 
     -||-> Assert-AreEqual 3 $resultAll3.Rights.Count <-||- 
     -||-> Assert-True {  -||-> $resultAll3.Rights -Contains "Send" <-||-  } <-||- 
     -||-> Assert-True {  -||-> $resultAll3.Rights -Contains "Listen" <-||-  } <-||- 
     -||-> Assert-True {  -||-> $resultAll3.Rights -Contains "Manage" <-||-  } <-||- 

     -||-> Write-Debug "Create a Namespace Authorization Rule" <-||-     
     -||-> Write-Debug "Auth Rule name : $authRuleName" <-||- 
     -||-> $result =  -||-> New-AzServiceBusAuthorizationRule -ResourceGroupName $resourceGroupName -Namespace $namespaceName -Name $authRuleName -Rights @( -||-> "Listen", "Send" <-||- ) <-||-  <-||- 
	
     -||-> Assert-AreEqual $authRuleName $result.Name <-||- 
     -||-> Assert-AreEqual 2 $result.Rights.Count <-||- 
     -||-> Assert-True {  -||-> $result.Rights -Contains "Listen" <-||-  } <-||- 
     -||-> Assert-True {  -||-> $result.Rights -Contains "Send" <-||-  } <-||- 

     -||-> Write-Debug "Get created authorizationRule" <-||- 
     -||-> $createdAuthRule =  -||-> Get-AzServiceBusAuthorizationRule -ResourceGroupName $resourceGroupName -Namespace $namespaceName -Name $authRuleName <-||-  <-||- 

     -||-> Assert-AreEqual $authRuleName $createdAuthRule.Name <-||- 
     -||-> Assert-AreEqual 2 $createdAuthRule.Rights.Count <-||- 
     -||-> Assert-True {  -||-> $createdAuthRule.Rights -Contains "Listen" <-||-  } <-||- 
     -||-> Assert-True {  -||-> $createdAuthRule.Rights -Contains "Send" <-||-  } <-||- 

     -||-> Write-Debug "Get the default Namespace AuthorizationRule" <-||-    
     -||-> $result =  -||-> Get-AzServiceBusAuthorizationRule -ResourceGroupName $resourceGroupName -Namespace $namespaceName -Name $defaultNamespaceAuthRule <-||-  <-||- 

     -||-> Assert-AreEqual $defaultNamespaceAuthRule $result.Name <-||- 
     -||-> Assert-AreEqual 3 $result.Rights.Count <-||- 
     -||-> Assert-True {  -||-> $result.Rights -Contains "Listen" <-||-  } <-||- 
     -||-> Assert-True {  -||-> $result.Rights -Contains "Send" <-||-  } <-||- 
     -||-> Assert-True {  -||-> $result.Rights -Contains "Manage" <-||-  } <-||- 

     -||-> Write-Debug "Get All Namespace AuthorizationRule" <-||- 
     -||-> $result =  -||-> Get-AzServiceBusAuthorizationRule -ResourceGroupName $resourceGroupName -Namespace $namespaceName <-||-  <-||- 

     -||-> $found = 0 <-||- 
    for ( -||-> $i = 0 <-||- ;  -||-> $i -lt $result.Count <-||- ;  -||-> $i++ <-||- ) {
         -||-> if ( -||-> $result[$i].Name -eq $authRuleName <-||- ) {
             -||-> $found = $found + 1 <-||- 
             -||-> Assert-AreEqual 2 $result[$i].Rights.Count <-||- 
             -||-> Assert-True {  -||-> $result[$i].Rights -Contains "Listen" <-||-  } <-||- 
             -||-> Assert-True {  -||-> $result[$i].Rights -Contains "Send" <-||-  } <-||-                       
        } <-||- 

         -||-> if ( -||-> $result[$i].Name -eq $defaultNamespaceAuthRule <-||- ) {
             -||-> $found = $found + 1 <-||- 
             -||-> Assert-AreEqual 3 $result[$i].Rights.Count <-||- 
             -||-> Assert-True {  -||-> $result[$i].Rights -Contains "Listen" <-||-  } <-||- 
             -||-> Assert-True {  -||-> $result[$i].Rights -Contains "Send" <-||-  } <-||- 
             -||-> Assert-True {  -||-> $result[$i].Rights -Contains "Manage" <-||-  } <-||-          
        } <-||- 
    }

     -||-> Assert-AreEqual $found 2 "All Authorizationrules: Namespace AuthorizationRules created earlier is not found." <-||- 
		
     -||-> Write-Debug "Update Namespace AuthorizationRules ListKeys" <-||- 
    
     -||-> $createdAuthRule.Rights.Add("Manage") <-||- 

     -||-> $updatedAuthRule =  -||-> Set-AzServiceBusAuthorizationRule -ResourceGroupName $resourceGroupName -Namespace $namespaceName -InputObject $createdAuthRule -Name $authRuleName <-||-  <-||- 
    
     -||-> Assert-AreEqual $authRuleName $updatedAuthRule.Name <-||- 
     -||-> Assert-AreEqual 3 $updatedAuthRule.Rights.Count <-||- 
     -||-> Assert-True {  -||-> $updatedAuthRule.Rights -Contains "Listen" <-||-  } <-||- 
     -||-> Assert-True {  -||-> $updatedAuthRule.Rights -Contains "Send" <-||-  } <-||- 
     -||-> Assert-True {  -||-> $updatedAuthRule.Rights -Contains "Manage" <-||-  } <-||-     
    
     -||-> Write-Debug "Get updated Namespace AuthorizationRules" <-||- 
     -||-> $updatedAuthRule =  -||-> Get-AzServiceBusAuthorizationRule -ResourceGroupName $resourceGroupName -Namespace $namespaceName -Name $authRuleName <-||-  <-||- 
    
     -||-> Assert-AreEqual $authRuleName $updatedAuthRule.Name <-||- 
     -||-> Assert-AreEqual 3 $updatedAuthRule.Rights.Count <-||- 
     -||-> Assert-True {  -||-> $updatedAuthRule.Rights -Contains "Listen" <-||-  } <-||- 
     -||-> Assert-True {  -||-> $updatedAuthRule.Rights -Contains "Send" <-||-  } <-||- 
     -||-> Assert-True {  -||-> $updatedAuthRule.Rights -Contains "Manage" <-||-  } <-||- 

     -||-> Write-Debug "Get namespace authorizationRules connectionStrings" <-||- 
     -||-> $namespaceListKeys =  -||-> Get-AzServiceBusKey -ResourceGroupName $resourceGroupName -Namespace $namespaceName -Name $authRuleName <-||-  <-||- 

     -||-> Assert-True {  -||-> $namespaceListKeys.PrimaryConnectionString -like "*$( -||-> $updatedAuthRule.PrimaryKey <-||- )*" <-||-  } <-||- 
     -||-> Assert-True {  -||-> $namespaceListKeys.SecondaryConnectionString -like "*$( -||-> $updatedAuthRule.SecondaryKey <-||- )*" <-||-  } <-||- 
	
    
     -||-> $policyKey = "PrimaryKey" <-||- 

     -||-> $namespaceRegenerateKeysDefault =  -||-> New-AzServiceBusKey -ResourceGroupName $resourceGroupName -Namespace $namespaceName -Name $authRuleName -RegenerateKey $policyKey <-||-  <-||- 
     -||-> Assert-True {  -||-> $namespaceRegenerateKeys.PrimaryKey -ne $namespaceListKeys.PrimaryKey <-||-  } <-||- 

     -||-> $namespaceRegenerateKeys =  -||-> New-AzServiceBusKey -ResourceGroupName $resourceGroupName -Namespace $namespaceName -Name $authRuleName -RegenerateKey $policyKey -KeyValue $namespaceListKeys.PrimaryKey <-||-  <-||- 
     -||-> Assert-AreEqual $namespaceRegenerateKeys.PrimaryKey $namespaceListKeys.PrimaryKey <-||- 

     -||-> $policyKey1 = "SecondaryKey" <-||- 

     -||-> $namespaceRegenerateKeys1 =  -||-> New-AzServiceBusKey -ResourceGroupName $resourceGroupName -Namespace $namespaceName -Name $authRuleName -RegenerateKey $policyKey1 -KeyValue $namespaceListKeys.PrimaryKey <-||-  <-||- 
     -||-> Assert-AreEqual $namespaceRegenerateKeys1.SecondaryKey $namespaceListKeys.PrimaryKey <-||- 
																	
     -||-> $namespaceRegenerateKeys1 =  -||-> New-AzServiceBusKey -ResourceGroupName $resourceGroupName -Namespace $namespaceName -Name $authRuleName -RegenerateKey $policyKey1 <-||-  <-||- 
     -||-> Assert-True {  -||-> $namespaceRegenerateKeys1.SecondaryKey -ne $namespaceListKeys.PrimaryKey <-||-  } <-||- 
     -||-> Assert-True {  -||-> $namespaceRegenerateKeys1.SecondaryKey -ne $namespaceListKeys.SecondaryKey <-||-  } <-||- 

     -||-> Write-Debug "Delete the created Namespace AuthorizationRule" <-||- 
     -||-> $result =  -||-> Remove-AzServiceBusAuthorizationRule -ResourceGroupName $resourceGroupName -Namespace $namespaceName -Name $authRuleName -Force <-||-  <-||- 
    
     -||-> Write-Debug " Delete namespaces" <-||- 
     -||-> Remove-AzServiceBusNamespace -ResourceGroupName $resourceGroupName -Name $namespaceName <-||- 
	   
} <-||- 

