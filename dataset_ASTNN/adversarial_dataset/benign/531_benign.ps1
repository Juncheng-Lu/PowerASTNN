













 -||-> function Publish-BitbucketDownload
{
    
    [CmdletBinding()]
    param(
        [pscredential]
        
        $Credential,

        [Parameter(Mandatory=$true)]
        [string]
        
        $Username,

        [Parameter(Mandatory=$true)]
        [string]
        
        $ProjectName,

        [Parameter(Mandatory=$true)]
        [string[]]
        
        $Path,

        [Parameter(Mandatory=$true)]
        [string]
        
        $ManifestPath
    )

     -||-> Set-StrictMode -Version 'Latest' <-||- 

     -||-> function Assert-Response
    {
        param(
            [Microsoft.PowerShell.Commands.HtmlWebResponseObject]
            $Response,

            [Uri]
            $ExpectedUri
        )

         -||-> if(  -||-> -not $Response <-||-  )
        {
             -||-> Write-Error ( -||-> 'No response.' <-||- ) <-||- 
            return  -||-> $false <-||- 
        } <-||- 

         -||-> if(  -||-> $Response.BaseResponse.StatusCode -ne [Net.HttpStatusCode]::OK <-||-  )
        {
             -||-> Write-Error ( -||-> 'Response failed.' <-||- ) <-||- 
            return  -||-> $false <-||- 
        } <-||- 

         -||-> if(  -||-> $Response.BaseResponse.ResponseUri -ne $ExpectedUri <-||-  )
        {
             -||-> Write-Error ( -||-> 'Response didn''t finish on URI {0} ({1}).' -f $ExpectedUri,$Response.BaseResponse.ResponseUri <-||- ) <-||- 
            return  -||-> $false <-||- 
        } <-||- 

         -||-> $errorElement = $Response.ParsedHtml.getElementById('error') <-||- 
         -||-> if(  -||-> $errorElement -and ( -||-> $errorElement | Get-Member 'innerHtml' <-||- ) -and $erroElement.innerHtml <-||-  )
        {
             -||-> Write-Error $errorElement.innerHtml <-||- 
            return  -||-> $false <-||- 
        } <-||- 

        return  -||-> $true <-||- 

    } <-||- 

     -||-> $manifest =  -||-> Test-ModuleManifest -Path $ManifestPath <-||-  <-||- 
     -||-> if(  -||-> -not $manifest <-||-  )
    {
        return
    } <-||- 

     -||-> $baseProjectUri = 'https://bitbucket.org/{0}/{1}' -f $Username,$ProjectName <-||- 

     -||-> $zipFileName = "{0}-{1}.zip" -f $manifest.Name,$manifest.Version <-||- 
     -||-> $zipDownloadUrl = '{0}/downloads/{1}' -f $baseProjectUri,$zipFileName <-||- 

     -||-> try
    {
         -||-> $resp =  -||-> Invoke-WebRequest -Uri $zipDownloadUrl -ErrorAction Ignore <-||-  <-||- 
         -||-> $publish = ( -||-> $resp.StatusCode -ne 200 <-||- ) <-||- 
    }
    catch
    {
         -||-> $publish = $true <-||- 
    } <-||- 

     -||-> if(  -||-> -not $publish <-||-  )
    {
         -||-> Write-Warning -Message ( -||-> '{0} file already published.' -f $zipFileName <-||- ) <-||- 
        return
    } <-||- 

     -||-> $zipFilePath =  -||-> Join-Path -Path $env:TEMP -ChildPath $zipFileName <-||-  <-||- 

     -||-> $outFile = '{0}+{1}' -f $manifest.Name,[IO.Path]::GetRandomFileName() <-||- 
     -||-> $outFile =  -||-> Join-Path -Path $env:TEMP -ChildPath $outFile <-||-  <-||- 

     -||-> try
    {
         -||-> if(  -||-> Test-Path $zipFilePath -PathType Leaf <-||-  )
        {
             -||-> Remove-Item $zipFilePath <-||- 
        } <-||- 

         -||-> Write-Verbose -Message ( -||-> 'Creating {0} ZIP file.' -f $zipFileName <-||- ) <-||- 
         -||-> Compress-Item -Path $Path -OutFile $zipFilePath <-||- 

         -||-> $PSDefaultParameterValues.Clear() <-||- 
         -||-> $PSDefaultParameterValues['Invoke-WebRequest:PassThru'] = $true <-||- 
         -||-> $PSDefaultParameterValues['Invoke-WebRequest:OutFile'] = $outFile <-||- 

         -||-> if(  -||-> -not $Credential <-||-  )
        {
             -||-> $Credential =  -||-> Get-Credential -Message ( -||-> 'Enter credentials for {0}' -f $baseProjectUri <-||- ) <-||-  <-||- 
        } <-||- 

         -||-> $session = $null <-||- 
         -||-> $loginUri = 'https://bitbucket.org/account/signin/' <-||- 
         -||-> $resp =  -||-> Invoke-WebRequest -Uri $loginUri -SessionVariable 'session' -Method Get <-||-  <-||-  
         -||-> if(  -||-> -not ( -||-> Assert-Response -Response $resp -ExpectedUri $loginUri <-||- ) <-||-  )
        {
            return
        } <-||- 

         -||-> $PSDefaultParameterValues['Invoke-WebRequest:WebSession'] = $session <-||- 

         -||-> $form =  -||-> $resp.Forms | 
                    Where-Object {  -||-> $_.Action -eq '/account/signin/' <-||-  } <-||-  <-||- 
         -||-> $formFields = $form.Fields <-||- 
         -||-> $formFields.id_username = $Credential.UserName <-||- 
         -||-> $formFields.id_password = $Credential.GetNetworkCredential().Password <-||- 

         -||-> $loginUri = 'https://bitbucket.org{0}' -f $form.Action <-||- 
         -||-> $body = @{
                        'username' =  -||-> $Credential.UserName <-||- ;
                        'password' =  -||-> $Credential.GetNetworkCredential().Password <-||- ;
                        'csrfmiddlewaretoken' =  -||-> $formFields.csrfmiddlewaretoken <-||- ;
                        'submit' =  -||-> '' <-||- ;
                        'next' =  -||-> '' <-||- ;
                        } <-||- 
         -||-> $resp =  -||-> Invoke-WebRequest -Uri $loginUri -Method $form.Method -Body $body -Headers @{ Referer =  -||-> $loginUri <-||-  } <-||-  <-||- 
         -||-> if(  -||-> -not ( -||-> Assert-Response -Response $resp -ExpectedUri 'https://bitbucket.org/dashboard/overview' <-||- ) <-||-  )
        {
            exit  -||-> 1 <-||- 
        } <-||- 

         -||-> $downloadUri = '{0}/downloads' -f $baseProjectUri <-||- 
         -||-> $resp =  -||-> Invoke-WebRequest -Uri $downloadUri -Method Get <-||-  <-||-  
         -||-> if(  -||-> -not ( -||-> Assert-Response -Response $resp -ExpectedUri $downloadUri <-||- ) <-||-  )
        {
            exit  -||-> 1 <-||- 
        } <-||- 

         -||-> $csrfToken =  -||-> $resp.Forms |
                        Where-Object {  -||-> $_.Fields.ContainsKey( 'csrfmiddlewaretoken' ) <-||-  } |
                        ForEach-Object {  -||-> $_.Fields.csrfmiddlewaretoken <-||-  } <-||-  <-||- 
         -||-> Write-Debug $csrfToken <-||- 

         -||-> $boundary = [Guid]::NewGuid().ToString() <-||- 

         -||-> $bodyStart = @"
--$boundary
Content-Disposition: form-data; name="csrfmiddlewaretoken"

$csrfToken
--$boundary
Content-Disposition: form-data; name="token"

--$boundary
Content-Disposition: form-data; name="files"; filename="$( -||-> Split-Path -Leaf -Path $zipFilePath <-||- )"
Content-Type: application/octet-stream


"@ <-||- 

         -||-> $bodyEnd = @"

--$boundary--
"@ <-||- 

         -||-> $requestInFile =  -||-> Join-Path -Path $env:TEMP -ChildPath ( -||-> [IO.Path]::GetRandomFileName() <-||- ) <-||-  <-||- 

         -||-> try
        {
             -||-> $fileStream =  -||-> New-Object 'System.IO.FileStream' ( -||-> $requestInFile, [System.IO.FileMode]'Create', [System.IO.FileAccess]'Write' <-||- ) <-||-  <-||- 
    
             -||-> try
            {
                 -||-> $bytes = [Text.Encoding]::UTF8.GetBytes($bodyStart) <-||- 
                 -||-> $fileStream.Write( $bytes, 0, $bytes.Length ) <-||- 

                 -||-> $bytes = [IO.File]::ReadAllBytes($zipFilePath) <-||- 
                 -||-> $fileStream.Write( $bytes, 0, $bytes.Length ) <-||- 

                 -||-> $bytes = [Text.Encoding]::UTF8.GetBytes($bodyEnd) <-||- 
                 -||-> $fileStream.Write( $bytes, 0, $bytes.Length ) <-||- 
            }
            finally
            { 
                 -||-> $fileStream.Close() <-||- 
            } <-||- 

             -||-> $contentType = 'multipart/form-data; boundary={0}' -f $boundary <-||- 

             -||-> $resp =  -||-> Invoke-WebRequest -Uri $downloadUri `
                                      -Method Post `
                                      -InFile $requestInFile `
                                      -ContentType $contentType `
                                      -Headers @{ Referer =  -||-> $downloadUri <-||-  } <-||-  <-||- 
             -||-> if(  -||-> -not ( -||-> Assert-Response -Response $resp -ExpectedUri $downloadUri <-||- ) <-||-  )
            {
                return
            } <-||- 

        }
        finally
        {
             -||-> Remove-Item -Path $requestInFile <-||- 
        } <-||- 

         -||-> $numTries = 10 <-||- 
         -||-> $tryNum = 0 <-||- 
         -||-> while(  -||-> $tryNum++ -lt $numTries <-||-  )
        {
             -||-> try
            {
                 -||-> $resp =  -||-> Invoke-WebRequest -Uri $zipDownloadUrl <-||-  <-||- 
                 -||-> $resp | Select-Object -Property 'StatusCode','StatusDescription',@{ Name =  -||-> 'Uri' <-||- ; Expression =  -||-> {  -||-> $zipDownloadUrl <-||-  } <-||- } <-||- 
                break
            }
            catch
            {
                 -||-> Start-Sleep -Seconds 1 <-||- 
            } <-||- 
        } <-||- 

    }
    finally
    {
         -||-> if(  -||-> ( -||-> Test-Path -Path $outFile -PathType Leaf <-||- ) <-||-  )
        {
             -||-> Remove-Item -Path $outFile <-||- 
        } <-||- 

         -||-> if(  -||-> ( -||-> Test-Path -Path $zipFilePath -PathType Leaf <-||- ) <-||-  )
        {
             -||-> Remove-Item -Path $zipFilePath <-||- 
        } <-||- 
    } <-||- 
} <-||- 

