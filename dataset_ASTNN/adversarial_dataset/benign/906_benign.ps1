

 -||-> Describe "Set-Item" -Tag "CI" {
     -||-> $testCases = @{ Path =  -||-> "variable:SetItemTestCase" <-||- ; Value =  -||-> "TestData" <-||- ; Validate =  -||-> {  -||-> $SetItemTestCase | Should -Be "TestData" <-||-  } <-||- ; Reset =  -||-> { -||-> remove-item variable:SetItemTestCase <-||- } <-||-  },
        @{ Path =  -||-> "alias:SetItemTestCase" <-||- ; Value =  -||-> "Get-Alias" <-||- ; Validate =  -||-> {  -||-> ( -||-> Get-Alias SetItemTestCase <-||- ).Definition | Should -Be "Get-Alias" <-||- } <-||- ; Reset =  -||-> {  -||-> remove-item alias:SetItemTestCase <-||-  } <-||-  },
        @{ Path =  -||-> "function:SetItemTestCase" <-||- ; Value =  -||-> {  -||-> 1 <-||-  } <-||- ; Validate =  -||-> {  -||-> SetItemTestCase | Should -Be 1 <-||-  } <-||- ; Reset =  -||-> {  -||-> remove-item function:SetItemTestCase <-||-  } <-||-  },
        @{ Path =  -||-> "env:SetItemTestCase" <-||- ; Value =  -||-> {  -||-> 1 <-||-  } <-||- ; Validate =  -||-> {  -||-> $env:SetItemTestCase | Should -Be 1 <-||-  } <-||- ; Reset =  -||-> {  -||-> remove-item env:SetItemTestCase <-||-  } <-||-  } <-||- 

     -||-> It "Set-Item should be able to handle <Path>" -TestCase $testCases {
        param ( $Path, $Value, $Validate, $Reset )
         -||-> Set-item -path $path -Value $value <-||- 
         -||-> try {
             -||-> & $Validate <-||- 
        }
        finally {
             -||-> & $reset <-||- 
        } <-||- 
    } <-||- 
} <-||- 


