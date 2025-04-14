#!/bin/sh

# Check, whether we were called fron CLI
if [ "$1" != "" ]; then
        hack="/tmp/sd/HACK"
        hack_conf="$hack/etc/hack.conf"
        hack_custom_conf="$hack/etc/hack_custom.conf"
fi

# Exit, if we were called from CLI without argument
if [ -z "$hack" ]; then
	echo "You must not start $0 from cli without argument(s)"
 	exit 1
fi

# We have to reload the hack and hack_custom config
[ -f "$hack_conf" ] && . $hack_conf
[ -f "$hack_custom_conf" ] && . $hack_custom_conf

# Services run file
services_run="$sys_temp/services.run"

# Anyka IPC Wrapper startlock file
anyka_startlock="$sys_temp/_ak39_startlock.ini"

# Define options for telnetd
export telnetd_options="-p $port_telnet"
[ "$FORCE_PASSWORDLESS_TELNETD" = "1" ] && telnetd_options="$telnetd_options -a"

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

# Get PID of service
getServicePID() {
	[ "$1" = "" ] && return 1
	
	local has_pid=""
	
	case $1 in
		anyka_ipc)
			[ -f "$sys_temp/anyka_ipc_wrapper.cmd" ] || return 1
			local wrapper_cmd=`cat $sys_temp/anyka_ipc_wrapper.cmd`
			has_pid=`pgrep -f "$wrapper_cmd"`
			;;
		ftp)
			has_pid=`pgrep -f "tcpsvd 0 .* ftpd"`
			;;
		telnet)
			has_pid=`pgrep -f "busybox telnetd $telnetd_options"`
			;;
		http)
			has_pid=`pgrep -f "busybox httpd"`
			;;
		cron)
			has_pid=`pgrep -f "busybox crond"`
			;;
		onvif)
			has_pid=`pgrep -f "onvif_srvd"`
			;;		
		mqtt)
			has_pid=`pgrep -f "mosquitto"`
			;;
		*)
			return 1
			;;
	esac
	
	[ -z "$has_pid" ] && return 1
	echo $has_pid && return 0
}

# Get/Set single service function
singleService() {
	[ "$1" = "" ] && return 1

	local cmd="$2"	
	local pid=""
	local sid=""
	local svc="$1"
	
	case $svc in
		anyka_ipc)
			[ -z "$cmd" ] && echo $svc && return 0
			[ -f "$sys_temp/anyka_ipc_wrapper.cmd" ] || return 1
			local wrapper_cmd=`cat $sys_temp/anyka_ipc_wrapper.cmd`
			pid=$(getServicePID anyka_ipc)
			sid="Anyka IPC"
			if [ "$cmd" = "start" ]; then
				rm -f $anyka_startlock
				[ -n "$pid" ] && echo "$sid is already running at pid $pid" || echo "$sid will start soon"
			elif [ "$cmd" = "stop" ]; then
				touch $anyka_startlock
				if [ -z "$pid" ]; then
					echo "$sid is already stopped"
				else
					kill -TERM $pid && echo "$sid stopped" || echo "Unable to stop $sid with TERM signal at pid $pid"
				fi
			elif [ "$cmd" = "status" ]; then
				[ -n "$pid" ] && echo "$sid is up and running at pid $pid" || echo "$sid is down"
			fi
			;;
		ftp)
			[ -z "$cmd" ] && echo $svc && return 0
			pid=$(getServicePID ftp)
			sid="FTP service"
			if [ "$cmd" = "start" ]; then
				touch $file_ftp_enabled
				[ -n "$pid" ] && echo "$sid is already running at pid $pid" || echo "$sid will start soon"
			elif [ "$cmd" = "stop" ]; then
				rm -f $file_ftp_enabled
				if [ -z "$pid" ]; then
					echo "$sid is already stopped"
				else
					kill -TERM $pid && echo "$sid stopped" || echo "Unable to stop $sid with TERM signal at pid $pid"
				fi
			elif [ "$cmd" = "status" ]; then
				[ -n "$pid" ] && echo "$sid is up and running at pid $pid" || echo "$sid is down"
			fi
			;;
		cron)
			[ -z "$cmd" ] && echo $svc && return 0
			pid=$(getServicePID cron)
			sid="Cron daemon"
			if [ "$cmd" = "start" ]; then
				touch $file_cron_enabled
				[ -n "$pid" ] && echo "$sid is already running at pid $pid" || echo "$sid will start soon"
			elif [ "$cmd" = "stop" ]; then
				rm -f $file_cron_enabled
				if [ -z "$pid" ]; then
					echo "$sid is already stopped"
				else
					kill -TERM $pid && echo "$sid stopped" || echo "Unable to stop $sid with TERM signal at pid $pid"
				fi
			elif [ "$cmd" = "status" ]; then
				[ -n "$pid" ] && echo "$sid is up and running at pid $pid" || echo "$sid is down"
			fi
			;;
		telnet)
			[ -z "$cmd" ] && echo $svc && return 0
			pid=$(getServicePID telnet)
			sid="Telnet service"
			if [ "$cmd" = "start" ]; then
				touch $file_telnet_enabled
				[ -n "$pid" ] && echo "$sid is already running at pid $pid" || echo "$sid will start soon"
			elif [ "$cmd" = "stop" ]; then
				rm -f $file_telnet_enabled
				if [ "$FORCE_IMMUTABLE_TELNETD" = "1" ]; then
					echo "Telnetd is immutable"
				else
					if [ -z "$pid" ]; then
						echo "$sid is already stopped"
					else
						kill -TERM $pid && echo "$sid stopped" || echo "Unable to stop $sid with TERM signal at pid $pid"
					fi
				fi
			elif [ "$cmd" = "status" ]; then
				[ -n "$pid" ] && echo "$sid is up and running at pid $pid" || echo "$sid is down"
			fi
			;;
		http)
			[ -z "$cmd" ] && echo $svc && return 0
			pid=$(getServicePID http)
			sid="HTTP service"
			if [ "$cmd" = "start" ]; then
				touch $file_http_enabled
				[ -n "$pid" ] && echo "$sid is already running at pid $pid" || echo "$sid will start soon"
			elif [ "$cmd" = "stop" ]; then
				rm -f $file_http_enabled
				if [ -z "$pid" ]; then
					echo "$sid is already stopped"
				else
					kill -TERM $pid && echo "$sid stopped" || echo "Unable to stop $sid with TERM signal at pid $pid"
				fi
			elif [ "$cmd" = "status" ]; then
				[ -n "$pid" ] && echo "$sid is up and running at pid $pid" || echo "$sid is down"
			fi
			;;
		onvif)
			[ -z "$cmd" ] && echo $svc && return 0
			pid=$(getServicePID onvif)
			sid="ONVIF service"
			if [ "$cmd" = "start" ]; then
				touch $file_onvif_enabled
				[ -n "$pid" ] && echo "$sid is already running at pid $pid" || echo "$sid will start soon"
			elif [ "$cmd" = "stop" ]; then
				rm -f $file_onvif_enabled
				if [ -z "$pid" ]; then
					echo "$sid is already stopped"
				else
					kill -TERM $pid && echo "$sid stopped" || echo "Unable to stop $sid with TERM signal at pid $pid"
				fi
			elif [ "$cmd" = "status" ]; then
				[ -n "$pid" ] && echo "$sid is up and running at pid $pid" || echo "$sid is down"
			fi
			;;
		mqtt)
			[ -z "$cmd" ] && echo $svc && return 0
			pid=$(getServicePID mqtt)
			sid="Mosquitto service"
			if [ "$cmd" = "start" ]; then
				touch $file_mqtt_enabled
				[ -n "$pid" ] && echo "$sid is already running at pid $pid" || echo "$sid will start soon"
			elif [ "$cmd" = "stop" ]; then
				rm -f $file_mqtt_enabled
				if [ -z "$pid" ]; then
					echo "$sid is already stopped"
				else
					kill -TERM $pid && echo "$sid stopped" || echo "Unable to stop $sid with TERM signal at pid $pid"
				fi
			elif [ "$cmd" = "status" ]; then
				[ -n "$pid" ] && echo "$sid is up and running at pid $pid" || echo "$sid is down"
			fi
			;;
	esac
	
	return 1
}

# CLI callable handling
if [ "$1" != "" ]; then
	sis=$(singleService "$2")
	
	# We dont want telnet, mosquitto and anyka_ipc to be mass controlled, so we remove it from services list
	services="ftp http cron onvif"
	
	case $1 in
		start)
			if [ -n "$sis" ]; then
				singleService $sis start
			else
				for svc in $services; do
					singleService $svc start
				done
			fi
			;;
		stop)
			if [ -n "$sis" ]; then
				singleService $sis stop
			else
				for svc in $services; do
					singleService $svc stop
				done
			fi
			;;
		restart)
			[ -z "$sis" ] && echo "You can only restart single services" && exit 1
			$0 stop $sis
			echo "Waiting 15 seconds for $sis to start"
			sleep 15
			$0 start $sis
			;;
		status)
			if [ -n "$sis" ]; then
				singleService $sis status
			else
				for svc in $services; do
					singleService $svc status
				done
			fi
			;;
		*)
			echo "Usage: $0 start|stop|restart|status [ftp|cron|telnet|http|onvif|anyka_ipc]"
			exit 1
			;;
	esac
	exit
fi

# Custom scripts run before services
[ -n "$custom_pre_services_async" -a -x "$custom_pre_services_async" ] && $custom_pre_services_async &
[ -n "$custom_pre_services" -a -x "$custom_pre_services" ] && $custom_pre_services

# Check, whether _ht_sw_settings.ini exists
if [ ! -e $sd_config/_ht_sw_settings.ini ]; then
        $cp $sys_config/_ht_sw_settings.ini $sd_config
fi
if [ -e $sd_config/_ht_sw_settings.ini ]; then
        compare $sys_config/_ht_sw_settings.ini $sd_config/_ht_sw_settings.ini || $cp $sys_config/_ht_sw_settings.ini $sd_config
fi

# FTP Service
if [ "$port_ftp" != "" ]; then
	has_ftp=$(getServicePID ftp)
 	if [ "$service_ftp_enabled" = "1" -a -f "$file_ftp_enabled" ]; then
		if [ "$has_ftp" = "" ]; then
			ftp_path="$sd_path"
			[ "$dcim_ftp_only" = "1" ] && ftp_path="$sd_dcim"
			$sys_bin/tcpsvd 0 $port_ftp ftpd -w $ftp_path -t 1800 &
		fi
	else
 		if [ "$has_ftp" != "" ]; then
			kill -KILL $has_ftp
   		fi
	fi
fi

# Telnet Service
if [ "$port_telnet" != "" ]; then
	has_telnet=$(getServicePID telnet)
	if [ "$FORCE_IMMUTABLE_TELNETD" = "1" ]; then
		if [ "$has_telnet" = "" ]; then
			$sd_bin/busybox telnetd $telnetd_options
		fi	
 	elif [ "$service_telnet_enabled" = "1" -a -f "$file_telnet_enabled" ]; then
		if [ "$has_telnet" = "" ]; then
			$sd_bin/busybox telnetd $telnetd_options
		fi
	else
 		if [ "$has_telnet" != "" ]; then
			kill -KILL $has_telnet
   		fi
 	fi
fi

# HTTP Service
if [ "$port_http" != "" ]; then
	has_http=$(getServicePID http)
 	if [ "$service_http_enabled" = "1" -a -f "$file_http_enabled" ]; then
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

# Cron daemon
has_crond=$(getServicePID cron)
if [ "$crond_enabled" = "1" -a -f "$file_cron_enabled" ]; then
 	if [ "$has_crond" = "" ]; then
    		$sd_bin/busybox crond -L $crond_log -c $sys_crontabs -b
  	fi
else
	if [ "$has_crond" != "" ]; then
		kill -KILL $has_crond
 	fi
fi

# ONVIF Service
if [ "$port_onvif" != "" ]; then
	has_onvif=$(getServicePID onvif)
 	if [ "$service_onvif_enabled" = "1" -a -f "$file_onvif_enabled" ]; then
		if [ "$has_onvif" = "" ]; then
			$sd_sbin/onvif.sh &
		fi
  	else
   		if [ "$has_onvif" != "" ]; then
			kill -KILL $has_onvif
     		fi
   	fi
fi

# Mosquitto Service
if [ "$port_mqtt" != "" ]; then
	has_mqtt=$(getServicePID mqtt)
 	if [ "$service_mqtt_enabled" = "1" -a -f "$file_mqtt_enabled" ]; then
		if [ "$has_mqtt" = "" ]; then
			$sd_sbin/mosquitto -c $sd_etc/mosquitto/mosquitto.conf -p $port_mqtt -d
		fi
  	else
   		if [ "$has_mqtt" != "" ]; then
			kill -KILL $has_mqtt
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
			if [ ! -f "/tmp/sd/HACK/etc/config/passwd" ]; then
				cp /tmp/sd/HACK/etc/config/passwd $mountedon/passwd
  			fi
			if [ ! -f "/tmp/sd/HACK/etc/config/shadow" ]; then
				cp /tmp/sd/HACK/etc/config/shadow $mountedon/shadow
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
 [ "$dcim_cleanup_days" = 0 ] || find $sd_dcim/ -type d -mtime +$dcim_cleanup_days -exec rm -rf {} \;
fi

# Custom scripts run after services
[ -n "$custom_post_services_async" -a -x "$custom_post_services_async" ] && $custom_post_services_async &
[ -n "$custom_post_services" -a -x "$custom_post_services" ] && $custom_post_services

# Touch services.run and tell the system, that the script is alive
touch $services_run >/dev/null 2>&1

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

# Check, wether sd card is read only and if we have to reboot
if [ "$reboot_on_sd_readonly" = "1" ]; then
	force_sd_reboot=0
	touch $sd_path/is.ro 2>/dev/null || force_sd_reboot=1
	if [ "$force_sd_reboot" = "1" ]; then
		reboot
	else
		rm -f $sd_path/is.ro >/dev/null 2>&1
	fi
fi
