#!/bin/sh
sleep 30

[ -n "$hack" ] || exit 1

while true; do
	gateway=`route -n | grep UG | awk '{print $2}'`
	[ -n "$gateway" ] && break
	sleep 3
done

touch /tmp/_ak39_startlock.ini
kill -KILL `pidof anyka_ipc_patched`  >/dev/null 2>&1
kill -KILL `pidof anyka_ipc` >/dev/null 2>&1
kill -KILL `pidof ipc_log_parser.sh` >/dev/null 2>&1

touch /tmp/_ak39_factory.ini
$sd_bin/anyka_ipc >/dev/null 2>&1 &
sleep 30 && state_led.sh off &
