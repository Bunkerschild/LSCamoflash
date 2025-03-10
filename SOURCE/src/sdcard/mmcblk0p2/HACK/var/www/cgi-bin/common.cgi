#!/bin/sh

[ -z "$root" ] && exit 1

busybox_firmware="/bin/busybox"
busybox_hack="$root/bin/busybox"

. $root/etc/hack.conf
. $root/etc/hack_custom.conf
. $root/etc/commands.conf

DB_SCRIPT="/tmp/sd/HACK/sbin/webui_db.sh"

IPADDRESS="${REMOTE_ADDR:-127.0.0.1}"

parse_keyval() {
	KEYVALS="$2"
	PARAM="$3"
	IFS="$1"
	[ -z "$KEYVALS" ] || return 1
	[ -z "$PARAM" ] || return 1
	[ -z "$IFS" ] || return 1
	for keyval in $KEYVALS; do
		key=$(echo "$keyval" | sed 's/=/ /g' | awk '{print $1}')
		value=$(echo "$keyval" | sed 's/=/ /g' | awk '{print $2}')
		value=$(printf '%b' "${value//+/ }")
		
		if [ "$key" = "$PARAM" ]; then
			echo $value
			return 0
		fi
	done
	return 1
}

is_private_ip() {
    case "$1" in
        10.*|192.168.*|172.1[6-9].*|172.2[0-9].*|172.3[0-1].*|127.*|::1|fd*)
            return 0 ;;
        *)
            return 1 ;;
    esac
}

send_error() {
	errno="$1"
	errstr="$2"
	errdesc="$3"
	
	[ -n $errno ] && errno="404" && errstr="Not found"
	[ -n $errdesc ] && errdesc="error"
	
	echo -e "Status: $errno $errstr\r"
	echo -e "Content-Type: text/plain\r\n\r"
	echo "$errdesc"
	exit 1
}

send_header() {
	content_type="$1"
	content_length="$2"
	filename="$3"
	
	[ "$filename" != "" ] && echo -e "Content-Disposition: attachment; filename=$filename\r"
	[ "$content_length" != "" ] && echo -e "Content-Length: $content_length\r"
	echo -e "Content-Type: $content_type\r\n\r"
}

send_json() {
	json=""
	for keyval in $*; do
		key=$(echo "$keyval" | sed 's/=/ /g' | awk '{print $1}')
		value=$(echo "$keyval" | sed 's/=/ /g' | awk '{print $2}')
		value=$(printf '%s' "$value" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' -e 's/\n/\\n/g' -e 's/\t/\\t/g')
		[ "$json" = "" ] || json="${json},"
		json="${json}\"$key\":\"$value\""
	done
	echo "{$json}"
}

SESSIONID=`parse_keyval '; ' "$HTTP_COOKIE" sessionid`
$DB_SCRIPT -o cleanup-sessions >/dev/null 2>&1

if [ "$NO_SESSION_REQUIRED" != "1" ]; then
	sessionData=`$DB_SCRIPT -o get-session -s $SESSIONID 2>/dev/null`

	[ "$sessionData" = "" ] && send_error 401 Unauthorized "Missing session"

	sessionUID=`echo "$sessionData" | cut -d "|" -f1`
	sessionIP=`echo "$sessionData" | cut -d "|" -f5`

	if [ "$sessionIP" != "$IPADDRESS" ]; then
		$DB_SCRIPT -o logout -s $SESSIONID >/dev/null 2>&1
		send_error 403 Forbidden "IP address change detected"
	fi
fi

if [ "$FORCE_PRIVATE_IP" = "1" ]; then
	is_private_ip $IPADDRESS || send_error 403 Forbidden "Not a private ip address"
fi
