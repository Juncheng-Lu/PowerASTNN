














 -||-> function Test-ExpressRouteBGPServiceCommunities
{
	 -||-> $communities =  -||-> Get-AzBgpServiceCommunity <-||-  <-||- 

	 -||-> Assert-NotNull $communities <-||- 
	 -||-> $crmOnlineCommunity =  -||-> $communities | Where-Object { -||-> $_.ServiceName -match "CRMOnline" <-||- } <-||-  <-||- 
	 -||-> Assert-NotNull $crmOnlineCommunity.BgpCommunities <-||- 
	 -||-> Assert-AreEqual true $crmOnlineCommunity.BgpCommunities[0].IsAuthorizedToUse <-||- 
} <-||- 


 -||-> function Test-ExpressRouteRouteFilters
{
     -||-> $rgname =  -||-> Get-ResourceGroupName <-||-  <-||- 
     -||-> $ruleName =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $filterName =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $location =  -||-> Get-ProviderLocation "Microsoft.Network/routeFilters" "westcentralus" <-||-  <-||- 

     -||-> try
    {
      
       -||-> $resourceGroup =  -||-> New-AzResourceGroup -Name $rgname -Location $location <-||-  <-||- 

      
       -||-> $job =  -||-> New-AzRouteFilter -Name $filterName -ResourceGroupName $rgname -Location $location -Force -AsJob <-||-  <-||- 
	   -||-> $job | Wait-Job <-||- 
	   -||-> $filter =  -||-> $job | Receive-Job <-||-  <-||- 

      
       -||-> Assert-AreEqual $rgName $filter.ResourceGroupName <-||- 
       -||-> Assert-AreEqual $filterName $filter.Name <-||- 
       -||-> Assert-NotNull $filter.Location <-||- 
       -||-> Assert-AreEqual 0 @( -||-> $filter.Rules <-||- ).Count <-||- 

	   -||-> $rule =  -||-> New-AzRouteFilterRuleConfig -Name $ruleName -Access Allow -RouteFilterRuleType Community -CommunityList "12076:5010" -Force <-||-  <-||- 
	   -||-> $filter =  -||-> Get-AzRouteFilter -Name $filterName -ResourceGroupName $rgname <-||-  <-||- 
	   -||-> $filter.Rules.Add($rule) <-||- 
	   -||-> $job =  -||-> Set-AzRouteFilter -RouteFilter $filter -Force -AsJob <-||-  <-||- 
	   -||-> $job | Wait-Job <-||- 
	   -||-> $filter =  -||-> $job | Receive-Job <-||-  <-||- 

	  
       -||-> Assert-AreEqual $rgName $filter.ResourceGroupName <-||- 
       -||-> Assert-AreEqual $filterName $filter.Name <-||- 
       -||-> Assert-NotNull $filter.Location <-||- 
       -||-> Assert-AreEqual 1 @( -||-> $filter.Rules <-||- ).Count <-||- 

	   -||-> $filter =  -||-> Get-AzRouteFilter -Name $filterName -ResourceGroupName $rgname <-||-  <-||- 
	   -||-> $filter.Rules.Clear() <-||- 
	   -||-> $filter =  -||-> Set-AzRouteFilter -RouteFilter $filter -Force <-||-  <-||- 

	  
       -||-> Assert-AreEqual $rgName $filter.ResourceGroupName <-||- 
       -||-> Assert-AreEqual $filterName $filter.Name <-||- 
       -||-> Assert-NotNull $filter.Location <-||- 
       -||-> Assert-AreEqual 0 @( -||-> $filter.Rules <-||- ).Count <-||- 

    }
    finally
    {
    
       -||-> Clean-ResourceGroup $rgname <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-ExpressRouteCircuitStageCRUD
{
    
     -||-> $rgname = 'movecircuit' <-||- 
     -||-> $circuitName =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $rglocation =  -||-> Get-ProviderLocation ResourceManagement "Brazil South" <-||-  <-||- 
     -||-> $location =  -||-> Get-ProviderLocation "Microsoft.Network/expressRouteCircuits" "Brazil South" <-||-  <-||- 

     -||-> try 
    {
      
       -||-> $resourceGroup =  -||-> New-AzResourceGroup -Name $rgname -Location $rglocation <-||-  <-||- 
      
      
	   -||-> $job =  -||-> New-AzExpressRouteCircuit -Name $circuitName -Location $location -ResourceGroupName $rgname -SkuTier Standard -SkuFamily MeteredData  -ServiceProviderName "equinix" -PeeringLocation "Silicon Valley" -BandwidthInMbps 500 -AllowClassicOperations $true -AsJob <-||-  <-||- 
	   -||-> $job | Wait-Job <-||- 
	   -||-> $circuit =  -||-> $job | Receive-Job <-||-  <-||- 
      
       -||-> $circuit =  -||-> Get-AzExpressRouteCircuit -Name $circuitName -ResourceGroupName $rgname <-||-  <-||- 
      
       -||-> $circuit.AllowClassicOperations = $false <-||- 
       -||-> $circuit =  -||-> Set-AzExpressRouteCircuit -ExpressRouteCircuit $circuit <-||-  <-||- 

       -||-> $actual =  -||-> Get-AzExpressRouteCircuitStats -ResourceGroupName $rgname -ExpressRouteCircuitName $circuit.Name <-||-  <-||-  
       -||-> Assert-AreEqual $actual.PrimaryBytesIn 0 <-||- 

	  
	   -||-> $job =  -||-> Move-AzExpressRouteCircuit -Name $circuitName -ResourceGroupName $rgname -Location $location -ServiceKey $circuit.ServiceKey -Force -AsJob <-||-  <-||- 
	   -||-> $job | Wait-Job <-||- 

      
	   -||-> $job =  -||-> Remove-AzExpressRouteCircuit -ResourceGroupName $rgname -name $circuitName -PassThru -Force -AsJob <-||-  <-||- 
	   -||-> $job | Wait-Job <-||- 
	   -||-> $delete =  -||-> $job | Receive-Job <-||-  <-||- 
       -||-> Assert-AreEqual true $delete <-||- 

      
       -||-> $list =  -||-> Get-AzExpressRouteCircuit -ResourceGroupName $rgname <-||-  <-||- 
       -||-> Assert-Null ( -||-> $list | Where-Object {  -||-> $_.ResourceGroupName -eq $rgname -and $_.Name -eq $circuitName <-||-  } <-||- ) <-||- ;

       -||-> $list =  -||-> Get-AzExpressRouteCircuit -ResourceGroupName "*" <-||-  <-||- 
       -||-> Assert-Null ( -||-> $list | Where-Object {  -||-> $_.ResourceGroupName -eq $rgname -and $_.Name -eq $circuitName <-||-  } <-||- ) <-||- ;

       -||-> $list =  -||-> Get-AzExpressRouteCircuit -Name "*" <-||-  <-||- 
       -||-> Assert-Null ( -||-> $list | Where-Object {  -||-> $_.ResourceGroupName -eq $rgname -and $_.Name -eq $circuitName <-||-  } <-||- ) <-||- ;

       -||-> $list =  -||-> Get-AzExpressRouteCircuit -ResourceGroupName "*" -Name "*" <-||-  <-||- 
       -||-> Assert-Null ( -||-> $list | Where-Object {  -||-> $_.ResourceGroupName -eq $rgname -and $_.Name -eq $circuitName <-||-  } <-||- ) <-||- ;
    }
    finally
    {
    
       -||-> Clean-ResourceGroup $rgname <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-ExpressRouteCircuitCRUD
{
    
     -||-> $rgname =  -||-> Get-ResourceGroupName <-||-  <-||- 
     -||-> $circuitName =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $rglocation =  -||-> Get-ProviderLocation ResourceManagement <-||-  <-||- 
     -||-> $location =  -||-> Get-ProviderLocation "Microsoft.Network/expressRouteCircuits" "Brazil South" <-||-  <-||- 

     -||-> try 
    {
      
       -||-> $resourceGroup =  -||-> New-AzResourceGroup -Name $rgname -Location $rglocation <-||-  <-||- 
      
      
		 -||-> $circuit =  -||-> New-AzExpressRouteCircuit -Name $circuitName -Location $location -ResourceGroupName $rgname -SkuTier Standard -SkuFamily MeteredData  -ServiceProviderName "equinix" -PeeringLocation "Silicon Valley" -BandwidthInMbps 500 <-||-  <-||- ;
      
      
       -||-> $getCircuit =  -||-> Get-AzExpressRouteCircuit -Name $circuitName -ResourceGroupName $rgname <-||-  <-||- 

      
       -||-> Assert-AreEqual $rgName $getCircuit.ResourceGroupName <-||- 
       -||-> Assert-AreEqual $circuitName $getCircuit.Name <-||- 
       -||-> Assert-NotNull $getCircuit.Location <-||- 
       -||-> Assert-NotNull $getCircuit.Etag <-||- 
       -||-> Assert-AreEqual 0 @( -||-> $getCircuit.Peerings <-||- ).Count <-||- 
       -||-> Assert-AreEqual "Standard_MeteredData" $getCircuit.Sku.Name <-||- 
       -||-> Assert-AreEqual "Standard" $getCircuit.Sku.Tier <-||- 
       -||-> Assert-AreEqual "MeteredData" $getCircuit.Sku.Family <-||- 
       -||-> Assert-AreEqual "equinix" $getCircuit.ServiceProviderProperties.ServiceProviderName <-||- 
       -||-> Assert-AreEqual "Silicon Valley" $getCircuit.ServiceProviderProperties.PeeringLocation <-||- 
       -||-> Assert-AreEqual "500" $getCircuit.ServiceProviderProperties.BandwidthInMbps <-||- 

      
       -||-> $list =  -||-> Get-AzExpressRouteCircuit -ResourceGroupName $rgname <-||-  <-||- 
       -||-> Assert-AreEqual 1 @( -||-> $list <-||- ).Count <-||- 
       -||-> Assert-AreEqual $list[0].ResourceGroupName $getCircuit.ResourceGroupName <-||- 
       -||-> Assert-AreEqual $list[0].Name $getCircuit.Name <-||- 
       -||-> Assert-AreEqual $list[0].Location $getCircuit.Location <-||- 
       -||-> Assert-AreEqual $list[0].Etag $getCircuit.Etag <-||- 
       -||-> Assert-AreEqual @( -||-> $list[0].Peerings <-||- ).Count @( -||-> $getCircuit.Peerings <-||- ).Count <-||- 

		
       -||-> $getCircuit.ServiceProviderProperties.BandwidthInMbps = 1000 <-||- 
       -||-> $getCircuit.Sku.Tier = "Premium" <-||- 
       -||-> $getCircuit.Sku.Family = "UnlimitedData" <-||- 

       -||-> $job =  -||-> Set-AzExpressRouteCircuit -ExpressRouteCircuit $getCircuit -AsJob <-||-  <-||- 
	   -||-> $job | Wait-Job <-||- 
	   -||-> $getCircuit =  -||-> $job | Receive-Job <-||-  <-||- 
       -||-> Assert-AreEqual $rgName $getCircuit.ResourceGroupName <-||- 
       -||-> Assert-AreEqual $circuitName $getCircuit.Name <-||- 
       -||-> Assert-NotNull $getCircuit.Location <-||- 
       -||-> Assert-NotNull $getCircuit.Etag <-||- 
       -||-> Assert-AreEqual 0 @( -||-> $getCircuit.Peerings <-||- ).Count <-||- 
       -||-> Assert-AreEqual "Standard_MeteredData" $getCircuit.Sku.Name <-||- 
       -||-> Assert-AreEqual "Premium" $getCircuit.Sku.Tier <-||- 
       -||-> Assert-AreEqual "UnlimitedData" $getCircuit.Sku.Family <-||- 
       -||-> Assert-AreEqual "equinix" $getCircuit.ServiceProviderProperties.ServiceProviderName <-||- 
       -||-> Assert-AreEqual "Silicon Valley" $getCircuit.ServiceProviderProperties.PeeringLocation <-||- 
       -||-> Assert-AreEqual "1000" $getCircuit.ServiceProviderProperties.BandwidthInMbps <-||- 
      

      
       -||-> $delete =  -||-> Remove-AzExpressRouteCircuit -ResourceGroupName $rgname -name $circuitName -PassThru -Force <-||-  <-||- 
       -||-> Assert-AreEqual true $delete <-||- 
		      
       -||-> $list =  -||-> Get-AzExpressRouteCircuit -ResourceGroupName $rgname <-||-  <-||- 
       -||-> Assert-AreEqual 0 @( -||-> $list <-||- ).Count <-||- 
    }
    finally
    {
    
       -||-> Clean-ResourceGroup $rgname <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-ExpressRouteCircuitPrivatePublicPeeringCRUD
{
    
     -||-> $rgname =  -||-> Get-ResourceGroupName <-||-  <-||- 
     -||-> $circuitName =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $rglocation =  -||-> Get-ProviderLocation ResourceManagement <-||-  <-||- 
     -||-> $location =  -||-> Get-ProviderLocation "Microsoft.Network/expressRouteCircuits" "Brazil South" <-||-  <-||- 

     -||-> try 
    {
        
         -||-> $resourceGroup =  -||-> New-AzResourceGroup -Name $rgname -Location $rglocation <-||-  <-||- 
    
        
         -||-> $peering =  -||-> New-AzExpressRouteCircuitPeeringConfig -Name AzurePrivatePeering -PeeringType AzurePrivatePeering -PeerASN 100 -PrimaryPeerAddressPrefix "192.168.1.0/30" -SecondaryPeerAddressPrefix "192.168.2.0/30" -VlanId 22 <-||-  <-||- 
         -||-> $circuit =  -||-> New-AzExpressRouteCircuit -Name $circuitName -Location $location -ResourceGroupName $rgname -SkuTier Standard -SkuFamily MeteredData  -ServiceProviderName "equinix" -PeeringLocation "Silicon Valley" -BandwidthInMbps 1000 -Peering $peering <-||-  <-||- 
    
        
         -||-> Assert-AreEqual $rgName $circuit.ResourceGroupName <-||- 
         -||-> Assert-AreEqual $circuitName $circuit.Name <-||- 
         -||-> Assert-NotNull $circuit.Location <-||- 
         -||-> Assert-NotNull $circuit.Etag <-||- 
         -||-> Assert-AreEqual 1 @( -||-> $circuit.Peerings <-||- ).Count <-||- 
         -||-> Assert-AreEqual "Standard_MeteredData" $circuit.Sku.Name <-||- 
         -||-> Assert-AreEqual "Standard" $circuit.Sku.Tier <-||- 
         -||-> Assert-AreEqual "MeteredData" $circuit.Sku.Family <-||- 
         -||-> Assert-AreEqual "equinix" $circuit.ServiceProviderProperties.ServiceProviderName <-||- 
         -||-> Assert-AreEqual "Silicon Valley" $circuit.ServiceProviderProperties.PeeringLocation <-||- 
         -||-> Assert-AreEqual "1000" $circuit.ServiceProviderProperties.BandwidthInMbps <-||- 
				
		
         -||-> Assert-AreEqual "AzurePrivatePeering" $circuit.Peerings[0].Name <-||- 
         -||-> Assert-AreEqual "AzurePrivatePeering" $circuit.Peerings[0].PeeringType <-||- 
		 -||-> Assert-AreEqual "100" $circuit.Peerings[0].PeerASN <-||- 
		 -||-> Assert-AreEqual "192.168.1.0/30" $circuit.Peerings[0].PrimaryPeerAddressPrefix <-||- 
		 -||-> Assert-AreEqual "192.168.2.0/30" $circuit.Peerings[0].SecondaryPeerAddressPrefix <-||- 
		 -||-> Assert-AreEqual "22" $circuit.Peerings[0].VlanId <-||- 

		 -||-> $stats =  -||-> Get-AzExpressRouteCircuitStats -ResourceGroupName $rgname -ExpressRouteCircuitName $circuit.Name -PeeringType AzurePrivatePeering <-||-  <-||- 
		 -||-> Assert-AreEqual $stats.PrimaryBytesIn 0 <-||- 

		 -||-> Get-AzExpressRouteCircuitARPTable -ResourceGroupName $rgname -ExpressRouteCircuitName $circuit.Name -PeeringType AzurePrivatePeering -DevicePath Primary <-||- 
		 -||-> Get-AzExpressRouteCircuitRouteTableSummary -ResourceGroupName $rgname -ExpressRouteCircuitName $circuit.Name -PeeringType AzurePrivatePeering -DevicePath Primary <-||- 
		 -||-> Get-AzExpressRouteCircuitRouteTable -ResourceGroupName $rgname -ExpressRouteCircuitName $circuit.Name -PeeringType AzurePrivatePeering -DevicePath Primary <-||- 
		
		
		 -||-> $p =  -||-> $circuit | Get-AzExpressRouteCircuitPeeringConfig -Name AzurePrivatePeering <-||-  <-||- 
		 -||-> Assert-AreEqual "AzurePrivatePeering" $p.Name <-||- 
		 -||-> Assert-AreEqual "AzurePrivatePeering" $p.PeeringType <-||- 
		 -||-> Assert-AreEqual "100" $p.PeerASN <-||- 
		 -||-> Assert-AreEqual "192.168.1.0/30" $p.PrimaryPeerAddressPrefix <-||- 
		 -||-> Assert-AreEqual "192.168.2.0/30" $p.SecondaryPeerAddressPrefix <-||- 
		 -||-> Assert-AreEqual "22" $p.VlanId <-||- 
		 -||-> Assert-Null $p.MicrosoftPeeringConfig <-||- 

		
		 -||-> $listPeering =  -||-> $circuit | Get-AzExpressRouteCircuitPeeringConfig <-||-  <-||- 
		 -||-> Assert-AreEqual 1 @( -||-> $listPeering <-||- ).Count <-||- 

		
         -||-> $delete =  -||-> Remove-AzExpressRouteCircuit -ResourceGroupName $rgname -name $circuitName -PassThru -Force <-||-  <-||- 
         -||-> Assert-AreEqual true $delete <-||- 
		    
         -||-> $list =  -||-> Get-AzExpressRouteCircuit -ResourceGroupName $rgname <-||-  <-||- 
         -||-> Assert-AreEqual 0 @( -||-> $list <-||- ).Count <-||- 	
		
    }
    finally
    {
    
       -||-> Clean-ResourceGroup $rgname <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-ExpressRouteCircuitMicrosoftPeeringCRUD
{
    
     -||-> $rgname =  -||-> Get-ResourceGroupName <-||-  <-||- 
     -||-> $circuitName =  -||-> Get-ResourceName <-||-  <-||- 
   -||-> $filterName = "filter" <-||- 
   -||-> $ruleName = "rule" <-||- 
     -||-> $rglocation =  -||-> Get-ProviderLocation ResourceManagement <-||-  <-||- 
     -||-> $location =  -||-> Get-ProviderLocation "Microsoft.Network/expressRouteCircuits" "Brazil South" <-||-  <-||- 

     -||-> try 
    {
        
         -||-> $resourceGroup =  -||-> New-AzResourceGroup -Name $rgname -Location $rglocation <-||-  <-||-     
        
         -||-> $peering =  -||-> New-AzExpressRouteCircuitPeeringConfig -Name MicrosoftPeering -PeeringType MicrosoftPeering -PeerASN 33 -PrimaryPeerAddressPrefix "192.171.1.0/30" -SecondaryPeerAddressPrefix "192.171.2.0/30" -VlanId 224 -MicrosoftConfigAdvertisedPublicPrefixes @( -||-> "11.2.3.4/30", "12.2.3.4/30" <-||- ) -MicrosoftConfigCustomerAsn 1000 -MicrosoftConfigRoutingRegistryName AFRINIC -LegacyMode $true <-||-  <-||-  
         -||-> $circuit =  -||-> New-AzExpressRouteCircuit -Name $circuitName -Location $location -ResourceGroupName $rgname -SkuTier Premium -SkuFamily MeteredData  -ServiceProviderName "equinix" -PeeringLocation "Silicon Valley" -BandwidthInMbps 1000 -Peering $peering <-||-  <-||- 	

        
         -||-> Assert-AreEqual $rgName $circuit.ResourceGroupName <-||- 
         -||-> Assert-AreEqual $circuitName $circuit.Name <-||- 
         -||-> Assert-NotNull $circuit.Location <-||- 
         -||-> Assert-NotNull $circuit.Etag <-||- 
         -||-> Assert-AreEqual 1 @( -||-> $circuit.Peerings <-||- ).Count <-||- 
         -||-> Assert-AreEqual "Premium_MeteredData" $circuit.Sku.Name <-||- 
         -||-> Assert-AreEqual "Premium" $circuit.Sku.Tier <-||- 
         -||-> Assert-AreEqual "MeteredData" $circuit.Sku.Family <-||- 
         -||-> Assert-AreEqual "equinix" $circuit.ServiceProviderProperties.ServiceProviderName <-||- 
         -||-> Assert-AreEqual "Silicon Valley" $circuit.ServiceProviderProperties.PeeringLocation <-||- 
         -||-> Assert-AreEqual "1000" $circuit.ServiceProviderProperties.BandwidthInMbps <-||- 
		
		
		 -||-> Assert-AreEqual "MicrosoftPeering" $circuit.Peerings[0].Name <-||- 
		 -||-> Assert-AreEqual "MicrosoftPeering" $circuit.Peerings[0].PeeringType <-||- 
		 -||-> Assert-AreEqual "192.171.1.0/30" $circuit.Peerings[0].PrimaryPeerAddressPrefix <-||- 
		 -||-> Assert-AreEqual "192.171.2.0/30" $circuit.Peerings[0].SecondaryPeerAddressPrefix <-||- 
		 -||-> Assert-AreEqual "224" $circuit.Peerings[0].VlanId <-||- 
		 -||-> Assert-NotNull $circuit.Peerings[0].MicrosoftPeeringConfig <-||- 
		 -||-> Assert-AreEqual "1000" $circuit.Peerings[0].MicrosoftPeeringConfig.CustomerASN <-||- 
		 -||-> Assert-AreEqual "AFRINIC" $circuit.Peerings[0].MicrosoftPeeringConfig.RoutingRegistryName <-||- 
		 -||-> Assert-AreEqual 2 @( -||-> $circuit.Peerings[0].MicrosoftPeeringConfig.AdvertisedPublicPrefixes <-||- ).Count <-||- 
		 -||-> Assert-NotNull $circuit.Peerings[0].MicrosoftPeeringConfig.AdvertisedPublicPrefixesState <-||- 

	    
		 -||-> $rule =  -||-> New-AzRouteFilterRuleConfig -Name $ruleName -Access Allow -RouteFilterRuleType Community -CommunityList "12076:5010" -Force <-||-  <-||- 	
		 -||-> $filter =  -||-> New-AzRouteFilter -Name $filterName -ResourceGroupName $rgname -Location $location -Rule $rule -Force <-||-  <-||- 
		
		
		 -||-> $circuit =  -||-> Get-AzExpressRouteCircuit -Name $circuitName -ResourceGroupName $rgname <-||-  <-||- 
		 -||-> $circuit.Peerings[0].RouteFilter = $filter <-||- 
		 -||-> Set-AzExpressRouteCircuit -ExpressRouteCircuit $circuit <-||- 

		
		 -||-> $p =  -||-> $circuit | Get-AzExpressRouteCircuitPeeringConfig -Name MicrosoftPeering <-||-  <-||- 
		 -||-> Assert-AreEqual "MicrosoftPeering" $p.Name <-||- 
		 -||-> Assert-AreEqual "MicrosoftPeering" $p.PeeringType <-||- 
		 -||-> Assert-AreEqual "192.171.1.0/30" $p.PrimaryPeerAddressPrefix <-||- 
		 -||-> Assert-AreEqual "192.171.2.0/30" $p.SecondaryPeerAddressPrefix <-||- 
		 -||-> Assert-AreEqual "224" $p.VlanId <-||- 
		 -||-> Assert-NotNull $p.MicrosoftPeeringConfig <-||- 
		 -||-> Assert-AreEqual "1000" $p.MicrosoftPeeringConfig.CustomerASN <-||- 
		 -||-> Assert-AreEqual "AFRINIC" $p.MicrosoftPeeringConfig.RoutingRegistryName <-||- 
		 -||-> Assert-AreEqual 2 @( -||-> $p.MicrosoftPeeringConfig.AdvertisedPublicPrefixes <-||- ).Count <-||- 
		 -||-> Assert-NotNull $p.MicrosoftPeeringConfig.AdvertisedPublicPrefixesState <-||- 

		
		 -||-> $listPeering =  -||-> $circuit | Get-AzExpressRouteCircuitPeeringConfig <-||-  <-||- 
		 -||-> Assert-AreEqual 1 @( -||-> $listPeering <-||- ).Count <-||- 

		
	     -||-> $circuit =  -||-> Get-AzExpressRouteCircuit -Name $circuitName -ResourceGroupName $rgname | Set-AzExpressRouteCircuitPeeringConfig -Name MicrosoftPeering -PeeringType MicrosoftPeering -PeerASN 44 -PrimaryPeerAddressPrefix "192.171.1.0/30" -SecondaryPeerAddressPrefix "192.171.2.0/30" -VlanId 555 -MicrosoftConfigAdvertisedPublicPrefixes @( -||-> "11.2.3.4/30", "12.2.3.4/30" <-||- ) -MicrosoftConfigCustomerAsn 1000 -MicrosoftConfigRoutingRegistryName AFRINIC | Set-AzExpressRouteCircuit <-||-  <-||-  
		 -||-> $p =  -||-> $circuit | Get-AzExpressRouteCircuitPeeringConfig -Name MicrosoftPeering <-||-  <-||- 
		 -||-> Assert-AreEqual "MicrosoftPeering" $p.Name <-||- 
		 -||-> Assert-AreEqual "MicrosoftPeering" $p.PeeringType <-||- 
		 -||-> Assert-AreEqual "44" $p.PeerASN <-||- 
		 -||-> Assert-AreEqual "192.171.1.0/30" $p.PrimaryPeerAddressPrefix <-||- 
		 -||-> Assert-AreEqual "192.171.2.0/30" $p.SecondaryPeerAddressPrefix <-||- 
		 -||-> Assert-AreEqual "555" $p.VlanId <-||- 
		 -||-> Assert-NotNull $p.MicrosoftPeeringConfig <-||- 
		 -||-> Assert-AreEqual "1000" $p.MicrosoftPeeringConfig.CustomerASN <-||- 
		 -||-> Assert-AreEqual "AFRINIC" $p.MicrosoftPeeringConfig.RoutingRegistryName <-||- 
		 -||-> Assert-AreEqual 2 @( -||-> $p.MicrosoftPeeringConfig.AdvertisedPublicPrefixes <-||- ).Count <-||- 
		 -||-> Assert-NotNull $p.MicrosoftPeeringConfig.AdvertisedPublicPrefixesState <-||- 

		
		 -||-> $primaryPeerAddressPrefixV6 = "fc00::/126" <-||- ;
		 -||-> $secondaryPeerAddressPrefixV6 = "fc00::/126" <-||- ;
		 -||-> $customerAsnV6 = 2000 <-||- ;
		 -||-> $routingRegistryNameV6 = "RADB" <-||- ;
		 -||-> $advertisedPublicPrefixesV6 = "fc02::1/128" <-||- ;
	     -||-> $circuit =  -||-> Get-AzExpressRouteCircuit -Name $circuitName -ResourceGroupName $rgname | Set-AzExpressRouteCircuitPeeringConfig -Name MicrosoftPeering -PeeringType MicrosoftPeering -PeerASN 44 -PrimaryPeerAddressPrefix $primaryPeerAddressPrefixV6 -SecondaryPeerAddressPrefix $secondaryPeerAddressPrefixV6 -VlanId 555 -MicrosoftConfigAdvertisedPublicPrefixes @( -||-> $advertisedPublicPrefixesV6 <-||- ) -MicrosoftConfigCustomerAsn $customerAsnV6 -MicrosoftConfigRoutingRegistryName $routingRegistryNameV6 -PeerAddressType IPv6 | Set-AzExpressRouteCircuit <-||-  <-||-  
		 -||-> $p =  -||-> $circuit | Get-AzExpressRouteCircuitPeeringConfig -Name MicrosoftPeering <-||-  <-||- 
		 -||-> Assert-AreEqual "MicrosoftPeering" $p.Name <-||- 
		 -||-> Assert-AreEqual "MicrosoftPeering" $p.PeeringType <-||- 
		 -||-> Assert-AreEqual "44" $p.PeerASN <-||- 
		 -||-> Assert-AreEqual $primaryPeerAddressPrefixV6 $p.Ipv6PeeringConfig.PrimaryPeerAddressPrefix <-||- 
		 -||-> Assert-AreEqual $secondaryPeerAddressPrefixV6 $p.Ipv6PeeringConfig.SecondaryPeerAddressPrefix <-||- 
		 -||-> Assert-AreEqual "555" $p.VlanId <-||- 
		 -||-> Assert-NotNull $p.Ipv6PeeringConfig.MicrosoftPeeringConfig <-||- 
		 -||-> Assert-AreEqual $customerAsnV6 $p.Ipv6PeeringConfig.MicrosoftPeeringConfig.CustomerASN <-||- 
		 -||-> Assert-AreEqual $routingRegistryNameV6 $p.Ipv6PeeringConfig.MicrosoftPeeringConfig.RoutingRegistryName <-||- 
		 -||-> Assert-AreEqual 1 @( -||-> $p.Ipv6PeeringConfig.MicrosoftPeeringConfig.AdvertisedPublicPrefixes <-||- ).Count <-||- 
		 -||-> Assert-NotNull $p.Ipv6PeeringConfig.MicrosoftPeeringConfig.AdvertisedPublicPrefixesState <-||- 
		
		
		 -||-> $listPeering =  -||-> $circuit | Get-AzExpressRouteCircuitPeeringConfig <-||-  <-||- 
		 -||-> Assert-AreEqual 1 @( -||-> $listPeering <-||- ).Count <-||- 

		 -||-> $deletePeering =  -||-> Remove-AzExpressRouteCircuitPeeringConfig -Name MicrosoftPeering -ExpressRouteCircuit $circuit -PeerAddressType All | Set-AzExpressRouteCircuit <-||-  <-||-  

		
		 -||-> $circuit =  -||-> Get-AzExpressRouteCircuit -Name $circuitName -ResourceGroupName $rgname <-||-  <-||-  
		 -||-> $listPeering =  -||-> $circuit | Get-AzExpressRouteCircuitPeeringConfig <-||-  <-||- 
		 -||-> Assert-AreEqual 0 @( -||-> $listPeering <-||- ).Count <-||- 

		
		 -||-> $primaryPeerAddressPrefixV6 = "fc00::/126" <-||- ;
		 -||-> $secondaryPeerAddressPrefixV6 = "fc00::/126" <-||- ;
		 -||-> $customerAsnV6 = 2000 <-||- ;
		 -||-> $routingRegistryNameV6 = "RADB" <-||- ;
		 -||-> $advertisedPublicPrefixesV6 = "fc02::1/128" <-||- ;
		 -||-> $circuit =  -||-> Get-AzExpressRouteCircuit -Name $circuitName -ResourceGroupName $rgname | Add-AzExpressRouteCircuitPeeringConfig -Name MicrosoftPeering -PeeringType MicrosoftPeering -PeerASN 44 -PrimaryPeerAddressPrefix $primaryPeerAddressPrefixV6 -SecondaryPeerAddressPrefix $secondaryPeerAddressPrefixV6 -VlanId 555 -MicrosoftConfigAdvertisedPublicPrefixes @( -||-> $advertisedPublicPrefixesV6 <-||- ) -MicrosoftConfigCustomerAsn $customerAsnV6 -MicrosoftConfigRoutingRegistryName $routingRegistryNameV6 -PeerAddressType IPv6 | Set-AzExpressRouteCircuit <-||-  <-||-  
		 -||-> $p =  -||-> $circuit | Get-AzExpressRouteCircuitPeeringConfig -Name MicrosoftPeering <-||-  <-||- 
		 -||-> Assert-AreEqual "MicrosoftPeering" $p.Name <-||- 
		 -||-> Assert-AreEqual "MicrosoftPeering" $p.PeeringType <-||- 
		 -||-> Assert-AreEqual "44" $p.PeerASN <-||- 
		 -||-> Assert-AreEqual $primaryPeerAddressPrefixV6 $p.Ipv6PeeringConfig.PrimaryPeerAddressPrefix <-||- 
		 -||-> Assert-AreEqual $secondaryPeerAddressPrefixV6 $p.Ipv6PeeringConfig.SecondaryPeerAddressPrefix <-||- 
		 -||-> Assert-AreEqual "555" $p.VlanId <-||- 
		 -||-> Assert-NotNull $p.Ipv6PeeringConfig.MicrosoftPeeringConfig <-||- 
		 -||-> Assert-AreEqual $customerAsnV6 $p.Ipv6PeeringConfig.MicrosoftPeeringConfig.CustomerASN <-||- 
		 -||-> Assert-AreEqual $routingRegistryNameV6 $p.Ipv6PeeringConfig.MicrosoftPeeringConfig.RoutingRegistryName <-||- 
		 -||-> Assert-AreEqual 1 @( -||-> $p.Ipv6PeeringConfig.MicrosoftPeeringConfig.AdvertisedPublicPrefixes <-||- ).Count <-||- 
		 -||-> Assert-NotNull $p.Ipv6PeeringConfig.MicrosoftPeeringConfig.AdvertisedPublicPrefixesState <-||- 

		
		 -||-> $delete =  -||-> Remove-AzExpressRouteCircuit -ResourceGroupName $rgname -name $circuitName -PassThru -Force <-||-  <-||- 
		 -||-> Assert-AreEqual true $delete <-||- 
		    
         -||-> $list =  -||-> Get-AzExpressRouteCircuit -ResourceGroupName $rgname <-||-  <-||- 
         -||-> Assert-AreEqual 0 @( -||-> $list <-||- ).Count <-||- 

    }
    finally
    {
        
           -||-> Clean-ResourceGroup $rgname <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-ExpressRouteCircuitAuthorizationCRUD
{
    
     -||-> $rgname =  -||-> Get-ResourceGroupName <-||-  <-||- 
     -||-> $circuitName =  -||-> Get-ResourceName <-||-  <-||- 
	 -||-> $authorizationName = "testkey" <-||- 
     -||-> $rglocation =  -||-> Get-ProviderLocation ResourceManagement <-||-  <-||- 
     -||-> $location =  -||-> Get-ProviderLocation "Microsoft.Network/expressRouteCircuits" "Brazil South" <-||-  <-||- 

     -||-> try 
    {
        
         -||-> $resourceGroup =  -||-> New-AzResourceGroup -Name $rgname -Location $rglocation <-||-  <-||- 
    
        
		 -||-> $authorization =  -||-> New-AzExpressRouteCircuitAuthorization -Name $authorizationName <-||-  <-||- 
		 -||-> $circuit =  -||-> New-AzExpressRouteCircuit -Name $circuitName -Location $location -ResourceGroupName $rgname -SkuTier Standard -SkuFamily MeteredData  -ServiceProviderName "equinix" -PeeringLocation "Silicon Valley" -BandwidthInMbps 500 -Authorization $authorization <-||-  <-||- 
    
        
         -||-> Assert-AreEqual $rgName $circuit.ResourceGroupName <-||- 
         -||-> Assert-AreEqual $circuitName $circuit.Name <-||- 
         -||-> Assert-NotNull $circuit.Location <-||- 
         -||-> Assert-NotNull $circuit.Etag <-||- 
         -||-> Assert-AreEqual 1 @( -||-> $circuit.Authorizations <-||- ).Count <-||- 
         -||-> Assert-AreEqual "Standard_MeteredData" $circuit.Sku.Name <-||- 
         -||-> Assert-AreEqual "Standard" $circuit.Sku.Tier <-||- 
         -||-> Assert-AreEqual "MeteredData" $circuit.Sku.Family <-||- 
         -||-> Assert-AreEqual "equinix" $circuit.ServiceProviderProperties.ServiceProviderName <-||- 
         -||-> Assert-AreEqual "Silicon Valley" $circuit.ServiceProviderProperties.PeeringLocation <-||- 
         -||-> Assert-AreEqual "500" $circuit.ServiceProviderProperties.BandwidthInMbps <-||- 
		
		
		 -||-> Assert-AreEqual $authorizationName $circuit.Authorizations[0].Name <-||- 
		

		
		 -||-> $a =  -||-> $circuit | Get-AzExpressRouteCircuitAuthorization -Name $authorizationName <-||-  <-||- 
		 -||-> Assert-AreEqual $authorizationName $a.Name <-||- 

		
		 -||-> $circuit =  -||-> Get-AzExpressRouteCircuit -Name $circuitName -ResourceGroupName $rgname | Add-AzExpressRouteCircuitAuthorization -Name "testkey2" | Set-AzExpressRouteCircuit <-||-  <-||- 

		 -||-> $a =  -||-> $circuit | Get-AzExpressRouteCircuitAuthorization -Name "testkey2" <-||-  <-||- 
		 -||-> Assert-AreEqual "testkey2" $a.Name <-||- 
		

		 -||-> $listAuthorization =  -||-> $circuit | Get-AzExpressRouteCircuitAuthorization <-||-  <-||- 
		 -||-> Assert-AreEqual 2 @( -||-> $listAuthorization <-||- ).Count <-||- 

        
         -||-> $delete =  -||-> Remove-AzExpressRouteCircuit -ResourceGroupName $rgname -name $circuitName -PassThru -Force <-||-  <-||- 
         -||-> Assert-AreEqual true $delete <-||- 
		    
         -||-> $list =  -||-> Get-AzExpressRouteCircuit -ResourceGroupName $rgname <-||-  <-||- 
         -||-> Assert-AreEqual 0 @( -||-> $list <-||- ).Count <-||- 
    }
    finally
    {
    
         -||-> Clean-ResourceGroup $rgname <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-ExpressRouteCircuitConnectionCRUD
{
	 -||-> $initCircuitName =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $peerCircuitName =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $rgname =  -||-> Get-ResourceGroupName <-||-  <-||- 
     -||-> $resourceTypeParent = "Microsoft.Network/expressRouteCircuits" <-||- 
     -||-> $rglocation =  -||-> Get-ProviderLocation $resourceTypeParent "Brazil South" <-||-  <-||- 
     -||-> $connectionName =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $addressPrefix = "30.0.0.0/29" <-||- 
	

	 -||-> try
	{
        
         -||-> $resourceGroup =  -||-> New-AzResourceGroup -Name $rgname -Location $rglocation <-||-  <-||- 
    
        
         -||-> $initpeering =  -||-> New-AzExpressRouteCircuitPeeringConfig -Name AzurePrivatePeering -PeeringType AzurePrivatePeering -PeerASN 100 -PrimaryPeerAddressPrefix "192.168.1.0/30" -SecondaryPeerAddressPrefix "192.168.2.0/30" -VlanId 22 <-||-  <-||- 
         -||-> $initckt =  -||-> New-AzExpressRouteCircuit -Name $initCircuitName -Location $rglocation -ResourceGroupName $rgname -SkuTier Standard -SkuFamily MeteredData  -ServiceProviderName "equinix" -PeeringLocation "Silicon Valley" -BandwidthInMbps 1000 -Peering $initpeering <-||-  <-||- 
		

        
		 -||-> $initckt =  -||-> Get-AzExpressRouteCircuit -Name $initCircuitName -ResourceGroupName $rgname <-||-  <-||- 
		 -||-> $initckt <-||- 

        
         -||-> Assert-AreEqual $rgName $initckt.ResourceGroupName <-||- 
         -||-> Assert-AreEqual $initCircuitName $initckt.Name <-||- 
         -||-> Assert-NotNull $initckt.Location <-||- 
         -||-> Assert-NotNull $initckt.Etag <-||- 
         -||-> Assert-AreEqual 1 @( -||-> $initckt.Peerings <-||- ).Count <-||- 
         -||-> Assert-AreEqual "Standard_MeteredData" $initckt.Sku.Name <-||- 
         -||-> Assert-AreEqual "Standard" $initckt.Sku.Tier <-||- 
         -||-> Assert-AreEqual "MeteredData" $initckt.Sku.Family <-||- 
         -||-> Assert-AreEqual "equinix" $initckt.ServiceProviderProperties.ServiceProviderName <-||- 
         -||-> Assert-AreEqual "Silicon Valley" $initckt.ServiceProviderProperties.PeeringLocation <-||- 
         -||-> Assert-AreEqual "1000" $initckt.ServiceProviderProperties.BandwidthInMbps <-||- 

        
         -||-> $peerpeering =  -||-> New-AzExpressRouteCircuitPeeringConfig -Name AzurePrivatePeering -PeeringType AzurePrivatePeering -PeerASN 200 -PrimaryPeerAddressPrefix "192.168.3.0/30" -SecondaryPeerAddressPrefix "192.168.4.0/30" -VlanId 44 <-||-  <-||- 
         -||-> $peerckt =  -||-> New-AzExpressRouteCircuit -Name $peerCircuitName -Location $rglocation -ResourceGroupName $rgname -SkuTier Standard -SkuFamily MeteredData  -ServiceProviderName "equinix" -PeeringLocation "Chicago" -BandwidthInMbps 1000 -Peering $peerpeering <-||-  <-||- 
		

        
		 -||-> $peerckt =  -||-> Get-AzExpressRouteCircuit -Name $peerCircuitName -ResourceGroupName $rgname <-||-  <-||- 
		 -||-> $peerckt <-||- 

        
         -||-> Assert-AreEqual $rgName $peerckt.ResourceGroupName <-||- 
         -||-> Assert-AreEqual $peerCircuitName $peerckt.Name <-||- 
         -||-> Assert-NotNull $peerckt.Location <-||- 
         -||-> Assert-NotNull $peerckt.Etag <-||- 
         -||-> Assert-AreEqual 1 @( -||-> $peerckt.Peerings <-||- ).Count <-||- 
         -||-> Assert-AreEqual "Standard_MeteredData" $peerckt.Sku.Name <-||- 
         -||-> Assert-AreEqual "Standard" $peerckt.Sku.Tier <-||- 
         -||-> Assert-AreEqual "MeteredData" $peerckt.Sku.Family <-||- 
         -||-> Assert-AreEqual "equinix" $peerckt.ServiceProviderProperties.ServiceProviderName <-||- 
         -||-> Assert-AreEqual "Chicago" $peerckt.ServiceProviderProperties.PeeringLocation <-||- 
         -||-> Assert-AreEqual "1000" $peerckt.ServiceProviderProperties.BandwidthInMbps <-||- 

		
		 -||-> Add-AzExpressRouteCircuitConnectionConfig -Name $connectionName -ExpressRouteCircuit $initckt -PeerExpressRouteCircuitPeering $peerckt.Peerings[0].Id -AddressPrefix $addressPrefix -AuthorizationKey test <-||- 

		
		 -||-> Set-AzExpressRouteCircuit -ExpressRouteCircuit $initckt <-||- 

		
		 -||-> $initckt =  -||-> Get-AzExpressRouteCircuit -Name $initCircuitName -ResourceGroupName $rgname <-||-  <-||- 
		 -||-> $initckt <-||- 

		
		 -||-> Assert-AreEqual $connectionName $initckt.Peerings[0].Connections[0].Name <-||- 
		 -||-> Assert-AreEqual "Succeeded" $initckt.Peerings[0].Connections[0].ProvisioningState <-||- 
		 -||-> Assert-AreEqual "Connected" $initckt.Peerings[0].Connections[0].CircuitConnectionStatus <-||- 
         -||-> Assert-AreEqual 1 $initckt.Peerings[0].Connections.Count <-||- 

		
		 -||-> $initckt =  -||-> Get-AzExpressRouteCircuit -Name $initCircuitName -ResourceGroupName $rgname <-||-  <-||- 

		
		 -||-> Assert-AreEqual $true $initckt.GlobalReachEnabled <-||- 

         -||-> $connection =  -||-> Get-AzureRmExpressRouteCircuitConnectionConfig -Name $connectionName -ExpressRouteCircuit $initckt <-||-  <-||- 
		 -||-> Assert-AreEqual $connectionName $connection.Name <-||- 
		 -||-> Assert-AreEqual "Succeeded" $connection.ProvisioningState <-||- 
		 -||-> Assert-AreEqual "Connected" $connection.CircuitConnectionStatus <-||- 

         -||-> $connections =  -||-> Get-AzureRmExpressRouteCircuitConnectionConfig -ExpressRouteCircuit $initckt <-||-  <-||- 
         -||-> Assert-NotNull $connections <-||- 
         -||-> Assert-AreEqual 1 $connections.Count <-||- 

		 -||-> $initckt =  -||-> Get-AzExpressRouteCircuit -Name $initCircuitName -ResourceGroupName $rgname <-||-  <-||- 
		 -||-> $peerckt =  -||-> Get-AzExpressRouteCircuit -Name $peerCircuitName -ResourceGroupName $rgname <-||-  <-||- 

		
		 -||-> Assert-AreEqual $true $peerckt.GlobalReachEnabled <-||- 

		
		 -||-> Assert-AreEqual 1 $peerckt.Peerings[0].PeeredConnections.Count <-||- 
		 -||-> Assert-AreEqual $initckt.ServiceKey $peerckt.Peerings[0].PeeredConnections[0].Name <-||- 
		 -||-> Assert-AreEqual $connectionName $peerckt.Peerings[0].PeeredConnections[0].ConnectionName <-||- 
		 -||-> Assert-AreEqual "Succeeded" $peerckt.Peerings[0].PeeredConnections[0].ProvisioningState <-||- 
		 -||-> Assert-AreEqual "Connected" $peerckt.Peerings[0].PeeredConnections[0].CircuitConnectionStatus <-||- 

		
		 -||-> Remove-AzExpressRouteCircuitConnectionConfig -Name $connectionName -ExpressRouteCircuit $initckt <-||- 

		
		 -||-> Set-AzExpressRouteCircuit -ExpressRouteCircuit $initckt <-||- 

		
		 -||-> $initckt =  -||-> Get-AzExpressRouteCircuit -Name $initCircuitName -ResourceGroupName $rgname <-||-  <-||- 
		 -||-> $initckt <-||- 

		
		 -||-> Assert-AreEqual $false $initckt.GlobalReachEnabled <-||- 

		
		 -||-> Assert-AreEqual 0 $initckt.Peerings[0].Connections.Count <-||- 

		
		 -||-> $peerckt =  -||-> Get-AzExpressRouteCircuit -Name $peerCircuitName -ResourceGroupName $rgname <-||-  <-||- 

		
		 -||-> Assert-AreEqual $false $peerckt.GlobalReachEnabled <-||- 

		
		 -||-> Assert-AreEqual 0 $peerckt.Peerings[0].PeeredConnections.Count <-||- 

         -||-> Remove-AzureRmExpressRouteCircuitPeeringConfig -ExpressRouteCircuit $initckt -Name AzurePrivatePeering <-||- 
         -||-> $initckt =  -||-> Set-AzureRmExpressRouteCircuit -ExpressRouteCircuit $initckt <-||-  <-||- 

         -||-> Assert-ThrowsLike {  -||-> Get-AzureRmExpressRouteCircuitConnectionConfig -ExpressRouteCircuit $initckt <-||-  } "*does not exist*" <-||- 
         -||-> Assert-ThrowsLike {  -||-> Add-AzureRmExpressRouteCircuitConnectionConfig -Name $connectionName -ExpressRouteCircuit $initckt -PeerExpressRouteCircuitPeering $peerckt.Peerings[0].Id -AddressPrefix $addressPrefix <-||-  } "*needs to be configured*" <-||- 
         -||-> Assert-ThrowsLike {  -||-> Remove-AzureRmExpressRouteCircuitConnectionConfig -ExpressRouteCircuit $initckt -Name $connectionName <-||-  } "*does not exist*" <-||- 

        
         -||-> $deleteinit =  -||-> Remove-AzExpressRouteCircuit -ResourceGroupName $rgname -name $initCircuitName -PassThru -Force <-||-  <-||- 
         -||-> Assert-AreEqual true $deleteinit <-||- 

         -||-> $deletepeer =  -||-> Remove-AzExpressRouteCircuit -ResourceGroupName $rgname -name $peerCircuitName -PassThru -Force <-||-  <-||- 
         -||-> Assert-AreEqual true $deletepeer <-||- 
		    
         -||-> $list =  -||-> Get-AzExpressRouteCircuit -ResourceGroupName $rgname <-||-  <-||- 
         -||-> Assert-AreEqual 0 @( -||-> $list <-||- ).Count <-||- 	
	}
	finally
	{
		
         -||-> Clean-ResourceGroup $rgname <-||- 
	} <-||- 
} <-||- 


 -||-> function Test-ExpressRouteCircuitPeeringWithRouteFilter
{
    
     -||-> $rgname =  -||-> Get-ResourceGroupName <-||-  <-||- 
     -||-> $rglocation =  -||-> Get-ProviderLocation ResourceManagement <-||-  <-||- 
     -||-> $location =  -||-> Get-ProviderLocation "Microsoft.Network/expressRouteCircuits" <-||-  <-||- 
     -||-> $ruleName =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $filterName =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $circuitName =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $peeringName = "MicrosoftPeering" <-||- 

     -||-> try
    {
         -||-> $resourceGroup =  -||-> New-AzResourceGroup -Name $rgname -Location $rglocation <-||-  <-||- 

         -||-> $rule =  -||-> New-AzRouteFilterRuleConfig -Name $ruleName -Access "Allow" -RouteFilterRuleType "Community" -CommunityList "12076:5010" -Force <-||-  <-||- 
         -||-> Assert-AreEqual $ruleName $rule.Name <-||- 

         -||-> $filter =  -||-> New-AzRouteFilter -ResourceGroupName $rgname -Name $filterName -Location $location -Rule $rule -Force <-||-  <-||- 
         -||-> Assert-AreEqual $filterName $filter.Name <-||- 
         -||-> Assert-AreEqual 1 @( -||-> $filter.Rules <-||- ).Count <-||- 
         -||-> Assert-AreEqual $ruleName $filter.Rules[0].Name <-||- 
         -||-> Assert-AreEqual $true $filter.Rules[0].Id.EndsWith($ruleName) <-||- 

         -||-> $peering =  -||-> New-AzExpressRouteCircuitPeeringConfig -Name $peeringName -RouteFilter $filter -PeeringType $peeringName -PeerASN 33 -PrimaryPeerAddressPrefix "192.171.1.0/30" -SecondaryPeerAddressPrefix "192.171.2.0/30" -VlanId 224 -MicrosoftConfigAdvertisedPublicPrefixes @( -||-> "11.2.3.4/30", "12.2.3.4/30" <-||- ) -MicrosoftConfigCustomerAsn 1000 -MicrosoftConfigRoutingRegistryName "AFRINIC" -LegacyMode $true <-||-  <-||- 
         -||-> Assert-AreEqual $peeringName $peering.Name <-||- 
         -||-> Assert-NotNull $peering.RouteFilter <-||- 
         -||-> Assert-AreEqual $true $peering.RouteFilter.Id.EndsWith($filterName) <-||-  

         -||-> $circuit =  -||-> New-AzExpressRouteCircuit -ResourceGroupName $rgname -Name $circuitName -Location $location -Peering $peering -SkuTier "Premium" -SkuFamily "MeteredData" -ServiceProviderName "equinix" -PeeringLocation "Atlanta" -BandwidthInMbps 1000 <-||-  <-||- 
         -||-> Assert-AreEqual $circuitName $circuit.Name <-||- 
         -||-> Assert-AreEqual 1 @( -||-> $circuit.Peerings <-||- ).Count <-||- 
         -||-> Assert-AreEqual $peeringName $circuit.Peerings[0].Name <-||- 
         -||-> Assert-AreEqual $true $circuit.Peerings[0].Id.EndsWith($peeringName) <-||- 

         -||-> $deletion =  -||-> Remove-AzExpressRouteCircuit -ResourceGroupName $rgname -Name $circuitName -PassThru -Force <-||-  <-||- 
         -||-> Assert-AreEqual $true $deletion <-||- 
         -||-> Assert-ThrowsLike {  -||-> Get-AzExpressRouteCircuit -ResourceGroupName $rgname -Name $circuitName <-||-  } "*${circuitName}*not found*" <-||- 

         -||-> $deletion =  -||-> Remove-AzRouteFilter -ResourceGroupName $rgname -Name $filterName -PassThru -Force <-||-  <-||- 
         -||-> Assert-AreEqual $true $deletion <-||- 
         -||-> Assert-ThrowsLike {  -||-> Get-AzRouteFilter -ResourceGroupName $rgname -Name $filterName <-||-  } "*${filterName}*not found*" <-||- 
    }
    finally
    {
        
         -||-> Clean-ResourceGroup $rgname <-||- 
    } <-||- 
} <-||- 


