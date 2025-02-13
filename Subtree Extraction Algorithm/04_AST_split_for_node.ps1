#提取所有的深度递归子树
# PipelineAST、AssignmentStatementAST、


#FunctionDefinationAST、
#ifstatementAST、whilestatementAST、forstatementAST
#trystatementAST（其中经常包含 statementblockAST）
function PipelineAST_add_delimiter{
    param (
    [Parameter(Mandatory=$true)]
    [string] $Script_string
    )
    # 获取 PowerShell 脚本的 AST
    [system.string]$ScriptContent = $Script_string
    $scriptContent
    $ast = [System.Management.Automation.Language.Parser]::ParseInput($ScriptContent, [ref]$null, [ref]$null)

   
    $pipelineASTs = $ast.FindAll( { $args[0] -is [System.Management.Automation.Language.PipelineAST] }, $true)
    $AssignmentStatementASTs = $ast.FindAll({param($node) $node -is [System.Management.Automation.Language.AssignmentStatementAST]}, $true)
    $FunctiondefinationASTs =  $ast.FindAll({param($node) $node -is [System.Management.Automation.Language.FunctiondefinitionAST]}, $true)
        
    $ifstatementASTs = $ast.FindAll({param($node) $node -is [System.Management.Automation.Language.ifstatementAST]}, $true)
    $whilestatementASTs  = $ast.FindAll({param($node) $node -is [System.Management.Automation.Language.whilestatementAST]}, $true)
    $forstatementASTs = $ast.FindAll({param($node) $node -is [System.Management.Automation.Language.ForStatementAst]}, $true)

    $TrystatementASTs = $ast.FindAll({param($node) $node -is [System.Management.Automation.Language.trystatementAST]}, $true)    

    
    # 遍历每个 PipelineAST 子树
    Write-Host -ForegroundColor Yellow -BackgroundColor Blue "get the deobfuscated script_part"
    $pipelineASTs.extent.text
    Write-Host -ForegroundColor Yellow -BackgroundColor Blue "get the deobfuscated script_part"

    # 输出修改后的脚本内容
    return $scriptContent
}

#$script_file_path = "D:\BaiduSyncdisk\PowerShell_deobfuscation\dataset_for_my_model\dataset_Power-ASTNN\02_benign_test_obfuscation\origin (2)"
#$script_file_path = "D:\BaiduSyncdisk\PowerShell_deobfuscation\dataset\malware_dataset_2021\mpsd_with_delimeters\test"
#$script_file_path = "D:\BaiduSyncdisk\PowerShell_deobfuscation\dataset_for_my_model\dataset_Power-ASTNN\02_benign_test_obfuscation\origin\datacon2022"
$script_file_path = "D:\BaiduSyncdisk\PowerShell_deobfuscation\dataset_for_my_model\dataset_Power-ASTNN\with_delimeters\all_with_delimeters\mixed_malicious"

$script_output_file_path
$scriptFiles = Get-ChildItem -Path $script_file_path -Filter *.ps1
$scriptFiles.count

# 对脚本按文件大小排序
$scriptFiles = $scriptFiles | Sort-Object -Property Length
$timeOutputFile = "D:\BaiduSyncdisk\PowerShell_deobfuscation\ASTNN_execution_times.txt"
if (Test-Path $timeOutputFile) {
    Remove-Item $timeOutputFile
}


$insertStringStart = " -|||-> "
$insertStringEnd = " <-|||- "
foreach ($scriptFile in $scriptFiles) {
    $scriptFilePath = $scriptFile.FullName
    $scriptContent = Get-Content $scriptFilePath -Raw
    Set-Content -Path $scriptFilePath -Value $scriptContent -Encoding UTF8
}

foreach ($scriptFile in $scriptFiles) {

    # 计算每个脚本的处理时间
    $startTime = Get-Date

    # 获取脚本文件的路径
    $scriptFilePath = $scriptFile.FullName
    $scriptFilePath
    # 读取脚本文件的内容
    $scriptContent =[IO.File]::ReadAllText((Resolve-Path $scriptFilePath ))
    #$scriptContent = Get-Content $scriptFilePath -Raw
    #$scriptContent
    $ast = [System.Management.Automation.Language.Parser]::ParseInput($scriptContent, [ref]$null, [ref]$null)
    
    $pipelineASTs = $ast.FindAll( { $args[0] -is [System.Management.Automation.Language.PipelineAST] }, $true)
    $AssignmentStatementASTs = $ast.FindAll( { $args[0] -is [System.Management.Automation.Language.AssignmentStatementAst] }, $true)
    $FunctiondefinationASTs =  $ast.FindAll( { $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $true)
    
    $ifstatementASTs = $ast.FindAll( { $args[0] -is [System.Management.Automation.Language.IfStatementAst] }, $true)
    $whilestatementASTs = $ast.FindAll( { $args[0] -is [System.Management.Automation.Language.WhileStatementAst] }, $true)
    $forstatementASTs = $ast.FindAll({ $args[0] -is [System.Management.Automation.Language.ForEachStatementAst] }, $true)
    $trystatementASTs =  $ast.FindAll({ $args[0] -is [System.Management.Automation.Language.TryStatementAst] }, $true)

    $offset_sets = @()
    $start_offset_set = @()
    $end_offset_set = @() 

    #01pipelineAST
    foreach ($pipelineAST in $pipelineASTs){
        $left =  $pipelineAST.extent.startoffset
        $right = $pipelineAST.extent.Endoffset
        $offset_pair = "$left,$right"
        $offset_sets += $offset_pair
    }

    #02AssignmentStatementAST
    foreach ($item in $AssignmentStatementASTs){
        $left = $item.extent.startoffset
        $right = $item.extent.endoffset
        $offset_pair = "$left,$right"
        $offset_sets += $offset_pair
    }

    #03FunctionStatementAST
    foreach ($item in $FunctiondefinationASTs){
        $left = $item.extent.startoffset
        $right = $item.extent.endoffset
        $offset_pair = "$left,$right"
        $offset_sets += $offset_pair
    }
    #04forstatementAST
    foreach ($item in $forstatementASTs){
        $left = $item.extent.startoffset
        $right = $item.extent.endoffset
        $offset_pair = "$left,$right"
        $offset_sets += $offset_pair
    }
    #05WhilestatementAST
   foreach ($item in $whilestatementASTs){
    $left = $item.extent.startoffset
    $right = $item.extent.endoffset
    $offset_pair = "$left,$right"
    $offset_sets += $offset_pair
    }
    #06ifstatementAST
    foreach ($item in $ifstatementASTs){
    $left = $item.extent.startoffset
    $right = $item.extent.endoffset
    $offset_pair = "$left,$right"
    $offset_sets += $offset_pair
    }
    #07trystatementAST
    foreach ($item in $trystatementASTs){
        $left = $item.extent.startoffset
        $right = $item.extent.endoffset
        $offset_pair = "$left,$right"
        $offset_sets += $offset_pair
    }


    foreach ($offsetPair in $offset_sets) {
        $start_offset,$end_offset =$offsetPair.split(',')
        $start_offset_set += [int]$start_offset
        $end_offset_set += [Int]$end_offset
        
    }

#没有真正地排序

    $int_start_Array = $start_offset_set | Sort-Object
    write-host $int_start_Array

    $int_end_Array = $end_offset_set | Sort-Object
    write-host $int_end_Array
    $script_add_delimeters = ""
    #$script_test = ""

    $int_start_Array_copy = $int_start_Array
    $int_end_Array_copy = $int_end_Array

    for([int]$i = 0; $i -lt $scriptcontent.length + 1; $i++){
        $flag = 1
        foreach($start in $int_start_Array){            
            if ($start -eq $i){
                if($i -eq $temp_start){
                    continue
                }else{
                    $temp_start = $i
                    [int]$count_start = 0
                    $count_start = $int_start_Array_copy | Where-Object { $_ -eq $temp_start } | Measure-Object | Select-Object -ExpandProperty Count
                    
                    for ($t = 0; $t -lt $count_start; $t++){
                    $script_add_delimeters = $script_add_delimeters +' -||-> '
                    #write-host "add start"
                }
            $script_add_delimeters += $scriptContent[$i]
            $flag = 0
                }
                
            }
        }
        foreach($end in $int_end_Array){
            #计算出现重复数字的次数
            if($end -eq $i){
                if($i -eq $temp_end){
                    continue
                }else{
                $temp_end = $i
                [int]$count_end = 0
                $count_end = $int_end_Array_copy | Where-Object { $_ -eq $temp_end } | Measure-Object | Select-Object -ExpandProperty Count
                
                for ($s = 0; $s -lt $count_end; $s++){
                    $script_add_delimeters = $script_add_delimeters + ' <-||- '
                    #write-host "add end"    
                }

                $script_add_delimeters += $scriptContent[$i]
                $flag = 0
                }
            }
        }
        if($flag -eq 0){
            continue
        }else{
            $script_add_delimeters += $scriptContent[$i]
        }
    }
    #$script_test
    write-host $script_add_delimeters
    Set-Content -Path $scriptFilePath -Value $script_add_delimeters -Encoding UTF8
    

    #计算结束时间戳
    $endTime = Get-Date
    $duration = $endTime - $startTime
    $seconds = $duration.TotalSeconds

    # 将每个脚本的执行时间（秒）写入文件
    Add-Content -Path $timeOutputFile -Value ("{0} took {1:N2} seconds" -f $scriptFile.Name, $seconds)



}
<#
遇到的坑： $scriptcontent.length + 1 否则匹配不到最后一个
          迷之循环错误，详见041样本
          起点offset和终点offset数量一定匹配，但是有可能会有重复值，每次循环一个字符，只能完成一次替换，然后就步进到下一个了
    #>



