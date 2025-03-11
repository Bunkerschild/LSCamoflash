#!/bin/sh

root="/tmp/sd/HACK"

. ./common.cgi

lockfile="/tmp/settings.lock"

settings_template="$sd_config/_ht_sw_config.tmpl"
settings_live="$sys_config/_ht_sw_settings.ini"
settings_persist="$sd_config/_ht_sw_settings.ini"
settings_tmp="$sd_config/_ht_sw_settings.tmp"
settings_prep="$sd_config/_ht_sw_settings.prep"

POST_DATA=""

if [ "$REQUEST_METHOD" = "POST" -a -n "$CONTENT_LENGTH" ]; then
	if [ -f "$lockfile" ]; then
		send_header application/json
		send_json status=locked
		exit
	fi

	touch $lockfile >/dev/null 2>&1
	read -r -n "$CONTENT_LENGTH" POST_DATA
	echo "[config]" > $settings_tmp
fi

convert_key() {
    key="$1"

    key=$(echo "$key" | sed -E 's/^(bool_|enum_|string_|str_|int_|integer_)//')

    key=$(echo "$key" | awk -F'_' '{
        for (i=1; i<=NF; i++) {
            if (i == 1)
                printf "%s", $i; 
            else 
                printf "%s%s", toupper(substr($i,1,1)), substr($i,2);
        }
        print "";
    }')

    echo "$key"
}

send_header application/json

json="{\"ts\":\"$(date +%s)\""
keylist="{"
valuelist="{"

for key in `cat $settings_template | grep -v "^\[config\]" | grep -v "^#" | grep "=" | awk '{print $1}'`; do
	[ "$key" = "bool_has_config_wifi" ] && continue
	
	if [ "$REQUEST_METHOD" = "POST" -a -n "$POST_DATA" ]; then
		value=`parse_keyval '&' $POST_DATA $key`
		echo "$key = $value" >> $settings_tmp
		continue
	fi
	
	value=`cat $settings_live | grep "^$key" | awk '{print $3}'`
	[ -z $value ] && value=`cat $settings_persist | grep "^$key" | awk '{print $3}'`
	[ -z $value ] && value=`cat $settings_template | grep "^$key" | awk '{print $3}'`
	nkey="$(convert_key $key)"
	keycomma=","
	valuecomma=","
	[ "$keylist" = "{" ] && keycomma=""
	[ "$valuelist" = "{" ] && valuecomma=""	
	keylist="${keylist}${keycomma}\"$key\":\"$nkey\""
	valuelist="${valuelist}${valuecomma}\"$nkey\":\"$value\""
done

if [ "$REQUEST_METHOD" = "POST" -a -n "$POST_DATA" ]; then
	fixed_length=30
	{
	  echo -e "\n[config]"
	  sed '/^\[/d' "$settings_tmp" | while IFS='=' read -r key value; do
	    key_trimmed=$(echo "$key" | sed 's/[[:space:]]*$//')
	    val_trimmed=$(echo "$value" | sed 's/^[[:space:]]*//')
	    printf "%-${fixed_length}s = %s\n" "$key_trimmed" "$val_trimmed"
	  done
	  echo ""
	} > "$settings_prep"
	rm -f $lockfile >/dev/null 2>&1
	send_json status=saved
else
	json="${json},\"keylist\":$keylist},\"valuelist\":$valuelist}}"

	echo $json
fi
