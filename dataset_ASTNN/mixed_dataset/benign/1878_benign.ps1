
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$False,Position=0)]
        [ValidateSet("MD5","SHA1","SHA256","SHA384","SHA512","RIPEMD160")]
        [string]$HashType = "SHA256",
    [Parameter(Mandatory=$True,Position=1)]
        
        [string[]]$Paths = @( -||-> "C:\Windows\*\xwizard.exe", "C:\users\*\AppData\Roaming\OpenCandy\EA88941C48E54CDE9CF90AD273C131BF\MixiCND_CID4.exe" <-||- )
) 

 -||-> $ErrorActionPreference = "Continue" <-||- 

 -||-> function Get-Hashes {
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory=$True,Position=0)]
			[ValidateSet("MD5","SHA1","SHA256","SHA384","SHA512","RIPEMD160")]
			[string]$HashType = "MD5",
        [Parameter(Mandatory=$True,Position=1)]
            [string[]]$Files
	)

	 -||-> $hashList = @() <-||- 
	
	switch -CaseSensitive ( -||-> $HashType <-||- ) {
		"MD5"       {  -||-> $hash = [System.Security.Cryptography.MD5]::Create() <-||-  }
		"SHA1"      {  -||-> $hash = [System.Security.Cryptography.SHA1]::Create() <-||-  }
		"SHA256"    {  -||-> $hash = [System.Security.Cryptography.SHA256]::Create() <-||-  }
		"SHA384"    {  -||-> $hash = [System.Security.Cryptography.SHA384]::Create() <-||-  }
		"SHA512"    {  -||-> $hash = [System.Security.Cryptography.SHA512]::Create() <-||-  }
		"RIPEMD160" {  -||-> $hash = [System.Security.Cryptography.RIPEMD160]::Create() <-||-  }
	}
	
     -||-> foreach ($file in  -||-> $Files <-||- ) {
       
		 -||-> Write-Debug -Message "Calculating hash of ${File}." <-||- 
		 -||-> if ( -||-> Test-Path -Path $File -PathType Leaf <-||- ) {
             -||-> ls $File -Force | Foreach-Object {
                 -||-> $FileData = [System.IO.File]::ReadAllBytes($_.FullName) <-||- 
                 -||-> $HashBytes = $hash.ComputeHash($FileData) <-||- 
                 -||-> $paddedHex = "" <-||- 
                 -||-> foreach ($byte in  -||-> $HashBytes <-||- ) {
				     -||-> $byteInHex = [String]::Format("{0:X}", $byte) <-||- 
				     -||-> $paddedHex += $byteInHex.PadLeft(2,"0") <-||- 
                } <-||- 
                 -||-> Write-Debug -Message "Hash value was $paddedHex." <-||- 
                 -||-> $hashList += $( -||-> $paddedHex + ":-:" + $_.FullName + ":-:" + $_.Length + ":-:" + $_.LastWriteTime <-||- ) <-||- 
            } <-||- 
		} <-||-  
	} <-||- 

	return  -||-> ,$hashList <-||- 
} <-||- 

 -||-> function Get-Hash {
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory=$True,Position=0)]
			[ValidateSet("MD5","SHA1","SHA256","SHA384","SHA512","RIPEMD160")]
			[string]$HashType = "MD5",
        [Parameter(Mandatory=$True,Position=1)]
            [string[]]$Files
    )

	 -||-> $HashType = $HashType.ToUpper() <-||- 

	 -||-> $hashList =  -||-> Get-Hashes -HashType "MD5" -Files $Paths <-||-  <-||- 

     -||-> $o =  -||-> "" | Select-Object File, Hash, Length, LastWritetime <-||-  <-||- 
     -||-> if ( -||-> $hashList <-||- ) {
         -||-> $hashList | ForEach-Object {
             -||-> $hash,$file,$length,$lastWritetime = $_ -split ":-:" <-||- 
             -||-> $o.File = $file <-||- 
             -||-> $o.Hash = $hash <-||- 
             -||-> $o.Length = $length <-||- 
             -||-> $o.LastWriteTime = $lastWritetime <-||- 
             -||-> $o <-||- 
        } <-||- 
    } else {
         -||-> $o.File = $null <-||- 
         -||-> $o.Hash = $null <-||- 
         -||-> $o.Length = $null <-||- 
         -||-> $o.LastWriteTime = $null <-||- 
         -||-> $o <-||- 
    } <-||- 
} <-||- 

 -||-> Get-Hash -HashType "MD5" -Files $Paths <-||- 

