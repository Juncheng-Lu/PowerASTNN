














 -||-> function Test-GetSubscriptionsEndToEnd
{
	 -||-> $allSubscriptions =  -||-> Get-AzSubscription <-||-  <-||- 
	 -||-> $firstSubscription = $allSubscriptions[0] <-||- 
	 -||-> $id = $firstSubscription.Id <-||- 
	 -||-> $tenant = $firstSubscription.TenantId <-||- 
	 -||-> $name = $firstSubscription.Name <-||- 
	 -||-> $subscription =  -||-> $firstSubscription | Get-AzSubscription <-||-  <-||- 
	 -||-> Assert-True {  -||-> $subscription -ne $null <-||-  } <-||- 
	 -||-> Assert-AreEqual $id $subscription.Id <-||- 
	 -||-> $subscription =  -||-> Get-AzSubscription -SubscriptionId $id <-||-  <-||- 
	 -||-> Assert-True {  -||-> $subscription -ne $null <-||-  } <-||- 
	 -||-> Assert-AreEqual $id $subscription.Id <-||- 
	 -||-> $subscription =  -||-> Get-AzSubscription -SubscriptionName $name -Tenant $tenant <-||-  <-||- 
	 -||-> Assert-True {  -||-> $subscription -ne $null <-||-  } <-||- 
	 -||-> Assert-AreEqual $name $subscription.Name <-||- 
	 -||-> $subscription =  -||-> Get-AzSubscription -SubscriptionName $name <-||-  <-||- 
	 -||-> Assert-True {  -||-> $subscription -ne $null <-||-  } <-||- 
	 -||-> Assert-AreEqual $name $subscription.Name <-||- 
	 -||-> $subscription =  -||-> Get-AzSubscription -SubscriptionName $name.ToUpper() <-||-  <-||- 
	 -||-> Assert-True {  -||-> $subscription -ne $null <-||-  } <-||- 
	 -||-> Assert-AreEqual $name $subscription.Name <-||- 
	 -||-> $mostSubscriptions =  -||-> Get-AzSubscription <-||-  <-||- 
	 -||-> Assert-True { -||-> $mostSubscriptions.Count -gt 0 <-||- } <-||- 
	 -||-> $tenantSubscriptions =  -||-> Get-AzSubscription -Tenant $tenant <-||-  <-||- 
	 -||-> Assert-True { -||-> $tenantSubscriptions.Count -gt 0 <-||- } <-||- 
} <-||- 


 -||-> function Test-PipingWithContext
{
     -||-> $allSubscriptions =  -||-> Get-AzSubscription <-||-  <-||- 
	 -||-> $firstSubscription = $allSubscriptions[0] <-||- 
	 -||-> $id = $firstSubscription.Id <-||- 
	 -||-> $name = $firstSubscription.Name <-||- 
	 -||-> $nameContext =  -||-> Get-AzSubscription -SubscriptionName $name | Set-AzContext <-||-  <-||- 
	 -||-> $idContext =  -||-> Get-AzSubscription -SubscriptionId $id | Set-AzContext <-||-  <-||- 
	 -||-> $contextByName =  -||-> Set-AzContext -SubscriptionName $name <-||-  <-||- 
	 -||-> Assert-True {  -||-> $nameContext -ne $null <-||-  } <-||- 
	 -||-> Assert-True {  -||-> $nameContext.Subscription -ne $null <-||-  } <-||- 
	 -||-> Assert-True {  -||-> $nameContext.Subscription.Id -ne $null <-||-  } <-||- 
	 -||-> Assert-True {  -||-> $nameContext.Subscription.Name -ne $null <-||-  } <-||- 
	 -||-> Assert-True {  -||-> $idContext -ne $null <-||-  } <-||- 
	 -||-> Assert-True {  -||-> $idContext.Subscription -ne $null <-||-  } <-||- 
	 -||-> Assert-True {  -||-> $idContext.Subscription.Id -ne $null <-||-  } <-||- 
	 -||-> Assert-True {  -||-> $idContext.Subscription.Name -ne $null <-||-  } <-||- 
	 -||-> Assert-AreEqual $idContext.Subscription.Id  $nameContext.Subscription.Id <-||- 
	 -||-> Assert-AreEqual $idContext.Subscription.Name  $nameContext.Subscription.Name <-||- 
	 -||-> Assert-True {  -||-> $contextByName -ne $null <-||-  } <-||- 
	 -||-> Assert-True {  -||-> $contextByName.Subscription -ne $null <-||-  } <-||- 
	 -||-> Assert-True {  -||-> $contextByName.Subscription.Id -ne $null <-||-  } <-||- 
	 -||-> Assert-True {  -||-> $contextByName.Subscription.Name -ne $null <-||-  } <-||- 
	 -||-> Assert-AreEqual $contextByName.Subscription.Name  $nameContext.Subscription.Name <-||- 
} <-||- 


 -||-> function Test-SetAzureRmContextEndToEnd
{
    
	 -||-> $allSubscriptions =  -||-> Get-AzSubscription <-||-  <-||- 
     -||-> $secondSubscription = $allSubscriptions[1] <-||- 
     -||-> Assert-True {  -||-> $allSubscriptions[0] -ne $null <-||-  } <-||- 
	 -||-> Assert-True {  -||-> $secondSubscription -ne $null <-||-  } <-||- 
     -||-> Set-AzContext -SubscriptionId $secondSubscription.Id <-||- 
     -||-> $context =  -||-> Get-AzContext <-||-  <-||- 
     -||-> Assert-AreEqual $context.Subscription.Id $secondSubscription.Id <-||- 
     -||-> $junkSubscriptionId = "49BC3D95-9A30-40F8-81E0-3CDEF0C3F8A5" <-||- 
     -||-> Assert-ThrowsContains { -||-> Set-AzContext -SubscriptionId $junkSubscriptionId <-||- } "provide a valid" <-||- 
} <-||- 


 -||-> function Test-SetAzureRmContextWithoutSubscription
{
     -||-> $allSubscriptions =  -||-> Get-AzSubscription <-||-  <-||- 
     -||-> $firstSubscription = $allSubscriptions[0] <-||- 
     -||-> $id = $firstSubscription.Id <-||- 
     -||-> $tenantId = $firstSubscription.TenantId <-||- 

     -||-> Assert-True {  -||-> $tenantId -ne $null <-||-  } <-||- 

     -||-> Set-AzContext -TenantId $tenantId <-||- 
     -||-> $context =  -||-> Get-AzContext <-||-  <-||- 

     -||-> Assert-True {  -||-> $context.Subscription -ne $null <-||-  } <-||- 
     -||-> Assert-True {  -||-> $context.Tenant -ne $null <-||-  } <-||- 
     -||-> Assert-AreEqual $context.Tenant.Id $firstSubscription.TenantId <-||- 
     -||-> Assert-AreEqual $context.Subscription.Id $firstSubscription.Id <-||- 
} <-||- 

