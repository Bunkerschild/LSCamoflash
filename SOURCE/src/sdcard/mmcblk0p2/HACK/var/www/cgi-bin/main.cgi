#!/bin/sh
. /tmp/sd/HACK/etc/hack.conf

echo -en "Content-Type: text/plain\r\n\r\n"
$sd_bin/busybox ls -a -Xp ..${REQUEST_URI#${SCRIPT_NAME}}
