 -||-> function Publish-Script {
    
    [CmdletBinding(SupportsShouldProcess = $true,
        PositionalBinding = $false,
        DefaultParameterSetName = 'PathParameterSet',
        HelpUri = 'https://go.microsoft.com/fwlink/?LinkId=619788')]
    Param
    (
        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'PathParameterSet')]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path,

        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'LiteralPathParameterSet')]
        [Alias('PSPath')]
        [ValidateNotNullOrEmpty()]
        [string]
        $LiteralPath,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $NuGetApiKey,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $Repository = $Script:PSGalleryModuleSource,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [PSCredential]
        $Credential,

        [Parameter()]
        [switch]
        $Force
    )

    Begin {
         -||-> Install-NuGetClientBinaries -CallerPSCmdlet $PSCmdlet -BootstrapNuGetExe -Force:$Force <-||- 
    }

    Process {
         -||-> $scriptFilePath = $null <-||- 
         -||-> if ( -||-> $Path <-||- ) {
             -||-> $scriptFilePath =  -||-> Resolve-PathHelper -Path $Path -CallerPSCmdlet $PSCmdlet |
            Microsoft.PowerShell.Utility\Select-Object -First 1 -ErrorAction Ignore <-||-  <-||- 

             -||-> if ( -||-> -not $scriptFilePath -or
                -not ( -||-> Microsoft.PowerShell.Management\Test-Path -Path $scriptFilePath -PathType Leaf <-||- ) <-||- ) {
                 -||-> $errorMessage = ( -||-> $LocalizedData.PathNotFound -f $Path <-||- ) <-||- 
                 -||-> ThrowError  -ExceptionName "System.ArgumentException" `
                    -ExceptionMessage $errorMessage `
                    -ErrorId "PathNotFound" `
                    -CallerPSCmdlet $PSCmdlet `
                    -ExceptionObject $Path `
                    -ErrorCategory InvalidArgument <-||- 
            } <-||- 
        }
        else {
             -||-> $scriptFilePath =  -||-> Resolve-PathHelper -Path $LiteralPath -IsLiteralPath -CallerPSCmdlet $PSCmdlet |
            Microsoft.PowerShell.Utility\Select-Object -First 1 -ErrorAction Ignore <-||-  <-||- 

             -||-> if ( -||-> -not $scriptFilePath -or
                -not ( -||-> Microsoft.PowerShell.Management\Test-Path -LiteralPath $scriptFilePath -PathType Leaf <-||- ) <-||- ) {
                 -||-> $errorMessage = ( -||-> $LocalizedData.PathNotFound -f $LiteralPath <-||- ) <-||- 
                 -||-> ThrowError  -ExceptionName "System.ArgumentException" `
                    -ExceptionMessage $errorMessage `
                    -ErrorId "PathNotFound" `
                    -CallerPSCmdlet $PSCmdlet `
                    -ExceptionObject $LiteralPath `
                    -ErrorCategory InvalidArgument <-||- 
            } <-||- 
        } <-||- 

         -||-> if ( -||-> -not $scriptFilePath.EndsWith('.ps1', [System.StringComparison]::OrdinalIgnoreCase) <-||- ) {
             -||-> $errorMessage = ( -||-> $LocalizedData.InvalidScriptFilePath -f $scriptFilePath <-||- ) <-||- 
             -||-> ThrowError  -ExceptionName "System.ArgumentException" `
                -ExceptionMessage $errorMessage `
                -ErrorId "InvalidScriptFilePath" `
                -CallerPSCmdlet $PSCmdlet `
                -ExceptionObject $scriptFilePath `
                -ErrorCategory InvalidArgument <-||- 
            return
        } <-||- 

         -||-> if ( -||-> $Repository -eq $Script:PSGalleryModuleSource <-||- ) {
             -||-> $repo =  -||-> Get-PSRepository -Name $Repository -ErrorAction SilentlyContinue -WarningAction SilentlyContinue <-||-  <-||- 
             -||-> if ( -||-> -not $repo <-||- ) {
                 -||-> $message = $LocalizedData.PSGalleryNotFound -f ( -||-> $Repository <-||- ) <-||- 
                 -||-> ThrowError -ExceptionName "System.ArgumentException" `
                    -ExceptionMessage $message `
                    -ErrorId 'PSGalleryNotFound' `
                    -CallerPSCmdlet $PSCmdlet `
                    -ErrorCategory InvalidArgument `
                    -ExceptionObject $Repository <-||- 
                return
            } <-||- 
        }
        else {
             -||-> $ev = $null <-||- 
             -||-> $repo =  -||-> Get-PSRepository -Name $Repository -ErrorVariable ev <-||-  <-||- 
            
             -||-> if ( -||-> $ev -or ( -||-> -not $repo <-||- ) <-||- ) { return } <-||- 
        } <-||- 

         -||-> $DestinationLocation = $null <-||- 

         -||-> if ( -||-> Get-Member -InputObject $repo -Name $script:ScriptPublishLocation <-||- ) {
             -||-> $DestinationLocation = $repo.ScriptPublishLocation <-||- 
        } <-||- 

         -||-> if ( -||-> -not $DestinationLocation -or
            ( -||-> -not ( -||-> Microsoft.PowerShell.Management\Test-Path -Path $DestinationLocation <-||- ) -and
                -not ( -||-> Test-WebUri -uri $DestinationLocation <-||- ) <-||- ) <-||- ) {
             -||-> $message = $LocalizedData.PSRepositoryScriptPublishLocationIsMissing -f ( -||-> $Repository, $Repository <-||- ) <-||- 
             -||-> ThrowError -ExceptionName "System.ArgumentException" `
                -ExceptionMessage $message `
                -ErrorId "PSRepositoryScriptPublishLocationIsMissing" `
                -CallerPSCmdlet $PSCmdlet `
                -ErrorCategory InvalidArgument `
                -ExceptionObject $Repository <-||- 
        } <-||- 

         -||-> $message = $LocalizedData.PublishLocation -f ( -||-> $DestinationLocation <-||- ) <-||- 
         -||-> Write-Verbose -Message $message <-||- 

         -||-> if ( -||-> -not $NuGetApiKey.Trim() <-||- ) {
             -||-> if ( -||-> Microsoft.PowerShell.Management\Test-Path -Path $DestinationLocation <-||- ) {
                 -||-> $NuGetApiKey = "$( -||-> Get-Random <-||- )" <-||- 
            }
            else {
                 -||-> $message = $LocalizedData.NuGetApiKeyIsRequiredForNuGetBasedGalleryService -f ( -||-> $Repository, $DestinationLocation <-||- ) <-||- 
                 -||-> ThrowError -ExceptionName "System.ArgumentException" `
                    -ExceptionMessage $message `
                    -ErrorId "NuGetApiKeyIsRequiredForNuGetBasedGalleryService" `
                    -CallerPSCmdlet $PSCmdlet `
                    -ErrorCategory InvalidArgument <-||- 
            } <-||- 
        } <-||- 

         -||-> $providerName =  -||-> Get-ProviderName -PSCustomObject $repo <-||-  <-||- 
         -||-> if ( -||-> $providerName -ne $script:NuGetProviderName <-||- ) {
             -||-> $message = $LocalizedData.PublishScriptSupportsOnlyNuGetBasedPublishLocations -f ( -||-> $DestinationLocation, $Repository, $Repository <-||- ) <-||- 
             -||-> ThrowError -ExceptionName "System.ArgumentException" `
                -ExceptionMessage $message `
                -ErrorId "PublishScriptSupportsOnlyNuGetBasedPublishLocations" `
                -CallerPSCmdlet $PSCmdlet `
                -ErrorCategory InvalidArgument `
                -ExceptionObject $Repository <-||- 
        } <-||- 

         -||-> if ( -||-> $Path <-||- ) {
             -||-> $PSScriptInfo =  -||-> Test-ScriptFileInfo -Path $scriptFilePath <-||-  <-||- 
        }
        else {
             -||-> $PSScriptInfo =  -||-> Test-ScriptFileInfo -LiteralPath $scriptFilePath <-||-  <-||- 
        } <-||- 

         -||-> if ( -||-> -not $PSScriptInfo <-||- ) {
            
            return
        } <-||- 

         -||-> $scriptName = $PSScriptInfo.Name <-||- 

         -||-> $result =  -||-> ValidateAndGet-VersionPrereleaseStrings -Version $PSScriptInfo.Version -CallerPSCmdlet $PSCmdlet <-||-  <-||- 
         -||-> if ( -||-> -not $result <-||- ) {
            
            
            return
        } <-||- 
         -||-> $scriptVersion = $result["Version"] <-||- 
         -||-> $scriptPrerelease = $result["Prerelease"] <-||- 
         -||-> $scriptFullVersion = $result["FullVersion"] <-||- 

        
         -||-> $tempScriptPath =  -||-> Microsoft.PowerShell.Management\Join-Path -Path $script:TempPath -ChildPath "$( -||-> Get-Random <-||- )" |
        Microsoft.PowerShell.Management\Join-Path -ChildPath $scriptName <-||-  <-||- 

         -||-> $null =  -||-> Microsoft.PowerShell.Management\New-Item -Path $tempScriptPath -ItemType Directory -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -Confirm:$false -WhatIf:$false <-||-  <-||- 
         -||-> if ( -||-> $Path <-||- ) {
             -||-> Microsoft.PowerShell.Management\Copy-Item -Path $scriptFilePath -Destination $tempScriptPath -Force -Recurse -Confirm:$false -WhatIf:$false <-||- 
        }
        else {
             -||-> Microsoft.PowerShell.Management\Copy-Item -LiteralPath $scriptFilePath -Destination $tempScriptPath -Force -Recurse -Confirm:$false -WhatIf:$false <-||- 
        } <-||- 

         -||-> try {
             -||-> $FindParameters = @{
                Name            =  -||-> $scriptName <-||- 
                Repository      =  -||-> $Repository <-||- 
                Tag             =  -||-> 'PSModule' <-||- 
                AllowPrerelease =  -||-> $true <-||- 
                Verbose         =  -||-> $VerbosePreference <-||- 
                ErrorAction     =  -||-> 'SilentlyContinue' <-||- 
                WarningAction   =  -||-> 'SilentlyContinue' <-||- 
                Debug           =  -||-> $DebugPreference <-||- 
            } <-||- 

             -||-> if ( -||-> $Credential <-||- ) {
                 -||-> $FindParameters[$script:Credential] = $Credential <-||- 
            } <-||- 

            
            
             -||-> $modulePSGetItemInfo =  -||-> Find-Module @FindParameters |
            Microsoft.PowerShell.Core\Where-Object {  -||-> $_.Name -eq $scriptName <-||-  } |
            Microsoft.PowerShell.Utility\Select-Object -Last 1 -ErrorAction Ignore <-||-  <-||- 
             -||-> if ( -||-> $modulePSGetItemInfo <-||- ) {
                 -||-> $message = $LocalizedData.SpecifiedNameIsAlearyUsed -f ( -||-> $scriptName, $Repository, 'Find-Module' <-||- ) <-||- 
                 -||-> ThrowError -ExceptionName "System.InvalidOperationException" `
                    -ExceptionMessage $message `
                    -ErrorId "SpecifiedNameIsAlearyUsed" `
                    -CallerPSCmdlet $PSCmdlet `
                    -ErrorCategory InvalidOperation `
                    -ExceptionObject $scriptName <-||- 
            } <-||- 

             -||-> $null = $FindParameters.Remove('Tag') <-||- 

             -||-> $currentPSGetItemInfo = $null <-||- 
             -||-> $currentPSGetItemInfo =  -||-> Find-Script @FindParameters |
            Microsoft.PowerShell.Core\Where-Object {  -||-> $_.Name -eq $scriptName <-||-  } |
            Microsoft.PowerShell.Utility\Select-Object -Last 1 -ErrorAction Ignore <-||-  <-||- 

             -||-> if ( -||-> $currentPSGetItemInfo <-||- ) {
                 -||-> $result =  -||-> ValidateAndGet-VersionPrereleaseStrings -Version $currentPSGetItemInfo.Version -CallerPSCmdlet $PSCmdlet <-||-  <-||- 
                 -||-> if ( -||-> -not $result <-||- ) {
                    
                    
                    return
                } <-||- 
                 -||-> $galleryScriptVersion = $result["Version"] <-||- 
                 -||-> $galleryScriptPrerelease = $result["Prerelease"] <-||- 
                 -||-> $galleryScriptFullVersion = $result["FullVersion"] <-||- 

                 -||-> if ( -||-> $galleryScriptFullVersion -eq $scriptFullVersion <-||- ) {
                     -||-> $message = $LocalizedData.ScriptVersionIsAlreadyAvailableInTheGallery -f ( -||-> $scriptName,
                        $scriptFullVersion,
                        $galleryScriptFullVersion,
                        $currentPSGetItemInfo.RepositorySourceLocation <-||- ) <-||- 
                     -||-> ThrowError -ExceptionName "System.InvalidOperationException" `
                        -ExceptionMessage $message `
                        -ErrorId 'ScriptVersionIsAlreadyAvailableInTheGallery' `
                        -CallerPSCmdlet $PSCmdlet `
                        -ErrorCategory InvalidOperation <-||- 
                } <-||- 

                 -||-> if ( -||-> $galleryScriptVersion -eq $scriptVersion -and -not $Force <-||- ) {
                    

                     -||-> if ( -||-> -not $Force -and ( -||-> -not $galleryScriptPrerelease -and $scriptPrerelease <-||- ) <-||- ) {
                        
                         -||-> $message = $LocalizedData.ScriptPrereleaseStringShouldBeGreaterThanGalleryPrereleaseString -f ( -||-> $scriptName,
                            $scriptVersion,
                            $scriptPrerelease,
                            $galleryScriptPrerelease,
                            $currentPSGetItemInfo.RepositorySourceLocation <-||- ) <-||- 
                         -||-> ThrowError -ExceptionName "System.InvalidOperationException" `
                            -ExceptionMessage $message `
                            -ErrorId "ScriptPrereleaseStringShouldBeGreaterThanGalleryPrereleaseString" `
                            -CallerPSCmdlet $PSCmdlet `
                            -ErrorCategory InvalidOperation <-||- 
                    }

                    
                    

                    elseif ( -||-> $galleryScriptPrerelease -and $scriptPrerelease <-||- ) {
                        

                         -||-> if ( -||-> -not $Force -and ( -||-> $galleryScriptPrerelease -gt $scriptPrerelease <-||- ) <-||- ) {
                            
                             -||-> $message = $LocalizedData.ScriptPrereleaseStringShouldBeGreaterThanGalleryPrereleaseString -f ( -||-> $scriptName,
                                $scriptVersion,
                                $scriptPrerelease,
                                $galleryScriptPrerelease,
                                $currentPSGetItemInfo.RepositorySourceLocation <-||- ) <-||- 
                             -||-> ThrowError -ExceptionName "System.InvalidOperationException" `
                                -ExceptionMessage $message `
                                -ErrorId "ScriptPrereleaseStringShouldBeGreaterThanGalleryPrereleaseString" `
                                -CallerPSCmdlet $PSCmdlet `
                                -ErrorCategory InvalidOperation <-||- 
                        } <-||- 

                        
                        
                    } <-||- 
                }
                elseif ( -||-> -not $Force -and ( -||-> Compare-PrereleaseVersions -FirstItemVersion $scriptVersion `
                            -FirstItemPrerelease $scriptPrerelease `
                            -SecondItemVersion $galleryScriptVersion `
                            -SecondItemPrerelease $galleryScriptPrerelease <-||- ) <-||- ) {
                     -||-> $message = $LocalizedData.ScriptVersionShouldBeGreaterThanGalleryVersion -f ( -||-> $scriptName,
                        $scriptVersion,
                        $galleryScriptVersion,
                        $currentPSGetItemInfo.RepositorySourceLocation <-||- ) <-||- 
                     -||-> ThrowError -ExceptionName "System.InvalidOperationException" `
                        -ExceptionMessage $message `
                        -ErrorId "ScriptVersionShouldBeGreaterThanGalleryVersion" `
                        -CallerPSCmdlet $PSCmdlet `
                        -ErrorCategory InvalidOperation <-||- 
                } <-||- 

                
                
            } <-||- 

             -||-> $shouldProcessMessage = $LocalizedData.PublishScriptwhatIfMessage -f ( -||-> $PSScriptInfo.Version, $scriptName <-||- ) <-||- 
             -||-> if ( -||-> $Force -or $PSCmdlet.ShouldProcess($shouldProcessMessage, "Publish-Script") <-||- ) {
                 -||-> $PublishPSArtifactUtility_Params = @{
                    PSScriptInfo     =  -||-> $PSScriptInfo <-||- 
                    NugetApiKey      =  -||-> $NuGetApiKey <-||- 
                    Destination      =  -||-> $DestinationLocation <-||- 
                    Repository       =  -||-> $Repository <-||- 
                    NugetPackageRoot =  -||-> $tempScriptPath <-||- 
                    Verbose          =  -||-> $VerbosePreference <-||- 
                    WarningAction    =  -||-> $WarningPreference <-||- 
                    ErrorAction      =  -||-> $ErrorActionPreference <-||- 
                    Debug            =  -||-> $DebugPreference <-||- 
                } <-||- 
                 -||-> if ( -||-> $PSBoundParameters.ContainsKey('Credential') <-||- ) {
                     -||-> $PublishPSArtifactUtility_Params.Add('Credential', $Credential) <-||- 
                } <-||- 
                 -||-> Publish-PSArtifactUtility @PublishPSArtifactUtility_Params <-||- 
            } <-||- 
        }
        finally {
             -||-> Microsoft.PowerShell.Management\Remove-Item $tempScriptPath -Force -Recurse -ErrorAction Ignore -WarningAction SilentlyContinue -Confirm:$false -WhatIf:$false <-||- 
        } <-||- 
    }
} <-||- 


