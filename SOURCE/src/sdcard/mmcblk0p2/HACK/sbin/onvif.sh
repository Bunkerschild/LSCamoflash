#!/bin/sh

[ -n "$hack" ] || exit 1

cd $sd_sbin

ONVIF_SNAP_USER="onvif"
ONVIF_SNAP_PASS="snap_human"

STEPS=15
MOTOR_CONTROL="$sd_sbin/ptz.sh"

LEFT="$MOTOR_CONTROL left $STEPS"
RIGHT="$MOTOR_CONTROL right $STEPS"
UP="$MOTOR_CONTROL up $STEPS"
DOWN="$MOTOR_CONTROL down $STEPS"

IP_ADDR=$(ip -4 addr show wlan0 | grep inet | awk '{print $2}' | cut -d'/' -f1)
while [[ -z $IP_ADDR ]]; do
    IP_ADDR=$(ip -4 addr show wlan0 | grep inet | awk '{print $2}' | cut -d'/' -f1)
done
echo $IP_ADDR

[ "$hd_width" = "auto" ] && hd_width=`cat $sys_config/_ht_hw_settings.ini 2>/dev/null | grep "^main_width" | awk '{print $3}' || echo "$device_width"`
[ "$hd_height" = "auto" ] && hd_height=`cat $sys_config/_ht_hw_settings.ini 2>/dev/null | grep "^main_height" | awk '{print $3}' || echo "$device_height"`
[ "$sd_width" = "auto" ] && sd_width=`cat $sys_config/_ht_hw_settings.ini 2>/dev/null | grep "^sub_width" | awk '{print $3}' || echo "640"`
[ "$sd_height" = "auto" ] && sd_height=`cat $sys_config/_ht_hw_settings.ini 2>/dev/null | grep "^sub_height" | awk '{print $3}' || echo "360"`

[ "$hd_width" = "" ] && hd_width="1920"
[ "$hd_height" = "" ] && hd_height="1080"

main_enc=`cat $sys_config/_ht_hw_settings.ini 2>/dev/null | grep "^main_enc_out_type" | awk '{print $3}' || echo "H264"`
sub_enc=`cat $sys_config/_ht_hw_settings.ini 2>/dev/null | grep "^sub_enc_out_type" | awk '{print $3}' || echo "H264"`

human_filter_enable=`cat $sys_config/_ht_sw_settings.ini 2>/dev/null | grep "^bool_human_filter_enable" | awk '{print $3}' || echo 0`

encoder_main="H264"
encoder_sub="H264"

# NO SUPPORT FOR H265 or MJPEG, yet :-(
#if [ "$main_enc" = "1" ]; then
#	encoder_main="MJPEG"
#elif [ "$main_enc" = "2" ]; then
#	encoder_main="H265"
#fi

#if [ "$sub_enc" = "1" ]; then
#	encoder_sub="MJPEG"
#elif [ "$sub_enc" = "2" ]; then
#	encoder_sub="H265"
#fi

ONVIF_PROFILE_0=""
ONVIF_PROFILE_1=""

[ -f "$sd_etc/onvif.users" ] && . $sd_etc/onvif.users
[ -z $ONVIF_USERNAME_0 ] || ONVIF_USERNAME_0="admin"
[ -z $ONVIF_PASSWORD_0 ] || ONVIF_PASSWORD_0="admin"
[ -z $ONVIF_USERNAME_1 ] || ONVIF_USERNAME_1="admin"
[ -z $ONVIF_PASSWORD_1 ] || ONVIF_PASSWORD_1="admin"

#if [ "$local_rtsp_only" = "1" ]; then
	HAS_RTSP=`netstat -tulpen | grep "LISTEN" | grep "^tcp" | awk '{print $4}' | grep "0.0.0.0:554"`
	
	if [ "$HAS_RTSP" = "" ]; then
		sleep 10
		exit 1
	fi
	
	ONVIF_PROFILE_0="--name HD --width $hd_width --height $hd_height --url rtsp://$IP_ADDR:554/main_ch --type $encoder_main --user $ONVIF_USERNAME_0 --password $ONVIF_PASSWORD_0"
#else
#	ONVIF_PROFILE_0="--name ${hd_width}x${hd_height} --width $hd_width --height $hd_height --url rtsp://$IP_ADDR:88/videoMain --type $encoder_main --user $ONVIF_USERNAME_0 --password $ONVIF_PASSWORD_0"
#
#	if [ "$sd_width" != "" -a "$sd_height" != "" ]; then
#		ONVIF_PROFILE_1="--name ${sd_width}x${sd_height} --width $sd_width --height $sd_height --url rtsp://$IP_ADDR:89/videoSub --type $encoder_sub --user $ONVIF_USERNAME_0 --password $ONVIF_PASSWORD_0"
#	fi
#fi

echo $ONVIF_PROFILE_0
echo $ONVIF_PROFILE_1

HARDWARE_ID=`cat $sys_config/wifimac.txt`

if [ "$human_filter_enable" = "1" ]; then
	SNAPURL="--snapurl http://$ONVIF_SNAP_USER:$ONVIF_SNAP_PASS@$IP_ADDR:$port_http/cgi-bin/snap_human.cgi"
else
	SNAPURL=""
fi

if [ "$device_has_ptz" = "1" ]; then
	LD_LIBRARY_PATH=$sd_lib:/lib:/usr/lib $sd_sbin/onvif_srvd \
	--no_fork --pid_file /var/run/onvif_srvd.pid --model "$device_model" --manufacturer "$device_manufacturer" --ifs wlan0 --port $port_onvif \
	--scope onvif://www.onvif.org/Profile/S --firmware_ver "LSCamoflash $device_version" --hardware_id "$HARDWARE_ID" --serial_num "$anyka_md5" \
	--ptz --move_left "eval $LEFT" --move_right "eval $RIGHT" --move_up "eval $UP" --move_down "eval $DOWN" $SNAPURL \
	$ONVIF_PROFILE_0 \
	$ONVIF_PROFILE_1
else
	LD_LIBRARY_PATH=$sd_lib:/lib:/usr/lib $sd_sbin/onvif_srvd \
	--no_fork --pid_file /var/run/onvif_srvd.pid --model "$device_model" --manufacturer "$device_manufacturer" --ifs wlan0 --port $port_onvif \
	--scope onvif://www.onvif.org/Profile/S --firmware_ver "LSCamoflash $device_version" --hardware_id "$HARDWARE_ID" --serial_num "$anyka_md5" $SNAPURL \
	$ONVIF_PROFILE_0 \
	$ONVIF_PROFILE_1
fi
