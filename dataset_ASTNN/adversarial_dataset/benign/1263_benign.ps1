


 -||-> Describe 'Automatic variable $input' -Tags "CI" {
    
    
     -||-> It '$input Type should be enumerator' -Skip {
         -||-> function from_begin { [cmdletbinding()]param() begin {  -||-> Write-Output -NoEnumerate $input <-||-  } } <-||- 
         -||-> function from_process { [cmdletbinding()]param() process {  -||-> Write-Output -NoEnumerate $input <-||-  } } <-||- 
         -||-> function from_end { [cmdletbinding()]param() end {  -||-> Write-Output -NoEnumerate $input <-||-  } } <-||- 

         -||-> ( -||-> from_begin <-||- ) -is [System.Collections.IEnumerator] | Should -BeTrue <-||- 
         -||-> ( -||-> from_process <-||- ) -is [System.Collections.IEnumerator] | Should -BeTrue <-||- 
         -||-> ( -||-> from_end <-||- ) -is [System.Collections.IEnumerator] | Should -BeTrue <-||- 
    } <-||- 

     -||-> It 'Empty $input really is empty' {
         -||-> & {  -||-> @( -||-> $input <-||- ).Count <-||-  } | Should -Be 0 <-||- 
         -||-> & { [cmdletbinding()]param() begin {  -||-> @( -||-> $input <-||- ).Count <-||-  } } | Should -Be 0 <-||- 
         -||-> & { [cmdletbinding()]param() process {  -||-> @( -||-> $input <-||- ).Count <-||-  } } | Should -Be 0 <-||- 
         -||-> & { [cmdletbinding()]param() end {  -||-> @( -||-> $input <-||- ).Count <-||-  } } | Should -Be 0 <-||- 
    } <-||- 
} <-||- 


