 -||-> function Update-Module {
    
    [CmdletBinding(SupportsShouldProcess = $true,
        HelpUri = 'https://go.microsoft.com/fwlink/?LinkID=398576')]
    Param
    (
        [Parameter(ValueFromPipelineByPropertyName = $true,
            Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Name,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNull()]
        [string]
        $RequiredVersion,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNull()]
        [string]
        $MaximumVersion,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [PSCredential]
        $Credential,

        [Parameter()]
        [ValidateSet("CurrentUser", "AllUsers")]
        [string]
        $Scope,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [Uri]
        $Proxy,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [PSCredential]
        $ProxyCredential,

        [Parameter()]
        [Switch]
        $Force,

        [Parameter()]
        [Switch]
        $AllowPrerelease,

        [Parameter()]
        [switch]
        $AcceptLicense,

        [Parameter()]
        [switch]
        $PassThru
    )

    Begin {
         -||-> Install-NuGetClientBinaries -CallerPSCmdlet $PSCmdlet -Proxy $Proxy -ProxyCredential $ProxyCredential <-||- 

         -||-> if ( -||-> $Scope -eq "AllUsers" -and -not ( -||-> Test-RunningAsElevated <-||- ) <-||- ) {
            
             -||-> $message = $LocalizedData.UpdateModuleAdminPrivilegeRequiredForAllUsersScope -f @( -||-> $script:programFilesModulesPath, $script:MyDocumentsModulesPath <-||- ) <-||- 

             -||-> ThrowError -ExceptionName "System.ArgumentException" `
                -ExceptionMessage $message `
                -ErrorId "UpdateModuleAdminPrivilegeRequiredForAllUsersScope" `
                -CallerPSCmdlet $PSCmdlet `
                -ErrorCategory InvalidArgument <-||- 
        } <-||- 

        
         -||-> $moduleNamesInPipeline = @() <-||- 
    }

    Process {
         -||-> $ValidationResult =  -||-> Validate-VersionParameters -CallerPSCmdlet $PSCmdlet `
            -Name $Name `
            -MaximumVersion $MaximumVersion `
            -RequiredVersion $RequiredVersion `
            -AllowPrerelease:$AllowPrerelease <-||-  <-||- 

         -||-> if ( -||-> -not $ValidationResult <-||- ) {
            
            
            return
        } <-||- 

         -||-> $GetPackageParameters = @{ } <-||- 
         -||-> $GetPackageParameters[$script:PSArtifactType] = $script:PSArtifactTypeModule <-||- 
         -||-> $GetPackageParameters["Provider"] = $script:PSModuleProviderName <-||- 
         -||-> $GetPackageParameters["MessageResolver"] = $script:PackageManagementMessageResolverScriptBlock <-||- 
         -||-> $GetPackageParameters['ErrorAction'] = 'SilentlyContinue' <-||- 
         -||-> $GetPackageParameters['WarningAction'] = 'SilentlyContinue' <-||- 
         -||-> if ( -||-> $AllowPrerelease <-||- ) {
             -||-> $PSBoundParameters[$script:AllowPrereleaseVersions] = $true <-||- 
        } <-||- 
         -||-> $null = $PSBoundParameters.Remove("AllowPrerelease") <-||- 
         -||-> $null = $PSBoundParameters.Remove("PassThru") <-||- 

         -||-> $PSGetItemInfos = @() <-||- 

         -||-> if ( -||-> -not $Name <-||- ) {
             -||-> $Name = @( -||-> '*' <-||- ) <-||- 
        } <-||- 

         -||-> foreach ($moduleName in  -||-> $Name <-||- ) {
             -||-> $GetPackageParameters['Name'] = $moduleName <-||- 
             -||-> $installedPackages =  -||-> PackageManagement\Get-Package @GetPackageParameters <-||-  <-||- 

             -||-> if ( -||-> -not $installedPackages -and -not ( -||-> Test-WildcardPattern -Name $moduleName <-||- ) <-||- ) {
                 -||-> $availableModules =  -||-> Get-Module -ListAvailable $moduleName -Verbose:$false | Microsoft.PowerShell.Utility\Select-Object -Unique -ErrorAction Ignore <-||-  <-||- 

                 -||-> if ( -||-> -not $availableModules <-||- ) {
                     -||-> $message = $LocalizedData.ModuleNotInstalledOnThisMachine -f ( -||-> $moduleName <-||- ) <-||- 
                     -||-> Write-Error -Message $message -ErrorId 'ModuleNotInstalledOnThisMachine' -Category InvalidOperation -TargetObject $moduleName <-||- 
                }
                else {
                     -||-> $message = $LocalizedData.ModuleNotInstalledUsingPowerShellGet -f ( -||-> $moduleName <-||- ) <-||- 
                     -||-> Write-Error -Message $message -ErrorId 'ModuleNotInstalledUsingInstallModuleCmdlet' -Category InvalidOperation -TargetObject $moduleName <-||- 
                } <-||- 

                continue
            } <-||- 

             -||-> $installedPackages |
            Microsoft.PowerShell.Core\ForEach-Object {  -||-> New-PSGetItemInfo -SoftwareIdentity $_ -Type $script:PSArtifactTypeModule <-||-  } |
            Microsoft.PowerShell.Core\ForEach-Object {  -||-> $PSGetItemInfos += $_ <-||-  } <-||- 
        } <-||- 

         -||-> $PSBoundParameters["Provider"] = $script:PSModuleProviderName <-||- 
         -||-> $PSBoundParameters[$script:PSArtifactType] = $script:PSArtifactTypeModule <-||- 

         -||-> foreach ($psgetItemInfo in  -||-> $PSGetItemInfos <-||- ) {
            
             -||-> if ( -||-> $moduleNamesInPipeline -contains $psgetItemInfo.Name <-||- ) {
                continue
            } <-||- 

             -||-> $moduleNamesInPipeline += $psgetItemInfo.Name <-||- 

             -||-> $message = $LocalizedData.CheckingForModuleUpdate -f ( -||-> $psgetItemInfo.Name <-||- ) <-||- 
             -||-> Write-Verbose -Message $message <-||- 

             -||-> $providerName =  -||-> Get-ProviderName -PSCustomObject $psgetItemInfo <-||-  <-||- 
             -||-> if ( -||-> -not $providerName <-||- ) {
                 -||-> $providerName = $script:NuGetProviderName <-||- 
            } <-||- 

             -||-> $PSBoundParameters["MessageResolver"] = $script:PackageManagementUpdateModuleMessageResolverScriptBlock <-||- 
             -||-> $PSBoundParameters["Name"] = $psgetItemInfo.Name <-||- 
             -||-> $PSBoundParameters['Source'] = $psgetItemInfo.Repository <-||- 

             -||-> $PSBoundParameters["PackageManagementProvider"] = $providerName <-||- 
             -||-> $PSBoundParameters["InstallUpdate"] = $true <-||- 

             -||-> if ( -||-> -not $Scope <-||- ) {
                 -||-> $Scope =  -||-> Get-InstallationScope -PreviousInstallLocation $psgetItemInfo.InstalledLocation -CurrentUserPath $script:MyDocumentsModulesPath <-||-  <-||- 
            } <-||- 

             -||-> $PSBoundParameters["Scope"] = $Scope <-||- 

             -||-> $sid =  -||-> PackageManagement\Install-Package @PSBoundParameters <-||-  <-||- 

             -||-> if ( -||-> $PassThru <-||- ) {
                 -||-> $sid | Microsoft.PowerShell.Core\ForEach-Object {  -||-> New-PSGetItemInfo -SoftwareIdentity $_ -Type $script:PSArtifactTypeModule <-||-  } <-||- 
            } <-||- 
        } <-||- 
    }
} <-||- 


