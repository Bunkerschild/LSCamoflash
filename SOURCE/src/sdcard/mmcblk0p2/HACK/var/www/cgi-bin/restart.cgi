#!/bin/sh

root="/tmp/sd/HACK"

. ./common.cgi

send_header application/json

anyka_pid=`ps awx | grep anyka_ipc | grep -v /usr/bin/anyka_ipc | grep -v grep | awk '{print $1}'`

if [ "$anyka_pid" = "" ]; then
	send_json restart=0 pid=0
else
	did_kill=0
	kill -KILL $anyka_pid >/dev/null 2>&1 && did_kill=1
	send_json restart=$did_kill pid=$anyka_pid
fi
