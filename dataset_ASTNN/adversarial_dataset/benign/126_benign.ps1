











 -||-> $siteName = 'CarbonSetIisHttpHeader' <-||- 
 -||-> $sitePort = 47938 <-||- 

 -||-> function Start-TestFixture
{
     -||-> & ( -||-> Join-Path -Path $PSScriptRoot '..\Initialize-CarbonTest.ps1' -Resolve <-||- ) <-||- 
} <-||- 

 -||-> function Start-Test
{
     -||-> Install-IisWebsite -Name $siteName -Path $TestDir -Binding ( -||-> 'http/*:{0}:*' -f $sitePort <-||- ) <-||- 
} <-||- 

 -||-> function Stop-Test
{
     -||-> Remove-IisWebsite -Name $siteName <-||- 
} <-||- 

 -||-> function Test-ShouldCreateNewHeader()
{
     -||-> $name = 'X-Carbon-SetIisHttpHeader' <-||- 
     -||-> $value = 'Brownies' <-||- 
     -||-> $header =  -||-> Get-IisHttpHeader -SiteName $siteName -Name $name <-||-  <-||- 
     -||-> Assert-Null $header <-||- 
     -||-> $result =  -||-> Set-IisHttpHeader -SiteName $siteName -Name $name -Value $value <-||-  <-||- 
     -||-> Assert-Null $result 'something returned from Set-IisHttpHeader' <-||- 
     -||-> $header =  -||-> Get-IisHttpHeader -SiteName $siteName -Name $name <-||-  <-||- 
     -||-> Assert-NotNull $header 'header not created' <-||- 
     -||-> Assert-Equal $name $header.Name <-||- 
     -||-> Assert-Equal $value $header.Value <-||- 
} <-||- 

 -||-> function Test-ShouldSetExistingHeader()
{
     -||-> $name = 'X-Carbon-SetIisHttpHeader' <-||- 
     -||-> $value = 'Brownies' <-||- 
     -||-> Set-IisHttpHeader -SiteName $siteName -Name $name -Value $value <-||- 
    
     -||-> $newValue = 'Blondies' <-||- 
     -||-> $result =  -||-> Set-IisHttpHeader -SiteName $siteName -Name $name -Value $newValue <-||-  <-||- 
     -||-> Assert-Null $result 'something returned from Set-IisHttpHeader' <-||- 
    
     -||-> $header =  -||-> Get-IisHttpHeader -SiteName $siteName -Name $name <-||-  <-||- 
     -||-> Assert-NotNull $header 'header not created' <-||- 
     -||-> Assert-Equal $name $header.Name <-||- 
     -||-> Assert-Equal $newValue $header.Value <-||- 
} <-||- 

 -||-> function Test-ShouldSetHeaderOnPath
{
     -||-> $name = 'X-Carbon-SetIisHttpHeader' <-||- 

     -||-> $value = 'Parent' <-||- 
     -||-> Set-IisHttpHeader -SiteName $siteName -Name $name -Value $value <-||- 
    
     -||-> $subValue = 'Child' <-||- 
     -||-> Set-IisHttpHeader -SiteName $siteName -Path SubFolder -Name $name -Value $subValue <-||- 
    
     -||-> $header =  -||-> Get-IisHttpHeader -SiteName $siteName -Name $name <-||-  <-||- 
     -||-> Assert-NotNull $header 'header not created' <-||- 
     -||-> Assert-Equal $name $header.Name <-||- 
     -||-> Assert-Equal $value $header.Value <-||- 
    
     -||-> $header =  -||-> Get-IisHttpHeader -SiteName $siteName -Path SubFolder -Name $name <-||-  <-||- 
     -||-> Assert-NotNull $header 'header not created' <-||- 
     -||-> Assert-Equal $name $header.Name <-||- 
     -||-> Assert-Equal $subValue $header.Value <-||- 
} <-||- 

 -||-> function Test-ShouldSupportWhatIf()
{
     -||-> $name = 'X-Carbon-SetIisHttpHeader' <-||- 
     -||-> $value = 'Brownies' <-||- 
     -||-> $header =  -||-> Get-IisHttpHeader -SiteName $siteName -Name $name <-||-  <-||- 
     -||-> Assert-Null $header <-||- 
     -||-> Set-IisHttpHeader -SiteName $siteName -Name $name -Value $value -WhatIf <-||- 
     -||-> $header =  -||-> Get-IisHttpHeader -SiteName $siteName -Name $name <-||-  <-||- 
     -||-> Assert-Null $header 'HTTP header created' <-||- 
} <-||- 



