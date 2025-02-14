




















 -||-> function Test-AzureIotDpsCertificateLifeCycle
{
	 -||-> $Location =  -||-> Get-Location "Microsoft.Devices" "Device Provisioning Service" <-||-  <-||-  
	 -||-> $IotDpsName =  -||-> getAssetName <-||-  <-||-  
	 -||-> $ResourceGroupName =  -||-> getAssetName <-||-  <-||-  
	 -||-> $TestOutputRoot = [System.AppDomain]::CurrentDomain.BaseDirectory <-||- ;

	
	 -||-> $certificatePath = "$TestOutputRoot\rootCertificate.cer" <-||- 
	 -||-> $verifyCertificatePath = "$TestOutputRoot\verifyCertificate.cer" <-||- 
	 -||-> $certificateSubject = "CN=TestCertificate" <-||- 
	 -||-> $certificateType = "Microsoft.Devices/provisioningServices/Certificates" <-||- 
	 -||-> $certificateName = "TestCertificate" <-||- 

	
	 -||-> $resourceGroup =  -||-> New-AzResourceGroup -Name $ResourceGroupName -Location $Location <-||-  <-||-  

	
	 -||-> $iotDps =  -||-> New-AzIoTDps -ResourceGroupName $ResourceGroupName -Name $IotDpsName -Location $Location <-||-  <-||- 
	 -||-> Assert-True {  -||-> $iotDps.Name -eq $IotDpsName <-||-  } <-||- 

	
	 -||-> New-CARootCert $certificateSubject $certificatePath <-||- 
	 -||-> $newCertificate =  -||-> Add-AzIoTDpsCertificate -ResourceGroupName $ResourceGroupName -Name $IotDpsName -CertificateName $certificateName -Path $certificatePath <-||-  <-||- 
	 -||-> Assert-True {  -||-> $newCertificate.Properties.Subject -eq $certificateSubject <-||-  } <-||- 
	 -||-> Assert-False {  -||-> $newCertificate.Properties.IsVerified <-||-  } <-||- 
	 -||-> Assert-True {  -||-> $newCertificate.Type -eq $certificateType <-||-  } <-||- 
	 -||-> Assert-True {  -||-> $newCertificate.CertificateName -eq $certificateName <-||-  } <-||- 

	
	 -||-> $certificates =  -||-> Get-AzIoTDpsCertificate -ResourceGroupName $ResourceGroupName -Name $IotDpsName <-||-  <-||- 
	 -||-> Assert-True {  -||-> $certificates.Count -gt 0 <-||- } <-||- 

	
	 -||-> $certificate =  -||-> Get-AzIoTDpsCertificate -ResourceGroupName $ResourceGroupName -Name $IotDpsName -CertificateName $certificateName <-||-  <-||- 
	 -||-> Assert-True {  -||-> $certificate.Properties.Subject -eq $certificateSubject <-||-  } <-||- 
	 -||-> Assert-False {  -||-> $certificate.Properties.IsVerified <-||-  } <-||- 
	 -||-> Assert-True {  -||-> $certificate.Type -eq $certificateType <-||-  } <-||- 
	 -||-> Assert-True {  -||-> $certificate.CertificateName -eq $certificateName <-||-  } <-||- 

	
	 -||-> $certificateWithVerificationCode =  -||-> Get-AzIoTDpsCertificate -ResourceGroupName $ResourceGroupName -Name $IotDpsName -CertificateName $certificateName | New-AzIotDpsCVC <-||-  <-||- 
	 -||-> Assert-True {  -||-> $certificateWithVerificationCode.Properties.Subject -eq $certificateSubject <-||-  } <-||- 
	 -||-> Assert-NotNull {  -||-> $certificateWithVerificationCode.Properties.VerificationCode <-||-  } <-||- 

	
	 -||-> New-CAVerificationCert $certificateWithVerificationCode.Properties.VerificationCode $certificateSubject $verifyCertificatePath <-||- 
	 -||-> $verifiedCertificate =  -||-> Get-AzIoTDpsCertificate -ResourceGroupName $ResourceGroupName -Name $IotDpsName -CertificateName $certificateName | Set-AzIotDpsCertificate -Path $verifyCertificatePath <-||-  <-||- 
	 -||-> Assert-True {  -||-> $verifiedCertificate.Properties.Subject -eq $certificateSubject <-||-  } <-||- 
	 -||-> Assert-True {  -||-> $verifiedCertificate.Properties.IsVerified <-||-  } <-||- 
	 -||-> Assert-True {  -||-> $verifiedCertificate.Type -eq $certificateType <-||-  } <-||- 
	 -||-> Assert-True {  -||-> $verifiedCertificate.CertificateName -eq $certificateName <-||-  } <-||- 

	
	 -||-> $result =  -||-> Get-AzIoTDpsCertificate -ResourceGroupName $ResourceGroupName -Name $IotDpsName -CertificateName $certificateName | Remove-AzIotDpsCertificate -PassThru <-||-  <-||- 
	 -||-> Assert-True {  -||-> $result <-||-  } <-||- 

	
	 -||-> Remove-AzResourceGroup -Name $ResourceGroupName -force <-||- 
} <-||- 



 -||-> function Get-CACertBySubjectName([string]$subjectName)
{
     -||-> $certificates =  -||-> gci -Recurse Cert:\LocalMachine\ |? {  -||-> $_.gettype().name -eq "X509Certificate2" <-||-  } <-||-  <-||- 
     -||-> $cert =  -||-> $certificates |? {  -||-> $_.subject -eq $subjectName -and $_.PSParentPath -eq "Microsoft.PowerShell.Security\Certificate::LocalMachine\My" <-||-  } <-||-  <-||- 
     -||-> if ( -||-> $NULL -eq $cert <-||- )
    {
        throw  -||-> ( -||-> "Unable to find certificate with subjectName {0}" -f $subjectName <-||- ) <-||- 
    } <-||- 

     -||-> write $cert[0] <-||- 
} <-||- 


 -||-> function New-CASelfsignedCertificate([string]$subjectName, [object]$signingCert, [bool]$isASigner=$true)
{
	
	 -||-> $selfSignedArgs = @{"-DnsName"= -||-> $subjectName <-||- ; 
		                "-CertStoreLocation"= -||-> "cert:\LocalMachine\My" <-||- ;
	                    "-NotAfter"= -||-> ( -||-> get-date <-||- ).AddDays(30) <-||- ; 
						} <-||- 

	 -||-> if ( -||-> $isASigner -eq $true <-||- )
	{
		 -||-> $selfSignedArgs += @{"-KeyUsage"= -||-> "CertSign" <-||- ; } <-||- 
		 -||-> $selfSignedArgs += @{"-TextExtension"=  -||-> @( -||-> ( -||-> "2.5.29.19={text}ca=TRUE&pathlength=12" <-||- ) <-||- ) <-||- ; } <-||- 
	}
	else
	{
		 -||-> $selfSignedArgs += @{"-TextExtension"=  -||-> @( -||-> "2.5.29.37={text}1.3.6.1.5.5.7.3.2,1.3.6.1.5.5.7.3.1", "2.5.29.19={text}ca=FALSE&pathlength=0" <-||- ) <-||-   } <-||- 
	} <-||- 

	 -||-> if ( -||-> $signingCert -ne $null <-||- )
	{
		 -||-> $selfSignedArgs += @{"-Signer"= -||-> $signingCert <-||-  } <-||- 
	} <-||- 

	 -||-> if ( -||-> $useEcc -eq $true <-||- )
	{
		 -||-> $selfSignedArgs += @{"-KeyAlgorithm"= -||-> "ECDSA_nistP256" <-||- ;
                      "-CurveExport"= -||-> "CurveName" <-||-  } <-||- 
	} <-||- 

	 -||-> write ( -||-> New-SelfSignedCertificate @selfSignedArgs <-||- ) <-||- 
} <-||- 


 -||-> function New-CARootCert([string]$subjectName, [string]$requestedFileName)
{
	 -||-> $certificate =  -||-> New-CASelfsignedCertificate $subjectName <-||-  <-||-  
	 -||-> Export-Certificate -cert $certificate -filePath $requestedFileName -Type Cert <-||- 
	 -||-> if ( -||-> -not ( -||-> Test-Path $requestedFileName <-||- ) <-||- )
    {
        throw  -||-> ( -||-> "Error: CERT file {0} doesn't exist" -f $requestedFileName <-||- ) <-||- 
    } <-||- 
} <-||- 


 -||-> function New-CAVerificationCert([string]$requestedSubjectName, [string]$_rootCertSubject, [string]$verifyRequestedFileName)
{
     -||-> $cnRequestedSubjectName = ( -||-> "CN={0}" -f $requestedSubjectName <-||- ) <-||- 
     -||-> $rootCACert =  -||-> Get-CACertBySubjectName $_rootCertSubject <-||-  <-||- 
	 -||-> $verifyCert =  -||-> New-CASelfsignedCertificate $cnRequestedSubjectName $rootCACert $false <-||-  <-||- 
	 -||-> Export-Certificate -cert $verifyCert -filePath $verifyRequestedFileName -Type Cert <-||- 
     -||-> if ( -||-> -not ( -||-> Test-Path $verifyRequestedFileName <-||- ) <-||- )
    {
        throw  -||-> ( -||-> "Error: CERT file {0} doesn't exist" -f $verifyRequestedFileName <-||- ) <-||- 
    } <-||- 

	
	 -||-> Get-ChildItem ( -||-> "Cert:\LocalMachine\My\{0}" -f $rootCACert.Thumbprint <-||- ) | Remove-Item <-||- 
	 -||-> Get-ChildItem ( -||-> "Cert:\LocalMachine\My\{0}" -f $verifyCert.Thumbprint <-||- ) | Remove-Item <-||- 
} <-||- 


