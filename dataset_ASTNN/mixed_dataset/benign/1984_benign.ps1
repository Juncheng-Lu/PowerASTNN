

 -||-> if ( -||-> Get-Command logparser.exe <-||- ) {
     -||-> $lpquery = @"
    SELECT count (
        ComputerStatus, 
        CriticallyFailedDetections, 
        PendingFullScan, 
        PendingManualSteps, 
        PendingOfflineScan, 
        PendingReboot, 
        RecentlyCleanedDetections, 
        SchemaVersion) AS cnt,
        ComputerStatus, 
        CriticallyFailedDetections, 
        PendingFullScan, 
        PendingManualSteps, 
        PendingOfflineScan, 
        PendingReboot, 
        RecentlyCleanedDetections, 
        SchemaVersion
    FROM
        *AMInfectionStatus.tsv
    GROUP BY
        ComputerStatus, 
        CriticallyFailedDetections, 
        PendingFullScan, 
        PendingManualSteps, 
        PendingOfflineScan, 
        PendingReboot, 
        RecentlyCleanedDetections, 
        SchemaVersion
    ORDER BY
        CNT ASC
"@ <-||- 

     -||-> & logparser -stats:off -i:csv -dtlines:0 -fixedsep:on -rtp:-1 "$lpquery" <-||- 

} else {
     -||-> $ScriptName = [System.IO.Path]::GetFileName($MyInvocation.ScriptName) <-||- 
     -||-> "${ScriptName} requires logparser.exe in the path." <-||- 
} <-||- 


