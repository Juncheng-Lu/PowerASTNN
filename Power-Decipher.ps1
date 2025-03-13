$currentFilePath = $PSScriptRoot

$sampleFolderPath = Join-Path -Path $currentFilePath -ChildPath "Obfuscated_File"
$resultFolderPath = Join-Path -Path $currentFilePath -ChildPath "Deobfucated_AMSI"
$fasttext_Path = Join-Path -Path $currentFilePath -ChildPath "fasttext_replace"
$final_Path = Join-Path -Path $currentFilePath -ChildPath "final_output"
$pythonScriptPath = Join-Path -Path $currentFilePath -ChildPath "replace-obfuscation.py"


if (-not (Test-Path -Path $resultFolderPath)) {
    New-Item -ItemType Directory -Path $resultFolderPath
}
if (-not (Test-Path -Path $fasttext_Path)) {
    New-Item -ItemType Directory -Path $fasttext_Path
}
if (-not (Test-Path -Path $final_Path)) {
    New-Item -ItemType Directory -Path $final_Path
}


Get-ChildItem -Path $resultFolderPath -File | Remove-Item -Force
Get-ChildItem -Path $fasttext_Path -File | Remove-Item -Force
Get-ChildItem -Path $final_Path -File | Remove-Item -Force


Get-ChildItem -Path $sampleFolderPath -File | ForEach-Object {

    $ScriptPath0 = $_.FullName

    $job = Start-Job -ScriptBlock {
        $ErrorActionPreference = 'SilentlyContinue'
        $WarningPreference = 'SilentlyContinue'
        $ProgressPreference = 'SilentlyContinue'
        $ConfirmPreference = 'None'
        $InformationPreference = 'SilentlyContinue'
        $ProgressPreference = 'SilentlyContinue'

        $process_ps1 = Join-Path -Path $using:currentFilePath -ChildPath "01_Memory_dump.ps1"
        & $process_ps1 -Script_Path $using:ScriptPath0 
    } 
    

    $timeoutSeconds = 120


    if (Wait-Job $job -Timeout $timeoutSeconds) {
        $result = Receive-Job $job
        Write-Host "$result"
    } else {

        Stop-Job $job -PassThru | Remove-Job
        Write-Warning "timeout"
    }


    if ($job.State -eq 'Completed') {
        Remove-Job $job -Force
    }
    
    $resultString = [System.String]$result

    $resultFilePath = Join-Path -Path $resultFolderPath -ChildPath $_.Name

    Out-File -FilePath $resultFilePath -Encoding default -InputObject $resultString
}

Write-Host "The first stage of processing is completed, and the results are saved in: $resultFolderPath"

Get-ChildItem -Path $resultFolderPath -File | ForEach-Object {

    $Script_Path0 = $_.FullName
    $Script_OutputPath = Join-Path -Path $fasttext_Path -ChildPath $_.Name
    $out_PSSCriptRoot = $PSScriptRoot
    $process_AST_ps1 = $out_PSSCriptRoot + '\' + "02_CommandExpressionAST.ps1"

    $result = & $process_AST_ps1 -Script_Path $Script_Path0 -Script_OutputPath $Script_OutputPath
}

Write-Host "The second stage has been processed and the results have been saved in: $fasttext_Path"

& python $pythonScriptPath
