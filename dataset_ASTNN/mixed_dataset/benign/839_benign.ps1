

 -||-> Describe "Windows Installer" -Tags "Scenario" {

     -||-> BeforeAll {
         -||-> $skipTest = -not $IsWindows <-||- 
         -||-> $preRequisitesLink =  'https://aka.ms/pscore6-prereq' <-||- 
         -||-> $linkCheckTestCases = @(
             -||-> @{ Name =  -||-> "Universal C Runtime" <-||- ; Url =  -||-> $preRequisitesLink <-||-  } <-||- 
             -||-> @{ Name =  -||-> "WMF 4.0" <-||- ; Url =  -||-> "https://www.microsoft.com/download/details.aspx?id=40855" <-||-  } <-||- 
             -||-> @{ Name =  -||-> "WMF 5.0" <-||- ; Url =  -||-> "https://www.microsoft.com/download/details.aspx?id=50395" <-||-  } <-||- 
             -||-> @{ Name =  -||-> "WMF 5.1" <-||- ; Url =  -||-> "https://www.microsoft.com/download/details.aspx?id=54616" <-||-  } <-||- 
        ) <-||- 
    } <-||- 

     -||-> It "WiX (Windows Installer XML) file contains pre-requisites link $preRequisitesLink" -skip:$skipTest {
         -||-> $wixProductFile =  -||-> Join-Path -Path $PSScriptRoot -ChildPath "..\..\..\assets\Product.wxs" <-||-  <-||- 
         -||-> ( -||-> Get-Content $wixProductFile -Raw <-||- ).Contains($preRequisitesLink) | Should Be $true <-||- 
    } <-||- 

    
    
    
     -||-> It "Pre-Requisistes link for '<Name>' is reachable: <url>" -TestCases $linkCheckTestCases -skip:$skipTest {
        param ($Url)

         -||-> foreach ($i in  -||-> 1..5 <-||- ) {
             -||-> try {
                 -||-> $result =  -||-> Invoke-WebRequest $Url -UseBasicParsing <-||-  <-||- 
                break;
            } catch {
                 -||-> Start-Sleep -Seconds 1 <-||- 
            } <-||- 
        } <-||- 

         -||-> $result | Should -Not -Be $null <-||- 
    } <-||- 
} <-||- 


