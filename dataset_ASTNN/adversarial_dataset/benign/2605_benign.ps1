














 -||-> function Test-SingleNetworkInterface
{
    
     -||-> $rgname =  -||-> Get-ComputeTestResourceName <-||-  <-||- 

     -||-> try
    {
        
         -||-> $loc =  -||-> Get-ComputeVMLocation <-||-  <-||- ;
         -||-> New-AzureRmResourceGroup -Name $rgname -Location $loc -Force <-||- ;
        
        
         -||-> $vmsize = 'Standard_A2' <-||- ;
         -||-> $vmname = 'vm' + $rgname <-||- ;
         -||-> $p =  -||-> New-AzureRmVMConfig -VMName $vmname -VMSize $vmsize <-||-  <-||- ;
         -||-> Assert-AreEqual $p.HardwareProfile.VmSize $vmsize <-||- ;

        
         -||-> $subnet =  -||-> New-AzureRmVirtualNetworkSubnetConfig -Name ( -||-> 'subnet' + $rgname <-||- ) -AddressPrefix "10.0.0.0/24" <-||-  <-||- ;
         -||-> $vnet =  -||-> New-AzureRmVirtualNetwork -Force -Name ( -||-> 'vnet' + $rgname <-||- ) -ResourceGroupName $rgname -Location $loc -AddressPrefix "10.0.0.0/16" -Subnet $subnet <-||-  <-||- ;
         -||-> $vnet =  -||-> Get-AzureRmVirtualNetwork -Name ( -||-> 'vnet' + $rgname <-||- ) -ResourceGroupName $rgname <-||-  <-||- ;
         -||-> $subnetId = $vnet.Subnets[0].Id <-||- ;
         -||-> $pubip =  -||-> New-AzureRmPublicIpAddress -Force -Name ( -||-> 'pubip' + $rgname <-||- ) -ResourceGroupName $rgname -Location $loc -AllocationMethod Dynamic -DomainNameLabel ( -||-> 'pubip' + $rgname <-||- ) <-||-  <-||- ;
         -||-> $pubip =  -||-> Get-AzureRmPublicIpAddress -Name ( -||-> 'pubip' + $rgname <-||- ) -ResourceGroupName $rgname <-||-  <-||- ;
         -||-> $pubipId = $pubip.Id <-||- ;
         -||-> $nic =  -||-> New-AzureRmNetworkInterface -Force -Name ( -||-> 'nic' + $rgname <-||- ) -ResourceGroupName $rgname -Location $loc -SubnetId $subnetId -PublicIpAddressId $pubip.Id <-||-  <-||- ;
         -||-> $nic =  -||-> Get-AzureRmNetworkInterface -Name ( -||-> 'nic' + $rgname <-||- ) -ResourceGroupName $rgname <-||-  <-||- ;
         -||-> $nicId = $nic.Id <-||- ;

         -||-> $p =  -||-> Add-AzureRmVMNetworkInterface -VM $p -Id $nicId <-||-  <-||- ;
         -||-> Assert-AreEqual $p.NetworkProfile.NetworkInterfaces.Count 1 <-||- ;
         -||-> Assert-AreEqual $p.NetworkProfile.NetworkInterfaces[0].Id $nicId <-||- ;
         -||-> Assert-Null $p.NetworkProfile.NetworkInterfaces[0].Primary <-||- ;

        
         -||-> $stoname = 'sto' + $rgname <-||- ;
         -||-> $stotype = 'Standard_GRS' <-||- ;
         -||-> New-AzureRmStorageAccount -ResourceGroupName $rgname -Name $stoname -Location $loc -Type $stotype <-||- ;
         -||-> $stoaccount =  -||-> Get-AzureRmStorageAccount -ResourceGroupName $rgname -Name $stoname <-||-  <-||- ;

         -||-> $osDiskName = 'osDisk' <-||- ;
         -||-> $osDiskCaching = 'ReadWrite' <-||- ;
         -||-> $osDiskVhdUri = "https://$stoname.blob.core.windows.net/test/os.vhd" <-||- ;
         -||-> $dataDiskVhdUri1 = "https://$stoname.blob.core.windows.net/test/data1.vhd" <-||- ;
         -||-> $dataDiskVhdUri2 = "https://$stoname.blob.core.windows.net/test/data2.vhd" <-||- ;
         -||-> $dataDiskVhdUri3 = "https://$stoname.blob.core.windows.net/test/data3.vhd" <-||- ;

         -||-> $p =  -||-> Set-AzureRmVMOSDisk -VM $p -Name $osDiskName -VhdUri $osDiskVhdUri -Caching $osDiskCaching -CreateOption FromImage <-||-  <-||- ;

         -||-> $p =  -||-> Add-AzureRmVMDataDisk -VM $p -Name 'testDataDisk1' -Caching 'ReadOnly' -DiskSizeInGB 10 -Lun 1 -VhdUri $dataDiskVhdUri1 -CreateOption Empty <-||-  <-||- ;
         -||-> $p =  -||-> Add-AzureRmVMDataDisk -VM $p -Name 'testDataDisk2' -Caching 'ReadOnly' -DiskSizeInGB 11 -Lun 2 -VhdUri $dataDiskVhdUri2 -CreateOption Empty <-||-  <-||- ;
         -||-> $p =  -||-> Add-AzureRmVMDataDisk -VM $p -Name 'testDataDisk3' -Caching 'ReadOnly' -DiskSizeInGB 12 -Lun 3 -VhdUri $dataDiskVhdUri3 -CreateOption Empty <-||-  <-||- ;
         -||-> $p =  -||-> Remove-AzureRmVMDataDisk -VM $p -Name 'testDataDisk3' <-||-  <-||- ;
        
         -||-> Assert-AreEqual $p.StorageProfile.OSDisk.Caching $osDiskCaching <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.OSDisk.Name $osDiskName <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.OSDisk.Vhd.Uri $osDiskVhdUri <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.DataDisks.Count 2 <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.DataDisks[0].Caching 'ReadOnly' <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.DataDisks[0].DiskSizeGB 10 <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.DataDisks[0].Lun 1 <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.DataDisks[0].Vhd.Uri $dataDiskVhdUri1 <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.DataDisks[1].Caching 'ReadOnly' <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.DataDisks[1].DiskSizeGB 11 <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.DataDisks[1].Lun 2 <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.DataDisks[1].Vhd.Uri $dataDiskVhdUri2 <-||- ;

        
         -||-> $user = "Foo12" <-||- ;
         -||-> $password = $PLACEHOLDER <-||- ;
         -||-> $securePassword =  -||-> ConvertTo-SecureString $password -AsPlainText -Force <-||-  <-||- ;
         -||-> $cred =  -||-> New-Object System.Management.Automation.PSCredential ( -||-> $user, $securePassword <-||- ) <-||-  <-||- ;
         -||-> $computerName = 'test' <-||- ;
         -||-> $vhdContainer = "https://$stoname.blob.core.windows.net/test" <-||- ;
         -||-> $img = 'a699494373c04fc0bc8f2bb1389d6106__Windows-Server-2012-Datacenter-201503.01-en.us-127GB.vhd' <-||- ;

        
         -||-> $p =  -||-> Set-AzureRmVMOperatingSystem -VM $p -Windows -ComputerName $computerName -Credential $cred <-||-  <-||- ;

         -||-> Assert-AreEqual $p.OSProfile.AdminUsername $user <-||- ;
         -||-> Assert-AreEqual $p.OSProfile.ComputerName $computerName <-||- ;
         -||-> Assert-AreEqual $p.OSProfile.AdminPassword $password <-||- ;

        
         -||-> $imgRef =  -||-> Get-DefaultCRPImage <-||-  <-||- ;
         -||-> $p = ( -||-> $imgRef | Set-AzureRmVMSourceImage -VM $p <-||- ) <-||- ;
         -||-> Assert-NotNull $p.StorageProfile.ImageReference <-||- ;
         -||-> Assert-Null $p.StorageProfile.SourceImageId <-||- ;

        
         -||-> $p.StorageProfile.DataDisks = $null <-||- ;

        
        
         -||-> New-AzureRmVM -ResourceGroupName $rgname -Location $loc -VM $p <-||- ;

        
         -||-> $vm1 =  -||-> Get-AzureRmVM -Name $vmname -ResourceGroupName $rgname <-||-  <-||- ;
         -||-> Assert-AreEqual $vm1.Name $vmname <-||- ;
         -||-> Assert-AreEqual $vm1.NetworkProfile.NetworkInterfaces.Count 1 <-||- ;
         -||-> Assert-AreEqual $vm1.NetworkProfile.NetworkInterfaces[0].Id $nicId <-||- ;

        
         -||-> $getnic =  -||-> Get-AzureRmNetworkInterface -Name ( -||-> 'nic' + $rgname <-||- ) -ResourceGroupName $rgname <-||-  <-||- ;
         -||-> Assert-AreEqual $vm1.NetworkProfile.NetworkInterfaces[0].Id $getnic.Id <-||- ;
         -||-> Assert-AreEqual $getnic.Primary true <-||- ;
         -||-> Assert-NotNull $getnic.MacAddress <-||- ;

        
         -||-> Remove-AzureRmVM -Name $vmname -ResourceGroupName $rgname -Force <-||- ;
    }
    finally
    {
        
         -||-> Clean-ResourceGroup $rgname <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-SingleNetworkInterfaceDnsSettings
{
    
     -||-> $rgname =  -||-> Get-ComputeTestResourceName <-||-  <-||- 

     -||-> try
    {
        
         -||-> $loc =  -||-> Get-ComputeVMLocation <-||-  <-||- ;
         -||-> New-AzureRmResourceGroup -Name $rgname -Location $loc -Force <-||- ;
        
        
         -||-> $vmsize = 'Standard_A2' <-||- ;
         -||-> $vmname = 'vm' + $rgname <-||- ;
         -||-> $p =  -||-> New-AzureRmVMConfig -VMName $vmname -VMSize $vmsize <-||-  <-||- ;
         -||-> Assert-AreEqual $p.HardwareProfile.VmSize $vmsize <-||- ;

        
         -||-> $subnet =  -||-> New-AzureRmVirtualNetworkSubnetConfig -Name ( -||-> 'subnet' + $rgname <-||- ) -AddressPrefix "10.0.0.0/24" <-||-  <-||- ;
         -||-> $vnet =  -||-> New-AzureRmVirtualNetwork -Force -Name ( -||-> 'vnet' + $rgname <-||- ) -ResourceGroupName $rgname -Location $loc -AddressPrefix "10.0.0.0/16" -Subnet $subnet <-||-  <-||- ;
         -||-> $vnet =  -||-> Get-AzureRmVirtualNetwork -Name ( -||-> 'vnet' + $rgname <-||- ) -ResourceGroupName $rgname <-||-  <-||- ;
         -||-> $subnetId = $vnet.Subnets[0].Id <-||- ;
         -||-> $pubip =  -||-> New-AzureRmPublicIpAddress -Force -Name ( -||-> 'pubip' + $rgname <-||- ) -ResourceGroupName $rgname -Location $loc -AllocationMethod Dynamic -DomainNameLabel ( -||-> 'pubip' + $rgname <-||- ) <-||-  <-||- ;
         -||-> $pubip =  -||-> Get-AzureRmPublicIpAddress -Name ( -||-> 'pubip' + $rgname <-||- ) -ResourceGroupName $rgname <-||-  <-||- ;
         -||-> $pubipId = $pubip.Id <-||- ;
         -||-> $nic =  -||-> New-AzureRmNetworkInterface -Force -Name ( -||-> 'nic' + $rgname <-||- ) -ResourceGroupName $rgname -Location $loc -SubnetId $subnetId -PublicIpAddressId $pubip.Id -DnsServer "8.8.8.8" <-||-  <-||- ;
         -||-> $nic =  -||-> Get-AzureRmNetworkInterface -Name ( -||-> 'nic' + $rgname <-||- ) -ResourceGroupName $rgname <-||-  <-||- ;
         -||-> $nicId = $nic.Id <-||- ;

         -||-> $p =  -||-> Add-AzureRmVMNetworkInterface -VM $p -Id $nicId <-||-  <-||- ;
         -||-> Assert-AreEqual $p.NetworkProfile.NetworkInterfaces.Count 1 <-||- ;
         -||-> Assert-AreEqual $p.NetworkProfile.NetworkInterfaces[0].Id $nicId <-||- ;
         -||-> Assert-Null $p.NetworkProfile.NetworkInterfaces[0].Primary <-||- ;

        
         -||-> $stoname = 'sto' + $rgname <-||- ;
         -||-> $stotype = 'Standard_GRS' <-||- ;
         -||-> New-AzureRmStorageAccount -ResourceGroupName $rgname -Name $stoname -Location $loc -Type $stotype <-||- ;
         -||-> $stoaccount =  -||-> Get-AzureRmStorageAccount -ResourceGroupName $rgname -Name $stoname <-||-  <-||- ;

         -||-> $osDiskName = 'osDisk' <-||- ;
         -||-> $osDiskCaching = 'ReadWrite' <-||- ;
         -||-> $osDiskVhdUri = "https://$stoname.blob.core.windows.net/test/os.vhd" <-||- ;
         -||-> $dataDiskVhdUri1 = "https://$stoname.blob.core.windows.net/test/data1.vhd" <-||- ;
         -||-> $dataDiskVhdUri2 = "https://$stoname.blob.core.windows.net/test/data2.vhd" <-||- ;
         -||-> $dataDiskVhdUri3 = "https://$stoname.blob.core.windows.net/test/data3.vhd" <-||- ;

         -||-> $p =  -||-> Set-AzureRmVMOSDisk -VM $p -Name $osDiskName -VhdUri $osDiskVhdUri -Caching $osDiskCaching -CreateOption FromImage <-||-  <-||- ;

         -||-> $p =  -||-> Add-AzureRmVMDataDisk -VM $p -Name 'testDataDisk1' -Caching 'ReadOnly' -DiskSizeInGB 10 -Lun 1 -VhdUri $dataDiskVhdUri1 -CreateOption Empty <-||-  <-||- ;
         -||-> $p =  -||-> Add-AzureRmVMDataDisk -VM $p -Name 'testDataDisk2' -Caching 'ReadOnly' -DiskSizeInGB 11 -Lun 2 -VhdUri $dataDiskVhdUri2 -CreateOption Empty <-||-  <-||- ;
         -||-> $p =  -||-> Add-AzureRmVMDataDisk -VM $p -Name 'testDataDisk3' -Caching 'ReadOnly' -DiskSizeInGB 12 -Lun 3 -VhdUri $dataDiskVhdUri3 -CreateOption Empty <-||-  <-||- ;
         -||-> $p =  -||-> Remove-AzureRmVMDataDisk -VM $p -Name 'testDataDisk3' <-||-  <-||- ;
        
        
         -||-> $user = "Foo12" <-||- ;
         -||-> $password = $PLACEHOLDER <-||- ;
         -||-> $securePassword =  -||-> ConvertTo-SecureString $password -AsPlainText -Force <-||-  <-||- ;
         -||-> $cred =  -||-> New-Object System.Management.Automation.PSCredential ( -||-> $user, $securePassword <-||- ) <-||-  <-||- ;
         -||-> $computerName = 'test' <-||- ;
         -||-> $vhdContainer = "https://$stoname.blob.core.windows.net/test" <-||- ;
         -||-> $img = 'a699494373c04fc0bc8f2bb1389d6106__Windows-Server-2012-Datacenter-201503.01-en.us-127GB.vhd' <-||- ;

        
         -||-> $p =  -||-> Set-AzureRmVMOperatingSystem -VM $p -Windows -ComputerName $computerName -Credential $cred <-||-  <-||- ;

        
         -||-> $imgRef =  -||-> Get-DefaultCRPImage <-||-  <-||- ;
         -||-> $p = ( -||-> $imgRef | Set-AzureRmVMSourceImage -VM $p <-||- ) <-||- ;
         -||-> Assert-NotNull $p.StorageProfile.ImageReference <-||- ;
         -||-> Assert-Null $p.StorageProfile.SourceImageId <-||- ;

        
         -||-> $p.StorageProfile.DataDisks = $null <-||- ;

        
        
         -||-> New-AzureRmVM -ResourceGroupName $rgname -Location $loc -VM $p <-||- ;

        
         -||-> $vm1 =  -||-> Get-AzureRmVM -Name $vmname -ResourceGroupName $rgname <-||-  <-||- ;
         -||-> Assert-AreEqual $vm1.Name $vmname <-||- ;
         -||-> Assert-AreEqual $vm1.NetworkProfile.NetworkInterfaces.Count 1 <-||- ;
         -||-> Assert-AreEqual $vm1.NetworkProfile.NetworkInterfaces[0].Id $nicId <-||- ;

        
         -||-> $getnic =  -||-> Get-AzureRmNetworkInterface -Name ( -||-> 'nic' + $rgname <-||- ) -ResourceGroupName $rgname <-||-  <-||- ;
         -||-> Assert-AreEqual $vm1.NetworkProfile.NetworkInterfaces[0].Id $getnic.Id <-||- ;
         -||-> Assert-AreEqual $getnic.Primary true <-||- ;
         -||-> Assert-NotNull $getnic.MacAddress <-||- ;
         -||-> Assert-NotNull $getnic.DnsSettings.AppliedDnsServers <-||- ;

        
         -||-> Remove-AzureRmVM -Name $vmname -ResourceGroupName $rgname -Force <-||- ;
    }
    finally
    {
        
         -||-> Clean-ResourceGroup $rgname <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-MultipleNetworkInterface
{
    
     -||-> $rgname =  -||-> Get-ComputeTestResourceName <-||-  <-||- 

     -||-> try
    {
        
         -||-> $loc =  -||-> Get-ComputeVMLocation <-||-  <-||- ;
         -||-> New-AzureRmResourceGroup -Name $rgname -Location $loc -Force <-||- ;
        
        
         -||-> $vmsize = 'Standard_A4' <-||- ;
         -||-> $vmname = 'vm' + $rgname <-||- ;
         -||-> $p =  -||-> New-AzureRmVMConfig -VMName $vmname -VMSize $vmsize <-||-  <-||- ;
         -||-> Assert-AreEqual $p.HardwareProfile.VmSize $vmsize <-||- ;

        
         -||-> $subnet =  -||-> New-AzureRmVirtualNetworkSubnetConfig -Name ( -||-> 'subnet' + $rgname <-||- ) -AddressPrefix "10.0.0.0/24" <-||-  <-||- ;
         -||-> $vnet =  -||-> New-AzureRmVirtualNetwork -Force -Name ( -||-> 'vnet' + $rgname <-||- ) -ResourceGroupName $rgname -Location $loc -AddressPrefix "10.0.0.0/16" -Subnet $subnet <-||-  <-||- ;
         -||-> $vnet =  -||-> Get-AzureRmVirtualNetwork -Name ( -||-> 'vnet' + $rgname <-||- ) -ResourceGroupName $rgname <-||-  <-||- ;
         -||-> $subnetId = $vnet.Subnets[0].Id <-||- ;
         -||-> $nic1 =  -||-> New-AzureRmNetworkInterface -Force -Name ( -||-> 'nic1' + $rgname <-||- ) -ResourceGroupName $rgname -Location $loc -SubnetId $subnetId <-||-  <-||- ;
         -||-> $nic2 =  -||-> New-AzureRmNetworkInterface -Force -Name ( -||-> 'nic2' + $rgname <-||- ) -ResourceGroupName $rgname -Location $loc -SubnetId $subnetId <-||-  <-||- ;
        
         -||-> $p =  -||-> Add-AzureRmVMNetworkInterface -VM $p -Id $nic1.Id <-||-  <-||- ;
         -||-> Assert-AreEqual $p.NetworkProfile.NetworkInterfaces.Count 1 <-||- ;
         -||-> Assert-AreEqual $p.NetworkProfile.NetworkInterfaces[0].Id $nic1.Id <-||- ;
         -||-> Assert-Null $p.NetworkProfile.NetworkInterfaces[0].Primary <-||- ;
        
         -||-> $p =  -||-> Add-AzureRmVMNetworkInterface -VM $p -Id $nic2.Id -Primary <-||-  <-||- ;
         -||-> Assert-AreEqual $p.NetworkProfile.NetworkInterfaces.Count 2 <-||- ;
         -||-> Assert-AreEqual $p.NetworkProfile.NetworkInterfaces[1].Id $nic2.Id <-||- ;

         -||-> Assert-AreEqual $p.NetworkProfile.NetworkInterfaces[1].Primary true <-||- ;
         -||-> Assert-AreNotEqual $p.NetworkProfile.NetworkInterfaces[0].Primary true <-||- ;

        
         -||-> $stoname = 'sto' + $rgname <-||- ;
         -||-> $stotype = 'Standard_GRS' <-||- ;
         -||-> New-AzureRmStorageAccount -ResourceGroupName $rgname -Name $stoname -Location $loc -Type $stotype <-||- ;
         -||-> $stoaccount =  -||-> Get-AzureRmStorageAccount -ResourceGroupName $rgname -Name $stoname <-||-  <-||- ;

         -||-> $osDiskName = 'osDisk' <-||- ;
         -||-> $osDiskCaching = 'ReadWrite' <-||- ;
         -||-> $osDiskVhdUri = "https://$stoname.blob.core.windows.net/test/os.vhd" <-||- ;
         -||-> $dataDiskVhdUri1 = "https://$stoname.blob.core.windows.net/test/data1.vhd" <-||- ;
         -||-> $dataDiskVhdUri2 = "https://$stoname.blob.core.windows.net/test/data2.vhd" <-||- ;
         -||-> $dataDiskVhdUri3 = "https://$stoname.blob.core.windows.net/test/data3.vhd" <-||- ;

         -||-> $p =  -||-> Set-AzureRmVMOSDisk -VM $p -Name $osDiskName -VhdUri $osDiskVhdUri -Caching $osDiskCaching -CreateOption FromImage <-||-  <-||- ;

         -||-> $p =  -||-> Add-AzureRmVMDataDisk -VM $p -Name 'testDataDisk1' -Caching 'ReadOnly' -DiskSizeInGB 10 -Lun 1 -VhdUri $dataDiskVhdUri1 -CreateOption Empty <-||-  <-||- ;
         -||-> $p =  -||-> Add-AzureRmVMDataDisk -VM $p -Name 'testDataDisk2' -Caching 'ReadOnly' -DiskSizeInGB 11 -Lun 2 -VhdUri $dataDiskVhdUri2 -CreateOption Empty <-||-  <-||- ;
         -||-> $p =  -||-> Add-AzureRmVMDataDisk -VM $p -Name 'testDataDisk3' -Caching 'ReadOnly' -DiskSizeInGB 12 -Lun 3 -VhdUri $dataDiskVhdUri3 -CreateOption Empty <-||-  <-||- ;
         -||-> $p =  -||-> Remove-AzureRmVMDataDisk -VM $p -Name 'testDataDisk3' <-||-  <-||- ;
        
        
         -||-> $user = "Foo12" <-||- ;
         -||-> $password = $PLACEHOLDER <-||- ;
         -||-> $securePassword =  -||-> ConvertTo-SecureString $password -AsPlainText -Force <-||-  <-||- ;
         -||-> $cred =  -||-> New-Object System.Management.Automation.PSCredential ( -||-> $user, $securePassword <-||- ) <-||-  <-||- ;
         -||-> $computerName = 'test' <-||- ;
         -||-> $vhdContainer = "https://$stoname.blob.core.windows.net/test" <-||- ;
         -||-> $img = 'a699494373c04fc0bc8f2bb1389d6106__Windows-Server-2012-Datacenter-201503.01-en.us-127GB.vhd' <-||- ;

        
         -||-> $p =  -||-> Set-AzureRmVMOperatingSystem -VM $p -Windows -ComputerName $computerName -Credential $cred <-||-  <-||- ;

        
         -||-> $imgRef =  -||-> Get-DefaultCRPImage <-||-  <-||- ;
         -||-> $p = ( -||-> $imgRef | Set-AzureRmVMSourceImage -VM $p <-||- ) <-||- ;
         -||-> Assert-NotNull $p.StorageProfile.ImageReference <-||- ;
         -||-> Assert-Null $p.StorageProfile.SourceImageId <-||- ;

        
         -||-> $p.StorageProfile.DataDisks = $null <-||- ;

        
        
         -||-> New-AzureRmVM -ResourceGroupName $rgname -Location $loc -VM $p <-||- ;

        
         -||-> $vm1 =  -||-> Get-AzureRmVM -Name $vmname -ResourceGroupName $rgname <-||-  <-||- ;
         -||-> Assert-AreEqual $vm1.Name $vmname <-||- ;
         -||-> Assert-AreEqual $vm1.NetworkProfile.NetworkInterfaces.Count 2 <-||- ;
         -||-> Assert-AreEqual $vm1.NetworkProfile.NetworkInterfaces[0].Id $nic1.Id <-||- ;
         -||-> Assert-AreEqual $vm1.NetworkProfile.NetworkInterfaces[1].Id $nic2.Id <-||- ;
        
        
         -||-> $getnic1 =  -||-> Get-AzureRmNetworkInterface -Name ( -||-> 'nic1' + $rgname <-||- ) -ResourceGroupName $rgname <-||-  <-||- ;
         -||-> Assert-AreEqual $vm1.NetworkProfile.NetworkInterfaces[0].Id $getnic1.Id <-||- ;
         -||-> Assert-AreNotEqual  $getnic1.Primary true <-||- ;
         -||-> Assert-NotNull $getnic1.MacAddress <-||- ;

         -||-> $getnic2 =  -||-> Get-AzureRmNetworkInterface -Name ( -||-> 'nic2' + $rgname <-||- ) -ResourceGroupName $rgname <-||-  <-||- ;
         -||-> Assert-AreEqual $vm1.NetworkProfile.NetworkInterfaces[1].Id $getnic2.Id <-||- ;
         -||-> Assert-AreEqual $getnic2.Primary true <-||- ;
         -||-> Assert-NotNull $getnic2.MacAddress <-||- ;

        
         -||-> Remove-AzureRmVM -Name $vmname -ResourceGroupName $rgname -Force <-||- ;
    }
    finally
    {
        
         -||-> Clean-ResourceGroup $rgname <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-AddNetworkInterface
{
    
     -||-> $rgname =  -||-> Get-ComputeTestResourceName <-||-  <-||- 

     -||-> try
    {
        
         -||-> $loc =  -||-> Get-ComputeVMLocation <-||-  <-||- ;
         -||-> New-AzureRmResourceGroup -Name $rgname -Location $loc -Force <-||- ;

        
         -||-> $vmsize = 'Standard_A2' <-||- ;
         -||-> $vmname = 'vm' + $rgname <-||- ;
         -||-> $p =  -||-> New-AzureRmVMConfig -VMName $vmname -VMSize $vmsize <-||-  <-||- ;
         -||-> Assert-AreEqual $p.HardwareProfile.VmSize $vmsize <-||- ;

        
         -||-> $subnet =  -||-> New-AzureRmVirtualNetworkSubnetConfig -Name ( -||-> 'subnet' + $rgname <-||- ) -AddressPrefix "10.0.0.0/24" <-||-  <-||- ;
         -||-> $vnet =  -||-> New-AzureRmVirtualNetwork -Force -Name ( -||-> 'vnet' + $rgname <-||- ) -ResourceGroupName $rgname -Location $loc -AddressPrefix "10.0.0.0/16" -Subnet $subnet <-||-  <-||- ;
         -||-> $vnet =  -||-> Get-AzureRmVirtualNetwork -Name ( -||-> 'vnet' + $rgname <-||- ) -ResourceGroupName $rgname <-||-  <-||- ;
         -||-> $subnetId = $vnet.Subnets[0].Id <-||- ;
         -||-> $pubip =  -||-> New-AzureRmPublicIpAddress -Force -Name ( -||-> 'pubip' + $rgname <-||- ) -ResourceGroupName $rgname -Location $loc -AllocationMethod Dynamic -DomainNameLabel ( -||-> 'pubip' + $rgname <-||- ) <-||-  <-||- ;
         -||-> $pubip =  -||-> Get-AzureRmPublicIpAddress -Name ( -||-> 'pubip' + $rgname <-||- ) -ResourceGroupName $rgname <-||-  <-||- ;
         -||-> $pubipId = $pubip.Id <-||- ;
         -||-> $nic =  -||-> New-AzureRmNetworkInterface -Force -Name ( -||-> 'nic' + $rgname <-||- ) -ResourceGroupName $rgname -Location $loc -SubnetId $subnetId -PublicIpAddressId $pubip.Id <-||-  <-||- ;
         -||-> $nicId = $nic.Id <-||- ;

         -||-> $nicList =  -||-> Get-AzureRmNetworkInterface -ResourceGroupName $rgname <-||-  <-||- ;
         -||-> $nicList[0].Primary = $true <-||- ;
         -||-> $p =  -||-> Add-AzureRmVMNetworkInterface -VM $p -NetworkInterface $nicList <-||-  <-||- ;
         -||-> Assert-AreEqual $p.NetworkProfile.NetworkInterfaces.Count 1 <-||- ;
         -||-> Assert-AreEqual $p.NetworkProfile.NetworkInterfaces[0].Id $nicList[0].Id <-||- ;
         -||-> Assert-AreEqual $p.NetworkProfile.NetworkInterfaces[0].Primary $true <-||- ;

        
         -||-> $stoname = 'sto' + $rgname <-||- ;
         -||-> $stotype = 'Standard_GRS' <-||- ;
         -||-> New-AzureRmStorageAccount -ResourceGroupName $rgname -Name $stoname -Location $loc -Type $stotype <-||- ;
         -||-> $stoaccount =  -||-> Get-AzureRmStorageAccount -ResourceGroupName $rgname -Name $stoname <-||-  <-||- ;

         -||-> $osDiskName = 'osDisk' <-||- ;
         -||-> $osDiskCaching = 'ReadWrite' <-||- ;
         -||-> $osDiskVhdUri = "https://$stoname.blob.core.windows.net/test/os.vhd" <-||- ;
         -||-> $dataDiskVhdUri1 = "https://$stoname.blob.core.windows.net/test/data1.vhd" <-||- ;
         -||-> $dataDiskVhdUri2 = "https://$stoname.blob.core.windows.net/test/data2.vhd" <-||- ;
         -||-> $dataDiskVhdUri3 = "https://$stoname.blob.core.windows.net/test/data3.vhd" <-||- ;

         -||-> $p =  -||-> Set-AzureRmVMOSDisk -VM $p -Name $osDiskName -VhdUri $osDiskVhdUri -Caching $osDiskCaching -CreateOption FromImage <-||-  <-||- ;

         -||-> $p =  -||-> Add-AzureRmVMDataDisk -VM $p -Name 'testDataDisk1' -Caching 'ReadOnly' -DiskSizeInGB 10 -Lun 1 -VhdUri $dataDiskVhdUri1 -CreateOption Empty <-||-  <-||- ;
         -||-> $p =  -||-> Add-AzureRmVMDataDisk -VM $p -Name 'testDataDisk2' -Caching 'ReadOnly' -DiskSizeInGB 11 -Lun 2 -VhdUri $dataDiskVhdUri2 -CreateOption Empty <-||-  <-||- ;

         -||-> Assert-AreEqual $p.StorageProfile.OSDisk.Caching $osDiskCaching <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.OSDisk.Name $osDiskName <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.OSDisk.Vhd.Uri $osDiskVhdUri <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.DataDisks.Count 2 <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.DataDisks[0].Caching 'ReadOnly' <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.DataDisks[0].DiskSizeGB 10 <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.DataDisks[0].Lun 1 <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.DataDisks[0].Vhd.Uri $dataDiskVhdUri1 <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.DataDisks[1].Caching 'ReadOnly' <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.DataDisks[1].DiskSizeGB 11 <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.DataDisks[1].Lun 2 <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.DataDisks[1].Vhd.Uri $dataDiskVhdUri2 <-||- ;

        
         -||-> $user = "Foo12" <-||- ;
         -||-> $password = $PLACEHOLDER <-||- ;
         -||-> $securePassword =  -||-> ConvertTo-SecureString $password -AsPlainText -Force <-||-  <-||- ;
         -||-> $cred =  -||-> New-Object System.Management.Automation.PSCredential ( -||-> $user, $securePassword <-||- ) <-||-  <-||- ;
         -||-> $computerName = 'test' <-||- ;
         -||-> $p =  -||-> Set-AzureRmVMOperatingSystem -VM $p -Windows -ComputerName $computerName -Credential $cred <-||-  <-||- ;

         -||-> Assert-AreEqual $p.OSProfile.AdminUsername $user <-||- ;
         -||-> Assert-AreEqual $p.OSProfile.ComputerName $computerName <-||- ;
         -||-> Assert-AreEqual $p.OSProfile.AdminPassword $password <-||- ;

        
         -||-> $imgRef =  -||-> Get-DefaultCRPImage <-||-  <-||- ;
         -||-> $p = ( -||-> $imgRef | Set-AzureRmVMSourceImage -VM $p <-||- ) <-||- ;
         -||-> Assert-NotNull $p.StorageProfile.ImageReference <-||- ;
         -||-> Assert-Null $p.StorageProfile.SourceImageId <-||- ;

        
         -||-> $p.StorageProfile.DataDisks = $null <-||- ;

        
        
         -||-> New-AzureRmVM -ResourceGroupName $rgname -Location $loc -VM $p <-||- ;

         -||-> $vm1 =  -||-> Get-AzureRmVM -Name $vmname -ResourceGroupName $rgname <-||-  <-||- ;
         -||-> Assert-AreEqual $vm1.Name $vmname <-||- ;
         -||-> Assert-AreEqual $vm1.NetworkProfile.NetworkInterfaces.Count 1 <-||- ;
         -||-> Assert-AreEqual $vm1.NetworkProfile.NetworkInterfaces[0].Id $nicId <-||- ;
    }
    finally
    {
        
         -||-> Clean-ResourceGroup $rgname <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-EffectiveRoutesAndNsg
{
    
     -||-> $rgname =  -||-> Get-ComputeTestResourceName <-||-  <-||- 

     -||-> try
    {
        
         -||-> $loc =  -||-> Get-ComputeVMLocation <-||-  <-||- ;
         -||-> New-AzureRmResourceGroup -Name $rgname -Location $loc -Force <-||- ;
        
        
         -||-> $vmsize = 'Standard_A2' <-||- ;
         -||-> $vmname = 'vm' + $rgname <-||- ;
         -||-> $p =  -||-> New-AzureRmVMConfig -VMName $vmname -VMSize $vmsize <-||-  <-||- ;
         -||-> Assert-AreEqual $p.HardwareProfile.VmSize $vmsize <-||- ;

        
         -||-> $subnet =  -||-> New-AzureRmVirtualNetworkSubnetConfig -Name ( -||-> 'subnet' + $rgname <-||- ) -AddressPrefix "10.0.0.0/24" <-||-  <-||- ;
         -||-> $vnet =  -||-> New-AzureRmVirtualNetwork -Force -Name ( -||-> 'vnet' + $rgname <-||- ) -ResourceGroupName $rgname -Location $loc -AddressPrefix "10.0.0.0/16" -Subnet $subnet <-||-  <-||- ;
         -||-> $vnet =  -||-> Get-AzureRmVirtualNetwork -Name ( -||-> 'vnet' + $rgname <-||- ) -ResourceGroupName $rgname <-||-  <-||- ;
         -||-> $subnetId = $vnet.Subnets[0].Id <-||- ;
         -||-> $pubip =  -||-> New-AzureRmPublicIpAddress -Force -Name ( -||-> 'pubip' + $rgname <-||- ) -ResourceGroupName $rgname -Location $loc -AllocationMethod Dynamic -DomainNameLabel ( -||-> 'pubip' + $rgname <-||- ) <-||-  <-||- ;
         -||-> $pubip =  -||-> Get-AzureRmPublicIpAddress -Name ( -||-> 'pubip' + $rgname <-||- ) -ResourceGroupName $rgname <-||-  <-||- ;
         -||-> $pubipId = $pubip.Id <-||- ;

		
		 -||-> $nsg =  -||-> New-AzureRmNetworkSecurityGroup -Force -Name ( -||-> 'nsg' + $rgname <-||- ) -ResourceGroupName $rgname -Location $loc <-||-  <-||- 
		 -||-> $nsgId = $nsg.Id <-||- 

         -||-> $nic =  -||-> New-AzureRmNetworkInterface -Force -Name ( -||-> 'nic' + $rgname <-||- ) -ResourceGroupName $rgname -Location $loc -SubnetId $subnetId -PublicIpAddressId $pubip.Id -NetworkSecurityGroupId $nsgId <-||-  <-||- ;
         -||-> $nic =  -||-> Get-AzureRmNetworkInterface -Name ( -||-> 'nic' + $rgname <-||- ) -ResourceGroupName $rgname <-||-  <-||- ;
         -||-> $nicId = $nic.Id <-||- ;

         -||-> $p =  -||-> Add-AzureRmVMNetworkInterface -VM $p -Id $nicId <-||-  <-||- ;
         -||-> Assert-AreEqual $p.NetworkProfile.NetworkInterfaces.Count 1 <-||- ;
         -||-> Assert-AreEqual $p.NetworkProfile.NetworkInterfaces[0].Id $nicId <-||- ;
         -||-> Assert-Null $p.NetworkProfile.NetworkInterfaces[0].Primary <-||- ;

        
         -||-> $stoname = 'sto' + $rgname <-||- ;
         -||-> $stotype = 'Standard_GRS' <-||- ;
         -||-> New-AzureRmStorageAccount -ResourceGroupName $rgname -Name $stoname -Location $loc -Type $stotype <-||- ;
         -||-> $stoaccount =  -||-> Get-AzureRmStorageAccount -ResourceGroupName $rgname -Name $stoname <-||-  <-||- ;

         -||-> $osDiskName = 'osDisk' <-||- ;
         -||-> $osDiskCaching = 'ReadWrite' <-||- ;
         -||-> $osDiskVhdUri = "https://$stoname.blob.core.windows.net/test/os.vhd" <-||- ;
         -||-> $dataDiskVhdUri1 = "https://$stoname.blob.core.windows.net/test/data1.vhd" <-||- ;
         -||-> $dataDiskVhdUri2 = "https://$stoname.blob.core.windows.net/test/data2.vhd" <-||- ;
         -||-> $dataDiskVhdUri3 = "https://$stoname.blob.core.windows.net/test/data3.vhd" <-||- ;

         -||-> $p =  -||-> Set-AzureRmVMOSDisk -VM $p -Name $osDiskName -VhdUri $osDiskVhdUri -Caching $osDiskCaching -CreateOption FromImage <-||-  <-||- ;

         -||-> $p =  -||-> Add-AzureRmVMDataDisk -VM $p -Name 'testDataDisk1' -Caching 'ReadOnly' -DiskSizeInGB 10 -Lun 1 -VhdUri $dataDiskVhdUri1 -CreateOption Empty <-||-  <-||- ;
         -||-> $p =  -||-> Add-AzureRmVMDataDisk -VM $p -Name 'testDataDisk2' -Caching 'ReadOnly' -DiskSizeInGB 11 -Lun 2 -VhdUri $dataDiskVhdUri2 -CreateOption Empty <-||-  <-||- ;
         -||-> $p =  -||-> Add-AzureRmVMDataDisk -VM $p -Name 'testDataDisk3' -Caching 'ReadOnly' -DiskSizeInGB 12 -Lun 3 -VhdUri $dataDiskVhdUri3 -CreateOption Empty <-||-  <-||- ;
         -||-> $p =  -||-> Remove-AzureRmVMDataDisk -VM $p -Name 'testDataDisk3' <-||-  <-||- ;
        
         -||-> Assert-AreEqual $p.StorageProfile.OSDisk.Caching $osDiskCaching <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.OSDisk.Name $osDiskName <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.OSDisk.Vhd.Uri $osDiskVhdUri <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.DataDisks.Count 2 <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.DataDisks[0].Caching 'ReadOnly' <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.DataDisks[0].DiskSizeGB 10 <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.DataDisks[0].Lun 1 <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.DataDisks[0].Vhd.Uri $dataDiskVhdUri1 <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.DataDisks[1].Caching 'ReadOnly' <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.DataDisks[1].DiskSizeGB 11 <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.DataDisks[1].Lun 2 <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.DataDisks[1].Vhd.Uri $dataDiskVhdUri2 <-||- ;

        
         -||-> $user = "Foo12" <-||- ;
         -||-> $password = $PLACEHOLDER <-||- ;
         -||-> $securePassword =  -||-> ConvertTo-SecureString $password -AsPlainText -Force <-||-  <-||- ;
         -||-> $cred =  -||-> New-Object System.Management.Automation.PSCredential ( -||-> $user, $securePassword <-||- ) <-||-  <-||- ;
         -||-> $computerName = 'test' <-||- ;
         -||-> $vhdContainer = "https://$stoname.blob.core.windows.net/test" <-||- ;
         -||-> $img = 'a699494373c04fc0bc8f2bb1389d6106__Windows-Server-2012-Datacenter-201503.01-en.us-127GB.vhd' <-||- ;

        
         -||-> $p =  -||-> Set-AzureRmVMOperatingSystem -VM $p -Windows -ComputerName $computerName -Credential $cred <-||-  <-||- ;

         -||-> Assert-AreEqual $p.OSProfile.AdminUsername $user <-||- ;
         -||-> Assert-AreEqual $p.OSProfile.ComputerName $computerName <-||- ;
         -||-> Assert-AreEqual $p.OSProfile.AdminPassword $password <-||- ;

        
         -||-> $imgRef =  -||-> Get-DefaultCRPImage <-||-  <-||- ;
         -||-> $p = ( -||-> $imgRef | Set-AzureRmVMSourceImage -VM $p <-||- ) <-||- ;
         -||-> Assert-NotNull $p.StorageProfile.ImageReference <-||- ;
         -||-> Assert-Null $p.StorageProfile.SourceImageId <-||- ;

        
         -||-> $p.StorageProfile.DataDisks = $null <-||- ;

        
        
         -||-> New-AzureRmVM -ResourceGroupName $rgname -Location $loc -VM $p <-||- ;

        
         -||-> $vm1 =  -||-> Get-AzureRmVM -Name $vmname -ResourceGroupName $rgname <-||-  <-||- ;
         -||-> Assert-AreEqual $vm1.Name $vmname <-||- ;
         -||-> Assert-AreEqual $vm1.NetworkProfile.NetworkInterfaces.Count 1 <-||- ;
         -||-> Assert-AreEqual $vm1.NetworkProfile.NetworkInterfaces[0].Id $nicId <-||- ;

        
         -||-> $getnic =  -||-> Get-AzureRmNetworkInterface -Name ( -||-> 'nic' + $rgname <-||- ) -ResourceGroupName $rgname <-||-  <-||- ;
         -||-> Assert-AreEqual $vm1.NetworkProfile.NetworkInterfaces[0].Id $getnic.Id <-||- ;
         -||-> Assert-AreEqual $getnic.Primary true <-||- ;
         -||-> Assert-NotNull $getnic.MacAddress <-||- ;

        
         -||-> $effectiveRoute =  -||-> Get-AzureRmEffectiveRouteTable -ResourceGroupName $rgname -NetworkInterfaceName $getnic.Name <-||-  <-||- 
		 -||-> Assert-NotNull $effectiveRoute[0].Source <-||- 

        
         -||-> $effectiveNsgs =  -||-> Get-AzureRmEffectiveNetworkSecurityGroup -ResourceGroupName $rgname -NetworkInterfaceName $getnic.Name <-||-  <-||-        
    }
    finally
    {
        
         -||-> Clean-ResourceGroup $rgname <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-SingleNetworkInterfaceWithAcceleratedNetworking
{
    
     -||-> $rgname =  -||-> Get-ComputeTestResourceName <-||-  <-||- 

     -||-> try
    {
        
         -||-> $loc = "WestCentralUS" <-||- ;
         -||-> New-AzureRmResourceGroup -Name $rgname -Location $loc -Force <-||- ;
        
        
         -||-> $vmsize = 'Standard_DS15_v2' <-||- ;
         -||-> $vmname = 'vm' + $rgname <-||- ;
         -||-> $p =  -||-> New-AzureRmVMConfig -VMName $vmname -VMSize $vmsize <-||-  <-||- ;
         -||-> Assert-AreEqual $p.HardwareProfile.VmSize $vmsize <-||- ;

        
         -||-> $subnet =  -||-> New-AzureRmVirtualNetworkSubnetConfig -Name ( -||-> 'subnet' + $rgname <-||- ) -AddressPrefix "10.0.0.0/24" <-||-  <-||- ;
         -||-> $vnet =  -||-> New-AzureRmVirtualNetwork -Force -Name ( -||-> 'vnet' + $rgname <-||- ) -ResourceGroupName $rgname -Location $loc -AddressPrefix "10.0.0.0/16" -Subnet $subnet <-||-  <-||- ;
         -||-> $vnet =  -||-> Get-AzureRmVirtualNetwork -Name ( -||-> 'vnet' + $rgname <-||- ) -ResourceGroupName $rgname <-||-  <-||- ;
         -||-> $subnetId = $vnet.Subnets[0].Id <-||- ;
         -||-> $pubip =  -||-> New-AzureRmPublicIpAddress -Force -Name ( -||-> 'pubip' + $rgname <-||- ) -ResourceGroupName $rgname -Location $loc -AllocationMethod Dynamic -DomainNameLabel ( -||-> 'pubip' + $rgname <-||- ) <-||-  <-||- ;
         -||-> $pubip =  -||-> Get-AzureRmPublicIpAddress -Name ( -||-> 'pubip' + $rgname <-||- ) -ResourceGroupName $rgname <-||-  <-||- ;
         -||-> $pubipId = $pubip.Id <-||- ;
         -||-> $nic =  -||-> New-AzureRmNetworkInterface -Force -Name ( -||-> 'nic' + $rgname <-||- ) -ResourceGroupName $rgname -Location $loc -EnableAcceleratedNetworking -SubnetId $subnetId -PublicIpAddressId $pubip.Id <-||-  <-||- ;
         -||-> $nic =  -||-> Get-AzureRmNetworkInterface -Name ( -||-> 'nic' + $rgname <-||- ) -ResourceGroupName $rgname <-||-  <-||- ;
         -||-> $nicId = $nic.Id <-||- ;
		 -||-> Assert-AreEqual $nic.EnableAcceleratedNetworking $true <-||- 

         -||-> $p =  -||-> Add-AzureRmVMNetworkInterface -VM $p -Id $nicId <-||-  <-||- ;
         -||-> Assert-AreEqual $p.NetworkProfile.NetworkInterfaces.Count 1 <-||- ;
         -||-> Assert-AreEqual $p.NetworkProfile.NetworkInterfaces[0].Id $nicId <-||- ;
         -||-> Assert-Null $p.NetworkProfile.NetworkInterfaces[0].Primary <-||- ;

        
         -||-> $stoname = 'sto' + $rgname <-||- ;
         -||-> $stotype = 'Standard_GRS' <-||- ;
         -||-> New-AzureRmStorageAccount -ResourceGroupName $rgname -Name $stoname -Location $loc -Type $stotype <-||- ;
         -||-> $stoaccount =  -||-> Get-AzureRmStorageAccount -ResourceGroupName $rgname -Name $stoname <-||-  <-||- ;

         -||-> $osDiskName = 'osDisk' <-||- ;
         -||-> $osDiskCaching = 'ReadWrite' <-||- ;
         -||-> $osDiskVhdUri = "https://$stoname.blob.core.windows.net/test/os.vhd" <-||- ;
         -||-> $dataDiskVhdUri1 = "https://$stoname.blob.core.windows.net/test/data1.vhd" <-||- ;
         -||-> $dataDiskVhdUri2 = "https://$stoname.blob.core.windows.net/test/data2.vhd" <-||- ;
         -||-> $dataDiskVhdUri3 = "https://$stoname.blob.core.windows.net/test/data3.vhd" <-||- ;

         -||-> $p =  -||-> Set-AzureRmVMOSDisk -VM $p -Name $osDiskName -VhdUri $osDiskVhdUri -Caching $osDiskCaching -CreateOption FromImage <-||-  <-||- ;

         -||-> $p =  -||-> Add-AzureRmVMDataDisk -VM $p -Name 'testDataDisk1' -Caching 'ReadOnly' -DiskSizeInGB 10 -Lun 1 -VhdUri $dataDiskVhdUri1 -CreateOption Empty <-||-  <-||- ;
         -||-> $p =  -||-> Add-AzureRmVMDataDisk -VM $p -Name 'testDataDisk2' -Caching 'ReadOnly' -DiskSizeInGB 11 -Lun 2 -VhdUri $dataDiskVhdUri2 -CreateOption Empty <-||-  <-||- ;
         -||-> $p =  -||-> Add-AzureRmVMDataDisk -VM $p -Name 'testDataDisk3' -Caching 'ReadOnly' -DiskSizeInGB 12 -Lun 3 -VhdUri $dataDiskVhdUri3 -CreateOption Empty <-||-  <-||- ;
         -||-> $p =  -||-> Remove-AzureRmVMDataDisk -VM $p -Name 'testDataDisk3' <-||-  <-||- ;
        
         -||-> Assert-AreEqual $p.StorageProfile.OSDisk.Caching $osDiskCaching <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.OSDisk.Name $osDiskName <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.OSDisk.Vhd.Uri $osDiskVhdUri <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.DataDisks.Count 2 <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.DataDisks[0].Caching 'ReadOnly' <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.DataDisks[0].DiskSizeGB 10 <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.DataDisks[0].Lun 1 <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.DataDisks[0].Vhd.Uri $dataDiskVhdUri1 <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.DataDisks[1].Caching 'ReadOnly' <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.DataDisks[1].DiskSizeGB 11 <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.DataDisks[1].Lun 2 <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.DataDisks[1].Vhd.Uri $dataDiskVhdUri2 <-||- ;

        
         -||-> $user = "Foo12" <-||- ;
         -||-> $password = $PLACEHOLDER <-||- ;
         -||-> $securePassword =  -||-> ConvertTo-SecureString $password -AsPlainText -Force <-||-  <-||- ;
         -||-> $cred =  -||-> New-Object System.Management.Automation.PSCredential ( -||-> $user, $securePassword <-||- ) <-||-  <-||- ;
         -||-> $computerName = 'test' <-||- ;
         -||-> $vhdContainer = "https://$stoname.blob.core.windows.net/test" <-||- ;
         -||-> $img = 'a699494373c04fc0bc8f2bb1389d6106__Windows-Server-2012-Datacenter-201503.01-en.us-127GB.vhd' <-||- ;

        
         -||-> $p =  -||-> Set-AzureRmVMOperatingSystem -VM $p -Windows -ComputerName $computerName -Credential $cred <-||-  <-||- ;

         -||-> Assert-AreEqual $p.OSProfile.AdminUsername $user <-||- ;
         -||-> Assert-AreEqual $p.OSProfile.ComputerName $computerName <-||- ;
         -||-> Assert-AreEqual $p.OSProfile.AdminPassword $password <-||- ;

        
         -||-> $imgRef =  -||-> Get-DefaultCRPImage "westcentralus" "MicrosoftWindowsServer" <-||-  <-||- ;
         -||-> $p = ( -||-> $imgRef | Set-AzureRmVMSourceImage -VM $p <-||- ) <-||- ;
         -||-> Assert-NotNull $p.StorageProfile.ImageReference <-||- ;
         -||-> Assert-Null $p.StorageProfile.SourceImageId <-||- ;

        
         -||-> $p.StorageProfile.DataDisks = $null <-||- ;

        
        
         -||-> New-AzureRmVM -ResourceGroupName $rgname -Location $loc -VM $p <-||- ;

        
         -||-> $vm1 =  -||-> Get-AzureRmVM -Name $vmname -ResourceGroupName $rgname <-||-  <-||- ;
         -||-> Assert-AreEqual $vm1.Name $vmname <-||- ;
         -||-> Assert-AreEqual $vm1.NetworkProfile.NetworkInterfaces.Count 1 <-||- ;
         -||-> Assert-AreEqual $vm1.NetworkProfile.NetworkInterfaces[0].Id $nicId <-||- ;
		
        
         -||-> $getnic =  -||-> Get-AzureRmNetworkInterface -Name ( -||-> 'nic' + $rgname <-||- ) -ResourceGroupName $rgname <-||-  <-||- ;
         -||-> Assert-AreEqual $vm1.NetworkProfile.NetworkInterfaces[0].Id $getnic.Id <-||- ;
		 -||-> Assert-AreEqual $getnic.EnableAcceleratedNetworking $true <-||- 

        
         -||-> Remove-AzureRmVM -Name $vmname -ResourceGroupName $rgname -Force <-||- ;
    }
    finally
    {
        
         -||-> Clean-ResourceGroup $rgname <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-VMNicWithAcceleratedNetworkingValidations
{
    
     -||-> $rgname =  -||-> Get-ComputeTestResourceName <-||-  <-||- 

     -||-> try
    {
        
         -||-> $loc = "WestCentralUS" <-||- ;
         -||-> New-AzureRmResourceGroup -Name $rgname -Location $loc -Force <-||- ;
        
        
         -||-> $vmsize = 'Standard_DS15_v2' <-||- ;
         -||-> $vmname = 'vm' + $rgname <-||- ;
         -||-> $p =  -||-> New-AzureRmVMConfig -VMName $vmname -VMSize $vmsize <-||-  <-||- ;
         -||-> Assert-AreEqual $p.HardwareProfile.VmSize $vmsize <-||- ;

        
         -||-> $subnet =  -||-> New-AzureRmVirtualNetworkSubnetConfig -Name ( -||-> 'subnet' + $rgname <-||- ) -AddressPrefix "10.0.0.0/24" <-||-  <-||- ;
         -||-> $vnet =  -||-> New-AzureRmVirtualNetwork -Force -Name ( -||-> 'vnet' + $rgname <-||- ) -ResourceGroupName $rgname -Location $loc -AddressPrefix "10.0.0.0/16" -Subnet $subnet <-||-  <-||- ;
         -||-> $vnet =  -||-> Get-AzureRmVirtualNetwork -Name ( -||-> 'vnet' + $rgname <-||- ) -ResourceGroupName $rgname <-||-  <-||- ;
         -||-> $subnetId = $vnet.Subnets[0].Id <-||- ;
         -||-> $pubip =  -||-> New-AzureRmPublicIpAddress -Force -Name ( -||-> 'pubip' + $rgname <-||- ) -ResourceGroupName $rgname -Location $loc -AllocationMethod Dynamic -DomainNameLabel ( -||-> 'pubip' + $rgname <-||- ) <-||-  <-||- ;
         -||-> $pubip =  -||-> Get-AzureRmPublicIpAddress -Name ( -||-> 'pubip' + $rgname <-||- ) -ResourceGroupName $rgname <-||-  <-||- ;
         -||-> $pubipId = $pubip.Id <-||- ;
         -||-> $nic =  -||-> New-AzureRmNetworkInterface -Force -Name ( -||-> 'nic' + $rgname <-||- ) -ResourceGroupName $rgname -Location $loc -EnableAcceleratedNetworking -SubnetId $subnetId -PublicIpAddressId $pubip.Id <-||-  <-||- ;
         -||-> $nic =  -||-> Get-AzureRmNetworkInterface -Name ( -||-> 'nic' + $rgname <-||- ) -ResourceGroupName $rgname <-||-  <-||- ;
         -||-> $nicId = $nic.Id <-||- ;
		 -||-> Assert-AreEqual $nic.EnableAcceleratedNetworking $true <-||- 

         -||-> $p =  -||-> Add-AzureRmVMNetworkInterface -VM $p -Id $nicId <-||-  <-||- ;
         -||-> Assert-AreEqual $p.NetworkProfile.NetworkInterfaces.Count 1 <-||- ;
         -||-> Assert-AreEqual $p.NetworkProfile.NetworkInterfaces[0].Id $nicId <-||- ;
         -||-> Assert-Null $p.NetworkProfile.NetworkInterfaces[0].Primary <-||- ;

        
         -||-> $stoname = 'sto' + $rgname <-||- ;
         -||-> $stotype = 'Standard_GRS' <-||- ;
         -||-> New-AzureRmStorageAccount -ResourceGroupName $rgname -Name $stoname -Location $loc -Type $stotype <-||- ;
         -||-> $stoaccount =  -||-> Get-AzureRmStorageAccount -ResourceGroupName $rgname -Name $stoname <-||-  <-||- ;

         -||-> $osDiskName = 'osDisk' <-||- ;
         -||-> $osDiskCaching = 'ReadWrite' <-||- ;
         -||-> $osDiskVhdUri = "https://$stoname.blob.core.windows.net/test/os.vhd" <-||- ;
         -||-> $dataDiskVhdUri1 = "https://$stoname.blob.core.windows.net/test/data1.vhd" <-||- ;
         -||-> $dataDiskVhdUri2 = "https://$stoname.blob.core.windows.net/test/data2.vhd" <-||- ;
         -||-> $dataDiskVhdUri3 = "https://$stoname.blob.core.windows.net/test/data3.vhd" <-||- ;

         -||-> $p =  -||-> Set-AzureRmVMOSDisk -VM $p -Name $osDiskName -VhdUri $osDiskVhdUri -Caching $osDiskCaching -CreateOption FromImage <-||-  <-||- ;

         -||-> $p =  -||-> Add-AzureRmVMDataDisk -VM $p -Name 'testDataDisk1' -Caching 'ReadOnly' -DiskSizeInGB 10 -Lun 1 -VhdUri $dataDiskVhdUri1 -CreateOption Empty <-||-  <-||- ;
         -||-> $p =  -||-> Add-AzureRmVMDataDisk -VM $p -Name 'testDataDisk2' -Caching 'ReadOnly' -DiskSizeInGB 11 -Lun 2 -VhdUri $dataDiskVhdUri2 -CreateOption Empty <-||-  <-||- ;
         -||-> $p =  -||-> Add-AzureRmVMDataDisk -VM $p -Name 'testDataDisk3' -Caching 'ReadOnly' -DiskSizeInGB 12 -Lun 3 -VhdUri $dataDiskVhdUri3 -CreateOption Empty <-||-  <-||- ;
         -||-> $p =  -||-> Remove-AzureRmVMDataDisk -VM $p -Name 'testDataDisk3' <-||-  <-||- ;
        
         -||-> Assert-AreEqual $p.StorageProfile.OSDisk.Caching $osDiskCaching <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.OSDisk.Name $osDiskName <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.OSDisk.Vhd.Uri $osDiskVhdUri <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.DataDisks.Count 2 <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.DataDisks[0].Caching 'ReadOnly' <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.DataDisks[0].DiskSizeGB 10 <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.DataDisks[0].Lun 1 <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.DataDisks[0].Vhd.Uri $dataDiskVhdUri1 <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.DataDisks[1].Caching 'ReadOnly' <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.DataDisks[1].DiskSizeGB 11 <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.DataDisks[1].Lun 2 <-||- ;
         -||-> Assert-AreEqual $p.StorageProfile.DataDisks[1].Vhd.Uri $dataDiskVhdUri2 <-||- ;

        
         -||-> $user = "Foo12" <-||- ;
         -||-> $password = $PLACEHOLDER <-||- ;
         -||-> $securePassword =  -||-> ConvertTo-SecureString $password -AsPlainText -Force <-||-  <-||- ;
         -||-> $cred =  -||-> New-Object System.Management.Automation.PSCredential ( -||-> $user, $securePassword <-||- ) <-||-  <-||- ;
         -||-> $computerName = 'test' <-||- ;
         -||-> $vhdContainer = "https://$stoname.blob.core.windows.net/test" <-||- ;
         -||-> $img = 'a699494373c04fc0bc8f2bb1389d6106__Windows-Server-2012-Datacenter-201503.01-en.us-127GB.vhd' <-||- ;

        
         -||-> $p =  -||-> Set-AzureRmVMOperatingSystem -VM $p -Windows -ComputerName $computerName -Credential $cred <-||-  <-||- ;

         -||-> Assert-AreEqual $p.OSProfile.AdminUsername $user <-||- ;
         -||-> Assert-AreEqual $p.OSProfile.ComputerName $computerName <-||- ;
         -||-> Assert-AreEqual $p.OSProfile.AdminPassword $password <-||- ;

        
         -||-> $imgRef =  -||-> Get-DefaultCRPImage "westcentralus" "MicrosoftWindowsServer" <-||-  <-||- ;
         -||-> $p = ( -||-> $imgRef | Set-AzureRmVMSourceImage -VM $p <-||- ) <-||- ;
         -||-> Assert-NotNull $p.StorageProfile.ImageReference <-||- ;
         -||-> Assert-Null $p.StorageProfile.SourceImageId <-||- ;

        
         -||-> $p.StorageProfile.DataDisks = $null <-||- ;

        
        
         -||-> New-AzureRmVM -ResourceGroupName $rgname -Location $loc -VM $p <-||- ;

        
         -||-> $vm1 =  -||-> Get-AzureRmVM -Name $vmname -ResourceGroupName $rgname <-||-  <-||- ;
         -||-> Assert-AreEqual $vm1.Name $vmname <-||- ;
         -||-> Assert-AreEqual $vm1.NetworkProfile.NetworkInterfaces.Count 1 <-||- ;
         -||-> Assert-AreEqual $vm1.NetworkProfile.NetworkInterfaces[0].Id $nicId <-||- ;
		
        
         -||-> $getnic =  -||-> Get-AzureRmNetworkInterface -Name ( -||-> 'nic' + $rgname <-||- ) -ResourceGroupName $rgname <-||-  <-||- ;
         -||-> Assert-AreEqual $vm1.NetworkProfile.NetworkInterfaces[0].Id $getnic.Id <-||- ;
		 -||-> Assert-AreEqual $getnic.EnableAcceleratedNetworking $true <-||- 

        
         -||-> Remove-AzureRmVM -Name $vmname -ResourceGroupName $rgname -Force <-||- ;
    }
    finally
    {
        
         -||-> Clean-ResourceGroup $rgname <-||- 
    } <-||- 
} <-||- 


