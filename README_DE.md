# LSCamoflash

LSCamoflash ist ein modifiziertes Firmware-Paket für bestimmte IP-Kameras, das zusätzliche Funktionen und Verbesserungen bietet.

![Build Status](https://github.com/Bunkerschild/LSCamoflash/actions/workflows/makefile.yml/badge.svg)
![CodeQL](https://github.com/Bunkerschild/LSCamoflash/actions/workflows/codeql.yml/badge.svg)

## Inhaltsverzeichnis

- [Installation](#installation)
- [Build-Umgebung einrichten](#build-umgebung-einrichten)
- [Verfügbare Tools](#verfügbare-tools)
- [Passwortverwaltung](#passwortverwaltung)
- [Webserver-Funktionen](#webserver-funktionen)
- [Update-Mechanismus](#update-mechanismus)
- [SD-Karten-Partitionierung](#sd-karten-partitionierung)
- [Geplante Verbesserungen](#geplante-verbesserungen)

## Installation

1. **Quellcode herunterladen:**

   ```bash
   git clone https://github.com/Bunkerschild/LSCamoflash.git
   cd LSCamoflash/SOURCE
   ```

2. **Build-Prozess starten:**

   - Um alle Komponenten herunterzuladen und zu kompilieren:

     ```bash
     make
     ```

     oder

     ```bash
     make all
     ```

   - Nach erfolgreichem Build befindet sich der Inhalt für die SD-Karte im `build/`-Verzeichnis, einschließlich der Installationsskripte `install.ps1` (für Windows) und `install.sh` (für Unix/Linux).

3. **Release erstellen:**

   - Um ein komprimiertes Tarball des `build/`-Verzeichnisses zu erstellen:

     ```bash
     make release
     ```

     Dies erzeugt eine gz-komprimierte Tar-Datei für die Verteilung.

## Build-Umgebung einrichten

Für den Build-Prozess werden folgende Pakete benötigt:

- `build-essential`: Grundlegende Compiler-Werkzeuge
- `flex`: Scanner-Generator
- `bison`: Parser-Generator
- `gsoap`: SOAP-Code-Generator (erforderlich für `onvif_srvd`)
- `binutils`: Sammlung von Binärwerkzeugen
- `make`: Build-Automatisierungstool
- `automake`: Tool zur Generierung von Makefiles
- `autoconf`: Tool zur Konfiguration von Softwarepaketen

**Hinweis:** Stellen Sie sicher, dass alle Abhängigkeiten installiert sind, um einen reibungslosen Build zu gewährleisten.

## Verfügbare Tools

Nach der Installation stehen folgende Tools zur Verfügung:

- `busybox`: Sammlung von Unix-Werkzeugen
- `chpasswd`: Passwortänderungstool
- `curl`: Datenübertragungswerkzeug
- `joe` (inkl. `jmacs`, `jpico`, `jstar`, `rjoe`): Texteditor
- `mosquitto` (inkl. `mosquitto_pub`, `mosquitto_sub`, `mosquitto_passwd`, `mosquitto_rr`): MQTT-Broker und -Clients
- `motor`: Terminal-basierter Dateimanager
- `msmtp` und `msmtpd`: SMTP-Client und -Server
- `openssl`: Toolkit für SSL/TLS
- `pcap-config`: Werkzeug zur Abfrage von libpcap-Konfigurationsdetails
- `sqlcipher`: Verschlüsselte SQLite-Datenbank
- `sqlite3`: SQLite-Datenbank-Client
- `strace` (inkl. `strace-log-merge`): Systemaufruf-Überwachung
- `tcpdump`: Netzwerkpaket-Analysator
- `upnpc`: UPnP-Client
- `onvif_srvd`: ONVIF-Geräteserver

## Passwortverwaltung

Um das Passwort für verschiedene Dienste (z.B. HTTP-Server) zu ändern, verwenden Sie `chpasswd`. Dies stellt sicher, dass die Passwortänderung persistent ist und nach einem Neustart erhalten bleibt.

**Hinweis:** Das `passwd`-Tool von `busybox` ändert das Passwort nur temporär und ist nicht für alle Dienste wirksam.

## Webserver-Funktionen

Der integrierte Webserver bietet folgende Funktionen:

- **Streaming:** Bereitstellung eines HLS-Streams über einen TUYA-Cloud API-Schlüssel sowie Abruf von RTSP- und FLV-Stream-URLs.
- **Kamerasteuerung:** Anpassung von Kameraeinstellungen und Neustart der Kamera über den HTTP-Dienst auf Port 8080 (konfigurierbar).
- **Dienstverwaltung:** Aktivierung oder Deaktivierung von Diensten wie FTP oder `crond` über eine zentrale Konfigurationsdatei.

## Update-Mechanismus

Ein integriertes Update-Skript hält die Kamera auf dem neuesten Stand. Funktionen des Update-Mechanismus:

- **Anpassbarer Update-Server:** Der Server kann in der Konfiguration festgelegt werden.
- **Flexible Update-Strategien:** Updates können global, gruppenbasiert oder individuell pro Kamera-ID bereitgestellt werden.
- **Versionsprüfung:** Vor einem Update wird die aktuelle Versionsnummer der Kamera mit dem Server abgeglichen, um inkrementelle Updates zu ermöglichen.

## SD-Karten-Partitionierung

Die SD-Karte ist so partitioniert, dass eine Formatierung über die TUYA-App den Hack nicht entfernt:

- **Mehrere Partitionen:** Die erste Partition (`mmcblk0p1`) wird formatiert, während die zweite Partition (`mmcblk0p2`) die wichtigen Daten enthält.
- **Automatische Wiederherstellung:** Ein Skript (`services.sh`) überprüft alle 30 Sekunden den Zustand der Partitionen und stellt sicher, dass notwendige Dateien nach einer Formatierung automatisch wiederhergestellt werden.

**Hinweis:** Vermeiden Sie es, die Kamera innerhalb von 1 Minute nach einer Formatierung neu zu starten, um die automatische Wiederherstellung zu gewährleisten. Sollte dies dennoch geschehen, können die erforderlichen Dateien manuell auf die erste Partition kopiert werden.

## Geplante Verbesserungen

- **Implementierung von Checksummen:** In zukünftigen Versionen werden für externe Downloads Checksummen verwendet, um die Integrität der Dateien sicherzustellen.
- **Überarbeitung von `strace-log-merge`:** Dieses Tool wird aktuell nur für interne Zwecke genutzt und könnte in späteren Versionen entfernt werden.
- **Verkürzung des Überwachungsintervalls:** Derzeit überprüft `services.sh` alle 30 Sekunden den Zustand der Partitionen. Es ist geplant, dieses Intervall in zukünftigen Versionen zu verkürzen, um eine schnellere Wiederherstellung zu ermöglichen.
