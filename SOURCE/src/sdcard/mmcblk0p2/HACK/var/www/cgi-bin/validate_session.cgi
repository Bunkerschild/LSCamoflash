#!/bin/sh

root="/tmp/sd/HACK/"

busybox_firmware="/bin/busybox"
busybox_hack="$root/bin/busybox"

. $root/etc/hack.conf
. $root/etc/hack_custom.conf
. $root/etc/commands.conf

DB_SCRIPT="/tmp/sd/HACK/sbin/webui_db.sh"

IPADDRESS="${REMOTE_ADDR:-127.0.0.1}"

parse_cookies() {
    IFS='; '
    for keyval in $HTTP_COOKIE; do
        key=$(echo "$keyval" | sed 's/=/ /g' | awk '{print $1}')
        value=$(echo "$keyval" | sed 's/=/ /g' | awk '{print $2}')
        value=$(printf '%b' "${value//+/ }")

        case "$key" in
            sessionid) SESSIONID="$value" ;;
        esac
    done
}

parse_cookies
$DB_SCRIPT -o cleanup-sessions >/dev/null 2>&1

sessionData=`$DB_SCRIPT -o get-session -s $SESSIONID 2>/dev/null`

if [ "$sessionData" = "" ]; then
	echo -e "Status: 401 Unauthorized\r"
	echo -e "Content-Type: text/plain\r\n\r"
	echo "Missing session data"
	exit 1
fi

sessionUID=`echo "$sessionData" | cut -d "|" -f1`
sessionIP=`echo "$sessionData" | cut -d "|" -f5`

if [ "$sessionIP" != "$IPADDRESS" ]; then
	$DB_SCRIPT -o logout -s $SESSIONID >/dev/null 2>&1
	echo -e "Status: 403 Forbidden\r"
	echo -e "Content-Type: text/plain\r\n\r"
	echo "IP address changed"
	exit 2
fi

