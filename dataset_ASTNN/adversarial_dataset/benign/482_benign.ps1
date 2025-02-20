
 -||-> function ConvertTo-CContainerInheritanceFlags
{
    
    [CmdletBinding()]
    [OutputType([Carbon.Security.ContainerInheritanceFlags])]
    param(
        [Parameter(Mandatory=$true,Position=0)]
        [Security.AccessControl.InheritanceFlags]
        
        $InheritanceFlags,

        [Parameter(Mandatory=$true,Position=1)]
        [Security.AccessControl.PropagationFlags]
        
        $PropagationFlags
    )

     -||-> Set-StrictMode -Version 'Latest' <-||- 

     -||-> Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState <-||- 

     -||-> $propFlagsNone = $PropagationFlags -eq [Security.AccessControl.PropagationFlags]::None <-||- 
     -||-> $propFlagsInheritOnly = $PropagationFlags -eq [Security.AccessControl.PropagationFlags]::InheritOnly <-||- 
     -||-> $propFlagsInheritOnlyNoPropagate = $PropagationFlags -eq ( -||-> [Security.AccessControl.PropagationFlags]::InheritOnly -bor [Security.AccessControl.PropagationFlags]::NoPropagateInherit <-||- ) <-||- 
     -||-> $propFlagsNoPropagate = $PropagationFlags -eq [Security.AccessControl.PropagationFlags]::NoPropagateInherit <-||- 

     -||-> if(  -||-> $InheritanceFlags -eq [Security.AccessControl.InheritanceFlags]::None <-||-  )
    {
        return  -||-> [Carbon.Security.ContainerInheritanceFlags]::Container <-||- 
    }
    elseif(  -||-> $InheritanceFlags -eq [Security.AccessControl.InheritanceFlags]::ContainerInherit <-||-  )
    {
         -||-> if(  -||-> $propFlagsInheritOnly <-||-  )
        {
            return  -||-> [Carbon.Security.ContainerInheritanceFlags]::SubContainers <-||- 
        }
        elseif(  -||-> $propFlagsInheritOnlyNoPropagate <-||-  )
        {
            return  -||-> [Carbon.Security.ContainerInheritanceFlags]::ChildContainers <-||- 
        }
        elseif(  -||-> $propFlagsNone <-||-  )
        {
            return  -||-> [Carbon.Security.ContainerInheritanceFlags]::ContainerAndSubContainers <-||- 
        }
        elseif(  -||-> $propFlagsNoPropagate <-||-  )
        {
            return  -||-> [Carbon.Security.ContainerInheritanceFlags]::ContainerAndChildContainers <-||- 
        } <-||- 
    }
    elseif(  -||-> $InheritanceFlags -eq [Security.AccessControl.InheritanceFlags]::ObjectInherit <-||-  )
    {
         -||-> if(  -||-> $propFlagsInheritOnly <-||-  )
        {
            return  -||-> [Carbon.Security.ContainerInheritanceFlags]::Leaves <-||- 
        }
        elseif(  -||-> $propFlagsInheritOnlyNoPropagate <-||-  )
        {
            return  -||-> [Carbon.Security.ContainerInheritanceFlags]::ChildLeaves <-||- 
        }
        elseif(  -||-> $propFlagsNone <-||-  )
        {
            return  -||-> [Carbon.Security.ContainerInheritanceFlags]::ContainerAndLeaves <-||- 
        }
        elseif(  -||-> $propFlagsNoPropagate <-||-  )
        {
            return  -||-> [Carbon.Security.ContainerInheritanceFlags]::ContainerAndChildLeaves <-||- 
        } <-||- 
    }
    elseif(  -||-> $InheritanceFlags -eq ( -||-> [Security.AccessControl.InheritanceFlags]::ContainerInherit -bor [Security.AccessControl.InheritanceFlags]::ObjectInherit <-||-  ) <-||-  )
    {
         -||-> if(  -||-> $propFlagsInheritOnly <-||-  )
        {
            return  -||-> [Carbon.Security.ContainerInheritanceFlags]::SubContainersAndLeaves <-||- 
        }
        elseif(  -||-> $propFlagsInheritOnlyNoPropagate <-||-  )
        {
            return  -||-> [Carbon.Security.ContainerInheritanceFlags]::ChildContainersAndChildLeaves <-||- 
        }
        elseif(  -||-> $propFlagsNone <-||-  )
        {
            return  -||-> [Carbon.Security.ContainerInheritanceFlags]::ContainerAndSubContainersAndLeaves <-||- 
        }
        elseif(  -||-> $propFlagsNoPropagate <-||-  )
        {
            return  -||-> [Carbon.Security.ContainerInheritanceFlags]::ContainerAndChildContainersAndChildLeaves <-||- 
        } <-||- 
    } <-||- 
} <-||- 


