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

  $URI = "https://raw.githubusercontent.com/dscloudit/CITPublic/master/Automate-Module.psm1"

  $TargetPath = "c:\support\Automate-Module.psm1"

  $WebClient.DownloadFile($uri, $TargetPath)

  Import-Module C:\support\Automate-Module.psm1

  Install-Automate -Server tools.cloudit.help -Token $Installer.InstallerToken -LocationID $Installer.LocationID

}
