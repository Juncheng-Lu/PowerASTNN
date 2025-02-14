

 -||-> Describe "Remove-PSBreakpoint" -Tags "CI" {
    
     -||-> $testScript =  -||-> Join-Path -Path ( -||-> Join-Path -Path $PSScriptRoot -ChildPath assets <-||- ) -ChildPath psbreakpointtestscript.ps1 <-||-  <-||- 

     -||-> $script = "`$var = 1
`$var2 = Get-Command


Get-Date
" <-||- 

     -||-> $script > $testScript <-||- 

     -||-> BeforeEach {
	
	 -||-> $line     =  -||-> Set-PSBreakpoint -Line 1,2,3 -Script $testScript <-||-  <-||- 
	 -||-> $command  =  -||-> Set-PSBreakpoint -Command "Get-Date" -Script $testScript <-||-  <-||- 
	 -||-> $variable =  -||-> Set-PSBreakpoint -Variable var2 -Script $testScript <-||-  <-||- 
    } <-||- 

     -||-> Context "Basic Removal Methods Tests" {
	 -||-> It "Should be able to remove a breakpoint by breakpoint Id" {
	     -||-> $NumberOfBreakpoints = $( -||-> Get-PSBreakpoint <-||- ).Id.length <-||- 
	     -||-> $BreakID = $( -||-> Get-PSBreakpoint <-||- ).Id[0] <-||- 
	     -||-> Remove-PSBreakpoint -Id $BreakID <-||- 

	     -||-> $( -||-> Get-PSBreakpoint <-||- ).Id.length | Should -Be ( -||-> $NumberOfBreakpoints -1 <-||- ) <-||- 
	} <-||- 

	 -||-> It "Should be able to remove a breakpoint by variable" {
	     -||-> $NumberOfBreakpoints = $( -||-> Get-PSBreakpoint <-||- ).Id.length <-||- 
	     -||-> Remove-PSBreakpoint -Breakpoint $variable <-||- 

	     -||-> $( -||-> Get-PSBreakpoint <-||- ).Id.length | Should -Be ( -||-> $NumberOfBreakpoints -1 <-||- ) <-||- 
	} <-||- 

	 -||-> It "Should be able to remove a breakpoint by command" {
	     -||-> $NumberOfBreakpoints = $( -||-> Get-PSBreakpoint <-||- ).Id.length <-||- 
	     -||-> Remove-PSBreakpoint -Breakpoint $command <-||- 

	     -||-> $( -||-> Get-PSBreakpoint <-||- ).Id.length | Should -Be ( -||-> $NumberOfBreakpoints -1 <-||- ) <-||- 
	} <-||- 

	 -||-> It "Should be able to pipe breakpoint objects to Remove-PSBreakpoint" {
	     -||-> $NumberOfBreakpoints = $( -||-> Get-PSBreakpoint <-||- ).Id.length <-||- 
	     -||-> $variable | Remove-PSBreakpoint <-||- 

	     -||-> $( -||-> Get-PSBreakpoint <-||- ).Id.length | Should -Be ( -||-> $NumberOfBreakpoints -1 <-||- ) <-||- 
	} <-||- 
    } <-||- 

     -||-> It "Should Remove all breakpoints" {
	 -||-> $( -||-> Get-PSBreakpoint <-||- ).Id.Length | Should -Not -BeNullOrEmpty <-||- 

	 -||-> Get-PSBreakpoint | Remove-PSBreakpoint <-||- 

	 -||-> $( -||-> Get-PSBreakpoint <-||- ).Id.Length | Should -Be 0 <-||- 
    } <-||- 

    

     -||-> Remove-Item $testScript <-||- 
} <-||- 


