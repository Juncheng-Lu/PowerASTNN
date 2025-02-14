











 -||-> & ( -||-> Join-Path -Path $PSScriptRoot -ChildPath 'Initialize-CarbonTest.ps1' -Resolve <-||- ) <-||- 

 -||-> Describe 'Remove-DotNetAppSetting' {
     -||-> $appSettingName = "TEST_APP_SETTING_NAME" <-||- 
     -||-> $appSettingValue = "TEST_APP_SETTING_VALUE" <-||- 

     -||-> function Assert-AppSetting($Name, $value, [Switch]$Framework, [Switch]$Framework64, [Switch]$Clr2, [Switch]$Clr4)
    {
         -||-> $Name = $Name -replace "'","''" <-||- 
         -||-> $command = @"
            
            Add-Type -AssemblyName System.Configuration
            
            `$config = [Configuration.ConfigurationManager]::OpenMachineConfiguration()
            
            `$appSettings = `$config.AppSettings.Settings
            
            if( `$appSettings['$Name'] )
            {
                `$appSettings['$Name'].Value
            }
            else
            {
                `$null
            }
"@ <-||- 

         -||-> $runtimes = @() <-||- 
         -||-> if(  -||-> $Clr2 <-||-  )
        {
             -||-> $runtimes += 'v2.0' <-||- 
        } <-||- 
         -||-> if(  -||-> $Clr4 <-||-  )
        {
             -||-> $runtimes += 'v4.0' <-||- 
        } <-||- 
        
         -||-> if(  -||-> $runtimes.Length -eq 0 <-||-  )
        {
            throw  -||-> "Must supply either or both the Clr2 and Clr2 switches." <-||- 
        } <-||- 
        
         -||-> $runtimes | ForEach-Object {
             -||-> $params = @{
                Command =  -||-> $command <-||- 
                Encode =  -||-> $true <-||- 
                Runtime =  -||-> $_ <-||- 
            } <-||- 
            
             -||-> if(  -||-> $Framework64 <-||-  )
            {
                 -||-> $actualValue =  -||-> Invoke-PowerShell @params <-||-  <-||- 
                 -||-> $actualValue | Should Be $Value <-||- 
            } <-||- 
            
             -||-> if(  -||-> $Framework <-||-  )
            {
                 -||-> $actualValue =  -||-> Invoke-PowerShell @params -x86 <-||-  <-||- 
                 -||-> $actualValue | Should Be $Value <-||- 
            } <-||- 
        } <-||- 
    } <-||- 

     -||-> function Remove-AppSetting
    {
         -||-> $appSettingName = $appSettingName -replace "'","''" <-||- 
         -||-> $command = @"
            
            Add-Type -AssemblyName System.Configuration
            
            `$config = [Configuration.ConfigurationManager]::OpenMachineConfiguration()
            `$appSettings = `$config.AppSettings.Settings
            if( `$appSettings['$appSettingName'] )
            {
                `$appSettings.Remove( '$appSettingName' )
                `$config.Save()
            }
"@ <-||- 

        
         -||-> if(  -||-> ( -||-> Test-DotNet -V2 <-||- ) <-||-  )
        {
             -||-> Invoke-PowerShell -Command $command -Encode -x86 -Runtime 'v2.0' <-||- 
             -||-> Invoke-PowerShell -Command $command -Encode -Runtime 'v2.0' <-||- 
        } <-||- 
    
         -||-> if(  -||-> ( -||-> Test-DotNet -V4 -Full <-||- ) <-||-  )
        {
             -||-> Invoke-PowerShell -Command $command -Encode -x86 -Runtime 'v4.0' <-||- 
             -||-> Invoke-PowerShell -Command $command -Encode -Runtime 'v4.0' <-||- 
        } <-||- 
    } <-||- 
    
     -||-> BeforeEach {
         -||-> $Global:Error.Clear() <-||- 
         -||-> if(  -||-> $Host.Name -ne 'Windows PowerShell ISE Host' <-||-  ) 
        {
             -||-> Set-DotNetAppSetting -Name $appSettingName -Value $appSettingValue -Framework64 -Clr2 -Framework -Clr4 <-||- 
        } <-||- 
    } <-||- 
    
     -||-> AfterEach {
         -||-> if(  -||-> $Host.Name -ne 'Windows PowerShell ISE Host' <-||-  ) 
        {
             -||-> Remove-AppSetting <-||- 
        } <-||- 
    } <-||- 
    
     -||-> if(  -||-> $Host.Name -ne 'Windows PowerShell ISE Host' <-||-  )
    {
         -||-> It 'should update machine config .NET 2 x64' {
             -||-> if(  -||-> -not ( -||-> Test-DotNet -V2 <-||- ) <-||-  )
            {
                 -||-> Fail ( -||-> '.NET v2 is not installed' <-||- ) <-||- 
            } <-||- 
    
             -||-> Remove-DotNetAppSetting -Name $appSettingName -Framework64 -Clr2 <-||- 
             -||-> Assert-AppSetting -Name $appSettingName -Value $null -Framework64 -Clr2 <-||- 
             -||-> Assert-AppSetting -Name $appSettingName -Value $appSettingValue -Framework64 -Clr4 <-||- 
             -||-> Assert-AppSetting -Name $appSettingName -Value $appSettingValue -Framework -Clr2 <-||- 
             -||-> Assert-AppSetting -Name $appSettingName -Value $appSettingValue -Framework -Clr4 <-||- 
        } <-||- 
    
         -||-> It 'should update machine config .NET 2 x86' {
             -||-> if(  -||-> -not ( -||-> Test-DotNet -V2 <-||- ) <-||-  )
            {
                 -||-> Fail ( -||-> '.NET v2 is not installed' <-||- ) <-||- 
            } <-||- 
    
             -||-> Remove-DotNetAppSetting -Name $appSettingName -Framework -Clr2 <-||- 
             -||-> Assert-AppSetting -Name $appSettingName -Value $appSettingValue -Framework64 -Clr2 <-||- 
             -||-> Assert-AppSetting -Name $appSettingName -Value $appSettingValue -Framework64 -Clr4 <-||- 
             -||-> Assert-AppSetting -Name $appSettingName -Value $null -Framework -Clr2 <-||- 
             -||-> Assert-AppSetting -Name $appSettingName -Value $appSettingValue -Framework -Clr4 <-||- 
        } <-||- 
    
         -||-> It 'should update machine config .NET 4 x64' {
             -||-> if(  -||-> -not ( -||-> Test-DotNet -V4 -Full <-||- ) <-||-  )
            {
                 -||-> Fail ( -||-> '.NET v4 full is not installed' <-||- ) <-||- 
            } <-||- 
    
             -||-> Remove-DotNetAppSetting -Name $appSettingName -Framework64 -Clr4 <-||- 
             -||-> Assert-AppSetting -Name $appSettingName -Value $appSettingValue -Framework64 -Clr2 <-||- 
             -||-> Assert-AppSetting -Name $appSettingName -Value $null -Framework64 -Clr4 <-||- 
             -||-> Assert-AppSetting -Name $appSettingName -Value $appSettingValue -Framework -Clr2 <-||- 
             -||-> Assert-AppSetting -Name $appSettingName -Value $appSettingValue -Framework -Clr4 <-||- 
        } <-||- 
    
         -||-> It 'should update machine config .NET 4 x86' {
             -||-> if(  -||-> -not ( -||-> Test-DotNet -V4 -Full <-||- ) <-||-  )
            {
                 -||-> Fail ( -||-> '.NET v4 full is not installed' <-||- ) <-||- 
            } <-||- 
    
             -||-> Remove-DotNetAppSetting -Name $appSettingName -Framework64 -Clr4 <-||- 
             -||-> Assert-AppSetting -Name $appSettingName -Value $appSettingValue -Framework64 -Clr2 <-||- 
             -||-> Assert-AppSetting -Name $appSettingName -Value $null -Framework64 -Clr4 <-||- 
             -||-> Assert-AppSetting -Name $appSettingName -Value $appSettingValue -Framework -Clr2 <-||- 
             -||-> Assert-AppSetting -Name $appSettingName -Value $appSettingValue -Framework -Clr4 <-||- 
        } <-||- 
    
         -||-> It 'should remove app setting with sensitive characters' {
             -||-> $name =  -||-> $value = '`1234567890-=qwertyuiop[]\a sdfghjkl;''zxcvbnm,./~!@
            Set-DotNetAppSetting -Name $name -Value $value -Framework64 -Clr4
            Assert-AppSetting -Name $name -Value $value -Framework64 -Clr4
            Remove-DotNetAppSetting -Name $name -Framework64 -Clr4
            Assert-AppSetting -Name $name -Value $null -Framework64 -Clr4
        }    
    }
    
    It ' -||-> s <-||-  <-||- should require a framework flag' {
        $error.Clear()
        Remove-DotNetAppSetting -Name $appSettingName -Clr2 -ErrorACtion SilentlyContinue
        $error.Count | Should Be 1
        ($error[0].Exception -like '*You must supply either or both of the Framework and Framework64 switches.') | Should Be $true
    }
    
    It 'should require a clr switch' {
        $error.Clear()
        Remove-DotNetAppSetting -Name $appSettingName -Framework -ErrorAction SilentlyContinue
        $error.Count | Should Be 1
        ($error[0].Exception -like '*You must supply either or both of the Clr2 and Clr4 switches.') | Should Be $true
    }
}

 <-||-  <-||-  <-||-  <-||- 
