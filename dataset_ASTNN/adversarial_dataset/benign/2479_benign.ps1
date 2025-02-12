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


