$drive = Get-Volume -FileSystemLabel Lubos_Csonka	#get the info about disk with the name Lubos_Csonka
$file = "Knihy\Databaze knih a LP.xlsm"				#path to file
$letter = $drive.DriveLetter + ":"					#join drive letter and colon. Otherwise path wouldnt work
$path = Join-Path -Path $letter -ChildPath $file	#Join paths of drive letter and path to file

#following if statemant is not tested
if ($env:computername -eq "DESKTOP-KGPMJ57" -or ($env:computername -eq "DESKTOP-8S0PLJ1" -and $env:username -eq "zanet")) #if it's gf's PC (or my computer but her acount), use these variables
{
    $GdriveS = "C:\Users\zanet\Disk Google\Databáze knih\Databaze knih a LP.xlsm"
    $GdriveZ = "C:\Users\zanet\Disk Google\Databáze knih\DatabazeKnihZaloha"
    $GdriveD = "C:\Users\zanet\Disk Google\Databáze knih\"
}
 elseif ($env:computername -eq "DESKTOP-8S0PLJ1" -and ($env:username -eq "LubosCs")) #if it's mine pc
{
    $GdriveS = "C:\Users\LubosCs\Disk Google\Databáze knih\Databaze knih a LP.xlsm"
    $GdriveZ = "C:\Users\LubosCs\Disk Google\Databáze knih\DatabazeKnihZaloha"
    $GdriveD = "C:\Users\LubosCs\Disk Google\Databáze knih\"
}
 else 
{Write-Host "Unknown PC."; break}

try {
    if (((get-date)-(ls $path).LastWriteTime).days -lt 1) {                     #if file is older than 1 day
        if (Test-Path $GdriveS)     #If there is file in Google Drive (folder in PC)
	        {if (!(Test-Path $GdriveZ))  #If there is not a folder Backup
                {(New-Item -ItemType directory -Path $GdriveZ);(Write-Host 'Vytvorená zložka DatabazeKnihZaloha')}    #create new folder Backup
                    if (Test-Path (Join-Path -Path $GdriveZ -ChildPath "DBKLP$(get-date -f yyMMdd).xlsm"))      #if there is already backup file with current date
                        {(Remove-Item (Join-Path -Path $GdriveZ -ChildPath "DBKLP$(get-date -f yyMMdd).xlsm"));(Write-Host 'Vymazaný súbor DBKLP'$(get-date -f yyMMdd)'.xlsm')};   #delete backup file
                (Move-Item $GdriveS -destination (Join-Path -Path $GdriveZ -ChildPath "DBKLP$(get-date -f yyMMdd).xlsm"));((Write-Host 'Vytvorený súbor DBKLP'$(get-date -f yyMMdd)'.xlsm'))} #If there is a folder Backup, move file into it and rename it with current date
    if (!(Get-Module -ListAvailable -Name BurntToast)) {(Install-Module BurntToast -Scope CurrentUser);(Write-Host 'Nainštalovaný modul BurntToast.')}	#if there is not module, install it
    (Copy-Item $path -Destination $GdriveD); (New-BurntToastNotification -Text "Databáza knih bola zálohovaná."); (Write-Host 'Databáza knih bola zálohovaná.')}	#if file is older than 1 day, copy it into folder and send a Win10 notification
    
    if (Test-Path $GdriveZ) {Get-ChildItem -Path $GdriveZ | Where-Object {($_.LastWriteTime -lt (Get-Date).AddDays(-30))} | Remove-Item | Write-Host 'Vymazaný súbor starší než 30 dní.' }  #if file in Backup is older than 30 days, delete it
} catch [Microsoft.PowerShell.Commands.MoveItemCommand]{
    Write-Host 'Nastala chyba!'
    Remove-Item -Path (Join-Path -Path $GdriveZ -ChildPath "DBKLP$(get-date -f yyMMdd).xlsm")
    Remove-Item -Path $GdriveS
    C:\Users\csonkal\Desktop\LCs_osobne\dbklp.ps1      #call function recursively
    New-BurntToastNotification -Text "Chyba pri presune súboru."
}
