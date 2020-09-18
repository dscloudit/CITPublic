$RootDirectory = "c:\support\"

$WebClient = New-Object -TypeName System.Net.Webclient
$UriBase = "https://raw.githubusercontent.com/dscloudit/CITPublic/master/"

#Download scripts for initial setup
$TargetPath = $RootDirectory + "InitialConnection.ps1"
$Uri = $UriBase + "InitialConnection.ps1"
$WebClient.DownloadFile($uri, $TargetPath)
$TargetPath = $RootDirectory + "InitialConnection.xml"
$Uri = $UriBase + "InitialConnection.xml"
$WebClient.DownloadFile($uri, $TargetPath)
#Register first script as a scheduled task

Register-ScheduledTask -Xml (get-content ($RootDirectory + "initialconnection.xml") | Out-String) -TaskName "Initial Connection"
c:\windows\system32\sysprep\sysprep /generalize /oobe /shutdown /unattend:c:\support\unattend.xml
