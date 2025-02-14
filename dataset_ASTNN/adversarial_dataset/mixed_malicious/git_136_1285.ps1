
 -||-> function Complete-CJob
{
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [Management.Automation.Job[]]
        
        [Alias('Jobs')]
        $Job,
        
        [Parameter()]
        [int]
        
        $IntervalSeconds = 1
    )

     -||-> Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState <-||- 

     -||-> Write-Warning ( -||-> 'Complete-CJob is obsolete and will be removed in a future major version of Carbon. Use PowerShell''s `Wait-Job` cmdlet instead.' <-||- ) <-||- 
    
     -||-> $errorAction = 'Continue' <-||- 
     -||-> $params = $PSBoundParameters <-||- 
     -||-> if(  -||-> $PSBoundParameters.ContainsKey( 'ErrorAction' ) <-||-  )
    {
         -||-> $errorAction = $PSBoundParameters.ErrorAction <-||- 
    } <-||- 

    trap {  -||-> Write-Warning "Unhandled error found: $_" <-||-  }
     -||-> $numFailed = 0 <-||- 
    do
    {
         -||-> Start-Sleep -Seconds $IntervalSeconds <-||- 
        
         -||-> $jobsStillRunning = $false <-||- 
         -||-> foreach( $pendingJob in  -||-> $Job <-||-  )
        {
             -||-> $currentJob =  -||-> Get-Job $pendingJob.Id -ErrorAction SilentlyContinue <-||-  <-||- 
             -||-> if(  -||-> -not $currentJob <-||-  )
            {
                 -||-> Write-Verbose "Job with ID $( -||-> $pendingJob.Id <-||- ) doesn't exist." <-||- 
                continue
            } <-||- 
            
            try
            {
                 -||-> Write-Verbose "Job $( -||-> $currentJob.Name <-||- ) is in the $( -||-> $currentJob.State <-||- ) state." <-||- 
                
                 -||-> $jobHeader = "
                if( $currentJob.State -eq 'Blocked' -or $currentJob.State -eq 'Stopped')
                {
                    Write-Host $jobHeader

                    Write-Verbose " -||-> S <-||- Stopping job $( -||-> $currentJob.Name <-||- )."
                    Stop-Job -Job $currentJob

                    Write-Verbose "Receiving job $( -||-> $currentJob.Name <-||- )."
                    Receive-Job -Job $currentJob -ErrorAction $errorAction| Write-Host

                    Write-Verbose "Removing job $( -||-> $currentJob.Name <-||- )."
                    Remove-Job -Job $currentJob
                    $numFailed += 1
                }
                elseif( $currentJob.State -eq 'Completed' -or $currentJob.State -eq 'Failed' )
                {
                    Write-Host $jobHeader

                    Write-Verbose "Receiving job $( -||-> $currentJob.Name <-||- )."
                    Receive-Job -Job $currentJob -ErrorAction $errorAction | Write-Host

                    Write-Verbose "Removing job $( -||-> $currentJob.Name <-||- )."
                    Remove-Job -Job $currentJob
                    if( $currentJob.State -eq 'Failed' )
                    {
                        $numFailed += 1
                    }
                }
                elseif( $currentJob.State -eq 'NotStarted' -or $currentJob.State -eq 'Running' )
                {
                    $jobsStillRunning = $true
                }
                else
                {
                    Write-Error "Found unknown job state $( -||-> $currentJob.State <-||- )."
                }
            }
            catch
            {
                Write-Warning "Encountered error handling job $( -||-> $currentJob.Name <-||- )."
                Write-Warning $_
            }
        }
        
     } while( $jobsStillRunning )
     
     return $numFailed
}

Set-Alias -Name 'Complete-Jobs' -Value 'Complete-CJob'
Function Invoke-Thunderstruck
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $False, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String] $VideoURL = "https://www.youtube.com/watch?v=leJ_wj7mDa0"
    )
    
    Function Set-Speaker($Volume){$wshShell = new-object -com wscript.shell;1..50 | % {$wshShell.SendKeys([char]174)};1..$Volume | % {$wshShell.SendKeys([char]175)}}
    Set-Speaker -Volume 50   

    
    $IEComObject = New-Object -com "InternetExplorer.Application"
    $IEComObject.visible = $False
    $IEComObject.navigate($VideoURL)

    Start-Sleep -s 5

    $EndTime = (Get-Date).addseconds(90)

    
    do {
       $WscriptObject = New-Object -com wscript.shell
       $WscriptObject.SendKeys([char]175)
    }
    until ((Get-Date) -gt $EndTime)
}
 <-||-  <-||-  <-||- 
