 -||-> function Get-PublishLocation
{
    [CmdletBinding()]
    Param
    (
        [Parameter()]
        [String]
        $Location
    )

     -||-> $PublishLocation = $null <-||- 

     -||-> if( -||-> $Location <-||- )
    {
        
         -||-> if( -||-> Microsoft.PowerShell.Management\Test-Path -Path $Location <-||- )
        {
             -||-> $PublishLocation = $Location <-||- 
        }
        else
        {
             -||-> $tempPublishLocation = $null <-||- 

             -||-> if( -||-> $Location.EndsWith('/api/v2', [System.StringComparison]::OrdinalIgnoreCase) <-||- )
            {
                 -||-> $tempPublishLocation = $Location + '/package/' <-||- 
            }
            elseif( -||-> $Location.EndsWith('/api/v2/', [System.StringComparison]::OrdinalIgnoreCase) <-||- )
            {
                 -||-> $tempPublishLocation = $Location + 'package/' <-||- 
            } <-||- 

             -||-> if( -||-> $tempPublishLocation <-||- )
            {
                 -||-> $PublishLocation = $tempPublishLocation <-||- 
            } <-||- 
        } <-||- 
    } <-||- 
    return  -||-> $PublishLocation <-||- 
} <-||- 

