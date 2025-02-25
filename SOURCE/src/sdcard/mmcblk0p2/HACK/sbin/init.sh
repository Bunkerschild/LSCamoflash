#!/bin/sh
echo -n "LSCamoflash init script is starting up at " && date

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

# Binding and setting up hostname config
if [ -n "$system_hostname" ]; then
        echo $system_hostname | $cut -d . -f1 > /tmp/hostname
        echo "127.0.0.1         localhost:localdomain           localhost" > /tmp/hosts
        echo "127.0.1.1         $system_hostname        $(echo $system_hostname | $cut -d . -f1)" >> /tmp/hosts
        $mount --bind /tmp/hostname /etc/sysconfig/HOSTNAME
        $mount --bind /tmp/hosts /etc/hosts
        $hostname $(echo $system_hostname | $cut -d . -f1)
fi

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
	echo -n "Disabling wifi scripts..."
	for i in `ls -1 $sys_usr_sbin/station_connect.sh $sys_usr_sbin/wifi_*`; do 
		mount --bind $sd_sbin/exit.sh $i
	done
	echo "done"
	
	# Copy wpa_supplicant to a safe execution position
	$cp -f $sys_usr_bin/wpa_supplicant $sd_bin/wifi_sup
	$cp -f $sys_usr_bin/wpa_cli $sd_bin/wifi_cli
	
	wpa_supplicant="$sd_bin/wifi_sup"

	# Disable wifi and networking tools
	echo -n "Disabling wifi and networking tools..."
	for i in $sys_sbin/udhcpc $sys_sbin/ifconfig $sys_usr_bin/wpa_supplicant $sys_usr_bin/wpa_cli; do 
		mount --bind $sd_sbin/exit.sh $i
	done
	echo "done"
	
	# Stop eventually running wpa_supplicant and udhcpc
	for i in wpa_supplicant udhcpc; do
		proc=$(pgrep -f "$i" || true)
		[ "$proc" != "" ] && $kill -KILL $proc 
	done
	
	# Setup network
	$wpa_supplicant -iwlan0 -D$wifi_driver -c /tmp/wpa_custom.conf > $sd_log/wpa_supplicant.log 2>&1 & $sleep 5
	if [ "$wifi_use_dhcp" = "1" -o "$wifi_ip_address" = "" ]; then
		$ifconfig lo up
		$ifconfig wlan0 0.0.0.0 up
		$udhcpc -x hostname:$(echo $system_hostname | $cut -d . -f1) \
		--interface=wlan0 --now --pidfile=/var/run/udhcpc-wlan0.pid \
		--script=$sd_sbin/udhcpc-hook.sh > $sd_log/udhcpc.log 2>&1 &
	else
		[ -n "$wifi_ip_address" -a -n "$wifi_netmask" -a -n "$wifi_broadcast" ] && $ifconfig wlan0 $wifi_ip_address netmask $wifi_netmask broadcast $wifi_broadcast
		[ -n "$wifi_ip_address" -a -n "$wifi_netmask" ] && $ifconfig wlan0 $wifi_ip_address netmask $wifi_netmask
		[ -n "$wifi_ip_address" -a -n "$wifi_broadcast" ] && $ifconfig wlan0 $wifi_ip_address broadcast $wifi_broadcast
		[ -n "$wifi_ip_address" ] && $ifconfig wlan0 $wifi_ip_address netmask $wifi_netmask broadcast $wifi_broadcast
		[ -n "$wifi_gateway" ] && $route add default gw $wifi_gateway
		echo -n "" > /etc/config/resolv.conf
		[ -n "$wifi_domainname" ] && echo "domainname $wifi_domainname" >> /etc/config/resolv.conf
		[ -n "$wifi_nameserver" ] && echo "nameserver $wifi_nameserver" >> /etc/config/resolv.conf
	fi
fi

# Breakout file
breakout_file="$sys_temp/hostapd.break"

# Loop device
export loop_device="/dev/loop0"

echo "Device name is: $system_hostname"
echo "Device MAC is: $device_mac"
echo "Device UID: $device_uid"
echo "Anyka IPC Checksum: $anyka_md5"

# Compare function
compare() {
	src="$1"
	dst="$2"
	
	[ "$dst" = "" ] && return 1
	
	echo -n "Comparing $src and $dst..."
	src_csum=`$md5sum "$src" | $grep "$src" | $awk '{print \$1}'`
	dst_csum=`$md5sum "$dst" | $grep "$dst" | $awk '{print \$1}'`
	
	if [ "$src_csum" = "$dst_csum" ]; then
		echo "identical"
		return 0
	fi

	echo "mismatch, update needed"
	return 1
}

# Create paths on sd, if not exist
echo "Creating directory structure"
for i in $sd_etc $sd_bin $sd_lib $sd_sbin $sd_backup $sd_www $sd_log $sd_patch $sd_overlay $sd_mnt $sd_crontabs; do
	$mkdir -p $i >/dev/null 2>&1 && echo " - $i"
done

# Swap configuration (disabled, because kernel does not support it, yet)
swap_file="$sd_overlay/swap.fil"
swap_space="64"

# Create swap file, if requested
if [ -n "$swap_space" -a "$swap_space" -gt 0 -a -n "$swap_file" ]; then
	if [ ! -f "$swap_file" ]; then
		echo "Generating $swap_space MB swap file in $swap_file"
		$dd if=/dev/zero of=$swap_file bs=1M count=$swap_space
		$mkswap $swap_file
	fi
	
	echo "Activating $swap_space MB swap file $swap_file"
	$swapon $swap_file
fi

overlay_dirs="bin sbin lib lib/modules usr/bin usr/sbin usr/share usr/lib usr/local usr/modules"

# Create overlay filesystem
if [ ! -f "$sd_overlay/fs.img" ]; then
	echo "Creating overlay filesystem"
	loop_device="/dev/loop$($losetup -a | $wc -l)"
	$dd if=/dev/zero of=$sd_overlay/fs.img bs=1k count=32768 && \
	$losetup $loop_device $sd_overlay/fs.img && \
	$mkfs_vfat $loop_device && \
	$mount $loop_device $sd_mnt || exit 1
	echo -n "Setting up overlay filesystem..."
	for i in $overlay_dirs; do
		$mkdir -p $sd_mnt/real/$i
		$mkdir -p $sd_mnt/$i
	done
	echo "done"
else
	echo -n "Mounting overlay filesystem..."
	loop_device="/dev/loop$($losetup -a | $wc -l)"
	$losetup $loop_device $sd_overlay/fs.img && \
	$mount $loop_device $sd_mnt && \
	echo "done" || exit 1
fi

# Prepare overlay filesystem
if [ -f "$sd_overlay/fs.img" ]; then
	echo -n "Preparing overlay filesystem..."
	for i in $overlay_dirs; do
		$mkdir -p $sd_mnt/real/$i
		$mkdir -p $sd_mnt/$i
		$mount -t tmpfs -o size=2K tmpfs $sd_mnt/$i
		$find /$i -maxdepth 1 -type f -exec $cp {} $sd_mnt/real/$i \;
		if [ "$i" != "bin" -a "$i" != "sbin" -a "$i" != "usr/bin" -a "$i" != "usr/sbin" ]; then
			$find /$i -maxdepth 1 -type l -exec $ln -sf $sd_mnt/{} $sd_mnt/real/$i \;
		fi
		$find $sd_mnt/real/$i -maxdepth 1 -type f -exec $ln -sf {} $sd_mnt/$i \;
	done
	for i in `$sd_mnt/real/bin/busybox --install 2>&1 | $cut -d : -f2 | $sed -e 's/\/usr//g'`; do 
		$ln -sf $sd_mnt/real/bin/busybox $sd_mnt/$i 
	done
	for i in `$busybox --install 2>&1 | $cut -d : -f2`; do 
		$ln -sf $busybox $sd_mnt/$i 
	done
	$find $sd_bin -maxdepth 1 -type f -exec $ln -sf {} $sd_mnt/bin \;
	$find $sd_sbin -maxdepth 1 -type f -not -name "*.sh" -exec $ln -sf {} $sd_mnt/sbin \;
	$find $sd_lib -maxdepth 1 -type f -exec $ln -sf {} $sd_mnt/lib \;
	$find $sd_lib -maxdepth 1 -type l -exec $ln -sf {} $sd_mnt/lib \;
	$find $sd_lib/pkgconfig -maxdepth 1 -type f -exec $ln -sf {} $sd_mnt/lib/pkgconfig \;
	for i in jmacs jpico jstar rjoe; do
		$ln -sf $sd_bin/joe $sd_mnt/bin/$i
	done
	$ln -sf $sd_share/joe $sd_mnt/usr/share
	$ln -sf $sd_share/aclocal $sd_mnt/usr/share
	echo "done"
fi

# Copy shadow and passwd files and clean them in case they were edited in windows
echo "Copying and linking shadow and passwd files to operating system"
for i in shadow passwd; do
	$cp $sd_config/$i $sys_config/$i
done

# Copy crontabs
echo -n "Copying crontabs from $sd_crontabs to $sys_crontabs..."
$mkdir -p $sys_crontabs >/dev/null 2>&1
$cp $sd_crontabs/* $sys_crontabs && echo "done" || echo "failed"

# Make a backup of the origin firmware files
if [ ! -e $sd_backup/root.tar ]; then
	echo "Creating backup of root-fs"
	$tar -cvpf $sd_backup/root.tar /bin /data /lib /sbin
fi
for i in etc usr var; do
	if [ ! -e $sd_backup/$i.tar ]; then
		echo "Creating backup of $i"
		$tar -cvpf $sd_backup/$i.tar /$i
	fi
done
if [ ! -e $sd_backup/filesystem.lst ]; then
	echo -n "Inventory of files, links and sockets..."
	$find / -type f -or -type l -or -type s > $sd_backup/filesystem.lst && echo "done" || echo "failed"
fi

# Check, whether anyka_ipc exists
if [ ! -e $sd_bin/anyka_ipc ]; then
	echo -n "Creating copy of firmwares anyka_ipc..." 
	$cp $sys_usr_bin/anyka_ipc $sd_bin && echo "done" || echo "failed"
fi
if [ -e $sd_bin/anyka_ipc ]; then
	compare $sys_usr_bin/anyka_ipc $sd_bin/anyka_ipc || $cp $sys_usr_bin/anyka_ipc $sd_bin 
fi

# Check, whether anyka_ipc_patched exists and if there are patches
if [ ! -e $sd_bin/anyka_ipc_patched -a -e $sd_bin/anyka_ipc ]; then
	anyka_checksum=`$md5sum -b $sd_bin/anyka_ipc`
	patch_file=`$find $sd_patch -type f -name "$anyka_checksum.ips.gz" | $awk '{print $1}'`
	
	if [ "$patch_file" != "" -a -f $patch_file ]; then
		$sd_sbin/apply_ips_patch.sh $patch_file $sd_bin/anyka_ipc $sd_bin/anyka_ipc_patched
	fi
fi

# Check, whether ssl exists
[ ! -d $sys_config/ssl ] && $mkdir -p $sys_config/ssl >/dev/null 2>&1
[ ! -f $sys_config/ssl/ca-bundle ] && $touch $sys_config/ssl/ca-bundle
echo -n "Linking ssl ca-bundle..."
$mount --bind $sd_config/ssl/ca-bundle $sys_config/ssl/ca-bundle && echo "done" || echo "failed"

# Check, whether joe exists
if [ ! -d $sys_config/joe ]; then
	echo -n "Creating and linking joe..."
	$mkdir -p $sys_config/joe >/dev/null 2>&1 && \
	$mount --bind $sd_config/joe $sys_config/joe && echo "done" || echo "failed"
fi

# Check, whether anyka_cfg.ini exists
if [ ! -e $sd_config/anyka_cfg.ini ]; then
	echo -n "Creating anyka_cfg.ini from factory_cfg.ini file..."
	$cp $sys_usr_local/factory_cfg.ini $sd_config/anyka_cfg.ini && echo "done" || echo "failed"
fi
if [ -e $sd_config/anyka_cfg.ini ]; then
	compare $sys_usr_local/factory_cfg.ini $sd_config/anyka_cfg.ini || $cp $sys_usr_local/factory_cfg.ini $sd_config/anyka_cfg.ini 
fi

# Check, whether _ht_hw_settings.ini exists
if [ ! -e $sd_config/_ht_hw_settings.ini ]; then
	echo -n "Creating _ht_hw_settings.ini file..."
	$cp $sys_config/_ht_hw_settings.ini $sd_config && echo "done" || echo "failed" 
fi
if [ -e $sd_config/_ht_hw_settings.ini ]; then
	compare $sys_config/_ht_hw_settings.ini $sd_config/_ht_hw_settings.ini || $cp $sys_config/_ht_hw_settings.ini $sd_config 
fi

# Check, whether _ht_sw_settings.ini exists
if [ ! -e $sd_config/_ht_sw_settings.ini ]; then
	echo -n "Creating _ht_sw_settings.ini file..."
	$cp $sys_config/_ht_sw_settings.ini $sd_config && echo "done" || echo "failed" 
fi
if [ -e $sd_config/_ht_sw_settings.ini ]; then
	compare $sys_config/_ht_sw_settings.ini $sd_config/_ht_sw_settings.ini || $cp $sys_config/_ht_sw_settings.ini $sd_config 
fi

# Check, whether libavssdkbeta.so exists
if [ ! -e $sd_lib/libavssdkbeta.so ]; then
	echo -n "Creating copy of libabsdkbeta.so file..."
	$cp $sys_usr_lib/libavssdkbeta.so $sd_lib && echo "done" || echo "failed"
fi
if [ -e $sd_lib/libavssdkbeta.so ]; then
	compare $sys_usr_lib/libavssdkbeta.so $sd_lib/libavssdkbeta.so || $cp $sys_usr_lib/libavssdkbeta.so $sd_lib 
fi

# Prepare and mount factory_cfg.ini
if [ -e $sd_config/anyka_cgi.ini ]; then
	echo -n "Updating anyka_cfg.ini file..."
	$sed -i -e 's/rtsp\ =\ 0/rtsp\ =\ 1/g' $sd_config/anyka_cfg.ini && \
	$sed -i -e 's/onvif\ =\ 0/onvif\ =\ 1/g' $sd_config/anyka_cfg.ini && \
	echo "done" || echo "failed"
	echo -n "Binding anyka_cfg.ini from sd card to $sys_usr_local/factory_cfg.ini file..."
	$mount --bind $sd_config/anyka_cfg.ini $sys_usr_local/factory_cfg.ini && echo "done" || echo "failed"
	echo -n "Copying anyka_cfg.ini from sd card to $sys_config..."
	$cp $sd_config/anyka_cfg.ini $sys_config/anyka_cfg.ini && echo "done" || echo "failed"
fi

# Check, whether a backup of tuya dbs exists
for i in $sys_config/tuya_enckey.db $sys_config/tuya_user.db $sys_config/tuya_user.db_bak; do
	if [ -e $i ]; then
		echo -n "Backing up $i file..."
		$cp $i $sd_config && echo "done" || echo "failed"
	fi
	if [ -e $i ]; then
		filename=`$basename $i`
		compare $i $sd_config/$filename || $cp $i $sd_config 
	fi
done

# Kill running telnetd and tcpsvd, if any
for i in telnetd tcpsvd; do
	proc=$($pgrep -f "$i" || true)
	if [ "$proc" != "" ]; then 
		echo -n "Killing $i with PID $proc..." 
		$kill -KILL $proc && echo "done" || echo "failed"
	fi
done

# Disable any kind of firmware update
for i in update_tmp.sh update_tmp_bak.sh update_tmp_ota.sh tf_update.sh; do
	echo -n "Disabling script $sys_usr_sbin/$i..."
	$mount --bind $sd_sbin/exit.sh $sys_usr_sbin/$i && echo "done" || echo "failed"
done

# Block Tuya Servers in case of offline mode
if [ "$use_offline_mode" != "" ]; then
	echo "OFFLINE MODE ENABLED"
	$mount --bind $sd_etc/hosts.offline /etc/hosts
fi

# Construct the anyka ipc wrapper
echo -n "Creating anyka_ipc_wrapper..."
echo "#!/bin/sh" > $sys_temp/anyka_ipc_wrapper.sh
echo "export hack=\"$sd_path/HACK\"" >> $sys_temp/anyka_ipc_wrapper.sh
echo "export hack_conf=\"\$hack/etc/hack.conf\"" >> $sys_temp/anyka_ipc_wrapper.sh
echo "export hack_custom_conf=\"\$hack/etc/hack_custom.conf\"" >> $sys_temp/anyka_ipc_wrapper.sh
echo "export commands_conf=\"\$hack/etc/commands.conf\"" >> $sys_temp/anyka_ipc_wrapper.sh
echo "export busybox_hack=\"$sd_bin/busybox\"" >> $sys_temp/anyka_ipc_wrapper.sh
echo "export busybox_firmware=\"$sys_bin/busybox\"" >> $sys_temp/anyka_ipc_wrapper.sh
echo "[ -f \"$hack_conf\" ] && . $hack_conf || exit 1" >> $sys_temp/anyka_ipc_wrapper.sh
echo "[ -f \"$hack_custom_conf\" ] && . $hack_custom_conf || exit 1" >> $sys_temp/anyka_ipc_wrapper.sh
echo "export busybox_hack=\"$sd_bin/busybox\"" >> $sys_temp/anyka_ipc_wrapper.sh
echo "[ -x \"$busybox_hack\" ] || exit 1" >> $sys_temp/anyka_ipc_wrapper.sh
echo "export busybox_firmware=\"$sys_bin/busybox\"" >> $sys_temp/anyka_ipc_wrapper.sh
echo "[ -x \"$busybox_firmware\" ] || exit 1" >> $sys_temp/anyka_ipc_wrapper.sh
echo "export busybox=\"$busybox_hack\"" >> $sys_temp/anyka_ipc_wrapper.sh
echo "[ -n \"$commands_conf\" ] && . $commands_conf || exit 1" >> $sys_temp/anyka_ipc_wrapper.sh
echo "export busybox=\"$busybox_hack\"" >> $sys_temp/anyka_ipc_wrapper.sh
echo "grep 'tilt_total_steps = 2200' $sys_temp/_ht_hw_settings.ini  || echo -e '\ntilt_total_steps = 2200' >> $sys_temp/_ht_hw_settings.ini" >> $sys_temp/anyka_ipc_wrapper.sh
echo "anyka_ipc_bin='$sd_bin/anyka_ipc'" >> $sys_temp/anyka_ipc_wrapper.sh
echo "if [ -x $sd_bin/anyka_ipc_patched ]; then" >> $sys_temp/anyka_ipc_wrapper.sh
echo "  export LD_LIBRARY_PATH=/lib:/usr/lib:$sd_lib" >> $sys_temp/anyka_ipc_wrapper.sh
if [ "$FORCE_STATE_LED_OFF" != "" -a "$FORCE_STATE_LED_OFF" != "0" ]; then
	echo " sleep $FORCE_STATE_LED_OFF && state_led.sh off &" >> $sys_temp/anyka_ipc_wrapper.sh
fi
if [ "$FORCE_AK39_FACTORY_ON_PATCHED" = "1" ]; then
	echo "  touch /tmp/_ak39_factory.ini" >> $sys_temp/anyka_ipc_wrapper.sh
fi
echo "  anyka_ipc_bin='$sd_bin/anyka_ipc_patched'" >> $sys_temp/anyka_ipc_wrapper.sh
echo "elif [ -x $sd_patch/$anyka_md5/bin/anyka_ipc_patched ]; then" >> $sys_temp/anyka_ipc_wrapper.sh
echo "  export LD_LIBRARY_PATH=/lib:/usr/lib:$sd_patch/$anyka_md5/lib" >> $sys_temp/anyka_ipc_wrapper.sh
if [ "$FORCE_STATE_LED_OFF" != "" -a "$FORCE_STATE_LED_OFF" != "0" ]; then
	echo " sleep $FORCE_STATE_LED_OFF && state_led.sh off &" >> $sys_temp/anyka_ipc_wrapper.sh
fi
if [  "$FORCE_AK39_FACTORY_ON_STATIC_PATCHED" = "1" ]; then
	echo "  touch /tmp/_ak39_factory.ini" >> $sys_temp/anyka_ipc_wrapper.sh
fi
echo "  anyka_ipc_bin='$sd_patch/$anyka_md5/bin/anyka_ipc_patched'" >> $sys_temp/anyka_ipc_wrapper.sh
echo "elif [ -x $sd_patch/$anyka_md5/bin/anyka_ipc ]; then" >> $sys_temp/anyka_ipc_wrapper.sh
echo "  export LD_LIBRARY_PATH=/lib:/usr/lib:$sd_patch/$anyka_md5/lib" >> $sys_temp/anyka_ipc_wrapper.sh
if [ "$FORCE_STATE_LED_OFF" != "" -a "$FORCE_STATE_LED_OFF" != "0" ]; then
	echo " sleep $FORCE_STATE_LED_OFF && state_led.sh off &" >> $sys_temp/anyka_ipc_wrapper.sh
fi
if [  "$FORCE_AK39_FACTORY_ON_STATIC" = "1" ]; then
	echo "  touch /tmp/_ak39_factory.ini" >> $sys_temp/anyka_ipc_wrapper.sh
fi
echo "  anyka_ipc_bin='$sd_patch/$anyka_md5/bin/anyka_ipc'" >> $sys_temp/anyka_ipc_wrapper.sh
echo "else" >> $sys_temp/anyka_ipc_wrapper.sh
echo "  export LD_LIBRARY_PATH=/lib:/usr/lib:$sd_lib" >> $sys_temp/anyka_ipc_wrapper.sh
if [ "$FORCE_STATE_LED_OFF" != "" -a "$FORCE_STATE_LED_OFF" != "0" ]; then
	echo " sleep $FORCE_STATE_LED_OFF && state_led.sh off &" >> $sys_temp/anyka_ipc_wrapper.sh
fi
if [  "$FORCE_AK39_FACTORY_ON_ORIGIN" = "1" ]; then
	echo "  touch /tmp/_ak39_factory.ini" >> $sys_temp/anyka_ipc_wrapper.sh
fi
echo "fi" >> $sys_temp/anyka_ipc_wrapper.sh
if [ "$local_rtsp_only" = "1" ]; then
	echo "proc=\$($pgrep -f \"anyka_rtsp.sh\" || true)" >> $sys_temp/anyka_ipc_wrapper.sh
	echo "if [ \"\$proc\" = \"\" ]; then" >> $sys_temp/anyka_ipc_wrapper.sh
	echo "  $sd_sbin/anyka_rtsp.sh &" >> $sys_temp/anyka_ipc_wrapper.sh
	echo "fi" >> $sys_temp/anyka_ipc_wrapper.sh
fi
echo "while [ -f \"/tmp/_ak39_startlock.ini\" ]; do" >> $sys_temp/anyka_ipc_wrapper.sh
echo "  sleep 3" >> $sys_temp/anyka_ipc_wrapper.sh
echo "done" >> $sys_temp/anyka_ipc_wrapper.sh
echo "\$anyka_ipc_bin 2>&1 | $sd_sbin/ipc_log_parser.sh $ipc_log" >> $sys_temp/anyka_ipc_wrapper.sh
echo "sleep 1" >> $sys_temp/anyka_ipc_wrapper.sh
echo "done"

# Prepare anyka ipc wrapper and configuration
echo -n "Enabling _ht_hw_settings.ini file..."
$cp $sys_usr_local/_ht_hw_settings.ini $sys_temp && \
$mount --bind $sys_temp/_ht_hw_settings.ini $sys_config/_ht_hw_settings.ini && \
echo "done" || echo "failed"
echo -n "Enabling anyka_ipc_wrapper..."
$chmod +x $sys_temp/anyka_ipc_wrapper.sh && \
$mount --bind $sys_temp/anyka_ipc_wrapper.sh $sys_usr_bin/anyka_ipc && \
echo "done" || echo "failed"

# Making the device silent, by disabling some disturbing sound files
touch $sys_temp/empty.mp3
$find $sys_usr_share -type f -name "8k16_*.mp3" -and -not -name "8k16_siren.mp3" -exec $mount --bind $sys_temp/empty.mp3 {} \;

# Binding sound files from SD
for a in `$find $sd_sound -type f -name "*.mp3" -not -name "8k16*"`; do
	i=`$basename $a`	
	echo -n "Binding soundfile $i.mp3..."
	[ -f "$sd_sound/$i" -a -f "$sys_usr_share/$i" ] && $mount --bind $sd_sound/$i $sys_usr_share/$i && echo "done" || echo "skipped"
done

# Binding profile
if [ -f "$sd_etc/profile" ]; then
	echo -n "Binding profile..."
	$mount --bind $sd_etc/profile $sys_etc/profile && echo "done" || echo "failed"
fi

# Custom scripts run after init
[ -n "$custom_pre_init_async" -a -x "$custom_pre_init_async" ] && $custom_pre_init_async &
[ -n "$custom_pre_init" -a -x "$custom_pre_init" ] && $custom_pre_init

# Run services.sh on SD card every 30 seconds
if [ -x "$sd_sbin/services.sh" ]; then
	# Custom scripts run once before services
	[ -n "$custom_pre_services_once_async" -a -x "$custom_pre_services_once_async" ] && $custom_pre_services_once_async &
	[ -n "$custom_pre_services_once" -a -x "$custom_pre_services_once" ] && $custom_pre_services_once
	echo "Running services.sh"
    	(while true; do if [ -f "$breakout_file" ]; then break; else $sd_sbin/services.sh; $sleep 30; fi; done ) < /dev/null >& /dev/null &
     	while [ ! -f $sys_temp/services.run ]; do
		$sleep 1
        done
	# Custom scripts run once after services
	[ -n "$custom_post_services_once_async" -a -x "$custom_post_services_once_async" ] && $custom_post_services_once_async &
	[ -n "$custom_post_services_once" -a -x "$custom_post_services_once" ] && $custom_post_once_services
else
	echo "No services.sh file. Exitting."
	exit 1
fi
