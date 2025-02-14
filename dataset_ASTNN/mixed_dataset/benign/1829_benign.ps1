






 -||-> [string]$appDeployToolkitHelpName = 'PSAppDeployToolkitHelp' <-||- 
 -||-> [string]$appDeployHelpScriptFriendlyName = 'App Deploy Toolkit Help' <-||- 
 -||-> [version]$appDeployHelpScriptVersion = [version]'3.8.0' <-||- 
 -||-> [string]$appDeployHelpScriptDate = '23/09/2019' <-||- 


 -||-> [string]$scriptDirectory =  -||-> Split-Path -Path $MyInvocation.MyCommand.Definition -Parent <-||-  <-||- 

 -||-> . "$scriptDirectory\AppDeployToolkitMain.ps1" -DisableLogging <-||- 









 -||-> Function Show-HelpConsole {
	
	 -||-> Add-Type -AssemblyName 'System.Windows.Forms' -ErrorAction 'Stop' <-||- 
	 -||-> Add-Type -AssemblyName System.Drawing -ErrorAction 'Stop' <-||- 

	
	 -||-> $HelpForm =  -||-> New-Object -TypeName 'System.Windows.Forms.Form' <-||-  <-||- 
	 -||-> $HelpListBox =  -||-> New-Object -TypeName 'System.Windows.Forms.ListBox' <-||-  <-||- 
	 -||-> $HelpTextBox =  -||-> New-Object -TypeName 'System.Windows.Forms.RichTextBox' <-||-  <-||- 
	 -||-> $InitialFormWindowState =  -||-> New-Object -TypeName 'System.Windows.Forms.FormWindowState' <-||-  <-||- 

	
	 -||-> $System_Drawing_Size =  -||-> New-Object -TypeName 'System.Drawing.Size' <-||-  <-||- 
	 -||-> $System_Drawing_Size.Height = 665 <-||- 
	 -||-> $System_Drawing_Size.Width = 957 <-||- 
	 -||-> $HelpForm.ClientSize = $System_Drawing_Size <-||- 
	 -||-> $HelpForm.DataBindings.DefaultDataSourceUpdateMode = 0 <-||- 
	 -||-> $HelpForm.Name = 'HelpForm' <-||- 
	 -||-> $HelpForm.Text = 'PowerShell App Deployment Toolkit Help Console' <-||- 
	 -||-> $HelpForm.WindowState = 'Normal' <-||- 
	 -||-> $HelpForm.ShowInTaskbar = $true <-||- 
	 -||-> $HelpForm.FormBorderStyle = 'Fixed3D' <-||- 
	 -||-> $HelpForm.MaximizeBox = $false <-||- 
	 -||-> $HelpForm.Icon =  -||-> New-Object -TypeName 'System.Drawing.Icon' -ArgumentList $AppDeployLogoIcon <-||-  <-||- 
	 -||-> $HelpListBox.Anchor = 7 <-||- 
	 -||-> $HelpListBox.BorderStyle = 1 <-||- 
	 -||-> $HelpListBox.DataBindings.DefaultDataSourceUpdateMode = 0 <-||- 
	 -||-> $HelpListBox.Font =  -||-> New-Object -TypeName 'System.Drawing.Font' -ArgumentList ( -||-> 'Microsoft Sans Serif', 9.75, 1, 3, 1 <-||- ) <-||-  <-||- 
	 -||-> $HelpListBox.FormattingEnabled = $true <-||- 
	 -||-> $HelpListBox.ItemHeight = 16 <-||- 
	 -||-> $System_Drawing_Point =  -||-> New-Object -TypeName 'System.Drawing.Point' <-||-  <-||- 
	 -||-> $System_Drawing_Point.X = 0 <-||- 
	 -||-> $System_Drawing_Point.Y = 0 <-||- 
	 -||-> $HelpListBox.Location = $System_Drawing_Point <-||- 
	 -||-> $HelpListBox.Name = 'HelpListBox' <-||- 
	 -||-> $System_Drawing_Size =  -||-> New-Object -TypeName 'System.Drawing.Size' <-||-  <-||- 
	 -||-> $System_Drawing_Size.Height = 658 <-||- 
	 -||-> $System_Drawing_Size.Width = 271 <-||- 
	 -||-> $HelpListBox.Size = $System_Drawing_Size <-||- 
	 -||-> $HelpListBox.Sorted = $true <-||- 
	 -||-> $HelpListBox.TabIndex = 2 <-||- 
	 -||-> $HelpListBox.add_SelectedIndexChanged({  -||-> $HelpTextBox.Text =  -||-> Get-Help -Name $HelpListBox.SelectedItem -Full | Out-String <-||-  <-||-  }) <-||- 
	 -||-> $helpFunctions =  -||-> Get-Command -CommandType 'Function' | Where-Object {  -||-> ( -||-> $_.HelpUri -match 'psappdeploytoolkit' <-||- ) -and ( -||-> $_.Definition -notmatch 'internal script function' <-||- ) <-||-  } | Select-Object -ExpandProperty Name <-||-  <-||- 
	 -||-> ForEach ($helpFunction in  -||-> $helpFunctions <-||- ) {
		 -||-> $null = $HelpListBox.Items.Add($helpFunction) <-||- 
	} <-||- 
	 -||-> $HelpForm.Controls.Add($HelpListBox) <-||- 
	 -||-> $HelpTextBox.Anchor = 11 <-||- 
	 -||-> $HelpTextBox.BorderStyle = 1 <-||- 
	 -||-> $HelpTextBox.DataBindings.DefaultDataSourceUpdateMode = 0 <-||- 
	 -||-> $HelpTextBox.Font =  -||-> New-Object -TypeName 'System.Drawing.Font' -ArgumentList ( -||-> 'Microsoft Sans Serif', 8.5, 0, 3, 1 <-||- ) <-||-  <-||- 
	 -||-> $HelpTextBox.ForeColor = [System.Drawing.Color]::FromArgb(255, 0, 0, 0) <-||- 
	 -||-> $System_Drawing_Point =  -||-> New-Object -TypeName System.Drawing.Point <-||-  <-||- 
	 -||-> $System_Drawing_Point.X = 277 <-||- 
	 -||-> $System_Drawing_Point.Y = 0 <-||- 
	 -||-> $HelpTextBox.Location = $System_Drawing_Point <-||- 
	 -||-> $HelpTextBox.Name = 'HelpTextBox' <-||- 
	 -||-> $HelpTextBox.ReadOnly = $True <-||- 
	 -||-> $System_Drawing_Size =  -||-> New-Object -TypeName 'System.Drawing.Size' <-||-  <-||- 
	 -||-> $System_Drawing_Size.Height = 658 <-||- 
	 -||-> $System_Drawing_Size.Width = 680 <-||- 
	 -||-> $HelpTextBox.Size = $System_Drawing_Size <-||- 
	 -||-> $HelpTextBox.TabIndex = 1 <-||- 
	 -||-> $HelpTextBox.Text = '' <-||- 
	 -||-> $HelpForm.Controls.Add($HelpTextBox) <-||- 

	
	 -||-> $InitialFormWindowState = $HelpForm.WindowState <-||- 
	
	 -||-> $HelpForm.add_Load($OnLoadForm_StateCorrection) <-||- 
	
	 -||-> $null = $HelpForm.ShowDialog() <-||- 
} <-||- 









 -||-> Write-Log -Message "Load [$appDeployHelpScriptFriendlyName] console..." -Source $appDeployToolkitHelpName <-||- 


 -||-> Show-HelpConsole <-||- 

 -||-> Write-Log -Message "[$appDeployHelpScriptFriendlyName] console closed." -Source $appDeployToolkitHelpName <-||- 






