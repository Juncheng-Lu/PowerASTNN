
[CmdletBinding()]
param (
	[Parameter(Mandatory = $False,
			   ValueFromPipeline = $False,
			   ValueFromPipelineByPropertyName = $False,
			   HelpMessage = 'What site server would you like to connect to?')]
	[string]$Server = 'CONFIGMANAGER',
	[Parameter(Mandatory = $False,
			   ValueFromPipeline = $False,
			   ValueFromPipelineByPropertyName = $False,
			   HelpMessage = 'What site does your ConfigMgr site server exist in?')]
	[string]$Site = 'UHP',
	[Parameter(Mandatory = $True,
			   ValueFromPipeline = $True,
			   ValueFromPipelineByPropertyName = $True,
			   HelpMessage = 'What device collection would you like to get clients from?')]
	[string]$SourceCollectionName,
	[Parameter(Mandatory = $True,
			   ValueFromPipeline = $True,
			   ValueFromPipelineByPropertyName = $True,
			   HelpMessage = 'What device collection would you like to put the random clients into?')]
	[string]$DestinationCollectionName,
	[Parameter(Mandatory = $True,
			   ValueFromPipeline = $False,
			   ValueFromPipelineByPropertyName = $True,
			   HelpMessage = 'How many random clients would you like to put into the destination collection?')]
	[int]$NumberOfClients
)

begin {
	 -||-> try {
		
		
		
		 -||-> $BeforeLocation = ( -||-> Get-Location <-||- ).Path <-||- 
		 -||-> Set-Location "$Site`:" <-||- 
		
		 -||-> $ConfigMgrWmiProps = @{
			'ComputerName' =  -||-> $Server <-||- ;
			'Namespace' =  -||-> "root\sms\site_$Site" <-||- 
		} <-||- 
		
		 -||-> Write-Verbose 'Verifying parameters...' <-||- 
		 -||-> if ( -||-> !( -||-> Get-CmDeviceCollection -Name $SourceCollectionName <-||- ) <-||- ) {
			throw  -||-> "$SourceCollectionName does not exist" <-||- 
		} elseif ( -||-> !( -||-> Get-CmDeviceCollection -Name $DestinationCollectionName <-||- ) <-||- ) {
			throw  -||-> "$DestinationCollectionName does not exist" <-||- 
		} <-||- 
		 -||-> $SourceCollectionId = ( -||-> Get-WmiObject @ConfigMgrWmiProps -Class SMS_Collection -Filter "Name = '$SourceCollectionName'" <-||- ).CollectionId <-||- 
		 -||-> $DestinationCollectionId = ( -||-> Get-WmiObject @ConfigMgrWmiProps -Class SMS_Collection -Filter "Name = '$DestinationCollectionName'" <-||- ).CollectionId <-||- 
		 -||-> $SourceClients =  -||-> Get-WmiObject @ConfigMgrWmiProps -Class "SMS_CM_RES_COLL_$SourceCollectionId" | where {  -||-> $_.DeviceOS -match 'Microsoft Windows NT' <-||-  } | select Name, DeviceOS | group DeviceOS | sort count -Descending <-||-  <-||- 
		 -||-> $ExistingDestinationClients =  -||-> Get-WmiObject @ConfigMgrWmiProps -Class "SMS_CM_RES_COLL_$DestinationCollectionId" | select -ExpandProperty Name <-||-  <-||- 
		 -||-> if ( -||-> $SourceClients.Count -eq 0 <-||- ) {
			throw  -||-> 'Source collection does not contain any members' <-||- 
		} <-||- 
		 -||-> $TargetClients = @() <-||- 
	} catch {
		
		 -||-> Write-Error $_.Exception.Message <-||- 
	} <-||- 
}

process {
	 -||-> try {
		 -||-> if ( -||-> $NumberOfClients -lt $SourceClients.Count <-||- ) {
			 -||-> Write-Verbose "Number of clients needed ($NumberOfClients) are less than total number of operating system groups ($( -||-> $SourceClients.Count <-||- ))..." <-||- 
			
			
			 -||-> $OsGroups = $SourceClients[0..( -||-> $NumberOfClients - 1 <-||- )] <-||- 
		} else {
			 -||-> Write-Verbose "Number of clients needed ($NumberOfClients) are equal to or exceed total operating system groups ($( -||-> $SourceClients.Count <-||- ))..." <-||- 
			 -||-> $OsGroups = $SourceClients <-||- 
		} <-||- 
		 -||-> Write-Verbose "Total OS groupings: $( -||-> $OsGroups.Count <-||- )" <-||- 
		
		
		for ( -||-> $i = 0 <-||- ;  -||-> $TargetClients.Count -lt $NumberOfClients <-||- ;  -||-> $i++ <-||- ) {
			 -||-> $GroupIndex = $i % $OsGroups.Count <-||- 
			 -||-> Write-Verbose "Using group index $GroupIndex..." <-||- 
			 -||-> $OsGroup = $OsGroups[$GroupIndex].Group <-||- 
			 -||-> Write-Verbose "Using group $( -||-> $OsGroups[$GroupIndex].Name <-||- )..." <-||- 
			 -||-> $ClientName = ( -||-> $OsGroups[$GroupIndex].Group | Get-Random <-||- ).Name <-||- 
			 -||-> Write-Verbose "Testing $ClientName for validity to add to target collection..." <-||- 
			 -||-> if ( -||-> ( -||-> $TargetClients -notcontains $ClientName <-||- ) -and ( -||-> $ExistingDestinationClients -notcontains $ClientName <-||- ) -and ( -||-> Test-Ping $ClientName <-||- ) <-||- ) {
				 -||-> Write-Verbose "$ClientName found to be acceptable. Adding to target collection array..." <-||- 
				 -||-> $TargetClients += $ClientName <-||- 
			} <-||- 
		}
		 -||-> Write-Verbose 'Finished checking clients.  Begin adding to target collection...' <-||- 
		
		
		
		 -||-> $TargetClients |
		foreach {
			 -||-> Write-Verbose "Adding $( -||-> $_ <-||- ) to target collection $DestinationCollectionName..." <-||- 
			 -||-> Add-CMDeviceCollectionDirectMembershipRule -CollectionName $DestinationCollectionName -ResourceId ( -||-> Get-CmDevice -Name $_ <-||- ).ResourceID <-||- 
		} <-||- 
	} catch {
		 -||-> Write-Error $_.Exception.Message <-||- 
	} <-||- 
}

end {
	 -||-> Set-Location $BeforeLocation <-||- 
}

