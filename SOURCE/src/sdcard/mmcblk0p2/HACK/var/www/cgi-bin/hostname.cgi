#!/bin/sh

root="/tmp/sd/HACK"

. ./common.cgi

send_header application/json
is_private_ip $IPADDRESS && \
echo "{\"hostname\":\"$($hostname)\",\"fqdn\":\"$($hostname -f)\",\"model\":\"$device_model\",\"manufacturer\":\"$device_manufacturer\",\"masked\":0}" || \
echo "{\"hostname\":\"camera\",\"fqdn\":\"camera.local\",\"model\":\"$device_model\",\"manufacturer\":\"$device_manufacturer\",\"masked\":1}"
