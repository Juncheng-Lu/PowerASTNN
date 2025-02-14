
 -||-> $rgname = "CustomRulesTest" <-||- 
 -||-> $location = "East US" <-||- 
 -||-> $appgwName = "WAFCustomRules" <-||- 


 -||-> $resourceGroup =  -||-> New-AzResourceGroup -Name $rgname -Location $location <-||-  <-||- 


 -||-> $sub1 =  -||-> New-AzVirtualNetworkSubnetConfig -Name "appgwSubnet" -AddressPrefix "10.0.0.0/24" <-||-  <-||- 
 -||-> $sub2 =  -||-> New-AzVirtualNetworkSubnetConfig -Name "backendSubnet" -AddressPrefix "10.0.1.0/24" <-||-  <-||- 
 -||-> $vnet =  -||-> New-AzvirtualNetwork -Name "Vnet1" -ResourceGroupName $rgname -Location $location `
  -AddressPrefix "10.0.0.0/16" -Subnet @( -||-> $sub1, $sub2 <-||- ) <-||-  <-||- 


 -||-> $publicip =  -||-> New-AzPublicIpAddress -ResourceGroupName $rgname -name "AppGwIP" `
  -location $location -AllocationMethod Static -Sku Standard <-||-  <-||- 


 -||-> $gwSubnet =  -||-> Get-AzVirtualNetworkSubnetConfig -Name "appgwSubnet" -VirtualNetwork $vnet <-||-  <-||- 

 -||-> $gipconfig =  -||-> New-AzApplicationGatewayIPConfiguration -Name "AppGwIpConfig" -Subnet $gwSubnet <-||-  <-||- 
 -||-> $fipconfig01 =  -||-> New-AzApplicationGatewayFrontendIPConfig -Name "fipconfig" -PublicIPAddress $publicip <-||-  <-||- 
 -||-> $pool =  -||-> New-AzApplicationGatewayBackendAddressPool -Name "pool1" `
  -BackendIPAddresses testbackend1.westus.cloudapp.azure.com, testbackend2.westus.cloudapp.azure.com <-||-  <-||- 
 -||-> $fp01 =  -||-> New-AzApplicationGatewayFrontendPort -Name "port1" -Port 80 <-||-  <-||- 


 -||-> $listener01 =  -||-> New-AzApplicationGatewayHttpListener -Name "listener1" -Protocol Http `
  -FrontendIPConfiguration $fipconfig01 -FrontendPort $fp01 <-||-  <-||- 
 -||-> $poolSetting01 =  -||-> New-AzApplicationGatewayBackendHttpSettings -Name "setting1" -Port 80 `
  -Protocol Http -CookieBasedAffinity Disabled <-||-  <-||- 
 -||-> $rule01 =  -||-> New-AzApplicationGatewayRequestRoutingRule -Name "rule1" -RuleType basic `
  -BackendHttpSettings $poolSetting01 -HttpListener $listener01 -BackendAddressPool $pool <-||-  <-||- 
 -||-> $autoscaleConfig =  -||-> New-AzApplicationGatewayAutoscaleConfiguration -MinCapacity 3 <-||-  <-||- 
 -||-> $sku =  -||-> New-AzApplicationGatewaySku -Name WAF_v2 -Tier WAF_v2 <-||-  <-||- 


 -||-> $variable =  -||-> New-AzApplicationGatewayFirewallMatchVariable -VariableName RequestHeaders -Selector User-Agent <-||-  <-||- 
 -||-> $condition =  -||-> New-AzApplicationGatewayFirewallCondition -MatchVariable $variable -Operator Contains -MatchValue "evilbot" -Transform Lowercase -NegationCondition $False <-||-  <-||-   
 -||-> $rule =  -||-> New-AzApplicationGatewayFirewallCustomRule -Name blockEvilBot -Priority 2 -RuleType MatchRule -MatchCondition $condition -Action Block <-||-  <-||- 
 -||-> $wafPolicy =  -||-> New-AzApplicationGatewayFirewallPolicy -Name wafPolicy -ResourceGroup $rgname -Location $location -CustomRule $rule <-||-  <-||- 
 -||-> $wafConfig =  -||-> New-AzApplicationGatewayWebApplicationFirewallConfiguration -Enabled $true -FirewallMode "Prevention" <-||-  <-||- 


 -||-> $appgw =  -||-> New-AzApplicationGateway -Name $appgwName -ResourceGroupName $rgname -Location $location -BackendAddressPools $pool -BackendHttpSettingsCollection $poolSetting01 -GatewayIpConfigurations $gipconfig -FrontendIpConfigurations $fipconfig01 -FrontendPorts $fp01 -HttpListeners $listener01 -RequestRoutingRules $rule01 -Sku $sku -AutoscaleConfiguration $autoscaleConfig -WebApplicationFirewallConfig $wafConfig -FirewallPolicy $wafPolicy <-||-  <-||- 

