




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
 


 -||-> Function Add-WindowsInformationProtectionPolicy(){



[cmdletbinding()]

param
(
    $JSON
)

 -||-> $graphApiVersion = "Beta" <-||- 
 -||-> $Resource = "deviceAppManagement/windowsInformationProtectionPolicies" <-||- 
    
     -||-> try {
        
         -||-> if( -||-> $JSON -eq "" -or $JSON -eq $null <-||- ){

         -||-> write-host "No JSON specified, please specify valid JSON for the iOS Policy..." -f Red <-||- 

        }

        else {

         -||-> Test-JSON -JSON $JSON <-||- 

         -||-> $uri = "https://graph.microsoft.com/$graphApiVersion/$( -||-> $Resource <-||- )" <-||- 
         -||-> Invoke-RestMethod -Uri $uri -Headers $authToken -Method Post -Body $JSON -ContentType "application/json" <-||- 

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



 -||-> Function Add-MDMWindowsInformationProtectionPolicy(){



[cmdletbinding()]

param
(
    $JSON
)

 -||-> $graphApiVersion = "Beta" <-||- 
 -||-> $Resource = "deviceAppManagement/mdmWindowsInformationProtectionPolicies" <-||- 
    
     -||-> try {
        
         -||-> if( -||-> $JSON -eq "" -or $JSON -eq $null <-||- ){

         -||-> write-host "No JSON specified, please specify valid JSON for the iOS Policy..." -f Red <-||- 

        }

        else {

         -||-> Test-JSON -JSON $JSON <-||- 

         -||-> $uri = "https://graph.microsoft.com/$graphApiVersion/$( -||-> $Resource <-||- )" <-||- 
         -||-> Invoke-RestMethod -Uri $uri -Headers $authToken -Method Post -Body $JSON -ContentType "application/json" <-||- 

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



 -||-> Function Get-EnterpriseDomain(){



     -||-> try {

     -||-> $uri = "https://graph.microsoft.com/v1.0/domains" <-||- 

     -||-> $domains = ( -||-> Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get <-||- ).Value <-||- 

     -||-> $EnterpriseDomain = ( -||-> $domains | ? {  -||-> $_.isInitial -eq $true <-||-  } | select id <-||- ).id <-||- 

    return  -||-> $EnterpriseDomain <-||- 

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





 -||-> Write-Host <-||- 


 -||-> if( -||-> $global:authToken <-||- ){

    
     -||-> $DateTime = ( -||-> Get-Date <-||- ).ToUniversalTime() <-||- 

    
     -||-> $TokenExpires = ( -||-> $authToken.ExpiresOn.datetime - $DateTime <-||- ).Minutes <-||- 

         -||-> if( -||-> $TokenExpires -le 0 <-||- ){

         -||-> Write-Host "Authentication Token expired" $TokenExpires "minutes ago" -ForegroundColor Yellow <-||- 
         -||-> Write-Host <-||- 

            

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





 -||-> $EnterpriseDomain =  -||-> Get-EnterpriseDomain <-||-  <-||- 

 -||-> $Sharepoint = $EnterpriseDomain.Split(".")[0] <-||- 



 -||-> $ManagedAppPolicy_WIP = @"

{
  "description": "",
  "displayName": "Win10 WIP WE Policy",
  "enforcementLevel": "encryptAuditAndPrompt",
  "enterpriseDomain": "$EnterpriseDomain",
  "enterpriseProtectedDomainNames": [],
  "protectionUnderLockConfigRequired": false,
  "dataRecoveryCertificate": null,
  "revokeOnUnenrollDisabled": false,
  "revokeOnMdmHandoffDisabled": false,
  "rightsManagementServicesTemplateId": null,
  "azureRightsManagementServicesAllowed": false,
  "iconsVisible": true,
  "protectedApps": [
    {
      "@odata.type": "
      "description": "",
      "displayName": "Microsoft Teams",
      "productName": "*",
      "publisherName": "O=Microsoft Corporation, L=Redmond, S=Washington, C=US",
      "denied": false,
      "binaryName": "teams.exe",
      "binaryVersionLow": "*",
      "binaryVersionHigh": "*"
    },
    {
      "@odata.type": "
      "description": "",
      "displayName": "Microsoft Remote Desktop",
      "productName": "*",
      "publisherName": "O=Microsoft Corporation, L=Redmond, S=Washington, C=US",
      "denied": false,
      "binaryName": "mstsc.exe",
      "binaryVersionLow": "*",
      "binaryVersionHigh": "*"
    },
    {
      "@odata.type": "
      "description": "",
      "displayName": "Microsoft Paint",
      "productName": "*",
      "publisherName": "O=Microsoft Corporation, L=Redmond, S=Washington, C=US",
      "denied": false,
      "binaryName": "mspaint.exe",
      "binaryVersionLow": "*",
      "binaryVersionHigh": "*"
    },
    {
      "@odata.type": "
      "description": "",
      "displayName": "Notepad",
      "productName": "*",
      "publisherName": "O=Microsoft Corporation, L=Redmond, S=Washington, C=US",
      "denied": false,
      "binaryName": "notepad.exe",
      "binaryVersionLow": "*",
      "binaryVersionHigh": "*"
    },
    {
      "@odata.type": "
      "description": "",
      "displayName": "Microsoft OneDrive",
      "productName": "*",
      "publisherName": "O=Microsoft Corporation, L=Redmond, S=Washington, C=US",
      "denied": false,
      "binaryName": "onedrive.exe",
      "binaryVersionLow": "*",
      "binaryVersionHigh": "*"
    },
    {
      "@odata.type": "
      "description": "",
      "displayName": "IE11",
      "productName": "*",
      "publisherName": "O=Microsoft Corporation, L=Redmond, S=Washington, C=US",
      "denied": false,
      "binaryName": "iexplore.exe",
      "binaryVersionLow": "*",
      "binaryVersionHigh": "*"
    },
    {
      "@odata.type": "
      "description": "",
      "displayName": "Company Portal",
      "productName": "Microsoft.CompanyPortal",
      "publisherName": "CN=Microsoft Corporation, O=Microsoft Corporation, L=Redmond, S=Washington, C=US",
      "denied": false
    },
    {
      "@odata.type": "
      "description": "",
      "displayName": "Microsoft Messaging",
      "productName": "Microsoft.Messaging",
      "publisherName": "CN=Microsoft Corporation, O=Microsoft Corporation, L=Redmond, S=Washington, C=US",
      "denied": false
    },
    {
      "@odata.type": "
      "description": "",
      "displayName": "Microsoft Movies and TV",
      "productName": "Microsoft.ZuneVideo",
      "publisherName": "CN=Microsoft Corporation, O=Microsoft Corporation, L=Redmond, S=Washington, C=US",
      "denied": false
    },
    {
      "@odata.type": "
      "description": "",
      "displayName": "Groove Music",
      "productName": "Microsoft.ZuneMusic",
      "publisherName": "CN=Microsoft Corporation, O=Microsoft Corporation, L=Redmond, S=Washington, C=US",
      "denied": false
    },
    {
      "@odata.type": "
      "description": "",
      "displayName": "Microsoft Photos",
      "productName": "Microsoft.Windows.Photos",
      "publisherName": "CN=Microsoft Corporation, O=Microsoft Corporation, L=Redmond, S=Washington, C=US",
      "denied": false
    },
    {
      "@odata.type": "
      "description": "",
      "displayName": "Mail and Calendar for Windows 10",
      "productName": "microsoft.windowscommunicationsapps",
      "publisherName": "CN=Microsoft Corporation, O=Microsoft Corporation, L=Redmond, S=Washington, C=US",
      "denied": false
    },
    {
      "@odata.type": "
      "description": "",
      "displayName": "OneNote",
      "productName": "Microsoft.Office.OneNote",
      "publisherName": "CN=Microsoft Corporation, O=Microsoft Corporation, L=Redmond, S=Washington, C=US",
      "denied": false
    },
    {
      "@odata.type": "
      "description": "",
      "displayName": "PowerPoint Mobile",
      "productName": "Microsoft.Office.PowerPoint",
      "publisherName": "CN=Microsoft Corporation, O=Microsoft Corporation, L=Redmond, S=Washington, C=US",
      "denied": false
    },
    {
      "@odata.type": "
      "description": "",
      "displayName": "Excel Mobile",
      "productName": "Microsoft.Office.Excel",
      "publisherName": "CN=Microsoft Corporation, O=Microsoft Corporation, L=Redmond, S=Washington, C=US",
      "denied": false
    },
    {
      "@odata.type": "
      "description": "",
      "displayName": "Word Mobile",
      "productName": "Microsoft.Office.Word",
      "publisherName": "CN=Microsoft Corporation, O=Microsoft Corporation, L=Redmond, S=Washington, C=US",
      "denied": false
    },
    {
      "@odata.type": "
      "description": "",
      "displayName": "Microsoft People",
      "productName": "Microsoft.People",
      "publisherName": "CN=Microsoft Corporation, O=Microsoft Corporation, L=Redmond, S=Washington, C=US",
      "denied": false
    },
    {
      "@odata.type": "
      "description": "",
      "displayName": "Microsoft Edge",
      "productName": "Microsoft.MicrosoftEdge",
      "publisherName": "CN=Microsoft Corporation, O=Microsoft Corporation, L=Redmond, S=Washington, C=US",
      "denied": false
    }
  ],
  "exemptApps": [],
  "protectedAppLockerFiles": [
    {
      "displayName": "Denied-Downlevel-Office-365-ProPlus.xml",
      "fileHash": "69f299b4-e4aa-48d1-8c6a-49600133d832",
      "file": "PEFwcExvY2tlclBvbGljeSBWZXJzaW9uPSIxIj4NCjxSdWxlQ29sbGVjdGlvbiBUeXBlPSJFeGUiIEVuZm9yY2VtZW50TW9kZT0iRW5hYmxlZCI+DQogIDxGaWxlUHVibGlzaGVyUnVsZSBJZD0iYjAwNWVhZGUtYTVlZS00ZjVhLWJlNDUtZDA4ZmE1NTdhNGIyIiBOYW1lPSJNSUNST1NPRlQgT0ZGSUNFLCBmcm9tIE89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgRGVzY3JpcHRpb249IiIgVXNlck9yR3JvdXBTaWQ9IlMtMS0xLTAiIEFjdGlvbj0iRGVueSI+DQogICAgPENvbmRpdGlvbnM+DQogICAgICA8RmlsZVB1Ymxpc2hlckNvbmRpdGlvbiBQdWJsaXNoZXJOYW1lPSJPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIFByb2R1Y3ROYW1lPSJNSUNST1NPRlQgT0ZGSUNFIiBCaW5hcnlOYW1lPSIqIj4NCiAgICAgICAgPEJpbmFyeVZlcnNpb25SYW5nZSBMb3dTZWN0aW9uPSIqIiBIaWdoU2VjdGlvbj0iKiIgLz4NCiAgICAgIDwvRmlsZVB1Ymxpc2hlckNvbmRpdGlvbj4NCiAgICA8L0NvbmRpdGlvbnM+DQogIDwvRmlsZVB1Ymxpc2hlclJ1bGU+DQogIDxGaWxlUHVibGlzaGVyUnVsZSBJZD0iZGU5ZjM0NjEtNjg1Ni00MDVkLTk2MjQtYTgwY2E3MDFmNmNiIiBOYW1lPSJNSUNST1NPRlQgT0ZGSUNFIDIwMDMsIGZyb20gTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBEZXNjcmlwdGlvbj0iIiBVc2VyT3JHcm91cFNpZD0iUy0xLTEtMCIgQWN0aW9uPSJEZW55Ij4NCiAgICA8Q29uZGl0aW9ucz4NCiAgICAgIDxGaWxlUHVibGlzaGVyQ29uZGl0aW9uIFB1Ymxpc2hlck5hbWU9Ik89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgUHJvZHVjdE5hbWU9Ik1JQ1JPU09GVCBPRkZJQ0UgMjAwMyIgQmluYXJ5TmFtZT0iKiI+DQogICAgICAgIDxCaW5hcnlWZXJzaW9uUmFuZ2UgTG93U2VjdGlvbj0iKiIgSGlnaFNlY3Rpb249IioiIC8+DQogICAgICA8L0ZpbGVQdWJsaXNoZXJDb25kaXRpb24+DQogICAgPC9Db25kaXRpb25zPg0KICA8L0ZpbGVQdWJsaXNoZXJSdWxlPg0KICA8RmlsZVB1Ymxpc2hlclJ1bGUgSWQ9ImFkZTFiODI4LTcwNTUtNDdmYy05OWJjLTQzMmNmN2QxMjA5ZSIgTmFtZT0iMjAwNyBNSUNST1NPRlQgT0ZGSUNFIFNZU1RFTSwgZnJvbSBPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIERlc2NyaXB0aW9uPSIiIFVzZXJPckdyb3VwU2lkPSJTLTEtMS0wIiBBY3Rpb249IkRlbnkiPg0KICAgIDxDb25kaXRpb25zPg0KICAgICAgPEZpbGVQdWJsaXNoZXJDb25kaXRpb24gUHVibGlzaGVyTmFtZT0iTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBQcm9kdWN0TmFtZT0iMjAwNyBNSUNST1NPRlQgT0ZGSUNFIFNZU1RFTSIgQmluYXJ5TmFtZT0iKiI+DQogICAgICAgIDxCaW5hcnlWZXJzaW9uUmFuZ2UgTG93U2VjdGlvbj0iKiIgSGlnaFNlY3Rpb249IioiIC8+DQogICAgICA8L0ZpbGVQdWJsaXNoZXJDb25kaXRpb24+DQogICAgPC9Db25kaXRpb25zPg0KICA8L0ZpbGVQdWJsaXNoZXJSdWxlPg0KICA8RmlsZVB1Ymxpc2hlclJ1bGUgSWQ9ImY2YTA3NWI1LWE1YjUtNDY1NC1hYmQ2LTczMWRhY2I0MGQ5NSIgTmFtZT0iTUlDUk9TT0ZUIE9GRklDRSBPTkVOT1RFLCBmcm9tIE89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgRGVzY3JpcHRpb249IiIgVXNlck9yR3JvdXBTaWQ9IlMtMS0xLTAiIEFjdGlvbj0iRGVueSI+DQogICAgPENvbmRpdGlvbnM+DQogICAgICA8RmlsZVB1Ymxpc2hlckNvbmRpdGlvbiBQdWJsaXNoZXJOYW1lPSJPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIFByb2R1Y3ROYW1lPSJNSUNST1NPRlQgT0ZGSUNFIE9ORU5PVEUiIEJpbmFyeU5hbWU9IioiPg0KICAgICAgICA8QmluYXJ5VmVyc2lvblJhbmdlIExvd1NlY3Rpb249IioiIEhpZ2hTZWN0aW9uPSIxMi4wLjk5OTkuOTk5OSIgLz4NCiAgICAgIDwvRmlsZVB1Ymxpc2hlckNvbmRpdGlvbj4NCiAgICA8L0NvbmRpdGlvbnM+DQogIDwvRmlsZVB1Ymxpc2hlclJ1bGU+DQogIDxGaWxlUHVibGlzaGVyUnVsZSBJZD0iMGVjMDNiMmYtZTlhNC00NzQzLWFlNjAtNmQyOTg4NmNmNmFlIiBOYW1lPSJNSUNST1NPRlQgT0ZGSUNFIE9VVExPT0ssIGZyb20gTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBEZXNjcmlwdGlvbj0iIiBVc2VyT3JHcm91cFNpZD0iUy0xLTEtMCIgQWN0aW9uPSJEZW55Ij4NCiAgICA8Q29uZGl0aW9ucz4NCiAgICAgIDxGaWxlUHVibGlzaGVyQ29uZGl0aW9uIFB1Ymxpc2hlck5hbWU9Ik89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgUHJvZHVjdE5hbWU9Ik1JQ1JPU09GVCBPRkZJQ0UgT1VUTE9PSyIgQmluYXJ5TmFtZT0iKiI+DQogICAgICAgIDxCaW5hcnlWZXJzaW9uUmFuZ2UgTG93U2VjdGlvbj0iKiIgSGlnaFNlY3Rpb249IjEyLjAuOTk5OS45OTk5IiAvPg0KICAgICAgPC9GaWxlUHVibGlzaGVyQ29uZGl0aW9uPg0KICAgIDwvQ29uZGl0aW9ucz4NCiAgPC9GaWxlUHVibGlzaGVyUnVsZT4NCiAgPEZpbGVQdWJsaXNoZXJSdWxlIElkPSI3YjI3MmVmZC00MTA1LTRmYjctOWQ0MC1iZmE1OTdjNjc5MmEiIE5hbWU9Ik1JQ1JPU09GVCBPRkZJQ0UgMjAxMywgZnJvbSBPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIERlc2NyaXB0aW9uPSIiIFVzZXJPckdyb3VwU2lkPSJTLTEtMS0wIiBBY3Rpb249IkRlbnkiPg0KICAgIDxDb25kaXRpb25zPg0KICAgICAgPEZpbGVQdWJsaXNoZXJDb25kaXRpb24gUHVibGlzaGVyTmFtZT0iTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBQcm9kdWN0TmFtZT0iTUlDUk9TT0ZUIE9GRklDRSAyMDEzIiBCaW5hcnlOYW1lPSIqIj4NCiAgICAgICAgPEJpbmFyeVZlcnNpb25SYW5nZSBMb3dTZWN0aW9uPSIqIiBIaWdoU2VjdGlvbj0iKiIgLz4NCiAgICAgIDwvRmlsZVB1Ymxpc2hlckNvbmRpdGlvbj4NCiAgICA8L0NvbmRpdGlvbnM+DQogIDwvRmlsZVB1Ymxpc2hlclJ1bGU+DQogIDxGaWxlUHVibGlzaGVyUnVsZSBJZD0iODlkOGE0ZDMtZjllMy00MjNhLTkyYWUtODZlNzMzM2UyNjYyIiBOYW1lPSJNSUNST1NPRlQgT05FTk9URSwgZnJvbSBPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIERlc2NyaXB0aW9uPSIiIFVzZXJPckdyb3VwU2lkPSJTLTEtMS0wIiBBY3Rpb249IkRlbnkiPg0KICAgIDxDb25kaXRpb25zPg0KICAgICAgPEZpbGVQdWJsaXNoZXJDb25kaXRpb24gUHVibGlzaGVyTmFtZT0iTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBQcm9kdWN0TmFtZT0iTUlDUk9TT0ZUIE9ORU5PVEUiIEJpbmFyeU5hbWU9IioiPg0KICAgICAgICA8QmluYXJ5VmVyc2lvblJhbmdlIExvd1NlY3Rpb249IioiIEhpZ2hTZWN0aW9uPSIqIiAvPg0KICAgICAgPC9GaWxlUHVibGlzaGVyQ29uZGl0aW9uPg0KICAgIDwvQ29uZGl0aW9ucz4NCiAgICA8RXhjZXB0aW9ucz4NCiAgICAgIDxGaWxlUHVibGlzaGVyQ29uZGl0aW9uIFB1Ymxpc2hlck5hbWU9Ik89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgUHJvZHVjdE5hbWU9Ik1JQ1JPU09GVCBPTkVOT1RFIiBCaW5hcnlOYW1lPSJPTkVOT1RFLkVYRSI+DQogICAgICAgIDxCaW5hcnlWZXJzaW9uUmFuZ2UgTG93U2VjdGlvbj0iMTYuMC43NTAwLjAwMDAiIEhpZ2hTZWN0aW9uPSIqIiAvPg0KICAgICAgPC9GaWxlUHVibGlzaGVyQ29uZGl0aW9uPg0KICAgIDwvRXhjZXB0aW9ucz4NCiAgPC9GaWxlUHVibGlzaGVyUnVsZT4NCiAgPEZpbGVQdWJsaXNoZXJSdWxlIElkPSI1YTIxMzhiZC04MDQyLTRlYzUtOTViNC1mOTkwNjY2ZmJmNjEiIE5hbWU9Ik1JQ1JPU09GVCBPVVRMT09LLCBmcm9tIE89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgRGVzY3JpcHRpb249IiIgVXNlck9yR3JvdXBTaWQ9IlMtMS0xLTAiIEFjdGlvbj0iRGVueSI+DQogICAgPENvbmRpdGlvbnM+DQogICAgICA8RmlsZVB1Ymxpc2hlckNvbmRpdGlvbiBQdWJsaXNoZXJOYW1lPSJPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIFByb2R1Y3ROYW1lPSJNSUNST1NPRlQgT1VUTE9PSyIgQmluYXJ5TmFtZT0iKiI+DQogICAgICAgIDxCaW5hcnlWZXJzaW9uUmFuZ2UgTG93U2VjdGlvbj0iKiIgSGlnaFNlY3Rpb249IioiIC8+DQogICAgICA8L0ZpbGVQdWJsaXNoZXJDb25kaXRpb24+DQogICAgPC9Db25kaXRpb25zPg0KICAgIDxFeGNlcHRpb25zPg0KICAgICAgPEZpbGVQdWJsaXNoZXJDb25kaXRpb24gUHVibGlzaGVyTmFtZT0iTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBQcm9kdWN0TmFtZT0iTUlDUk9TT0ZUIE9VVExPT0siIEJpbmFyeU5hbWU9Ik9VVExPT0suRVhFIj4NCiAgICAgICAgPEJpbmFyeVZlcnNpb25SYW5nZSBMb3dTZWN0aW9uPSIxNi4wLjc1MDAuMDAwMCIgSGlnaFNlY3Rpb249IioiIC8+DQogICAgICA8L0ZpbGVQdWJsaXNoZXJDb25kaXRpb24+DQogICAgPC9FeGNlcHRpb25zPg0KICA8L0ZpbGVQdWJsaXNoZXJSdWxlPg0KICA8RmlsZVB1Ymxpc2hlclJ1bGUgSWQ9IjNmYzVmOWM1LWYxODAtNDM1Yi04MzhmLTI5NjAxMDZhMzg2MCIgTmFtZT0iTUlDUk9TT0ZUIE9ORURSSVZFLCBmcm9tIE89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgRGVzY3JpcHRpb249IiIgVXNlck9yR3JvdXBTaWQ9IlMtMS0xLTAiIEFjdGlvbj0iRGVueSI+DQogICAgPENvbmRpdGlvbnM+DQogICAgICA8RmlsZVB1Ymxpc2hlckNvbmRpdGlvbiBQdWJsaXNoZXJOYW1lPSJPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIFByb2R1Y3ROYW1lPSJNSUNST1NPRlQgT05FRFJJVkUiIEJpbmFyeU5hbWU9IioiPg0KICAgICAgICA8QmluYXJ5VmVyc2lvblJhbmdlIExvd1NlY3Rpb249IioiIEhpZ2hTZWN0aW9uPSIqIiAvPg0KICAgICAgPC9GaWxlUHVibGlzaGVyQ29uZGl0aW9uPg0KICAgIDwvQ29uZGl0aW9ucz4NCiAgICA8RXhjZXB0aW9ucz4NCiAgICAgIDxGaWxlUHVibGlzaGVyQ29uZGl0aW9uIFB1Ymxpc2hlck5hbWU9Ik89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgUHJvZHVjdE5hbWU9Ik1JQ1JPU09GVCBPTkVEUklWRSIgQmluYXJ5TmFtZT0iT05FRFJJVkUuRVhFIj4NCiAgICAgICAgPEJpbmFyeVZlcnNpb25SYW5nZSBMb3dTZWN0aW9uPSIxNy4zLjYzODYuMDQxMiIgSGlnaFNlY3Rpb249IioiIC8+DQogICAgICA8L0ZpbGVQdWJsaXNoZXJDb25kaXRpb24+DQogICAgPC9FeGNlcHRpb25zPg0KICA8L0ZpbGVQdWJsaXNoZXJSdWxlPg0KICA8RmlsZVB1Ymxpc2hlclJ1bGUgSWQ9IjE3ZDk4OGVmLTA3M2UtNGQ5Mi1iNGJmLWY0NzdiMmVjY2NiNSIgTmFtZT0iTUlDUk9TT0ZUIE9GRklDRSAyMDE2LCBmcm9tIE89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgRGVzY3JpcHRpb249IiIgVXNlck9yR3JvdXBTaWQ9IlMtMS0xLTAiIEFjdGlvbj0iRGVueSI+DQogICAgPENvbmRpdGlvbnM+DQogICAgICA8RmlsZVB1Ymxpc2hlckNvbmRpdGlvbiBQdWJsaXNoZXJOYW1lPSJPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIFByb2R1Y3ROYW1lPSJNSUNST1NPRlQgT0ZGSUNFIDIwMTYiIEJpbmFyeU5hbWU9IioiPg0KICAgICAgICA8QmluYXJ5VmVyc2lvblJhbmdlIExvd1NlY3Rpb249IioiIEhpZ2hTZWN0aW9uPSIqIiAvPg0KICAgICAgPC9GaWxlUHVibGlzaGVyQ29uZGl0aW9uPg0KICAgIDwvQ29uZGl0aW9ucz4NCiAgICA8RXhjZXB0aW9ucz4NCiAgICAgIDxGaWxlUHVibGlzaGVyQ29uZGl0aW9uIFB1Ymxpc2hlck5hbWU9Ik89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgUHJvZHVjdE5hbWU9Ik1JQ1JPU09GVCBPRkZJQ0UgMjAxNiIgQmluYXJ5TmFtZT0iTFlOQy5FWEUiPg0KICAgICAgICA8QmluYXJ5VmVyc2lvblJhbmdlIExvd1NlY3Rpb249IjE2LjAuNzUwMC4wMDAwIiBIaWdoU2VjdGlvbj0iKiIgLz4NCiAgICAgIDwvRmlsZVB1Ymxpc2hlckNvbmRpdGlvbj4NCiAgICAgIDxGaWxlUHVibGlzaGVyQ29uZGl0aW9uIFB1Ymxpc2hlck5hbWU9Ik89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgUHJvZHVjdE5hbWU9Ik1JQ1JPU09GVCBPRkZJQ0UgMjAxNiIgQmluYXJ5TmFtZT0iTFlOQzk5LkVYRSI+DQogICAgICAgIDxCaW5hcnlWZXJzaW9uUmFuZ2UgTG93U2VjdGlvbj0iMTYuMC43NTAwLjAwMDAiIEhpZ2hTZWN0aW9uPSIqIiAvPg0KICAgICAgPC9GaWxlUHVibGlzaGVyQ29uZGl0aW9uPg0KICAgICAgPEZpbGVQdWJsaXNoZXJDb25kaXRpb24gUHVibGlzaGVyTmFtZT0iTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBQcm9kdWN0TmFtZT0iTUlDUk9TT0ZUIE9GRklDRSAyMDE2IiBCaW5hcnlOYW1lPSJVQ01BUEkuRVhFIj4NCiAgICAgICAgPEJpbmFyeVZlcnNpb25SYW5nZSBMb3dTZWN0aW9uPSIxNi4wLjc1MDAuMDAwMCIgSGlnaFNlY3Rpb249IioiIC8+DQogICAgICA8L0ZpbGVQdWJsaXNoZXJDb25kaXRpb24+DQogICAgICA8RmlsZVB1Ymxpc2hlckNvbmRpdGlvbiBQdWJsaXNoZXJOYW1lPSJPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIFByb2R1Y3ROYW1lPSJNSUNST1NPRlQgT0ZGSUNFIDIwMTYiIEJpbmFyeU5hbWU9Ik9DUFVCTUdSLkVYRSI+DQogICAgICAgIDxCaW5hcnlWZXJzaW9uUmFuZ2UgTG93U2VjdGlvbj0iMTYuMC43NTAwLjAwMDAiIEhpZ2hTZWN0aW9uPSIqIiAvPg0KICAgICAgPC9GaWxlUHVibGlzaGVyQ29uZGl0aW9uPg0KICAgICAgPEZpbGVQdWJsaXNoZXJDb25kaXRpb24gUHVibGlzaGVyTmFtZT0iTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBQcm9kdWN0TmFtZT0iTUlDUk9TT0ZUIE9GRklDRSAyMDE2IiBCaW5hcnlOYW1lPSJXSU5XT1JELkVYRSI+DQogICAgICAgIDxCaW5hcnlWZXJzaW9uUmFuZ2UgTG93U2VjdGlvbj0iMTYuMC43NTAwLjAwMDAiIEhpZ2hTZWN0aW9uPSIqIiAvPg0KICAgICAgPC9GaWxlUHVibGlzaGVyQ29uZGl0aW9uPg0KICAgICAgPEZpbGVQdWJsaXNoZXJDb25kaXRpb24gUHVibGlzaGVyTmFtZT0iTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBQcm9kdWN0TmFtZT0iTUlDUk9TT0ZUIE9GRklDRSAyMDE2IiBCaW5hcnlOYW1lPSJFWENFTC5FWEUiPg0KICAgICAgICA8QmluYXJ5VmVyc2lvblJhbmdlIExvd1NlY3Rpb249IjE2LjAuNzUwMC4wMDAwIiBIaWdoU2VjdGlvbj0iKiIgLz4NCiAgICAgIDwvRmlsZVB1Ymxpc2hlckNvbmRpdGlvbj4NCiAgICAgIDxGaWxlUHVibGlzaGVyQ29uZGl0aW9uIFB1Ymxpc2hlck5hbWU9Ik89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgUHJvZHVjdE5hbWU9Ik1JQ1JPU09GVCBPRkZJQ0UgMjAxNiIgQmluYXJ5TmFtZT0iUE9XRVJQTlQuRVhFIj4NCiAgICAgICAgPEJpbmFyeVZlcnNpb25SYW5nZSBMb3dTZWN0aW9uPSIxNi4wLjc1MDAuMDAwMCIgSGlnaFNlY3Rpb249IioiIC8+DQogICAgICA8L0ZpbGVQdWJsaXNoZXJDb25kaXRpb24+DQogICAgICA8RmlsZVB1Ymxpc2hlckNvbmRpdGlvbiBQdWJsaXNoZXJOYW1lPSJPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIFByb2R1Y3ROYW1lPSJNSUNST1NPRlQgT0ZGSUNFIDIwMTYiIEJpbmFyeU5hbWU9Ik1TT1NZTkMuRVhFIj4NCiAgICAgICAgPEJpbmFyeVZlcnNpb25SYW5nZSBMb3dTZWN0aW9uPSIxNi4wLjc1MDAuMDAwMCIgSGlnaFNlY3Rpb249IioiIC8+DQogICAgICA8L0ZpbGVQdWJsaXNoZXJDb25kaXRpb24+DQogICAgPC9FeGNlcHRpb25zPg0KICA8L0ZpbGVQdWJsaXNoZXJSdWxlPg0KPC9SdWxlQ29sbGVjdGlvbj4NCjwvQXBwTG9ja2VyUG9saWN5Pg==",
      "id": "a23470d1-1fb1-445f-9282-e4a7d10ff5b8",
      "@odata.type": "
    },
    {
      "displayName": "Office-365-ProPlus-1708-Allowed.xml",
      "fileHash": "4107a857-0e0b-483f-8ff5-bb3ed095b434",
      "file": "PEFwcExvY2tlclBvbGljeSBWZXJzaW9uPSIxIj4NCiAgPFJ1bGVDb2xsZWN0aW9uIFR5cGU9IkV4ZSIgRW5mb3JjZW1lbnRNb2RlPSJFbmFibGVkIj4NCiAgICA8RmlsZVB1Ymxpc2hlclJ1bGUgSWQ9ImQ2NjMyNzZjLTU0NGUtNGRlYS1iNzVjLTc1ZmMyZDRlMDI2NiIgTmFtZT0iTFlOQy5FWEUsIHZlcnNpb24gMTYuMC43ODcwLjIwMjAgYW5kIGFib3ZlLCBpbiBNSUNST1NPRlQgT0ZGSUNFIDIwMTYsIGZyb20gTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBEZXNjcmlwdGlvbj0iIiBVc2VyT3JHcm91cFNpZD0iUy0xLTEtMCIgQWN0aW9uPSJBbGxvdyI+DQogICAgICA8Q29uZGl0aW9ucz4NCiAgICAgICAgPEZpbGVQdWJsaXNoZXJDb25kaXRpb24gUHVibGlzaGVyTmFtZT0iTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBQcm9kdWN0TmFtZT0iTUlDUk9TT0ZUIE9GRklDRSAyMDE2IiBCaW5hcnlOYW1lPSJMWU5DLkVYRSI+DQoJCSAgICAgICAgICA8QmluYXJ5VmVyc2lvblJhbmdlIExvd1NlY3Rpb249IjE2LjAuNzg3MC4yMDIwIiBIaWdoU2VjdGlvbj0iKiIgLz4NCiAgICAgICAgPC9GaWxlUHVibGlzaGVyQ29uZGl0aW9uPg0KICAgICAgPC9Db25kaXRpb25zPg0KCTwvRmlsZVB1Ymxpc2hlclJ1bGU+DQogICAgPEZpbGVQdWJsaXNoZXJSdWxlIElkPSIyMTk1NzFiNC1hMjU3LTRiNGMtYjg1Ni1lYmYwNjgxZWUwZjAiIE5hbWU9IkxZTkM5OS5FWEUsIHZlcnNpb24gMTYuMC43ODcwLjIwMjAgYW5kIGFib3ZlLCBpbiBNSUNST1NPRlQgT0ZGSUNFIDIwMTYsIGZyb20gTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBEZXNjcmlwdGlvbj0iIiBVc2VyT3JHcm91cFNpZD0iUy0xLTEtMCIgQWN0aW9uPSJBbGxvdyI+DQogICAgICA8Q29uZGl0aW9ucz4NCiAgICAgICAgPEZpbGVQdWJsaXNoZXJDb25kaXRpb24gUHVibGlzaGVyTmFtZT0iTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBQcm9kdWN0TmFtZT0iTUlDUk9TT0ZUIE9GRklDRSAyMDE2IiBCaW5hcnlOYW1lPSJMWU5DOTkuRVhFIj4NCiAgICAgICAgICA8QmluYXJ5VmVyc2lvblJhbmdlIExvd1NlY3Rpb249IjE2LjAuNzg3MC4yMDIwIiBIaWdoU2VjdGlvbj0iKiIgLz4NCiAgICAgICAgPC9GaWxlUHVibGlzaGVyQ29uZGl0aW9uPg0KICAgICAgPC9Db25kaXRpb25zPg0KICAgIDwvRmlsZVB1Ymxpc2hlclJ1bGU+DQogICAgPEZpbGVQdWJsaXNoZXJSdWxlIElkPSI1MzhkNDQzYS05ZmRiLTQ5MWUtOGJjMy1lNzhkYjljMzEwYzciIE5hbWU9Ik9ORU5PVEVNLkVYRSwgdmVyc2lvbiAxNi4wLjgyMDEuMjAyNSBhbmQgYWJvdmUsIGluIE1JQ1JPU09GVCBPTkVOT1RFLCBmcm9tIE89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgRGVzY3JpcHRpb249IiIgVXNlck9yR3JvdXBTaWQ9IlMtMS0xLTAiIEFjdGlvbj0iQWxsb3ciPg0KICAgICAgPENvbmRpdGlvbnM+DQogICAgICAgIDxGaWxlUHVibGlzaGVyQ29uZGl0aW9uIFB1Ymxpc2hlck5hbWU9Ik89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgUHJvZHVjdE5hbWU9Ik1JQ1JPU09GVCBPTkVOT1RFIiBCaW5hcnlOYW1lPSJPTkVOT1RFTS5FWEUiPg0KICAgICAgICAgIDxCaW5hcnlWZXJzaW9uUmFuZ2UgTG93U2VjdGlvbj0iMTYuMC44MjAxLjIwMjUiIEhpZ2hTZWN0aW9uPSIqIiAvPg0KICAgICAgICA8L0ZpbGVQdWJsaXNoZXJDb25kaXRpb24+DQogICAgICA8L0NvbmRpdGlvbnM+DQogICAgPC9GaWxlUHVibGlzaGVyUnVsZT4NCiAgICA8RmlsZVB1Ymxpc2hlclJ1bGUgSWQ9IjZlZjA3YTkyLWYxZGItNDg4MC04YjQwLWRkMzliNzQzYTQ4NSIgTmFtZT0iV0lOV09SRC5FWEUsIHZlcnNpb24gMTYuMC44MjAxLjIwMjUgYW5kIGFib3ZlLCBpbiBNSUNST1NPRlQgT0ZGSUNFIDIwMTYsIGZyb20gTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBEZXNjcmlwdGlvbj0iIiBVc2VyT3JHcm91cFNpZD0iUy0xLTEtMCIgQWN0aW9uPSJBbGxvdyI+DQogICAgICA8Q29uZGl0aW9ucz4NCiAgICAgICAgPEZpbGVQdWJsaXNoZXJDb25kaXRpb24gUHVibGlzaGVyTmFtZT0iTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBQcm9kdWN0TmFtZT0iTUlDUk9TT0ZUIE9GRklDRSAyMDE2IiBCaW5hcnlOYW1lPSJXSU5XT1JELkVYRSI+DQogICAgICAgICAgPEJpbmFyeVZlcnNpb25SYW5nZSBMb3dTZWN0aW9uPSIxNi4wLjgyMDEuMjAyNSIgSGlnaFNlY3Rpb249IioiIC8+DQogICAgICAgIDwvRmlsZVB1Ymxpc2hlckNvbmRpdGlvbj4NCiAgICAgIDwvQ29uZGl0aW9ucz4NCiAgICA8L0ZpbGVQdWJsaXNoZXJSdWxlPg0KICAgIDxGaWxlUHVibGlzaGVyUnVsZSBJZD0iN2Q3NGQxYWQtYTYwYi00ZWE4LWJiNjAtM2Q0MDQ4ODZkMTBiIiBOYW1lPSJPTkVOT1RFLkVYRSwgdmVyc2lvbiAxNi4wLjgyMDEuMjAyNSBhbmQgYWJvdmUsIGluIE1JQ1JPU09GVCBPTkVOT1RFLCBmcm9tIE89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgRGVzY3JpcHRpb249IiIgVXNlck9yR3JvdXBTaWQ9IlMtMS0xLTAiIEFjdGlvbj0iQWxsb3ciPg0KICAgICAgPENvbmRpdGlvbnM+DQogICAgICAgIDxGaWxlUHVibGlzaGVyQ29uZGl0aW9uIFB1Ymxpc2hlck5hbWU9Ik89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgUHJvZHVjdE5hbWU9Ik1JQ1JPU09GVCBPTkVOT1RFIiBCaW5hcnlOYW1lPSJPTkVOT1RFLkVYRSI+DQogICAgICAgICAgPEJpbmFyeVZlcnNpb25SYW5nZSBMb3dTZWN0aW9uPSIxNi4wLjgyMDEuMjAyNSIgSGlnaFNlY3Rpb249IioiIC8+DQogICAgICAgIDwvRmlsZVB1Ymxpc2hlckNvbmRpdGlvbj4NCiAgICAgIDwvQ29uZGl0aW9ucz4NCiAgICA8L0ZpbGVQdWJsaXNoZXJSdWxlPg0KICAgIDxGaWxlUHVibGlzaGVyUnVsZSBJZD0iODQwOWFhNjItMWI1Mi00ODRiLTg3ODctZDU3Y2M4NTI1ZTIxIiBOYW1lPSJPQ1BVQk1HUi5FWEUsIHZlcnNpb24gMTYuMC43ODcwLjIwMjAgYW5kIGFib3ZlLCBpbiBNSUNST1NPRlQgT0ZGSUNFIDIwMTYsIGZyb20gTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBEZXNjcmlwdGlvbj0iIiBVc2VyT3JHcm91cFNpZD0iUy0xLTEtMCIgQWN0aW9uPSJBbGxvdyI+DQogICAgICA8Q29uZGl0aW9ucz4NCiAgICAgICAgPEZpbGVQdWJsaXNoZXJDb25kaXRpb24gUHVibGlzaGVyTmFtZT0iTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBQcm9kdWN0TmFtZT0iTUlDUk9TT0ZUIE9GRklDRSAyMDE2IiBCaW5hcnlOYW1lPSJPQ1BVQk1HUi5FWEUiPg0KICAgICAgICAgIDxCaW5hcnlWZXJzaW9uUmFuZ2UgTG93U2VjdGlvbj0iMTYuMC43ODcwLjIwMjAiIEhpZ2hTZWN0aW9uPSIqIiAvPg0KICAgICAgICA8L0ZpbGVQdWJsaXNoZXJDb25kaXRpb24+DQogICAgICA8L0NvbmRpdGlvbnM+DQogICAgPC9GaWxlUHVibGlzaGVyUnVsZT4NCiAgICA8RmlsZVB1Ymxpc2hlclJ1bGUgSWQ9ImU2Y2NjY2QxLWE2MGYtNGNiNC04YjRiLTkwM2M3MDk3NmI1MCIgTmFtZT0iUE9XRVJQTlQuRVhFLCB2ZXJzaW9uIDE2LjAuODIwMS4yMDI1IGFuZCBhYm92ZSwgaW4gTUlDUk9TT0ZUIE9GRklDRSAyMDE2LCBmcm9tIE89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgRGVzY3JpcHRpb249IiIgVXNlck9yR3JvdXBTaWQ9IlMtMS0xLTAiIEFjdGlvbj0iQWxsb3ciPg0KICAgICAgPENvbmRpdGlvbnM+DQogICAgICAgIDxGaWxlUHVibGlzaGVyQ29uZGl0aW9uIFB1Ymxpc2hlck5hbWU9Ik89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgUHJvZHVjdE5hbWU9Ik1JQ1JPU09GVCBPRkZJQ0UgMjAxNiIgQmluYXJ5TmFtZT0iUE9XRVJQTlQuRVhFIj4NCiAgICAgICAgICA8QmluYXJ5VmVyc2lvblJhbmdlIExvd1NlY3Rpb249IjE2LjAuODIwMS4yMDI1IiBIaWdoU2VjdGlvbj0iKiIgLz4NCiAgICAgICAgPC9GaWxlUHVibGlzaGVyQ29uZGl0aW9uPg0KICAgICAgPC9Db25kaXRpb25zPg0KICAgIDwvRmlsZVB1Ymxpc2hlclJ1bGU+DQogICAgPEZpbGVQdWJsaXNoZXJSdWxlIElkPSJlYzc5ZWJiZS0zMTY5LTRhMjYtYWY1ZS1lMDc2YzkwOTY0OTUiIE5hbWU9Ik1TT1NZTkMuRVhFLCB2ZXJzaW9uIDE2LjAuODIwMS4yMDI1IGFuZCBhYm92ZSwgaW4gTUlDUk9TT0ZUIE9GRklDRSAyMDE2LCBmcm9tIE89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgRGVzY3JpcHRpb249IiIgVXNlck9yR3JvdXBTaWQ9IlMtMS0xLTAiIEFjdGlvbj0iQWxsb3ciPg0KICAgICAgPENvbmRpdGlvbnM+DQogICAgICAgIDxGaWxlUHVibGlzaGVyQ29uZGl0aW9uIFB1Ymxpc2hlck5hbWU9Ik89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgUHJvZHVjdE5hbWU9Ik1JQ1JPU09GVCBPRkZJQ0UgMjAxNiIgQmluYXJ5TmFtZT0iTVNPU1lOQy5FWEUiPg0KICAgICAgICAgIDxCaW5hcnlWZXJzaW9uUmFuZ2UgTG93U2VjdGlvbj0iMTYuMC44MjAxLjIwMjUiIEhpZ2hTZWN0aW9uPSIqIiAvPg0KICAgICAgICA8L0ZpbGVQdWJsaXNoZXJDb25kaXRpb24+DQogICAgICA8L0NvbmRpdGlvbnM+DQogICAgPC9GaWxlUHVibGlzaGVyUnVsZT4NCiAgICA8RmlsZVB1Ymxpc2hlclJ1bGUgSWQ9ImYwYjM1MjZiLTE0ZTctNDQyOC05NzAzLTRkZmYyZWE0MDAwZCIgTmFtZT0iVUNNQVBJLkVYRSwgdmVyc2lvbiAxNi4wLjc4NzAuMjAyMCBhbmQgYWJvdmUsIGluIE1JQ1JPU09GVCBPRkZJQ0UgMjAxNiwgZnJvbSBPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIERlc2NyaXB0aW9uPSIiIFVzZXJPckdyb3VwU2lkPSJTLTEtMS0wIiBBY3Rpb249IkFsbG93Ij4NCiAgICAgIDxDb25kaXRpb25zPg0KICAgICAgICA8RmlsZVB1Ymxpc2hlckNvbmRpdGlvbiBQdWJsaXNoZXJOYW1lPSJPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIFByb2R1Y3ROYW1lPSJNSUNST1NPRlQgT0ZGSUNFIDIwMTYiIEJpbmFyeU5hbWU9IlVDTUFQSS5FWEUiPg0KICAgICAgICAgIDxCaW5hcnlWZXJzaW9uUmFuZ2UgTG93U2VjdGlvbj0iMTYuMC43ODcwLjIwMjAiIEhpZ2hTZWN0aW9uPSIqIiAvPg0KICAgICAgICA8L0ZpbGVQdWJsaXNoZXJDb25kaXRpb24+DQogICAgICA8L0NvbmRpdGlvbnM+DQogICAgPC9GaWxlUHVibGlzaGVyUnVsZT4NCiAgICA8RmlsZVB1Ymxpc2hlclJ1bGUgSWQ9ImYxYmVkY2IxLWNhMzQtNDdiNS04NmM4LTI1NjU0YjE3OGNiOSIgTmFtZT0iT1VUTE9PSy5FWEUsIHZlcnNpb24gMTYuMC44MjAxLjIwMjUgYW5kIGFib3ZlLCBpbiBNSUNST1NPRlQgT1VUTE9PSywgZnJvbSBPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIERlc2NyaXB0aW9uPSIiIFVzZXJPckdyb3VwU2lkPSJTLTEtMS0wIiBBY3Rpb249IkFsbG93Ij4NCiAgICAgIDxDb25kaXRpb25zPg0KICAgICAgICA8RmlsZVB1Ymxpc2hlckNvbmRpdGlvbiBQdWJsaXNoZXJOYW1lPSJPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIFByb2R1Y3ROYW1lPSJNSUNST1NPRlQgT1VUTE9PSyIgQmluYXJ5TmFtZT0iT1VUTE9PSy5FWEUiPg0KICAgICAgICAgIDxCaW5hcnlWZXJzaW9uUmFuZ2UgTG93U2VjdGlvbj0iMTYuMC44MjAxLjIwMjUiIEhpZ2hTZWN0aW9uPSIqIiAvPg0KICAgICAgICA8L0ZpbGVQdWJsaXNoZXJDb25kaXRpb24+DQogICAgICA8L0NvbmRpdGlvbnM+DQogICAgPC9GaWxlUHVibGlzaGVyUnVsZT4NCiAgICA8RmlsZVB1Ymxpc2hlclJ1bGUgSWQ9ImY5NjFlODQ2LTNmZTctNDY0Yy05NTA4LTAzNTMzN2QxZTg2OCIgTmFtZT0iRVhDRUwuRVhFLCB2ZXJzaW9uIDE2LjAuODIwMS4yMDI1IGFuZCBhYm92ZSwgaW4gTUlDUk9TT0ZUIE9GRklDRSAyMDE2LCBmcm9tIE89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgRGVzY3JpcHRpb249IiIgVXNlck9yR3JvdXBTaWQ9IlMtMS0xLTAiIEFjdGlvbj0iQWxsb3ciPg0KICAgICAgPENvbmRpdGlvbnM+DQogICAgICAgIDxGaWxlUHVibGlzaGVyQ29uZGl0aW9uIFB1Ymxpc2hlck5hbWU9Ik89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgUHJvZHVjdE5hbWU9Ik1JQ1JPU09GVCBPRkZJQ0UgMjAxNiIgQmluYXJ5TmFtZT0iRVhDRUwuRVhFIj4NCiAgICAgICAgICA8QmluYXJ5VmVyc2lvblJhbmdlIExvd1NlY3Rpb249IjE2LjAuODIwMS4yMDI1IiBIaWdoU2VjdGlvbj0iKiIgLz4NCiAgICAgICAgPC9GaWxlUHVibGlzaGVyQ29uZGl0aW9uPg0KICAgICAgPC9Db25kaXRpb25zPg0KICAgIDwvRmlsZVB1Ymxpc2hlclJ1bGU+DQogICAgPEZpbGVQdWJsaXNoZXJSdWxlIElkPSJkNzAzMzE5Yy0wYzllLTQ0NjctYWQwOS03MTMzMDdlMzBkZjYiIE5hbWU9Ik1JQ1JPU09GVCBPRkZJQ0UsIGZyb20gTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBEZXNjcmlwdGlvbj0iIiBVc2VyT3JHcm91cFNpZD0iUy0xLTEtMCIgQWN0aW9uPSJEZW55Ij4NCiAgICAgIDxDb25kaXRpb25zPg0KICAgICAgICA8RmlsZVB1Ymxpc2hlckNvbmRpdGlvbiBQdWJsaXNoZXJOYW1lPSJPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIFByb2R1Y3ROYW1lPSJNSUNST1NPRlQgT0ZGSUNFIiBCaW5hcnlOYW1lPSIqIj4NCiAgICAgICAgICA8QmluYXJ5VmVyc2lvblJhbmdlIExvd1NlY3Rpb249IioiIEhpZ2hTZWN0aW9uPSIqIiAvPg0KICAgICAgICA8L0ZpbGVQdWJsaXNoZXJDb25kaXRpb24+DQogICAgICA8L0NvbmRpdGlvbnM+DQogICAgPC9GaWxlUHVibGlzaGVyUnVsZT4NCiAgICA8RmlsZVB1Ymxpc2hlclJ1bGUgSWQ9ImRlOWYzNDYxLTY4NTYtNDA1ZC05NjI0LWE4MGNhNzAxZjZjYiIgTmFtZT0iTUlDUk9TT0ZUIE9GRklDRSAyMDAzLCBmcm9tIE89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgRGVzY3JpcHRpb249IiIgVXNlck9yR3JvdXBTaWQ9IlMtMS0xLTAiIEFjdGlvbj0iRGVueSI+DQogICAgICA8Q29uZGl0aW9ucz4NCiAgICAgICAgPEZpbGVQdWJsaXNoZXJDb25kaXRpb24gUHVibGlzaGVyTmFtZT0iTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBQcm9kdWN0TmFtZT0iTUlDUk9TT0ZUIE9GRklDRSAyMDAzIiBCaW5hcnlOYW1lPSIqIj4NCiAgICAgICAgICA8QmluYXJ5VmVyc2lvblJhbmdlIExvd1NlY3Rpb249IioiIEhpZ2hTZWN0aW9uPSIqIiAvPg0KICAgICAgICA8L0ZpbGVQdWJsaXNoZXJDb25kaXRpb24+DQogICAgICA8L0NvbmRpdGlvbnM+DQogICAgPC9GaWxlUHVibGlzaGVyUnVsZT4NCiAgICA8RmlsZVB1Ymxpc2hlclJ1bGUgSWQ9ImFkZTFiODI4LTcwNTUtNDdmYy05OWJjLTQzMmNmN2QxMjA5ZSIgTmFtZT0iMjAwNyBNSUNST1NPRlQgT0ZGSUNFIFNZU1RFTSwgZnJvbSBPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIERlc2NyaXB0aW9uPSIiIFVzZXJPckdyb3VwU2lkPSJTLTEtMS0wIiBBY3Rpb249IkRlbnkiPg0KICAgICAgPENvbmRpdGlvbnM+DQogICAgICAgIDxGaWxlUHVibGlzaGVyQ29uZGl0aW9uIFB1Ymxpc2hlck5hbWU9Ik89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgUHJvZHVjdE5hbWU9IjIwMDcgTUlDUk9TT0ZUIE9GRklDRSBTWVNURU0iIEJpbmFyeU5hbWU9IioiPg0KICAgICAgICAgIDxCaW5hcnlWZXJzaW9uUmFuZ2UgTG93U2VjdGlvbj0iKiIgSGlnaFNlY3Rpb249IioiIC8+DQogICAgICAgIDwvRmlsZVB1Ymxpc2hlckNvbmRpdGlvbj4NCiAgICAgIDwvQ29uZGl0aW9ucz4NCiAgICA8L0ZpbGVQdWJsaXNoZXJSdWxlPg0KICAgIDxGaWxlUHVibGlzaGVyUnVsZSBJZD0iYmIzODc3YjYtZjFhZC00YzgzLTk2ZTItZDZiZjc1ZTMzY2JmIiBOYW1lPSJNSUNST1NPRlQgT0ZGSUNFIDIwMTAsIGZyb20gTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBEZXNjcmlwdGlvbj0iIiBVc2VyT3JHcm91cFNpZD0iUy0xLTEtMCIgQWN0aW9uPSJEZW55Ij4NCiAgICAgIDxDb25kaXRpb25zPg0KICAgICAgICA8RmlsZVB1Ymxpc2hlckNvbmRpdGlvbiBQdWJsaXNoZXJOYW1lPSJPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIFByb2R1Y3ROYW1lPSJNSUNST1NPRlQgT0ZGSUNFIDIwMTAiIEJpbmFyeU5hbWU9IioiPg0KICAgICAgICAgIDxCaW5hcnlWZXJzaW9uUmFuZ2UgTG93U2VjdGlvbj0iKiIgSGlnaFNlY3Rpb249IioiIC8+DQogICAgICAgIDwvRmlsZVB1Ymxpc2hlckNvbmRpdGlvbj4NCiAgICAgIDwvQ29uZGl0aW9ucz4NCiAgICA8L0ZpbGVQdWJsaXNoZXJSdWxlPg0KICAgIDxGaWxlUHVibGlzaGVyUnVsZSBJZD0iMjM2MzVlZWYtYjFlMy00ZGEyLTg4NTktMDYzOGVjNjA3YjM4IiBOYW1lPSJNSUNST1NPRlQgT0ZGSUNFIDIwMTMsIGZyb20gTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBEZXNjcmlwdGlvbj0iIiBVc2VyT3JHcm91cFNpZD0iUy0xLTEtMCIgQWN0aW9uPSJEZW55Ij4NCiAgICAgIDxDb25kaXRpb25zPg0KICAgICAgICA8RmlsZVB1Ymxpc2hlckNvbmRpdGlvbiBQdWJsaXNoZXJOYW1lPSJPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIFByb2R1Y3ROYW1lPSJNSUNST1NPRlQgT0ZGSUNFIDIwMTMiIEJpbmFyeU5hbWU9IioiPg0KICAgICAgICAgIDxCaW5hcnlWZXJzaW9uUmFuZ2UgTG93U2VjdGlvbj0iKiIgSGlnaFNlY3Rpb249IioiIC8+DQogICAgICAgIDwvRmlsZVB1Ymxpc2hlckNvbmRpdGlvbj4NCiAgICAgIDwvQ29uZGl0aW9ucz4NCiAgICA8L0ZpbGVQdWJsaXNoZXJSdWxlPg0KICAgIDxGaWxlUHVibGlzaGVyUnVsZSBJZD0iZDJkMDUyMGEtNTdkZS00YmQ1LWJjZDktYjNkNDcyMjFmODdhIiBOYW1lPSJNSUNST1NPRlQgT0ZGSUNFIDIwMTYsIGZyb20gTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBEZXNjcmlwdGlvbj0iIiBVc2VyT3JHcm91cFNpZD0iUy0xLTEtMCIgQWN0aW9uPSJEZW55Ij4NCiAgICAgIDxDb25kaXRpb25zPg0KICAgICAgICA8RmlsZVB1Ymxpc2hlckNvbmRpdGlvbiBQdWJsaXNoZXJOYW1lPSJPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIFByb2R1Y3ROYW1lPSJNSUNST1NPRlQgT0ZGSUNFIDIwMTYiIEJpbmFyeU5hbWU9IioiPg0KICAgICAgICAgIDxCaW5hcnlWZXJzaW9uUmFuZ2UgTG93U2VjdGlvbj0iKiIgSGlnaFNlY3Rpb249IioiIC8+DQogICAgICAgIDwvRmlsZVB1Ymxpc2hlckNvbmRpdGlvbj4NCiAgICAgIDwvQ29uZGl0aW9ucz4NCiAgICAgIDxFeGNlcHRpb25zPg0KICAgICAgICA8RmlsZVB1Ymxpc2hlckNvbmRpdGlvbiBQdWJsaXNoZXJOYW1lPSJPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIFByb2R1Y3ROYW1lPSJNSUNST1NPRlQgT0ZGSUNFIDIwMTYiIEJpbmFyeU5hbWU9IkVYQ0VMLkVYRSI+DQogICAgICAgICAgPEJpbmFyeVZlcnNpb25SYW5nZSBMb3dTZWN0aW9uPSIxNi4wLjgyMDEuMjAyNSIgSGlnaFNlY3Rpb249IioiIC8+DQogICAgICAgIDwvRmlsZVB1Ymxpc2hlckNvbmRpdGlvbj4NCiAgICAgICAgPEZpbGVQdWJsaXNoZXJDb25kaXRpb24gUHVibGlzaGVyTmFtZT0iTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBQcm9kdWN0TmFtZT0iTUlDUk9TT0ZUIE9GRklDRSAyMDE2IiBCaW5hcnlOYW1lPSJMWU5DLkVYRSI+DQogICAgICAgICAgPEJpbmFyeVZlcnNpb25SYW5nZSBMb3dTZWN0aW9uPSIxNi4wLjc4NzAuMjAyMCIgSGlnaFNlY3Rpb249IioiIC8+DQogICAgICAgIDwvRmlsZVB1Ymxpc2hlckNvbmRpdGlvbj4NCiAgICAgICAgPEZpbGVQdWJsaXNoZXJDb25kaXRpb24gUHVibGlzaGVyTmFtZT0iTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBQcm9kdWN0TmFtZT0iTUlDUk9TT0ZUIE9GRklDRSAyMDE2IiBCaW5hcnlOYW1lPSJMWU5DOTkuRVhFIj4NCiAgICAgICAgICA8QmluYXJ5VmVyc2lvblJhbmdlIExvd1NlY3Rpb249IjE2LjAuNzg3MC4yMDIwIiBIaWdoU2VjdGlvbj0iKiIgLz4NCiAgICAgICAgPC9GaWxlUHVibGlzaGVyQ29uZGl0aW9uPg0KICAgICAgICA8RmlsZVB1Ymxpc2hlckNvbmRpdGlvbiBQdWJsaXNoZXJOYW1lPSJPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIFByb2R1Y3ROYW1lPSJNSUNST1NPRlQgT0ZGSUNFIDIwMTYiIEJpbmFyeU5hbWU9Ik1TT1NZTkMuRVhFIj4NCiAgICAgICAgICA8QmluYXJ5VmVyc2lvblJhbmdlIExvd1NlY3Rpb249IjE2LjAuODIwMS4yMDI1IiBIaWdoU2VjdGlvbj0iKiIgLz4NCiAgICAgICAgPC9GaWxlUHVibGlzaGVyQ29uZGl0aW9uPg0KICAgICAgICA8RmlsZVB1Ymxpc2hlckNvbmRpdGlvbiBQdWJsaXNoZXJOYW1lPSJPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIFByb2R1Y3ROYW1lPSJNSUNST1NPRlQgT0ZGSUNFIDIwMTYiIEJpbmFyeU5hbWU9Ik9DUFVCTUdSLkVYRSI+DQogICAgICAgICAgPEJpbmFyeVZlcnNpb25SYW5nZSBMb3dTZWN0aW9uPSIxNi4wLjc4NzAuMjAyMCIgSGlnaFNlY3Rpb249IioiIC8+DQogICAgICAgIDwvRmlsZVB1Ymxpc2hlckNvbmRpdGlvbj4NCiAgICAgICAgPEZpbGVQdWJsaXNoZXJDb25kaXRpb24gUHVibGlzaGVyTmFtZT0iTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBQcm9kdWN0TmFtZT0iTUlDUk9TT0ZUIE9GRklDRSAyMDE2IiBCaW5hcnlOYW1lPSJQT1dFUlBOVC5FWEUiPg0KICAgICAgICAgIDxCaW5hcnlWZXJzaW9uUmFuZ2UgTG93U2VjdGlvbj0iMTYuMC44MjAxLjIwMjUiIEhpZ2hTZWN0aW9uPSIqIiAvPg0KICAgICAgICA8L0ZpbGVQdWJsaXNoZXJDb25kaXRpb24+DQogICAgICAgIDxGaWxlUHVibGlzaGVyQ29uZGl0aW9uIFB1Ymxpc2hlck5hbWU9Ik89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgUHJvZHVjdE5hbWU9Ik1JQ1JPU09GVCBPRkZJQ0UgMjAxNiIgQmluYXJ5TmFtZT0iVUNNQVBJLkVYRSI+DQogICAgICAgICAgPEJpbmFyeVZlcnNpb25SYW5nZSBMb3dTZWN0aW9uPSIxNi4wLjc4NzAuMjAyMCIgSGlnaFNlY3Rpb249IioiIC8+DQogICAgICAgIDwvRmlsZVB1Ymxpc2hlckNvbmRpdGlvbj4NCiAgICAgICAgPEZpbGVQdWJsaXNoZXJDb25kaXRpb24gUHVibGlzaGVyTmFtZT0iTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBQcm9kdWN0TmFtZT0iTUlDUk9TT0ZUIE9GRklDRSAyMDE2IiBCaW5hcnlOYW1lPSJXSU5XT1JELkVYRSI+DQogICAgICAgICAgPEJpbmFyeVZlcnNpb25SYW5nZSBMb3dTZWN0aW9uPSIxNi4wLjgyMDEuMjAyNSIgSGlnaFNlY3Rpb249IioiIC8+DQogICAgICAgIDwvRmlsZVB1Ymxpc2hlckNvbmRpdGlvbj4NCiAgICAgIDwvRXhjZXB0aW9ucz4NCiAgICA8L0ZpbGVQdWJsaXNoZXJSdWxlPg0KICAgIDxGaWxlUHVibGlzaGVyUnVsZSBJZD0iYTMzNjVkZmYtNjA1Mi00MWE4LTgyYTYtMzQ0NDRlYzI1OTUzIiBOYW1lPSJNSUNST1NPRlQgT05FTk9URSwgZnJvbSBPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIERlc2NyaXB0aW9uPSIiIFVzZXJPckdyb3VwU2lkPSJTLTEtMS0wIiBBY3Rpb249IkRlbnkiPg0KICAgICAgPENvbmRpdGlvbnM+DQogICAgICAgIDxGaWxlUHVibGlzaGVyQ29uZGl0aW9uIFB1Ymxpc2hlck5hbWU9Ik89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgUHJvZHVjdE5hbWU9Ik1JQ1JPU09GVCBPTkVOT1RFIiBCaW5hcnlOYW1lPSIqIj4NCiAgICAgICAgICA8QmluYXJ5VmVyc2lvblJhbmdlIExvd1NlY3Rpb249IioiIEhpZ2hTZWN0aW9uPSIqIiAvPg0KICAgICAgICA8L0ZpbGVQdWJsaXNoZXJDb25kaXRpb24+DQogICAgICA8L0NvbmRpdGlvbnM+DQogICAgICA8RXhjZXB0aW9ucz4NCiAgICAgICAgPEZpbGVQdWJsaXNoZXJDb25kaXRpb24gUHVibGlzaGVyTmFtZT0iTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBQcm9kdWN0TmFtZT0iTUlDUk9TT0ZUIE9ORU5PVEUiIEJpbmFyeU5hbWU9Ik9ORU5PVEUuRVhFIj4NCiAgICAgICAgICA8QmluYXJ5VmVyc2lvblJhbmdlIExvd1NlY3Rpb249IjE2LjAuODIwMS4yMDI1IiBIaWdoU2VjdGlvbj0iKiIgLz4NCiAgICAgICAgPC9GaWxlUHVibGlzaGVyQ29uZGl0aW9uPg0KICAgICAgICA8RmlsZVB1Ymxpc2hlckNvbmRpdGlvbiBQdWJsaXNoZXJOYW1lPSJPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIFByb2R1Y3ROYW1lPSJNSUNST1NPRlQgT05FTk9URSIgQmluYXJ5TmFtZT0iT05FTk9URU0uRVhFIj4NCiAgICAgICAgICA8QmluYXJ5VmVyc2lvblJhbmdlIExvd1NlY3Rpb249IjE2LjAuODIwMS4yMDI1IiBIaWdoU2VjdGlvbj0iKiIgLz4NCiAgICAgICAgPC9GaWxlUHVibGlzaGVyQ29uZGl0aW9uPg0KICAgICAgPC9FeGNlcHRpb25zPg0KICAgIDwvRmlsZVB1Ymxpc2hlclJ1bGU+DQogICAgPEZpbGVQdWJsaXNoZXJSdWxlIElkPSIwYmE0YzE1MC0xY2IzLTRjYjktYWIwMi0yNjUyNzQ0MTk0MDkiIE5hbWU9Ik1JQ1JPU09GVCBPVVRMT09LLCBmcm9tIE89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgRGVzY3JpcHRpb249IiIgVXNlck9yR3JvdXBTaWQ9IlMtMS0xLTAiIEFjdGlvbj0iRGVueSI+DQogICAgICA8Q29uZGl0aW9ucz4NCiAgICAgICAgPEZpbGVQdWJsaXNoZXJDb25kaXRpb24gUHVibGlzaGVyTmFtZT0iTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBQcm9kdWN0TmFtZT0iTUlDUk9TT0ZUIE9VVExPT0siIEJpbmFyeU5hbWU9IioiPg0KICAgICAgICAgIDxCaW5hcnlWZXJzaW9uUmFuZ2UgTG93U2VjdGlvbj0iKiIgSGlnaFNlY3Rpb249IioiIC8+DQogICAgICAgIDwvRmlsZVB1Ymxpc2hlckNvbmRpdGlvbj4NCiAgICAgIDwvQ29uZGl0aW9ucz4NCiAgICAgIDxFeGNlcHRpb25zPg0KICAgICAgICA8RmlsZVB1Ymxpc2hlckNvbmRpdGlvbiBQdWJsaXNoZXJOYW1lPSJPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIFByb2R1Y3ROYW1lPSJNSUNST1NPRlQgT1VUTE9PSyIgQmluYXJ5TmFtZT0iT1VUTE9PSy5FWEUiPg0KICAgICAgICAgIDxCaW5hcnlWZXJzaW9uUmFuZ2UgTG93U2VjdGlvbj0iMTYuMC44MjAxLjIwMjUiIEhpZ2hTZWN0aW9uPSIqIiAvPg0KICAgICAgICA8L0ZpbGVQdWJsaXNoZXJDb25kaXRpb24+DQogICAgICA8L0V4Y2VwdGlvbnM+DQogICAgPC9GaWxlUHVibGlzaGVyUnVsZT4NCiAgICA8RmlsZVB1Ymxpc2hlclJ1bGUgSWQ9IjY3MTRmODVmLWFkZGEtNGVjNy05NDdjLTc1NTJmN2Q5NDYyNSIgTmFtZT0iTUlDUk9TT0ZUIENMSVAgT1JHQU5JWkVSLCBmcm9tIE89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgRGVzY3JpcHRpb249IiIgVXNlck9yR3JvdXBTaWQ9IlMtMS0xLTAiIEFjdGlvbj0iRGVueSI+DQogICAgICA8Q29uZGl0aW9ucz4NCiAgICAgICAgPEZpbGVQdWJsaXNoZXJDb25kaXRpb24gUHVibGlzaGVyTmFtZT0iTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBQcm9kdWN0TmFtZT0iTUlDUk9TT0ZUIENMSVAgT1JHQU5JWkVSIiBCaW5hcnlOYW1lPSIqIj4NCiAgICAgICAgICA8QmluYXJ5VmVyc2lvblJhbmdlIExvd1NlY3Rpb249IioiIEhpZ2hTZWN0aW9uPSIqIiAvPg0KICAgICAgICA8L0ZpbGVQdWJsaXNoZXJDb25kaXRpb24+DQogICAgICA8L0NvbmRpdGlvbnM+DQogICAgPC9GaWxlUHVibGlzaGVyUnVsZT4JDQogICAgPEZpbGVQdWJsaXNoZXJSdWxlIElkPSI3NGFiMzY4Zi1hMTQ3LTRjZjktODBjMy01M2ZiNjY5YzQ4MzYiIE5hbWU9Ik1JQ1JPU09GVCBPRkZJQ0UgSU5GT1BBVEgsIGZyb20gTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBEZXNjcmlwdGlvbj0iIiBVc2VyT3JHcm91cFNpZD0iUy0xLTEtMCIgQWN0aW9uPSJEZW55Ij4NCiAgICAgIDxDb25kaXRpb25zPg0KICAgICAgICA8RmlsZVB1Ymxpc2hlckNvbmRpdGlvbiBQdWJsaXNoZXJOYW1lPSJPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIFByb2R1Y3ROYW1lPSJNSUNST1NPRlQgT0ZGSUNFIElORk9QQVRIIiBCaW5hcnlOYW1lPSIqIj4NCiAgICAgICAgICA8QmluYXJ5VmVyc2lvblJhbmdlIExvd1NlY3Rpb249IioiIEhpZ2hTZWN0aW9uPSIqIiAvPg0KICAgICAgICA8L0ZpbGVQdWJsaXNoZXJDb25kaXRpb24+DQogICAgICA8L0NvbmRpdGlvbnM+DQogICAgPC9GaWxlUHVibGlzaGVyUnVsZT4NCiAgICA8RmlsZVB1Ymxpc2hlclJ1bGUgSWQ9Ijk3NjlkMjA5LTg1ZjgtNDM4OS1iZGM2LWRkY2EzMGYxYzY3MSIgTmFtZT0iTUlDUk9TT0ZUIE9GRklDRSBIRUxQIFZJRVdFUiwgZnJvbSBPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIERlc2NyaXB0aW9uPSIiIFVzZXJPckdyb3VwU2lkPSJTLTEtMS0wIiBBY3Rpb249IkRlbnkiPg0KICAgICAgPENvbmRpdGlvbnM+DQogICAgICAgIDxGaWxlUHVibGlzaGVyQ29uZGl0aW9uIFB1Ymxpc2hlck5hbWU9Ik89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgUHJvZHVjdE5hbWU9Ik1JQ1JPU09GVCBPRkZJQ0UgSEVMUCBWSUVXRVIiIEJpbmFyeU5hbWU9IioiPg0KICAgICAgICAgIDxCaW5hcnlWZXJzaW9uUmFuZ2UgTG93U2VjdGlvbj0iKiIgSGlnaFNlY3Rpb249IioiIC8+DQogICAgICAgIDwvRmlsZVB1Ymxpc2hlckNvbmRpdGlvbj4NCiAgICAgIDwvQ29uZGl0aW9ucz4NCiAgICA8L0ZpbGVQdWJsaXNoZXJSdWxlPg0KCTwvUnVsZUNvbGxlY3Rpb24+DQo8L0FwcExvY2tlclBvbGljeT4=",
      "id": "0c5c4541-87a8-478b-b9fc-4206d0f421f9",
      "@odata.type": "
    }
  ],
  "exemptAppLockerFiles": [],
  "enterpriseNetworkDomainNames": [],
  "enterpriseProxiedDomains": [
    {
      "displayName": "SharePoint",
      "proxiedDomains": [
        {
          "ipAddressOrFQDN": "$Sharepoint.sharepoint.com",
          "@odata.type": "
        },
        {
          "ipAddressOrFQDN": "$Sharepoint-my.sharepoint.com",
          "@odata.type": "
        },
        {
          "ipAddressOrFQDN": "$Sharepoint.sharepoint.com",
          "@odata.type": "
        }
      ],
      "@odata.type": "
    }
  ],
  "enterpriseIPRanges": [],
  "enterpriseIPRangesAreAuthoritative": false,
  "enterpriseProxyServers": [],
  "enterpriseInternalProxyServers": [],
  "enterpriseProxyServersAreAuthoritative": false,
  "neutralDomainResources": [],
  "windowsHelloForBusinessBlocked": false,
  "pinMinimumLength": 4,
  "pinUppercaseLetters": "notAllow",
  "pinLowercaseLetters": "notAllow",
  "pinSpecialCharacters": "notAllow",
  "pinExpirationDays": 0,
  "numberOfPastPinsRemembered": 0,
  "passwordMaximumAttemptCount": 0,
  "minutesOfInactivityBeforeDeviceLock": 0,
  "mdmEnrollmentUrl": "https://enrollment.manage.microsoft.com/enrollmentserver/discovery.svc",
  "@odata.type": "
}

"@ <-||- 



 -||-> $ManagedAppPolicy_WIP_MDM = @"

{
  "description": "",
  "displayName": "Win10 WIP MDM Policy",
  "enforcementLevel": "encryptAuditAndPrompt",
  "enterpriseDomain": "$EnterpriseDomain",
  "enterpriseProtectedDomainNames": [],
  "protectionUnderLockConfigRequired": false,
  "dataRecoveryCertificate": null,
  "revokeOnUnenrollDisabled": false,
  "rightsManagementServicesTemplateId": null,
  "azureRightsManagementServicesAllowed": false,
  "iconsVisible": true,
  "protectedApps": [
    {
      "@odata.type": "
      "description": "",
      "displayName": "Microsoft Teams",
      "productName": "*",
      "publisherName": "O=Microsoft Corporation, L=Redmond, S=Washington, C=US",
      "denied": false,
      "binaryName": "teams.exe",
      "binaryVersionLow": "*",
      "binaryVersionHigh": "*"
    },
    {
      "@odata.type": "
      "description": "",
      "displayName": "Microsoft Remote Desktop",
      "productName": "*",
      "publisherName": "O=Microsoft Corporation, L=Redmond, S=Washington, C=US",
      "denied": false,
      "binaryName": "mstsc.exe",
      "binaryVersionLow": "*",
      "binaryVersionHigh": "*"
    },
    {
      "@odata.type": "
      "description": "",
      "displayName": "Microsoft Paint",
      "productName": "*",
      "publisherName": "O=Microsoft Corporation, L=Redmond, S=Washington, C=US",
      "denied": false,
      "binaryName": "mspaint.exe",
      "binaryVersionLow": "*",
      "binaryVersionHigh": "*"
    },
    {
      "@odata.type": "
      "description": "",
      "displayName": "Notepad",
      "productName": "*",
      "publisherName": "O=Microsoft Corporation, L=Redmond, S=Washington, C=US",
      "denied": false,
      "binaryName": "notepad.exe",
      "binaryVersionLow": "*",
      "binaryVersionHigh": "*"
    },
    {
      "@odata.type": "
      "description": "",
      "displayName": "Microsoft OneDrive",
      "productName": "*",
      "publisherName": "O=Microsoft Corporation, L=Redmond, S=Washington, C=US",
      "denied": false,
      "binaryName": "onedrive.exe",
      "binaryVersionLow": "*",
      "binaryVersionHigh": "*"
    },
    {
      "@odata.type": "
      "description": "",
      "displayName": "IE11",
      "productName": "*",
      "publisherName": "O=Microsoft Corporation, L=Redmond, S=Washington, C=US",
      "denied": false,
      "binaryName": "iexplore.exe",
      "binaryVersionLow": "*",
      "binaryVersionHigh": "*"
    },
    {
      "@odata.type": "
      "description": "",
      "displayName": "Company Portal",
      "productName": "Microsoft.CompanyPortal",
      "publisherName": "CN=Microsoft Corporation, O=Microsoft Corporation, L=Redmond, S=Washington, C=US",
      "denied": false
    },
    {
      "@odata.type": "
      "description": "",
      "displayName": "Microsoft Messaging",
      "productName": "Microsoft.Messaging",
      "publisherName": "CN=Microsoft Corporation, O=Microsoft Corporation, L=Redmond, S=Washington, C=US",
      "denied": false
    },
    {
      "@odata.type": "
      "description": "",
      "displayName": "Microsoft Movies and TV",
      "productName": "Microsoft.ZuneVideo",
      "publisherName": "CN=Microsoft Corporation, O=Microsoft Corporation, L=Redmond, S=Washington, C=US",
      "denied": false
    },
    {
      "@odata.type": "
      "description": "",
      "displayName": "Groove Music",
      "productName": "Microsoft.ZuneMusic",
      "publisherName": "CN=Microsoft Corporation, O=Microsoft Corporation, L=Redmond, S=Washington, C=US",
      "denied": false
    },
    {
      "@odata.type": "
      "description": "",
      "displayName": "Microsoft Photos",
      "productName": "Microsoft.Windows.Photos",
      "publisherName": "CN=Microsoft Corporation, O=Microsoft Corporation, L=Redmond, S=Washington, C=US",
      "denied": false
    },
    {
      "@odata.type": "
      "description": "",
      "displayName": "Mail and Calendar for Windows 10",
      "productName": "microsoft.windowscommunicationsapps",
      "publisherName": "CN=Microsoft Corporation, O=Microsoft Corporation, L=Redmond, S=Washington, C=US",
      "denied": false
    },
    {
      "@odata.type": "
      "description": "",
      "displayName": "OneNote",
      "productName": "Microsoft.Office.OneNote",
      "publisherName": "CN=Microsoft Corporation, O=Microsoft Corporation, L=Redmond, S=Washington, C=US",
      "denied": false
    },
    {
      "@odata.type": "
      "description": "",
      "displayName": "PowerPoint Mobile",
      "productName": "Microsoft.Office.PowerPoint",
      "publisherName": "CN=Microsoft Corporation, O=Microsoft Corporation, L=Redmond, S=Washington, C=US",
      "denied": false
    },
    {
      "@odata.type": "
      "description": "",
      "displayName": "Excel Mobile",
      "productName": "Microsoft.Office.Excel",
      "publisherName": "CN=Microsoft Corporation, O=Microsoft Corporation, L=Redmond, S=Washington, C=US",
      "denied": false
    },
    {
      "@odata.type": "
      "description": "",
      "displayName": "Word Mobile",
      "productName": "Microsoft.Office.Word",
      "publisherName": "CN=Microsoft Corporation, O=Microsoft Corporation, L=Redmond, S=Washington, C=US",
      "denied": false
    },
    {
      "@odata.type": "
      "description": "",
      "displayName": "Microsoft People",
      "productName": "Microsoft.People",
      "publisherName": "CN=Microsoft Corporation, O=Microsoft Corporation, L=Redmond, S=Washington, C=US",
      "denied": false
    },
    {
      "@odata.type": "
      "description": "",
      "displayName": "Microsoft Edge",
      "productName": "Microsoft.MicrosoftEdge",
      "publisherName": "CN=Microsoft Corporation, O=Microsoft Corporation, L=Redmond, S=Washington, C=US",
      "denied": false
    }
  ],
  "exemptApps": [],
  "protectedAppLockerFiles": [
    {
      "displayName": "Denied-Downlevel-Office-365-ProPlus.xml",
      "fileHash": "786d7f7d-0735-49b8-9293-7b3aaf68b68c",
      "file": "PEFwcExvY2tlclBvbGljeSBWZXJzaW9uPSIxIj4NCjxSdWxlQ29sbGVjdGlvbiBUeXBlPSJFeGUiIEVuZm9yY2VtZW50TW9kZT0iRW5hYmxlZCI+DQogIDxGaWxlUHVibGlzaGVyUnVsZSBJZD0iYjAwNWVhZGUtYTVlZS00ZjVhLWJlNDUtZDA4ZmE1NTdhNGIyIiBOYW1lPSJNSUNST1NPRlQgT0ZGSUNFLCBmcm9tIE89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgRGVzY3JpcHRpb249IiIgVXNlck9yR3JvdXBTaWQ9IlMtMS0xLTAiIEFjdGlvbj0iRGVueSI+DQogICAgPENvbmRpdGlvbnM+DQogICAgICA8RmlsZVB1Ymxpc2hlckNvbmRpdGlvbiBQdWJsaXNoZXJOYW1lPSJPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIFByb2R1Y3ROYW1lPSJNSUNST1NPRlQgT0ZGSUNFIiBCaW5hcnlOYW1lPSIqIj4NCiAgICAgICAgPEJpbmFyeVZlcnNpb25SYW5nZSBMb3dTZWN0aW9uPSIqIiBIaWdoU2VjdGlvbj0iKiIgLz4NCiAgICAgIDwvRmlsZVB1Ymxpc2hlckNvbmRpdGlvbj4NCiAgICA8L0NvbmRpdGlvbnM+DQogIDwvRmlsZVB1Ymxpc2hlclJ1bGU+DQogIDxGaWxlUHVibGlzaGVyUnVsZSBJZD0iZGU5ZjM0NjEtNjg1Ni00MDVkLTk2MjQtYTgwY2E3MDFmNmNiIiBOYW1lPSJNSUNST1NPRlQgT0ZGSUNFIDIwMDMsIGZyb20gTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBEZXNjcmlwdGlvbj0iIiBVc2VyT3JHcm91cFNpZD0iUy0xLTEtMCIgQWN0aW9uPSJEZW55Ij4NCiAgICA8Q29uZGl0aW9ucz4NCiAgICAgIDxGaWxlUHVibGlzaGVyQ29uZGl0aW9uIFB1Ymxpc2hlck5hbWU9Ik89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgUHJvZHVjdE5hbWU9Ik1JQ1JPU09GVCBPRkZJQ0UgMjAwMyIgQmluYXJ5TmFtZT0iKiI+DQogICAgICAgIDxCaW5hcnlWZXJzaW9uUmFuZ2UgTG93U2VjdGlvbj0iKiIgSGlnaFNlY3Rpb249IioiIC8+DQogICAgICA8L0ZpbGVQdWJsaXNoZXJDb25kaXRpb24+DQogICAgPC9Db25kaXRpb25zPg0KICA8L0ZpbGVQdWJsaXNoZXJSdWxlPg0KICA8RmlsZVB1Ymxpc2hlclJ1bGUgSWQ9ImFkZTFiODI4LTcwNTUtNDdmYy05OWJjLTQzMmNmN2QxMjA5ZSIgTmFtZT0iMjAwNyBNSUNST1NPRlQgT0ZGSUNFIFNZU1RFTSwgZnJvbSBPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIERlc2NyaXB0aW9uPSIiIFVzZXJPckdyb3VwU2lkPSJTLTEtMS0wIiBBY3Rpb249IkRlbnkiPg0KICAgIDxDb25kaXRpb25zPg0KICAgICAgPEZpbGVQdWJsaXNoZXJDb25kaXRpb24gUHVibGlzaGVyTmFtZT0iTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBQcm9kdWN0TmFtZT0iMjAwNyBNSUNST1NPRlQgT0ZGSUNFIFNZU1RFTSIgQmluYXJ5TmFtZT0iKiI+DQogICAgICAgIDxCaW5hcnlWZXJzaW9uUmFuZ2UgTG93U2VjdGlvbj0iKiIgSGlnaFNlY3Rpb249IioiIC8+DQogICAgICA8L0ZpbGVQdWJsaXNoZXJDb25kaXRpb24+DQogICAgPC9Db25kaXRpb25zPg0KICA8L0ZpbGVQdWJsaXNoZXJSdWxlPg0KICA8RmlsZVB1Ymxpc2hlclJ1bGUgSWQ9ImY2YTA3NWI1LWE1YjUtNDY1NC1hYmQ2LTczMWRhY2I0MGQ5NSIgTmFtZT0iTUlDUk9TT0ZUIE9GRklDRSBPTkVOT1RFLCBmcm9tIE89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgRGVzY3JpcHRpb249IiIgVXNlck9yR3JvdXBTaWQ9IlMtMS0xLTAiIEFjdGlvbj0iRGVueSI+DQogICAgPENvbmRpdGlvbnM+DQogICAgICA8RmlsZVB1Ymxpc2hlckNvbmRpdGlvbiBQdWJsaXNoZXJOYW1lPSJPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIFByb2R1Y3ROYW1lPSJNSUNST1NPRlQgT0ZGSUNFIE9ORU5PVEUiIEJpbmFyeU5hbWU9IioiPg0KICAgICAgICA8QmluYXJ5VmVyc2lvblJhbmdlIExvd1NlY3Rpb249IioiIEhpZ2hTZWN0aW9uPSIxMi4wLjk5OTkuOTk5OSIgLz4NCiAgICAgIDwvRmlsZVB1Ymxpc2hlckNvbmRpdGlvbj4NCiAgICA8L0NvbmRpdGlvbnM+DQogIDwvRmlsZVB1Ymxpc2hlclJ1bGU+DQogIDxGaWxlUHVibGlzaGVyUnVsZSBJZD0iMGVjMDNiMmYtZTlhNC00NzQzLWFlNjAtNmQyOTg4NmNmNmFlIiBOYW1lPSJNSUNST1NPRlQgT0ZGSUNFIE9VVExPT0ssIGZyb20gTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBEZXNjcmlwdGlvbj0iIiBVc2VyT3JHcm91cFNpZD0iUy0xLTEtMCIgQWN0aW9uPSJEZW55Ij4NCiAgICA8Q29uZGl0aW9ucz4NCiAgICAgIDxGaWxlUHVibGlzaGVyQ29uZGl0aW9uIFB1Ymxpc2hlck5hbWU9Ik89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgUHJvZHVjdE5hbWU9Ik1JQ1JPU09GVCBPRkZJQ0UgT1VUTE9PSyIgQmluYXJ5TmFtZT0iKiI+DQogICAgICAgIDxCaW5hcnlWZXJzaW9uUmFuZ2UgTG93U2VjdGlvbj0iKiIgSGlnaFNlY3Rpb249IjEyLjAuOTk5OS45OTk5IiAvPg0KICAgICAgPC9GaWxlUHVibGlzaGVyQ29uZGl0aW9uPg0KICAgIDwvQ29uZGl0aW9ucz4NCiAgPC9GaWxlUHVibGlzaGVyUnVsZT4NCiAgPEZpbGVQdWJsaXNoZXJSdWxlIElkPSI3YjI3MmVmZC00MTA1LTRmYjctOWQ0MC1iZmE1OTdjNjc5MmEiIE5hbWU9Ik1JQ1JPU09GVCBPRkZJQ0UgMjAxMywgZnJvbSBPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIERlc2NyaXB0aW9uPSIiIFVzZXJPckdyb3VwU2lkPSJTLTEtMS0wIiBBY3Rpb249IkRlbnkiPg0KICAgIDxDb25kaXRpb25zPg0KICAgICAgPEZpbGVQdWJsaXNoZXJDb25kaXRpb24gUHVibGlzaGVyTmFtZT0iTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBQcm9kdWN0TmFtZT0iTUlDUk9TT0ZUIE9GRklDRSAyMDEzIiBCaW5hcnlOYW1lPSIqIj4NCiAgICAgICAgPEJpbmFyeVZlcnNpb25SYW5nZSBMb3dTZWN0aW9uPSIqIiBIaWdoU2VjdGlvbj0iKiIgLz4NCiAgICAgIDwvRmlsZVB1Ymxpc2hlckNvbmRpdGlvbj4NCiAgICA8L0NvbmRpdGlvbnM+DQogIDwvRmlsZVB1Ymxpc2hlclJ1bGU+DQogIDxGaWxlUHVibGlzaGVyUnVsZSBJZD0iODlkOGE0ZDMtZjllMy00MjNhLTkyYWUtODZlNzMzM2UyNjYyIiBOYW1lPSJNSUNST1NPRlQgT05FTk9URSwgZnJvbSBPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIERlc2NyaXB0aW9uPSIiIFVzZXJPckdyb3VwU2lkPSJTLTEtMS0wIiBBY3Rpb249IkRlbnkiPg0KICAgIDxDb25kaXRpb25zPg0KICAgICAgPEZpbGVQdWJsaXNoZXJDb25kaXRpb24gUHVibGlzaGVyTmFtZT0iTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBQcm9kdWN0TmFtZT0iTUlDUk9TT0ZUIE9ORU5PVEUiIEJpbmFyeU5hbWU9IioiPg0KICAgICAgICA8QmluYXJ5VmVyc2lvblJhbmdlIExvd1NlY3Rpb249IioiIEhpZ2hTZWN0aW9uPSIqIiAvPg0KICAgICAgPC9GaWxlUHVibGlzaGVyQ29uZGl0aW9uPg0KICAgIDwvQ29uZGl0aW9ucz4NCiAgICA8RXhjZXB0aW9ucz4NCiAgICAgIDxGaWxlUHVibGlzaGVyQ29uZGl0aW9uIFB1Ymxpc2hlck5hbWU9Ik89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgUHJvZHVjdE5hbWU9Ik1JQ1JPU09GVCBPTkVOT1RFIiBCaW5hcnlOYW1lPSJPTkVOT1RFLkVYRSI+DQogICAgICAgIDxCaW5hcnlWZXJzaW9uUmFuZ2UgTG93U2VjdGlvbj0iMTYuMC43NTAwLjAwMDAiIEhpZ2hTZWN0aW9uPSIqIiAvPg0KICAgICAgPC9GaWxlUHVibGlzaGVyQ29uZGl0aW9uPg0KICAgIDwvRXhjZXB0aW9ucz4NCiAgPC9GaWxlUHVibGlzaGVyUnVsZT4NCiAgPEZpbGVQdWJsaXNoZXJSdWxlIElkPSI1YTIxMzhiZC04MDQyLTRlYzUtOTViNC1mOTkwNjY2ZmJmNjEiIE5hbWU9Ik1JQ1JPU09GVCBPVVRMT09LLCBmcm9tIE89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgRGVzY3JpcHRpb249IiIgVXNlck9yR3JvdXBTaWQ9IlMtMS0xLTAiIEFjdGlvbj0iRGVueSI+DQogICAgPENvbmRpdGlvbnM+DQogICAgICA8RmlsZVB1Ymxpc2hlckNvbmRpdGlvbiBQdWJsaXNoZXJOYW1lPSJPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIFByb2R1Y3ROYW1lPSJNSUNST1NPRlQgT1VUTE9PSyIgQmluYXJ5TmFtZT0iKiI+DQogICAgICAgIDxCaW5hcnlWZXJzaW9uUmFuZ2UgTG93U2VjdGlvbj0iKiIgSGlnaFNlY3Rpb249IioiIC8+DQogICAgICA8L0ZpbGVQdWJsaXNoZXJDb25kaXRpb24+DQogICAgPC9Db25kaXRpb25zPg0KICAgIDxFeGNlcHRpb25zPg0KICAgICAgPEZpbGVQdWJsaXNoZXJDb25kaXRpb24gUHVibGlzaGVyTmFtZT0iTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBQcm9kdWN0TmFtZT0iTUlDUk9TT0ZUIE9VVExPT0siIEJpbmFyeU5hbWU9Ik9VVExPT0suRVhFIj4NCiAgICAgICAgPEJpbmFyeVZlcnNpb25SYW5nZSBMb3dTZWN0aW9uPSIxNi4wLjc1MDAuMDAwMCIgSGlnaFNlY3Rpb249IioiIC8+DQogICAgICA8L0ZpbGVQdWJsaXNoZXJDb25kaXRpb24+DQogICAgPC9FeGNlcHRpb25zPg0KICA8L0ZpbGVQdWJsaXNoZXJSdWxlPg0KICA8RmlsZVB1Ymxpc2hlclJ1bGUgSWQ9IjNmYzVmOWM1LWYxODAtNDM1Yi04MzhmLTI5NjAxMDZhMzg2MCIgTmFtZT0iTUlDUk9TT0ZUIE9ORURSSVZFLCBmcm9tIE89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgRGVzY3JpcHRpb249IiIgVXNlck9yR3JvdXBTaWQ9IlMtMS0xLTAiIEFjdGlvbj0iRGVueSI+DQogICAgPENvbmRpdGlvbnM+DQogICAgICA8RmlsZVB1Ymxpc2hlckNvbmRpdGlvbiBQdWJsaXNoZXJOYW1lPSJPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIFByb2R1Y3ROYW1lPSJNSUNST1NPRlQgT05FRFJJVkUiIEJpbmFyeU5hbWU9IioiPg0KICAgICAgICA8QmluYXJ5VmVyc2lvblJhbmdlIExvd1NlY3Rpb249IioiIEhpZ2hTZWN0aW9uPSIqIiAvPg0KICAgICAgPC9GaWxlUHVibGlzaGVyQ29uZGl0aW9uPg0KICAgIDwvQ29uZGl0aW9ucz4NCiAgICA8RXhjZXB0aW9ucz4NCiAgICAgIDxGaWxlUHVibGlzaGVyQ29uZGl0aW9uIFB1Ymxpc2hlck5hbWU9Ik89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgUHJvZHVjdE5hbWU9Ik1JQ1JPU09GVCBPTkVEUklWRSIgQmluYXJ5TmFtZT0iT05FRFJJVkUuRVhFIj4NCiAgICAgICAgPEJpbmFyeVZlcnNpb25SYW5nZSBMb3dTZWN0aW9uPSIxNy4zLjYzODYuMDQxMiIgSGlnaFNlY3Rpb249IioiIC8+DQogICAgICA8L0ZpbGVQdWJsaXNoZXJDb25kaXRpb24+DQogICAgPC9FeGNlcHRpb25zPg0KICA8L0ZpbGVQdWJsaXNoZXJSdWxlPg0KICA8RmlsZVB1Ymxpc2hlclJ1bGUgSWQ9IjE3ZDk4OGVmLTA3M2UtNGQ5Mi1iNGJmLWY0NzdiMmVjY2NiNSIgTmFtZT0iTUlDUk9TT0ZUIE9GRklDRSAyMDE2LCBmcm9tIE89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgRGVzY3JpcHRpb249IiIgVXNlck9yR3JvdXBTaWQ9IlMtMS0xLTAiIEFjdGlvbj0iRGVueSI+DQogICAgPENvbmRpdGlvbnM+DQogICAgICA8RmlsZVB1Ymxpc2hlckNvbmRpdGlvbiBQdWJsaXNoZXJOYW1lPSJPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIFByb2R1Y3ROYW1lPSJNSUNST1NPRlQgT0ZGSUNFIDIwMTYiIEJpbmFyeU5hbWU9IioiPg0KICAgICAgICA8QmluYXJ5VmVyc2lvblJhbmdlIExvd1NlY3Rpb249IioiIEhpZ2hTZWN0aW9uPSIqIiAvPg0KICAgICAgPC9GaWxlUHVibGlzaGVyQ29uZGl0aW9uPg0KICAgIDwvQ29uZGl0aW9ucz4NCiAgICA8RXhjZXB0aW9ucz4NCiAgICAgIDxGaWxlUHVibGlzaGVyQ29uZGl0aW9uIFB1Ymxpc2hlck5hbWU9Ik89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgUHJvZHVjdE5hbWU9Ik1JQ1JPU09GVCBPRkZJQ0UgMjAxNiIgQmluYXJ5TmFtZT0iTFlOQy5FWEUiPg0KICAgICAgICA8QmluYXJ5VmVyc2lvblJhbmdlIExvd1NlY3Rpb249IjE2LjAuNzUwMC4wMDAwIiBIaWdoU2VjdGlvbj0iKiIgLz4NCiAgICAgIDwvRmlsZVB1Ymxpc2hlckNvbmRpdGlvbj4NCiAgICAgIDxGaWxlUHVibGlzaGVyQ29uZGl0aW9uIFB1Ymxpc2hlck5hbWU9Ik89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgUHJvZHVjdE5hbWU9Ik1JQ1JPU09GVCBPRkZJQ0UgMjAxNiIgQmluYXJ5TmFtZT0iTFlOQzk5LkVYRSI+DQogICAgICAgIDxCaW5hcnlWZXJzaW9uUmFuZ2UgTG93U2VjdGlvbj0iMTYuMC43NTAwLjAwMDAiIEhpZ2hTZWN0aW9uPSIqIiAvPg0KICAgICAgPC9GaWxlUHVibGlzaGVyQ29uZGl0aW9uPg0KICAgICAgPEZpbGVQdWJsaXNoZXJDb25kaXRpb24gUHVibGlzaGVyTmFtZT0iTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBQcm9kdWN0TmFtZT0iTUlDUk9TT0ZUIE9GRklDRSAyMDE2IiBCaW5hcnlOYW1lPSJVQ01BUEkuRVhFIj4NCiAgICAgICAgPEJpbmFyeVZlcnNpb25SYW5nZSBMb3dTZWN0aW9uPSIxNi4wLjc1MDAuMDAwMCIgSGlnaFNlY3Rpb249IioiIC8+DQogICAgICA8L0ZpbGVQdWJsaXNoZXJDb25kaXRpb24+DQogICAgICA8RmlsZVB1Ymxpc2hlckNvbmRpdGlvbiBQdWJsaXNoZXJOYW1lPSJPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIFByb2R1Y3ROYW1lPSJNSUNST1NPRlQgT0ZGSUNFIDIwMTYiIEJpbmFyeU5hbWU9Ik9DUFVCTUdSLkVYRSI+DQogICAgICAgIDxCaW5hcnlWZXJzaW9uUmFuZ2UgTG93U2VjdGlvbj0iMTYuMC43NTAwLjAwMDAiIEhpZ2hTZWN0aW9uPSIqIiAvPg0KICAgICAgPC9GaWxlUHVibGlzaGVyQ29uZGl0aW9uPg0KICAgICAgPEZpbGVQdWJsaXNoZXJDb25kaXRpb24gUHVibGlzaGVyTmFtZT0iTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBQcm9kdWN0TmFtZT0iTUlDUk9TT0ZUIE9GRklDRSAyMDE2IiBCaW5hcnlOYW1lPSJXSU5XT1JELkVYRSI+DQogICAgICAgIDxCaW5hcnlWZXJzaW9uUmFuZ2UgTG93U2VjdGlvbj0iMTYuMC43NTAwLjAwMDAiIEhpZ2hTZWN0aW9uPSIqIiAvPg0KICAgICAgPC9GaWxlUHVibGlzaGVyQ29uZGl0aW9uPg0KICAgICAgPEZpbGVQdWJsaXNoZXJDb25kaXRpb24gUHVibGlzaGVyTmFtZT0iTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBQcm9kdWN0TmFtZT0iTUlDUk9TT0ZUIE9GRklDRSAyMDE2IiBCaW5hcnlOYW1lPSJFWENFTC5FWEUiPg0KICAgICAgICA8QmluYXJ5VmVyc2lvblJhbmdlIExvd1NlY3Rpb249IjE2LjAuNzUwMC4wMDAwIiBIaWdoU2VjdGlvbj0iKiIgLz4NCiAgICAgIDwvRmlsZVB1Ymxpc2hlckNvbmRpdGlvbj4NCiAgICAgIDxGaWxlUHVibGlzaGVyQ29uZGl0aW9uIFB1Ymxpc2hlck5hbWU9Ik89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgUHJvZHVjdE5hbWU9Ik1JQ1JPU09GVCBPRkZJQ0UgMjAxNiIgQmluYXJ5TmFtZT0iUE9XRVJQTlQuRVhFIj4NCiAgICAgICAgPEJpbmFyeVZlcnNpb25SYW5nZSBMb3dTZWN0aW9uPSIxNi4wLjc1MDAuMDAwMCIgSGlnaFNlY3Rpb249IioiIC8+DQogICAgICA8L0ZpbGVQdWJsaXNoZXJDb25kaXRpb24+DQogICAgICA8RmlsZVB1Ymxpc2hlckNvbmRpdGlvbiBQdWJsaXNoZXJOYW1lPSJPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIFByb2R1Y3ROYW1lPSJNSUNST1NPRlQgT0ZGSUNFIDIwMTYiIEJpbmFyeU5hbWU9Ik1TT1NZTkMuRVhFIj4NCiAgICAgICAgPEJpbmFyeVZlcnNpb25SYW5nZSBMb3dTZWN0aW9uPSIxNi4wLjc1MDAuMDAwMCIgSGlnaFNlY3Rpb249IioiIC8+DQogICAgICA8L0ZpbGVQdWJsaXNoZXJDb25kaXRpb24+DQogICAgPC9FeGNlcHRpb25zPg0KICA8L0ZpbGVQdWJsaXNoZXJSdWxlPg0KPC9SdWxlQ29sbGVjdGlvbj4NCjwvQXBwTG9ja2VyUG9saWN5Pg==",
      "id": "95a3cc79-7306-4eac-8a1a-7daef9f083b3",
      "@odata.type": "
    },
    {
      "displayName": "Office-365-ProPlus-1708-Allowed.xml",
      "fileHash": "2eb106c8-234b-4253-af44-63f522bfe222",
      "file": "PEFwcExvY2tlclBvbGljeSBWZXJzaW9uPSIxIj4NCiAgPFJ1bGVDb2xsZWN0aW9uIFR5cGU9IkV4ZSIgRW5mb3JjZW1lbnRNb2RlPSJFbmFibGVkIj4NCiAgICA8RmlsZVB1Ymxpc2hlclJ1bGUgSWQ9ImQ2NjMyNzZjLTU0NGUtNGRlYS1iNzVjLTc1ZmMyZDRlMDI2NiIgTmFtZT0iTFlOQy5FWEUsIHZlcnNpb24gMTYuMC43ODcwLjIwMjAgYW5kIGFib3ZlLCBpbiBNSUNST1NPRlQgT0ZGSUNFIDIwMTYsIGZyb20gTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBEZXNjcmlwdGlvbj0iIiBVc2VyT3JHcm91cFNpZD0iUy0xLTEtMCIgQWN0aW9uPSJBbGxvdyI+DQogICAgICA8Q29uZGl0aW9ucz4NCiAgICAgICAgPEZpbGVQdWJsaXNoZXJDb25kaXRpb24gUHVibGlzaGVyTmFtZT0iTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBQcm9kdWN0TmFtZT0iTUlDUk9TT0ZUIE9GRklDRSAyMDE2IiBCaW5hcnlOYW1lPSJMWU5DLkVYRSI+DQoJCSAgICAgICAgICA8QmluYXJ5VmVyc2lvblJhbmdlIExvd1NlY3Rpb249IjE2LjAuNzg3MC4yMDIwIiBIaWdoU2VjdGlvbj0iKiIgLz4NCiAgICAgICAgPC9GaWxlUHVibGlzaGVyQ29uZGl0aW9uPg0KICAgICAgPC9Db25kaXRpb25zPg0KCTwvRmlsZVB1Ymxpc2hlclJ1bGU+DQogICAgPEZpbGVQdWJsaXNoZXJSdWxlIElkPSIyMTk1NzFiNC1hMjU3LTRiNGMtYjg1Ni1lYmYwNjgxZWUwZjAiIE5hbWU9IkxZTkM5OS5FWEUsIHZlcnNpb24gMTYuMC43ODcwLjIwMjAgYW5kIGFib3ZlLCBpbiBNSUNST1NPRlQgT0ZGSUNFIDIwMTYsIGZyb20gTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBEZXNjcmlwdGlvbj0iIiBVc2VyT3JHcm91cFNpZD0iUy0xLTEtMCIgQWN0aW9uPSJBbGxvdyI+DQogICAgICA8Q29uZGl0aW9ucz4NCiAgICAgICAgPEZpbGVQdWJsaXNoZXJDb25kaXRpb24gUHVibGlzaGVyTmFtZT0iTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBQcm9kdWN0TmFtZT0iTUlDUk9TT0ZUIE9GRklDRSAyMDE2IiBCaW5hcnlOYW1lPSJMWU5DOTkuRVhFIj4NCiAgICAgICAgICA8QmluYXJ5VmVyc2lvblJhbmdlIExvd1NlY3Rpb249IjE2LjAuNzg3MC4yMDIwIiBIaWdoU2VjdGlvbj0iKiIgLz4NCiAgICAgICAgPC9GaWxlUHVibGlzaGVyQ29uZGl0aW9uPg0KICAgICAgPC9Db25kaXRpb25zPg0KICAgIDwvRmlsZVB1Ymxpc2hlclJ1bGU+DQogICAgPEZpbGVQdWJsaXNoZXJSdWxlIElkPSI1MzhkNDQzYS05ZmRiLTQ5MWUtOGJjMy1lNzhkYjljMzEwYzciIE5hbWU9Ik9ORU5PVEVNLkVYRSwgdmVyc2lvbiAxNi4wLjgyMDEuMjAyNSBhbmQgYWJvdmUsIGluIE1JQ1JPU09GVCBPTkVOT1RFLCBmcm9tIE89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgRGVzY3JpcHRpb249IiIgVXNlck9yR3JvdXBTaWQ9IlMtMS0xLTAiIEFjdGlvbj0iQWxsb3ciPg0KICAgICAgPENvbmRpdGlvbnM+DQogICAgICAgIDxGaWxlUHVibGlzaGVyQ29uZGl0aW9uIFB1Ymxpc2hlck5hbWU9Ik89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgUHJvZHVjdE5hbWU9Ik1JQ1JPU09GVCBPTkVOT1RFIiBCaW5hcnlOYW1lPSJPTkVOT1RFTS5FWEUiPg0KICAgICAgICAgIDxCaW5hcnlWZXJzaW9uUmFuZ2UgTG93U2VjdGlvbj0iMTYuMC44MjAxLjIwMjUiIEhpZ2hTZWN0aW9uPSIqIiAvPg0KICAgICAgICA8L0ZpbGVQdWJsaXNoZXJDb25kaXRpb24+DQogICAgICA8L0NvbmRpdGlvbnM+DQogICAgPC9GaWxlUHVibGlzaGVyUnVsZT4NCiAgICA8RmlsZVB1Ymxpc2hlclJ1bGUgSWQ9IjZlZjA3YTkyLWYxZGItNDg4MC04YjQwLWRkMzliNzQzYTQ4NSIgTmFtZT0iV0lOV09SRC5FWEUsIHZlcnNpb24gMTYuMC44MjAxLjIwMjUgYW5kIGFib3ZlLCBpbiBNSUNST1NPRlQgT0ZGSUNFIDIwMTYsIGZyb20gTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBEZXNjcmlwdGlvbj0iIiBVc2VyT3JHcm91cFNpZD0iUy0xLTEtMCIgQWN0aW9uPSJBbGxvdyI+DQogICAgICA8Q29uZGl0aW9ucz4NCiAgICAgICAgPEZpbGVQdWJsaXNoZXJDb25kaXRpb24gUHVibGlzaGVyTmFtZT0iTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBQcm9kdWN0TmFtZT0iTUlDUk9TT0ZUIE9GRklDRSAyMDE2IiBCaW5hcnlOYW1lPSJXSU5XT1JELkVYRSI+DQogICAgICAgICAgPEJpbmFyeVZlcnNpb25SYW5nZSBMb3dTZWN0aW9uPSIxNi4wLjgyMDEuMjAyNSIgSGlnaFNlY3Rpb249IioiIC8+DQogICAgICAgIDwvRmlsZVB1Ymxpc2hlckNvbmRpdGlvbj4NCiAgICAgIDwvQ29uZGl0aW9ucz4NCiAgICA8L0ZpbGVQdWJsaXNoZXJSdWxlPg0KICAgIDxGaWxlUHVibGlzaGVyUnVsZSBJZD0iN2Q3NGQxYWQtYTYwYi00ZWE4LWJiNjAtM2Q0MDQ4ODZkMTBiIiBOYW1lPSJPTkVOT1RFLkVYRSwgdmVyc2lvbiAxNi4wLjgyMDEuMjAyNSBhbmQgYWJvdmUsIGluIE1JQ1JPU09GVCBPTkVOT1RFLCBmcm9tIE89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgRGVzY3JpcHRpb249IiIgVXNlck9yR3JvdXBTaWQ9IlMtMS0xLTAiIEFjdGlvbj0iQWxsb3ciPg0KICAgICAgPENvbmRpdGlvbnM+DQogICAgICAgIDxGaWxlUHVibGlzaGVyQ29uZGl0aW9uIFB1Ymxpc2hlck5hbWU9Ik89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgUHJvZHVjdE5hbWU9Ik1JQ1JPU09GVCBPTkVOT1RFIiBCaW5hcnlOYW1lPSJPTkVOT1RFLkVYRSI+DQogICAgICAgICAgPEJpbmFyeVZlcnNpb25SYW5nZSBMb3dTZWN0aW9uPSIxNi4wLjgyMDEuMjAyNSIgSGlnaFNlY3Rpb249IioiIC8+DQogICAgICAgIDwvRmlsZVB1Ymxpc2hlckNvbmRpdGlvbj4NCiAgICAgIDwvQ29uZGl0aW9ucz4NCiAgICA8L0ZpbGVQdWJsaXNoZXJSdWxlPg0KICAgIDxGaWxlUHVibGlzaGVyUnVsZSBJZD0iODQwOWFhNjItMWI1Mi00ODRiLTg3ODctZDU3Y2M4NTI1ZTIxIiBOYW1lPSJPQ1BVQk1HUi5FWEUsIHZlcnNpb24gMTYuMC43ODcwLjIwMjAgYW5kIGFib3ZlLCBpbiBNSUNST1NPRlQgT0ZGSUNFIDIwMTYsIGZyb20gTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBEZXNjcmlwdGlvbj0iIiBVc2VyT3JHcm91cFNpZD0iUy0xLTEtMCIgQWN0aW9uPSJBbGxvdyI+DQogICAgICA8Q29uZGl0aW9ucz4NCiAgICAgICAgPEZpbGVQdWJsaXNoZXJDb25kaXRpb24gUHVibGlzaGVyTmFtZT0iTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBQcm9kdWN0TmFtZT0iTUlDUk9TT0ZUIE9GRklDRSAyMDE2IiBCaW5hcnlOYW1lPSJPQ1BVQk1HUi5FWEUiPg0KICAgICAgICAgIDxCaW5hcnlWZXJzaW9uUmFuZ2UgTG93U2VjdGlvbj0iMTYuMC43ODcwLjIwMjAiIEhpZ2hTZWN0aW9uPSIqIiAvPg0KICAgICAgICA8L0ZpbGVQdWJsaXNoZXJDb25kaXRpb24+DQogICAgICA8L0NvbmRpdGlvbnM+DQogICAgPC9GaWxlUHVibGlzaGVyUnVsZT4NCiAgICA8RmlsZVB1Ymxpc2hlclJ1bGUgSWQ9ImU2Y2NjY2QxLWE2MGYtNGNiNC04YjRiLTkwM2M3MDk3NmI1MCIgTmFtZT0iUE9XRVJQTlQuRVhFLCB2ZXJzaW9uIDE2LjAuODIwMS4yMDI1IGFuZCBhYm92ZSwgaW4gTUlDUk9TT0ZUIE9GRklDRSAyMDE2LCBmcm9tIE89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgRGVzY3JpcHRpb249IiIgVXNlck9yR3JvdXBTaWQ9IlMtMS0xLTAiIEFjdGlvbj0iQWxsb3ciPg0KICAgICAgPENvbmRpdGlvbnM+DQogICAgICAgIDxGaWxlUHVibGlzaGVyQ29uZGl0aW9uIFB1Ymxpc2hlck5hbWU9Ik89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgUHJvZHVjdE5hbWU9Ik1JQ1JPU09GVCBPRkZJQ0UgMjAxNiIgQmluYXJ5TmFtZT0iUE9XRVJQTlQuRVhFIj4NCiAgICAgICAgICA8QmluYXJ5VmVyc2lvblJhbmdlIExvd1NlY3Rpb249IjE2LjAuODIwMS4yMDI1IiBIaWdoU2VjdGlvbj0iKiIgLz4NCiAgICAgICAgPC9GaWxlUHVibGlzaGVyQ29uZGl0aW9uPg0KICAgICAgPC9Db25kaXRpb25zPg0KICAgIDwvRmlsZVB1Ymxpc2hlclJ1bGU+DQogICAgPEZpbGVQdWJsaXNoZXJSdWxlIElkPSJlYzc5ZWJiZS0zMTY5LTRhMjYtYWY1ZS1lMDc2YzkwOTY0OTUiIE5hbWU9Ik1TT1NZTkMuRVhFLCB2ZXJzaW9uIDE2LjAuODIwMS4yMDI1IGFuZCBhYm92ZSwgaW4gTUlDUk9TT0ZUIE9GRklDRSAyMDE2LCBmcm9tIE89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgRGVzY3JpcHRpb249IiIgVXNlck9yR3JvdXBTaWQ9IlMtMS0xLTAiIEFjdGlvbj0iQWxsb3ciPg0KICAgICAgPENvbmRpdGlvbnM+DQogICAgICAgIDxGaWxlUHVibGlzaGVyQ29uZGl0aW9uIFB1Ymxpc2hlck5hbWU9Ik89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgUHJvZHVjdE5hbWU9Ik1JQ1JPU09GVCBPRkZJQ0UgMjAxNiIgQmluYXJ5TmFtZT0iTVNPU1lOQy5FWEUiPg0KICAgICAgICAgIDxCaW5hcnlWZXJzaW9uUmFuZ2UgTG93U2VjdGlvbj0iMTYuMC44MjAxLjIwMjUiIEhpZ2hTZWN0aW9uPSIqIiAvPg0KICAgICAgICA8L0ZpbGVQdWJsaXNoZXJDb25kaXRpb24+DQogICAgICA8L0NvbmRpdGlvbnM+DQogICAgPC9GaWxlUHVibGlzaGVyUnVsZT4NCiAgICA8RmlsZVB1Ymxpc2hlclJ1bGUgSWQ9ImYwYjM1MjZiLTE0ZTctNDQyOC05NzAzLTRkZmYyZWE0MDAwZCIgTmFtZT0iVUNNQVBJLkVYRSwgdmVyc2lvbiAxNi4wLjc4NzAuMjAyMCBhbmQgYWJvdmUsIGluIE1JQ1JPU09GVCBPRkZJQ0UgMjAxNiwgZnJvbSBPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIERlc2NyaXB0aW9uPSIiIFVzZXJPckdyb3VwU2lkPSJTLTEtMS0wIiBBY3Rpb249IkFsbG93Ij4NCiAgICAgIDxDb25kaXRpb25zPg0KICAgICAgICA8RmlsZVB1Ymxpc2hlckNvbmRpdGlvbiBQdWJsaXNoZXJOYW1lPSJPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIFByb2R1Y3ROYW1lPSJNSUNST1NPRlQgT0ZGSUNFIDIwMTYiIEJpbmFyeU5hbWU9IlVDTUFQSS5FWEUiPg0KICAgICAgICAgIDxCaW5hcnlWZXJzaW9uUmFuZ2UgTG93U2VjdGlvbj0iMTYuMC43ODcwLjIwMjAiIEhpZ2hTZWN0aW9uPSIqIiAvPg0KICAgICAgICA8L0ZpbGVQdWJsaXNoZXJDb25kaXRpb24+DQogICAgICA8L0NvbmRpdGlvbnM+DQogICAgPC9GaWxlUHVibGlzaGVyUnVsZT4NCiAgICA8RmlsZVB1Ymxpc2hlclJ1bGUgSWQ9ImYxYmVkY2IxLWNhMzQtNDdiNS04NmM4LTI1NjU0YjE3OGNiOSIgTmFtZT0iT1VUTE9PSy5FWEUsIHZlcnNpb24gMTYuMC44MjAxLjIwMjUgYW5kIGFib3ZlLCBpbiBNSUNST1NPRlQgT1VUTE9PSywgZnJvbSBPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIERlc2NyaXB0aW9uPSIiIFVzZXJPckdyb3VwU2lkPSJTLTEtMS0wIiBBY3Rpb249IkFsbG93Ij4NCiAgICAgIDxDb25kaXRpb25zPg0KICAgICAgICA8RmlsZVB1Ymxpc2hlckNvbmRpdGlvbiBQdWJsaXNoZXJOYW1lPSJPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIFByb2R1Y3ROYW1lPSJNSUNST1NPRlQgT1VUTE9PSyIgQmluYXJ5TmFtZT0iT1VUTE9PSy5FWEUiPg0KICAgICAgICAgIDxCaW5hcnlWZXJzaW9uUmFuZ2UgTG93U2VjdGlvbj0iMTYuMC44MjAxLjIwMjUiIEhpZ2hTZWN0aW9uPSIqIiAvPg0KICAgICAgICA8L0ZpbGVQdWJsaXNoZXJDb25kaXRpb24+DQogICAgICA8L0NvbmRpdGlvbnM+DQogICAgPC9GaWxlUHVibGlzaGVyUnVsZT4NCiAgICA8RmlsZVB1Ymxpc2hlclJ1bGUgSWQ9ImY5NjFlODQ2LTNmZTctNDY0Yy05NTA4LTAzNTMzN2QxZTg2OCIgTmFtZT0iRVhDRUwuRVhFLCB2ZXJzaW9uIDE2LjAuODIwMS4yMDI1IGFuZCBhYm92ZSwgaW4gTUlDUk9TT0ZUIE9GRklDRSAyMDE2LCBmcm9tIE89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgRGVzY3JpcHRpb249IiIgVXNlck9yR3JvdXBTaWQ9IlMtMS0xLTAiIEFjdGlvbj0iQWxsb3ciPg0KICAgICAgPENvbmRpdGlvbnM+DQogICAgICAgIDxGaWxlUHVibGlzaGVyQ29uZGl0aW9uIFB1Ymxpc2hlck5hbWU9Ik89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgUHJvZHVjdE5hbWU9Ik1JQ1JPU09GVCBPRkZJQ0UgMjAxNiIgQmluYXJ5TmFtZT0iRVhDRUwuRVhFIj4NCiAgICAgICAgICA8QmluYXJ5VmVyc2lvblJhbmdlIExvd1NlY3Rpb249IjE2LjAuODIwMS4yMDI1IiBIaWdoU2VjdGlvbj0iKiIgLz4NCiAgICAgICAgPC9GaWxlUHVibGlzaGVyQ29uZGl0aW9uPg0KICAgICAgPC9Db25kaXRpb25zPg0KICAgIDwvRmlsZVB1Ymxpc2hlclJ1bGU+DQogICAgPEZpbGVQdWJsaXNoZXJSdWxlIElkPSJkNzAzMzE5Yy0wYzllLTQ0NjctYWQwOS03MTMzMDdlMzBkZjYiIE5hbWU9Ik1JQ1JPU09GVCBPRkZJQ0UsIGZyb20gTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBEZXNjcmlwdGlvbj0iIiBVc2VyT3JHcm91cFNpZD0iUy0xLTEtMCIgQWN0aW9uPSJEZW55Ij4NCiAgICAgIDxDb25kaXRpb25zPg0KICAgICAgICA8RmlsZVB1Ymxpc2hlckNvbmRpdGlvbiBQdWJsaXNoZXJOYW1lPSJPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIFByb2R1Y3ROYW1lPSJNSUNST1NPRlQgT0ZGSUNFIiBCaW5hcnlOYW1lPSIqIj4NCiAgICAgICAgICA8QmluYXJ5VmVyc2lvblJhbmdlIExvd1NlY3Rpb249IioiIEhpZ2hTZWN0aW9uPSIqIiAvPg0KICAgICAgICA8L0ZpbGVQdWJsaXNoZXJDb25kaXRpb24+DQogICAgICA8L0NvbmRpdGlvbnM+DQogICAgPC9GaWxlUHVibGlzaGVyUnVsZT4NCiAgICA8RmlsZVB1Ymxpc2hlclJ1bGUgSWQ9ImRlOWYzNDYxLTY4NTYtNDA1ZC05NjI0LWE4MGNhNzAxZjZjYiIgTmFtZT0iTUlDUk9TT0ZUIE9GRklDRSAyMDAzLCBmcm9tIE89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgRGVzY3JpcHRpb249IiIgVXNlck9yR3JvdXBTaWQ9IlMtMS0xLTAiIEFjdGlvbj0iRGVueSI+DQogICAgICA8Q29uZGl0aW9ucz4NCiAgICAgICAgPEZpbGVQdWJsaXNoZXJDb25kaXRpb24gUHVibGlzaGVyTmFtZT0iTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBQcm9kdWN0TmFtZT0iTUlDUk9TT0ZUIE9GRklDRSAyMDAzIiBCaW5hcnlOYW1lPSIqIj4NCiAgICAgICAgICA8QmluYXJ5VmVyc2lvblJhbmdlIExvd1NlY3Rpb249IioiIEhpZ2hTZWN0aW9uPSIqIiAvPg0KICAgICAgICA8L0ZpbGVQdWJsaXNoZXJDb25kaXRpb24+DQogICAgICA8L0NvbmRpdGlvbnM+DQogICAgPC9GaWxlUHVibGlzaGVyUnVsZT4NCiAgICA8RmlsZVB1Ymxpc2hlclJ1bGUgSWQ9ImFkZTFiODI4LTcwNTUtNDdmYy05OWJjLTQzMmNmN2QxMjA5ZSIgTmFtZT0iMjAwNyBNSUNST1NPRlQgT0ZGSUNFIFNZU1RFTSwgZnJvbSBPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIERlc2NyaXB0aW9uPSIiIFVzZXJPckdyb3VwU2lkPSJTLTEtMS0wIiBBY3Rpb249IkRlbnkiPg0KICAgICAgPENvbmRpdGlvbnM+DQogICAgICAgIDxGaWxlUHVibGlzaGVyQ29uZGl0aW9uIFB1Ymxpc2hlck5hbWU9Ik89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgUHJvZHVjdE5hbWU9IjIwMDcgTUlDUk9TT0ZUIE9GRklDRSBTWVNURU0iIEJpbmFyeU5hbWU9IioiPg0KICAgICAgICAgIDxCaW5hcnlWZXJzaW9uUmFuZ2UgTG93U2VjdGlvbj0iKiIgSGlnaFNlY3Rpb249IioiIC8+DQogICAgICAgIDwvRmlsZVB1Ymxpc2hlckNvbmRpdGlvbj4NCiAgICAgIDwvQ29uZGl0aW9ucz4NCiAgICA8L0ZpbGVQdWJsaXNoZXJSdWxlPg0KICAgIDxGaWxlUHVibGlzaGVyUnVsZSBJZD0iYmIzODc3YjYtZjFhZC00YzgzLTk2ZTItZDZiZjc1ZTMzY2JmIiBOYW1lPSJNSUNST1NPRlQgT0ZGSUNFIDIwMTAsIGZyb20gTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBEZXNjcmlwdGlvbj0iIiBVc2VyT3JHcm91cFNpZD0iUy0xLTEtMCIgQWN0aW9uPSJEZW55Ij4NCiAgICAgIDxDb25kaXRpb25zPg0KICAgICAgICA8RmlsZVB1Ymxpc2hlckNvbmRpdGlvbiBQdWJsaXNoZXJOYW1lPSJPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIFByb2R1Y3ROYW1lPSJNSUNST1NPRlQgT0ZGSUNFIDIwMTAiIEJpbmFyeU5hbWU9IioiPg0KICAgICAgICAgIDxCaW5hcnlWZXJzaW9uUmFuZ2UgTG93U2VjdGlvbj0iKiIgSGlnaFNlY3Rpb249IioiIC8+DQogICAgICAgIDwvRmlsZVB1Ymxpc2hlckNvbmRpdGlvbj4NCiAgICAgIDwvQ29uZGl0aW9ucz4NCiAgICA8L0ZpbGVQdWJsaXNoZXJSdWxlPg0KICAgIDxGaWxlUHVibGlzaGVyUnVsZSBJZD0iMjM2MzVlZWYtYjFlMy00ZGEyLTg4NTktMDYzOGVjNjA3YjM4IiBOYW1lPSJNSUNST1NPRlQgT0ZGSUNFIDIwMTMsIGZyb20gTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBEZXNjcmlwdGlvbj0iIiBVc2VyT3JHcm91cFNpZD0iUy0xLTEtMCIgQWN0aW9uPSJEZW55Ij4NCiAgICAgIDxDb25kaXRpb25zPg0KICAgICAgICA8RmlsZVB1Ymxpc2hlckNvbmRpdGlvbiBQdWJsaXNoZXJOYW1lPSJPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIFByb2R1Y3ROYW1lPSJNSUNST1NPRlQgT0ZGSUNFIDIwMTMiIEJpbmFyeU5hbWU9IioiPg0KICAgICAgICAgIDxCaW5hcnlWZXJzaW9uUmFuZ2UgTG93U2VjdGlvbj0iKiIgSGlnaFNlY3Rpb249IioiIC8+DQogICAgICAgIDwvRmlsZVB1Ymxpc2hlckNvbmRpdGlvbj4NCiAgICAgIDwvQ29uZGl0aW9ucz4NCiAgICA8L0ZpbGVQdWJsaXNoZXJSdWxlPg0KICAgIDxGaWxlUHVibGlzaGVyUnVsZSBJZD0iZDJkMDUyMGEtNTdkZS00YmQ1LWJjZDktYjNkNDcyMjFmODdhIiBOYW1lPSJNSUNST1NPRlQgT0ZGSUNFIDIwMTYsIGZyb20gTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBEZXNjcmlwdGlvbj0iIiBVc2VyT3JHcm91cFNpZD0iUy0xLTEtMCIgQWN0aW9uPSJEZW55Ij4NCiAgICAgIDxDb25kaXRpb25zPg0KICAgICAgICA8RmlsZVB1Ymxpc2hlckNvbmRpdGlvbiBQdWJsaXNoZXJOYW1lPSJPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIFByb2R1Y3ROYW1lPSJNSUNST1NPRlQgT0ZGSUNFIDIwMTYiIEJpbmFyeU5hbWU9IioiPg0KICAgICAgICAgIDxCaW5hcnlWZXJzaW9uUmFuZ2UgTG93U2VjdGlvbj0iKiIgSGlnaFNlY3Rpb249IioiIC8+DQogICAgICAgIDwvRmlsZVB1Ymxpc2hlckNvbmRpdGlvbj4NCiAgICAgIDwvQ29uZGl0aW9ucz4NCiAgICAgIDxFeGNlcHRpb25zPg0KICAgICAgICA8RmlsZVB1Ymxpc2hlckNvbmRpdGlvbiBQdWJsaXNoZXJOYW1lPSJPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIFByb2R1Y3ROYW1lPSJNSUNST1NPRlQgT0ZGSUNFIDIwMTYiIEJpbmFyeU5hbWU9IkVYQ0VMLkVYRSI+DQogICAgICAgICAgPEJpbmFyeVZlcnNpb25SYW5nZSBMb3dTZWN0aW9uPSIxNi4wLjgyMDEuMjAyNSIgSGlnaFNlY3Rpb249IioiIC8+DQogICAgICAgIDwvRmlsZVB1Ymxpc2hlckNvbmRpdGlvbj4NCiAgICAgICAgPEZpbGVQdWJsaXNoZXJDb25kaXRpb24gUHVibGlzaGVyTmFtZT0iTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBQcm9kdWN0TmFtZT0iTUlDUk9TT0ZUIE9GRklDRSAyMDE2IiBCaW5hcnlOYW1lPSJMWU5DLkVYRSI+DQogICAgICAgICAgPEJpbmFyeVZlcnNpb25SYW5nZSBMb3dTZWN0aW9uPSIxNi4wLjc4NzAuMjAyMCIgSGlnaFNlY3Rpb249IioiIC8+DQogICAgICAgIDwvRmlsZVB1Ymxpc2hlckNvbmRpdGlvbj4NCiAgICAgICAgPEZpbGVQdWJsaXNoZXJDb25kaXRpb24gUHVibGlzaGVyTmFtZT0iTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBQcm9kdWN0TmFtZT0iTUlDUk9TT0ZUIE9GRklDRSAyMDE2IiBCaW5hcnlOYW1lPSJMWU5DOTkuRVhFIj4NCiAgICAgICAgICA8QmluYXJ5VmVyc2lvblJhbmdlIExvd1NlY3Rpb249IjE2LjAuNzg3MC4yMDIwIiBIaWdoU2VjdGlvbj0iKiIgLz4NCiAgICAgICAgPC9GaWxlUHVibGlzaGVyQ29uZGl0aW9uPg0KICAgICAgICA8RmlsZVB1Ymxpc2hlckNvbmRpdGlvbiBQdWJsaXNoZXJOYW1lPSJPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIFByb2R1Y3ROYW1lPSJNSUNST1NPRlQgT0ZGSUNFIDIwMTYiIEJpbmFyeU5hbWU9Ik1TT1NZTkMuRVhFIj4NCiAgICAgICAgICA8QmluYXJ5VmVyc2lvblJhbmdlIExvd1NlY3Rpb249IjE2LjAuODIwMS4yMDI1IiBIaWdoU2VjdGlvbj0iKiIgLz4NCiAgICAgICAgPC9GaWxlUHVibGlzaGVyQ29uZGl0aW9uPg0KICAgICAgICA8RmlsZVB1Ymxpc2hlckNvbmRpdGlvbiBQdWJsaXNoZXJOYW1lPSJPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIFByb2R1Y3ROYW1lPSJNSUNST1NPRlQgT0ZGSUNFIDIwMTYiIEJpbmFyeU5hbWU9Ik9DUFVCTUdSLkVYRSI+DQogICAgICAgICAgPEJpbmFyeVZlcnNpb25SYW5nZSBMb3dTZWN0aW9uPSIxNi4wLjc4NzAuMjAyMCIgSGlnaFNlY3Rpb249IioiIC8+DQogICAgICAgIDwvRmlsZVB1Ymxpc2hlckNvbmRpdGlvbj4NCiAgICAgICAgPEZpbGVQdWJsaXNoZXJDb25kaXRpb24gUHVibGlzaGVyTmFtZT0iTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBQcm9kdWN0TmFtZT0iTUlDUk9TT0ZUIE9GRklDRSAyMDE2IiBCaW5hcnlOYW1lPSJQT1dFUlBOVC5FWEUiPg0KICAgICAgICAgIDxCaW5hcnlWZXJzaW9uUmFuZ2UgTG93U2VjdGlvbj0iMTYuMC44MjAxLjIwMjUiIEhpZ2hTZWN0aW9uPSIqIiAvPg0KICAgICAgICA8L0ZpbGVQdWJsaXNoZXJDb25kaXRpb24+DQogICAgICAgIDxGaWxlUHVibGlzaGVyQ29uZGl0aW9uIFB1Ymxpc2hlck5hbWU9Ik89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgUHJvZHVjdE5hbWU9Ik1JQ1JPU09GVCBPRkZJQ0UgMjAxNiIgQmluYXJ5TmFtZT0iVUNNQVBJLkVYRSI+DQogICAgICAgICAgPEJpbmFyeVZlcnNpb25SYW5nZSBMb3dTZWN0aW9uPSIxNi4wLjc4NzAuMjAyMCIgSGlnaFNlY3Rpb249IioiIC8+DQogICAgICAgIDwvRmlsZVB1Ymxpc2hlckNvbmRpdGlvbj4NCiAgICAgICAgPEZpbGVQdWJsaXNoZXJDb25kaXRpb24gUHVibGlzaGVyTmFtZT0iTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBQcm9kdWN0TmFtZT0iTUlDUk9TT0ZUIE9GRklDRSAyMDE2IiBCaW5hcnlOYW1lPSJXSU5XT1JELkVYRSI+DQogICAgICAgICAgPEJpbmFyeVZlcnNpb25SYW5nZSBMb3dTZWN0aW9uPSIxNi4wLjgyMDEuMjAyNSIgSGlnaFNlY3Rpb249IioiIC8+DQogICAgICAgIDwvRmlsZVB1Ymxpc2hlckNvbmRpdGlvbj4NCiAgICAgIDwvRXhjZXB0aW9ucz4NCiAgICA8L0ZpbGVQdWJsaXNoZXJSdWxlPg0KICAgIDxGaWxlUHVibGlzaGVyUnVsZSBJZD0iYTMzNjVkZmYtNjA1Mi00MWE4LTgyYTYtMzQ0NDRlYzI1OTUzIiBOYW1lPSJNSUNST1NPRlQgT05FTk9URSwgZnJvbSBPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIERlc2NyaXB0aW9uPSIiIFVzZXJPckdyb3VwU2lkPSJTLTEtMS0wIiBBY3Rpb249IkRlbnkiPg0KICAgICAgPENvbmRpdGlvbnM+DQogICAgICAgIDxGaWxlUHVibGlzaGVyQ29uZGl0aW9uIFB1Ymxpc2hlck5hbWU9Ik89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgUHJvZHVjdE5hbWU9Ik1JQ1JPU09GVCBPTkVOT1RFIiBCaW5hcnlOYW1lPSIqIj4NCiAgICAgICAgICA8QmluYXJ5VmVyc2lvblJhbmdlIExvd1NlY3Rpb249IioiIEhpZ2hTZWN0aW9uPSIqIiAvPg0KICAgICAgICA8L0ZpbGVQdWJsaXNoZXJDb25kaXRpb24+DQogICAgICA8L0NvbmRpdGlvbnM+DQogICAgICA8RXhjZXB0aW9ucz4NCiAgICAgICAgPEZpbGVQdWJsaXNoZXJDb25kaXRpb24gUHVibGlzaGVyTmFtZT0iTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBQcm9kdWN0TmFtZT0iTUlDUk9TT0ZUIE9ORU5PVEUiIEJpbmFyeU5hbWU9Ik9ORU5PVEUuRVhFIj4NCiAgICAgICAgICA8QmluYXJ5VmVyc2lvblJhbmdlIExvd1NlY3Rpb249IjE2LjAuODIwMS4yMDI1IiBIaWdoU2VjdGlvbj0iKiIgLz4NCiAgICAgICAgPC9GaWxlUHVibGlzaGVyQ29uZGl0aW9uPg0KICAgICAgICA8RmlsZVB1Ymxpc2hlckNvbmRpdGlvbiBQdWJsaXNoZXJOYW1lPSJPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIFByb2R1Y3ROYW1lPSJNSUNST1NPRlQgT05FTk9URSIgQmluYXJ5TmFtZT0iT05FTk9URU0uRVhFIj4NCiAgICAgICAgICA8QmluYXJ5VmVyc2lvblJhbmdlIExvd1NlY3Rpb249IjE2LjAuODIwMS4yMDI1IiBIaWdoU2VjdGlvbj0iKiIgLz4NCiAgICAgICAgPC9GaWxlUHVibGlzaGVyQ29uZGl0aW9uPg0KICAgICAgPC9FeGNlcHRpb25zPg0KICAgIDwvRmlsZVB1Ymxpc2hlclJ1bGU+DQogICAgPEZpbGVQdWJsaXNoZXJSdWxlIElkPSIwYmE0YzE1MC0xY2IzLTRjYjktYWIwMi0yNjUyNzQ0MTk0MDkiIE5hbWU9Ik1JQ1JPU09GVCBPVVRMT09LLCBmcm9tIE89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgRGVzY3JpcHRpb249IiIgVXNlck9yR3JvdXBTaWQ9IlMtMS0xLTAiIEFjdGlvbj0iRGVueSI+DQogICAgICA8Q29uZGl0aW9ucz4NCiAgICAgICAgPEZpbGVQdWJsaXNoZXJDb25kaXRpb24gUHVibGlzaGVyTmFtZT0iTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBQcm9kdWN0TmFtZT0iTUlDUk9TT0ZUIE9VVExPT0siIEJpbmFyeU5hbWU9IioiPg0KICAgICAgICAgIDxCaW5hcnlWZXJzaW9uUmFuZ2UgTG93U2VjdGlvbj0iKiIgSGlnaFNlY3Rpb249IioiIC8+DQogICAgICAgIDwvRmlsZVB1Ymxpc2hlckNvbmRpdGlvbj4NCiAgICAgIDwvQ29uZGl0aW9ucz4NCiAgICAgIDxFeGNlcHRpb25zPg0KICAgICAgICA8RmlsZVB1Ymxpc2hlckNvbmRpdGlvbiBQdWJsaXNoZXJOYW1lPSJPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIFByb2R1Y3ROYW1lPSJNSUNST1NPRlQgT1VUTE9PSyIgQmluYXJ5TmFtZT0iT1VUTE9PSy5FWEUiPg0KICAgICAgICAgIDxCaW5hcnlWZXJzaW9uUmFuZ2UgTG93U2VjdGlvbj0iMTYuMC44MjAxLjIwMjUiIEhpZ2hTZWN0aW9uPSIqIiAvPg0KICAgICAgICA8L0ZpbGVQdWJsaXNoZXJDb25kaXRpb24+DQogICAgICA8L0V4Y2VwdGlvbnM+DQogICAgPC9GaWxlUHVibGlzaGVyUnVsZT4NCiAgICA8RmlsZVB1Ymxpc2hlclJ1bGUgSWQ9IjY3MTRmODVmLWFkZGEtNGVjNy05NDdjLTc1NTJmN2Q5NDYyNSIgTmFtZT0iTUlDUk9TT0ZUIENMSVAgT1JHQU5JWkVSLCBmcm9tIE89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgRGVzY3JpcHRpb249IiIgVXNlck9yR3JvdXBTaWQ9IlMtMS0xLTAiIEFjdGlvbj0iRGVueSI+DQogICAgICA8Q29uZGl0aW9ucz4NCiAgICAgICAgPEZpbGVQdWJsaXNoZXJDb25kaXRpb24gUHVibGlzaGVyTmFtZT0iTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBQcm9kdWN0TmFtZT0iTUlDUk9TT0ZUIENMSVAgT1JHQU5JWkVSIiBCaW5hcnlOYW1lPSIqIj4NCiAgICAgICAgICA8QmluYXJ5VmVyc2lvblJhbmdlIExvd1NlY3Rpb249IioiIEhpZ2hTZWN0aW9uPSIqIiAvPg0KICAgICAgICA8L0ZpbGVQdWJsaXNoZXJDb25kaXRpb24+DQogICAgICA8L0NvbmRpdGlvbnM+DQogICAgPC9GaWxlUHVibGlzaGVyUnVsZT4JDQogICAgPEZpbGVQdWJsaXNoZXJSdWxlIElkPSI3NGFiMzY4Zi1hMTQ3LTRjZjktODBjMy01M2ZiNjY5YzQ4MzYiIE5hbWU9Ik1JQ1JPU09GVCBPRkZJQ0UgSU5GT1BBVEgsIGZyb20gTz1NSUNST1NPRlQgQ09SUE9SQVRJT04sIEw9UkVETU9ORCwgUz1XQVNISU5HVE9OLCBDPVVTIiBEZXNjcmlwdGlvbj0iIiBVc2VyT3JHcm91cFNpZD0iUy0xLTEtMCIgQWN0aW9uPSJEZW55Ij4NCiAgICAgIDxDb25kaXRpb25zPg0KICAgICAgICA8RmlsZVB1Ymxpc2hlckNvbmRpdGlvbiBQdWJsaXNoZXJOYW1lPSJPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIFByb2R1Y3ROYW1lPSJNSUNST1NPRlQgT0ZGSUNFIElORk9QQVRIIiBCaW5hcnlOYW1lPSIqIj4NCiAgICAgICAgICA8QmluYXJ5VmVyc2lvblJhbmdlIExvd1NlY3Rpb249IioiIEhpZ2hTZWN0aW9uPSIqIiAvPg0KICAgICAgICA8L0ZpbGVQdWJsaXNoZXJDb25kaXRpb24+DQogICAgICA8L0NvbmRpdGlvbnM+DQogICAgPC9GaWxlUHVibGlzaGVyUnVsZT4NCiAgICA8RmlsZVB1Ymxpc2hlclJ1bGUgSWQ9Ijk3NjlkMjA5LTg1ZjgtNDM4OS1iZGM2LWRkY2EzMGYxYzY3MSIgTmFtZT0iTUlDUk9TT0ZUIE9GRklDRSBIRUxQIFZJRVdFUiwgZnJvbSBPPU1JQ1JPU09GVCBDT1JQT1JBVElPTiwgTD1SRURNT05ELCBTPVdBU0hJTkdUT04sIEM9VVMiIERlc2NyaXB0aW9uPSIiIFVzZXJPckdyb3VwU2lkPSJTLTEtMS0wIiBBY3Rpb249IkRlbnkiPg0KICAgICAgPENvbmRpdGlvbnM+DQogICAgICAgIDxGaWxlUHVibGlzaGVyQ29uZGl0aW9uIFB1Ymxpc2hlck5hbWU9Ik89TUlDUk9TT0ZUIENPUlBPUkFUSU9OLCBMPVJFRE1PTkQsIFM9V0FTSElOR1RPTiwgQz1VUyIgUHJvZHVjdE5hbWU9Ik1JQ1JPU09GVCBPRkZJQ0UgSEVMUCBWSUVXRVIiIEJpbmFyeU5hbWU9IioiPg0KICAgICAgICAgIDxCaW5hcnlWZXJzaW9uUmFuZ2UgTG93U2VjdGlvbj0iKiIgSGlnaFNlY3Rpb249IioiIC8+DQogICAgICAgIDwvRmlsZVB1Ymxpc2hlckNvbmRpdGlvbj4NCiAgICAgIDwvQ29uZGl0aW9ucz4NCiAgICA8L0ZpbGVQdWJsaXNoZXJSdWxlPg0KCTwvUnVsZUNvbGxlY3Rpb24+DQo8L0FwcExvY2tlclBvbGljeT4=",
      "id": "4e49ffae-f006-46b9-b74d-785565f7efb4",
      "@odata.type": "
    }
  ],
  "exemptAppLockerFiles": [],
  "enterpriseNetworkDomainNames": [],
  "enterpriseProxiedDomains": [
    {
      "displayName": "SharePoint",
      "proxiedDomains": [
        {
          "ipAddressOrFQDN": "$Sharepoint.sharepoint.com",
          "@odata.type": "
        },
        {
          "ipAddressOrFQDN": "$Sharepoint-my.sharepoint.com",
          "@odata.type": "
        },
        {
          "ipAddressOrFQDN": "$Sharepoint.sharepoint.com",
          "@odata.type": "
        }
      ],
      "@odata.type": "
    }
  ],
  "enterpriseIPRanges": [],
  "enterpriseIPRangesAreAuthoritative": false,
  "enterpriseProxyServers": [],
  "enterpriseInternalProxyServers": [],
  "enterpriseProxyServersAreAuthoritative": false,
  "neutralDomainResources": [],
  "@odata.type": "
}

"@ <-||- 



 -||-> Write-Host "Adding Windows Information Protection Without Enrollment Policy from JSON..." -ForegroundColor Yellow <-||- 

 -||-> Add-WindowsInformationProtectionPolicy -JSON $ManagedAppPolicy_WIP <-||- 

 -||-> Write-Host <-||- 

 -||-> Write-Host "Adding Windows Information Protection MDM Policy from JSON..." -ForegroundColor Yellow <-||- 

 -||-> Add-MDMWindowsInformationProtectionPolicy -JSON $ManagedAppPolicy_WIP_MDM <-||- 

 -||-> Write-Host <-||- 

