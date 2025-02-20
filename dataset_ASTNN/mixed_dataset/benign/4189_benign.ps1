
 -||-> New-AzResourceGroup -Name myResourceGroupAG -Location eastus <-||- 


 -||-> $backendSubnetConfig =  -||-> New-AzVirtualNetworkSubnetConfig `
  -Name myBackendSubnet `
  -AddressPrefix 10.0.1.0/24 <-||-  <-||- 
 -||-> $agSubnetConfig =  -||-> New-AzVirtualNetworkSubnetConfig `
  -Name myAGSubnet `
  -AddressPrefix 10.0.2.0/24 <-||-  <-||- 
 -||-> $vnet =  -||-> New-AzVirtualNetwork `
  -ResourceGroupName myResourceGroupAG `
  -Location eastus `
  -Name myVNet `
  -AddressPrefix 10.0.0.0/16 `
  -Subnet $backendSubnetConfig, $agSubnetConfig <-||-  <-||- 
 -||-> $pip =  -||-> New-AzPublicIpAddress `
  -ResourceGroupName myResourceGroupAG `
  -Location eastus `
  -Name myAGPublicIPAddress `
  -AllocationMethod Dynamic <-||-  <-||- 


 -||-> $vnet =  -||-> Get-AzVirtualNetwork `
  -ResourceGroupName myResourceGroupAG `
  -Name myVNet <-||-  <-||- 
 -||-> $subnet=$vnet.Subnets[0] <-||- 
 -||-> $gipconfig =  -||-> New-AzApplicationGatewayIPConfiguration `
  -Name myAGIPConfig `
  -Subnet $subnet <-||-  <-||- 
 -||-> $fipconfig =  -||-> New-AzApplicationGatewayFrontendIPConfig `
  -Name myAGFrontendIPConfig `
  -PublicIPAddress $pip <-||-  <-||- 
 -||-> $frontendport =  -||-> New-AzApplicationGatewayFrontendPort `
  -Name myFrontendPort `
  -Port 80 <-||-  <-||- 


 -||-> $defaultPool =  -||-> New-AzApplicationGatewayBackendAddressPool `
  -Name appGatewayBackendPool <-||-  <-||-  
 -||-> $poolSettings =  -||-> New-AzApplicationGatewayBackendHttpSettings `
  -Name myPoolSettings `
  -Port 80 `
  -Protocol Http `
  -CookieBasedAffinity Enabled `
  -RequestTimeout 120 <-||-  <-||- 


 -||-> $defaultlistener =  -||-> New-AzApplicationGatewayHttpListener `
  -Name mydefaultListener `
  -Protocol Http `
  -FrontendIPConfiguration $fipconfig `
  -FrontendPort $frontendport <-||-  <-||- 
 -||-> $frontendRule =  -||-> New-AzApplicationGatewayRequestRoutingRule `
  -Name rule1 `
  -RuleType Basic `
  -HttpListener $defaultlistener `
  -BackendAddressPool $defaultPool `
  -BackendHttpSettings $poolSettings <-||-  <-||- 


 -||-> $sku =  -||-> New-AzApplicationGatewaySku `
  -Name WAF_Medium `
  -Tier WAF `
  -Capacity 2 <-||-  <-||- 
 -||-> $wafConfig =  -||-> New-AzApplicationGatewayWebApplicationFirewallConfiguration `
  -Enabled $true `
  -FirewallMode "Detection" <-||-  <-||- 
 -||-> $appgw =  -||-> New-AzApplicationGateway `
  -Name myAppGateway `
  -ResourceGroupName myResourceGroupAG `
  -Location eastus `
  -BackendAddressPools $defaultPool `
  -BackendHttpSettingsCollection $poolSettings `
  -FrontendIpConfigurations $fipconfig `
  -GatewayIpConfigurations $gipconfig `
  -FrontendPorts $frontendport `
  -HttpListeners $defaultlistener `
  -RequestRoutingRules $frontendRule `
  -Sku $sku `
  -WebApplicationFirewallConfig $wafConfig <-||-  <-||- 


 -||-> $vnet =  -||-> Get-AzVirtualNetwork `
  -ResourceGroupName myResourceGroupAG `
  -Name myVNet <-||-  <-||- 
 -||-> $appgw =  -||-> Get-AzApplicationGateway `
  -ResourceGroupName myResourceGroupAG `
  -Name myAppGateway <-||-  <-||- 
 -||-> $backendPool =  -||-> Get-AzApplicationGatewayBackendAddressPool `
  -Name appGatewayBackendPool `
  -ApplicationGateway $appgw <-||-  <-||- 
 -||-> $ipConfig =  -||-> New-AzVmssIpConfig `
  -Name myVmssIPConfig `
  -SubnetId $vnet.Subnets[1].Id `
  -ApplicationGatewayBackendAddressPoolsId $backendPool.Id <-||-  <-||- 
 -||-> $vmssConfig =  -||-> New-AzVmssConfig `
  -Location eastus `
  -SkuCapacity 2 `
  -SkuName Standard_DS2 `
  -UpgradePolicyMode Automatic <-||-  <-||- 
 -||-> Set-AzVmssStorageProfile $vmssConfig `
  -ImageReferencePublisher MicrosoftWindowsServer `
  -ImageReferenceOffer WindowsServer `
  -ImageReferenceSku 2016-Datacenter `
  -ImageReferenceVersion latest <-||- 
 -||-> Set-AzVmssOsProfile $vmssConfig `
  -AdminUsername azureuser `
  -AdminPassword "Azure123456!" `
  -ComputerNamePrefix myvmss <-||- 
 -||-> Add-AzVmssNetworkInterfaceConfiguration `
  -VirtualMachineScaleSet $vmssConfig `
  -Name myVmssNetConfig `
  -Primary $true `
  -IPConfiguration $ipConfig <-||- 
 -||-> New-AzVmss `
  -ResourceGroupName myResourceGroupAG `
  -Name myvmss `
  -VirtualMachineScaleSet $vmssConfig <-||- 


 -||-> $publicSettings = @{ "fileUris" =  -||-> ( -||-> ,"https://raw.githubusercontent.com/davidmu1/samplescripts/master/appgatewayurl.ps1" <-||- ) <-||- ; 
  "commandToExecute" =  -||-> "powershell -ExecutionPolicy Unrestricted -File appgatewayurl.ps1" <-||-  } <-||- 
 -||-> $vmss =  -||-> Get-AzVmss -ResourceGroupName myResourceGroupAG -VMScaleSetName myvmss <-||-  <-||- 
 -||-> Add-AzVmssExtension -VirtualMachineScaleSet $vmss `
  -Name "customScript" `
  -Publisher "Microsoft.Compute" `
  -Type "CustomScriptExtension" `
  -TypeHandlerVersion 1.8 `
  -Setting $publicSettings <-||- 
 -||-> Update-AzVmss `
  -ResourceGroupName myResourceGroupAG `
  -Name myvmss `
  -VirtualMachineScaleSet $vmss <-||- 


 -||-> $storageAccount =  -||-> New-AzStorageAccount `
  -ResourceGroupName myResourceGroupAG `
  -Name myagstore1 `
  -Location eastus `
  -SkuName "Standard_LRS" <-||-  <-||- 


 -||-> $appgw =  -||-> Get-AzApplicationGateway `
  -ResourceGroupName myResourceGroupAG `
  -Name myAppGateway <-||-  <-||- 
 -||-> $store =  -||-> Get-AzStorageAccount `
  -ResourceGroupName myResourceGroupAG `
  -Name myagstore1 <-||-  <-||- 
 -||-> Set-AzDiagnosticSetting `
  -ResourceId $appgw.Id `
  -StorageAccountId $store.Id `
  -Categories ApplicationGatewayAccessLog, ApplicationGatewayPerformanceLog, ApplicationGatewayFirewallLog `
  -Enabled $true `
  -RetentionEnabled $true `
  -RetentionInDays 30 <-||- 


 -||-> Get-AzPublicIPAddress -ResourceGroupName myResourceGroupAG -Name myAGPublicIPAddress <-||- 


