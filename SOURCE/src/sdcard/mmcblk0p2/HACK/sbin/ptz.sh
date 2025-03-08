#!/bin/sh

root="/tmp/sd/HACK/"

busybox_firmware="/bin/busybox"
busybox_hack="$root/bin/busybox"

old_ptz_1080p_seek="4313c8"
old_ptz_1080p_up_down="431684"
old_ptz_1080p_left_right="431614"
old_ptz_1080p_checksum="2bc721ccfcd502291f10486aa72ce8a6"

indoor_ptz_1080p_seek="51c1d8"
indoor_ptz_1080p_up_down="51c3a4"
indoor_ptz_1080p_left_right="51c334"
indoor_ptz_1080p_checksum="8ea59723a177e1c68a798ca1a2882798"

indoor_ptz_1296p_seek="51a888"
indoor_ptz_1296p_up_down="51aa54"
indoor_ptz_1296p_left_right="51a9e4"
indoor_ptz_1296p_checksum="86396fdb14f2e029fa169afd4b598391"

outdoor_ptz_1296p_seek="5357cc"
outdoor_ptz_1296p_up_down="53599c"
outdoor_ptz_1296p_left_right="53592c"
outdoor_ptz_1296p_checksum="339313038233b6f7645197ff93dd0d88"

set_seek=""
set_up_down=""
set_left_right=""

. $root/etc/hack.conf
. $root/etc/hack_custom.conf
. $root/etc/commands.conf
. $root/etc/anyka_checksums.conf

anyka_pid_count=`ps awx | grep anyka_ipc | grep -v grep | wc -l`
anyka_pid=""

if [ "$anyka_pid_count" = 1 ]; then
        anyka_pid=`ps awx | grep anyka_ipc | grep -v grep | awk '{print $1}'`
elif [ "$anyka_pid_count" = 2 ]; then
        anyka_pid=`ps awx | grep anyka_ipc | grep -v grep | grep -v "/usr/bin/anyka_ipc" | awk '{print $1}'`
else
        echo "No running process"
        exit 1
fi

if [ -z "$anyka_pid" ]; then
        echo "Process is dead"
        exit 2
fi

anyka_bin=`cat /proc/$anyka_pid/cmdline | awk '{print $1}'`
anyka_chk=`md5sum $anyka_bin | awk '{print $1}'`

case $anyka_chk in
	$old_ptz_1080p_originl|$old_ptz_1080p_patched)
		set_seek="$old_ptz_1080p_seek"
		set_up_down="$old_ptz_1080p_up_down"
		set_left_right="$old_ptz_1080p_left_right"
	;;
	$indoor_ptz_1080p_originl|$indoor_ptz_1080p_patched)
		set_seek="$indoor_ptz_1080p_seek"
		set_up_down="$indoor_ptz_1080p_up_down"
		set_left_right="$indoor_ptz_1080p_left_right"
	;;
	$indoor_ptz_1296p_originl|$indoor_ptz_1296p_patched)
		set_seek="$indoor_ptz_1296p_seek"
		set_up_down="$indoor_ptz_1296p_up_down"
		set_left_right="$indoor_ptz_1296p_left_right"
	;;
	$outdoor_ptz_1296p_originl|$outdoor_ptz_1296p_patched)
		set_seek="$outdoor_ptz_1296p_seek"
		set_up_down="$outdoor_ptz_1296p_up_down"
		set_left_right="$outdoor_ptz_1296p_left_right"
	;;
	*)
		echo "Not a supported ptz camera"
		exit 3
	;;
esac

DIR="$1"
DIST="$2"

INVERT=`cat $sys_config/_ht_sw_settings.ini 2>/dev/null | grep "bool_rotate180" | awk '{print $3}' || echo 0`

if [ "$INVERT" = "0" ]; then
	VAL_ADD="ffa60000"
	VAL_SUB="5b0000"
else
	VAL_SUB="ffa60000"
	VAL_ADD="5b0000"
fi

case $DIR in
	up|down|left|right)
	;;
	*)
		echo "Invalid direction"
		exit 4
	;;
esac

if [ "$DIST" = "" ]; then
	echo "Usage: $0 up|down|left|right distance"
	exit 5
fi

case $DIR in
	up)
		ADDR=$set_up_down
		VAL=$VAL_ADD
	;;
	down)
		ADDR=$set_up_down
		VAL=$VAL_SUB
	;;
	left)
		ADDR=$set_left_right
		VAL=$VAL_ADD
	;;
	right)
		ADDR=$set_left_right
		VAL=$VAL_SUB
	;;
esac

if [ "$anyka_pid" != "" ] && [ "$DIR" != "" ]; then
 # Pause motion detection for 3 seconds
 echo -en '\xB8\x0B\x00\x00' | dd of=/proc/$anyka_pid/mem bs=1 count=4 seek=$((0x$set_seek))
 $sd_bin/motor $anyka_pid $ADDR 40046d40 $VAL $DIST 2>/dev/null
fi
