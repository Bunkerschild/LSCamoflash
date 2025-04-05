#!/bin/bash

echo "LSCamoflash SD-Karten Partitionierungsskript"
echo "ACHTUNG: NUR WECHSELMEDIEN WERDEN ANGEZEIGT! ALLE DATEN AUF DEM GEWAEHLTEN DATENTRAEGER WERDEN GELOESCHT!"
echo "ABBRUCH MIT CTRL+C"
sleep 5

# Wechselmedien auflisten
echo "Verfuegbare Wechselmedien:"
lsblk -o NAME,MODEL,SIZE,TYPE | grep "disk"

# Benutzer nach der SD-Karte fragen
read -p "Gib den Geraetenamen deiner SD-Karte ein (z.B. mmcblk0 oder sdb): " disk

# Überpruefen, ob das Geraet existiert
if [ ! -b "/dev/$disk" ]; then
    echo "Fehler: Das Geraet /dev/$disk existiert nicht!"
    exit 1
fi

# Sicherheitspruefung: Ist es ein Wechselmedium?
if ! lsblk -d -o NAME,ROTA | grep "^$disk" | awk '{print $2}' | grep "0"; then
    echo "Fehler: Der gewaehlte Datentraeger ist KEIN Wechselmedium! Abbruch."
    exit 1
fi

# SD Groesse
sdsize=`fdisk -l /dev/mmcblk0 | grep "^Disk" | grep bytes | awk '{print $5}'`
sdsect=`fdisk -l /dev/mmcblk0 | grep "^Disk" | grep bytes | awk '{print $7}'`
p2size=$((1024 * 1024 * 1024))
p1size=$(($sdsize - $p2size))
p1sect=`awk "BEGIN {print ($sdsect / $sdsize * $p1size)}"`

# Partitionen loeschen
echo "Loesche vorhandene Partitionen auf /dev/$disk ..."
wipefs --all --force /dev/$disk

# Partitionierung durchfuehren
echo "Erstelle neue Partitionen..."
echo "o
n
p
1

$p1sect
n
p
2


t
1
0c
t
2
0c
w" | fdisk /dev/$disk >/dev/null 2>&1

# Warten, bis das System die Partitionen erkennt
sleep 2
partprobe /dev/$disk

# Partitionen formatieren
echo "Formatiere Partitionen als FAT32..."
mkfs.vfat -F32 /dev/${disk}p1
mkfs.vfat -F32 /dev/${disk}p2

# Mount-Punkte erstellen
mount1=$(mktemp -d)
mount2=$(mktemp -d)

# Partitionen mounten
mount /dev/${disk}p1 "$mount1"
mount /dev/${disk}p2 "$mount2"

# Dateien kopieren
echo "Kopiere Dateien auf die erste Partition..."
cp -r ./mmcblk0p1/* "$mount1"/

echo "Kopiere Dateien auf die zweite Partition..."
cp -r ./mmcblk0p2/* "$mount2"/

echo "Kopiere Konfigurationsdateien, sofern vorhanden..."
[ -f "./hack_custom.conf" ] && cp -f ./hack_custom.conf "$mount2/HACK/etc"
[ -f "./mmcblk0p2/HACK/etc/passwd" ] && cp -f ./mmcblk0p2/HACK/etc/passwd "$mount1/"
[ -f "./mmcblk0p2/HACK/etc/shadow" ] && cp -f ./mmcblk0p2/HACK/etc/shadow "$mount1/"
[ -f "./passwd" ] && cp -f ./passwd "$mount1/" && cp -f ./passwd "$mount2/HACK/etc/config"
[ -f "./shadow" ] && cp -f ./shadow "$mount1/" && cp -f ./shadow "$mount2/HACK/etc/config"
[ -f "./httpd.conf" ] && cp -f ./httpd.conf "$mount2/HACK/etc"
[ -f "./crontab" ] && cp -f ./crontab "$mount2/HACK/var/spool/cron/crontabs/root"

echo "Synchronisiere Dateisysteme..."
sync
echo "Dateisysteme unmounten..."
# Unmounten
umount "$mount1"
umount "$mount2"

# Mount-Punkte bereinigen
rmdir "$mount1" "$mount2"

echo "Partitionierung und Datenkopie abgeschlossen!"
