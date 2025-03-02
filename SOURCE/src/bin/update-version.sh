#!/bin/bash

# Datei, in der die Versionsnummer gespeichert wird
VERSION_FILE="version.txt"

# Falls die Datei nicht existiert, eine Standardversion anlegen
if [[ ! -f $VERSION_FILE ]]; then
    echo "1.00.0001" > $VERSION_FILE
fi

# Aktuelle Version einlesen
VERSION=$(cat $VERSION_FILE)

# Version in ihre Bestandteile zerlegen
MAJOR=$(echo $VERSION | cut -d'.' -f1)
MINOR=$(echo $VERSION | cut -d'.' -f2)
REVISION=$(echo $VERSION | cut -d'.' -f3)

# Sicherstellen, dass REVISION numerisch ist
REVISION=$(echo "$REVISION" | sed 's/^0*//')  # Führende Nullen entfernen
if [[ -z "$REVISION" ]]; then
    REVISION=0
fi

# Argumentenverarbeitung
if [[ "$1" == "--major" ]]; then
    ((MAJOR++))
    MINOR=00
    REVISION=0001
elif [[ "$1" == "--minor" ]]; then
    ((MINOR++))
    REVISION=0001
elif [[ "$1" == "--revision" ]]; then
    ((REVISION++))
fi

# Revision auf mindestens 4 Stellen auffüllen
REVISION=$(printf "%04d" "$REVISION")

# Neue Versionsnummer zusammensetzen
NEW_VERSION="$MAJOR.$(printf "%02d" "$MINOR").$REVISION"

# Neue Version in die Datei schreiben
echo "$NEW_VERSION" > $VERSION_FILE

# Neue Version ausgeben
echo "Neue Version: $NEW_VERSION"
