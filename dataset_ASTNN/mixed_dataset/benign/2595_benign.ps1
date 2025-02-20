















 -||-> function Test-AEMExtensionBasicWindowsWAD
{
     -||-> $rgname =  -||-> Get-ComputeTestResourceName <-||-  <-||- 
     -||-> $loc =  -||-> Get-ComputeVMLocation <-||-  <-||- 

     -||-> try
    {
        
         -||-> $vm =  -||-> Create-AdvancedVM -rgname $rgname -loc $loc <-||-  <-||- 
         -||-> $vmname = $vm.Name <-||- 

        
         -||-> $extension =  -||-> Get-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname <-||-  <-||- 
         -||-> Assert-Null $extension <-||- 
        
         -||-> $testResult =  -||-> Test-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname -SkipStorageCheck <-||-  <-||- 
         -||-> Assert-False {  -||-> $testResult.Result <-||-  } <-||- 

        
         -||-> Set-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname -SkipStorage -EnableWAD <-||- 
         -||-> $extension =  -||-> Get-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname <-||-  <-||- 

         -||-> Assert-NotNull $extension <-||- 
         -||-> Assert-AreEqual $extension.Publisher 'Microsoft.AzureCAT.AzureEnhancedMonitoring' <-||- 
         -||-> Assert-AreEqual $extension.ExtensionType 'AzureCATExtensionHandler' <-||- 
         -||-> Assert-AreEqual $extension.Name 'AzureCATExtensionHandler' <-||- 
         -||-> $settings =  -||-> $extension.PublicSettings | ConvertFrom-Json <-||-  <-||- 
         -||-> Assert-NotNull $settings.cfg <-||- 

        
         -||-> $testResult =  -||-> Test-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname -WaitTimeInMinutes 50 -SkipStorageCheck <-||-  <-||- 
         -||-> Assert-True {  -||-> $testResult.Result <-||-  } <-||- 
         -||-> Assert-True {  -||-> ( -||-> $testResult.PartialResults.Count -gt 0 <-||- ) <-||-  } <-||- 

        
         -||-> Remove-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname <-||- 
         -||-> $extension =  -||-> Get-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname <-||-  <-||- 
         -||-> Assert-Null $extension <-||- 
    }
    finally
    {
        
         -||-> Clean-ResourceGroup $rgname <-||- 
    } <-||- 
} <-||- 

 -||-> function Test-AEMExtensionBasicWindows
{
     -||-> $rgname =  -||-> Get-ComputeTestResourceName <-||-  <-||- 
     -||-> $loc =  -||-> Get-ComputeVMLocation <-||-  <-||- 

     -||-> try
    {
        
         -||-> $vm =  -||-> Create-AdvancedVM -rgname $rgname -loc $loc <-||-  <-||- 
         -||-> $vmname = $vm.Name <-||- 

        
         -||-> $extension =  -||-> Get-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname <-||-  <-||- 
         -||-> Assert-Null $extension <-||- 
        
         -||-> $testResult =  -||-> Test-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname -SkipStorageCheck <-||-  <-||- 
         -||-> Assert-False {  -||-> $testResult.Result <-||-  } <-||- 

        
         -||-> Set-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname -SkipStorage <-||- 
         -||-> $extension =  -||-> Get-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname <-||-  <-||- 

         -||-> Assert-NotNull $extension <-||- 
         -||-> Assert-AreEqual $extension.Publisher 'Microsoft.AzureCAT.AzureEnhancedMonitoring' <-||- 
         -||-> Assert-AreEqual $extension.ExtensionType 'AzureCATExtensionHandler' <-||- 
         -||-> Assert-AreEqual $extension.Name 'AzureCATExtensionHandler' <-||- 
         -||-> $settings =  -||-> $extension.PublicSettings | ConvertFrom-Json <-||-  <-||- 
         -||-> Assert-NotNull $settings.cfg <-||- 

        
         -||-> $testResult =  -||-> Test-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname -WaitTimeInMinutes 50 -SkipStorageCheck <-||-  <-||- 
         -||-> Assert-True {  -||-> $testResult.Result <-||-  } <-||- 
         -||-> Assert-True {  -||-> ( -||-> $testResult.PartialResults.Count -gt 0 <-||- ) <-||-  } <-||- 

        
         -||-> Remove-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname <-||- 
         -||-> $extension =  -||-> Get-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname <-||-  <-||- 
         -||-> Assert-Null $extension <-||- 
    }
    finally
    {
        
         -||-> Clean-ResourceGroup $rgname <-||- 
    } <-||- 
} <-||- 

 -||-> function Test-AEMExtensionAdvancedWindowsWAD
{
     -||-> $rgname =  -||-> Get-ComputeTestResourceName <-||-  <-||- 
     -||-> $loc =  -||-> Get-ComputeVMLocation <-||-  <-||- 

     -||-> try
    {
         -||-> Write-Verbose "Start the test Test-AEMExtensionAdvancedWindows" <-||- 
        
         -||-> $vm =  -||-> Create-AdvancedVM -rgname $rgname -loc $loc -vmsize 'Standard_DS2' -stotype 'Premium_LRS' -nicCount 2 <-||-  <-||- 
         -||-> $vmname = $vm.Name <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedWindows: VM created" <-||- 

        
         -||-> Write-Verbose "Test-AEMExtensionAdvancedWindows: Get with no extension" <-||- 
         -||-> $extension =  -||-> Get-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname <-||-  <-||- 
         -||-> Assert-Null $extension <-||- 

        
         -||-> Write-Verbose "Test-AEMExtensionAdvancedWindows: Test with no extension" <-||- 
         -||-> $res =  -||-> Test-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname -SkipStorageCheck <-||-  <-||- 
         -||-> Assert-False {  -||-> $res.Result <-||-  } <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedWindows: Test done" <-||- 

         -||-> $stoname = 'sto' + $rgname + "2" <-||- ;
         -||-> New-AzureRmStorageAccount -ResourceGroupName $rgname -Name $stoname -Location $loc -Type 'Standard_LRS' <-||- ;

        
         -||-> Write-Verbose "Test-AEMExtensionAdvancedWindows: Set with no extension" <-||- 
         -||-> Set-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname -WADStorageAccountName $stoname -SkipStorage -EnableWAD <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedWindows: Set done" <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedWindows: Get with extension" <-||- 
         -||-> $extension =  -||-> Get-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname <-||-  <-||- 
        

         -||-> Assert-NotNull $extension <-||- 
         -||-> Assert-AreEqual $extension.Publisher 'Microsoft.AzureCAT.AzureEnhancedMonitoring' <-||- 
         -||-> Assert-AreEqual $extension.ExtensionType 'AzureCATExtensionHandler' <-||- 
         -||-> Assert-AreEqual $extension.Name 'AzureCATExtensionHandler' <-||- 
         -||-> $settings =  -||-> $extension.PublicSettings | ConvertFrom-Json <-||-  <-||- 
         -||-> Assert-NotNull $settings.cfg <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedWindows: Get done" <-||- 

        
         -||-> Write-Verbose "Test-AEMExtensionAdvancedWindows: Test with extension" <-||- 
         -||-> $res =  -||-> Test-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname -SkipStorageCheck <-||-  <-||- 
         -||-> Assert-True {  -||-> $res.Result <-||-  } <-||- 
         -||-> Assert-True {  -||-> ( -||-> $res.PartialResults.Count -gt 0 <-||- ) <-||-  } <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedWindows: Test done" <-||- 

        
         -||-> Write-Verbose "Test-AEMExtensionAdvancedWindows: Remove with extension" <-||- 
         -||-> Remove-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedWindows: Remove done" <-||- 

         -||-> Write-Verbose "Test-AEMExtensionAdvancedWindows: Get after remove" <-||- 
         -||-> $extension =  -||-> Get-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname <-||-  <-||- 
         -||-> Assert-Null $extension <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedWindows: Get after remove done" <-||- 
    }
    finally
    {
        
         -||-> Clean-ResourceGroup $rgname <-||- 
    } <-||- 
} <-||- 

 -||-> function Test-AEMExtensionAdvancedWindows
{
     -||-> $rgname =  -||-> Get-ComputeTestResourceName <-||-  <-||- 
     -||-> $loc =  -||-> Get-ComputeVMLocation <-||-  <-||- 

     -||-> try
    {
         -||-> Write-Verbose "Start the test Test-AEMExtensionAdvancedWindows" <-||- 
        
         -||-> $vm =  -||-> Create-AdvancedVM -rgname $rgname -loc $loc -vmsize 'Standard_DS2' -stotype 'Premium_LRS' -nicCount 2 <-||-  <-||- 
         -||-> $vmname = $vm.Name <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedWindows: VM created" <-||- 

        
         -||-> Write-Verbose "Test-AEMExtensionAdvancedWindows: Get with no extension" <-||- 
         -||-> $extension =  -||-> Get-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname <-||-  <-||- 
         -||-> Assert-Null $extension <-||- 

        
         -||-> Write-Verbose "Test-AEMExtensionAdvancedWindows: Test with no extension" <-||- 
         -||-> $res =  -||-> Test-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname -SkipStorageCheck <-||-  <-||- 
         -||-> Assert-False {  -||-> $res.Result <-||-  } <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedWindows: Test done" <-||- 

         -||-> $stoname = 'sto' + $rgname + "2" <-||- ;
         -||-> New-AzureRmStorageAccount -ResourceGroupName $rgname -Name $stoname -Location $loc -Type 'Standard_LRS' <-||- ;

        
         -||-> Write-Verbose "Test-AEMExtensionAdvancedWindows: Set with no extension" <-||- 
         -||-> Set-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname -WADStorageAccountName $stoname -SkipStorage <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedWindows: Set done" <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedWindows: Get with extension" <-||- 
         -||-> $extension =  -||-> Get-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname <-||-  <-||- 
        

         -||-> Assert-NotNull $extension <-||- 
         -||-> Assert-AreEqual $extension.Publisher 'Microsoft.AzureCAT.AzureEnhancedMonitoring' <-||- 
         -||-> Assert-AreEqual $extension.ExtensionType 'AzureCATExtensionHandler' <-||- 
         -||-> Assert-AreEqual $extension.Name 'AzureCATExtensionHandler' <-||- 
         -||-> $settings =  -||-> $extension.PublicSettings | ConvertFrom-Json <-||-  <-||- 
         -||-> Assert-NotNull $settings.cfg <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedWindows: Get done" <-||- 

        
         -||-> Write-Verbose "Test-AEMExtensionAdvancedWindows: Test with extension" <-||- 
         -||-> $res =  -||-> Test-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname -SkipStorageCheck <-||-  <-||- 
         -||-> Assert-True {  -||-> $res.Result <-||-  } <-||- 
         -||-> Assert-True {  -||-> ( -||-> $res.PartialResults.Count -gt 0 <-||- ) <-||-  } <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedWindows: Test done" <-||- 

        
         -||-> Write-Verbose "Test-AEMExtensionAdvancedWindows: Remove with extension" <-||- 
         -||-> Remove-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedWindows: Remove done" <-||- 

         -||-> Write-Verbose "Test-AEMExtensionAdvancedWindows: Get after remove" <-||- 
         -||-> $extension =  -||-> Get-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname <-||-  <-||- 
         -||-> Assert-Null $extension <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedWindows: Get after remove done" <-||- 
    }
    finally
    {
        
         -||-> Clean-ResourceGroup $rgname <-||- 
    } <-||- 
} <-||- 

 -||-> function Test-AEMExtensionAdvancedWindowsMD
{
     -||-> $rgname =  -||-> Get-ComputeTestResourceName <-||-  <-||- 
     -||-> $loc =  -||-> Get-ComputeVMLocation <-||-  <-||- 

     -||-> try
    {
         -||-> Write-Verbose "Start the test Test-AEMExtensionAdvancedWindowsMD" <-||- 
        
         -||-> $vm =  -||-> Create-AdvancedVM -rgname $rgname -loc $loc -vmsize 'Standard_DS2' -stotype 'Premium_LRS' -nicCount 2 -useMD <-||-  <-||- 
         -||-> $vmname = $vm.Name <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedWindowsMD: VM created" <-||- 

        
         -||-> Write-Verbose "Test-AEMExtensionAdvancedWindowsMD: Get with no extension" <-||- 
         -||-> $extension =  -||-> Get-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname <-||-  <-||- 
         -||-> Assert-Null $extension <-||- 

        
         -||-> Write-Verbose "Test-AEMExtensionAdvancedWindowsMD: Test with no extension" <-||- 
         -||-> $res =  -||-> Test-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname -SkipStorageCheck <-||-  <-||- 
         -||-> Assert-False {  -||-> $res.Result <-||-  } <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedWindowsMD: Test done" <-||- 

         -||-> $stoname = 'sto' + $rgname + "2" <-||- ;
         -||-> New-AzureRmStorageAccount -ResourceGroupName $rgname -Name $stoname -Location $loc -Type 'Standard_LRS' <-||- ;

        
         -||-> Write-Verbose "Test-AEMExtensionAdvancedWindowsMD: Set with no extension" <-||- 
         -||-> Set-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname -WADStorageAccountName $stoname -SkipStorage <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedWindowsMD: Set done" <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedWindowsMD: Get with extension" <-||- 
         -||-> $extension =  -||-> Get-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname <-||-  <-||- 
        

         -||-> Assert-NotNull $extension <-||- 
         -||-> Assert-AreEqual $extension.Publisher 'Microsoft.AzureCAT.AzureEnhancedMonitoring' <-||- 
         -||-> Assert-AreEqual $extension.ExtensionType 'AzureCATExtensionHandler' <-||- 
         -||-> Assert-AreEqual $extension.Name 'AzureCATExtensionHandler' <-||- 
         -||-> $settings =  -||-> $extension.PublicSettings | ConvertFrom-Json <-||-  <-||- 
         -||-> Assert-NotNull $settings.cfg <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedWindowsMD: Get done" <-||- 

        
         -||-> Write-Verbose "Test-AEMExtensionAdvancedWindowsMD: Test with extension" <-||- 
         -||-> $res =  -||-> Test-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname -SkipStorageCheck <-||-  <-||- 
         -||-> Assert-True {  -||-> $res.Result <-||-  } <-||- 
         -||-> Assert-True {  -||-> ( -||-> $res.PartialResults.Count -gt 0 <-||- ) <-||-  } <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedWindowsMD: Test done" <-||- 

        
         -||-> Write-Verbose "Test-AEMExtensionAdvancedWindowsMD: Remove with extension" <-||- 
         -||-> Remove-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedWindowsMD: Remove done" <-||- 

         -||-> Write-Verbose "Test-AEMExtensionAdvancedWindowsMD: Get after remove" <-||- 
         -||-> $extension =  -||-> Get-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname <-||-  <-||- 
         -||-> Assert-Null $extension <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedWindowsMD: Get after remove done" <-||- 
    }
    finally
    {
        
         -||-> Clean-ResourceGroup $rgname <-||- 
    } <-||- 
} <-||- 

 -||-> function Test-AEMExtensionAdvancedLinuxMD
{
     -||-> $rgname =  -||-> Get-ComputeTestResourceName <-||-  <-||- 
     -||-> $loc =  -||-> Get-ComputeVMLocation <-||-  <-||- 

     -||-> try
    {
         -||-> Write-Host "Start the test Test-AEMExtensionAdvancedLinuxMD" <-||- 
        
         -||-> $vm =  -||-> Create-AdvancedVM -rgname $rgname -loc $loc -vmsize 'Standard_DS2' -stotype 'Premium_LRS' -nicCount 2 -useMD -linux <-||-  <-||- 
		 -||-> $vmname = $vm.Name <-||- 
		 -||-> $vm =  -||-> Get-AzureRmVM -ResourceGroupName $rgname -Name $vmname <-||-  <-||- 
		 -||-> Add-AzureRmVMDataDisk -VM $vm -StorageAccountType StandardLRS -Lun ( -||-> ( -||-> $vm.StorageProfile.DataDisks | select -ExpandProperty Lun | Measure-Object -Maximum <-||- ).Maximum + 1 <-||- ) -CreateOption Empty -DiskSizeInGB 10 | Update-AzureRmVM <-||- 
		
        
         -||-> Write-Verbose "Test-AEMExtensionAdvancedLinuxMD: VM created" <-||- 

        
         -||-> Write-Verbose "Test-AEMExtensionAdvancedLinuxMD: Get with no extension" <-||- 
         -||-> $extension =  -||-> Get-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname <-||-  <-||- 
         -||-> Assert-Null $extension <-||- 

        
         -||-> Write-Verbose "Test-AEMExtensionAdvancedLinuxMD: Test with no extension" <-||- 
         -||-> $res =  -||-> Test-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname -SkipStorageCheck <-||-  <-||- 
         -||-> Assert-False {  -||-> $res.Result <-||-  } <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedLinuxMD: Test done" <-||- 

         -||-> $stoname = 'sto' + $rgname + "2" <-||- ;
         -||-> New-AzureRmStorageAccount -ResourceGroupName $rgname -Name $stoname -Location $loc -Type 'Standard_LRS' <-||- ;

        
         -||-> Write-Verbose "Test-AEMExtensionAdvancedLinuxMD: Set with no extension" <-||- 
         -||-> Set-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname -WADStorageAccountName $stoname -SkipStorage <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedLinuxMD: Set done" <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedLinuxMD: Get with extension" <-||- 
         -||-> $extension =  -||-> Get-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname <-||-  <-||- 
        

         -||-> Assert-NotNull $extension <-||- 
         -||-> Assert-AreEqual $extension.Publisher 'Microsoft.OSTCExtensions' <-||- 
         -||-> Assert-AreEqual $extension.ExtensionType 'AzureEnhancedMonitorForLinux' <-||- 
         -||-> Assert-AreEqual $extension.Name 'AzureEnhancedMonitorForLinux' <-||- 
         -||-> $settings =  -||-> $extension.PublicSettings | ConvertFrom-Json <-||-  <-||- 
         -||-> Assert-NotNull $settings.cfg <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedLinuxMD: Get done" <-||- 

        
         -||-> Write-Verbose "Test-AEMExtensionAdvancedLinuxMD: Test with extension" <-||- 
         -||-> $res =  -||-> Test-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname -SkipStorageCheck <-||-  <-||- 
         -||-> Assert-True {  -||-> $res.Result <-||-  } <-||- 
         -||-> Assert-True {  -||-> ( -||-> $res.PartialResults.Count -gt 0 <-||- ) <-||-  } <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedLinuxMD: Test done" <-||- 

        
         -||-> Write-Verbose "Test-AEMExtensionAdvancedLinuxMD: Remove with extension" <-||- 
         -||-> Remove-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedLinuxMD: Remove done" <-||- 

         -||-> Write-Verbose "Test-AEMExtensionAdvancedLinuxMD: Get after remove" <-||- 
         -||-> $extension =  -||-> Get-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname <-||-  <-||- 
         -||-> Assert-Null $extension <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedLinuxMD: Get after remove done" <-||- 
    }
    finally
    {
        
         -||-> Clean-ResourceGroup $rgname <-||- 
    } <-||- 
} <-||- 

 -||-> function Test-AEMExtensionBasicLinuxWAD
{
     -||-> $rgname =  -||-> Get-ComputeTestResourceName <-||-  <-||- 
     -||-> $loc =  -||-> Get-ComputeVMLocation <-||-  <-||- 

     -||-> try
    {
       
         -||-> $vm =  -||-> Create-AdvancedVM -rgname $rgname -loc $loc -linux <-||-  <-||- 
         -||-> $vmname = $vm.Name <-||- 

        
         -||-> $extension =  -||-> Get-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname <-||-  <-||- 
         -||-> Assert-Null $extension <-||- 
        
         -||-> $testResult =  -||-> Test-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname -SkipStorageCheck <-||-  <-||- 
         -||-> Assert-False {  -||-> $testResult.Result <-||-  } <-||- 

        
         -||-> Set-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname -SkipStorage -EnableWAD <-||- 
         -||-> $extension =  -||-> Get-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname <-||-  <-||- 

         -||-> Assert-NotNull $extension <-||- 
         -||-> Assert-AreEqual $extension.Publisher 'Microsoft.OSTCExtensions' <-||- 
         -||-> Assert-AreEqual $extension.ExtensionType 'AzureEnhancedMonitorForLinux' <-||- 
         -||-> Assert-AreEqual $extension.Name 'AzureEnhancedMonitorForLinux' <-||- 
         -||-> $settings =  -||-> $extension.PublicSettings | ConvertFrom-Json <-||-  <-||- 
         -||-> Assert-NotNull $settings.cfg <-||- 

        
         -||-> $testResult =  -||-> Test-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname -WaitTimeInMinutes 50 -SkipStorageCheck <-||-  <-||- 
         -||-> Assert-True {  -||-> $testResult.Result <-||-  } <-||- 
         -||-> Assert-True {  -||-> ( -||-> $testResult.PartialResults.Count -gt 0 <-||- ) <-||-  } <-||- 

        
         -||-> Remove-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname <-||- 
         -||-> $extension =  -||-> Get-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname <-||-  <-||- 
         -||-> Assert-Null $extension <-||- 
    }
    finally
    {
        
         -||-> Clean-ResourceGroup $rgname <-||- 
    } <-||- 
} <-||- 

 -||-> function Test-AEMExtensionBasicLinux
{
     -||-> $rgname =  -||-> Get-ComputeTestResourceName <-||-  <-||- 
     -||-> $loc =  -||-> Get-ComputeVMLocation <-||-  <-||- 

     -||-> try
    {
       
         -||-> $vm =  -||-> Create-AdvancedVM -rgname $rgname -loc $loc -linux <-||-  <-||- 
         -||-> $vmname = $vm.Name <-||- 

        
         -||-> $extension =  -||-> Get-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname <-||-  <-||- 
         -||-> Assert-Null $extension <-||- 
        
         -||-> $testResult =  -||-> Test-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname -SkipStorageCheck <-||-  <-||- 
         -||-> Assert-False {  -||-> $testResult.Result <-||-  } <-||- 

        
         -||-> Set-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname -SkipStorage <-||- 
         -||-> $extension =  -||-> Get-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname <-||-  <-||- 

         -||-> Assert-NotNull $extension <-||- 
         -||-> Assert-AreEqual $extension.Publisher 'Microsoft.OSTCExtensions' <-||- 
         -||-> Assert-AreEqual $extension.ExtensionType 'AzureEnhancedMonitorForLinux' <-||- 
         -||-> Assert-AreEqual $extension.Name 'AzureEnhancedMonitorForLinux' <-||- 
         -||-> $settings =  -||-> $extension.PublicSettings | ConvertFrom-Json <-||-  <-||- 
         -||-> Assert-NotNull $settings.cfg <-||- 

        
         -||-> $testResult =  -||-> Test-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname -WaitTimeInMinutes 50 -SkipStorageCheck <-||-  <-||- 
         -||-> Assert-True {  -||-> $testResult.Result <-||-  } <-||- 
         -||-> Assert-True {  -||-> ( -||-> $testResult.PartialResults.Count -gt 0 <-||- ) <-||-  } <-||- 

        
         -||-> Remove-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname <-||- 
         -||-> $extension =  -||-> Get-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname <-||-  <-||- 
         -||-> Assert-Null $extension <-||- 
    }
    finally
    {
        
         -||-> Clean-ResourceGroup $rgname <-||- 
    } <-||- 
} <-||- 

 -||-> function Test-AEMExtensionAdvancedLinuxWAD
{
     -||-> $rgname =  -||-> Get-ComputeTestResourceName <-||-  <-||- 
     -||-> $loc =  -||-> Get-ComputeVMLocation <-||-  <-||- 

     -||-> try
    {
         -||-> Write-Verbose "Start the test Test-AEMExtensionAdvancedLinux" <-||- 
        
         -||-> $vm =  -||-> Create-AdvancedVM -rgname $rgname -loc $loc -vmsize 'Standard_DS2' -stotype 'Premium_LRS' -nicCount 2 -linux <-||-  <-||- 
         -||-> $vmname = $vm.Name <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedLinux: VM created" <-||- 

        
         -||-> Write-Verbose "Test-AEMExtensionAdvancedLinux: Get with no extension" <-||- 
         -||-> $extension =  -||-> Get-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname <-||-  <-||- 
         -||-> Assert-Null $extension <-||- 

        
         -||-> Write-Verbose "Test-AEMExtensionAdvancedLinux: Test with no extension" <-||- 
         -||-> $res =  -||-> Test-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname -SkipStorageCheck <-||-  <-||- 
         -||-> Write-Verbose ( -||-> "Test-AEMExtensionAdvancedLinux: Test result " + $res.Result <-||- ) <-||- 
         -||-> Assert-False {  -||-> $res.Result <-||-  } <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedLinux: Test done" <-||- 

         -||-> $stoname = 'sto' + $rgname + "2" <-||- ;
         -||-> New-AzureRmStorageAccount -ResourceGroupName $rgname -Name $stoname -Location $loc -Type 'Standard_LRS' <-||- ;

        
         -||-> Write-Verbose "Test-AEMExtensionAdvancedLinux: Set with no extension" <-||- 
         -||-> Set-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname -WADStorageAccountName $stoname -SkipStorage -EnableWAD <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedLinux: Set done" <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedLinux: Get with extension" <-||- 
         -||-> $extension =  -||-> Get-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname <-||-  <-||- 
        

         -||-> Assert-NotNull $extension <-||- 
         -||-> Assert-AreEqual $extension.Publisher 'Microsoft.OSTCExtensions' <-||- 
         -||-> Assert-AreEqual $extension.ExtensionType 'AzureEnhancedMonitorForLinux' <-||- 
         -||-> Assert-AreEqual $extension.Name 'AzureEnhancedMonitorForLinux' <-||- 
         -||-> $settings =  -||-> $extension.PublicSettings | ConvertFrom-Json <-||-  <-||- 
         -||-> Assert-NotNull $settings.cfg <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedLinux: Get done" <-||- 

        
         -||-> Write-Verbose "Test-AEMExtensionAdvancedLinux: Test with extension" <-||- 
         -||-> $res =  -||-> Test-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname -SkipStorageCheck <-||-  <-||- 
         -||-> Assert-True {  -||-> $res.Result <-||-  } <-||- 
         -||-> Assert-True {  -||-> ( -||-> $res.PartialResults.Count -gt 0 <-||- ) <-||-  } <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedLinux: Test done" <-||- 

        
         -||-> Write-Verbose "Test-AEMExtensionAdvancedLinux: Remove with extension" <-||- 
         -||-> Remove-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedLinux: Remove done" <-||- 

         -||-> Write-Verbose "Test-AEMExtensionAdvancedLinux: Get after remove" <-||- 
         -||-> $extension =  -||-> Get-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname <-||-  <-||- 
         -||-> Assert-Null $extension <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedLinux: Get after remove done" <-||- 
    }
    finally
    {
        
         -||-> Clean-ResourceGroup $rgname <-||- 
    } <-||- 
} <-||- 

 -||-> function Test-AEMExtensionAdvancedLinux
{
     -||-> $rgname =  -||-> Get-ComputeTestResourceName <-||-  <-||- 
     -||-> $loc =  -||-> Get-ComputeVMLocation <-||-  <-||- 

     -||-> try
    {
         -||-> Write-Verbose "Start the test Test-AEMExtensionAdvancedLinux" <-||- 
        
         -||-> $vm =  -||-> Create-AdvancedVM -rgname $rgname -loc $loc -vmsize 'Standard_DS2' -stotype 'Premium_LRS' -nicCount 2 -linux <-||-  <-||- 
         -||-> $vmname = $vm.Name <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedLinux: VM created" <-||- 

        
         -||-> Write-Verbose "Test-AEMExtensionAdvancedLinux: Get with no extension" <-||- 
         -||-> $extension =  -||-> Get-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname <-||-  <-||- 
         -||-> Assert-Null $extension <-||- 

        
         -||-> Write-Verbose "Test-AEMExtensionAdvancedLinux: Test with no extension" <-||- 
         -||-> $res =  -||-> Test-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname -SkipStorageCheck <-||-  <-||- 
         -||-> Write-Verbose ( -||-> "Test-AEMExtensionAdvancedLinux: Test result " + $res.Result <-||- ) <-||- 
         -||-> Assert-False {  -||-> $res.Result <-||-  } <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedLinux: Test done" <-||- 

         -||-> $stoname = 'sto' + $rgname + "2" <-||- ;
         -||-> New-AzureRmStorageAccount -ResourceGroupName $rgname -Name $stoname -Location $loc -Type 'Standard_LRS' <-||- ;

        
         -||-> Write-Verbose "Test-AEMExtensionAdvancedLinux: Set with no extension" <-||- 
         -||-> Set-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname -WADStorageAccountName $stoname -SkipStorage <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedLinux: Set done" <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedLinux: Get with extension" <-||- 
         -||-> $extension =  -||-> Get-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname <-||-  <-||- 
        

         -||-> Assert-NotNull $extension <-||- 
         -||-> Assert-AreEqual $extension.Publisher 'Microsoft.OSTCExtensions' <-||- 
         -||-> Assert-AreEqual $extension.ExtensionType 'AzureEnhancedMonitorForLinux' <-||- 
         -||-> Assert-AreEqual $extension.Name 'AzureEnhancedMonitorForLinux' <-||- 
         -||-> $settings =  -||-> $extension.PublicSettings | ConvertFrom-Json <-||-  <-||- 
         -||-> Assert-NotNull $settings.cfg <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedLinux: Get done" <-||- 

        
         -||-> Write-Verbose "Test-AEMExtensionAdvancedLinux: Test with extension" <-||- 
         -||-> $res =  -||-> Test-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname -SkipStorageCheck <-||-  <-||- 
         -||-> Assert-True {  -||-> $res.Result <-||-  } <-||- 
         -||-> Assert-True {  -||-> ( -||-> $res.PartialResults.Count -gt 0 <-||- ) <-||-  } <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedLinux: Test done" <-||- 

        
         -||-> Write-Verbose "Test-AEMExtensionAdvancedLinux: Remove with extension" <-||- 
         -||-> Remove-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedLinux: Remove done" <-||- 

         -||-> Write-Verbose "Test-AEMExtensionAdvancedLinux: Get after remove" <-||- 
         -||-> $extension =  -||-> Get-AzureRmVMAEMExtension -ResourceGroupName $rgname -VMName $vmname <-||-  <-||- 
         -||-> Assert-Null $extension <-||- 
         -||-> Write-Verbose "Test-AEMExtensionAdvancedLinux: Get after remove done" <-||- 
    }
    finally
    {
        
         -||-> Clean-ResourceGroup $rgname <-||- 
    } <-||- 
} <-||- 

 -||-> function Create-AdvancedVM($rgname, $vmname, $loc, $vmsize, $stotype, $nicCount, [Switch] $linux, [Switch] $useMD)
{
    
     -||-> $rgname =  -||-> if ( -||-> [string]::IsNullOrEmpty($rgname) <-||- ) {  -||-> Get-ComputeTestResourceName <-||-  } else {  -||-> $rgname <-||-  } <-||-  <-||- 
     -||-> $vmname =  -||-> if ( -||-> [string]::IsNullOrEmpty($vmname) <-||- ) {  -||-> 'vm' + $rgname <-||-  } else {  -||-> $vmname <-||-  } <-||-  <-||- 
     -||-> $loc =  -||-> if ( -||-> [string]::IsNullOrEmpty($loc) <-||- ) {  -||-> Get-ComputeVMLocation <-||-  } else {  -||-> $loc <-||-  } <-||-  <-||- 
     -||-> $vmsize =  -||-> if ( -||-> [string]::IsNullOrEmpty($vmsize) <-||- ) {  -||-> 'Standard_A2' <-||-  } else {  -||-> $vmsize <-||-  } <-||-  <-||- 
     -||-> $stotype =  -||-> if ( -||-> [string]::IsNullOrEmpty($stotype) <-||- ) {  -||-> 'Standard_LRS' <-||-  } else {  -||-> $stotype <-||-  } <-||-  <-||- 
     -||-> $nicCount =  -||-> if ( -||-> [string]::IsNullOrEmpty($nicCount) <-||- ) {  -||-> 1 <-||-  } else {  -||-> [int]$nicCount <-||-  } <-||-  <-||- 

    
     -||-> $g =  -||-> New-AzureRmResourceGroup -Name $rgname -Location $loc -Force <-||-  <-||- ;

    
     -||-> $p =  -||-> New-AzureRmVMConfig -VMName $vmname -VMSize $vmsize <-||-  <-||- ;
     -||-> Assert-AreEqual $p.HardwareProfile.VmSize $vmsize <-||- ;

    
     -||-> $subnet =  -||-> New-AzureRmVirtualNetworkSubnetConfig -Name ( -||-> 'subnet' + $rgname <-||- ) -AddressPrefix "10.0.0.0/24" <-||-  <-||- ;
     -||-> $vnet =  -||-> New-AzureRmVirtualNetwork -Force -Name ( -||-> 'vnet' + $rgname <-||- ) -ResourceGroupName $rgname -Location $loc -AddressPrefix "10.0.0.0/16" -Subnet $subnet <-||-  <-||- ;
     -||-> $vnet =  -||-> Get-AzureRmVirtualNetwork -Name ( -||-> 'vnet' + $rgname <-||- ) -ResourceGroupName $rgname <-||-  <-||- ;
     -||-> $subnetId = $vnet.Subnets[0].Id <-||- ;
     -||-> $pubip =  -||-> New-AzureRmPublicIpAddress -Force -Name ( -||-> 'pubip' + $rgname <-||- ) -ResourceGroupName $rgname -Location $loc -AllocationMethod Dynamic -DomainNameLabel ( -||-> 'pubip' + $rgname <-||- ) <-||-  <-||- ;
     -||-> $pubip =  -||-> Get-AzureRmPublicIpAddress -Name ( -||-> 'pubip' + $rgname <-||- ) -ResourceGroupName $rgname <-||-  <-||- ;
     -||-> $pubipId = $pubip.Id <-||- ;
    
     -||-> $pibparams = @{} <-||- 
     -||-> $pibparams.Add("PublicIpAddressId", $pubip.Id) <-||- 
     -||-> $nicPrimParams = @{} <-||- 
     -||-> $nicPrimParams.Add("Primary", $true) <-||- 
    for ( -||-> $i = 0 <-||- ; -||-> $i -lt $nicCount <-||- ; -||-> $i++ <-||- )
    {
         -||-> $nic =  -||-> New-AzureRmNetworkInterface -Force -Name ( -||-> 'nic' + $i + $rgname <-||- ) -ResourceGroupName $rgname -Location $loc -SubnetId $subnetId @pibparams <-||-  <-||- 
         -||-> $nic =  -||-> Get-AzureRmNetworkInterface -Name ( -||-> 'nic' + $i + $rgname <-||- ) -ResourceGroupName $rgname <-||-  <-||- ;
         -||-> $nicId = $nic.Id <-||- ;

         -||-> $p =  -||-> Add-AzureRmVMNetworkInterface -VM $p -Id $nicId @nicPrimParams <-||-  <-||- ;
         -||-> Assert-AreEqual $p.NetworkProfile.NetworkInterfaces[$i].Id $nicId <-||- ;

         -||-> $pibparams = @{} <-||- 
         -||-> $nicPrimParams = @{} <-||- 
    }
     -||-> Assert-AreEqual $p.NetworkProfile.NetworkInterfaces.Count $nicCount <-||- ;   

    
     -||-> $stoname = 'sto' + $rgname <-||- ;
     -||-> $s =  -||-> New-AzureRmStorageAccount -ResourceGroupName $rgname -Name $stoname -Location $loc -Type $stotype <-||-  <-||- ;
     -||-> Retry-IfException {  -||-> $global:stoaccount =  -||-> Get-AzureRmStorageAccount -ResourceGroupName $rgname -Name $stoname <-||-  <-||- ; } <-||- 
     -||-> $stokey = ( -||-> Get-AzureRmStorageAccountKey -ResourceGroupName $rgname -Name $stoname <-||- ).Key1 <-||- ;

     -||-> $osDiskName = 'osDisk' <-||- ;
     -||-> $osDiskCaching = 'ReadWrite' <-||- ;
     -||-> $osDiskVhdUri = "https://$stoname.blob.core.windows.net/test/os.vhd" <-||- ;
     -||-> $dataDiskVhdUri1 = "https://$stoname.blob.core.windows.net/test/data1.vhd" <-||- ;
     -||-> $dataDiskVhdUri2 = "https://$stoname.blob.core.windows.net/test/data2.vhd" <-||- ;
     -||-> $dataDiskVhdUri3 = "https://$stoname.blob.core.windows.net/test/data3.vhd" <-||- ;

	 -||-> $osURI = @{} <-||- 
	 -||-> $disk1Uri = @{} <-||- 
	 -||-> $disk2Uri = @{} <-||- 
	 -||-> $disk3Uri = @{} <-||- 

	 -||-> if ( -||-> -not $useMD <-||- )
	{
		 -||-> $osURI = @{"VhdUri"= -||-> $osDiskVhdUri <-||- } <-||- 
		 -||-> $disk1Uri = @{"VhdUri"= -||-> $dataDiskVhdUri1 <-||- } <-||- 
		 -||-> $disk2Uri = @{"VhdUri"= -||-> $dataDiskVhdUri2 <-||- } <-||- 
		 -||-> $disk3Uri = @{"VhdUri"= -||-> $dataDiskVhdUri3 <-||- } <-||- 
	} <-||- 

     -||-> $p =  -||-> Set-AzureRmVMOSDisk -VM $p -Name $osDiskName @osURI -Caching $osDiskCaching -CreateOption FromImage <-||-  <-||- ;

     -||-> $p =  -||-> Add-AzureRmVMDataDisk -VM $p -Name 'testDataDisk1' -Caching 'ReadOnly' -DiskSizeInGB 10 -Lun 1 @disk1Uri -CreateOption Empty <-||-  <-||- ;
     -||-> $p =  -||-> Add-AzureRmVMDataDisk -VM $p -Name 'testDataDisk2' -Caching 'ReadOnly' -DiskSizeInGB 11 -Lun 2 @disk2Uri -CreateOption Empty <-||-  <-||- ;
     -||-> $p =  -||-> Add-AzureRmVMDataDisk -VM $p -Name 'testDataDisk3' -Caching 'ReadOnly' -DiskSizeInGB 12 -Lun 3 @disk3Uri -CreateOption Empty <-||-  <-||- ;
     -||-> $p =  -||-> Remove-AzureRmVMDataDisk -VM $p -Name 'testDataDisk3' <-||-  <-||- ;

     -||-> Assert-AreEqual $p.StorageProfile.OsDisk.Caching $osDiskCaching <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.OsDisk.Name $osDiskName <-||- ;
	 -||-> if ( -||-> -not $useMD <-||- )
	{
		 -||-> Assert-AreEqual $p.StorageProfile.OsDisk.Vhd.Uri $osDiskVhdUri <-||- ;
	} <-||- 
     -||-> Assert-AreEqual $p.StorageProfile.DataDisks.Count 2 <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.DataDisks[0].Caching 'ReadOnly' <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.DataDisks[0].DiskSizeGB 10 <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.DataDisks[0].Lun 1 <-||- ;
	 -||-> if ( -||-> -not $useMD <-||- )
	{
		 -||-> Assert-AreEqual $p.StorageProfile.DataDisks[0].Vhd.Uri $dataDiskVhdUri1 <-||- ;
	} <-||- 
     -||-> Assert-AreEqual $p.StorageProfile.DataDisks[1].Caching 'ReadOnly' <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.DataDisks[1].DiskSizeGB 11 <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.DataDisks[1].Lun 2 <-||- ;
	 -||-> if ( -||-> -not $useMD <-||- )
	{
		 -||-> Assert-AreEqual $p.StorageProfile.DataDisks[1].Vhd.Uri $dataDiskVhdUri2 <-||- ;
	} <-||- 

    
     -||-> $user = "Foo12" <-||- ;
     -||-> $password = $PLACEHOLDER <-||- ;
     -||-> $securePassword =  -||-> ConvertTo-SecureString $password -AsPlainText -Force <-||-  <-||- ;
     -||-> $cred =  -||-> New-Object System.Management.Automation.PSCredential ( -||-> $user, $securePassword <-||- ) <-||-  <-||- ;
     -||-> $computerName = 'test' <-||- ;
     -||-> $vhdContainer = "https://$stoname.blob.core.windows.net/test" <-||- ;

     -||-> if ( -||-> $linux <-||- )
    {
         -||-> $p =  -||-> Set-AzureRmVMOperatingSystem -VM $p -Linux -ComputerName $computerName -Credential $cred <-||-  <-||- ;

         -||-> $imgRef =  -||-> Get-LinuxImage <-||-  <-||- ;
         -||-> $p = ( -||-> $imgRef | Set-AzureRmVMSourceImage -VM $p <-||- ) <-||- ;
    }
    else
    {
         -||-> $p =  -||-> Set-AzureRmVMOperatingSystem -VM $p -Windows -ComputerName $computerName -Credential $cred -ProvisionVMAgent <-||-  <-||- ;

         -||-> $imgRef =  -||-> Get-DefaultCRPWindowsImageOffline <-||-  <-||- ;
         -||-> $p = ( -||-> $imgRef | Set-AzureRmVMSourceImage -VM $p <-||- ) <-||- ;
    } <-||- 

     -||-> Assert-AreEqual $p.OSProfile.AdminUsername $user <-||- ;
     -||-> Assert-AreEqual $p.OSProfile.ComputerName $computerName <-||- ;
     -||-> Assert-AreEqual $p.OSProfile.AdminPassword $password <-||- ;
     -||-> if ( -||-> -not $linux <-||- )
    {
         -||-> Assert-AreEqual $p.OSProfile.WindowsConfiguration.ProvisionVMAgent $true <-||- ;
    } <-||- 

     -||-> Assert-AreEqual $p.StorageProfile.ImageReference.Offer $imgRef.Offer <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.ImageReference.Publisher $imgRef.PublisherName <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.ImageReference.Sku $imgRef.Skus <-||- ;
     -||-> Assert-AreEqual $p.StorageProfile.ImageReference.Version $imgRef.Version <-||- ;

    
     -||-> $p =  -||-> Set-AzureRmVMBootDiagnostics -VM $p -Disable <-||-  <-||- 
     -||-> $v =  -||-> New-AzureRmVM -ResourceGroupName $rgname -Location $loc -VM $p <-||-  <-||- ;

     -||-> $vm =  -||-> Get-AzureRmVM -ResourceGroupName $rgname -VMName $vmname <-||-  <-||- 
    return  -||-> $vm <-||- 
} <-||- 

 -||-> function Get-LinuxImage
{
    return  -||-> Create-ComputeVMImageObject 'SUSE' 'SLES' '12-SP1' 'latest' <-||- ;
} <-||- 

