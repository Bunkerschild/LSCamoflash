@echo off
echo LSCamoflash SD-Karten Partitionierungsskript
echo ACHTUNG: NUR WECHSELMEDIEN WERDEN ANGEZEIGT! ALLE DATEN AUF DEM GEWÄHLTEN DATENTRÄGER WERDEN GELÖSCHT!
echo ABBRUCH MIT CTRL+C
pause

:: Liste nur Wechselmedien auf
wmic diskdrive where "MediaType like 'Removable Media'" get Index, Model, Size

:: Prüfen, ob überhaupt ein Wechselmedium gefunden wurde
setlocal enabledelayedexpansion
set hasSDCard=false

for /f "skip=1 tokens=1" %%A in ('wmic diskdrive where "MediaType like 'Removable Media'" get Index ^| findstr /r "^[0-9]"') do (
    set hasSDCard=true
)

:: Falls keine SD-Karte erkannt wurde, abbrechen
if "%hasSDCard%"=="false" (
    echo Keine SD-Karte oder Wechselmedium gefunden! Skript wird beendet.
    pause
    exit
)

:: Benutzer nach dem SD-Karten-Datenträger fragen
set /p disknum="Gib die Datenträgernummer deiner SD-Karte ein: "

:: Sicherheit prüfen: Ist es wirklich ein Wechselmedium?
wmic diskdrive where "Index=%disknum%" get MediaType | findstr /i "Removable" > nul
if %errorlevel% neq 0 (
    echo Fehler: Der gewählte Datenträger ist KEIN Wechselmedium! Abbruch.
    pause
    exit
)

:: Automatische Ermittlung freier Laufwerksbuchstaben für Partition 1 und 2
set DRIVE1=
set DRIVE2=

for %%A in (E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    fsutil fsinfo drivetype %%A: 2>nul | findstr "Nicht bereit" >nul
    if not errorlevel 1 (
        if not defined DRIVE1 (
            set DRIVE1=%%A
        ) else if not defined DRIVE2 (
            set DRIVE2=%%A
        )
    )
)

:: Verzögerte Variablenerweiterung für die Prüfung
if "!DRIVE1!"=="" (
    echo Fehler: Kein freier Laufwerksbuchstabe für die erste Partition gefunden!
    pause
    exit
)
if "!DRIVE2!"=="" (
    echo Fehler: Kein freier Laufwerksbuchstabe für die zweite Partition gefunden!
    pause
    exit
)

echo Erster freier Laufwerksbuchstabe: %DRIVE1%:
echo Zweiter freier Laufwerksbuchstabe: %DRIVE2%:
pause

:: Diskpart-Befehle in eine temporäre Datei schreiben
(
echo select disk %disknum%
echo clean
echo create partition primary
echo shrink desired=1024
echo format fs=fat32 quick
echo assign letter=%DRIVE1%
echo create partition primary
echo format fs=fat32 quick
echo assign letter=%DRIVE2%
echo exit
) > diskpart_script.txt

:: Diskpart-Skript ausführen
diskpart /s diskpart_script.txt

:: Temporäre Datei löschen
del diskpart_script.txt

:: Dateien aus SDCARD/mmcblk0p1 nach %DRIVE1%: kopieren
echo Kopiere Dateien auf die erste Partition (%DRIVE1%:)...
robocopy SDCARD\mmcblk0p1 %DRIVE1%:\ /E /V /MT:8

:: Dateien aus SDCARD/mmcblk0p2 nach %DRIVE2%: kopieren
echo Kopiere Dateien auf die zweite Partition (%DRIVE2%:)...
robocopy SDCARD\mmcblk0p2 %DRIVE2%:\ /E /V /MT:8

echo Partitionierung und Datenkopie abgeschlossen! 
pause
