

 -||-> Describe "Configuration file locations" -tags "CI","Slow" {

     -||-> BeforeAll {
         -||-> $powershell =  -||-> Join-Path -Path $PsHome -ChildPath "pwsh" <-||-  <-||- 
         -||-> $profileName = "Microsoft.PowerShell_profile.ps1" <-||- 
    } <-||- 

     -||-> Context "Default configuration file locations" {

         -||-> BeforeAll {

             -||-> if ( -||-> $IsWindows <-||- ) {
                 -||-> $ProductName = "WindowsPowerShell" <-||- 
                 -||-> if ( -||-> $IsCoreCLR -and ( -||-> $PSHOME -notlike "*Windows\System32\WindowsPowerShell\v1.0" <-||- ) <-||- )
                {
                     -||-> $ProductName =  "PowerShell" <-||- 
                } <-||- 
                 -||-> $expectedCache    = [IO.Path]::Combine($env:LOCALAPPDATA, "Microsoft", "Windows", "PowerShell", "StartupProfileData-NonInteractive") <-||- 
                 -||-> $expectedModule   = [IO.Path]::Combine($env:USERPROFILE, "Documents", $ProductName, "Modules") <-||- 
                 -||-> $expectedProfile  = [io.path]::Combine($env:USERPROFILE, "Documents", $ProductName, $profileName) <-||- 
                 -||-> $expectedReadline = [IO.Path]::Combine($env:AppData, "Microsoft", "Windows", "PowerShell", "PSReadline", "ConsoleHost_history.txt") <-||- 
            } else {
                 -||-> $expectedCache    = [IO.Path]::Combine($env:HOME, ".cache", "powershell", "StartupProfileData-NonInteractive") <-||- 
                 -||-> $expectedModule   = [IO.Path]::Combine($env:HOME, ".local", "share", "powershell", "Modules") <-||- 
                 -||-> $expectedProfile  = [io.path]::Combine($env:HOME,".config","powershell",$profileName) <-||- 
                 -||-> $expectedReadline = [IO.Path]::Combine($env:HOME, ".local", "share", "powershell", "PSReadLine", "ConsoleHost_history.txt") <-||- 
            } <-||- 

             -||-> $ItArgs = @{} <-||- 
        } <-||- 

         -||-> BeforeEach {
             -||-> $original_PSModulePath = $env:PSModulePath <-||- 
        } <-||- 

         -||-> AfterEach {
             -||-> $env:PSModulePath = $original_PSModulePath <-||- 
        } <-||- 

         -||-> It @ItArgs "Profile location should be correct" {
             -||-> & $powershell -noprofile -c `$PROFILE | Should -Be $expectedProfile <-||- 
        } <-||- 

         -||-> It @ItArgs "PSModulePath should contain the correct path" {
             -||-> $env:PSModulePath = "" <-||- 
             -||-> $actual =  -||-> & $powershell -noprofile -c `$env:PSModulePath <-||-  <-||- 
             -||-> $actual | Should -Match ( -||-> [regex]::Escape($expectedModule) <-||- ) <-||- 
        } <-||- 

         -||-> It @ItArgs "PSReadLine history save location should be correct" {
             -||-> & $powershell -noprofile {  -||-> ( -||-> Get-PSReadlineOption <-||- ).HistorySavePath <-||-  } | Should -Be $expectedReadline <-||- 
        } <-||- 

        
         -||-> It "JIT cache should be created correctly" -Skip {
             -||-> Remove-Item -ErrorAction SilentlyContinue $expectedCache <-||- 
             -||-> & $powershell -noprofile { exit } <-||- 
             -||-> $expectedCache | Should -Exist <-||- 
        } <-||- 

        
    } <-||- 

     -||-> Context "XDG Base Directory Specification is supported on Linux" {
         -||-> BeforeAll {
            
             -||-> if ( -||-> $IsWindows <-||- ) {
                 -||-> $ItArgs = @{ skip =  -||-> $true <-||-  } <-||- 
            } else {
                 -||-> $ItArgs = @{} <-||- 
            } <-||- 
        } <-||- 

         -||-> BeforeEach {
             -||-> $original_PSModulePath = $env:PSModulePath <-||- 
             -||-> $original_XDG_CONFIG_HOME = $env:XDG_CONFIG_HOME <-||- 
             -||-> $original_XDG_CACHE_HOME = $env:XDG_CACHE_HOME <-||- 
             -||-> $original_XDG_DATA_HOME = $env:XDG_DATA_HOME <-||- 
        } <-||- 

         -||-> AfterEach {
             -||-> $env:PSModulePath = $original_PSModulePath <-||- 
             -||-> $env:XDG_CONFIG_HOME = $original_XDG_CONFIG_HOME <-||- 
             -||-> $env:XDG_CACHE_HOME = $original_XDG_CACHE_HOME <-||- 
             -||-> $env:XDG_DATA_HOME = $original_XDG_DATA_HOME <-||- 
        } <-||- 

         -||-> It @ItArgs "Profile should respect XDG_CONFIG_HOME" {
             -||-> $env:XDG_CONFIG_HOME = $TestDrive <-||- 
             -||-> $expected = [IO.Path]::Combine($TestDrive, "powershell", $profileName) <-||- 
             -||-> & $powershell -noprofile -c `$PROFILE | Should -Be $expected <-||- 
        } <-||- 

         -||-> It @ItArgs "PSModulePath should respect XDG_DATA_HOME" {
             -||-> $env:PSModulePath = "" <-||- 
             -||-> $env:XDG_DATA_HOME = $TestDrive <-||- 
             -||-> $expected = [IO.Path]::Combine($TestDrive, "powershell", "Modules") <-||- 
             -||-> $actual =  -||-> & $powershell -noprofile -c `$env:PSModulePath <-||-  <-||- 
             -||-> $actual | Should -Match $expected <-||- 
        } <-||- 

         -||-> It @ItArgs "PSReadLine history should respect XDG_DATA_HOME" {
             -||-> $env:XDG_DATA_HOME = $TestDrive <-||- 
             -||-> $expected = [IO.Path]::Combine($TestDrive, "powershell", "PSReadLine", "ConsoleHost_history.txt") <-||- 
             -||-> & $powershell -noprofile {  -||-> ( -||-> Get-PSReadlineOption <-||- ).HistorySavePath <-||-  } | Should -Be $expected <-||- 
        } <-||- 

        
         -||-> It -Skip "JIT cache should respect XDG_CACHE_HOME" {
             -||-> $env:XDG_CACHE_HOME = $TestDrive <-||- 
             -||-> $expected = [IO.Path]::Combine($TestDrive, "powershell", "StartupProfileData-NonInteractive") <-||- 
             -||-> Remove-Item -ErrorAction SilentlyContinue $expected <-||- 
             -||-> & $powershell -noprofile { exit } <-||- 
             -||-> $expected | Should -Exist <-||- 
        } <-||- 
    } <-||- 
} <-||- 

 -||-> Describe "Working directory on startup" -Tag "CI" {
     -||-> BeforeAll {
         -||-> $powershell =  -||-> Join-Path -Path $PSHOME -ChildPath "pwsh" <-||-  <-||- 
         -||-> $testPath =  -||-> New-Item -ItemType Directory -Path "$TestDrive\test[dir]" <-||-  <-||- 
         -||-> $currentDirectory =  -||-> Get-Location <-||-  <-||- 
    } <-||- 

     -||-> AfterAll {
         -||-> Set-Location $currentDirectory <-||- 
    } <-||- 

    
     -||-> It "Can start in directory where name contains wildcard characters" -Pending {
         -||-> Set-Location -LiteralPath $testPath.FullName <-||- 
         -||-> if ( -||-> $IsMacOS <-||- ) {
            
             -||-> $expectedPath = "/private" + $testPath.FullName <-||- 
        } else {
             -||-> $expectedPath = $testPath.FullName <-||- 
        } <-||- 
         -||-> & $powershell -noprofile -c {  -||-> $PWD.Path <-||-  } | Should -BeExactly $expectedPath <-||- 
    } <-||- 
} <-||- 


