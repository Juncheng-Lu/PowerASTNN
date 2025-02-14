














 -||-> function Test-GetAzureRmLogProfile
{
     -||-> try
    {
        
         -||-> $actual =  -||-> Get-AzLogProfile -Name default <-||-  <-||- 

         -||-> Assert-AreEqual /subscriptions/a93fb07c-6c93-40be-bf3b-4f0deba10f4b/providers/microsoft.insights/logprofiles/default $actual.Id "Resource Ids not equal" <-||- 
         -||-> Assert-AreEqual default        $actual.Name "Names not equal" <-||- 
         -||-> Assert-AreEqual "/subscriptions/a93fb07c-6c93-40be-bf3b-4f0deba10f4b/resourceGroups/insights-integration/providers/Microsoft.Storage/storageAccounts/insightsintegration7777" $actual.StorageAccountId "Storage Account Ids not equal" <-||- 
         -||-> Assert-Null $actual.ServiceBusRuleId "ServiceBus rule Id not null" <-||- 
         -||-> Assert-AreEqual 1              $actual.Locations.Count "Count not 1" <-||- 
         -||-> Assert-AreEqual global         $actual.Locations "Location not global" <-||- 
         -||-> Assert-AreEqual 3              $actual.Categories.Count "Categories count not 3" <-||- 
         -||-> Assert-AreEqual Delete         $actual.Categories[0] "Category[0] not Delete" <-||- 
         -||-> Assert-AreEqual Write          $actual.Categories[1] "Category[1] not Write" <-||- 
         -||-> Assert-AreEqual Action         $actual.Categories[2] "Category[2] not Action" <-||- 
         -||-> Assert-False {  -||-> $actual.RetentionPolicy.Enabled <-||-  } "RetentionPolicy not false" <-||- 
         -||-> Assert-AreEqual 0              $actual.RetentionPolicy.Days "Retention Days not 0" <-||- 
    }
    finally
    {
        
        
    } <-||- 
} <-||- 


 -||-> function Test-AddAzureRmLogProfile
{
     -||-> try
    {
         -||-> $actual =  -||-> Add-AzLogProfile -Name default -StorageAccountId /subscriptions/1a66ce04-b633-4a0b-b2bc-a912ec8986a6/resourceGroups/insights-integration/providers/Microsoft.Storage/storageAccounts/insightsintegration7777 -Location global -Category Delete,Write,Action <-||-  <-||- 

         -||-> Assert-AreEqual $true $actual <-||- 
    }
    finally
    {
        
        
    } <-||- 
} <-||- 


 -||-> function Test-AddAzureRmLogProfileWithRetention
{
     -||-> try
    {
         -||-> $actual =  -||-> Add-AzLogProfile -Name default -StorageAccountId /subscriptions/1a66ce04-b633-4a0b-b2bc-a912ec8986a6/resourceGroups/insights-integration/providers/Microsoft.Storage/storageAccounts/insightsintegration7777 -Location global -Category Delete,Write,Action -RetentionInDays 90 <-||-  <-||- 

         -||-> Assert-AreEqual $true $actual <-||- 
    }
    finally
    {
        
        
    } <-||- 
} <-||- 

