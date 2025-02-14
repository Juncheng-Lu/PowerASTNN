














 -||-> function Test-VirtualMachineProfile
{
     -||-> Get-AzVmss -ResourceGroupName "fakeresource" -VMScaleSetName "fakevmss" -ErrorAction SilentlyContinue <-||- 

    
     -||-> $vmsize = 'Standard_A2' <-||- ;
     -||-> $vmname = 'pstestvm' + ( -||-> ( -||-> Get-Random <-||- ) % 10000 <-||- ) <-||- ;
     -||-> $vmssID =  "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rggroup/providers/Microsoft.Compute/virtualMachineScaleSets/testvmss" <-||- 
     -||-> $p =  -||-> New-AzVMConfig -VMName $vmname -VMSize $vmsize -VmssId $vmssID <-||-  <-||- ;
     -||-> Assert-AreEqual $p.HardwareProfile.VmSize $vmsize <-||- ;
     -||-> Assert-AreEqual $vmssID $p.VirtualMachineScaleSet.Id <-||- ;

    
     -||-> $ipname = 'hpfip' + ( -||-> ( -||-> Get-Random <-||- ) % 10000 <-||- ) <-||- ;
     -||-> $ipRefUri1 = "https://test.foo.bar/$ipname" <-||- ;
     -||-> $nicName = $ipname + 'nic1' <-||- ;
     -||-> $publicIPName = $ipname + 'name1' <-||- ;

     -||-> $p =  -||-> Add-AzVMNetworkInterface -VM $p -Id $ipRefUri1 <-||-  <-||- ;

     -||-> $ipname = 'hpfip' + ( -||-> ( -||-> Get-Random <-||- ) % 10000 <-||- ) <-||- ;
     -||-> $ipRefUri2 = "https://test.foo.bar/$ipname" <-||- ;
     -||-> $p =  -||-> Add-AzVMNetworkInterface -VM $p -Id $ipRefUri2 <-||-  <-||- ;

    
     -||-> $p =  -||-> $p | Remove-AzVMNetworkInterface <-||-  <-||- ;
     -||-> Assert-AreEqual $p.NetworkProfile.NetworkInterfaces.Count 0 <-||- ;

     -||-> $p =  -||-> Add-AzVMNetworkInterface -VM $p -Id $ipRefUri1 -Primary <-||-  <-||- ;
     -||-> $p =  -||-> Add-AzVMNetworkInterface -VM $p -Id $ipRefUri2 <-||-  <-||- ;
     -||-> $p =  -||-> Remove-AzVMNetworkInterface -VM $p -Id $ipRefUri2 <-||-  <-||- ;

     -||-> Assert-AreEqual $p.NetworkProfile.NetworkInterfaces.Count 1 <-||- ;
     -||-> Assert-AreEqual $p.NetworkProfile.NetworkInterfaces[0].Id $ipRefUri1 <-||- ;
     -||-> Assert-AreEqual $p.NetworkProfile.NetworkInterfaces[0].Primary $true <-||- ;

    
     -||-> $stoname = 'hpfteststo' + ( -||-> ( -||-> Get-Random <-||- ) % 10000 <-||- ) <-||- ;
     -||-> $stotype = 'Standard_GRS' <-||- ;

     -||-> $osDiskName = 'osDisk' <-||- ;
     -||-> $osDiskCaching = 'ReadWrite' <-||- ;
     -||-> $osDiskVhdUri = "https://$stoname.blob.core.windows.net/test/os.vhd" <-||- ;
     -||-> $dataDiskVhdUri1 = "https://$stoname.blob.core.windows.net/test/data1.vhd" <-||- ;
     -||-> $dataDiskVhdUri2 = "https://$stoname.blob.core.windows.net/test/data2.vhd" <-||- ;

     -||-> $p =  -||-> Set-AzVMOSDisk -VM $p -Name $osDiskName -VhdUri $osDiskVhdUri -Caching $osDiskCaching -CreateOption Empty <-||-  <-||- ;

     -||-> $p =  -||-> Add-AzVMDataDisk -VM $p -Name 'testDataDisk1' -Caching 'ReadOnly' -DiskSizeInGB 10 -Lun 0 -VhdUri $dataDiskVhdUri1 -CreateOption Empty <-||-  <-||- ;
     -||-> $p =  -||-> Add-AzVMDataDisk -VM $p -Name 'testDataDisk2' -Caching 'ReadOnly' -DiskSizeInGB 11 -Lun 1 -VhdUri $dataDiskVhdUri2 -CreateOption Empty <-||-  <-||- ;

    
     -||-> $managedDataDiskId = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rggroup/providers/Microsoft.Compute/disks/testDataDisk3" <-||- ;
     -||-> Assert-ThrowsContains `
        {  -||-> Add-AzVMDataDisk -VM $p -Name 'dataDisk' -Caching 'ReadOnly' -DiskSizeInGB $null -Lun 2 -CreateOption Empty -ManagedDiskId $managedDataDiskId -StorageAccountType Standard_LRS <-||- ; } `
        "does not match with given managed disk ID" <-||- ;

     -||-> $p =  -||-> Add-AzVMDataDisk -VM $p -Name 'testDataDisk3' -Caching 'ReadOnly' -DiskSizeInGB $null -Lun 2 -CreateOption Empty `
                          -ManagedDiskId $managedDataDiskId -StorageAccountType Standard_LRS -DiskEncryptionSetId "enc_id1" <-||-  <-||- ;
     -||-> Assert-AreEqual $managedDataDiskId $p.StorageProfile.DataDisks[2].ManagedDisk.Id <-||- ;
     -||-> Assert-AreEqual "Standard_LRS" $p.StorageProfile.DataDisks[2].ManagedDisk.StorageAccountType <-||- ;
     -||-> Assert-Null $p.StorageProfile.DataDisks[2].DiskSizeGB <-||- ;
     -||-> Assert-AreEqual $false $p.StorageProfile.DataDisks[2].WriteAcceleratorEnabled <-||- ;
     -||-> Assert-AreEqual "enc_id1" $p.StorageProfile.DataDisks[2].ManagedDisk.DiskEncryptionSet.Id <-||- ;

     -||-> $p =  -||-> Set-AzVMDataDisk -VM $p -Name 'testDataDisk3' -StorageAccountType Premium_LRS -WriteAccelerator -DiskEncryptionSetId "enc_id2" <-||-  <-||- ;
     -||-> Assert-AreEqual $managedDataDiskId $p.StorageProfile.DataDisks[2].ManagedDisk.Id <-||- ;
     -||-> Assert-AreEqual "Premium_LRS" $p.StorageProfile.DataDisks[2].ManagedDisk.StorageAccountType <-||- ;
     -||-> Assert-AreEqual $true $p.StorageProfile.DataDisks[2].WriteAcceleratorEnabled <-||- ;
     -||-> Assert-AreEqual "enc_id2" $p.StorageProfile.DataDisks[2].ManagedDisk.DiskEncryptionSet.Id <-||- ;

     -||-> $p =  -||-> Remove-AzVMDataDisk -VM $p -Name 'testDataDisk3' <-||-  <-||- ;

     -||-> Assert-AreEqual $p.StorageProfile.OSDisk.Caching $osDiskCaching <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.OSDisk.Name $osDiskName <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.OSDisk.Vhd.Uri $osDiskVhdUri <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.OSDisk.Vhd.Uri $osDiskVhdUri <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.DataDisks.Count 2 <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.DataDisks[0].Caching 'ReadOnly' <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.DataDisks[0].DiskSizeGB 10 <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.DataDisks[0].Lun 0 <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.DataDisks[0].Vhd.Uri $dataDiskVhdUri1 <-||- ;
     -||-> Assert-Null $p.StorageProfile.DataDisks[0].WriteAcceleratorEnabled <-||- ;

     -||-> Assert-AreEqual $p.StorageProfile.DataDisks[1].Caching 'ReadOnly' <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.DataDisks[1].DiskSizeGB 11 <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.DataDisks[1].Lun 1 <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.DataDisks[1].Vhd.Uri $dataDiskVhdUri2 <-||- ;
     -||-> Assert-Null $p.StorageProfile.DataDisks[1].WriteAcceleratorEnabled <-||- ;

    
     -||-> $p =  -||-> $p | Remove-AzVMDataDisk <-||-  <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.DataDisks.Count 0 <-||- ;

     -||-> $p =  -||-> Add-AzVMDataDisk -VM $p -Name 'testDataDisk1' -Caching 'ReadOnly' -DiskSizeInGB 10 -Lun 0 -VhdUri $dataDiskVhdUri1 -CreateOption Empty <-||-  <-||- ;
     -||-> $p =  -||-> Add-AzVMDataDisk -VM $p -Name 'testDataDisk2' -Caching 'ReadOnly' -DiskSizeInGB 11 -Lun 1 -VhdUri $dataDiskVhdUri2 -CreateOption Empty <-||-  <-||- ;

     -||-> Assert-AreEqual $p.StorageProfile.DataDisks.Count 2 <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.DataDisks[0].Caching 'ReadOnly' <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.DataDisks[0].DiskSizeGB 10 <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.DataDisks[0].Lun 0 <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.DataDisks[0].Vhd.Uri $dataDiskVhdUri1 <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.DataDisks[1].Caching 'ReadOnly' <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.DataDisks[1].DiskSizeGB 11 <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.DataDisks[1].Lun 1 <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.DataDisks[1].Vhd.Uri $dataDiskVhdUri2 <-||- ;

     -||-> $managedOsDiskId_0 = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rggroup/providers/Microsoft.Compute/disks/osDisk0" <-||- ;
     -||-> $managedOsDiskId_1 = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rggroup/providers/Microsoft.Compute/disks/osDisk1" <-||- ;

     -||-> $p =  -||-> Set-AzVMOsDisk -VM $p -ManagedDiskId $managedOsDiskId_0 -StorageAccountType Standard_LRS -WriteAccelerator <-||-  <-||- ;
     -||-> Assert-AreEqual $osDiskCaching $p.StorageProfile.OSDisk.Caching <-||- ;
     -||-> Assert-AreEqual $osDiskName $p.StorageProfile.OSDisk.Name <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.OSDisk.Vhd.Uri $osDiskVhdUri <-||- ;
     -||-> Assert-AreEqual $managedOsDiskId_0 $p.StorageProfile.OSDisk.ManagedDisk.Id <-||- ;
     -||-> Assert-AreEqual "Standard_LRS" $p.StorageProfile.OSDisk.ManagedDisk.StorageAccountType <-||- ;
     -||-> Assert-AreEqual $true $p.StorageProfile.OSDisk.WriteAcceleratorEnabled <-||- ;
     -||-> Assert-Null $p.StorageProfile.OSDisk.DiffDiskSettings <-||- ;

     -||-> $p =  -||-> Set-AzVMOsDisk -VM $p -ManagedDiskId $managedOsDiskId_1 -DiffDiskSetting "Local" -DiskEncryptionSetId "enc_id3" <-||-  <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.OSDisk.Caching $osDiskCaching <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.OSDisk.Name $osDiskName <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.OSDisk.Vhd.Uri $osDiskVhdUri <-||- ;
     -||-> Assert-AreEqual $managedOsDiskId_1 $p.StorageProfile.OSDisk.ManagedDisk.Id <-||- ;
     -||-> Assert-AreEqual "enc_id3" $p.StorageProfile.OSDisk.ManagedDisk.DiskEncryptionSet.Id <-||- ;
     -||-> Assert-Null $p.StorageProfile.OSDisk.ManagedDisk.StorageAccountType <-||- ;
     -||-> Assert-AreEqual $false $p.StorageProfile.OSDisk.WriteAcceleratorEnabled <-||- ;
     -||-> Assert-AreEqual "Local" $p.StorageProfile.OSDisk.DiffDiskSettings.Option <-||- ;

    
     -||-> $user = "Foo12" <-||- ;
     -||-> $password = $PLACEHOLDER <-||- ;
     -||-> $securePassword =  -||-> ConvertTo-SecureString $password -AsPlainText -Force <-||-  <-||- ;
     -||-> $cred =  -||-> New-Object System.Management.Automation.PSCredential ( -||-> $user, $securePassword <-||- ) <-||-  <-||- ;
     -||-> $computerName = 'test' <-||- ;
     -||-> $vhdContainer = "https://$stoname.blob.core.windows.net/test" <-||- ;

     -||-> $winRMCertUrl = "http://keyVaultName.vault.azure.net/secrets/secretName/secretVersion" <-||- ;
     -||-> $timeZone = "Pacific Standard Time" <-||- ;
     -||-> $custom = "echo 'Hello World'" <-||- ;
     -||-> $encodedCustom = "ZWNobyAnSGVsbG8gV29ybGQn" <-||- ;

     -||-> $p =  -||-> Set-AzVMOperatingSystem -VM $p -Windows -ComputerName $computerName -Credential $cred -CustomData $custom -WinRMHttp -WinRMHttps -WinRMCertificateUrl $winRMCertUrl -ProvisionVMAgent -EnableAutoUpdate -TimeZone $timeZone <-||-  <-||- ;

    
     -||-> $imgRef =  -||-> Get-DefaultCRPWindowsImageOffline -loc $loc <-||-  <-||- ;
     -||-> $p = ( -||-> $imgRef | Set-AzVMSourceImage -VM $p <-||- ) <-||- ;

     -||-> $subid = ( -||-> Get-AzContext <-||- ).Subscription.SubscriptionId <-||- ;

     -||-> $referenceUri = "/subscriptions/" + $subid + "/resourceGroups/RgTest1/providers/Microsoft.KeyVault/vaults/TestVault123" <-||- ;
     -||-> $certStore = "My" <-||- ;
     -||-> $certUrl =  "https://testvault123.vault.azure.net/secrets/Test1/514ceb769c984379a7e0230bdd703272" <-||- ;
     -||-> $p =  -||-> Add-AzVMSecret -VM $p -SourceVaultId $referenceUri -CertificateStore $certStore -CertificateUrl $certUrl <-||-  <-||- ;

     -||-> $referenceUri2 = "/subscriptions/" + $subid + "/resourceGroups/RgTest1/providers/Microsoft.KeyVault/vaults/TestVault456" <-||- ;
     -||-> $p =  -||-> Add-AzVMSecret -VM $p -SourceVaultId $referenceUri2 -CertificateStore $certStore -CertificateUrl $certUrl <-||-  <-||- ;

     -||-> $certStore2 = "My2" <-||- ;
     -||-> $certUrl2 =  "https://testvault123.vault.azure.net/secrets/Test1/514ceb769c984379a7e0230bddaaaaaa" <-||- ;
     -||-> $p =  -||-> Add-AzVMSecret -VM $p -SourceVaultId $referenceUri -CertificateStore $certStore2 -CertificateUrl $certUrl2 <-||-  <-||- ;

     -||-> Assert-AreEqual 2 $p.OSProfile.Secrets.Count <-||- ;
     -||-> Assert-AreEqual $p.OSProfile.Secrets[0].SourceVault.Id $referenceUri <-||- ;
     -||-> Assert-AreEqual $p.OSProfile.Secrets[0].VaultCertificates[0].CertificateStore $certStore <-||- ;
     -||-> Assert-AreEqual $p.OSProfile.Secrets[0].VaultCertificates[0].CertificateUrl $certUrl <-||- ;
     -||-> Assert-AreEqual $p.OSProfile.Secrets[0].SourceVault.Id $referenceUri <-||- ;
     -||-> Assert-AreEqual $p.OSProfile.Secrets[0].VaultCertificates[1].CertificateStore $certStore2 <-||- ;
     -||-> Assert-AreEqual $p.OSProfile.Secrets[0].VaultCertificates[1].CertificateUrl $certUrl2 <-||- ;
     -||-> Assert-AreEqual $p.OSProfile.Secrets[1].SourceVault.Id $referenceUri2 <-||- ;
     -||-> Assert-AreEqual $p.OSProfile.Secrets[1].VaultCertificates[0].CertificateStore $certStore <-||- ;
     -||-> Assert-AreEqual $p.OSProfile.Secrets[1].VaultCertificates[0].CertificateUrl $certUrl <-||- ;

     -||-> $p =  -||-> Remove-AzVMSecret -VM $p -SourceVaultId $referenceUri <-||-  <-||- ;
     -||-> Assert-AreEqual 1 $p.OSProfile.Secrets.Count <-||- ;
     -||-> Assert-AreEqual $p.OSProfile.Secrets[0].SourceVault.Id $referenceUri2 <-||- ;
     -||-> Assert-AreEqual $p.OSProfile.Secrets[0].VaultCertificates[0].CertificateStore $certStore <-||- ;
     -||-> Assert-AreEqual $p.OSProfile.Secrets[0].VaultCertificates[0].CertificateUrl $certUrl <-||- ;

     -||-> $p =  -||-> Remove-AzVMSecret -VM $p <-||-  <-||- ;
     -||-> Assert-AreEqual 0 $p.OSProfile.Secrets.Count <-||- ;

     -||-> $p =  -||-> Add-AzVMSecret -VM $p -SourceVaultId $referenceUri -CertificateStore $certStore -CertificateUrl $certUrl <-||-  <-||- ;
     -||-> $p =  -||-> Add-AzVMSecret -VM $p -SourceVaultId $referenceUri2 -CertificateStore $certStore -CertificateUrl $certUrl <-||-  <-||- ;
     -||-> $p =  -||-> Add-AzVMSecret -VM $p -SourceVaultId $referenceUri -CertificateStore $certStore2 -CertificateUrl $certUrl2 <-||-  <-||- ;

     -||-> $aucSetting = "AutoLogon" <-||- ;
     -||-> $aucContent = "<UserAccounts><AdministratorPassword><Value>" + $password + "</Value><PlainText>true</PlainText></AdministratorPassword></UserAccounts>" <-||- ;
     -||-> $p =  -||-> Add-AzVMAdditionalUnattendContent -VM $p -Content $aucContent -SettingName $aucSetting <-||-  <-||- ;
     -||-> $p =  -||-> Add-AzVMAdditionalUnattendContent -VM $p -Content $aucContent -SettingName $aucSetting <-||-  <-||- ;

     -||-> Assert-AreEqual $p.OSProfile.AdminUsername $user <-||- ;
     -||-> Assert-AreEqual $p.OSProfile.ComputerName $computerName <-||- ;
     -||-> Assert-AreEqual $p.OSProfile.AdminPassword $password <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.ImageReference.Offer $imgRef.Offer <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.ImageReference.Publisher $imgRef.PublisherName <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.ImageReference.Sku $imgRef.Skus <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.ImageReference.Version $imgRef.Version <-||- ;
     -||-> Assert-AreEqual $p.OSProfile.Secrets[0].SourceVault.Id $referenceUri <-||- ;
     -||-> Assert-AreEqual $p.OSProfile.Secrets[0].VaultCertificates[0].CertificateStore $certStore <-||- ;
     -||-> Assert-AreEqual $p.OSProfile.Secrets[0].VaultCertificates[0].CertificateUrl $certUrl <-||- ;
     -||-> Assert-AreEqual $p.OSProfile.Secrets[0].SourceVault.Id $referenceUri <-||- ;
     -||-> Assert-AreEqual $p.OSProfile.Secrets[0].VaultCertificates[1].CertificateStore $certStore2 <-||- ;
     -||-> Assert-AreEqual $p.OSProfile.Secrets[0].VaultCertificates[1].CertificateUrl $certUrl2 <-||- ;
     -||-> Assert-AreEqual $p.OSProfile.Secrets[1].SourceVault.Id $referenceUri2 <-||- ;
     -||-> Assert-AreEqual $p.OSProfile.Secrets[1].VaultCertificates[0].CertificateStore $certStore <-||- ;
     -||-> Assert-AreEqual $p.OSProfile.Secrets[1].VaultCertificates[0].CertificateUrl $certUrl <-||- ;
     -||-> Assert-AreEqual $encodedCustom $p.OSProfile.CustomData <-||- ;

    
     -||-> Assert-Null $p.OSProfile.WindowsConfiguration.WinRM.Listeners[0].CertificateUrl <-||- ;
     -||-> Assert-AreEqual "http" $p.OSProfile.WindowsConfiguration.WinRM.Listeners[0].Protocol <-||-  ;
     -||-> Assert-AreEqual $winRMCertUrl $p.OSProfile.WindowsConfiguration.WinRM.Listeners[1].CertificateUrl <-||-  ;
     -||-> Assert-AreEqual "https" $p.OSProfile.WindowsConfiguration.WinRM.Listeners[1].Protocol <-||-  ;

    
     -||-> Assert-AreEqual $true $p.OSProfile.WindowsConfiguration.ProvisionVMAgent <-||- ;
     -||-> Assert-AreEqual $true $p.OSProfile.WindowsConfiguration.EnableAutomaticUpdates <-||- ;
     -||-> Assert-AreEqual $timeZone $p.OSProfile.WindowsConfiguration.TimeZone <-||- ;

    
    
     -||-> Assert-AreEqual $aucContent $p.OSProfile.WindowsConfiguration.AdditionalUnattendContent[0].Content <-||- ;
     -||-> Assert-AreEqual "oobeSystem" $p.OSProfile.WindowsConfiguration.AdditionalUnattendContent[0].PassName <-||- ;
     -||-> Assert-AreEqual $aucSetting $p.OSProfile.WindowsConfiguration.AdditionalUnattendContent[0].SettingName <-||- ;
    
     -||-> Assert-AreEqual $aucContent $p.OSProfile.WindowsConfiguration.AdditionalUnattendContent[1].Content <-||- ;
     -||-> Assert-AreEqual "oobeSystem" $p.OSProfile.WindowsConfiguration.AdditionalUnattendContent[1].PassName <-||- ;
     -||-> Assert-AreEqual $aucSetting $p.OSProfile.WindowsConfiguration.AdditionalUnattendContent[1].SettingName <-||- ;

    
     -||-> $img = "b4590d9e3ed742e4a1d46e5424aa335e__SUSE-Linux-Enterprise-Server-11-SP3-v206" <-||- ;

     -||-> $p =  -||-> Set-AzVMOperatingSystem -VM $p -Linux -ComputerName $computerName -Credential $cred -CustomData $custom -DisablePasswordAuthentication <-||-  <-||- ;

     -||-> $imgRef =  -||-> Get-DefaultCRPLinuxImageOffline -loc $loc <-||-  <-||- ;
     -||-> $p = ( -||-> $imgRef | Set-AzVMSourceImage -VM $p <-||- ) <-||- ;

     -||-> $sshPath = "/home/pstestuser/.ssh/authorized_keys" <-||- ;
     -||-> $sshPublicKey = "MIIDszCCApugAwIBAgIJALBV9YJCF/tAMA0GCSqGSIb3DQEBBQUAMEUxCzAJBgNV" <-||- ;
     -||-> $p =  -||-> Add-AzVMSshPublicKey -VM $p -KeyData $sshPublicKey -Path $sshPath <-||-  <-||- ;
     -||-> $p =  -||-> Add-AzVMSshPublicKey -VM $p -KeyData $sshPublicKey -Path $sshPath <-||-  <-||- ;
     -||-> $p =  -||-> Add-AzVMSecret -VM $p -SourceVaultId $referenceUri -CertificateStore $certStore -CertificateUrl $certUrl <-||-  <-||- ;

     -||-> Assert-AreEqual $p.OSProfile.AdminUsername $user <-||- ;
     -||-> Assert-AreEqual $p.OSProfile.ComputerName $computerName <-||- ;
     -||-> Assert-AreEqual $p.OSProfile.AdminPassword $password <-||- ;

     -||-> Assert-AreEqual $p.StorageProfile.ImageReference.Offer $imgRef.Offer <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.ImageReference.Publisher $imgRef.PublisherName <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.ImageReference.Sku $imgRef.Skus <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.ImageReference.Version $imgRef.Version <-||- ;

     -||-> Assert-AreEqual $p.OSProfile.Secrets[0].SourceVault.Id $referenceUri <-||- ;
     -||-> Assert-AreEqual $p.OSProfile.Secrets[0].VaultCertificates[0].CertificateStore $certStore <-||- ;
     -||-> Assert-AreEqual $p.OSProfile.Secrets[0].VaultCertificates[0].CertificateUrl $certUrl <-||- ;
     -||-> Assert-AreEqual $encodedCustom $p.OSProfile.CustomData <-||- ;

    
     -||-> Assert-AreEqual $sshPublicKey $p.OSProfile.LinuxConfiguration.Ssh.PublicKeys[0].KeyData <-||- ;
     -||-> Assert-AreEqual $sshPath $p.OSProfile.LinuxConfiguration.Ssh.PublicKeys[0].Path <-||- ;
     -||-> Assert-AreEqual $sshPublicKey $p.OSProfile.LinuxConfiguration.Ssh.PublicKeys[1].KeyData <-||- ;
     -||-> Assert-AreEqual $sshPath $p.OSProfile.LinuxConfiguration.Ssh.PublicKeys[1].Path <-||- ;
     -||-> Assert-AreEqual $true $p.OSProfile.LinuxConfiguration.DisablePasswordAuthentication <-||- ;

    
     -||-> Assert-Null $p.AdditionalCapabilities <-||- ;
} <-||- 


 -||-> function Test-VirtualMachineProfileWithoutAUC
{
    
     -||-> $vmsize = 'Standard_A2' <-||- ;
     -||-> $vmname = 'pstestvm' + ( -||-> ( -||-> Get-Random <-||- ) % 10000 <-||- ) <-||- ;
     -||-> $p =  -||-> New-AzVMConfig -VMName $vmname -VMSize $vmsize -EnableUltraSSD <-||-  <-||- ;
     -||-> Assert-AreEqual $p.HardwareProfile.VmSize $vmsize <-||- ;
     -||-> Assert-True {  -||-> $p.AdditionalCapabilities.UltraSSDEnabled <-||-  } <-||- ;

    
     -||-> $ipname = 'hpfip' + ( -||-> ( -||-> Get-Random <-||- ) % 10000 <-||- ) <-||- ;
     -||-> $ipRefUri = "https://test.foo.bar/$ipname" <-||- ;
     -||-> $nicName = $ipname + 'nic1' <-||- ;
     -||-> $publicIPName = $ipname + 'name1' <-||- ;

     -||-> $p =  -||-> Add-AzVMNetworkInterface -VM $p -Id $ipRefUri <-||-  <-||- ;

     -||-> Assert-AreEqual $p.NetworkProfile.NetworkInterfaces.Count 1 <-||- ;
     -||-> Assert-AreEqual $p.NetworkProfile.NetworkInterfaces[0].Id $ipRefUri <-||- ;

    
     -||-> $stoname = 'hpfteststo' + ( -||-> ( -||-> Get-Random <-||- ) % 10000 <-||- ) <-||- ;
     -||-> $stotype = 'Standard_GRS' <-||- ;

     -||-> $osDiskName = 'osDisk' <-||- ;
     -||-> $osDiskCaching = 'ReadWrite' <-||- ;
     -||-> $osDiskVhdUri = "https://$stoname.blob.core.windows.net/test/os.vhd" <-||- ;
     -||-> $dataDiskVhdUri1 = "https://$stoname.blob.core.windows.net/test/data1.vhd" <-||- ;
     -||-> $dataDiskVhdUri2 = "https://$stoname.blob.core.windows.net/test/data2.vhd" <-||- ;
     -||-> $dataDiskVhdUri3 = "https://$stoname.blob.core.windows.net/test/data3.vhd" <-||- ;

     -||-> $dekUri = "https://testvault123.vault.azure.net/secrets/Test1/514ceb769c984379a7e0230bddaaaaaa" <-||- ;
     -||-> $dekId =  "/subscriptions/" + $subid + "/resourceGroups/RgTest1/providers/Microsoft.KeyVault/vaults/TestVault123" <-||- ;
     -||-> $kekUri = "http://keyVaultName.vault.azure.net/secrets/secretName/secretVersion" <-||- ;
     -||-> $kekId = "/subscriptions/" + $subid + "/resourceGroups/RgTest1/providers/Microsoft.KeyVault/vaults/TestVault123" <-||- ;

     -||-> $p =  -||-> Set-AzVMOSDisk -VM $p -Windows -Name $osDiskName -VhdUri $osDiskVhdUri -Caching $osDiskCaching -CreateOption Empty -DiskEncryptionKeyUrl $dekUri -DiskEncryptionKeyVaultId $dekId -KeyEncryptionKeyUrl $kekUri -KeyEncryptionKeyVaultId $kekId <-||-  <-||- ;

     -||-> $p =  -||-> Add-AzVMDataDisk -VM $p -Name 'testDataDisk1' -Caching 'ReadOnly' -DiskSizeInGB 10 -Lun 0 -VhdUri $dataDiskVhdUri1 -CreateOption Empty <-||-  <-||- ;
     -||-> $p =  -||-> Add-AzVMDataDisk -VM $p -Name 'testDataDisk2' -Caching 'ReadOnly' -DiskSizeInGB 11 -Lun 1 -VhdUri $dataDiskVhdUri2 -CreateOption Empty <-||-  <-||- ;
     -||-> $p =  -||-> Add-AzVMDataDisk -VM $p -Name 'testDataDisk3' -Caching 'ReadOnly' -DiskSizeInGB 12 -Lun 2 -VhdUri $dataDiskVhdUri3 -CreateOption Empty <-||-  <-||- ;
     -||-> $p =  -||-> Remove-AzVMDataDisk -VM $p -Name 'testDataDisk3' <-||-  <-||- ;

     -||-> Assert-AreEqual $p.StorageProfile.OSDisk.EncryptionSettings.DiskEncryptionKey.SourceVault.Id $dekId <-||- 
     -||-> Assert-AreEqual $p.StorageProfile.OSDisk.EncryptionSettings.DiskEncryptionKey.SecretUrl $dekUri <-||- 
     -||-> Assert-AreEqual $p.StorageProfile.OSDisk.EncryptionSettings.KeyEncryptionKey.SourceVault.Id $kekId <-||- 
     -||-> Assert-AreEqual $p.StorageProfile.OSDisk.EncryptionSettings.KeyEncryptionKey.KeyUrl $kekUri <-||- 
     -||-> Assert-AreEqual $p.StorageProfile.OSDisk.Caching $osDiskCaching <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.OSDisk.Name $osDiskName <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.OSDisk.Vhd.Uri $osDiskVhdUri <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.DataDisks.Count 2 <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.DataDisks[0].Caching 'ReadOnly' <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.DataDisks[0].DiskSizeGB 10 <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.DataDisks[0].Lun 0 <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.DataDisks[0].Vhd.Uri $dataDiskVhdUri1 <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.DataDisks[1].Caching 'ReadOnly' <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.DataDisks[1].DiskSizeGB 11 <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.DataDisks[1].Lun 1 <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.DataDisks[1].Vhd.Uri $dataDiskVhdUri2 <-||- ;

    
     -||-> $user = "Foo12" <-||- ;
     -||-> $password = $PLACEHOLDER <-||- ;
     -||-> $securePassword =  -||-> ConvertTo-SecureString $password -AsPlainText -Force <-||-  <-||- ;
     -||-> $cred =  -||-> New-Object System.Management.Automation.PSCredential ( -||-> $user, $securePassword <-||- ) <-||-  <-||- ;
     -||-> $computerName = 'test' <-||- ;
     -||-> $vhdContainer = "https://$stoname.blob.core.windows.net/test" <-||- ;
     -||-> $img = 'a699494373c04fc0bc8f2bb1389d6106__Windows-Server-2012-Datacenter-201503.01-en.us-127GB.vhd' <-||- ;

     -||-> $winRMCertUrl = "http://keyVaultName.vault.azure.net/secrets/secretName/secretVersion" <-||- ;
     -||-> $timeZone = "Pacific Standard Time" <-||- ;
     -||-> $custom = "echo 'Hello World'" <-||- ;
     -||-> $encodedCustom = "ZWNobyAnSGVsbG8gV29ybGQn" <-||- ;

     -||-> $p =  -||-> Set-AzVMOperatingSystem -VM $p -Windows -ComputerName $computerName -Credential $cred -CustomData $custom -WinRMHttp -WinRMHttps -WinRMCertificateUrl $winRMCertUrl -ProvisionVMAgent -EnableAutoUpdate -TimeZone $timeZone <-||-  <-||- ;

     -||-> $imgRef =  -||-> Get-DefaultCRPWindowsImageOffline -loc $loc <-||-  <-||- ;
     -||-> $p = ( -||-> $imgRef | Set-AzVMSourceImage -VM $p <-||- ) <-||- ;

     -||-> $subid = ( -||-> Get-AzContext <-||- ).Subscription.SubscriptionId <-||- ;

     -||-> $referenceUri = "/subscriptions/" + $subid + "/resourceGroups/RgTest1/providers/Microsoft.KeyVault/vaults/TestVault123" <-||- ;
     -||-> $certStore = "My" <-||- ;
     -||-> $certUrl =  "https://testvault123.vault.azure.net/secrets/Test1/514ceb769c984Assert-True379a7e0230bdd703272" <-||- ;
     -||-> $p =  -||-> Add-AzVMSecret -VM $p -SourceVaultId $referenceUri -CertificateStore $certStore -CertificateUrl $certUrl <-||-  <-||- ;

     -||-> $referenceUri2 = "/subscriptions/" + $subid + "/resourceGroups/RgTest1/providers/Microsoft.KeyVault/vaults/TestVault456" <-||- ;
     -||-> $p =  -||-> Add-AzVMSecret -VM $p -SourceVaultId $referenceUri2 -CertificateStore $certStore -CertificateUrl $certUrl <-||-  <-||- ;

     -||-> $certStore2 = "My2" <-||- ;
     -||-> $certUrl2 =  "https://testvault123.vault.azure.net/secrets/Test1/514ceb769c984379a7e0230bddaaaaaa" <-||- ;
     -||-> $p =  -||-> Add-AzVMSecret -VM $p -SourceVaultId $referenceUri -CertificateStore $certStore2 -CertificateUrl $certUrl2 <-||-  <-||- ;

     -||-> Assert-AreEqual $p.OSProfile.AdminUsername $user <-||- ;
     -||-> Assert-AreEqual $p.OSProfile.ComputerName $computerName <-||- ;
     -||-> Assert-AreEqual $p.OSProfile.AdminPassword $password <-||- ;

     -||-> Assert-AreEqual $p.StorageProfile.ImageReference.Offer $imgRef.Offer <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.ImageReference.Publisher $imgRef.PublisherName <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.ImageReference.Sku $imgRef.Skus <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.ImageReference.Version $imgRef.Version <-||- ;

     -||-> Assert-AreEqual $p.OSProfile.Secrets[0].SourceVault.Id $referenceUri <-||- ;
     -||-> Assert-AreEqual $p.OSProfile.Secrets[0].VaultCertificates[0].CertificateStore $certStore <-||- ;
     -||-> Assert-AreEqual $p.OSProfile.Secrets[0].VaultCertificates[0].CertificateUrl $certUrl <-||- ;
     -||-> Assert-AreEqual $p.OSProfile.Secrets[0].SourceVault.Id $referenceUri <-||- ;
     -||-> Assert-AreEqual $p.OSProfile.Secrets[0].VaultCertificates[1].CertificateStore $certStore2 <-||- ;
     -||-> Assert-AreEqual $p.OSProfile.Secrets[0].VaultCertificates[1].CertificateUrl $certUrl2 <-||- ;
     -||-> Assert-AreEqual $p.OSProfile.Secrets[1].SourceVault.Id $referenceUri2 <-||- ;
     -||-> Assert-AreEqual $p.OSProfile.Secrets[1].VaultCertificates[0].CertificateStore $certStore <-||- ;
     -||-> Assert-AreEqual $p.OSProfile.Secrets[1].VaultCertificates[0].CertificateUrl $certUrl <-||- ;
     -||-> Assert-AreEqual $encodedCustom $p.OSProfile.CustomData <-||- ;

    
     -||-> Assert-Null $p.OSProfile.WindowsConfiguration.WinRM.Listeners[0].CertificateUrl <-||- ;
     -||-> Assert-AreEqual "http" $p.OSProfile.WindowsConfiguration.WinRM.Listeners[0].Protocol <-||-  ;
     -||-> Assert-AreEqual $winRMCertUrl $p.OSProfile.WindowsConfiguration.WinRM.Listeners[1].CertificateUrl <-||-  ;
     -||-> Assert-AreEqual "https" $p.OSProfile.WindowsConfiguration.WinRM.Listeners[1].Protocol <-||-  ;

    
     -||-> Assert-AreEqual $true $p.OSProfile.WindowsConfiguration.ProvisionVMAgent <-||- ;
     -||-> Assert-AreEqual $true $p.OSProfile.WindowsConfiguration.EnableAutomaticUpdates <-||- ;
     -||-> Assert-AreEqual $timeZone $p.OSProfile.WindowsConfiguration.TimeZone <-||- ;

    
     -||-> Assert-Null $p.OSProfile.WindowsConfiguration.AdditionalUnattendContent "NULL" <-||- ;
     -||-> Assert-False { -||-> $p.OSProfile.WindowsConfiguration.AdditionalUnattendContent.IsInitialized <-||- } <-||- ;

     -||-> $p.OSProfile = $null <-||- ;
     -||-> $p =  -||-> Set-AzVMOperatingSystem -VM $p -Windows -ComputerName $computerName -Credential $cred <-||-  <-||- ;
     -||-> Assert-Null $p.OSProfile.WindowsConfiguration.ProvisionVMAgent <-||- ;

     -||-> $p.OSProfile = $null <-||- ;
     -||-> $p =  -||-> Set-AzVMOperatingSystem -VM $p -Windows -ComputerName $computerName -Credential $cred -DisableVMAgent <-||-  <-||- ;
     -||-> Assert-False { -||-> $p.OSProfile.WindowsConfiguration.ProvisionVMAgent <-||- } <-||- ;

} <-||- 


