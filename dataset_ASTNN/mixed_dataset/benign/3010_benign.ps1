 -||-> Describe "Register-PSFConfigValidation Unit Tests" -Tag "CI", "Pipeline", "Unit" {
	 -||-> BeforeAll {
		 -||-> Get-PSFConfig -Module Register-PSFConfigValidation -Force | ForEach-Object {
			 -||-> $null = [PSFramework.Configuration.ConfigurationHost]::Configurations.Remove($_.FullName) <-||- 
		} <-||- 
	} <-||- 
	 -||-> AfterAll {
		 -||-> Get-PSFConfig -Module Register-PSFConfigValidation -Force | ForEach-Object {
			 -||-> $null = [PSFramework.Configuration.ConfigurationHost]::Configurations.Remove($_.FullName) <-||- 
		} <-||- 
	} <-||- 
	
	
	 -||-> It "Should have the designed for parameters & sets" {
		 -||-> ( -||-> Get-Command Register-PSFConfigValidation <-||- ).ParameterSets.Name | Should -Be '__AllParameterSets' <-||- 
		 -||-> $properties = 'Name', 'ScriptBlock', 'Verbose', 'Debug', 'ErrorAction', 'WarningAction', 'InformationAction', 'ErrorVariable', 'WarningVariable', 'InformationVariable', 'OutVariable', 'OutBuffer', 'PipelineVariable' <-||- 
		 -||-> Compare-Object $properties ( -||-> ( -||-> Get-Command Register-PSFConfigValidation <-||- ).Parameters.Keys | Remove-PSFNull -Enumerate <-||- ) | Should -BeNullOrEmpty <-||- 
	} <-||- 
	
	 -||-> Context "Ensuring validation can be created, assigned and used" {
		
		 -||-> $scriptblock = {
			Param (
				$Value
			)
			
			 -||-> $Result =  -||-> New-Object PSObject -Property @{
				Success =  -||-> $True <-||- 
				Value   =  -||-> $null <-||- 
				Message =  -||-> "" <-||- 
			} <-||-  <-||- 
			
			 -||-> if ( -||-> $Value -notin 0, 1 <-||- )
			{
				 -||-> $Result.Message = "Not a '0' or '1': $Value" <-||- 
				 -||-> $Result.Success = $False <-||- 
				return  -||-> $Result <-||- 
			} <-||- 
						
			 -||-> $Result.Value = [int]$Value <-||- 
			
			return  -||-> $Result <-||- 
		} <-||- 
		
		
		 -||-> It "Should create the validation rule without an issue" {
			 -||-> {  -||-> Register-PSFConfigValidation -Name 'integer0or1' -ScriptBlock $scriptblock <-||-  } | Should -Not -Throw <-||- 
			 -||-> [PSFramework.Configuration.ConfigurationHost]::Validation["integer0or1"] | Should -Be $scriptblock <-||- 
		} <-||- 
		
		
		 -||-> It "Should correctly create new configuration values with this validation" {
			 -||-> $config =  -||-> Set-PSFConfig -FullName 'Register-PSFConfigValidation.Phase1.Setting1' -Value 1 -Validation 'integer0or1' -EnableException -PassThru <-||-  <-||- 
			 -||-> $config.Validation | Should -Be $scriptblock <-||- 
		} <-||- 
		
		
		 -||-> It "Should accept legal input" {
			 -||-> {  -||-> Set-PSFConfig -FullName 'Register-PSFConfigValidation.Phase1.Setting1' -Value 0 -EnableException <-||-  } | Should -Not -Throw <-||- 
		} <-||- 
		
		 -||-> It "Should refuse illegal input" {
			 -||-> {  -||-> Set-PSFConfig -FullName 'Register-PSFConfigValidation.Phase1.Setting1' -Value 2 -EnableException <-||-  } | Should -Throw <-||- 
		} <-||- 
	} <-||- 
} <-||- 

