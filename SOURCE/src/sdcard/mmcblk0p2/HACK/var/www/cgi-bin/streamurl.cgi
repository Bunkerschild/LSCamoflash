#!/bin/sh

root="/tmp/sd/HACK/"

busybox_firmware="/bin/busybox"
busybox_hack="$root/bin/busybox"

. $root/etc/hack.conf
. $root/etc/hack_custom.conf
. $root/etc/commands.conf

export STREAM_TYPE=RTSP
export STREAM_SOURCE=LOCAL

TYPE=$(echo "$QUERY_STRING" | sed -n 's/.*type=\([^&]*\).*/\1/p')
SOURCE=$(echo "$QUERY_STRING" | sed -n 's/.*source=\([^&]*\).*/\1/p')

[ -n "$TYPE" ] && STREAM_TYPE=$TYPE
[ -n "$SOURCE" ] && STREAM_SOURCE=$SOURCE

if [ "$STREAM_SOURCE" = "LOCAL" -o "$STREAM_SOURCE" = "local" ]; then
	STREAM_SOURCE="LOCAL"
	case $STREAM_TYPE in
		RTSP|rtsp)
			STREAM_TYPE=RTSP
			;;
		*)
			echo "Status: 404 Not found"
			echo -e "Content-Type: text/plain\r\n\r"
			echo "Invalid local stream type: $STREAM_TYPE"
			exit 1
			;;
	esac
	
	IP_ADDR=$(ip -4 addr show wlan0 | grep inet | awk '{print $2}' | cut -d'/' -f1)
	while [[ -z $IP_ADDR ]]; do
	    IP_ADDR=$(ip -4 addr show wlan0 | grep inet | awk '{print $2}' | cut -d'/' -f1)
	done
	
	json="{\"url\":\"rtsp://$IP_ADDR:554/main_ch\",\"type\":\"$STREAM_TYPE\",\"source\":\"$STREAM_SOURCE\"}"
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
			echo "Status: 404 Not found"
			echo -e "Content-Type: text/plain\r\n\r"
			echo "Invalid remote stream type: $STREAM_TYPE"
			exit 1
			;;
	esac

	json=`/tmp/sd/HACK/sbin/get_stream_url.sh`
fi

if [ -n "$json" ]; then
	echo -e "Content-type: application/json\r\n\r"
	echo $json
else
	echo "Status: 404 Not found"
	echo -e "Content-type: text/plain\r\n\r"
	echo "No response"
fi
