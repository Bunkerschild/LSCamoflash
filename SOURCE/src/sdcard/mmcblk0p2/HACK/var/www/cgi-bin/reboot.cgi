#!/bin/sh

root="/tmp/sd/HACK"

. ./common.cgi

send_header application/json
sleep 3 && reboot & send_json reboot=1

