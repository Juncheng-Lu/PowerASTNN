 -||-> function New-SelfSignedCertificateEx
{
	[CmdletBinding(DefaultParameterSetName = 'Store')]
	param
	(
		[Parameter(Mandatory, Position = 0)]
		[string]$Subject,
		
		[Parameter(Position = 1)]
		[DateTime]$NotBefore = [DateTime]::Now.AddDays(-1),
		
		[Parameter(Position = 2)]
		[DateTime]$NotAfter = $NotBefore.AddDays(365),
		
		[string]$SerialNumber,
		
		[Alias('CSP')]
		[string]$ProviderName = 'Microsoft Enhanced Cryptographic Provider v1.0',
		
		[string]$AlgorithmName = 'RSA',
		
		[int]$KeyLength = 2048,
		
		[ValidateSet('Exchange', 'Signature')]
		[string]$KeySpec = 'Exchange',
		
		[Alias('EKU')]
		[Security.Cryptography.Oid[]]$EnhancedKeyUsage,
		
		[Alias('KU')]
		[Security.Cryptography.X509Certificates.X509KeyUsageFlags]$KeyUsage,
		
		[Alias('SAN')]
		[String[]]$SubjectAlternativeName,
		
		[bool]$IsCA,
		
		[int]$PathLength = -1,
		
		[Security.Cryptography.X509Certificates.X509ExtensionCollection]$CustomExtension,
		
		[ValidateSet('MD5', 'SHA1', 'SHA256', 'SHA384', 'SHA512')]
		[string]$SignatureAlgorithm = 'SHA1',
		
		[string]$FriendlyName,
		
		[Parameter(ParameterSetName = 'Store')]
		[Security.Cryptography.X509Certificates.StoreLocation]$StoreLocation = 'CurrentUser',
		
		[Parameter(ParameterSetName = 'Store')]
		[Security.Cryptography.X509Certificates.StoreName]$StoreName = 'My',
		
		[Parameter(Mandatory = $true, ParameterSetName = 'File')]
		[Alias('OutFile', 'OutPath', 'Out')]
		[IO.FileInfo]$Path,
		
		[Parameter(Mandatory = $true, ParameterSetName = 'File')]
		[Security.SecureString]$Password,
		
		[switch]$AllowSMIME,
		
		[switch]$Exportable,
		
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[switch]$PassThru
	)
	
	 -||-> $ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop <-||- ;
	
	
	 -||-> if ( -||-> [Environment]::OSVersion.Version.Major -lt 6 <-||- )
	{
		throw  -||-> ( -||-> New-Object NotSupportedException -ArgumentList 'Windows XP and Windows Server 2003 are not supported!' <-||- ) <-||- ;
	} <-||- 
	
	
	
	
	 -||-> New-Variable -Name UserContext -Value 0x1 -Option Constant <-||- ;
	 -||-> New-Variable -Name MachineContext -Value 0x2 -Option Constant <-||- ;
	
	
	
	 -||-> New-Variable -Name Base64Header -Value 0x0 -Option Constant <-||- ;
	 -||-> New-Variable -Name Base64 -Value 0x1 -Option Constant <-||- ;
	 -||-> New-Variable -Name Binary -Value 0x3 -Option Constant <-||- ;
	 -||-> New-Variable -Name Base64RequestHeader -Value 0x4 -Option Constant <-||- ;
	
	
	
	 -||-> New-Variable -Name OtherName -Value 0x1 -Option Constant <-||- ;
	 -||-> New-Variable -Name RFC822Name -Value 0x2 -Option Constant <-||- ;
	 -||-> New-Variable -Name DNSName -Value 0x3 -Option Constant <-||- ;
	 -||-> New-Variable -Name DirectoryName -Value 0x5 -Option Constant <-||- ;
	 -||-> New-Variable -Name URL -Value 0x7 -Option Constant <-||- ;
	 -||-> New-Variable -Name IPAddress -Value 0x8 -Option Constant <-||- ;
	 -||-> New-Variable -Name RegisteredID -Value 0x9 -Option Constant <-||- ;
	 -||-> New-Variable -Name Guid -Value 0xa -Option Constant <-||- ;
	 -||-> New-Variable -Name UPN -Value 0xb -Option Constant <-||- ;
	
	
	
	 -||-> New-Variable -Name AllowNone -Value 0x0 -Option Constant <-||- ;
	 -||-> New-Variable -Name AllowNoOutstandingRequest -Value 0x1 -Option Constant <-||- ;
	 -||-> New-Variable -Name AllowUntrustedCertificate -Value 0x2 -Option Constant <-||- ;
	 -||-> New-Variable -Name AllowUntrustedRoot -Value 0x4 -Option Constant <-||- ;
	
	
	
	 -||-> New-Variable -Name PFXExportEEOnly -Value 0x0 -Option Constant <-||- ;
	 -||-> New-Variable -Name PFXExportChainNoRoot -Value 0x1 -Option Constant <-||- ;
	 -||-> New-Variable -Name PFXExportChainWithRoot -Value 0x2 -Option Constant <-||- ;
	
	
	
	
	
	
	 -||-> $subjectDN =  -||-> New-Object -ComObject X509Enrollment.CX500DistinguishedName <-||-  <-||- ;
	 -||-> $subjectDN.Encode($Subject, 0x0) <-||- ;
	
	
	
	
	
	 -||-> $extensionsToAdd = @() <-||- ;
	
	
	 -||-> if ( -||-> $EnhancedKeyUsage <-||- )
	{
		 -||-> $oIDs =  -||-> New-Object -ComObject X509Enrollment.CObjectIDs <-||-  <-||- ;
		 -||-> $EnhancedKeyUsage | ForEach-Object {
			 -||-> $oID =  -||-> New-Object -ComObject X509Enrollment.CObjectID <-||-  <-||- ;
			 -||-> $oID.InitializeFromValue($_.Value) <-||- ;
			
			
			 -||-> $oIDs.Add($oID) <-||- ;
		} <-||- 
		
		
		 -||-> $eku =  -||-> New-Object -ComObject X509Enrollment.CX509ExtensionEnhancedKeyUsage <-||-  <-||- ;
		 -||-> $eku.InitializeEncode($oIDs) <-||- ;
		 -||-> $extensionsToAdd += 'EKU' <-||- ;
	} <-||- 
	
	
	
	 -||-> if ( -||-> $KeyUsage -ne $null <-||- )
	{
		 -||-> $ku =  -||-> New-Object -ComObject X509Enrollment.CX509ExtensionKeyUsage <-||-  <-||- ;
		 -||-> $ku.InitializeEncode([int]$KeyUsage) <-||- ;
		 -||-> $ku.Critical = $true <-||- ;
		 -||-> $extensionsToAdd += 'KU' <-||- ;
	} <-||- 
	
	
	
	 -||-> if ( -||-> $PSBoundParameters.Keys.Contains('IsCA') <-||- )
	{
		
		 -||-> $basicConstraints =  -||-> New-Object -ComObject X509Enrollment.CX509ExtensionBasicConstraints <-||-  <-||- ;
		 -||-> if ( -||-> !$IsCA <-||- )
		{
			 -||-> $PathLength = -1 <-||- ;
		} <-||- 
		 -||-> $basicConstraints.InitializeEncode($IsCA, $PathLength) <-||- ;
		 -||-> $basicConstraints.Critical = $IsCA <-||- ;
		 -||-> $extensionsToAdd += 'BasicConstraints' <-||- ;
	} <-||- 
	
	
	
	 -||-> if ( -||-> $SubjectAlternativeName <-||- )
	{
		 -||-> $san =  -||-> New-Object -ComObject X509Enrollment.CX509ExtensionAlternativeNames <-||-  <-||- ;
		 -||-> $names =  -||-> New-Object -ComObject X509Enrollment.CAlternativeNames <-||-  <-||- ;
		 -||-> foreach ($altName in  -||-> $SubjectAlternativeName <-||- )
		{
			 -||-> $name =  -||-> New-Object -ComObject X509Enrollment.CAlternativeName <-||-  <-||- ;
			 -||-> if ( -||-> $altName.Contains('@') <-||- )
			{
				 -||-> $name.InitializeFromString($RFC822Name, $altName) <-||- ;
			}
			else
			{
				 -||-> try
				{
					 -||-> $bytes = [Net.IPAddress]::Parse($altName).GetAddressBytes() <-||- ;
					 -||-> $name.InitializeFromRawData($IPAddress, $Base64, [Convert]::ToBase64String($bytes)) <-||- ;
				}
				catch
				{
					 -||-> try
					{
						 -||-> $bytes = [Guid]::Parse($altName).ToByteArray() <-||- ;
						 -||-> $name.InitializeFromRawData($Guid, $Base64, [Convert]::ToBase64String($bytes)) <-||- ;
					}
					catch
					{
						 -||-> try
						{
							 -||-> $bytes = ( -||-> [Security.Cryptography.X509Certificates.X500DistinguishedName]$altName <-||- ).RawData <-||- ;
							 -||-> $name.InitializeFromRawData($DirectoryName, $Base64, [Convert]::ToBase64String($bytes)) <-||- ;
						}
						catch
						{
							 -||-> $name.InitializeFromString($DNSName, $altName) <-||- ;
						} <-||- 
					} <-||- 
				} <-||- 
			} <-||- 
			 -||-> $names.Add($name) <-||- ;
		} <-||- 
		 -||-> $san.InitializeEncode($names) <-||- ;
		 -||-> $extensionsToAdd += 'SAN' <-||- ;
	} <-||- 
	
	
	
	 -||-> if ( -||-> $CustomExtension <-||- )
	{
		 -||-> $count = 0 <-||- ;
		 -||-> foreach ($ext in  -||-> $CustomExtension <-||- )
		{
			
			 -||-> $extension =  -||-> New-Object -ComObject X509Enrollment.CX509Extension <-||-  <-||- ;
			 -||-> $extensionOID =  -||-> New-Object -ComObject X509Enrollment.CObjectId <-||-  <-||- ;
			 -||-> $extensionOID.InitializeFromValue($ext.Oid.Value) <-||- ;
			 -||-> $extensionValue = [Convert]::ToBase64String($ext.RawData) <-||- ;
			 -||-> $extension.Initialize($extensionOID, $Base64, $extensionValue) <-||- ;
			 -||-> $extension.Critical = $ext.Critical <-||- ;
			 -||-> New-Variable -Name ( -||-> 'ext' + $count <-||- ) -Value $extension <-||- ;
			 -||-> $extensionsToAdd += ( -||-> 'ext' + $count <-||- ) <-||- ;
			 -||-> $count++ <-||- ;
		} <-||- 
	} <-||- 
	
	
	
	
	
	
	 -||-> $privateKey =  -||-> New-Object -ComObject X509Enrollment.CX509PrivateKey <-||-  <-||- ;
	 -||-> $privateKey.ProviderName = $ProviderName <-||- ;
	 -||-> $algorithmID =  -||-> New-Object -ComObject X509Enrollment.CObjectId <-||-  <-||- ;
	 -||-> $algorithmID.InitializeFromValue(( -||-> [Security.Cryptography.Oid]$AlgorithmName <-||- ).Value) <-||- ;
	 -||-> $privateKey.Algorithm = $algorithmID <-||- ;
	
	
	 -||-> $privateKey.KeySpec = switch ( -||-> $KeySpec <-||- ) { 'Exchange' {  -||-> 1 <-||-  }; 'Signature' {  -||-> 2 <-||-  } } <-||- 
	 -||-> $privateKey.Length = $KeyLength <-||- ;
	
	
	switch ( -||-> $PSCmdlet.ParameterSetName <-||- )
	{
		'Store'
		{
			 -||-> $privateKey.MachineContext =  -||-> if ( -||-> $StoreLocation -eq 'LocalMachine' <-||- ) {  -||-> $true <-||-  }
			else {  -||-> $false <-||-  } <-||-  <-||- 
		}
		'File'
		{
			 -||-> $privateKey.MachineContext = $false <-||- ;
		}
	}
	
	 -||-> $privateKey.ExportPolicy =  -||-> if ( -||-> $Exportable <-||- ) {  -||-> 1 <-||-  }
	else {  -||-> 0 <-||-  } <-||-  <-||- 
	 -||-> $privateKey.Create() <-||- ;
	
	
	
	
	
	 -||-> $cert =  -||-> New-Object -ComObject X509Enrollment.CX509CertificateRequestCertificate <-||-  <-||- ;
	
	
	 -||-> if ( -||-> $privateKey.MachineContext <-||- )
	{
		 -||-> $cert.InitializeFromPrivateKey($MachineContext, $privateKey, '') <-||- ;
	}
	else
	{
		 -||-> $cert.InitializeFromPrivateKey($UserContext, $privateKey, '') <-||- ;
	} <-||- 
	
	 -||-> $cert.Subject = $subjectDN <-||- ;
	 -||-> $cert.Issuer = $cert.Subject <-||- ;
	 -||-> $cert.NotBefore = $NotBefore <-||- ;
	 -||-> $cert.NotAfter = $NotAfter <-||- ;
	
	
	 -||-> foreach ($item in  -||-> $extensionsToAdd <-||- )
	{
		 -||-> $cert.X509Extensions.Add(( -||-> Get-Variable -Name $item -ValueOnly <-||- )) <-||- ;
	} <-||- 
	
	
	 -||-> if ( -||-> ![string]::IsNullOrEmpty($SerialNumber) <-||- )
	{
		 -||-> if ( -||-> $SerialNumber -match '[^0-9a-fA-F]' <-||- )
		{
			throw  -||-> 'Invalid serial number specified.' <-||- ;
		} <-||- 
		
		 -||-> if ( -||-> $SerialNumber.Length % 2 <-||- )
		{
			 -||-> $SerialNumber = '0' + $SerialNumber <-||- ;
		} <-||- 
		
		 -||-> $bytes =  -||-> $SerialNumber -split '(.{2})' | Where-Object {  -||-> $_ <-||-  } | ForEach-Object {  -||-> [Convert]::ToByte($_, 16) <-||-  } <-||-  <-||- 
		 -||-> $byteString = [Convert]::ToBase64String($bytes) <-||- ;
		 -||-> $cert.SerialNumber.InvokeSet($byteString, 1) <-||- ;
	} <-||- 
	
	 -||-> if ( -||-> $AllowSMIME <-||- )
	{
		 -||-> $cert.SmimeCapabilities = $true <-||- ;
	} <-||- 
	
	 -||-> $signatureOID =  -||-> New-Object -ComObject X509Enrollment.CObjectId <-||-  <-||- ;
	 -||-> $signatureOID.InitializeFromValue(( -||-> [Security.Cryptography.Oid]$SignatureAlgorithm <-||- ).Value) <-||- ;
	 -||-> $cert.SignatureInformation.HashAlgorithm = $signatureOID <-||- ;
	
	
	
	 -||-> $cert.Encode() <-||- ;
	
	
	
	 -||-> $request =  -||-> New-Object -ComObject X509Enrollment.CX509enrollment <-||-  <-||- ;
	 -||-> $request.InitializeFromRequest($cert) <-||- ;
	 -||-> $request.CertificateFriendlyName = $FriendlyName <-||- ;
	 -||-> $endCert = $request.CreateRequest($Base64) <-||- ;
	 -||-> $request.InstallResponse($AllowUntrustedCertificate, $endCert, $Base64, '') <-||- ;
	
	
	
	 -||-> if ( -||-> $PSCmdlet.ParameterSetName.Equals('File') <-||- )
	{
		 -||-> $PFXString = $request.CreatePFX(
			[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)),
			$PFXExportEEOnly,
			$Base64
		) <-||- 
		 -||-> Set-Content -Path $Path -Value ( -||-> [Convert]::FromBase64String($PFXString) <-||- ) -Encoding Byte <-||- ;
	} <-||- 
	
	
	 -||-> if ( -||-> $PassThru.IsPresent <-||- )
	{
		 -||-> @( -||-> Get-ChildItem -Path "Cert:\$StoreLocation\$StoreName" <-||- ).where({  -||-> $_.Subject -match $Subject <-||-  }) <-||- 
	} <-||- 
	
	 -||-> $ErrorActionPreference = [System.Management.Automation.ActionPreference]::Continue <-||- ;
} <-||- 

