
 -||-> function Uninstall-CService
{
    
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(Mandatory=$true)]
        [string]
        
        $Name,

        [timespan]
        
        
        
        $StopTimeout
    )
    
     -||-> Set-StrictMode -Version 'Latest' <-||- 
     -||-> Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState <-||- 

     -||-> $service =  -||-> Get-Service | Where-Object {  -||-> $_.Name -eq $Name <-||-  } <-||-  <-||- 
     -||-> $sc =  -||-> Join-Path -Path $env:WinDir -ChildPath 'system32\sc.exe' -Resolve <-||-  <-||- 

     -||-> if(  -||-> -not $service <-||-  )
    {
        return
    } <-||- 

     -||-> $origVerbosePref = $VerbosePreference <-||- 
     -||-> $VerbosePreference = 'SilentlyContinue' <-||- 
     -||-> $cimService =  -||-> Get-CimInstance 'Win32_Service' -Filter ( -||-> 'Name = ''{0}''' -f $service.Name <-||- ) <-||-  <-||- 
     -||-> $cimServiceProcessCount = 0 <-||- 
     -||-> if(  -||-> $cimService <-||-  )
    {
         -||-> $cimServiceProcessCount =  -||-> Get-CimInstance 'Win32_Service' -Filter ( -||-> 'ProcessId = ''{0}''' -f $cimService.ProcessId <-||- ) |
                                            Measure-Object |
                                            Select-Object -ExpandProperty 'Count' <-||-  <-||- 
    } <-||- 
     -||-> $VerbosePreference = $origVerbosePref <-||- 

     -||-> if(  -||-> -not $pscmdlet.ShouldProcess( "service '$Name'", "remove" ) <-||-  )
    {
        return
    } <-||- 

     -||-> Stop-Service $Name <-||- 
     -||-> if(  -||-> $cimService -and $cimServiceProcessCount -eq 1 <-||-  )
    {
         -||-> $process =  -||-> Get-Process -Id $cimService.ProcessId -ErrorAction Ignore <-||-  <-||- 
         -||-> if(  -||-> $process <-||-  )
        {
             -||-> $killService = $true <-||- 
             -||-> if(  -||-> $StopTimeout <-||-  )
            {
                 -||-> Write-Verbose -Message ( -||-> '[Uninstall-CService]  [{0}]  Waiting "{1}" second(s) for service process "{2}" to exit.' -f $Name,$StopTimeout.TotalSeconds,$process.Id <-||- ) <-||- 
                 -||-> $killService = -not $process.WaitForExit($StopTimeout.TotalMilliseconds) <-||- 
            } <-||- 

             -||-> if(  -||-> $killService <-||-  )
            {
                 -||-> $attemptNum = 0 <-||- 
                 -||-> $maxAttempts = 100 <-||- 
                 -||-> $killed = $false <-||- 
                 -||-> while(  -||-> $attemptNum++ -lt $maxAttempts <-||-  )
                {
                     -||-> Write-Verbose -Message ( -||-> '[Uninstall-CService]  [{0}]  [Attempt {1,3} of {2}]  Killing service process "{3}".' -f $Name,$attemptNum,$maxAttempts,$process.Id <-||- ) <-||- 
                     -||-> Stop-Process -Id $process.Id -Force -ErrorAction Ignore <-||- 
                     -||-> if(  -||-> -not ( -||-> Get-Process -Id $process.Id -ErrorAction Ignore <-||- ) <-||-  )
                    {
                         -||-> $killed = $true <-||- 
                        break
                    } <-||- 
                     -||-> Start-Sleep -Milliseconds 100 <-||- 
                } <-||- 
                 -||-> if(  -||-> -not $killed <-||-  )
                {
                     -||-> Write-Error -Message ( -||-> 'Failed to kill "{0}" service process "{1}".' -f $Name,$process.Id <-||- ) -ErrorAction $ErrorActionPreference <-||- 
                } <-||- 
            } <-||- 
        } <-||- 
    } <-||- 


     -||-> Write-Verbose -Message ( -||-> '[Uninstall-CService]  [{0}]  {1} delete {0}' -f $Name,$sc <-||- ) <-||- 
     -||-> $output =  -||-> & $sc delete $Name <-||-  <-||- 
     -||-> if(  -||-> $LASTEXITCODE <-||-  )
    {
         -||-> if(  -||-> $LASTEXITCODE -eq 1072 <-||-  )
        {
             -||-> Write-Warning -Message ( -||-> 'The {0} service is marked for deletion and will be removed during the next reboot.{1}{2}' -f $Name,( -||-> [Environment]::NewLine <-||- ),( -||-> $output -join ( -||-> [Environment]::NewLine <-||- ) <-||- ) <-||- ) <-||- 
        }
        else
        {
             -||-> Write-Error -Message ( -||-> 'Failed to uninstall {0} service (returned non-zero exit code {1}):{2}{3}' -f $Name,$LASTEXITCODE,( -||-> [Environment]::NewLine <-||- ),( -||-> $output -join ( -||-> [Environment]::NewLine <-||- ) <-||- ) <-||- ) <-||- 
        } <-||- 
    }
    else
    {
         -||-> $output | Write-Verbose <-||- 
    } <-||- 
} <-||- 

 -||-> Set-Alias -Name 'Remove-Service' -Value 'Uninstall-CService' <-||- 



