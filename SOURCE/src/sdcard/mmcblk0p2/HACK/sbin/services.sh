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

# Service enable files
ftp_enabled="$sys_temp/ftp_enabled.svc"
http_enabled="$sys_temp/http_enabled.svc"
telnet_enabled="$sys_temp/telnet_enabled.svc"
cron_enabled="$sys_temp/cron_enabled.svc"
onvif_enabled="$sys_temp/onvif_enabled.svc"
mqtt_enabled="$sys_temp/mqtt_enabled.svc"

# First start file
first_start="$sys_temp/services.fs"

# Services run file
services_run="$sys_temp/services.run"

# Anyka IPC Wrapper startlock file
anyka_startlock="$sys_temp/_ak39_startlock.ini"

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
		http)
			has_pid=`pgrep -f "busybox telnetd"`
			;;
		telnet)
			has_pid=`pgrep -f "busybox httpd"`
			;;
		cron)
			has_pid=`pgrep -f "crond"`
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
				touch $ftp_enabled
				[ -n "$pid" ] && echo "$sid is already running at pid $pid" || echo "$sid will start soon"
			elif [ "$cmd" = "stop" ]; then
				rm -f $ftp_enabled
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
				touch $cron_enabled
				[ -n "$pid" ] && echo "$sid is already running at pid $pid" || echo "$sid will start soon"
			elif [ "$cmd" = "stop" ]; then
				rm -f $cron_enabled
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
				touch $telnet_enabled
				[ -n "$pid" ] && echo "$sid is already running at pid $pid" || echo "$sid will start soon"
			elif [ "$cmd" = "stop" ]; then
				rm -f $telnet_enabled
				if [ -z "$pid" ]; then
					echo "$sid is already stopped"
				else
					kill -TERM $pid && echo "$sid stopped" || echo "Unable to stop $sid with TERM signal at pid $pid"
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
				touch $http_enabled
				[ -n "$pid" ] && echo "$sid is already running at pid $pid" || echo "$sid will start soon"
			elif [ "$cmd" = "stop" ]; then
				rm -f $http_enabled
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
				touch $onvif_enabled
				[ -n "$pid" ] && echo "$sid is already running at pid $pid" || echo "$sid will start soon"
			elif [ "$cmd" = "stop" ]; then
				rm -f $onvif_enabled
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
				touch $mqtt_enabled
				[ -n "$pid" ] && echo "$sid is already running at pid $pid" || echo "$sid will start soon"
			elif [ "$cmd" = "stop" ]; then
				rm -f $mqtt_enabled
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

# Initialize services enabled files on first start
if [ !-f "$first_start" ]; then
	touch $first_start
	touch $ftp_enabled
	touch $http_enabled
	touch $cron_enabled
	touch $telnet_enabled
	touch $onvif_enabled
	touch $mqtt_enabled
fi

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
 	if [ "$ftp_enabled" = "1" -a -f "$ftp_enabled" ]; then
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
	has_telnet=$(getServicePID telnet)
 	if [ "$telnet_enabled" = "1" -a -f "$telnet_enabled" ]; then
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
	has_http=$(getServicePID http)
 	if [ "$http_enabled" = "1" -a -f "$http_enabled" ]; then
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
if [ "$crond_enabled" = "1" -a -f "$cron_enabled" ]; then
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
 	if [ "$onvif_enabled" = "1" -a -f "$onvif_enabled" ]; then
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
 	if [ "$mqtt_enabled" = "1" -a -f "$mqtt_enabled" ]; then
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
 /tmp/sd/cgi-bin/cleanup.cgi > $cleanup_log
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
