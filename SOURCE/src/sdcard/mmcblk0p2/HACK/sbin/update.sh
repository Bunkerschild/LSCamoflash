#!/bin/sh

[ -n "$hack" -a -n "$update_url" -a -n "$device_uid" ] || exit 1

VERSION=$(cat /tmp/sd/HACK/etc/version.txt)
UPDATE_URL=$(echo $update_url | sed -e "s/%device_uid%/$device_uid/g")

echo -n "Updater is starting up at " && date

updatetgz="$sd_update/update.tgz"

# Extract version components
V_MAJOR=$(echo "$VERSION" | cut -d "." -f1)
V_MINOR=$(echo "$VERSION" | cut -d "." -f2)
V_REVISION=$(echo "$VERSION" | cut -d "." -f3)

if [ -d "$sd_update" ]; then
	echo "Installing update: $VERSION" >> $sd_log/update.log
	mounted=`cat /proc/mounts | grep /dev/mmcblk0p1 | grep $sys_mnt | awk '{print $2}'`
		
	[ "$mounted" = "$sys_mnt" ] || mounted=`mount /dev/mmcblk0p1 $sys_mnt >/dev/null 2>&1 && echo 1`
	[ -x "$sd_update/update-pre.sh" ] && $sd_update/update-pre.sh $VERSION >> $sd_log/update.log 2>&1
        [ -d $sd_update/mmcblk0p1 ] && $cp -av $sd_update/mmcblk0p1/* $sys_mnt/ >> $sd_log/update.log 2>&1
        [ -d $sd_update/mmcblk0p2 ] && $cp -av $sd_update/mmcblk0p2/* $sd_path/ >> $sd_log/update.log 2>&1
	[ -x "$sd_update/update-post.sh" ] && $sd_update/update-post.sh $VERSION >> $sd_log/update.log 2>&1
        [ "$mounted" = "1" ] && umount $sys_mnt >/dev/null 2>&1
 
        $rm -rf $sd_update
        $rm -rf $sd_overlay
	echo -n "Update installed: " >> $sd_log/update.log
	date >> $sd_log/update.log
        $mv $sd_log/update.log $sd_log/update-last.log
        exit
fi

agent="LSCamoflash/$VERSION;uid=$device_uid"
curl_cmd="$curl -A $agent"

[ "$update_ssl_ignore" = "1" ] && curl_cmd="$curl_cmd --insecure"

# Fetch latest version
UPDATE=$($curl_cmd "$UPDATE_URL/version.txt" 2>/dev/null)
if [ -z "$UPDATE" ]; then
    echo "Error: Unable to fetch update version."
    exit 1
fi

U_MAJOR=$(echo "$UPDATE" | cut -d "." -f1)
U_MINOR=$(echo "$UPDATE" | cut -d "." -f2)
U_REVISION=$(echo "$UPDATE" | cut -d "." -f3)

echo -n "Date: " > $sd_log/update.log
date >> $sd_log/update.log
echo "Current Version:  $VERSION" >> $sd_log/update.log
echo "Available Update: $UPDATE" >> $sd_log/update.log

# Compare versions
if [ "$U_MAJOR" -gt "$V_MAJOR" ] ||
   { [ "$U_MAJOR" -eq "$V_MAJOR" ] && [ "$U_MINOR" -gt "$V_MINOR" ]; } ||
   { [ "$U_MAJOR" -eq "$V_MAJOR" ] && [ "$U_MINOR" -eq "$V_MINOR" ] && [ "$U_REVISION" -gt "$V_REVISION" ]; }; then
    echo "Download Update: $UPDATE" >> $sd_log/update.log

        # Fetch latest version data
        $mkdir -p $sd_update
        HAVEDATA=$($curl_cmd -o $updatetgz "$UPDATE_URL/update-$UPDATE.tgz" >/dev/null 2>&1 && echo 1)

        if [ "$HAVEDATA" = "1" -a -f "$updatetgz" ]; then
                        $mkdir -p $sd_update
                        $tar -C $sd_update -xvzf $updatetgz >> $sd_log/update.log 2>&1
                        $rm -f $updatetgz
                        echo $UPDATE > $sd_etc/version.txt
                        echo "Update from $VERSION to $UPDATE extracted" >> $sd_log/update.log
                        [ -x "$sd_update/prepare.sh" ] && $sd_update/prepare.sh >> $sd_log/update.log
                        echo "Rebooting device" >> $sd_log/update.log
                        $touch /tmp/hostapd.reboot
        else
                echo "Error: Unable to fetch update data." >> $sd_log/update.log
                $rm -rf $sd_update
                $mv $sd_log/update.log $sd_log/update-error.log
                exit 2
        fi
else
    echo "No update needed. Already on the latest version." >> $sd_log/update.log
fi
