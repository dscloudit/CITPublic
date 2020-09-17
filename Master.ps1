$RootDirectory = "c:\support\"

$WebClient = New-Object -TypeName System.Net.Webclient
$URIBASE = "https://raw.githubusercontent.com/dscloudit/CITPublic/master/"

#Download scripts for initial setup
$TargetPath = $RootDirectory + "InitialConnection.ps1"
$WebClient.DownloadFile($uri, $TargetPath)
$TargetPath = $RootDirectory + "InitialConnection.xml"
$WebClient.DownloadFile($uri, $TargetPath)
#Register first script as a scheduled task

Register-ScheduledTask -Xml (get-content $RootDirectory + "initialconnection.xml" | Out-String) -TaskName "Initial Connection"
