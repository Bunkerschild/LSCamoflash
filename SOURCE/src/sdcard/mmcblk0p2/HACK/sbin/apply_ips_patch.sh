#!/bin/sh
patch="$1"
src="$2"
dst="$3"

exiterr() {
    echo "ERROR: $1"
    exit $2
}

[ "$patch" = "" ] && exiterr "Missing patch file" 1
[ -f "$patch" ] || exiterr "Patch file not found" 2

[ "$src" = "" ] && exiterr "Missing source file" 1
[ -f "$src" ] || exiterr "Source file not found" 2

[ "$dst" = "" ] && exiterr "Missing destination file" 1
[ -f "$dst" ] && exiterr "Destination file exists" 3

# Originaldatei kopieren
cp "$src" "$dst" || exiterr "Failed to copy source file" 4

# IPS-Datei entpacken
cp $patch /tmp/patch.ips.gz && gunzip /tmp/patch.ips.gz || exiterr "Unable to gunzip patch" 5

# IPS-Datei als Hex-Dump einlesen
hexdump -ve '1/1 "%02X"' "/tmp/patch.ips" > /tmp/patch.hex

# "PATCH"-Header entfernen (10 Zeichen = 5 Bytes)
sed -i 's/^5041544348//' /tmp/patch.hex

# EOF "454F46" suchen und abschneiden
sed -i 's/454F46.*//' /tmp/patch.hex

# Patch-Blöcke verarbeiten
while [ -s /tmp/patch.hex ]; do
    # Offset (3 Bytes, Big Endian)
    offset_hex=$(head -c 6 /tmp/patch.hex)
    offset=$((0x$offset_hex))
    sed -i '1s/^......//' /tmp/patch.hex

    # Länge (2 Bytes, Big Endian)
    length_hex=$(head -c 4 /tmp/patch.hex)
    length=$((0x$length_hex))
    sed -i '1s/^....//' /tmp/patch.hex

    if [ "$length" -eq 0 ]; then
        # RLE-Block (Länge 2 Bytes, Wiederholtes Byte 1 Byte)
        rle_size_hex=$(head -c 4 /tmp/patch.hex)
        rle_size=$((0x$rle_size_hex))
        sed -i '1s/^....//' /tmp/patch.hex

        rle_value=$(head -c 2 /tmp/patch.hex)
        sed -i '1s/^..//' /tmp/patch.hex

        # RLE-Werte schreiben
        printf "$(printf '\\x%s' "$rle_value")%.0s" $(seq 1 "$rle_size") | dd of="$dst" bs=1 seek="$offset" count="$rle_size" conv=notrunc status=none

    else
        # Normaler Block
        patch_data=$(head -c "$((length * 2))" /tmp/patch.hex)
        sed -i "1s/^$(printf '%0.s.' $(seq 1 $((length * 2))))//" /tmp/patch.hex

        # Bytes schreiben
        printf "$(echo "$patch_data" | sed 's/\(..\)/\\x\1/g')" | dd of="$dst" bs=1 seek="$offset" count="$length" conv=notrunc status=none
    fi
done

echo "Patch erfolgreich angewendet: $dst"
rm /tmp/patch.hex
rm /tmp/patch.ips
