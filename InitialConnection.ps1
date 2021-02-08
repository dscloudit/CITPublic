While((Test-path C:\windows\LTSvc) -eq $false)

{
  #Checking for serialnumber first
  $Serial = Get-WmiObject win32_bios | select Serialnumber
  $Serial = $Serial.SerialNumber
  $Serial = [uri]::EscapeUriString($Serial)
  $Installer = Invoke-webrequest -uri http://setup.cloudit.help/rd/api/serialdeploy/$Serial -usebasicparsing
  $installer = $Installer.content | ConvertFrom-Json
  If ($Installer -eq $Null)
  #Creating the form to prompt for input.
  {
  add-type -AssemblyName Microsoft.VisualBasic

  $title = "Initial Setup"

  $msg   = "Enter your Access Code:"

  $AccessCode = [Microsoft.VisualBasic.Interaction]::InputBox($msg, $title)

  

  #Taking the value from the form and using it to do an API request to the server

  $Installer = Invoke-webrequest -uri http://setup.cloudit.help/rd/api/clientdeploy/$accesscode -usebasicparsing

  $installer = $Installer.content | ConvertFrom-Json

  }

  #$Installer | Out-File c:\support\testaccess.txt



  #Downloading other powershell script to install automate

  $WebClient = New-Object -TypeName System.Net.Webclient
  $InstallToken = $Installer.installertoken
  $URI = "https://tools.cloudit.help/labtech/deployment.aspx?InstallerToken=$InstallToken"

  $TargetPath = "c:\support\Agent.msi"

  $WebClient.DownloadFile($uri, $TargetPath)
 
  $job = Start-Job -ScriptBlock{
  [Net.ServicePointManager]::SecurityProtocol = ([Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12)
  $URI = "Https://raw.githubusercontent.com/Braingears/Powershell/master/Automate-Module.psm1"
  $TargetPath = "c:\support\Automate-module.psm1"
  $WebClient = New-Object -TypeName System.Net.Webclient
  $WebClient.DownloadFile($uri, $TargetPath)
  Import-Module "c:\support\automate-module.psm1"
  Install-automate -Server "Tools.cloudit.help" -LocationID $Using:Installer.LocationID -Token $Using:InstallToken -Force
  }
  $Job | Wait-Job -Timeout 120
  $job | Stop-Job
  Start-Sleep 60
  #If databases exists then we successfully registered into automate
  #Disable task from startup
  if(test-path c:\windows\ltsvc\databases)
  {
    Unregister-ScheduledTask -TaskName "Initial Connection" -Confirm:$false
	Get-ChildItem -Path "c:\support" -Recurse | Remove-Item -Force -Recurse
  }

}

