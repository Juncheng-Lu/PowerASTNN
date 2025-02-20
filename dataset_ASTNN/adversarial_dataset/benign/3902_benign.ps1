 -||-> $HostSupportsSettingWindowTitle = $null <-||- 
 -||-> $OriginalWindowTitle = $null <-||- 

 -||-> function Test-WindowTitleIsWriteable {
     -||-> if ( -||-> $null -eq $HostSupportsSettingWindowTitle <-||- ) {
        
         -||-> try {
             -||-> $script:OriginalWindowTitle = $Host.UI.RawUI.WindowTitle <-||- 
             -||-> $newTitle = "${OriginalWindowTitle} " <-||- 
             -||-> $Host.UI.RawUI.WindowTitle = $newTitle <-||- 
             -||-> $script:HostSupportsSettingWindowTitle = ( -||-> $Host.UI.RawUI.WindowTitle -eq $newTitle <-||- ) <-||- 
             -||-> $Host.UI.RawUI.WindowTitle = $OriginalWindowTitle <-||- 
             -||-> Write-Debug "HostSupportsSettingWindowTitle: $HostSupportsSettingWindowTitle" <-||- 
             -||-> Write-Debug "OriginalWindowTitle: $OriginalWindowTitle" <-||- 
        }
        catch {
             -||-> $script:OriginalWindowTitle = $null <-||- 
             -||-> $script:HostSupportsSettingWindowTitle = $false <-||- 
             -||-> Write-Debug "HostSupportsSettingWindowTitle error: $_" <-||- 
        } <-||- 
    } <-||- 
    return  -||-> $HostSupportsSettingWindowTitle <-||- 
} <-||- 

 -||-> function Reset-WindowTitle {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    param()
     -||-> $settings = $global:GitPromptSettings <-||- 

    
     -||-> if ( -||-> $HostSupportsSettingWindowTitle -and $OriginalWindowTitle -and $settings.WindowTitle <-||- ) {
         -||-> Write-Debug "Resetting WindowTitle: '$OriginalWindowTitle'" <-||- 
         -||-> $Host.UI.RawUI.WindowTitle = $OriginalWindowTitle <-||- 
    } <-||- 
} <-||- 

 -||-> function Set-WindowTitle {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    param($GitStatus, $IsAdmin)
     -||-> $settings = $global:GitPromptSettings <-||- 

    
     -||-> if ( -||-> $settings.WindowTitle -and ( -||-> Test-WindowTitleIsWriteable <-||- ) <-||- ) {
         -||-> try {
             -||-> if ( -||-> $settings.WindowTitle -is [scriptblock] <-||- ) {
                
                 -||-> $windowTitleText = "$( -||-> & $settings.WindowTitle $GitStatus $IsAdmin <-||- )" <-||- 
            }
            else {
                 -||-> $windowTitleText = $ExecutionContext.SessionState.InvokeCommand.ExpandString("$( -||-> $settings.WindowTitle <-||- )") <-||- 
            } <-||- 

             -||-> Write-Debug "Setting WindowTitle: $windowTitleText" <-||- 
             -||-> $Host.UI.RawUI.WindowTitle = "$windowTitleText" <-||- 
        }
        catch {
             -||-> Write-Debug "Error occurred during evaluation of `$GitPromptSettings.WindowTitle: $_" <-||- 
        } <-||- 
    } <-||- 
} <-||- 


