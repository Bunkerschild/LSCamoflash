#!/bin/bash

echo "LSCamoflash SD-Karten Partitionierungsskript"
echo "ACHTUNG: NUR WECHSELMEDIEN WERDEN ANGEZEIGT! ALLE DATEN AUF DEM GEWÄHLTEN DATENTRÄGER WERDEN GELÖSCHT!"
echo "ABBRUCH MIT CTRL+C"
sleep 5

# Wechselmedien auflisten
echo "Verfügbare Wechselmedien:"
lsblk -o NAME,MODEL,SIZE,TYPE | grep "disk"

# Benutzer nach der SD-Karte fragen
read -p "Gib den Gerätenamen deiner SD-Karte ein (z.B. mmcblk0 oder sdb): " disk

# Überprüfen, ob das Gerät existiert
if [ ! -b "/dev/$disk" ]; then
    echo "Fehler: Das Gerät /dev/$disk existiert nicht!"
    exit 1
fi

# Sicherheitsprüfung: Ist es ein Wechselmedium?
if ! lsblk -d -o NAME,ROTA | grep -q "$disk 0"; then
    echo "Fehler: Der gewählte Datenträger ist KEIN Wechselmedium! Abbruch."
    exit 1
fi

# Partitionen löschen
echo "Lösche vorhandene Partitionen auf /dev/$disk ..."
wipefs --all --force /dev/$disk
parted -s /dev/$disk mklabel msdos

# Partitionierung durchführen
echo "Erstelle neue Partitionen..."
parted -s /dev/$disk mkpart primary fat32 1MiB -1GiB
parted -s /dev/$disk mkpart primary fat32 -1GiB 100%

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
[ -f "./shadow" ] && cp -f ./shadow "$mount1/" && cp -f ./shadow "$mount2/HACK/etc/config"

# Unmounten
umount "$mount1"
umount "$mount2"

# Mount-Punkte bereinigen
rmdir "$mount1" "$mount2"

echo "Partitionierung und Datenkopie abgeschlossen!"
