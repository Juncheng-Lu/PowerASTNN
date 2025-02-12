

[cmdletbinding(DefaultParameterSetName='Build')]
param(
    [Parameter(ParameterSetName='packageSigned')]
    [Parameter(ParameterSetName='Build')]
    [ValidatePattern("^v\d+\.\d+\.\d+(-\w+(\.\d+)?)?$")]
    [string]$ReleaseTag,

    
    [Parameter(Mandatory,ParameterSetName='packageSigned')]
    [string]
    $BuildPath,

    [Parameter(Mandatory,ParameterSetName='packageSigned')]
    [string]
    $SignedFilesPath
)

DynamicParam {
    

    
     -||-> $buildJsonPath = ( -||-> Join-Path -path $PSScriptRoot -ChildPath 'build.json' <-||- ) <-||- 
     -||-> $build =  -||-> Get-Content -Path $buildJsonPath | ConvertFrom-Json <-||-  <-||- 
     -||-> $names = @( -||-> $build.Windows.Name <-||- ) <-||- 
     -||-> foreach($name in  -||-> $build.Linux.Name <-||- )
    {
         -||-> $names += $name <-||- 
    } <-||- 

    
     -||-> $ParameterAttr =  -||-> New-Object "System.Management.Automation.ParameterAttribute" <-||-  <-||- 
     -||-> $ValidateSetAttr =  -||-> New-Object "System.Management.Automation.ValidateSetAttribute" -ArgumentList $names <-||-  <-||- 
     -||-> $Attributes =  -||-> New-Object "System.Collections.ObjectModel.Collection``1[System.Attribute]" <-||-  <-||- 
     -||-> $Attributes.Add($ParameterAttr) > $null <-||- 
     -||-> $Attributes.Add($ValidateSetAttr) > $null <-||- 

    
     -||-> $Parameter =  -||-> New-Object "System.Management.Automation.RuntimeDefinedParameter" -ArgumentList ( -||-> "Name", [string], $Attributes <-||- ) <-||-  <-||- 
     -||-> $Dict =  -||-> New-Object "System.Management.Automation.RuntimeDefinedParameterDictionary" <-||-  <-||- 
     -||-> $Dict.Add("Name", $Parameter) > $null <-||- 
    return  -||-> $Dict <-||- 
}

Begin {
     -||-> $Name = $PSBoundParameters['Name'] <-||- 
}

End {
     -||-> $ErrorActionPreference = 'Stop' <-||- 

     -||-> $additionalFiles = @() <-||- 
     -||-> $buildPackageName = $null <-||- 
    
     -||-> if ( -||-> $BuildPath <-||- )
    {
         -||-> Import-Module ( -||-> Join-Path -path $PSScriptRoot -childpath '..\..\build.psm1' <-||- ) <-||- 
         -||-> Import-Module ( -||-> Join-Path -path $PSScriptRoot -childpath '..\packaging' <-||- ) <-||- 

        
         -||-> $destFolder = $env:temp <-||- 
         -||-> if( -||-> $env:BUILD_STAGINGDIRECTORY <-||- )
        {
            
             -||-> $destFolder = $env:BUILD_STAGINGDIRECTORY <-||- 
        } <-||- 

         -||-> $BuildPackagePath =  -||-> New-PSSignedBuildZip -BuildPath $BuildPath -SignedFilesPath $SignedFilesPath -DestinationFolder $destFolder <-||-  <-||- 
         -||-> Write-Verbose -Verbose "New-PSSignedBuildZip returned `$BuildPackagePath as: $BuildPackagePath" <-||- 
         -||-> Write-Host "
        $buildPackageName = Split-Path -Path $BuildPackagePath -Leaf
        $additionalFiles += $BuildPackagePath
    }

    $psReleaseBranch = 'master'
    $psReleaseFork = 'PowerShell'
    $location = Join-Path -Path $PSScriptRoot -ChildPath 'PSRelease'
    if(Test-Path $location)
    {
        Remove-Item -Path $location -Recurse -Force
    }

    $gitBinFullPath = (Get-Command -Name git).Source
    if (-not $gitBinFullPath)
    {
        throw "Git is required to proceed. Install from 'https://git-scm.com/download/win'"
    }

    Write-Verbose "cloning -b $psReleaseBranch --quiet https://github.com/$psReleaseFork/PSRelease.git" -verbose
    & $gitBinFullPath clone -b $psReleaseBranch --quiet https://github.com/$psReleaseFork/PSRelease.git $location

    Push-Location -Path $PWD.Path

    $unresolvedRepoRoot = Join-Path -Path $PSScriptRoot '../..'
    $resolvedRepoRoot = (Resolve-Path -Path $unresolvedRepoRoot).ProviderPath

    try
    {
        Write-Verbose "Starting build at $resolvedRepoRoot  ..." -Verbose
        Import-Module "$location/vstsBuild" -Force
        Import-Module "$location/dockerBasedBuild" -Force
        Clear-VstsTaskState

        $buildParameters = @{
            ReleaseTag = $ReleaseTag
            BuildPackageName = $buildPackageName
        }

        Invoke-Build -RepoPath $resolvedRepoRoot -BuildJsonPath './tools/releaseBuild/build.json' -Name $Name -Parameters $buildParameters -AdditionalFiles $AdditionalFiles
    }
    catch
    {
        Write-VstsError -Error $_
    }
    finally{
        Write-VstsTaskState
        exit 0
    }
}

 <-||-  <-||- 
