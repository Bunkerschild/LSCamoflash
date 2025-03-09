#!/bin/sh

. ./validate_session.cgi

echo -e "Content-type: application/json\r"
echo -e "\r"

echo "{\"reboot\":\"ok\"}"
reboot
