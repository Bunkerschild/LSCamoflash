#!/bin/sh

root="/tmp/sd/HACK"

. ./common.cgi

settings_template="$sd_config/_ht_sw_config.tmpl"
settings_live="$sys_config/_ht_sw_settings.ini"
settings_persist="$sd_config/_ht_sw_settings.ini"

convert_key() {
    key="$1"

    key=$(echo "$key" | sed -E 's/^(bool_|enum_|string_|str_|int_)//')

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

for key in `cat $settings_template | grep -v "^[config]" | grep -v "^#" | grep "=" | awk '{print $1}'`; do
	[ "$key" = "bool_has_config_wifi" ] && continue
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

json="${json},\"keylist\":$keylist},\"valuelist\":$valuelist}}"

echo $json
