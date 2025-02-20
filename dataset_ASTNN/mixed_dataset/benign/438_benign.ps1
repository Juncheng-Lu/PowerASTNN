
 -||-> function Set-CDotNetConnectionString
{
    
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(Mandatory=$true)]
        [string]
        
        $Name,

        [Parameter(Mandatory=$true)]
        [string]
        
        $Value,

        [string]
        
        $ProviderName,
        
        [Switch]
        
        $Framework,
        
        [Switch]
        
        $Framework64,
        
        [Switch]
        
        $Clr2,
        
        [Switch]
        
        $Clr4
    )
    
     -||-> Set-StrictMode -Version 'Latest' <-||- 

     -||-> Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState <-||- 

     -||-> if(  -||-> -not ( -||-> $Framework -or $Framework64 <-||- ) <-||-  )
    {
         -||-> Write-Error "You must supply either or both of the Framework and Framework64 switches." <-||- 
        return
    } <-||- 
    
     -||-> if(  -||-> -not ( -||-> $Clr2 -or $Clr4 <-||- ) <-||-  )
    {
         -||-> Write-Error "You must supply either or both of the Clr2 and Clr4 switches." <-||- 
        return
    } <-||- 
    
     -||-> $runtimes = @() <-||- 
     -||-> if(  -||-> $Clr2 <-||-  )
    {
         -||-> $runtimes += 'v2.0' <-||- 
    } <-||- 
     -||-> if(  -||-> $Clr4 <-||-  )
    {
         -||-> $runtimes += 'v4.0' <-||- 
    } <-||- 

     -||-> $runtimes | ForEach-Object {
         -||-> $params = @{
            FilePath =  -||-> ( -||-> Join-Path $CarbonBinDir 'Set-DotNetConnectionString.ps1' -Resolve <-||- ) <-||- ;
            ArgumentList =  -||-> @(
                                 -||-> ( -||-> ConvertTo-CBase64 -Value $Name <-||- ),
                                ( -||-> ConvertTo-CBase64 -Value $Value <-||- ),
                                ( -||-> ConvertTo-CBase64 -Value $ProviderName <-||- ) <-||-  
                            ) <-||- ;
            Runtime =  -||-> $_ <-||- ;
            ExecutionPolicy =  -||-> [Microsoft.PowerShell.ExecutionPolicy]::RemoteSigned <-||- ;
        } <-||- 

         -||-> if(  -||-> $Framework <-||-  )
        {    
             -||-> Invoke-CPowerShell @params -x86 <-||- 
        } <-||- 
        
         -||-> if(  -||-> $Framework64 <-||-  )
        {
             -||-> Invoke-CPowerShell @params <-||- 
        } <-||- 
    } <-||- 
} <-||- 



