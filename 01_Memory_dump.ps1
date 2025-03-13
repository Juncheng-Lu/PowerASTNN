param(
    [Parameter(Mandatory = $false)]
        [string] $Amsi_Path = "C:\Amsi_recorder_log",
    [Parameter(Mandatory = $true)]
        [string] $Script_Path
)

function Amsi_Parser {
    param (
        [Parameter(Mandatory = $true)]
        [string] $Amsi_Path,
        [string] $Script_string
    )

    #merge and replace ; to \n


   
    <#
     
    $tokens = $null
    $parseErrors = $null
    $null = [System.Management.Automation.Language.Parser]::ParseInput($Script_string, [ref]$tokens, [ref]$parseErrors)

    if ($parseErrors.Count -gt 0) {
        #Write-Host "parse error :"
        $parseErrors | ForEach-Object { Write-Host $_ }
    } else {
    
        #$tokens | ForEach-Object {
           # Write-Host "Token 类型: $($_.Kind), 内容: $($_.Text)"
        #}
    }

    
    $modifiedScript = ''
    foreach ($token in $tokens) {
        if ($token.Kind -eq 'Semi') {
            
            $modifiedScript += "`n"
        } else {
            
            $modifiedScript += $token.Text

        }
    }
    $Script_string = $modifiedScript
    set-content -value $modifiedScript -Path "temp.ps1"
    
    #>
    $SAST =  [System.Management.Automation.Language.Parser]::ParseInput($Script_String, [ref]$null, [ref]$null)
    $Pipelines = $SAST.FindAll( { $args[0] -is [System.Management.Automation.Language.PipelineAST] }, $true)
    $Scripblocks = $SAST.FindAll( { $args[0] -is [System.Management.Automation.Language.ScriptBlockAST] }, $true)

    $start_offset = 0
    $end_offset = 0

    
    
    <#
     for($i = 0; $i -lt $Pipelines.count; $i++){
        write-host -ForegroundColor Black -BackgroundColor Blue "all pipelines  startoffset endoffset"
        write-host $pipelines[$i].extent.startlinenumber
        write-host $pipelines[$i].extent.endlinenumber
        write-host $Pipelines[$i].extent.startoffset
        write-host $Pipelines[$i].extent.endoffset
        write-host -ForegroundColor Black -BackgroundColor Blue "end++++++++++++++++++++++++"
    }   
    #>
    $temp_ast_number = 0
    
    $pipelines_ast_includes = @()
    $pipelines_ast_includes += $Pipelines[0]
    for($i = 1; $i -lt $Pipelines.count; $i++) {
        $current_pipelineast = $Pipelines[$i]
        $previous_pipelineast = $Pipelines[$i - 1]
        if(($current_pipelineast.extent.startoffset -gt $Pipelines[$temp_ast_number].extent.startoffset) -and ($current_pipelineast.extent.endoffset -lt $Pipelines[$temp_ast_number].extent.endoffset)){
              
            continue
        }else{
            $pipelines_ast_includes += $Pipelines[$i]
            $temp_ast_number = $i
        }
    }

    
    <#
    for($i = 0; $i -lt $pipelines_ast_includes.count; $i++){
        write-host -ForegroundColor Black -BackgroundColor white "all pipelines_ast_includs  startoffset endoffset"
        write-host $pipelines_ast_includes[$i].extent.startlinenumber
        write-host $pipelines_ast_includes[$i].extent.endlinenumber
        write-host $Pipelines_ast_includes[$i].extent.startoffset
        write-host $Pipelines_ast_includes[$i].extent.endoffset
        write-host $Pipelines_ast_includes[$i].extent.text
        write-host -ForegroundColor Black -BackgroundColor white "end++++++++++++++++++++++++"
    }
    #>


    
    $pipelines_set = @()
    $key = 0
    $pipelines_set += $pipelines_ast_includes[0].extent.text
    $pipelines_string_endoffset = @()
    $pipelines_string_endoffset += $pipelines_ast_includes[0].extent.startOffset
    $pipelines_ast_endoffset =@()
    $pipelines_ast_endoffset += $pipelines_ast_includes[0].extent.endoffset

    for($i = 1; $i -lt $pipelines_ast_includes.count; $i++) {
        $current_pipelineast = $pipelines_ast_includes[$i]
        $previous_pipelineast = $pipelines_ast_includes[$i - 1]
        #$current_pipelineast.extent
        #$previous_pipelineast.extent
        if(($current_pipelineast.extent.startlinenumber -eq $previous_pipelineast.extent.endlinenumber) -and (($current_pipelineast.extent.startoffset - $previous_pipelineast.extent.endoffset) -lt 10 ) ){
            
            <#
            
            $start_offset = $previous_pipelineast.extent.endoffset 
            $end_offset = $current_pipelineast.extent.startoffset 
            echo "start"
            
            $start_offset
            $end_offset
            echo "end"
            try {
                 $middle_text = $Script_string.Substring($start_offset + 1, $end_offset-$start_offset - 1)
            }
            catch {
                #$middle_text = ""
            }
               
            $pipelines_set[$key] = $pipelines_set[$key] + $middle_text + $current_pipelineast.extent.text
            #record Substring_number
            #>
            $pipelines_ast_endoffset[$key] = $current_pipelineast.extent.endoffset
            #$pipelines_string_endoffset[$key]
            
            $pipelines_set[$key]  = $Script_string.Substring( $pipelines_string_endoffset[$key], $pipelines_ast_endoffset[$key] - $pipelines_string_endoffset[$key] + 1)
        }else{
            #$pipelines_set += $current_pipelineast.extent.text
            $pipelines_set += $current_pipelineast.extent.text
            $pipelines_string_endoffset += $current_pipelineast.extent.startOffset
            $pipelines_ast_endoffset += $current_pipelineast.extent.endoffset
            $key = $key + 1
        }
    }
    $pipelines_string_set = @()


    for($i = 0; $i -lt $pipelines_string_endoffset.count; $i++){
        
        #$pipelines_string_set += $Script_string.Substring(0,[int]$pipelines_string_endoffset[$i] - 1)
        <#
               
        #>
        try {
            $pipelines_string_set += $Script_string.Substring(0,[int]$pipelines_string_endoffset[$i] - 1)

        } catch [System.ArgumentOutOfRangeException] {
            
            
            $pipelines_string_set += "000"
        } 

    }
   
    <#
     write-host -ForegroundColor Black -BackgroundColor white "pipelines_set"
    write-host $pipelines_set[-1]
    $byteCount = [System.Text.Encoding]::UTF8.GetByteCount($pipelines_set[-1])
    Write-Host "pipelines_set字符串的字节数为: $byteCount"
    write-host -ForegroundColor Black -BackgroundColor white "end"

        write-host -ForegroundColor Black -BackgroundColor white "pipelines_string_set"
    write-host $pipelines_string_set[-1]
    $byteCount = [System.Text.Encoding]::UTF8.GetByteCount($pipelines_string_set[-1])
    Write-Host "pipelines_string_set字符串的字节数为: $byteCount"
    write-host -ForegroundColor Black -BackgroundColor white "end"
    #>


    #Write-Host -ForegroundColor Green -BackgroundColor Black "Amsi_Parser results:   ----------------------------"
    for($i = 0; $i -lt $pipelines_set.count; $i++){
       
       #set-content -value $pipelines_set[$i] -Path "pipelines_$i.ps1"
       
        # Write-Host -ForegroundColor Black -BackgroundColor Blue "all [string][text]PipelinesAsts we need are here:"+ "$i"
        #$pipelines_set[$i]
        #Write-Host -ForegroundColor Black -BackgroundColor Blue "all [int]Pipelines_string_startoffset are here:"+ "$i"
        
        ##$pipelines_string_endoffset[$i]
        #Write-Host -ForegroundColor Black -BackgroundColor Blue "all [string][text]Pipelines_strings are here:"+ "$i"
        #$pipelines_string_set[$i]
    }
    #Write-Host -ForegroundColor Green -BackgroundColor Black "Amsi_Parser results end:   ----------------------------"

    
    $results = @()
    for($i = 0; $i -lt $pipelines_string_endoffset.count; $i++){


        $results += dealwith_pipeline_Ast -Amsi_Path "C:\Amsi_recorder_log" -Pipeline_string $pipelines_string_set[$i] -Pipeline $pipelines_set[$i]
        #$results += dealwith_pipeline_Ast -Amsi_Path "C:\Amsi_recorder_log" -Pipeline_string $pipelines_string_set[$i] -Pipeline $s
    }
    $final_results = @()

    
    for ($i = 0; $i -lt $results.count; $i++) {
        $currentString = $results[$i]

        
        try {
            $endChars = $currentString.Substring($currentString.Length - 20)
        }
        catch {
            continue
        }
        
        if (($endChars -eq ('r' * 20)) -or ($endChars -eq ('e' * 20)) ){
            $final_results += $currentString
        }
    }

    $final_results_no_delimeters = @()
    #ready to replace the obfuscated part, if length -eq 0, do not replace 
    foreach ($item in $final_results){
        $final_results_no_delimeters += $item.Substring(0,$item.length - 20)
        
    }
    #dealwith_pipeline_Ast -Amsi_Path "C:\Amsi_recorder_log" -Pipeline_string $pipelines_string_set[1] -Pipeline $pipelines_set[1]
    for($i = 0; $i -lt $final_results.count; $i++){
        #Write-Host -ForegroundColor Yellow -BackgroundColor Blue "replace pipelinges result is:"
        #Write-Host $final_results_no_delimeters[$i]
        #Write-Host -ForegroundColor Yellow -BackgroundColor Blue "replace pipelinges result is: end"
    }
    for($i = 0; $i -lt $final_results.count; $i++){
        
        #$pipelines_set[$i].length
        #Write-Host -ForegroundColor Red -BackgroundColor Blue "will be replaced as "
        #Write-Host $final_results_no_delimeters[$i]
        #Write-Host -ForegroundColor Yellow -BackgroundColor Blue "----------------------------------"
        #$Script_string = $Script_string -replace [regex]::Escape([string]($pipelines_set[$i])), $final_results_no_delimeters[$i]
        
    }

    
    for($i=$final_results.count - 1; $i -ge 0; $i--){
        
        $start = $pipelines_string_endoffset[$i]  
        
        $length = $pipelines_set[$i].length
        
        $end = $pipelines_string_endoffset[$i] + $length #200+501=701
        
        <#
        Write-Host -ForegroundColor Yellow -BackgroundColor Blue "----------------------------------"
        $start
        $end
        #>
        
        $Script_string = [string]$Script_string

        #Write-Host -ForegroundColor Yellow -BackgroundColor Blue "start+++++++++++++++++++++++++++++++++"
        #$Script_string.Substring(0,$start)
        #Write-Host -ForegroundColor Yellow -BackgroundColor Blue "middle+++++++++++++++++++++++++++++++++"
        #$final_results_no_delimeters[$i]
        #Write-Host -ForegroundColor Yellow -BackgroundColor Blue "end+++++++++++++++++++++++++++++++++"
        #$Script_string.Substring($end, $Script_string.length-$end)
        #Write-Host -ForegroundColor Yellow -BackgroundColor Blue "----------------------------------"
        #$Script_string = $Script_string.Substring(0,$start) + $final_results_no_delimeters[$i] + $Script_string.Substring($end)
        $Script_string = [string]$Script_string.Substring(0,$start) + [string]$final_results_no_delimeters[$i] + [string]$Script_string.Substring($end, $Script_string.length-$end)
        
        #$Script_string.Substring(0,$start)
        #$final_results_no_delimeters[$i]
        
        #$Script_string.Substring($end, $Script_string.length-$end)
    }
    Write-Host "------------final----------------------"
    #Write-Host -ForegroundColor Yellow -BackgroundColor Blue $Script_string
    Write-output $Script_string
}
#0 100-200  300-400 500-700  1000
#  100-110  300-350 500-600
#      1-499 500-600 701-1000
# 0-299    300-350   401 -end
function dealwith_pipeline_Ast {
    param (
        [Parameter(Mandatory = $true)]
        [string] $Amsi_Path ,
        [string] $Pipeline_string,
        [string] $Pipeline,
        [string] $deobfuscated_file
    )
    $ErrorActionPreference = 'SilentlyContinue'
    $WarningPreference = 'SilentlyContinue'
    $ProgressPreference = 'SilentlyContinue'
    $ConfirmPreference = 'None'
    $InformationPreference = 'SilentlyContinue'
    $ProgressPreference = 'SilentlyContinue'
    Get-ChildItem $Amsi_Path -File | Remove-Item -Force

    #Write-Host -ForegroundColor Black -BackgroundColor Yellow "01 execute the former script_string to get all the variables: "
    #write-host $Pipeline_String 
    Invoke-Expression $Pipeline_string 
    # delete the remain amsi_log
    Get-ChildItem $Amsi_Path -File | Remove-Item -Force

    #Write-Host -ForegroundColor Black -BackgroundColor Yellow "02 invoke pipeline "
    #write-host $pipeline

    #Invoke-Expression $Pipeline
    try {
        Invoke-Expression $pipeline
    }
    catch {
        "the Origin script is something wrong"
    }

    #start-sleep 1
    $all_pipeline_scripts = Get-ChildItem $Amsi_Path -File
    #| Sort-Object -Name
    $session_number = ($all_pipeline_scripts[0].name.split('_'))[0]
    if ($session_number -eq 0){
        $session_number = ($all_pipeline_scripts[1].name.split('_'))[0]
    }

    #$matchingFiles = Get-ChildItem -Path $Amsi_Path | Where-Object { $_.Name -like "$session_number" + "_*" }
    
    $matchingFiles = Get-ChildItem -Path $Amsi_Path
    
    
    $all_scripts_path = $matchingFiles.FullName

    $sorted_paths = $all_scripts_path | Sort-Object { [System.IO.Path]::GetFileName($_) }

    $all_scripts_path = $sorted_paths
    Write-Host -ForegroundColor Black -BackgroundColor Yellow "all script path is  "
    write-host $all_scripts_path 
    #write-host $session_number
    #Write-Host -ForegroundColor Black -BackgroundColor Yellow "end"

    if($all_scripts_path.count -eq 1){
        $deobfuscated_file = $pipeline
        return $deobfuscated_file+"rrrrrrrrrrrrrrrrrrrr"
    }

    #Write-Host -ForegroundColor Black -BackgroundColor Yellow "03 all memory dump scripts' directory are here: "
    #$all_scripts_path
    
    
    $pipeline_scriptstring = Get-Content $all_scripts_path[0] -Raw 

    #所有脚本块的set
    $KAST =  [System.Management.Automation.Language.Parser]::ParseInput($pipeline, [ref]$null, [ref]$null)
    $ScriptBlockAst = $KAST.FindAll( { $args[0] -is [System.Management.Automation.Language.ScriptBlockAST] }, $true)
    
    #write-host $bytes.length

    $scriptblock_set = @()

    for($i=0; $i -lt $ScriptBlockAst.count; $i++){
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($ScriptBlockAst[$i].extent.text)
 
        if($pipeline.length -eq $bytes.length){
            continue
        }else{
            $scriptblock_set +=  $ScriptBlockAst.Extent.text
        }  
    }
    #Write-Host -ForegroundColor Yellow -BackgroundColor Blue "all scriptblock is "
    #write-host $scriptblock_set
    #Write-Host -ForegroundColor Yellow -BackgroundColor Blue "end `n "
    #now we deobfuscated the $deobfuscated_file, cuz there will be more obfuscatd file
    #Write-Host -ForegroundColor Yellow -BackgroundColor Blue "get the deobfuscated script_part"
    #deal with Fragmented_AST
    
    $deobfuscated_file = $Pipeline
    $start_flag = 0
    Write-Host -ForegroundColor Red -BackgroundColor black "script count "
    write-host $all_scripts_path.count
    for($i = 0; $i -lt $all_scripts_path.count; $i++){
        Write-Host -ForegroundColor Red -BackgroundColor black "now script path is "
        write-host $all_scripts_path[$i]
        if($start_flag -eq 0){
            $start_flag = 1
            continue
        }else{
            $next_script = Get-Content -path  $all_scripts_path[$i] -Raw
            
            if($scriptblock_set -contains $next_script) {
                continue
            
            }elseif($next_script -match 'Author="Microsoft Corporation"'){
                continue
            }elseif($next_script -match 'RUntIME.inTeRoPSErvices.mARSHal'){
                continue
            }
            else{

                $deobfuscated_file = $next_script
                Write-Host -ForegroundColor Red -BackgroundColor black "get the deobfuscated script_part, ready or not? "
                $lines = $deobfuscated_file.Split("`n")

                if($lines.count -ge 3 ){
                    Write-Host -ForegroundColor Red -BackgroundColor black "lines count > 1,this is the deobfuscated part"
                    write-host $all_scripts_path[$i]
                    break
                }else{
                    Write-Host -ForegroundColor Red -BackgroundColor black "lines count = 1 ,need next file"
                    write-host $all_scripts_path[$i]
                    continue
                    
                }
            }
        }
    }
<#
ForEach ($item in $all_scripts_path) {
        if($start_flag -eq 0){
            $start_flag = 1
            continue
        }else{
            $next_script = Get-Content $item -Raw  

            
            if ($scriptblock_set -contains $next_script) {
                continue
            
            }elseif($next_script -match 'Author="Microsoft Corporation"'){
                continue
            }elseif($next_script -match 'RUntIME.inTeRoPSErvices.mARSHal'){
                continue
            }
            else{

                $deobfuscated_file = $next_script
                Write-Host -ForegroundColor Red -BackgroundColor black "get the deobfuscated script_part"
                write-host $deobfuscated_file
                $lines = $deobfuscated_file -split "`n"
                if($lines.count -eq 1){
                    
                }else{
                    break
                }
            }
        }

#>
    
    if($deobfuscated_file.length -le 5 ){
        $deobfuscated_file =  $Pipeline
    }
    
    return $deobfuscated_file+"rrrrrrrrrrrrrrrrrrrr"
    <#
    $AST =  [System.Management.Automation.Language.Parser]::ParseInput($deobfuscated_file, [ref]$null, [ref]$null)
    $Pipelines = $AST.FindAll( { $args[0] -is [System.Management.Automation.Language.PipelineAST] }, $true)
    
    if($Pipelines.count -eq 0){
        #Write-Host -ForegroundColor Red -BackgroundColor black "This is the final deobfuscated part for this pipeline"
        return $deobfuscated_file+"rrrrrrrrrrrrrrrrrrrr"
    }else{
        #Write-Host -ForegroundColor Red -BackgroundColor black "There is more Obfuscated parts in this pipelineast, go deep!"
        #write-host $pipelines.count
        #Amsi_Parser -Amsi_Path $Amsi_Path  -Script_String $deobfuscated_file
        return $deobfuscated_file+"rrrrrrrrrrrrrrrrrrrr"
    }
    #>

    
}




$Script_string = Get-Content -Path $Script_Path -Raw
Get-ChildItem "C:\Amsi_recorder_log" -File | Remove-Item -Force
$rs =  Amsi_Parser -Amsi_Path $Amsi_Path -Script_String $Script_string 
write-output $rs
