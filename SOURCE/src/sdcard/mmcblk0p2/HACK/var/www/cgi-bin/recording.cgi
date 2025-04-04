#!/bin/sh

root="/tmp/sd/HACK"

. ./common.cgi

DCIM="/mnt/DCIM/record"
DAYS=""

if [ -d "$DCIM" ]; then
	DAYS=`ls -1 $DCIM | sort -rn`
	
	if [ "$DAYS" = "" ]; then
		send_header application/json
		send_json available=true days=0
		exit
	fi
	
	days_count=`ls -1 $DCIM | wc -l`
	
	DAY=`parse_keyval '&' "$QUERY_STRING" day`
	FILE=`parse_keyval '&' "$QUERY_STRING" file`
	DELETE=`parse_keyval '&' "$QUERY_STRING" delete`
	TYPE=`parse_keyval '&' "$QUERY_STRING" type`
	
	if [ -z "$DAY" -a -z "$FILE" ]; then
		send_header application/json
		
		json="{\"available\":\"true\",\"days\":\"$days_count\",\"data\":{"
		data_json=""
		first=1
		
		for dir in $DAYS; do
			mp4_count=`ls -1 $DCIM/$dir/*.mp4 | wc -l`
			jpg_count=`ls -1 $DCIM/$dir/*.jpg | wc -l`
			day_json="\"datestamp\":\"$dir\",\"mp4Count\":\"$mp4_count\",\"jpgCount\":\"$jpg_count\""	

			if [ "$mp4_count" -gt 0 ]; then
				mp4_files=`ls -1 $DCIM/$dir/*.mp4 | sort -rn`
				mp4_json=""
				for file in $mp4_files; do
					basefile=`basename $file`
					if [ "$mp4_json" = "" ]; then
						mp4_json="\"$basefile\""
					else
						mp4_json="${mp4_json},\"$basefile\""
					fi
				done
				day_json="${day_json},\"mp4Files\":[$mp4_json]"
			else
				day_json="${day_json},\"mp4Files\":[]"
			fi

			if [ "$jpg_count" -gt 0 ]; then
				jpg_files=`ls -1 $DCIM/$dir/*.jpg | sort -rn`
				jpg_json=""
				for file in $jpg_files; do
					basefile=`basename $file`
					if [ "$jpg_json" = "" ]; then
						jpg_json="\"$basefile\""
					else
						jpg_json="${jpg_json},\"$basefile\""
					fi
				done
				day_json="${day_json},\"jpgFiles\":[$jpg_json]"
			else
				day_json="${day_json},\"jpgFiles\":[]"
			fi
			
		 	if [ "$first" = "1" ]; then
		 		first=0
		 		data_json="${data_json}\"day$dir\":{$day_json}"
		 	else
				data_json="${data_json},\"day$dir\":{$day_json}"
			fi
		done
		
		json="${json}${data_json}}}"
		
		echo $json
		exit
	fi
else
        send_header application/json
        send_json available=false
        exit
fi

if [ -n "$DAY" -a -n "$FILE" ]; then
	daypath=$(basename $DAY)
	filename=$(basename $FILE)
	fileext=$(echo "$FILE" | cut -d "." -f2)
	
	if [ "$DELETE" != "" ]; then
		case $TYPE in
			mp4|jpg)
				deletefiles="*.$TYPE"
				;;
			*)
				send_error 417 "Expectation failed" "Expected mp4 or jpg type"
				;;
		esac
		case $DELETE in
			all)
				deletepath="$DCIM"
				;;
			day)
				deletepath="$DCIM/$daypath"
				;;
			file)
				deletepath="$DCIM/$daypath"
				deletefiles="$filename"
				
				if [ "$fileext" != "$TYPE" ]; then
					send_error 403 "Forbidden" "You are not allowed to delete other files than $TYPE"
				fi
				;;
			*)
				send_error 417 "Expectation failed" "Expected all, day or file for parameter delete"
				;;
		esac
		find $deletepath -type f -name $deletefiles -exec rm -f {} \;
		if [ "$DELETE" = "all" ]; then
			rm -rf $deletepath >/dev/null 2>&1
			mkdir -p $deletepath
		else
			testdir=`ls -1 $deletepath`
			[ "$testdir" = "" ] && rmdir $deletepath >/dev/null 2>&1
		fi
		send_header application/json
		send_json delete=success		
		exit
	fi
	
	file="$DCIM/$daypath/$filename"
	filesize=`stat -c %s "$file"`
	
	[ "$daypath" = ".." -o "$daypath" = "." -o "$daypath" = "" ] && send_error 403 "Forbidden" "Invalid day specification"
	[ "$filename" = ".." -o "$filename" = "." -o "$filename" = "" ] && send_error 403 "Forbidden" "Invalid file specification"
	[ "$filesize" = 0 -o "$filesize" = "" ] && send_error 417 "Expectation failed" "File is empty"
	[ -f "$file" ] || send_error 404 "Not found" "File not found"
	
	if [ "$fileext" = "mp4" ]; then
		send_header video/mp4 $filesize "$filename"
	elif [ "$fileext" = "jpg" ]; then
		send_header image/jpeg $filesize "$filename"
	else
		send_error 403 "Forbidden" "Forbidden file extension"
	fi

	cat "$file"
else
	send_error 422 "Missing parameter" "Parameters day and file must be set"
fi
