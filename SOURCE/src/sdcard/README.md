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

## SD Card Preparation (available only for Linux)
Before installing LSCamoflash, it is recommended to prepare the SD card using the `disk_prepare.sh` script. This utility:

- **Erases all data** on the SD card irreversibly
- **Performs read/write tests** to detect card damage and measure performance
- **Rates the card's suitability** for use with the cameras based on capacity and read/write speeds (using school grades)
- **Performs secure clearing** using `blkdiscard` and FAT32 formatting to remove any residual data that could slow down read/write access
- **Helps restore** partially damaged cards to a working state

### Capacity Requirements
- **Recommended**: At least **32 GB** SD card
- **Maximum**: **128 GB** SD card

⚠️ **Warning**: Running this script will **permanently delete all data** on the selected SD card. Ensure you have selected the correct device.

### Basic Usage
To run the script on Linux:
```bash
chmod +x ./disk_prepare.sh
sudo ./disk_prepare.sh
```

### Advanced Command-Line Options (For Experts)
The script supports the following CLI switches:

```bash
Usage:
  disk_prepare.sh                        # interactive disk selection + confirmation
  disk_prepare.sh -D /dev/mmcblk0        # non-interactive with confirmation
  disk_prepare.sh -D /dev/mmcblk0 -F     # skip confirmation prompt
  disk_prepare.sh -D /dev/mmcblk0 -f     # faster test (count=128)
  disk_prepare.sh -D /dev/mmcblk0 -u     # ultra-fast test (count=64)
```

**Options:**
- `-D, --disk <device>`: Select disk non-interactively (e.g., `/dev/mmcblk0`, `/dev/sdb`)
- `-F, --force`: Skip the destructive confirmation prompt (use with caution)
- `-f, --fast`: Faster test with reduced write operations. Only applicable for SD cards >= 8 GiB. Trades thoroughness for speed.
- `-u, --ultra`: Ultra-fast test with minimal write operations. Only applicable for SD cards >= 8 GiB. Provides the quickest result but least precise speed measurement.
- `-h, --help`: Display the help message

**Speed vs. Accuracy**: The `--fast` and `--ultra` options are only recommended when you need results quickly. The standard mode (default) provides the most accurate performance measurement. Faster modes reduce the amount of data written to the card and therefore provide less precise speed measurements.

## Automatic Installation (Recommended)
To simplify partitioning and file copying, installation scripts are provided for Windows and Linux:

- **Windows**: Run `install.ps1` in powershell as Administrator.
  ```powershell
  Set-ExecutionPolicy Bypass -Scope Process -Force
  .\install.ps1
  Set-ExecutionPolicy Default -Scope Process -Force
  ```
- **Linux**: Run `install.sh` with root privileges:
  ```bash
  chmod +x ./install.sh
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

The **recommended method** is the **automatic installation with `install.ps1` (Windows) or `install.sh` (Linux)**, as it avoids errors and simplifies the process.
