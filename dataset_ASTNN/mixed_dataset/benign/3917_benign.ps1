param(
	[string]$Version,
	[string]$Path,
	[switch]$Force,
	$Update,
	[switch]$Uninstall
)





 -||-> $Configs = @{
	Url =  -||-> "https://1.eu.dl.wireshark.org/win64/Wireshark-win64-1.10.5.exe" <-||- 
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
                     -||-> Start-Process -FilePath $( -||-> Join-Path $_.Path $_.Filename <-||- ) -ArgumentList "/S /desktopicon=yes" -Wait <-||- 
                } <-||- 
                		
                
                
                
                
                
                
                

                 -||-> $_.Downloads | ForEach-Object{
                     -||-> Remove-Item ( -||-> Join-Path $_.Path $_.Filename <-||- ) -Force <-||- 
                } <-||- 
                		
                
                
                
                		
                 -||-> if( -||-> $Update <-||- ){ -||-> $_.Result = "AppUpdated" <-||- ; -||-> $_ <-||- 
                }else{ -||-> $_.Result = "AppInstalled" <-||- ; -||-> $_ <-||- } <-||- 
            		
            
            
            
            		
            }else{
            	
                 -||-> $_.Result = "ConditionExclusion" <-||- ; -||-> $_ <-||- 
            } <-||- 

        
        
        
        	
        }else{
            
             -||-> $Executable = "C:\Program Files\Wireshark\uninstall.exe" <-||- ;  -||-> if( -||-> Test-Path $Executable <-||- ){ -||-> Start-Process -FilePath $Executable -ArgumentList "/S" -Wait <-||- } <-||- 
                
             -||-> $_.Result = "AppUninstalled" <-||- ; -||-> $_ <-||- 
        } <-||- 

    
    
    

    }catch{

         -||-> $Config.Result = "Error" <-||- ; -||-> $Config <-||- 
    } <-||- 
} <-||- 

