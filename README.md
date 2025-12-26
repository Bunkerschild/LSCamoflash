# LSCamoflash

LSCamoflash is a modified firmware package for specific IP cameras that provides additional features and improvements.

- [LSCamoflash Github-Page](https://bunkerschild.github.io/LSCamoflash/)
- [Download Latest Autobuild Full Package](https://bunkerschild.github.io/LSCamoflash/autobuild/LSCamoflash-Autobuild.tar.gz)
- [Download Latest Autobuild Update Package](https://bunkerschild.github.io/LSCamoflash/autobuild/update-autobuild.tgz)
- [Download Latest Release](https://github.com/Bunkerschild/LSCamoflash/releases/latest)

[![GitHub stars](https://img.shields.io/github/stars/Bunkerschild/LSCamoflash.svg)](https://github.com/Bunkerschild/LSCamoflash/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/Bunkerschild/LSCamoflash.svg)](https://github.com/Bunkerschild/LSCamoflash/network)

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![GitHub release](https://img.shields.io/github/v/release/Bunkerschild/LSCamoflash.svg)](https://github.com/Bunkerschild/LSCamoflash/releases)
[![GitHub downloads](https://img.shields.io/github/downloads/Bunkerschild/LSCamoflash/total.svg)](https://github.com/Bunkerschild/LSCamoflash/releases)
[![Last commit](https://img.shields.io/github/last-commit/Bunkerschild/LSCamoflash.svg)](https://github.com/Bunkerschild/LSCamoflash/commits/main)
[![Security Policy](https://img.shields.io/badge/security-policy-blue.svg)](SECURITY.md)

[![Build-Test](https://github.com/Bunkerschild/LSCamoflash/actions/workflows/makefile.yml/badge.svg)](https://github.com/Bunkerschild/LSCamoflash/actions/workflows/makefile.yml)
[![Create Stable Release](https://github.com/Bunkerschild/LSCamoflash/actions/workflows/release.yml/badge.svg)](https://github.com/Bunkerschild/LSCamoflash/actions/workflows/release.yml)
[![CodeQL Advanced](https://github.com/Bunkerschild/LSCamoflash/actions/workflows/codeql.yml/badge.svg)](https://github.com/Bunkerschild/LSCamoflash/actions/workflows/codeql.yml)
[![Deploy GitHub Pages](https://github.com/Bunkerschild/LSCamoflash/actions/workflows/jekyll-gh-pages.yml/badge.svg)](https://github.com/Bunkerschild/LSCamoflash/actions/workflows/jekyll-gh-pages.yml)

Security issues should be reported responsibly. See SECURITY.md.

## Table of Contents

- [Installation](#installation)
- [Setting up the Build Environment](#setting-up-the-build-environment)
- [Available Tools](#available-tools)
- [Password Management](#password-management)
- [Web Server Features](#web-server-features)
- [Update Mechanism](#update-mechanism)
- [SD Card Partitioning](#sd-card-partitioning)
- [Planned Improvements](#planned-improvements)
- [Disclaimer](#disclaimer)

## Disclaimer

**WARNING:** This project modifies firmware and may void your device warranty. Use at your own risk.

- **No Liability:** The authors assume no responsibility for any damage, loss of data, corrupted hardware, or any other harm resulting from the use of this software.
- **As-Is:** This software is provided "as-is" without any warranties or guarantees of any kind.
- **Use at Your Own Risk:** By using LSCamoflash, you acknowledge that you understand the risks involved and accept full responsibility for any consequences.
- **Hardware Risk:** Flashing firmware may permanently damage your device if something goes wrong. Ensure you have a backup and understand the process before proceeding.
- **Data Loss:** Always backup important data before using this firmware. We are not responsible for data loss.
- **Authorized Use Only:** This software may only be used on devices that you own or have explicit permission to modify. Unauthorized access to computer systems is illegal. Any attempt to use this firmware to gain unauthorized access to or control over devices that you do not own or have permission to modify is strictly prohibited and may violate applicable laws including the Computer Fraud and Abuse Act and similar regulations in your jurisdiction.
- **No Malicious Use:** This project shall not be used for creating malware, spyware, or any other malicious software intended to compromise device security, intercept communications, or harm others.
- **Legal Responsibility:** Users are solely responsible for ensuring their use of LSCamoflash complies with all applicable laws and regulations in their jurisdiction. The authors disclaim all liability for any illegal use or consequences thereof.

Please refer to the [LICENSE files](LICENSE.md) for full legal details.

## Installation

1. **Download the source code:**

   ```bash
   git clone https://github.com/Bunkerschild/LSCamoflash.git
   cd LSCamoflash/SOURCE
   ```

2. **Start the build process:**

   - To download and compile all components:

     ```bash
     make
     ```

     or

     ```bash
     make all
     ```

   - After a successful build, the content for the SD card will be located in the `build/` directory, including the installation scripts `install.ps1` (for Windows) and `install.sh` (for Unix/Linux).

3. **Create a release:**

   - To create a compressed tarball of the `build/` directory:

     ```bash
     make release
     ```

     This generates a gz-compressed tar file for distribution.

## Setting up the Build Environment

The following packages are required for the build process:

- `build-essential`: Basic compiler tools
- `flex`: Scanner generator
- `bison`: Parser generator
- `gsoap`: SOAP code generator (required for `onvif_srvd`)
- `binutils`: Collection of binary utilities
- `make`: Build automation tool
- `automake`: Tool for generating Makefiles
- `autoconf`: Tool for configuring software packages

**Note:** Ensure all dependencies are installed to ensure a smooth build process.

## Available Tools

After installation, the following tools are available:

- `busybox`: Collection of Unix utilities
- `chpasswd`: Password change tool
- `curl`: Data transfer tool
- `joe` (incl. `jmacs`, `jpico`, `jstar`, `rjoe`): Text editor
- `mosquitto` (incl. `mosquitto_pub`, `mosquitto_sub`, `mosquitto_passwd`, `mosquitto_rr`): MQTT broker and clients
- `motor`: CLI PTZ-Controller
- `msmtp` and `msmtpd`: SMTP client and server
- `openssl`: SSL/TLS toolkit
- `pcap-config`: Tool for querying libpcap configuration details
- `sqlcipher`: Encrypted SQLite database
- `sqlite3`: SQLite database client
- `strace` (incl. `strace-log-merge`): System call monitoring
- `tcpdump`: Network packet analyzer
- `upnpc`: UPnP client
- `onvif_srvd`: ONVIF device server

## Password Management

To change the password for various services (e.g., the HTTP server), use `chpasswd`. This ensures that password changes are persistent and remain after a reboot.

**Note:** The `passwd` tool from `busybox` only changes the password temporarily and does not work for all services.

## Web Server Features

The integrated web server offers the following features:

- **Streaming:** Provides an HLS stream via a TUYA Cloud API key and allows retrieval of RTSP and FLV stream URLs.
- **Camera Control:** Adjust camera settings and restart the camera via the HTTP service on port 8080 (configurable).
- **Service Management:** Enable or disable services such as FTP or `crond` via a central configuration file.

## Update Mechanism

An integrated update script keeps the camera up to date. Features of the update mechanism:

- **Configurable update server:** The server can be set in the configuration.
- **Flexible update strategies:** Updates can be provided globally, by groups, or individually per camera ID.
- **Version checking:** Before an update, the camera's current version is checked against the server to allow incremental updates.

## SD Card Partitioning

The SD card is partitioned so that formatting via the TUYA app does not remove the hack:

- **Multiple partitions:** The first partition (`mmcblk0p1`) is formatted, while the second partition (`mmcblk0p2`) contains the important data.
- **Automatic recovery:** A script (`services.sh`) checks the state of the partitions every 30 seconds and ensures that necessary files are automatically restored after formatting.

**Note:** Avoid restarting the camera within 1 minute after formatting to ensure automatic recovery. If this happens, the required files can be manually copied to the first partition.

## Planned Improvements

- **Implementation of checksums:** Future versions will use checksums for external downloads to ensure file integrity.
- **Review of `strace-log-merge`:** This tool is currently only used for internal purposes and may be removed in later versions.
- **Reducing monitoring intervals:** Currently, `services.sh` checks the state of the partitions every 30 seconds. Future versions aim to shorten this interval for faster recovery.





