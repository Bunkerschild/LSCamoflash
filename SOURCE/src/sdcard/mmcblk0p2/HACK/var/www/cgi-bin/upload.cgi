#!/bin/sh
. /tmp/sd/HACK/etc/hack.conf

# POST upload format:
# -----------------------------29995809218093749221856446032^M
# Content-Disposition: form-data; name="file1"; filename="..."^M
# Content-Type: application/octet-stream^M
# ^M    <--------- headers end with empty line
# file contents
# file contents
# file contents
# ^M    <--------- extra empty line
# -----------------------------29995809218093749221856446032--^M

file=/tmp/$$-$RANDOM

CR=`printf '\r'`

# CGI output must start with at least empty line (or headers)
printf '\r\n'

IFS="$CR"
read -r delim_line
IFS=""

while read -r line; do
    #echo "got line: $line\r\n"
    fname=$(echo $line | awk -F'filename=' '{print $2}' | awk -F'"' '{print $2}')
    if [ "$fname" != "" ]; then
     filename=$fname
     #echo "GOT FILENAME: $filename"
    fi
    test x"$line" = x"" && break
    test x"$line" = x"$CR" && break
done

cat >"$file"

# We need to delete the tail of "\r\ndelim_line--\r\n"
tail_len=$((${#delim_line} + 6))

# Get and check file size
filesize=`stat -c"%s" "$file"`
test "$filesize" -lt "$tail_len" && exit 1

# Check that tail is correct
$sd_bin/busybox dd if="$file" skip=$((filesize - tail_len)) bs=1 count=1000 >"$file.tail" 2>/dev/null
printf "\r\n%s--\r\n" "$delim_line" >"$file.tail.expected"
if ! $sd_bin/busybox diff -q "$file.tail" "$file.tail.expected" >/dev/null; then
    printf "<html>\n<body>\nMalformed file upload"
    exit 1
fi
rm "$file.tail"
rm "$file.tail.expected"

# Truncate the file
$sd_bin/busybox dd of="$file" seek=$((filesize - tail_len)) bs=1 count=0 >/dev/null 2>/dev/null

# Move file
rm -f $sd_upload/$filename
mv $file $sd_upload/$filename

printf "<html>\n<body>\nFile $filename has been accepted"
