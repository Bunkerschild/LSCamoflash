#!/bin/sh

root="/tmp/sd/HACK/"

busybox_firmware="/bin/busybox"
busybox_hack="$root/bin/busybox"

. $root/etc/hack.conf
. $root/etc/hack_custom.conf
. $root/etc/commands.conf

echo -e "Content-type: text/plain\r"
echo -e "\r"
anyka_pid_count=`ps awx | grep anyka_ipc | grep -v grep | wc -l`
anyka_pid=""

if [ "$anyka_pid_count" = 1 ]; then
        anyka_pid=`ps awx | grep anyka_ipc | grep -v grep | awk '{print $1}'`
elif [ "$anyka_pid_count" = 2 ]; then
        anyka_pid=`ps awx | grep anyka_ipc | grep -v grep | grep -v "/usr/bin/anyka_ipc" | awk '{print $1}'`
else
        if [ -z "$DIR" ]; then
                echo "no"
                exit 1
        fi
        echo "No running process"
        exit 1
fi

if [ -z "$anyka_pid" ]; then
        if [ -z "$DIR" ]; then
                echo "no"
                exit 1
        fi
        echo "Process is dead"
        exit 2
fi

anyka_bin=`cat /proc/$anyka_pid/cmdline | awk '{print $1}'`
anyka_chk=`md5sum $anyka_bin | awk '{print $1}'`

if [ "$anyka_chk" != "2bc721ccfcd502291f10486aa72ce8a6" ]; then
        if [ -z "$DIR" ]; then
                echo "no"
                exit 1
        fi
        echo "Wrong anyka_ipc version"
        exit 3
elif [ -z "$DIR" ]; then
        echo "yes"
        exit
fi

echo ${REQUEST_URI}
TMP=${REQUEST_URI#*dist=};
DIST=${TMP%&*}
TMP=${REQUEST_URI#*dir=};
DIR=${TMP%&*}
echo DIST=$DIST DIR=$DIR PID=$anyka_pid

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

if [ "$anyka_pid" != "" ] && [ "$DIR" != "" ]; then
 # Pause motion detection for 3 seconds
# echo -en '\xB8\x0B\x00\x00' | dd of=/proc/$anyka_pid/mem bs=1 count=4 seek=$((0x4313c8))
 $sd_bin/motor $anyka_pid $ADDR 40046d40 $VAL $DIST 2>/dev/null
fi
