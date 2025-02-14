











 -||-> Set-StrictMode -Version 'Latest' <-||- 

 -||-> & ( -||-> Join-Path -Path $PSScriptRoot -ChildPath 'Initialize-CarbonTest.ps1' -Resolve <-||- ) <-||- 

 -||-> $tempDir = $null <-||- 
 -||-> $privateKeyPassword = ( -||-> New-Credential -User 'doesn''t matter' -Password 'fubarsnafu' <-||- ).Password <-||- 
 -||-> $subject = $null <-||- 
 -||-> $publicKeyPath = $null <-||- 
 -||-> $privateKeyPath = $null <-||- 

 -||-> Describe 'New-RsaKeyPair' {

     -||-> function Assert-KeyProperty
    {
        param(
            $Length = 4096,
            [datetime]
            $ValidTo,
            $Algorithm = 'sha512RSA'
        )

         -||-> Set-StrictMode -Version 'Latest' <-||- 

         -||-> if(  -||-> -not $ValidTo <-||-  )
        {
             -||-> $ValidTo = ( -||-> Get-Date <-||- ).AddDays( [Math]::Floor(( -||-> [DateTime]::MaxValue - [DateTime]::UtcNow <-||- ).TotalDays) ) <-||- 
        } <-||- 

         -||-> $cert =  -||-> Get-Certificate -Path $publicKeyPath <-||-  <-||- 
        
         -||-> [timespan]$span = $ValidTo - $cert.NotAfter <-||- 
         -||-> $span.TotalDays | Should BeGreaterThan ( -||-> -2 <-||- ) <-||- 
         -||-> $span.TotalDays | Should BeLessThan 2 <-||- 
         -||-> $cert.Subject | Should Be $subject <-||- 
         -||-> $cert.PublicKey.Key.KeySize | Should Be $Length <-||- 
         -||-> $cert.PublicKey.Key.KeyExchangeAlgorithm | Should Be 'RSA-PKCS1-KeyEx' <-||- 
         -||-> $cert.SignatureAlgorithm.FriendlyName | Should Be $Algorithm <-||- 
         -||-> $keyUsage =  -||-> $cert.Extensions | Where-Object {  -||-> $_ -is [Security.Cryptography.X509Certificates.X509KeyUsageExtension] <-||-  } <-||-  <-||- 
         -||-> $keyUsage | Should Not BeNullOrEmpty <-||- 
         -||-> $keyUsage.KeyUsages.HasFlag([Security.Cryptography.X509Certificates.X509KeyUsageFlags]::DataEncipherment) | Should Be $true <-||- 
         -||-> $keyUsage.KeyUsages.HasFlag([Security.Cryptography.X509Certificates.X509KeyUsageFlags]::KeyEncipherment) | Should Be $true <-||- 
         -||-> $enhancedKeyUsage =  -||-> $cert.Extensions | Where-Object {  -||-> $_ -is [Security.Cryptography.X509Certificates.X509EnhancedKeyUsageExtension] <-||-  } <-||-  <-||- 
         -||-> $enhancedKeyUsage | Should Not BeNullOrEmpty <-||- 

        
         -||-> $osVersion = ( -||-> Get-WmiObject -Class 'Win32_OperatingSystem' <-||- ).Version <-||- 
         -||-> if(  -||-> $osVersion -notmatch '6.1\b' <-||-  )
        {
             -||-> $usage =  -||-> $enhancedKeyUsage.EnhancedKeyUsages | Where-Object {  -||-> $_.FriendlyName -eq 'Document Encryption' <-||-  } <-||-  <-||- 
             -||-> $usage | Should Not BeNullOrEmpty <-||- 
        } <-||- 
    } <-||- 

     -||-> BeforeEach {
         -||-> $tempDir =  -||-> New-TempDirectory -Prefix $PSCommandPath <-||-  <-||- 
         -||-> $Global:Error.Clear() <-||- 

         -||-> $subject = 'CN={0}' -f [Guid]::NewGuid() <-||- 
         -||-> $publicKeyPath =  -||-> Join-Path -Path $tempDir -ChildPath 'public.cer' <-||-  <-||- 
         -||-> $privateKeyPath =  -||-> Join-Path -Path $tempDir -ChildPath 'private.pfx' <-||-  <-||- 
    } <-||- 

     -||-> AfterEach {
         -||-> Remove-Item -Path $tempDir -Recurse <-||- 
    } <-||- 

     -||-> It 'should generate a public/private key pair' {

         -||-> $output =  -||-> New-RsaKeyPair -Subject $subject -PublicKeyFile $publicKeyPath -PrivateKeyFile $privateKeyPath -Password $privateKeyPassword <-||-  <-||- 
         -||-> $output | Should Not BeNullOrEmpty <-||- 
         -||-> $output.Count | Should Be 2 <-||- 

         -||-> $publicKeyPath | Should Exist <-||- 
         -||-> $output[0].FullName | Should Be $publicKeyPath <-||- 

         -||-> $privateKeyPath | Should Exist <-||- 
         -||-> $output[1].FullName | Should Be $privateKeyPath <-||- 

         -||-> Assert-KeyProperty <-||- 

        
         -||-> $secret = [IO.Path]::GetRandomFileName() <-||- 
         -||-> $protectedSecret =  -||-> Protect-String -String $secret -Certificate $publicKeyPath <-||-  <-||- 
         -||-> $decryptedSecret =  -||-> Unprotect-String -ProtectedString $protectedSecret -PrivateKeyPath $privateKeyPath -Password $privateKeyPassword <-||-  <-||- 
         -||-> $decryptedSecret | Should Be $secret <-||- 

         -||-> $publicKey =  -||-> Get-Certificate -Path $publicKeyPath <-||-  <-||- 
         -||-> $publicKey | Should Not BeNullOrEmpty <-||- 

        
         -||-> $configData = @{
            AllNodes =  -||-> @(
                 -||-> @{
                    NodeName =  -||-> 'localhost' <-||- ;
                    CertificateFile =  -||-> $PublicKeyPath <-||- ;
                    Thumbprint =  -||-> $publicKey.Thumbprint <-||- ;
                } <-||- 
            ) <-||- 
        } <-||- 

        configuration TestEncryption
        {
             -||-> Set-StrictMode -Off <-||- 

            Import-DscResource -ModuleName 'PSDesiredStateConfiguration'

            node $AllNodes.NodeName
            {
                User 'CreateDummyUser'
                {
                    UserName =  -||-> 'fubarsnafu' <-||- ;
                    Password =  -||-> ( -||-> New-Credential -UserName 'fubarsnafu' -Password 'Password1' <-||- ) <-||- 
                }
            }
        }

         -||-> & TestEncryption -ConfigurationData $configData -OutputPath $tempDir <-||- 

        
         -||-> $dscRegKey = 'HKLM:\SOFTWARE\Microsoft\PowerShell\3\DSC' <-||- 
         -||-> $dscRegKeyErrorMessages =  -||-> $Global:Error |
                                  Where-Object {  -||-> $_ -is [System.Management.Automation.ErrorRecord] <-||-  } |
                                  Where-Object {  -||-> $_.Exception.Message -like ( -||-> '*Cannot find path ''{0}''*' -f $dscRegKey <-||- ) <-||-  } <-||-  <-||- 

         -||-> foreach ($error in  -||-> $dscRegKeyErrorMessages <-||- )
        {
             -||-> $Global:Error.Remove($error) <-||- 
        } <-||- 

         -||-> $Global:Error.Count | Should Be 0 <-||- 
         -||-> Join-Path -Path $tempDir -ChildPath 'localhost.mof' | Should Not Contain 'Password1' <-||- 
    } <-||- 

     -||-> if(  -||-> Get-Command -Name 'Protect-CmsMessage' -ErrorAction Ignore <-||-  )
    {
        
         -||-> It 'should generate key pairs that can be used by CMS cmdlets' {
             -||-> $output =  -||-> New-RsaKeyPair -Subject 'CN=to@example.com' -PublicKeyFile $publicKeyPath -PrivateKeyFile $privateKeyPath -Password $privateKeyPassword <-||-  <-||- 

             -||-> $cert =  -||-> Install-Certificate -Path $privateKeyPath -StoreLocation CurrentUser -StoreName My -Password $privateKeyPassword <-||-  <-||- 

             -||-> try
            {
                 -||-> $message = 'fubarsnafu' <-||- 
                 -||-> $protectedMessage =  -||-> Protect-CmsMessage -To $publicKeyPath -Content $message <-||-  <-||- 
                 -||-> Unprotect-CmsMessage -Content $protectedMessage | Should Be $message <-||- 
            }
            finally
            {
                 -||-> Uninstall-Certificate -Thumbprint $cert.Thumbprint -StoreLocation CurrentUser -StoreName My <-||- 
            } <-||- 
        } <-||- 
    } <-||- 


     -||-> It 'should generate key with custom configuration' {
         -||-> $validTo = [datetime]::Now.AddDays(30) <-||- 
         -||-> $length = 2048 <-||- 

         -||-> $output =  -||-> New-RsaKeyPair -Subject $subject `
                                 -PublicKeyFile $publicKeyPath `
                                 -PrivateKeyFile $privateKeyPath `
                                 -Password $privateKeyPassword `
                                 -ValidTo $validTo `
                                 -Length $length `
                                 -Algorithm sha1 <-||-  <-||- 

         -||-> Assert-KeyProperty -Length $length -ValidTo $validTo -Algorithm 'sha1RSA' <-||- 

    } <-||- 

     -||-> It 'should reject subjects that don''t begin with CN=' {
         -||-> {  -||-> New-RsaKeyPair -Subject 'fubar' -PublicKeyFile $publicKeyPath -PrivateKeyFile $privateKeyPath -Password $privateKeyPassword <-||-  } | Should Throw <-||- 
         -||-> $Global:Error[0] | Should Match 'does not match' <-||- 
    } <-||- 

     -||-> It 'should not protect private key' {
         -||-> $output =  -||-> New-RsaKeyPair -Subject $subject -PublicKeyFile $publicKeyPath -PrivateKeyFile $privateKeyPath -Password $null <-||-  <-||- 
         -||-> $output.Count | Should Be 2 <-||- 

         -||-> $privateKey =  -||-> Get-Certificate -Path $privateKeyPath <-||-  <-||- 
         -||-> $privateKey | Should Not BeNullOrEmpty <-||- 

         -||-> $secret = [IO.Path]::GetRandomFileName() <-||- 
         -||-> $protectedSecret =  -||-> Protect-String -String $secret -PublicKeyPath $publicKeyPath <-||-  <-||- 
         -||-> Unprotect-String -ProtectedString $protectedSecret -PrivateKeyPath $privateKeyPath | Should Be $secret <-||- 
    } <-||- 
} <-||- 

