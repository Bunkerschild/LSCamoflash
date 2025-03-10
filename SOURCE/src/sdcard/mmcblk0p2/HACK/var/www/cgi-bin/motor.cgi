#!/bin/sh

root="/tmp/sd/HACK"

. ./common.cgi

send_header application/json

DIST=`parse_keyval '&' "$QUERY_STRING" dist`
DIR=`parse_keyval '&' "$QUERY_STRING" dir`

if [ "$DIST" = "" -a "$DIR" = "" ]; then
	send_json has_ptz=$device_has_ptz
	exit
fi

did_ptz=0
$sd_sbin/ptz.sh $DIR $DIST 2>/dev/null && did_ptz=1
send_json has_ptz=$device_has_ptz did_ptz=$did_ptz dir=$DIR dist=$DIST 
