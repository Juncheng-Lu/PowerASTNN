

 -||-> if ( -||-> Get-Command logparser.exe <-||- ) {
     -||-> $lpquery = @"
    SELECT
        COUNT(ProcessName) as ct,
        ProcessName
    FROM
        *ProcsWMI.tsv
    GROUP BY
        ProcessName
    ORDER BY
        ct ASC
"@ <-||- 

     -||-> & logparser -stats:off -i:csv -dtlines:0 -fixedsep:on -rtp:-1 "$lpquery" <-||- 

} else {
     -||-> $ScriptName = [System.IO.Path]::GetFileName($MyInvocation.ScriptName) <-||- 
     -||-> "${ScriptName} requires logparser.exe in the path." <-||- 
} <-||- 


