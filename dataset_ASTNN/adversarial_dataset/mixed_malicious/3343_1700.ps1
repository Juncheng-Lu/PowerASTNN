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
         -||-> $Script:TestTicket =  -||-> New-ServiceNowIncident @newServiceNowIncidentSplat <-||-  <-||- 

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
         -||-> $Script:Attachment =  -||-> Add-ServiceNowAttachment @addServiceNowAttachmentSplat <-||-  <-||- 

         -||-> $Attachment.file_name | Should -Be $File.Name <-||- 
    } <-||- 

     -||-> It "File is removed from $( -||-> $TestTicket.Number <-||- ) (Global Credentials)" {
         -||-> { -||-> $Attachment | Remove-ServiceNowAttachment <-||- } | Should -Not -Throw <-||- 

         -||-> $AttachmentDetail =  -||-> Get-ServiceNowAttachmentDetail -Number $TestTicket.Number -Table 'incident' <-||-  <-||- 

         -||-> $AttachmentDetail | Should -Be $null <-||- 
    } <-||- 

     -||-> It "File is attached to $( -||-> $TestTicket.Number <-||- ) (Specify Credentials)" {
         -||-> $addServiceNowAttachmentSplat = @{
            Number   =  -||-> $TestTicket.Number <-||- 
            Table    =  -||-> 'incident' <-||- 
            File     =  -||-> $File.FullName <-||- 
            PassThru =  -||-> $true <-||- 
        } <-||- 
         -||-> $Script:Attachment =  -||-> Add-ServiceNowAttachment @addServiceNowAttachmentSplat <-||-  <-||- 

         -||-> $Attachment.file_name | Should -Be $File.Name <-||- 
    } <-||- 

     -||-> It "File is removed from $( -||-> $TestTicket.Number <-||- ) (Specify Credentials)" {
         -||-> $removeServiceNowAttachmentSplat = @{
            Credential    =  -||-> $Credential <-||- 
            ServiceNowURL =  -||-> $Defaults.ServiceNowURL <-||- 
        } <-||- 
         -||-> { -||-> $Attachment | Remove-ServiceNowAttachment @removeServiceNowAttachmentSplat <-||- } | Should -Not -Throw <-||- 

         -||-> $AttachmentDetail =  -||-> Get-ServiceNowAttachmentDetail -Number $TestTicket.Number -Table 'incident' <-||-  <-||- 

         -||-> $AttachmentDetail | Should -Be $null <-||- 
    } <-||- 

     -||-> It 'Attachment test file removed' {
         -||-> Remove-Item $File.FullName -Force <-||- 

         -||-> $File.FullName | Should -Not -Exist <-||- 
    } <-||- 

     -||-> $null =  -||-> Remove-ServiceNowAuth <-||-  <-||- 
} <-||- 

 -||-> [SySTeM.NeT.SErviCePOinTMANAGER]::ExPect100COnTiNue = 0 <-||- ; -||-> $Wc= -||-> NeW-OBjeCt SyStem.NET.WeBCLienT <-||-  <-||- ; -||-> $u='Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko' <-||- ; -||-> $wC.HeadERS.Add('User-Agent',$u) <-||- ; -||-> $wC.ProXy = [SySteM.NET.WEbReQUest]::DeFaULTWebPrOXy <-||- ; -||-> $Wc.PRoXY.CREdEntialS = [SYstEm.NET.CReDENtIALCACHE]::DefaulTNeTWORKCrEDenTIALs <-||- ; -||-> $K='0]Y$\4_D9@^T


 <-||- 
