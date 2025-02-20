











 -||-> Import-Module -Name ( -||-> Join-Path -Path $PSScriptRoot -ChildPath 'CarbonDscTest' -Resolve <-||- ) -Force <-||- 

 -||-> Describe 'Carbon_EnvironmentVariable' {
     -||-> function Assert-EnvironmentVariable
    {
        param(
            $Name,
            $Value
        )
    
         -||-> Set-StrictMode -Version 'Latest' <-||- 
    
         -||-> $stdOutPath =  -||-> Join-Path -Path $env:Temp -ChildPath ( -||-> [IO.Path]::GetRandomFileName() <-||- ) <-||-  <-||- 
         -||-> $stderrPath =  -||-> Join-Path -Path $env:Temp -ChildPath ( -||-> [IO.Path]::GetRandomFileName() <-||- ) <-||-  <-||- 
         -||-> ( -||-> $stdoutpath,$stderrPath <-||- ) | ForEach-Object {  -||-> New-Item -ItemType 'File' -Path $_ <-||-  } | Out-Null <-||- 
         -||-> try
        {
             -||-> Start-Process -FilePath 'cmd.exe' -ArgumentList ( -||-> '/c',( -||-> 'echo %{0}%' -f $Name <-||- ) <-||- ) -UseNewEnvironment -Wait -RedirectStandardError $stderrPath -RedirectStandardOutput $stdOutPath -NoNewWindow <-||- 
             -||-> $stderr =  -||-> Get-Content -Path $stderrPath -Raw <-||-  <-||-  
             -||-> $stdErr | Should BeNullOrEmpty <-||- 
             -||-> $stdout =  -||-> Get-Content -Path $stdOutPath -Raw <-||-  <-||- 
             -||-> $stdout = $stdout.Trim() <-||- 
             -||-> if(  -||-> $value -eq $null <-||-  )
            {
                 -||-> $stdout | Should Be ( -||-> '%{0}%' -f $Name <-||- ) <-||- 
            }
            else
            {
                 -||-> $stdout | Should Be $value <-||- 
            } <-||- 
        }
        finally
        {
             -||-> ( -||-> $stdoutpath,$stderrPath <-||- ) | Where-Object {  -||-> Test-Path -Path $_ -PathType leaf <-||-  } | Remove-Item <-||- 
        } <-||- 
    
    } <-||- 
    
     -||-> BeforeAll {
         -||-> Start-CarbonDscTestFixture 'EnvironmentVariable' <-||- 
         -||-> [Environment]::SetEnvironmentVariable('fubar',$null,'Machine') <-||- 
         -||-> [Environment]::SetEnvironmentVariable('fubar',$null,'Process') <-||- 
    } <-||- 
    
     -||-> AfterAll {
         -||-> Stop-CarbonDscTestFixture <-||- 
         -||-> [Environment]::SetEnvironmentVariable('fubar',$null,'Machine') <-||- 
         -||-> [Environment]::SetEnvironmentVariable('fubar',$null,'Process') <-||- 
    } <-||- 

     -||-> BeforeEach {
         -||-> $Global:Error.Clear() <-||- 
    } <-||- 
    
     -||-> It 'test target resource' {
         -||-> ( -||-> Test-TargetResource -Name 'fubar' -Value 'fubar' -Ensure 'Present' <-||- ) | Should Be $false <-||- 
         -||-> ( -||-> Test-TargetResource -Name 'fubar' -Value 'fubar' -Ensure 'Absent' <-||- ) | Should Be $true <-||- 
         -||-> ( -||-> Test-TargetResource -Name 'Path' -Value ( -||-> [Environment]::GetEnvironmentVariable('Path','Machine') <-||- ) -Ensure 'Present' <-||- ) | Should Be $true <-||- 
         -||-> ( -||-> Test-TargetResource -Name 'Path' -Value ( -||-> [Environment]::GetEnvironmentVariable('Path','Machine') <-||- ) -Ensure 'Absent' <-||- ) | Should Be $false <-||- 
    } <-||- 
    
     -||-> It 'get target resource' {
         -||-> $resource =  -||-> Get-TargetResource -Name 'fubar' <-||-  <-||- 
         -||-> $resource | Should Not BeNullOrEmpty <-||- 
         -||-> $resource.Name | Should Be 'fubar' <-||- 
         -||-> Assert-DscResourceAbsent $resource <-||- 
         -||-> $resource.Value | Should BeNullOrEmpty <-||- 
    
         -||-> $resource =  -||-> Get-TargetResource -Name 'TEMP' <-||-  <-||- 
         -||-> $resource | Should Not BeNullOrEmpty <-||- 
         -||-> $resource.Name | Should Be 'TEMP' <-||- 
         -||-> Assert-DscResourcePresent $resource <-||- 
         -||-> $resource.Value | Should Be ( -||-> [Environment]::GetEnvironmentVariable('TEMP','Machine') <-||- ) <-||- 
    } <-||- 
    
     -||-> It 'set target resource' {
         -||-> $value = [Guid]::NewGuid().ToString() <-||- 
         -||-> Set-TargetResource -Name 'fubar' -Value $value -Ensure 'Present' <-||- 
    
         -||-> $value | Should Be ( -||-> [Environment]::GetEnvironmentVariable('fubar','Machine') <-||- ) <-||- 
         -||-> $value | Should Be ( -||-> [Environment]::GetEnvironmentVariable('fubar','Process') <-||- ) <-||- 
    
         -||-> Set-TargetResource -Name 'fubar' -Ensure 'Absent' <-||- 
    } <-||- 
    
    configuration ShouldSetEnvironmentVariable
    {
        param(
            $Value,
            $Ensure
        )
    
         -||-> Set-StrictMode -Off <-||- 
    
        Import-DscResource -Name '*' -Module 'Carbon'
    
        node 'localhost'
        {
             -||-> Carbon_EnvironmentVariable setEnvVariable <-||- 
             -||-> {
                 -||-> Name = 'CarbonDscEnvironmentVariable' <-||- ;
                 -||-> Value = $Value <-||- ;
                 -||-> Ensure = $Ensure <-||- ;
            } <-||- 
        }
    }
     -||-> It 'should run through dsc' {
         -||-> $value = [Guid]::NewGuid().ToString() <-||- 
    
         -||-> & ShouldSetEnvironmentVariable -Value $value -Ensure 'Present' -OutputPath $CarbonDscOutputRoot <-||- 
    
         -||-> Start-DscConfiguration -Wait -ComputerName 'localhost' -Path $CarbonDscOutputRoot -Force <-||- 
         -||-> $Global:Error.Count | Should Be 0 <-||- 
         -||-> Assert-EnvironmentVariable 'CarbonDscEnvironmentVariable' $value <-||- 
    
         -||-> & ShouldSetEnvironmentVariable -Ensure 'Absent' -OutputPath $CarbonDscOutputRoot <-||- 
         -||-> Start-DscConfiguration -Wait -ComputerName 'localhost' -Path $CarbonDscOutputRoot -Force <-||- 
         -||-> $Global:Error.Count | Should Be 0 <-||- 
         -||-> Assert-EnvironmentVariable 'CarbonDscEnvironmentVariable' $null <-||- 


         -||-> $result =  -||-> Get-DscConfiguration <-||-  <-||- 
         -||-> $Global:Error.Count | Should Be 0 <-||- 
         -||-> $result | Should BeOfType ( -||-> [Microsoft.Management.Infrastructure.CimInstance] <-||- ) <-||- 
         -||-> $result.PsTypeNames | Where-Object {  -||-> $_ -like '*Carbon_EnvironmentVariable' <-||-  } | Should Not BeNullOrEmpty <-||- 
    } <-||- 
} <-||- 



















 -||-> Function Out-EncodedOctalCommand
{


    [CmdletBinding(DefaultParameterSetName = 'FilePath')] Param (
        [Parameter(Position = 0, ValueFromPipeline = $True, ParameterSetName = 'ScriptBlock')]
        [ValidateNotNullOrEmpty()]
        [ScriptBlock]
        $ScriptBlock,

        [Parameter(Position = 0, ParameterSetName = 'FilePath')]
        [ValidateNotNullOrEmpty()]
        [String]
        $Path,

        [Switch]
        $NoExit,

        [Switch]
        $NoProfile,

        [Switch]
        $NonInteractive,

        [Switch]
        $NoLogo,

        [Switch]
        $Wow64,
        
        [Switch]
        $Command,

        [ValidateSet('Normal', 'Minimized', 'Maximized', 'Hidden')]
        [String]
        $WindowStyle,

        [ValidateSet('Bypass', 'Unrestricted', 'RemoteSigned', 'AllSigned', 'Restricted')]
        [String]
        $ExecutionPolicy,
        
        [Switch]
        $PassThru
    )

    
     -||-> $EncodingBase = 8 <-||- 

    
     -||-> If( -||-> $PSBoundParameters['Path'] <-||- )
    {
         -||-> Get-ChildItem $Path -ErrorAction Stop | Out-Null <-||- 
         -||-> $ScriptString = [IO.File]::ReadAllText(( -||-> Resolve-Path $Path <-||- )) <-||- 
    }
    Else
    {
         -||-> $ScriptString = [String]$ScriptBlock <-||- 
    } <-||- 

    
    
     -||-> $RandomDelimiters  = @( -||-> '_','-',',','{','}','~','!','@','%','&','<','>',';',':' <-||- ) <-||- 

    
     -||-> @( -||-> 'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z' <-||- ) | ForEach-Object { -||-> $UpperLowerChar = $_ <-||- ;  -||-> If( -||-> ( -||-> ( -||-> Get-Random -Input @( -||-> 1..2 <-||- ) <-||- )-1 -eq 0 <-||- ) <-||- ) { -||-> $UpperLowerChar = $UpperLowerChar.ToUpper() <-||- } <-||-   -||-> $RandomDelimiters += $UpperLowerChar <-||- } <-||- 
    
    
     -||-> $RandomDelimiters = ( -||-> Get-Random -Input $RandomDelimiters -Count ( -||-> $RandomDelimiters.Count/4 <-||- ) <-||- ) <-||- 

    
     -||-> $DelimitedEncodedArray = '' <-||- 
     -||-> ( -||-> [Char[]]$ScriptString <-||- ) | ForEach-Object { -||-> $DelimitedEncodedArray += ( -||-> [Convert]::ToString(( -||-> [Int][Char]$_ <-||- ),$EncodingBase) + ( -||-> Get-Random -Input $RandomDelimiters <-||- ) <-||- ) <-||- } <-||- 

    
     -||-> $DelimitedEncodedArray = $DelimitedEncodedArray.SubString(0,$DelimitedEncodedArray.Length-1) <-||- 

    
     -||-> $RandomDelimitersToPrint = ( -||-> Get-Random -Input $RandomDelimiters -Count $RandomDelimiters.Length <-||- ) -Join '' <-||- 
    
    
     -||-> $ForEachObject =  -||-> Get-Random -Input @( -||-> 'ForEach','ForEach-Object','%' <-||- ) <-||-  <-||- 
     -||-> $StrJoin       = ( -||-> [Char[]]'[String]::Join'      | ForEach-Object { -||-> $Char = $_.ToString().ToLower() <-||- ;  -||-> If( -||-> Get-Random -Input @( -||-> 0..1 <-||- ) <-||- ) { -||-> $Char = $Char.ToUpper() <-||- } <-||-   -||-> $Char <-||- } <-||- ) -Join '' <-||- 
     -||-> $StrStr        = ( -||-> [Char[]]'[String]'            | ForEach-Object { -||-> $Char = $_.ToString().ToLower() <-||- ;  -||-> If( -||-> Get-Random -Input @( -||-> 0..1 <-||- ) <-||- ) { -||-> $Char = $Char.ToUpper() <-||- } <-||-   -||-> $Char <-||- } <-||- ) -Join '' <-||- 
     -||-> $Join          = ( -||-> [Char[]]'-Join'               | ForEach-Object { -||-> $Char = $_.ToString().ToLower() <-||- ;  -||-> If( -||-> Get-Random -Input @( -||-> 0..1 <-||- ) <-||- ) { -||-> $Char = $Char.ToUpper() <-||- } <-||-   -||-> $Char <-||- } <-||- ) -Join '' <-||- 
     -||-> $CharStr       = ( -||-> [Char[]]'Char'                | ForEach-Object { -||-> $Char = $_.ToString().ToLower() <-||- ;  -||-> If( -||-> Get-Random -Input @( -||-> 0..1 <-||- ) <-||- ) { -||-> $Char = $Char.ToUpper() <-||- } <-||-   -||-> $Char <-||- } <-||- ) -Join '' <-||- 
     -||-> $Int           = ( -||-> [Char[]]'Int'                 | ForEach-Object { -||-> $Char = $_.ToString().ToLower() <-||- ;  -||-> If( -||-> Get-Random -Input @( -||-> 0..1 <-||- ) <-||- ) { -||-> $Char = $Char.ToUpper() <-||- } <-||-   -||-> $Char <-||- } <-||- ) -Join '' <-||- 
     -||-> $ForEachObject = ( -||-> [Char[]]$ForEachObject        | ForEach-Object { -||-> $Char = $_.ToString().ToLower() <-||- ;  -||-> If( -||-> Get-Random -Input @( -||-> 0..1 <-||- ) <-||- ) { -||-> $Char = $Char.ToUpper() <-||- } <-||-   -||-> $Char <-||- } <-||- ) -Join '' <-||- 
     -||-> $ToInt16       = ( -||-> [Char[]]'[Convert]::ToInt16(' | ForEach-Object { -||-> $Char = $_.ToString().ToLower() <-||- ;  -||-> If( -||-> Get-Random -Input @( -||-> 0..1 <-||- ) <-||- ) { -||-> $Char = $Char.ToUpper() <-||- } <-||-   -||-> $Char <-||- } <-||- ) -Join '' <-||- 

    
     -||-> $RandomDelimitersToPrintForDashSplit = '' <-||- 
     -||-> ForEach($RandomDelimiter in  -||-> $RandomDelimiters <-||- )
    {
        
         -||-> $Split = ( -||-> [Char[]]'Split' | ForEach-Object { -||-> $Char = $_.ToString().ToLower() <-||- ;  -||-> If( -||-> Get-Random -Input @( -||-> 0..1 <-||- ) <-||- ) { -||-> $Char = $Char.ToUpper() <-||- } <-||-   -||-> $Char <-||- } <-||- ) -Join '' <-||- 

         -||-> $RandomDelimitersToPrintForDashSplit += ( -||-> '-' + $Split + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + "'" + $RandomDelimiter + "'" + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) <-||- ) <-||- 
    } <-||- 
     -||-> $RandomDelimitersToPrintForDashSplit = $RandomDelimitersToPrintForDashSplit.Trim() <-||- 
    
    
     -||-> $RandomStringSyntax = ( -||-> [Char[]]( -||-> Get-Random -Input @( -||-> '[String]$_','$_.ToString()' <-||- ) <-||- ) | ForEach-Object { -||-> $Char = $_.ToString().ToLower() <-||- ;  -||-> If( -||-> Get-Random -Input @( -||-> 0..1 <-||- ) <-||- ) { -||-> $Char = $Char.ToUpper() <-||- } <-||-   -||-> $Char <-||- } <-||- ) -Join '' <-||- 
     -||-> $RandomConversionSyntax  = @() <-||- 
     -||-> $RandomConversionSyntax += "[$CharStr]" + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + '(' + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + $ToInt16 + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + '(' + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + $RandomStringSyntax + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + ')' + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + ',' + $EncodingBase + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + ')' + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + ')' <-||- 
     -||-> $RandomConversionSyntax += $ToInt16 + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + '(' + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + $RandomStringSyntax + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + ')' + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + ',' + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + $EncodingBase + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + ')' + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + ( -||-> Get-Random -Input @( -||-> '-as','-As','-aS','-AS' <-||- ) <-||- ) + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + "[$CharStr]" <-||- 
     -||-> $RandomConversionSyntax = ( -||-> Get-Random -Input $RandomConversionSyntax <-||- ) <-||- 

    
     -||-> $EncodedArray = '' <-||- 
     -||-> ( -||-> [Char[]]$ScriptString <-||- ) | ForEach-Object { -||-> $EncodedArray += ( -||-> [Convert]::ToString(( -||-> [Int][Char]$_ <-||- ),$EncodingBase) + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + ',' + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) <-||- ) <-||- } <-||- 

    
     -||-> $EncodedArray = ( -||-> '(' + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + $EncodedArray.Trim().Trim(',') + ')' <-||- ) <-||- 

    
    
    
    
     -||-> $SetOfsVarSyntax      = @() <-||- 
     -||-> $SetOfsVarSyntax     += 'Set-Item' + ' '*( -||-> Get-Random -Input @( -||-> 1,2 <-||- ) <-||- ) + "'Variable:OFS'" + ' '*( -||-> Get-Random -Input @( -||-> 1,2 <-||- ) <-||- ) + "''" <-||- 
     -||-> $SetOfsVarSyntax     += ( -||-> Get-Random -Input @( -||-> 'Set-Variable','SV','SET' <-||- ) <-||- ) + ' '*( -||-> Get-Random -Input @( -||-> 1,2 <-||- ) <-||- ) + "'OFS'" + ' '*( -||-> Get-Random -Input @( -||-> 1,2 <-||- ) <-||- ) + "''" <-||- 
     -||-> $SetOfsVar            = ( -||-> Get-Random -Input $SetOfsVarSyntax <-||- ) <-||- 

     -||-> $SetOfsVarBackSyntax  = @() <-||- 
     -||-> $SetOfsVarBackSyntax += 'Set-Item' + ' '*( -||-> Get-Random -Input @( -||-> 1,2 <-||- ) <-||- ) + "'Variable:OFS'" + ' '*( -||-> Get-Random -Input @( -||-> 1,2 <-||- ) <-||- ) + "' '" <-||- 
     -||-> $SetOfsVarBackSyntax += ( -||-> Get-Random -Input @( -||-> 'Set-Variable','SV','SET' <-||- ) <-||- ) + ' '*( -||-> Get-Random -Input @( -||-> 1,2 <-||- ) <-||- ) + "'OFS'" + ' '*( -||-> Get-Random -Input @( -||-> 1,2 <-||- ) <-||- ) + "' '" <-||- 
     -||-> $SetOfsVarBack        = ( -||-> Get-Random -Input $SetOfsVarBackSyntax <-||- ) <-||- 

    
     -||-> $SetOfsVar            = ( -||-> [Char[]]$SetOfsVar     | ForEach-Object { -||-> $Char = $_.ToString().ToLower() <-||- ;  -||-> If( -||-> Get-Random -Input @( -||-> 0..1 <-||- ) <-||- ) { -||-> $Char = $Char.ToUpper() <-||- } <-||-   -||-> $Char <-||- } <-||- ) -Join '' <-||- 
     -||-> $SetOfsVarBack        = ( -||-> [Char[]]$SetOfsVarBack | ForEach-Object { -||-> $Char = $_.ToString().ToLower() <-||- ;  -||-> If( -||-> Get-Random -Input @( -||-> 0..1 <-||- ) <-||- ) { -||-> $Char = $Char.ToUpper() <-||- } <-||-   -||-> $Char <-||- } <-||- ) -Join '' <-||- 

    
     -||-> $BaseScriptArray  = @() <-||- 
     -||-> $BaseScriptArray += '(' + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + "'" + $DelimitedEncodedArray + "'." + $Split + "(" + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + "'" + $RandomDelimitersToPrint + "'" + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + ')' + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + '|' + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + $ForEachObject + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + '{' + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + '(' + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + $RandomConversionSyntax + ')' +  ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + '}' + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + ')' <-||- 
     -||-> $BaseScriptArray += '(' + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + "'" + $DelimitedEncodedArray + "'" + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + $RandomDelimitersToPrintForDashSplit + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + '|' + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + $ForEachObject + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + '{' + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + '(' + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + $RandomConversionSyntax + ')' +  ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + '}' + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + ')' <-||- 
     -||-> $BaseScriptArray += '(' + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + $EncodedArray + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + '|' + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + $ForEachObject + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + '{' + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + '(' + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + $RandomConversionSyntax + ')' +  ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + '}' + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + ')' <-||- 
    
    
     -||-> $NewScriptArray   = @() <-||- 
     -||-> $NewScriptArray  += ( -||-> Get-Random -Input $BaseScriptArray <-||- ) + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + $Join + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + "''" <-||- 
     -||-> $NewScriptArray  += $Join + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + ( -||-> Get-Random -Input $BaseScriptArray <-||- ) <-||- 
     -||-> $NewScriptArray  += $StrJoin + '(' + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + "''" + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + ',' + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + ( -||-> Get-Random -Input $BaseScriptArray <-||- ) + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + ')' <-||- 
     -||-> $NewScriptArray  += '"' + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + '$(' + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + $SetOfsVar + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + ')' + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + '"' + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + '+' + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + $StrStr + ( -||-> Get-Random -Input $BaseScriptArray <-||- ) + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + '+' + '"' + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + '$(' + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + $SetOfsVarBack + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + ')' + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + '"' <-||- 

    
     -||-> $NewScript = ( -||-> Get-Random -Input $NewScriptArray <-||- ) <-||- 

    
    
     -||-> $InvokeExpressionSyntax  = @() <-||- 
     -||-> $InvokeExpressionSyntax += ( -||-> Get-Random -Input @( -||-> 'IEX','Invoke-Expression' <-||- ) <-||- ) <-||- 
    
    
    
     -||-> $InvocationOperator = ( -||-> Get-Random -Input @( -||-> '.','&' <-||- ) <-||- ) + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) <-||- 
     -||-> $InvokeExpressionSyntax += $InvocationOperator + "( `$ShellId[1]+`$ShellId[13]+'x')" <-||- 
     -||-> $InvokeExpressionSyntax += $InvocationOperator + "( `$PSHome[" + ( -||-> Get-Random -Input @( -||-> 4,21 <-||- ) <-||- ) + "]+`$PSHome[" + ( -||-> Get-Random -Input @( -||-> 30,34 <-||- ) <-||- ) + "]+'x')" <-||- 
     -||-> $InvokeExpressionSyntax += $InvocationOperator + "( `$env:ComSpec[4," + ( -||-> Get-Random -Input @( -||-> 15,24,26 <-||- ) <-||- ) + ",25]-Join'')" <-||- 
     -||-> $InvokeExpressionSyntax += $InvocationOperator + "((" + ( -||-> Get-Random -Input @( -||-> 'Get-Variable','GV','Variable' <-||- ) <-||- ) + " '*mdr*').Name[3,11,2]-Join'')" <-||- 
     -||-> $InvokeExpressionSyntax += $InvocationOperator + "( " + ( -||-> Get-Random -Input @( -||-> '$VerbosePreference.ToString()','([String]$VerbosePreference)' <-||- ) <-||- ) + "[1,3]+'x'-Join'')" <-||- 
    
    

    
     -||-> $InvokeExpression = ( -||-> Get-Random -Input $InvokeExpressionSyntax <-||- ) <-||- 

    
     -||-> $InvokeExpression = ( -||-> [Char[]]$InvokeExpression | ForEach-Object { -||-> $Char = $_.ToString().ToLower() <-||- ;  -||-> If( -||-> Get-Random -Input @( -||-> 0..1 <-||- ) <-||- ) { -||-> $Char = $Char.ToUpper() <-||- } <-||-   -||-> $Char <-||- } <-||- ) -Join '' <-||- 
    
    
     -||-> $InvokeOptions  = @() <-||- 
     -||-> $InvokeOptions += ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + $InvokeExpression + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + '(' + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + $NewScript + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + ')' + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) <-||- 
     -||-> $InvokeOptions += ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + $NewScript + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + '|' + ' '*( -||-> Get-Random -Input @( -||-> 0,1 <-||- ) <-||- ) + $InvokeExpression <-||- 

     -||-> $NewScript = ( -||-> Get-Random -Input $InvokeOptions <-||- ) <-||- 

    
     -||-> If( -||-> !$PSBoundParameters['PassThru'] <-||- )
    {
        
         -||-> $PowerShellFlags = @() <-||- 

        
        
         -||-> $CommandlineOptions =  -||-> New-Object String[]( -||-> 0 <-||- ) <-||-  <-||- 
         -||-> If( -||-> $PSBoundParameters['NoExit'] <-||- )
        {
           -||-> $FullArgument = "-NoExit" <-||- ;
           -||-> $CommandlineOptions += $FullArgument.SubString(0,( -||-> Get-Random -Minimum 4 -Maximum ( -||-> $FullArgument.Length+1 <-||- ) <-||- )) <-||- 
        } <-||- 
         -||-> If( -||-> $PSBoundParameters['NoProfile'] <-||- )
        {
           -||-> $FullArgument = "-NoProfile" <-||- ;
           -||-> $CommandlineOptions += $FullArgument.SubString(0,( -||-> Get-Random -Minimum 4 -Maximum ( -||-> $FullArgument.Length+1 <-||- ) <-||- )) <-||- 
        } <-||- 
         -||-> If( -||-> $PSBoundParameters['NonInteractive'] <-||- )
        {
           -||-> $FullArgument = "-NonInteractive" <-||- ;
           -||-> $CommandlineOptions += $FullArgument.SubString(0,( -||-> Get-Random -Minimum 5 -Maximum ( -||-> $FullArgument.Length+1 <-||- ) <-||- )) <-||- 
        } <-||- 
         -||-> If( -||-> $PSBoundParameters['NoLogo'] <-||- )
        {
           -||-> $FullArgument = "-NoLogo" <-||- ;
           -||-> $CommandlineOptions += $FullArgument.SubString(0,( -||-> Get-Random -Minimum 4 -Maximum ( -||-> $FullArgument.Length+1 <-||- ) <-||- )) <-||- 
        } <-||- 
         -||-> If( -||-> $PSBoundParameters['WindowStyle'] -OR $WindowsStyle <-||- )
        {
             -||-> $FullArgument = "-WindowStyle" <-||- 
             -||-> If( -||-> $WindowsStyle <-||- ) { -||-> $ArgumentValue = $WindowsStyle <-||- }
            Else { -||-> $ArgumentValue = $PSBoundParameters['WindowStyle'] <-||- } <-||- 

            
            Switch( -||-> $ArgumentValue.ToLower() <-||- )
            {
                'normal'    { -||-> If( -||-> Get-Random -Input @( -||-> 0..1 <-||- ) <-||- ) { -||-> $ArgumentValue = ( -||-> Get-Random -Input @( -||-> '0','n','no','nor','norm','norma' <-||- ) <-||- ) <-||- } <-||- }
                'hidden'    { -||-> If( -||-> Get-Random -Input @( -||-> 0..1 <-||- ) <-||- ) { -||-> $ArgumentValue = ( -||-> Get-Random -Input @( -||-> '1','h','hi','hid','hidd','hidde' <-||- ) <-||- ) <-||- } <-||- }
                'minimized' { -||-> If( -||-> Get-Random -Input @( -||-> 0..1 <-||- ) <-||- ) { -||-> $ArgumentValue = ( -||-> Get-Random -Input @( -||-> '2','mi','min','mini','minim','minimi','minimiz','minimize' <-||- ) <-||- ) <-||- } <-||- }
                'maximized' { -||-> If( -||-> Get-Random -Input @( -||-> 0..1 <-||- ) <-||- ) { -||-> $ArgumentValue = ( -||-> Get-Random -Input @( -||-> '3','ma','max','maxi','maxim','maximi','maximiz','maximize' <-||- ) <-||- ) <-||- } <-||- }
                default { -||-> Write-Error "An invalid `$ArgumentValue value ($ArgumentValue) was passed to switch block for Out-PowerShellLauncher." <-||- ; Exit;}
            }

             -||-> $PowerShellFlags += $FullArgument.SubString(0,( -||-> Get-Random -Minimum 2 -Maximum ( -||-> $FullArgument.Length+1 <-||- ) <-||- )) + ' '*( -||-> Get-Random -Minimum 1 -Maximum 3 <-||- ) + $ArgumentValue <-||- 
        } <-||- 
         -||-> If( -||-> $PSBoundParameters['ExecutionPolicy'] -OR $ExecutionPolicy <-||- )
        {
             -||-> $FullArgument = "-ExecutionPolicy" <-||- 
             -||-> If( -||-> $ExecutionPolicy <-||- ) { -||-> $ArgumentValue = $ExecutionPolicy <-||- }
            Else { -||-> $ArgumentValue = $PSBoundParameters['ExecutionPolicy'] <-||- } <-||- 
            
             -||-> $ExecutionPolicyFlags = @() <-||- 
             -||-> $ExecutionPolicyFlags += '-EP' <-||- 
            For( -||-> $Index=3 <-||- ;  -||-> $Index -le $FullArgument.Length <-||- ;  -||-> $Index++ <-||- )
            {
                 -||-> $ExecutionPolicyFlags += $FullArgument.SubString(0,$Index) <-||- 
            }
             -||-> $ExecutionPolicyFlag =  -||-> Get-Random -Input $ExecutionPolicyFlags <-||-  <-||- 
             -||-> $PowerShellFlags += $ExecutionPolicyFlag + ' '*( -||-> Get-Random -Minimum 1 -Maximum 3 <-||- ) + $ArgumentValue <-||- 
        } <-||- 
        
        
        
         -||-> If( -||-> $CommandlineOptions.Count -gt 1 <-||- )
        {
             -||-> $CommandlineOptions =  -||-> Get-Random -InputObject $CommandlineOptions -Count $CommandlineOptions.Count <-||-  <-||- 
        } <-||- 

        
         -||-> If( -||-> $PSBoundParameters['Command'] <-||- )
        {
             -||-> $FullArgument = "-Command" <-||- 
             -||-> $CommandlineOptions += $FullArgument.SubString(0,( -||-> Get-Random -Minimum 2 -Maximum ( -||-> $FullArgument.Length+1 <-||- ) <-||- )) <-||- 
        } <-||- 

        
        For( -||-> $i=0 <-||- ;  -||-> $i -lt $PowerShellFlags.Count <-||- ;  -||-> $i++ <-||- )
        {
             -||-> $PowerShellFlags[$i] = ( -||-> [Char[]]$PowerShellFlags[$i] | ForEach-Object { -||-> $Char = $_.ToString().ToLower() <-||- ;  -||-> If( -||-> Get-Random -Input @( -||-> 0..1 <-||- ) <-||- ) { -||-> $Char = $Char.ToUpper() <-||- } <-||-   -||-> $Char <-||- } <-||- ) -Join '' <-||- 
        }

        
         -||-> $CommandlineOptions = ( -||-> $CommandlineOptions | ForEach-Object { -||-> $_ + " "*( -||-> Get-Random -Minimum 1 -Maximum 3 <-||- ) <-||- } <-||- ) -Join '' <-||- 
         -||-> $CommandlineOptions = " "*( -||-> Get-Random -Minimum 0 -Maximum 3 <-||- ) + $CommandlineOptions + " "*( -||-> Get-Random -Minimum 0 -Maximum 3 <-||- ) <-||- 

        
         -||-> If( -||-> $PSBoundParameters['Wow64'] <-||- )
        {
             -||-> $CommandLineOutput = "C:\WINDOWS\SysWOW64\WindowsPowerShell\v1.0\powershell.exe $( -||-> $CommandlineOptions <-||- ) `"$NewScript`"" <-||- 
        }
        Else
        {
            
            
             -||-> $CommandLineOutput = "powershell $( -||-> $CommandlineOptions <-||- ) `"$NewScript`"" <-||- 
        } <-||- 

        
         -||-> $CmdMaxLength = 8190 <-||- 
         -||-> If( -||-> $CommandLineOutput.Length -gt $CmdMaxLength <-||- )
        {
                 -||-> Write-Warning "This command exceeds the cmd.exe maximum allowed length of $CmdMaxLength characters! Its length is $( -||-> $CmdLineOutput.Length <-||- ) characters." <-||- 
        } <-||- 
        
         -||-> $NewScript = $CommandLineOutput <-||- 
    } <-||- 

    Return  -||-> $NewScript <-||- 
} <-||- 

