














 -||-> function Remediation-SubscriptionScope-Crud
{
    -||-> $assignmentId =  -||-> Get-TestRemediationSubscriptionPolicyAssignmentId <-||-  <-||- 
    -||-> $remediationName = "PSTestRemediation" <-||- 

   
    -||-> $remediation =  -||-> Start-AzPolicyRemediation -PolicyAssignmentId $assignmentId -Name $remediationName -LocationFilter "westus2","west central us" <-||-  <-||- 
    -||-> Validate-Remediation $remediation <-||- 
    -||-> Assert-AreEqual $assignmentId $remediation.PolicyAssignmentId <-||- 
    -||-> Assert-Null $remediation.PolicyDefinitionReferenceId <-||- 
    -||-> Assert-AreEqual "Accepted" $remediation.ProvisioningState <-||- 
    -||-> Assert-AreEqual 2 $remediation.Filters.Locations.Count <-||- 
    -||-> Assert-AreEqualArray $remediation.Filters.Locations @( -||-> "westus2", "westcentralus" <-||- ) <-||- 
    -||-> Assert-AreEqual 3 $remediation.DeploymentSummary.TotalDeployments <-||- 

   
    -||-> $job = ( -||-> $remediation | Stop-AzPolicyRemediation -AsJob <-||- ) <-||- 
    -||-> $job | Wait-Job <-||- 

   
    -||-> $remediation =  -||-> Get-AzPolicyRemediation -Name $remediationName <-||-  <-||- 
    -||-> Validate-Remediation $remediation <-||- 
    -||-> Assert-AreEqual $remediationName $remediation.Name <-||- 
    -||-> Assert-AreEqual $assignmentId $remediation.PolicyAssignmentId <-||- 
    -||-> Assert-AreEqual "Canceled" $remediation.ProvisioningState <-||- 
    -||-> Assert-AreEqual 2 $remediation.Filters.Locations.Count <-||- 
    -||-> Assert-AreEqualArray $remediation.Filters.Locations @( -||-> "westus2", "westcentralus" <-||- ) <-||- 
    -||-> Assert-AreEqual 3 $remediation.DeploymentSummary.TotalDeployments <-||- 
    -||-> Assert-AreEqual 0 $remediation.DeploymentSummary.FailedDeployments <-||- 

   
    -||-> $remediation =  -||-> Get-AzPolicyRemediation -Name $remediationName -IncludeDetail <-||-  <-||- 
    -||-> Assert-AreEqual 3 $remediation.Deployments.Count <-||- 
    -||-> $remediation.Deployments | ForEach-Object {
       -||-> Validate-RemediationDeployment $_ <-||- 
       -||-> Assert-AreEqual "Canceled" $_.Status <-||- 
   } <-||- 

   
    -||-> $remediation =  -||-> Get-AzPolicyRemediation -Name $remediationName -IncludeDetail -Top 2 <-||-  <-||- 
    -||-> Assert-AreEqual 2 $remediation.Deployments.Count <-||- 
    -||-> $remediation.Deployments | ForEach-Object {
       -||-> Validate-RemediationDeployment $_ <-||- 
       -||-> Assert-AreEqual "Canceled" $_.Status <-||- 
   } <-||- 

   
    -||-> $remediations =  -||-> Get-AzPolicyRemediation <-||-  <-||- 
    -||-> Assert-AreEqual 72 $remediations.Count <-||- 
    -||-> Validate-Remediation $remediations[10] <-||- 

   
    -||-> $remediations =  -||-> Get-AzPolicyRemediation -Top 5 <-||-  <-||- 
    -||-> Assert-AreEqual 5 $remediations.Count <-||- 
    -||-> Validate-Remediation $remediations[0] <-||- 

   
    -||-> $remediations =  -||-> Get-AzPolicyRemediation -Filter "PolicyAssignmentId eq '$assignmentId'" <-||-  <-||- 
    -||-> Assert-AreEqual 2 $remediations.Count <-||- 
    -||-> $remediations | ForEach-Object {
       -||-> Validate-Remediation $_ <-||- 
       -||-> Assert-AreEqual $assignmentId $_.PolicyAssignmentId <-||- 
   } <-||- 

   
    -||-> $result = ( -||-> $remediation | Remove-AzPolicyRemediation -PassThru <-||- ) <-||- 
    -||-> Assert-AreEqual $true $result <-||- 
} <-||- 


 -||-> function Remediation-ResourceGroupScope-Crud
{
    -||-> $assignmentId =  -||-> Get-TestRemediationSubscriptionPolicyAssignmentId <-||-  <-||- 
    -||-> $remediationName = "PSTestRemediation" <-||- 
    -||-> $resourceGroupName = "elpere" <-||- 

   
    -||-> $remediation =  -||-> Start-AzPolicyRemediation -ResourceGroupName $resourceGroupName -PolicyAssignmentId $assignmentId -Name $remediationName <-||-  <-||- 
    -||-> Validate-Remediation $remediation <-||- 
    -||-> Assert-AreEqual $assignmentId $remediation.PolicyAssignmentId <-||- 
    -||-> Assert-Null $remediation.PolicyDefinitionReferenceId <-||- 
    -||-> Assert-AreEqual "Accepted" $remediation.ProvisioningState <-||- 
    -||-> Assert-Null $remediation.Filters <-||- 
    -||-> Assert-AreEqual 5 $remediation.DeploymentSummary.TotalDeployments <-||- 

   
   -||-> Stop-AzPolicyRemediation -ResourceId $remediation.Id <-||- 

   
    -||-> $remediation =  -||-> Get-AzPolicyRemediation -ResourceGroupName $resourceGroupName -Name $remediationName <-||-  <-||- 
    -||-> Validate-Remediation $remediation <-||- 
    -||-> Assert-AreEqual $remediationName $remediation.Name <-||- 
    -||-> Assert-AreEqual $assignmentId $remediation.PolicyAssignmentId <-||- 
    -||-> Assert-AreEqual "Canceled" $remediation.ProvisioningState <-||- 
    -||-> Assert-Null $remediation.Filters <-||- 
    -||-> Assert-AreEqual 5 $remediation.DeploymentSummary.TotalDeployments <-||- 
    -||-> Assert-AreEqual 0 $remediation.DeploymentSummary.FailedDeployments <-||- 

   
    -||-> $remediation =  -||-> Get-AzPolicyRemediation -ResourceGroupName $resourceGroupName -Name $remediationName -IncludeDetail <-||-  <-||- 
    -||-> Assert-AreEqual 5 $remediation.Deployments.Count <-||- 
    -||-> $remediation.Deployments | ForEach-Object {
       -||-> Validate-RemediationDeployment $_ <-||- 
       -||-> Assert-AreEqual "Canceled" $_.Status <-||- 
   } <-||- 

   
    -||-> $remediation =  -||-> Get-AzPolicyRemediation -ResourceGroupName $resourceGroupName -Name $remediationName -IncludeDetail -Top 2 <-||-  <-||- 
    -||-> Assert-AreEqual 2 $remediation.Deployments.Count <-||- 
    -||-> $remediation.Deployments | ForEach-Object {
       -||-> Validate-RemediationDeployment $_ <-||- 
       -||-> Assert-AreEqual "Canceled" $_.Status <-||- 
   } <-||- 

   
    -||-> $remediations =  -||-> Get-AzPolicyRemediation -ResourceGroupName $resourceGroupName <-||-  <-||- 
    -||-> Assert-AreEqual 11 $remediations.Count <-||- 
    -||-> Validate-Remediation $remediations[5] <-||- 

   
    -||-> $remediations =  -||-> Get-AzPolicyRemediation -ResourceGroupName $resourceGroupName -Top 5 <-||-  <-||- 
    -||-> Assert-AreEqual 5 $remediations.Count <-||- 
    -||-> Validate-Remediation $remediations[0] <-||- 

   
    -||-> $remediations =  -||-> Get-AzPolicyRemediation -ResourceGroupName $resourceGroupName -Filter "PolicyAssignmentId eq '$assignmentId'" <-||-  <-||- 
    -||-> Assert-AreEqual 1 $remediations.Count <-||- 
    -||-> $remediations | ForEach-Object {
       -||-> Validate-Remediation $_ <-||- 
       -||-> Assert-AreEqual $assignmentId $_.PolicyAssignmentId <-||- 
   } <-||- 

   
    -||-> $result = ( -||-> Remove-AzPolicyRemediation -ResourceGroupName $resourceGroupName -Name $remediationName -PassThru <-||- ) <-||- 
    -||-> Assert-AreEqual $true $result <-||- 
} <-||- 


 -||-> function Remediation-ResourceScope-Crud
{
    -||-> $assignmentId =  -||-> Get-TestRemediationSubscriptionPolicyAssignmentId <-||-  <-||- 
    -||-> $remediationName = "PSTestRemediation" <-||- 
    -||-> $scope = "/subscriptions/d0610b27-9663-4c05-89f8-5b4be01e86a5/resourceGroups/elpere/providers/Microsoft.KeyVault/vaults/elpereKv" <-||- 

   
    -||-> $remediation =  -||-> Start-AzPolicyRemediation -Scope $scope -PolicyAssignmentId $assignmentId -Name $remediationName <-||-  <-||- 
    -||-> Validate-Remediation $remediation <-||- 
    -||-> Assert-AreEqual $assignmentId $remediation.PolicyAssignmentId <-||- 
    -||-> Assert-Null $remediation.PolicyDefinitionReferenceId <-||- 
    -||-> Assert-AreEqual "Accepted" $remediation.ProvisioningState <-||- 
    -||-> Assert-Null $remediation.Filters <-||- 
    -||-> Assert-AreEqual 1 $remediation.DeploymentSummary.TotalDeployments <-||- 

   
    -||-> $job =  -||-> Stop-AzPolicyRemediation -Scope $scope -Name $remediationName -AsJob <-||-  <-||- 
    -||-> $job | Wait-Job <-||- 

   
    -||-> $remediation =  -||-> Get-AzPolicyRemediation -Scope $scope -Name $remediationName <-||-  <-||- 
    -||-> Validate-Remediation $remediation <-||- 
    -||-> Assert-AreEqual $remediationName $remediation.Name <-||- 
    -||-> Assert-AreEqual $assignmentId $remediation.PolicyAssignmentId <-||- 
    -||-> Assert-AreEqual "Canceled" $remediation.ProvisioningState <-||- 
    -||-> Assert-Null $remediation.Filters <-||- 
    -||-> Assert-AreEqual 1 $remediation.DeploymentSummary.TotalDeployments <-||- 
    -||-> Assert-AreEqual 0 $remediation.DeploymentSummary.FailedDeployments <-||- 

   
    -||-> $remediation =  -||-> Get-AzPolicyRemediation -Scope $scope -Name $remediationName -IncludeDetail <-||-  <-||- 
    -||-> Assert-AreEqual 1 $remediation.Deployments.Count <-||- 
    -||-> $remediation.Deployments | ForEach-Object {
       -||-> Validate-RemediationDeployment $_ <-||- 
       -||-> Assert-AreEqual "Canceled" $_.Status <-||- 
   } <-||- 

   
    -||-> $remediation =  -||-> Get-AzPolicyRemediation -Scope $scope -Name $remediationName -IncludeDetail -Top 2 <-||-  <-||- 
    -||-> Assert-AreEqual 1 $remediation.Deployments.Count <-||- 
    -||-> $remediation.Deployments | ForEach-Object {
       -||-> Validate-RemediationDeployment $_ <-||- 
       -||-> Assert-AreEqual "Canceled" $_.Status <-||- 
   } <-||- 

   
    -||-> $remediations =  -||-> Get-AzPolicyRemediation -Scope $scope <-||-  <-||- 
    -||-> Assert-AreEqual 1 $remediations.Count <-||- 
    -||-> Validate-Remediation $remediations[0] <-||- 

   
    -||-> $remediations =  -||-> Get-AzPolicyRemediation -Scope $scope -Filter "PolicyAssignmentId eq '$assignmentId'" <-||-  <-||- 
    -||-> Assert-AreEqual 1 $remediations.Count <-||- 
    -||-> $remediations | ForEach-Object {
       -||-> Validate-Remediation $_ <-||- 
       -||-> Assert-AreEqual $assignmentId $_.PolicyAssignmentId <-||- 
   } <-||- 

   
    -||-> $result = ( -||-> Remove-AzPolicyRemediation -Scope $scope -Name $remediationName -PassThru <-||- ) <-||- 
    -||-> Assert-AreEqual $true $result <-||- 
} <-||- 


 -||-> function Remediation-ManagementGroupScope-Crud
{
    -||-> $assignmentId =  -||-> Get-TestRemediationMgPolicyAssignmentId <-||-  <-||- 
    -||-> $remediationName = "PSTestRemediation" <-||- 
    -||-> $managementGroupId = "PolicyUIMG" <-||- 

   
    -||-> $remediation =  -||-> Start-AzPolicyRemediation -ManagementGroupName $managementGroupId -PolicyAssignmentId $assignmentId -Name $remediationName <-||-  <-||- 
    -||-> Validate-Remediation $remediation <-||- 
    -||-> Assert-AreEqual $assignmentId $remediation.PolicyAssignmentId <-||- 
    -||-> Assert-Null $remediation.PolicyDefinitionReferenceId <-||- 
    -||-> Assert-AreEqual "Accepted" $remediation.ProvisioningState <-||- 
    -||-> Assert-Null $remediation.Filters <-||- 
    -||-> Assert-AreEqual 1 $remediation.DeploymentSummary.TotalDeployments <-||- 

   
    -||-> Stop-AzPolicyRemediation -ManagementGroupName $managementGroupId -Name $remediationName <-||- 

   
    -||-> $remediation =  -||-> Get-AzPolicyRemediation -ManagementGroupName $managementGroupId -Name $remediationName <-||-  <-||- 
    -||-> Validate-Remediation $remediation <-||- 
    -||-> Assert-AreEqual $remediationName $remediation.Name <-||- 
    -||-> Assert-AreEqual $assignmentId $remediation.PolicyAssignmentId <-||- 
    -||-> Assert-AreEqual "Canceled" $remediation.ProvisioningState <-||- 
    -||-> Assert-Null $remediation.Filters <-||- 
    -||-> Assert-AreEqual 1 $remediation.DeploymentSummary.TotalDeployments <-||- 
    -||-> Assert-AreEqual 0 $remediation.DeploymentSummary.FailedDeployments <-||- 

   
    -||-> $remediation =  -||-> Get-AzPolicyRemediation -ManagementGroupName $managementGroupId -Name $remediationName -IncludeDetail <-||-  <-||- 
    -||-> Assert-AreEqual 1 $remediation.Deployments.Count <-||- 
    -||-> $remediation.Deployments | ForEach-Object {
       -||-> Validate-RemediationDeployment $_ <-||- 
       -||-> Assert-AreEqual "Canceled" $_.Status <-||- 
   } <-||- 

   
    -||-> $remediation =  -||-> Get-AzPolicyRemediation -ManagementGroupName $managementGroupId -Name $remediationName -IncludeDetail -Top 2 <-||-  <-||- 
    -||-> Assert-AreEqual 1 $remediation.Deployments.Count <-||- 
    -||-> $remediation.Deployments | ForEach-Object {
       -||-> Validate-RemediationDeployment $_ <-||- 
       -||-> Assert-AreEqual "Canceled" $_.Status <-||- 
   } <-||- 

   
    -||-> $remediations =  -||-> Get-AzPolicyRemediation -ManagementGroupName $managementGroupId <-||-  <-||- 
    -||-> Assert-AreEqual 3 $remediations.Count <-||- 
    -||-> Validate-Remediation $remediations[2] <-||- 

   
    -||-> $remediations =  -||-> Get-AzPolicyRemediation -Top 2 <-||-  <-||- 
    -||-> Assert-AreEqual 2 $remediations.Count <-||- 
    -||-> Validate-Remediation $remediations[1] <-||- 

   
    -||-> $remediations =  -||-> Get-AzPolicyRemediation -ManagementGroupName $managementGroupId -Filter "PolicyAssignmentId eq '$assignmentId'" <-||-  <-||- 
    -||-> Assert-AreEqual 1 $remediations.Count <-||- 
    -||-> $remediations | ForEach-Object {
       -||-> Validate-Remediation $_ <-||- 
       -||-> Assert-AreEqual $assignmentId $_.PolicyAssignmentId <-||- 
   } <-||- 

   
    -||-> $result = ( -||-> Remove-AzPolicyRemediation -ResourceId $remediation.Id -PassThru <-||- ) <-||- 
    -||-> Assert-AreEqual $true $result <-||- 
} <-||- 


 -||-> function Remediation-BackgroundJobs {
    -||-> $assignmentId =  -||-> Get-TestRemediationSubscriptionPolicyAssignmentId <-||-  <-||- 
    -||-> $remediationName = "PSTestRemediation" <-||- 

   
    -||-> $job =  -||-> Start-AzPolicyRemediation -PolicyAssignmentId $assignmentId -Name $remediationName -LocationFilter "eastus2" -AsJob <-||-  <-||- 
    -||-> $job | Wait-Job <-||- 
    -||-> Assert-AreEqual "Completed" $job.State <-||- 
    -||-> $remediation =  -||-> $job | Receive-Job <-||-  <-||- 

    -||-> Validate-Remediation $remediation <-||- 
    -||-> Assert-AreEqual $assignmentId $remediation.PolicyAssignmentId <-||- 
    -||-> Assert-Null $remediation.PolicyDefinitionReferenceId <-||- 
    -||-> Assert-AreEqual "Succeeded" $remediation.ProvisioningState <-||- 
    -||-> Assert-AreEqual 1 $remediation.Filters.Locations.Count <-||- 
    -||-> Assert-AreEqualArray $remediation.Filters.Locations @( -||-> "eastus2" <-||- ) <-||- 
    -||-> Assert-AreEqual 1 $remediation.DeploymentSummary.TotalDeployments <-||- 
    -||-> Assert-AreEqual 1 $remediation.DeploymentSummary.SuccessfulDeployments <-||- 
    -||-> Assert-AreEqual 0 $remediation.DeploymentSummary.FailedDeployments <-||- 

   
    -||-> $remediation =  -||-> Start-AzPolicyRemediation -PolicyAssignmentId $assignmentId -Name $remediationName -LocationFilter "eastus2" <-||-  <-||- 

   
    -||-> $job = ( -||-> $remediation | Remove-AzPolicyRemediation -AllowStop -PassThru -AsJob <-||- ) <-||- 
    -||-> $job | Wait-Job <-||- 
    -||-> Assert-AreEqual "Completed" $job.State <-||- 
    -||-> $result =  -||-> $job | Receive-Job <-||-  <-||- 
    -||-> Assert-AreEqual $true $result <-||- 
} <-||- 

