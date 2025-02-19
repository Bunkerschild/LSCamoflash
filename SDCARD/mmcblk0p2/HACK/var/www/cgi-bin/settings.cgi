#!/bin/sh

root="/tmp/sd/HACK"
config_file="/etc/config/_ht_sw_settings.ini"
temp_file="/tmp/_ht_sw_settings.tmp"
lock_file="/tmp/_ht_sw_settings.lock"
backup_file="/tmp/_ht_sw_settings.bak"

busybox_firmware="/bin/busybox"
busybox_hack="$root/bin/busybox"

. $root/etc/hack.conf
. $root/etc/hack_custom.conf
. $root/etc/commands.conf

decode_url() {
    local url_encoded="$1"
    printf '%b\n' "$(echo -n "$url_encoded" | sed -E 's/%([0-9A-Fa-f]{2})/\\x\1/g')"
}

echo -e "Content-type: application/json\r"
echo -e "\r"

# Parameter aus der Anfrage extrahieren
query_string="$QUERY_STRING"
save=$(echo "$query_string" | sed -n 's/.*save=\([^&]*\).*/\1/p')
key=$(echo "$query_string" | sed -n 's/.*key=\([^&]*\).*/\1/p')
val=$(echo "$query_string" | sed -n 's/.*val=\([^&]*\).*/\1/p')

# Falls kein Key angegeben wurde ??? Ganze Config als JSON ausgeben
if [ -z "$key" -a -z "$save"]; then
    OLDIFS=$IFS
    IFS=$'\n'
    json=""

    while IFS= read -r line; do
        echo "$line" | grep -Eq "^\[.*\]$|^$" && continue

        config_key=$(echo "$line" | awk -F '=' '{gsub(/[ \t]+/, "", $1); print $1}')
        config_val=$(echo "$line" | awk -F '=' '{gsub(/^[ \t]+|[ \t]+$/, "", $2); print $2}')

        [ -z "$config_key" ] || [ -z "$config_val" ] && continue

        comma=","
        [ -z "$json" ] && comma=""

        json="${json}${comma}\"$config_key\":\"$config_val\""
    done < "$config_file"

    IFS=$OLDIFS
    echo "{$json}"
    exit 0
fi

# Falls nur ein einzelner Key abgefragt wird
if [ -n "$key" ] && [ -z "$val" ]; then
    config_val=$(grep -E "^[ \t]*$key[ \t]*=" "$config_file" | awk -F '=' '{gsub(/^[ \t]+|[ \t]+$/, "", $2); print $2}')

    if [ -z "$config_val" ]; then
        echo "{\"error\":\"Key '$key' not found\"}"
        exit 1
    fi

    echo "{\"$key\":\"$config_val\"}"
    exit 0
fi

# Falls mehrere Werte ??bergeben werden
if [ -n "$save" ]; then
    [ ! -f $lock_file ] && echo "$$" > $lock_file
    
    lockpid=`cat $lockfile`
    lockround=0
    
    while [ -f $lockfile ]; do
    	sleep 1
    	lockround=$(($lockround + 1))
    	if [ "$lockround" -gt 60 ]; then
	        echo "{\"error\":\"Lockfile timeout\"}"
    		exit 1
    	fi
    	
    	haspid=`ps awx | grep $lockpid | grep settings.cgi`
    	
    	if [ "$haspid" = "" ]; then
    		rm -f $lock_file
    		break
    	fi
    done
    
    echo "$$" > $lock_file
    
    OLDIFS=$IFS
    IFS=";"
    
    have=0
    wrote=0
        
    for keyval in $(decode_url "$save"); do
    	    echo $keyval | grep -q "=" || continue
    	    
    	    key=`echo $keyval | cut -d "=" -f1`
    	    val=`echo $keyval | cut -d "=" -f2`
    	    
    	    have=$(($have + 1))
    	    
	    # Pr??fen, ob der Schl??ssel existiert
	    if ! grep -qE "^[ \t]*$key[ \t]*=" "$config_file"; then
		continue
	    fi
		
	    # **Fix: temp_file wird initialisiert, um ??berlauf zu verhindern**
    	    > "$temp_file"

	    updated=0
	    while IFS= read -r line; do
	        if echo "$line" | grep -qE "^[ \t]*$key[ \t]*="; then
	            # Behalte urspr??ngliche Anzahl an Leerzeichen/Tabs vor dem `=`
	            orig_format=$(echo "$line" | grep -oE "^[ \t]*$key[ \t]*=")
	            echo "$orig_format $val" >> "$temp_file"
	            updated=1
	        else
	            echo "$line" >> "$temp_file"
	        fi
	    done < "$config_file"
	    
	    # Falls der Key nicht aktualisiert wurde
	    if [ "$updated" -eq 0 ]; then
	    	rm -f $temp_file
	    	continue
	    fi
	    
	    # **Datei ersetzen ohne `mv`-Probleme**
	    mv -f "$temp_file" "$config_file"
	    sync  # Warten, bis ??nderungen auf die Disk geschrieben wurden
	
	    # **Sicherstellen, dass die ??nderung ??bernommen wurde**
	    new_value=$(grep -E "^[ \t]*$key[ \t]*=" "$config_file" | awk -F '=' '{gsub(/^[ \t]+|[ \t]+$/, "", $2); print $2}')
	
	    if [ "$new_value" = "$val" ]; then
	    	wrote=$(($wrote + 1))
	    fi
    done
    
    echo "{\"success\":\"Batch job $wrote of $have succeeded\"}"
    rm -f $lock_file
    
    IFS=$OLDIFS
    exit 0
fi

# Falls ein Key-Wert-Paar gesetzt wird
if [ -n "$key" ] && [ -n "$val" ]; then
    [ ! -f $lock_file ] && echo "$$" > $lock_file
    
    lockpid=`cat $lockfile`
    lockround=0
    
    while [ -f $lockfile ]; do
    	sleep 1
    	lockround=$(($lockround + 1))
    	if [ "$lockround" -gt 60 ]; then
	        echo "{\"error\":\"Lockfile timeout\"}"
    		exit 1
    	fi
    	
    	haspid=`ps awx | grep $lockpid | grep settings.cgi`
    	
    	if [ "$haspid" = "" ]; then
    		rm -f $lock_file
    		break
    	fi
    done
    
    echo "$$" > $lock_file

    # Pr??fen, ob der Schl??ssel existiert
    if ! grep -qE "^[ \t]*$key[ \t]*=" "$config_file"; then
        echo "{\"error\":\"Key '$key' not found\"}"
        rm -f $lock_file
        exit 1
    fi

    # **Fix: temp_file wird initialisiert, um ??berlauf zu verhindern**
    > "$temp_file"

    updated=0
    while IFS= read -r line; do
        if echo "$line" | grep -qE "^[ \t]*$key[ \t]*="; then
            # Behalte urspr??ngliche Anzahl an Leerzeichen/Tabs vor dem `=`
            orig_format=$(echo "$line" | grep -oE "^[ \t]*$key[ \t]*=")
            echo "$orig_format $val" >> "$temp_file"
            updated=1
        else
            echo "$line" >> "$temp_file"
        fi
    done < "$config_file"

    # Falls der Key nicht aktualisiert wurde
    if [ "$updated" -eq 0 ]; then
        echo "{\"error\":\"Value update failed for '$key'\"}"
        rm -f "$temp_file"
        rm -f $lock_file
        exit 1
    fi
    
    # **Datei ersetzen ohne `mv`-Probleme**
    mv -f "$temp_file" "$config_file"
    sync  # Warten, bis ??nderungen auf die Disk geschrieben wurden

    # **Sicherstellen, dass die ??nderung ??bernommen wurde**
    new_value=$(grep -E "^[ \t]*$key[ \t]*=" "$config_file" | awk -F '=' '{gsub(/^[ \t]+|[ \t]+$/, "", $2); print $2}')

    if [ "$new_value" != "$val" ]; then
        echo "{\"error\":\"Value update failed for '$key'\"}"
        rm -f $lock_file
        exit 1
    fi

    echo "{\"success\":\"Key '$key' set to '$val'\"}"
    rm -f $lock_file
    exit 0
fi

# Falls ein ung??ltiges Format genutzt wurde
echo '{"error":"Invalid request"}'
exit 1
