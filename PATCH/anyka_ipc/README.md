# Static Patch for anyka_ipc

This patch (see [LSCOutdoor1080P](https://github.com/guino/LSCOutdoor1080P)) is used to statically patch a version of **anyka_ipc**, enabling **RTSP support**.

## Supported Cameras
The patch works on the following cameras with **firmware version 2.10.36** and **anyka_ipc MD5 checksums**:

- **Static outdoor camera (1080p)**: `c05ea3bd828f58ce48094b7aa5db63fc`
- **Rotatable indoor camera (1080p)**: `8ea59723a177e1c68a798ca1a2882798`

## Installation Guide
1. **Download the repository files** or clone them using Git.
2. Copy the contents of the `SDCARD` directory onto a **FAT32-formatted** SD card.
3. **Download the firmware update** file from Tuya servers:
   - [Download Link](https://fireware.tuyaeu.com:1443/smart/firmware/upgrade/ay1541668973821t35pE/165966791961ed11009a7.bin0)
4. **Extract the firmware** using `binwalk`:
   ```sh
   binwalk -e -M 165966791961ed11009a7.bin
   ```
5. Locate the files:
   - `anyka_ipc` from `_165966791961ed11009a7.bin.extracted/_usr.sqsh4.extracted/squashfs-root/bin/`
   - `libavssdkbeta.so` from `_165966791961ed11009a7.bin.extracted/_usr.sqsh4.extracted/squashfs-root/lib/`
   - Copy both files to a **separate folder** on your PC.
6. **Apply the patch:**
   - Open [ROM Patcher](https://www.marcrobledo.com/RomPatcher.js/) (Do NOT enable Creator Mode!).
   - Select `anyka_ipc` as **ROM file**.
   - Verify that the displayed **MD5 checksum** matches `5ac1f462bf039ec3c6c0a31d27ae652a` (if not, stop and recheck!).
   - Select `anyka_ipc_rtsp.zip` from the **PATCH/anyka_ipc** directory.
   - Click **"Apply Patch"** and save the resulting file.
   - Rename the **downloaded file** to `anyka_ipc_patched`.

## Deploying the Patch
1. **Create the required directory structure** on your SD card:
   ```sh
   mkdir -p HACK/usr/patch/<MD5-CHECKSUM>/bin
   mkdir -p HACK/usr/patch/<MD5-CHECKSUM>/lib
   ```
2. **Copy the patched files** to the SD card:
   ```sh
   cp anyka_ipc anyka_ipc_patched HACK/usr/patch/<MD5-CHECKSUM>/bin/
   cp libavssdkbeta.so HACK/usr/patch/<MD5-CHECKSUM>/lib/
   ```
   *(Replace `<MD5-CHECKSUM>` with your camera's original anyka_ipc checksum.)*
3. **Insert the SD card** into the camera and power it on.
4. **Check RTSP, Telnet & FTP access:**
   - RTSP: `rtsp://<your-camera-ip>:554/main_ch`
   - Telnet: `telnet://<your-camera-ip>:24` (Username: `root`, Password: `LSCamoflash`)
   - FTP: `ftp://<your-camera-ip>:21` (Username: `root`, Password: `LSCamoflash`)

## Troubleshooting
- If **RTSP or Telnet is not working**, or the camera is stuck with a **blinking blue LED**:
  1. **Power off the camera**, remove the SD card.
  2. Rename or delete `HACK/usr/patch/<MD5-CHECKSUM>/bin/anyka_ipc_patched`.
  3. Insert the SD card again and power on the camera.
  4. If the issue persists, also remove `HACK/usr/patch/<MD5-CHECKSUM>/bin/anyka_ipc` and repeat.
- To verify the patch:
   ```sh
   md5sum /usr/bin/anyka_ipc
   ```
   Check if the checksum matches an entry in `SDCARD/HACK/etc/hack.conf` under `Static patch supported`.

---

# Statischer Patch für anyka_ipc

Dieser Patch (siehe [LSCOutdoor1080P](https://github.com/guino/LSCOutdoor1080P)) wird verwendet, um eine **statische Modifikation** an **anyka_ipc** vorzunehmen und **RTSP-Unterstützung** zu aktivieren.

## Unterstützte Kameras
Der Patch funktioniert mit den folgenden Kameras (**Firmware-Version 2.10.36**) und diesen **MD5-Prüfsummen**:

- **Statische Outdoor-Kamera (1080p)**: `c05ea3bd828f58ce48094b7aa5db63fc`
- **Drehbare Indoor-Kamera (1080p)**: `8ea59723a177e1c68a798ca1a2882798`

## Installationsanleitung
1. **Lade das Repository herunter** oder klone es mit Git.
2. Kopiere den Inhalt des `SDCARD`-Verzeichnisses auf eine **FAT32-formatierte** SD-Karte.
3. **Lade das Firmware-Update** von den Tuya-Servern herunter:
   - [Download-Link](https://fireware.tuyaeu.com:1443/smart/firmware/upgrade/ay1541668973821t35pE/165966791961ed11009a7.bin0)
4. **Extrahiere die Firmware** mit `binwalk`:
   ```sh
   binwalk -e -M 165966791961ed11009a7.bin
   ```
5. Finde die relevanten Dateien:
   - `anyka_ipc` aus `_165966791961ed11009a7.bin.extracted/_usr.sqsh4.extracted/squashfs-root/bin/`
   - `libavssdkbeta.so` aus `_165966791961ed11009a7.bin.extracted/_usr.sqsh4.extracted/squashfs-root/lib/`
   - Kopiere beide Dateien in einen separaten Ordner auf deinem PC.
6. **Patch anwenden:**
   - Öffne [ROM Patcher](https://www.marcrobledo.com/RomPatcher.js/) (**Creator Mode nicht aktivieren!**).
   - Wähle `anyka_ipc` als **ROM-Datei**.
   - Prüfe, ob die **MD5-Prüfsumme** `5ac1f462bf039ec3c6c0a31d27ae652a` entspricht.
   - Wähle `anyka_ipc_rtsp.zip` als **Patch-Datei**.
   - Klicke auf **"Apply Patch"** und speichere die Datei als `anyka_ipc_patched`.

## Patch auf der Kamera anwenden
1. **Erstelle die benötigte Ordnerstruktur** auf der SD-Karte:
   ```sh
   mkdir -p HACK/usr/patch/<MD5-CHECKSUM>/bin
   mkdir -p HACK/usr/patch/<MD5-CHECKSUM>/lib
   ```
2. **Kopiere die gepatchten Dateien** auf die SD-Karte:
   ```sh
   cp anyka_ipc anyka_ipc_patched HACK/usr/patch/<MD5-CHECKSUM>/bin/
   cp libavssdkbeta.so HACK/usr/patch/<MD5-CHECKSUM>/lib/
   ```
3. **SD-Karte einlegen und Kamera starten.**
4. **Teste RTSP, Telnet & FTP-Zugriff:**
   - RTSP: `rtsp://<Kamera-IP>:554/main_ch`
   - Telnet: `telnet://<Kamera-IP>:24` (Benutzer: `root`, Passwort: `LSCamoflash`)
   - FTP: `ftp://<Kamera-IP>:21` (Benutzer: `root`, Passwort: `LSCamoflash`)

## Fehlerbehebung
Falls **RTSP oder Telnet nicht funktioniert**, oder die Kamera mit einer **blinkenden blauen LED** stecken bleibt:
1. **Schalte die Kamera aus** und entferne die SD-Karte.
2. Benenne `HACK/usr/patch/<MD5-CHECKSUM>/bin/anyka_ipc_patched` um oder lösche es.
3. Setze die SD-Karte wieder ein und starte die Kamera erneut.
4. Falls das Problem weiterhin besteht, entferne auch `HACK/usr/patch/<MD5-CHECKSUM>/bin/anyka_ipc` und wiederhole den Vorgang.

Um den Patch zu überprüfen:
```sh
md5sum /usr/bin/anyka_ipc
```
Überprüfe, ob die Prüfsumme mit einem Eintrag in `SDCARD/HACK/etc/hack.conf` unter `Static patch supported` übereinstimmt.

## FTP-Zugriff
- Neben RTSP und Telnet ist auch **FTP-Zugriff** auf die SD-Karte über **Port 21** möglich.
- Zugangsdaten sind dieselben wie bei Telnet:
  - **Benutzername:** `root`
  - **Passwort:** `LSCamoflash`
