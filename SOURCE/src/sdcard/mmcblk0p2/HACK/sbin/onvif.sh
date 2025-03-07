#!/bin/sh

[ -n "$hack" ] || exit 1

cd $sd_sbin

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

[ "$hd_width" = "auto" ] && hd_width=`cat $sys_config/_ht_hw_settings.ini | grep "^main_width" | awk '{print $3}'`
[ "$hd_height" = "auto" ] && hd_height=`cat $sys_config/_ht_hw_settings.ini | grep "^main_height" | awk '{print $3}'`
[ "$sd_width" = "auto" ] && sd_width=`cat $sys_config/_ht_hw_settings.ini | grep "^sub_width" | awk '{print $3}'`
[ "$sd_height" = "auto" ] && sd_height=`cat $sys_config/_ht_hw_settings.ini | grep "^sub_height" | awk '{print $3}'`

main_enc=`cat $sys_config/_ht_hw_settings.ini | grep "^main_enc_out_type" | awk '{print $3}'`
sub_enc=`cat $sys_config/_ht_hw_settings.ini | grep "^sub_enc_out_type" | awk '{print $3}'`

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

#if [ "$local_rtsp_only" = "1" ]; then
	HAS_RTSP=`netstat -tulpen | grep "LISTEN" | grep "^tcp" | awk '{print $4}' | grep "0.0.0.0:554"`
	
	if [ "$HAS_RTSP" = "" ]; then
		sleep 10
		exit 1
	fi
	
	ONVIF_PROFILE_0="--name \"HD\" --width $hd_width --height $hd_height --url rtsp://$IP_ADDR:554/main_ch --type $encoder_main"
#else
#	ONVIF_PROFILE_0="--name ${hd_width}x${hd_height} --width $hd_width --height $hd_height --url rtsp://$IP_ADDR:88/videoMain --type $encoder_main"
#
#	if [ "$sd_width" != "" -a "$sd_height" != "" ]; then
#		ONVIF_PROFILE_1="--name ${sd_width}x${sd_height} --width $sd_width --height $sd_height --url rtsp://$IP_ADDR:89/videoSub --type $encoder_sub"
#	fi
#fi

echo $ONVIF_PROFILE_0
echo $ONVIF_PROFILE_1

HARDWARE_ID=`cat $sys_config/wifimac.txt`

DEFAULT_OPTIONS="--no_fork --pid_file /var/run/onvif_srvd.pid --model \"$device_model\" --manufacturer \"$device_manufacturer\" --ifs wlan0 --port $port_onvif --scope onvif://www.onvif.org/Profile/S --version \"LSCamoflash $device_version\" --hardware-id \"$HARDWARE_ID\""
PTZ_OPTIONS=""

if [ "$device_ptz" = "1" ]; then
	PTZ_OPTIONS="--ptz --move_left \"eval $LEFT\" --move_right \"eval $RIGHT\" --move_up \"eval $UP\" --move_down \"eval $DOWN\""
fi

exec ./onvif_srvd $DEFAULT_OPTIONS $ONVIF_PROFILE_0 $ONVIF_PROFILE_1 $PTZ_OPTIONS
