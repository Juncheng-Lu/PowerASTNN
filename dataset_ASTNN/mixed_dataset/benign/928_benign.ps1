

 -||-> Describe 'Get-WinEvent' -Tags "CI" {
     -||-> BeforeAll {
         -||-> if (  -||-> ! $IsWindows <-||-  )
        {
             -||-> $origDefaults = $PSDefaultParameterValues.Clone() <-||- 
             -||-> $PSDefaultParameterValues['it:skip'] = $true <-||- 
        } <-||- 
    } <-||- 
     -||-> AfterAll {
         -||-> if (  -||-> ! $IsWindows <-||-  ){
             -||-> $global:PSDefaultParameterValues = $origDefaults <-||- 
        } <-||- 
    } <-||- 
     -||-> Context "Get-WinEvent ListProvider parameter" {
         -||-> It 'Get-WinEvent can list the providers' {
             -||-> $result =  -||-> Get-WinEvent -listprovider * -erroraction ignore <-||-  <-||- 
             -||-> $result | Should -Not -BeNullOrEmpty <-||- 
        } <-||- 
         -||-> It 'Get-WinEvent can get a provider by name' {
             -||-> $providers =  -||-> Get-WinEvent -listprovider * -erroraction ignore <-||-  <-||- 
             -||-> $result =  -||-> Get-WinEvent -listprovider ( -||-> $providers[0].name <-||- ) <-||-  <-||- 
             -||-> $result | Should -Not -BeNullOrEmpty <-||- 
        } <-||- 

    } <-||- 
     -||-> Context "Get-WinEvent can retrieve events" {
        
         -||-> BeforeAll {
             -||-> if (  -||-> ! $IsWindows <-||-  ) { return } <-||- 
             -||-> $foundEvents = $false <-||- 
             -||-> $providers =  -||-> Get-WinEvent -listprovider * -erroraction ignore <-||-  <-||- 
             -||-> foreach($provider in  -||-> $providers <-||- ) {
                 -||-> $events =  -||-> Get-WinEvent -provider $provider.name -erroraction ignore <-||-  <-||- 
                 -||-> if (  -||-> $events.Count -gt 2 <-||-  ) {
                     -||-> $providerForTests = $provider <-||- 
                     -||-> $foundEvents = $true <-||- 
                    break
                } <-||- 
            } <-||- 
        } <-||- 
         -||-> It 'Get-WinEvent can get events from a provider' {
            
             -||-> $results =  -||-> Get-WinEvent -provider $providerForTests.Name -max 20 <-||-  <-||- 
             -||-> foreach($event in  -||-> $results <-||-  ) {
                 -||-> $event.providername | Should -BeExactly $providerForTests.name <-||- 
            } <-||- 
        } <-||- 
         -||-> It 'Get-WinEvent can get events via logname' {
             -||-> $results =  -||-> get-winevent -logname $providerForTests.LogLinks.LogName -MaxEvents 10 <-||-  <-||- 
             -||-> $results | Should -Not -BeNullOrEmpty <-||- 
        } <-||- 
         -||-> It 'Throw if count of lognames exceeds Windows API limit' {
             -||-> if ( -||-> [System.Environment]::OSVersion.Version.Major -ge 10 <-||- ) {
                 -||-> {  -||-> get-winevent -logname * <-||-  } | Should -Throw -ErrorId "LogCountLimitExceeded,Microsoft.PowerShell.Commands.GetWinEventCommand" <-||- 
            } <-||- 
        } <-||- 
         -||-> It 'Get-WinEvent can use the simplest of filters' {
             -||-> $filter = @{ ProviderName =  -||-> $providerForTests.Name <-||-  } <-||- 
             -||-> $testEvents =  -||-> Get-WinEvent -filterhashtable $filter <-||-  <-||- 

             -||-> $testEventDict = [System.Collections.Generic.Dictionary[int, System.Diagnostics.Eventing.Reader.EventLogRecord]]::new() <-||- 
             -||-> foreach ($te in  -||-> $testEvents <-||- )
            {
                 -||-> $testEventDict.TryAdd($te.Id, $te) <-||- 
            } <-||- 

             -||-> foreach ($e in  -||-> $events <-||- )
            {
                 -||-> if ( -||-> -not $testEventDict.ContainsKey($e.Id) <-||- )
                {
                    throw  -||-> new "Unexpected event log: $e" <-||- 
                } <-||- 
            } <-||- 

             -||-> $testEvents.Count | Should -Be $events.Count <-||- 
        } <-||- 
         -||-> It 'Get-WinEvent can use a filter which includes two items' {
             -||-> $filter = @{ ProviderName =  -||-> $providerForTests.Name <-||- ; Id =  -||-> $events[0].Id <-||- } <-||- 
             -||-> $results =  -||-> Get-WinEvent -filterHashtable $filter <-||-  <-||- 
             -||-> $results | Should -Not -BeNullOrEmpty <-||- 
        } <-||- 
         -||-> It 'Get-WinEvent can retrieve event via XmlQuery' {
             -||-> $level = $events[0].Level <-||- 
             -||-> $logname = $providerForTests.loglinks.logname <-||- 
             -||-> $filter = "<QueryList><Query><Select Path='${logname}'>*[System[Level=${level}]]</Select></Query></QueryList>" <-||- 
             -||-> $results =  -||-> Get-WinEvent -filterXml $filter -max 3 <-||-  <-||- 
             -||-> $results | Should -Not -BeNullOrEmpty <-||- 
        } <-||- 
         -||-> It 'Get-WinEvent can retrieve event via XPath' {
             -||-> $level = $events[0].Level <-||- 
             -||-> $logname  = $providerForTests.loglinks.logname <-||- 
             -||-> $xpathFilter = "*[System[Level=$level]]" <-||- 
             -||-> $results =  -||-> Get-WinEvent -logname $logname -filterXPath $xpathFilter -max 3 <-||-  <-||- 
             -||-> $results | Should -Not -BeNullOrEmpty <-||- 
        } <-||- 

    } <-||- 
     -||-> Context "Get-WinEvent UserData Queries" {
         -||-> It 'Get-WinEvent can retrieve events with UserData queries using FilterXml' {
            
            
             -||-> $eventLogFile = [io.path]::Combine($PSScriptRoot, "assets", "Saved-Events.evtx") <-||- 
             -||-> $filter = "<QueryList><Query><Select Path='file://$eventLogFile'>*[UserData/*/Param2='Windows x64']</Select></Query></QueryList>" <-||- 
             -||-> $results =  -||-> Get-WinEvent -FilterXml $filter -ErrorAction silentlycontinue <-||-  <-||- 
             -||-> @( -||-> $results <-||- ).Count | Should -Be 1 <-||- 
             -||-> $results.RecordId | Should -Be 10 <-||- 
        } <-||- 
         -||-> It 'Get-WinEvent can retrieve events with UserData queries using FilterHashtable (one value)' {
            
            
             -||-> $eventLogFile = [io.path]::Combine($PSScriptRoot, "assets", "Saved-Events.evtx") <-||- 
             -||-> $filter = @{ path =  -||-> "$eventLogFile" <-||- ; Param2 =  -||-> "Windows x64" <-||- } <-||- 
             -||-> $results =  -||-> Get-WinEvent -filterHashtable $filter -ErrorAction silentlycontinue <-||-  <-||- 
             -||-> @( -||-> $results <-||- ).Count | Should -Be 1 <-||- 
             -||-> $results.RecordId | Should -Be 10 <-||- 
        } <-||- 
         -||-> It 'Get-WinEvent can retrieve events with UserData queries using FilterHashtable (array of values)' {
            
            
             -||-> $eventLogFile = [io.path]::Combine($PSScriptRoot, "assets", "Saved-Events.evtx") <-||- 
             -||-> $filter = @{ path =  -||-> "$eventLogFile" <-||- ; DriverName =  -||-> "Remote Desktop Easy Print", "Microsoft enhanced Point and Print compatibility driver" <-||-  } <-||- 
             -||-> $results =  -||-> Get-WinEvent -filterHashtable $filter -ErrorAction silentlycontinue <-||-  <-||- 
             -||-> @( -||-> $results <-||- ).Count | Should -Be 2 <-||- 
             -||-> ( -||-> $results.RecordId -contains 9 <-||- ) | Should -BeTrue <-||- 
             -||-> ( -||-> $results.RecordId -contains 11 <-||- ) | Should -BeTrue <-||- 
        } <-||- 
         -||-> It 'Get-WinEvent can retrieve events with UserData queries using FilterHashtable (multiple named params)' {
            
            
             -||-> $eventLogFile = [io.path]::Combine($PSScriptRoot, "assets", "Saved-Events.evtx") <-||- 
             -||-> $filter = @{ path =  -||-> "$eventLogFile" <-||- ; PackageAware= -||-> "Not package aware" <-||- ; DriverName =  -||-> "Remote Desktop Easy Print", "Microsoft enhanced Point and Print compatibility driver" <-||-  } <-||- 
             -||-> $results =  -||-> Get-WinEvent -filterHashtable $filter -ErrorAction silentlycontinue <-||-  <-||- 
             -||-> @( -||-> $results <-||- ).Count | Should -Be 2 <-||- 
             -||-> ( -||-> $results.RecordId -contains 9 <-||- ) | Should -BeTrue <-||- 
             -||-> ( -||-> $results.RecordId -contains 11 <-||- ) | Should -BeTrue <-||- 
        } <-||- 
         -||-> It 'Get-WinEvent can retrieve events with UserData queries using FilterXPath' {
            
            
             -||-> $eventLogFile = [io.path]::Combine($PSScriptRoot, "assets", "Saved-Events.evtx") <-||- 
             -||-> $filter = "*/UserData/*/Param2='Windows x64'" <-||- 
             -||-> $results =  -||-> Get-WinEvent -path $eventLogFile -filterXPath $filter -ErrorAction silentlycontinue <-||-  <-||- 
             -||-> @( -||-> $results <-||- ).Count | Should -Be 1 <-||- 
             -||-> $results.RecordId | Should -Be 10 <-||- 
        } <-||- 
    } <-||- 
     -||-> Context "Get-WinEvent Queries with SuppressHashFilter" {
         -||-> It 'Get-WinEvent can suppress events by Id' {
            
            
             -||-> $eventLogFile = [io.path]::Combine($PSScriptRoot, "assets", "Saved-Events.evtx") <-||- 
             -||-> $filter = @{ path =  -||-> "$eventLogFile" <-||- } <-||- 
             -||-> $results =  -||-> Get-WinEvent -filterHashtable $filter -ErrorAction silentlycontinue <-||-  <-||- 
             -||-> $filterSuppress = @{ path =  -||-> "$eventLogFile" <-||- ;  SuppressHashFilter= -||-> @{Id= -||-> 370 <-||- } <-||- } <-||- 
             -||-> $resultsSuppress =  -||-> Get-WinEvent -filterHashtable $filterSuppress -ErrorAction silentlycontinue <-||-  <-||- 
             -||-> @( -||-> $results <-||- ).Count | Should -Be 3 <-||- 
             -||-> @( -||-> $resultsSuppress <-||- ).Count | Should -Be 2 <-||- 
        } <-||- 
         -||-> It 'Get-WinEvent can suppress events by UserData' {
            
            
             -||-> $eventLogFile = [io.path]::Combine($PSScriptRoot, "assets", "Saved-Events.evtx") <-||- 
             -||-> $filter = @{ path =  -||-> "$eventLogFile" <-||- } <-||- 
             -||-> $results =  -||-> Get-WinEvent -filterHashtable $filter -ErrorAction silentlycontinue <-||-  <-||- 
             -||-> $filterSuppress = @{ path =  -||-> "$eventLogFile" <-||- ;  SuppressHashFilter= -||-> @{Param2 =  -||-> "Windows x64" <-||- } <-||- } <-||- 
             -||-> $resultsSuppress =  -||-> Get-WinEvent -filterHashtable $filterSuppress -ErrorAction silentlycontinue <-||-  <-||- 
             -||-> @( -||-> $results <-||- ).Count | Should -Be 3 <-||- 
             -||-> @( -||-> $resultsSuppress <-||- ).Count | Should -Be 2 <-||- 
        } <-||- 
    } <-||- 
     -||-> It 'can query a System log' {
         -||-> Get-WinEvent -LogName System -MaxEvents 1 | Should -Not -BeNullOrEmpty <-||- 
    } <-||- 
} <-||- 


