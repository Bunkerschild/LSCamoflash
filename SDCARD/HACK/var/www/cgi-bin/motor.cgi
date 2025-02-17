#!/bin/sh

root="/tmp/sd/HACK/"

busybox_firmware="/bin/busybox"
busybox_hack="$root/bin/busybox"

. $root/etc/hack.conf
. $root/etc/hack_custom.conf
. $root/etc/commands.conf

anyka_ipc_bin='anyka_ipc'
if [ -x $sd_bin/anyka_ipc_patched ]; then
	anyka_ipc_bin='anyka_ipc_patched'
fi

echo -e "Content-type: text/plain\r"
echo -e "\r"
echo ${REQUEST_URI}
TMP=${REQUEST_URI#*dist=};
DIST=${TMP%&*}
TMP=${REQUEST_URI#*dir=};
DIR=${TMP%&*}
PID=$(pgrep -f "$anyka_ipc_bin")
echo DIST=$DIST DIR=$DIR PID=$PID

if [ "$DIR" == "up" ] || [ "$DIR" == "down" ]; then
 ADDR=431684
else
 ADDR=431614
fi

if [ "$DIR" == "down" ] || [ "$DIR" == "left" ]; then
 VAL=ffa60000
else
 VAL=5b0000
fi

if [ "$PID" != "" ] && [ "$DIR" != "" ]; then
 # Pause motion detection for 3 seconds
 echo -en '\xB8\x0B\x00\x00' | dd of=/proc/$PID/mem bs=1 count=4 seek=$((0x4313c8))
 $sd_bin/motor $PID $ADDR 40046d40 $VAL $DIST 2>/dev/null
fi
