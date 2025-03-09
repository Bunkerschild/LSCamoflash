#!/bin/sh

. ./validate_session.cgi

echo -e "Content-type: text/plain\r"
echo -e "\r"

TMP=${REQUEST_URI#*dist=};
DIST=${TMP%&*}
TMP=${REQUEST_URI#*dir=};
DIR=${TMP%&*}

[ "$DIR" = "$REQUEST_URI" ] && DIR=""
[ "$DIST" = "$REQUEST_URI" ] && DIST=""

if [ "$DIST" = "" -a "$DIR" = "" ]; then
	if [ "$device_has_ptz" = "1" ]; then
		echo "yes"
	else
		echo "no"
	fi
	exit
fi

$sd_sbin/ptz.sh $DIR $DIST
