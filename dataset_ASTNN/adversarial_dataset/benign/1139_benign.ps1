


 -||-> Describe "UntrustedDataMode tests for variable assignments" -Tags 'CI' {

     -||-> BeforeAll {

         -||-> $testModule =  -||-> Join-Path $TestDrive "UntrustedDataModeTest.psm1" <-||-  <-||- 
         -||-> Set-Content -Path $testModule -Value @'
        $scriptVar = 15
        $Global:globalVar = "Hello"

        
        function Test-Untrusted
        {
            [CmdletBinding()]
            param(
                [Parameter()]
                [ValidateTrustedData()]
                $Argument
            )

            Write-Output $Argument
        }

        
        function Test-SimpleUntrusted
        {
            param(
                [ValidateTrustedData()]
                $Argument
            )

            Write-Output $Argument
        }

        
        function Test-OtherParameterType
        {
            [CmdletBinding()]
            param(
                [Parameter()]
                [ValidateTrustedData()]
                [string[]] $Name,

                [Parameter()]
                [ValidateTrustedData()]
                [DateTime] $Date,

                [Parameter()]
                [ValidateTrustedData()]
                [System.IO.FileInfo] $File,

                [Parameter()]
                [ValidateTrustedData()]
                [System.Diagnostics.ProcessStartInfo] $StartInfo
            )

            throw "No Validation Exception!"
        }

        function Test-WithScriptVar { Test-Untrusted -Argument $scriptVar }
        function Test-WithGlobalVar { Test-Untrusted -Argument $Global:globalVar }

        function Test-SplatScriptVar { Test-Untrusted @scriptVar }
        function Test-SplatGlobalVar { Test-Untrusted @Global:globalVar }

        function Get-ScriptVar { $scriptVar }
        function Get-GlobalVar { $Global:globalVar }

        function Set-ScriptVar { $Script:scriptVar = "Trusted-Script" }
        function Set-GlobalVar { $Global:globalVar = "Trusted-Global" }

        
        
        
        
        function Test-AddType { Add-Type -TypeDefinition $args[0] }
        function Test-InvokeExpression { Invoke-Expression -Command $args[0] }
        function Test-NewObject { New-Object -TypeName $args[0] }
        function Test-ForeachObject { Get-Date | Foreach-Object -MemberName $args[0] }
        function Test-ImportModule { Import-Module -Name $args[0] }
        function Test-StartJob { Start-Job -ScriptBlock $args[0] }

'@ <-||- 

        
         -||-> $ps = [powershell]::Create() <-||- 

        
         -||-> function Execute-Script
        {
            param([string]$Script)

             -||-> $ps.Commands.Clear() <-||- 
             -||-> $ps.Streams.ClearStreams() <-||- 
             -||-> $ps.AddScript($Script).Invoke() <-||- 
        } <-||- 

        
        
         -||-> Execute-Script -Script "Import-Module $testModule" <-||- 

        
         -||-> Execute-Script -Script '$ExecutionContext.SessionState.LanguageMode = "ConstrainedLanguage"' <-||- 

        
         -||-> Execute-Script -Script '$mo = Get-Module UntrustedDataModeTest' <-||- 
    } <-||- 

     -||-> AfterAll {
        
         -||-> $ps.Dispose() <-||- 

        
        
        
         -||-> $ExecutionContext.SessionState.LanguageMode = "FullLanguage" <-||- 
    } <-||- 

     -||-> It "verify the initial state of the test module 'UntrustedDataModeTest'" {
         -||-> $result =  -||-> Execute-Script -Script "Test-WithScriptVar" <-||-  <-||- 
         -||-> $result | Should Be 15 <-||- 

         -||-> $result =  -||-> Execute-Script -Script "Test-WithGlobalVar" <-||-  <-||- 
         -||-> $result | Should Be "Hello" <-||- 

         -||-> $result =  -||-> Execute-Script -Script "Get-ScriptVar" <-||-  <-||- 
         -||-> $result | Should Be 15 <-||- 

         -||-> $result =  -||-> Execute-Script -Script "Get-GlobalVar" <-||-  <-||- 
         -||-> $result | Should Be "Hello" <-||- 

         -||-> $result =  -||-> Execute-Script -Script '$ExecutionContext.SessionState.LanguageMode' <-||-  <-||- 
         -||-> $result | Should Be "ConstrainedLanguage" <-||- 
    } <-||- 

     -||-> Context "Set global variable value in top-level session state" {

         -||-> BeforeAll {

             -||-> $testScript = @'
            Get-GlobalVar
            try { Test-WithGlobalVar } catch { $_.FullyQualifiedErrorId }
'@ <-||- 

             -||-> $testCases = @(
                
                 -||-> @{
                    Name =  -||-> 'language in global scope' <-||- 
                    SetupScript =  -||-> '$globalVar = "language in global scope"' <-||- 
                    ExpectedOutput =  -||-> "language in global scope;ParameterArgumentValidationError,Test-Untrusted" <-||- 
                },
                @{
                    Name =  -||-> 'language in sub scope' <-||- 
                    SetupScript =  -||-> '& { $Global:globalVar = "language in sub scope" }' <-||- 
                    ExpectedOutput =  -||-> "language in sub scope;ParameterArgumentValidationError,Test-Untrusted" <-||- 
                },

                
                @{
                    Name =  -||-> 'New-Variable in global scope' <-||- 
                    SetupScript =  -||-> 'New-Variable globalVar -Value "New-Variable in global scope" -Force' <-||- 
                    ExpectedOutput =  -||-> "New-Variable in global scope;ParameterArgumentValidationError,Test-Untrusted" <-||- 
                },
                @{
                    Name =  -||-> "New-Variable in sub scope with [-Scope Global]" <-||- 
                    SetupScript =  -||-> '& { New-Variable globalVar -Value "New-Variable in sub scope with [-Scope Global]" -Force -Scope Global }' <-||- 
                    ExpectedOutput =  -||-> "New-Variable in sub scope with [-Scope Global];ParameterArgumentValidationError,Test-Untrusted" <-||- 
                },
                @{
                    Name =  -||-> "New-Variable in sub scope with [-Scope 1]" <-||- 
                    SetupScript =  -||-> '& { New-Variable globalVar -Value "New-Variable in sub scope with [-Scope 1]" -Force -Scope 1 }' <-||- 
                    ExpectedOutput =  -||-> "New-Variable in sub scope with [-Scope 1];ParameterArgumentValidationError,Test-Untrusted" <-||- 
                },

                
                @{
                    Name =  -||-> 'Set-Variable in global scope' <-||- 
                    SetupScript =  -||-> 'Set-Variable globalVar -Value "Set-Variable in global scope" -Force' <-||- 
                    ExpectedOutput =  -||-> "Set-Variable in global scope;ParameterArgumentValidationError,Test-Untrusted" <-||- 
                },
                @{
                    Name =  -||-> 'Set-Variable in sub scope with [-Scope Global]' <-||- 
                    SetupScript =  -||-> '& { Set-Variable globalVar -Value "Set-Variable in sub scope with [-Scope Global]" -Scope Global  }' <-||- 
                    ExpectedOutput =  -||-> "Set-Variable in sub scope with [-Scope Global];ParameterArgumentValidationError,Test-Untrusted" <-||- 
                },
                @{
                    Name =  -||-> 'Set-Variable in sub scope with [-Scope 1]' <-||- 
                    SetupScript =  -||-> '& { Set-Variable globalVar -Value "Set-Variable in sub scope with [-Scope 1]" -Scope 1  }' <-||- 
                    ExpectedOutput =  -||-> "Set-Variable in sub scope with [-Scope 1];ParameterArgumentValidationError,Test-Untrusted" <-||- 
                },

                
                @{
                    Name =  -||-> 'New-Item in global scope' <-||- 
                    SetupScript =  -||-> 'New-Item variable:\globalVar -Value "New-Item in global scope" -Force' <-||- 
                    ExpectedOutput =  -||-> "New-Item in global scope;ParameterArgumentValidationError,Test-Untrusted" <-||- 
                },
                @{
                    Name =  -||-> 'New-Item in sub scope' <-||- 
                    
                    SetupScript =  -||-> 'Set-GlobalVar; & { New-Item variable:\globalVar -Value "New-Item in sub scope" -Force }' <-||- 
                    ExpectedOutput =  -||-> "Trusted-Global;Trusted-Global" <-||- 
                },

                
                @{
                    Name =  -||-> 'Set-Item in global scope' <-||- 
                    SetupScript =  -||-> 'Set-Item variable:\globalVar -Value "Set-Item in global scope" -Force' <-||- 
                    ExpectedOutput =  -||-> "Set-Item in global scope;ParameterArgumentValidationError,Test-Untrusted" <-||- 
                },
                @{
                    Name =  -||-> 'Set-Item in sub scope' <-||- 
                    
                    SetupScript =  -||-> 'Set-GlobalVar; & { Set-Item variable:\globalVar -Value "Set-Item in sub scope" -Force }' <-||- 
                    ExpectedOutput =  -||-> "Trusted-Global;Trusted-Global" <-||- 
                },

                
                @{
                    Name =  -||-> 'ErrorVariable in global scope' <-||- 
                    SetupScript =  -||-> 'Write-Error "Error" -ErrorAction SilentlyContinue -ErrorVariable globalVar' <-||- 
                    ExpectedOutput =  -||-> "Error;ParameterArgumentValidationError,Test-Untrusted" <-||- 
                },
                @{
                    Name =  -||-> 'ErrorVariable in sub scope' <-||- 
                    SetupScript =  -||-> '& { Write-Error "Error-in-Sub" -ErrorAction SilentlyContinue -ErrorVariable global:globalVar }' <-||- 
                    ExpectedOutput =  -||-> "Error-in-Sub;ParameterArgumentValidationError,Test-Untrusted" <-||- 
                },

                
                @{
                    Name =  -||-> 'OutVariable in global scope' <-||- 
                    SetupScript =  -||-> 'Write-Output "Out" -OutVariable globalVar' <-||- 
                    ExpectedOutput =  -||-> "Out;ParameterArgumentValidationError,Test-Untrusted" <-||- 
                },
                @{
                    Name =  -||-> 'OutVariable in sub scope' <-||- 
                    SetupScript =  -||-> '& { Write-Output "Out-in-Sub" -OutVariable global:globalVar }' <-||- 
                    ExpectedOutput =  -||-> "Out-in-Sub;ParameterArgumentValidationError,Test-Untrusted" <-||- 
                },

                
                @{
                    Name =  -||-> 'WarningVariable in global scope' <-||- 
                    SetupScript =  -||-> 'Write-Warning "Warning" -WarningAction SilentlyContinue -WarningVariable globalVar' <-||- 
                    ExpectedOutput =  -||-> "Warning;ParameterArgumentValidationError,Test-Untrusted" <-||- 
                },
                @{
                    Name =  -||-> 'WarningVariable in sub scope' <-||- 
                    SetupScript =  -||-> '& { Write-Warning "Warning-in-Sub" -WarningAction SilentlyContinue -WarningVariable global:globalVar }' <-||- 
                    ExpectedOutput =  -||-> "Warning-in-Sub;ParameterArgumentValidationError,Test-Untrusted" <-||- 
                },

                
                @{
                    Name =  -||-> 'InformationVariable in global scope' <-||- 
                    SetupScript =  -||-> 'Write-Information "Information" -InformationAction SilentlyContinue -InformationVariable globalVar' <-||- 
                    ExpectedOutput =  -||-> "Information;ParameterArgumentValidationError,Test-Untrusted" <-||- 
                },
                @{
                    Name =  -||-> 'InformationVariable in sub scope' <-||- 
                    SetupScript =  -||-> '& { Write-Information "Information-in-Sub" -InformationAction SilentlyContinue -InformationVariable global:globalVar }' <-||- 
                    ExpectedOutput =  -||-> "Information-in-Sub;ParameterArgumentValidationError,Test-Untrusted" <-||- 
                },

                
                
                @{
                    Name =  -||-> 'Data Section' <-||- 
                    SetupScript =  -||-> 'data globalVar { "data section" }' <-||- 
                    ExpectedOutput =  -||-> "data section;ParameterArgumentValidationError,Test-Untrusted" <-||- 
                } <-||- 
            ) <-||- 
        } <-||- 

         -||-> It "<Name>" -TestCases $testCases {
            param ($SetupScript, $ExpectedOutput)

             -||-> Execute-Script -Script $SetupScript > $null <-||- 
             -||-> $result =  -||-> Execute-Script -Script $testScript <-||-  <-||- 

             -||-> $result -join ";" | Should Be $ExpectedOutput <-||- 
        } <-||- 

         -||-> It "Enable 'data global:var' test if the syntax is supported" {
             -||-> try {
                 -||-> [scriptblock]::Create('data global:var { "data section" }') <-||- 
                throw  -||-> "No Exception!" <-||- 
            } catch {

                
                
                
                 -||-> $_.FullyQualifiedErrorId | Should Be "ParseException" <-||- 
            } <-||- 
        } <-||- 
    } <-||- 

     -||-> Context "Set variable in Import-LocalizedData" {

         -||-> BeforeAll {
             -||-> $localData =  -||-> Join-Path $TestDrive "local.psd1" <-||-  <-||- 
             -||-> Set-Content $localData -Value '"Localized-Data"' <-||- 
        } <-||- 

         -||-> It "test global variable set by Import-LocalizedData" {
             -||-> $testScript = @'
            Get-GlobalVar
            try { Test-WithGlobalVar } catch { $_.FullyQualifiedErrorId }
'@ <-||- 
             -||-> Execute-Script -Script "Import-LocalizedData -BindingVariable globalVar -BaseDirectory $TestDrive -FileName local.psd1" <-||- 
             -||-> $result =  -||-> Execute-Script -Script $testScript <-||-  <-||- 

             -||-> $result -join ";" | Should Be "Localized-Data;ParameterArgumentValidationError,Test-Untrusted" <-||- 
        } <-||- 
    } <-||- 

     -||-> Context "Exported variables by module loading" {

         -||-> BeforeAll {
            
             -||-> $VarModule =  -||-> Join-Path $TestDrive "Var.psm1" <-||-  <-||- 
             -||-> Set-Content $VarModule -Value @'
            $globalVar = "global-from-module"
            $scriptVar = "script-from-module"
            Export-ModuleMember -Variable globalVar, scriptVar
'@ <-||- 

             -||-> $testScript = @'
            Get-GlobalVar
            try { Test-WithGlobalVar } catch { $_.FullyQualifiedErrorId }

            Get-ScriptVar
            try { Test-WithScriptVar } catch { $_.FullyQualifiedErrorId }
'@ <-||- 
        } <-||- 

         -||-> BeforeEach {
            
             -||-> Execute-Script -Script "Set-ScriptVar; Set-GlobalVar" <-||- 
        } <-||- 

         -||-> It "test global variable set by exported variable" {
             -||-> try {
                
                
                 -||-> Execute-Script -Script "Import-Module $VarModule" <-||- 
                 -||-> $result =  -||-> Execute-Script -Script $testScript <-||-  <-||- 

                 -||-> $result -join ";" | Should Be "global-from-module;ParameterArgumentValidationError,Test-Untrusted;Trusted-Script;Trusted-Script" <-||- 
            } finally {
                 -||-> Execute-Script -Script "Remove-Module Var -Force" <-||- 
            } <-||- 
        } <-||- 
    } <-||- 

     -||-> Context "Splatting of untrusted value" {
         -||-> It "test splatting global variable" {
             -||-> $testScript = @'
            Get-GlobalVar
            try { Test-SplatGlobalVar } catch { $_.FullyQualifiedErrorId }
'@ <-||- 
             -||-> Execute-Script -Script '$globalVar = @{ Argument = "global-splatting" }' <-||- 
             -||-> $result =  -||-> Execute-Script -Script $testScript <-||-  <-||- 

             -||-> $result -join ";" | Should Be "System.Collections.Hashtable;ParameterArgumentValidationError,Test-Untrusted" <-||- 
        } <-||- 
    } <-||- 

     -||-> Context "ValidateTrustedDataAttribute takes NO effect in non-FullLanguage" {

         -||-> It "test 'ValidateTrustedDataAttribute' NOT take effect in non-FullLanguage [Add-Type]" {
            
             -||-> $result =  -||-> Execute-Script -Script @'
            try {
                $globalVar = "C
                Add-Type -TypeDefinition $globalVar
                throw "Expected 'CannotDefineNewType' error was not thrown"
            } catch {
                $_.FullyQualifiedErrorId
            }
'@ <-||-  <-||- 
             -||-> $result | Should Be "CannotDefineNewType,Microsoft.PowerShell.Commands.AddTypeCommand" <-||- 
        } <-||- 

         -||-> It "test 'ValidateTrustedDataAttribute' NOT take effect in non-FullLanguage [Invoke-Expression]" {
            
             -||-> $result =  -||-> Execute-Script -Script @'
            $globalVar = "Get-Process -id $PID"
            Invoke-Expression -Command $globalVar | ForEach-Object Id
'@ <-||-  <-||- 
             -||-> $result | Should Be $PID <-||- 
        } <-||- 

         -||-> It "test 'ValidateTrustedDataAttribute' NOT take effect in non-FullLanguage [New-Object]" {
            
             -||-> $result =  -||-> Execute-Script -Script @'
            $globalVar = "uri"
            New-Object -TypeName $globalVar -ArgumentList 'https://www.bing.com'
'@ <-||-  <-||- 
             -||-> $result | Should Not BeNullOrEmpty <-||- 
        } <-||- 

         -||-> It "test 'ValidateTrustedDataAttribute' NOT take effect in non-FullLanguage [Foreach-Object]" {
            
             -||-> $result =  -||-> Execute-Script -Script @'
            $globalVar = "Year"
            Get-Date | Foreach-Object -MemberName $globalVar
'@ <-||-  <-||- 
             -||-> $result | Should Not BeNullOrEmpty <-||- 
        } <-||- 

         -||-> It "test 'ValidateTrustedDataAttribute' NOT take effect in non-FullLanguage [Import-Module]" {
            
             -||-> $result =  -||-> Execute-Script -Script @'
            $globalVar = "NonExistModule"
            Import-Module -Name $globalVar -ErrorAction SilentlyContinue -ErrorVariable ev; $ev
'@ <-||-  <-||- 
             -||-> $result | Should Not BeNullOrEmpty <-||- 
             -||-> $result.FullyQualifiedErrorId | Should Be "Modules_ModuleNotFound,Microsoft.PowerShell.Commands.ImportModuleCommand" <-||- 
        } <-||- 

         -||-> It "test 'ValidateTrustedDataAttribute' NOT take effect in non-FullLanguage [Start-Job]" {
            
             -||-> $result =  -||-> Execute-Script -Script @'
            try {
                $globalVar = {1+1}
                Start-Job -ScriptBlock $globalVar
                throw "Expected 'CannotStartJob' error was not thrown"
            } catch {
                $_.FullyQualifiedErrorId
            }
'@ <-||-  <-||- 
             -||-> $result | Should Be "CannotStartJobInconsistentLanguageMode,Microsoft.PowerShell.Commands.StartJobCommand" <-||- 
        } <-||- 
    } <-||- 

     -||-> Context "ValidateTrustedDataAttribute takes effect in FullLanguage" {

         -||-> It "test 'ValidateTrustedDataAttribute' take effect when calling from 'Constrained' to 'Full' [Script Cmdlet]" {
            
             -||-> $result =  -||-> Execute-Script -Script @'
            try {
                $globalVar = "C
                Test-Untrusted -Argument $globalVar
                throw "Expected 'ParameterArgumentValidationError' was not thrown"
            } catch {
                $_.FullyQualifiedErrorId
            }
'@ <-||-  <-||- 
             -||-> $result | Should Be "ParameterArgumentValidationError,Test-Untrusted" <-||- 
        } <-||- 

         -||-> It "test 'ValidateTrustedDataAttribute' take effect when calling from 'Constrained' to 'Full' [Simple function]" {
            
             -||-> $result =  -||-> Execute-Script -Script @'
            try {
                $globalVar = "C
                Test-SimpleUntrusted -Argument $globalVar
                throw "Expected 'ParameterArgumentValidationError' was not thrown"
            } catch {
                $_.FullyQualifiedErrorId
            }
'@ <-||-  <-||- 
             -||-> $result | Should Be "ParameterArgumentValidationError,Test-SimpleUntrusted" <-||- 
        } <-||- 

         -||-> It "test 'ValidateTrustedDataAttribute' with param type conversion [string -> string[]]" {
            
             -||-> $result =  -||-> Execute-Script -Script @'
            try {
                $globalVar = "John"
                Test-OtherParameterType -Name $globalVar
                throw "Expected 'ParameterArgumentValidationError' was not thrown"
            } catch {
                $_.FullyQualifiedErrorId
            }
'@ <-||-  <-||- 
             -||-> $result | Should Be "ParameterArgumentValidationError,Test-OtherParameterType" <-||- 
        } <-||- 

         -||-> It "test 'ValidateTrustedDataAttribute' with value type param [DateTime]" {
            
             -||-> $result =  -||-> Execute-Script -Script @'
            try {
                $globalVar = Get-Date
                Test-OtherParameterType -Date $globalVar
                throw "Expected 'ParameterArgumentValidationError' was not thrown"
            } catch {
                $_.FullyQualifiedErrorId
            }
'@ <-||-  <-||- 
             -||-> $result | Should Be "ParameterArgumentValidationError,Test-OtherParameterType" <-||- 
        } <-||- 

         -||-> It "test 'ValidateTrustedDataAttribute' with param type conversion [string -> FileInfo]" {
            
             -||-> $result =  -||-> Execute-Script -Script @'
            try {
                $globalVar = "FakeFile"
                Test-OtherParameterType -File $globalVar
                throw "Expected 'ParameterArgumentValidationError' was not thrown"
            } catch {
                $_.FullyQualifiedErrorId
            }
'@ <-||-  <-||- 
             -||-> $result | Should Be "ParameterArgumentValidationError,Test-OtherParameterType" <-||- 
        } <-||- 

         -||-> It "test type property conversion to [ProcessStartInfo] should fail during Lang-Mode transition" {
            
             -||-> $result =  -||-> Execute-Script -Script @'
            try {
                Test-OtherParameterType -StartInfo @{ FileName = "File" }
                throw "Expected conversion error was not thrown"
            } catch {
                $_.FullyQualifiedErrorId
            }
'@ <-||-  <-||- 
             -||-> $result | Should Be "ParameterArgumentTransformationError,Test-OtherParameterType" <-||- 
        } <-||- 
    } <-||- 

     -||-> Context "Validate trusted data for parameters of some built-in powershell cmdlets" {

         -||-> BeforeAll {
             -||-> $ScriptTemplate = @'
            try {{
                {0}
                throw "Expected 'ParameterArgumentValidationError' was not thrown"
            }} catch {{
                $_.FullyQualifiedErrorId
            }}
'@ <-||- 
             -||-> $testCases = @(
                 -||-> @{ Name =  -||-> "test 'ValidateTrustedDataAttribute' on [Add-Type]" <-||- ;          Argument =  -||-> '$globalVar = "Global-Value"; Test-AddType $globalVar' <-||- ;          ExpectedErrorId =  -||-> "ParameterArgumentValidationError,Microsoft.PowerShell.Commands.AddTypeCommand" <-||-  } <-||- 
                 -||-> @{ Name =  -||-> "test 'ValidateTrustedDataAttribute' on [Invoke-Expression]" <-||- ; Argument =  -||-> '$globalVar = "Global-Value"; Test-InvokeExpression $globalVar' <-||- ; ExpectedErrorId =  -||-> "ParameterArgumentValidationError,Microsoft.PowerShell.Commands.InvokeExpressionCommand" <-||-  } <-||- 
                 -||-> @{ Name =  -||-> "test 'ValidateTrustedDataAttribute' on [New-Object]" <-||- ;        Argument =  -||-> '$globalVar = "Global-Value"; Test-NewObject $globalVar' <-||- ;        ExpectedErrorId =  -||-> "ParameterArgumentValidationError,Microsoft.PowerShell.Commands.NewObjectCommand" <-||-  } <-||- 
                 -||-> @{ Name =  -||-> "test 'ValidateTrustedDataAttribute' on [Foreach-Object]" <-||- ;    Argument =  -||-> '$globalVar = "Global-Value"; Test-ForeachObject $globalVar' <-||- ;    ExpectedErrorId =  -||-> "ParameterArgumentValidationError,Microsoft.PowerShell.Commands.ForeachObjectCommand" <-||-  } <-||- 
                 -||-> @{ Name =  -||-> "test 'ValidateTrustedDataAttribute' on [Import-Module]" <-||- ;     Argument =  -||-> '$globalVar = "Global-Value"; Test-ImportModule $globalVar' <-||- ;     ExpectedErrorId =  -||-> "ParameterArgumentValidationError,Microsoft.PowerShell.Commands.ImportModuleCommand" <-||-  } <-||- 
                 -||-> @{ Name =  -||-> "test 'ValidateTrustedDataAttribute' on [Start-Job]" <-||- ;         Argument =  -||-> '$globalVar = {1+1}; Test-StartJob $globalVar' <-||- ;                  ExpectedErrorId =  -||-> "ParameterArgumentValidationError,Microsoft.PowerShell.Commands.StartJobCommand" <-||-  } <-||- 
            ) <-||- 
        } <-||- 

         -||-> It "<Name>" -TestCases $testCases {
            param ($Argument, $ExpectedErrorId)
            
             -||-> $testScript = $ScriptTemplate -f $Argument <-||- 
             -||-> $result =  -||-> Execute-Script -Script $testScript <-||-  <-||- 
             -||-> $result | Should Be $ExpectedErrorId <-||- 
        } <-||- 
    } <-||- 
} <-||- 


