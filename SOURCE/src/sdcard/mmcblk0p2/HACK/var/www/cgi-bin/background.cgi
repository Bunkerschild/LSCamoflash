#!/bin/sh

root="/tmp/sd/HACK"
NO_SESSION_REQUIRED="1"
FORCE_PRIVATE_IP="1"
. ./common.cgi

SNAP_HUMAN_TMP="/tmp/snap_human.jpg"
SNAP_HUMAN_SD="$sd_www/images/snap_human.jpg"
SNAPSHOT_SD="$sd_www/images/snapshot_sd.jpg"
BACKGROUND_SD="$sd_www/images/background_sd.jpg"
BACKGROUND_DEFAULT="$sd_www/images/background.jpg"
DISP_FILENAME="background_$(date +%s).jpg" 

if [ -f "$SNAP_HUMAN_TMP" ]; then
        [ -f "$SNAP_HUMAN_SD" ] && ( find "$SNAP_HUMAN_TMP" -newer "$SNAP_HUMAN_SD" >/dev/null 2>&1 && cp -f "$SNAP_HUMAN_TMP" "$SNAP_HUMAN_SD" >/dev/null 2>&1 ) || cp -f "$SNAP_HUMAN_TMP" "$SNAP_HUMAN_SD" >/dev/null 2>&1
        [ -f "$SNAPSHOT_SD" ] || cp -f "$SNAP_HUMAN_TMP" "$SNAPSHOT_SD" >/dev/null 2>&1
        [ -f "$BACKGROUND_SD" ] || cp -f "$SNAP_HUMAN_TMP" "$BACKGROUND_SD" >/dev/null 2>&1
else
	[ -f "$BACKGROUND_SD" ] || cp -f "$BACKGROUND_DEFAULT" "$BACKGROUND_SD" > /dev/null 2>&1 
fi 

if [ -f "$SNAPSHOT_SD" ]; then
	BGSRC=""
	find "$SNAPSHOT_SD" -newer "$SNAP_HUMAN_SD" >/dev/null 2>&1 && BGSRC="$SNAPSHOT_SD"
	[ "$BGSRC" = "" -a -f "$SNAP_HUMAN_SD" ] && BGSRC="$SNAP_HUMAN_SD"
	
	if [ "$BGSRC" != "" ]; then
		find "$BGSRC" -newer "$BACKGROUND_SD" >/dev/null 2>&1 && cp -f "$BGSRC" "$BACKGROUND_SD" >/dev/null 2>&1
	fi
else
	[ -f "$SNAP_HUMAN_SD" ] && find "$SNAP_HUMAN_SD" -newer "$BACKGROUND_SD" >/dev/null 2>&1 && cp -f "$SNAP_HUMAN_SD" "$BACKGROUND_SD" >/dev/null 2>&1
fi

[ -f "$BACKGROUND_SD" ] || send_error 404 "Not found" "Background image not found"
FILESIZE=`stat -c %s "$BACKGROUND_SD"`
[ "$FILESIZE" = "0" -o "$FILESIZE" = "" ] && send_error 500 "Internal server error" "Background size must be non-zero"

send_header image/jpeg $FILESIZE $DISP_FILENAME
cat "$BACKGROUND_SD"
