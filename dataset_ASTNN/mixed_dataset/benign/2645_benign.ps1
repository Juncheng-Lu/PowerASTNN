
    
    
    
    
    
    
    
    
    
    


 -||-> . "$PSScriptRoot\TestExplorer.ps1" <-||- 

 -||-> function Create-HelperModule(
    [string] $moduleDir,
    [string] $moduleName,
    [string] $archiveDir) {

     -||-> if( -||-> -not ( -||-> Test-Path $archiveDir <-||- ) <-||- ) {
         -||-> $null =  -||-> New-Item -ItemType directory -Path $archiveDir -ErrorAction Stop <-||-  <-||- 
    } <-||- 
     -||-> $archivePath =   -||-> Join-Path $archiveDir "$moduleName.zip" <-||-  <-||- 
     -||-> if ( -||-> Test-Path $archivePath <-||- ) {
         -||-> $null =  -||-> Remove-Item $archivePath -ErrorAction Stop <-||-  <-||- 
    } <-||- 
     -||-> $moduleFilePath =  -||-> Join-Path $moduleDir "$moduleName.psm1" <-||-  <-||- 
     -||-> Write-Verbose "Creating $archivePath..." <-||- 
     -||-> $null =  -||-> Compress-Archive -LiteralPath $moduleFilePath -DestinationPath $archivePath -ErrorAction Stop <-||-  <-||- 
     -||-> Write-Verbose "$archivePath created." <-||- 
} <-||- 

 -||-> function Create-SmokeTestModule(
    [string] $srcPath,
    [string] $archiveDir,
    [string] $moduleName,
    [string[]] $projectList) {

     -||-> if ( -||-> -not ( -||-> Test-Path $archiveDir <-||- ) <-||- ) {
         -||-> $null =  -||-> New-Item -ItemType directory -Path $archiveDir -ErrorAction Stop <-||-  <-||- 
    } <-||- 
     -||-> $files =  -||-> New-Object System.Collections.ArrayList <-||-  <-||- 
     -||-> Write-Verbose "Adding .ps1 common test files from /tools/ScenarioTest.ResourceManager..." <-||- 
     -||-> $rmCommonFileNames = 'Common.ps1', 'Assert.ps1' <-||- 
     -||-> 'Common.ps1', 'Assert.ps1' | ForEach-Object {
         -||-> $rmFilename = $_ <-||-  
         -||-> $rmCommonFilePath =  -||-> Join-Path $srcPath ".." "tools" "ScenarioTest.ResourceManager" $rmFilename <-||-  <-||- 
         -||-> if( -||-> Test-Path $rmCommonFilePath <-||- ){
             -||-> $null = $files.Add(( -||-> Copy-Item $rmCommonFilePath  ( -||-> Join-Path $archiveDir $rmFilename <-||- ) -PassThru -ErrorAction Stop <-||- )) <-||- 
        } else {
             -||-> Write-Warning "!!! Common resource management file not found: $rmCommonFilePath" <-||- 
        } <-||- 
    } <-||- 

     -||-> Write-Verbose "Gathering .ps1 test file list from $srcPath..." <-||- 
     -||-> $commonFileName = 'Common.ps1' <-||- 
     -||-> foreach($folder in  -||-> Get-TestFolders $srcPath $projectList <-||- ) {
         -||-> $null = $files.AddRange(@( -||-> Filter-TestFiles $folder.Path <-||- )) <-||- 
         -||-> $commonFilePath =  -||-> Join-Path $folder.Path $commonFileName <-||-  <-||- 
         -||-> if( -||-> Test-Path $commonFilePath <-||- ){
            
             -||-> $null = $files.Add(( -||-> Copy-Item $commonFilePath "$archiveDir\$( -||-> $folder.Name <-||- )$commonFileName" -PassThru -ErrorAction Stop <-||- )) <-||- 
        } <-||- 
        
         -||-> $null = $files.AddRange(@( -||-> Get-ChildItem -Path $folder.Path -Filter "*$commonFileName" -ErrorAction Stop | Where-Object {  -||-> $_.Name -ine $commonFileName <-||-  } <-||- )) <-||- 
         -||-> if( -||-> $folder.Name -eq 'Resources' <-||- ) {
             -||-> $null = $files.AddRange(@( -||-> Get-ChildItem "$( -||-> $folder.Path <-||- )\..\" -Filter "*.json" -ErrorAction Stop <-||- )) <-||- 
        } <-||- 
    } <-||- 

    
     -||-> $moduleFile =  -||-> New-Item "$archiveDir\$moduleName.psm1" -type file <-||-  <-||- 
     -||-> $files | Where-Object {  -||-> $_.Name -like '*.ps1' <-||-  } `
        | ForEach-Object { -||-> '. "$PSScriptRoot\' + $_.Name + '"' <-||- } `
        | Add-Content $moduleFile.FullName -ErrorAction Stop <-||- 
     -||-> $null = $files.Add($moduleFile) <-||- 

     -||-> $zipPath = "$archiveDir\$moduleName.zip" <-||- 
     -||-> if( -||-> Test-Path $zipPath <-||- ) {
         -||-> Remove-Item $zipPath -Force -ErrorAction Stop <-||- 
    } <-||- 
     -||-> Write-Verbose "Creating $zipPath..." <-||- 
     -||-> $files | Compress-Archive -CompressionLevel Fastest -DestinationPath $zipPath -ErrorAction Stop <-||- 
     -||-> Write-Verbose "$zipPath created." <-||- 

     -||-> Get-ChildItem -Path $archiveDir -Filter "*.ps*" | Remove-Item -Force -ErrorAction Stop <-||- 
} <-||- 



 -||-> function Convert-NupkgToZip (
    [string] $path,
    [string[]] $moduleList,
    [string] $outputPath) {
   
     -||-> if ( -||-> -not ( -||-> Test-Path $outputPath <-||- ) <-||- ) {
         -||-> $null =  -||-> New-Item -ItemType directory -Path $outputPath -ErrorAction Stop <-||-  <-||- 
    } <-||- 

     -||-> $modulePathFilters =  -||-> $moduleList | ForEach-Object {
        
         -||-> $nupkgPath =  -||-> Join-Path $path "${_}.[0-9]*.nupkg" <-||-  <-||- 
         -||-> @{Name =  -||-> $_ <-||- ; Path =  -||-> $nupkgPath <-||- ; Exists =  -||-> Test-Path $nupkgPath <-||- } <-||- 
    } <-||-  <-||- 
    
     -||-> $notFound = ( -||-> $modulePathFilters | ForEach-Object {  -||-> $_.Exists <-||-  } <-||- ) -contains $false <-||- 
     -||-> if ( -||-> $notFound <-||- ) {
         -||-> $missingModules =  -||-> $modulePathFilters | Where-Object {  -||-> -not $_.Exists <-||-  } | ForEach-Object {  -||-> $_.Name <-||-  } <-||-  <-||- 
        throw  -||-> "Cannot find modules ($missingModules) in the directory '$path'" <-||- 
    } <-||- 

     -||-> $packages =  -||-> $modulePathFilters | ForEach-Object {  -||-> @{Name =  -||-> $_.Name <-||- ; File =  -||-> ( -||-> Get-ChildItem $_.Path | Select-Object -Last 1 <-||- ) <-||- } <-||-  } <-||-  <-||- 
     -||-> foreach ($package in  -||-> $packages <-||- ) {
         -||-> $zipPath =  -||-> Join-Path $outputPath "$( -||-> $package.Name <-||- ).zip" <-||-  <-||- 
         -||-> if( -||-> Test-Path $zipPath <-||- ) {
             -||-> Remove-Item $zipPath -Force -ErrorAction Stop <-||- 
        } <-||- 
         -||-> Copy-Item $package.File.FullName $zipPath <-||- 
    } <-||- 
} <-||- 

 -||-> function Get-LatestBuildPath([string] $searchPath) {
     -||-> $folderSuffix = '_PowerShell' <-||- 
    
     -||-> Get-ChildItem $searchPath -Directory -Filter "*$folderSuffix" `
        | ForEach-Object -Begin { 
             -||-> $date = [DateTime]::MinValue.ToString('yyyy_MM_dd') <-||- 
             -||-> $path = $null <-||- 
        } -Process { 
             -||-> $folderDateText = $_.Name -ireplace "$folderSuffix`$", '' <-||- 
             -||-> if( -||-> $folderDateText -gt $date <-||- ) { 
                 -||-> $date = $folderDateText <-||- 
                 -||-> $path = $_ <-||- 
            } <-||- 
        } -End {  -||-> $path <-||-  } <-||- 
} <-||- 

 -||-> function Create-SignedModules([hashtable] $signedModules, [string] $modulesDir, [string] $archiveDir) {
     -||-> if( -||-> [string]::IsNullOrEmpty($modulesDir) <-||- ) {
         -||-> $latestBuildPath =  -||-> Get-LatestBuildPath -searchPath '\\aaptfile01\ADXSDK\PowerShell' <-||-  <-||- 
         -||-> Write-Verbose "Latest drop path found: $( -||-> $latestBuildPath.FullName <-||- )" <-||- 
         -||-> $modulesDir =  -||-> Join-Path $latestBuildPath.FullName 'pkgs' <-||-  <-||- 
    } <-||- 
     -||-> Convert-NupkgToZip `
        -path $modulesDir `
        -moduleList ( -||-> $signedModules.Accounts + $signedModules.Other <-||- ) `
        -outputPath $archiveDir <-||- 
     -||-> Write-Verbose "Signed module zips created in '$archiveDir'." <-||- 
} <-||- 

