#!/bin/sh
echo -n "LSCamoflash network script is starting up at " && date

# Check, whether we were called from hostapd script and load configs
[ -n "$hack" -a -n "$hack_conf" -a -f "$hack_conf" ] && . $hack_conf && echo "Configuration loaded from: $hack_conf" || exit 1
[ -n "$hack_custom_conf" ] && . $hack_custom_conf && echo "Custom configuration override loaded from: $hack_custom_conf"

# Redefine variables for next scripts (in case of /mnt is unmounted)
export hack="$sd_path/HACK"
export hack_conf="$hack/etc/hack.conf"
export hack_custom_conf="$hack/etc/hack_custom.conf"
export commands_conf="$hack/etc/commands.conf"

# Define busyboxes
export busybox_hack="$sd_bin/busybox"
export busybox_firmware="$sys_bin/busybox"

# Load commands variables
[ -n "$commands_conf" ] && . $commands_conf && echo "Command variables loaded from: $commands_conf" || exit 1

# Check wifi configuration override requirements
if [ "$wifi_config_override" = "1" ]; then
	wifi_reset_override=0

	[ -n "$wifi_driver" ] || wifi_reset_override=1
	[ -n "$wifi_ssid" ] || wifi_reset_override=1

    if [ "$wifi_reset_override" = "1" ]; then
		wifi_config_override=0
	fi
fi

network_mode="tuya"
wpa_supplicant="$sys_usr_bin/wpa_supplicant"
wpa_cli="$sys_usr_bin/wpa_cli"

# Wifi configuration
if [ "$wifi_config_override" = "1" ]; then
	echo "Wifi configuration override requested"
	echo "ctrl_interface=/var/run/wpa_supplicant" > /tmp/wpa_custom.conf
	echo "network={" >> /tmp/wpa_custom.conf
	echo "    ssid=\"$wifi_ssid\"" >> /tmp/wpa_custom.conf
	echo "    scan_ssid=$wifi_scan_ssid" >> /tmp/wpa_custom.conf
	echo "    key_mgmt=$wifi_key_mgmt" >> /tmp/wpa_custom.conf
	echo "    pairwise=$wifi_pairwise" >> /tmp/wpa_custom.conf
	echo "    group=$wifi_group" >> /tmp/wpa_custom.conf
	echo "    psk=\"$wifi_psk\"" >> /tmp/wpa_custom.conf
	echo "}" >> /tmp/wpa_custom.conf
	
   	# Disable wifi scripts
   	for i in `ls -1 $sys_usr_sbin/station_connect.sh $sys_usr_sbin/wifi_*`; do 
        mounted=`$cat /proc/mounts | $grep "$i" | $grep "$sd_bin/exit.sh" >/dev/null 2>&1 && echo 1 || echo 0`
        [ "$mounted" = "1" ] || mount --bind $sd_sbin/exit.sh $i
   	done
	
    # Copy wpa_supplicant to a safe execution position
   	[ -f "$sd_bin/wifi_sup" ] || $cp -f $sys_usr_bin/wpa_supplicant $sd_bin/wifi_sup
    [ -f "$sd_bin/wifi_cli" ] || $cp -f $sys_usr_bin/wpa_cli $sd_bin/wifi_cli
	
	wpa_supplicant="$sd_bin/wifi_sup"
    wpa_cli="$sd_bin/wifi_cli"

	# Disable wifi and networking tools
	for i in $sys_usr_bin/wpa_supplicant $sys_usr_bin/wpa_cli; do 
        mounted=`$cat /proc/mounts | $grep "$i" | $grep "$sd_bin/exit.sh" >/dev/null 2>&1 && echo 1 || echo 0`
		[ "$mounted" = "1" ] || mount --bind $sd_sbin/exit.sh $i
	done
	
	# Stop eventually running wpa_supplicant and udhcpc
	for i in wpa_supplicant udhcpc; do
		proc=$(pgrep -f "$i" || true)
		[ "$proc" != "" ] && $kill -KILL $proc 
	done
	
	# Setup network
	LD_LIBRARY_PATH="/lib:/usr/lib" $wpa_supplicant -iwlan0 -D$wifi_driver -c /tmp/wpa_custom.conf > $sd_log/wpa_supplicant.log 2>&1 & $sleep 5
	if [ "$wifi_use_dhcp" = "1" -o "$wifi_ip_address" = "" ]; then
        network_mode="dhcp"
		$ifconfig lo up
		$ifconfig wlan0 0.0.0.0 up
		$udhcpc -x hostname:$(echo $system_hostname | $cut -d . -f1) \
		--interface=wlan0 --now --pidfile=/var/run/udhcpc-wlan0.pid \
		--script=$sd_sbin/udhcpc-hook.sh > $sd_log/udhcpc.log 2>&1 &
	else
        network_mode="manual"
		[ -n "$wifi_ip_address" -a -n "$wifi_netmask" -a -n "$wifi_broadcast" ] && $ifconfig wlan0 $wifi_ip_address netmask $wifi_netmask broadcast $wifi_broadcast
		[ -n "$wifi_ip_address" -a -n "$wifi_netmask" ] && $ifconfig wlan0 $wifi_ip_address netmask $wifi_netmask
		[ -n "$wifi_ip_address" -a -n "$wifi_broadcast" ] && $ifconfig wlan0 $wifi_ip_address broadcast $wifi_broadcast
		[ -n "$wifi_ip_address" ] && $ifconfig wlan0 $wifi_ip_address netmask $wifi_netmask broadcast $wifi_broadcast
		[ -n "$wifi_gateway" ] && $route add default gw $wifi_gateway
		echo -n "" > $sys_config/resolv.conf
		[ -n "$wifi_domainname" ] && echo "domainname $wifi_domainname" >> $sys_config/resolv.conf
		[ -n "$wifi_nameserver" ] && echo "nameserver $wifi_nameserver" >> $sys_config/resolv.conf
	fi
fi

echo "$network_mode" > $network_file

if [ "$network_mode" != "tuya" ]; then
    while true; do
        $sleep 60
        LD_LIBRARY_PATH="/lib:/usr/lib" $wpa_cli -p /var/run/wpa_supplicant -i wlan0 ping 2>/dev/null | $grep "PONG" >/dev/null 2>&1 || {
            echo "wpa_supplicant not responding, restarting network..."
            $sd_sbin/network.sh &
            exit 0
        }
        if [ "$network_mode" = "dhcp" ]; then
			$ps w | $grep udhcpc | $grep -v grep | $awk '{print $1}' || {
                echo "udhcpc not running, restarting network..."
                $sd_sbin/network.sh &
                exit 0
            }
        fi
    done
fi
