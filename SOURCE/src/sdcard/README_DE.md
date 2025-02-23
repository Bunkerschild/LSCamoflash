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

- **Windows**: Führe `install.ps1` in der Powershell als Administrator aus.
  ```powershell
  Set-ExecutionPolicy Bypass -Scope Process -Force
  .\install.ps1
  Set-ExecutionPolicy Default -Scope Process -Force
  ```
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

Die **empfohlene Methode** ist die **automatische Installation mit `install.ps1` (Windows) oder `install.sh` (Linux)**, da sie Fehler vermeidet und den Vorgang vereinfacht.
