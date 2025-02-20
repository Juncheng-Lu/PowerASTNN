



















 -||-> $global:ps_test_tag_name = 'crptestps6050' <-||- 


 -||-> function get_vm_config_object
{
    param ([string] $rgname, [string] $vmsize)
    
     -||-> $st =  -||-> Write-Verbose "Creating VM Config Object - Start" <-||-  <-||- ;

     -||-> $vmname = $rgname + 'vm' <-||- ;
     -||-> $p =  -||-> New-AzVMConfig -VMName $vmname -VMSize $vmsize <-||-  <-||- ;

     -||-> $st =  -||-> Write-Verbose "Creating VM Config Object - End" <-||-  <-||- ;

    return  -||-> $p <-||- ;
} <-||- 


 -||-> function get_created_storage_account_name
{
    param ([string] $loc, [string] $rgname)

     -||-> $st =  -||-> Write-Verbose "Creating and getting storage account for '${loc}' and '${rgname}' - Start" <-||-  <-||- ;

     -||-> $stoname = $rgname + 'sto' <-||- ;
     -||-> $stotype = 'Standard_GRS' <-||- ;

     -||-> $st =  -||-> Write-Verbose "Creating and getting storage account for '${loc}' and '${rgname}' - '${stotype}' & '${stoname}'" <-||-  <-||- ;

     -||-> $st =  -||-> New-AzStorageAccount -ResourceGroupName $rgname -Name $stoname -Location $loc -Type $stotype <-||-  <-||- ;
     -||-> $st =  -||-> Set-AzStorageAccount -ResourceGroupName $rgname -Name $stoname -Tags ( -||-> Get-ComputeTestTag $global:ps_test_tag_name <-||- ) <-||-  <-||- ;
     -||-> $st =  -||-> Get-AzStorageAccount -ResourceGroupName $rgname -Name $stoname <-||-  <-||- ;
    
     -||-> $st =  -||-> Write-Verbose "Creating and getting storage account for '${loc}' and '${rgname}' - End" <-||-  <-||- ;

    return  -||-> $stoname <-||- ;
} <-||- 


 -||-> function create_and_setup_nic_ids
{
    param ([string] $loc, [string] $rgname, $vmconfig)

     -||-> $st =  -||-> Write-Verbose "Creating and getting NICs for '${loc}' and '${rgname}' - Start" <-||-  <-||- ;

     -||-> $subnet =  -||-> New-AzVirtualNetworkSubnetConfig -Name ( -||-> $rgname + 'subnet' <-||- ) -AddressPrefix "10.0.0.0/24" <-||-  <-||- ;
     -||-> $vnet =  -||-> New-AzVirtualNetwork -Force -Name ( -||-> $rgname + 'vnet' <-||- ) -ResourceGroupName $rgname -Location $loc -AddressPrefix "10.0.0.0/16" -Subnet $subnet -Tag ( -||-> Get-ComputeTestTag $global:ps_test_tag_name <-||- ) <-||-  <-||- ;
     -||-> $vnet =  -||-> Get-AzVirtualNetwork -Name ( -||-> $rgname + 'vnet' <-||- ) -ResourceGroupName $rgname <-||-  <-||- ;
     -||-> $subnetId = $vnet.Subnets[0].Id <-||- ;
     -||-> $nic_ids = @( -||-> $null <-||- ) * 1 <-||- ;
     -||-> $nic0 =  -||-> New-AzNetworkInterface -Force -Name ( -||-> $rgname + 'nic0' <-||- ) -ResourceGroupName $rgname -Location $loc -SubnetId $subnetId -Tag ( -||-> Get-ComputeTestTag $global:ps_test_tag_name <-||- ) <-||-  <-||- ;
     -||-> $nic_ids[0] = $nic0.Id <-||- ;
     -||-> $vmconfig =  -||-> Add-AzVMNetworkInterface -VM $vmconfig -Id $nic0.Id <-||-  <-||- ;
     -||-> $st =  -||-> Write-Verbose "Creating and getting NICs for '${loc}' and '${rgname}' - End" <-||-  <-||- ;

    return  -||-> $nic_ids <-||- ;
} <-||- 

 -||-> function create_and_setup_vm_config_object
{
    param ([string] $loc, [string] $rgname, [string] $vmsize)

     -||-> $st =  -||-> Write-Verbose "Creating and setting up the VM config object for '${loc}', '${rgname}' and '${vmsize}' - Start" <-||-  <-||- ;

     -||-> $vmconfig =  -||-> get_vm_config_object $rgname $vmsize <-||-  <-||- 

     -||-> $user = "Foo12" <-||- ;
     -||-> $password = $rgname + "BaR
    $securePassword = ConvertTo-SecureString $password -AsPlainText -Force;
    $cred = New-Object System.Management.Automation.PSCredential ($user, $securePassword);
    $computerName = $rgname + " -||-> c <-||- cn";
    $vmconfig = Set-AzVMOperatingSystem -VM $vmconfig -Windows -ComputerName $computerName -Credential $cred;

    $st = Write-Verbose "Creating and setting up the VM config object for '${loc}', '${rgname}' and '${vmsize}' - End";

    return $vmconfig;
}


function setup_image_and_disks
{
    param ([string] $loc, [string] $rgname, [string] $stoname, $vmconfig)

    $st = Write-Verbose "Setting up image and disks of VM config object jfor '${loc}', '${rgname}' and '${stoname}' - Start";

    $osDiskName = 'osDisk';
    $osDiskVhdUri = "https://$stoname.blob.core.windows.net/test/os.vhd";
    $osDiskCaching = 'ReadWrite';

    $vmconfig = Set-AzVMOSDisk -VM $vmconfig -Name $osDiskName -VhdUri $osDiskVhdUri -Caching $osDiskCaching -CreateOption FromImage;

    
    $imgRef = Get-DefaultCRPImage -loc $loc;
    $vmconfig = ($imgRef | Set-AzVMSourceImage -VM $vmconfig);

    
    $vmconfig.StorageProfile.DataDisks = $null;

    $st = Write-Verbose "Setting up image and disks of VM config object jfor '${loc}', '${rgname}' and '${stoname}' - End";

    return $vmconfig;
}


function ps_vm_dynamic_test_func_3_crptestps5200
{
    
    $rgname = 'crptestps5200';

    try
    {
        $loc = 'Central US';
        $vmsize = 'Standard_A6';

        $st = Write-Verbose "Running Test ps_vm_dynamic_test_func_3_crptestps5200 - Start ${rgname}, ${loc} <-||-  &  -||-> ${vmsize} -||-> " <-||- ";

        $st = Write-Verbose 'Running Test ps_vm_dynamic_test_func_3_crptestps5200 - Creating Resource Group';
        $st = New-AzResourceGroup -Location $loc -Name $rgname -Tag (Get-ComputeTestTag $global:ps_test_tag_name) -Force;

        $vmconfig = create_and_setup_vm_config_object $loc $rgname $vmsize;

        
        $stoname = get_created_storage_account_name $loc $rgname;

        
        $nicids = create_and_setup_nic_ids $loc $rgname $vmconfig;

        
        $st = setup_image_and_disks $loc $rgname $stoname $vmconfig;

        
        $st = Write-Verbose 'Running Test ps_vm_dynamic_test_func_3_crptestps5200 - Creating VM';

        $vmname = $rgname + 'vm';
        
        $st = New-AzVM -ResourceGroupName $rgname -Location $loc -VM $vmconfig -Tags (Get-ComputeTestTag $global:ps_test_tag_name);

        
        $st = Write-Verbose 'Running Test ps_vm_dynamic_test_func_3_crptestps5200 - Getting VM';
        $vm1 = Get-AzVM -Name $vmname -ResourceGroupName $rgname;

        
        $st = Write-Verbose 'Running Test ps_vm_dynamic_test_func_3_crptestps5200 - Removing VM';
        $st = Remove-AzVM -Name $vmname -ResourceGroupName $rgname -Force;

        $st = Write-Verbose 'Running Test ps_vm_dynamic_test_func_3_crptestps5200 - End';
    }
    finally
    {
        
        Clean-ResourceGroup $rgname
    }
}


 <-||-  <-||- 
