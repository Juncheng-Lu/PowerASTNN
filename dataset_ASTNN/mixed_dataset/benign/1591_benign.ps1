 -||-> function Get-SCCMDeviceCollectionDeployment
{

    [CmdletBinding()]
    PARAM
    (
        [Parameter(Mandatory)]
        [System.String]$DeviceName,

        [Parameter(Mandatory)]
        [System.String]$SiteCode,

        [Parameter(Mandatory)]
        [System.String]$ComputerName,

        [Alias('RunAs')]
        [pscredential]
        [System.Management.Automation.Credential()]
        $Credential = [System.Management.Automation.PSCredential]::Empty,

        [ValidateSet('Required', 'Available')]
        [System.String]$Purpose
    )

    BEGIN
    {
         -||-> $FunctionName = ( -||-> Get-Variable -Scope 1 -Name MyInvocation -ValueOnly <-||- ).MyCommand.Name <-||- 

         -||-> Write-Verbose -Message "[$FunctionName] Create splatting" <-||- 

        
         -||-> $Splatting = @{
            ComputerName =  -||-> $ComputerName <-||- 
            NameSpace =  -||-> "root\SMS\Site_$SiteCode" <-||- 
        } <-||- 

         -||-> IF ( -||-> $PSBoundParameters['Credential'] <-||- )
        {
             -||-> Write-Verbose -Message "[$FunctionName] Append splatting" <-||- 
             -||-> $Splatting.Credential = $Credential <-||- 
        } <-||- 

        Switch ( -||-> $Purpose <-||- )
        {
            "Required" {  -||-> $DeploymentIntent = 0 <-||-  }
            "Available" {  -||-> $DeploymentIntent = 2 <-||-  }
            default {  -||-> $DeploymentIntent = "NA" <-||-  }
        }

         -||-> Write-Verbose -Message "[$FunctionName] Define helper functions" <-||- 
         -||-> Write-Verbose -Message "[$FunctionName] helper function: Get-SCCMDeploymentIntentName" <-||- 
         -||-> Function Get-SCCMDeploymentIntentName
        {
                PARAM(
                [Parameter(Mandatory)]
                $DeploymentIntent
                )
                    PROCESS
                    {
                 -||-> if ( -||-> $DeploymentIntent = 0 <-||- ) {  -||-> Write-Output "Required" <-||-  } <-||- 
                 -||-> if ( -||-> $DeploymentIntent = 2 <-||- ) {  -||-> Write-Output "Available" <-||-  } <-||- 
                 -||-> if ( -||-> $DeploymentIntent -ne 0 -and $DeploymentIntent -ne 2 <-||- ) {  -||-> Write-Output "NA" <-||-  } <-||- 
            }
        } <-||-  

         -||-> Write-Verbose -Message "[$FunctionName] helper function: Get-SCCMDeploymentTypeName" <-||- 
         -||-> function Get-SCCMDeploymentTypeName
        {
            
            PARAM ($TypeID)
            switch ( -||-> $TypeID <-||- )
            {
                1 {  -||-> "Application" <-||-  }
                2 {  -||-> "Program" <-||-  }
                3 {  -||-> "MobileProgram" <-||-  }
                4 {  -||-> "Script" <-||-  }
                5 {  -||-> "SoftwareUpdate" <-||-  }
                6 {  -||-> "Baseline" <-||-  }
                7 {  -||-> "TaskSequence" <-||-  }
                8 {  -||-> "ContentDistribution" <-||-  }
                9 {  -||-> "DistributionPointGroup" <-||-  }
                10{  -||-> "DistributionPointHealth" <-||-  }
                11{  -||-> "ConfigurationPolicy" <-||-  }
            }
        } <-||- 

    }
    PROCESS
    {
         -||-> TRY
        {

             -||-> Write-Verbose -Message "[$FunctionName] Retrieving Device '$DeviceName'..." <-||- 
             -||-> $Device =  -||-> Get-WMIObject @Splatting -Query "Select * From SMS_R_SYSTEM WHERE Name='$DeviceName'" <-||-  <-||- 

             -||-> Write-Verbose -Message "[$FunctionName] Retrieving collection(s) where the device is member..." <-||- 
             -||-> Get-WmiObject -Class sms_fullcollectionmembership @splatting -Filter "ResourceID = '$( -||-> $Device.resourceid <-||- )'" | ForEach-Object {

                 -||-> Write-Verbose -Message "[$FunctionName] Retrieving collection '$( -||-> $_.Collectionid <-||- )'..." <-||- 
                 -||-> $Collections =  -||-> Get-WmiObject @splatting -Query "Select * From SMS_Collection WHERE CollectionID='$( -||-> $_.Collectionid <-||- )'" <-||-  <-||- 

                 -||-> Foreach ($Collection in  -||-> $collections <-||- )
                {
                     -||-> IF ( -||-> $DeploymentIntent -eq 'NA' <-||- )
                    {
                         -||-> Write-Verbose -Message "[$FunctionName] DeploymentIntent is not specified" <-||- 
                         -||-> $Deployments = ( -||-> Get-WmiObject @splatting -Query "Select * From SMS_DeploymentInfo WHERE CollectionID='$( -||-> $Collection.CollectionID <-||- )'" <-||- ) <-||- 
                    }
                    ELSE
                    {
                         -||-> Write-Verbose -Message "[$FunctionName] DeploymentIntent '$DeploymentIntent'" <-||- 
                         -||-> $Deployments = ( -||-> Get-WmiObject @splatting -Query "Select * From SMS_DeploymentInfo WHERE CollectionID='$( -||-> $Collection.CollectionID <-||- )' AND DeploymentIntent='$DeploymentIntent'" <-||- ) <-||- 
                    } <-||- 

                     -||-> Foreach ($Deploy in  -||-> $Deployments <-||- )
                    {
                         -||-> Write-Verbose -Message "[$FunctionName] Retrieving DeploymentType..." <-||- 
                         -||-> $TypeName =  -||-> Get-SCCMDeploymentTypeName -TypeID $Deploy.DeploymentTypeid <-||-  <-||- 
                         -||-> if ( -||-> -not $TypeName <-||- ) {  -||-> $TypeName =  -||-> Get-SCCMDeploymentTypeName -TypeID $Deploy.DeploymentType <-||-  <-||-  } <-||- 

                        
                         -||-> Write-Verbose -Message "[$FunctionName] Preparing output..." <-||- 
                         -||-> $Properties = @{
                            DeviceName =  -||-> $DeviceName <-||- 
                            ComputerName =  -||-> $ComputerName <-||- 
                            CollectionName =  -||-> $Deploy.CollectionName <-||- 
                            CollectionID =  -||-> $Deploy.CollectionID <-||- 
                            DeploymentID =  -||-> $Deploy.DeploymentID <-||- 
                            DeploymentName =  -||-> $Deploy.DeploymentName <-||- 
                            DeploymentIntent =  -||-> $deploy.DeploymentIntent <-||- 
                            DeploymentIntentName =  -||-> ( -||-> Get-SCCMDeploymentIntentName -DeploymentIntent $deploy.DeploymentIntent <-||- ) <-||- 
                            DeploymentTypeName =  -||-> $TypeName <-||- 
                            TargetName =  -||-> $Deploy.TargetName <-||- 
                            TargetSubName =  -||-> $Deploy.TargetSubname <-||- 

                        } <-||- 

                        
                         -||-> Write-Verbose -Message "[$FunctionName] Output information" <-||- 
                         -||-> New-Object -TypeName PSObject -prop $Properties <-||- 

                        
                         -||-> $TypeName="" <-||- 
                    } <-||- 
                } <-||- 
            } <-||- 
        }
        CATCH{
             -||-> $PSCmdlet.ThrowTerminatingError() <-||- 
        } <-||- 
    }
} <-||- 


