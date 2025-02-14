













 -||-> $location = "southeastasia" <-||- 
 -||-> $resourceGroupName = "pstestFSRG1bca8f8e" <-||- 
 -||-> $vaultName = "PSTestFSRSV1bca8f8e" <-||- 
 -||-> $fileShareFriendlyName = "pstestfs1bca8f8e" <-||- 
 -||-> $fileShareName = "AzureFileShare;pstestfs1bca8f8e" <-||- 
 -||-> $saName = "pstestsa1bca8f8e" <-||- 
 -||-> $saRgName = "pstestFSRG1bca8f8e" <-||- 
 -||-> $targetSaName = "pstestsa3rty7d7s" <-||- 
 -||-> $targetFileShareName = "pstestfs3rty7d7s" <-||- 
 -||-> $targetFolder = "pstestfolder3rty7d7s" <-||- 
 -||-> $folderPath = "pstestfolder1bca8f8e" <-||- 
 -||-> $filePath = "pstestfolder1bca8f8e/pstestfile1bca8f8e.txt" <-||- 
 -||-> $skuName="Standard_LRS" <-||- 
 -||-> $policyName = "AFSBackupPolicy" <-||- 
 -||-> $newPolicyName = "NewAFSBackupPolicy" <-||- 























 -||-> function Test-AzureFSItem
{
	 -||-> try
	{
		 -||-> $vault =  -||-> Get-AzRecoveryServicesVault -ResourceGroupName $resourceGroupName -Name $vaultName <-||-  <-||- 
		 -||-> Enable-Protection $vault $fileShareFriendlyName $saName <-||- 

		 -||-> $policy =  -||-> Get-AzRecoveryServicesBackupProtectionPolicy `
			-VaultId $vault.ID `
			-Name $policyName <-||-  <-||- 

		 -||-> $container =  -||-> Get-AzRecoveryServicesBackupContainer `
			-VaultId $vault.ID `
			-ContainerType AzureStorage `
			-Status Registered `
			-FriendlyName $saName <-||-  <-||- 
		
		
		 -||-> $items =  -||-> Get-AzRecoveryServicesBackupItem `
			-VaultId $vault.ID `
			-Container $container `
			-WorkloadType AzureFiles <-||-  <-||- ;
		 -||-> Assert-True {  -||-> $items.Name -contains $fileShareName <-||-  } <-||- 

		
		 -||-> $items =  -||-> Get-AzRecoveryServicesBackupItem `
			-VaultId $vault.ID `
			-Container $container `
			-WorkloadType AzureFiles `
			-ProtectionStatus Healthy <-||-  <-||- ;
		 -||-> Assert-True {  -||-> $items.Name -contains $fileShareName <-||-  } <-||- 

		
		 -||-> $items =  -||-> Get-AzRecoveryServicesBackupItem `
			-VaultId $vault.ID `
			-Container $container `
			-WorkloadType AzureFiles `
			-ProtectionState IRPending <-||-  <-||- ;
		 -||-> Assert-True {  -||-> $items.Name -contains $fileShareName <-||-  } <-||- 

		
		 -||-> $items =  -||-> Get-AzRecoveryServicesBackupItem `
			-VaultId $vault.ID `
			-Container $container `
			-WorkloadType AzureFiles `
			-Name $fileShareFriendlyName `
			-ProtectionStatus Healthy <-||-  <-||- ;
		 -||-> Assert-True {  -||-> $items.Name -contains $fileShareName <-||-  } <-||- 

		
		 -||-> $items =  -||-> Get-AzRecoveryServicesBackupItem `
			-VaultId $vault.ID `
			-Container $container `
			-WorkloadType AzureFiles `
			-Name $fileShareFriendlyName `
			-ProtectionState IRPending <-||-  <-||- ;
		 -||-> Assert-True {  -||-> $items.Name -contains $fileShareName <-||-  } <-||- 

		
		 -||-> $items =  -||-> Get-AzRecoveryServicesBackupItem `
			-VaultId $vault.ID `
			-Container $container `
			-WorkloadType AzureFiles `
			-ProtectionState IRPending `
			-ProtectionStatus Healthy <-||-  <-||- ;
		 -||-> Assert-True {  -||-> $items.Name -contains $fileShareName <-||-  } <-||- 

		
		 -||-> $items =  -||-> Get-AzRecoveryServicesBackupItem `
			-VaultId $vault.ID `
			-Policy $policy <-||-  <-||- ;
		 -||-> Assert-True {  -||-> $items.Name -contains $fileShareName <-||-  } <-||- 

		
		 -||-> $items =  -||-> Get-AzRecoveryServicesBackupItem `
			-VaultId $vault.ID `
			-Container $container `
			-WorkloadType AzureFiles `
			-Name $fileShareFriendlyName `
			-ProtectionState IRPending `
			-ProtectionStatus Healthy <-||-  <-||- ;
		 -||-> Assert-True {  -||-> $items.Name -contains $fileShareName <-||-  } <-||- 
	}
	finally
	{
		 -||-> Cleanup-Vault $vault $items $container <-||- 
	} <-||- 
} <-||- 

 -||-> function Test-AzureFSBackup
{
	 -||-> try
	{
		 -||-> $vault =  -||-> Get-AzRecoveryServicesVault -ResourceGroupName $resourceGroupName -Name $vaultName <-||-  <-||- 
		 -||-> $item =  -||-> Enable-Protection $vault $fileShareFriendlyName $saName <-||-  <-||- 
		 -||-> $container =  -||-> Get-AzRecoveryServicesBackupContainer `
			-VaultId $vault.ID `
			-ContainerType AzureStorage `
			-Status Registered `
			-FriendlyName $saName <-||-  <-||- 

		
		 -||-> $backupJob =  -||-> Backup-AzRecoveryServicesBackupItem `
			-VaultId $vault.ID `
			-Item $item | Wait-AzRecoveryServicesBackupJob -VaultId $vault.ID <-||-  <-||- 

		 -||-> Assert-True {  -||-> $backupJob.Status -eq "Completed" <-||-  } <-||- 
	}
	finally
	{
		 -||-> Cleanup-Vault $vault $item $container <-||- 
	} <-||- 
} <-||- 

 -||-> function Test-AzureFSProtection
{
	 -||-> try
	{
		 -||-> $vault =  -||-> Get-AzRecoveryServicesVault -ResourceGroupName $resourceGroupName -Name $vaultName <-||-  <-||- 
		
		 -||-> $policy =  -||-> Get-AzRecoveryServicesBackupProtectionPolicy `
			-VaultId $vault.ID `
			-Name $policyName <-||-  <-||- 

		 -||-> $enableJob =  -||-> Enable-AzRecoveryServicesBackupProtection `
			-VaultId $vault.ID `
			-Policy $Policy `
			-Name $fileShareFriendlyName `
			-StorageAccountName $saName <-||-  <-||- 

		 -||-> $container =  -||-> Get-AzRecoveryServicesBackupContainer `
			-VaultId $vault.ID `
			-ContainerType AzureStorage `
			-Status Registered `
			-FriendlyName $saName <-||-  <-||- 

		 -||-> $item =  -||-> Get-AzRecoveryServicesBackupItem `
			-VaultId $vault.ID `
			-Container $container `
			-WorkloadType AzureFiles <-||-  <-||- 
		 -||-> Assert-True {  -||-> $item.Name -contains $fileShareName <-||-  } <-||- 
		 -||-> Assert-True {  -||-> $item.LastBackupStatus -eq "IRPending" <-||-  } <-||- 
		 -||-> Assert-True {  -||-> $item.ProtectionPolicyName -eq $policyName <-||-  } <-||- 
		
		
		 -||-> $newPolicy =  -||-> Get-AzRecoveryServicesBackupProtectionPolicy `
		-VaultId $vault.ID `
		-Name $newPolicyName <-||-  <-||- 

		 -||-> $enableJob =   -||-> Enable-AzRecoveryServicesBackupProtection `
			-VaultId $vault.ID `
			-Policy $newPolicy `
			-Item $item <-||-  <-||- 
		
		 -||-> $item =  -||-> Get-AzRecoveryServicesBackupItem `
		-VaultId $vault.ID `
		-Container $container `
		-WorkloadType AzureFiles <-||-  <-||- 

		 -||-> Assert-True {  -||-> $item.Name -contains $fileShareName <-||-  } <-||- 
		 -||-> Assert-True {  -||-> $item.LastBackupStatus -eq "IRPending" <-||-  } <-||- 
		 -||-> Assert-True {  -||-> $item.ProtectionPolicyName -eq $newPolicyName <-||-  } <-||- 
	}
	finally
	{
		 -||-> Cleanup-Vault $vault $item $container <-||- 
	} <-||- 
} <-||- 

 -||-> function Test-AzureFSGetRPs
{
	 -||-> try
	{
		
		 -||-> $vault =  -||-> Get-AzRecoveryServicesVault -ResourceGroupName $resourceGroupName -Name $vaultName <-||-  <-||- 
		 -||-> $item =  -||-> Enable-Protection $vault $fileShareFriendlyName $saName <-||-  <-||- 
		 -||-> $container =  -||-> Get-AzRecoveryServicesBackupContainer `
			-VaultId $vault.ID `
			-ContainerType AzureStorage `
			-Status Registered `
			-FriendlyName $saName <-||-  <-||- 
		 -||-> $backupJob =  -||-> Backup-Item $vault $item <-||-  <-||- 

		 -||-> $backupStartTime = $backupJob.StartTime.AddMinutes(-1) <-||- ;
		 -||-> $backupEndTime = $backupJob.EndTime.AddMinutes(1) <-||- ;

		 -||-> $recoveryPoint =  -||-> Get-AzRecoveryServicesBackupRecoveryPoint `
			-VaultId $vault.ID `
			-StartDate $backupStartTime `
			-EndDate $backupEndTime `
			-Item $item <-||-  <-||- ;
	
		 -||-> Assert-NotNull $recoveryPoint[0] <-||- ;
		 -||-> Assert-True {  -||-> $recoveryPoint[0].Id -match $item.Id <-||-  } <-||- ;

		
		 -||-> $recoveryPointDetail =  -||-> Get-AzRecoveryServicesBackupRecoveryPoint `
			-VaultId $vault.ID `
			-RecoveryPointId $recoveryPoint[0].RecoveryPointId `
			-Item $item <-||-  <-||- ;
	
		 -||-> Assert-NotNull $recoveryPointDetail <-||- ;
	}
	finally
	{
		 -||-> Cleanup-Vault $vault $item $container <-||- 
	} <-||- 
} <-||- 

 -||-> function Test-AzureFSFullRestore
{
	 -||-> try
	{
		 -||-> $vault =  -||-> Get-AzRecoveryServicesVault -ResourceGroupName $resourceGroupName -Name $vaultName <-||-  <-||- 
		 -||-> $item =  -||-> Enable-Protection $vault $fileShareFriendlyName $saName <-||-  <-||- 
		 -||-> $container =  -||-> Get-AzRecoveryServicesBackupContainer `
			-VaultId $vault.ID `
			-ContainerType AzureStorage `
			-Status Registered `
			-FriendlyName $saName <-||-  <-||- 
		 -||-> $backupJob =  -||-> Backup-Item $vault $item <-||-  <-||- 

		 -||-> $backupStartTime = $backupJob.StartTime.AddMinutes(-1) <-||- ;
		 -||-> $backupEndTime = $backupJob.EndTime.AddMinutes(1) <-||- ;

		 -||-> $recoveryPoint =  -||-> Get-AzRecoveryServicesBackupRecoveryPoint `
			-VaultId $vault.ID `
			-StartDate $backupStartTime `
			-EndDate $backupEndTime `
			-Item $item <-||-  <-||- ;

		 -||-> Assert-ThrowsContains {  -||-> Restore-AzRecoveryServicesBackupItem `
			-VaultId $vault.ID `
			-VaultLocation $vault.Location `
			-RecoveryPoint $recoveryPoint[0] `
			-ResolveConflict Overwrite `
			-TargetStorageAccountName $targetSaName `
			-TargetFolder $targetFolder <-||-  } `
			"Provide TargetFileShareName for Alternate Location restore or remove TargetStorageAccountName for Original Location restore" <-||- 

		 -||-> Assert-ThrowsContains {  -||-> Restore-AzRecoveryServicesBackupItem `
			-VaultId $vault.ID `
			-VaultLocation $vault.Location `
			-RecoveryPoint $recoveryPoint[0] `
			-ResolveConflict Overwrite `
			-TargetFileShareName $targetFileShareName `
			-TargetFolder $targetFolder <-||-  } `
			"Provide TargetStorageAccountName for Alternate Location restore or remove TargetFileShareName for Original Location restore" <-||- 

		 -||-> Assert-ThrowsContains {  -||-> Restore-AzRecoveryServicesBackupItem `
			-VaultId $vault.ID `
		  	-VaultLocation $vault.Location `
		  	-RecoveryPoint $recoveryPoint[0] `
		  	-ResolveConflict Overwrite `
		  	-SourceFileType File <-||-  } `
		  	"Provide SourceFilePath for File restore or remove SourceFileType for file share restore" <-||- 

		 -||-> Assert-ThrowsContains {  -||-> Restore-AzRecoveryServicesBackupItem `
			-VaultId $vault.ID `
			-VaultLocation $vault.Location `
			-RecoveryPoint $recoveryPoint[0] `
			-ResolveConflict Overwrite `
			-SourceFilePath $filePath <-||-  } `
			"Provide SourceFileType for File restore or remove SourceFilePath for file share restore" <-||- 
    
		
		
		 -||-> $restoreJob1 =  -||-> Restore-AzRecoveryServicesBackupItem `
			-VaultId $vault.ID `
			-VaultLocation $vault.Location `
			-RecoveryPoint $recoveryPoint[0] `
			-ResolveConflict Overwrite `
			-SourceFilePath $folderPath `
			-SourceFileType Directory `
			-TargetStorageAccountName $targetSaName `
			-TargetFileShareName $targetFileShareName `
			-TargetFolder $targetFolder | `
				Wait-AzRecoveryServicesBackupJob -VaultId $vault.ID <-||-  <-||- 
		
		 -||-> Assert-True {  -||-> $restoreJob1.Status -eq "Completed" <-||-  } <-||- 
    
		
		
		 -||-> $restoreJob2 =  -||-> Restore-AzRecoveryServicesBackupItem `
			-VaultId $vault.ID `
			-VaultLocation $vault.Location `
			-RecoveryPoint $recoveryPoint[0] `
			-ResolveConflict Overwrite `
			-TargetStorageAccountName $targetSaName `
			-TargetFileShareName $targetFileShareName `
			-TargetFolder $targetFolder | `
				Wait-AzRecoveryServicesBackupJob -VaultId $vault.ID <-||-  <-||- 
		
		 -||-> Assert-True {  -||-> $restoreJob2.Status -eq "Completed" <-||-  } <-||- 

		
		
		 -||-> $restoreJob3 =  -||-> Restore-AzRecoveryServicesBackupItem `
			-VaultId $vault.ID `
			-VaultLocation $vault.Location `
			-RecoveryPoint $recoveryPoint[0] `
			-ResolveConflict Overwrite `
			-SourceFilePath $filePath `
			-SourceFileType File | `
				Wait-AzRecoveryServicesBackupJob -VaultId $vault.ID <-||-  <-||- 

		 -||-> Assert-True {  -||-> $restoreJob3.Status -eq "Completed" <-||-  } <-||- 

		
		
		 -||-> $restoreJob4 =  -||-> Restore-AzRecoveryServicesBackupItem `
			-VaultId $vault.ID `
			-VaultLocation $vault.Location `
			-RecoveryPoint $recoveryPoint[0] `
			-ResolveConflict Overwrite | `
				Wait-AzRecoveryServicesBackupJob -VaultId $vault.ID <-||-  <-||- 

		 -||-> Assert-True {  -||-> $restoreJob4.Status -eq "Completed" <-||-  } <-||- 
	}
	finally
	{
		 -||-> Cleanup-Vault $vault $item $container <-||- 
	} <-||- 
} <-||- 

