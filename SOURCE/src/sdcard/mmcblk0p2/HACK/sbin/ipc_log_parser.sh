#!/bin/sh

[ -n "$hack" ] || exit 1

DEBUG_FILE=$1

[ -z $DEBUG_FILE ] && DEBUG_FILE="/dev/null"

# Sicherstellen, dass das Verzeichnis existiert
mkdir -p /tmp/anyka/

contains() {
    string="$1"
    substring="$2"
    if test "${string#*$substring}" != "$string"
    then
        return 0    # $substring is in $string
    else
        return 1    # $substring is not in $string
    fi
}

grep_pid="read pid:"
grep_uuid="read uuid:"
grep_auth_key="read auth_key:"
grep_sensor_fps="set sensor fps:"
grep_detected="[INFO] Detected"

main() {
    IFS='$\n'
    echo -n "" > $DEBUG_FILE
    while true; do
    read -r BUF;
    if [ $? -ne 0 ]; then
        sleep 1;
        continue
    fi
    if contains "$BUF" "$grep_sensor_fps"; then
        fps=`echo "$BUF" | awk -F"$grep_sensor_fps " '{print $2}'`
        echo "Sensor set to $fps fps"
        echo "$fps" > /tmp/anyka/sensor_fps
    elif contains "$BUF" "$grep_pid"; then
        pid=`echo "$BUF" | awk -F"$grep_pid " '{print $2}'`
        echo "PID is $pid"
        echo "$pid" > /tmp/anyka/pid
    elif contains "$BUF" "$grep_uuid"; then
        uuid=`echo "$BUF" | awk -F"$grep_uuid " '{print $2}'`
        echo "UUID is $uuid"
        echo "$uuid" > /tmp/anyka/uuid
    elif contains "$BUF" "$grep_auth_key"; then
        auth_key=`echo "$BUF" | awk -F"$grep_auth_key " '{print $2}'`
        echo "Auth key is $auth_key"
        echo "$auth_key" > /tmp/anyka/auth_key
    elif contains "$BUF" "$grep_detect"; then
        echo "Motion detected at $(date)"
        echo "$(date)" > /tmp/anyka/motion_detected
    fi
    echo $BUF >> $DEBUG_FILE
    done
}

main
