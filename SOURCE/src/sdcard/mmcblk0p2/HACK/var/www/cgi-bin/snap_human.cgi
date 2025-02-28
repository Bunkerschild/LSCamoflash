#!/bin/sh

root="/tmp/sd/HACK/"

busybox_firmware="/bin/busybox"
busybox_hack="$root/bin/busybox"

. $root/etc/hack.conf
. $root/etc/hack_custom.conf
. $root/etc/commands.conf

if [ -f "/tmp/snap_human.jpg" ]; then
        echo -e "Content-type: image/jpeg\r"
        echo -e "\r"

        cat /tmp/snap_human.jpg
else
        echo -e "Content-Type: text/plain\r"
        echo -e "\r"

        echo "No human snapshot stored"
fi
