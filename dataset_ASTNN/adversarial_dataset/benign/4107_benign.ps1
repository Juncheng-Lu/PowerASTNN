




 -||-> function ConvertTo-ScriptExtent {
    
    [CmdletBinding()]
    [OutputType([System.Management.Automation.Language.IScriptExtent])]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName='ByOffset')]
        [Alias('StartOffset', 'Offset')]
        [int]
        $StartOffsetNumber,

        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName='ByOffset')]
        [Alias('EndOffset')]
        [int]
        $EndOffsetNumber,

        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName='ByPosition')]
        [Alias('StartLine', 'Line')]
        [int]
        $StartLineNumber,

        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName='ByPosition')]
        [Alias('StartColumn', 'Column')]
        [int]
        $StartColumnNumber,

        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName='ByPosition')]
        [Alias('EndLine')]
        [int]
        $EndLineNumber,

        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName='ByPosition')]
        [Alias('EndColumn')]
        [int]
        $EndColumnNumber,

        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName='ByPosition')]
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName='ByOffset')]
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName='ByBuffer')]
        [Alias('File', 'FileName')]
        [string]
        $FilePath = $psEditor.GetEditorContext().CurrentFile.Path,

        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName='ByBuffer')]
        [Alias('Start')]
        [Microsoft.PowerShell.EditorServices.BufferPosition]
        $StartBuffer,

        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName='ByBuffer')]
        [Alias('End')]
        [Microsoft.PowerShell.EditorServices.BufferPosition]
        $EndBuffer,

        [Parameter(Mandatory,
                   ValueFromPipeline,
                   ValueFromPipelineByPropertyName,
                   ParameterSetName='ByExtent')]
        [System.Management.Automation.Language.IScriptExtent]
        $Extent
    )
    begin {
         -||-> $fileContext = $psEditor.GetEditorContext().CurrentFile <-||- 
         -||-> $emptyExtent =  -||-> New-Object Microsoft.PowerShell.EditorServices.FullScriptExtent @(
              -||-> $fileContext,
             0,
             0 <-||- ) <-||-  <-||- 
    }
    process {
        
         -||-> $returnAsIs = $Extent -and
                     ( -||-> 0 -ne $Extent.StartOffset   -or
                      0 -ne $Extent.EndOffset     -or
                      $Extent -eq $emptyExtent <-||- ) <-||- 

         -||-> if ( -||-> $returnAsIs <-||- ) { return  -||-> $Extent <-||-  } <-||- 

         -||-> if ( -||-> $StartOffsetNumber <-||- ) {
             -||-> $startOffset = $StartOffsetNumber <-||- 
             -||-> $endOffset   = $EndOffsetNumber <-||- 

            
             -||-> if ( -||-> -not $EndOffsetNumber <-||- ) {
                 -||-> $endOffset = $startOffset <-||- 
            } <-||- 
            return  -||-> New-Object Microsoft.PowerShell.EditorServices.FullScriptExtent @(
                 -||-> $fileContext,
                $startOffset,
                $endOffset <-||- ) <-||- 
        } <-||- 
         -||-> if ( -||-> -not $StartBuffer <-||- ) {
             -||-> if ( -||-> -not $StartColumnNumber <-||- ) {  -||-> $StartColumnNumber = 1 <-||-  } <-||- 
             -||-> if ( -||-> -not $StartLineNumber <-||- )   {  -||-> $StartLineNumber   = 1 <-||-  } <-||- 
             -||-> $StartBuffer =  -||-> New-Object Microsoft.PowerShell.EditorServices.BufferPosition @(
                 -||-> $StartLineNumber,
                $StartColumnNumber <-||- ) <-||-  <-||- 

             -||-> if ( -||-> $EndLineNumber -and $EndColumnNumber <-||- ) {
                 -||-> $EndBuffer =  -||-> New-Object Microsoft.PowerShell.EditorServices.BufferPosition @(
                     -||-> $EndLineNumber,
                    $EndColumnNumber <-||- ) <-||-  <-||- 
            } <-||- 
        } <-||- 
         -||-> if ( -||-> -not $EndBuffer <-||- ) {  -||-> $EndBuffer = $StartBuffer <-||-  } <-||- 

         -||-> $bufferRange =  -||-> New-Object Microsoft.PowerShell.EditorServices.BufferRange @(
             -||-> $StartBuffer,
            $EndBuffer <-||- ) <-||-  <-||- 

        return  -||-> New-Object Microsoft.PowerShell.EditorServices.FullScriptExtent @(
             -||-> $fileContext,
            $bufferRange <-||- ) <-||- 
    }
} <-||- 


