New-Item -path "c:\" -Name "Support" -ItemType "Directory"
$RootDirectory = "c:\support\"
#Set policy to remote signed so we can run scripts locally
Set-ExecutionPolicy RemoteSigned

#Download Master Script
$WebClient = New-Object -TypeName System.Net.Webclient
$URIBASE = "https://raw.githubusercontent.com/dscloudit/CITPublic/master/"
$TargetPath = $RootDirectory + "Master.ps1"
$WebClient.DownloadFile($uri, $TargetPath)

#Execute Master Script
Invoke-Command -FilePath $RootDirectory + "Master.ps1"
