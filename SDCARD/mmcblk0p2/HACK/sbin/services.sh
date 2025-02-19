#!/bin/sh

[ -n "$hack" ] || exit 1

# Custom scripts run before services
[ -n "$custom_pre_services_async" -a -x "$custom_pre_services_async" ] && $custom_pre_services_async &
[ -n "$custom_pre_services" -a -x "$custom_pre_services" ] && $custom_pre_services

# Compare function
compare() {
        src="$1"
        dst="$2"

        [ "$dst" = "" ] && return 1

        src_csum=`$md5sum "$src" | $grep "$src" | $awk '{print \$1}'`
        dst_csum=`$md5sum "$dst" | $grep "$dst" | $awk '{print \$1}'`

        if [ "$src_csum" = "$dst_csum" ]; then
                return 0
        fi

        return 1
}

# Check, whether _ht_sw_settings.ini exists
if [ ! -e $sd_config/_ht_sw_settings.ini ]; then
        $cp $sys_config/_ht_sw_settings.ini $sd_config
fi
if [ -e $sd_config/_ht_sw_settings.ini ]; then
        compare $sys_config/_ht_sw_settings.ini $sd_config/_ht_sw_settings.ini || $cp $sys_config/_ht_sw_settings.ini $sd_config
fi

# FTP Service
if [ "$port_ftp" != "" ]; then
	has_ftp=`pgrep -f "tcpsvd 0 $port_ftp ftpd"`
 	if [ "$ftp_enabled" = "1" ]; then
		if [ "$has_ftp" = "" ]; then
			$sys_bin/tcpsvd 0 $port_ftp ftpd -w $sd_path -t 1800 &
		fi
	else
 		if [ "$has_ftp" != "" ]; then
			kill -KILL $has_ftp
   		fi
	fi
fi

# Telnet Service
if [ "$port_telnet" != "" ]; then
	has_telnet=`pgrep -f "busybox telnetd"`
 	if [ "$telnet_enabled" = "1" ]; then
		if [ "$has_telnet" = "" ]; then
			$sd_bin/busybox telnetd -p $port_telnet
		fi
	else
 		if [ "$has_telnet" != "" ]; then
			kill -KILL $has_telnet
   		fi
 	fi
fi

# HTTP Service
if [ "$port_http" != "" ]; then
	has_http=`pgrep -f "busybox httpd"`
 	if [ "$http_enabled" = "1" ]; then
		if [ "$has_http" = "" ]; then
			$sd_bin/busybox httpd -c $sd_etc/httpd.conf -h $sd_www -p $port_http
		fi
  	else
   		if [ "$has_http" != "" ]; then
			kill -KILL $has_http
       		fi
   	fi
fi

# Offline mode
if [ "$use_offline_mode" != "" ]; then
	has_ntpclient=`pgrep -f "ntpclient"`
	if [ "$has_ntpclient" = "" ]; then
		ntpclient -h $ntp_server -s -l $ntp_update >/dev/null 2>&1 & sleep 3
		$sys_usr_sbin/state_led.sh off >/dev/null 2>&1
	fi
	has_offline=`pgrep -f "offline.sh"`
	if [ "$has_offline" = "" ]; then
		$sd_sbin/offline.sh & sleep 1
	fi		
fi

# ONVIF Service
if [ "$port_onvif" != "" ]; then
	has_onvif=`pgrep -f "onvif"`
 	if [ "$onvif_enabled" = "1" ]; then
		if [ "$has_onvif" = "" ]; then
			$sd_sbin/onvif.sh &
		fi
  	else
   		if [ "$has_onvif" != "" ]; then
			kill -KILL $has_onvif
     		fi
   	fi
fi

# Make sure hostapd and _ht_ap_mode.conf is on partition 1
if [ -x "/tmp/hostapd" ]; then
	mkfsrunning=`ps awx | grep "mkfs.vfat" | grep -v "grep" | awk '{print $1}'`

 	if [ "$mkfsrunning" = "" ]; then
		mountedon=`mount | grep "^/dev/mmcblk0p1" | awk '{print $3}' | grep "/mnt"`
	 	forcedmount=""

 		if [ "$mountedon" = "" ]; then
			mount /dev/mmcblk0p1 /mnt && forcedmount="1"
			mountedon=`mount | grep "^/dev/mmcblk0p1" | awk '{print $3}' | grep "/mnt"`
	  	fi

 		if [ "$mountedon" != "" ]; then
			if [ ! -f "$mountedon/hostapd" ]; then
				cp /tmp/hostapd $mountedon/hostapd
  			fi
			if [ ! -f "$mountedon/_ht_ap_mode.conf" ]; then
				touch $mountedon/_ht_ap_mode.conf
  			fi
    			if [ "$forcedmount" = "1" ]; then
				umount /mnt && forcedmount=""
      			fi
  		fi
    	fi
fi

# Daily cleanup of DCIM
if [ ! -e /tmp/cleanup`date +%Y%m%d` ]; then
 rm -rf /tmp/cleanup*
 touch /tmp/cleanup`date +%Y%m%d`
 /tmp/sd/cgi-bin/cleanup.cgi > $cleanup_log
fi

# Custom scripts run after services
[ -n "$custom_post_services_async" -a -x "$custom_post_services_async" ] && $custom_post_services_async &
[ -n "$custom_post_services" -a -x "$custom_post_services" ] && $custom_post_services

# Touch services.run and tell the system, that the script is alive
touch $sys_temp/services.run >/dev/null 2>&1

# Update script path
update="$sd_sbin/update.sh"

# Reboot flag
reboot_flag="$sys_temp/hostapd.reboot"
reboot_file="$sd_path/hostapd.reboot"

# Breakout file
breakout_file="$sys_temp/hostapd.break"

# Check for updates
[ -x $update ] && $update

# Check for reboot file and move it to reboot flag
[ -f "$reboot_file" ] && mv $reboot_file $reboot_flag
	
# Check for reboot flag
if [ -f $reboot_flag ]; then 
	# Breakout
	touch $breakout_file

	# Reboot
	rm -f $reboot_flag
	reboot
fi

