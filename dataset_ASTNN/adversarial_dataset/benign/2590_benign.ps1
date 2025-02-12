
















 -||-> function Test-VirtualMachineScaleSet
{
     -||-> Test-VirtualMachineScaleSet-Common $false <-||- 
} <-||- 

 -||-> function Test-VirtualMachineScaleSet-ManagedDisks
{
     -||-> Test-VirtualMachineScaleSet-Common $true <-||- 
} <-||- 
 -||-> function Test-VirtualMachineScaleSet-Common($IsManaged)
{
    
     -||-> $rgname =  -||-> Get-ComputeTestResourceName <-||-  <-||- 

     -||-> try
    {
        
         -||-> $loc = 'westus' <-||- ;
         -||-> New-AzureRMResourceGroup -Name $rgname -Location $loc -Force <-||- ;

        
         -||-> $stoname = 'sto' + $rgname <-||- ;
         -||-> $stotype = 'Standard_GRS' <-||- ;
         -||-> New-AzureRMStorageAccount -ResourceGroupName $rgname -Name $stoname -Location $loc -Type $stotype <-||- ;
         -||-> $stoaccount =  -||-> Get-AzureRMStorageAccount -ResourceGroupName $rgname -Name $stoname <-||-  <-||- ;

        
         -||-> $subnet =  -||-> New-AzureRMVirtualNetworkSubnetConfig -Name ( -||-> 'subnet' + $rgname <-||- ) -AddressPrefix "10.0.0.0/24" <-||-  <-||- ;
         -||-> $vnet =  -||-> New-AzureRMVirtualNetwork -Force -Name ( -||-> 'vnet' + $rgname <-||- ) -ResourceGroupName $rgname -Location $loc -AddressPrefix "10.0.0.0/16" -Subnet $subnet <-||-  <-||- ;
         -||-> $vnet =  -||-> Get-AzureRMVirtualNetwork -Name ( -||-> 'vnet' + $rgname <-||- ) -ResourceGroupName $rgname <-||-  <-||- ;
         -||-> $subnetId = $vnet.Subnets[0].Id <-||- ;

        
         -||-> $vmssName = 'vmss' + $rgname <-||- ;
         -||-> $vmssType = 'Microsoft.Compute/virtualMachineScaleSets' <-||- ;

         -||-> $adminUsername = 'Foo12' <-||- ;
         -||-> $adminPassword = "BaR@123" + $rgname <-||- ;

         -||-> $imgRef =  -||-> Get-DefaultCRPImage -loc $loc <-||-  <-||- ;
         -||-> $vhdContainer = "https://" + $stoname + ".blob.core.windows.net/" + $vmssName <-||- ;

         -||-> $extname = 'csetest' <-||- ;
         -||-> $publisher = 'Microsoft.Compute' <-||- ;
         -||-> $exttype = 'BGInfo' <-||- ;
         -||-> $extver = '2.1' <-||- ;

         -||-> $ipCfg =  -||-> New-AzureRmVmssIPConfig -Name 'test' -SubnetId $subnetId <-||-  <-||- ;
         -||-> $vmss =  -||-> New-AzureRmVmssConfig -Location $loc -SkuCapacity 2 -SkuName 'Standard_A0' -UpgradePolicyMode 'automatic' -NetworkInterfaceConfiguration $netCfg -Overprovision $false `
            | Add-AzureRmVmssNetworkInterfaceConfiguration -Name 'test' -Primary $true -IPConfiguration $ipCfg `
            | Set-AzureRmVmssOSProfile -ComputerNamePrefix 'test' -AdminUsername $adminUsername -AdminPassword $adminPassword `
            | Add-AzureRmVmssExtension -Name $extname -Publisher $publisher -Type $exttype -TypeHandlerVersion $extver -AutoUpgradeMinorVersion $true `
            | Remove-AzureRmVmssExtension -Name $extname `
            | Add-AzureRmVmssNetworkInterfaceConfiguration -Name 'test2' -IPConfiguration $ipCfg `
            | Remove-AzureRmVmssNetworkInterfaceConfiguration -Name 'test2' <-||-  <-||- 
         -||-> if ( -||-> $IsManaged -eq $true <-||- )
        {
             -||-> $vmss =  -||-> $vmss | Set-AzureRmVmssStorageProfile -OsDiskCreateOption 'FromImage' -OsDiskCaching 'None' `
                    -ImageReferenceOffer $imgRef.Offer -ImageReferenceSku $imgRef.Skus -ImageReferenceVersion $imgRef.Version `
                    -ImageReferencePublisher $imgRef.PublisherName <-||-  <-||- 
        }
        else
        {
             -||-> $vmss =  -||-> $vmss| Set-AzureRmVmssStorageProfile -Name 'test' -OsDiskCreateOption 'FromImage' -OsDiskCaching 'None' `
                    -ImageReferenceOffer $imgRef.Offer -ImageReferenceSku $imgRef.Skus -ImageReferenceVersion $imgRef.Version `
                    -ImageReferencePublisher $imgRef.PublisherName -VhdContainer $vhdContainer <-||-  <-||-  `
        } <-||- 

        
         -||-> Assert-AreEqual 'test' $vmss.VirtualMachineProfile.NetworkProfile.NetworkInterfaceConfigurations[0].Name <-||- ;
         -||-> Assert-AreEqual $true $vmss.VirtualMachineProfile.NetworkProfile.NetworkInterfaceConfigurations[0].Primary <-||- ;
         -||-> Assert-AreEqual $subnetId `
            $vmss.VirtualMachineProfile.NetworkProfile.NetworkInterfaceConfigurations[0].IpConfigurations[0].Subnet.Id <-||- ;

         -||-> $vmss =  -||-> New-AzureRmVmss -ResourceGroupName $rgname -Name $vmssName -VirtualMachineScaleSet $vmss <-||-  <-||- ;

         -||-> Assert-AreEqual $loc $vmss.Location <-||- ;
         -||-> Assert-AreEqual 2 $vmss.Sku.Capacity <-||- ;
         -||-> Assert-AreEqual 'Standard_A0' $vmss.Sku.Name <-||- ;
         -||-> Assert-AreEqual 'Automatic' $vmss.UpgradePolicy.Mode <-||- ;

        
         -||-> Assert-AreEqual 'test' $vmss.VirtualMachineProfile.NetworkProfile.NetworkInterfaceConfigurations[0].Name <-||- ;
         -||-> Assert-AreEqual $true $vmss.VirtualMachineProfile.NetworkProfile.NetworkInterfaceConfigurations[0].Primary <-||- ;
         -||-> Assert-AreEqual $subnetId `
            $vmss.VirtualMachineProfile.NetworkProfile.NetworkInterfaceConfigurations[0].IpConfigurations[0].Subnet.Id <-||- ;

        
         -||-> Assert-AreEqual 'test' $vmss.VirtualMachineProfile.OsProfile.ComputerNamePrefix <-||- ;
         -||-> Assert-AreEqual $adminUsername $vmss.VirtualMachineProfile.OsProfile.AdminUsername <-||- ;
         -||-> Assert-Null $vmss.VirtualMachineProfile.OsProfile.AdminPassword <-||- ;

        

         -||-> Assert-AreEqual 'FromImage' $vmss.VirtualMachineProfile.StorageProfile.OsDisk.CreateOption <-||- ;
         -||-> Assert-AreEqual 'None' $vmss.VirtualMachineProfile.StorageProfile.OsDisk.Caching <-||- ;
         -||-> if( -||-> $IsManaged -eq $false <-||- )
        {
             -||-> Assert-AreEqual 'test' $vmss.VirtualMachineProfile.StorageProfile.OsDisk.Name <-||- ;
             -||-> Assert-AreEqual $vhdContainer $vmss.VirtualMachineProfile.StorageProfile.OsDisk.VhdContainers[0] <-||- ;
        } <-||- 
         -||-> Assert-AreEqual $imgRef.Offer $vmss.VirtualMachineProfile.StorageProfile.ImageReference.Offer <-||- ;
         -||-> Assert-AreEqual $imgRef.Skus $vmss.VirtualMachineProfile.StorageProfile.ImageReference.Sku <-||- ;
         -||-> Assert-AreEqual $imgRef.Version $vmss.VirtualMachineProfile.StorageProfile.ImageReference.Version <-||- ;
         -||-> Assert-AreEqual $imgRef.PublisherName $vmss.VirtualMachineProfile.StorageProfile.ImageReference.Publisher <-||- ;

         -||-> Write-Verbose ( -||-> 'Running Command : ' + 'Get-AzureRmVmss' <-||- ) <-||- ;
         -||-> $vmssResult =  -||-> Get-AzureRmVmss -ResourceGroupName $rgname -VMScaleSetName $vmssName <-||-  <-||- ;
         -||-> Assert-AreEqual $vmssName $vmssResult.Name <-||- ;
         -||-> Assert-True {  -||-> $vmssName -eq $vmssResult.Name <-||-  } <-||- ;
         -||-> $output =  -||-> $vmssResult | Out-String <-||-  <-||- ;
         -||-> Write-Verbose ( -||-> $output <-||- ) <-||- ;
         -||-> Assert-True {  -||-> $output.Contains("VirtualMachineProfile") <-||-  } <-||- ;

        
         -||-> Write-Verbose ( -||-> 'Running Command : ' + 'Get-AzureRmVmss ListAll' <-||- ) <-||- ;
         -||-> $vmssList =  -||-> Get-AzureRmVmss <-||-  <-||- ;
         -||-> Assert-True {  -||-> ( -||-> $vmssList | select -ExpandProperty Name <-||- ) -contains $vmssName <-||-  } <-||- ;
         -||-> $output =  -||-> $vmssList | Out-String <-||-  <-||- ;
         -||-> Write-Verbose ( -||-> $output <-||- ) <-||- ;
         -||-> Assert-False {  -||-> $output.Contains("VirtualMachineProfile") <-||-  } <-||- ;

        
         -||-> Write-Verbose ( -||-> 'Running Command : ' + 'Get-AzureRmVmss List' <-||- ) <-||- ;
         -||-> $vmssList =  -||-> Get-AzureRmVmss -ResourceGroupName $rgname <-||-  <-||- ;
         -||-> Assert-True {  -||-> ( -||-> $vmssList | select -ExpandProperty Name <-||- ) -contains $vmssName <-||-  } <-||- ;
         -||-> $output =  -||-> $vmssList | Out-String <-||-  <-||- ;
         -||-> Write-Verbose ( -||-> $output <-||- ) <-||- ;
         -||-> Assert-False {  -||-> $output.Contains("VirtualMachineProfile") <-||-  } <-||- ;

        
         -||-> Write-Verbose ( -||-> 'Running Command : ' + 'Get-AzureRmVmssSku' <-||- ) <-||- ;
         -||-> $skuList =  -||-> Get-AzureRmVmssSku -ResourceGroupName $rgname  -VMScaleSetName $vmssName <-||-  <-||- ;
         -||-> $output =  -||-> $skuList | Out-String <-||-  <-||- ;
         -||-> Write-Verbose ( -||-> $output <-||- ) <-||- ;
         -||-> Write-Verbose ( -||-> 'Running Command : ' + 'Get-AzureRmVmssSku | Format-Custom' <-||- ) <-||- ;
         -||-> $output =  -||-> $skuList | Format-Custom | Out-String <-||-  <-||- ;
         -||-> Write-Verbose ( -||-> $output <-||- ) <-||- ;
        

        
         -||-> Write-Verbose ( -||-> 'Running Command : ' + 'Get-AzureRmVmssVM List' <-||- ) <-||- ;
         -||-> $vmListResult =  -||-> Get-AzureRmVmssVM -ResourceGroupName $rgname -VMScaleSetName $vmssName <-||-  <-||- ;
         -||-> $output =  -||-> $vmListResult | Out-String <-||-  <-||- ;
         -||-> Write-Verbose ( -||-> $output <-||- ) <-||- ;
         -||-> Assert-False {  -||-> $output.Contains("StorageProfile") <-||-  } <-||- ;

        
        for ( -||-> $i = 0 <-||- ;  -||-> $i -lt 2 <-||- ;  -||-> $i++ <-||- )
        {
             -||-> Write-Verbose ( -||-> 'Running Command : ' + 'Get-AzureRmVmssVM' <-||- ) <-||- ;
             -||-> $vm =  -||-> Get-AzureRmVmssVM -ResourceGroupName $rgname  -VMScaleSetName $vmssName -InstanceId $i <-||-  <-||- ;
             -||-> Assert-NotNull $vm <-||- ;
             -||-> $output =  -||-> $vm | Out-String <-||-  <-||- ;
             -||-> Write-Verbose ( -||-> $output <-||- ) <-||- ;
             -||-> Assert-True {  -||-> $output.Contains("StorageProfile") <-||-  } <-||- ;

             -||-> Write-Verbose ( -||-> 'Running Command : ' + 'Get-AzureRmVmssVM -InstanceView' <-||- ) <-||- ;
             -||-> $vmInstance =  -||-> Get-AzureRmVmssVM -InstanceView  -ResourceGroupName $rgname  -VMScaleSetName $vmssName -InstanceId $i <-||-  <-||- ;
             -||-> Assert-NotNull $vmInstance <-||- ;
             -||-> $output =  -||-> $vmInstance | Out-String <-||-  <-||- ;

             -||-> Write-Verbose( -||-> $output <-||- ) <-||- ;
             -||-> Assert-True {  -||-> $output.Contains("PlatformUpdateDomain") <-||-  } <-||- ;
        }

         -||-> $st =  -||-> $vmssResult | Stop-AzureRmVmss -StayProvision -Force <-||-  <-||- ;
         -||-> $st =  -||-> $vmssResult | Stop-AzureRmVmss -Force <-||-  <-||- ;
         -||-> $st =  -||-> $vmssResult | Start-AzureRmVmss <-||-  <-||- ;
         -||-> $st =  -||-> $vmssResult | Restart-AzureRmVmss <-||-  <-||- ;

         -||-> if ( -||-> $IsManaged -eq $true <-||- )
        {
             -||-> $st =  -||-> $vmssResult | Set-AzureRmVmss -ReimageAll <-||-  <-||- ;
        } <-||- 
         -||-> $instanceListParam = @() <-||- ;
        for ( -||-> $i = 0 <-||- ;  -||-> $i -lt 2 <-||- ;  -||-> $i++ <-||- )
        {
             -||-> $instanceListParam += $i.ToString() <-||- ;
        }

         -||-> $st =  -||-> $vmssResult | Stop-AzureRmVmss -StayProvision -InstanceId $instanceListParam -Force <-||-  <-||- ;
         -||-> $st =  -||-> $vmssResult | Stop-AzureRmVmss -InstanceId $instanceListParam -Force <-||-  <-||- ;
         -||-> $st =  -||-> $vmssResult | Start-AzureRmVmss -InstanceId $instanceListParam <-||-  <-||- ;
         -||-> $st =  -||-> $vmssResult | Restart-AzureRmVmss -InstanceId $instanceListParam <-||-  <-||- ;
         -||-> if ( -||-> $IsManaged -eq $true <-||- )
        {
            for ( -||-> $j = 0 <-||- ;  -||-> $j -lt 2 <-||- ;  -||-> $j++ <-||- )
            {
                 -||-> $st =  -||-> Set-AzureRmVmssVM -ReimageAll -ResourceGroupName $rgname  -VMScaleSetName $vmssName -InstanceId $j <-||-  <-||- 
            }
        } <-||- 

        
         -||-> $st =  -||-> Remove-AzureRmVmss -ResourceGroupName $rgname -VMScaleSetName $vmssName -InstanceId 1 -Force <-||-  <-||- ;
         -||-> $st =  -||-> $vmssResult | Remove-AzureRmVmss -Force <-||-  <-||- ;
    }
    finally
    {
        
         -||-> Clean-ResourceGroup $rgname <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-VirtualMachineScaleSetReimageUpdate
{
    
     -||-> $rgname =  -||-> Get-ComputeTestResourceName <-||-  <-||- 

     -||-> try
    {
        
         -||-> $loc = 'westus' <-||- ;
         -||-> New-AzureRMResourceGroup -Name $rgname -Location $loc -Force <-||- ;

        
         -||-> $stoname = 'sto' + $rgname <-||- ;
         -||-> $stotype = 'Standard_GRS' <-||- ;
         -||-> New-AzureRMStorageAccount -ResourceGroupName $rgname -Name $stoname -Location $loc -Type $stotype <-||- ;
         -||-> $stoaccount =  -||-> Get-AzureRMStorageAccount -ResourceGroupName $rgname -Name $stoname <-||-  <-||- ;

        
         -||-> $subnet =  -||-> New-AzureRMVirtualNetworkSubnetConfig -Name ( -||-> 'subnet' + $rgname <-||- ) -AddressPrefix "10.0.0.0/24" <-||-  <-||- ;
         -||-> $vnet =  -||-> New-AzureRMVirtualNetwork -Force -Name ( -||-> 'vnet' + $rgname <-||- ) -ResourceGroupName $rgname -Location $loc -AddressPrefix "10.0.0.0/16" -Subnet $subnet <-||-  <-||- ;
         -||-> $vnet =  -||-> Get-AzureRMVirtualNetwork -Name ( -||-> 'vnet' + $rgname <-||- ) -ResourceGroupName $rgname <-||-  <-||- ;
         -||-> $subnetId = $vnet.Subnets[0].Id <-||- ;

        
         -||-> $vmssName = 'vmss' + $rgname <-||- ;
         -||-> $vmssType = 'Microsoft.Compute/virtualMachineScaleSets' <-||- ;

         -||-> $adminUsername = 'Foo12' <-||- ;
         -||-> $adminPassword = "BaR@123" + $rgname <-||- ;

         -||-> $imgRef =  -||-> Get-DefaultCRPImage -loc $loc <-||-  <-||- ;
         -||-> $vhdContainer = "https://" + $stoname + ".blob.core.windows.net/" + $vmssName <-||- ;

         -||-> $aucComponentName="Microsoft-Windows-Shell-Setup" <-||- ;
         -||-> $aucComponentName="MicrosoftWindowsShellSetup" <-||- ;
         -||-> $aucPassName ="oobeSystem" <-||- ;
         -||-> $aucSetting = "AutoLogon" <-||- ;
         -||-> $aucContent = "<UserAccounts><AdministratorPassword><Value>password</Value><PlainText>true</PlainText></AdministratorPassword></UserAccounts>" <-||- ;

         -||-> $extname = 'csetest' <-||- ;
         -||-> $publisher = 'Microsoft.Compute' <-||- ;
         -||-> $exttype = 'BGInfo' <-||- ;
         -||-> $extver = '2.1' <-||- ;

         -||-> $extname2 = 'csetest2' <-||- ;

         -||-> $ipCfg =  -||-> New-AzureRmVmssIPConfig -Name 'test' -SubnetId $subnetId <-||-  <-||- ;
         -||-> $vmss =  -||-> New-AzureRmVmssConfig -Location $loc -SkuCapacity 2 -SkuName 'Standard_A0' -UpgradePolicyMode 'Manual' -NetworkInterfaceConfiguration $netCfg `
            | Add-AzureRmVmssNetworkInterfaceConfiguration -Name 'test' -Primary $true -IPConfiguration $ipCfg `
            | Set-AzureRmVmssOSProfile -ComputerNamePrefix 'test' -AdminUsername $adminUsername -AdminPassword $adminPassword `
            | Set-AzureRmVmssStorageProfile -Name 'test' -OsDiskCreateOption 'FromImage' -OsDiskCaching 'None' `
            -ImageReferenceOffer $imgRef.Offer -ImageReferenceSku $imgRef.Skus -ImageReferenceVersion $imgRef.Version `
            -ImageReferencePublisher $imgRef.PublisherName -VhdContainer $vhdContainer `
            | Add-AzureRmVmssAdditionalUnattendContent -ComponentName  $aucComponentName -Content  $aucContent -PassName  $aucPassName -SettingName  $aucSetting `
            | Add-AzureRmVmssExtension -Name $extname -Publisher $publisher -Type $exttype -TypeHandlerVersion $extver -AutoUpgradeMinorVersion $true <-||-  <-||- ;

         -||-> $vmss.VirtualMachineProfile.OsProfile.WindowsConfiguration.AdditionalUnattendContent = $null <-||- ;
         -||-> $result =  -||-> New-AzureRmVmss -ResourceGroupName $rgname -Name $vmssName -VirtualMachineScaleSet $vmss <-||-  <-||- ;

         -||-> Assert-AreEqual $loc $result.Location <-||- ;
         -||-> Assert-AreEqual 2 $result.Sku.Capacity <-||- ;
         -||-> Assert-AreEqual 'Standard_A0' $result.Sku.Name <-||- ;
         -||-> Assert-AreEqual 'Manual' $result.UpgradePolicy.Mode <-||- ;

        
         -||-> Assert-AreEqual 'test' $result.VirtualMachineProfile.NetworkProfile.NetworkInterfaceConfigurations[0].Name <-||- ;
         -||-> Assert-AreEqual $true $result.VirtualMachineProfile.NetworkProfile.NetworkInterfaceConfigurations[0].Primary <-||- ;
         -||-> Assert-AreEqual $subnetId `
            $result.VirtualMachineProfile.NetworkProfile.NetworkInterfaceConfigurations[0].IpConfigurations[0].Subnet.Id <-||- ;

        
         -||-> Assert-AreEqual 'test' $result.VirtualMachineProfile.OsProfile.ComputerNamePrefix <-||- ;
         -||-> Assert-AreEqual $adminUsername $result.VirtualMachineProfile.OsProfile.AdminUsername <-||- ;
         -||-> Assert-Null $result.VirtualMachineProfile.OsProfile.AdminPassword <-||- ;

        
         -||-> Assert-AreEqual 'test' $result.VirtualMachineProfile.StorageProfile.OsDisk.Name <-||- ;
         -||-> Assert-AreEqual 'FromImage' $result.VirtualMachineProfile.StorageProfile.OsDisk.CreateOption <-||- ;
         -||-> Assert-AreEqual 'None' $result.VirtualMachineProfile.StorageProfile.OsDisk.Caching <-||- ;
         -||-> Assert-AreEqual $vhdContainer $result.VirtualMachineProfile.StorageProfile.OsDisk.VhdContainers[0] <-||- ;
         -||-> Assert-AreEqual $imgRef.Offer $result.VirtualMachineProfile.StorageProfile.ImageReference.Offer <-||- ;
         -||-> Assert-AreEqual $imgRef.Skus $result.VirtualMachineProfile.StorageProfile.ImageReference.Sku <-||- ;
         -||-> Assert-AreEqual $imgRef.Version $result.VirtualMachineProfile.StorageProfile.ImageReference.Version <-||- ;
         -||-> Assert-AreEqual $imgRef.PublisherName $result.VirtualMachineProfile.StorageProfile.ImageReference.Publisher <-||- ;

        
         -||-> Assert-AreEqual $extname $result.VirtualMachineProfile.ExtensionProfile.Extensions[0].Name <-||- ;
         -||-> Assert-AreEqual $publisher $result.VirtualMachineProfile.ExtensionProfile.Extensions[0].Publisher <-||- ;
         -||-> Assert-AreEqual $exttype $result.VirtualMachineProfile.ExtensionProfile.Extensions[0].Type <-||- ;
         -||-> Assert-AreEqual $extver $result.VirtualMachineProfile.ExtensionProfile.Extensions[0].TypeHandlerVersion <-||- ;
         -||-> Assert-AreEqual $true $result.VirtualMachineProfile.ExtensionProfile.Extensions[0].AutoUpgradeMinorVersion <-||- ;

         -||-> $vmssInstanceViewResult =  -||-> Get-AzureRmVmss -ResourceGroupName $rgname -VMScaleSetName $vmssName -InstanceView <-||-  <-||- ;
         -||-> Assert-AreEqual "ProvisioningState/succeeded" $vmssInstanceViewResult.VirtualMachine.StatusesSummary[0].Code <-||- ;

        
         -||-> $st =  -||-> Get-AzureRmVmss -ResourceGroupName $rgname -VMScaleSetName $vmssName | Update-AzureRmVmss -ResourceGroupName $rgname -Name $vmssName <-||-  <-||- ;
         -||-> $vmssResult =  -||-> Get-AzureRmVmss -ResourceGroupName $rgname -VMScaleSetName $vmssName <-||-  <-||- ;
         -||-> $vmssInstanceViewResult =  -||-> Get-AzureRmVmss -ResourceGroupName $rgname -VMScaleSetName $vmssName -InstanceView <-||-  <-||- ;
         -||-> Assert-AreEqual "ProvisioningState/succeeded" $vmssInstanceViewResult.VirtualMachine.StatusesSummary[0].Code <-||- ;

         -||-> Update-AzureRmVmssInstance -ResourceGroupName $rgname -VMScaleSetName $vmssName -InstanceId "0" <-||- ;
         -||-> $vmssResult =  -||-> Get-AzureRmVmss -ResourceGroupName $rgname -VMScaleSetName $vmssName <-||-  <-||- ;
         -||-> $vmssInstanceViewResult =  -||-> Get-AzureRmVmss -ResourceGroupName $rgname -VMScaleSetName $vmssName -InstanceView <-||-  <-||- ;
         -||-> Assert-AreEqual "ProvisioningState/succeeded" $vmssInstanceViewResult.VirtualMachine.StatusesSummary[0].Code <-||- ;

        
         -||-> Assert-ThrowsContains {
             -||-> Set-AzureRmVmss -Reimage -ResourceGroupName $rgname -VMScaleSetName $vmssName <-||- ; } `
            "Conflict" <-||- ;

        
         -||-> $st =  -||-> Remove-AzureRmVmss -ResourceGroupName $rgname -VMScaleSetName $vmssName -InstanceId 1 -Force <-||-  <-||- ;
         -||-> $st =  -||-> Remove-AzureRmVmss -ResourceGroupName $rgname -VMScaleSetName $vmssName -Force <-||-  <-||- ;
    }
    finally
    {
        
         -||-> Clean-ResourceGroup $rgname <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-VirtualMachineScaleSetLB
{
    
     -||-> $rgname =  -||-> Get-ComputeTestResourceName <-||-  <-||- 

     -||-> try
    {
        
         -||-> $loc = 'westus' <-||- ;
         -||-> New-AzureRMResourceGroup -Name $rgname -Location $loc -Force <-||- ;

        
         -||-> $stoname = 'sto' + $rgname <-||- ;
         -||-> $stotype = 'Standard_GRS' <-||- ;
         -||-> New-AzureRMStorageAccount -ResourceGroupName $rgname -Name $stoname -Location $loc -Type $stotype <-||- ;
         -||-> $stoaccount =  -||-> Get-AzureRMStorageAccount -ResourceGroupName $rgname -Name $stoname <-||-  <-||- ;

        
         -||-> $subnet =  -||-> New-AzureRMVirtualNetworkSubnetConfig -Name ( -||-> 'subnet' + $rgname <-||- ) -AddressPrefix "10.0.0.0/24" <-||-  <-||- ;
         -||-> $vnet =  -||-> New-AzureRMVirtualNetwork -Force -Name ( -||-> 'vnet' + $rgname <-||- ) -ResourceGroupName $rgname -Location $loc -AddressPrefix "10.0.0.0/16" -Subnet $subnet <-||-  <-||- ;
         -||-> $vnet =  -||-> Get-AzureRMVirtualNetwork -Name ( -||-> 'vnet' + $rgname <-||- ) -ResourceGroupName $rgname <-||-  <-||- ;
         -||-> $subnetId = $vnet.Subnets[0].Id <-||- ;
         -||-> $pubip =  -||-> New-AzureRMPublicIpAddress -Force -Name ( -||-> 'pubip' + $rgname <-||- ) -ResourceGroupName $rgname -Location $loc -AllocationMethod Dynamic -DomainNameLabel ( -||-> 'pubip' + $rgname <-||- ) <-||-  <-||- ;
         -||-> $pubip =  -||-> Get-AzureRMPublicIpAddress -Name ( -||-> 'pubip' + $rgname <-||- ) -ResourceGroupName $rgname <-||-  <-||- ;

        
         -||-> $frontendName =  -||-> Get-ResourceName <-||-  <-||- 
         -||-> $backendAddressPoolName =  -||-> Get-ResourceName <-||-  <-||- 
         -||-> $probeName =  -||-> Get-ResourceName <-||-  <-||- 
         -||-> $inboundNatPoolName =  -||-> Get-ResourceName <-||-  <-||- 
         -||-> $lbruleName =  -||-> Get-ResourceName <-||-  <-||- 
         -||-> $lbName =  -||-> Get-ResourceName <-||-  <-||- 

         -||-> $frontend =  -||-> New-AzureRmLoadBalancerFrontendIpConfig -Name $frontendName -PublicIpAddress $pubip <-||-  <-||- 
         -||-> $backendAddressPool =  -||-> New-AzureRmLoadBalancerBackendAddressPoolConfig -Name $backendAddressPoolName <-||-  <-||- 
         -||-> $probe =  -||-> New-AzureRmLoadBalancerProbeConfig -Name $probeName -RequestPath healthcheck.aspx -Protocol http -Port 80 -IntervalInSeconds 15 -ProbeCount 2 <-||-  <-||- 
         -||-> $inboundNatPool =  -||-> New-AzureRmLoadBalancerInboundNatPoolConfig -Name $inboundNatPoolName -FrontendIPConfigurationId `
            $frontend.Id -Protocol Tcp -FrontendPortRangeStart 3360 -FrontendPortRangeEnd 3362 -BackendPort 3370 <-||-  <-||- ;
         -||-> $lbrule =  -||-> New-AzureRmLoadBalancerRuleConfig -Name $lbruleName `
            -FrontendIPConfiguration $frontend -BackendAddressPool $backendAddressPool `
            -Probe $probe -Protocol Tcp -FrontendPort 80 -BackendPort 80 `
            -IdleTimeoutInMinutes 15 -EnableFloatingIP -LoadDistribution SourceIP <-||-  <-||- ;
         -||-> $actualLb =  -||-> New-AzureRmLoadBalancer -Name $lbName -ResourceGroupName $rgname -Location $loc `
            -FrontendIpConfiguration $frontend -BackendAddressPool $backendAddressPool `
            -Probe $probe -LoadBalancingRule $lbrule -InboundNatPool $inboundNatPool <-||-  <-||- ;
         -||-> $expectedLb =  -||-> Get-AzureRmLoadBalancer -Name $lbName -ResourceGroupName $rgname <-||-  <-||- 

        
         -||-> Assert-AreEqual $expectedLb.ResourceGroupName $actualLb.ResourceGroupName <-||- ;
         -||-> Assert-AreEqual $expectedLb.Name $actualLb.Name <-||- ;
         -||-> Assert-AreEqual $expectedLb.Location $actualLb.Location <-||- ;
         -||-> Assert-AreEqual "Succeeded" $expectedLb.ProvisioningState <-||- ;
         -||-> Assert-NotNull $expectedLb.ResourceGuid <-||- ;
         -||-> Assert-AreEqual 1 @( -||-> $expectedLb.FrontendIPConfigurations <-||- ).Count <-||- ;
         -||-> Assert-AreEqual $frontendName $expectedLb.FrontendIPConfigurations[0].Name <-||- ;
         -||-> Assert-AreEqual $pubip.Id $expectedLb.FrontendIPConfigurations[0].PublicIpAddress.Id <-||- ;
         -||-> Assert-Null $expectedLb.FrontendIPConfigurations[0].PrivateIpAddress <-||- ;
         -||-> Assert-AreEqual $backendAddressPoolName $expectedLb.BackendAddressPools[0].Name <-||- ;
         -||-> Assert-AreEqual $probeName $expectedLb.Probes[0].Name <-||- ;
         -||-> Assert-AreEqual $probe.RequestPath $expectedLb.Probes[0].RequestPath <-||- ;
         -||-> Assert-AreEqual $expectedLb.FrontendIPConfigurations[0].Id $expectedLb.InboundNatPools[0].FrontendIPConfiguration.Id <-||- ;
         -||-> Assert-AreEqual $lbruleName $expectedLb.LoadBalancingRules[0].Name <-||- ;
         -||-> Assert-AreEqual $expectedLb.FrontendIPConfigurations[0].Id $expectedLb.LoadBalancingRules[0].FrontendIPConfiguration.Id <-||- ;
         -||-> Assert-AreEqual $expectedLb.BackendAddressPools[0].Id $expectedLb.LoadBalancingRules[0].BackendAddressPool.Id <-||- ;

        
         -||-> $vmssName = 'vmss' + $rgname <-||- ;
         -||-> $vmssType = 'Microsoft.Compute/virtualMachineScaleSets' <-||- ;
         -||-> $adminUsername = 'Foo12' <-||- ;
         -||-> $adminPassword = "BaR@123" + $rgname <-||- ;
         -||-> $imgRef =  -||-> Get-DefaultCRPImage -loc $loc <-||-  <-||- ;
         -||-> $vhdContainer = "https://" + $stoname + ".blob.core.windows.net/" + $vmssName <-||- ;
         -||-> $extname = 'csetest' <-||- ;
         -||-> $publisher = 'Microsoft.Compute' <-||- ;
         -||-> $exttype = 'BGInfo' <-||- ;
         -||-> $extver = '2.1' <-||- ;

         -||-> $ipCfg =  -||-> New-AzureRmVmssIPConfig -Name 'test' `
            -LoadBalancerInboundNatPoolsId $expectedLb.InboundNatPools[0].Id `
            -LoadBalancerBackendAddressPoolsId $expectedLb.BackendAddressPools[0].Id `
            -SubnetId $subnetId <-||-  <-||- ;
         -||-> Assert-AreEqual $expectedLb.InboundNatPools[0].Id $ipCfg.LoadBalancerInboundNatPools[0].Id <-||- ;
         -||-> Assert-AreEqual $expectedLb.BackendAddressPools[0].Id $ipCfg.LoadBalancerBackendAddressPools[0].Id <-||- ;
         -||-> Assert-AreEqual $subnetId $ipCfg.Subnet.Id <-||- ;

         -||-> $settingString = ‘{ “AntimalwareEnabled”: true}’ <-||- ;
         -||-> $vmss =  -||-> New-AzureRmVmssConfig -Location $loc -SkuCapacity 2 -SkuName 'Standard_A0' -UpgradePolicyMode 'automatic' -NetworkInterfaceConfiguration $netCfg `
            | Add-AzureRmVmssNetworkInterfaceConfiguration -Name 'test' -Primary $true -IPConfiguration $ipCfg `
            | Set-AzureRmVmssOSProfile -ComputerNamePrefix 'test' -AdminUsername $adminUsername -AdminPassword $adminPassword `
            | Set-AzureRmVmssStorageProfile -Name 'test' -OsDiskCreateOption 'FromImage' -OsDiskCaching 'None' `
            -ImageReferenceOffer $imgRef.Offer -ImageReferenceSku $imgRef.Skus -ImageReferenceVersion $imgRef.Version `
            -ImageReferencePublisher $imgRef.PublisherName -VhdContainer $vhdContainer `
            | Add-AzureRmVmssExtension -Name $extname -Publisher $publisher -Type $exttype -TypeHandlerVersion $extver -AutoUpgradeMinorVersion $true -Setting $settingString `
            | Remove-AzureRmVmssExtension -Name $extname `
            | Add-AzureRmVmssNetworkInterfaceConfiguration -Name 'test2' -IPConfiguration $ipCfg `
            | Remove-AzureRmVmssNetworkInterfaceConfiguration -Name 'test2' `
            | New-AzureRmVmss -ResourceGroupName $rgname -Name $vmssName <-||-  <-||- ;

         -||-> Assert-AreEqual $loc $vmss.Location <-||- ;
         -||-> Assert-AreEqual 2 $vmss.Sku.Capacity <-||- ;
         -||-> Assert-AreEqual 'Standard_A0' $vmss.Sku.Name <-||- ;
         -||-> Assert-AreEqual 'automatic' $vmss.UpgradePolicy.Mode <-||- ;

        
         -||-> Assert-AreEqual 'test' $vmss.VirtualMachineProfile.NetworkProfile.NetworkInterfaceConfigurations[0].Name <-||- ;
         -||-> Assert-AreEqual $true $vmss.VirtualMachineProfile.NetworkProfile.NetworkInterfaceConfigurations[0].Primary <-||- ;
         -||-> Assert-AreEqual $expectedLb.InboundNatPools[0].Id  `
            $vmss.VirtualMachineProfile.NetworkProfile.NetworkInterfaceConfigurations[0].IpConfigurations[0].LoadBalancerInboundNatPools[0].Id <-||- ;
         -||-> Assert-AreEqual $expectedLb.BackendAddressPools[0].Id  `
            $vmss.VirtualMachineProfile.NetworkProfile.NetworkInterfaceConfigurations[0].IpConfigurations[0].LoadBalancerBackendAddressPools[0].Id <-||- ;
         -||-> Assert-AreEqual $subnetId `
            $vmss.VirtualMachineProfile.NetworkProfile.NetworkInterfaceConfigurations[0].IpConfigurations[0].Subnet.Id <-||- ;

        
         -||-> Assert-AreEqual 'test' $vmss.VirtualMachineProfile.OsProfile.ComputerNamePrefix <-||- ;
         -||-> Assert-AreEqual $adminUsername $vmss.VirtualMachineProfile.OsProfile.AdminUsername <-||- ;
         -||-> Assert-Null $vmss.VirtualMachineProfile.OsProfile.AdminPassword <-||- ;

        
         -||-> Assert-AreEqual 'test' $vmss.VirtualMachineProfile.StorageProfile.OsDisk.Name <-||- ;
         -||-> Assert-AreEqual 'FromImage' $vmss.VirtualMachineProfile.StorageProfile.OsDisk.CreateOption <-||- ;
         -||-> Assert-AreEqual 'None' $vmss.VirtualMachineProfile.StorageProfile.OsDisk.Caching <-||- ;
         -||-> Assert-AreEqual $vhdContainer $vmss.VirtualMachineProfile.StorageProfile.OsDisk.VhdContainers[0] <-||- ;
         -||-> Assert-AreEqual $imgRef.Offer $vmss.VirtualMachineProfile.StorageProfile.ImageReference.Offer <-||- ;
         -||-> Assert-AreEqual $imgRef.Skus $vmss.VirtualMachineProfile.StorageProfile.ImageReference.Sku <-||- ;
         -||-> Assert-AreEqual $imgRef.Version $vmss.VirtualMachineProfile.StorageProfile.ImageReference.Version <-||- ;
         -||-> Assert-AreEqual $imgRef.PublisherName $vmss.VirtualMachineProfile.StorageProfile.ImageReference.Publisher <-||- ;

         -||-> Write-Verbose ( -||-> 'Running Command : ' + 'Get-AzureRmVmss' <-||- ) <-||- ;
         -||-> $vmssResult =  -||-> Get-AzureRmVmss -ResourceGroupName $rgname -VMScaleSetName $vmssName <-||-  <-||- ;
         -||-> Assert-True {  -||-> $vmssName -eq $vmssResult.Name <-||-  } <-||- ;
         -||-> $output =  -||-> $vmssResult | Out-String <-||-  <-||- ;
         -||-> Write-Verbose ( -||-> $output <-||- ) <-||- ;
         -||-> Write-Output $output <-||- ;
         -||-> Assert-True {  -||-> $output.Contains("VirtualMachineProfile") <-||-  } <-||- ;

        
         -||-> Write-Verbose ( -||-> 'Running Command : ' + 'Get-AzureRmVmss ListAll' <-||- ) <-||- ;
         -||-> $vmssList =  -||-> Get-AzureRmVmss | ? Name -like 'vmsscrptestps*' <-||-  <-||- ;
         -||-> Assert-True {  -||-> ( -||-> $vmssList | select -ExpandProperty Name <-||- ) -contains $vmssName <-||-  } <-||- ;
         -||-> $output =  -||-> $vmssList | Out-String <-||-  <-||- ;
         -||-> Assert-AreEqual 1 $vmssList.Count <-||- 
         -||-> Write-Verbose ( -||-> $output <-||- ) <-||- ;
         -||-> Assert-False {  -||-> $output.Contains("VirtualMachineProfile") <-||-  } <-||- ;

        
         -||-> Write-Verbose ( -||-> 'Running Command : ' + 'Get-AzureRmVmss List' <-||- ) <-||- ;
         -||-> $vmssList =  -||-> Get-AzureRmVmss -ResourceGroupName $rgname <-||-  <-||- ;
         -||-> Assert-True {  -||-> ( -||-> $vmssList | select -ExpandProperty Name <-||- ) -contains $vmssName <-||-  } <-||- ;
         -||-> $output =  -||-> $vmssList | Out-String <-||-  <-||- ;
         -||-> Write-Verbose ( -||-> $output <-||- ) <-||- ;
         -||-> Assert-False {  -||-> $output.Contains("VirtualMachineProfile") <-||-  } <-||- ;

        
         -||-> Write-Verbose ( -||-> 'Running Command : ' + 'Get-AzureRmVmssSku' <-||- ) <-||- ;
         -||-> $skuList =  -||-> Get-AzureRmVmssSku -ResourceGroupName $rgname  -VMScaleSetName $vmssName <-||-  <-||- ;
         -||-> $output =  -||-> $skuList | Out-String <-||-  <-||- ;
         -||-> Write-Verbose ( -||-> $output <-||- ) <-||- ;

        
         -||-> Write-Verbose ( -||-> 'Running Command : ' + 'Get-AzureRmVmssVM List' <-||- ) <-||- ;
         -||-> $vmListResult =  -||-> Get-AzureRmVmssVM -ResourceGroupName $rgname -VMScaleSetName $vmssName <-||-  <-||- ; 
         -||-> $output =  -||-> $vmListResult | Out-String <-||-  <-||- ;
         -||-> Write-Verbose ( -||-> $output <-||- ) <-||- ;
         -||-> Assert-False {  -||-> $output.Contains("StorageProfile") <-||-  } <-||- ;

        
        for ( -||-> $i = 0 <-||- ;  -||-> $i -lt 2 <-||- ;  -||-> $i++ <-||- )
        {
             -||-> Write-Verbose ( -||-> 'Running Command : ' + 'Get-AzureRmVmssVM' <-||- ) <-||- ;
             -||-> $vm =  -||-> Get-AzureRmVmssVM -ResourceGroupName $rgname  -VMScaleSetName $vmssName -InstanceId $i <-||-  <-||- ;
             -||-> Assert-NotNull $vm <-||- ;
             -||-> $output =  -||-> $vm | Out-String <-||-  <-||- ;
             -||-> Write-Verbose ( -||-> $output <-||- ) <-||- ;
             -||-> Assert-True {  -||-> $output.Contains("StorageProfile") <-||-  } <-||- ;

             -||-> Write-Verbose ( -||-> 'Running Command : ' + 'Get-AzureRmVmssVM -InstanceView' <-||- ) <-||- ;
             -||-> $vmInstance =  -||-> Get-AzureRmVmssVM -InstanceView  -ResourceGroupName $rgname  -VMScaleSetName $vmssName -InstanceId $i <-||-  <-||- ;
             -||-> Assert-NotNull $vmInstance <-||- ;
             -||-> $output =  -||-> $vmInstance | Out-String <-||-  <-||- ;
             -||-> Write-Verbose( -||-> $output <-||- ) <-||- ;
             -||-> Assert-True {  -||-> $output.Contains("PlatformUpdateDomain") <-||-  } <-||- ;
        }

         -||-> $st =  -||-> Remove-AzureRmVmss -ResourceGroupName $rgname -VMScaleSetName $vmssName -Force <-||-  <-||- ;
    }
    finally
    {
        
         -||-> Clean-ResourceGroup $rgname <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-VirtualMachineScaleSetNextLink
{
    
     -||-> $rgname =  -||-> Get-ComputeTestResourceName <-||-  <-||- 

     -||-> try
    {
        
         -||-> $loc = 'southeastasia' <-||- ;
         -||-> New-AzureRMResourceGroup -Name $rgname -Location $loc -Force <-||- ;

        
         -||-> $stoname = 'sto' + $rgname <-||- ;
         -||-> $stotype = 'Standard_GRS' <-||- ;
         -||-> New-AzureRMStorageAccount -ResourceGroupName $rgname -Name $stoname -Location $loc -Type $stotype <-||- ;
         -||-> $stoaccount =  -||-> Get-AzureRMStorageAccount -ResourceGroupName $rgname -Name $stoname <-||-  <-||- ;

        
         -||-> $subnet =  -||-> New-AzureRMVirtualNetworkSubnetConfig -Name ( -||-> 'subnet' + $rgname <-||- ) -AddressPrefix "10.0.0.0/24" <-||-  <-||- ;
         -||-> $vnet =  -||-> New-AzureRMVirtualNetwork -Force -Name ( -||-> 'vnet' + $rgname <-||- ) -ResourceGroupName $rgname -Location $loc -AddressPrefix "10.0.0.0/16" -Subnet $subnet <-||-  <-||- ;
         -||-> $vnet =  -||-> Get-AzureRMVirtualNetwork -Name ( -||-> 'vnet' + $rgname <-||- ) -ResourceGroupName $rgname <-||-  <-||- ;
         -||-> $subnetId = $vnet.Subnets[0].Id <-||- ;

        
         -||-> $vmssName = 'vmss' + $rgname <-||- ;
         -||-> $adminUsername = 'Foo12' <-||- ;
         -||-> $adminPassword = $PLACEHOLDER <-||- ;
         -||-> $imgRef =  -||-> Get-DefaultCRPImage -loc $loc <-||-  <-||- ;
         -||-> $vmss_number = 180 <-||- ;

         -||-> $ipCfg =  -||-> New-AzureRmVmssIPConfig -Name 'test' -SubnetId $subnetId <-||-  <-||- ;
         -||-> $vmss =  -||-> New-AzureRmVmssConfig -Location $loc -SkuCapacity $vmss_number -SkuName 'Standard_A0' -UpgradePolicyMode 'Automatic' -NetworkInterfaceConfiguration $netCfg -Overprovision $false -SinglePlacementGroup $false `
            | Add-AzureRmVmssNetworkInterfaceConfiguration -Name 'test' -Primary $true -IPConfiguration $ipCfg `
            | Set-AzureRmVmssOSProfile -ComputerNamePrefix 'test' -AdminUsername $adminUsername -AdminPassword $adminPassword `
            | Set-AzureRmVmssStorageProfile -OsDiskCreateOption 'FromImage' -OsDiskCaching 'None' `
            -ImageReferenceOffer $imgRef.Offer -ImageReferenceSku $imgRef.Skus -ImageReferenceVersion $imgRef.Version -ImageReferencePublisher $imgRef.PublisherName <-||-  <-||- ;

         -||-> $result =  -||-> New-AzureRmVmss -ResourceGroupName $rgname -Name $vmssName -VirtualMachineScaleSet $vmss <-||-  <-||- ;

         -||-> $vmssVmResult =  -||-> Get-AzureRmVmssVM -ResourceGroupName $rgname -VMScaleSetName $vmssName | ? Name -like 'vmsscrptestps*' <-||-  <-||- ;
         -||-> Assert-AreEqual $vmss_number $vmssVmResult.Count <-||- 
    }
    finally
    {
        
         -||-> Clean-ResourceGroup $rgname <-||- 
    } <-||- 
} <-||- 


