 -||-> Set-PSFConfig -Module 'PSFramework' -Name 'Path.Temp' -Value $env:TEMP -Initialize -Validation 'string' -Description "Path pointing at the temp path. Used with Get-PSFPath." <-||- 
 -||-> Set-PSFConfig -Module 'PSFramework' -Name 'Path.LocalAppData' -Value $script:path_LocalAppData -Initialize -Validation 'string' -Description "Path pointing at the LocalAppData path. Used with Get-PSFPath." <-||- 
 -||-> Set-PSFConfig -Module 'PSFramework' -Name 'Path.AppData' -Value $script:path_AppData -Initialize -Validation 'string' -Description "Path pointing at the AppData path. Used with Get-PSFPath." <-||- 
 -||-> Set-PSFConfig -Module 'PSFramework' -Name 'Path.ProgramData' -Value $script:path_ProgramData -Initialize -Validation 'string' -Description "Path pointing at the ProgramData path. Used with Get-PSFPath." <-||- 

