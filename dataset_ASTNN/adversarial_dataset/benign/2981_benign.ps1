

















 -||-> $subscriptionId ="302110e3-cd4e-4244-9874-07c91853c809" <-||- 
 -||-> $reservationOrderId = "704aee8c-c906-47c7-bd22-781841fb48b5" <-||- 
 -||-> $reservationId = "ac7f6b04-ff45-4da1-83f3-b0f2f6c8128e" <-||- 


 -||-> function Test-GetCatalog
{
	
	 -||-> $catalog =  -||-> Get-AzReservationCatalog -SubscriptionId $subscriptionId -ReservedResourceType VirtualMachines -Location westus <-||-  <-||- 
	 -||-> Foreach ($item in  -||-> $catalog <-||- )
	{
		 -||-> Assert-NotNull $item.ResourceType <-||- 
		 -||-> Assert-NotNull $item.Name <-||- 
		 -||-> Assert-True {  -||-> $item.Terms.Count -gt 0 <-||-  } <-||- 
		 -||-> Assert-True {  -||-> $item.Locations.Count -gt 0 <-||-  } <-||- 
	} <-||- 

	
	 -||-> $catalog =  -||-> Get-AzReservationCatalog -SubscriptionId $subscriptionId -ReservedResourceType SuseLinux <-||-  <-||- 
	 -||-> Foreach ($item in  -||-> $catalog <-||- )
	{
		 -||-> Assert-NotNull $item.ResourceType <-||- 
		 -||-> Assert-NotNull $item.Name <-||- 
		 -||-> Assert-Null $item.Locations <-||- 
		 -||-> Assert-True {  -||-> $item.Terms.Count -gt 0 <-||-  } <-||- 
	} <-||- 

	
	 -||-> $catalog =  -||-> Get-AzReservationCatalog -SubscriptionId $subscriptionId -ReservedResourceType SqlDatabases -Location southeastasia <-||-  <-||- 
	 -||-> Foreach ($item in  -||-> $catalog <-||- )
	{
		 -||-> Assert-NotNull $item.ResourceType <-||- 
		 -||-> Assert-NotNull $item.Name <-||- 
		 -||-> Assert-True {  -||-> $item.Terms.Count -gt 0 <-||-  } <-||- 
		 -||-> Assert-True {  -||-> $item.Locations.Count -gt 0 <-||-  } <-||- 
	} <-||- 

    
	 -||-> $catalog =  -||-> Get-AzReservationCatalog -SubscriptionId $subscriptionId -ReservedResourceType CosmosDb <-||-  <-||- 
	 -||-> Foreach ($item in  -||-> $catalog <-||- )
	{
		 -||-> Assert-NotNull $item.ResourceType <-||- 
		 -||-> Assert-NotNull $item.Name <-||- 
		 -||-> Assert-True {  -||-> $item.Terms.Count -gt 0 <-||-  } <-||- 
		 -||-> Assert-Null $item.Locations <-||- 
	} <-||- 
} <-||- 


 -||-> function Test-GetReservationOrderId
{
	 -||-> $appliedReservations =  -||-> Get-AzReservationOrderId -SubscriptionId $subscriptionId <-||-  <-||- 

	 -||-> $name = "default" <-||- 
	 -||-> $type = "Microsoft.Capacity/AppliedReservations" <-||- 
	 -||-> $id = "/subscriptions/" + $subscriptionId + "/providers/microsoft.capacity/AppliedReservations/default" <-||- 

	 -||-> Assert-AreEqual $id $appliedReservations.Id <-||- 
	 -||-> Assert-AreEqual $name $appliedReservations.Name <-||- 
	 -||-> Assert-AreEqual $type $appliedReservations.Type <-||- 
} <-||- 


 -||-> function Test-SplitReservation
{
	 -||-> $type = "Microsoft.Capacity/reservationOrders/reservations" <-||- 

	 -||-> $splitResult =  -||-> Split-AzReservation -ReservationOrderId $reservationOrderId -ReservationId $reservationId -Quantity 1,1 <-||-  <-||- 
	 -||-> Foreach ($splitItem in  -||-> $splitResult <-||- )
	{
		 -||-> Assert-NotNull $splitItem <-||- 
		 -||-> Assert-True {  -||-> $splitItem.Etag -gt 0 <-||- } <-||- 
		 -||-> Assert-NotNull $splitItem.Id <-||- 
		 -||-> Assert-NotNull $splitItem.Name <-||- 
		 -||-> Assert-NotNull $splitItem.Sku <-||- 
		 -||-> Assert-AreEqual $splitItem.Type $type <-||- 	 
	} <-||- 
} <-||- 


 -||-> function Test-MergeReservation
{
	 -||-> $reservationId1 = "efcd2077-baa6-4be3-8190-2b9ba939c8bc" <-||- 
	 -||-> $reservationId2 = "0281e256-5b31-424a-8df8-e67f6531113a" <-||- 
	 -||-> $type = "Microsoft.Capacity/reservationOrders/reservations" <-||- 
	 -||-> $mergeResult =  -||-> Merge-AzReservation -ReservationOrderId $reservationOrderId -ReservationId $reservationId1,$reservationId2 <-||-  <-||- 
	 -||-> Foreach ($mergeItem in  -||-> $mergeResult <-||- )
	{
		 -||-> Assert-NotNull $mergeItem <-||- 
		 -||-> Assert-True {  -||-> $mergeItem.Etag -gt 0 <-||- } <-||- 
		 -||-> Assert-NotNull $mergeItem.Id <-||- 
		 -||-> Assert-NotNull $mergeItem.Name <-||- 
		 -||-> Assert-NotNull $mergeItem.Sku <-||- 
		 -||-> Assert-AreEqual $mergeItem.Type $type <-||- 	 
	} <-||- 
} <-||- 
	

 -||-> function Test-GetReservation
{
	 -||-> $name = $reservationOrderId + '/' + $reservationId <-||- 
	 -||-> $type = "Microsoft.Capacity/reservationOrders/reservations" <-||- 
	 -||-> $id = "/providers/microsoft.capacity/reservationOrders/" + $reservationOrderId + "/reservations/" + $reservationId <-||- 

	 -||-> $reservationItem =  -||-> Get-AzReservation -ReservationOrderId $reservationOrderId -ReservationId $reservationId <-||-  <-||- 

	 -||-> Assert-NotNull $reservationItem <-||- 
	 -||-> Assert-NotNull $reservationItem.Etag <-||- 
	 -||-> Assert-AreEqual $reservationItem.Id $id <-||- 
	 -||-> Assert-AreEqual $reservationItem.Name $name <-||- 
	 -||-> Assert-NotNull $reservationItem.Sku <-||- 
	 -||-> Assert-AreEqual $reservationItem.Type $type <-||- 	 

	
} <-||- 


 -||-> function Test-UpdateReservationToShared
{
	 -||-> $type = "Microsoft.Capacity/reservationOrders/reservations" <-||- 

	 -||-> $reservationItem =  -||-> Update-AzReservation -ReservationOrderId $reservationOrderId -ReservationId $reservationId -appliedscopetype Shared -InstanceFlexibility On <-||-  <-||- 

	 -||-> Assert-NotNull $reservationItem <-||- 
	 -||-> Assert-NotNull $reservationItem.Etag <-||- 

	 -||-> $name = $reservationOrderId + '/' + $reservationId <-||- 
	 -||-> $id = "/providers/microsoft.capacity/reservationOrders/" + $reservationOrderId + "/reservations/" + $reservationId <-||- 

	 -||-> Assert-AreEqual $reservationItem.Id $id <-||- 
	 -||-> Assert-AreEqual $reservationItem.Name $name <-||- 
	 -||-> Assert-NotNull $reservationItem.Sku <-||- 
	 -||-> Assert-AreEqual $reservationItem.Type $type <-||- 	 
} <-||- 
	

 -||-> function Test-UpdateReservationToSingle
{
	 -||-> $type = "Microsoft.Capacity/reservationOrders/reservations" <-||- 
	 -||-> $subscription = "/subscriptions/302110e3-cd4e-4244-9874-07c91853c809" <-||- 

	 -||-> $reservationItem =  -||-> Update-AzReservation -ReservationOrderId $reservationOrderId -ReservationId $reservationId -appliedscopetype Single -appliedscope $subscription -InstanceFlexibility On <-||-  <-||- 

	 -||-> Assert-NotNull $reservationItem <-||- 
	 -||-> Assert-NotNull $reservationItem.Etag <-||- 

	 -||-> $name = $reservationOrderId + '/' + $reservationId <-||- 
	 -||-> $id = "/providers/microsoft.capacity/reservationOrders/" + $reservationOrderId + "/reservations/" + $reservationId <-||- 

	 -||-> Assert-AreEqual $reservationItem.Id $id <-||- 
	 -||-> Assert-AreEqual $reservationItem.Name $name <-||- 
	 -||-> Assert-NotNull $reservationItem.Sku <-||- 
	 -||-> Assert-AreEqual $reservationItem.Type $type <-||- 	
} <-||- 


 -||-> function Test-ListReservations
{
	 -||-> $name = $reservationOrderId + '/' + $reservationId <-||- 
	 -||-> $type = "Microsoft.Capacity/reservationOrders/reservations" <-||- 
	 -||-> $id = "/providers/microsoft.capacity/reservationOrders/" + $reservationOrderId + "/reservations/" + $reservationId <-||- 

	 -||-> $reservations =  -||-> Get-AzReservation -ReservationOrderId $reservationOrderId <-||-  <-||- 

	 -||-> Foreach($reservation in  -||-> $reservations <-||- )
	{
		 -||-> Assert-NotNull $reservation <-||- 
		 -||-> Assert-NotNull $reservation.Etag <-||- 
		 -||-> Assert-NotNull $reservation.Id <-||- 
		 -||-> Assert-NotNull $reservation.Name <-||- 
		 -||-> Assert-NotNull $reservation.Sku <-||- 
		 -||-> Assert-AreEqual $reservation.Type $type <-||- 
	} <-||- 
} <-||- 


 -||-> function Test-ListReservationHistory
{
	 -||-> $type = "Microsoft.Capacity/reservationOrders/reservations/revisions" <-||- 

	 -||-> $reservationItemList =  -||-> Get-AzReservationHistory -ReservationOrderId $reservationOrderId -ReservationId $reservationId <-||-  <-||- 

	 -||-> Assert-NotNull $reservationItemList <-||- 
	 -||-> Assert-True { -||-> $reservationItemList.Count -ge 1 <-||- } <-||- 

	 -||-> $reservationItem = $reservationItemList[0] <-||- 
	 -||-> Assert-NotNull $reservationItem.Etag <-||- 

	 -||-> $name = $reservationOrderId + '/' + $reservationId + '/' + $reservationItem.Etag <-||- 
	 -||-> $id = "/providers/microsoft.capacity/reservationOrders/" + $reservationOrderId + "/reservations/" + $reservationId + "/revisions/" + $reservationItem.Etag <-||- 

	 -||-> Assert-AreEqual $reservationItem.Id $id <-||- 
	 -||-> Assert-AreEqual $reservationItem.Name $name <-||- 
	 -||-> Assert-NotNull $reservationItem.Sku <-||- 
	 -||-> Assert-AreEqual $reservationItem.Type $type <-||- 
} <-||- 

