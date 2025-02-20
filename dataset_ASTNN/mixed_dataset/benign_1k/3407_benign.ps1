 -||-> Register-PSFTeppScriptblock -Name 'PSFramework-LanguageNames' -ScriptBlock {
	 -||-> [System.Globalization.CultureInfo]::GetCultures([System.Globalization.CultureTypes]::AllCultures).Name | Where-Object {  -||-> $_ -and ( -||-> $_.Trim() <-||- ) <-||-  } <-||- 
} <-||- 

 -||-> Register-PSFTeppScriptblock -Name 'PSFramework-LocalizedStrings-Names' -ScriptBlock {
	 -||-> ( -||-> [PSFRamework.Localization.LocalizationHost]::Strings.Values | Where-Object Module -EQ $fakeBoundParameter.Module <-||- ).Name <-||- 
} <-||- 

 -||-> Register-PSFTeppScriptblock -Name 'PSFramework-LocalizedStrings-Modules' -ScriptBlock {
	 -||-> [PSFRamework.Localization.LocalizationHost]::Strings.Values.Module | Select-Object -Unique <-||- 
} <-||- 

