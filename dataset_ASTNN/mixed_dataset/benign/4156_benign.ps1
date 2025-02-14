




param (
    [Parameter(Mandatory = $true, 
    HelpMessage= "Source Storage account name.")]
    [ValidatePattern("^[a-z0-9`]{3,24}$")]
    [String]$srcStorageAccountName,

    [Parameter(Mandatory = $true, 
    HelpMessage= "Source Storage account key.")]
    [String]$srcStorageAccountKey,
    
    [Parameter(Mandatory = $true, 
    HelpMessage= "Destination Storage account name.")]
    [ValidatePattern("^[a-z0-9`]{3,24}$")]
    [String]$DestStorageAccountName,

    [Parameter(Mandatory = $true, 
    HelpMessage= "Destination Storage account key.")]
    [String]$DestStorageAccountKey,

    [Parameter(Mandatory = $false, 
    HelpMessage= "Input the full filePath of the AzCopy.exe, e.g.: C:\Program Files (x86)\Microsoft SDKs\Azure\AzCopy\AzCopy.exe")]
    [String]$AzCopyPath = "C:\Program Files (x86)\Microsoft SDKs\Azure\AzCopy\AzCopy.exe",

    [Parameter(Mandatory = $false, 
    HelpMessage='Sets the number of retries in an event of failure. Set to 0 for no retry, set -1 for infinite retry.')]
    [Int32]$RetryTimes = 3,

    [Parameter(Mandatory = $false, 
    ValueFromPipeline = $true, 
    HelpMessage='Used for resume operation. When provided, the script will copy containers that are alphabetically after $LastSuccessContainerName')]
    [String]$LastSuccessContainerName = $nullz
 )

  -||-> if(  -||-> ( -||-> Get-Item $AzCopyPath <-||- ).Exists <-||- )
 {

     -||-> $FileItemVersion = ( -||-> Get-Item $AzCopyPath <-||- ).VersionInfo <-||- 
     -||-> $FilePath = ( -||-> "{0}.{1}.{2}.{3}" -f  $FileItemVersion.FileMajorPart,  $FileItemVersion.FileMinorPart,  $FileItemVersion.FileBuildPart,  $FileItemVersion.FilePrivatePart <-||- ) <-||- 

    
     -||-> if( -||-> ( -||-> [version] $FilePath -lt "7.0.0.2" <-||- ) -and ( -||-> [version] $FilePath -ne "0.0.0.0" <-||- ) <-||- )
    {
         -||-> $AzCopyPath =  -||-> Read-Host "Version of AzCopy found at default install directory is of a lower, unsupported version. Please input the full filePath of the AzCopy.exe that is version 7.0.0.2 or higher, e.g.: C:\Program Files (x86)\Microsoft SDKs\Azure\AzCopy\AzCopy.exe" <-||-  <-||- 
    } <-||- 
 }
 elseIf(  -||-> ( -||-> Get-Item $AzCopyPath <-||- ).Exists -eq $false <-||- )
 {
     -||-> $AzCopyPath =  -||-> Read-Host "Input the full filePath of the AzCopy.exe, e.g.: C:\Program Files (x86)\Microsoft SDKs\Azure\AzCopy\AzCopy.exe" <-||-  <-||- 
 } <-||- 


 -||-> $Error.Clear() <-||- 
 -||-> $srcCtx =  -||-> New-AzStorageContext -StorageAccountName $srcStorageAccountName -StorageAccountKey $srcStorageAccountKey <-||-  <-||- 
 -||-> if ( -||-> $srcCtx -eq $null <-||- )
{
     -||-> Write-Error "Script could not create source Storage Context, possibly due to invalid StorageAccountName or StorageAccount Key terminating: $Error[0]" <-||- ;
    return;
} <-||- 
 -||-> $destCtx =  -||-> New-AzStorageContext -StorageAccountName $destStorageAccountName -StorageAccountKey $destStorageAccountKey <-||-  <-||- 
 -||-> if ( -||-> $destCtx -eq $null <-||- )
{
     -||-> Write-Error "Script could not create destination storage context, possibly due to invalid StorageAccountName or StorageAccount Key terminating: $Error[0]" <-||- ;
    return;
} <-||- 


 -||-> $Error.Clear() <-||- 
 -||-> $Containers =  -||-> Get-AzStorageContainer -MaxCount 1 -Context $srcCtx <-||-  <-||- 
 -||-> if ( -||-> $Error.Count -gt 0 <-||- )
{
     -||-> Write-Error "Script failed to connect to source Storage account, terminating: $Error[0]" <-||- ;
    return;
} <-||- 
 -||-> $Containers =  -||-> Get-AzStorageContainer -MaxCount 1 -Context $destCtx <-||-  <-||- 
 -||-> if ( -||-> $Error.Count -gt 0 <-||- )
{
     -||-> Write-Error "Script failed to connect to destination Storage account, terminating: $Error[0]" <-||- ;
    return;
} <-||- 


 -||-> if( -||-> ( -||-> Test-Path $AzCopyPath <-||- ) -eq $false <-||- )
{
     -||-> Write-Error "Script is terminating since the provided AzCopyPath does not exist: $AzCopyPath " <-||- ;
    return;
}
elseif( -||-> ( -||-> Get-Item $AzCopyPath <-||- ).BaseName -ne "AzCopy" <-||-  )
{
     -||-> Write-Error "Script is terminating since the provided AzCopyPath does not refer to the AzCopy exe: $AzCopyPath " <-||- ;
    return;
}
elseif( -||-> ( -||-> Get-Item $AzCopyPath <-||- ).BaseName -eq "AzCopy" <-||- )
{
     -||-> $FileItemVersion = ( -||-> Get-Item $AzCopyPath <-||- ).VersionInfo <-||- 
     -||-> $FilePath = ( -||-> "{0}.{1}.{2}.{3}" -f  $FileItemVersion.FileMajorPart,  $FileItemVersion.FileMinorPart,  $FileItemVersion.FileBuildPart,  $FileItemVersion.FilePrivatePart <-||- ) <-||- 

     -||-> if( -||-> [version] $FilePath -lt "7.0.0.2" <-||- )
    {
         -||-> $AzCopyPath =  -||-> Read-Host "Version of AzCopy found at provided path is of a lower, unsupported version. Please input the full filePath of the AzCopy.exe that is version 7.0.0.2 or higher, e.g.: C:\Program Files (x86)\Microsoft SDKs\Azure\AzCopy\AzCopy.exe" <-||-  <-||- 
    } <-||- 
} <-||- 

 -||-> $OutputLastSuccessContainer = $LastSuccessContainerName <-||- ;
 -||-> $HasReachedLastSuccessContainer = $false <-||- ;

 -||-> if ( -||-> $LastSuccessContainerName -eq $null -or $LastSuccessContainerName -eq "" <-||- )
{
     -||-> $HasReachedLastSuccessContainer = $true <-||- ;
} <-||- 


 -||-> $MaxReturn = 250 <-||- 
 -||-> $Token = $Null <-||- 

do{
    
     -||-> $retry = 1 <-||- 
     -||-> $Error.Clear() <-||- 
     -||-> $srcContainers =  -||-> Get-AzStorageContainer -MaxCount $MaxReturn -ContinuationToken $Token -Context $srcCtx <-||-  <-||- 

    
     -||-> while( -||-> ( -||-> $Error.Count -gt 0 <-||- ) -and ( -||-> $RetryTimes -eq -1 -or $retry -le $retryTimes <-||- ) <-||- )
    {
         -||-> Write-Host "Retry List containers $retry" <-||- 
         -||-> $Error.Clear() <-||- 
         -||-> $srcContainers =  -||-> Get-AzStorageContainer -MaxCount $MaxReturn -ContinuationToken $Token -Context $srcCtx <-||-  <-||- 
         -||-> $retry++ <-||- 
    } <-||- 

    
     -||-> if ( -||-> $Error.Count -gt 0 <-||- ){
         -||-> Write-Error "Terminating the script since listing source containers failed: $Error[0]" <-||- ;
         -||-> $CopyContainerFail = $true <-||- 
        break;
    } <-||- 
     -||-> $Token = $srcContainers[$srcContainers.Count -1].ContinuationToken <-||- ;

    
     -||-> $CopyContainerFail = $false <-||- 
     -||-> foreach ($container in  -||-> $srcContainers <-||- )
    {
         -||-> if ( -||-> !$HasReachedLastSuccessContainer <-||- )
        {
             -||-> if ( -||-> $container.Name -eq $LastSuccessContainerName <-||- )
            {
                 -||-> $HasReachedLastSuccessContainer = $true <-||- ;
            } <-||- 
             -||-> Write-Host "Skipping container copy: $( -||-> $container.Name <-||- )" <-||- 
            Continue;
        } <-||- 

         -||-> Write-Host "Start copying container: $( -||-> $container.Name <-||- )" <-||- 
         -||-> $retry = 1 <-||- 

        
         -||-> $destContainer = $destCtx.StorageAccount.CreateCloudBlobClient().GetContainerReference($container.Name) <-||- 
         -||-> $azCopyCmd = [string]::Format("""{0}"" /source:{1} /dest:{2} /sourcekey:""{3}"" /destkey:""{4}"" /snapshot /y /s /synccopy",$AzCopyPath, $container.CloudBlobContainer.Uri.AbsoluteUri, $destContainer.Uri.AbsoluteUri, $srcStorageAccountKey, $DestStorageAccountKey) <-||- 
    
        
         -||-> Write-Host "$azCopyCmd" <-||- 
         -||-> $result =  -||-> cmd /c $azCopyCmd <-||-  <-||- 
         -||-> foreach($s in  -||-> $result <-||- )
        {
             -||-> Write-Host $s <-||-  
        } <-||- 

        
         -||-> while( -||-> ( -||-> $LASTEXITCODE -ne 0 <-||- ) -and ( -||-> $RetryTimes -eq -1 -or $retry -le $retryTimes <-||- ) <-||- )
        {
             -||-> Write-Host "Retry $retry : $azCopyCmd" <-||- 
             -||-> $result =  -||-> cmd /c $azCopyCmd <-||-  <-||- 
             -||-> foreach($s in  -||-> $result <-||- )
            {
                 -||-> Write-Host $s <-||-  
            } <-||- 
             -||-> $retry++ <-||- 
        } <-||- 

        
         -||-> if ( -||-> $LASTEXITCODE -ne 0 <-||- ){
             -||-> Write-Error "Container copy failed: $( -||-> $container.Name <-||- )" <-||- ;
             -||-> $CopyContainerFail = $true <-||- 
            break;
        }
        else
        {
             -||-> Write-Host "Finished copying container: $( -||-> $container.Name <-||- )" <-||- 
             -||-> Write-Host "" <-||- 
             -||-> $OutputLastSuccessContainer = $container.Name <-||- 
        } <-||- 
    } <-||- 
     -||-> if( -||-> $CopyContainerFail <-||- )
    {
        break;
    } <-||- 
}
While ( -||-> $Token -ne $Null <-||- )


 -||-> if ( -||-> $CopyContainerFail <-||- )
{
     -||-> if( -||-> ( -||-> $OutputLastSuccessContainer -ne $null <-||- ) -and ( -||-> $OutputLastSuccessContainer -ne "" <-||- ) <-||- )
    {
         -||-> Write-Warning "To resume, rerun the script and append the parameter: ""-LastSuccessContainer $OutputLastSuccessContainer""" <-||- 
        return  -||-> $OutputLastSuccessContainer <-||- 
    }
    else
    {
         -||-> Write-Warning "To resume, rerun the script." <-||- 
        return  -||-> $null <-||- 
    } <-||- 
}
else
{
     -||-> Write-Host "All Containers copied successfully." <-||- 
    return  -||-> "" <-||- 
} <-||- 


