














 -||-> function Test-RoleDefinitionCreateTests
{
    
     -||-> $rdName = 'CustomRole Tests Role' <-||- 
     -||-> New-AzureRmRoleDefinition -InputFile NewRoleDefinition.json <-||- 

     -||-> $rd =  -||-> Get-AzureRmRoleDefinition -Name $rdName <-||-  <-||- 
	 -||-> Assert-AreEqual "Test role" $rd.Description <-||-  
	 -||-> Assert-AreEqual $true $rd.IsCustom <-||- 
	 -||-> Assert-NotNull $rd.Actions <-||- 
	 -||-> Assert-AreEqual "Microsoft.Authorization/*/read" $rd.Actions[0] <-||- 
	 -||-> Assert-AreEqual "Microsoft.Support/*" $rd.Actions[1] <-||- 
	 -||-> Assert-NotNull $rd.AssignableScopes <-||- 
	
	
	 -||-> $roleDef =  -||-> Get-AzureRmRoleDefinition -Name "Reader" <-||-  <-||- 
	 -||-> $roleDef.Id = $null <-||- 
	 -||-> $roleDef.Name = "Custom Reader" <-||- 
	 -||-> $roleDef.Actions.Add("Microsoft.ClassicCompute/virtualMachines/restart/action") <-||- 
	 -||-> $roleDef.Description = "Read, monitor and restart virtual machines" <-||- 
     -||-> $roleDef.AssignableScopes[0] = "/subscriptions/00977cdb-163f-435f-9c32-39ec8ae61f4d" <-||- 

	 -||-> New-AzureRmRoleDefinition -Role $roleDef <-||- 
	 -||-> $addedRoleDef =  -||-> Get-AzureRmRoleDefinition -Name "Custom Reader" <-||-  <-||- 

	 -||-> Assert-NotNull $addedRoleDef.Actions <-||- 
	 -||-> Assert-AreEqual $roleDef.Description $addedRoleDef.Description <-||- 
	 -||-> Assert-AreEqual $roleDef.AssignableScopes $addedRoleDef.AssignableScopes <-||- 
	 -||-> Assert-AreEqual $true $addedRoleDef.IsCustom <-||- 

     -||-> Remove-AzureRmRoleDefinition -Id $addedRoleDef.Id -Force <-||- 
     -||-> Remove-AzureRmRoleDefinition -Id $rd.Id -Force <-||- 
    
} <-||- 


 -||-> function Test-RdNegativeScenarios
{
	
	 -||-> Add-Type -Path ".\\Microsoft.Azure.Commands.Resources.dll" <-||- 

    
     -||-> $rdName = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' <-||- 
     -||-> $rdNull =  -||-> Get-AzureRmRoleDefinition -Name $rdName <-||-  <-||- 
     -||-> Assert-Null $rdNull <-||- 

     -||-> $rdId = '85E460B3-89E9-48BA-9DCD-A8A99D64A674' <-||- 
	
     -||-> $badIdException = "RoleDefinitionDoesNotExist: The specified role definition with ID '" + $rdId + "' does not exist." <-||- 

    
     -||-> Assert-Throws {  -||-> Set-AzureRmRoleDefinition -InputFile .\Resources\RoleDefinition.json <-||-  } $badIdException <-||- 

    
     -||-> $roleDefNotProvided = "Parameter set cannot be resolved using the specified named parameters." <-||- 
     -||-> Assert-Throws {  -||-> Set-AzureRmRoleDefinition <-||-  } $roleDefNotProvided <-||- 

    
     -||-> $roleDefNotProvided = "Cannot validate argument on parameter 'InputFile'. The argument is null or empty. Provide an argument that is not null or empty, and then try the command again." <-||- 
     -||-> Assert-Throws {  -||-> Set-AzureRmRoleDefinition -InputFile "" <-||-  } $roleDefNotProvided <-||- 
     -||-> Assert-Throws {  -||-> Set-AzureRmRoleDefinition -InputFile "" -Role $rdNull <-||-  } $roleDefNotProvided <-||- 

    
     -||-> $roleDefNotProvided = "Cannot validate argument on parameter 'Role'. The argument is null or empty. Provide an argument that is not null or empty, and then try the command again." <-||- 
     -||-> Assert-Throws {  -||-> Set-AzureRmRoleDefinition -Role $rdNull <-||-  } $roleDefNotProvided <-||- 
     -||-> Assert-Throws {  -||-> Set-AzureRmRoleDefinition -InputFile .\Resources\RoleDefinition.json -Role $rd <-||-  } $roleDefNotProvided <-||- 

    

    
     -||-> $missingSubscription = "MissingSubscription: The request did not have a provided subscription. All requests must have an associated subscription Id." <-||- 
     -||-> Assert-Throws {  -||-> Remove-AzureRmRoleDefinition -Id $rdId -Force <-||- } $badIdException <-||- 
} <-||- 


 -||-> function Test-RDPositiveScenarios
{
    
     -||-> Add-Type -Path ".\\Microsoft.Azure.Commands.Resources.dll" <-||- 

    
     -||-> $rdName = 'Another tests role' <-||- 
     -||-> [Microsoft.Azure.Commands.Resources.Models.Authorization.AuthorizationClient]::RoleDefinitionNames.Enqueue("032F61D2-ED09-40C9-8657-26A273DA7BAE") <-||- 
     -||-> $rd =  -||-> New-AzureRmRoleDefinition -InputFile .\Resources\RoleDefinition.json <-||-  <-||- 
     -||-> $rd =  -||-> Get-AzureRmRoleDefinition -Name $rdName <-||-  <-||- 

    
     -||-> $rd.Actions.Add('Microsoft.Authorization/*/read') <-||- 
     -||-> $updatedRd =  -||-> Set-AzureRmRoleDefinition -Role $rd <-||-  <-||- 
     -||-> Assert-NotNull $updatedRd <-||- 

    
     -||-> $deletedRd =  -||-> Remove-AzureRmRoleDefinition -Id $rd.Id -Force -PassThru <-||-  <-||- 
     -||-> Assert-AreEqual $rd.Name $deletedRd.Name <-||- 

    
     -||-> $readRd =  -||-> Get-AzureRmRoleDefinition -Name $rd.Name <-||-  <-||- 
     -||-> Assert-Null $readRd <-||- 
} <-||- 


 -||-> function Test-RDRemove
{
    
     -||-> Add-Type -Path ".\\Microsoft.Azure.Commands.Resources.dll" <-||- 

    
     -||-> [Microsoft.Azure.Commands.Resources.Models.Authorization.AuthorizationClient]::RoleDefinitionNames.Enqueue("65E1D983-ECF4-42D4-8C08-5B1FD6E86335") <-||- 

	 -||-> $subscription = $( -||-> Get-AzureRmContext <-||- ).Subscription <-||- 
	 -||-> $resourceGroups =  -||-> Get-AzureRmResourceGroup | Select-Object -Last 1 -Wait <-||-  <-||- 
	
	 -||-> $scope = "/subscriptions/" + $subscription[0].SubscriptionId <-||- 
	 -||-> $rgScope = "/subscriptions/" + $subscription[0].SubscriptionId + "/resourceGroups/" + $resourceGroups[0].ResourceGroupName <-||- 

	 -||-> $roleDef =  -||-> Get-AzureRmRoleDefinition -Name "Reader" <-||-  <-||- 
	 -||-> $roleDef.Id = $null <-||- 
	 -||-> $roleDef.Name = "CustomRole123_65E1D983-ECF4-42D4-8C08-5B1FD6E86335" <-||- 
	 -||-> $roleDef.Description = "Test Remove RD" <-||- 
     -||-> $roleDef.AssignableScopes[0] = $rgScope <-||- 

     -||-> $Rd =  -||-> New-AzureRmRoleDefinition -Role $roleDef <-||-  <-||- 
     -||-> Assert-NotNull $Rd <-||- 


    
	 -||-> $badIdException = "RoleDefinitionDoesNotExist: The specified role definition with ID '" + $Rd.Id + "' does not exist." <-||- 
	 -||-> Assert-Throws {  -||-> Remove-AzureRmRoleDefinition -Id $Rd.Id -Scope $scope -Force -PassThru <-||- } $badIdException <-||- 

	
	 -||-> $badIdException = "RoleDefinitionDoesNotExist: The specified role definition with ID '" + $Rd.Id + "' does not exist." <-||- 
	 -||-> Assert-Throws {  -||-> Remove-AzureRmRoleDefinition -Id $Rd.Id -Scope $scope -Force -PassThru <-||- } $badIdException <-||- 

	
	 -||-> $deletedRd =  -||-> Remove-AzureRmRoleDefinition -Id $Rd.Id -Scope $rgScope -Force -PassThru <-||-  <-||- 
	 -||-> Assert-AreEqual $Rd.Name $deletedRd.Name <-||- 
} <-||- 


 -||-> function Test-RDGet
{
    
     -||-> Add-Type -Path ".\\Microsoft.Azure.Commands.Resources.dll" <-||- 
	
	 -||-> $subscription = $( -||-> Get-AzureRmContext <-||- ).Subscription <-||- 

	 -||-> $resource =  -||-> Get-AzureRmResource | Select-Object -Last 1 -Wait <-||-  <-||- 
     -||-> Assert-NotNull $resource "Cannot find any resource to continue test execution." <-||- 
	
	 -||-> $subScope = "/subscriptions/" + $subscription[0].SubscriptionId <-||- 
	 -||-> $rgScope = "/subscriptions/" + $subscription[0].SubscriptionId + "/resourceGroups/" + $resource.ResourceGroupName <-||- 
	 -||-> $resourceScope = $resource.ResourceId <-||- 
	
     -||-> [Microsoft.Azure.Commands.Resources.Models.Authorization.AuthorizationClient]::RoleDefinitionNames.Enqueue("99CC0F56-7395-4097-A31E-CC63874AC5EF") <-||- 
	 -||-> $roleDef1 =  -||-> Get-AzureRmRoleDefinition -Name "Reader" <-||-  <-||- 
	 -||-> $roleDef1.Id = $null <-||- 
	 -||-> $roleDef1.Name = "CustomRole_99CC0F56-7395-4097-A31E-CC63874AC5EF" <-||- 
	 -||-> $roleDef1.Description = "Test Get RD" <-||- 
     -||-> $roleDef1.AssignableScopes[0] = $subScope <-||-  

     -||-> $roleDefSubScope =  -||-> New-AzureRmRoleDefinition -Role $roleDef1 <-||-  <-||- 
     -||-> Assert-NotNull $roleDefSubScope <-||- 

	 -||-> [Microsoft.Azure.Commands.Resources.Models.Authorization.AuthorizationClient]::RoleDefinitionNames.Enqueue("E3CC9CD7-9D0A-47EC-8C75-07C544065220") <-||- 
	 -||-> $roleDef1.Id = $null <-||- 
	 -||-> $roleDef1.Name = "CustomRole_E3CC9CD7-9D0A-47EC-8C75-07C544065220" <-||- 
	 -||-> $roleDef1.Description = "Test Get RD" <-||- 
     -||-> $roleDef1.AssignableScopes[0] = $rgScope <-||- 

     -||-> $roleDefRGScope =  -||-> New-AzureRmRoleDefinition -Role $roleDef1 <-||-  <-||- 
     -||-> Assert-NotNull $roleDefRGScope <-||- 
	
	 -||-> [Microsoft.Azure.Commands.Resources.Models.Authorization.AuthorizationClient]::RoleDefinitionNames.Enqueue("8D2E860C-5640-4B7C-BD3C-80940C715033") <-||- 
	 -||-> $roleDef1.Id = $null <-||- 
	 -||-> $roleDef1.Name = "CustomRole_8D2E860C-5640-4B7C-BD3C-80940C715033" <-||- 
	 -||-> $roleDef1.Description = "Test Get RD" <-||- 
     -||-> $roleDef1.AssignableScopes[0] = $resourceScope <-||- 

     -||-> $roleDefResourceScope =  -||-> New-AzureRmRoleDefinition -Role $roleDef1 <-||-  <-||- 
     -||-> Assert-NotNull $roleDefResourceScope <-||- 

    
	 -||-> $roles1 =  -||-> Get-AzureRmRoleDefinition -Scope $subScope <-||-  <-||- 	
	

	
	 -||-> $roles2 =  -||-> Get-AzureRmRoleDefinition -Scope $rgScope <-||-  <-||- 
	

	
	 -||-> $roles3 =  -||-> Get-AzureRmRoleDefinition -Scope $resourceScope <-||-  <-||- 
	


	
	 -||-> $deletedRd =  -||-> Remove-AzureRmRoleDefinition -Id $roleDefSubScope.Id -Scope $subScope -Force -PassThru <-||-  <-||- 
	 -||-> Assert-AreEqual $roleDefSubScope.Name $deletedRd.Name <-||- 

	
	 -||-> $deletedRd =  -||-> Remove-AzureRmRoleDefinition -Id $roleDefRGScope.Id -Scope $rgScope -Force -PassThru <-||-  <-||- 
	 -||-> Assert-AreEqual $roleDefRGScope.Name $deletedRd.Name <-||- 

	
	 -||-> $deletedRd =  -||-> Remove-AzureRmRoleDefinition -Id $roleDefResourceScope.Id -Scope $resourceScope -Force -PassThru <-||-  <-||- 
	 -||-> Assert-AreEqual $roleDefResourceScope.Name $deletedRd.Name <-||- 
} <-||- 

