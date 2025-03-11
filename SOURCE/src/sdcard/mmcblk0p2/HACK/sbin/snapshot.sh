#!/bin/sh
root="/tmp/sd/HACK"

LD_LIBRARY_PATH=$root/lib:/lib:/usr/lib

busybox_firmware="/bin/busybox"
busybox_hack="$root/bin/busybox"

. $root/etc/hack.conf
. $root/etc/hack_custom.conf
. $root/etc/commands.conf

sdtmp="/tmp/sd/snapshot.tmp"
stream_sd="/tmp/VideoSubStream0"
stream_hd="/tmp/VideoMainStream0"

if [ "$1" = "hd" ]; then
	stream=$stream_hd
	ext="hd"
else
	stream=$stream_sd
	ext="sd"
fi

mkdir -p $sdtmp >/dev/null 2>&1
cp -f $stream $sdtmp/snapshot.h264
touch $sd_www/snapshot_$ext.lock >/dev/null 2>&1
ffmpeg -r 15 -i $sdtmp/snapshot.h264 -c:v copy -bsf:v h264_mp4toannexb $sdtmp/snapshot.ts -y && \
ffmpeg -i $sdtmp/snapshot.ts -frames:v 1 $sd_www/images/snapshot_$ext.jpg -y
rm -rf $sdtmp >/dev/null 2>&1
rm -f $sd_www/snapshot_$ext.lock >/dev/null 2>&1
