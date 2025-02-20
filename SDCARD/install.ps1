# PowerShell Skript zur SD-Karten-Partitionierung und Datei-Kopie
Write-Host "LSCamoflash SD-Karten Partitionierungsskript" -ForegroundColor Cyan
Write-Host "ACHTUNG: ALLE DATEN AUF DER SD-KARTE WERDEN GELOESCHT!" -ForegroundColor Red
Write-Host "ABBRUCH MIT STRG+C"
Pause

# Wechselmedien auflisten
$removableDisks = Get-WmiObject Win32_DiskDrive | Where-Object { $_.MediaType -match "Removable" }

if (-not $removableDisks) {
    Write-Host "Keine SD-Karte oder Wechselmedium gefunden! Skript wird beendet." -ForegroundColor Yellow
    Pause
    Exit
}

Write-Host "`nGefundene Wechselmedien:"
$removableDisks | ForEach-Object { Write-Host "$($_.Index): $($_.Model) - Groesse: $($_.Size) Bytes" }

# Benutzer nach der SD-Karten-Nummer fragen
$disknum = Read-Host "Gib die Datentraegernummer deiner SD-Karte ein"

# Pruefen, ob die eingegebene Nummer zu einem Wechselmedium gehoert
$selectedDisk = $removableDisks | Where-Object { $_.Index -eq $disknum }

if (-not $selectedDisk) {
    Write-Host "Fehler: Der gewaehlte Datentraeger ist KEIN Wechselmedium! Abbruch." -ForegroundColor Red
    Pause
    Exit
}

Write-Host "SD-Karte erkannt: $($selectedDisk.Model)" -ForegroundColor Green

# Automatische Ermittlung von zwei freien Laufwerksbuchstaben
$allLetters = "E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"
$usedLetters = (Get-Volume).DriveLetter
$freeLetters = $allLetters | Where-Object { $_ -notin $usedLetters }

if ($freeLetters.Count -lt 2) {
    Write-Host "Fehler: Nicht genuegend freie Laufwerksbuchstaben gefunden!" -ForegroundColor Red
    Pause
    Exit
}

$drive1 = $freeLetters[0]
$drive2 = $freeLetters[1]

Write-Host "Laufwerksbuchstaben zugewiesen: Partition 1 -> $drive1, Partition 2 -> $drive2"

# Diskpart-Skript fuer Partitionierung erstellen
$diskpartScript = @"
select disk $disknum
clean
convert mbr
create partition primary
shrink desired=1024
format fs=fat32 quick
assign letter=$drive1
create partition primary
format fs=fat32 quick
assign letter=$drive2
exit
"@

# Diskpart-Befehl ausfuehren
Write-Host "Starte Partitionierung mit DiskPart..." -ForegroundColor Cyan
$diskpartScript | Out-File -FilePath "$env:TEMP\diskpart.txt" -Encoding ascii
Start-Process -FilePath "diskpart.exe" -ArgumentList "/s $env:TEMP\diskpart.txt" -NoNewWindow -Wait

Write-Host "Partitionierung abgeschlossen!" -ForegroundColor Green

# Warte kurz, bis Windows die Partitionen erkannt hat
Start-Sleep -Seconds 5

# Kopiere Dateien von mmcblk0p1 nach $drive1
$source1 = ".\mmcblk0p1\*"
$dest1 = "$drive1`:\"
if (Test-Path $source1) {
    Write-Host "Kopiere Dateien von mmcblk0p1 nach $drive1..." -ForegroundColor Cyan
    Copy-Item -Path $source1 -Destination $dest1 -Recurse -Force
    Write-Host "Kopieren auf $drive1 abgeschlossen!" -ForegroundColor Green
} else {
    Write-Host "Warnung: mmcblk0p1 nicht gefunden, keine Dateien kopiert!" -ForegroundColor Yellow
}

# Kopiere Dateien von mmcblk0p2 nach $drive2
$source2 = ".\mmcblk0p2\*"
$dest2 = "$drive2`:\"
if (Test-Path $source2) {
    Write-Host "Kopiere Dateien von mmcblk0p2 nach $drive2..." -ForegroundColor Cyan
    Copy-Item -Path $source2 -Destination $dest2 -Recurse -Force
    Write-Host "Kopieren auf $drive2 abgeschlossen!" -ForegroundColor Green
} else {
    Write-Host "Warnung: mmcblk0p2 nicht gefunden, keine Dateien kopiert!" -ForegroundColor Yellow
}

# Falls hack_custom.conf existiert, kopiere sie in den Ordner HACK/etc auf Laufwerk 2
$hackConfig = ".\hack_custom.conf"
$hackDest = "$drive2`:\HACK\etc\hack_custom.conf"

if (Test-Path $hackConfig) {
    Write-Host "Kopiere hack_custom.conf nach HACK/etc auf $drive2..." -ForegroundColor Cyan
    New-Item -ItemType Directory -Path "$drive2`:\HACK\etc" -Force | Out-Null
    Copy-Item -Path $hackConfig -Destination $hackDest -Force
    Write-Host "hack_custom.conf erfolgreich kopiert!" -ForegroundColor Green
} else {
    Write-Host "hack_custom.conf nicht gefunden, kein Kopiervorgang notwendig." -ForegroundColor Yellow
}

$localPasswd = ".\passwd"
$etcPasswd = ".\mmcblk0p2\HACK\etc\config\passwd"
$etcPasswdDest = "$drive1`:\passwd"
$etcPasswdDest2 = "$drive2`:\HACK\etc\config\passwd"

if (Test-Path $localPasswd) {
    Write-Host "Kopiere lokale ./passwd Version nach / auf $drive1 und /HACK/etc/config auf $drive2..." -ForegroundColor Cyan
    Copy-Item -Path $localPasswd -Destination $etcPasswdDest -Force
    Copy-Item -Path $localPasswd -Destination $etcPasswdDest2 -Force
    Write-Host "lokale passwd Version erfolgreich kopiert!" -ForegroundColor Green
} elseif (Test-Path $etcPasswd) {
    Write-Host "Kopiere HACK/etc/config/passwd nach / auf $drive1..." -ForegroundColor Cyan
    Copy-Item -Path $etcPasswd -Destination $etcPasswdDest -Force
    Write-Host "passwd erfolgreich kopiert!" -ForegroundColor Green
} else {
    Write-Host "passwd nicht gefunden, kein Kopiervorgang notwendig." -ForegroundColor Yellow
}

$localShadow = ".\shadow"
$etcShadow = ".\mmcblk0p2\HACK\etc\config\shadow"
$etcShadowDest = "$drive1`:\shadow"
$etcShadowDest2 = "$drive2`:\HACK\etc\config\shadow"

if (Test-Path $localShadow) {
    Write-Host "Kopiere lokale ./shadow Version nach / auf $drive1 und /HACK/etc/config auf $drive2..." -ForegroundColor Cyan
    Copy-Item -Path $localShadow -Destination $etcShadowDest -Force
    Copy-Item -Path $localShadow -Destination $etcShadowDest2 -Force
    Write-Host "lokale shadow Version erfolgreich kopiert!" -ForegroundColor Green
} elseif (Test-Path $etcShadow) {
    Write-Host "Kopiere HACK/etc/config/shadow nach / auf $drive1..." -ForegroundColor Cyan
    Copy-Item -Path $etcShadow -Destination $etcShadowDest -Force
    Write-Host "shadow erfolgreich kopiert!" -ForegroundColor Green
} else {
    Write-Host "shadow nicht gefunden, kein Kopiervorgang notwendig." -ForegroundColor Yellow
}

$localHttpdConf = ".\httpd.conf"
$localHttpdConfDest = "$drive2`:\HACK\etc\httpd.conf"

if (Test-Path $localHttpdConf) {
    Write-Host "Kopiere lokale ./httpd.conf Version nach /HACK/etc auf $drive2..." -ForegroundColor Cyan
    Copy-Item -Path $localHttpdConf -Destination $localHttpdConfDest -Force
    Write-Host "lokale httpd.conf Version erfolgreich kopiert!" -ForegroundColor Green
} else {
    Write-Host "httpd.conf nicht gefunden, kein Kopiervorgang notwendig." -ForegroundColor Yellow
}

$localCrontab = ".\crontab"
$localCrontabDest = "$drive2`:\HACK\var\spool\cron\crontabs\root"

if (Test-Path $localCrontab) {
    Write-Host "Kopiere lokale ./crontab Version nach /HACK/var/spool/cron/crontabs/root auf $drive2..." -ForegroundColor Cyan
    Copy-Item -Path $localCrontab -Destination $localCrontabDest -Force
    Write-Host "lokale crontab Version erfolgreich kopiert!" -ForegroundColor Green
} else {
    Write-Host "crontab nicht gefunden, kein Kopiervorgang notwendig." -ForegroundColor Yellow
}

Write-Host "Alle Vorgaenge abgeschlossen!" -ForegroundColor Green
Pause
