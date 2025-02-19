# LSCamoflash - SD Card Setup Guide

## Introduction

LSCamoflash requires an SD card with two partitions to function properly. The software has been updated to detect manipulations on the SD card, making it necessary to move the hack files to a separate partition (`mmcblk0p2`).

### Partition Requirements:
- **Partition 1 (`mmcblk0p1`)**: At least **256MB**, formatted as **FAT32**.
  - Stores `hostapd` and `_ht_ap_mode.conf`.
- **Partition 2 (`mmcblk0p2`)**: At least **1GB**, formatted as **FAT32**.
  - Stores the hack files.

The `SDCARD` folder in this repository contains:
- `mmcblk0p1/` - Contents for the first partition.
- `mmcblk0p2/` - Contents for the second partition.

## How to Partition the SD Card

### **Windows**

1. **Insert the SD card** into your computer.
2. **Open Disk Management**: Press `Win + X`, then select `Disk Management`.
3. **Locate your SD card** (e.g., `Disk 2`).
4. **Delete existing partitions**:
   - Right-click each partition and select `Delete Volume` until the entire SD card is unallocated.
5. **Create the first partition (`mmcblk0p1`)**:
   - Right-click the unallocated space → `New Simple Volume`.
   - Set size: **256MB** (or more).
   - Format as **FAT32**.
   - Assign a drive letter (e.g., `E:`).
6. **Create the second partition (`mmcblk0p2`)**:
   - Right-click the remaining unallocated space → `New Simple Volume`.
   - Set size: **At least 1GB**.
   - Format as **FAT32**.
   - Assign a drive letter (e.g., `F:`).
7. **Copy files**:
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
   ├─mmcblk0p1  256M  
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
     - Partition **1**, size **+256M**.
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

LSCamoflash benötigt eine SD-Karte mit zwei Partitionen, um korrekt zu funktionieren. Die Software wurde aktualisiert, um Manipulationen an der SD-Karte zu erkennen. Daher müssen die Hack-Dateien auf eine separate Partition (`mmcblk0p2`) verschoben werden.

### **Partitionsanforderungen:**
- **Partition 1 (`mmcblk0p1`)**: Mindestens **256MB**, formatiert als **FAT32**.
  - Speichert `hostapd` und `_ht_ap_mode.conf`.
- **Partition 2 (`mmcblk0p2`)**: Mindestens **1GB**, formatiert als **FAT32**.
  - Speichert die Hack-Dateien.

Im `SDCARD`-Ordner dieses Repos befinden sich:
- `mmcblk0p1/` - Inhalte für die erste Partition.
- `mmcblk0p2/` - Inhalte für die zweite Partition.

## **SD-Karte partitionieren**

### **Windows**

1. **SD-Karte einlegen**.
2. **Datenträgerverwaltung öffnen** (`Win + X` → `Datenträgerverwaltung`).
3. **SD-Karte finden** (z. B. `Datenträger 2`).
4. **Vorhandene Partitionen löschen**:
   - Rechtsklick auf jede Partition → `Volume löschen`.
5. **Erste Partition (`mmcblk0p1`) erstellen**:
   - Rechtsklick auf `Nicht zugewiesener Speicher` → `Neues einfaches Volume`.
   - Größe: **256MB** (oder mehr).
   - Format: **FAT32**.
   - Laufwerksbuchstaben zuweisen.
6. **Zweite Partition (`mmcblk0p2`) erstellen**:
   - Rechtsklick auf `Nicht zugewiesener Speicher` → `Neues einfaches Volume`.
   - Größe: **mindestens 1GB**.
   - Format: **FAT32**.
   - Laufwerksbuchstaben zuweisen.
7. **Dateien kopieren**:
   - Inhalte aus `SDCARD/mmcblk0p1/` → auf **erste Partition** (`mmcblk0p1`).
   - Inhalte aus `SDCARD/mmcblk0p2/` → auf **zweite Partition** (`mmcblk0p2`).

### **Linux**

1. **SD-Karte identifizieren**:
   ```bash
   lsblk
   ```
2. **Partitionen löschen und neu erstellen**:
   ```bash
   sudo fdisk /dev/mmcblk0
   ```
   - `d` zum Löschen aller Partitionen.
   - `n` → `p` → `1` → `+256M`.
   - `t` → `b` für FAT32.
   - `n` → `p` → `2` → `+1G`.
   - `t` → Partition `2` → `b` für FAT32.
   - `w` zum Speichern.
3. **Partitionen formatieren**:
   ```bash
   sudo mkfs.vfat -F32 /dev/mmcblk0p1
   sudo mkfs.vfat -F32 /dev/mmcblk0p2
   ```
4. **Dateien kopieren**:
   ```bash
   sudo mount /dev/mmcblk0p1 /mnt/mmcblk0p1
   sudo mount /dev/mmcblk0p2 /mnt/mmcblk0p2
   sudo cp -r SDCARD/mmcblk0p1/* /mnt/mmcblk0p1/
   sudo cp -r SDCARD/mmcblk0p2/* /mnt/mmcblk0p2/
   sudo umount /mnt/mmcblk0p1
   sudo umount /mnt/mmcblk0p2
   
