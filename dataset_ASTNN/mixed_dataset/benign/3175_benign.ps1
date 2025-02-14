













 -||-> function Test-ApplicationSecurityGroupCRUD
{
     -||-> $rgLocation =  -||-> Get-ProviderLocation ResourceManagement <-||-  <-||- 
     -||-> $resourceTypeParent = "Microsoft.Network/ApplicationSecurityGroups" <-||- 
     -||-> $location =  -||-> Get-ProviderLocation $resourceTypeParent <-||-  <-||- 

     -||-> $rgName =  -||-> Get-ResourceGroupName <-||-  <-||- 
     -||-> $asgName =  -||-> Get-ResourceName <-||-  <-||- 

     -||-> try
    {
        
         -||-> $resourceGroup =  -||-> New-AzResourceGroup -Name $rgName -Location $location -Tags @{ testtag =  -||-> "ASG tag" <-||-  } <-||-  <-||- 

        
         -||-> $job =  -||-> New-AzApplicationSecurityGroup -ResourceGroupName $rgName -Name $asgName -Location $rgLocation -AsJob <-||-  <-||- 
		 -||-> $job | Wait-Job <-||- 
		 -||-> $asgNew =  -||-> $job | Receive-Job <-||-  <-||- 

         -||-> Assert-AreEqual $rgName $asgNew.ResourceGroupName <-||- 
         -||-> Assert-AreEqual $asgName $asgNew.Name <-||- 
         -||-> Assert-NotNull $asgNew.Location <-||- 
         -||-> Assert-NotNull $asgNew.Etag <-||- 

        
         -||-> $asgGet =  -||-> Get-AzApplicationSecurityGroup -ResourceGroupName $rgName -Name $asgName <-||-  <-||- 
         -||-> Assert-AreEqual $rgName $asgGet.ResourceGroupName <-||- 
         -||-> Assert-AreEqual $asgName $asgGet.Name <-||- 
         -||-> Assert-NotNull $asgGet.Location <-||- 
         -||-> Assert-NotNull $asgGet.Etag <-||- 

         -||-> $asgGet =  -||-> Get-AzApplicationSecurityGroup -ResourceGroupName "*" <-||-  <-||- 
         -||-> Assert-True {  -||-> $asgGet.Count -ge 0 <-||-  } <-||- 

         -||-> $asgGet =  -||-> Get-AzApplicationSecurityGroup -Name "*" <-||-  <-||- 
         -||-> Assert-True {  -||-> $asgGet.Count -ge 0 <-||-  } <-||- 

         -||-> $asgGet =  -||-> Get-AzApplicationSecurityGroup -ResourceGroupName "*" -Name "*" <-||-  <-||- 
         -||-> Assert-True {  -||-> $asgGet.Count -ge 0 <-||-  } <-||- 

        
         -||-> $asgDelete =  -||-> Remove-AzApplicationSecurityGroup -Name $asgName -ResourceGroupName $rgName -PassThru -Force <-||-  <-||- 
         -||-> Assert-AreEqual $true $asgDelete <-||- 
    }
    finally
    {
        
         -||-> Clean-ResourceGroup $rgName <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-ApplicationSecurityGroupCollections
{
     -||-> $rgLocation =  -||-> Get-ProviderLocation ResourceManagement <-||-  <-||- 
     -||-> $resourceTypeParent = "Microsoft.Network/ApplicationSecurityGroups" <-||- 
     -||-> $location =  -||-> Get-ProviderLocation $resourceTypeParent <-||-  <-||- 

     -||-> $rgName1 =  -||-> Get-ResourceGroupName <-||-  <-||- 
     -||-> $rgName2 =  -||-> Get-ResourceGroupName <-||-  <-||- 

     -||-> $asgName1 =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $asgName2 =  -||-> Get-ResourceName <-||-  <-||- 

     -||-> try
    {
        
         -||-> $resourceGroup1 =  -||-> New-AzResourceGroup -Name $rgName1 -Location $location -Tags @{ testtag =  -||-> "ASG tag" <-||-  } <-||-  <-||- 
         -||-> $resourceGroup2 =  -||-> New-AzResourceGroup -Name $rgName2 -Location $location -Tags @{ testtag =  -||-> "ASG tag" <-||-  } <-||-  <-||- 

        
         -||-> $asg1 =  -||-> New-AzApplicationSecurityGroup -Name $asgName1 -ResourceGroupName $rgName1 -Location $rgLocation <-||-  <-||- 
         -||-> $asg2 =  -||-> New-AzApplicationSecurityGroup -Name $asgName2 -ResourceGroupName $rgName2 -Location $rgLocation <-||-  <-||- 

        
         -||-> $listRg =  -||-> Get-AzApplicationSecurityGroup -ResourceGroupName $rgName1 <-||-  <-||- 
         -||-> Assert-AreEqual 1 @( -||-> $listRg <-||- ).Count <-||- 
         -||-> Assert-AreEqual $listRg[0].ResourceGroupName $asg1.ResourceGroupName <-||- 
         -||-> Assert-AreEqual $listRg[0].Name $asg1.Name <-||- 
         -||-> Assert-AreEqual $listRg[0].Location $asg1.Location <-||- 
         -||-> Assert-AreEqual $listRg[0].Etag $asg1.Etag <-||- 

        
         -||-> $listSub =  -||-> Get-AzApplicationSecurityGroup <-||-  <-||- 

         -||-> $asg1FromList =  -||-> @( -||-> $listSub <-||- ) | Where-Object Name -eq $asgName1 | Where-Object ResourceGroupName -eq $rgName1 <-||-  <-||- 
         -||-> Assert-AreEqual $asg1.ResourceGroupName $asg1FromList.ResourceGroupName <-||- 
         -||-> Assert-AreEqual $asg1.Name $asg1FromList.Name <-||- 
         -||-> Assert-AreEqual $asg1.Location $asg1FromList.Location <-||- 
         -||-> Assert-AreEqual $asg1.Etag $asg1FromList.Etag <-||- 

         -||-> $asg2FromList =  -||-> @( -||-> $listSub <-||- ) | Where-Object Name -eq $asgName2 | Where-Object ResourceGroupName -eq $rgName2 <-||-  <-||- 
         -||-> Assert-AreEqual $asg2.ResourceGroupName $asg2FromList.ResourceGroupName <-||- 
         -||-> Assert-AreEqual $asg2.Name $asg2FromList.Name <-||- 
         -||-> Assert-AreEqual $asg2.Location $asg2FromList.Location <-||- 
         -||-> Assert-AreEqual $asg2.Etag $asg2FromList.Etag <-||- 
    }
    finally
    {
        
         -||-> Clean-ResourceGroup $rgName1 <-||- 
         -||-> Clean-ResourceGroup $rgName2 <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-ApplicationSecurityGroupInNewSecurityRule
{
    param([bool] $useIds = $false)

     -||-> $rgLocation =  -||-> Get-ProviderLocation ResourceManagement <-||-  <-||- 
     -||-> $resourceTypeParent = "Microsoft.Network/ApplicationSecurityGroups" <-||- 
     -||-> $location =  -||-> Get-ProviderLocation $resourceTypeParent <-||-  <-||- 

     -||-> $rgName =  -||-> Get-ResourceGroupName <-||-  <-||- 
     -||-> $asgName =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $nsgName =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $securityRuleNames = @( -||-> ( -||-> Get-ResourceName <-||- ), ( -||-> Get-ResourceName <-||- ), ( -||-> Get-ResourceName <-||- ), ( -||-> Get-ResourceName <-||- ) <-||- ) <-||- 

     -||-> try
    {
        
         -||-> $resourceGroup =  -||-> New-AzResourceGroup -Name $rgName -Location $location -Tags @{ testtag =  -||-> "ASG tag" <-||-  } <-||-  <-||- 

        
         -||-> $asg =  -||-> New-AzApplicationSecurityGroup -ResourceGroupName $rgName -Name $asgName -Location $rgLocation <-||-  <-||- 

        
         -||-> $securityRules = @() <-||- 

         -||-> if ( -||-> $useIds <-||- )
        {
             -||-> $securityRules +=  -||-> New-AzNetworkSecurityRuleConfig -Name $securityRuleNames[0] -Description "description" -Protocol Tcp -SourcePortRange "23-45" -DestinationPortRange "46-56" -SourceApplicationSecurityGroupId $asg.Id -DestinationApplicationSecurityGroupId $asg.Id -Access Allow -Priority 100 -Direction Inbound <-||-  <-||- 
             -||-> $securityRules +=  -||-> New-AzNetworkSecurityRuleConfig -Name $securityRuleNames[1] -Description "description" -Protocol Tcp -SourcePortRange "23-45" -DestinationPortRange "46-56" -SourceApplicationSecurityGroupId $asg.Id -DestinationAddressPrefix * -Access Allow -Priority 102 -Direction Inbound <-||-  <-||- 
             -||-> $securityRules +=  -||-> New-AzNetworkSecurityRuleConfig -Name $securityRuleNames[2] -Description "description" -Protocol Tcp -SourcePortRange "23-45" -DestinationPortRange "46-56" -SourceAddressPrefix * -DestinationApplicationSecurityGroupId $asg.Id -Access Allow -Priority 103 -Direction Inbound <-||-  <-||- 
             -||-> $securityRules +=  -||-> New-AzNetworkSecurityRuleConfig -Name $securityRuleNames[3] -Description "description" -Protocol Tcp -SourcePortRange "23-45" -DestinationPortRange "46-56" -SourceAddressPrefix * -DestinationAddressPrefix * -Access Allow -Priority 104 -Direction Inbound <-||-  <-||- 
        }
        else
        {
             -||-> $securityRules +=  -||-> New-AzNetworkSecurityRuleConfig -Name $securityRuleNames[0] -Description "description" -Protocol Tcp -SourcePortRange "23-45" -DestinationPortRange "46-56" -SourceApplicationSecurityGroup $asg -DestinationApplicationSecurityGroup $asg -Access Allow -Priority 100 -Direction Inbound <-||-  <-||- 
             -||-> $securityRules +=  -||-> New-AzNetworkSecurityRuleConfig -Name $securityRuleNames[1] -Description "description" -Protocol Tcp -SourcePortRange "23-45" -DestinationPortRange "46-56" -SourceApplicationSecurityGroup $asg -DestinationAddressPrefix * -Access Allow -Priority 102 -Direction Inbound <-||-  <-||- 
             -||-> $securityRules +=  -||-> New-AzNetworkSecurityRuleConfig -Name $securityRuleNames[2] -Description "description" -Protocol Tcp -SourcePortRange "23-45" -DestinationPortRange "46-56" -SourceAddressPrefix * -DestinationApplicationSecurityGroup $asg -Access Allow -Priority 103 -Direction Inbound <-||-  <-||- 
             -||-> $securityRules +=  -||-> New-AzNetworkSecurityRuleConfig -Name $securityRuleNames[3] -Description "description" -Protocol Tcp -SourcePortRange "23-45" -DestinationPortRange "46-56" -SourceAddressPrefix * -DestinationAddressPrefix * -Access Allow -Priority 104 -Direction Inbound <-||-  <-||- 
        } <-||- 

        
         -||-> $nsg =  -||-> New-AzNetworkSecurityGroup -name $nsgName -ResourceGroupName $rgName -Location $location -SecurityRule $securityRules <-||-  <-||- 

        
         -||-> Assert-AreEqual $rgName $nsg.ResourceGroupName <-||- 
         -||-> Assert-AreEqual $nsgName $nsg.Name <-||- 
         -||-> Assert-NotNull $nsg.Location <-||- 
         -||-> Assert-NotNull $nsg.Etag <-||- 
         -||-> Assert-AreEqual 4 @( -||-> $nsg.SecurityRules <-||- ).Count <-||- 

         -||-> $securityRule =  -||-> @( -||-> $nsg.SecurityRules <-||- ) | Where-Object Name -eq $securityRuleNames[0] <-||-  <-||- 
         -||-> Assert-Null $securityRule.SourceAddressPrefix <-||- 
         -||-> Assert-Null $securityRule.DestinationAddressPrefix <-||- 
         -||-> Assert-AreEqual $asg.Id $securityRule.SourceApplicationSecurityGroups.Id <-||- 
         -||-> Assert-AreEqual $asg.Id $securityRule.DestinationApplicationSecurityGroups.Id <-||- 

         -||-> $securityRule =  -||-> @( -||-> $nsg.SecurityRules <-||- ) | Where-Object Name -eq $securityRuleNames[1] <-||-  <-||- 
         -||-> Assert-Null $securityRule.SourceAddressPrefix <-||- 
         -||-> Assert-AreEqual "*" $securityRule.DestinationAddressPrefix <-||- 
         -||-> Assert-AreEqual $asg.Id $securityRule.SourceApplicationSecurityGroups.Id <-||- 
         -||-> Assert-Null $securityRule.DestinationApplicationSecurityGroups <-||- 

         -||-> $securityRule =  -||-> @( -||-> $nsg.SecurityRules <-||- ) | Where-Object Name -eq $securityRuleNames[2] <-||-  <-||- 
         -||-> Assert-AreEqual "*" $securityRule.SourceAddressPrefix <-||- 
         -||-> Assert-Null $securityRule.DestinationAddressPrefix <-||- 
         -||-> Assert-Null $securityRule.SourceApplicationSecurityGroups <-||- 
         -||-> Assert-AreEqual $asg.Id $securityRule.DestinationApplicationSecurityGroups.Id <-||- 

         -||-> $securityRule =  -||-> @( -||-> $nsg.SecurityRules <-||- ) | Where-Object Name -eq $securityRuleNames[3] <-||-  <-||- 
         -||-> Assert-AreEqual "*" $securityRule.SourceAddressPrefix <-||- 
         -||-> Assert-AreEqual "*" $securityRule.DestinationAddressPrefix <-||- 
         -||-> Assert-Null $securityRule.SourceApplicationSecurityGroups <-||- 
         -||-> Assert-Null $securityRule.DestinationApplicationSecurityGroups <-||- 
    }
    finally
    {
        
         -||-> Clean-ResourceGroup $rgName <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-ApplicationSecurityGroupInAddedSecurityRule
{
    param([bool] $useIds = $false)

     -||-> $rgLocation =  -||-> Get-ProviderLocation ResourceManagement <-||-  <-||- 
     -||-> $resourceTypeParent = "Microsoft.Network/ApplicationSecurityGroups" <-||- 
     -||-> $location =  -||-> Get-ProviderLocation $resourceTypeParent <-||-  <-||- 

     -||-> $rgName =  -||-> Get-ResourceGroupName <-||-  <-||- 
     -||-> $asgName =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $nsgName =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $securityRuleNames = @( -||-> ( -||-> Get-ResourceName <-||- ), ( -||-> Get-ResourceName <-||- ), ( -||-> Get-ResourceName <-||- ), ( -||-> Get-ResourceName <-||- ) <-||- ) <-||- 

     -||-> try
    {
        
         -||-> $resourceGroup =  -||-> New-AzResourceGroup -Name $rgName -Location $location -Tags @{ testtag =  -||-> "ASG tag" <-||-  } <-||-  <-||- 

        
         -||-> $asg =  -||-> New-AzApplicationSecurityGroup -ResourceGroupName $rgName -Name $asgName -Location $rgLocation <-||-  <-||- 

        
         -||-> $nsg =  -||-> New-AzNetworkSecurityGroup -name $nsgName -ResourceGroupName $rgName -Location $location <-||-  <-||- 

         -||-> if ( -||-> $useIds <-||- )
        {
             -||-> Add-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg -Name $securityRuleNames[0] -Description "description" -Protocol Tcp -SourcePortRange "23-45" -DestinationPortRange "46-56" -SourceApplicationSecurityGroupId $asg.Id -DestinationApplicationSecurityGroupId $asg.Id -Access Allow -Priority 100 -Direction Inbound <-||- 
             -||-> Add-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg -Name $securityRuleNames[1] -Description "description" -Protocol Tcp -SourcePortRange "23-45" -DestinationPortRange "46-56" -SourceApplicationSecurityGroupId $asg.Id -DestinationAddressPrefix * -Access Allow -Priority 102 -Direction Inbound <-||- 
             -||-> Add-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg -Name $securityRuleNames[2] -Description "description" -Protocol Tcp -SourcePortRange "23-45" -DestinationPortRange "46-56" -SourceAddressPrefix * -DestinationApplicationSecurityGroupId $asg.Id -Access Allow -Priority 103 -Direction Inbound <-||- 
             -||-> Add-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg -Name $securityRuleNames[3] -Description "description" -Protocol Tcp -SourcePortRange "23-45" -DestinationPortRange "46-56" -SourceAddressPrefix * -DestinationAddressPrefix * -Access Allow -Priority 104 -Direction Inbound <-||- 
        }
        else
        {
             -||-> Add-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg -Name $securityRuleNames[0] -Description "description" -Protocol Tcp -SourcePortRange "23-45" -DestinationPortRange "46-56" -SourceApplicationSecurityGroup $asg -DestinationApplicationSecurityGroup $asg -Access Allow -Priority 100 -Direction Inbound <-||- 
             -||-> Add-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg -Name $securityRuleNames[1] -Description "description" -Protocol Tcp -SourcePortRange "23-45" -DestinationPortRange "46-56" -SourceApplicationSecurityGroup $asg -DestinationAddressPrefix * -Access Allow -Priority 102 -Direction Inbound <-||- 
             -||-> Add-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg -Name $securityRuleNames[2] -Description "description" -Protocol Tcp -SourcePortRange "23-45" -DestinationPortRange "46-56" -SourceAddressPrefix * -DestinationApplicationSecurityGroup $asg -Access Allow -Priority 103 -Direction Inbound <-||- 
             -||-> Add-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg -Name $securityRuleNames[3] -Description "description" -Protocol Tcp -SourcePortRange "23-45" -DestinationPortRange "46-56" -SourceAddressPrefix * -DestinationAddressPrefix * -Access Allow -Priority 104 -Direction Inbound <-||- 
        } <-||- 

         -||-> $securityRules =  -||-> Get-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg <-||-  <-||- 

        
         -||-> Assert-AreEqual 4 @( -||-> $securityRules <-||- ).Count <-||- 

         -||-> $securityRule =  -||-> @( -||-> $securityRules <-||- ) | Where-Object Name -eq $securityRuleNames[0] <-||-  <-||- 
         -||-> Assert-Null $securityRule.SourceAddressPrefix <-||- 
         -||-> Assert-Null $securityRule.DestinationAddressPrefix <-||- 
         -||-> Assert-AreEqual $asg.Id $securityRule.SourceApplicationSecurityGroups.Id <-||- 
         -||-> Assert-AreEqual $asg.Id $securityRule.DestinationApplicationSecurityGroups.Id <-||- 

         -||-> $securityRule =  -||-> @( -||-> $securityRules <-||- ) | Where-Object Name -eq $securityRuleNames[1] <-||-  <-||- 
         -||-> Assert-Null $securityRule.SourceAddressPrefix <-||- 
         -||-> Assert-AreEqual "*" $securityRule.DestinationAddressPrefix <-||- 
         -||-> Assert-AreEqual $asg.Id $securityRule.SourceApplicationSecurityGroups.Id <-||- 
         -||-> Assert-Null $securityRule.DestinationApplicationSecurityGroups <-||- 

         -||-> $securityRule =  -||-> @( -||-> $securityRules <-||- ) | Where-Object Name -eq $securityRuleNames[2] <-||-  <-||- 
         -||-> Assert-AreEqual "*" $securityRule.SourceAddressPrefix <-||- 
         -||-> Assert-Null $securityRule.DestinationAddressPrefix <-||- 
         -||-> Assert-Null $securityRule.SourceApplicationSecurityGroups <-||- 
         -||-> Assert-AreEqual $asg.Id $securityRule.DestinationApplicationSecurityGroups.Id <-||- 

         -||-> $securityRule =  -||-> @( -||-> $securityRules <-||- ) | Where-Object Name -eq $securityRuleNames[3] <-||-  <-||- 
         -||-> Assert-AreEqual "*" $securityRule.SourceAddressPrefix <-||- 
         -||-> Assert-AreEqual "*" $securityRule.DestinationAddressPrefix <-||- 
         -||-> Assert-Null $securityRule.SourceApplicationSecurityGroups <-||- 
         -||-> Assert-Null $securityRule.DestinationApplicationSecurityGroups <-||- 
    }
    finally
    {
        
         -||-> Clean-ResourceGroup $rgName <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-ApplicationSecurityGroupInSetSecurityRule
{
    param([bool] $useIds = $false)

     -||-> $rgLocation =  -||-> Get-ProviderLocation ResourceManagement <-||-  <-||- 
     -||-> $resourceTypeParent = "Microsoft.Network/ApplicationSecurityGroups" <-||- 
     -||-> $location =  -||-> Get-ProviderLocation $resourceTypeParent <-||-  <-||- 

     -||-> $rgName =  -||-> Get-ResourceGroupName <-||-  <-||- 
     -||-> $asgName =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $nsgName =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $securityRuleNames = @( -||-> ( -||-> Get-ResourceName <-||- ), ( -||-> Get-ResourceName <-||- ), ( -||-> Get-ResourceName <-||- ), ( -||-> Get-ResourceName <-||- ) <-||- ) <-||- 

     -||-> try
    {
         -||-> $resourceGroup =  -||-> New-AzResourceGroup -Name $rgName -Location $location -Tags @{ testtag =  -||-> "ASG tag" <-||-  } <-||-  <-||- 

         -||-> $asg =  -||-> New-AzApplicationSecurityGroup -ResourceGroupName $rgName -Name $asgName -Location $rgLocation <-||-  <-||- 

         -||-> $securityRules = @() <-||- 
         -||-> $securityRules +=  -||-> New-AzNetworkSecurityRuleConfig -Name $securityRuleNames[0] -Description "description" -Protocol Tcp -SourcePortRange "23-45" -DestinationPortRange "46-56" -SourceAddressPrefix * -DestinationAddressPrefix * -Access Allow -Priority 100 -Direction Inbound <-||-  <-||- 
         -||-> $securityRules +=  -||-> New-AzNetworkSecurityRuleConfig -Name $securityRuleNames[1] -Description "description" -Protocol Tcp -SourcePortRange "23-45" -DestinationPortRange "46-56" -SourceAddressPrefix * -DestinationAddressPrefix * -Access Allow -Priority 102 -Direction Inbound <-||-  <-||- 
         -||-> $securityRules +=  -||-> New-AzNetworkSecurityRuleConfig -Name $securityRuleNames[2] -Description "description" -Protocol Tcp -SourcePortRange "23-45" -DestinationPortRange "46-56" -SourceAddressPrefix * -DestinationAddressPrefix * -Access Allow -Priority 103 -Direction Inbound <-||-  <-||- 
        
         -||-> $nsg =  -||-> New-AzNetworkSecurityGroup -name $nsgName -ResourceGroupName $rgName -Location $location -SecurityRule $securityRules <-||-  <-||- 

         -||-> if ( -||-> $useIds <-||- )
        {
             -||-> Set-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg -Name $securityRuleNames[0] -Description "description" -Protocol Tcp -SourcePortRange "23-45" -DestinationPortRange "46-56" -SourceApplicationSecurityGroupId $asg.Id -DestinationApplicationSecurityGroupId $asg.Id -Access Allow -Priority 100 -Direction Inbound <-||- 
             -||-> Set-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg -Name $securityRuleNames[1] -Description "description" -Protocol Tcp -SourcePortRange "23-45" -DestinationPortRange "46-56" -SourceApplicationSecurityGroupId $asg.Id -DestinationAddressPrefix * -Access Allow -Priority 102 -Direction Inbound <-||- 
             -||-> Set-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg -Name $securityRuleNames[2] -Description "description" -Protocol Tcp -SourcePortRange "23-45" -DestinationPortRange "46-56" -SourceAddressPrefix * -DestinationApplicationSecurityGroupId $asg.Id -Access Allow -Priority 103 -Direction Inbound <-||- 
        }
        else
        {
             -||-> Set-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg  -Name $securityRuleNames[0] -Description "description" -Protocol Tcp -SourcePortRange "23-45" -DestinationPortRange "46-56" -SourceApplicationSecurityGroup $asg -DestinationApplicationSecurityGroup $asg -Access Allow -Priority 100 -Direction Inbound <-||- 
             -||-> Set-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg  -Name $securityRuleNames[1] -Description "description" -Protocol Tcp -SourcePortRange "23-45" -DestinationPortRange "46-56" -SourceApplicationSecurityGroup $asg -DestinationAddressPrefix * -Access Allow -Priority 102 -Direction Inbound <-||- 
             -||-> Set-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg  -Name $securityRuleNames[2] -Description "description" -Protocol Tcp -SourcePortRange "23-45" -DestinationPortRange "46-56" -SourceAddressPrefix * -DestinationApplicationSecurityGroup $asg -Access Allow -Priority 103 -Direction Inbound <-||- 
        } <-||- 

         -||-> $securityRules =  -||-> Get-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg <-||-  <-||- 

         -||-> $securityRule =  -||-> @( -||-> $securityRules <-||- ) | Where-Object Name -eq $securityRuleNames[0] <-||-  <-||- 
         -||-> Assert-Null $securityRule.SourceAddressPrefix <-||- 
         -||-> Assert-Null $securityRule.DestinationAddressPrefix <-||- 
         -||-> Assert-AreEqual $asg.Id $securityRule.SourceApplicationSecurityGroups.Id <-||- 
         -||-> Assert-AreEqual $asg.Id $securityRule.DestinationApplicationSecurityGroups.Id <-||- 

         -||-> $securityRule =  -||-> @( -||-> $securityRules <-||- ) | Where-Object Name -eq $securityRuleNames[1] <-||-  <-||- 
         -||-> Assert-Null $securityRule.SourceAddressPrefix <-||- 
         -||-> Assert-AreEqual "*" $securityRule.DestinationAddressPrefix <-||- 
         -||-> Assert-AreEqual $asg.Id $securityRule.SourceApplicationSecurityGroups.Id <-||- 
         -||-> Assert-Null $securityRule.DestinationApplicationSecurityGroups <-||- 

         -||-> $securityRule =  -||-> @( -||-> $securityRules <-||- ) | Where-Object Name -eq $securityRuleNames[2] <-||-  <-||- 
         -||-> Assert-AreEqual "*" $securityRule.SourceAddressPrefix <-||- 
         -||-> Assert-Null $securityRule.DestinationAddressPrefix <-||- 
         -||-> Assert-Null $securityRule.SourceApplicationSecurityGroups <-||- 
         -||-> Assert-AreEqual $asg.Id $securityRule.DestinationApplicationSecurityGroups.Id <-||- 
    }
    finally
    {
        
         -||-> Clean-ResourceGroup $rgName <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-ApplicationSecurityGroupInNewNetworkInterface
{
     -||-> $rgLocation =  -||-> Get-ProviderLocation ResourceManagement <-||-  <-||- 
     -||-> $resourceTypeParent = "Microsoft.Network/ApplicationSecurityGroups" <-||- 
     -||-> $location =  -||-> Get-ProviderLocation $resourceTypeParent <-||-  <-||- 

     -||-> $rgName =  -||-> Get-ResourceGroupName <-||-  <-||- 

     -||-> $asgName1 =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $asgName2 =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $asgName3 =  -||-> Get-ResourceName <-||-  <-||- 

     -||-> $vnetName =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $subnetName =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $nicName =  -||-> Get-ResourceName <-||-  <-||- 

     -||-> try
    {
         -||-> $resourceGroup =  -||-> New-AzResourceGroup -Name $rgName -Location $location -Tags @{ testtag =  -||-> "ASG tag" <-||-  } <-||-  <-||- 

         -||-> $asg1 =  -||-> New-AzApplicationSecurityGroup -ResourceGroupName $rgName -Name $asgName1 -Location $rgLocation <-||-  <-||- 
         -||-> $asg2 =  -||-> New-AzApplicationSecurityGroup -ResourceGroupName $rgName -Name $asgName2 -Location $rgLocation <-||-  <-||- 
         -||-> $asg3 =  -||-> New-AzApplicationSecurityGroup -ResourceGroupName $rgName -Name $asgName3 -Location $rgLocation <-||-  <-||- 

         -||-> $subnet =  -||-> New-AzVirtualNetworkSubnetConfig -Name $subnetName -AddressPrefix 10.0.1.0/24 <-||-  <-||- 
         -||-> $vnet =  -||-> New-AzVirtualNetwork -Name $vnetName -ResourceGroupName $rgName -Location $location -AddressPrefix 10.0.0.0/16 -Subnet $subnet <-||-  <-||- 

         -||-> $nic =  -||-> New-AzNetworkInterface -Name $nicName -ResourceGroupName $rgName -Location $location -Subnet $vnet.Subnets[0] -ApplicationSecurityGroup $asg1 <-||-  <-||- 

         -||-> Assert-AreEqual 1 @( -||-> $nic.IpConfigurations.ApplicationSecurityGroups <-||- ).Count <-||- 
         -||-> Assert-AreEqual $asg1.Id @( -||-> $nic.IpConfigurations.ApplicationSecurityGroups <-||- )[0].Id <-||- 

         -||-> $nic =  -||-> New-AzNetworkInterface -Name $nicName -ResourceGroupName $rgName -Location $location -Subnet $vnet.Subnets[0] -ApplicationSecurityGroup @( -||-> $asg2, $asg3 <-||- ) -Force <-||-  <-||- 

         -||-> Assert-AreEqual 2 @( -||-> $nic.IpConfigurations.ApplicationSecurityGroups <-||- ).Count <-||- 
         -||-> Assert-AreEqual $true ( -||-> @( -||-> $nic.IpConfigurations.ApplicationSecurityGroups.Id <-||- ) -contains $asg2.Id <-||- ) <-||- 
         -||-> Assert-AreEqual $true ( -||-> @( -||-> $nic.IpConfigurations.ApplicationSecurityGroups.Id <-||- ) -contains $asg3.Id <-||- ) <-||- 
    }
    finally
    {
        
         -||-> Clean-ResourceGroup $rgName <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-ApplicationSecurityGroupInNewNetworkInterfaceIpConfig
{
    param([bool] $useIds = $false)

     -||-> $rgLocation =  -||-> Get-ProviderLocation ResourceManagement <-||-  <-||- 
     -||-> $resourceTypeParent = "Microsoft.Network/ApplicationSecurityGroups" <-||- 
     -||-> $location =  -||-> Get-ProviderLocation $resourceTypeParent <-||-  <-||- 

     -||-> $rgName =  -||-> Get-ResourceGroupName <-||-  <-||- 

     -||-> $asgName1 =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $asgName2 =  -||-> Get-ResourceName <-||-  <-||- 

     -||-> $ipConfigName1 =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $ipConfigName2 =  -||-> Get-ResourceName <-||-  <-||- 

     -||-> $vnetName =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $subnetName =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $nicName =  -||-> Get-ResourceName <-||-  <-||- 

     -||-> try
    {
         -||-> $resourceGroup =  -||-> New-AzResourceGroup -Name $rgName -Location $location -Tags @{ testtag =  -||-> "ASG tag" <-||-  } <-||-  <-||- 

         -||-> $asg1 =  -||-> New-AzApplicationSecurityGroup -ResourceGroupName $rgName -Name $asgName1 -Location $rgLocation <-||-  <-||- 
         -||-> $asg2 =  -||-> New-AzApplicationSecurityGroup -ResourceGroupName $rgName -Name $asgName2 -Location $rgLocation <-||-  <-||- 

         -||-> $subnet =  -||-> New-AzVirtualNetworkSubnetConfig -Name $subnetName -AddressPrefix 10.0.1.0/24 <-||-  <-||- 
         -||-> $vnet =  -||-> New-AzVirtualNetwork -Name $vnetName -ResourceGroupName $rgName -Location $location -AddressPrefix 10.0.0.0/16 -Subnet $subnet <-||-  <-||- 

         -||-> if ( -||-> $useIds <-||- )
        {
             -||-> $ipConfig1 =  -||-> New-AzNetworkInterfaceIpConfig -Name $ipConfigName1 -SubnetId $vnet.Subnets[0].Id -ApplicationSecurityGroupId $asg1.Id -Primary <-||-  <-||- 
             -||-> $ipConfig2 =  -||-> New-AzNetworkInterfaceIpConfig -Name $ipConfigName2 -SubnetId $vnet.Subnets[0].Id -ApplicationSecurityGroupId $asg1.Id <-||-  <-||- 
        }
        else
        {
             -||-> $ipConfig1 =  -||-> New-AzNetworkInterfaceIpConfig -Name $ipConfigName1 -Subnet $vnet.Subnets[0] -ApplicationSecurityGroup $asg1 -Primary <-||-  <-||- 
             -||-> $ipConfig2 =  -||-> New-AzNetworkInterfaceIpConfig -Name $ipConfigName2 -Subnet $vnet.Subnets[0] -ApplicationSecurityGroup $asg1 <-||-  <-||- 
        } <-||- 

         -||-> $nic =  -||-> New-AzNetworkInterface -Name $nicName -ResourceGroupName $rgName -Location $location -IpConfiguration @( -||-> $ipConfig1, $ipConfig2 <-||- ) <-||-  <-||- 

         -||-> Assert-AreEqual 1 @( -||-> $nic.IpConfigurations[0].ApplicationSecurityGroups <-||- ).Count <-||- 
         -||-> Assert-AreEqual $asg1.Id @( -||-> $nic.IpConfigurations[0].ApplicationSecurityGroups <-||- ).Id <-||- 

         -||-> Assert-AreEqual 1 @( -||-> $nic.IpConfigurations[1].ApplicationSecurityGroups <-||- ).Count <-||- 
         -||-> Assert-AreEqual $asg1.Id @( -||-> $nic.IpConfigurations[1].ApplicationSecurityGroups <-||- ).Id <-||- 

         -||-> if ( -||-> $useIds <-||- )
        {
             -||-> $ipConfig1 =  -||-> New-AzNetworkInterfaceIpConfig -Name $ipConfigName1 -SubnetId $vnet.Subnets[0].Id -ApplicationSecurityGroupId ( -||-> $asg1.Id, $asg2.Id <-||- ) -Primary <-||-  <-||- 
             -||-> $ipConfig2 =  -||-> New-AzNetworkInterfaceIpConfig -Name $ipConfigName2 -SubnetId $vnet.Subnets[0].Id -ApplicationSecurityGroupId ( -||-> $asg1.Id, $asg2.Id <-||- ) <-||-  <-||- 
        }
        else
        {
             -||-> $ipConfig1 =  -||-> New-AzNetworkInterfaceIpConfig -Name $ipConfigName1 -Subnet $vnet.Subnets[0] -ApplicationSecurityGroup ( -||-> $asg1, $asg2 <-||- ) -Primary <-||-  <-||- 
             -||-> $ipConfig2 =  -||-> New-AzNetworkInterfaceIpConfig -Name $ipConfigName2 -Subnet $vnet.Subnets[0] -ApplicationSecurityGroup ( -||-> $asg1, $asg2 <-||- ) <-||-  <-||- 
        } <-||- 

         -||-> $nic =  -||-> New-AzNetworkInterface -Name $nicName -ResourceGroupName $rgName -Location $location -IpConfiguration @( -||-> $ipConfig1, $ipConfig2 <-||- ) -Force <-||-  <-||- 

         -||-> Assert-AreEqual 2 @( -||-> $nic.IpConfigurations[0].ApplicationSecurityGroups <-||- ).Count <-||- 
         -||-> Assert-AreEqual $true ( -||-> @( -||-> $nic.IpConfigurations[0].ApplicationSecurityGroups <-||- ).Id -contains $asg1.Id <-||- ) <-||- 
         -||-> Assert-AreEqual $true ( -||-> @( -||-> $nic.IpConfigurations[0].ApplicationSecurityGroups <-||- ).Id -contains $asg2.Id <-||- ) <-||- 

         -||-> Assert-AreEqual 2 @( -||-> $nic.IpConfigurations[1].ApplicationSecurityGroups <-||- ).Count <-||- 
         -||-> Assert-AreEqual $true ( -||-> @( -||-> $nic.IpConfigurations[1].ApplicationSecurityGroups <-||- ).Id -contains $asg1.Id <-||- ) <-||- 
         -||-> Assert-AreEqual $true ( -||-> @( -||-> $nic.IpConfigurations[1].ApplicationSecurityGroups <-||- ).Id -contains $asg2.Id <-||- ) <-||- 
    }
    finally
    {
        
         -||-> Clean-ResourceGroup $rgName <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-ApplicationSecurityGroupInAddedNetworkInterfaceIpConfig
{
    param([bool] $useIds = $false)

     -||-> $rgLocation =  -||-> Get-ProviderLocation ResourceManagement <-||-  <-||- 
     -||-> $resourceTypeParent = "Microsoft.Network/ApplicationSecurityGroups" <-||- 
     -||-> $location =  -||-> Get-ProviderLocation $resourceTypeParent <-||-  <-||- 

     -||-> $rgName =  -||-> Get-ResourceGroupName <-||-  <-||- 

     -||-> $asgName1 =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $asgName2 =  -||-> Get-ResourceName <-||-  <-||- 

     -||-> $ipConfigName1 =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $ipConfigName2 =  -||-> Get-ResourceName <-||-  <-||- 

     -||-> $vnetName =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $subnetName =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $nicName =  -||-> Get-ResourceName <-||-  <-||- 

     -||-> try
    {
         -||-> $resourceGroup =  -||-> New-AzResourceGroup -Name $rgName -Location $location -Tags @{ testtag =  -||-> "ASG tag" <-||-  } <-||-  <-||- 

         -||-> $asg1 =  -||-> New-AzApplicationSecurityGroup -ResourceGroupName $rgName -Name $asgName1 -Location $rgLocation <-||-  <-||- 
         -||-> $asg2 =  -||-> New-AzApplicationSecurityGroup -ResourceGroupName $rgName -Name $asgName2 -Location $rgLocation <-||-  <-||- 

         -||-> $subnet =  -||-> New-AzVirtualNetworkSubnetConfig -Name $subnetName -AddressPrefix 10.0.1.0/24 <-||-  <-||- 
         -||-> $vnet =  -||-> New-AzVirtualNetwork -Name $vnetName -ResourceGroupName $rgName -Location $location -AddressPrefix 10.0.0.0/16 -Subnet $subnet <-||-  <-||- 

         -||-> $nic =  -||-> New-AzNetworkInterface -Name $nicName -ResourceGroupName $rgName -Location $location  -Subnet $vnet.Subnets[0] <-||-  <-||- 

         -||-> if ( -||-> $useIds <-||- )
        {
             -||-> $ipconfigSet =  -||-> Set-AzNetworkInterfaceIpConfig -NetworkInterface $nic -Name $nic.IpConfigurations[0].Name -SubnetId $vnet.Subnets[0].Id -ApplicationSecurityGroupId $asg1.Id -Primary <-||-  <-||- 
             -||-> $ipConfig1 =  -||-> Add-AzNetworkInterfaceIpConfig -NetworkInterface $nic -Name $ipConfigName1 -SubnetId $vnet.Subnets[0].Id -ApplicationSecurityGroupId $asg1.Id  | Set-AzNetworkInterface <-||-  <-||- 
             -||-> $ipConfig2 =  -||-> Add-AzNetworkInterfaceIpConfig -NetworkInterface $nic -Name $ipConfigName2 -SubnetId $vnet.Subnets[0].Id -ApplicationSecurityGroupId $asg1.Id  | Set-AzNetworkInterface <-||-  <-||- 
        }
        else
        {
             -||-> $ipconfigSet =  -||-> Set-AzNetworkInterfaceIpConfig -NetworkInterface $nic -Name $nic.IpConfigurations[0].Name -Subnet $vnet.Subnets[0] -ApplicationSecurityGroup $asg1 -Primary <-||-  <-||- 
             -||-> $ipConfig1 =  -||-> Add-AzNetworkInterfaceIpConfig -NetworkInterface $nic -Name $ipConfigName1 -Subnet $vnet.Subnets[0] -ApplicationSecurityGroup $asg1  | Set-AzNetworkInterface <-||-  <-||- 
             -||-> $ipConfig2 =  -||-> Add-AzNetworkInterfaceIpConfig -NetworkInterface $nic -Name $ipConfigName2 -Subnet $vnet.Subnets[0] -ApplicationSecurityGroup $asg1  | Set-AzNetworkInterface <-||-  <-||- 
        } <-||- 

         -||-> $nic =  -||-> Get-AzNetworkInterface -Name $nicName -ResourceGroupName $rgName <-||-  <-||- 

         -||-> Assert-AreEqual 3 @( -||-> $nic.IpConfigurations <-||- ).Count <-||- 

         -||-> Assert-AreEqual 1 @( -||-> $nic.IpConfigurations[0].ApplicationSecurityGroups <-||- ).Count <-||- 
         -||-> Assert-AreEqual 1 @( -||-> $nic.IpConfigurations[1].ApplicationSecurityGroups <-||- ).Count <-||- 
         -||-> Assert-AreEqual 1 @( -||-> $nic.IpConfigurations[2].ApplicationSecurityGroups <-||- ).Count <-||- 

         -||-> Assert-AreEqual $asg1.Id @( -||-> $nic.IpConfigurations[0].ApplicationSecurityGroups <-||- ).Id <-||- 
         -||-> Assert-AreEqual $asg1.Id @( -||-> $nic.IpConfigurations[1].ApplicationSecurityGroups <-||- ).Id <-||- 
         -||-> Assert-AreEqual $asg1.Id @( -||-> $nic.IpConfigurations[2].ApplicationSecurityGroups <-||- ).Id <-||- 

         -||-> $nic =  -||-> New-AzNetworkInterface -Name $nicName -ResourceGroupName $rgName -Location $location  -Subnet $vnet.Subnets[0] -Force <-||-  <-||- 

         -||-> if ( -||-> $useIds <-||- )
        {
             -||-> $ipconfigSet =  -||-> Set-AzNetworkInterfaceIpConfig -NetworkInterface $nic -Name $nic.IpConfigurations[0].Name -SubnetId $vnet.Subnets[0].Id -ApplicationSecurityGroupId @( -||-> $asg1.Id, $asg2.Id <-||- ) -Primary <-||-  <-||- 
             -||-> $ipConfig1 =  -||-> Add-AzNetworkInterfaceIpConfig -NetworkInterface $nic -Name $ipConfigName1 -SubnetId $vnet.Subnets[0].Id -ApplicationSecurityGroupId @( -||-> $asg1.Id, $asg2.Id <-||- ) | Set-AzNetworkInterface <-||-  <-||- 
             -||-> $ipConfig2 =  -||-> Add-AzNetworkInterfaceIpConfig -NetworkInterface $nic -Name $ipConfigName2 -SubnetId $vnet.Subnets[0].Id -ApplicationSecurityGroupId @( -||-> $asg1.Id, $asg2.Id <-||- ) | Set-AzNetworkInterface <-||-  <-||- 
        }
        else
        {
             -||-> $ipconfigSet =  -||-> Set-AzNetworkInterfaceIpConfig -NetworkInterface $nic -Name $nic.IpConfigurations[0].Name -Subnet $vnet.Subnets[0] -ApplicationSecurityGroup @( -||-> $asg1, $asg2 <-||- ) -Primary <-||-  <-||- 
             -||-> $ipConfig1 =  -||-> Add-AzNetworkInterfaceIpConfig -NetworkInterface $nic -Name $ipConfigName1 -Subnet $vnet.Subnets[0] -ApplicationSecurityGroup @( -||-> $asg1, $asg2 <-||- ) | Set-AzNetworkInterface <-||-  <-||- 
             -||-> $ipConfig2 =  -||-> Add-AzNetworkInterfaceIpConfig -NetworkInterface $nic -Name $ipConfigName2 -Subnet $vnet.Subnets[0] -ApplicationSecurityGroup @( -||-> $asg1, $asg2 <-||- ) | Set-AzNetworkInterface <-||-  <-||- 
        } <-||- 

         -||-> $nic =  -||-> Get-AzNetworkInterface -Name $nicName -ResourceGroupName $rgName <-||-  <-||- 

         -||-> Assert-AreEqual 3 @( -||-> $nic.IpConfigurations <-||- ).Count <-||- 

         -||-> Assert-AreEqual 2 @( -||-> $nic.IpConfigurations[0].ApplicationSecurityGroups <-||- ).Count <-||- 
         -||-> Assert-AreEqual 2 @( -||-> $nic.IpConfigurations[1].ApplicationSecurityGroups <-||- ).Count <-||- 
         -||-> Assert-AreEqual 2 @( -||-> $nic.IpConfigurations[2].ApplicationSecurityGroups <-||- ).Count <-||- 

         -||-> Assert-AreEqual $true ( -||-> @( -||-> $nic.IpConfigurations[0].ApplicationSecurityGroups <-||- ).Id -contains $asg1.Id <-||- ) <-||- 
         -||-> Assert-AreEqual $true ( -||-> @( -||-> $nic.IpConfigurations[1].ApplicationSecurityGroups <-||- ).Id -contains $asg1.Id <-||- ) <-||- 
         -||-> Assert-AreEqual $true ( -||-> @( -||-> $nic.IpConfigurations[2].ApplicationSecurityGroups <-||- ).Id -contains $asg1.Id <-||- ) <-||- 

         -||-> Assert-AreEqual $true ( -||-> @( -||-> $nic.IpConfigurations[0].ApplicationSecurityGroups <-||- ).Id -contains $asg2.Id <-||- ) <-||- 
         -||-> Assert-AreEqual $true ( -||-> @( -||-> $nic.IpConfigurations[1].ApplicationSecurityGroups <-||- ).Id -contains $asg2.Id <-||- ) <-||- 
         -||-> Assert-AreEqual $true ( -||-> @( -||-> $nic.IpConfigurations[2].ApplicationSecurityGroups <-||- ).Id -contains $asg2.Id <-||- ) <-||- 
    }
    finally
    {
        
         -||-> Clean-ResourceGroup $rgName <-||- 
    } <-||- 
} <-||- 


