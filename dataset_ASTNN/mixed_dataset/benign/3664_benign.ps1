 -||-> function Install-Script {
    
    [CmdletBinding(DefaultParameterSetName = 'NameParameterSet',
        HelpUri = 'https://go.microsoft.com/fwlink/?LinkId=619784',
        SupportsShouldProcess = $true)]
    Param
    (
        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0,
            ParameterSetName = 'NameParameterSet')]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Name,

        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0,
            ParameterSetName = 'InputObject')]
        [ValidateNotNull()]
        [PSCustomObject[]]
        $InputObject,

        [Parameter(ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'NameParameterSet')]
        [ValidateNotNull()]
        [string]
        $MinimumVersion,

        [Parameter(ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'NameParameterSet')]
        [ValidateNotNull()]
        [string]
        $MaximumVersion,

        [Parameter(ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'NameParameterSet')]
        [ValidateNotNull()]
        [string]
        $RequiredVersion,

        [Parameter(ParameterSetName = 'NameParameterSet')]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Repository,

        [Parameter()]
        [ValidateSet("CurrentUser", "AllUsers")]
        [string]
        $Scope,

        [Parameter()]
        [Switch]
        $NoPathUpdate,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [Uri]
        $Proxy,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [PSCredential]
        $ProxyCredential,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [PSCredential]
        $Credential,

        [Parameter()]
        [switch]
        $Force,

        [Parameter(ParameterSetName = 'NameParameterSet')]
        [switch]
        $AllowPrerelease,

        [Parameter()]
        [switch]
        $AcceptLicense,

        [Parameter()]
        [switch]
        $PassThru
    )

    Begin {
         -||-> if ( -||-> $Scope -eq "AllUsers" -and -not ( -||-> Test-RunningAsElevated <-||- ) <-||- ) {
            
             -||-> $message = $LocalizedData.InstallScriptAdminPrivilegeRequiredForAllUsersScope -f @( -||-> $script:ProgramFilesScriptsPath, $script:MyDocumentsScriptsPath <-||- ) <-||- 

             -||-> ThrowError -ExceptionName "System.ArgumentException" `
                -ExceptionMessage $message `
                -ErrorId "InstallScriptAdminPrivilegeRequiredForAllUsersScope" `
                -CallerPSCmdlet $PSCmdlet `
                -ErrorCategory InvalidArgument <-||- 
        } <-||- 

        
        
         -||-> if ( -||-> -not $Scope <-||- ) {
             -||-> $Scope = "CurrentUser" <-||- 
             -||-> if ( -||-> -not $script:IsCoreCLR -and ( -||-> Test-RunningAsElevated <-||- ) <-||- ) {
                 -||-> $Scope = "AllUsers" <-||- 
            } <-||- 
        } <-||- 

        
         -||-> if ( -||-> $Scope -eq 'AllUsers' <-||- ) {
             -||-> $scopePath = $script:ProgramFilesScriptsPath <-||- 
        }
        else {
             -||-> $scopePath = $script:MyDocumentsScriptsPath <-||- 
        } <-||- 

         -||-> ValidateAndSet-PATHVariableIfUserAccepts -Scope $Scope `
            -ScopePath $scopePath `
            -NoPathUpdate:$NoPathUpdate `
            -Force:$Force <-||- 

         -||-> Install-NuGetClientBinaries -CallerPSCmdlet $PSCmdlet -Proxy $Proxy -ProxyCredential $ProxyCredential <-||- 

        
         -||-> $scriptNamesInPipeline = @() <-||- 

         -||-> $YesToAll = $false <-||- 
         -||-> $NoToAll = $false <-||- 
         -||-> $SourceSGrantedTrust = @() <-||- 
         -||-> $SourcesDeniedTrust = @() <-||- 
    }

    Process {
         -||-> $RepositoryIsNotTrusted = $LocalizedData.RepositoryIsNotTrusted <-||- 
         -||-> $QueryInstallUntrustedPackage = $LocalizedData.QueryInstallUntrustedScriptPackage <-||- 
         -||-> $PackageTarget = $LocalizedData.InstallScriptwhatIfMessage <-||- 

         -||-> $PSBoundParameters["Provider"] = $script:PSModuleProviderName <-||- 
         -||-> $PSBoundParameters["MessageResolver"] = $script:PackageManagementInstallScriptMessageResolverScriptBlock <-||- 
         -||-> $PSBoundParameters[$script:PSArtifactType] = $script:PSArtifactTypeScript <-||- 
         -||-> $PSBoundParameters['Scope'] = $Scope <-||- 
         -||-> if ( -||-> $AllowPrerelease <-||- ) {
             -||-> $PSBoundParameters[$script:AllowPrereleaseVersions] = $true <-||- 
        } <-||- 
         -||-> $null = $PSBoundParameters.Remove("AllowPrerelease") <-||- 
         -||-> $null = $PSBoundParameters.Remove("PassThru") <-||- 

         -||-> if ( -||-> $PSCmdlet.ParameterSetName -eq "NameParameterSet" <-||- ) {
             -||-> $ValidationResult =  -||-> Validate-VersionParameters -CallerPSCmdlet $PSCmdlet `
                -Name $Name `
                -TestWildcardsInName `
                -MinimumVersion $MinimumVersion `
                -MaximumVersion $MaximumVersion `
                -RequiredVersion $RequiredVersion `
                -AllowPrerelease:$AllowPrerelease <-||-  <-||- 

             -||-> if ( -||-> -not $ValidationResult <-||- ) {
                
                
                return
            } <-||- 

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

             -||-> if ( -||-> -not $Force <-||- ) {
                 -||-> foreach ($scriptName in  -||-> $Name <-||- ) {
                    
                     -||-> $cmd =  -||-> Microsoft.PowerShell.Core\Get-Command -Name $scriptName `
                        -ErrorAction Ignore `
                        -WarningAction SilentlyContinue <-||-  <-||- 
                     -||-> if ( -||-> $cmd <-||- ) {
                        
                         -||-> $InstalledScriptInfo =  -||-> Test-ScriptInstalled -Name $scriptName `
                            -ErrorAction SilentlyContinue `
                            -WarningAction SilentlyContinue <-||-  <-||- 
                         -||-> if ( -||-> -not $InstalledScriptInfo <-||- ) {
                             -||-> $message = $LocalizedData.CommandAlreadyAvailable -f ( -||-> $scriptName <-||- ) <-||- 
                             -||-> Write-Error -Message $message -ErrorId CommandAlreadyAvailableWitScriptName -Category InvalidOperation <-||- 

                            
                             -||-> if ( -||-> $scriptName -eq $Name <-||- ) {
                                return
                            } <-||- 
                        } <-||- 
                    } <-||- 
                } <-||- 
            } <-||- 

             -||-> $installedPackages =  -||-> PackageManagement\Install-Package @PSBoundParameters <-||-  <-||- 

             -||-> if ( -||-> $PassThru <-||- ) {
                 -||-> $installedPackages | Microsoft.PowerShell.Core\ForEach-Object {  -||-> New-PSGetItemInfo -SoftwareIdentity $_ -Type $script:PSArtifactTypeScript <-||-  } <-||- 
            } <-||- 
        }
        elseif ( -||-> $PSCmdlet.ParameterSetName -eq "InputObject" <-||- ) {
             -||-> $null = $PSBoundParameters.Remove("InputObject") <-||- 

             -||-> foreach ($inputValue in  -||-> $InputObject <-||- ) {

                 -||-> if ( -||-> ( -||-> $inputValue.PSTypeNames -notcontains "Microsoft.PowerShell.Commands.PSRepositoryItemInfo" <-||- ) -and
                    ( -||-> $inputValue.PSTypeNames -notcontains "Deserialized.Microsoft.PowerShell.Commands.PSRepositoryItemInfo" <-||- ) <-||- ) {
                     -||-> ThrowError -ExceptionName "System.ArgumentException" `
                        -ExceptionMessage $LocalizedData.InvalidInputObjectValue `
                        -ErrorId "InvalidInputObjectValue" `
                        -CallerPSCmdlet $PSCmdlet `
                        -ErrorCategory InvalidArgument `
                        -ExceptionObject $inputValue <-||- 
                } <-||- 

                 -||-> $psRepositoryItemInfo = $inputValue <-||- 

                
                 -||-> if ( -||-> $scriptNamesInPipeline -contains $psRepositoryItemInfo.Name <-||- ) {
                    continue
                } <-||- 

                 -||-> $scriptNamesInPipeline += $psRepositoryItemInfo.Name <-||- 

                 -||-> if ( -||-> $psRepositoryItemInfo.PowerShellGetFormatVersion -and
                    ( -||-> $script:SupportedPSGetFormatVersionMajors -notcontains $psRepositoryItemInfo.PowerShellGetFormatVersion.Major <-||- ) <-||- ) {
                     -||-> $message = $LocalizedData.NotSupportedPowerShellGetFormatVersionScripts -f ( -||-> $psRepositoryItemInfo.Name, $psRepositoryItemInfo.PowerShellGetFormatVersion, $psRepositoryItemInfo.Name <-||- ) <-||- 
                     -||-> Write-Error -Message $message -ErrorId "NotSupportedPowerShellGetFormatVersion" -Category InvalidOperation <-||- 
                    continue
                } <-||- 

                 -||-> $PSBoundParameters["Name"] = $psRepositoryItemInfo.Name <-||- 
                 -||-> $PSBoundParameters["RequiredVersion"] = $psRepositoryItemInfo.Version <-||- 
                 -||-> if ( -||-> ( -||-> $psRepositoryItemInfo.AdditionalMetadata <-||- ) -and
                    ( -||-> Get-Member -InputObject $psRepositoryItemInfo.AdditionalMetadata -Name "IsPrerelease" <-||- ) -and
                    ( -||-> $psRepositoryItemInfo.AdditionalMetadata.IsPrerelease -eq "true" <-||- ) <-||- ) {
                     -||-> $PSBoundParameters[$script:AllowPrereleaseVersions] = $true <-||- 
                }
                elseif ( -||-> $PSBoundParameters.ContainsKey($script:AllowPrereleaseVersions) <-||- ) {
                     -||-> $null = $PSBoundParameters.Remove($script:AllowPrereleaseVersions) <-||- 
                } <-||- 
                 -||-> $PSBoundParameters['Source'] = $psRepositoryItemInfo.Repository <-||- 
                 -||-> $PSBoundParameters["PackageManagementProvider"] = ( -||-> Get-ProviderName -PSCustomObject $psRepositoryItemInfo <-||- ) <-||- 

                 -||-> $InstalledScriptInfo =  -||-> Test-ScriptInstalled -Name $psRepositoryItemInfo.Name <-||-  <-||- 
                 -||-> if ( -||-> -not $Force -and $InstalledScriptInfo <-||- ) {
                     -||-> $message = $LocalizedData.ScriptAlreadyInstalledVerbose -f ( -||-> $InstalledScriptInfo.Version, $InstalledScriptInfo.Name, $InstalledScriptInfo.ScriptBase <-||- ) <-||- 
                     -||-> Write-Verbose -Message $message <-||- 
                }
                else {
                    
                     -||-> if ( -||-> -not $Force <-||- ) {
                         -||-> $cmd =  -||-> Microsoft.PowerShell.Core\Get-Command -Name $psRepositoryItemInfo.Name `
                            -ErrorAction Ignore `
                            -WarningAction SilentlyContinue <-||-  <-||- 
                         -||-> if ( -||-> $cmd <-||- ) {
                             -||-> $message = $LocalizedData.CommandAlreadyAvailable -f ( -||-> $psRepositoryItemInfo.Name <-||- ) <-||- 
                             -||-> Write-Error -Message $message -ErrorId CommandAlreadyAvailableWitScriptName -Category InvalidOperation <-||- 

                            continue
                        } <-||- 
                    } <-||- 

                     -||-> $source = $psRepositoryItemInfo.Repository <-||- 
                     -||-> $installationPolicy = ( -||-> Get-PSRepository -Name $source <-||- ).InstallationPolicy <-||- 
                     -||-> $ShouldProcessMessage = $PackageTarget -f ( -||-> $psRepositoryItemInfo.Name, $psRepositoryItemInfo.Version <-||- ) <-||- 

                     -||-> if ( -||-> $psCmdlet.ShouldProcess($ShouldProcessMessage) <-||- ) {
                         -||-> if ( -||-> $installationPolicy.Equals("Untrusted", [StringComparison]::OrdinalIgnoreCase) <-||- ) {
                             -||-> if ( -||-> -not( -||-> $YesToAll -or $NoToAll -or $SourceSGrantedTrust.Contains($source) -or $sourcesDeniedTrust.Contains($source) -or $Force <-||- ) <-||- ) {
                                 -||-> $message = $QueryInstallUntrustedPackage -f ( -||-> $psRepositoryItemInfo.Name, $psRepositoryItemInfo.RepositorySourceLocation <-||- ) <-||- 

                                 -||-> if ( -||-> $PSVersionTable.PSVersion -ge '5.0.0' <-||- ) {
                                     -||-> $sourceTrusted = $psCmdlet.ShouldContinue("$message", "$RepositoryIsNotTrusted", $true, [ref]$YesToAll, [ref]$NoToAll) <-||- 
                                }
                                else {
                                     -||-> $sourceTrusted = $psCmdlet.ShouldContinue("$message", "$RepositoryIsNotTrusted", [ref]$YesToAll, [ref]$NoToAll) <-||- 
                                } <-||- 

                                 -||-> if ( -||-> $sourceTrusted <-||- ) {
                                     -||-> $SourcesGrantedTrust += $source <-||- 
                                }
                                else {
                                     -||-> $SourcesDeniedTrust += $source <-||- 
                                } <-||- 
                            } <-||- 
                        } <-||- 
                    } <-||- 
                     -||-> if ( -||-> $installationPolicy.Equals("trusted", [StringComparison]::OrdinalIgnoreCase) -or $SourcesGrantedTrust.Contains($source) -or $YesToAll -or $Force <-||- ) {
                         -||-> $PSBoundParameters["Force"] = $true <-||- 
                         -||-> $installedPackages =  -||-> PackageManagement\Install-Package @PSBoundParameters <-||-  <-||- 

                         -||-> if ( -||-> $PassThru <-||- ) {
                             -||-> $installedPackages | Microsoft.PowerShell.Core\ForEach-Object {  -||-> New-PSGetItemInfo -SoftwareIdentity $_ -Type $script:PSArtifactTypeScript <-||-  } <-||- 
                        } <-||- 
                    } <-||- 
                } <-||- 
            } <-||- 
        } <-||- 
    }
} <-||- 


