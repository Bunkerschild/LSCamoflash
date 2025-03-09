#!/bin/sh
busybox_firmware="/bin/busybox"
busybox_hack="/tmp/sd/HACK/bin/busybox"

. /tmp/sd/HACK/etc/hack.conf
. /tmp/sd/HACK/etc/hack_custom.conf
. /tmp/sd/HACK/etc/commands.conf

# Funktion zum Berechnen eines SHA256-HMAC-Signatur
hmac_sha256() {
    echo -n "$2" | $openssl dgst -sha256 -hmac "$1" | $awk '{print $2}' | $busybox tr '[:lower:]' '[:upper:]'
}

# Parameter aus den Umgebungsvariablen oder Standardeinstellungen beziehen
DEVICE_ID="$tuya_api_device_id"
CLIENT_ID="$tuya_api_client_id"
CLIENT_SECRET="$tuya_api_client_secret"
TUYA_BASE_URL="$tuya_api_url"
STREAM_TYPE="${STREAM_TYPE:-RTSP}"
RETURN_AS="${RETURN_AS:-json}"

# Zeitstempel generieren
T=$(($($date -u +%s%3N) - ($get_stream_url_tz_offset * 1000)))

# Curl vorbereiten
curlcmd="$curl"
[ "$get_stream_url_ignore_ssl" = "1" ] && curlcmd="$curlcmd --insecure"
[ "$get_stream_url_trace_log" != "" ] && curlcmd="$curlcmd --trace $get_stream_url_trace_log"

# Token anfordern
TOKEN_PATH="/v1.0/token?grant_type=1"
SIGN_STRING="${CLIENT_ID}${T}GET
e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855

$TOKEN_PATH"
SIGN=$(hmac_sha256 "$CLIENT_SECRET" "$SIGN_STRING")

TOKEN_RESPONSE=$($curlcmd -s -H "sign_method: HMAC-SHA256" -H "client_id: $CLIENT_ID" -H "t: $T" -H "mode: cors" -H "Content-Type: application/json" -H "sign: $SIGN" "${TUYA_BASE_URL}${TOKEN_PATH}")
ACCESS_TOKEN=$(echo "$TOKEN_RESPONSE" | $awk -F '"' '/"access_token":/{print $6}')

if [ -z "$ACCESS_TOKEN" ]; then
    echo "{\"error\": \"Failed to get token\"}"
    exit 1
fi

# Zeitstempel generieren
T2=$(($($date -u +%s%3N) - ($get_stream_url_tz_offset * 1000)))

# Stream-URL anfordern
STREAM_PATH="/v1.0/devices/$DEVICE_ID/stream/actions/allocate"
BODY="{\"type\":\"$STREAM_TYPE\"}"
ENCODED_BODY=$(echo -n "$BODY" | $sha256sum | $awk '{print $1}')
SIGN_STRING="${CLIENT_ID}${ACCESS_TOKEN}${T2}POST
$ENCODED_BODY

$STREAM_PATH"
SIGN=$(hmac_sha256 "$CLIENT_SECRET" "$SIGN_STRING")

STREAM_RESPONSE=$($curlcmd -s -X POST -H "sign_method: HMAC-SHA256" -H "client_id: $CLIENT_ID" -H "t: $T2" -H "mode: cors" -H "Content-Type: application/json" -H "sign: $SIGN" -H "access_token: $ACCESS_TOKEN" -d "$BODY" "${TUYA_BASE_URL}${STREAM_PATH}")
STREAM_URL=$(echo "$STREAM_RESPONSE" | $awk -F '"' '/"url":/{print $6}')

if [ -z "$STREAM_URL" ]; then
    echo "{\"error\": \"Failed to get stream URL\"}"
    exit 1
fi

# R??ckgabe entsprechend dem gew??nschten Format
case "$RETURN_AS" in
    text)
        echo "$STREAM_URL"
        ;;
    json)
        echo "{\"url\": \"$STREAM_URL\",\"type\": \"$STREAM_TYPE\", \"source\": \"REMOTE\"}"
        ;;
    *)
        echo "{\"error\": \"Invalid return format\"}"
        exit 1
        ;;
esac
