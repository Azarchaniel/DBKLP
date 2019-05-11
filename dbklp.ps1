$drive = Get-Volume -FileSystemLabel Lubos_Csonka	#get the info about disk with the name Lubos_Csonka
$file = "Knihy\Databaze knih a LP.xlsm"				#path to file
$letter = $drive.DriveLetter + ":"					#join drive letter and colon. Otherwise path wouldnt work
$path = Join-Path -Path $letter -ChildPath $file	#Join paths of drive letter and path to file

try {
    if (((get-date)-(ls $path).LastWriteTime).days -lt 1) {                     #if file is older than 1 day
        if (Test-Path "C:\Users\csonkal\Downloads\Databaze knih a LP.xlsm")     #If there is file in Google Drive (folder in PC)
	        {if (!(Test-Path "C:\Users\csonkal\Downloads\DatabazeKnihZaloha"))  #If there is not a folder Backup
                {(New-Item -ItemType directory -Path "C:\Users\csonkal\Downloads\DatabazeKnihZaloha");(Write-Host 'Vytvorená zložka DatabazeKnihZaloha')}    #create new folder Backup
                    if (Test-Path "C:\Users\csonkal\Downloads\DatabazeKnihZaloha\DBKLP$(get-date -f yyMMdd).xlsm")        #if there is already backup file with current date
                        {(Remove-Item "C:\Users\csonkal\Downloads\DatabazeKnihZaloha\DBKLP$(get-date -f yyMMdd).xlsm");(Write-Host 'Vymazaný súbor DBKLP'$(get-date -f yyMMdd)'.xlsm')};   #delete backup file
                (Move-Item "C:\Users\csonkal\Downloads\Databaze knih a LP.xlsm" -destination "C:\Users\csonkal\Downloads\DatabazeKnihZaloha\DBKLP$(get-date -f yyMMdd).xlsm");((Write-Host 'Vytvorený súbor DBKLP'$(get-date -f yyMMdd)'.xlsm'))} #If there is a folder Backup, move file into it and rename it with current date
    if (!(Get-Module "BurntToast")) {Install-Module BurntToast -Scope CurrentUser}	#if there is not module, install it
    (Copy-Item $path -Destination "C:\Users\csonkal\Downloads\"); (New-BurntToastNotification -Text "Databáza knih bola zálohovaná."); (Write-Host 'Databáza knih bola zálohovaná.')}	#if file is older than 1 day, copy it into folder and send a Win10 notification
    
    if (Test-Path "C:\Users\csonkal\Downloads\DatabazeKnihZaloha") {Get-ChildItem -Path "C:\Users\csonkal\Downloads\DatabazeKnihZaloha" | Where-Object {($_.LastWriteTime -lt (Get-Date).AddDays(-30))} | Remove-Item}  #if file in Backup is older than 30 days, delete it
} catch [Microsoft.PowerShell.Commands.MoveItemCommand]{
    Write-Host 'Nastala chyba!'
    Remove-Item -Path "C:\Users\csonkal\Downloads\DatabazeKnihZaloha\DBKLP$(get-date -f yyMMdd).xlsm"
    Remove-Item -Path "C:\Users\csonkal\Downloads\Databaze knih a LP.xlsm"
    C:\Users\csonkal\Desktop\LCs_osobne\dbklp.ps1      #call function recursively
    New-BurntToastNotification -Text "Chyba pri presune súboru."
}


#TODO: change path from Downloads to Google Drive local
#TODO: better Error handling
