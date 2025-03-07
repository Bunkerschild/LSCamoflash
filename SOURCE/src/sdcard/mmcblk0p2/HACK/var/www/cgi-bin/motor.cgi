#!/bin/sh

root="/tmp/sd/HACK/"

busybox_firmware="/bin/busybox"
busybox_hack="$root/bin/busybox"

. $root/etc/hack.conf
. $root/etc/hack_custom.conf
. $root/etc/commands.conf

echo -e "Content-type: text/plain\r"
echo -e "\r"

TMP=${REQUEST_URI#*dist=};
DIST=${TMP%&*}
TMP=${REQUEST_URI#*dir=};
DIR=${TMP%&*}

$sd_sbin/ptz.sh $DIR $DIST
