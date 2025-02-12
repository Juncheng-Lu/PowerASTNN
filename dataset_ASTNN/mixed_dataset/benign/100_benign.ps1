











 -||-> & ( -||-> Join-Path -Path $PSScriptRoot 'Initialize-CarbonTest.ps1' -Resolve <-||- ) <-||- 

 -||-> Describe 'New-Junction' {

     -||-> $JunctionPath = $null <-||- 
     -||-> $tempDir =  -||-> Get-Item -Path 'TestDrive:' <-||-  <-||- 
    
     -||-> BeforeEach {
         -||-> $Global:Error.Clear() <-||- 
         -||-> $JunctionPath =  -||-> Join-Path $tempDir ( -||-> [IO.Path]::GetRandomFileName() <-||- ) <-||-  <-||- 
    } <-||- 
    
     -||-> AfterEach {
         -||-> Get-ChildItem -Path $tempDir |
            Where-Object {  -||-> $_.PsIsContainer -and $_.IsJunction <-||-  } |
            ForEach-Object {  -||-> Remove-Junction -LiteralPath $_.FullName <-||-  } <-||- 
    } <-||- 
    
     -||-> function Invoke-NewJunction($link, $target)
    {
        return  -||-> New-Junction $link $target <-||- 
    } <-||- 
    
     -||-> It 'should create junction' {
         -||-> $result =  -||-> Invoke-NewJunction $JunctionPath $PSScriptRoot <-||-  <-||- 
         -||-> $result | Should Not BeNullOrEmpty <-||- 
         -||-> $JunctionPath | Should Exist <-||- 
         -||-> $result.Attributes -like '*ReparsePoint*' | Should Be $true <-||- 
    } <-||- 
    
     -||-> It 'should not create junction if link is directory' {
         -||-> $error.Clear() <-||- 
         -||-> $result =  -||-> Invoke-NewJunction $PSScriptRoot $tempDir 2> $null <-||-  <-||- 
         -||-> @( -||-> $error <-||- ).Length | Should Be 1 <-||- 
         -||-> $result | Should BeNullOrEmpty <-||- 
    } <-||- 
    
     -||-> It 'should not create junction if junction already exists' {
         -||-> $error.Clear() <-||- 
         -||-> Invoke-NewJunction $JunctionPath $PSScriptRoot <-||- 
         -||-> @( -||-> $error <-||- ).Length | Should Be 0 <-||- 
        
         -||-> $result =  -||-> Invoke-NewJunction $JunctionPath $tempDir 2> $null <-||-  <-||- 
         -||-> @( -||-> $error <-||- ).Length | Should Be 1 <-||- 
         -||-> $result | Should BeNullOrEmpty <-||- 
    } <-||- 

     -||-> It 'should create a junction containing wildcard characters' {
         -||-> $JunctionPath =  -||-> Join-Path -Path $tempDir -ChildPath 'containswildcards[]' <-||-  <-||- 
         -||-> $result =  -||-> New-Junction -Link $JunctionPath -Target $PSScriptRoot <-||-  <-||- 
         -||-> $result | Should BeNullOrEmpty <-||- 
         -||-> $Global:Error.Count | Should Be 0 <-||- 
         -||-> Test-PathIsJunction -LiteralPath $JunctionPath | Should Be $true <-||- 
    } <-||- 

     -||-> It 'should error if creating an existin junction containing wildcard characters' {
         -||-> $JunctionPath =  -||-> Join-Path -Path $tempDir -ChildPath 'containswildcards[]' <-||-  <-||- 
         -||-> New-Junction -Link $JunctionPath -Target $PSScriptRoot <-||- 
         -||-> $Global:Error.Count | Should Be 0 <-||- 
         -||-> New-Junction -Link $JunctionPath -Target $PSScriptRoot -ErrorAction SilentlyContinue <-||- 
         -||-> $Global:Error.Count | Should Be 1 <-||- 
         -||-> $Global:Error | Where {  -||-> $_ -like '*already exists*' <-||-  } | Should Not BeNullOrEmpty <-||- 
    } <-||- 
    
} <-||- 


