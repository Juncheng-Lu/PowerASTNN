




 -||-> function Get-AuthToken {



[cmdletbinding()]

param
(
    [Parameter(Mandatory=$true)]
    $User
)

 -||-> $userUpn =  -||-> New-Object "System.Net.Mail.MailAddress" -ArgumentList $User <-||-  <-||- 

 -||-> $tenant = $userUpn.Host <-||- 

 -||-> Write-Host "Checking for AzureAD module..." <-||- 

     -||-> $AadModule =  -||-> Get-Module -Name "AzureAD" -ListAvailable <-||-  <-||- 
    
     -||-> if ( -||-> $AadModule -eq $null <-||- ) {
    
         -||-> Write-Host "AzureAD PowerShell module not found, looking for AzureADPreview" <-||- 
         -||-> $AadModule =  -||-> Get-Module -Name "AzureADPreview" -ListAvailable <-||-  <-||- 
    
    } <-||- 
    
     -||-> if ( -||-> $AadModule -eq $null <-||- ) {
         -||-> write-host <-||- 
         -||-> write-host "AzureAD Powershell module not installed..." -f Red <-||- 
         -||-> write-host "Install by running 'Install-Module AzureAD' or 'Install-Module AzureADPreview' from an elevated PowerShell prompt" -f Yellow <-||- 
         -||-> write-host "Script can't continue..." -f Red <-||- 
         -||-> write-host <-||- 
        exit
    } <-||- 
    



     -||-> if( -||-> $AadModule.count -gt 1 <-||- ){
    
         -||-> $Latest_Version = ( -||-> $AadModule | select version | Sort-Object <-||- )[-1] <-||- 
    
         -||-> $aadModule =  -||-> $AadModule | ? {  -||-> $_.version -eq $Latest_Version.version <-||-  } <-||-  <-||- 
    
            
    
             -||-> if( -||-> $AadModule.count -gt 1 <-||- ){
    
             -||-> $aadModule =  -||-> $AadModule | select -Unique <-||-  <-||- 
    
            } <-||- 
    
         -||-> $adal =  -||-> Join-Path $AadModule.ModuleBase "Microsoft.IdentityModel.Clients.ActiveDirectory.dll" <-||-  <-||- 
         -||-> $adalforms =  -||-> Join-Path $AadModule.ModuleBase "Microsoft.IdentityModel.Clients.ActiveDirectory.Platform.dll" <-||-  <-||- 
    
    }
    
    else {
    
         -||-> $adal =  -||-> Join-Path $AadModule.ModuleBase "Microsoft.IdentityModel.Clients.ActiveDirectory.dll" <-||-  <-||- 
         -||-> $adalforms =  -||-> Join-Path $AadModule.ModuleBase "Microsoft.IdentityModel.Clients.ActiveDirectory.Platform.dll" <-||-  <-||- 
    
    } <-||- 
    
 -||-> [System.Reflection.Assembly]::LoadFrom($adal) | Out-Null <-||- 

 -||-> [System.Reflection.Assembly]::LoadFrom($adalforms) | Out-Null <-||- 

 -||-> $clientId = "d1ddf0e4-d672-4dae-b554-9d5bdfd93547" <-||- 

 -||-> $redirectUri = "urn:ietf:wg:oauth:2.0:oob" <-||- 

 -||-> $resourceAppIdURI = "https://graph.microsoft.com" <-||- 

 -||-> $authority = "https://login.microsoftonline.com/$Tenant" <-||- 

     -||-> try {
    
     -||-> $authContext =  -||-> New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext" -ArgumentList $authority <-||-  <-||- 
    
    
    
    
     -||-> $platformParameters =  -||-> New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.PlatformParameters" -ArgumentList "Auto" <-||-  <-||- 
    
     -||-> $userId =  -||-> New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.UserIdentifier" -ArgumentList ( -||-> $User, "OptionalDisplayableId" <-||- ) <-||-  <-||- 
    
     -||-> $authResult = $authContext.AcquireTokenAsync($resourceAppIdURI,$clientId,$redirectUri,$platformParameters,$userId).Result <-||- 
    
        
    
         -||-> if( -||-> $authResult.AccessToken <-||- ){
    
        
    
         -||-> $authHeader = @{
            'Content-Type'= -||-> 'application/json' <-||- 
            'Authorization'= -||-> "Bearer " + $authResult.AccessToken <-||- 
            'ExpiresOn'= -||-> $authResult.ExpiresOn <-||- 
            } <-||- 
    
        return  -||-> $authHeader <-||- 
    
        }
    
        else {
    
         -||-> Write-Host <-||- 
         -||-> Write-Host "Authorization Access Token is null, please re-run authentication..." -ForegroundColor Red <-||- 
         -||-> Write-Host <-||- 
        break
    
        } <-||- 
    
    }

    catch {
    
     -||-> write-host $_.Exception.Message -f Red <-||- 
     -||-> write-host $_.Exception.ItemName -f Red <-||- 
     -||-> write-host <-||- 
    break

    } <-||- 

} <-||- 



 -||-> Function Get-IntuneMAMApplication(){



[cmdletbinding()]

param
(
[switch]$Android,
[switch]$iOS
)

 -||-> $graphApiVersion = "Beta" <-||- 
 -||-> $Resource = "deviceAppManagement/mobileApps" <-||- 

     -||-> try {

         -||-> $Count_Params = 0 <-||- 

         -||-> if( -||-> $Android.IsPresent <-||- ){  -||-> $Count_Params++ <-||-  } <-||- 
         -||-> if( -||-> $iOS.IsPresent <-||- ){  -||-> $Count_Params++ <-||-  } <-||- 

         -||-> if( -||-> $Count_Params -gt 1 <-||- ){

         -||-> write-host "Multiple parameters set, specify a single parameter -Android or -iOS against the function" -f Red <-||- 
         -||-> Write-Host <-||- 

        }
        
        elseif( -||-> $Android <-||- ){

         -||-> $uri = "https://graph.microsoft.com/$graphApiVersion/$( -||-> $resource <-||- )" <-||- 
         -||-> ( -||-> Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get <-||- ).Value | ? {  -||-> ( -||-> $_.'@odata.type' <-||- ).Contains("managedAndroidStoreApp") <-||-  } <-||- 

        }

        elseif( -||-> $iOS <-||- ){

         -||-> $uri = "https://graph.microsoft.com/$graphApiVersion/$( -||-> $resource <-||- )" <-||- 
         -||-> ( -||-> Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get <-||- ).Value | ? {  -||-> ( -||-> $_.'@odata.type' <-||- ).Contains("managedIOSStoreApp") <-||-  } <-||- 

        }

        else {

         -||-> $uri = "https://graph.microsoft.com/$graphApiVersion/$( -||-> $resource <-||- )" <-||- 
         -||-> ( -||-> Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get <-||- ).Value | ? {  -||-> ( -||-> $_.'@odata.type' <-||- ).Contains("managed") <-||-  } <-||- 

        } <-||- 

    }

    catch {

     -||-> $ex = $_.Exception <-||- 
     -||-> $errorResponse = $ex.Response.GetResponseStream() <-||- 
     -||-> $reader =  -||-> New-Object System.IO.StreamReader( -||-> $errorResponse <-||- ) <-||-  <-||- 
     -||-> $reader.BaseStream.Position = 0 <-||- 
     -||-> $reader.DiscardBufferedData() <-||- 
     -||-> $responseBody = $reader.ReadToEnd() <-||- ;
     -||-> Write-Host "Response content:`n$responseBody" -f Red <-||- 
     -||-> Write-Error "Request to $Uri failed with HTTP Status $( -||-> $ex.Response.StatusCode <-||- ) $( -||-> $ex.Response.StatusDescription <-||- )" <-||- 
     -||-> write-host <-||- 
    break

    } <-||- 

} <-||- 





 -||-> write-host <-||- 


 -||-> if( -||-> $global:authToken <-||- ){

    
     -||-> $DateTime = ( -||-> Get-Date <-||- ).ToUniversalTime() <-||- 
    
    
     -||-> $TokenExpires = ( -||-> $authToken.ExpiresOn.datetime - $DateTime <-||- ).Minutes <-||- 
    
         -||-> if( -||-> $TokenExpires -le 0 <-||- ){
    
         -||-> write-host "Authentication Token expired" $TokenExpires "minutes ago" -ForegroundColor Yellow <-||- 
         -||-> write-host <-||- 
    
            
    
             -||-> if( -||-> $User -eq $null -or $User -eq "" <-||- ){
    
             -||-> $User =  -||-> Read-Host -Prompt "Please specify your user principal name for Azure Authentication" <-||-  <-||- 
             -||-> Write-Host <-||- 
    
            } <-||- 
    
         -||-> $global:authToken =  -||-> Get-AuthToken -User $User <-||-  <-||- 
    
        } <-||- 
}



else {
    
     -||-> if( -||-> $User -eq $null -or $User -eq "" <-||- ){
    
     -||-> $User =  -||-> Read-Host -Prompt "Please specify your user principal name for Azure Authentication" <-||-  <-||- 
     -||-> Write-Host <-||- 
    
    } <-||- 


 -||-> $global:authToken =  -||-> Get-AuthToken -User $User <-||-  <-||- 

} <-||- 





 -||-> $APP_iOS =  -||-> Get-IntuneMAMApplication -iOS | Sort-Object displayName <-||-  <-||- 

 -||-> $APP_Android =  -||-> Get-IntuneMAMApplication -Android | Sort-Object displayName <-||-  <-||- 

 -||-> Write-Host "Managed iOS Store Applications" -f Yellow <-||- 
 -||-> Write-Host <-||- 

     -||-> $APP_iOS | ForEach-Object {

     -||-> Write-Host "DisplayName:" $_.displayName -ForegroundColor Cyan <-||- 
     -||-> $_.'@odata.type' <-||- 
     -||-> $_.bundleId <-||- 
     -||-> Write-Host <-||- 

    } <-||- 



 -||-> Write-Host "Managed Android Store Applications" -f Yellow <-||- 
 -||-> Write-Host <-||- 

     -||-> $APP_Android | ForEach-Object {

     -||-> Write-Host "DisplayName:" $_.displayName -ForegroundColor Cyan <-||- 
     -||-> $_.'@odata.type' <-||- 
     -||-> $_.packageId <-||- 
     -||-> Write-Host <-||- 

    } <-||- 

 -||-> Write-Host <-||- 

