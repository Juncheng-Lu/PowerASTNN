














 -||-> function Get-StorageTestMode {
     -||-> try {
         -||-> $testMode = [Microsoft.Azure.Test.HttpRecorder.HttpMockServer]::Mode <-||- ;
         -||-> $testMode = $testMode.ToString() <-||- ;
    } catch {
         -||-> if ( -||-> $PSItem.Exception.Message -like '*Unable to find type*' <-||- ) {
             -||-> $testMode = 'Record' <-||- ;
        } else {
            throw;
        } <-||- 
    } <-||- 

    return  -||-> $testMode <-||- 
} <-||- 


 -||-> function Clean-ResourceGroup($rgname)
{
     -||-> if ( -||-> ( -||-> Get-StorageTestMode <-||- ) -ne 'Playback' <-||- ) {
         -||-> try 
        {
             -||-> Write-Verbose "Attempting to remove StorageSync resources from resource group $rgname" <-||- 
             -||-> $syncServices =  -||-> Get-AzStorageSyncService -ResourceGroup $rgname <-||-  <-||- 
             -||-> foreach ($syncService in  -||-> $syncServices <-||- )
            {                
                 -||-> Get-AzStorageSyncServer -ParentObject $syncService | Unregister-AzStorageSyncServer -Force <-||- 
                
                 -||-> $syncGroups =  -||-> Get-AzStorageSyncGroup -ParentObject $syncService <-||-  <-||- 
                 -||-> foreach ($syncGroup in  -||-> $syncGroups <-||- )
                {
                     -||-> Get-AzStorageSyncCloudEndpoint -ParentObject $syncGroup | Remove-AzStorageSyncCloudEndpoint -Force <-||- 
                } <-||- 
                 -||-> $syncGroups | Remove-AzStorageSyncGroup -Force <-||- 
            } <-||- 
             -||-> $syncServices | Remove-AzStorageSyncService -Force <-||- 
        }
        catch
        {
             -||-> Write-Verbose "Exception $( -||-> $_.Exception.ToString() <-||- )" <-||- 
        } <-||- 
         -||-> Write-Verbose "Attempting to remove resource group $rgname" <-||- 
         -||-> Remove-AzResourceGroup -Name $rgname -Force <-||- 
    } <-||- 
} <-||- 









 -||-> function Retry-IfException
{
    param([ScriptBlock] $script, [int] $times = 30, [string] $message = "*")

     -||-> if ( -||-> $times -le 0 <-||- )
    {
        throw  -||-> 'Retry time(s) should not be equal to or less than 0.' <-||- ;
    } <-||- 

     -||-> $oldErrorActionPreferenceValue = $ErrorActionPreference <-||- ;
     -||-> $ErrorActionPreference = "SilentlyContinue" <-||- ;

     -||-> $iter = 0 <-||- ;
     -||-> $succeeded = $false <-||- ;
     -||-> while ( -||-> ( -||-> $iter -lt $times <-||- ) -and ( -||-> -not $succeeded <-||- ) <-||- )
    {
         -||-> $iter += 1 <-||- ;

         -||-> try
        {
             -||-> &$script <-||- ;
        }
        catch
        {

        } <-||- 

         -||-> if ( -||-> $Error.Count -gt 0 <-||- )
        {
             -||-> $actualMessage = $Error[0].Exception.Message <-||- ;

             -||-> Write-Output ( -||-> "Caught exception: '$actualMessage'" <-||- ) <-||- ;

             -||-> if ( -||-> -not ( -||-> $actualMessage -like $message <-||- ) <-||- )
            {
                 -||-> $ErrorActionPreference = $oldErrorActionPreferenceValue <-||- ;
                throw  -||-> "Expected exception not received: '$message' the actual message is '$actualMessage'" <-||- ;
            } <-||- 

             -||-> $Error.Clear() <-||- ;
             -||-> Wait-Seconds 10 <-||- ;
            continue;
        } <-||- 

         -||-> $succeeded = $true <-||- ;
    } <-||- 

     -||-> $ErrorActionPreference = $oldErrorActionPreferenceValue <-||- ;
} <-||- 


 -||-> function Get-RandomItemName
{
    param([string] $prefix = "pslibtest")
    
     -||-> if ( -||-> $prefix -eq $null -or $prefix -eq '' <-||- )
    {
         -||-> $prefix = "pslibtest" <-||- ;
    } <-||- 

     -||-> $str = $prefix + ( -||-> ( -||-> [guid]::NewGuid().ToString() -replace '-','' <-||- )[0..9] -join '' <-||- ) <-||- ;
    return  -||-> $str <-||- ;
} <-||- 


 -||-> function Get-ResourceGroupName
{
    return  -||-> getAssetName <-||- 
} <-||- 


 -||-> function Get-ResourceName($prefix)
{
    return  -||-> $prefix + ( -||-> getAssetName <-||- ) <-||- 
} <-||- 


 -||-> function Get-StorageManagementTestResourceName
{
     -||-> $stack =  -||-> Get-PSCallStack <-||-  <-||- 
     -||-> $testName = $null <-||- ;
     -||-> foreach ($frame in  -||-> $stack <-||- )
    {
         -||-> if ( -||-> $frame.Command.StartsWith("Test-", "CurrentCultureIgnoreCase") <-||- )
        {
             -||-> $testName = $frame.Command <-||- ;
        } <-||- 
    } <-||- 
    
     -||-> try
    {
         -||-> $assetName = [Microsoft.Azure.Test.HttpRecorder.HttpMockServer]::GetAssetName($testName, "pstestrg") <-||- 
    }
    catch
    {
         -||-> if ( -||-> $PSItem.Exception.Message -like '*Unable to find type*' <-||- )
        {
             -||-> $assetName =  -||-> Get-RandomItemName <-||-  <-||- ;
        }
        else
        {
            throw;
        } <-||- 
    } <-||- 

    return  -||-> $assetName <-||- 
} <-||- 


 -||-> function Get-StorageSyncLocation($provider)
{
     -||-> $defaultLocation = "Central US EUAP" <-||- 
     -||-> if ( -||-> [Microsoft.Azure.Test.HttpRecorder.HttpMockServer]::Mode -ne [Microsoft.Azure.Test.HttpRecorder.HttpRecorderMode]::Playback <-||- )
    {
         -||-> $namespace = $provider.Split("/")[0] <-||- 
         -||-> if( -||-> $provider.Contains("/") <-||- )
        {
             -||-> $type = $provider.Substring($namespace.Length + 1) <-||- 
             -||-> $location =  -||-> Get-AzResourceProvider -ProviderNamespace $namespace | where { -||-> $_.ResourceTypes[0].ResourceTypeName -eq $type <-||- } <-||-  <-||- 

             -||-> if ( -||-> $location -eq $null <-||- )
            {
                return  -||-> $defaultLocation <-||- 
            } else
            {
                return  -||-> $location.Locations[0].ToLower() -replace '\s','' <-||- 
            } <-||- 
        } <-||- 

        return  -||-> $defaultLocation <-||- 
    } <-||- 

    return  -||-> $defaultLocation <-||- 
} <-||- 


 -||-> function Get-ResourceGroupLocation()
{
    return  -||-> Get-Location -providerNamespace "Microsoft.Resources"  -resourceType "resourceGroups" -preferredLocation "West US" <-||- 
} <-||- 


 -||-> function Normalize-Location($location)
{
     -||-> if( -||-> -not [string]::IsNullOrEmpty($location) <-||- )
    {
        return  -||-> $location.ToLower().Replace(" ", "") <-||-  
    } <-||- 

    return  -||-> $location <-||- 
} <-||- 


 -||-> function IsLive
{
    return  -||-> [Microsoft.Azure.Test.HttpRecorder.HttpMockServer]::Mode -ne [Microsoft.Azure.Test.HttpRecorder.HttpRecorderMode]::Playback <-||- 
} <-||- 


 -||-> function Create-StorageShare
{
    param (
        [Parameter(Position = 0)]
        $Name, 
        [Parameter(Position = 1)]
        $Context)
    
     -||-> if ( -||-> [string]::IsNullOrEmpty($Name) <-||- )
    {
        throw  -||-> "Invalid argument: Name" <-||- 
    } <-||- 

     -||-> if( -||-> IsLive <-||- )
    {
         -||-> if ( -||-> $null -eq $Context <-||- )
        {
            throw  -||-> "Invalid argument: Context" <-||- 
        } <-||- 

         -||-> $azureFileShare = $null <-||- 
         -||-> if ( -||-> gcm New-AzStorageShare -ErrorAction SilentlyContinue <-||- )
        {
             -||-> Write-Verbose "Using New-AzStorageShare cmdlet to create share: $( -||-> $Name <-||- ) in storage account: $( -||-> $Context.StorageAccountName <-||- )" <-||- 
             -||-> $azureFileShare =  -||-> New-AzStorageShare -Name $Name -Context $Context <-||-  <-||- 
        }
        elseif ( -||-> gcm New-AzureStorageShare -ErrorAction SilentlyContinue <-||- )
        {
             -||-> Write-Verbose "Using New-AzureStorageShare cmdlet to create share: $( -||-> $Name <-||- ) in storage account: $( -||-> $Context.StorageAccountName <-||- )" <-||- 
             -||-> $azureFileShare =  -||-> New-AzureStorageShare -Name $Name -Context $Context <-||-  <-||-             
        }
        else 
        {
            throw  -||-> "Neither New-AzStorageShare nor New-AzureStorageShare cmdlet is available" <-||- 
        } <-||- 
        return  -||-> $azureFileShare.Name <-||- 
    }
    else 
    {
        return  -||-> $azureFileShareName <-||- 
    } <-||- 
} <-||- 

 -||-> function Remove-StorageShare
{
    param (
        [Parameter(Position = 0)]
        $Name, 
        [Parameter(Position = 1)]
        $Context)
    
     -||-> if ( -||-> [string]::IsNullOrEmpty($Name) <-||- )
    {
        throw  -||-> "Invalid argument: Name" <-||- 
    } <-||- 
    
     -||-> if( -||-> IsLive <-||- )
    {
         -||-> if ( -||-> $null -eq $Context <-||- )
        {
            throw  -||-> "Invalid argument: Context" <-||- 
        } <-||- 

         -||-> $result = $null <-||- 
         -||-> if ( -||-> gcm Remove-AzStorageShare -ErrorAction SilentlyContinue <-||- )
        {
             -||-> Write-Verbose "Using Remove-AzStorageShare cmdlet" <-||- 
             -||-> $result =  -||-> Remove-AzStorageShare -Name $Name -Context $Context -Force <-||-  <-||- 
        }
        elseif ( -||-> gcm Remove-AzureStorageShare -ErrorAction SilentlyContinue <-||- )
        {
             -||-> Write-Verbose "Using Remove-AzureStorageShare cmdlet" <-||- 
             -||-> $result =  -||-> Remove-AzureStorageShare -Name $Name -Context $Context -Force <-||-  <-||- 
        }
        else 
        {
            throw  -||-> "Neither Remove-AzStorageShare nor Remove-AzureStorageShare cmdlet is available" <-||- 
        } <-||- 
        return  -||-> $result <-||- 
    } <-||- 
} <-||- 

 -||-> function Create-StorageContext
{
    param ($StorageAccountName, $StorageAccountKey)

     -||-> if ( -||-> [string]::IsNullOrEmpty($StorageAccountName) <-||- )
    {
        throw  -||-> "Invalid argument: StorageAccountName" <-||- 
    } <-||- 

     -||-> if ( -||-> [string]::IsNullOrEmpty($StorageAccountKey) <-||- )
    {
        throw  -||-> "Invalid argument: StorageAccountKey" <-||- 
    } <-||- 

     -||-> $result = $null <-||- 

     -||-> if( -||-> IsLive <-||- )
    {
         -||-> if ( -||-> gcm New-AzStorageContext -ErrorAction SilentlyContinue <-||- )
        {
             -||-> Write-Verbose "Using New-AzStorageContext cmdlet" <-||- 
             -||-> $result =  -||-> New-AzStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey -Protocol https -Endpoint core.windows.net <-||-  <-||- 
        }
        elseif ( -||-> gcm New-AzureStorageContext -ErrorAction SilentlyContinue <-||- )
        {
             -||-> Write-Verbose "Using New-AzureStorageContext cmdlet" <-||- 
             -||-> $result =  -||-> New-AzureStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey -Protocol https -Endpoint core.windows.net <-||-  <-||- 
        }
        else 
        {
            throw  -||-> "Neither New-AzStorageContext nor New-AzureStorageContext cmdlet is available" <-||- 
        } <-||- 
    } <-||- 
    
    return  -||-> $result <-||- 
} <-||- 

