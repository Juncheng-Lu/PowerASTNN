















     -||-> function Test-ConfigurationPipelining{
        
		 -||-> $config =  -||-> New-AzHDInsightClusterConfig -ClusterType Hadoop -ClusterTier Standard <-||-  <-||- 
		 -||-> Assert-NotNull $config.ClusterType <-||- 
		 -||-> Assert-NotNull $config.ClusterTier <-||- 
		
		
		 -||-> Assert-AreEqual $config.AdditionalStorageAccounts.Count 0 <-||- 
		 -||-> $config =  -||-> $config | Add-AzHDInsightStorage -StorageAccountName fakestorageaccount -StorageAccountKey STORAGEACCOUNTKEY== <-||-  <-||- 
		 -||-> Assert-AreEqual $config.AdditionalStorageAccounts.Count 1 <-||- 
		
		
		 -||-> Assert-AreEqual $config.Configurations.Count 0 <-||- 
		 -||-> Assert-Null $config.Configurations["core-site"] <-||- 
		 -||-> $coreconfig =  -||-> New-Object "System.Collections.Generic.Dictionary``2[System.String,System.String]" <-||-  <-||- 
		 -||-> $coreconfig.Add('coreconfig', 'corevalue') <-||- 
		 -||-> Assert-Null $config.Configurations["core-site"] <-||- 
		 -||-> $config =  -||-> $config | Add-AzHDInsightConfigValues -Core $coreconfig <-||-  <-||- 
		 -||-> Assert-NotNull $config.Configurations["core-site"] <-||- 

		 -||-> $oozieconfig =  -||-> New-Object "System.Collections.Generic.Dictionary``2[System.String,System.String]" <-||-  <-||- 
		 -||-> $oozieconfig.Add('oozieconfig', 'oozievalue') <-||- 
		 -||-> Assert-Null $config.Configurations["oozie-site"] <-||- 
		 -||-> $config =  -||-> $config | Add-AzHDInsightConfigValues -OozieSite $coreconfig <-||-  <-||- 
		 -||-> Assert-NotNull $config.Configurations["oozie-site"] <-||- 

		
		 -||-> Assert-Null $config.OozieMetastore <-||- 
		 -||-> Assert-Null $config.HiveMetastore <-||- 
		 -||-> $secpasswd =  -||-> ConvertTo-SecureString "PlainTextPassword" -AsPlainText -Force <-||-  <-||- 
		 -||-> $mycreds =  -||-> New-Object System.Management.Automation.PSCredential ( -||-> "username", $secpasswd <-||- ) <-||-  <-||- 
		 -||-> $config =  -||-> $config | Add-AzHDInsightMetastore -MetastoreType HiveMetastore -SqlAzureServerName server.server.server -DatabaseName dbname -Credential $mycreds <-||-  <-||- 
		 -||-> Assert-NotNull $config.HiveMetastore <-||- 
		 -||-> Assert-Null $config.OozieMetastore <-||- 

		
		 -||-> Assert-AreEqual $config.ScriptActions.Count 0 <-||- 
		 -||-> Assert-Null $config.ScriptActions["WorkerNode"] <-||- 
		 -||-> $config =  -||-> $config | Add-AzHDInsightScriptAction -NodeType WorkerNode -Uri "http://uri.com" -Name "scriptaction" -Parameters "parameters" <-||-  <-||- 
		 -||-> Assert-AreEqual $config.ScriptActions.Count 1 <-||- 
		 -||-> Assert-AreEqual $config.ScriptActions["WorkerNode"].Count 1 <-||- 
		 -||-> $config =  -||-> $config | Add-AzHDInsightScriptAction -NodeType WorkerNode -Uri "http://uri.com" -Name "scriptaction2" -Parameters "parameters" <-||-  <-||- 
		 -||-> Assert-AreEqual $config.ScriptActions.Count 1 <-||- 
		 -||-> Assert-AreEqual $config.ScriptActions["WorkerNode"].Count 2 <-||- 

		
		 -||-> Assert-Null $config.DefaultStorageAccountName <-||- 
		 -||-> Assert-Null $config.DefaultStorageAccountKey <-||- 
		 -||-> $config =  -||-> $config | Set-AzHDInsightDefaultStorage -StorageAccountName fakedefaultaccount -StorageAccountKey DEFAULTACCOUNTKEY== <-||-  <-||- 
		 -||-> Assert-NotNull $config.DefaultStorageAccountName <-||- 
		 -||-> Assert-NotNull $config.DefaultStorageAccountKey <-||- 

		
		 -||-> $componentName="Spark" <-||- 
		 -||-> $componentVersion="2.3" <-||- 
		 -||-> $config= -||-> $config | Add-AzHDInsightComponentVersion -ComponentName $componentName -ComponentVersion $componentVersion <-||-  <-||- 
		 -||-> Assert-AreEqual $config.ComponentVersion[$componentName] $componentVersion <-||- 

		
		 -||-> $objectId= -||-> New-Guid <-||-  <-||- 
		 -||-> $certificateFilePath="testhost:/testpath/" <-||- 
		 -||-> $certificatePassword="testpassword123@" <-||- 
		 -||-> $aadTenantId= -||-> New-Guid <-||-  <-||- 
		 -||-> $config= -||-> $config | Add-AzHDInsightClusterIdentity -ObjectId $objectId -CertificateFilePath $certificateFilePath `
		-CertificatePassword $certificatePassword -AadTenantId $aadTenantId <-||-  <-||- 
		 -||-> Assert-AreEqual $config.CertificatePassword $certificatePassword <-||- 

		
		 -||-> Assert-Null $config.SecurityProfile <-||- 
		 -||-> $domain = "sampledomain.onmicrosoft.com" <-||- 
		 -||-> $domainUser = "sample.user@sampledomain.onmicrosoft.com" <-||- 
		 -||-> $domainPassword =  -||-> ConvertTo-SecureString "domainPassword" -AsPlainText -Force <-||-  <-||- 
		 -||-> $domainUserCredential =  -||-> New-Object System.Management.Automation.PSCredential( -||-> $domainUser, $domainPassword <-||- ) <-||-  <-||- 
		 -||-> $organizationalUnitDN = "ou=testunitdn" <-||- 
		 -||-> $ldapsUrls = ( -||-> "ldaps://sampledomain.onmicrosoft.com:636","ldaps://sampledomain.onmicrosoft.com:389" <-||- ) <-||- 
		 -||-> $clusterUsersGroupDNs = ( -||-> "groupdn1","groupdn2" <-||- ) <-||- 
		 -||-> $config =  -||-> $config | Add-AzHDInsightSecurityProfile -Domain $domain -DomainUserCredential $domainUserCredential -OrganizationalUnitDN $organizationalUnitDN -LdapsUrls $ldapsUrls -ClusterUsersGroupDNs $clusterUsersGroupDNs <-||-  <-||-  
		 -||-> Assert-AreEqual $config.SecurityProfile.Domain $domain <-||- 
		 -||-> Assert-NotNull $config.SecurityProfile.LdapsUrls <-||- 
    } <-||- 

