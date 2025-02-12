 -||-> function New-PSFSupportPackage
{

	[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingEmptyCatchBlock", "")]
	[CmdletBinding(HelpUri = 'https://psframework.org/documentation/commands/PSFramework/New-PSFSupportPackage')]
	param (
		[string]
		$Path = "$( -||-> $env:USERPROFILE <-||- )\Desktop",
		
		[PSFramework.Utility.SupportData]
		$Include = 'All',
		
		[PSFramework.Utility.SupportData]
		$Exclude = 'None',
		
		[string[]]
		$Variables,
		
		[switch]
		$ExcludeError,
		
		[switch]
		[Alias('Silent')]
		$EnableException
	)
	
	begin
	{
		 -||-> Write-PSFMessage -Level InternalComment -Message "Starting" <-||- 
		 -||-> Write-PSFMessage -Level Verbose -Message "Bound parameters: $( -||-> $PSBoundParameters.Keys -join ", " <-||- )" <-||- 
		
		
		 -||-> function Get-ShellBuffer
		{
			[CmdletBinding()]
			param ()
			
			 -||-> try
			{
				
				 -||-> $rec =  -||-> New-Object System.Management.Automation.Host.Rectangle <-||-  <-||- 
				 -||-> $rec.Left = 0 <-||- 
				 -||-> $rec.Right = $host.ui.rawui.BufferSize.Width - 1 <-||- 
				 -||-> $rec.Top = 0 <-||- 
				 -||-> $rec.Bottom = $host.ui.rawui.BufferSize.Height - 1 <-||- 
				
				
				 -||-> $buffer = $host.ui.rawui.GetBufferContents($rec) <-||- 
				
				
				 -||-> $int = 0 <-||- 
				 -||-> $lines = @() <-||- 
				 -||-> while ( -||-> $int -le $rec.Bottom <-||- )
				{
					 -||-> $n = 0 <-||- 
					 -||-> $line = "" <-||- 
					 -||-> while ( -||-> $n -le $rec.Right <-||- )
					{
						 -||-> $line += $buffer[$int, $n].Character <-||- 
						 -||-> $n++ <-||- 
					} <-||- 
					 -||-> $line = $line.TrimEnd() <-||- 
					 -||-> $lines += $line <-||- 
					 -||-> $int++ <-||- 
				} <-||- 
				
				
				 -||-> $int = 0 <-||- 
				 -||-> $temp = $lines[$int] <-||- 
				 -||-> while ( -||-> $temp -eq "" <-||- ) {  -||-> $int++ <-||- ;  -||-> $temp = $lines[$int] <-||-  } <-||- 
				
				
				 -||-> $z = $rec.Bottom <-||- 
				 -||-> $temp = $lines[$z] <-||- 
				 -||-> while ( -||-> $temp -eq "" <-||- ) {  -||-> $z-- <-||- ;  -||-> $temp = $lines[$z] <-||-  } <-||- 
				
				
				 -||-> $z-- <-||- 
				
				
				 -||-> $temp = $lines[$z] <-||- 
				 -||-> while ( -||-> $temp -eq "" <-||- ) {  -||-> $z-- <-||- ;  -||-> $temp = $lines[$z] <-||-  } <-||- 
				
				
				return  -||-> $lines[$int .. $z] <-||- 
			}
			catch { } <-||- 
		} <-||- 
		
	}
	process
	{
		 -||-> $filePathXml =  -||-> Join-Path $Path "powershell_support_pack_$( -||-> Get-Date -Format "yyyy_MM_dd-HH_mm_ss" <-||- ).cliDat" <-||-  <-||- 
		 -||-> $filePathZip = $filePathXml -replace "\.cliDat$", ".zip" <-||- 
		
		 -||-> Write-PSFMessage -Level Critical -Message @"
Gathering information...
Will write the final output to: $filePathZip
$( -||-> Get-PSFConfigValue -FullName 'psframework.supportpackage.contactmessage' -Fallback '' <-||- )
Be aware that this package contains a lot of information including your input history in the console.
Please make sure no sensitive data (such as passwords) can be caught this way.

Ideally start a new console, perform the minimal steps required to reproduce the issue, then run this command.
This will make it easier for us to troubleshoot and you won't be sending us the keys to your castle.
"@ <-||- 
		
		 -||-> $hash = @{ } <-||- 
		 -||-> if ( -||-> ( -||-> $Include -band 1 <-||- ) -and -not ( -||-> $Exclude -band 1 <-||- ) <-||- )
		{
			 -||-> Write-PSFMessage -Level Important -Message "Collecting PSFramework logged messages (Get-PSFMessage)" <-||- 
			 -||-> $hash["Messages"] =  -||-> Get-PSFMessage <-||-  <-||- 
		} <-||- 
		 -||-> if ( -||-> ( -||-> $Include -band 2 <-||- ) -and -not ( -||-> $Exclude -band 2 <-||- ) <-||- )
		{
			 -||-> Write-PSFMessage -Level Important -Message "Collecting PSFramework logged errors (Get-PSFMessage -Errors)" <-||- 
			 -||-> $hash["Errors"] =  -||-> Get-PSFMessage -Errors <-||-  <-||- 
		} <-||- 
		 -||-> if ( -||-> ( -||-> $Include -band 4 <-||- ) -and -not ( -||-> $Exclude -band 4 <-||- ) <-||- )
		{
			 -||-> Write-PSFMessage -Level Important -Message "Trying to collect copy of console buffer (what you can see on your console)" <-||- 
			 -||-> $hash["ConsoleBuffer"] =  -||-> Get-ShellBuffer <-||-  <-||- 
		} <-||- 
		 -||-> if ( -||-> ( -||-> $Include -band 8 <-||- ) -and -not ( -||-> $Exclude -band 8 <-||- ) <-||- )
		{
			 -||-> Write-PSFMessage -Level Important -Message "Collecting Operating System information (Win32_OperatingSystem)" <-||- 
			 -||-> $hash["OperatingSystem"] =  -||-> Get-CimInstance -ClassName Win32_OperatingSystem <-||-  <-||- 
		} <-||- 
		 -||-> if ( -||-> ( -||-> $Include -band 16 <-||- ) -and -not ( -||-> $Exclude -band 16 <-||- ) <-||- )
		{
			 -||-> Write-PSFMessage -Level Important -Message "Collecting CPU information (Win32_Processor)" <-||- 
			 -||-> $hash["CPU"] =  -||-> Get-CimInstance -ClassName Win32_Processor <-||-  <-||- 
		} <-||- 
		 -||-> if ( -||-> ( -||-> $Include -band 32 <-||- ) -and -not ( -||-> $Exclude -band 32 <-||- ) <-||- )
		{
			 -||-> Write-PSFMessage -Level Important -Message "Collecting Ram information (Win32_PhysicalMemory)" <-||- 
			 -||-> $hash["Ram"] =  -||-> Get-CimInstance -ClassName Win32_PhysicalMemory <-||-  <-||- 
		} <-||- 
		 -||-> if ( -||-> ( -||-> $Include -band 64 <-||- ) -and -not ( -||-> $Exclude -band 64 <-||- ) <-||- )
		{
			 -||-> Write-PSFMessage -Level Important -Message "Collecting PowerShell & .NET Version (`$PSVersionTable)" <-||- 
			 -||-> $hash["PSVersion"] = $PSVersionTable <-||- 
		} <-||- 
		 -||-> if ( -||-> ( -||-> $Include -band 128 <-||- ) -and -not ( -||-> $Exclude -band 128 <-||- ) <-||- )
		{
			 -||-> Write-PSFMessage -Level Important -Message "Collecting Input history (Get-History)" <-||- 
			 -||-> $hash["History"] =  -||-> Get-History <-||-  <-||- 
		} <-||- 
		 -||-> if ( -||-> ( -||-> $Include -band 256 <-||- ) -and -not ( -||-> $Exclude -band 256 <-||- ) <-||- )
		{
			 -||-> Write-PSFMessage -Level Important -Message "Collecting list of loaded modules (Get-Module)" <-||- 
			 -||-> $hash["Modules"] =  -||-> Get-Module <-||-  <-||- 
		} <-||- 
		 -||-> if ( -||-> ( -||-> ( -||-> $Include -band 512 <-||- ) -and -not ( -||-> $Exclude -band 512 <-||- ) <-||- ) -and ( -||-> Get-Command -Name Get-PSSnapIn -ErrorAction SilentlyContinue <-||- ) <-||- )
		{
			 -||-> Write-PSFMessage -Level Important -Message "Collecting list of loaded snapins (Get-PSSnapin)" <-||- 
			 -||-> $hash["SnapIns"] =  -||-> Get-PSSnapin <-||-  <-||- 
		} <-||- 
		 -||-> if ( -||-> ( -||-> $Include -band 1024 <-||- ) -and -not ( -||-> $Exclude -band 1024 <-||- ) <-||- )
		{
			 -||-> Write-PSFMessage -Level Important -Message "Collecting list of loaded assemblies (Name, Version, and Location)" <-||- 
			 -||-> $hash["Assemblies"] =  -||-> [appdomain]::CurrentDomain.GetAssemblies() | Select-Object CodeBase, FullName, Location, ImageRuntimeVersion, GlobalAssemblyCache, IsDynamic <-||-  <-||- 
		} <-||- 
		 -||-> if ( -||-> Test-PSFParameterBinding -ParameterName "Variables" <-||- )
		{
			 -||-> Write-PSFMessage -Level Important -Message "Adding variables specified for export: $( -||-> $Variables -join ", " <-||- )" <-||- 
			 -||-> $hash["Variables"] =  -||-> $Variables | Get-Variable -ErrorAction Ignore <-||-  <-||- 
		} <-||- 
		 -||-> if ( -||-> ( -||-> $Include -band 2048 <-||- ) -and -not ( -||-> $Exclude -band 2048 <-||- ) -and ( -||-> -not $ExcludeError <-||- ) <-||- )
		{
			 -||-> Write-PSFMessage -Level Important -Message "Adding content of `$Error" <-||- 
			 -||-> $hash["PSErrors"] = @() <-||- 
			 -||-> foreach ($errorItem in  -||-> $global:Error <-||- ) {  -||-> $hash["PSErrors"] +=  -||-> New-Object PSFramework.Message.PsfException( -||-> $errorItem <-||- ) <-||-  <-||-  } <-||- 
		} <-||- 
		 -||-> if ( -||-> ( -||-> $Include -band 4096 <-||- ) -and -not ( -||-> $Exclude -band 4096 <-||- ) <-||- )
		{
			 -||-> if ( -||-> Test-Path function:Get-DbatoolsLog <-||- )
			{
				 -||-> Write-PSFMessage -Level Important -Message "Collecting dbatools logged messages (Get-DbatoolsLog)" <-||- 
				 -||-> $hash["DbatoolsMessages"] =  -||-> Get-DbatoolsLog <-||-  <-||- 
				 -||-> Write-PSFMessage -Level Important -Message "Collecting dbatools logged errors (Get-DbatoolsLog -Errors)" <-||- 
				 -||-> $hash["DbatoolsErrors"] =  -||-> Get-DbatoolsLog -Errors <-||-  <-||- 
			} <-||- 
		} <-||- 
		
		 -||-> $data = [pscustomobject]$hash <-||- 
		
		 -||-> try {  -||-> $data | Export-PsfClixml -Path $filePathXml -ErrorAction Stop <-||-  }
		catch
		{
			 -||-> Stop-PSFFunction -Message "Failed to export dump to file!" -ErrorRecord $_ -Target $filePathXml <-||- 
			return
		} <-||- 
		
		 -||-> try {  -||-> Compress-Archive -Path $filePathXml -DestinationPath $filePathZip -ErrorAction Stop <-||-  }
		catch
		{
			 -||-> Stop-PSFFunction -Message "Failed to pack dump-file into a zip archive. Please do so manually before submitting the results as the unpacked xml file will be rather large." -ErrorRecord $_ -Target $filePathZip <-||- 
			return
		} <-||- 
		
		 -||-> Remove-Item -Path $filePathXml -ErrorAction Ignore <-||- 
	}
	end
	{
		 -||-> Write-PSFMessage -Level InternalComment -Message "Ending" <-||- 
	}
} <-||- 


