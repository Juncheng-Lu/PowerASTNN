














 -||-> function Test-AzureLocation
{
     -||-> $providerLocations =  -||-> Get-AzureRmLocation <-||-  <-||- 

     -||-> Assert-True {  -||-> $providerLocations.Count -gt 0 <-||-  } <-||- 
     -||-> foreach ($location in  -||-> $providerLocations <-||- )
    {
         -||-> Assert-True {  -||-> $location.Providers.Count -gt 0 <-||-  } <-||- 
    } <-||- 
 } <-||- 

