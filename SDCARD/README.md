# LSCamoflash - SD Card Setup Guide

## Introduction

LSCamoflash requires an SD card with two partitions to function properly. The software has been updated to detect manipulations on the SD card, making it necessary to move the hack files to a separate partition (`mmcblk0p2`).

### Partition Requirements:
- **Partition 1 (`mmcblk0p1`)**: At least **14GB**, formatted as **FAT32**.
  - Stores video recordings and `hostapd` and `_ht_ap_mode.conf`.
- **Partition 2 (`mmcblk0p2`)**: At least **1GB**, formatted as **FAT32**.
  - Stores the hack files.

The `SDCARD` folder in this repository contains:
- `mmcblk0p1/` - Contents for the first partition.
- `mmcblk0p2/` - Contents for the second partition.

## How to Partition the SD Card

### **Windows (Using Diskpart)**

1. **Insert the SD card** into your computer.
2. **Open Command Prompt as Administrator** (`Win + R`, type `cmd`, press `Ctrl + Shift + Enter`).
3. **Start Diskpart**:
   ```
   diskpart
   ```
4. **List available disks**:
   ```
   list disk
   ```
5. **Select your SD card** (replace `X` with the correct disk number):
   ```
   select disk X
   ```
6. **Clean the SD card**:
   ```
   clean
   ```
7. **Create the first partition (`mmcblk0p1`)**:
   ```
   create partition primary size=14336
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

### **Linux**

1. **Identify your SD card**:
   ```bash
   lsblk
   ```
   Example output:
   ```
   mmcblk0      14.9G
   ├─mmcblk0p1  14G  
   └─mmcblk0p2  1G  
   ```
2. **Unmount the SD card** (if mounted):
   ```bash
   sudo umount /dev/mmcblk0p1
   sudo umount /dev/mmcblk0p2
   ```
3. **Open `fdisk` to partition the SD card**:
   ```bash
   sudo fdisk /dev/mmcblk0
   ```
   - Press `d` to delete existing partitions.
   - Press `n` to create a new partition:
     - Select `p` for primary.
     - Partition **1**, size **+14G**.
     - Press `t`, then enter `b` (FAT32 format).
   - Press `n` again to create the second partition:
     - Partition **2**, size **+1G** (or more).
     - Press `t`, select partition **2**, enter `b` (FAT32 format).
   - Press `w` to write changes and exit.
4. **Format the partitions**:
   ```bash
   sudo mkfs.vfat -F32 /dev/mmcblk0p1
   sudo mkfs.vfat -F32 /dev/mmcblk0p2
   ```
5. **Mount and copy files**:
   ```bash
   sudo mount /dev/mmcblk0p1 /mnt/mmcblk0p1
   sudo mount /dev/mmcblk0p2 /mnt/mmcblk0p2
   
   sudo cp -r SDCARD/mmcblk0p1/* /mnt/mmcblk0p1/
   sudo cp -r SDCARD/mmcblk0p2/* /mnt/mmcblk0p2/
   
   sudo umount /mnt/mmcblk0p1
   sudo umount /mnt/mmcblk0p2
   ```
---
# LSCamoflash - SD-Karten-Setup-Anleitung

## Einführung

LSCamoflash benötigt eine SD-Karte mit zwei Partitionen, um ordnungsgemäß zu funktionieren. Die Software wurde aktualisiert, um Manipulationen an der SD-Karte zu erkennen, weshalb die Hack-Dateien auf eine separate Partition (`mmcblk0p2`) verschoben wurden.

### Partitionierungsanforderungen:
- **Partition 1 (`mmcblk0p1`)**: Mindestens **14GB**, formatiert als **FAT32**.
  - Speichert Videoaufnahmen sowie `hostapd` und `_ht_ap_mode.conf`.
- **Partition 2 (`mmcblk0p2`)**: Mindestens **1GB**, formatiert als **FAT32**.
  - Speichert die Hack-Dateien.

Der Ordner `SDCARD` in diesem Repository enthält:
- `mmcblk0p1/` - Inhalte für die erste Partition.
- `mmcblk0p2/` - Inhalte für die zweite Partition.

## So partitionierst du die SD-Karte

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
   create partition primary size=14336
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

### **Linux**

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
