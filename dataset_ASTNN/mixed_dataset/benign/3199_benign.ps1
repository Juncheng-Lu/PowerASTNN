














 -||-> function ServiceBusRuleTests {
    
     -||-> $location =  -||-> Get-Location <-||-  <-||- 
     -||-> $resourceGroupName =  -||-> getAssetName "RGName-" <-||-  <-||- 
     -||-> $namespaceName =  -||-> getAssetName "Namespace1-" <-||-  <-||- 
     -||-> $nameTopic =  -||-> getAssetName "Topic-" <-||-  <-||- 
     -||-> $subName =  -||-> getAssetName "Subscription-" <-||-  <-||- 
     -||-> $ruleName =  -||-> getAssetName "Rule-" <-||-  <-||- 
     -||-> $ruleName1 =  -||-> getAssetName "Rule-" <-||-  <-||- 
	 
     -||-> Write-Debug "Create resource group" <-||- 
     -||-> Write-Debug "ResourceGroup name : $resourceGroupName" <-||- 
     -||-> New-AzResourceGroup -Name $resourceGroupName -Location $location -Force <-||- 
        
     -||-> Write-Debug " Create new Topic namespace" <-||- 
     -||-> Write-Debug "NamespaceName : $namespaceName" <-||-  
     -||-> $result =  -||-> New-AzServiceBusNamespace -ResourceGroupName $resourceGroupName -Location $location -Name $namespaceName <-||-  <-||- 
    
     -||-> Write-Debug "Get the created namespace within the resource group" <-||- 
     -||-> $createdNamespace =  -||-> Get-AzServiceBusNamespace -ResourceGroupName $resourceGroupName -Name $namespaceName <-||-  <-||- 

     -||-> Assert-AreEqual $createdNamespace.Name $namespaceName <-||- 	

     -||-> Assert-AreEqual $createdNamespace.Name $namespaceName "Namespace created earlier is not found." <-||- 

     -||-> Write-Debug "Create Topic" <-||- 
	
     -||-> $result =  -||-> New-AzServiceBusTopic -ResourceGroupName $resourceGroupName -Namespace $namespaceName -Name $nameTopic -EnablePartitioning $TRUE <-||-  <-||- 
     -||-> Assert-AreEqual $result.Name $nameTopic "In CreateTopic response Name not found" <-||- 

     -||-> $resultGetTopic =  -||-> Get-AzServiceBusTopic -ResourceGroupName $resourceGroupName -Namespace $namespaceName -Name $result.Name <-||-  <-||- 
     -||-> Assert-AreEqual $resultGetTopic.Name $result.Name "In 'Get-AzServiceBusTopic' response, Topic Name not found" <-||- 
	
     -||-> $resultGetTopic.EnableExpress = $TRUE <-||- 

     -||-> $resltSetTopic =  -||-> Set-AzServiceBusTopic -ResourceGroupName $resourceGroupName -Namespace $namespaceName -Name $resultGetTopic.Name -InputObject $resultGetTopic <-||-  <-||- 
     -||-> Assert-AreEqual $resltSetTopic.Name $resultGetTopic.Name "In GetTopic response, TopicName not found" <-||- 

    
     -||-> $ResulListTopic =  -||-> Get-AzServiceBusTopic -ResourceGroupName $resourceGroupName -Namespace $namespaceName <-||-  <-||- 
     -||-> Assert-True {  -||-> $ResulListTopic.Count -gt 0 <-||-  } "no Topics were found in ListTopic" <-||- 
	
    
     -||-> $resltNewSub =  -||-> New-AzServiceBusSubscription -ResourceGroupName $resourceGroupName -Namespace $namespaceName -Topic $resultGetTopic.Name -Name $subName <-||-  <-||- 
     -||-> Assert-AreEqual $resltNewSub.Name $subName "Created Subscription not found" <-||- 

    
     -||-> $resultGetSub =  -||-> Get-AzServiceBusSubscription -ResourceGroupName $resourceGroupName -Namespace $namespaceName -Topic $resultGetTopic.Name -Name $subName <-||-  <-||- 
     -||-> Assert-AreEqual $resultGetSub.Name $subName "Get-Sub, Created Subscription not found" <-||- 

    
     -||-> $createRule =  -||-> New-AzServiceBusRule -ResourceGroupName $resourceGroupName -Namespace $namespaceName -Topic $resultGetTopic.Name -Subscription $subName -Name $ruleName -SqlExpression "myproperty='test'" -ActionSqlExpression "SET myAction='test'" -RequiresPreprocessing <-||-  <-||- 
     -||-> Assert-AreEqual $createRule.Name $ruleName "Rule created earlier is not found." <-||- 
     -||-> Assert-AreEqual $createRule.Action.SqlExpression "SET myAction='test'" "Action SqlExpression is not found." <-||- 
	
    
     -||-> $getRule =  -||-> Get-AzServiceBusRule -ResourceGroupName $resourceGroupName -Namespace $namespaceName -Topic $resultGetTopic.Name -Subscription $subName -Name $ruleName <-||-  <-||- 
     -||-> Assert-AreEqual $getRule.Name $ruleName "Get-rule, Rule created earlier is not found." <-||- 

    
     -||-> $getRule.SqlFilter.SqlExpression = "myproperty='testing'" <-||- 

     -||-> $setRule =  -||-> Set-AzServiceBusRule -ResourceGroupName $resourceGroupName -Namespace $namespaceName -Topic $resultGetTopic.Name -Subscription $subName -Name $ruleName -InputObject $getRule <-||-  <-||- 	
     -||-> Assert-AreEqual $setRule.SqlFilter.SqlExpression "myproperty='testing'" "Rule's SqlExpression updated earlier is not found." <-||- 
	
    
     -||-> $createRule1 =  -||-> New-AzServiceBusRule -ResourceGroupName $resourceGroupName -Namespace $namespaceName -Topic $resultGetTopic.Name -Subscription $subName -Name $ruleName1 -SqlExpression "myproperty='test'" <-||-  <-||- 
     -||-> Assert-AreEqual $createRule1.Name $ruleName1 "Rule created earlier is not found." <-||- 
	
    
     -||-> $getRule1 =  -||-> Get-AzServiceBusRule -ResourceGroupName $resourceGroupName -Namespace $namespaceName -Topic $resultGetTopic.Name -Subscription $subName -Name $ruleName1 <-||-  <-||- 
     -||-> Assert-AreEqual $getRule1.Name $ruleName1 "Get-rule, Rule created earlier is not found." <-||- 

    
     -||-> $getRule1.FilterType = "CorrelationFilter" <-||- 
     -||-> $getRule1.CorrelationFilter.Properties.add("topichint", "topichintexpresion") <-||- 
     -||-> $getRule1.CorrelationFilter.Properties.add("topichint1", "topichintexpresion1") <-||- 
     -||-> $getRule1.CorrelationFilter.Properties.add("topichint2", "topichintexpresion2") <-||- 

     -||-> $setRule1 =  -||-> Set-AzServiceBusRule -ResourceGroupName $resourceGroupName -Namespace $namespaceName -Topic $resultGetTopic.Name -Subscription $subName -Name $ruleName1 -InputObject $getRule1 <-||-  <-||- 
     -||-> Assert-AreEqual $setRule1.FilterType "CorrelationFilter" "Rule's FilterType is not CorrelationFilter" <-||- 
     -||-> Assert-True {  -||-> $setRule1.CorrelationFilter.Properties.Count -gt 1 <-||-  } "CorrelationFilter - properties count is less than 1, where as it should be greate than 1" <-||- 
     -||-> Assert-AreEqual $setRule1.CorrelationFilter.Properties.Count 3 "CorrelationFilter - properties count in not 3" <-||- 

    
     -||-> Remove-AzServiceBusRule -ResourceGroupName $resourceGroupName -Namespace $namespaceName -Topic $resultGetTopic.Name -Subscription $subName -Name $ruleName -Force <-||- 
	
    
     -||-> Remove-AzServiceBusRule -ResourceGroupName $resourceGroupName -Namespace $namespaceName -Topic $resultGetTopic.Name -Subscription $subName -Name $ruleName1 -Force <-||- 

    
     -||-> $ruleList_delete =  -||-> Get-AzServiceBusRule -ResourceGroupName $resourceGroupName -Namespace $namespaceName -Topic $resultGetTopic.Name -Subscription $subName <-||-  <-||- 
     -||-> Assert-AreEqual $ruleList_delete.Count 0 "Rule List: Rule count not equal to Zero delete" <-||- 
	
    
     -||-> $ResultDeleteTopic =  -||-> Remove-AzServiceBusSubscription -ResourceGroupName $resourceGroupName -Namespace $namespaceName -Topic $ResulListTopic[0].Name -Name $resultGetSub.Name -PassThru <-||-  <-||- 
     -||-> Assert-True {  -||-> $ResultDeleteTopic <-||-  } "Subscription not deleted" <-||- 
		 
    
    
     -||-> Write-Debug " Delete the Topic" <-||- 
    for ( -||-> $i = 0 <-||- ;  -||-> $i -lt $ResulListTopic.Count <-||- ;  -||-> $i++ <-||- ) {
         -||-> $delete1 =  -||-> Remove-AzServiceBusTopic -ResourceGroupName $resourceGroupName -Namespace $namespaceName -Name $ResulListTopic[$i].Name <-||-  <-||- 
    }

     -||-> Write-Debug "Delete NameSpace" <-||- 
     -||-> Remove-AzServiceBusNamespace -ResourceGroupName $resourceGroupName -Name $namespaceName <-||- 

     -||-> Write-Debug " Delete resourcegroup" <-||- 
     -||-> Remove-AzResourceGroup -Name $resourceGroupName -Force <-||- 

} <-||- 

