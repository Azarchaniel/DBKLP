$PSDefaultParameterValues['*:Encoding'] = 'utf8'
$drive = Get-Volume -FileSystemLabel Lubos_Csonka	#get the info about disk with the name Lubos_Csonka
$file = "Knihy\Databaze knih a LP.xlsm"			#path to file
$letter = $drive.DriveLetter + ":"					#join drive letter and colon. Otherwise path wouldnt work
$path = Join-Path -Path $letter -ChildPath $file	#Join paths of drive letter and path to file

if (((get-date)-(ls $path).LastWriteTime).days -lt 1) {
if (Test-Path "C:\Users\csonkal\Downloads\Databaze knih a LP.xlsm") {if (!(Test-Path "C:\Users\csonkal\Downloads\DatabazeKnihZaloha")) {New-Item -ItemType directory -Path "C:\Users\csonkal\Downloads\DatabazeKnihZaloha"} (Move-Item "C:\Users\csonkal\Downloads\Databaze knih a LP.xlsm" -destination "C:\Users\csonkal\Downloads\DatabazeKnihZaloha\DBKLP$(get-date -f yyMMdd).xlsm")}
#If there is file in Google Drive (folder in PC)***
	#If there is not a folder Backup, create new folder Backup
#***move file into folder Backup and rename it with current date
if (!(Get-Module "BurntToast")) {Install-Module BurntToast -Scope CurrentUser}	#if there is not module, install it
(Copy-Item $path -Destination "C:\Users\csonkal\Downloads\"); (New-BurntToastNotification -Text "Database of books was backed up.")}	#if file is older than 1 day, copy it into folder and send a Win10 notification
#notification has a problem with showing special characters. GitHub issue sent.


#change path from Downloads to Google Drive local
