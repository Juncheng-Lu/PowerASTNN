














 -||-> function Test-PolicyCrud
{
     -||-> $Name =  -||-> getAssetName <-||-  <-||- 
     -||-> $resourceGroup =  -||-> TestSetup-CreateResourceGroup <-||-  <-||- 
     -||-> $resourceGroupName = $resourceGroup.ResourceGroupName <-||- 
     -||-> $tags = @{"tag1" =  -||-> "value1" <-||- ; "tag2" =  -||-> "value2" <-||- } <-||- 
     -||-> $matchCondition1 =  -||-> New-AzFrontDoorWafMatchConditionObject -MatchVariable RequestHeader -OperatorProperty Contains -Selector "UserAgent" -MatchValue "WINDOWS" -Transform "Uppercase" <-||-  <-||- 
     -||-> $customRule1 =  -||-> New-AzFrontDoorWafCustomRuleObject -Name "Rule1" -RuleType MatchRule -MatchCondition $matchCondition1 -Action Block -Priority 2 <-||-  <-||- 

     -||-> $ruleOverride =  -||-> New-AzFrontDoorWafManagedRuleOverrideObject -RuleId "942100" -Action Log <-||-  <-||- 
     -||-> $override1 =  -||-> New-AzFrontDoorWafRuleGroupOverrideObject -RuleGroupName SQLI -ManagedRuleOverride $ruleOverride <-||-  <-||- 
     -||-> $managedRule1 =  -||-> New-AzFrontDoorWafManagedRuleObject -Type DefaultRuleSet -Version "1.0" -RuleGroupOverride $override1 <-||-  <-||- 
     -||-> $managedRule2 =  -||-> New-AzFrontDoorWafManagedRuleObject -Type BotProtection -Version "preview-0.1" <-||-  <-||- 

     -||-> New-AzFrontDoorWafPolicy -Name $Name -ResourceGroupName $resourceGroupName -Customrule $customRule1 -ManagedRule $managedRule1,$managedRule2 -EnabledState Enabled -Mode Prevention <-||- 
	
     -||-> $retrievedPolicy =  -||-> Get-AzFrontDoorWafPolicy -Name $Name -ResourceGroupName $resourceGroupName <-||-  <-||-  
     -||-> Assert-NotNull $retrievedPolicy <-||- 
     -||-> Assert-AreEqual $Name $retrievedPolicy.Name <-||- 
     -||-> Assert-AreEqual $customRule1.Name $retrievedPolicy.CustomRules[0].Name <-||- 
     -||-> Assert-AreEqual $customRule1.RuleType $retrievedPolicy.CustomRules[0].RuleType <-||- 
     -||-> Assert-AreEqual $customRule1.Action $retrievedPolicy.CustomRules[0].Action <-||- 
     -||-> Assert-AreEqual $customRule1.Priority $retrievedPolicy.CustomRules[0].Priority <-||- 
     -||-> Assert-AreEqual $matchCondition1.MatchVariable $retrievedPolicy.CustomRules[0].MatchConditions[0].MatchVariable <-||- 
     -||-> Assert-AreEqual $matchCondition1.Selector $retrievedPolicy.CustomRules[0].MatchConditions[0].Selector <-||- 
     -||-> Assert-AreEqual $matchCondition1.OperatorProperty $retrievedPolicy.CustomRules[0].MatchConditions[0].OperatorProperty <-||- 
     -||-> Assert-AreEqual $matchCondition1.MatchValue[0] $retrievedPolicy.CustomRules[0].MatchConditions[0].MatchValue[0] <-||- 
     -||-> Assert-AreEqual $matchCondition1.Transform[0] $retrievedPolicy.CustomRules[0].MatchConditions[0].Transform[0] <-||- 
     -||-> Assert-AreEqual $managedRule1.RuleGroupOverrides[0].ManagedRuleOverrides[0].Action $retrievedPolicy.ManagedRules[0].RuleGroupOverrides[0].ManagedRuleOverrides[0].Action <-||- 
     -||-> Assert-AreEqual $managedRule1.RuleSetType $retrievedPolicy.ManagedRules[0].RuleSetType <-||- 
     -||-> Assert-AreEqual $managedRule1.RuleSetVersion $retrievedPolicy.ManagedRules[0].RuleSetVersion <-||- 
     -||-> Assert-AreEqual $managedRule2.RuleSetType $retrievedPolicy.ManagedRules[1].RuleSetType <-||- 
     -||-> Assert-AreEqual $managedRule2.RuleSetVersion $retrievedPolicy.ManagedRules[1].RuleSetVersion <-||- 

     -||-> $customRule2 =  -||-> New-AzFrontDoorWafCustomRuleObject -Name "Rule2" -RuleType MatchRule -MatchCondition $matchCondition1 -Action Log -Priority 2 <-||-  <-||- 
     -||-> $updatedPolicy =  -||-> Update-AzFrontDoorWafPolicy -Name $Name -ResourceGroupName $resourceGroupName -Customrule $customRule2 <-||-  <-||- 
     -||-> Assert-NotNull $updatedPolicy <-||- 
     -||-> Assert-AreEqual $Name $updatedPolicy.Name <-||- 
     -||-> Assert-AreEqual $customRule2.Name $updatedPolicy.CustomRules[0].Name <-||- 
     -||-> Assert-AreEqual $customRule2.Action $updatedPolicy.CustomRules[0].Action <-||- 
     -||-> Assert-AreEqual $customRule2.Priority $updatedPolicy.CustomRules[0].Priority <-||- 
     -||-> Assert-AreEqual $managedRule1.RuleGroupOverrides[0].ManagedRuleOverrides[0].Action $updatedPolicy.ManagedRules[0].RuleGroupOverrides[0].ManagedRuleOverrides[0].Action <-||- 

     -||-> $customRule3 =  -||-> New-AzFrontDoorWafCustomRuleObject -Name "Rule3" -RuleType MatchRule -MatchCondition $matchCondition1 -Action Log -Priority 3 -EnabledState Disabled <-||-  <-||- 
     -||-> $updatedPolicy =  -||-> Update-AzFrontDoorWafPolicy -Name $Name -ResourceGroupName $resourceGroupName -Customrule $customRule3 <-||-  <-||- 
     -||-> Assert-NotNull $updatedPolicy <-||- 
     -||-> Assert-AreEqual $Name $updatedPolicy.Name <-||- 
     -||-> Assert-AreEqual $customRule3.Name $updatedPolicy.CustomRules[0].Name <-||- 
     -||-> Assert-AreEqual $customRule3.Action $updatedPolicy.CustomRules[0].Action <-||- 
     -||-> Assert-AreEqual $customRule3.Priority $updatedPolicy.CustomRules[0].Priority <-||- 
     -||-> Assert-AreEqual $customRule3.EnabledState $updatedPolicy.CustomRules[0].EnabledState <-||- 
     -||-> Assert-AreEqual $managedRule1.RuleGroupOverrides[0].ManagedRuleOverrides[0].Action $updatedPolicy.ManagedRules[0].RuleGroupOverrides[0].ManagedRuleOverrides[0].Action <-||- 

     -||-> $removed =  -||-> Remove-AzFrontDoorWafPolicy -Name $Name -ResourceGroupName $resourceGroupName -PassThru <-||-  <-||- 
     -||-> Assert-True {  -||-> $removed <-||-  } <-||- 
     -||-> Assert-ThrowsContains {  -||-> Get-AzFrontDoorWafPolicy -Name $Name -ResourceGroupName $resourceGroupName <-||-  } "does not exist." <-||- 
} <-||- 


 -||-> function Test-PolicyCrudWithPiping
{
     -||-> $Name =  -||-> getAssetName <-||-  <-||- 
     -||-> $resourceGroup =  -||-> TestSetup-CreateResourceGroup <-||-  <-||- 
     -||-> $resourceGroupName = $resourceGroup.ResourceGroupName <-||- 
     -||-> $tag = @{"tag1" =  -||-> "value1" <-||- ; "tag2" =  -||-> "value2" <-||- } <-||- 
     -||-> $matchCondition1 =  -||-> New-AzFrontDoorWafMatchConditionObject -MatchVariable RequestHeader -OperatorProperty Contains -Selector "UserAgent" -MatchValue "WINDOWS" -Transform "Uppercase" <-||-  <-||- 
     -||-> $customRule1 =  -||-> New-AzFrontDoorWafCustomRuleObject -Name "Rule1" -RuleType MatchRule -MatchCondition $matchCondition1 -Action Block -Priority 2 <-||-  <-||- 

     -||-> $ruleOverride =  -||-> New-AzFrontDoorWafManagedRuleOverrideObject -RuleId "942100" -Action Log <-||-  <-||- 
     -||-> $override1 =  -||-> New-AzFrontDoorWafRuleGroupOverrideObject -RuleGroupName SQLI -ManagedRuleOverride $ruleOverride <-||-  <-||- 
     -||-> $managedRule1 =  -||-> New-AzFrontDoorWafManagedRuleObject -Type DefaultRuleSet -Version "1.0" -RuleGroupOverride $override1 <-||-  <-||- 
     -||-> $managedRule2 =  -||-> New-AzFrontDoorWafManagedRuleObject -Type BotProtection -Version "preview-0.1" <-||-  <-||- 

     -||-> New-AzFrontDoorWafPolicy -Name $Name -ResourceGroupName $resourceGroupName -Customrule $customRule1 -ManagedRule $managedRule1,$managedRule2 -EnabledState Enabled -Mode Prevention <-||- 

     -||-> $customRule2 =  -||-> New-AzFrontDoorWafCustomRuleObject -Name "Rule2" -RuleType MatchRule -MatchCondition $matchCondition1 -Action Log -Priority 2 <-||-  <-||- 
     -||-> $updatedPolicy =  -||-> Get-AzFrontDoorWafPolicy -Name $Name -ResourceGroupName $resourceGroupName | Update-AzFrontDoorWafPolicy -Customrule $customRule2 <-||-  <-||- 
     -||-> Assert-NotNull $updatedPolicy <-||- 
     -||-> Assert-AreEqual $Name $updatedPolicy.Name <-||- 
     -||-> Assert-AreEqual $customRule2.Name $updatedPolicy.CustomRules[0].Name <-||- 
     -||-> Assert-AreEqual $customRule2.Action $updatedPolicy.CustomRules[0].Action <-||- 
     -||-> Assert-AreEqual $customRule2.Priority $updatedPolicy.CustomRules[0].Priority <-||- 
     -||-> Assert-AreEqual $managedRule1.RuleGroupOverrides[0].ManagedRuleOverrides[0].Action $updatedPolicy.ManagedRules[0].RuleGroupOverrides[0].ManagedRuleOverrides[0].Action <-||- 

     -||-> $removed =  -||-> Get-AzFrontDoorWafPolicy -Name $Name -ResourceGroupName $resourceGroupName | Remove-AzFrontDoorWafPolicy -PassThru <-||-  <-||- 
     -||-> Assert-True {  -||-> $removed <-||-  } <-||- 
     -||-> Assert-ThrowsContains {  -||-> Get-AzFrontDoorWafPolicy -Name $Name -ResourceGroupName $resourceGroupName <-||-  } "does not exist." <-||- 
} <-||- 

