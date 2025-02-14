















 -||-> function Get-AllSecretPermissions 
{
    return  -||-> @(
         -||-> "get",
        "list",
        "set",
        "delete",
        "backup",
        "restore",
        "recover" <-||- 
    ) <-||- 
} <-||- 

 -||-> function Get-AllKeyPermissions
{
    return  -||-> @(
         -||-> "get",
        "create",
        "delete",
        "list",
        "update",
        "import",
        "backup",
        "restore",
        "recover",
        "sign", 
        "verify", 
        "wrapKey",
        "unwrapKey", 
        "encrypt", 
        "decrypt" <-||- 
    ) <-||- 
} <-||- 

 -||-> function Get-AllCertPermissions
{
    return  -||-> @(
         -||-> "get",
        "delete",
        "list",
        "create",
        "import",
        "update",
        "deleteissuers",
        "getissuers",
        "listissuers",
        "managecontacts", 
        "manageissuers", 
        "setissuers",
        "recover" <-||- 
    ) <-||- 
} <-||- 

 -||-> function Get-AllStoragePermissions
{
    return  -||-> @(
          -||-> "delete",
         "deletesas",
         "get",
         "getsas",
         "list",
         "listsas",
         "regeneratekey",
         "set",
         "setsas",
         "update" <-||- 
    ) <-||- 
} <-||- 


 -||-> function Test-CreateNewVault
{
	 -||-> $rgName =  -||-> getAssetName <-||-  <-||- 
	 -||-> $unknownRGName =  -||-> getAssetName <-||-  <-||- 
	 -||-> $vault1Name =  -||-> getAssetName <-||-  <-||- 
	 -||-> $vault2Name =  -||-> getAssetName <-||-  <-||- 
	 -||-> $vault3Name =  -||-> getAssetName <-||-  <-||- 
	 -||-> $vault4Name =  -||-> getAssetName <-||-  <-||- 
	 -||-> $vault5Name =  -||-> getAssetName <-||-  <-||- 
	 -||-> $rgLocation =  -||-> Get-Location "Microsoft.Resources" "resourceGroups" "West US" <-||-  <-||- 
	 -||-> $vaultLocation =  -||-> Get-Location "Microsoft.KeyVault" "vault" "West US" <-||-  <-||- 
	 -||-> $tagKey = "asdf" <-||- 
	 -||-> $tagValue = "qwerty" <-||- 
	 -||-> New-AzResourceGroup -Name $rgName -Location $rgLocation <-||- 

	 -||-> try
	{
		 -||-> $actual =  -||-> New-AzKeyVault -VaultName $vault1Name -ResourceGroupName $rgName -Location $vaultLocation -Tag @{$tagKey =  -||-> $tagValue <-||- } <-||-  <-||- 
		 -||-> Assert-AreEqual $vault1Name $actual.VaultName <-||- 
		 -||-> Assert-AreEqual $rgName $actual.ResourceGroupName <-||- 
		 -||-> Assert-AreEqual $vaultLocation $actual.Location <-||- 
		 -||-> Assert-AreEqual $actual.Tags.Count 1 <-||- 
		 -||-> Assert-AreEqual $actual.Tags.ContainsKey($tagKey) $true <-||- 
		 -||-> Assert-AreEqual $actual.Tags.ContainsValue($tagValue) $true <-||- 
		 -||-> Assert-AreEqual "Standard" $actual.Sku <-||- 
		 -||-> Assert-AreEqual $false $actual.EnabledForDeployment <-||- 
		
		 -||-> Assert-AreEqual 0 @( -||-> $actual.AccessPolicies <-||- ).Count <-||- 

		
		 -||-> $actual =  -||-> New-AzKeyVault -VaultName $vault2Name -ResourceGroupName $rgName -Location $vaultLocation -Sku premium -EnabledForDeployment <-||-  <-||- 
		 -||-> Assert-AreEqual $vault2Name $actual.VaultName <-||- 
		 -||-> Assert-AreEqual $rgName $actual.ResourceGroupName <-||- 
		 -||-> Assert-AreEqual $vaultLocation $actual.Location <-||- 
		 -||-> Assert-AreEqual "Premium" $actual.Sku <-||- 
		 -||-> Assert-AreEqual $true $actual.EnabledForDeployment <-||- 
		 -||-> Assert-AreEqual 0 @( -||-> $actual.AccessPolicies <-||- ).Count <-||- 

		
		 -||-> $actual =  -||-> New-AzKeyVault -VaultName $vault3Name -ResourceGroupName $rgName -Location $vaultLocation -Sku standard -EnableSoftDelete <-||-  <-||- 
		 -||-> Assert-AreEqual $vault3Name $actual.VaultName <-||- 
		 -||-> Assert-AreEqual $rgName $actual.ResourceGroupName <-||- 
		 -||-> Assert-AreEqual $vaultLocation $actual.Location <-||- 
		 -||-> Assert-AreEqual "Standard" $actual.Sku <-||- 
		 -||-> Assert-AreEqual $true $actual.EnableSoftDelete <-||- 
		 -||-> Assert-AreEqual 0 @( -||-> $actual.AccessPolicies <-||- ).Count <-||- 

		
		 -||-> $actual =  -||-> New-AzKeyVault $vault4Name $rgName $vaultLocation <-||-  <-||- 
		 -||-> Assert-NotNull $actual <-||- 

		
		 -||-> Assert-Throws {  -||-> New-AzKeyVault -VaultName $vault1Name -ResourceGroupName $rgname -Location $vaultLocation <-||-  } <-||- 

		
		 -||-> Assert-Throws {  -||-> New-AzKeyVault -VaultName $vault5Name -ResourceGroupName $unknownRGName -Location $vaultLocation <-||-  } <-||- 
	}

	finally
	{
		 -||-> Remove-AzResourceGroup -Name $rgName -Force <-||- 
	} <-||- 
} <-||- 






 -||-> function Test-RecoverDeletedVault
{
    Param($rgName, $location)

    
     -||-> $vaultname =  -||-> Get-VaultName <-||-  <-||- 

    
     -||-> $vault =  -||-> New-AzKeyVault -VaultName $vaultName -ResourceGroupName $rgname -Location $location -Sku standard -EnableSoftDelete -Tag @{"x"=  -||-> "y" <-||- } <-||-  <-||- 

    
     -||-> Assert-AreEqual $vaultName $vault.VaultName <-||- 
     -||-> Assert-AreEqual $rgname $vault.ResourceGroupName <-||- 
     -||-> Assert-AreEqual $location $vault.Location <-||- 
     -||-> Assert-AreEqual "Standard" $vault.Sku <-||- 
     -||-> Assert-True {  -||-> $vault.EnableSoftDelete <-||-  } <-||- 
     -||-> Assert-AreEqual $vault.Tags.Count 1 <-||- 
     -||-> Assert-True {  -||-> $vault.Tags.ContainsKey("x") <-||-  } <-||- 
     -||-> Assert-True {  -||-> $vault.Tags.ContainsValue("y") <-||-  } <-||- 

     -||-> if ( -||-> $global:noADCmdLetMode <-||- ) {return;} <-||- 
     -||-> Assert-AreEqual 1 @( -||-> $vault.AccessPolicies <-||- ).Count <-||- 

    
     -||-> Remove-AzKeyVault -VaultName $vaultName -ResourceGroupName $rgname -Force -Confirm:$false <-||- 

     -||-> $allDeletedVault =  -||-> Get-AzKeyVault -InRemovedState <-||-  <-||- 
     -||-> Assert-True {  -||-> $allDeletedVault.Count -gt 0 <-||-  } <-||- 

     -||-> $deletedVault =  -||-> Get-AzKeyVault -VaultName  $vaultName -Location $location -InRemovedState <-||-  <-||- 
     -||-> Assert-AreEqual $vaultName $deletedVault.VaultName <-||- 
     -||-> Assert-AreEqual $location $deletedVault.Location <-||- 
     -||-> Assert-AreEqual "Standard" $vault.Sku <-||- 
     -||-> Assert-NotNull $deletedVault.DeletionDate <-||- 
     -||-> Assert-NotNull $deletedVault.ScheduledPurgeDate <-||- 
     -||-> Assert-AreEqual $deletedVault.Tags.Count 1 <-||- 
     -||-> Assert-True {  -||-> $deletedVault.Tags.ContainsKey("x") <-||-  } <-||- 
     -||-> Assert-True {  -||-> $deletedVault.Tags.ContainsValue("y") <-||-  } <-||- 

     -||-> $recoveredVault =  -||-> Undo-AzKeyVaultRemoval -VaultName $vaultName -ResourceGroupName $rgname -Location $location -Tag @{"m"=  -||-> "n" <-||- } <-||-  <-||- 
     -||-> Compare-Vaults $vault $recoveredVault <-||- 
    
     -||-> Assert-AreEqual $recoveredVault.Tags.Count 1 <-||- 
     -||-> Assert-True {  -||-> $recoveredVault.Tags.ContainsKey("m") <-||-  } <-||- 
     -||-> Assert-True {  -||-> $recoveredVault.Tags.ContainsValue("n") <-||-  } <-||- 
} <-||- 


 -||-> function Test-GetNoneexistingDeletedVault
{
     -||-> $deletedVault =  -||-> Get-AzKeyVault -VaultName  'non-existing' -Location 'eastus2' -InRemovedState <-||-  <-||- 
     -||-> Assert-Null $deletedVault <-||- 
} <-||- 


 -||-> function Test-PurgeDeletedVault
{
    Param($rgName, $location)

    
     -||-> $vaultname =  -||-> Get-VaultName <-||-  <-||- 

    
     -||-> New-AzKeyVault -VaultName $vaultName -ResourceGroupName $rgname -Location $location -Sku standard -EnableSoftDelete -Tag @{"x"=  -||-> "y" <-||- } <-||- 
     -||-> Remove-AzKeyVault -VaultName $vaultName -ResourceGroupName $rgname -Force -Confirm:$false <-||- 
     -||-> Remove-AzKeyVault -VaultName $vaultName -Location $location -Force -Confirm:$false -InRemovedState <-||- 

     -||-> $deletedVault =  -||-> Get-AzKeyVault -VaultName  $vaultName -Location $location -InRemovedState <-||-  <-||- 
     -||-> Assert-Null $deletedVault <-||- 
} <-||- 




 -||-> function Test-GetVault
{
	 -||-> $rgName =  -||-> getAssetName <-||-  <-||- 
	 -||-> $vaultName =  -||-> getAssetName <-||-  <-||- 
	 -||-> $rgLocation =  -||-> Get-Location "Microsoft.Resources" "resourceGroups" "West US" <-||-  <-||- 
	 -||-> $vaultLocation =  -||-> Get-Location "Microsoft.KeyVault" "vault" "West US" <-||-  <-||- 
	 -||-> New-AzResourceGroup -Name $rgName -Location $rgLocation <-||- 

	 -||-> try
	{
		 -||-> New-AzKeyVault -Name $vaultName -ResourceGroupName $rgName -Location $vaultLocation <-||- 
		 -||-> $got =  -||-> Get-AzKeyVault -VaultName $vaultName -ResourceGroupName $rgName <-||-  <-||- 

		 -||-> Assert-NotNull $got <-||- 
		 -||-> Assert-AreEqual $got.Location $vaultLocation <-||- 
		 -||-> Assert-AreEqual $got.ResourceGroupName $rgName <-||- 
		 -||-> Assert-AreEqual $got.VaultName $vaultName <-||- 

		 -||-> $got =  -||-> Get-AzKeyVault -VaultName $vaultName <-||-  <-||- 

		 -||-> Assert-NotNull $got <-||- 
		 -||-> Assert-AreEqual $got.Location $vaultLocation <-||- 
		 -||-> Assert-AreEqual $got.ResourceGroupName $rgName <-||- 
		 -||-> Assert-AreEqual $got.VaultName $vaultName <-||- 

		 -||-> $got =  -||-> Get-AzKeyVault -VaultName $vaultName.toUpper() <-||-  <-||- 

		 -||-> Assert-NotNull $got <-||- 
		 -||-> Assert-AreEqual $got.Location $vaultLocation <-||- 
		 -||-> Assert-AreEqual $got.ResourceGroupName $rgName <-||- 
		 -||-> Assert-AreEqual $got.VaultName $vaultName <-||- 

		 -||-> $unknownVault =  -||-> getAssetName <-||-  <-||- 
		 -||-> $unknownRG =  -||-> getAssetName <-||-  <-||- 

		 -||-> $unknown =  -||-> Get-AzKeyVault -VaultName $vaultName -ResourceGroupName $unknownRG <-||-  <-||- 
		 -||-> Assert-Null $unknown <-||- 

		 -||-> $unknown =  -||-> Get-AzKeyVault -VaultName $unknownVault -ResourceGroupName $rgName <-||-  <-||- 
		 -||-> Assert-Null $unknown <-||- 
	}

	finally
	{
		 -||-> Remove-AzResourceGroup -Name $rgName -Force <-||- 
	} <-||- 
} <-||- 

 -||-> function Test-ListVaults
{
	 -||-> $rgName =  -||-> getAssetName <-||-  <-||- 
	 -||-> $vault1Name =  -||-> getAssetName <-||-  <-||- 
	 -||-> $vault2Name =  -||-> getAssetName <-||-  <-||- 
	 -||-> $rgLocation =  -||-> Get-Location "Microsoft.Resources" "resourceGroups" "West US" <-||-  <-||- 
	 -||-> $vaultLocation =  -||-> Get-Location "Microsoft.KeyVault" "vault" "West US" <-||-  <-||- 
	 -||-> $tag = @{"abcdefg"= -||-> "bcdefgh" <-||- } <-||- 

	 -||-> New-AzResourceGroup -Name $rgName -Location $rgLocation <-||- 
	
	 -||-> try
	{
		 -||-> New-AzKeyVault -Name $vault1Name -ResourceGroupName $rgName -Location $vaultLocation <-||- 
		 -||-> New-AzKeyVault -Name $vault2Name -ResourceGroupName $rgName -Location $vaultLocation -Tag $tag <-||- 

		 -||-> $list =  -||-> Get-AzKeyVault <-||-  <-||- 
		 -||-> Assert-NotNull $list <-||- 
		 -||-> Assert-True {  -||-> $list.Count -gt 1 <-||-  } <-||- 
		 -||-> foreach($v in  -||-> $list <-||- )
		{
			 -||-> Assert-NotNull $v.VaultName <-||- 
			 -||-> Assert-NotNull $v.ResourceGroupName <-||- 
		} <-||- 

		 -||-> $list =  -||-> Get-AzKeyVault -ResourceGroupName $rgName <-||-  <-||- 
		 -||-> Assert-NotNull $list <-||- 
		 -||-> Assert-True {  -||-> $list.Count -eq 2 <-||-  } <-||- 
		 -||-> foreach($v in  -||-> $list <-||- )
		{
			 -||-> Assert-NotNull $v.VaultName <-||- 
			 -||-> Assert-AreEqual $rgName $v.ResourceGroupName <-||- 
			 -||-> Assert-AreEqual ( -||-> Normalize-Location $vaultLocation <-||- ) ( -||-> Normalize-Location $v.Location <-||- ) <-||- 
		} <-||- 

		 -||-> $list =  -||-> Get-AzKeyVault -ResourceGroupName $rgName -VaultName * <-||-  <-||- 
		 -||-> Assert-NotNull $list <-||- 
		 -||-> Assert-True {  -||-> $list.Count -eq 2 <-||-  } <-||- 
		 -||-> foreach($v in  -||-> $list <-||- )
		{
			 -||-> Assert-NotNull $v.VaultName <-||- 
			 -||-> Assert-AreEqual $rgName $v.ResourceGroupName <-||- 
			 -||-> Assert-AreEqual ( -||-> Normalize-Location $vaultLocation <-||- ) ( -||-> Normalize-Location $v.Location <-||- ) <-||- 
		} <-||- 

		 -||-> $list =  -||-> Get-AzKeyVault -ResourceGroupName * -VaultName * <-||-  <-||- 
		 -||-> Assert-NotNull $list <-||- 
		 -||-> Assert-True {  -||-> $list.Count -gt 1 <-||-  } <-||- 
		 -||-> foreach($v in  -||-> $list <-||- )
		{
			 -||-> Assert-NotNull $v.VaultName <-||- 
			 -||-> Assert-NotNull $v.ResourceGroupName <-||- 
		} <-||- 

		 -||-> $list =  -||-> Get-AzKeyVault -ResourceGroupName * -VaultName $vault1Name <-||-  <-||- 
		 -||-> Assert-NotNull $list <-||- 
		 -||-> Assert-True {  -||-> $list.Count -eq 1 <-||-  } <-||- 
		 -||-> foreach($v in  -||-> $list <-||- )
		{
			 -||-> Assert-NotNull $v.VaultName <-||- 
			 -||-> Assert-AreEqual $rgName $v.ResourceGroupName <-||- 
			 -||-> Assert-AreEqual ( -||-> Normalize-Location $vaultLocation <-||- ) ( -||-> Normalize-Location $v.Location <-||- ) <-||- 
		} <-||- 

		 -||-> $list =  -||-> Get-AzKeyVault -VaultName * <-||-  <-||- 
		 -||-> Assert-NotNull $list <-||- 
		 -||-> Assert-True {  -||-> $list.Count -gt 1 <-||-  } <-||- 
		 -||-> foreach($v in  -||-> $list <-||- )
		{
			 -||-> Assert-NotNull $v.VaultName <-||- 
			 -||-> Assert-NotNull $v.ResourceGroupName <-||- 
		} <-||- 

		 -||-> $list =  -||-> Get-AzKeyVault -Tag $tag <-||-  <-||- 
		 -||-> Assert-NotNull $list <-||- 
		 -||-> Assert-True {  -||-> $list.Count -eq 1 <-||-  } <-||- 
		 -||-> Assert-AreEqual $list[0].Tags.Keys[0] $tag.Keys[0] <-||- 
		 -||-> Assert-AreEqual $list.Tags[$list[0].Tags.Keys[0]] $tag[$tag.Keys[0]] <-||- 

		 -||-> $unknownRg =  -||-> getAssetName <-||-  <-||- 
		 -||-> Assert-Throws {  -||-> Get-AzKeyVault -ResourceGroupName $unknownRg <-||-  } <-||- 
	}
    
	finally
	{
		 -||-> Remove-AzResourceGroup -Name $rgName -Force <-||- 
	} <-||- 
} <-||- 




 -||-> function Test-DeleteVaultByName
{
	 -||-> $rgName =  -||-> getAssetName <-||-  <-||- 
	 -||-> $vaultName =  -||-> getAssetName <-||-  <-||- 
	 -||-> $rgLocation =  -||-> Get-Location "Microsoft.Resources" "resourceGroups" "West US" <-||-  <-||- 
	 -||-> $vaultLocation =  -||-> Get-Location "Microsoft.KeyVault" "vault" "West US" <-||-  <-||- 
	 -||-> $tag = @{"abcdefg"= -||-> "bcdefgh" <-||- } <-||- 

	 -||-> New-AzResourceGroup -Name $rgName -Location $rgLocation <-||- 

	 -||-> try
	{
		 -||-> New-AzKeyVault -VaultName $vaultName -ResourceGroupName $rgname -Location $vaultLocation <-||- 

		 -||-> Remove-AzKeyVault -VaultName $vaultName -Force <-||- 

		 -||-> $deletedVault =  -||-> Get-AzKeyVault -VaultName $vaultName -ResourceGroupName $rgName <-||-  <-||- 
		 -||-> Assert-Null $deletedVault <-||- 

		
		 -||-> New-AzKeyVault -VaultName $vaultName -ResourceGroupName $rgname -Location $vaultLocation <-||- 
		
		 -||-> Get-AzKeyVault -VaultName $vaultName | Remove-AzKeyVault -Force <-||- 

		 -||-> $deletedVault =  -||-> Get-AzKeyVault -VaultName $vaultName -ResourceGroupName $rgName <-||-  <-||- 
		 -||-> Assert-Null $deletedVault <-||- 

		
		 -||-> $job =  -||-> Remove-AzKeyVault -VaultName $vaultName -AsJob <-||-  <-||- 
		 -||-> $job | Wait-Job <-||- 

		 -||-> Assert-Throws {  -||-> $job | Receive-Job <-||-  } <-||- 
	}
	
	finally
	{
		 -||-> Remove-AzResourceGroup -Name $rgName -Force <-||- 
	} <-||- 
} <-||- 





 -||-> function Test-SetRemoveAccessPolicyByUPN
{
    Param($existingVaultName, $rgName, $upn)

     -||-> $PermToKeys = @( -||-> "encrypt", "decrypt", "unwrapKey", "wrapKey", "verify", "sign", "get", "list", "update", "create", "import", "delete", "backup", "restore" <-||- ) <-||- 
     -||-> $PermToSecrets = @( -||-> "get", "list", "set", "delete", "backup", "restore" <-||- ) <-||- 
     -||-> $PermToCertificates = @( -||-> "get", "list", "create", "delete" <-||- ) <-||- 
     -||-> $PermToStorage = @( -||-> "get", "list", "delete" <-||- ) <-||- 
     -||-> $vault =  -||-> Set-AzKeyVaultAccessPolicy -VaultName $existingVaultName -ResourceGroupName $rgName -UserPrincipalName $upn -PermissionsToKeys $PermToKeys -PermissionsToSecrets $PermToSecrets -PermissionsToCertificates $PermToCertificates -PermissionsToStorage $PermToStorage -PassThru <-||-  <-||- 
    
     -||-> CheckVaultAccessPolicy $vault $PermToKeys $PermToSecrets $PermToCertificates $PermToStorage <-||- 
     -||-> if ( -||-> -not $global:noADCmdLetMode <-||- ) {
         -||-> Assert-AreEqual $upn ( -||-> Get-AzADUser -ObjectId $vault.AccessPolicies[0].ObjectId <-||- )[0].UserPrincipalName <-||- 
    } <-||- 

     -||-> $vault =  -||-> Remove-AzKeyVaultAccessPolicy -VaultName $existingVaultName -ResourceGroupName $rgName -UserPrincipalName $upn -PassThru <-||-  <-||- 
     -||-> Assert-AreEqual 0 $vault.AccessPolicies.Count <-||- 
} <-||- 

 -||-> function Test-SetRemoveAccessPolicyByEmailAddress
{
    Param($existingVaultName, $rgName, $email, $upn)

     -||-> $PermToKeys = @( -||-> "encrypt", "decrypt", "unwrapKey", "wrapKey", "verify", "sign", "get", "list", "update", "create", "import", "delete", "backup", "restore" <-||- ) <-||- 
     -||-> $PermToSecrets = @( -||-> "get", "list", "set", "delete" <-||- ) <-||- 
     -||-> $PermToCertificates = @( -||-> "get", "list", "create", "delete" <-||- ) <-||- 
     -||-> $PermToStorage = @( -||-> "get", "list", "delete" <-||- ) <-||- 

     -||-> $vault =  -||-> Set-AzKeyVaultAccessPolicy -VaultName $existingVaultName -ResourceGroupName $rgName -EmailAddress $email -PermissionsToKeys $PermToKeys -PermissionsToSecrets $PermToSecrets -PermissionsToCertificates $PermToCertificates -PermissionsToStorage $PermToStorage -PassThru <-||-  <-||- 

     -||-> CheckVaultAccessPolicy $vault $PermToKeys $PermToSecrets $PermToCertificates $PermToStorage <-||- 
     -||-> if ( -||-> -not $global:noADCmdLetMode <-||- ) {
         -||-> Assert-AreEqual  $vault.AccessPolicies[0].ObjectId ( -||-> Get-AzADUser -Mail $upn <-||- ).Id <-||- 
    } <-||- 

     -||-> $vault =  -||-> Remove-AzKeyVaultAccessPolicy -VaultName $existingVaultName -ResourceGroupName $rgName -EmailAddress $email -PassThru <-||-  <-||- 
     -||-> Assert-AreEqual 0 $vault.AccessPolicies.Count <-||- 
} <-||- 

 -||-> function Test-SetRemoveAccessPolicyBySPN
{
    Param($existingVaultName, $rgName, $spn)

     -||-> $PermToKeys = @() <-||- 
     -||-> $PermToSecrets = @( -||-> "get", "set", "list" <-||- ) <-||- 
     -||-> $PermToCertificates = @( -||-> "get", "import" <-||- ) <-||- 
     -||-> $PermToStorage = @( -||-> "get", "list" <-||- ) <-||- 
    
     -||-> $setAccessPolicyFunc = {  -||-> Set-AzKeyVaultAccessPolicy -VaultName $existingVaultName -ResourceGroupName $rgName -ServicePrincipalName $spn -PermissionsToKeys $PermToKeys -PermissionsToSecrets $PermToSecrets -PermissionsToCertificates $PermToCertificates -PermissionsToStorage $PermToStorage -PassThru <-||-  } <-||- 
    
     -||-> if ( -||-> $global:noADCmdLetMode <-||- ) {
         -||-> Assert-Throws {  -||-> &$setAccessPolicyFunc <-||-  } <-||- 
    }
    else{
         -||-> $vault =  -||-> &$setAccessPolicyFunc <-||-  <-||- 

         -||-> CheckVaultAccessPolicy $vault $PermToKeys $PermToSecrets $PermToCertificates $PermToStorage <-||- 

         -||-> Assert-AreEqual $spn ( -||-> Get-AzADServicePrincipal -ObjectId $vault.AccessPolicies[0].ObjectId <-||- )[0].ServicePrincipalNames[0] <-||- 

         -||-> $vault =  -||-> Remove-AzKeyVaultAccessPolicy -VaultName $existingVaultName -ResourceGroupName $rgName -SPN $spn -PassThru <-||-  <-||- 
         -||-> Assert-AreEqual 0 $vault.AccessPolicies.Count <-||- 
    } <-||- 
} <-||- 

 -||-> function Test-SetRemoveAccessPolicyByObjectId
{
    Param($existingVaultName, $rgName, $objId, [switch]$bypassObjectIdValidation)

     -||-> $PermToKeys = @( -||-> "encrypt", "decrypt" <-||- ) <-||- 
     -||-> $PermToSecrets = @() <-||- 
     -||-> $PermToCertificates = @() <-||- 
     -||-> $PermToStorage = @() <-||- 

     -||-> $vault <-||- ;
     -||-> if ( -||-> $bypassObjectIdValidation.IsPresent <-||- )
    {
         -||-> $vault =  -||-> Set-AzKeyVaultAccessPolicy -VaultName $existingVaultName -ResourceGroupName $rgName -ObjectId $objId -PermissionsToKeys $PermToKeys -PermissionsToCertificates $PermToCertificates -PermissionsToStorage $PermToStorage -BypassObjectIdValidation -PassThru <-||-  <-||- 
    }
    else
    {
         -||-> $vault =  -||-> Set-AzKeyVaultAccessPolicy -VaultName $existingVaultName -ResourceGroupName $rgName -ObjectId $objId -PermissionsToKeys $PermToKeys -PermissionsToCertificates $PermToCertificates -PermissionsToStorage $PermToStorage -PassThru <-||-  <-||- 
    } <-||- 

     -||-> CheckVaultAccessPolicy $vault $PermToKeys $PermToSecrets $PermToCertificates $PermToStorage <-||- 
    
     -||-> Assert-AreEqual $objId $vault.AccessPolicies[0].ObjectId <-||- 

     -||-> $vault =  -||-> Remove-AzKeyVaultAccessPolicy -VaultName $existingVaultName -ResourceGroupName $rgName -ObjectId $objId -PassThru <-||-  <-||- 
     -||-> Assert-AreEqual 0 $vault.AccessPolicies.Count <-||- 
} <-||- 

 -||-> function Test-SetRemoveAccessPolicyByCompoundId
{
    Param($existingVaultName, $rgName, $appId, $objId)

     -||-> Assert-NotNull $appId <-||- 

     -||-> $PermToKeys = @( -||-> "encrypt", "decrypt" <-||- ) <-||- 
     -||-> $PermToSecrets = @() <-||- 
     -||-> $PermToCertificates = @( -||-> "list", "delete" <-||- ) <-||- 
     -||-> $PermToStorage = @( -||-> "list", "delete" <-||- ) <-||- 
     -||-> $vault =  -||-> Set-AzKeyVaultAccessPolicy -VaultName $existingVaultName -ResourceGroupName $rgName -ObjectId $objId -ApplicationId $appId -PermissionsToKeys $PermToKeys -PermissionsToCertificates $PermToCertificates -PermissionsToStorage $PermToStorage -PassThru <-||-  <-||- 

     -||-> CheckVaultAccessPolicy $vault $PermToKeys $PermToSecrets $PermToCertificates $PermToStorage <-||- 
    
     -||-> Assert-AreEqual $objId $vault.AccessPolicies[0].ObjectId <-||- 
     -||-> Assert-AreEqual $appId $vault.AccessPolicies[0].ApplicationId <-||- 

     -||-> $vault =  -||-> Remove-AzKeyVaultAccessPolicy -VaultName $existingVaultName -ResourceGroupName $rgName -ObjectId $objId -ApplicationId $appId -PassThru <-||-  <-||- 
     -||-> Assert-AreEqual 0 $vault.AccessPolicies.Count <-||- 
} <-||- 

 -||-> function Test-RemoveAccessPolicyWithCompoundIdPolicies
{
    Param($existingVaultName, $rgName, $appId1, $appId2, $objId)

     -||-> Assert-NotNull $appId1 <-||- 
     -||-> Assert-NotNull $appId2 <-||- 

    
     -||-> $PermToKeys = @( -||-> "encrypt", "decrypt" <-||- ) <-||- 
     -||-> $PermToSecrets = @() <-||- 
     -||-> $PermToCertificates = @( -||-> "all" <-||- ) <-||- 
     -||-> $PermToStorage = @( -||-> "all" <-||- ) <-||- 
     -||-> $vault =  -||-> Set-AzKeyVaultAccessPolicy -VaultName $existingVaultName -ResourceGroupName $rgName -ObjectId $objId -PermissionsToKeys $PermToKeys -PassThru <-||-  <-||- 
     -||-> $vault =  -||-> Set-AzKeyVaultAccessPolicy -VaultName $existingVaultName -ResourceGroupName $rgName -ObjectId $objId -ApplicationId $appId1 -PermissionsToKeys $PermToKeys -PassThru <-||-  <-||- 
     -||-> $vault =  -||-> Set-AzKeyVaultAccessPolicy -VaultName $existingVaultName -ResourceGroupName $rgName -ObjectId $objId -ApplicationId $appId2 -PermissionsToKeys $PermToKeys -PermissionsToCertificates $PermToCertificates -PassThru <-||-  <-||- 
     -||-> $vault =  -||-> Set-AzKeyVaultAccessPolicy -VaultName $existingVaultName -ResourceGroupName $rgName -ObjectId $objId -ApplicationId $appId2 -PermissionsToKeys $PermToKeys -PermissionsToStorage $PermToStorage -PassThru <-||-  <-||- 
     -||-> Assert-AreEqual 3 $vault.AccessPolicies.Count <-||- 

    
     -||-> $vault =  -||-> Remove-AzKeyVaultAccessPolicy -VaultName $existingVaultName -ResourceGroupName $rgName -ObjectId $objId -ApplicationId $appId1 -PassThru <-||-  <-||- 
     -||-> Assert-AreEqual 2 $vault.AccessPolicies.Count <-||- 

    
     -||-> $vault =  -||-> Remove-AzKeyVaultAccessPolicy -VaultName $existingVaultName -ResourceGroupName $rgName -ObjectId $objId -PassThru <-||-  <-||- 
     -||-> Assert-AreEqual 0 $vault.AccessPolicies.Count <-||- 
} <-||- 

 -||-> function Test-SetCompoundIdAccessPolicy
{
    Param($existingVaultName, $rgName, $appId, $objId)

     -||-> Assert-NotNull $appId <-||- 

    
     -||-> $PermToKeys = @( -||-> "encrypt", "decrypt" <-||- ) <-||- 
     -||-> $PermToSecrets = @() <-||- 
     -||-> $PermToCertificates = @() <-||- 
     -||-> $PermToStorage = @() <-||- 
     -||-> $vault =  -||-> Set-AzKeyVaultAccessPolicy -VaultName $existingVaultName -ResourceGroupName $rgName -ObjectId $objId -ApplicationId $appId -PermissionsToKeys $PermToKeys -PermissionsToCertificates $PermToCertificates -PermissionsToStorage $PermToStorage -PassThru <-||-  <-||- 

     -||-> CheckVaultAccessPolicy $vault $PermToKeys $PermToSecrets $PermToCertificates $PermToStorage <-||- 
    
     -||-> Assert-AreEqual $objId $vault.AccessPolicies[0].ObjectId <-||- 
     -||-> Assert-AreEqual $appId $vault.AccessPolicies[0].ApplicationId <-||- 

    
     -||-> $vault =  -||-> Set-AzKeyVaultAccessPolicy -VaultName $existingVaultName -ResourceGroupName $rgName -ObjectId $objId -PermissionsToKeys $PermToKeys -PassThru <-||-  <-||- 
     -||-> Assert-AreEqual 2 $vault.AccessPolicies.Count <-||- 

    
     -||-> $vault =  -||-> Set-AzKeyVaultAccessPolicy -VaultName $existingVaultName -ResourceGroupName $rgName -ObjectId $objId -ApplicationId $appId -PermissionsToKeys @( -||-> "encrypt" <-||- ) -PassThru <-||-  <-||- 
     -||-> Assert-AreEqual 2 $vault.AccessPolicies.Count <-||- 
     -||-> $vault =  -||-> Remove-AzKeyVaultAccessPolicy -VaultName $existingVaultName -ResourceGroupName $rgName -ObjectId $objId -ApplicationId $appId -PassThru <-||-  <-||- 
     -||-> CheckVaultAccessPolicy $vault $PermToKeys $PermToSecrets $PermToCertificates $PermToStorage <-||- 
     -||-> Assert-AreEqual $objId $vault.AccessPolicies[0].ObjectId <-||- 
     -||-> Assert-AreEqual $vault.AccessPolicies[0].ApplicationId $null <-||- 

     -||-> $vault =  -||-> Remove-AzKeyVaultAccessPolicy -VaultName $existingVaultName -ResourceGroupName $rgName -ObjectId $objId -PassThru <-||-  <-||- 
     -||-> Assert-AreEqual 0 $vault.AccessPolicies.Count <-||- 
} <-||- 



 -||-> function Test-ModifyAccessPolicy
{
    Param($existingVaultName, $rgName, $objId)

    
     -||-> $PermToKeys = @() <-||- 
     -||-> $PermToSecrets = @() <-||- 
     -||-> $vault =  -||-> Set-AzKeyVaultAccessPolicy -VaultName $existingVaultName -ResourceGroupName $rgName -ObjectId $objId -PermissionsToKeys $PermToKeys -PassThru <-||-  <-||- 
     -||-> Assert-NotNull $vault <-||- 
     -||-> Assert-AreEqual 0 $vault.AccessPolicies.Count <-||- 

    
     -||-> $PermToKeys = @( -||-> "encrypt", "decrypt", "unwrapKey", "wrapKey", "verify", "sign", "get", "list", "update", "create", "import", "delete", "backup", "restore" <-||- ) <-||- 
     -||-> $PermToSecrets = @( -||-> "get", "list", "set", "delete", "backup", "restore" <-||- ) <-||- 
     -||-> $PermToCertificates = @( -||-> "list", "delete" <-||- ) <-||- 
     -||-> $PermToStorage = @( -||-> "list", "delete" <-||- ) <-||- 
     -||-> $vault =  -||-> Set-AzKeyVaultAccessPolicy -VaultName $existingVaultName -ResourceGroupName $rgName -ObjectId $objId -PermissionsToKeys $PermToKeys -PermissionsToSecrets $PermToSecrets -PermissionsToCertificates $PermToCertificates -PermissionsToStorage $PermToStorage -PassThru <-||-  <-||- 

     -||-> CheckVaultAccessPolicy $vault $PermToKeys $PermToSecrets $PermToCertificates $PermToStorage <-||- 
     -||-> Assert-AreEqual $objId $vault.AccessPolicies[0].ObjectId <-||- 

    
     -||-> $vault.AccessPolicies[0].PermissionsToKeys.Remove("unwrapKey") <-||- 
     -||-> $vault =  -||-> $vault.AccessPolicies[0] | Set-AzKeyVaultAccessPolicy -VaultName $existingVaultName -ResourceGroupName $rgName -PassThru <-||-  <-||- 

     -||-> $PermToKeys = @( -||-> "encrypt", "decrypt", "wrapKey", "verify", "sign", "get", "list", "update", "create", "import", "delete", "backup", "restore" <-||- ) <-||-     
     -||-> CheckVaultAccessPolicy $vault $PermToKeys $PermToSecrets $PermToCertificates $PermToStorage <-||-  

    
     -||-> $PermToSecrets =  -||-> Get-AllSecretPermissions <-||-  <-||- 
     -||-> $vault =  -||-> Set-AzKeyVaultAccessPolicy -VaultName $existingVaultName -ResourceGroupName $rgName -ObjectId $objId -PermissionsToSecrets $PermToSecrets -PassThru <-||-  <-||- 
     -||-> CheckVaultAccessPolicy $vault $PermToKeys $PermToSecrets $PermToCertificates $PermToStorage <-||-  

    
     -||-> $PermToKeys = @() <-||- 
     -||-> $vault =  -||-> Set-AzKeyVaultAccessPolicy -VaultName $existingVaultName -ResourceGroupName $rgName -ObjectId $objId -PermissionsToKeys $PermToKeys -PassThru <-||-  <-||- 
     -||-> CheckVaultAccessPolicy $vault $PermToKeys $PermToSecrets $PermToCertificates $PermToStorage <-||-  
    
    
     -||-> $PermToSecrets = @() <-||- 
     -||-> $vault =  -||-> Set-AzKeyVaultAccessPolicy -VaultName $existingVaultName -ResourceGroupName $rgName -ObjectId $objId -PermissionsToKeys $PermToKeys -PermissionsToSecrets $PermToSecrets -PassThru <-||-  <-||- 
     -||-> CheckVaultAccessPolicy $vault $PermToKeys $PermToSecrets $PermToCertificates $PermToStorage <-||-  

    
     -||-> $PermToCertificates = @() <-||- 
     -||-> $vault =  -||-> Set-AzKeyVaultAccessPolicy -VaultName $existingVaultName -ResourceGroupName $rgName -ObjectId $objId -PermissionsToCertificates $PermToCertificates -PassThru <-||-  <-||- 
     -||-> CheckVaultAccessPolicy $vault $PermToKeys $PermToSecrets $PermToCertificates $PermToStorage <-||-  

    
     -||-> $PermToStorage = @() <-||- 
     -||-> $vault =  -||-> Set-AzKeyVaultAccessPolicy -VaultName $existingVaultName -ResourceGroupName $rgName -ObjectId $objId -PermissionsToStorage $PermToStorage -PassThru <-||-  <-||- 
     -||-> Assert-NotNull $vault <-||- 
     -||-> Assert-AreEqual 0 $vault.AccessPolicies.Count <-||- 
} <-||- 

 -||-> function Test-ModifyAccessPolicyEnabledForDeployment
{
    Param($existingVaultName, $rgName)
     -||-> $vault =  -||-> Get-AzKeyVault -VaultName $existingVaultName -ResourceGroupName $rgName <-||-  <-||- 
     -||-> Assert-NotNull $vault <-||- 
     -||-> Assert-AreEqual 0 $vault.AccessPolicies.Count <-||- 
     -||-> Assert-AreEqual $false $vault.EnabledForDeployment <-||- 

    
     -||-> $vault =  -||-> Set-AzKeyVaultAccessPolicy -VaultName $existingVaultName -ResourceGroupName $rgName -EnabledForDeployment -PassThru <-||-  <-||- 
     -||-> Assert-NotNull $vault <-||- 
     -||-> Assert-AreEqual 0 $vault.AccessPolicies.Count <-||- 
     -||-> Assert-AreEqual $true $vault.EnabledForDeployment <-||- 

     -||-> $vault =  -||-> Remove-AzKeyVaultAccessPolicy -VaultName $existingVaultName -ResourceGroupName $rgName -EnabledForDeployment -PassThru <-||-  <-||- 
     -||-> Assert-NotNull $vault <-||- 
     -||-> Assert-AreEqual 0 $vault.AccessPolicies.Count <-||- 
     -||-> Assert-AreEqual $false $vault.EnabledForDeployment <-||- 
} <-||- 

 -||-> function Test-ModifyAccessPolicyEnabledForTemplateDeployment
{
    Param($existingVaultName, $rgName)
     -||-> $vault =  -||-> Get-AzKeyVault -VaultName $existingVaultName -ResourceGroupName $rgName <-||-  <-||- 
     -||-> Assert-NotNull $vault <-||- 
     -||-> Assert-AreEqual 0 $vault.AccessPolicies.Count <-||- 
     -||-> if ( -||-> $vault.EnabledForTemplateDeployment -ne $null <-||- )
    {
         -||-> Assert-AreEqual $false $vault.EnabledForTemplateDeployment <-||- 
    } <-||- 

    
     -||-> $vault =  -||-> Set-AzKeyVaultAccessPolicy -VaultName $existingVaultName -ResourceGroupName $rgName -EnabledForTemplateDeployment -PassThru <-||-  <-||- 
     -||-> Assert-NotNull $vault <-||- 
     -||-> Assert-AreEqual 0 $vault.AccessPolicies.Count <-||- 
     -||-> Assert-AreEqual $true $vault.EnabledForTemplateDeployment <-||- 

     -||-> $vault =  -||-> Remove-AzKeyVaultAccessPolicy -VaultName $existingVaultName -ResourceGroupName $rgName -EnabledForTemplateDeployment -PassThru <-||-  <-||- 
     -||-> Assert-NotNull $vault <-||- 
     -||-> Assert-AreEqual 0 $vault.AccessPolicies.Count <-||- 
     -||-> Assert-AreEqual $false $vault.EnabledForTemplateDeployment <-||- 
} <-||- 

 -||-> function Test-ModifyAccessPolicyEnabledForDiskEncryption
{
    Param($existingVaultName, $rgName)
     -||-> $vault =  -||-> Get-AzKeyVault -VaultName $existingVaultName -ResourceGroupName $rgName <-||-  <-||- 
     -||-> Assert-NotNull $vault <-||- 
     -||-> Assert-AreEqual 0 $vault.AccessPolicies.Count <-||- 
     -||-> if ( -||-> $vault.EnabledForDiskEncryption -ne $null <-||- )
    {
         -||-> Assert-AreEqual $false $vault.EnabledForDiskEncryption <-||- 
    } <-||- 

    
     -||-> $vault =  -||-> Set-AzKeyVaultAccessPolicy -VaultName $existingVaultName -ResourceGroupName $rgName -EnabledForDiskEncryption -PassThru <-||-  <-||- 
     -||-> Assert-NotNull $vault <-||- 
     -||-> Assert-AreEqual 0 $vault.AccessPolicies.Count <-||- 
     -||-> Assert-AreEqual $true $vault.EnabledForDiskEncryption <-||- 

     -||-> $vault =  -||-> Remove-AzKeyVaultAccessPolicy -VaultName $existingVaultName -ResourceGroupName $rgName -EnabledForDiskEncryption -PassThru <-||-  <-||- 
     -||-> Assert-NotNull $vault <-||- 
     -||-> Assert-AreEqual 0 $vault.AccessPolicies.Count <-||- 
     -||-> Assert-AreEqual $false $vault.EnabledForDiskEncryption <-||- 
} <-||- 

 -||-> function Test-ModifyAccessPolicyNegativeCases
{
    Param($existingVaultName, $rgName, $objId)

    
     -||-> Assert-Throws {  -||-> Set-AzKeyVaultAccessPolicy -VaultName $existingVaultName -ResourceGroupName $rgName -ObjectId $objId -PermissionsToSecrets blah, get <-||-  } <-||- 
     -||-> Assert-Throws {  -||-> Set-AzKeyVaultAccessPolicy -VaultName $existingVaultName -ResourceGroupName $rgName -ObjectId $objId -PermissionsToCertificates blah, get <-||-  } <-||- 

    
     -||-> Assert-Throws {  -||-> Set-AzKeyVaultAccessPolicy -VaultName $existingVaultName -ResourceGroupName $rgName <-||-  } <-||- 
     -||-> Assert-Throws {  -||-> Set-AzKeyVaultAccessPolicy -VaultName $existingVaultName <-||-  } <-||- 
     -||-> Assert-Throws {  -||-> Remove-AzKeyVaultAccessPolicy -VaultName $existingVaultName -ResourceGroupName $rgName <-||-  } <-||- 
     -||-> Assert-Throws {  -||-> Remove-AzKeyVaultAccessPolicy -VaultName $existingVaultName <-||-  } <-||- 
     -||-> Assert-Throws {  -||-> Set-AzKeyVaultAccessPolicy -VaultName $existingVaultName -ResourceGroupName $rgName -UserPrincipalName $objId <-||-  } <-||- 
     -||-> Assert-Throws {  -||-> Set-AzKeyVaultAccessPolicy -VaultName $existingVaultName -ResourceGroupName $rgName -SPN $objId <-||-  } <-||- 
     -||-> Assert-Throws {  -||-> Set-AzKeyVaultAccessPolicy -VaultName $existingVaultName -ResourceGroupName $rgName -ObjectId $objId <-||-  } <-||- 
} <-||- 

 -||-> function Test-RemoveNonExistentAccessPolicyDoesNotThrow
{
    Param($existingVaultName, $rgName, $objId)
     -||-> $vault =  -||-> Remove-AzKeyVaultAccessPolicy -VaultName $existingVaultName -ResourceGroupName $rgName -ObjectId $objId -PassThru <-||-  <-||- 
     -||-> Assert-AreEqual 0 $vault.AccessPolicies.Count <-||- 
} <-||- 



 -||-> function Test-AllPermissionExpansion
{
    Param($existingVaultName, $rgName, $upn)
     -||-> $vault =  -||-> Get-AzKeyVault -VaultName $existingVaultName -ResourceGroupName $rgName <-||-  <-||- 
     -||-> Assert-NotNull $vault <-||- 
     -||-> Assert-AreEqual 0 $vault.AccessPolicies.Count <-||- 

     -||-> $vault =  -||-> Set-AzKeyVaultAccessPolicy -VaultName $existingVaultName -ResourceGroupName $rgName -UserPrincipalName $upn -PermissionsToKeys all -PermissionsToSecrets all -PermissionsToCertificates all -PermissionsToStorage all -PassThru <-||-  <-||- 
     -||-> CheckVaultAccessPolicy $vault ( -||-> Get-AllKeyPermissions <-||- ) ( -||-> Get-AllSecretPermissions <-||- ) ( -||-> Get-AllCertPermissions <-||- ) ( -||-> Get-AllStoragePermissions <-||- ) <-||- 
} <-||- 

 -||-> function CheckVaultAccessPolicy
{
    Param($vault, $expectedPermsToKeys, $expectedPermsToSecrets, $expectedPermsToCertificates, $expectedPermsToStorage)
     -||-> Assert-NotNull $vault <-||- 
     -||-> Assert-AreEqual 1 $vault.AccessPolicies.Count <-||- 

     -||-> $compare =  -||-> Compare-Object $vault.AccessPolicies[0].PermissionsToKeys $expectedPermsToKeys <-||-  <-||- 
     -||-> Assert-Null $compare <-||- 
     -||-> $compare =  -||-> Compare-Object $vault.AccessPolicies[0].PermissionsToSecrets $expectedPermsToSecrets <-||-  <-||- 
     -||-> Assert-Null $compare <-||- 
     -||-> $compare =  -||-> Compare-Object $vault.AccessPolicies[0].PermissionsToCertificates $expectedPermsToCertificates <-||-  <-||- 
     -||-> Assert-Null $compare <-||- 
     -||-> $compare =  -||-> Compare-Object $vault.AccessPolicies[0].PermissionsToStorage $expectedPermsToStorage <-||-  <-||- 
     -||-> Assert-Null $compare <-||- 
} <-||- 

 -||-> function Compare-Vaults
{
    Param($vault1, $vault2)
     -||-> Assert-AreEqual $vault1.VaultName $vault2.VaultName <-||- 
     -||-> Assert-AreEqual $vault1.ResourceGroupName $vault2.ResourceGroupName <-||- 
     -||-> Assert-AreEqual $vault1.Location $vault2.Location <-||- 
     -||-> Assert-AreEqual $vault1.Sku $vault2.Sku <-||- 
     -||-> Assert-AreEqual $vault1.EnabledForDeployment $vault2.EnabledForDeployment <-||- 
     -||-> Assert-AreEqual $vault1.EnableSoftDelete $vault2.EnableSoftDelete <-||- 
     -||-> Assert-AreEqual $vault1.EnabledForTemplateDeployment $vault2.EnabledForTemplateDeployment <-||- 
     -||-> Assert-AreEqual $vault1.EnabledForDiskEncryption $vault2.EnabledForDiskEncryption <-||- 

     -||-> If( -||-> $vault2.AccessPolicies.Count -eq 1 <-||- )
    {
         -||-> CheckVaultAccessPolicy $vault1 $vault2.AccessPolicies[0].PermissionsToKeys $vault2.AccessPolicies[0].PermissionsToSecrets $vault2.AccessPolicies[0].PermissionsToCertificates $vault2.AccessPolicies[0].PermissionsToStorage <-||- 
         -||-> Assert-AreEqual $vault1.AccessPolicies[0].ObjectId $vault2.AccessPolicies[0].ObjectId <-||- 
    } <-||- 
} <-||- 

 -||-> function Test-NetworkRuleSet
{
	 -||-> $resourceGroupName =  -||-> getAssetName <-||-  <-||- 
	 -||-> $resourceGroupLocation =  -||-> Get-Location "Microsoft.Resources" "resourceGroups" "westus" <-||-  <-||- 
	 -||-> $vaultName =  -||-> getAssetName <-||-  <-||- 
	 -||-> $vaultLocation =  -||-> Get-Location "Microsoft.KeyVault" "vaults" "westus" <-||-  <-||- 
	 -||-> $virtualNetworkName =  -||-> getAssetName <-||-  <-||- 
	 -||-> $virtualNetworkLocation =  -||-> Get-Location "Microsoft.Network" "virtualNetworks" "westus" <-||-  <-||- 

	 -||-> try
	{
		 -||-> $rg =  -||-> New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation <-||-  <-||- 
		 -||-> $vault =  -||-> New-AzKeyVault -VaultName $vaultName -ResourceGroupName $resourceGroupName -Location $vaultLocation <-||-  <-||- 

		 -||-> $frontendSubnet =  -||-> New-AzVirtualNetworkSubnetConfig -Name frontendSubnet -AddressPrefix "10.0.1.0/24" -ServiceEndpoint Microsoft.KeyVault <-||-  <-||-  
		 -||-> $virtualNetwork =  -||-> New-AzVirtualNetwork -Name $virtualNetworkName -ResourceGroupName $resourceGroupName -Location $virtualNetworkLocation -AddressPrefix "10.0.0.0/16" -Subnet $frontendSubnet <-||-  <-||- 

		 -||-> $myNetworkResId = ( -||-> Get-AzVirtualNetwork -Name $virtualNetworkName -ResourceGroupName $resourceGroupName <-||- ).Subnets[0].Id <-||- 
		 -||-> Add-AzKeyVaultNetworkRule -VaultName $vaultName -IpAddressRange "10.0.1.0/24" -VirtualNetworkResourceId $myNetworkResId <-||- 
		 -||-> $vault =  -||-> Get-AzKeyVault -ResourceGroupName $resourceGroupName -Name $vaultName <-||-  <-||- 
		 -||-> Assert-AreEqual $vault.NetworkAcls.IpAddressRanges.Count 1 <-||- 
		 -||-> Assert-AreEqual $vault.NetworkAcls.IpAddressRanges[0] "10.0.1.0/24" <-||- 
		 -||-> Assert-AreEqual $vault.NetworkAcls.VirtualNetworkResourceIds.Count 1 <-||- 
		 -||-> Assert-AreEqual $vault.NetworkAcls.VirtualNetworkResourceIds[0] $myNetworkResId <-||- 
		 -||-> Assert-AreEqual $vault.NetworkAcls.Bypass.toString() "AzureServices" <-||- 
		 -||-> Assert-AreEqual $vault.NetworkAcls.DefaultAction.toString() "Allow" <-||- 

		 -||-> $networkRule =  -||-> Update-AzKeyVaultNetworkRuleSet -VaultName $vaultName -ResourceGroupName $resourceGroupName -Bypass None -DefaultAction Deny -PassThru <-||-  <-||- 
		 -||-> Assert-AreEqual $networkRule.NetworkAcls.Bypass.toString() "None" <-||- 
		 -||-> Assert-AreEqual $networkRule.NetworkAcls.DefaultAction.toString() "Deny" <-||- 
		 -||-> $vault =  -||-> Get-AzKeyVault -ResourceGroupName $resourceGroupName -Name $vaultName <-||-  <-||- 
		 -||-> Assert-AreEqual $vault.NetworkAcls.Bypass.toString() "None" <-||- 
		 -||-> Assert-AreEqual $vault.NetworkAcls.DefaultAction.toString() "Deny" <-||- 

		 -||-> Remove-AzKeyVaultNetworkRule -VaultName $vaultName -ResourceGroupName $resourceGroupName -IpAddressRange "10.0.1.0/24" -VirtualNetworkResourceId $myNetworkResId <-||- 
		 -||-> $vault =  -||-> Get-AzKeyVault -ResourceGroupName $resourceGroupName -Name $vaultName <-||-  <-||- 
		 -||-> Assert-AreEqual $vault.NetworkAcls.IpAddressRanges.Count 0 <-||- 
		 -||-> Assert-AreEqual $vault.NetworkAcls.VirtualNetworkResourceIds.Count 0 <-||- 
	}
	finally
	{
		 -||-> Remove-AzResourceGroup -Name $resourceGroupName -Force <-||- 
	} <-||- 
} <-||- 

