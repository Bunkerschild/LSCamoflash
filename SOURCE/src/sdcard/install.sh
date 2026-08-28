#!/bin/bash

use_sd_config=0

if [ "$1" = "-u" -o "$1" = "--use-sd-config" ]; then
	use_sd_config=1
fi

echo "LSCamoflash SD-Karten Partitionierungsskript"
[ "$use_sd_config" = "1" ] && echo "Konfigurationsdateien werden von der SD uebernommen, sofern vorhanden."
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

# Sicherheitspruefung: Ist es ein Wechselmedium? (RM=1, nicht ROTA:
# moderne interne SSDs sind ROTA=0 und wuerden die alte Pruefung faelschlich bestehen)
if [ "$(lsblk -dno RM /dev/$disk 2>/dev/null)" != "1" ]; then
    echo "Fehler: Der gewaehlte Datentraeger ist KEIN Wechselmedium! Abbruch."
    exit 1
fi

# Partitions-Namensschema bestimmen: mmcblk0/nvme (endet auf Ziffer) -> "p"-Trenner,
# sd*/hd*/vd* -> kein Trenner (z.B. sdb -> sdb1, mmcblk0 -> mmcblk0p1)
case "$disk" in
	*[0-9]) part="${disk}p" ;;
	*)      part="${disk}" ;;
esac

# Mount-Punkte erstellen
mount1=$(mktemp -d)
mount2=$(mktemp -d)

if [ "$use_sd_config" = "1" ]; then
	mount /dev/${part}1 $mount1 >/dev/null 2>&1
	mount /dev/${part}2 $mount2 >/dev/null 2>&1
	
	for m in $mount1 $mount2; do
		if [ -f "$m/HACK/etc/hack_custom.conf" ]; then
			echo "Kopiere Konfiguration von SD Karte..."
			cp -f $m/HACK/etc/hack_custom.conf hack_custom.conf >/dev/null 2>&1
			cp -f $m/HACK/etc/config/passwd passwd >/dev/null 2>&1
			cp -f $m/HACK/etc/config/shadow shadow >/dev/null 2>&1
			cp -f $m/HACK/var/spool/cron/crontabs/root crontab >/dev/null 2>&1
		fi
	done
	
	umount $mount2 >/dev/null 2>&1
	umount $mount1 >/dev/null 2>&1
fi

# SD Groesse (blockdev statt fdisk-Ausgabe zu parsen)
sdsize=$(blockdev --getsize64 /dev/$disk)
p2size=$((1024 * 1024 * 1024))                 # Partition 2 = 1 GiB
# Partition 1 in ganzen MiB; wird als "+<MiB>M" an fdisk uebergeben. Vermeidet die
# Fliesskomma-/Wissenschaftsnotation (z.B. 6.04e+07) die fdisk nicht als Sektor parsen kann.
p1mib=$(( (sdsize - p2size) / 1024 / 1024 ))

# Vorhandene (evtl. automatisch gemountete) Partitionen aushaengen
umount /dev/${disk}?* 2>/dev/null

# Partitionen loeschen
echo "Loesche vorhandene Partitionen auf /dev/$disk ..."
wipefs --all --force /dev/$disk

# Partitionierung mit sfdisk (skriptfaehig statt fragiler fdisk-Tastendruck-Sequenz):
#   Partition 1 = p1mib MiB, Partition 2 = Rest, beide Typ 0x0c (W95 FAT32 LBA)
echo "Erstelle neue Partitionen..."
sfdisk --wipe always --wipe-partitions always /dev/$disk <<EOF
label: dos
size=${p1mib}MiB, type=0c
type=0c
EOF

# Kernel die neue Partitionstabelle einlesen lassen und pruefen, dass beide da sind
sync
partprobe /dev/$disk 2>/dev/null
udevadm settle 2>/dev/null
sleep 2
if [ ! -b /dev/${part}1 ] || [ ! -b /dev/${part}2 ]; then
	echo "Fehler: /dev/${part}1 bzw. /dev/${part}2 wurde nicht angelegt (Partitionstabelle nicht neu eingelesen). Abbruch." >&2
	exit 1
fi

# Vor dem Formatieren aushaengen (falls der Desktop automatisch gemountet hat)
udevadm settle 2>/dev/null
umount /dev/${part}1 2>/dev/null
umount /dev/${part}2 2>/dev/null

# Partitionen formatieren
echo "Formatiere Partitionen als FAT32..."
mkfs.vfat -F32 /dev/${part}1
mkfs.vfat -F32 /dev/${part}2

# Partitionen mounten
mount /dev/${part}1 "$mount1"
mount /dev/${part}2 "$mount2"

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
