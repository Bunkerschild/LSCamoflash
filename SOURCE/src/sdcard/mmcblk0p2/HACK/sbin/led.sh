#! /bin/sh

led="/sys/class/leds/$1"
leds=`ls -1 /sys/class/leds | xargs`
mode=$2
brightness=1
brightnessoff=0
delay_off=$3
delay_on=$4

default_br=1
default_blk=100
default_led="/sys/class/leds/$(echo $leds | awk '{print $1}')"
PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin

usage()
{
	echo "Usage: $0 led($leds) mode(on|off|blink) off_time on_time"
	echo "Light on led: $0 $default_led on brightness"
	echo "Light off led: $0 $default_led off"
	echo "Flash led in 200ms: $0 $default_led blink 100 100"
	exit 3
}

light_on_led()
{
	echo ${brightness} > ${led}/brightness
}

light_off_led()
{
	light_on_led
	echo ${brightnessoff} > ${led}/brightness
}

blink_led()
{
	light=`cat ${led}/brightness`
	if [ "$light" -eq "$brightnessoff" ]
	then
		light_on_led 1
	fi
	
	echo "timer" > ${led}/trigger
	echo $delay_off > ${led}/delay_off
	echo $delay_on > ${led}/delay_on
}

#
# main:
#

if [ "$#" -lt "1" ]
then
	usage
	exit 2
fi

case "$mode" in
	on)
		if [ -z $brightness ]
		then
			brightness=$default_br
		fi
		light_on_led $brightness
		;;
	off)
		light_off_led
		;;
	blink)

		if [ -z $delay_on ]
		then
			delay_on=$default_blk
		fi

		if [ -z $delay_off ]
		then
			delay_off=$default_blk
		fi
		blink_led
		;;
	*)
		usage
		exit 1
		;;
esac

exit 0

