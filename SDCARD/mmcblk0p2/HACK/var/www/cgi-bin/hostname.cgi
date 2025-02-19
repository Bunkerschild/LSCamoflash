#!/bin/sh

root="/tmp/sd/HACK/"

busybox_firmware="/bin/busybox"
busybox_hack="$root/bin/busybox"

. $root/etc/hack.conf
. $root/etc/hack_custom.conf
. $root/etc/commands.conf

echo -e "Content-type: application/json\r"
echo -e "\r"

echo "{\"hostname\":\"$($hostname)\",\"fqdn\":\"$($hostname -f)\"}"
