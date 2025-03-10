#!/bin/sh

root="/tmp/sd/HACK"

. ./common.cgi

export STREAM_TYPE=RTSP
export STREAM_SOURCE=LOCAL

TYPE=$(echo "$QUERY_STRING" | sed -n 's/.*type=\([^&]*\).*/\1/p')
SOURCE=$(echo "$QUERY_STRING" | sed -n 's/.*source=\([^&]*\).*/\1/p')

[ -n "$TYPE" ] && STREAM_TYPE=$TYPE
[ -n "$SOURCE" ] && STREAM_SOURCE=$SOURCE

if [ "$STREAM_SOURCE" = "LOCAL" -o "$STREAM_SOURCE" = "local" ]; then
	IP_ADDR=$(ip -4 addr show wlan0 | grep inet | awk '{print $2}' | cut -d'/' -f1)
	while [[ -z $IP_ADDR ]]; do
	    IP_ADDR=$(ip -4 addr show wlan0 | grep inet | awk '{print $2}' | cut -d'/' -f1)
	done
	STREAM_SOURCE="LOCAL"
	case $STREAM_TYPE in
		RTSP|rtsp)
			STREAM_TYPE=RTSP
			STREAM_ADDR="rtsp://$IP_ADDR:554/main_ch"
			;;
		ONVIF|onvif)
			STREAM_TYPE=ONVIF
			STREAM_ADDR="onvif://$IP_ADDR:5000/"
			;;
		*)
			send_error 400 "Bad request" "Invalid local stream type: $STREAM_TYPE"
			;;
	esac	
	json="{\"url\":\"$STREAM_ADDR\",\"type\":\"$STREAM_TYPE\",\"source\":\"$STREAM_SOURCE\"}"
else
	STREAM_SOURCE="REMOTE"
	case $STREAM_TYPE in
		HLS|hls)
			STREAM_TYPE=HLS
			;;
		FLV|flv)
			STREAM_TYPE=FLV
			;;
		RTMP|rtmp)
			STREAM_TYPE=RTMP
			;;
		RTSP|rtsp)
			STREAM_TYPE=RTSP
			;;
		*)
			send_error 400 "Bad request" "Invalid remote stream type: $STREAM_TYPE"
			;;
	esac

	json=`/tmp/sd/HACK/sbin/get_stream_url.sh`
fi

if [ -n "$json" ]; then
	send_header application/json
	echo $json
else
	send_error 503 "Service unavailable" "No response from gateway script"
fi
