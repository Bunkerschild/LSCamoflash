#!/bin/sh

. ./validate_session.cgi

echo -e "Content-type: application/json\r"
echo -e "\r"

echo "{\"restart\":" 
anyka_pid=`ps awx | grep anyka_ipc | grep -v /usr/bin/anyka_ipc | grep -v grep | awk '{print $1}'`

if [ "$anyka_pid" = "" ]; then
	echo "\"not running\"}"
else
	kill -KILL $anyka_pid >/dev/null 2>&1 && echo "\"ok\"}" || echo "\"failed\"}"
fi
