# LSCamoflash - SD Card Setup Guide

## Introduction

LSCamoflash requires an SD card with two partitions to function properly. The software has been updated to detect manipulations on the SD card, making it necessary to move the hack files to a separate partition (`mmcblk0p2`).

### Partition Requirements:
- **Partition 1 (`mmcblk0p1`)**: At least **14GB**, formatted as **FAT32**.
  - Stores video recordings as well as `hostapd` and `_ht_ap_mode.conf`.
- **Partition 2 (`mmcblk0p2`)**: At least **1GB**, formatted as **FAT32**.
  - Stores the hack files.

The `SDCARD` folder in this repository contains:
- `mmcblk0p1/` - Contents for the first partition.
- `mmcblk0p2/` - Contents for the second partition.

## Automatic Installation (Recommended)
To simplify partitioning and file copying, installation scripts are provided for Windows and Linux:

- **Windows**: Run `install.bat` as Administrator.
- **Linux**: Run `install.sh` with root privileges:
  ```bash
  sudo ./install.sh
  ```

These scripts will automatically handle partitioning and copying the files to the SD card.

---

## Manual SD Card Partitioning
If the scripts cannot be used, the SD card can be partitioned manually.

### **Windows (Using Diskpart)**

1. **Insert the SD card into the computer**.
2. **Open the command prompt as Administrator** (`Win + R`, type `cmd`, then press `Ctrl + Shift + Enter`).
3. **Start Diskpart**:
   ```
   diskpart
   ```
4. **List available disks**:
   ```
   list disk
   ```
5. **Select the SD card** (replace `X` with the correct disk number):
   ```
   select disk X
   ```
6. **Clean the SD card**:
   ```
   clean
   ```
7. **Create the first partition (`mmcblk0p1`)**:
   ```
   create partition primary
   shrink desired=1024
   format fs=fat32 quick
   assign letter=E
   ```
8. **Create the second partition (`mmcblk0p2`)**:
   ```
   create partition primary
   format fs=fat32 quick
   assign letter=F
   ```
9. **Exit Diskpart**:
   ```
   exit
   ```
10. **Copy files**:
    - Copy the contents of `SDCARD/mmcblk0p1/` to the **first partition** (`mmcblk0p1`).
    - Copy the contents of `SDCARD/mmcblk0p2/` to the **second partition** (`mmcblk0p2`).

### **Linux (Manual Method)**

1. **Identify the SD card**:
   ```bash
   lsblk
   ```
   Example output:
   ```
   mmcblk0      14.9G
   ├─mmcblk0p1  14G  
   └─mmcblk0p2  1G  
   ```
2. **Unmount the SD card (if mounted)**:
   ```bash
   sudo umount /dev/mmcblk0p1
   sudo umount /dev/mmcblk0p2
   ```
3. **Start `fdisk` to partition the SD card**:
   ```bash
   sudo fdisk /dev/mmcblk0
   ```
   - Press `d` to delete existing partitions.
   - Press `n` to create a new partition:
     - Select `p` for primary partition.
     - Partition **1**, size **+14G**.
     - Press `t`, then enter `b` for FAT32.
   - Press `n` again to create the second partition:
     - Partition **2**, size **+1G** (or more).
     - Press `t`, select partition **2**, enter `b` for FAT32.
   - Press `w` to save changes and exit `fdisk`.
4. **Format the partitions**:
   ```bash
   sudo mkfs.vfat -F32 /dev/mmcblk0p1
   sudo mkfs.vfat -F32 /dev/mmcblk0p2
   ```
5. **Copy files**:
   ```bash
   sudo mount /dev/mmcblk0p1 /mnt/mmcblk0p1
   sudo mount /dev/mmcblk0p2 /mnt/mmcblk0p2
   
   sudo cp -r SDCARD/mmcblk0p1/* /mnt/mmcblk0p1/
   sudo cp -r SDCARD/mmcblk0p2/* /mnt/mmcblk0p2/
   
   sudo umount /mnt/mmcblk0p1
   sudo umount /mnt/mmcblk0p2
   ```

---

The **recommended method** is the **automatic installation with `install.bat` (Windows) or `install.sh` (Linux)**, as it avoids errors and simplifies the process.

---

# LSCamoflash - SD-Karten-Setup-Anleitung

## Einführung

LSCamoflash benötigt eine SD-Karte mit zwei Partitionen, um ordnungsgemäß zu funktionieren. Die Software wurde aktualisiert, um Manipulationen an der SD-Karte zu erkennen, weshalb die Hack-Dateien auf eine separate Partition (`mmcblk0p2`) verschoben wurden.

### Partitionierungsanforderungen:
- **Partition 1 (`mmcblk0p1`)**: Mindestens **14GB**, formatiert als **FAT32**.
  - Speichert Videoaufnahmen sowie `hostapd` und `_ht_ap_mode.conf`.
- **Partition 2 (`mmcblk0p2`)**: Mindestens **1GB**, formatiert als **FAT32**.
  - Speichert die Hack-Dateien.

Im `SDCARD`-Ordner dieses Repos befinden sich:
- `mmcblk0p1/` - Inhalte für die erste Partition.
- `mmcblk0p2/` - Inhalte für die zweite Partition.

## Automatische Installation (Empfohlen)
Um die Partitionierung und das Kopieren der Dateien zu vereinfachen, gibt es für Windows und Linux jeweils ein Installationsskript:

- **Windows**: Führe `install.bat` als Administrator aus.
- **Linux**: Führe `install.sh` mit Root-Rechten aus:
  ```bash
  sudo ./install.sh
  ```

Diese Skripte sorgen automatisch für die richtige Partitionierung und das Kopieren der Dateien auf die SD-Karte.

---

## Manuelle SD-Karten-Partitionierung
Falls die Skripte nicht genutzt werden können, kann die SD-Karte manuell partitioniert werden.

### **Windows (mit Diskpart)**

1. **SD-Karte in den Computer einlegen**.
2. **Eingabeaufforderung als Administrator öffnen** (`Win + R`, `cmd` eingeben, dann `Strg + Umschalt + Enter` drücken).
3. **Diskpart starten**:
   ```
   diskpart
   ```
4. **Verfügbare Datenträger auflisten**:
   ```
   list disk
   ```
5. **SD-Karte auswählen** (`X` durch die richtige Datenträgernummer ersetzen):
   ```
   select disk X
   ```
6. **SD-Karte bereinigen**:
   ```
   clean
   ```
7. **Erste Partition (`mmcblk0p1`) erstellen**:
   ```
   create partition primary
   shrink desired=1024
   format fs=fat32 quick
   assign letter=E
   ```
8. **Zweite Partition (`mmcblk0p2`) erstellen**:
   ```
   create partition primary
   format fs=fat32 quick
   assign letter=F
   ```
9. **Diskpart beenden**:
   ```
   exit
   ```
10. **Dateien kopieren**:
    - Kopiere den Inhalt von `SDCARD/mmcblk0p1/` auf die **erste Partition** (`mmcblk0p1`).
    - Kopiere den Inhalt von `SDCARD/mmcblk0p2/` auf die **zweite Partition** (`mmcblk0p2`).

### **Linux (Manuelle Methode)**

1. **SD-Karte identifizieren**:
   ```bash
   lsblk
   ```
   Beispielausgabe:
   ```
   mmcblk0      14.9G
   ├─mmcblk0p1  14G  
   └─mmcblk0p2  1G  
   ```
2. **SD-Karte aushängen (falls eingehängt)**:
   ```bash
   sudo umount /dev/mmcblk0p1
   sudo umount /dev/mmcblk0p2
   ```
3. **`fdisk` starten, um die SD-Karte zu partitionieren**:
   ```bash
   sudo fdisk /dev/mmcblk0
   ```
   - `d` drücken, um vorhandene Partitionen zu löschen.
   - `n` drücken, um eine neue Partition zu erstellen:
     - `p` für primäre Partition auswählen.
     - Partition **1**, Größe **+14G**.
     - `t` drücken, dann `b` für FAT32 eingeben.
   - `n` erneut drücken, um die zweite Partition zu erstellen:
     - Partition **2**, Größe **+1G** (oder mehr).
     - `t` drücken, Partition **2** auswählen und `b` für FAT32 eingeben.
   - `w` drücken, um die Änderungen zu speichern und `fdisk` zu beenden.
4. **Partitionen formatieren**:
   ```bash
   sudo mkfs.vfat -F32 /dev/mmcblk0p1
   sudo mkfs.vfat -F32 /dev/mmcblk0p2
   ```
5. **Dateien kopieren**:
   ```bash
   sudo mount /dev/mmcblk0p1 /mnt/mmcblk0p1
   sudo mount /dev/mmcblk0p2 /mnt/mmcblk0p2
   
   sudo cp -r SDCARD/mmcblk0p1/* /mnt/mmcblk0p1/
   sudo cp -r SDCARD/mmcblk0p2/* /mnt/mmcblk0p2/
   
   sudo umount /mnt/mmcblk0p1
   sudo umount /mnt/mmcblk0p2
   ```

---

Die **empfohlene Methode** ist die **automatische Installation mit `install.bat` (Windows) oder `install.sh` (Linux)**, da sie Fehler vermeidet und den Vorgang vereinfacht.
