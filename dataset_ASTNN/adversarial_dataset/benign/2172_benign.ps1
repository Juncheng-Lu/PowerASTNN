 -||-> function Get-HumanTime($Seconds) {
     -||-> if ( -||-> $Seconds -gt 0.99 <-||- ) {
         -||-> $time = [math]::Round($Seconds, 2) <-||- 
         -||-> $unit = 's' <-||- 
    }
    else {
         -||-> $time = [math]::Floor($Seconds * 1000) <-||- 
         -||-> $unit = 'ms' <-||- 
    } <-||- 
    return  -||-> "$time$unit" <-||- 
} <-||- 

 -||-> function GetFullPath ([string]$Path) {
     -||-> $Folder =  -||-> & $SafeCommands['Split-Path'] -Path $Path -Parent <-||-  <-||- 
     -||-> $File =  -||-> & $SafeCommands['Split-Path'] -Path $Path -Leaf <-||-  <-||- 

     -||-> if (  -||-> -not ( -||-> [String]::IsNullOrEmpty($Folder) <-||- ) <-||- ) {
         -||-> $FolderResolved =  -||-> & $SafeCommands['Resolve-Path'] -Path $Folder <-||-  <-||- 
    }
    else {
         -||-> $FolderResolved =  -||-> & $SafeCommands['Resolve-Path'] -Path $ExecutionContext.SessionState.Path.CurrentFileSystemLocation <-||-  <-||- 
    } <-||- 

     -||-> $Path =  -||-> & $SafeCommands['Join-Path'] -Path $FolderResolved.ProviderPath -ChildPath $File <-||-  <-||- 

    return  -||-> $Path <-||- 
} <-||- 

 -||-> function Export-PesterResults {
    param (
        $PesterState,
        [string] $Path,
        [string] $Format
    )

    switch -Wildcard ( -||-> $Format <-||- ) {
        '*Xml' {
             -||-> Export-XmlReport -PesterState $PesterState -Path $Path -Format $Format <-||- 
        }

        default {
            throw  -||-> "'$Format' is not a valid Pester export format." <-||- 
        }
    }
} <-||- 
 -||-> function Export-XmlReport {
    param (
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        $PesterState,

        [parameter(Mandatory = $true)]
        [String] $Path,

        [parameter(Mandatory = $true)]
        [ValidateSet('NUnitXml', 'JUnitXml')]
        [string] $Format
    )

    
    
    

     -||-> $Path =  -||-> GetFullPath -Path $Path <-||-  <-||- 

     -||-> $settings =  -||-> & $SafeCommands['New-Object'] -TypeName Xml.XmlWriterSettings -Property @{
        Indent =  -||-> $true <-||- 
        NewLineOnAttributes =  -||-> $false <-||- 
    } <-||-  <-||- 

     -||-> $xmlFile = $null <-||- 
     -||-> $xmlWriter = $null <-||- 
     -||-> try {
         -||-> $xmlFile = [IO.File]::Create($Path) <-||- 
         -||-> $xmlWriter = [Xml.XmlWriter]::Create($xmlFile, $settings) <-||- 

        switch ( -||-> $Format <-||- ) {
            'NUnitXml' {
                 -||-> Write-NUnitReport -XmlWriter $xmlWriter -PesterState $PesterState <-||- 
            }

            'JUnitXml' {
                 -||-> Write-JUnitReport -XmlWriter $xmlWriter -PesterState $PesterState <-||- 
            }
        }

         -||-> $xmlWriter.Flush() <-||- 
         -||-> $xmlFile.Flush() <-||- 
    }
    finally {
         -||-> if ( -||-> $null -ne $xmlWriter <-||- ) {
             -||-> try {
                 -||-> $xmlWriter.Close() <-||- 
            }
            catch {
            } <-||- 
        } <-||- 
         -||-> if ( -||-> $null -ne $xmlFile <-||- ) {
             -||-> try {
                 -||-> $xmlFile.Close() <-||- 
            }
            catch {
            } <-||- 
        } <-||- 
    } <-||- 
} <-||- 

 -||-> function Write-NUnitReport($PesterState, [System.Xml.XmlWriter] $XmlWriter) {
    
     -||-> $XmlWriter.WriteStartDocument($false) <-||- 

    
     -||-> $xmlWriter.WriteStartElement('test-results') <-||- 

     -||-> Write-NUnitTestResultAttributes @PSBoundParameters <-||- 
     -||-> Write-NUnitTestResultChildNodes @PSBoundParameters <-||- 

     -||-> $XmlWriter.WriteEndElement() <-||- 
} <-||- 

 -||-> function Write-NUnitTestResultAttributes($PesterState, [System.Xml.XmlWriter] $XmlWriter) {
     -||-> $XmlWriter.WriteAttributeString('xmlns', 'xsi', $null, 'http://www.w3.org/2001/XMLSchema-instance') <-||- 
     -||-> $XmlWriter.WriteAttributeString('xsi', 'noNamespaceSchemaLocation', [Xml.Schema.XmlSchema]::InstanceNamespace , 'nunit_schema_2.5.xsd') <-||- 
     -||-> $XmlWriter.WriteAttributeString('name', 'Pester') <-||- 
     -||-> $XmlWriter.WriteAttributeString('total', ( -||-> $PesterState.TotalCount - $PesterState.SkippedCount <-||- )) <-||- 
     -||-> $XmlWriter.WriteAttributeString('errors', '0') <-||- 
     -||-> $XmlWriter.WriteAttributeString('failures', $PesterState.FailedCount) <-||- 
     -||-> $XmlWriter.WriteAttributeString('not-run', '0') <-||- 
     -||-> $XmlWriter.WriteAttributeString('inconclusive', $PesterState.PendingCount + $PesterState.InconclusiveCount) <-||- 
     -||-> $XmlWriter.WriteAttributeString('ignored', $PesterState.SkippedCount) <-||- 
     -||-> $XmlWriter.WriteAttributeString('skipped', '0') <-||- 
     -||-> $XmlWriter.WriteAttributeString('invalid', '0') <-||- 
     -||-> $date =  -||-> & $SafeCommands['Get-Date'] <-||-  <-||- 
     -||-> $XmlWriter.WriteAttributeString('date', ( -||-> & $SafeCommands['Get-Date'] -Date $date -Format 'yyyy-MM-dd' <-||- )) <-||- 
     -||-> $XmlWriter.WriteAttributeString('time', ( -||-> & $SafeCommands['Get-Date'] -Date $date -Format 'HH:mm:ss' <-||- )) <-||- 
} <-||- 

 -||-> function Write-NUnitTestResultChildNodes($PesterState, [System.Xml.XmlWriter] $XmlWriter) {
     -||-> Write-NUnitEnvironmentInformation @PSBoundParameters <-||- 
     -||-> Write-NUnitCultureInformation @PSBoundParameters <-||- 

     -||-> $suiteInfo =  -||-> Get-TestSuiteInfo -TestSuite $PesterState -TestSuiteName $PesterState.TestSuiteName <-||-  <-||- 

     -||-> $XmlWriter.WriteStartElement('test-suite') <-||- 

     -||-> Write-NUnitTestSuiteAttributes -TestSuiteInfo $suiteInfo -XmlWriter $XmlWriter <-||- 

     -||-> $XmlWriter.WriteStartElement('results') <-||- 

     -||-> foreach ($action in  -||-> $PesterState.TestActions.Actions <-||- ) {
         -||-> Write-NUnitTestSuiteElements -XmlWriter $XmlWriter -Node $action <-||- 
    } <-||- 

     -||-> $XmlWriter.WriteEndElement() <-||- 
     -||-> $XmlWriter.WriteEndElement() <-||- 
} <-||- 

 -||-> function Write-NUnitEnvironmentInformation($PesterState, [System.Xml.XmlWriter] $XmlWriter) {
     -||-> $XmlWriter.WriteStartElement('environment') <-||- 

     -||-> $environment =  -||-> Get-RunTimeEnvironment <-||-  <-||- 
     -||-> foreach ($keyValuePair in  -||-> $environment.GetEnumerator() <-||- ) {
         -||-> if ( -||-> $keyValuePair.Name -eq 'junit-version' <-||- ) {
            continue
        } <-||- 

         -||-> $XmlWriter.WriteAttributeString($keyValuePair.Name, $keyValuePair.Value) <-||- 
    } <-||- 

     -||-> $XmlWriter.WriteEndElement() <-||- 
} <-||- 

 -||-> function Write-NUnitCultureInformation($PesterState, [System.Xml.XmlWriter] $XmlWriter) {
     -||-> $XmlWriter.WriteStartElement('culture-info') <-||- 

     -||-> $XmlWriter.WriteAttributeString('current-culture', ( -||-> [System.Threading.Thread]::CurrentThread.CurrentCulture <-||- ).Name) <-||- 
     -||-> $XmlWriter.WriteAttributeString('current-uiculture', ( -||-> [System.Threading.Thread]::CurrentThread.CurrentUiCulture <-||- ).Name) <-||- 

     -||-> $XmlWriter.WriteEndElement() <-||- 
} <-||- 

 -||-> function Write-NUnitTestSuiteElements($Node, [System.Xml.XmlWriter] $XmlWriter, [string] $Path) {
     -||-> $suiteInfo =  -||-> Get-TestSuiteInfo $Node <-||-  <-||- 

     -||-> $XmlWriter.WriteStartElement('test-suite') <-||- 

     -||-> Write-NUnitTestSuiteAttributes -TestSuiteInfo $suiteInfo -XmlWriter $XmlWriter <-||- 

     -||-> $XmlWriter.WriteStartElement('results') <-||- 

     -||-> $separator =  -||-> if ( -||-> $Path <-||- ) {
         -||-> '.' <-||- 
    }
    else {
         -||-> '' <-||- 
    } <-||-  <-||- 
     -||-> $newName =  -||-> if ( -||-> $Node.Hint -ne 'Script' <-||- ) {
         -||-> $suiteInfo.Name <-||- 
    }
    else {
         -||-> '' <-||- 
    } <-||-  <-||- 
     -||-> $newPath = "${Path}${separator}${newName}" <-||- 

     -||-> foreach ($action in  -||-> $Node.Actions <-||- ) {
         -||-> if ( -||-> $action.Type -eq 'TestGroup' <-||- ) {
             -||-> Write-NUnitTestSuiteElements -Node $action -XmlWriter $XmlWriter -Path $newPath <-||- 
        } <-||- 
    } <-||- 

     -||-> $suites = @(
         -||-> $Node.Actions |
            & $SafeCommands['Where-Object'] {  -||-> $_.Type -eq 'TestCase' <-||-  } |
            & $SafeCommands['Group-Object'] -Property ParameterizedSuiteName <-||- 
    ) <-||- 

     -||-> foreach ($suite in  -||-> $suites <-||- ) {
         -||-> if ( -||-> $suite.Name <-||- ) {
             -||-> $parameterizedSuiteInfo =  -||-> Get-ParameterizedTestSuiteInfo -TestSuiteGroup $suite <-||-  <-||- 

             -||-> $XmlWriter.WriteStartElement('test-suite') <-||- 

             -||-> Write-NUnitTestSuiteAttributes -TestSuiteInfo $parameterizedSuiteInfo -TestSuiteType 'ParameterizedTest' -XmlWriter $XmlWriter -Path $newPath <-||- 

             -||-> $XmlWriter.WriteStartElement('results') <-||- 
        } <-||- 

         -||-> foreach ($testCase in  -||-> $suite.Group <-||- ) {
             -||-> Write-NUnitTestCaseElement -TestResult $testCase -XmlWriter $XmlWriter -Path $newPath -ParameterizedSuiteName $suite.Name <-||- 
        } <-||- 

         -||-> if ( -||-> $suite.Name <-||- ) {
             -||-> $XmlWriter.WriteEndElement() <-||- 
             -||-> $XmlWriter.WriteEndElement() <-||- 
        } <-||- 
    } <-||- 

     -||-> $XmlWriter.WriteEndElement() <-||- 
     -||-> $XmlWriter.WriteEndElement() <-||- 
} <-||- 

 -||-> function Write-JUnitReport($PesterState, [System.Xml.XmlWriter] $XmlWriter) {
    
     -||-> $XmlWriter.WriteStartDocument($false) <-||- 

    
     -||-> $xmlWriter.WriteStartElement('testsuites') <-||- 

     -||-> Write-JUnitTestResultAttributes @PSBoundParameters <-||- 

     -||-> $testSuiteNumber = 0 <-||- 
     -||-> foreach ($action in  -||-> $PesterState.TestActions.Actions <-||- ) {
         -||-> Write-JUnitTestSuiteElements -XmlWriter $XmlWriter -Node $action -Id $testSuiteNumber <-||- 
         -||-> $testSuiteNumber++ <-||- 
    } <-||- 

     -||-> $XmlWriter.WriteEndElement() <-||- 
} <-||- 

 -||-> function Write-JUnitTestResultAttributes($PesterState, [System.Xml.XmlWriter] $XmlWriter) {
     -||-> $XmlWriter.WriteAttributeString('xmlns', 'xsi', $null, 'http://www.w3.org/2001/XMLSchema-instance') <-||- 
     -||-> $XmlWriter.WriteAttributeString('xsi', 'noNamespaceSchemaLocation', [Xml.Schema.XmlSchema]::InstanceNamespace , 'junit_schema_4.xsd') <-||- 
     -||-> $XmlWriter.WriteAttributeString('name', $PesterState.TestSuiteName) <-||- 
     -||-> $XmlWriter.WriteAttributeString('tests', $PesterState.PassedCount) <-||- 
     -||-> $XmlWriter.WriteAttributeString('errors', '0') <-||- 
     -||-> $XmlWriter.WriteAttributeString('failures', $PesterState.FailedCount) <-||- 
     -||-> $XmlWriter.WriteAttributeString('disabled', $PesterState.PendingCount + $PesterState.InconclusiveCount + $PesterState.SkippedCount) <-||- 
     -||-> $XmlWriter.WriteAttributeString('time', ( -||-> $PesterState.Time.TotalSeconds.ToString('0.000', [System.Globalization.CultureInfo]::InvariantCulture) <-||- )) <-||- 
} <-||- 

 -||-> function Write-JUnitTestSuiteElements($Node, [System.Xml.XmlWriter] $XmlWriter, [uint16] $Id) {
     -||-> $XmlWriter.WriteStartElement('testsuite') <-||- 

     -||-> Write-JUnitTestSuiteAttributes -Action $Node -XmlWriter $XmlWriter -Package $Node.Name -Id $Id <-||- 

     -||-> $testCases =  -||-> foreach ($al1 in  -||-> $node.Actions <-||- ) {
         -||-> if ( -||-> $al1.Type -ne 'TestCase' <-||- ) {
             -||-> foreach ($al2 in  -||-> $al1.Actions <-||- ) {
                 -||-> if ( -||-> $al2.Type -ne 'TestCase' <-||- ) {
                     -||-> foreach ($alt3 in  -||-> $al2.Actions <-||- ) {
                         -||-> $path = "$( -||-> $al1.Name <-||- ).$( -||-> $al2.Name <-||- ).$( -||-> $alt3.Name <-||- )" <-||- 
                         -||-> $alt3 | Add-Member -PassThru -MemberType NoteProperty -Name Path -Value $path <-||- 
                    } <-||- 
                }
                else {
                     -||-> $path = "$( -||-> $al1.Name <-||- ).$( -||-> $al2.Name <-||- )" <-||- 
                     -||-> $al2 | Add-Member -PassThru -MemberType NoteProperty -Name Path -Value $path <-||- 
                } <-||- 
            } <-||- 
        }
        else {
             -||-> $path = "$( -||-> $al1.Name <-||- )" <-||- 
             -||-> $al1 | Add-Member -PassThru -MemberType NoteProperty -Name Path -Value $path <-||- 
        } <-||- 
    } <-||-  <-||- 

     -||-> foreach ($t in  -||-> $testCases <-||- ) {
         -||-> Write-JUnitTestCaseElements -Action $t -XmlWriter $XmlWriter -Package $Node.Name <-||- 
    } <-||- 

     -||-> $XmlWriter.WriteEndElement() <-||- 
} <-||- 

 -||-> function Write-JUnitTestSuiteAttributes($Action, [System.Xml.XmlWriter] $XmlWriter, [string] $Package, [uint16] $Id) {
     -||-> $environment =  -||-> Get-RunTimeEnvironment <-||-  <-||- 

     -||-> $XmlWriter.WriteAttributeString('name', $Action.Name) <-||- 
     -||-> $XmlWriter.WriteAttributeString('tests', $Action.TotalCount) <-||- 
     -||-> $XmlWriter.WriteAttributeString('errors', '0') <-||- 
     -||-> $XmlWriter.WriteAttributeString('failures', $Action.FailedCount) <-||- 
     -||-> $XmlWriter.WriteAttributeString('hostname', $environment.'machine-name') <-||- 
     -||-> $XmlWriter.WriteAttributeString('id', $Id) <-||- 
     -||-> $XmlWriter.WriteAttributeString('skipped', $Action.SkippedCount) <-||- 
     -||-> $XmlWriter.WriteAttributeString('disabled', $Action.InconclusiveCount + $Action.PendingCount) <-||- 
     -||-> $XmlWriter.WriteAttributeString('package', $Package) <-||- 
     -||-> $XmlWriter.WriteAttributeString('time', $Action.Time.TotalSeconds.ToString('0.000', [System.Globalization.CultureInfo]::InvariantCulture)) <-||- 

     -||-> $XmlWriter.WriteStartElement('properties') <-||- 

     -||-> foreach ($keyValuePair in  -||-> $environment.GetEnumerator() <-||- ) {
         -||-> if ( -||-> $keyValuePair.Name -eq 'nunit-version' <-||- ) {
            continue
        } <-||- 

         -||-> $XmlWriter.WriteStartElement('property') <-||- 
         -||-> $XmlWriter.WriteAttributeString('name', $keyValuePair.Name) <-||- 
         -||-> $XmlWriter.WriteAttributeString('value', $keyValuePair.Value) <-||- 
         -||-> $XmlWriter.WriteEndElement() <-||- 
    } <-||- 

     -||-> $XmlWriter.WriteEndElement() <-||- 
} <-||- 

 -||-> function Write-JUnitTestCaseElements($Action, [System.Xml.XmlWriter] $XmlWriter, [string] $Package) {
     -||-> $XmlWriter.WriteStartElement('testcase') <-||- 

     -||-> Write-JUnitTestCaseAttributes -Action $Action -XmlWriter $XmlWriter -ClassName $Package <-||- 

     -||-> $XmlWriter.WriteEndElement() <-||- 
} <-||- 

 -||-> function Write-JUnitTestCaseAttributes($Action, [System.Xml.XmlWriter] $XmlWriter, [string] $ClassName) {
     -||-> $XmlWriter.WriteAttributeString('name', $Action.Path) <-||- 

     -||-> $statusElementName = switch ( -||-> $Action.Result <-||- ) {
        Passed {
             -||-> $null <-||- 
        }

        Failed {
             -||-> 'failure' <-||- 
        }

        default {
             -||-> 'skipped' <-||- 
        }
    } <-||- 

     -||-> $XmlWriter.WriteAttributeString('status', $Action.Result) <-||- 
     -||-> $XmlWriter.WriteAttributeString('classname', $ClassName) <-||- 
     -||-> $XmlWriter.WriteAttributeString('assertions', '0') <-||- 
     -||-> $XmlWriter.WriteAttributeString('time', $Action.Time.TotalSeconds.ToString('0.000', [System.Globalization.CultureInfo]::InvariantCulture)) <-||- 

     -||-> if ( -||-> $null -ne $statusElementName <-||- ) {
         -||-> Write-JUnitTestCaseMessageElements -Action $Action -XmlWriter $XmlWriter -StatusElementName $statusElementName <-||- 
    } <-||- 
} <-||- 

 -||-> function Write-JUnitTestCaseMessageElements($Action, [System.Xml.XmlWriter] $XmlWriter, [string] $StatusElementName) {
     -||-> $XmlWriter.WriteStartElement($StatusElementName) <-||- 

     -||-> $XmlWriter.WriteAttributeString('message', $Action.FailureMessage) <-||-  

     -||-> $XmlWriter.WriteEndElement() <-||- 
} <-||- 

 -||-> function Get-ParameterizedTestSuiteInfo ([Microsoft.PowerShell.Commands.GroupInfo] $TestSuiteGroup) {
     -||-> $node =  -||-> & $SafeCommands['New-Object'] psobject -Property @{
        Name =  -||-> $TestSuiteGroup.Name <-||- 
        TotalCount =  -||-> 0 <-||- 
        Time =  -||-> [timespan]0 <-||- 
        PassedCount =  -||-> 0 <-||- 
        FailedCount =  -||-> 0 <-||- 
        SkippedCount =  -||-> 0 <-||- 
        PendingCount =  -||-> 0 <-||- 
        InconclusiveCount =  -||-> 0 <-||- 
    } <-||-  <-||- 

     -||-> foreach ($testCase in  -||-> $TestSuiteGroup.Group <-||- ) {
         -||-> $node.TotalCount++ <-||- 

        switch ( -||-> $testCase.Result <-||- ) {
            Passed {
                 -||-> $Node.PassedCount++ <-||- ; break;
            }
            Failed {
                 -||-> $Node.FailedCount++ <-||- ; break;
            }
            Skipped {
                 -||-> $Node.SkippedCount++ <-||- ; break;
            }
            Pending {
                 -||-> $Node.PendingCount++ <-||- ; break;
            }
            Inconclusive {
                 -||-> $Node.InconclusiveCount++ <-||- ; break;
            }
        }

         -||-> $Node.Time += $testCase.Time <-||- 
    } <-||- 

    return  -||-> Get-TestSuiteInfo -TestSuite $node <-||- 
} <-||- 

 -||-> function Get-TestSuiteInfo ($TestSuite, $TestSuiteName) {
     -||-> if ( -||-> -not $PSBoundParameters.ContainsKey('TestSuiteName') <-||- ) {
         -||-> $TestSuiteName = $TestSuite.Name <-||- 
    } <-||- 

     -||-> $suite = @{
        resultMessage =  -||-> 'Failure' <-||- 
        success =  -||-> if ( -||-> $TestSuite.FailedCount -eq 0 <-||- ) {
             -||-> 'True' <-||- 
        }
        else {
             -||-> 'False' <-||- 
        } <-||- 
        totalTime =  -||-> Convert-TimeSpan $TestSuite.Time <-||- 
        name =  -||-> $TestSuiteName <-||- 
        description =  -||-> $TestSuiteName <-||- 
    } <-||- 

     -||-> $suite.resultMessage =  -||-> Get-GroupResult $TestSuite <-||-  <-||- 
     -||-> $suite <-||- 
} <-||- 

 -||-> function Get-TestTime($tests) {
     -||-> [TimeSpan]$totalTime = 0 <-||- ;
     -||-> if ( -||-> $tests <-||- ) {
         -||-> foreach ($test in  -||-> $tests <-||- ) {
             -||-> $totalTime += $test.time <-||- 
        } <-||- 
    } <-||- 

     -||-> Convert-TimeSpan -TimeSpan $totalTime <-||- 
} <-||- 
 -||-> function Convert-TimeSpan {
    param (
        [Parameter(ValueFromPipeline = $true)]
        $TimeSpan
    )
    process {
         -||-> if ( -||-> $TimeSpan <-||- ) {
             -||-> [string][math]::round(( -||-> [TimeSpan]$TimeSpan <-||- ).totalseconds, 4) <-||- 
        }
        else {
             -||-> '0' <-||- 
        } <-||- 
    }
} <-||- 
 -||-> function Get-TestSuccess($tests) {
     -||-> $result = $true <-||- 
     -||-> if ( -||-> $tests <-||- ) {
         -||-> foreach ($test in  -||-> $tests <-||- ) {
             -||-> if ( -||-> -not $test.Passed <-||- ) {
                 -||-> $result = $false <-||- 
                break
            } <-||- 
        } <-||- 
    } <-||- 
     -||-> [String]$result <-||- 
} <-||- 
 -||-> function Write-NUnitTestSuiteAttributes($TestSuiteInfo, [string] $TestSuiteType = 'TestFixture', [System.Xml.XmlWriter] $XmlWriter, [string] $Path) {
     -||-> $name = $TestSuiteInfo.Name <-||- 

     -||-> if ( -||-> $TestSuiteType -eq 'ParameterizedTest' -and $Path <-||- ) {
         -||-> $name = "$Path.$name" <-||- 
    } <-||- 

     -||-> $XmlWriter.WriteAttributeString('type', $TestSuiteType) <-||- 
     -||-> $XmlWriter.WriteAttributeString('name', $name) <-||- 
     -||-> $XmlWriter.WriteAttributeString('executed', 'True') <-||- 
     -||-> $XmlWriter.WriteAttributeString('result', $TestSuiteInfo.resultMessage) <-||- 
     -||-> $XmlWriter.WriteAttributeString('success', $TestSuiteInfo.success) <-||- 
     -||-> $XmlWriter.WriteAttributeString('time', $TestSuiteInfo.totalTime) <-||- 
     -||-> $XmlWriter.WriteAttributeString('asserts', '0') <-||- 
     -||-> $XmlWriter.WriteAttributeString('description', $TestSuiteInfo.Description) <-||- 
} <-||- 

 -||-> function Write-NUnitTestCaseElement($TestResult, [System.Xml.XmlWriter] $XmlWriter, [string] $ParameterizedSuiteName, [string] $Path) {
     -||-> $XmlWriter.WriteStartElement('test-case') <-||- 

     -||-> Write-NUnitTestCaseAttributes -TestResult $TestResult -XmlWriter $XmlWriter -ParameterizedSuiteName $ParameterizedSuiteName -Path $Path <-||- 

     -||-> $XmlWriter.WriteEndElement() <-||- 
} <-||- 

 -||-> function Write-NUnitTestCaseAttributes($TestResult, [System.Xml.XmlWriter] $XmlWriter, [string] $ParameterizedSuiteName, [string] $Path) {
     -||-> $testName = $TestResult.Name <-||- 

     -||-> if ( -||-> $testName -eq $ParameterizedSuiteName <-||- ) {
         -||-> $paramString = '' <-||- 
         -||-> if ( -||-> $null -ne $TestResult.Parameters <-||- ) {
             -||-> $params = @(
                 -||-> foreach ($value in  -||-> $TestResult.Parameters.Values <-||- ) {
                     -||-> if ( -||-> $null -eq $value <-||- ) {
                         -||-> 'null' <-||- 
                    }
                    elseif ( -||-> $value -is [string] <-||- ) {
                         -||-> '"{0}"' -f $value <-||- 
                    }
                    else {
                        
                        
                         -||-> [string]$value <-||- 
                    } <-||- 
                } <-||- 
            ) <-||- 

             -||-> $paramString = $params -join ',' <-||- 
        } <-||- 

         -||-> $testName = "$testName($paramString)" <-||- 
    } <-||- 

     -||-> $separator =  -||-> if ( -||-> $Path <-||- ) {
         -||-> '.' <-||- 
    }
    else {
         -||-> '' <-||- 
    } <-||-  <-||- 
     -||-> $testName = "${Path}${separator}${testName}" <-||- 

     -||-> $XmlWriter.WriteAttributeString('description', $TestResult.Name) <-||- 

     -||-> $XmlWriter.WriteAttributeString('name', $testName) <-||- 
     -||-> $XmlWriter.WriteAttributeString('time', ( -||-> Convert-TimeSpan $TestResult.Time <-||- )) <-||- 
     -||-> $XmlWriter.WriteAttributeString('asserts', '0') <-||- 
     -||-> $XmlWriter.WriteAttributeString('success', $TestResult.Passed) <-||- 

    switch ( -||-> $TestResult.Result <-||- ) {
        Passed {
             -||-> $XmlWriter.WriteAttributeString('result', 'Success') <-||- 
             -||-> $XmlWriter.WriteAttributeString('executed', 'True') <-||- 

            break
        }

        Skipped {
             -||-> $XmlWriter.WriteAttributeString('result', 'Ignored') <-||- 
             -||-> $XmlWriter.WriteAttributeString('executed', 'False') <-||- 

             -||-> if ( -||-> $TestResult.FailureMessage <-||- ) {
                 -||-> $XmlWriter.WriteStartElement('reason') <-||- 
                 -||-> $xmlWriter.WriteElementString('message', $TestResult.FailureMessage) <-||- 
                 -||-> $XmlWriter.WriteEndElement() <-||-  
            } <-||- 

            break
        }

        Pending {
             -||-> $XmlWriter.WriteAttributeString('result', 'Inconclusive') <-||- 
             -||-> $XmlWriter.WriteAttributeString('executed', 'True') <-||- 

             -||-> if ( -||-> $TestResult.FailureMessage <-||- ) {
                 -||-> $XmlWriter.WriteStartElement('reason') <-||- 
                 -||-> $xmlWriter.WriteElementString('message', $TestResult.FailureMessage) <-||- 
                 -||-> $XmlWriter.WriteEndElement() <-||-  
            } <-||- 

            break
        }

        Inconclusive {
             -||-> $XmlWriter.WriteAttributeString('result', 'Inconclusive') <-||- 
             -||-> $XmlWriter.WriteAttributeString('executed', 'True') <-||- 

             -||-> if ( -||-> $TestResult.FailureMessage <-||- ) {
                 -||-> $XmlWriter.WriteStartElement('reason') <-||- 
                 -||-> $xmlWriter.WriteElementString('message', $TestResult.FailureMessage) <-||- 
                 -||-> $XmlWriter.WriteEndElement() <-||-  
            } <-||- 

            break
        }
        Failed {
             -||-> $XmlWriter.WriteAttributeString('result', 'Failure') <-||- 
             -||-> $XmlWriter.WriteAttributeString('executed', 'True') <-||- 
             -||-> $XmlWriter.WriteStartElement('failure') <-||- 
             -||-> $xmlWriter.WriteElementString('message', $TestResult.FailureMessage) <-||- 
             -||-> $XmlWriter.WriteElementString('stack-trace', $TestResult.StackTrace) <-||- 
             -||-> $XmlWriter.WriteEndElement() <-||-  
            break
        }
    }
} <-||- 
 -||-> function Get-RunTimeEnvironment() {
    
     -||-> $computerName = $env:ComputerName <-||- 
     -||-> $userName = $env:Username <-||- 
     -||-> if ( -||-> $null -ne $SafeCommands['Get-CimInstance'] <-||- ) {
         -||-> $osSystemInformation = ( -||-> & $SafeCommands['Get-CimInstance'] Win32_OperatingSystem <-||- ) <-||- 
    }
    elseif ( -||-> $null -ne $SafeCommands['Get-WmiObject'] <-||- ) {
         -||-> $osSystemInformation = ( -||-> & $SafeCommands['Get-WmiObject'] Win32_OperatingSystem <-||- ) <-||- 
    }
    elseif ( -||-> $IsMacOS -or $IsLinux <-||- ) {
         -||-> $osSystemInformation = @{
            Name =  -||-> "Unknown" <-||- 
            Version =  -||-> "0.0.0.0" <-||- 
        } <-||- 
         -||-> try {
             -||-> if ( -||-> $null -ne $SafeCommands['uname'] <-||- ) {
                 -||-> $osSystemInformation.Version =  -||-> & $SafeCommands['uname'] -r <-||-  <-||- 
                 -||-> $osSystemInformation.Name =  -||-> & $SafeCommands['uname'] -s <-||-  <-||- 
                 -||-> $computerName =  -||-> & $SafeCommands['uname'] -n <-||-  <-||- 
            } <-||- 
             -||-> if ( -||-> $null -ne $SafeCommands['id'] <-||- ) {
                 -||-> $userName =  -||-> & $SafeCommands['id'] -un <-||-  <-||- 
            } <-||- 
        }
        catch {
            
        } <-||- 
    }
    else {
         -||-> $osSystemInformation = @{
            Name =  -||-> "Unknown" <-||- 
            Version =  -||-> "0.0.0.0" <-||- 
        } <-||- 
    } <-||- 

     -||-> if (  -||-> ( -||-> $PSVersionTable.ContainsKey('PSEdition') <-||- ) -and ( -||-> $PSVersionTable.PSEdition -eq 'Core' <-||- ) <-||- ) {
         -||-> $CLrVersion = "Unknown" <-||- 

    }
    else {
         -||-> $CLrVersion = [string]$PSVersionTable.ClrVersion <-||- 
    } <-||- 

     -||-> @{
        'nunit-version' =  -||-> '2.5.8.0' <-||- 
        'junit-version' =  -||-> '4' <-||- 
        'os-version' =  -||-> $osSystemInformation.Version <-||- 
        platform =  -||-> $osSystemInformation.Name <-||- 
        cwd =  -||-> ( -||-> & $SafeCommands['Get-Location'] <-||- ).Path <-||-  
        'machine-name' =  -||-> $computerName <-||- 
        user =  -||-> $username <-||- 
        'user-domain' =  -||-> $env:userDomain <-||- 
        'clr-version' =  -||-> $CLrVersion <-||- 
    } <-||- 
} <-||- 

 -||-> function Exit-WithCode ($FailedCount) {
     -||-> $host.SetShouldExit($FailedCount) <-||- 
} <-||- 

 -||-> function Get-GroupResult ($InputObject) {
    
    
     -||-> if ( -||-> $inputObject.FailedCount -gt 0 <-||- ) {
        return  -||-> 'Failure' <-||- 
    } <-||- 
     -||-> if ( -||-> $InputObject.SkippedCount -gt 0 <-||- ) {
        return  -||-> 'Ignored' <-||- 
    } <-||- 
     -||-> if ( -||-> $InputObject.PendingCount -gt 0 <-||- ) {
        return  -||-> 'Inconclusive' <-||- 
    } <-||- 
    return  -||-> 'Success' <-||- 
} <-||- 


