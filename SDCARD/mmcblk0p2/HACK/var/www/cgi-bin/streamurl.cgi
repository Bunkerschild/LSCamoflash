#!/bin/sh

root="/tmp/sd/HACK/"

busybox_firmware="/bin/busybox"
busybox_hack="$root/bin/busybox"

. $root/etc/hack.conf
. $root/etc/hack_custom.conf
. $root/etc/commands.conf

export STREAM_TYPE=RTSP

echo -e "Content-type: application/json\r"
echo -e "\r"

TMP=${REQUEST_URI#*type=};
TYPE=${TMP%&*}

[ -n "$TYPE" ] && STREAM_TYPE=$TYPE

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
	*)
		STREAM_TYPE=RTSP
		;;
esac

json=`/tmp/sd/HACK/sbin/get_stream_url.sh`

if [ -n "$json" ]; then
	echo $json
else
	echo "{\"error\": \"no response from get_stream_url\"}"
fi
