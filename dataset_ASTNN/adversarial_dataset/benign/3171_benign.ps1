














 -||-> function Test-LocalNetworkGatewayCRUD
{
    
     -||-> $rgname =  -||-> Get-ResourceGroupName <-||-  <-||- 
     -||-> $rname =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $rglocation =  -||-> Get-ProviderLocation ResourceManagement <-||-  <-||- 
     -||-> $resourceTypeParent = "Microsoft.Network/localNetworkGateways" <-||- 
     -||-> $location =  -||-> Get-ProviderLocation $resourceTypeParent <-||-  <-||- 

     -||-> try 
     {
      
       -||-> $resourceGroup =  -||-> New-AzResourceGroup -Name $rgname -Location $rglocation -Tags @{ testtag =  -||-> "testval" <-||-  } <-||-  <-||-              

      
       -||-> $job =  -||-> New-AzLocalNetworkGateway -ResourceGroupName $rgname -name $rname -location $location -AddressPrefix 192.168.0.0/16 -GatewayIpAddress 192.168.3.4 -AsJob <-||-  <-||- 
       -||-> $job | Wait-Job <-||- 
	   -||-> $actual =  -||-> $job | Receive-Job <-||-  <-||- 
	   -||-> $expected =  -||-> Get-AzLocalNetworkGateway -ResourceGroupName $rgname -name $rname <-||-  <-||- 
       -||-> Assert-AreEqual $expected.ResourceGroupName $actual.ResourceGroupName <-||- 	
       -||-> Assert-AreEqual $expected.Name $actual.Name <-||- 	
       -||-> Assert-AreEqual "192.168.3.4" $expected.GatewayIpAddress <-||- 
       -||-> Assert-AreEqual "192.168.0.0/16" $expected.LocalNetworkAddressSpace.AddressPrefixes[0] <-||- 
       -||-> $expected.Location = $location <-||- 

      
       -||-> $list =  -||-> Get-AzLocalNetworkGateway -ResourceGroupName $rgname <-||-  <-||- 
       -||-> Assert-AreEqual 1 @( -||-> $list <-||- ).Count <-||- 
       -||-> Assert-AreEqual $list[0].ResourceGroupName $actual.ResourceGroupName <-||- 	
       -||-> Assert-AreEqual $list[0].Name $actual.Name <-||- 	
       -||-> Assert-AreEqual $list[0].Location $actual.Location <-||- 
       -||-> Assert-AreEqual "192.168.3.4" $list[0].GatewayIpAddress <-||- 
      
      
       -||-> $job =  -||-> Set-AzLocalNetworkGateway -LocalNetworkGateway $expected -AddressPrefix "200.168.0.0/16" -AsJob <-||-  <-||- 
	   -||-> $job | Wait-Job <-||- 
	   -||-> $actual =  -||-> $job | Receive-Job <-||-  <-||- 
       -||-> $expected =  -||-> Get-AzLocalNetworkGateway -ResourceGroupName $rgname -name $rname <-||-  <-||-     
       -||-> Assert-AreEqual "200.168.0.0/16" $expected.LocalNetworkAddressSpace.AddressPrefixes[0] <-||- 

	  
	   -||-> $asn = 1234 <-||- 
	   -||-> $bgpPeeringAddress = "1.2.3.4" <-||- 
	   -||-> $peerWeight = 15 <-||- 
	   -||-> $actual =  -||-> Set-AzLocalNetworkGateway -LocalNetworkGateway $expected -Asn $asn -BgpPeeringAddress $bgpPeeringAddress -PeerWeight $peerWeight <-||-  <-||- 
       -||-> $expected =  -||-> Get-AzLocalNetworkGateway -ResourceGroupName $rgname -name $rname <-||-  <-||-     
       -||-> Assert-AreEqual $asn $expected.BgpSettings.Asn <-||- 
	   -||-> Assert-AreEqual $bgpPeeringAddress $expected.BgpSettings.BgpPeeringAddress <-||- 
	   -||-> Assert-AreEqual $peerWeight $expected.BgpSettings.PeerWeight <-||- 

	   -||-> $list =  -||-> Get-AzLocalNetworkGateway -ResourceGroupName "*" -Name "*" <-||-  <-||- 
	   -||-> Assert-True {  -||-> $list.Count -ge 0 <-||-  } <-||- 

	   -||-> $list =  -||-> Get-AzLocalNetworkGateway -ResourceGroupName "*" <-||-  <-||- 
	   -||-> Assert-True {  -||-> $list.Count -ge 0 <-||-  } <-||- 

	  
	   -||-> $asn = 1337 <-||- 
	   -||-> $actual =  -||-> Set-AzLocalNetworkGateway -LocalNetworkGateway $expected -Asn $asn <-||-  <-||- 
       -||-> $expected =  -||-> Get-AzLocalNetworkGateway -ResourceGroupName $rgname -name $rname <-||-  <-||-     
       -||-> Assert-AreEqual $asn $expected.BgpSettings.Asn <-||- 

        
         -||-> Assert-ThrowsContains {  -||-> Set-AzLocalNetworkGateway -LocalNetworkGateway $expected -PeerWeight -1 <-||-  } "PeerWeight cannot be negative" <-||- 

      
       -||-> $job =  -||-> Remove-AzLocalNetworkGateway -ResourceGroupName $actual.ResourceGroupName -name $rname -PassThru -Force -AsJob <-||-  <-||- 
	   -||-> $job | Wait-Job <-||- 
	   -||-> $delete =  -||-> $job | Receive-Job <-||-  <-||- 
       -||-> Assert-AreEqual true $delete <-||- 
      
       -||-> $list =  -||-> Get-AzLocalNetworkGateway -ResourceGroupName $actual.ResourceGroupName <-||-  <-||- 
       -||-> Assert-AreEqual 0 @( -||-> $list <-||- ).Count <-||- 

        
         -||-> Assert-ThrowsContains {  -||-> Set-AzLocalNetworkGateway -LocalNetworkGateway $actual <-||-  } "not found" <-||- 
         -||-> Assert-Throws {  -||-> New-AzLocalNetworkGateway -ResourceGroupName $rgname -name $rname -location $location -PeerWeight -1 <-||-  } "PeerWeight cannot be negative" <-||- 
         -||-> Assert-ThrowsContains {  -||-> New-AzLocalNetworkGateway -ResourceGroupName $rgname -name $rname -location $location -Asn 64 <-||-  } "ASN and BgpPeeringAddress must both be specified" <-||- 
         -||-> Assert-ThrowsContains {  -||-> New-AzLocalNetworkGateway -ResourceGroupName $rgname -name $rname -location $location -BgpPeeringAddress "1.2.3.4" <-||-  } "ASN and BgpPeeringAddress must both be specified" <-||- 
     }
     finally
     {
        
         -||-> Clean-ResourceGroup $rgname <-||- 
     } <-||- 
} <-||- 


