param(
	[string]$Version,
	[string]$Path,
	[switch]$Force,
	$Update,
	[switch]$Uninstall
)





 -||-> $Configs = @{
	Url =  -||-> "http://netcologne.dl.sourceforge.net/project/keepass/KeePass%202.x/2.27/KeePass-2.27-Setup.exe" <-||- 
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
                     -||-> Start-Process -FilePath $( -||-> Join-Path $_.Path $_.Filename <-||- ) -ArgumentList "/VERYSILENT /NORESTART" -Wait <-||- 
                } <-||- 
                		
                
                
                

                 -||-> $Executable = "C:\Program Files (x86)\KeePass Password Safe 2\KeePass.exe" <-||- ; -||-> if( -||-> Test-Path $Executable <-||- ){ -||-> Set-Content -Path ( -||-> Join-Path $PSbin.Path "KeePass.bat" <-||- ) -Value "@echo off`nstart `"`" `"$Executable`" %*" <-||- } <-||- 
                                
                
                
                

                 -||-> $_.Downloads | ForEach-Object{
                     -||-> Remove-Item $( -||-> Join-Path $_.Path $_.Filename <-||- ) <-||- 
                } <-||- 
                		
                
                
                
                		
                 -||-> if( -||-> $Update <-||- ){ -||-> $_.Result = "AppUpdated" <-||- ; -||-> $_ <-||- 
                }else{ -||-> $_.Result = "AppInstalled" <-||- ; -||-> $_ <-||- } <-||- 
            		
            
            
            
            		
            }else{
            	
                 -||-> $_.Result = "ConditionExclusion" <-||- ; -||-> $_ <-||- 
            } <-||- 

        
        
        
        	
        }else{

             -||-> if( -||-> Test-Path ( -||-> Join-Path $PSbin.Path "KeePass.bat" <-||- ) <-||- ){ -||-> Remove-Item ( -||-> Join-Path $PSbin.Path "KeePass.bat" <-||- ) <-||- } <-||- 
            
             -||-> $Executable = "C:\Program Files (x86)\KeePass Password Safe 2\unins000.exe" <-||- ;  -||-> if( -||-> Test-Path $Executable <-||- ){ -||-> Start-Process -FilePath $Executable -ArgumentList "/VERYSILENT /NORESTART" -Wait <-||- } <-||- 
            
             -||-> $_.Result = "AppUninstalled" <-||- ; -||-> $_ <-||- 
        } <-||- 

    
    
    

    }catch{

         -||-> $Config.Result = "Error" <-||- ; -||-> $Config <-||- 
    } <-||- 
} <-||- 

