#!/bin/sh

[ -n "$hack" ] || exit 1

cd $sd_sbin

STEPS=15
MOTOR_CONTROL="$sd_sbin/motor.sh"

LEFT="$MOTOR_CONTROL $STEPS left "
RIGHT="$MOTOR_CONTROL $STEPS right"
UP="$MOTOR_CONTROL $STEPS up"
DOWN="$MOTOR_CONTROL $STEPS down"

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

camera_model=`cat $sd_config/anyka_cfg.ini | grep "^dev_name" | awk '{print $3}'`
camera_manufacturer="LSC"

ONVIF_PROFILE_0="--name HD --width $hd_width --height $hd_height --url rtsp://$IP_ADDR:88/videoMain --type $encoder_main"
ONVIF_PROFILE_1=""

if [ "$sd_width" != "" -a "$sd_height" != "" ]; then
	ONVIF_PROFILE_1="--name SD --width $sd_width --height $sd_height --url rtsp://$IP_ADDR:89/videoSub --type $encoder_sub"
fi

echo $ONVIF_PROFILE_0
echo $ONVIF_PROFILE_1

exec ./onvif_srvd --no_fork --pid_file /var/run/onvif_srvd.pid --model "$camera_model" --manufacturer "$camera_manufacturer" --ifs wlan0 --port $port_onvif --scope onvif://www.onvif.org/Profile/S $ONVIF_PROFILE_0 $ONVIF_PROFILE_1 \
        --ptz \
        --move_left "eval $LEFT" \
        --move_right "eval $RIGHT" \
        --move_up "eval $UP" \
        --move_down "eval $DOWN"