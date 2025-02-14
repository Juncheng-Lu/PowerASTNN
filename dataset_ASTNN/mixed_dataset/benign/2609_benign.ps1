














 -||-> function Test-Disk
{
    
     -||-> $rgname =  -||-> Get-ComputeTestResourceName <-||-  <-||- ;
     -||-> $diskname = 'disk' + $rgname <-||- ;

     -||-> try
    {
        
         -||-> $loc =  -||-> Get-ComputeVMLocation <-||-  <-||- ;
         -||-> New-AzureRmResourceGroup -Name $rgname -Location $loc -Force <-||- ;
         -||-> $subId =  -||-> Get-SubscriptionIdFromResourceGroup $rgname <-||-  <-||- ;
         -||-> $mockkey = 'https://myvault.vault-int.azure-int.net/secrets/123/' <-||- ;
         -||-> $mocksourcevault = '/subscriptions/' + $subId + '/resourceGroups/' + $rgname + '/providers/Microsoft.KeyVault/vaults/TestVault123' <-||- ;
         -||-> $access = 'Read' <-||- ;

        
         -||-> $diskconfig =  -||-> New-AzureRmDiskConfig -Location $loc -DiskSizeGB 5 -AccountType StandardLRS -OsType Windows -CreateOption Empty -EncryptionSettingsEnabled $true <-||-  <-||- ;
        
         -||-> $diskconfig =  -||-> Set-AzureRmDiskDiskEncryptionKey -Disk $diskconfig -SecretUrl $mockkey -SourceVaultId $mocksourcevault <-||-  <-||- ;
         -||-> $diskconfig =  -||-> Set-AzureRmDiskKeyEncryptionKey -Disk $diskconfig -KeyUrl $mockkey -SourceVaultId $mocksourcevault <-||-  <-||- ;
         -||-> Assert-AreEqual $mockkey $diskconfig.EncryptionSettings.DiskEncryptionKey.SecretUrl <-||- ;
         -||-> Assert-AreEqual $mocksourcevault $diskconfig.EncryptionSettings.DiskEncryptionKey.SourceVault.Id <-||- ;
         -||-> Assert-AreEqual $mockkey $diskconfig.EncryptionSettings.KeyEncryptionKey.KeyUrl <-||- ;
         -||-> Assert-AreEqual $mocksourcevault $diskconfig.EncryptionSettings.KeyEncryptionKey.SourceVault.Id <-||- ;

        
         -||-> $mockimage = '/subscriptions/' + $subId + '/resourceGroups/' + $rgname + '/providers/Microsoft.Compute/images/TestImage123' <-||- ;
         -||-> $diskconfig =  -||-> Set-AzureRmDiskImageReference -Disk $diskconfig -Id $mockimage -Lun 0 <-||-  <-||- ;
         -||-> Assert-AreEqual $mockimage $diskconfig.CreationData.ImageReference.Id <-||- ;
         -||-> Assert-AreEqual 0 $diskconfig.CreationData.ImageReference.Lun <-||- ;

         -||-> $diskconfig.EncryptionSettings.Enabled = $false <-||- ;
         -||-> $diskconfig.EncryptionSettings.DiskEncryptionKey = $null <-||- ;
         -||-> $diskconfig.EncryptionSettings.KeyEncryptionKey = $null <-||- ;
         -||-> $diskconfig.CreationData.ImageReference = $null <-||- ;

         -||-> New-AzureRmDisk -ResourceGroupName $rgname -DiskName $diskname -Disk $diskconfig <-||- ;

        
         -||-> $disk =  -||-> Get-AzureRmDisk -ResourceGroupName $rgname -DiskName $diskname <-||-  <-||- ;
         -||-> Assert-AreEqual 5 $disk.DiskSizeGB <-||- ;
         -||-> Assert-AreEqual StandardLRS $disk.AccountType <-||- ;
         -||-> Assert-AreEqual Windows $disk.OsType <-||- ;
         -||-> Assert-AreEqual Empty $disk.CreationData.CreateOption <-||- ;
         -||-> Assert-AreEqual $false $disk.EncryptionSettings.Enabled <-||- ;

        
         -||-> Grant-AzureRmDiskAccess -ResourceGroupName $rgname -DiskName $diskname -Access $access -DurationInSecond 5 <-||- ;
         -||-> Revoke-AzureRmDiskAccess -ResourceGroupName $rgname -DiskName $diskname <-||- ;

        
         -||-> $updateconfig =  -||-> New-AzureRmDiskUpdateConfig -DiskSizeGB 10 -AccountType PremiumLRS -OsType Windows -CreateOption Empty <-||-  <-||- ;
         -||-> Update-AzureRmDisk -ResourceGroupName $rgname -DiskName $diskname -DiskUpdate $updateconfig <-||- ;

        
         -||-> Remove-AzureRmDisk -ResourceGroupName $rgname -DiskName $diskname -Force <-||- ;
    }
    finally
    {
        
         -||-> Clean-ResourceGroup $rgname <-||- 
    } <-||- 
} <-||- 

 -||-> function Test-Snapshot
{
    
     -||-> $rgname =  -||-> Get-ComputeTestResourceName <-||-  <-||- ;
     -||-> $snapshotname = 'snapshot' + $rgname <-||- ;

     -||-> try
    {
        
         -||-> $loc =  -||-> Get-ComputeVMLocation <-||-  <-||- ;
         -||-> New-AzureRmResourceGroup -Name $rgname -Location $loc -Force <-||- ;
         -||-> $subId =  -||-> Get-SubscriptionIdFromResourceGroup $rgname <-||-  <-||- ;
         -||-> $mockkey = 'https://myvault.vault-int.azure-int.net/secrets/123/' <-||- ;
         -||-> $mocksourcevault = '/subscriptions/' + $subId + '/resourceGroups/' + $rgname + '/providers/Microsoft.KeyVault/vaults/TestVault123' <-||- ;
         -||-> $access = 'Read' <-||- ;

        
         -||-> $snapshotconfig =  -||-> New-AzureRmSnapshotConfig -Location $loc -DiskSizeGB 5 -AccountType StandardLRS -OsType Windows -CreateOption Empty -EncryptionSettingsEnabled $true <-||-  <-||- ;

        
         -||-> $snapshotconfig =  -||-> Set-AzureRmSnapshotDiskEncryptionKey -Snapshot $snapshotconfig -SecretUrl $mockkey -SourceVaultId $mocksourcevault <-||-  <-||- ;
         -||-> $snapshotconfig =  -||-> Set-AzureRmSnapshotKeyEncryptionKey -Snapshot $snapshotconfig -KeyUrl $mockkey -SourceVaultId $mocksourcevault <-||-  <-||- ;
         -||-> Assert-AreEqual $mockkey $snapshotconfig.EncryptionSettings.DiskEncryptionKey.SecretUrl <-||- ;
         -||-> Assert-AreEqual $mocksourcevault $snapshotconfig.EncryptionSettings.DiskEncryptionKey.SourceVault.Id <-||- ;
         -||-> Assert-AreEqual $mockkey $snapshotconfig.EncryptionSettings.KeyEncryptionKey.KeyUrl <-||- ;
         -||-> Assert-AreEqual $mocksourcevault $snapshotconfig.EncryptionSettings.KeyEncryptionKey.SourceVault.Id <-||- ;

        
         -||-> $mockimage = '/subscriptions/' + $subId + '/resourceGroups/' + $rgname + '/providers/Microsoft.Compute/images/TestImage123' <-||- ;
         -||-> $snapshotconfig =  -||-> Set-AzureRmSnapshotImageReference -Snapshot $snapshotconfig -Id $mockimage -Lun 0 <-||-  <-||- ;
         -||-> Assert-AreEqual $mockimage $snapshotconfig.CreationData.ImageReference.Id <-||- ;
         -||-> Assert-AreEqual 0 $snapshotconfig.CreationData.ImageReference.Lun <-||- ;

         -||-> $snapshotconfig.EncryptionSettings.Enabled = $false <-||- ;
         -||-> $snapshotconfig.EncryptionSettings.DiskEncryptionKey = $null <-||- ;
         -||-> $snapshotconfig.EncryptionSettings.KeyEncryptionKey = $null <-||- ;
         -||-> $snapshotconfig.CreationData.ImageReference = $null <-||- ;
         -||-> New-AzureRmSnapshot -ResourceGroupName $rgname -SnapshotName $snapshotname -Snapshot $snapshotconfig <-||- ;

        
         -||-> $snapshot =  -||-> Get-AzureRmSnapshot -ResourceGroupName $rgname -SnapshotName $snapshotname <-||-  <-||- ;
         -||-> Assert-AreEqual 5 $snapshot.DiskSizeGB <-||- ;
         -||-> Assert-AreEqual StandardLRS $snapshot.AccountType <-||- ;
         -||-> Assert-AreEqual Windows $snapshot.OsType <-||- ;
         -||-> Assert-AreEqual Empty $snapshot.CreationData.CreateOption <-||- ;
         -||-> Assert-AreEqual $false $snapshot.EncryptionSettings.Enabled <-||- ;

        
         -||-> Grant-AzureRmSnapshotAccess -ResourceGroupName $rgname -SnapshotName $snapshotname -Access $access -DurationInSecond 5 <-||- ;
         -||-> Revoke-AzureRmSnapshotAccess -ResourceGroupName $rgname -SnapshotName $snapshotname <-||- ;

        
         -||-> $updateconfig =  -||-> New-AzureRmSnapshotUpdateConfig -DiskSizeGB 10 -AccountType PremiumLRS -OsType Windows -CreateOption Empty <-||-  <-||- ;
         -||-> Update-AzureRmSnapshot -ResourceGroupName $rgname -SnapshotName $snapshotname -SnapshotUpdate $updateconfig <-||- ;

        
         -||-> Remove-AzureRmSnapshot -ResourceGroupName $rgname -SnapshotName $snapshotname -Force <-||- ;
    }
    finally
    {
        
         -||-> Clean-ResourceGroup $rgname <-||- 
    } <-||- 
} <-||- 

