 -||-> Describe "Validating the module manifest" {
	 -||-> $moduleRoot = ( -||-> Resolve-Path "$PSScriptRoot\..\.." <-||- ).Path <-||- 
	 -||-> $manifest =  -||-> ( -||-> ( -||-> Get-Content "$moduleRoot\PSFramework.psd1" <-||- ) -join "`n" <-||- ) | Invoke-Expression <-||-  <-||- 
	 -||-> Context "Basic resources validation" {
		 -||-> $files =  -||-> Get-ChildItem "$moduleRoot\functions" -Recurse -File -Filter "*.ps1" <-||-  <-||- 
		 -||-> It "Exports all functions in the public folder" {
			
			 -||-> $functions = ( -||-> Compare-Object -ReferenceObject $files.BaseName -DifferenceObject $manifest.FunctionsToExport | Where-Object SideIndicator -Like '<=' <-||- ).InputObject <-||- 
			 -||-> $functions | Should -BeNullOrEmpty <-||- 
		} <-||- 
		 -||-> It "Exports no function that isn't also present in the public folder" {
			 -||-> $functions = ( -||-> Compare-Object -ReferenceObject $files.BaseName -DifferenceObject $manifest.FunctionsToExport | Where-Object SideIndicator -Like '=>' <-||- ).InputObject <-||- 
			 -||-> $functions | Should -BeNullOrEmpty <-||- 
		} <-||- 
		
		 -||-> It "Exports none of its internal functions" {
			 -||-> $files =  -||-> Get-ChildItem "$moduleRoot\internal\functions" -Recurse -File -Filter "*.ps1" <-||-  <-||- 
			 -||-> $files | Where-Object BaseName -In $manifest.FunctionsToExport | Should -BeNullOrEmpty <-||- 
		} <-||- 
	} <-||- 
	
	 -||-> Context "Individual file validation" {
		 -||-> It "The root module file exists" {
			 -||-> Test-Path "$moduleRoot\$( -||-> $manifest.RootModule <-||- )" | Should -Be $true <-||- 
		} <-||- 
		
		 -||-> foreach ($format in  -||-> $manifest.FormatsToProcess <-||- )
		{
			 -||-> It "The file $format should exist" {
				 -||-> Test-Path "$moduleRoot\$format" | Should -Be $true <-||- 
			} <-||- 
		} <-||- 
		
		 -||-> foreach ($type in  -||-> $manifest.TypesToProcess <-||- )
		{
			 -||-> It "The file $type should exist" {
				 -||-> Test-Path "$moduleRoot\$type" | Should -Be $true <-||- 
			} <-||- 
		} <-||- 
		
		 -||-> foreach ($assembly in  -||-> $manifest.RequiredAssemblies <-||- )
		{
			 -||-> It "The file $assembly should exist" {
				 -||-> Test-Path "$moduleRoot\$assembly" | Should -Be $true <-||- 
			} <-||- 
		} <-||- 
	} <-||- 
} <-||- 

