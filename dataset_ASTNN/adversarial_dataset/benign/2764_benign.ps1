
















 -||-> $suffix="v2avm1" <-||- 
 -||-> $JobQueryWaitTimeInSeconds = 0 <-||- 
 -||-> $PrimaryFabricName = "V2A-W2K12-400" <-||- 
 -||-> $PrimaryNetworkFriendlyName = "corp" <-||- 
 -||-> $RecoveryNetworkFriendlyName = "corp" <-||- 
 -||-> $NetworkMappingName = "corp96map" <-||- 
 -||-> $RecoveryPlanName = "RPSwag96" + $suffix <-||- 
 -||-> $policyName1 = "V2aTest" + $suffix <-||- 
 -||-> $policyName2 = "V2aTest"+ $suffix+"-failback" <-||- 
 -||-> $PrimaryProtectionContainerMapping = "pcmmapping" + $suffix <-||- 
 -||-> $reverseMapping = "reverseMap" + $suffix <-||- 
 -||-> $pcName = "V2A-W2K12-400" <-||- 

 -||-> $rpiName = "V2ATest-rpi-" + $suffix <-||- 
 -||-> $RecoveryAzureStorageAccountId = "/subscriptions/7c943c1b-5122-4097-90c8-861411bdd574/resourceGroups/canaryexproute/providers/Microsoft.Storage/storageAccounts/ev2teststorage" <-||-  
 -||-> $RecoveryResourceGroupId  = "/subscriptions/7c943c1b-5122-4097-90c8-861411bdd574/resourceGroups/canaryexproute" <-||-  
 -||-> $AzureVmNetworkId = "/subscriptions/7c943c1b-5122-4097-90c8-861411bdd574/resourceGroups/ERNetwork/providers/Microsoft.Network/virtualNetworks/ASRCanaryTestSub3-CORP-SEA-VNET-1" <-||- 
 -||-> $rpiNameNew = "V2ATest-CentOS6U7-400-new" <-||- 
 -||-> $vCenterIpOrHostName = "10.150.209.216" <-||- 
 -||-> $vCenterName = "BCDR" <-||- 
 -||-> $Subnet = "Subnet-1" <-||- 

 -||-> $piName = "v2avm1" <-||- 
 -||-> $vmIp = "10.150.208.125" <-||- 


 -||-> function WaitForJobCompletion
{ 
    param(
        [string] $JobId,
        [int] $JobQueryWaitTimeInSeconds = $JobQueryWaitTimeInSeconds
        )
         -||-> $isJobLeftForProcessing = $true <-||- ;
        do
        {
             -||-> $Job =  -||-> Get-AzRecoveryServicesAsrJob -Name $JobId <-||-  <-||- 
             -||-> $Job <-||- 

             -||-> if( -||-> $Job.State -eq "InProgress" -or $Job.State -eq "NotStarted" <-||- )
            {
                 -||-> $isJobLeftForProcessing = $true <-||- 
            }
            else
            {
                 -||-> $isJobLeftForProcessing = $false <-||- 
            } <-||- 

             -||-> if( -||-> $isJobLeftForProcessing <-||- )
            {
                 -||-> [Microsoft.Rest.ClientRuntime.Azure.TestFramework.TestUtilities]::Wait($JobQueryWaitTimeInSeconds * 1000) <-||- 
            } <-||- 
        }While( -||-> $isJobLeftForProcessing <-||- )
} <-||- 


 -||-> Function WaitForIRCompletion
{ 
    param(
        [PSObject] $VM,
        [int] $JobQueryWaitTimeInSeconds = $JobQueryWaitTimeInSeconds
        )
         -||-> $isProcessingLeft = $true <-||- 
         -||-> $IRjobs = $null <-||- 

        do
        {
             -||-> $IRjobs =  -||-> Get-AzRecoveryServicesAsrJob -TargetObjectId $VM.Name | Sort-Object StartTime -Descending | select -First 4 | Where-Object{ -||-> $_.JobType -eq "PrimaryIrCompletion" -or $_.JobType -eq "SecondaryIrCompletion" <-||- } <-||-  <-||- 
             -||-> if( -||-> $IRjobs -eq $null -or $IRjobs.Count -lt 2 <-||- )
            {
                 -||-> $isProcessingLeft = $true <-||- 
            }
            else
            {
                 -||-> $isProcessingLeft = $false <-||- 
            } <-||- 

             -||-> if( -||-> $isProcessingLeft <-||- )
            {
                 -||-> [Microsoft.Rest.ClientRuntime.Azure.TestFramework.TestUtilities]::Wait($JobQueryWaitTimeInSeconds * 1000) <-||- 
            } <-||- 
        }While( -||-> $isProcessingLeft <-||- )

         -||-> $IRjobs <-||- 
         -||-> WaitForJobCompletion -JobId $IRjobs[0].Name -JobQueryWaitTimeInSeconds $JobQueryWaitTimeInSeconds <-||- 
         -||-> WaitForJobCompletion -JobId $IRjobs[1].Name -JobQueryWaitTimeInSeconds $JobQueryWaitTimeInSeconds <-||- 
} <-||- 


 -||-> function Test-SiteRecoveryEnumerationTests
{
    param([string] $vaultSettingsFilePath)

    
     -||-> Import-AzRecoveryServicesAsrVaultSettingsFile -Path $vaultSettingsFilePath <-||- 

    
     -||-> $vaults =  -||-> Get-AzRecoveryServicesVault <-||-  <-||- 
     -||-> Assert-True {  -||-> $vaults.Count -gt 0 <-||-  } <-||- 
     -||-> Assert-NotNull( -||-> $vaults <-||- ) <-||- 
     -||-> foreach($vault in  -||-> $vaults <-||- )
    {
         -||-> Assert-NotNull( -||-> $vault.Name <-||- ) <-||- 
         -||-> Assert-NotNull( -||-> $vault.ID <-||- ) <-||- 
    } <-||- 

    
     -||-> $rsps =  -||-> Get-AzRecoveryServicesAsrFabric | Get-AzRecoveryServicesAsrServicesProvider <-||-  <-||- 
     -||-> Assert-True {  -||-> $rsps.Count -gt 0 <-||-  } <-||- 
     -||-> Assert-NotNull( -||-> $rsps <-||- ) <-||- 
     -||-> foreach($rsp in  -||-> $rsps <-||- )
    {
         -||-> Assert-NotNull( -||-> $rsp.Name <-||- ) <-||- 
         -||-> Assert-NotNull( -||-> $rsp.ID <-||- ) <-||- 
    } <-||- 

    
     -||-> $protectionContainers =  -||-> Get-AzRecoveryServicesAsrFabric | Get-AzRecoveryServicesAsrProtectionContainer <-||-  <-||- 
     -||-> Assert-True {  -||-> $protectionContainers.Count -gt 0 <-||-  } <-||- 
     -||-> Assert-NotNull( -||-> $protectionContainers <-||- ) <-||- 
     -||-> foreach($protectionContainer in  -||-> $protectionContainers <-||- )
    {
         -||-> Assert-NotNull( -||-> $protectionContainer.Name <-||- ) <-||- 
         -||-> Assert-NotNull( -||-> $protectionContainer.ID <-||- ) <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-AsrEvent
{
    param([string] $vaultSettingsFilePath)

    
     -||-> Import-AzRecoveryServicesAsrVaultSettingsFile -Path $vaultSettingsFilePath <-||- 

     -||-> $Events =  -||-> get-asrEvent <-||-  <-||- 
     -||-> Assert-NotNull( -||-> $Events <-||- ) <-||- 

     -||-> $e =  -||-> Get-AzRecoveryServicesAsrEvent -Name $Events[0].Name <-||-  <-||- 
     -||-> Assert-NotNull( -||-> $e <-||- ) <-||- 
     -||-> Assert-NotNull( -||-> $e.Name <-||- ) <-||- 
     -||-> Assert-NotNull( -||-> $e.Description <-||- ) <-||- 
     -||-> Assert-NotNull( -||-> $e.FabricId <-||- ) <-||- 
     -||-> Assert-NotNull( -||-> $e.AffectedObjectFriendlyName <-||- ) <-||- 

     -||-> $e =  -||-> Get-AzRecoveryServicesAsrEvent -Severity $Events[0].Severity <-||-  <-||- 
     -||-> Assert-NotNull( -||-> $e <-||- ) <-||- 

     -||-> $e =  -||-> Get-AzRecoveryServicesAsrEvent -EventType VmHealth <-||-  <-||- 
     -||-> Assert-NotNull( -||-> $e <-||- ) <-||- 

     -||-> $e =  -||-> Get-AzRecoveryServicesAsrEvent -EventType VmHealth -AffectedObjectFriendlyName $e[0].AffectedObjectFriendlyName <-||-  <-||- 
     -||-> Assert-NotNull( -||-> $e <-||- ) <-||- 

     -||-> $e =  -||-> Get-AzRecoveryServicesAsrEvent -EventType VmHealth -FabricId $e[0].FabricId <-||-  <-||- 
     -||-> Assert-NotNull( -||-> $e <-||- ) <-||- 

      -||-> $e =  -||-> Get-AzRecoveryServicesAsrEvent -ResourceId  $e[0].Id <-||-  <-||- 
     -||-> Assert-NotNull( -||-> $e <-||- ) <-||- 

     -||-> $fabric =   -||-> Get-AsrFabric -FriendlyName $PrimaryFabricName <-||-  <-||- 
     -||-> $e =  -||-> Get-AzRecoveryServicesAsrEvent -Fabric $fabric <-||-  <-||- 
     -||-> Assert-NotNull( -||-> $e <-||- ) <-||- 
    
     -||-> $e =  -||-> Get-AzRecoveryServicesAsrEvent -AffectedObjectFriendlyName $Events[0].AffectedObjectFriendlyName <-||-  <-||- 
     -||-> Assert-NotNull( -||-> $e <-||- ) <-||- 
    
     -||-> $e =  -||-> Get-AzRecoveryServicesAsrEvent -StartTime "8/18/2017 2:05:00 AM" <-||-  <-||- 
     -||-> Assert-NotNull( -||-> $e <-||- ) <-||- 

} <-||- 



 -||-> function Test-Job
{
    param([string] $vaultSettingsFilePath)

    
     -||-> Import-AzRecoveryServicesAsrVaultSettingsFile -Path $vaultSettingsFilePath <-||- 
    
     -||-> $jobs =   -||-> Get-AzRecoveryServicesAsrJob <-||-  <-||- 
     -||-> Assert-NotNull( -||-> $jobs <-||- ) <-||- 
     -||-> $job = $jobs[0] <-||- 
     -||-> Assert-NotNull( -||-> $job.name <-||- ) <-||- 
     -||-> Assert-NotNull( -||-> $job.id <-||- ) <-||- 

     -||-> $job =  -||-> Get-AzRecoveryServicesAsrJob -name $job.name <-||-  <-||- 

     -||-> Assert-NotNull( -||-> $job.name <-||- ) <-||- 
     -||-> Assert-NotNull( -||-> $job.id <-||- ) <-||- 

     -||-> $job =  -||-> Get-AzRecoveryServicesAsrJob -job $job <-||-  <-||- 

     -||-> Assert-NotNull( -||-> $job.name <-||- ) <-||- 
     -||-> Assert-NotNull( -||-> $job.id <-||- ) <-||- 

     -||-> $jobList =  -||-> Get-AzRecoveryServicesAsrJob -TargetObjectId $job.TargetObjectId <-||-  <-||- 

     -||-> Assert-NotNull( -||-> $jobList <-||- ) <-||- 

     -||-> $jobList =  -||-> Get-AzRecoveryServicesAsrJob -StartTime '2017-08-04T09:28:52.0000000Z' -EndTime '2017-08-10T14:20:50.0000000Z' <-||-  <-||- 
     -||-> Assert-NotNull( -||-> $jobList <-||- ) <-||- 

     -||-> $jobList =   -||-> Get-AzRecoveryServicesAsrJob -State Succeeded <-||-  <-||- 
     -||-> Assert-NotNull( -||-> $jobList <-||- ) <-||- 
} <-||- 


 -||-> function Test-NotificationSettings
{
    param([string] $vaultSettingsFilePath)

    
     -||-> Import-AzRecoveryServicesAsrVaultSettingsFile -Path $vaultSettingsFilePath <-||- 
    
     -||-> $NotificationSettings =  -||-> Set-AzRecoveryServicesAsrNotificationSetting -EnableEmailSubscriptionOwner -CustomEmailAddress "abcxxxx@microsft.com" <-||-  <-||- 
     -||-> Assert-NotNull( -||-> $NotificationSettings <-||- ) <-||- 
    
     -||-> $NotificationSettings =  -||-> Set-AzRecoveryServicesAsrNotificationSetting -DisableEmailToSubscriptionOwner -CustomEmailAddress "abcxxxx@microsft.com" <-||-  <-||- 
     -||-> Assert-NotNull( -||-> $NotificationSettings <-||- ) <-||- 

     -||-> $NotificationSettings =  -||-> Get-AzRecoveryServicesAsrNotificationSetting <-||-  <-||- 
     -||-> Assert-NotNull( -||-> $NotificationSettings <-||- ) <-||- 
     -||-> Assert-NotNull( -||-> $NotificationSettings.CustomEmailAddress <-||- ) <-||- 
     -||-> Assert-AreEqual -expected "abcxxxx@microsft.com" -actual $NotificationSettings.CustomEmailAddress <-||- 
     -||-> Assert-NotNull( -||-> $NotificationSettings.EmailSubscriptionOwner <-||- ) <-||- 
     -||-> Assert-NotNull( -||-> $NotificationSettings.Locale <-||- ) <-||- 
     -||-> Set-AzRecoveryServicesAsrNotificationSetting -DisableNotification <-||- 
} <-||- 


