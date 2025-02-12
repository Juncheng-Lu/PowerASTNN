 -||-> . $PSScriptRoot\Shared.ps1 <-||- 

 -||-> Describe 'Write-VcsStatus Tests' {
     -||-> Mock -ModuleName posh-git -CommandName git {
         -||-> $OFS = " " <-||- 
         -||-> if ( -||-> $args -contains 'rev-parse' <-||- ) {
             -||-> $res =  -||-> Invoke-Expression "&$gitbin $args" <-||-  <-||- 
            return  -||-> $res <-||- 
        } <-||- 
         -||-> Convert-NativeLineEnding -SplitLines @'

A  test/Foo.Tests.ps1
D test/Bar.Tests.ps1
M test/Baz.Tests.ps1

'@ <-||- 
    } <-||- 

     -||-> Context 'AnsiConsole disabled' {
         -||-> BeforeAll {
            
             -||-> $global:GitPromptSettings =  -||-> & $module.NewBoundScriptBlock({ -||-> [PoshGitPromptSettings]::new() <-||- }) <-||-  <-||- 
             -||-> $GitPromptSettings.AnsiConsole = $false <-||- 
        } <-||- 

         -||-> It 'Returns no output from Write-VcsStatus' {
            
             -||-> $OFS = '' <-||- 
             -||-> $res =  -||-> Write-VcsStatus 6>&1 <-||-  <-||- 
             -||-> "$res" | Should BeExactly " [master +1 ~0 -0 ~]" <-||- 

            
             -||-> $res =  -||-> Write-VcsStatus 6>$null <-||-  <-||- 
             -||-> $res | Should BeExactly $null <-||- 
        } <-||- 
    } <-||- 

     -||-> Context 'AnsiConsole enabled' {
         -||-> BeforeAll {
            
             -||-> $global:GitPromptSettings =  -||-> & $module.NewBoundScriptBlock({ -||-> [PoshGitPromptSettings]::new() <-||- }) <-||-  <-||- 
             -||-> $GitPromptSettings.AnsiConsole = $true <-||- 
        } <-||- 

         -||-> It 'Returns status output from Write-VcsStatus as string' {
             -||-> $res =  -||-> Write-VcsStatus <-||-  <-||- 
             -||-> $res | Should BeExactly " ${csi}93m[${csi}39m${csi}96mmaster${csi}39m${csi}32m +1${csi}39m${csi}32m ~0${csi}39m${csi}32m -0${csi}39m${csi}96m ~${csi}39m${csi}93m]${csi}39m" <-||- 
        } <-||- 
    } <-||- 
} <-||- 


