#input01: A obfuscated Script or Path
#input02：An AST of A obfuscated Script

#output01 in terminal: the origin Script
#output02 in terminal: the Script's all commandexpressionASTs' extent, which contain the System.String and Other Types
#output03 in terminal: the System.String Dict
#output04 in file and terminal: row i is the obfuscated text, row i+1 is the deobfuscated text

# We don't change the origin Script

param(
    [Parameter(Mandatory = $false)]
        [string] $Amsi_Path = "C:\Amsi_recorder_log",
    [Parameter(Mandatory = $true)]
        [string] $Script_Path,
    [Parameter(Mandatory = $true)]
        [string] $Script_OutputPath

)


function Get-Ast {
  param (
      [object] $InputObject
  )

  $ast = switch ($InputObject) {
      {$_ -is [string]} {
          if (Test-Path -LiteralPath $_) {
              $path = Resolve-Path -Path $_
              [System.Management.Automation.Language.Parser]::ParseFile($path.ProviderPath, [ref]$null, [ref]$null)
          }
          else {
              [System.Management.Automation.Language.Parser]::ParseInput($_, [ref]$null, [ref]$null)
          }
          break
      }
      {$_ -is [System.Management.Automation.FunctionInfo] -or
          $_ -is [System.Management.Automation.ExternalScriptInfo]} {
          $InputObject.ScriptBlock.Ast
          break
      }
      {$_ -is [scriptblock]} {
          $_.Ast
          break
      }
      Default {
          throw 'InputObject type not recognised'
      }
  }

  $ast
}

function Out-FileUtf8NoBom {

    <#
    .SYNOPSIS
      Outputs to a UTF-8-encoded file *without a BOM* (byte-order mark).
  
    .DESCRIPTION
  
      Mimics the most important aspects of Out-File:
        * Input objects are sent to Out-String first.
        * -Append allows you to append to an existing file, -NoClobber prevents
          overwriting of an existing file.
        * -Width allows you to specify the line width for the text representations
          of input objects that aren't strings.
      However, it is not a complete implementation of all Out-File parameters:
        * Only a literal output path is supported, and only as a parameter.
        * -Force is not supported.
        * Conversely, an extra -UseLF switch is supported for using LF-only newlines.
  
    .NOTES
      The raison d'être for this advanced function is that Windows PowerShell
      lacks the ability to write UTF-8 files without a BOM: using -Encoding UTF8 
      invariably prepends a BOM.
  
      Copyright (c) 2017, 2022 Michael Klement <mklement0@gmail.com> (http://same2u.net), 
      released under the [MIT license](https://spdx.org/licenses/MIT#licenseText).
  
    #>
  
    [CmdletBinding(PositionalBinding=$false)]
    param(
      [Parameter(Mandatory, Position = 0)] [string] $LiteralPath,
      [switch] $Append,
      [switch] $NoClobber,
      [AllowNull()] [int] $Width,
      [switch] $UseLF,
      [Parameter(ValueFromPipeline)] $InputObject
    )
  
    begin {
  
      # Convert the input path to a full one, since .NET's working dir. usually
      # differs from PowerShell's.
      $dir = Split-Path -LiteralPath $LiteralPath
      if ($dir) { $dir = Convert-Path -ErrorAction Stop -LiteralPath $dir } else { $dir = $pwd.ProviderPath }
      $LiteralPath = [IO.Path]::Combine($dir, [IO.Path]::GetFileName($LiteralPath))
      
      # If -NoClobber was specified, throw an exception if the target file already
      # exists.
      if ($NoClobber -and (Test-Path $LiteralPath)) {
        Throw [IO.IOException] "The file '$LiteralPath' already exists."
      }
      
      # Create a StreamWriter object.
      # Note that we take advantage of the fact that the StreamWriter class by default:
      # - uses UTF-8 encoding
      # - without a BOM.
      $sw = New-Object System.IO.StreamWriter $LiteralPath, $Append
      
      $htOutStringArgs = @{}
      if ($Width) { $htOutStringArgs += @{ Width = $Width } }
  
      try { 
        # Create the script block with the command to use in the steppable pipeline.
        $scriptCmd = { 
          & Microsoft.PowerShell.Utility\Out-String -Stream @htOutStringArgs | 
            . { process { if ($UseLF) { $sw.Write(($_ + "`n")) } else { $sw.WriteLine($_) } } }
        }  
        
        $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
        $steppablePipeline.Begin($PSCmdlet)
      }
      catch { throw }
  
    }
  
    process
    {
      $steppablePipeline.Process($_)
    }
  
    end {
      $steppablePipeline.End()
      $sw.Dispose()
    }
  
  
}

function deal_with_all_commandExpressionAST {
  param (
    [Parameter(Mandatory=$true)]
    [string] $Script_string,
    [string] $Script_OutputPath
  )

  $AST = [System.Management.Automation.Language.Parser]::ParseInput($Script_string, [ref]$null, [ref]$null)
  #$AST = Get-Ast -InputObject $Script_string
  $commandexpression = $AST.FindAll( { $args[0] -is [System.Management.Automation.Language.commandExpressionAst ] }, $true)
  
  Write-Host -BackgroundColor Blue "02: The whole commandExpressionAst's extent is: (all type)"
  write-host $commandexpression.extent.text
  Write-Host -BackgroundColor Blue "02: commandExpressionAst's extent end `n"

  #Part 2: Get A dict, key: extent of obfuscated, value: [startOffset, endOffset], we use the value to declude whether has a subtree
  #remove the duplicate keys
  #Invoke-Command, only the System.String Object is the key we need.
  $sequence_words_and_offsets = [ordered]@{}

  for ($i = 0; $i -lt $commandexpression.Count; $i++) {
      
      $type_name = Invoke-Command -ScriptBlock { 
          param($p1)
          $p1
          # Write-Host $i
          # Write-Host $p1
          try {
              $run_result = try {
                Invoke-Expression -Command $p1
              }
              catch {
                # Write-Host "================hhhhhhhhhhhhhhhhhhhhh"
              } 
          }
          catch {
              #throw "out of control"
              $run_result = [Type]("go to")
              <#Do this if a terminating exception happens#>
          }
          Write-Host $run_result
          try {
              $Member_all_info = try {
                Get-Member -InputObject $run_result}catch [InvalidOperationException]{
                  "no result,it's not a system.string" }
              $Member_all_info.TypeName[0]
          }
          catch {
              <#Do this if a terminating exception happens#>
          }
          
                                                                                        
      } -ArgumentList $commandexpression[$i].extent.Text
      $type_name

      
      if (($Type_Name -eq "System.String")) {

          try {
              $sequence_words_and_offsets.Add($commandexpression[$i].extent.Text, @($commandexpression[$i].extent.StartOffset, $commandexpression[$i].extent.EndOffset))
          }
          catch {
              "already add this key!"
          }
      }
  }
  #
  Write-Host -BackgroundColor Blue "03: The System.String dict is "
  $sequence_words_and_offsets
  Write-Host -BackgroundColor Blue "03: The dict is end `n"


  #Part 3: Input a dict: $sequence_words_and_offsets, the key is only System.String, the value is the [Startoffset,endOffset]
          # Invoke-command the key, we can get the de-obfuscated key 

  Write-Host -BackgroundColor Blue "04 all the text we need to replace and write to file"
  $offset = 0
  # bug,watch out the {}
  $sequence_words_and_offsets.GetEnumerator() | ForEach-Object {          
    if ($_.Value[0] -lt $offset ) {   
      #continue
      }    
    else {
          #$local_variable = ". C:\Users\Lsz\Documents\BaiduSyncdisk\PowerShell_deobfuscation\dataset\origin\804.ps1 `n"          
          #$result_key = Invoke-Expression -Command $_.key          
          #. C:\Users\Lsz\Documents\BaiduSyncdisk\PowerShell_deobfuscation\dataset\origin\988.ps1
          
          $result_key = Invoke-Expression -Command $_.key
          #$result_key = Invoke-Expression -Command $_.key
          
          #$result_key = $($_.key) 
          #$_.key
          #$result_key
          $PSDefaultParameterValues['*:Encoding'] = 'Default'
          #default we don't record "text" to text
          if($_.key.length -ne $result_key.length + 2) {
            #if($False -ne $result_key){
              out-File -FilePath $Script_OutputPath -Append -Encoding default -InputObject "0000000000"
              out-file -FilePath $Script_OutputPath -Append -Encoding default -InputObject $_.Key
              out-File -FilePath $Script_OutputPath -Append -Encoding default -InputObject "1111111111"
              out-File -FilePath $Script_OutputPath -Append -Encoding default -InputObject $result_key
              out-File -FilePath $Script_OutputPath -Append -Encoding default -InputObject "0000000000"
            #}
          }
          
          #Out-FileUtf8NoBom -LiteralPath $Script_OutputPath -Append -InputObject $_.key
          #Out-FileUtf8NoBom -LiteralPath $Script_OutputPath -Append -InputObject $re
          
          
          $sub_AST = [System.Management.Automation.Language.Parser]::ParseInput($result_key, [ref]$null, [ref]$null)
          $sub_commandexpression = $sub_AST.FindAll( { $args[0] -is [System.Management.Automation.Language.commandExpressionAst ] }, $true)
          
          if ($sub_commandexpression.Count -ge 1) {
            try {
              deal_with_all_commandExpressionAST -script_string $result_key -Script_OutputPath $Script_OutputPath
              Write-Host -ForegroundColor black -BackgroundColor Yellow "deal with the sub_commandexpressionAST" 
            }
            catch {
              <#Do this if a terminating exception happens#>
              #Write-Host -BackgroundColor Blue "deal with the sub_commandexpressionAST"

            }
          } 
          $offset = $_.Value[1]     
       }   
    }
    
  Write-Host -BackgroundColor Blue "04 End `n"
}





$ScriptString0 = [IO.File]::ReadAllText((Resolve-Path $Script_Path))



$rs = deal_with_all_commandExpressionAST -Script_string $ScriptString0 -Script_OutputPath $Script_OutputPath
write-output $rs

