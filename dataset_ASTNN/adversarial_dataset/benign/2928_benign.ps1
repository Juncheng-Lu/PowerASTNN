














 -||-> function Test-ZoneCrud
{
	 -||-> $zoneName =  -||-> Get-RandomZoneName <-||-  <-||- 
     -||-> $resourceGroup =  -||-> TestSetup-CreateResourceGroup <-||-  <-||- 
	 -||-> $createdZone =  -||-> New-AzDnsZone -Name $zoneName -ResourceGroupName $resourceGroup.ResourceGroupName -Tags @{tag1= -||-> "value1" <-||- } <-||-  <-||- 

	 -||-> Assert-NotNull $createdZone <-||- 
	 -||-> Assert-NotNull $createdZone.Etag <-||- 
	 -||-> Assert-AreEqual $zoneName $createdZone.Name <-||- 
	 -||-> Assert-AreEqual $resourceGroup.ResourceGroupName $createdZone.ResourceGroupName <-||- 
	 -||-> Assert-AreEqual 1 $createdZone.Tags.Count <-||- 
	 -||-> Assert-AreEqual 2 $createdZone.NumberOfRecordSets <-||- 
	 -||-> Assert-AreNotEqual $createdZone.NumberOfRecordSets $createdZone.MaxNumberOfRecordSets <-||- 
	 -||-> Assert-Null $createdZone.Type <-||- 
	 -||-> Assert-AreEqual 0 $createdZone.RegistrationVirtualNetworkIds.Count <-||- 
	 -||-> Assert-AreEqual 0 $createdZone.ResolutionVirtualNetworkIds.Count <-||- 

	 -||-> $retrievedZone =  -||-> Get-AzDnsZone -Name $zoneName -ResourceGroupName $resourceGroup.ResourceGroupName <-||-  <-||- 

	 -||-> Assert-NotNull $retrievedZone <-||- 
	 -||-> Assert-NotNull $retrievedZone.Etag <-||- 
	 -||-> Assert-AreEqual $zoneName $retrievedZone.Name <-||- 
	 -||-> Assert-AreEqual $resourceGroup.ResourceGroupName $retrievedZone.ResourceGroupName <-||- 
	 -||-> Assert-AreEqual $retrievedZone.Etag $createdZone.Etag <-||- 
	 -||-> Assert-AreEqual 1 $retrievedZone.Tags.Count <-||- 
	 -||-> Assert-AreEqual $createdZone.NumberOfRecordSets $retrievedZone.NumberOfRecordSets <-||- 
	 -||-> Assert-Null $retrievedZone.Type <-||- 
	 -||-> Assert-AreEqual 0 $retrievedZone.RegistrationVirtualNetworkIds.Count <-||- 
	 -||-> Assert-AreEqual 0 $retrievedZone.ResolutionVirtualNetworkIds.Count <-||- 
	
	

	 -||-> $updatedZone =  -||-> Set-AzDnsZone -Name $zoneName -ResourceGroupName $resourceGroup.ResourceGroupName -Tags @{tag1= -||-> "value1" <-||- ;tag2= -||-> "value2" <-||- } <-||-  <-||- 

	 -||-> Assert-NotNull $updatedZone <-||- 
	 -||-> Assert-NotNull $updatedZone.Etag <-||- 
	 -||-> Assert-AreEqual $zoneName $updatedZone.Name <-||- 
	 -||-> Assert-AreEqual $resourceGroup.ResourceGroupName $updatedZone.ResourceGroupName <-||- 
	 -||-> Assert-AreNotEqual $updatedZone.Etag $createdZone.Etag <-||- 
	 -||-> Assert-AreEqual 2 $updatedZone.Tags.Count <-||- 
	 -||-> Assert-Null $updatedZone.Type <-||- 
	 -||-> Assert-AreEqual 0 $updatedZone.RegistrationVirtualNetworkIds.Count <-||- 
	 -||-> Assert-AreEqual 0 $updatedZone.ResolutionVirtualNetworkIds.Count <-||- 

	 -||-> $retrievedZone =  -||-> Get-AzDnsZone -Name $zoneName -ResourceGroupName $resourceGroup.ResourceGroupName <-||-  <-||- 

	 -||-> Assert-NotNull $retrievedZone <-||- 
	 -||-> Assert-NotNull $retrievedZone.Etag <-||- 
	 -||-> Assert-AreEqual $zoneName $retrievedZone.Name <-||- 
	 -||-> Assert-AreEqual $resourceGroup.ResourceGroupName $retrievedZone.ResourceGroupName <-||- 
	 -||-> Assert-AreEqual $retrievedZone.Etag $updatedZone.Etag <-||- 
	 -||-> Assert-AreEqual 2 $retrievedZone.Tags.Count <-||- 
	 -||-> Assert-Null $retrievedZone.Type <-||- 
	 -||-> Assert-AreEqual 0 $retrievedZone.RegistrationVirtualNetworkIds.Count <-||- 
	 -||-> Assert-AreEqual 0 $retrievedZone.ResolutionVirtualNetworkIds.Count <-||- 

	 -||-> $removed =  -||-> Remove-AzDnsZone -Name $zoneName -ResourceGroupName $resourceGroup.ResourceGroupName -PassThru -Confirm:$false <-||-  <-||- 

	 -||-> Assert-True {  -||-> $removed <-||-  } <-||- 

	 -||-> Assert-Throws {  -||-> Get-AzDnsZone -Name $zoneName -ResourceGroupName $resourceGroup.ResourceGroupName <-||-  } <-||- 
	 -||-> Remove-AzResourceGroup -Name $resourceGroup.ResourceGroupName -Force <-||- 
} <-||- 


 -||-> function Test-ZoneWithDelegation
{
	
	 -||-> $parentZoneName =  -||-> Get-RandomZoneName <-||-  <-||- 
     -||-> $resourceGroup =  -||-> TestSetup-CreateResourceGroup <-||-  <-||- 
	
	 -||-> try
    {
         -||-> $createdParentZone =  -||-> New-AzDnsZone -Name $parentZoneName -ResourceGroupName $resourceGroup.ResourceGroupName -Tags @{tag1= -||-> "value1" <-||- } <-||-  <-||- 

		 -||-> Assert-NotNull $createdParentZone <-||- 
		 -||-> Assert-NotNull $createdParentZone.Etag <-||- 
		 -||-> Assert-AreEqual $parentZoneName $createdParentZone.Name <-||- 
		 -||-> Assert-AreEqual $resourceGroup.ResourceGroupName $createdParentZone.ResourceGroupName <-||- 
		 -||-> Assert-AreEqual 1 $createdParentZone.Tags.Count <-||- 
		 -||-> Assert-AreEqual 2 $createdParentZone.NumberOfRecordSets <-||- 
		 -||-> Assert-AreNotEqual $createdParentZone.NumberOfRecordSets $createdParentZone.MaxNumberOfRecordSets <-||- 
		 -||-> Assert-Null $createdParentZone.Type <-||- 

		
		 -||-> $childZoneNamePrefix =  -||-> Get-RandomZoneName <-||-  <-||- 
		 -||-> $childZoneName = $childZoneNamePrefix + '.' + $parentZoneName <-||- 
		 -||-> $createdChildZone =  -||-> New-AzDnsZone -Name $childZoneName -ResourceGroupName $resourceGroup.ResourceGroupName -Tags @{tag1= -||-> "value1" <-||- } -ParentZoneName $parentZoneName <-||-  <-||- 

		 -||-> Assert-NotNull $createdChildZone <-||- 
		 -||-> Assert-NotNull $createdChildZone.Etag <-||- 
		 -||-> Assert-AreEqual $childZoneName $createdChildZone.Name <-||- 
		 -||-> Assert-AreEqual $resourceGroup.ResourceGroupName $createdChildZone.ResourceGroupName <-||- 
		 -||-> Assert-AreEqual 1 $createdChildZone.Tags.Count <-||- 
		 -||-> Assert-AreEqual 2 $createdChildZone.NumberOfRecordSets <-||- 
		 -||-> Assert-AreNotEqual $createdChildZone.NumberOfRecordSets $createdChildZone.MaxNumberOfRecordSets <-||- 
		 -||-> Assert-Null $createdChildZone.Type <-||- 

		
		 -||-> $delegationRecordSet =  -||-> Get-AzDnsRecordSet -Name $childZoneNamePrefix -RecordType NS -ZoneName $parentZoneName -ResourceGroupName $resourceGroup.ResourceGroupName <-||-  <-||- 
	
		 -||-> Assert-NotNull $delegationRecordSet <-||- 
		 -||-> Assert-NotNull $delegationRecordSet.Records <-||- 
		 -||-> Assert-AreEqual $createdChildZone.NameServers.Count $delegationRecordSet.Records.Count <-||- 

		
		 -||-> $removedParent =  -||-> Remove-AzDnsZone -Name $parentZoneName -ResourceGroupName $resourceGroup.ResourceGroupName -PassThru -Confirm:$false <-||-  <-||- 
		 -||-> $removedChild =  -||-> Remove-AzDnsZone -Name $childZoneName -ResourceGroupName $resourceGroup.ResourceGroupName -PassThru -Confirm:$false <-||-  <-||- 

		 -||-> Assert-True {  -||-> $removedParent <-||-  } <-||- 
		 -||-> Assert-True {  -||-> $removedChild <-||-  } <-||- 

		 -||-> Assert-Throws {  -||-> Get-AzDnsZone -Name $parentZoneName -ResourceGroupName $resourceGroup.ResourceGroupName <-||-  } <-||- 
		 -||-> Assert-Throws {  -||-> Get-AzDnsZone -Name $childZoneName -ResourceGroupName $resourceGroup.ResourceGroupName <-||-  } <-||- 
    }
    finally
    {
         -||-> Remove-AzResourceGroup -Name $resourceGroup.ResourceGroupName -Force <-||- 
    } <-||- 
} <-||- 

 -||-> function Test-PrivateZoneCrud
{
	 -||-> $zoneName =  -||-> Get-RandomZoneName <-||-  <-||- 
     -||-> $resourceGroup =  -||-> TestSetup-CreateResourceGroup <-||-  <-||- 
	 -||-> $regVirtualNetwork =  -||-> TestSetup-CreateVirtualNetwork $resourceGroup <-||-  <-||- 
	 -||-> $resVirtualNetwork =  -||-> TestSetup-CreateVirtualNetwork $resourceGroup <-||-  <-||- 

	 -||-> $createdZone =  -||-> New-AzDnsZone -Name $zoneName -ResourceGroupName $resourceGroup.ResourceGroupName -Tags @{tag1= -||-> "value1" <-||- } -ZoneType Private -RegistrationVirtualNetworkId @( -||-> $regVirtualNetwork.Id <-||- ) -ResolutionVirtualNetworkId @( -||-> $resVirtualNetwork.Id <-||- ) <-||-  <-||- 
	 -||-> Assert-NotNull $createdZone <-||- 
	 -||-> Assert-NotNull $createdZone.Etag <-||- 
	 -||-> Assert-AreEqual $zoneName $createdZone.Name <-||- 
	 -||-> Assert-AreEqual $resourceGroup.ResourceGroupName $createdZone.ResourceGroupName <-||- 
	 -||-> Assert-AreEqual 1 $createdZone.Tags.Count <-||- 
	 -||-> Assert-AreEqual 1 $createdZone.NumberOfRecordSets <-||- 
	 -||-> Assert-AreNotEqual $createdZone.NumberOfRecordSets $createdZone.MaxNumberOfRecordSets <-||- 
	 -||-> Assert-AreEqual Private $createdZone.ZoneType <-||- 
	 -||-> Assert-AreEqual 1 $createdZone.RegistrationVirtualNetworkIds.Count <-||- 
	 -||-> Assert-AreEqual $regVirtualNetwork.Id $createdZone.RegistrationVirtualNetworkIds[0] <-||- 
	 -||-> Assert-AreEqual 1 $createdZone.ResolutionVirtualNetworkIds.Count <-||- 
	 -||-> Assert-AreEqual $resVirtualNetwork.Id $createdZone.ResolutionVirtualNetworkIds[0] <-||- 

	 -||-> $retrievedZone =  -||-> Get-AzDnsZone -Name $zoneName -ResourceGroupName $resourceGroup.ResourceGroupName <-||-  <-||- 
	 -||-> Assert-NotNull $retrievedZone <-||- 
	 -||-> Assert-NotNull $retrievedZone.Etag <-||- 
	 -||-> Assert-AreEqual $zoneName $retrievedZone.Name <-||- 
	 -||-> Assert-AreEqual $resourceGroup.ResourceGroupName $retrievedZone.ResourceGroupName <-||- 
	 -||-> Assert-AreEqual $retrievedZone.Etag $createdZone.Etag <-||- 
	 -||-> Assert-AreEqual 1 $retrievedZone.Tags.Count <-||- 
	 -||-> Assert-AreEqual $createdZone.NumberOfRecordSets $retrievedZone.NumberOfRecordSets <-||- 
	 -||-> Assert-AreEqual Private $retrievedZone.ZoneType <-||- 
	 -||-> Assert-AreEqual $createdZone.RegistrationVirtualNetworkIds.Count $retrievedZone.RegistrationVirtualNetworkIds.Count <-||- 
	 -||-> Assert-AreEqual $createdZone.RegistrationVirtualNetworkIds[0] $retrievedZone.RegistrationVirtualNetworkIds[0] <-||- 
	 -||-> Assert-AreEqual $createdZone.ResolutionVirtualNetworkIds.Count $retrievedZone.ResolutionVirtualNetworkIds.Count <-||- 
	 -||-> Assert-AreEqual $createdZone.ResolutionVirtualNetworkIds[0] $retrievedZone.ResolutionVirtualNetworkIds[0] <-||- 
	
	

	 -||-> $updatedZone =  -||-> Set-AzDnsZone -Name $zoneName -ResourceGroupName $resourceGroup.ResourceGroupName -Tags @{tag1= -||-> "value1" <-||- ;tag2= -||-> "value2" <-||- } -RegistrationVirtualNetworkId @() -ResolutionVirtualNetworkId @() <-||-  <-||- 
	 -||-> Assert-NotNull $updatedZone <-||- 
	 -||-> Assert-NotNull $updatedZone.Etag <-||- 
	 -||-> Assert-AreEqual $zoneName $updatedZone.Name <-||- 
	 -||-> Assert-AreEqual $resourceGroup.ResourceGroupName $updatedZone.ResourceGroupName <-||- 
	 -||-> Assert-AreNotEqual $updatedZone.Etag $createdZone.Etag <-||- 
	 -||-> Assert-AreEqual 2 $updatedZone.Tags.Count <-||- 
	 -||-> Assert-AreEqual Private $updatedZone.ZoneType <-||- 
	 -||-> Assert-AreEqual 0 $updatedZone.RegistrationVirtualNetworkIds.Count <-||- 
	 -||-> Assert-AreEqual 0 $updatedZone.ResolutionVirtualNetworkIds.Count <-||- 

	 -||-> $updatedZone.RegistrationVirtualNetworkIds = @( -||-> $regVirtualNetwork.Id <-||- ) <-||- 
	 -||-> $updatedZone.ResolutionVirtualNetworkIds = @( -||-> $resVirtualNetwork.Id <-||- ) <-||- 
	 -||-> $updatedZone =  -||-> $updatedZone | Set-AzDnsZone <-||-  <-||- 
	 -||-> Assert-NotNull $updatedZone <-||- 
	 -||-> Assert-NotNull $updatedZone.Etag <-||- 
	 -||-> Assert-AreEqual $zoneName $updatedZone.Name <-||- 
	 -||-> Assert-AreEqual $resourceGroup.ResourceGroupName $updatedZone.ResourceGroupName <-||- 
	 -||-> Assert-AreNotEqual $updatedZone.Etag $createdZone.Etag <-||- 
	 -||-> Assert-AreEqual 2 $updatedZone.Tags.Count <-||- 
	 -||-> Assert-AreEqual Private $updatedZone.ZoneType <-||- 
	 -||-> Assert-AreEqual 1 $updatedZone.RegistrationVirtualNetworkIds.Count <-||- 
	 -||-> Assert-AreEqual $regVirtualNetwork.Id $updatedZone.RegistrationVirtualNetworkIds[0] <-||- 
	 -||-> Assert-AreEqual 1 $updatedZone.ResolutionVirtualNetworkIds.Count <-||- 
	 -||-> Assert-AreEqual $resVirtualNetwork.Id $updatedZone.ResolutionVirtualNetworkIds[0] <-||- 

	 -||-> $retrievedZone =  -||-> Get-AzDnsZone -Name $zoneName -ResourceGroupName $resourceGroup.ResourceGroupName <-||-  <-||- 
	 -||-> Assert-NotNull $retrievedZone <-||- 
	 -||-> Assert-NotNull $retrievedZone.Etag <-||- 
	 -||-> Assert-AreEqual $zoneName $retrievedZone.Name <-||- 
	 -||-> Assert-AreEqual $resourceGroup.ResourceGroupName $retrievedZone.ResourceGroupName <-||- 
	 -||-> Assert-AreEqual $retrievedZone.Etag $updatedZone.Etag <-||- 
	 -||-> Assert-AreEqual 2 $retrievedZone.Tags.Count <-||- 
	 -||-> Assert-AreEqual Private $retrievedZone.ZoneType <-||- 
	 -||-> Assert-AreEqual $updatedZone.RegistrationVirtualNetworkIds.Count $retrievedZone.RegistrationVirtualNetworkIds.Count <-||- 
	 -||-> Assert-AreEqual $updatedZone.RegistrationVirtualNetworkIds[0] $retrievedZone.RegistrationVirtualNetworkIds[0] <-||- 
	 -||-> Assert-AreEqual $updatedZone.ResolutionVirtualNetworkIds.Count $retrievedZone.ResolutionVirtualNetworkIds.Count <-||- 
	 -||-> Assert-AreEqual $updatedZone.ResolutionVirtualNetworkIds[0] $retrievedZone.ResolutionVirtualNetworkIds[0] <-||- 

	 -||-> $removed =  -||-> Remove-AzDnsZone -Name $zoneName -ResourceGroupName $resourceGroup.ResourceGroupName -PassThru -Confirm:$false <-||-  <-||- 

	 -||-> Assert-True {  -||-> $removed <-||-  } <-||- 

	 -||-> Assert-Throws {  -||-> Get-AzDnsZone -Name $zoneName -ResourceGroupName $resourceGroup.ResourceGroupName <-||-  } <-||- 
	 -||-> Remove-AzResourceGroup -Name $resourceGroup.ResourceGroupName -Force <-||- 
} <-||- 


 -||-> function Test-PrivateZoneCrudRegistrationVnet
{
	 -||-> $zoneName =  -||-> Get-RandomZoneName <-||-  <-||- 
     -||-> $resourceGroup =  -||-> TestSetup-CreateResourceGroup <-||-  <-||- 
	 -||-> $regVirtualNetwork =  -||-> TestSetup-CreateVirtualNetwork $resourceGroup <-||-  <-||- 

	 -||-> $createdZone =  -||-> New-AzDnsZone -Name $zoneName -ResourceGroupName $resourceGroup.ResourceGroupName -Tags @{tag1= -||-> "value1" <-||- } -ZoneType Private -RegistrationVirtualNetworkId @( -||-> $regVirtualNetwork.Id <-||- ) <-||-  <-||- 
	 -||-> Assert-NotNull $createdZone <-||- 
	 -||-> Assert-NotNull $createdZone.Etag <-||- 
	 -||-> Assert-AreEqual $zoneName $createdZone.Name <-||- 
	 -||-> Assert-AreEqual $resourceGroup.ResourceGroupName $createdZone.ResourceGroupName <-||- 
	 -||-> Assert-AreEqual 1 $createdZone.Tags.Count <-||- 
	 -||-> Assert-AreEqual 1 $createdZone.NumberOfRecordSets <-||- 
	 -||-> Assert-AreNotEqual $createdZone.NumberOfRecordSets $createdZone.MaxNumberOfRecordSets <-||- 
	 -||-> Assert-AreEqual Private $createdZone.ZoneType <-||- 
	 -||-> Assert-AreEqual 1 $createdZone.RegistrationVirtualNetworkIds.Count <-||- 
	 -||-> Assert-AreEqual $regVirtualNetwork.Id $createdZone.RegistrationVirtualNetworkIds[0] <-||- 
	 -||-> Assert-AreEqual 0 $createdZone.ResolutionVirtualNetworkIds.Count <-||- 

	 -||-> $retrievedZone =  -||-> Get-AzDnsZone -Name $zoneName -ResourceGroupName $resourceGroup.ResourceGroupName <-||-  <-||- 
	 -||-> Assert-NotNull $retrievedZone <-||- 
	 -||-> Assert-NotNull $retrievedZone.Etag <-||- 
	 -||-> Assert-AreEqual $zoneName $retrievedZone.Name <-||- 
	 -||-> Assert-AreEqual $resourceGroup.ResourceGroupName $retrievedZone.ResourceGroupName <-||- 
	 -||-> Assert-AreEqual $retrievedZone.Etag $createdZone.Etag <-||- 
	 -||-> Assert-AreEqual 1 $retrievedZone.Tags.Count <-||- 
	 -||-> Assert-AreEqual $createdZone.NumberOfRecordSets $retrievedZone.NumberOfRecordSets <-||- 
	 -||-> Assert-AreEqual Private $retrievedZone.ZoneType <-||- 
	 -||-> Assert-AreEqual $createdZone.RegistrationVirtualNetworkIds.Count $retrievedZone.RegistrationVirtualNetworkIds.Count <-||- 
	 -||-> Assert-AreEqual $createdZone.RegistrationVirtualNetworkIds[0] $retrievedZone.RegistrationVirtualNetworkIds[0] <-||- 
	 -||-> Assert-AreEqual $createdZone.ResolutionVirtualNetworkIds.Count $retrievedZone.ResolutionVirtualNetworkIds.Count <-||- 
	
	

	 -||-> $updatedZone =  -||-> Set-AzDnsZone -Name $zoneName -ResourceGroupName $resourceGroup.ResourceGroupName -Tags @{tag1= -||-> "value1" <-||- ;tag2= -||-> "value2" <-||- } -RegistrationVirtualNetworkId @() <-||-  <-||- 
	 -||-> Assert-NotNull $updatedZone <-||- 
	 -||-> Assert-NotNull $updatedZone.Etag <-||- 
	 -||-> Assert-AreEqual $zoneName $updatedZone.Name <-||- 
	 -||-> Assert-AreEqual $resourceGroup.ResourceGroupName $updatedZone.ResourceGroupName <-||- 
	 -||-> Assert-AreNotEqual $updatedZone.Etag $createdZone.Etag <-||- 
	 -||-> Assert-AreEqual 2 $updatedZone.Tags.Count <-||- 
	 -||-> Assert-AreEqual Private $updatedZone.ZoneType <-||- 
	 -||-> Assert-AreEqual 0 $updatedZone.RegistrationVirtualNetworkIds.Count <-||- 
	 -||-> Assert-AreEqual 0 $updatedZone.ResolutionVirtualNetworkIds.Count <-||- 

	 -||-> $updatedZone.RegistrationVirtualNetworkIds = @( -||-> $regVirtualNetwork.Id <-||- ) <-||- 
	 -||-> $updatedZone =  -||-> $updatedZone | Set-AzDnsZone <-||-  <-||- 
	 -||-> Assert-NotNull $updatedZone <-||- 
	 -||-> Assert-NotNull $updatedZone.Etag <-||- 
	 -||-> Assert-AreEqual $zoneName $updatedZone.Name <-||- 
	 -||-> Assert-AreEqual $resourceGroup.ResourceGroupName $updatedZone.ResourceGroupName <-||- 
	 -||-> Assert-AreNotEqual $updatedZone.Etag $createdZone.Etag <-||- 
	 -||-> Assert-AreEqual 2 $updatedZone.Tags.Count <-||- 
	 -||-> Assert-AreEqual Private $updatedZone.ZoneType <-||- 
	 -||-> Assert-AreEqual 1 $updatedZone.RegistrationVirtualNetworkIds.Count <-||- 
	 -||-> Assert-AreEqual $regVirtualNetwork.Id $updatedZone.RegistrationVirtualNetworkIds[0] <-||- 
	 -||-> Assert-AreEqual 0 $updatedZone.ResolutionVirtualNetworkIds.Count <-||- 

	 -||-> $retrievedZone =  -||-> Get-AzDnsZone -Name $zoneName -ResourceGroupName $resourceGroup.ResourceGroupName <-||-  <-||- 
	 -||-> Assert-NotNull $retrievedZone <-||- 
	 -||-> Assert-NotNull $retrievedZone.Etag <-||- 
	 -||-> Assert-AreEqual $zoneName $retrievedZone.Name <-||- 
	 -||-> Assert-AreEqual $resourceGroup.ResourceGroupName $retrievedZone.ResourceGroupName <-||- 
	 -||-> Assert-AreEqual $retrievedZone.Etag $updatedZone.Etag <-||- 
	 -||-> Assert-AreEqual 2 $retrievedZone.Tags.Count <-||- 
	 -||-> Assert-AreEqual Private $retrievedZone.ZoneType <-||- 
	 -||-> Assert-AreEqual $updatedZone.RegistrationVirtualNetworkIds.Count $retrievedZone.RegistrationVirtualNetworkIds.Count <-||- 
	 -||-> Assert-AreEqual $updatedZone.RegistrationVirtualNetworkIds[0] $retrievedZone.RegistrationVirtualNetworkIds[0] <-||- 
	 -||-> Assert-AreEqual $updatedZone.ResolutionVirtualNetworkIds.Count $retrievedZone.ResolutionVirtualNetworkIds.Count <-||- 

	 -||-> $removed =  -||-> Remove-AzDnsZone -Name $zoneName -ResourceGroupName $resourceGroup.ResourceGroupName -PassThru -Confirm:$false <-||-  <-||- 

	 -||-> Assert-True {  -||-> $removed <-||-  } <-||- 

	 -||-> Assert-Throws {  -||-> Get-AzDnsZone -Name $zoneName -ResourceGroupName $resourceGroup.ResourceGroupName <-||-  } <-||- 
	 -||-> Remove-AzResourceGroup -Name $resourceGroup.ResourceGroupName -Force <-||- 
} <-||- 


 -||-> function Test-PrivateZoneCrudResolutionVnet
{
	 -||-> $zoneName =  -||-> Get-RandomZoneName <-||-  <-||- 
     -||-> $resourceGroup =  -||-> TestSetup-CreateResourceGroup <-||-  <-||- 
	 -||-> $resVirtualNetwork =  -||-> TestSetup-CreateVirtualNetwork $resourceGroup <-||-  <-||- 

	 -||-> $createdZone =  -||-> New-AzDnsZone -Name $zoneName -ResourceGroupName $resourceGroup.ResourceGroupName -Tags @{tag1= -||-> "value1" <-||- } -ZoneType Private -ResolutionVirtualNetworkId @( -||-> $resVirtualNetwork.Id <-||- ) <-||-  <-||- 
	 -||-> Assert-NotNull $createdZone <-||- 
	 -||-> Assert-NotNull $createdZone.Etag <-||- 
	 -||-> Assert-AreEqual $zoneName $createdZone.Name <-||- 
	 -||-> Assert-AreEqual $resourceGroup.ResourceGroupName $createdZone.ResourceGroupName <-||- 
	 -||-> Assert-AreEqual 1 $createdZone.Tags.Count <-||- 
	 -||-> Assert-AreEqual 1 $createdZone.NumberOfRecordSets <-||- 
	 -||-> Assert-AreNotEqual $createdZone.NumberOfRecordSets $createdZone.MaxNumberOfRecordSets <-||- 
	 -||-> Assert-AreEqual Private $createdZone.ZoneType <-||- 
	 -||-> Assert-AreEqual 0 $createdZone.RegistrationVirtualNetworkIds.Count <-||- 
	 -||-> Assert-AreEqual 1 $createdZone.ResolutionVirtualNetworkIds.Count <-||- 
	 -||-> Assert-AreEqual $resVirtualNetwork.Id $createdZone.ResolutionVirtualNetworkIds[0] <-||- 

	 -||-> $retrievedZone =  -||-> Get-AzDnsZone -Name $zoneName -ResourceGroupName $resourceGroup.ResourceGroupName <-||-  <-||- 
	 -||-> Assert-NotNull $retrievedZone <-||- 
	 -||-> Assert-NotNull $retrievedZone.Etag <-||- 
	 -||-> Assert-AreEqual $zoneName $retrievedZone.Name <-||- 
	 -||-> Assert-AreEqual $resourceGroup.ResourceGroupName $retrievedZone.ResourceGroupName <-||- 
	 -||-> Assert-AreEqual $retrievedZone.Etag $createdZone.Etag <-||- 
	 -||-> Assert-AreEqual 1 $retrievedZone.Tags.Count <-||- 
	 -||-> Assert-AreEqual $createdZone.NumberOfRecordSets $retrievedZone.NumberOfRecordSets <-||- 
	 -||-> Assert-AreEqual Private $retrievedZone.ZoneType <-||- 
	 -||-> Assert-AreEqual $createdZone.RegistrationVirtualNetworkIds.Count $retrievedZone.RegistrationVirtualNetworkIds.Count <-||- 
	 -||-> Assert-AreEqual $createdZone.ResolutionVirtualNetworkIds.Count $retrievedZone.ResolutionVirtualNetworkIds.Count <-||- 
	 -||-> Assert-AreEqual $createdZone.ResolutionVirtualNetworkIds[0] $retrievedZone.ResolutionVirtualNetworkIds[0] <-||- 
	
	

	 -||-> $updatedZone =  -||-> Set-AzDnsZone -Name $zoneName -ResourceGroupName $resourceGroup.ResourceGroupName -Tags @{tag1= -||-> "value1" <-||- ;tag2= -||-> "value2" <-||- } -ResolutionVirtualNetworkId @() <-||-  <-||- 
	 -||-> Assert-NotNull $updatedZone <-||- 
	 -||-> Assert-NotNull $updatedZone.Etag <-||- 
	 -||-> Assert-AreEqual $zoneName $updatedZone.Name <-||- 
	 -||-> Assert-AreEqual $resourceGroup.ResourceGroupName $updatedZone.ResourceGroupName <-||- 
	 -||-> Assert-AreNotEqual $updatedZone.Etag $createdZone.Etag <-||- 
	 -||-> Assert-AreEqual 2 $updatedZone.Tags.Count <-||- 
	 -||-> Assert-AreEqual Private $updatedZone.ZoneType <-||- 
	 -||-> Assert-AreEqual 0 $updatedZone.RegistrationVirtualNetworkIds.Count <-||- 
	 -||-> Assert-AreEqual 0 $updatedZone.ResolutionVirtualNetworkIds.Count <-||- 

	 -||-> $updatedZone.ResolutionVirtualNetworkIds = @( -||-> $resVirtualNetwork.Id <-||- ) <-||- 
	 -||-> $updatedZone =  -||-> $updatedZone | Set-AzDnsZone <-||-  <-||- 
	 -||-> Assert-NotNull $updatedZone <-||- 
	 -||-> Assert-NotNull $updatedZone.Etag <-||- 
	 -||-> Assert-AreEqual $zoneName $updatedZone.Name <-||- 
	 -||-> Assert-AreEqual $resourceGroup.ResourceGroupName $updatedZone.ResourceGroupName <-||- 
	 -||-> Assert-AreNotEqual $updatedZone.Etag $createdZone.Etag <-||- 
	 -||-> Assert-AreEqual 2 $updatedZone.Tags.Count <-||- 
	 -||-> Assert-AreEqual Private $updatedZone.ZoneType <-||- 
	 -||-> Assert-AreEqual 0 $updatedZone.RegistrationVirtualNetworkIds.Count <-||- 
	 -||-> Assert-AreEqual 1 $updatedZone.ResolutionVirtualNetworkIds.Count <-||- 
	 -||-> Assert-AreEqual $resVirtualNetwork.Id $updatedZone.ResolutionVirtualNetworkIds[0] <-||- 

	 -||-> $retrievedZone =  -||-> Get-AzDnsZone -Name $zoneName -ResourceGroupName $resourceGroup.ResourceGroupName <-||-  <-||- 
	 -||-> Assert-NotNull $retrievedZone <-||- 
	 -||-> Assert-NotNull $retrievedZone.Etag <-||- 
	 -||-> Assert-AreEqual $zoneName $retrievedZone.Name <-||- 
	 -||-> Assert-AreEqual $resourceGroup.ResourceGroupName $retrievedZone.ResourceGroupName <-||- 
	 -||-> Assert-AreEqual $retrievedZone.Etag $updatedZone.Etag <-||- 
	 -||-> Assert-AreEqual 2 $retrievedZone.Tags.Count <-||- 
	 -||-> Assert-AreEqual Private $retrievedZone.ZoneType <-||- 
	 -||-> Assert-AreEqual $updatedZone.RegistrationVirtualNetworkIds.Count $retrievedZone.RegistrationVirtualNetworkIds.Count <-||- 
	 -||-> Assert-AreEqual $updatedZone.ResolutionVirtualNetworkIds.Count $retrievedZone.ResolutionVirtualNetworkIds.Count <-||- 
	 -||-> Assert-AreEqual $updatedZone.ResolutionVirtualNetworkIds[0] $retrievedZone.ResolutionVirtualNetworkIds[0] <-||- 

	 -||-> $removed =  -||-> Remove-AzDnsZone -Name $zoneName -ResourceGroupName $resourceGroup.ResourceGroupName -PassThru -Confirm:$false <-||-  <-||- 

	 -||-> Assert-True {  -||-> $removed <-||-  } <-||- 

	 -||-> Assert-Throws {  -||-> Get-AzDnsZone -Name $zoneName -ResourceGroupName $resourceGroup.ResourceGroupName <-||-  } <-||- 
	 -||-> Remove-AzResourceGroup -Name $resourceGroup.ResourceGroupName -Force <-||- 
} <-||- 


 -||-> function Test-PrivateZoneCrudByVirtualNetworkIds
{
	 -||-> $zoneName =  -||-> Get-RandomZoneName <-||-  <-||- 
     -||-> $resourceGroup =  -||-> TestSetup-CreateResourceGroup <-||-  <-||- 
	 -||-> $regVirtualNetwork =  -||-> TestSetup-CreateVirtualNetwork $resourceGroup <-||-  <-||- 
	 -||-> $resVirtualNetwork =  -||-> TestSetup-CreateVirtualNetwork $resourceGroup <-||-  <-||- 

	 -||-> $createdZone =  -||-> New-AzDnsZone -Name $zoneName -ResourceGroupName $resourceGroup.ResourceGroupName -Tags @{tag1= -||-> "value1" <-||- } -ZoneType Private -RegistrationVirtualNetworkId @( -||-> $regVirtualNetwork.Id <-||- ) -ResolutionVirtualNetworkId @( -||-> $resVirtualNetwork.Id <-||- ) <-||-  <-||- 
	 -||-> Assert-NotNull $createdZone <-||- 
	 -||-> Assert-NotNull $createdZone.Etag <-||- 
	 -||-> Assert-AreEqual $zoneName $createdZone.Name <-||- 
	 -||-> Assert-AreEqual $resourceGroup.ResourceGroupName $createdZone.ResourceGroupName <-||- 
	 -||-> Assert-AreEqual 1 $createdZone.Tags.Count <-||- 
	 -||-> Assert-AreEqual 1 $createdZone.NumberOfRecordSets <-||- 
	 -||-> Assert-AreNotEqual $createdZone.NumberOfRecordSets $createdZone.MaxNumberOfRecordSets <-||- 
	 -||-> Assert-AreEqual Private $createdZone.ZoneType <-||- 
	 -||-> Assert-AreEqual 1 $createdZone.RegistrationVirtualNetworkIds.Count <-||- 
	 -||-> Assert-AreEqual $regVirtualNetwork.Id $createdZone.RegistrationVirtualNetworkIds[0] <-||- 
	 -||-> Assert-AreEqual 1 $createdZone.ResolutionVirtualNetworkIds.Count <-||- 
	 -||-> Assert-AreEqual $resVirtualNetwork.Id $createdZone.ResolutionVirtualNetworkIds[0] <-||- 

	 -||-> $updatedZone =  -||-> Set-AzDnsZone -Name $zoneName -ResourceGroupName $resourceGroup.ResourceGroupName -Tags @{tag1= -||-> "value1" <-||- ;tag2= -||-> "value2" <-||- } -RegistrationVirtualNetworkId @() -ResolutionVirtualNetworkId @() <-||-  <-||- 
	 -||-> Assert-NotNull $updatedZone <-||- 
	 -||-> Assert-NotNull $updatedZone.Etag <-||- 
	 -||-> Assert-AreEqual $zoneName $updatedZone.Name <-||- 
	 -||-> Assert-AreEqual $resourceGroup.ResourceGroupName $updatedZone.ResourceGroupName <-||- 
	 -||-> Assert-AreNotEqual $updatedZone.Etag $createdZone.Etag <-||- 
	 -||-> Assert-AreEqual 2 $updatedZone.Tags.Count <-||- 
	 -||-> Assert-AreEqual Private $updatedZone.ZoneType <-||- 
	 -||-> Assert-AreEqual 0 $updatedZone.RegistrationVirtualNetworkIds.Count <-||- 
	 -||-> Assert-AreEqual 0 $updatedZone.ResolutionVirtualNetworkIds.Count <-||- 

	 -||-> $updatedZone =  -||-> Set-AzDnsZone -Name $zoneName -ResourceGroupName $resourceGroup.ResourceGroupName -Tags @{tag1= -||-> "value1" <-||- ;tag2= -||-> "value2" <-||- ;tag3= -||-> "value3" <-||- } -RegistrationVirtualNetworkId @( -||-> $regVirtualNetwork.Id <-||- ) -ResolutionVirtualNetworkId @( -||-> $resVirtualNetwork.Id <-||- ) <-||-  <-||- 
	 -||-> Assert-NotNull $updatedZone <-||- 
	 -||-> Assert-NotNull $updatedZone.Etag <-||- 
	 -||-> Assert-AreEqual $zoneName $updatedZone.Name <-||- 
	 -||-> Assert-AreEqual $resourceGroup.ResourceGroupName $updatedZone.ResourceGroupName <-||- 
	 -||-> Assert-AreNotEqual $updatedZone.Etag $createdZone.Etag <-||- 
	 -||-> Assert-AreEqual 3 $updatedZone.Tags.Count <-||- 
	 -||-> Assert-AreEqual Private $updatedZone.ZoneType <-||- 
	 -||-> Assert-AreEqual 1 $updatedZone.RegistrationVirtualNetworkIds.Count <-||- 
	 -||-> Assert-AreEqual $regVirtualNetwork.Id $updatedZone.RegistrationVirtualNetworkIds[0] <-||- 
	 -||-> Assert-AreEqual 1 $updatedZone.ResolutionVirtualNetworkIds.Count <-||- 
	 -||-> Assert-AreEqual $resVirtualNetwork.Id $updatedZone.ResolutionVirtualNetworkIds[0] <-||- 

	 -||-> $updatedZone.RegistrationVirtualNetworkIds = @() <-||- 
	 -||-> $updatedZone.ResolutionVirtualNetworkIds = @() <-||- 
	 -||-> $updatedZone =  -||-> $updatedZone | Set-AzDnsZone <-||-  <-||- 
	 -||-> Assert-NotNull $updatedZone <-||- 
	 -||-> Assert-NotNull $updatedZone.Etag <-||- 
	 -||-> Assert-AreEqual $zoneName $updatedZone.Name <-||- 
	 -||-> Assert-AreEqual $resourceGroup.ResourceGroupName $updatedZone.ResourceGroupName <-||- 
	 -||-> Assert-AreNotEqual $updatedZone.Etag $createdZone.Etag <-||- 
	 -||-> Assert-AreEqual 3 $updatedZone.Tags.Count <-||- 
	 -||-> Assert-AreEqual Private $updatedZone.ZoneType <-||- 
	 -||-> Assert-AreEqual 0 $updatedZone.RegistrationVirtualNetworkIds.Count <-||- 
	 -||-> Assert-AreEqual 0 $updatedZone.ResolutionVirtualNetworkIds.Count <-||- 

	 -||-> $removed =  -||-> Remove-AzDnsZone -Name $zoneName -ResourceGroupName $resourceGroup.ResourceGroupName -PassThru -Confirm:$false <-||-  <-||- 

	 -||-> Assert-True {  -||-> $removed <-||-  } <-||- 

	 -||-> Assert-Throws {  -||-> Get-AzDnsZone -Name $zoneName -ResourceGroupName $resourceGroup.ResourceGroupName <-||-  } <-||- 
	 -||-> Remove-AzResourceGroup -Name $resourceGroup.ResourceGroupName -Force <-||- 
} <-||- 


 -||-> function Test-PrivateZoneCrudByVirtualNetworkObjects
{
	 -||-> $zoneName =  -||-> Get-RandomZoneName <-||-  <-||- 
     -||-> $resourceGroup =  -||-> TestSetup-CreateResourceGroup <-||-  <-||- 
	 -||-> $regVirtualNetwork =  -||-> TestSetup-CreateVirtualNetwork $resourceGroup <-||-  <-||- 
	 -||-> $resVirtualNetwork =  -||-> TestSetup-CreateVirtualNetwork $resourceGroup <-||-  <-||- 

	 -||-> $createdZone =  -||-> New-AzDnsZone -Name $zoneName -ResourceGroupName $resourceGroup.ResourceGroupName -Tags @{tag1= -||-> "value1" <-||- } -ZoneType Private -RegistrationVirtualNetwork @( -||-> $regVirtualNetwork <-||- ) -ResolutionVirtualNetwork @( -||-> $resVirtualNetwork <-||- ) <-||-  <-||- 
	 -||-> Assert-NotNull $createdZone <-||- 
	 -||-> Assert-NotNull $createdZone.Etag <-||- 
	 -||-> Assert-AreEqual $zoneName $createdZone.Name <-||- 
	 -||-> Assert-AreEqual $resourceGroup.ResourceGroupName $createdZone.ResourceGroupName <-||- 
	 -||-> Assert-AreEqual 1 $createdZone.Tags.Count <-||- 
	 -||-> Assert-AreEqual 1 $createdZone.NumberOfRecordSets <-||- 
	 -||-> Assert-AreNotEqual $createdZone.NumberOfRecordSets $createdZone.MaxNumberOfRecordSets <-||- 
	 -||-> Assert-AreEqual Private $createdZone.ZoneType <-||- 
	 -||-> Assert-AreEqual 1 $createdZone.RegistrationVirtualNetworkIds.Count <-||- 
	 -||-> Assert-AreEqual $regVirtualNetwork.Id $createdZone.RegistrationVirtualNetworkIds[0] <-||- 
	 -||-> Assert-AreEqual 1 $createdZone.ResolutionVirtualNetworkIds.Count <-||- 
	 -||-> Assert-AreEqual $resVirtualNetwork.Id $createdZone.ResolutionVirtualNetworkIds[0] <-||- 

	 -||-> $updatedZone =  -||-> Set-AzDnsZone -Name $zoneName -ResourceGroupName $resourceGroup.ResourceGroupName -Tags @{tag1= -||-> "value1" <-||- ;tag2= -||-> "value2" <-||- } -RegistrationVirtualNetwork @() -ResolutionVirtualNetwork @() <-||-  <-||- 
	 -||-> Assert-NotNull $updatedZone <-||- 
	 -||-> Assert-NotNull $updatedZone.Etag <-||- 
	 -||-> Assert-AreEqual $zoneName $updatedZone.Name <-||- 
	 -||-> Assert-AreEqual $resourceGroup.ResourceGroupName $updatedZone.ResourceGroupName <-||- 
	 -||-> Assert-AreNotEqual $updatedZone.Etag $createdZone.Etag <-||- 
	 -||-> Assert-AreEqual 2 $updatedZone.Tags.Count <-||- 
	 -||-> Assert-AreEqual Private $updatedZone.ZoneType <-||- 
	 -||-> Assert-AreEqual 0 $updatedZone.RegistrationVirtualNetworkIds.Count <-||- 
	 -||-> Assert-AreEqual 0 $updatedZone.ResolutionVirtualNetworkIds.Count <-||- 

	 -||-> $updatedZone =  -||-> Set-AzDnsZone -Name $zoneName -ResourceGroupName $resourceGroup.ResourceGroupName -Tags @{tag1= -||-> "value1" <-||- ;tag2= -||-> "value2" <-||- ;tag3= -||-> "value3" <-||- } -RegistrationVirtualNetwork @( -||-> $regVirtualNetwork <-||- ) -ResolutionVirtualNetwork @( -||-> $resVirtualNetwork <-||- ) <-||-  <-||- 
	 -||-> Assert-NotNull $updatedZone <-||- 
	 -||-> Assert-NotNull $updatedZone.Etag <-||- 
	 -||-> Assert-AreEqual $zoneName $updatedZone.Name <-||- 
	 -||-> Assert-AreEqual $resourceGroup.ResourceGroupName $updatedZone.ResourceGroupName <-||- 
	 -||-> Assert-AreNotEqual $updatedZone.Etag $createdZone.Etag <-||- 
	 -||-> Assert-AreEqual 3 $updatedZone.Tags.Count <-||- 
	 -||-> Assert-AreEqual Private $updatedZone.ZoneType <-||- 
	 -||-> Assert-AreEqual 1 $updatedZone.RegistrationVirtualNetworkIds.Count <-||- 
	 -||-> Assert-AreEqual $regVirtualNetwork.Id $updatedZone.RegistrationVirtualNetworkIds[0] <-||- 
	 -||-> Assert-AreEqual 1 $updatedZone.ResolutionVirtualNetworkIds.Count <-||- 
	 -||-> Assert-AreEqual $resVirtualNetwork.Id $updatedZone.ResolutionVirtualNetworkIds[0] <-||- 

	 -||-> $updatedZone.RegistrationVirtualNetworkIds = @() <-||- 
	 -||-> $updatedZone.ResolutionVirtualNetworkIds = @() <-||- 
	 -||-> $updatedZone =  -||-> $updatedZone | Set-AzDnsZone <-||-  <-||- 
	 -||-> Assert-NotNull $updatedZone <-||- 
	 -||-> Assert-NotNull $updatedZone.Etag <-||- 
	 -||-> Assert-AreEqual $zoneName $updatedZone.Name <-||- 
	 -||-> Assert-AreEqual $resourceGroup.ResourceGroupName $updatedZone.ResourceGroupName <-||- 
	 -||-> Assert-AreNotEqual $updatedZone.Etag $createdZone.Etag <-||- 
	 -||-> Assert-AreEqual 3 $updatedZone.Tags.Count <-||- 
	 -||-> Assert-AreEqual Private $updatedZone.ZoneType <-||- 
	 -||-> Assert-AreEqual 0 $updatedZone.RegistrationVirtualNetworkIds.Count <-||- 
	 -||-> Assert-AreEqual 0 $updatedZone.ResolutionVirtualNetworkIds.Count <-||- 

	 -||-> $removed =  -||-> Remove-AzDnsZone -Name $zoneName -ResourceGroupName $resourceGroup.ResourceGroupName -PassThru -Confirm:$false <-||-  <-||- 

	 -||-> Assert-True {  -||-> $removed <-||-  } <-||- 

	 -||-> Assert-Throws {  -||-> Get-AzDnsZone -Name $zoneName -ResourceGroupName $resourceGroup.ResourceGroupName <-||-  } <-||- 
	 -||-> Remove-AzResourceGroup -Name $resourceGroup.ResourceGroupName -Force <-||- 
} <-||- 


 -||-> function Test-ZoneCrudTrimsDot
{
	 -||-> $zoneName =  -||-> Get-RandomZoneName <-||-  <-||- 
	 -||-> $zoneNameWithDot = $zoneName + "." <-||- 
     -||-> $resourceGroup =  -||-> TestSetup-CreateResourceGroup <-||-  <-||- 
	 -||-> $createdZone =  -||-> New-AzDnsZone -Name $zoneNameWithDot -ResourceGroupName $resourceGroup.ResourceGroupName <-||-  <-||- 

	 -||-> Assert-NotNull $createdZone <-||- 
	 -||-> Assert-AreEqual $zoneName $createdZone.Name <-||- 

	 -||-> $retrievedZone =  -||-> Get-AzDnsZone -Name $zoneNameWithDot -ResourceGroupName $resourceGroup.ResourceGroupName <-||-  <-||- 

	 -||-> Assert-NotNull $retrievedZone <-||- 
	 -||-> Assert-AreEqual $zoneName $retrievedZone.Name <-||- 

	 -||-> $updatedZone =  -||-> Set-AzDnsZone -Name $zoneNameWithDot -ResourceGroupName $resourceGroup.ResourceGroupName -Tags @{tag1= -||-> "value1" <-||- ;tag2= -||-> "value2" <-||- } <-||-  <-||- 

	 -||-> Assert-NotNull $updatedZone <-||- 
	 -||-> Assert-AreEqual $zoneName $updatedZone.Name <-||- 

	 -||-> $removed =  -||-> Remove-AzDnsZone -Name $zoneNameWithDot -ResourceGroupName $resourceGroup.ResourceGroupName -PassThru -Confirm:$false <-||-  <-||- 

	 -||-> Assert-True {  -||-> $removed <-||-  } <-||- 

	 -||-> Assert-Throws {  -||-> Get-AzDnsZone -Name $zoneName -ResourceGroupName $resourceGroup.ResourceGroupName <-||-  } <-||- 
	 -||-> Remove-AzResourceGroup -Name $resourceGroup.ResourceGroupName -Force <-||- 
} <-||- 


 -||-> function Test-ZoneCrudWithPiping
{
	 -||-> $zoneName =  -||-> Get-RandomZoneName <-||-  <-||- 
     -||-> $createdZone =  -||-> TestSetup-CreateResourceGroup | New-AzDnsZone -Name $zoneName -Tags @{tag1= -||-> "value1" <-||- } <-||-  <-||- 

	 -||-> $resourceGroupName = $createdZone.ResourceGroupName <-||- 

	 -||-> Assert-NotNull $createdZone <-||- 
	 -||-> Assert-NotNull $createdZone.Etag <-||- 
	 -||-> Assert-AreEqual $zoneName $createdZone.Name <-||- 
	 -||-> Assert-NotNull $createdZone.ResourceGroupName <-||- 
	 -||-> Assert-AreEqual 1 $createdZone.Tags.Count <-||- 

	 -||-> $updatedZone =  -||-> Get-AzResourceGroup -Name $resourceGroupName | Get-AzDnsZone -Name $zoneName | Set-AzDnsZone -Tags $null <-||-  <-||- 

	 -||-> Assert-NotNull $updatedZone <-||- 
	 -||-> Assert-NotNull $updatedZone.Etag <-||- 
	 -||-> Assert-AreEqual $zoneName $updatedZone.Name <-||- 
	 -||-> Assert-AreEqual $resourceGroupName $updatedZone.ResourceGroupName <-||- 
	 -||-> Assert-AreNotEqual $updatedZone.Etag $createdZone.Etag <-||- 
	 -||-> Assert-AreEqual 0 $updatedZone.Tags.Count <-||- 

	 -||-> $removed =  -||-> Get-AzDnsZone -Name $zoneName -ResourceGroupName $resourceGroupName | Remove-AzDnsZone -PassThru -Confirm:$false <-||-  <-||- 

	 -||-> Assert-True {  -||-> $removed <-||-  } <-||- 

	 -||-> Assert-Throws {  -||-> Get-AzDnsZone -Name $zoneName -ResourceGroupName $resourceGroupName <-||-  } <-||- 
	 -||-> Remove-AzResourceGroup -Name $ResourceGroupName -Force <-||- 
} <-||- 


 -||-> function Test-ZoneCrudWithPipingTrimsDot
{
	 -||-> $zoneName =  -||-> Get-RandomZoneName <-||-  <-||- 
	 -||-> $zoneNameWithDot = $zoneName + "." <-||- 
     -||-> $createdZone =  -||-> TestSetup-CreateResourceGroup | New-AzDnsZone -Name $zoneName <-||-  <-||- 

	 -||-> $resourceGroupName = $createdZone.ResourceGroupName <-||- 

	 -||-> $zoneObjectWithDot =  -||-> New-Object Microsoft.Azure.Commands.Dns.DnsZone <-||-  <-||- 
	 -||-> $zoneObjectWithDot.Name = $zoneNameWithDot <-||- 
	 -||-> $zoneObjectWithDot.ResourceGroupName = $resourceGroupName <-||- 

	 -||-> $updatedZone =  -||-> $zoneObjectWithDot | Set-AzDnsZone -Overwrite <-||-  <-||- 

	 -||-> Assert-NotNull $updatedZone <-||- 
	 -||-> Assert-AreEqual $zoneName $updatedZone.Name <-||- 

	 -||-> $removed =  -||-> $zoneObjectWithDot | Remove-AzDnsZone -Overwrite -PassThru -Confirm:$false <-||-  <-||- 

	 -||-> Assert-True {  -||-> $removed <-||-  } <-||- 

	 -||-> Assert-Throws {  -||-> Get-AzDnsZone -Name $zoneName -ResourceGroupName $resourceGroupName <-||-  } <-||- 
	 -||-> Remove-AzResourceGroup -Name $resourceGroupName -Force <-||- 
} <-||- 


 -||-> function Test-ZoneNewAlreadyExists
{
	 -||-> $zoneName =  -||-> Get-RandomZoneName <-||-  <-||- 
     -||-> $createdZone =  -||-> TestSetup-CreateResourceGroup | New-AzDnsZone -Name $zoneName <-||-  <-||- 
	 -||-> $resourceGroupName = $createdZone.ResourceGroupName <-||- 
	 -||-> Assert-NotNull $createdZone <-||- 

	 -||-> $message = [System.String]::Format("The Zone {0} exists already and hence cannot be created again.", $zoneName) <-||- ;
	 -||-> Assert-Throws {  -||-> New-AzDnsZone -Name $zoneName -ResourceGroupName $resourceGroupName <-||-  } $message <-||- 

	 -||-> $createdZone | Remove-AzDnsZone -PassThru -Confirm:$false <-||- 
	 -||-> Remove-AzResourceGroup -Name $resourceGroupName -Force <-||- 
} <-||- 


 -||-> function Test-ZoneSetEtagMismatch
{
	 -||-> $zoneName =  -||-> Get-RandomZoneName <-||-  <-||- 
     -||-> $createdZone =  -||-> TestSetup-CreateResourceGroup | New-AzDnsZone -Name $zoneName <-||-  <-||- 
	 -||-> $originalEtag = $createdZone.Etag <-||- 
	 -||-> $createdZone.Etag = "gibberish" <-||- 

	 -||-> $resourceGroupName = $createdZone.ResourceGroupName <-||- 
	 -||-> $message = [System.String]::Format("The Zone {0} has been modified (etag mismatch).", $zoneName) <-||- ;
	 -||-> Assert-Throws {  -||-> $createdZone | Set-AzDnsZone <-||-  } $message <-||- 

	 -||-> $updatedZone =  -||-> $createdZone | Set-AzDnsZone -Overwrite <-||-  <-||- 

	 -||-> Assert-AreNotEqual "gibberish" $updatedZone.Etag <-||- 
	 -||-> Assert-AreNotEqual $createdZone.Etag $updatedZone.Etag <-||- 

	 -||-> $updatedZone | Remove-AzDnsZone -PassThru -Confirm:$false <-||- 
	 -||-> Remove-AzResourceGroup -Name $resourceGroupName -Force <-||- 
} <-||- 


 -||-> function Test-ZoneSetNotFound
{
	 -||-> $zoneName =  -||-> Get-RandomZoneName <-||-  <-||- 
     -||-> $resourceGroup =  -||-> TestSetup-CreateResourceGroup <-||-  <-||- 

	 -||-> Assert-ThrowsLike {  -||-> Set-AzDnsZone -Name $zoneName -ResourceGroupName $resourceGroup.ResourceGroupName <-||-  }  "*was not found*" <-||- ;
	 -||-> Remove-AzResourceGroup -Name $resourceGroup.ResourceGroupName -Force <-||- 
} <-||- 


 -||-> function Test-ZoneRemoveEtagMismatch
{
	 -||-> $zoneName =  -||-> Get-RandomZoneName <-||-  <-||- 
     -||-> $createdZone =  -||-> TestSetup-CreateResourceGroup | New-AzDnsZone -Name $zoneName <-||-  <-||- 
	 -||-> $originalEtag = $createdZone.Etag <-||- 
	 -||-> $createdZone.Etag = "gibberish" <-||- 

	 -||-> $resourceGroupName = $createdZone.ResourceGroupName <-||- 
	 -||-> $message = [System.String]::Format("The Zone {0} has been modified (etag mismatch).", $zoneName) <-||- ;
	 -||-> Assert-Throws {  -||-> $createdZone | Remove-AzDnsZone -Confirm:$false <-||-  } $message <-||- 

	 -||-> $removed =  -||-> $createdZone | Remove-AzDnsZone -Overwrite -Confirm:$false -PassThru <-||-  <-||- 

	 -||-> Assert-True {  -||-> $removed <-||-  } <-||- 
	 -||-> Remove-AzResourceGroup -Name $resourceGroupName -Force <-||- 
} <-||- 


 -||-> function Test-ZoneRemoveNonExisting
{
	 -||-> $zoneName =  -||-> Get-RandomZoneName <-||-  <-||- 
     -||-> $resourceGroup =  -||-> TestSetup-CreateResourceGroup <-||-  <-||- 

	 -||-> $removed =  -||-> Remove-AzDnsZone -Name $zoneName -ResourceGroupName $resourceGroup.ResourceGroupName -Confirm:$false -PassThru <-||-  <-||- 
	 -||-> Remove-AzResourceGroup -Name $resourceGroup.ResourceGroupName -Force <-||- 
} <-||- 


 -||-> function Test-ZoneList
{
	 -||-> $zoneName1 =  -||-> Get-RandomZoneName <-||-  <-||- 
	 -||-> $zoneName2 = $zoneName1 + "A" <-||- 
	 -||-> $resourceGroup =  -||-> TestSetup-CreateResourceGroup <-||-  <-||- 
     -||-> $createdZone1 =  -||-> $resourceGroup | New-AzDnsZone -Name $zoneName1 -Tags @{tag1= -||-> "value1" <-||- } <-||-  <-||- 
	 -||-> $createdZone2 =  -||-> $resourceGroup | New-AzDnsZone -Name $zoneName2 <-||-  <-||- 

	 -||-> $result =  -||-> Get-AzDnsZone -ResourceGroupName $resourceGroup.ResourceGroupName <-||-  <-||- 

	 -||-> Assert-AreEqual 2 $result.Count <-||- 

	 -||-> Assert-AreEqual $createdZone1.Etag $result[0].Etag <-||- 
	 -||-> Assert-AreEqual $createdZone1.Name $result[0].Name <-||- 
	 -||-> Assert-NotNull $resourceGroup.ResourceGroupName $result[0].ResourceGroupName <-||- 
	 -||-> Assert-AreEqual 1 $result[0].Tags.Count <-||- 

	 -||-> Assert-AreEqual $createdZone2.Etag $result[1].Etag <-||- 
	 -||-> Assert-AreEqual $createdZone2.Name $result[1].Name <-||- 
	 -||-> Assert-NotNull $resourceGroup.ResourceGroupName $result[1].ResourceGroupName <-||- 
	 -||-> Assert-AreEqual 0 $result[1].Tags.Count <-||- 

	 -||-> $result | Remove-AzDnsZone -PassThru -Confirm:$false <-||- 
	 -||-> Remove-AzResourceGroup -Name $resourceGroup.ResourceGroupName -Force <-||- 
} <-||- 

 -||-> function Test-ZoneListSubscription
{
	 -||-> $zoneName1 =  -||-> Get-RandomZoneName <-||-  <-||- 
	 -||-> $zoneName2 = $zoneName1 + "A" <-||- 
	 -||-> $resourceGroup =  -||-> TestSetup-CreateResourceGroup <-||-  <-||- 
     -||-> $createdZone1 =  -||-> $resourceGroup | New-AzDnsZone -Name $zoneName1 -Tags @{tag1= -||-> "value1" <-||- } <-||-  <-||- 
	 -||-> $createdZone2 =  -||-> $resourceGroup | New-AzDnsZone -Name $zoneName2 <-||-  <-||- 

	 -||-> $result =  -||-> Get-AzDnsZone <-||-  <-||- 

	 -||-> Assert-True   {  -||-> $result.Count -ge 2 <-||-  } <-||- 

	 -||-> $createdZone1 | Remove-AzDnsZone -PassThru -Confirm:$false <-||- 
	 -||-> $createdZone2 | Remove-AzDnsZone -PassThru -Confirm:$false <-||- 
	 -||-> Remove-AzResourceGroup -Name $resourceGroup.ResourceGroupName -Force <-||- 
} <-||- 


 -||-> function Test-ZoneListWithEndsWith
{
	 -||-> $suffix = ".com" <-||- 
	 -||-> $suffixWithDot = ".com." <-||- 
	 -||-> $zoneName1 =  -||-> Get-RandomZoneName <-||-  <-||- 
	 -||-> $zoneName2 = $zoneName1 + $suffix <-||- 
	 -||-> $resourceGroup =  -||-> TestSetup-CreateResourceGroup <-||-  <-||- 
     -||-> $createdZone1 =  -||-> $resourceGroup | New-AzDnsZone -Name $zoneName1 <-||-  <-||- 
	 -||-> $createdZone2 =  -||-> $resourceGroup | New-AzDnsZone -Name $zoneName2 <-||-  <-||- 

	 -||-> $result =  -||-> Get-AzDnsZone -ResourceGroupName $resourceGroup.ResourceGroupName -EndsWith $suffixWithDot <-||-  <-||- 

	 -||-> Assert-AreEqual 1 $result.Count <-||- 

	 -||-> Assert-AreEqual $createdZone2.Etag $result[0].Etag <-||- 
	 -||-> Assert-AreEqual $createdZone2.Name $result[0].Name <-||- 
	 -||-> Assert-NotNull $resourceGroup.ResourceGroupName $result[0].ResourceGroupName <-||- 
	 -||-> $result | Remove-AzDnsZone -PassThru -Confirm:$false <-||- 
	 -||-> Remove-AzResourceGroup -Name $resourceGroup.ResourceGroupName -Force <-||- 
} <-||- 


 -||-> function Test-AddRemoveRecordSet
{
	 -||-> $zoneName =  -||-> Get-RandomZoneName <-||-  <-||- 
	 -||-> $recordName =  -||-> getAssetname <-||-  <-||- 
     -||-> $resourceGroup =  -||-> TestSetup-CreateResourceGroup <-||-  <-||- 
	 -||-> $createdZone =  -||-> New-AzDnsZone -Name $zoneName -ResourceGroupName $resourceGroup.ResourceGroupName -Tags @{Name= -||-> "tag1" <-||- ;Value= -||-> "value1" <-||- } <-||-  <-||- 

	 -||-> $record =  -||-> $createdZone | New-AzDnsRecordSet -Name $recordName -Ttl 100 -RecordType A -DnsRecords @() | Add-AzDnsRecordConfig -Ipv4Address 1.1.1.1 | Set-AzDnsRecordSet <-||-  <-||- 
	 -||-> $updatedZone =  -||-> Get-AzDnsZone -ResourceGroupName $resourceGroup.ResourceGroupName -Name $zoneName <-||-  <-||- 
	 -||-> Assert-AreEqual 3 $updatedZone.NumberOfRecordSets <-||- 

	 -||-> $removeRecord =  -||-> $updatedZone | Get-AzDnsRecordSet -Name $recordName -RecordType A | Remove-AzDnsRecordSet -Name $recordName -RecordType A -PassThru -Confirm:$false <-||-  <-||- 
	 -||-> $finalZone =  -||-> Get-AzDnsZone -ResourceGroupName $resourceGroup.ResourceGroupName -Name $zoneName <-||-  <-||- 
	 -||-> Assert-AreEqual 2 $finalZone.NumberOfRecordSets <-||- 

	 -||-> $finalZone | Remove-AzDnsZone -PassThru -Confirm:$false <-||- 
	 -||-> Remove-AzResourceGroup -Name $resourceGroup.resourceGroupName -Force <-||- 
} <-||- 

