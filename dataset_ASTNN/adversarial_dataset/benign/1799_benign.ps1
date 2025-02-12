

param([parameter(Mandatory=$true)][string] $CMS,
			[int] $output=0)
 -||-> $CMS=$CMS.replace("\", "%5C") <-||- 

 -||-> $srvlist =  -||-> gci "SQLSERVER:\sqlregistration\Central Management Server Group\$CMSInst\" -Recurse | where { -||-> $_.ServerName -ne $null <-||- } <-||-  <-||- 

 -||-> $report=@() <-||- 

 -||-> foreach ($server in  -||-> $srvlist <-||- )
{
	 -||-> try
	{
		 -||-> if( -||-> $server.ServerName.Contains("\") <-||- )
		{
			 -||-> $sqlhost=$server.ServerName.Substring(0,$server.ServerName.IndexOf("\")) <-||- 
			 -||-> $instance=$server.ServerName.Substring($server.ServerName.IndexOf("\")+1) <-||- 
			 -||-> $svcs= -||-> gwmi Win32_service -computer $sqlhost | where { -||-> $_.name -like "*$instance*" <-||- } <-||-  <-||- 
		}
		else
		{
			 -||-> $sqlhost=$server.ServerName.Substring(0,$server.ServerName.IndexOf("\")) <-||- 
			 -||-> $svcs= -||-> gwmi Win32_service -computer $sqlhost | where { -||-> $_.name -like "*SQLSERVER*" <-||- } <-||-  <-||- 
		} <-||- 
		
		
		 -||-> foreach ($svc in  -||-> $svcs <-||- )
		{
			 -||-> $output =  -||-> New-Object System.Object <-||-  <-||- 
			 -||-> $output | Add-Member -type NoteProperty -name Instance -value $sqlhost <-||- 
			 -||-> $output | Add-Member -type NoteProperty -name SvcName -value $svc.Name <-||- 
			 -||-> $output | Add-Member -type NoteProperty -name DisplayName -value $svc.DisplayName <-||- 
			 -||-> $output | Add-Member -type NoteProperty -name State -value $svc.State <-||- 
			 -||-> $report+=$output <-||- 
		} <-||- 
	}
	catch
	{
		 -||-> $output =  -||-> New-Object System.Object <-||-  <-||- 
		 -||-> $output | Add-Member -type NoteProperty -name Instance -value $sqlhost <-||- 
		 -||-> $output | Add-Member -type NoteProperty -name SvcName -value "No_Service_Collected" <-||- 
		 -||-> $output | Add-Member -type NoteProperty -name DisplayName -value "No Service Collected - COLLECTION ERROR" <-||- 
		 -||-> $output | Add-Member -type NoteProperty -name State -value "ERROR" <-||- 
		 -||-> $report+=$output <-||- 
	} <-||- 
} <-||- 

switch( -||-> $output <-||- )
{
	0 {
			 -||-> $report | Format-Table Instance,DisplayName,State <-||- 
		}
	1 {
			
			 -||-> $smtp="smtp.gmail.com" <-||- 
			 -||-> $from="dummy@sdflab.com" <-||- 
			 -||-> $to="michael_fal@outlook.com" <-||- 
			
			 -||-> if( -||-> ( -||-> $report | where { -||-> $_.State -ne "Running" <-||- } <-||- ).Length -gt 0 <-||- )
			{
				 -||-> [string]$body= -||-> $report|where{ -||-> $_.State -ne "Running" <-||- }| ConvertTo-HTML <-||-  <-||- 
				 -||-> Send-MailMessage -To $to -from $from -subject "Service Monitor Report" -smtpserver $smtp -body $body -BodyAsHtml <-||- 
			} <-||- 
		}
	
	default {
			 -||-> $report|where{ -||-> $_.State -ne "Running" <-||- } | Format-Table Instance,DisplayName,State <-||- 
		}
}

