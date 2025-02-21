#!/bin/bash

# Zielverzeichnis für Downloads
TARGET_DIR="download"
mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR" || exit 1

# Liste der URLs
URLS=(
    "https://toolchains.bootlin.com/downloads/releases/toolchains/armv5-eabi/tarballs/armv5-eabi--uclibc--stable-2020.08-1.tar.bz2"
    "https://www.tcpdump.org/release/libpcap-1.10.4.tar.gz"
    "https://www.tcpdump.org/release/tcpdump-4.99.4.tar.gz"
    "https://www.openssl.org/source/openssl-3.0.12.tar.gz"
    "https://busybox.net/downloads/busybox-1.36.1.tar.bz2"
    "https://sourceforge.net/projects/joe-editor/files/JOE%20sources/joe-4.6/joe-4.6.tar.gz"
    "https://strace.io/files/6.9/strace-6.9.tar.xz"
    "http://www.zlib.net/zlib-1.3.1.tar.gz"
    "https://sourceware.org/ftp/elfutils/0.189/elfutils-0.189.tar.bz2"
    "https://www.lysator.liu.se/~nisse/misc/argp-standalone-1.3.tar.gz"
    "https://libbsd.freedesktop.org/releases/libbsd-0.11.7.tar.xz"
    "https://archive.hadrons.org/software/libmd/libmd-1.0.4.tar.xz"
    "http://ftp.de.debian.org/debian/pool/main/o/obstack/libobstack_1.1.orig.tar.gz"
    "https://www.sqlite.org/2024/sqlite-autoconf-3450200.tar.gz"
    "https://github.com/sqlcipher/sqlcipher/archive/refs/tags/v4.5.5.tar.gz"
    "https://curl.se/download/curl-8.7.1.tar.gz"
    "https://curl.se/ca/cacert.pem"
    "http://ftp.gnu.org/gnu/gdb/gdb-14.1.tar.xz"
    "https://gmplib.org/download/gmp/gmp-6.3.0.tar.xz"
    "https://www.mpfr.org/mpfr-4.2.1/mpfr-4.2.1.tar.xz"
    "https://raw.githubusercontent.com/coreutils/gnulib/master/lib/md5.h"
    "https://raw.githubusercontent.com/coreutils/gnulib/master/lib/sha1.h"
    "https://raw.githubusercontent.com/coreutils/gnulib/master/lib/md5.c"
    "https://raw.githubusercontent.com/coreutils/gnulib/master/lib/md5.h"
    "https://raw.githubusercontent.com/coreutils/gnulib/master/lib/sha1.c"
    "https://raw.githubusercontent.com/coreutils/gnulib/master/lib/sha1.h"
    "https://ftp.gnu.org/gnu/binutils/binutils-2.40.tar.xz"
    "http://ftp.gnu.org/gnu/coreutils/coreutils-9.4.tar.xz"
    "https://marlam.de/msmtp/releases/msmtp-1.8.24.tar.xz"
    "https://github.com/miniupnp/miniupnp/archive/refs/tags/miniupnpc_2_3_0.tar.gz"
)

# Dateien herunterladen
for url in "${URLS[@]}"; do
    echo "Lade herunter: $url"
    wget -c "$url"
done

echo "Alle Dateien wurden heruntergeladen."
