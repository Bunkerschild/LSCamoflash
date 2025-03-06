#!/bin/sh
root="/tmp/sd/HACK/"

busybox_firmware="/bin/busybox"
busybox_hack="$root/bin/busybox"

. $root/etc/hack.conf
. $root/etc/hack_custom.conf
. $root/etc/commands.conf

export DOCUMENT_ROOT="$sd_www"
export REQUEST_URI="$REQUEST_URI"
export BASE_FILENAME=`basename $REQUEST_URI | $cut -d ? -f1`
export BASE_DIRNAME=`dirname $REQUEST_URI`
[ "$BASE_DIRNAME" = "/" ] && BASE_DIRNAME=""
export BASE_EXTENSION=`echo "$BASE_FILENAME" | $rev | $cut -d . -f1 | $rev`
export SCRIPT_FILENAME="${DOCUMENT_ROOT}${BASE_DIRNAME}/${BASE_FILENAME}"
export REQUEST_METHOD="$REQUEST_METHOD"
export QUERY_STRING=`basename $REQUEST_URI | $cut -d ? -f2`
export CONTENT_TYPE="$CONTENT_TYPE"
export CONTENT_LENGTH="$CONTENT_LENGTH"
export SCRIPT_NAME="$BASE_FILENAME"
export GATEWAY_INTERFACE="CGI/1.1"
export SERVER_PROTOCOL="$SERVER_PROTOCOL"
export SERVER_SOFTWARE="busybox-httpd"
export REDIRECT_STATUS=1
export LD_LIBRARY_PATH=$root/lib:/usr/lib:/lib

if [ "$QUERY_STRING" = "$BASE_FILENAME" ]; then
        QUERY_STRING=""
fi

for segment in `echo "$BASE_DIRNAME" | $sed -i 's/\// /g'`; do
        if [ "$segment" = ".." -o "$segment" = "" ]; then
                echo "Status: 403 Forbidden"
                echo -e "Content-Type: text/plain\n"
                echo "Illegal directory request: $BASE_DIRNAME"
                exit 1
        fi
done

if [ ! -f "$SCRIPT_FILENAME" ]; then
        echo "Status: 404 Not Found"
        echo -e "Content-Type: text/plain\n"
        echo "No input file specified: $SCRIPT_FILENAME"
        exit 1
fi

case $BASE_EXTENSION in
        php)
                exec $sd_bin/php-cgi
        ;;
        py)
                exec $sd_bin/python "$SCRIPT_FILENAME"
        ;;
        cgi)
                if [ "$(dirname $SCRIPT_FILENAME)" != "$DOCUMENT_ROOT/cgi-bin" ]; then
                        echo "Status: 403 Forbidden"
                        echo -e "Content-Type: text/plain\n"
                        echo "Illegal script execution path: $BASE_DIRNAME"
                        exit 1
                fi

                exec $SCRIPT_FILENAME
        ;;
        *)
                echo "Status: 403 Forbidden"
                echo -e "Content-Type: text/plain\n"
                echo "Illegal extension request: $BASE_EXTENSION"
                exit 1
        ;;
esac
