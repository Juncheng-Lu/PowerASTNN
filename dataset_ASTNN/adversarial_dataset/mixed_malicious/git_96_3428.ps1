














 -||-> function Test-GetSubscriptionsEndToEnd
{
	 -||-> $allSubscriptions =  -||-> Get-AzureRmSubscription <-||-  <-||- 
	 -||-> $firstSubscription = $allSubscriptions[0] <-||- 
	 -||-> $id = $firstSubscription.Id <-||- 
	 -||-> $tenant = $firstSubscription.TenantId <-||- 
	 -||-> $name = $firstSubscription.Name <-||- 
	 -||-> $subscription = $firstSubscription <-||- 
	 -||-> Assert-True {  -||-> $subscription -ne $null <-||-  } <-||- 
	 -||-> Assert-AreEqual $id $subscription.Id <-||- 
	 -||-> $subscription =  -||-> Get-AzureRmSubscription -SubscriptionId $id <-||-  <-||- 
	 -||-> Assert-True {  -||-> $subscription -ne $null <-||-  } <-||- 
	 -||-> Assert-AreEqual $id $subscription.Id <-||- 
	 -||-> $subscription =  -||-> Get-AzureRmSubscription -SubscriptionName $name -Tenant $tenant <-||-  <-||- 
	 -||-> Assert-True {  -||-> $subscription -ne $null <-||-  } <-||- 
	 -||-> Assert-AreEqual $name $subscription.Name <-||- 
	 -||-> $subscription =  -||-> Get-AzureRmSubscription -SubscriptionName $name <-||-  <-||- 
	 -||-> Assert-True {  -||-> $subscription -ne $null <-||-  } <-||- 
	 -||-> Assert-AreEqual $name $subscription.Name <-||- 
	 -||-> $subscription =  -||-> Get-AzureRmSubscription -SubscriptionName $name.ToUpper() <-||-  <-||- 
	 -||-> Assert-True {  -||-> $subscription -ne $null <-||-  } <-||- 
	 -||-> Assert-AreEqual $name $subscription.Name <-||- 
	 -||-> $mostSubscriptions =  -||-> Get-AzureRmSubscription <-||-  <-||- 
	 -||-> Assert-True { -||-> $mostSubscriptions.Count -gt 0 <-||- } <-||- 
	 -||-> $tenantSubscriptions =  -||-> Get-AzureRmSubscription -Tenant $tenant <-||-  <-||- 
	 -||-> Assert-True { -||-> $tenantSubscriptions.Count -gt 0 <-||- } <-||- 
} <-||- 

 -||-> function Test-PipingWithContext
{
     -||-> $allSubscriptions =  -||-> Get-AzureRmSubscription <-||-  <-||- 
	 -||-> $firstSubscription = $allSubscriptions[0] <-||- 
	 -||-> $id = $firstSubscription.Id <-||- 
	 -||-> $name = $firstSubscription.Name <-||- 
	 -||-> $nameContext =  -||-> Get-AzureRmSubscription -SubscriptionName $name | Set-AzureRmContext <-||-  <-||- 
	 -||-> $idContext =  -||-> Get-AzureRmSubscription -SubscriptionId $id | Set-AzureRmContext <-||-  <-||- 
	 -||-> $contextByName =  -||-> Set-AzureRmContext -SubscriptionName $name <-||-  <-||- 
	 -||-> Assert-True {  -||-> $nameContext -ne $null <-||-  } <-||- 
	 -||-> Assert-True {  -||-> $nameContext.Subscription -ne $null <-||-  } <-||- 
	 -||-> Assert-True {  -||-> $nameContext.Subscription.Id -ne $null <-||-  } <-||- 
	 -||-> Assert-True {  -||-> $nameContext.Subscription.Name -ne $null <-||-  } <-||- 
	 -||-> Assert-True {  -||-> $idContext -ne $null <-||-  } <-||- 
	 -||-> Assert-True {  -||-> $idContext.Subscription -ne $null <-||-  } <-||- 
	 -||-> Assert-True {  -||-> $idContext.Subscription.Id -ne $null <-||-  } <-||- 
	 -||-> Assert-True {  -||-> $idContext.Subscription.Name -ne $null <-||-  } <-||- 
	 -||-> Assert-AreEqual $idContext.Subscription.Id  $nameContext.Subscription.Id <-||- 
	 -||-> Assert-AreEqual $idContext.Subscription.Name  $nameContext.Subscription.Name <-||- 
	 -||-> Assert-True {  -||-> $contextByName -ne $null <-||-  } <-||- 
	 -||-> Assert-True {  -||-> $contextByName.Subscription -ne $null <-||-  } <-||- 
	 -||-> Assert-True {  -||-> $contextByName.Subscription.Id -ne $null <-||-  } <-||- 
	 -||-> Assert-True {  -||-> $contextByName.Subscription.Name -ne $null <-||-  } <-||- 
	 -||-> Assert-AreEqual $contextByName.Subscription.Name  $nameContext.Subscription.Name <-||- 
} <-||- 

 -||-> function Test-SetAzureRmContextEndToEnd
{
    
	 -||-> $allSubscriptions =  -||-> Get-AzureRmSubscription <-||-  <-||- 
     -||-> $secondSubscription = $allSubscriptions[1] <-||- 
     -||-> Assert-True {  -||-> $allSubscriptions[0] -ne $null <-||-  } <-||- 
	 -||-> Assert-True {  -||-> $secondSubscription -ne $null <-||-  } <-||- 
     -||-> Set-AzureRmContext -SubscriptionId $secondSubscription.Id <-||- 
     -||-> $context =  -||-> Get-AzureRmContext <-||-  <-||- 
     -||-> Assert-AreEqual $context.Subscription.Id $secondSubscription.Id <-||- 
     -||-> $junkSubscriptionId = "49BC3D95-9A30-40F8-81E0-3CDEF0C3F8A5" <-||- 
     -||-> Assert-ThrowsContains { -||-> Set-AzureRmContext -SubscriptionId $junkSubscriptionId <-||- } "Please provide a valid tenant or a valid subscription." <-||- 
} <-||- 

 -||-> function Test-SetAzureRmContextWithoutSubscription
{
     -||-> $allSubscriptions =  -||-> Get-AzureRmSubscription <-||-  <-||- 
     -||-> $firstSubscription = $allSubscriptions[0] <-||- 
     -||-> $id = $firstSubscription.Id <-||- 
     -||-> $tenantId = $firstSubscription.TenantId <-||- 

     -||-> Assert-True {  -||-> $tenantId -ne $null <-||-  } <-||- 

     -||-> Set-AzureRmContext -TenantId $tenantId <-||- 
     -||-> $context =  -||-> Get-AzureRmContext <-||-  <-||- 

     -||-> Assert-True {  -||-> $context.Subscription -ne $null <-||-  } <-||- 
     -||-> Assert-True {  -||-> $context.Tenant -ne $null <-||-  } <-||- 
     -||-> Assert-AreEqual $context.Tenant.Id $firstSubscription.TenantId <-||- 
     -||-> Assert-AreEqual $context.Subscription.Id $firstSubscription.Id <-||- 
} <-||- 

 -||-> [String] $PsCredmanUtils = @"
using System;
using System.Runtime.InteropServices;

namespace PsUtils
{
    public class CredMan
    {
        
        // DllImport derives from System.Runtime.InteropServices
        [DllImport("Advapi32.dll", SetLastError = true, EntryPoint = "CredDeleteW", CharSet = CharSet.Unicode)]
        private static extern bool CredDeleteW([In] string target, [In] CRED_TYPE type, [In] int reservedFlag);

        [DllImport("Advapi32.dll", SetLastError = true, EntryPoint = "CredEnumerateW", CharSet = CharSet.Unicode)]
        private static extern bool CredEnumerateW([In] string Filter, [In] int Flags, out int Count, out IntPtr CredentialPtr);

        [DllImport("Advapi32.dll", SetLastError = true, EntryPoint = "CredFree")]
        private static extern void CredFree([In] IntPtr cred);

        [DllImport("Advapi32.dll", SetLastError = true, EntryPoint = "CredReadW", CharSet = CharSet.Unicode)]
        private static extern bool CredReadW([In] string target, [In] CRED_TYPE type, [In] int reservedFlag, out IntPtr CredentialPtr);

        [DllImport("Advapi32.dll", SetLastError = true, EntryPoint = "CredWriteW", CharSet = CharSet.Unicode)]
        private static extern bool CredWriteW([In] ref Credential userCredential, [In] UInt32 flags);
        

        
        public enum CRED_FLAGS : uint
        {
            NONE = 0x0,
            PROMPT_NOW = 0x2,
            USERNAME_TARGET = 0x4
        }

        public enum CRED_ERRORS : uint
        {
            ERROR_SUCCESS = 0x0,
            ERROR_INVALID_PARAMETER = 0x80070057,
            ERROR_INVALID_FLAGS = 0x800703EC,
            ERROR_NOT_FOUND = 0x80070490,
            ERROR_NO_SUCH_LOGON_SESSION = 0x80070520,
            ERROR_BAD_USERNAME = 0x8007089A
        }

        public enum CRED_PERSIST : uint
        {
            SESSION = 1,
            LOCAL_MACHINE = 2,
            ENTERPRISE = 3
        }

        public enum CRED_TYPE : uint
        {
            GENERIC = 1,
            DOMAIN_PASSWORD = 2,
            DOMAIN_CERTIFICATE = 3,
            DOMAIN_VISIBLE_PASSWORD = 4,
            GENERIC_CERTIFICATE = 5,
            DOMAIN_EXTENDED = 6,
            MAXIMUM = 7,      // Maximum supported cred type
            MAXIMUM_EX = (MAXIMUM + 1000),  // Allow new applications to run on old OSes
        }

        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
        public struct Credential
        {
            public CRED_FLAGS Flags;
            public CRED_TYPE Type;
            public string TargetName;
            public string Comment;
            public DateTime LastWritten;
            public UInt32 CredentialBlobSize;
            public string CredentialBlob;
            public CRED_PERSIST Persist;
            public UInt32 AttributeCount;
            public IntPtr Attributes;
            public string TargetAlias;
            public string UserName;
        }

        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
        private struct NativeCredential
        {
            public CRED_FLAGS Flags;
            public CRED_TYPE Type;
            public IntPtr TargetName;
            public IntPtr Comment;
            public System.Runtime.InteropServices.ComTypes.FILETIME LastWritten;
            public UInt32 CredentialBlobSize;
            public IntPtr CredentialBlob;
            public UInt32 Persist;
            public UInt32 AttributeCount;
            public IntPtr Attributes;
            public IntPtr TargetAlias;
            public IntPtr UserName;
        }
        

        
        private class CriticalCredentialHandle : Microsoft.Win32.SafeHandles.CriticalHandleZeroOrMinusOneIsInvalid
        {
            public CriticalCredentialHandle(IntPtr preexistingHandle)
            {
                SetHandle(preexistingHandle);
            }

            private Credential XlateNativeCred(IntPtr pCred)
            {
                NativeCredential ncred = (NativeCredential)Marshal.PtrToStructure(pCred, typeof(NativeCredential));
                Credential cred = new Credential();
                cred.Type = ncred.Type;
                cred.Flags = ncred.Flags;
                cred.Persist = (CRED_PERSIST)ncred.Persist;

                long LastWritten = ncred.LastWritten.dwHighDateTime;
                LastWritten = (LastWritten << 32) + ncred.LastWritten.dwLowDateTime;
                cred.LastWritten = DateTime.FromFileTime(LastWritten);

                cred.UserName = Marshal.PtrToStringUni(ncred.UserName);
                cred.TargetName = Marshal.PtrToStringUni(ncred.TargetName);
                cred.TargetAlias = Marshal.PtrToStringUni(ncred.TargetAlias);
                cred.Comment = Marshal.PtrToStringUni(ncred.Comment);
                cred.CredentialBlobSize = ncred.CredentialBlobSize;
                if (0 < ncred.CredentialBlobSize)
                {
                    cred.CredentialBlob = Marshal.PtrToStringUni(ncred.CredentialBlob, (int)ncred.CredentialBlobSize / 2);
                }
                return cred;
            }

            public Credential GetCredential()
            {
                if (IsInvalid)
                {
                    throw new InvalidOperationException("Invalid CriticalHandle!");
                }
                Credential cred = XlateNativeCred(handle);
                return cred;
            }

            public Credential[] GetCredentials(int count)
            {
                if (IsInvalid)
                {
                    throw new InvalidOperationException("Invalid CriticalHandle!");
                }
                Credential[] Credentials = new Credential[count];
                IntPtr pTemp = IntPtr.Zero;
                for (int inx = 0; inx < count; inx++)
                {
                    pTemp = Marshal.ReadIntPtr(handle, inx * IntPtr.Size);
                    Credential cred = XlateNativeCred(pTemp);
                    Credentials[inx] = cred;
                }
                return Credentials;
            }

            override protected bool ReleaseHandle()
            {
                if (IsInvalid)
                {
                    return false;
                }
                CredFree(handle);
                SetHandleAsInvalid();
                return true;
            }
        }
        

        
        public static int CredDelete(string target, CRED_TYPE type)
        {
            if (!CredDeleteW(target, type, 0))
            {
                return Marshal.GetHRForLastWin32Error();
            }
            return 0;
        }

        public static int CredEnum(string Filter, out Credential[] Credentials)
        {
            int count = 0;
            int Flags = 0x0;
            if (string.IsNullOrEmpty(Filter) ||
                "*" == Filter)
            {
                Filter = null;
                if (6 <= Environment.OSVersion.Version.Major)
                {
                    Flags = 0x1; //CRED_ENUMERATE_ALL_CREDENTIALS; only valid is OS >= Vista
                }
            }
            IntPtr pCredentials = IntPtr.Zero;
            if (!CredEnumerateW(Filter, Flags, out count, out pCredentials))
            {
                Credentials = null;
                return Marshal.GetHRForLastWin32Error(); 
            }
            CriticalCredentialHandle CredHandle = new CriticalCredentialHandle(pCredentials);
            Credentials = CredHandle.GetCredentials(count);
            return 0;
        }

        public static int CredRead(string target, CRED_TYPE type, out Credential Credential)
        {
            IntPtr pCredential = IntPtr.Zero;
            Credential = new Credential();
            if (!CredReadW(target, type, 0, out pCredential))
            {
                return Marshal.GetHRForLastWin32Error();
            }
            CriticalCredentialHandle CredHandle = new CriticalCredentialHandle(pCredential);
            Credential = CredHandle.GetCredential();
            return 0;
        }

        public static int CredWrite(Credential userCredential)
        {
            if (!CredWriteW(ref userCredential, 0))
            {
                return Marshal.GetHRForLastWin32Error();
            }
            return 0;
        }

        

        private static int AddCred()
        {
            Credential Cred = new Credential();
            string Password = "Password";
            Cred.Flags = 0;
            Cred.Type = CRED_TYPE.GENERIC;
            Cred.TargetName = "Target";
            Cred.UserName = "UserName";
            Cred.AttributeCount = 0;
            Cred.Persist = CRED_PERSIST.ENTERPRISE;
            Cred.CredentialBlobSize = (uint)Password.Length;
            Cred.CredentialBlob = Password;
            Cred.Comment = "Comment";
            return CredWrite(Cred);
        }

        private static bool CheckError(string TestName, CRED_ERRORS Rtn)
        {
            switch(Rtn)
            {
                case CRED_ERRORS.ERROR_SUCCESS:
                    Console.WriteLine(string.Format("'{0}' worked", TestName));
                    return true;
                case CRED_ERRORS.ERROR_INVALID_FLAGS:
                case CRED_ERRORS.ERROR_INVALID_PARAMETER:
                case CRED_ERRORS.ERROR_NO_SUCH_LOGON_SESSION:
                case CRED_ERRORS.ERROR_NOT_FOUND:
                case CRED_ERRORS.ERROR_BAD_USERNAME:
                    Console.WriteLine(string.Format("'{0}' failed; {1}.", TestName, Rtn));
                    break;
                default:
                    Console.WriteLine(string.Format("'{0}' failed; 0x{1}.", TestName, Rtn.ToString("X")));
                    break;
            }
            return false;
        }

        /*
         * Note: the Main() function is primarily for debugging and testing in a Visual 
         * Studio session.  Although it will work from PowerShell, it's not very useful.
         */
        public static void Main()
        {
            Credential[] Creds = null;
            Credential Cred = new Credential();
            int Rtn = 0;

            Console.WriteLine("Testing CredWrite()");
            Rtn = AddCred();
            if (!CheckError("CredWrite", (CRED_ERRORS)Rtn))
            {
                return;
            }
            Console.WriteLine("Testing CredEnum()");
            Rtn = CredEnum(null, out Creds);
            if (!CheckError("CredEnum", (CRED_ERRORS)Rtn))
            {
                return;
            }
            Console.WriteLine("Testing CredRead()");
            Rtn = CredRead("Target", CRED_TYPE.GENERIC, out Cred);
            if (!CheckError("CredRead", (CRED_ERRORS)Rtn))
            {
                return;
            }
            Console.WriteLine("Testing CredDelete()");
            Rtn = CredDelete("Target", CRED_TYPE.GENERIC);
            if (!CheckError("CredDelete", (CRED_ERRORS)Rtn))
            {
                return;
            }
            Console.WriteLine("Testing CredRead() again");
            Rtn = CredRead("Target", CRED_TYPE.GENERIC, out Cred);
            if (!CheckError("CredRead", (CRED_ERRORS)Rtn))
            {
                Console.WriteLine("if the error is 'ERROR_NOT_FOUND', this result is OK.");
            }
        }
    }
}
"@ <-||- 


 -||-> $PsCredMan = $null <-||- 
 -||-> try
{
     -||-> $PsCredMan = [PsUtils.CredMan] <-||- 
}
catch
{
    
     -||-> $Error.RemoveAt($Error.Count-1) <-||- 
} <-||- 
 -||-> if( -||-> $null -eq $PsCredMan <-||- )
{
     -||-> Add-Type $PsCredmanUtils <-||- 
} <-||- 


 -||-> [HashTable] $ErrorCategory = @{0x80070057 =  -||-> "InvalidArgument" <-||- ;
                               0x800703EC =  -||-> "InvalidData" <-||- ;
                               0x80070490 =  -||-> "ObjectNotFound" <-||- ;
                               0x80070520 =  -||-> "SecurityError" <-||- ;
                               0x8007089A =  -||-> "SecurityError" <-||- } <-||- 

 -||-> function Enum-Creds
{
    Param
    (
        [Parameter(Mandatory=$false)][AllowEmptyString()][String] $Filter = [String]::Empty
    )
    
     -||-> [PsUtils.CredMan+Credential[]] $Creds = [Array]::CreateInstance([PsUtils.CredMan+Credential], 0) <-||- 
     -||-> [Int] $Results = 0 <-||- 
     -||-> try
    {
         -||-> $Results = [PsUtils.CredMan]::CredEnum($Filter, [Ref]$Creds) <-||- 
    }
    catch
    {
        return  -||-> $_ <-||- 
    } <-||- 
    switch( -||-> $Results <-||- )
    {
        0 {break}
        0x80070490 {break} 
        default
        {
             -||-> [String] $Msg = "Failed to enumerate credentials store for user '$Env:UserName'" <-||- 
             -||-> [Management.ManagementException] $MgmtException =  -||-> New-Object Management.ManagementException( -||-> $Msg <-||- ) <-||-  <-||- 
             -||-> [Management.Automation.ErrorRecord] $ErrRcd =  -||-> New-Object Management.Automation.ErrorRecord( -||-> $MgmtException, $Results.ToString("X"), $ErrorCategory[$Results], $null <-||- ) <-||-  <-||- 
            return  -||-> $ErrRcd <-||- 
        }
    }
    return  -||-> $Creds <-||- 
} <-||- 

 -||-> function CredManMain
{

     -||-> $OFS = "`r`n" <-||- 
     -||-> [Object] $Creds =  -||-> Enum-Creds <-||-  <-||- 
     -||-> if( -||-> $Creds -split [Array] -and 0 -eq $Creds.Length <-||- )
    {
         -||-> Write-Output "No Credentials found for $( -||-> $Env:UserName <-||- )" <-||- 
        return
    } <-||- 
     -||-> if( -||-> $Creds -is [Management.Automation.ErrorRecord] <-||- )
    {
        return  -||-> $Creds <-||- 
    } <-||- 
     -||-> Write-Output "+-----------+--------------------------+`n" <-||- 
     -||-> foreach($Cred in  -||-> $Creds <-||- )
    {
         -||-> [String] $CredStr = @"
        
| UserName  | $( -||-> $Cred.UserName <-||- )
| Password  | $( -||-> $Cred.CredentialBlob <-||- )
| Target    | $( -||-> $Cred.TargetName.Substring($Cred.TargetName.IndexOf("=")+1) <-||- )
| Updated   | $( -||-> [String]::Format("{0:yyyy-MM-dd HH:mm:ss}", $Cred.LastWritten.ToUniversalTime()) <-||- ) UTC
| Comment   | $( -||-> $Cred.Comment+$OFS <-||- )
"@ <-||- 

         -||-> $CredStrArry += $CredStr <-||- 
         -||-> Write-Output $CredStr <-||- 
         -||-> Write-Output "+-----------+--------------------------+`n" <-||- 
    } <-||- 
    return
} <-||- 

 -||-> CredManMain <-||- 

