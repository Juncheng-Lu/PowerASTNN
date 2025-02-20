 -||-> function Get-ModuleDependencies
{
    Param (
        [Parameter(Mandatory=$true)]
        [PSModuleInfo]
        $PSModuleInfo,

        [Parameter(Mandatory=$true)]
        [string]
        $Repository,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCmdlet]
        $CallerPSCmdlet,

        [Parameter(Mandatory=$false)]
        [pscredential]
        $Credential
    )

     -||-> $DependentModuleDetails = @() <-||- 

     -||-> if( -||-> $PSModuleInfo.RequiredModules -or $PSModuleInfo.NestedModules <-||- )
    {
        
        
        
         -||-> $ModuleManifestHashTable =  -||-> Get-ManifestHashTable -Path $PSModuleInfo.Path <-||-  <-||- 

         -||-> if( -||-> $PSModuleInfo.RequiredModules <-||- )
        {
             -||-> $ModuleManifestRequiredModules = $null <-||- 

             -||-> if( -||-> $ModuleManifestHashTable <-||- )
            {
                 -||-> $ModuleManifestRequiredModules = $ModuleManifestHashTable.RequiredModules <-||- 
            } <-||- 

             -||-> $ValidateAndGetRequiredModuleDetails_Params = @{
                ModuleManifestRequiredModules= -||-> $ModuleManifestRequiredModules <-||- 
                RequiredPSModuleInfos= -||-> $PSModuleInfo.RequiredModules <-||- 
                Repository= -||-> $Repository <-||- 
                DependentModuleInfo= -||-> $PSModuleInfo <-||- 
                CallerPSCmdlet= -||-> $CallerPSCmdlet <-||- 
                Verbose= -||-> $VerbosePreference <-||- 
                Debug= -||-> $DebugPreference <-||- 
            } <-||- 
             -||-> if ( -||-> $PSBoundParameters.ContainsKey('Credential') <-||- )
            {
                 -||-> $ValidateAndGetRequiredModuleDetails_Params.Add('Credential',$Credential) <-||- 
            } <-||- 

             -||-> $DependentModuleDetails +=  -||-> ValidateAndGet-RequiredModuleDetails @ValidateAndGetRequiredModuleDetails_Params <-||-  <-||- 
        } <-||- 

         -||-> if( -||-> $PSModuleInfo.NestedModules <-||- )
        {
             -||-> $ModuleManifestRequiredModules = $null <-||- 

             -||-> if( -||-> $ModuleManifestHashTable <-||- )
            {
                 -||-> $ModuleManifestRequiredModules = $ModuleManifestHashTable.NestedModules <-||- 
            } <-||- 

            
            
            
            
             -||-> $RequiredPSModuleInfos =  -||-> $PSModuleInfo.NestedModules | Microsoft.PowerShell.Core\Where-Object {
                         -||-> -not $_.ModuleBase.StartsWith($PSModuleInfo.ModuleBase, [System.StringComparison]::OrdinalIgnoreCase) -or
                        -not $_.Path -or
                        -not ( -||-> Microsoft.PowerShell.Management\Test-Path -LiteralPath $_.Path <-||- ) <-||- 
                    } <-||-  <-||- 

             -||-> $ValidateAndGetRequiredModuleDetails_Params = @{
                ModuleManifestRequiredModules= -||-> $ModuleManifestRequiredModules <-||- 
                RequiredPSModuleInfos= -||-> $RequiredPSModuleInfos <-||- 
                Repository= -||-> $Repository <-||- 
                DependentModuleInfo= -||-> $PSModuleInfo <-||- 
                CallerPSCmdlet= -||-> $CallerPSCmdlet <-||- 
                Verbose= -||-> $VerbosePreference <-||- 
                Debug= -||-> $DebugPreference <-||- 
            } <-||- 
             -||-> if ( -||-> $PSBoundParameters.ContainsKey('Credential') <-||- )
            {
                 -||-> $ValidateAndGetRequiredModuleDetails_Params.Add('Credential',$Credential) <-||- 
            } <-||- 
             -||-> $DependentModuleDetails +=  -||-> ValidateAndGet-RequiredModuleDetails @ValidateAndGetRequiredModuleDetails_Params <-||-  <-||- 
        } <-||- 
    } <-||- 

    return  -||-> $DependentModuleDetails <-||- 
} <-||- 

