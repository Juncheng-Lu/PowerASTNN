














 -||-> function Test-SearchGetSearchResultsAndUpdate
{
     -||-> $rgname = "mms-eus" <-||- 
     -||-> $wsname = "188087e4-5850-4d8b-9d08-3e5b448eaecd" <-||- 

	 -||-> $top = 5 <-||- 

	 -||-> $searchResult =  -||-> Get-AzOperationalInsightsSearchResults -ResourceGroupName $rgname -WorkspaceName $wsname -Top $top -Query "*" <-||-  <-||- 

	 -||-> Assert-NotNull $searchResult <-||- 
	 -||-> Assert-NotNull $searchResult.Metadata <-||- 
	 -||-> Assert-NotNull $searchResult.Value <-||- 
	 -||-> Assert-AreEqual $searchResult.Value.Count $top <-||- 

	
	 -||-> $stringType = "string".GetType() <-||- 
	 -||-> $valueType = $searchResult.Value.GetType() <-||- 
	 -||-> $valueIsString = $valueType.GenericTypeArguments.Contains($stringType) <-||- 
	 -||-> Assert-AreEqual $true $valueIsString <-||- 

	 -||-> $idArray = $searchResult.Id.Split("/") <-||- 
	 -||-> $id = $idArray[$idArray.Length-1] <-||- 
	 -||-> $updatedResult =  -||-> Get-AzOperationalInsightsSearchResults -ResourceGroupName $rgname -WorkspaceName $wsname -Id $id <-||-  <-||- 
	
	 -||-> Assert-NotNull $updatedResult <-||- 
	 -||-> Assert-NotNull $updatedResult.Metadata <-||- 
	 -||-> Assert-NotNull $searchResult.Value <-||- 
} <-||- 


 -||-> function Test-SearchGetSchema
{
     -||-> $wsname =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $dsName =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $rgname =  -||-> Get-ResourceGroupName <-||-  <-||- 
     -||-> $wslocation =  -||-> Get-ProviderLocation <-||-  <-||- 

     -||-> New-AzResourceGroup -Name $rgname -Location $wslocation -Force <-||- 

    
     -||-> $workspace =  -||-> New-AzOperationalInsightsWorkspace -ResourceGroupName $rgname -Name $wsname -Location $wslocation -Sku premium -Force <-||-  <-||- 
	 -||-> $schema =  -||-> Get-AzOperationalInsightsSchema -ResourceGroupName $rgname -WorkspaceName $wsname <-||-  <-||- 
	 -||-> Assert-NotNull $schema <-||- 
	 -||-> Assert-NotNull $schema.Metadata <-||- 
	 -||-> Assert-AreEqual $schema.Metadata.ResultType "schema" <-||- 
	 -||-> Assert-NotNull $schema.Value <-||- 
} <-||- 


 -||-> function Test-SearchGetSavedSearchesAndResults
{
     -||-> $rgname = "mms-eus" <-||- 
     -||-> $wsname = "188087e4-5850-4d8b-9d08-3e5b448eaecd" <-||- 

	 -||-> $savedSearches =  -||-> Get-AzOperationalInsightsSavedSearch -ResourceGroupName $rgname -WorkspaceName $wsname <-||-  <-||- 
	
	 -||-> Assert-NotNull $savedSearches <-||- 
	 -||-> Assert-NotNull $savedSearches.Value <-||- 
	
	 -||-> $idArray = $savedSearches.Value[0].Id.Split("/") <-||- 
	 -||-> $id = $idArray[$idArray.Length-1] <-||- 

	 -||-> $savedSearch =  -||-> Get-AzOperationalInsightsSavedSearch -ResourceGroupName $rgname -WorkspaceName $wsname -SavedSearchId $id <-||-  <-||- 

	 -||-> Assert-NotNull $savedSearch <-||- 
	 -||-> Assert-NotNull $savedSearch.ETag <-||- 
	 -||-> Assert-NotNull $savedSearch.Id <-||- 
	 -||-> Assert-NotNull $savedSearch.Properties <-||- 
	 -||-> Assert-NotNull $savedSearch.Properties.Query <-||- 

	 -||-> $savedSearchResult =  -||-> Get-AzOperationalInsightsSavedSearchResults -ResourceGroupName $rgname -WorkspaceName $wsname -SavedSearchId $id <-||-  <-||- 

	 -||-> Assert-NotNull $savedSearchResult <-||- 
	 -||-> Assert-NotNull $savedSearchResult.Metadata <-||- 
	 -||-> Assert-NotNull $savedSearchResult.Value <-||- 
} <-||- 


 -||-> function Test-SearchSetAndRemoveSavedSearches
{
     -||-> $wsname =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $dsName =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $rgname =  -||-> Get-ResourceGroupName <-||-  <-||- 
     -||-> $wslocation =  -||-> Get-ProviderLocation <-||-  <-||- 

     -||-> New-AzResourceGroup -Name $rgname -Location $wslocation -Force <-||- 

    
     -||-> $workspace =  -||-> New-AzOperationalInsightsWorkspace -ResourceGroupName $rgname -Name $wsname -Location $wslocation -Sku premium -Force <-||-  <-||- 

	 -||-> $id = "test-new-saved-search-id-2015" <-||- 
	 -||-> $displayName = "TestingSavedSearch" <-||- 
	 -||-> $category = "Saved Search Test Category" <-||- 
	 -||-> $version = 1 <-||- 
	 -||-> $query = "* | measure Count() by Computer" <-||- 

	
	 -||-> $savedSearches =  -||-> Get-AzOperationalInsightsSavedSearch -ResourceGroupName $rgname -WorkspaceName $wsname <-||-  <-||- 
	 -||-> $count = $savedSearches.Value.Count <-||- 
	 -||-> $newCount = $count + 1 <-||- 
	 -||-> $tags = @{"Group" =  -||-> "Computer" <-||- } <-||- 

	 -||-> New-AzOperationalInsightsSavedSearch -ResourceGroupName $rgname -WorkspaceName $wsname -SavedSearchId $id -DisplayName $displayName -Category $category -Query $query -Tag $tags -Version $version -Force <-||- 
	
	
	 -||-> $savedSearches =  -||-> Get-AzOperationalInsightsSavedSearch -ResourceGroupName $rgname -WorkspaceName $wsname <-||-  <-||- 
	 -||-> Assert-AreEqual $savedSearches.Value.Count $newCount <-||- 

	 -||-> $etag = "" <-||- 
	 -||-> ForEach ($s in  -||-> $savedSearches.Value <-||- )
	{
		 -||-> If ( -||-> $s.Properties.DisplayName.Equals($displayName) <-||- ) {
			 -||-> $etag = $s.ETag <-||- 
		} <-||- 
	} <-||- 

	
	
	 -||-> $query = "* | distinct Computer" <-||- 
	 -||-> Set-AzOperationalInsightsSavedSearch -ResourceGroupName $rgname -WorkspaceName $wsname -SavedSearchId $id -DisplayName $displayName -Category $category -Query $query -Tag $tags -Version $version -ETag $etag <-||- 
	
	
	 -||-> $savedSearches =  -||-> Get-AzOperationalInsightsSavedSearch -ResourceGroupName $rgname -WorkspaceName $wsname <-||-  <-||- 
	 -||-> Assert-AreEqual $savedSearches.Value.Count $newCount <-||- 

	 -||-> $found = 0 <-||- 
	 -||-> $hasTag = 0 <-||- 
	 -||-> ForEach ($s in  -||-> $savedSearches.Value <-||- )
	{
		 -||-> If ( -||-> $s.Properties.DisplayName.Equals($displayName) -And $s.Properties.Query.Equals($query) <-||- ) {
			 -||-> $found = 1 <-||- 
			 -||-> If ( -||-> $s.Properties.Tags["Group"] -eq "Computer" <-||- ) {
				 -||-> $hasTag = 1 <-||- 
			} <-||- 
		} <-||- 
	} <-||- 
	 -||-> Assert-AreEqual $found 1 <-||- 
	 -||-> Assert-AreEqual $hasTag 1 <-||- 


	 -||-> Remove-AzOperationalInsightsSavedSearch -ResourceGroupName $rgname -WorkspaceName $wsname -SavedSearchId $id <-||- 
	
	
	 -||-> $savedSearches =  -||-> Get-AzOperationalInsightsSavedSearch -ResourceGroupName $rgname -WorkspaceName $wsname <-||-  <-||- 
	 -||-> Assert-AreEqual $savedSearches.Value.Count $count <-||- 
} <-||- 

