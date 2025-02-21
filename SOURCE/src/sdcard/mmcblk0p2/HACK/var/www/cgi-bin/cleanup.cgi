#!/bin/sh

root="/tmp/sd/HACK/"

busybox_firmware="/bin/busybox"
busybox_hack="$root/bin/busybox"

. $root/etc/hack.conf
. $root/etc/hack_custom.conf
. $root/etc/commands.conf

echo -e "Content-type: text/plain\r"
echo -e "\r"

DAYS=$dcim_cleanup_days
YEAR=$(date +%Y)

$find $sd_dcim/ -type d -mtime +$DAYS -exec echo rm -rf {} \; -exec rm -rf {} \;
YEAR=$((YEAR-1))

if [ -e $sd_dcim/ ]; then
 $find $sd_dcim/ -type d -mtime +$DAYS -exec echo rm -rf {} \; -exec rm -rf {} \;
fi
