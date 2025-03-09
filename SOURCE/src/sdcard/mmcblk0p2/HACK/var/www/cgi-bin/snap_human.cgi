#!/bin/sh

. ./validate_session.cgi

onvif_token=`cat $sd_etc/onvif.token 2>/dev/null`

TMP=${REQUEST_URI#*token=};
TOKEN=${TMP%&*}

if [ "$TOKEN" = "$onvif_token" ]; then
	if [ -f "/tmp/snap_human.jpg" ]; then
	        echo -e "Content-type: image/jpeg\r"
	        echo -e "\r"
	
	        cat /tmp/snap_human.jpg
	else
		echo "Status: 404 Not found"
	        echo -e "Content-Type: text/plain\r"
	        echo -e "\r"
	
	        echo "No human snapshot stored"
	        exit 1
	fi
else
	echo "Status: 401 Unauthorized"
	echo -e "Content-Type: text/plain\r\n\r"
	echo "Invalid token"
	exit 2
fi
