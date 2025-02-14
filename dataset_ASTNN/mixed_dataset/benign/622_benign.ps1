 -||-> Set-Location -Path $env:SystemDrive\ <-||- 
 -||-> Clear-Host <-||- 

 -||-> $Error.Clear() <-||- 
 -||-> Import-Module -Name posh-git -ErrorAction SilentlyContinue <-||- 

 -||-> if ( -||-> -not( -||-> $Error[0] <-||- ) <-||- ) {
     -||-> $DefaultTitle = $Host.UI.RawUI.WindowTitle <-||- 
     -||-> $GitPromptSettings.BeforeText = '(' <-||- 
     -||-> $GitPromptSettings.BeforeForegroundColor = [ConsoleColor]::Cyan <-||- 
     -||-> $GitPromptSettings.AfterText = ')' <-||- 
     -||-> $GitPromptSettings.AfterForegroundColor = [ConsoleColor]::Cyan <-||- 

     -||-> function prompt {

         -||-> if ( -||-> -not( -||-> Get-GitDirectory <-||- ) <-||- ) {
             -||-> $Host.UI.RawUI.WindowTitle = $DefaultTitle <-||- 
             -||-> "PS $( -||-> $executionContext.SessionState.Path.CurrentLocation <-||- )$( -||-> '>' * ( -||-> $nestedPromptLevel + 1 <-||- ) <-||- ) " <-||-    
        }
        else {
             -||-> $realLASTEXITCODE = $LASTEXITCODE <-||- 

             -||-> Write-Host 'PS ' -ForegroundColor Green -NoNewline <-||- 
             -||-> Write-Host "$( -||-> $executionContext.SessionState.Path.CurrentLocation <-||- ) " -ForegroundColor Yellow -NoNewline <-||- 

             -||-> Write-VcsStatus <-||- 

             -||-> $LASTEXITCODE = $realLASTEXITCODE <-||- 
            return  -||-> "`n$( -||-> '$' * ( -||-> $nestedPromptLevel + 1 <-||- ) <-||- ) " <-||-    
        } <-||- 

    } <-||- 

}
else {
     -||-> Write-Warning -Message 'Unable to load the Posh-Git PowerShell Module' <-||- 
} <-||- 

 -||-> $PSDefaultParameterValues += @{
    'Out-Default:OutVariable' =  -||-> 'LastResult' <-||- 
    'Out-File:Encoding' =  -||-> 'utf8' <-||- 
    'Export-Csv:NoTypeInformation' =  -||-> $true <-||- 
    'ConvertTo-Csv:NoTypeInformation' =  -||-> $true <-||- 
    'Receive-Job:Keep' =  -||-> $true <-||- 
    'Install-Module:AllowClobber' =  -||-> $true <-||- 
    'Install-Module:Force' =  -||-> $true <-||- 
    'Install-Module:SkipPublisherCheck' =  -||-> $true <-||- 
    'Group-Object:NoElement' =  -||-> $true <-||- 
} <-||- 

