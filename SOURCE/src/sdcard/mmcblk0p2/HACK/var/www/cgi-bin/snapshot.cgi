#!/bin/sh

root="/tmp/sd/HACK"

NO_SESSION_REQUIRED="1"
FORCE_PRIVATE_IP="1"

. ./common.cgi

[ -f "$sd_etc/onvif.token" ] || send_error 404 "Not found" "Missing onvif token file"
onvif_token=`cat $sd_etc/onvif.token 2>/dev/null`
TOKEN=`parse_keyval '&' "$QUERY_STRING" token`
[ "$TOKEN" = "$onvif_token" -o "$AUTHORIZED" = "1" ] || send_error 401 "Unauthorized" "Invalid onvif token"

SNAPSHOT=`parse_keyval '&' "$QUERY_STRING" snapshot`
if [ "$SNAPSHOT" = "update" ]; then
	snapdone=0
	$sd_sbin/snapshot.sh && snapdone=1
	
	send_header application/json
	send_json success=$snapdone
	exit
fi

SNAP_HUMAN_TMP="/tmp/snap_human.jpg"
SNAP_HUMAN_SD="$sd_www/images/snap_human.jpg"
SNAPSHOT_SD="$sd_www/images/snapshot_sd.jpg"
SNAPSHOT_FILE="$sd_www/images/snapshot.jpg"
DISP_FILENAME="snapshot_$(date +%s).jpg"

if [ -f "$SNAP_HUMAN_TMP" ]; then
	[ -f "$SNAP_HUMAN_SD" ] && ( find "$SNAP_HUMAN_TMP" -newer "$SNAP_HUMAN_SD" >/dev/null 2>&1 && cp -f "$SNAP_HUMAN_TMP" "$SNAP_HUMAN_SD" >/dev/null 2>&1 ) || cp -f "$SNAP_HUMAN_TMP" "$SNAP_HUMAN_SD" >/dev/null 2>&1
	[ -f "$SNAPSHOT_SD" ] || cp -f "$SNAP_HUMAN_TMP" "$SNAPSHOT_SD" >/dev/null 2>&1
	[ -f "$SNAPSHOT_FILE" ] || cp -f "$SNAP_HUMAN_TMP" "$SNAPSHOT_FILE" >/dev/null 2>&1
fi

if [ -f "$SNAPSHOT_SD" ]; then
	SNAPSRC=""
	find "$SNAPSHOT_SD" -newer "$SNAP_HUMAN_SD" >/dev/null 2>&1 && SNAPSRC="$SNAPSHOT_SD"
	[ "$SNAPSRC" = "" -a -f "$SNAP_HUMAN_SD" ] && SNAPSRC="$SNAP_HUMAN_SD"
	
	if [ "$SNAPSRC" != "" ]; then
		find "$SNAPSRC" -newer "$SNAPSHOT_FILE" >/dev/null 2>&1 && cp -f "$SNAPSRC" "$SNAPSHOT_FILE" >/dev/null 2>&1
	fi
else
	[ -f "$SNAP_HUMAN_SD" ] && find "$SNAP_HUMAN_SD" -newer "$SNAPSHOT_FILE" >/dev/null 2>&1 && cp -f "$SNAP_HUMAN_SD" "$SNAPSHOT_FILE" >/dev/null 2>&1
fi

[ -f "$SNAPSHOT_FILE" ] || send_error 404 "Not found" "Snapshot image not found"
FILESIZE=`stat -c %s "$SNAPSHOT_FILE"`
[ "$FILESIZE" = "0" -o "$FILESIZE" = "" ] && send_error 500 "Internal server error" "Snapshot size must be non-zero"

send_header image/jpeg $FILESIZE $DISP_FILENAME
cat "$SNAPSHOT_FILE"
