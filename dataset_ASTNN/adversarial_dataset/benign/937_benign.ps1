

 -||-> Describe "Job Cmdlet Tests" -Tag "CI" {
     -||-> Context "Simple Jobs" {
         -||-> BeforeEach {
             -||-> $j =  -||-> Start-Job -ScriptBlock {  -||-> 1 + 1 <-||-  } -Name "My Job" <-||-  <-||- 
        } <-||- 
         -||-> AfterEach {
             -||-> Get-Job | Remove-Job -Force <-||- 
        } <-||- 
         -||-> It "Start-Job produces a job object" {
             -||-> $j | Should -BeOfType "System.Management.Automation.Job" <-||- 
             -||-> $j.Name | Should -BeExactly "My Job" <-||- 
        } <-||- 
         -||-> It "Get-Job retrieves a job object" {
             -||-> ( -||-> Get-Job -Id $j.Id <-||- ) | Should -BeOfType "System.Management.Automation.Job" <-||- 
        } <-||- 
         -||-> It "Get-Job retrieves an array of job objects" {
             -||-> Start-Job -ScriptBlock {  -||-> 2 * 2 <-||-  } <-||- 
             -||-> $jobs =  -||-> Get-Job <-||-  <-||- 
             -||-> $jobs.Count | Should -Be 2 <-||- 
             -||-> foreach ($job in  -||-> $jobs <-||- )
            {
                 -||-> $job | Should -BeOfType "System.Management.Automation.Job" <-||- 
            } <-||- 
        } <-||- 
         -||-> It "Remove-Job can remove a job" {
             -||-> Remove-Job $j -Force <-||- 
             -||-> {  -||-> Get-Job $j -ErrorAction Stop <-||-  } | Should -Throw -ErrorId "JobWithSpecifiedNameNotFound,Microsoft.PowerShell.Commands.GetJobCommand" <-||- 
        } <-||- 
         -||-> It "Receive-Job can retrieve job results" {
             -||-> Wait-Job -Timeout 60 -id $j.id | Should -Not -BeNullOrEmpty <-||- 
             -||-> receive-job -id $j.id | Should -Be 2 <-||- 
        } <-||- 
         -||-> It "-RunAs32 not supported from 64-bit pwsh" -Skip:( -||-> -not [System.Environment]::Is64BitProcess <-||- ) {
             -||-> {  -||-> Start-Job -ScriptBlock {} -RunAs32 <-||-  } | Should -Throw -ErrorId "RunAs32NotSupported,Microsoft.PowerShell.Commands.StartJobCommand" <-||- 
        } <-||- 
         -||-> It "-RunAs32 supported in 32-bit pwsh" -Skip:( -||-> [System.Environment]::Is64BitProcess <-||- ) {
             -||-> $job =  -||-> Start-Job -ScriptBlock {  -||-> 1+1 <-||-  } -RunAs32 <-||-  <-||- 
             -||-> Receive-Job $job -Wait | Should -Be 2 <-||- 
        } <-||- 
    } <-||- 
     -||-> Context "Jobs with arguments" {
         -||-> It "Start-Job accepts arguments" {
             -||-> $sb = {  -||-> Write-Output $args[1] <-||- ;  -||-> Write-Output $args[0] <-||-  } <-||- 
             -||-> $j =  -||-> Start-Job -ScriptBlock $sb -ArgumentList "$TestDrive", 42 <-||-  <-||- 
             -||-> Wait-job -Timeout ( -||-> 5 * 60 <-||- ) $j | Should -Be $j <-||- 
             -||-> $r =  -||-> Receive-Job $j <-||-  <-||- 
             -||-> $r -Join "," | Should -Be "42,$TestDrive" <-||- 
        } <-||- 
    } <-||- 
     -||-> Context "jobs which take time" {
         -||-> BeforeEach {
             -||-> $j =  -||-> Start-Job -ScriptBlock {  -||-> Start-Sleep -Seconds 15 <-||-  } <-||-  <-||- 
        } <-||- 
         -||-> AfterEach {
             -||-> Get-Job | Remove-Job -Force <-||- 
        } <-||- 
         -||-> It "Wait-Job will wait for a job" {
             -||-> $result =  -||-> Wait-Job $j <-||-  <-||- 
             -||-> $result | Should -Be $j <-||- 
             -||-> $j.State | Should -BeExactly "Completed" <-||- 
        } <-||- 
         -||-> It "Wait-Job will timeout waiting for a job" {
             -||-> $result =  -||-> Wait-Job -Timeout 2 $j <-||-  <-||- 
             -||-> $result | Should -BeNullOrEmpty <-||- 
        } <-||- 
         -||-> It "Stop-Job will stop a job" {
             -||-> Stop-Job -Id $j.Id <-||- 
             -||-> $out =  -||-> Receive-Job $j -ErrorVariable err <-||-  <-||- 
             -||-> $out | Should -BeNullOrEmpty <-||- 
             -||-> $err | Should -BeNullOrEmpty <-||- 
             -||-> $j.State | Should -BeExactly "Stopped" <-||- 
        } <-||- 
         -||-> It "Remove-Job will not remove a running job" {
             -||-> $id = $j.Id <-||- 
             -||-> Remove-Job $j -ErrorAction SilentlyContinue <-||- 
             -||-> $job =  -||-> Get-Job -Id $id <-||-  <-||- 
             -||-> $job | Should -Be $j <-||- 
        } <-||- 
         -||-> It "Remove-Job -Force will remove a running job" {
             -||-> $id = $j.Id <-||- 
             -||-> Remove-Job $j -Force <-||- 
             -||-> $job =  -||-> Get-Job -Id $id -ErrorAction SilentlyContinue <-||-  <-||- 
             -||-> $job | Should -BeNullOrEmpty <-||- 
        } <-||- 
    } <-||- 
     -||-> Context "Retrieving partial output from jobs" {
         -||-> BeforeAll {
             -||-> function GetResults($job, $n, $keep)
            {
                 -||-> $results = @() <-||- 

                
                for ( -||-> $count = 0 <-||- ;  -||-> $results.Count -lt $n <-||- ;  -||-> $count++ <-||- )
                {
                     -||-> if ( -||-> $count -eq 1000 <-||- )
                    {
                        
                        throw  -||-> "Receive-Job behaves suspiciously: Cannot receive $n results in 5 minutes." <-||- 
                    } <-||- 

                    
                     -||-> Start-Sleep -Milliseconds 300 <-||- 

                     -||-> if ( -||-> $keep <-||- )
                    {
                         -||-> $results =  -||-> Receive-Job -Keep $job <-||-  <-||- 
                    }
                    else
                    {
                         -||-> $results +=  -||-> Receive-Job $job <-||-  <-||- 
                    } <-||- 
                }

                return  -||-> $results <-||- 
            } <-||- 

             -||-> function CheckContent($array)
            {
                for ( -||-> $i=1 <-||- ;  -||-> $i -lt $array.Count <-||- ;  -||-> $i++ <-||- )
                {
                     -||-> if ( -||-> $array[$i] -ne ( -||-> $array[$i-1] + 1 <-||- ) <-||- )
                    {
                        return  -||-> $false <-||- 
                    } <-||- 
                }

                return  -||-> $true <-||- 
            } <-||- 

        } <-||- 
         -||-> BeforeEach {
             -||-> $j =  -||-> Start-Job -ScriptBlock {  -||-> $count = 1 <-||- ;  -||-> while ( -||-> $true <-||- ) {  -||-> Write-Output ( -||-> $count++ <-||- ) <-||- ;  -||-> Start-Sleep -Milliseconds 30 <-||-  } <-||-  } <-||-  <-||- 
        } <-||- 
         -||-> AfterEach {
             -||-> Get-Job | Remove-Job -Force <-||- 
        } <-||- 

         -||-> It "Receive-Job will retrieve partial output" {
             -||-> $result1 =  -||-> GetResults $j 5 $false <-||-  <-||- 
             -||-> $result2 =  -||-> GetResults $j 5 $false <-||-  <-||- 
             -||-> CheckContent ( -||-> $result1 + $result2 <-||- ) | Should -BeTrue <-||- 
        } <-||- 
         -||-> It "Receive-Job will retrieve partial output, including -Keep results" {
             -||-> $result1 =  -||-> GetResults $j 5 $true <-||-  <-||- 
             -||-> $result2 =  -||-> GetResults $j ( -||-> $result1.Count + 5 <-||- ) $false <-||-  <-||- 
             -||-> Compare-Object -SyncWindow 0 -PassThru $result1 $result2[0..( -||-> $result1.Count-1 <-||- )] | Should -BeNullOrEmpty <-||- 
             -||-> $result2[$result1.Count - 1] + 1 | Should -Be $result2[$result1.Count] <-||- 
        } <-||- 
    } <-||- 
} <-||- 
 -||-> Describe "Debug-job test" -tag "Feature" {
     -||-> BeforeAll {
         -||-> $rs = [runspacefactory]::CreateRunspace() <-||- 
         -||-> $rs.Open() <-||- 
         -||-> $rs.Debugger.SetDebugMode([System.Management.Automation.DebugModes]::RemoteScript) <-||- 
         -||-> $rs.Debugger.add_DebuggerStop({ -||-> $true <-||- }) <-||- 
         -||-> $ps = [powershell]::Create() <-||- 
         -||-> $ps.Runspace = $rs <-||- 
    } <-||- 
     -||-> AfterAll {
         -||-> $rs.Dispose() <-||- 
         -||-> $ps.Dispose() <-||- 
    } <-||- 
    
    
     -||-> It "Debug-Job will break into debugger" -pending {
         -||-> $ps.AddScript('$job = start-job { 1..300 | ForEach-Object { Start-Sleep 1 } }').Invoke() <-||- 
         -||-> $ps.Commands.Clear() <-||- 
         -||-> $ps.Runspace.Debugger.GetCallStack() | Should -BeNullOrEmpty <-||- 
         -||-> Start-Sleep 3 <-||- 
         -||-> $asyncResult = $ps.AddScript('debug-job $job').BeginInvoke() <-||- 
         -||-> $ps.commands.clear() <-||- 
         -||-> Start-Sleep 2 <-||- 
         -||-> $result = $ps.runspace.Debugger.GetCallStack() <-||- 
         -||-> $result.Command | Should -BeExactly "<ScriptBlock>" <-||- 
    } <-||- 
} <-||- 

 -||-> Describe "Ampersand background test" -tag "CI","Slow" {
     -||-> Context "Simple background job" {
         -||-> AfterEach {
             -||-> Get-Job | Remove-Job -Force <-||- 
        } <-||- 
         -||-> It "Background with & produces a job object" {
             -||-> $j =  -||-> Write-Output Hi <-||-  <-||-  &
             -||-> $j | Should -BeOfType System.Management.Automation.Job <-||- 
        } <-||- 
    } <-||- 
     -||-> Context "Variable tests" {
         -||-> AfterEach {
             -||-> Get-Job | Remove-Job -Force <-||- 
        } <-||- 
         -||-> It "doesn't cause error when variable is missing" {
             -||-> Remove-Item variable:name -ErrorAction Ignore <-||- 
             -||-> $j =  -||-> write-output "Hi $name" <-||-  <-||-  &
             -||-> Receive-Job $j -Wait | Should -BeExactly "Hi " <-||- 
        } <-||- 
         -||-> It "Copies variables to the child process" {
             -||-> $n1 = "Bob" <-||- 
             -||-> $n2 = "Mary" <-||- 
             -||-> ${n 3} = "Bill" <-||- 
             -||-> $j =  -||-> Write-Output "Hi $n1! Hi ${n2}! Hi ${n 3}!" <-||-  <-||-  &
             -||-> Receive-Job $j -Wait | Should -BeExactly "Hi Bob! Hi Mary! Hi Bill!" <-||- 
        } <-||- 
         -||-> It 'Make sure that $PID from the parent process does not overwrite $PID in the child process' {
             -||-> $j =  -||-> Write-Output $pid <-||-  <-||-  &
             -||-> $cpid =  -||-> Receive-Job $j -Wait <-||-  <-||- 
             -||-> $pid | Should -Not -BeExactly $cpid <-||- 
        } <-||- 
         -||-> It 'Make sure that $global:PID from the parent process does not overwrite $global:PID in the child process' {
             -||-> $j =  -||-> Write-Output $global:pid <-||-  <-||-  &
             -||-> $cpid =  -||-> Receive-Job -Wait $j <-||-  <-||- 
             -||-> $pid | Should -Not -BeExactly $cpid <-||- 
        } <-||- 
         -||-> It "starts in the current directory" {
             -||-> $j =  -||-> Get-Location | Foreach-Object -MemberName Path <-||-  <-||-  &
             -||-> Receive-Job -Wait $j | Should -Be ( -||-> $pwd.Path <-||- ) <-||- 
        } <-||- 
         -||-> It "Test that output redirection is done in the background job" {
             -||-> $j =  -||-> Write-Output hello > $TESTDRIVE/hello.txt <-||-  <-||-  &
             -||-> Receive-Job -Wait $j | Should -BeNullOrEmpty <-||- 
             -||-> Get-Content $TESTDRIVE/hello.txt | Should -BeExactly "hello" <-||- 
        } <-||- 
         -||-> It "Test that error redirection is done in the background job" {
             -||-> $j =  -||-> Write-Error MyError 2> $TESTDRIVE/myerror.txt <-||-  <-||-  &
             -||-> Receive-Job -Wait $j | Should -BeNullOrEmpty <-||- 
             -||-> Get-Content -Raw $TESTDRIVE/myerror.txt | Should -Match "MyError" <-||- 
        } <-||- 
    } <-||- 
     -||-> Context "Backgrounding expressions" {
         -||-> AfterEach {
             -||-> Get-Job | Remove-Job -Force <-||- 
        } <-||- 
         -||-> It "handles backgrounding expressions" {
             -||-> $j =  -||-> 2+3 <-||-  <-||-  &
             -||-> Receive-Job $j -Wait | Should -Be 5 <-||- 
        } <-||- 
         -||-> It "handles backgrounding mixed expressions" {
             -||-> $j =  -||-> 1..10 | ForEach-Object -Begin { -||-> $s=0 <-||- } -Process { -||-> $s += $_ <-||- } -End { -||-> $s <-||- } <-||-  <-||-  &
             -||-> Receive-Job -Wait $j | Should -Be 55 <-||- 
        } <-||- 
    } <-||- 
} <-||- 


