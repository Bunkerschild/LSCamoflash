#!/bin/sh

[ -n "$hack" ] || exit 1

echo "${0}: starting $(date)" >> $offline_log

# Wait for date to be corrected
while [ `date +%s` -lt 1645543474 ]; do
 date >> $offline_log
 sleep 10
done

pattern=":$port_ftp\|:$port_telnet\|:123\|:554\|:$port_onvif\|:6668\|:$port_http"

IP_ADDR=$(ip -4 addr show wlan0 | grep inet | awk '{print $2}' | cut -d'/' -f1)
while [[ -z $IP_ADDR ]]; do
    IP_ADDR=$(ip -4 addr show wlan0 | grep inet | awk '{print $2}' | cut -d'/' -f1)
done

echo "${0}: blocked hosts" >> $offline_log

# Function to check if an IP is private
is_private_ip() {
  case "$1" in
    10.*|192.168.*|172.1[6-9].*|172.2[0-9].*|172.3[0-1].*) return 0 ;;  # Private IPs
    127.*) return 0 ;;  # Localhost
    *) return 1 ;;  # Public IPs
  esac
}

# Wait for connection to be dropped
while [ `netstat -ntu 2>&1 | grep -v 127.0.0.1 | grep -v "$pattern" | grep ESTABLISHED | awk '{print $5}' | awk -F: '{print $1}' | grep -v "$IP_ADDR" | wc -l` -gt 0 ]; do
 for ip in `netstat -ntu 2>&1 | grep -v 127.0.0.1 | grep -v "$pattern" | grep ESTABLISHED | awk '{print $5}' | awk -F: '{print $1}' | grep -v "$IP_ADDR"`; do
  echo "${0}: checking $ip" >> $offline_log
  
  if is_private_ip "$ip"; then
    echo "${0}: skipping private IP $ip" >> $offline_log
    continue
  fi
  
  if [ "`route -n | grep -c $ip`" == "0" ]; then
   route add -net $ip netmask 255.255.255.255 gw 127.0.0.1  2>&1 >> $offline_log
   echo "${0}: blocked $ip" >> $offline_log
  fi
 done
done

echo "${0} done $(date)" >> $offline_log
