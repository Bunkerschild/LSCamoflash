# Definiere Pfade
ROOT_DIR := $(shell pwd)
DOWNLOAD_DIR := $(ROOT_DIR)/download
TOOLCHAIN_DIR := $(ROOT_DIR)/toolchain
PACKAGES_DIR := $(ROOT_DIR)/packages
STAGING_DIR := $(ROOT_DIR)/staging
BUILD_DIR := $(ROOT_DIR)/build
SRC_DIR := $(ROOT_DIR)/src

# Hack paths
BUILD_HACK := $(BUILD_DIR)/mmcblk0p2/HACK
STAGE_HACK := $(STAGING_DIR)/tmp/sd/HACK

# SD card
SDCARD := /tmp/sd
SDROOT := $(SDCARD)/HACK

# Version
VERSION = $(shell cat version.txt)

# Definiere die Toolchain-Pfade
TOOLCHAIN_PATH := $(TOOLCHAIN_DIR)
PKG_CONFIG_PATH := $(TOOLCHAIN_PATH)/lib/pkgconfig:$(TOOLCHAIN_PATH)/share/pkgconfig
PATH := $(TOOLCHAIN_PATH)/bin:$(PATH)

# Definiere die Cross-Compiler Variablen
HOST := arm-buildroot-linux-uclibcgnueabi
C := $(TOOLCHAIN_PATH)/bin/$(HOST)-gcc
CC := $(TOOLCHAIN_PATH)/bin/$(HOST)-gcc
GCC := $(TOOLCHAIN_PATH)/bin/$(HOST)-g++
CXX := $(TOOLCHAIN_PATH)/bin/$(HOST)-g++
CPP := $(TOOLCHAIN_PATH)/bin/$(HOST)-cpp
AR := $(TOOLCHAIN_PATH)/bin/$(HOST)-ar
NM := $(TOOLCHAIN_PATH)/bin/$(HOST)-nm
LD := $(TOOLCHAIN_PATH)/bin/$(HOST)-ld
RANLIB := $(TOOLCHAIN_PATH)/bin/$(HOST)-ranlib
STRIP := $(TOOLCHAIN_PATH)/bin/$(HOST)-strip
CROSS_PREFIX := $(HOST)

# Definiere Paketversionen
LIBPCAP := libpcap-1.10.4
TCPDUMP := tcpdump-4.99.4
OPENSSL := openssl-3.0.12
ZLIB := zlib-1.3.1
JOE := joe-4.6
STRACE := strace-6.9
SQLITE3 := sqlite-autoconf-3450200
SQLCIPHER := sqlcipher-4.5.5
MSMTP := msmtp-1.8.24
MINIUPNPC := miniupnpc_2_3_0
CURL := curl-8.7.1
BUSYBOX := busybox-1.36.1
MOSQUITTO := mosquitto-2.0.20
CJSON := cJSON-1.7.18
GSOAP := gsoap-2.8
ONVIF := onvif_srvd-1.1
GMP := gmp-6.3.0
LIBGPG_ERROR := libgpg-error-1.51
LIBGCRYPT := libgcrypt-1.11.0
LIBILBC := libilbc-3.0.4
OPENJPEG := openjpeg-2.5.3
OPUS := opus-1.5.2
FFMPEG := ffmpeg-7.1
LIBEXECINFO := libexecinfo-1.1-rc1
RADARE2 := radare2-5.9.8
GLIBC := glibc-2.32
KERNEL := linux-4.4.192

# Exportiere die Variablen für alle Ziele
export TOOLCHAIN_PATH PKG_CONFIG_PATH PATH C CC GCC CXX CPP AR RANLIB CROSS_PREFIX

# Liste der zu ladenden Pakete
URLS := \
    https://toolchains.bootlin.com/downloads/releases/toolchains/armv5-eabi/tarballs/armv5-eabi--uclibc--stable-2020.08-1.tar.bz2 \
    https://www.kernel.org/pub/linux/kernel/v4.x/linux-4.4.192.tar.gz \
    https://www.tcpdump.org/release/$(LIBPCAP).tar.gz \
    https://www.tcpdump.org/release/$(TCPDUMP).tar.gz \
    https://www.openssl.org/source/$(OPENSSL).tar.gz \
    https://busybox.net/downloads/$(BUSYBOX).tar.bz2 \
    https://sourceforge.net/projects/joe-editor/files/JOE%20sources/$(JOE)/$(JOE).tar.gz \
    https://strace.io/files/6.9/$(STRACE).tar.xz \
    http://www.zlib.net/$(ZLIB).tar.gz \
    https://www.sqlite.org/2024/$(SQLITE3).tar.gz \
    https://github.com/sqlcipher/sqlcipher/archive/refs/tags/v4.5.5.tar.gz\#f=/$(SQLCIPHER).tar.gz \
    https://curl.se/download/$(CURL).tar.gz \
    https://curl.se/ca/cacert.pem \
    https://marlam.de/msmtp/releases/$(MSMTP).tar.xz \
    https://github.com/DaveGamble/cJSON/archive/refs/tags/v1.7.18.tar.gz\#f=/$(CJSON).tar.gz \
    https://github.com/eclipse-mosquitto/mosquitto/archive/refs/tags/v2.0.20.tar.gz\#f=/$(MOSQUITTO).tar.gz \
    https://sourceforge.net/projects/gsoap2/files/gsoap_2.8.137.zip/download\#f=/$(GSOAP).zip \
    https://github.com/KoynovStas/onvif_srvd/archive/refs/tags/v1.1.tar.gz\#f=/$(ONVIF).tar.gz \
    https://ffmpeg.org/releases/ffmpeg-7.1.tar.xz \
    https://gmplib.org/download/gmp/gmp-6.3.0.tar.xz \
    https://www.gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.51.tar.bz2 \
    https://www.gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.11.0.tar.bz2 \
    https://github.com/TimothyGu/libilbc/releases/download/v3.0.4/libilbc-3.0.4.tar.gz \
    https://github.com/uclouvain/openjpeg/archive/refs/tags/v2.5.3.tar.gz\#f=/$(OPENJPEG).tar.gz \
    https://downloads.xiph.org/releases/opus/opus-1.5.2.tar.gz \
    https://github.com/radareorg/radare2/archive/refs/tags/5.9.8.tar.gz\#f=/$(RADARE2).tar.gz \
    https://github.com/Bunkerschild/libexecinfo/archive/refs/tags/v1.1-rc1.tar.gz\#f=/$(LIBEXECINFO).tar.gz \
    https://ftp.gnu.org/gnu/glibc/$(GLIBC).tar.gz \
    https://github.com/miniupnp/miniupnp/archive/refs/tags/$(MINIUPNPC).tar.gz

# Ziele definieren
all: download toolchain packages staging build

download: $(DOWNLOAD_DIR) $(patsubst %,$(DOWNLOAD_DIR)/%,$(notdir $(URLS)))

$(TOOLCHAIN_DIR)/buildroot.config: $(TOOLCHAIN_DIR)
	@tar -xf $(DOWNLOAD_DIR)/armv5-eabi--uclibc--stable-2020.08-1.tar.bz2 -C $(TOOLCHAIN_DIR) --strip-components=1
	@touch $@
	
toolchain: $(TOOLCHAIN_DIR)/buildroot.config

$(PACKAGES_DIR)/cacert.pem: $(PACKAGES_DIR)
	@for file in $(DOWNLOAD_DIR)/*; do \
	  if [ "$$file" != "$(DOWNLOAD_DIR)/armv5-eabi--uclibc--stable-2020.08-1.tar.bz2" -a "$$file" != "$(DOWNLOAD_DIR)/cacert.pem" ]; then \
	  	cd $(PACKAGES_DIR); \
	  	unzip -o $$file 2>/dev/null || tar -xvf $$file -C $(PACKAGES_DIR) || echo "Skipping $$file"; \
	  fi; \
	done
	@touch $@
	
packages: $(PACKAGES_DIR)/cacert.pem

$(DOWNLOAD_DIR):
	@mkdir -p $@

$(TOOLCHAIN_DIR):
	@mkdir -p $@

$(PACKAGES_DIR):
	@mkdir -p $@

$(STAGING_DIR):
	@mkdir -p $@

$(BUILD_DIR):
	@mkdir -p $@

$(DOWNLOAD_DIR)/%:
	@echo "Downloading $(@F)..."
	@wget -c -O $@ $(filter %$(@F),$(URLS))
	
$(PACKAGES_DIR)/$(LIBPCAP)/config.status:
	@cd $(PACKAGES_DIR)/$(LIBPCAP); ./configure --host=$(HOST) --disable-shared CC=$(CC) --prefix=$(SDROOT) --sysconfdir=$(SDROOT)/etc/config --datarootdir=$(SDROOT)/usr/share
	
$(PACKAGES_DIR)/$(LIBPCAP)/libpcap.a: $(PACKAGES_DIR)/$(LIBPCAP)/config.status
	@make -C $(PACKAGES_DIR)/$(LIBPCAP) -j$(nproc)

$(STAGING_DIR)/$(SDROOT)/lib/libpcap.a: $(PACKAGES_DIR)/$(LIBPCAP)/libpcap.a
	@make -C $(PACKAGES_DIR)/$(LIBPCAP) install DESTDIR=$(STAGING_DIR)

libpcap: $(STAGING_DIR)/$(SDROOT)/lib/libpcap.a

libpcap-clean:
	@make -C $(PACKAGES_DIR)/$(LIBPCAP) clean distclean

$(PACKAGES_DIR)/$(TCPDUMP)/config.status: $(PACKAGES_DIR)/$(LIBPCAP)/libpcap.a
	@cd $(PACKAGES_DIR)/$(TCPDUMP); ./configure --host=$(HOST) CC=$(CC) --prefix=$(SDROOT) --sysconfdir=$(SDROOT)/etc/config --datarootdir=$(SDROOT)/usr/share
	
$(PACKAGES_DIR)/$(TCPDUMP)/tcpdump: $(PACKAGES_DIR)/$(TCPDUMP)/config.status
	@make -C $(PACKAGES_DIR)/$(TCPDUMP) -j$(nproc) LDFLAGS="--static"
	
$(STAGING_DIR)/$(SDROOT)/bin/tcpdump: $(PACKAGES_DIR)/$(TCPDUMP)/tcpdump
	@make -C $(PACKAGES_DIR)/$(TCPDUMP) install DESTDIR=$(STAGING_DIR)
	@$(STRIP) $(STAGING_DIR)/$(SDROOT)/bin/tcpdump

tcpdump: $(STAGING_DIR)/$(SDROOT)/bin/tcpdump

tcpdump-clean:
	@make -C $(PACKAGES_DIR)/$(TCPDUMP) clean distclean

$(PACKAGES_DIR)/$(OPENSSL)/configdata.pm:
	@cd $(PACKAGES_DIR)/$(OPENSSL); ./Configure linux-generic32 no-shared no-dso no-tests no-threads no-zlib no-async no-comp --prefix=$(SDROOT) --openssldir=$(SDROOT)/etc/config/ssl -static CC=$(CC) AR=$(AR) RANLIB=$(RANLIB)
	
$(PACKAGES_DIR)/$(OPENSSL)/apps/openssl: $(PACKAGES_DIR)/$(OPENSSL)/configdata.pm
	@make -C $(PACKAGES_DIR)/$(OPENSSL) -j$(nproc)
	
$(STAGING_DIR)/$(SDROOT)/bin/openssl: $(PACKAGES_DIR)/$(OPENSSL)/apps/openssl
	@make -C $(PACKAGES_DIR)/$(OPENSSL) install DESTDIR=$(STAGING_DIR)
	@$(STRIP) $(STAGING_DIR)/$(SDROOT)/bin/openssl
	
openssl: $(STAGING_DIR)/$(SDROOT)/bin/openssl

openssl-clean:
	@make -C $(PACKAGES_DIR)/$(OPENSSL) clean distclean

$(PACKAGES_DIR)/$(ZLIB)/configure.log:
	@cd $(PACKAGES_DIR)/$(ZLIB); ./configure --prefix=$(SDROOT)
	
$(PACKAGES_DIR)/$(ZLIB)/libz.a: $(PACKAGES_DIR)/$(ZLIB)/configure.log
	@make -C $(PACKAGES_DIR)/$(ZLIB) -j$(nproc)
	
$(STAGING_DIR)/$(SDROOT)/lib/libz.a: $(PACKAGES_DIR)/$(ZLIB)/libz.a
	@make -C $(PACKAGES_DIR)/$(ZLIB) install DESTDIR=$(STAGING_DIR)
	
zlib: $(STAGING_DIR)/$(SDROOT)/lib/libz.a

zlib-clean:
	@make -C $(PACKAGES_DIR)/$(ZLIB) clean distclean

$(PACKAGES_DIR)/$(JOE)/config.status:
	@cd $(PACKAGES_DIR)/$(JOE); ./configure --host=$(HOST) --prefix=$(SDROOT) --sysconfdir=$(SDROOT)/etc/config --datarootdir=$(SDROOT)/usr/share
	
$(PACKAGES_DIR)/$(JOE)/joe/joe: $(PACKAGES_DIR)/$(JOE)/config.status
	@make -C $(PACKAGES_DIR)/$(JOE) -j$(nproc)
	
$(STAGING_DIR)/$(SDROOT)/bin/joe: $(PACKAGES_DIR)/$(JOE)/joe/joe
	@make -C $(PACKAGES_DIR)/$(JOE) install DESTDIR=$(STAGING_DIR)
	@$(STRIP) $(STAGING_DIR)/$(SDROOT)/bin/joe
	
joe: $(STAGING_DIR)/$(SDROOT)/bin/joe

joe-clean:
	@make -C $(PACKAGES_DIR)/$(JOE) clean distclean

$(PACKAGES_DIR)/$(STRACE)/config.status:
	@cd $(PACKAGES_DIR)/$(STRACE); ./configure --host=$(HOST) --prefix=$(SDROOT) --sysconfdir=$(SDROOT)/etc/config --datarootdir=$(SDROOT)/usr/share
	
$(PACKAGES_DIR)/$(STRACE)/src/strace: $(PACKAGES_DIR)/$(STRACE)/config.status
	@make -C $(PACKAGES_DIR)/$(STRACE) -j$(nproc)
	
$(STAGING_DIR)/$(SDROOT)/bin/strace: $(PACKAGES_DIR)/$(STRACE)/src/strace
	@make -C $(PACKAGES_DIR)/$(STRACE) install DESTDIR=$(STAGING_DIR)
	@$(STRIP) $(STAGING_DIR)/$(SDROOT)/bin/strace
	
strace: $(STAGING_DIR)/$(SDROOT)/bin/strace

strace-clean:
	@make -C $(PACKAGES_DIR)/$(STRACE) clean distclean

$(PACKAGES_DIR)/$(SQLITE3)/config.status:
	@cd $(PACKAGES_DIR)/$(SQLITE3); ./configure --host=$(HOST) --prefix=$(SDROOT) --sysconfdir=$(SDROOT)/etc/config --datarootdir=$(SDROOT)/usr/share
	
$(PACKAGES_DIR)/$(SQLITE3)/sqlite3: $(PACKAGES_DIR)/$(SQLITE3)/config.status
	@make -C $(PACKAGES_DIR)/$(SQLITE3) -j$(nproc)
	
$(STAGING_DIR)/$(SDROOT)/bin/sqlite3: $(PACKAGES_DIR)/$(SQLITE3)/sqlite3
	@make -C $(PACKAGES_DIR)/$(SQLITE3) install DESTDIR=$(STAGING_DIR)
	@$(STRIP) $(STAGING_DIR)/$(SDROOT)/bin/sqlite3
	
sqlite3: $(STAGING_DIR)/$(SDROOT)/bin/sqlite3

sqlite3-clean:
	@make -C $(PACKAGES_DIR)/$(SQLITE3) clean distclean

$(PACKAGES_DIR)/$(SQLCIPHER)/config.status:
	@cd $(PACKAGES_DIR)/$(SQLCIPHER); ./configure --host=$(HOST) --prefix=$(SDROOT) --sysconfdir=$(SDROOT)/etc/config --datarootdir=$(SDROOT)/usr/share --with-sysroot=$(STAGING_DIR)/$(SDROOT) CFLAGS="-I$(STAGING_DIR)/$(SDROOT)/include -DSQLITE_HAS_CODEC -DSQLCIPHER_CRYPTO_OPENSSL" LDFLAGS="-L$(STAGING_DIR)/$(SDROOT)/lib --static -lssl -lcrypto"

$(PACKAGES_DIR)/$(SQLCIPHER)/sqlcipher: $(PACKAGES_DIR)/$(SQLCIPHER)/config.status
	@make -C $(PACKAGES_DIR)/$(SQLCIPHER) -j$(nproc)
	
$(STAGING_DIR)/$(SDROOT)/bin/sqlcipher: $(PACKAGES_DIR)/$(SQLCIPHER)/sqlcipher
	@make -C $(PACKAGES_DIR)/$(SQLCIPHER) install DESTDIR=$(STAGING_DIR)
	@$(STRIP) $(STAGING_DIR)/$(SDROOT)/bin/sqlcipher
	
sqlcipher: $(STAGING_DIR)/$(SDROOT)/bin/sqlcipher

sqlcipher-clean:
	@make -C $(PACKAGES_DIR)/$(SQLCIPHER) clean distclean

$(PACKAGES_DIR)/$(MSMTP)/config.status:
	@cd $(PACKAGES_DIR)/$(MSMTP); ./configure --host=$(HOST) --prefix=$(SDROOT) --sysconfdir=$(SDROOT)/etc/config --datarootdir=$(SDROOT)/usr/share

$(PACKAGES_DIR)/$(MSMTP)/src/msmtp: $(PACKAGES_DIR)/$(MSMTP)/config.status
	@make -C $(PACKAGES_DIR)/$(MSMTP) -j$(nproc)
	
$(STAGING_DIR)/$(SDROOT)/bin/msmtp: $(PACKAGES_DIR)/$(MSMTP)/src/msmtp
	@make -C $(PACKAGES_DIR)/$(MSMTP) install DESTDIR=$(STAGING_DIR)
	@$(STRIP) $(STAGING_DIR)/$(SDROOT)/bin/msmtp
	
msmtp: $(STAGING_DIR)/$(SDROOT)/bin/msmtp

msmtp-clean:
	@make -C $(PACKAGES_DIR)/$(MSMTP) clean distclean

$(PACKAGES_DIR)/miniupnp-$(MINIUPNPC)/miniupnpc/build/upnpc-static:
	@INSTALLPREFIX=$(SDROOT) make -C $(PACKAGES_DIR)/miniupnp-$(MINIUPNPC)/miniupnpc -j$(nproc) 
	
$(STAGING_DIR)/$(SDROOT)/bin/upnpc-static: $(PACKAGES_DIR)/miniupnp-$(MINIUPNPC)/miniupnpc/build/upnpc-static
	@make -C $(PACKAGES_DIR)/miniupnp-$(MINIUPNPC)/miniupnpc install-static DESTDIR=$(STAGING_DIR)/$(SDROOT) INSTALLDIRINC=$(STAGING_DIR)/$(SDROOT)/include INSTALLDIRLIB=$(STAGING_DIR)/$(SDROOT)/lib INSTALLDIRBIN=$(STAGING_DIR)/$(SDROOT)/bin
	@cp $(PACKAGES_DIR)/miniupnp-$(MINIUPNPC)/miniupnpc/build/upnpc-static $(STAGING_DIR)/$(SDROOT)/bin
	@$(STRIP) $(STAGING_DIR)/$(SDROOT)/bin/upnpc-static
	
miniupnpc: $(STAGING_DIR)/$(SDROOT)/bin/upnpc-static

miniupnpc-clean:
	@make -C $(PACKAGES_DIR)/$(MINIUPNPC) clean

$(PACKAGES_DIR)/$(CURL)/config.status:
	@cd $(PACKAGES_DIR)/$(CURL); ./configure --host=$(HOST) --prefix=$(SDROOT) --sysconfdir=$(SDROOT)/etc/config --datarootdir=$(SDROOT)/usr/share --disable-shared --enable-static --with-ssl=$(STAGING_DIR)/$(SDROOT) --with-zlib --disable-ldap --enable-rtsp --disable-dict --enable-file --enable-telnet --enable-tftp --disable-pop3 --disable-imap --disable-smtp --disable-gopher --enable-ftp --enable-hsts --enable-headers-api --enable-websockets --with-ca-path=$(SDROOT)/etc/config/ssl --with-ca-bundle=$(SDROOT)/etc/config/ssl/ca-bundle --with-nghttp2 --enable-mqtt --enable-unix-sockets --enable-cookies --enable-socketpair --enable-http-auth --enable-bearer-auth --enable-digest-auth --enable-negotiate-auth --enable-verbose --disable-docs --enable-dnsshuffle --enable-doh --enable-mime --enable-bindlocal --enable-form-api --enable-dateparse --enable-netrc --enable-progress-meter --enable-get-easy-options --disable-manual LDFLAGS="-L$(STAGING_DIR)/$(SDROOT)/lib --static -lssl -lcrypto" CFLAGS="-I$(STAGING_DIR)/$(SDROOT)/include"

$(PACKAGES_DIR)/$(CURL)/src/curl: $(PACKAGES_DIR)/$(CURL)/config.status
	@make -C $(PACKAGES_DIR)/$(CURL) -j$(nproc)
	
$(STAGING_DIR)/$(SDROOT)/bin/curl: $(PACKAGES_DIR)/$(CURL)/src/curl
	@make -C $(PACKAGES_DIR)/$(CURL) install DESTDIR=$(STAGING_DIR)
	@$(STRIP) $(STAGING_DIR)/$(SDROOT)/bin/curl
	
$(STAGING_DIR)/$(SDROOT)/etc/config/ssl/ca-bundle:
	@cp $(DOWNLOAD_DIR)/cacert.pem $(STAGING_DIR)/$(SDROOT)/etc/config/ssl/ca-bundle
	
curl: $(STAGING_DIR)/$(SDROOT)/bin/curl $(STAGING_DIR)/$(SDROOT)/etc/config/ssl/ca-bundle

curl-clean:
	@make -C $(PACKAGES_DIR)/$(CURL) clean distclean

$(PACKAGES_DIR)/$(BUSYBOX)/.config:
	@make -C $(PACKAGES_DIR)/$(BUSYBOX) defconfig
	@cp busybox-config $(PACKAGES_DIR)/$(BUSYBOX)/.config

$(PACKAGES_DIR)/$(BUSYBOX)/busybox: $(PACKAGES_DIR)/$(BUSYBOX)/.config
	@make -C $(PACKAGES_DIR)/$(BUSYBOX) -j$(nproc)
	
$(STAGING_DIR)/$(SDROOT)/bin/busybox: $(PACKAGES_DIR)/$(BUSYBOX)/busybox
	@make -C $(PACKAGES_DIR)/$(BUSYBOX) install
	@cp $(PACKAGES_DIR)/$(BUSYBOX)/_install/bin/busybox $(STAGING_DIR)/$(SDROOT)/bin
	@$(STRIP) $(STAGING_DIR)/$(SDROOT)/bin/busybox
	
busybox: $(STAGING_DIR)/$(SDROOT)/bin/busybox

busybox-clean:
	@make -C $(PACKAGES_DIR)/$(BUSYBOX) clean distclean

$(PACKAGES_DIR)/$(CJSON)/cjson-config:
	@cp cjson-config $(PACKAGES_DIR)/$(CJSON)/CMakeLists.txt
	@cp cjson-config $(PACKAGES_DIR)/$(CJSON)

$(PACKAGES_DIR)/$(CJSON)/build/Makefile: $(PACKAGES_DIR)/$(CJSON)/cjson-config
	@mkdir -p $(PACKAGES_DIR)/$(CJSON)/build
	@cd $(PACKAGES_DIR)/$(CJSON)/build; cmake -DCMAKE_PREFIX_PATH=/ ..

$(PACKAGES_DIR)/$(CJSON)/build/libcjson.a: $(PACKAGES_DIR)/$(CJSON)/build/Makefile
	@make -C $(PACKAGES_DIR)/$(CJSON)/build -j$(nproc)
	@touch $@

$(STAGING_DIR)/$(SDROOT)/usr/local/lib/libcjson.a: $(PACKAGES_DIR)/$(CJSON)/build/libcjson.a
	@make -C $(PACKAGES_DIR)/$(CJSON)/build install DESTDIR=$(STAGING_DIR)/$(SDROOT)
	@touch $@

cjson: $(STAGING_DIR)/$(SDROOT)/usr/local/lib/libcjson.a

cjson-clean:
	@rm -rf $(PACKAGES_DIR)/$(CJSON)/build
	@rm $(PACKAGES_DIR)/$(CJSON)/cjson-config

$(PACKAGES_DIR)/$(MOSQUITTO)/mosquitto-config: $(STAGING_DIR)/$(SDROOT)/bin/openssl $(STAGING_DIR)/$(SDROOT)/lib/libz.a
	@cp mosquitto-config $(PACKAGES_DIR)/$(MOSQUITTO)/config.mk
	@cp mosquitto-config $(PACKAGES_DIR)/$(MOSQUITTO)/mosquitto-config

$(PACKAGES_DIR)/$(MOSQUITTO)/build/Makefile: $(PACKAGES_DIR)/$(MOSQUITTO)/mosquitto-config
	@mkdir -p $(PACKAGES_DIR)/$(MOSQUITTO)/build
	@mv $(PACKAGES_DIR)/$(MOSQUITTO)/man $(PACKAGES_DIR)/$(MOSQUITTO)/man.orig
	@mkdir $(PACKAGES_DIR)/$(MOSQUITTO)/man
	@touch $(PACKAGES_DIR)/$(MOSQUITTO)/man/CMakeLists.txt
	@cd $(PACKAGES_DIR)/$(MOSQUITTO)/build; cmake .. -DCMAKE_INSTALL_PREFIX=/ -DWITH_STATIC_LIBRARIES=ON -DOPENSSL_ROOT_DIR=$(PACKAGES_DIR)/$(OPENSSL) -DBUILD_SHARED_LIBS=OFF -DWITH_DOCS=no -DWITH_DESTDIR=$(STAGING_DIR)/$(SDROOT)

$(PACKAGES_DIR)/$(MOSQUITTO)/build/src/mosquitto: $(PACKAGES_DIR)/$(MOSQUITTO)/build/Makefile
	@make -C $(PACKAGES_DIR)/$(MOSQUITTO)/build -j$(nproc)
	@touch $@
	
$(STAGING_DIR)/$(SDROOT)/usr/sbin/mosquitto: $(PACKAGES_DIR)/$(MOSQUITTO)/build/src/mosquitto
	@make -C $(PACKAGES_DIR)/$(MOSQUITTO)/build DESTDIR=$(STAGING_DIR)/$(SDROOT) WITH_DOCS=no install
	@touch $@
	
mosquitto: $(STAGING_DIR)/$(SDROOT)/usr/sbin/mosquitto

mosquitto-clean:
	@rm -rf $(PACKAGES_DIR)/$(MOSQUITTO)/build
	@rm $(PACKAGES_DIR)/$(MOSQUITTO)/mosquitto-config

$(PACKAGES_DIR)/$(GSOAP)/config.status:
	@cd $(PACKAGES_DIR)/$(GSOAP); ac_cv_func_malloc_0_nonnull=yes ./configure --host=$(HOST) --prefix=$(SDROOT) --sysconfdir=$(SDROOT)/etc/config --datarootdir=$(SDROOT)/usr/share --disable-shared --enable-static --with-ssl=$(STAGING_DIR)/$(SDROOT) --with-zlib=$(STAGING_DIR)/$(SDROOT) --with-openssl=$(STAGING_DIR)/$(SDROOT) LDFLAGS="-L$(STAGING_DIR)/$(SDROOT)/lib --static -lssl -lcrypto" CFLAGS="-I$(STAGING_DIR)/$(SDROOT)/include"
	@echo -e "all:\n\ninstall:\n" > $(PACKAGES_DIR)/$(GSOAP)/gsoap/wsdl/Makefile

$(PACKAGES_DIR)/$(GSOAP)/gsoap/libgsoap.a: $(PACKAGES_DIR)/$(GSOAP)/config.status
	@make -C $(PACKAGES_DIR)/$(GSOAP) -j$(nproc)
	
$(STAGING_DIR)/$(SDROOT)/lib/libgsoap.a: $(PACKAGES_DIR)/$(GSOAP)/gsoap/libgsoap.a
	@make -C $(PACKAGES_DIR)/$(GSOAP) install DESTDIR=$(STAGING_DIR)
		
gsoap: $(STAGING_DIR)/$(SDROOT)/lib/libgsoap.a

gsoap-clean:
	@make -C $(PACKAGES_DIR)/$(GSOAP) clean distclean

$(PACKAGES_DIR)/$(ONVIF)/Makefile.new:
	@cp onvif-makefile $(PACKAGES_DIR)/$(ONVIF)/Makefile.new
	@cp $(PACKAGES_DIR)/$(ONVIF)/Makefile $(PACKAGES_DIR)/$(ONVIF)/Makefile.old
	@cp onvif-makefile $(PACKAGES_DIR)/$(ONVIF)/Makefile
	@touch $@

$(PACKAGES_DIR)/$(ONVIF)/onvif_srvd: $(PACKAGES_DIR)/$(ONVIF)/Makefile.new
	@make -C $(PACKAGES_DIR)/$(ONVIF) -j$(nproc) release
	@touch $@

$(STAGING_DIR)/$(SDROOT)/sbin/onvif_srvd: $(PACKAGES_DIR)/$(ONVIF)/onvif_srvd
	@mkdir -p $(STAGING_DIR)/$(SDROOT)/sbin/ || true
	@cp $(PACKAGES_DIR)/$(ONVIF)/onvif_srvd $@
	@touch $@

onvif: $(STAGING_DIR)/$(SDROOT)/sbin/onvif_srvd

onvif-clean:
	@rm -rf $(PACKAGES_DIR)/$(ONVIF)/build
	@rm $(PACKAGES_DIR)/$(ONVIF)/onvif-config

$(PACKAGES_DIR)/$(LIBGPG_ERROR)/Makefile:
	@ln -sf $(PACKAGES_DIR)/$(LIBGPG_ERROR)/src/syscfg/lock-obj-pub.arm-unknown-linux-gnueabi.h $(PACKAGES_DIR)/$(LIBGPG_ERROR)/src/syscfg/lock-obj-pub.linux-uclibcgnueabi.h
	@cd $(PACKAGES_DIR)/$(LIBGPG_ERROR); ./configure --prefix=$(SDROOT) --enable-static --with-gnu-ld --host=$(HOST) --disable-nls \
	CFLAGS="-I$(STAGING_DIR)/$(SDROOT)/include -I$(STAGING_DIR)/$(SDROOT)/usr/include" LDFLAGS="-L$(STAGING_DIR)/$(SDROOT)/lib -L$(STAGING_DIR)/$(SDROOT)/usr/lib"
	
$(PACKAGES_DIR)/$(LIBGPG_ERROR)/src/libgpg-error.la: $(PACKAGES_DIR)/$(LIBGPG_ERROR)/Makefile
	@make -C $(PACKAGES_DIR)/$(LIBGPG_ERROR) -j$(nproc)
	
$(STAGING_DIR)/$(SDROOT)/lib/libgpg-error.la: $(PACKAGES_DIR)/$(LIBGPG_ERROR)/src/libgpg-error.la
	@cp $(PACKAGES_DIR)/$(LIBGPG_ERROR)/src/gpg-error-config $(STAGING_DIR)/$(SDROOT)/bin
	@sed -i -e "s|prefix=$(SDROOT)|prefix=$(STAGING_DIR)/$(SDROOT)|g" $(STAGING_DIR)/$(SDROOT)/bin/gpg-error-config
	@make -C $(PACKAGES_DIR)/$(LIBGPG_ERROR) install DESTDIR=$(STAGING_DIR)
	
libgpg-error: $(STAGING_DIR)/$(SDROOT)/lib/libgpg-error.la

libgpg-error-clean:
	@make -C $(PACKAGES_DIR)/$(LIBGPG_ERROR) clean distclean

$(PACKAGES_DIR)/$(LIBGCRYPT)/Makefile:
	@cd $(PACKAGES_DIR)/$(LIBGCRYPT); ./configure --prefix=$(SDROOT) --enable-static --enable-cxx --with-gnu-ld --host=$(HOST) --disable-asm \
	 --disable-jent-support --disable-padlock-support --disable-aesni-support --disable-shaext-support --disable-pclmul-support --disable-sse41-support \
	 --disable-drng-support --disable-avx-support --disable-avx2-support --disable-avx512-support --disable-gfni-support --disable-sve-support --disable-sve2-support --disable-ppc-crypto-support \
 	 --disable-doc --disable-optimization --disable-amd64-as-feature-detection --disable-instrumentation-munging --disable-O-flag-munging --enable-static \
	 --with-libgpg-error-prefix=$(STAGING_DIR)/$(SDROOT) CFLAGS="-I$(STAGING_DIR)/$(SDROOT)/include -I$(STAGING_DIR)/$(SDROOT)/usr/include" LDFLAGS="-L$(STAGING_DIR)/$(SDROOT)/lib -L$(STAGING_DIR)/$(SDROOT)/usr/lib -lgpg-error"
	
$(PACKAGES_DIR)/$(LIBGCRYPT)/src/libgcrypt.la: $(PACKAGES_DIR)/$(LIBGCRYPT)/Makefile
	@make -C $(PACKAGES_DIR)/$(LIBGCRYPT) -j$(nproc)
	
$(STAGING_DIR)/$(SDROOT)/lib/libgcrypt.la: $(PACKAGES_DIR)/$(LIBGCRYPT)/src/libgcrypt.la
	@make -C $(PACKAGES_DIR)/$(LIBGCRYPT) install DESTDIR=$(STAGING_DIR)
	
libgcrypt: $(STAGING_DIR)/$(SDROOT)/lib/libgcrypt.la

libgcrypt-clean:
	@make -C $(PACKAGES_DIR)/$(LIBGCRYPT) clean distclean

$(PACKAGES_DIR)/$(GMP)/Makefile:
	@cd $(PACKAGES_DIR)/$(GMP); ./configure --prefix=$(SDROOT) --enable-static --enable-cxx --with-gnu-ld --host=$(HOST)
	
$(PACKAGES_DIR)/$(GMP)/libgmp.la: $(PACKAGES_DIR)/$(GMP)/Makefile
	@make -C $(PACKAGES_DIR)/$(GMP) -j$(nproc)
	
$(STAGING_DIR)/$(SDROOT)/lib/libgmp.la: $(PACKAGES_DIR)/$(GMP)/libgmp.la
	@make -C $(PACKAGES_DIR)/$(GMP) install DESTDIR=$(STAGING_DIR)
	
gmp: $(STAGING_DIR)/$(SDROOT)/lib/libgmp.la

gmp-clean:
	@make -C $(PACKAGES_DIR)/$(GMP) clean distclean

$(PACKAGES_DIR)/$(LIBILBC)/build-shared/Makefile:
	@mkdir -p $(PACKAGES_DIR)/$(LIBILBC)/build-shared
	@cd $(PACKAGES_DIR)/$(LIBILBC)/build-shared; cmake .. -DBUILD_SHARED_LIBS=on -DCMAKE_INSTALL_PREFIX=$(STAGING_DIR)/$(SDROOT)
		
$(PACKAGES_DIR)/$(LIBILBC)/build-static/Makefile:
	@mkdir -p $(PACKAGES_DIR)/$(LIBILBC)/build-static
	@cd $(PACKAGES_DIR)/$(LIBILBC)/build-static; cmake .. -DBUILD_SHARED_LIBS=off -DCMAKE_INSTALL_PREFIX=$(STAGING_DIR)/$(SDROOT)
		
$(PACKAGES_DIR)/$(LIBILBC)/build-shared/libilbc.so: $(PACKAGES_DIR)/$(LIBILBC)/build-shared/Makefile
	@make -C $(PACKAGES_DIR)/$(LIBILBC)/build-shared -j$(nproc)
	
$(PACKAGES_DIR)/$(LIBILBC)/build-static/libilbc.a: $(PACKAGES_DIR)/$(LIBILBC)/build-static/Makefile
	@make -C $(PACKAGES_DIR)/$(LIBILBC)/build-static -j$(nproc)
		
$(STAGING_DIR)/$(SDROOT)/lib/libilbc.so: $(PACKAGES_DIR)/$(LIBILBC)/build-shared/libilbc.so
	@make -C $(PACKAGES_DIR)/$(LIBILBC)/build-shared install
	@touch $@
	
$(STAGING_DIR)/$(SDROOT)/lib/libilbc.a: $(PACKAGES_DIR)/$(LIBILBC)/build-static/libilbc.a
	@make -C $(PACKAGES_DIR)/$(LIBILBC)/build-static install
	@touch $@
		
libilbc: $(STAGING_DIR)/$(SDROOT)/lib/libilbc.a $(STAGING_DIR)/$(SDROOT)/lib/libilbc.so

libilbc-clean:
	@rm -rf $(PACKAGES_DIR)/$(LIBILBC)/build-shared
	@rm -rf $(PACKAGES_DIR)/$(LIBILBC)/build-static

$(PACKAGES_DIR)/$(OPENJPEG)/build/Makefile:
	@mkdir -p $(PACKAGES_DIR)/$(OPENJPEG)/build
	@cd $(PACKAGES_DIR)/$(OPENJPEG)/build; cmake .. -DCMAKE_INSTALL_PREFIX=$(STAGING_DIR)/$(SDROOT)
	
$(PACKAGES_DIR)/$(OPENJPEG)/libopenjp2.a: $(PACKAGES_DIR)/$(OPENJPEG)/build/Makefile
	@make -C $(PACKAGES_DIR)/$(OPENJPEG)/build -j$(nproc)
	@touch $@
	
$(STAGING_DIR)/$(SDROOT)/lib/libopenjp2.a: $(PACKAGES_DIR)/$(OPENJPEG)/libopenjp2.a
	@make -C $(PACKAGES_DIR)/$(OPENJPEG)/build install
	@touch $@
	
openjpeg: $(STAGING_DIR)/$(SDROOT)/lib/libopenjp2.a

openjpeg-clean:
	@make -C $(PACKAGES_DIR)/$(OPENJPEG) clean distclean

$(PACKAGES_DIR)/$(OPUS)/Makefile:
	@cd $(PACKAGES_DIR)/$(OPUS); ./configure --prefix=$(SDROOT) --enable-static --with-gnu-ld --host=$(HOST)
	
$(PACKAGES_DIR)/$(OPUS)/libopus.la: $(PACKAGES_DIR)/$(OPUS)/Makefile
	@make -C $(PACKAGES_DIR)/$(OPUS) -j$(nproc)
	
$(STAGING_DIR)/$(SDROOT)/lib/libopus.la: $(PACKAGES_DIR)/$(OPUS)/libopus.la
	@make -C $(PACKAGES_DIR)/$(OPUS) install DESTDIR=$(STAGING_DIR)
	
opus: $(STAGING_DIR)/$(SDROOT)/lib/libopus.la

opus-clean:
	@make -C $(PACKAGES_DIR)/$(OPUS) clean distclean

$(PACKAGES_DIR)/$(FFMPEG)/ffbuild/config.mak:
	@cp ./ffmpeg-configure $(PACKAGES_DIR)/$(FFMPEG)/configure
	@cd $(PACKAGES_DIR)/$(FFMPEG); ./configure --prefix=$(SDROOT) --arch=arm --cross-prefix=$(HOST)- --target-os=linux \
	--extra-cflags="-Dstatic_assert=_Static_assert -I$(STAGING_DIR)/$(SDROOT)/include -I$(STAGING_DIR)/$(SDROOT)/usr/include -I$(STAGING_DIR)/$(SDROOT)/include/opus -I$(STAGING_DIR)/$(SDROOT)/include/openjpeg-2.5" \
	--extra-ldflags="-L$(STAGING_DIR)/$(SDROOT)/lib -L$(STAGING_DIR)/$(SDROOT)/usr/lib -lgmp -lgcrypt -lgpg-error -lilbc -lopenjp2 -lopus" \
	--disable-static --enable-shared --enable-cross-compile --stdc=c11 --disable-doc --enable-zlib --enable-gmp --enable-gcrypt --enable-gpl --enable-version3 --enable-libilbc --enable-libopus --disable-encoders --disable-decoders --disable-protocols \
	--enable-decoder=adpcm_g722 --enable-decoder=adpcm_g726 --enable-decoder=adpcm_g7261e --enable-decoder=aac --enable-decoder=aac_latm --enable-decoder=aac_mediacodec --enable-decoder=ac3 --enable-decoder=ac3_at --enable-decoder=ac3_fixed --enable-decoder=flv --enable-decoder=flac --enable-decoder=g729 --enable-decoder=gif --enable-decoder=h261 --enable-decoder=h263 --enable-decoder=h263_v4l2m2m --enable-decoder=h263i --enable-decoder=h263p --enable-decoder=h264 --enable-decoder=h264_cuvid --enable-decoder=h264_mediacodec --enable-decoder=h264_v4l2m2m --enable-decoder=hevc --enable-decoder=hevc_cuvid --enable-decoder=hevc_mediacodec --enable-decoder=hevc_v4l2m2m --enable-decoder=ilbc --enable-decoder=ilbc_at --enable-decoder=mjpeg --enable-decoder=mjpeg_cuvid --enable-decoder=mjpegb --enable-decoder=mp1 --enable-decoder=mp1_at --enable-decoder=mp1float --enable-decoder=mp2 --enable-decoder=mp2_at --enable-decoder=mp2float --enable-decoder=mp3 --enable-decoder=mp3_at --enable-decoder=mp3_mediacodec --enable-decoder=mp3adu --enable-decoder=mp3adufloat --enable-decoder=mp3float --enable-decoder=mp3on4 --enable-decoder=mp3on4float --enable-decoder=mpeg1_cuvid --enable-decoder=mpeg1_v4l2m2m --enable-decoder=mpeg1video --enable-decoder=mpeg2_cuvid --enable-decoder=mpeg2_mediacodec --enable-decoder=mpeg2_v4l2m2m --enable-decoder=mpeg2video --enable-decoder=mpeg4 --enable-decoder=mpeg4_cuvid --enable-decoder=mpeg4_mediacodec --enable-decoder=mpeg4_v4l2m2m --enable-decoder=mpegvideo --enable-decoder=pcm_alaw --enable-decoder=pcm_alaw_at --enable-decoder=pcm_mulaw --enable-decoder=pcm_mulaw_at --enable-decoder=speex --enable-decoder=text --enable-decoder=vp7 --enable-decoder=vp8 --enable-decoder=vp8_cuvid --enable-decoder=vp8_mediacodec --enable-decoder=vp8_v4l2m2m --enable-decoder=vp9 --enable-decoder=vp9_cuvid --enable-decoder=vp9_mediacodec --enable-decoder=vp9_v4l2m2m --enable-decoder=webp --enable-decoder=wmav1 --enable-decoder=wmav2 --enable-decoder=yuv4 --enable-decoder=zlib \
	--enable-encoder=aac --enable-encoder=aac_at --enable-encoder=ac3 --enable-encoder=ac3_fixed --enable-encoder=ac3_mf --enable-encoder=adpcm_g722 --enable-encoder=adpcm_g726 --enable-encoder=adpcm_7261e --enable-encoder=flac --enable-encoder=flv --enable-encoder=h261 --enable-encoder=h263 --enable-encoder=h263_v4l2m2m --enable-encoder=h263p --enable-encoder=h264_mediacodec --enable-encoder=h264_v4l2m2m --enable-encoder=hevc_mediacodec --enable-encoder=hevc_v4l2m2m --enable-encoder=ilbc_at --enable-encoder=mjpeg --enable-encoder=mp2 --enable-encoder=mp2fixed --enable-encoder=mp3_mf --enable-encoder=mpeg1video --enable-encoder=mpeg2video --enable-encoder=mpeg4 --enable-encoder=mpeg4_mediacodec --enable-encoder=mpeg4_v4l2m2m --enable-encoder=opus --enable-encoder=pcm_alaw --enable-encoder=pcm_alaw_at --enable-encoder=pcm_mulaw --enable-encoder=pcm_mulaw_at --enable-encoder=png --enable-encoder=rawvideo --enable-encoder=text --enable-encoder=vorbis --enable-encoder=vp8_mediacodec --enable-encoder=vp8_v4l2m2m --enable-encoder=vp9_mediacodec --enable-encoder=wacpack --enable-encoder=wmav1 --enable-encoder=wmav2 --enable-encoder=yuv4 --enable-encoder=zlib \
	--enable-protocol=concat --enable-protocol=concaf --enable-protocol=data --enable-protocol=fd --enable-protocol=file --enable-protocol=hls --enable-protocol=http --enable-protocol=https --enable-protocol=pipe --enable-protocol=prompeg --enable-protocol=rtmp --enable-protocol=rtmpe --enable-protocol=rtmps --enable-protocol=rtmpt --enable-protocol=rtmpte --enable-protocol=rtmpts --enable-protocol=trp --enable-protocol=sctp --enable-protocol=srtp --enable-protocol=subfile --enable-protocol=tcp --enable-protocol=tee --enable-protocol=tls --enable-protocol=udp --enable-protocol=unix

$(PACKAGES_DIR)/$(FFMPEG)/ffprobe: $(PACKAGES_DIR)/$(FFMPEG)/ffbuild/config.mak
	@make -C $(PACKAGES_DIR)/$(FFMPEG) -j$(nproc)
	
$(STAGING_DIR)/$(SDROOT)/bin/ffprobe: $(PACKAGES_DIR)/$(FFMPEG)/ffprobe
	@make -C $(PACKAGES_DIR)/$(FFMPEG) install DESTDIR=$(STAGING_DIR)
	@touch $@
	
ffmpeg: $(STAGING_DIR)/$(SDROOT)/bin/ffprobe

ffmpeg-clean:
	@make -C $(PACKAGES_DIR)/$(FFMPEG) clean distclean

$(PACKAGES_DIR)/$(LIBEXECINFO)/libexecinfo.so:
	@make -C $(PACKAGES_DIR)/$(LIBEXECINFO) -j$(nproc)
	@touch $@
	
$(STAGING_DIR)/$(SDROOT)/lib/libexecinfo.so: $(PACKAGES_DIR)/$(LIBEXECINFO)/libexecinfo.so
	@make -C $(PACKAGES_DIR)/$(LIBEXECINFO) install PREFIX=$(SDROOT) DESTDIR=$(STAGING_DIR)
	@touch $@
	
libexecinfo: $(STAGING_DIR)/$(SDROOT)/lib/libexecinfo.so

libexecinfo-clean:
	@make -C $(PACKAGES_DIR)/$(LIBEXECINFO) clean

$(PACKAGES_DIR)/$(GLIBC)/build/config.status:
	@mkdir $(PACKAGES_DIR)/$(GLIBC)/build || true
	@cd $(PACKAGES_DIR)/$(GLIBC)/build; ../configure --prefix=$(SDROOT) --host=$(HOST) --disable-timezone-tools --disable-hidden-plt --enable-kernel=4.4 \
	--disable-werror --disable-crypt --disable-build-nscd --with-bugurl=https://github.com/Bunkerschild/LSCamoflash --with-arch=armv5te --with-tune=arm926ej-s \
	CFLAGS="-nostdinc" LDFLAGS="-nostdlib"

$(PACKAGES_DIR)/$(GLIBC)/build/libc.so: $(PACKAGES_DIR)/$(GLIBC)/build/config.status
	@make -C $(PACKAGES_DIR)/$(GLIBC)/build -j$(nproc) 
	@touch $@
	
$(STAGING_DIR)/$(SDROOT)/lib/libc.so: $(PACKAGES_DIR)/$(GLIBC)/build/libc.so
	@make -C $(PACKAGES_DIR)/$(GLIBC)/build install PREFIX=$(SDROOT) DESTDIR=$(STAGING_DIR)
	@touch $@
	
glibc: $(STAGING_DIR)/$(SDROOT)/lib/libc.so

glibc-clean:
	@rm -rf $(PACKAGES_DIR)/$(GLIBC)/build

$(PACKAGES_DIR)/$(KERNEL)/.config:
	@make -C $(PACKAGES_DIR)/$(KERNEL) ARCH=arm CROSS_COMPILE=$(HOST)- defconfig
	@cp $(ROOT_DIR)/kernel-config $(PACKAGES_DIR)/$(KERNEL)/.config
	@touch $@

$(PACKAGES_DIR)/$(KERNEL)/.modules: $(PACKAGES_DIR)/$(KERNEL)/.config
	@make -C $(PACKAGES_DIR)/$(KERNEL) ARCH=arm CROSS_COMPILE=$(HOST)- HOSTCFLAGS="-fcommon" modules
	@touch $@
		
$(PACKAGES_DIR)/$(KERNEL)/.kernel: $(PACKAGES_DIR)/$(KERNEL)/.config
	@make -C $(PACKAGES_DIR)/$(KERNEL) ARCH=arm CROSS_COMPILE=$(HOST)- HOSTCFLAGS="-fcommon" bzImage
	@touch $@
		
$(STAGING_DIR)/$(SDROOT)/lib/modules/.install: $(PACKAGES_DIR)/$(KERNEL)/.modules
	@make -C $(PACKAGES_DIR)/$(KERNEL) ARCH=arm CROSS_COMPILE=$(HOST)- INSTALL_MOD_PATH=$(STAGING_DIR)/$(SDROOT)/lib/modules modules_install
	@touch $@
		
$(STAGING_DIR)/$(SDROOT)/usr/kernel/.install: $(PACKAGES_DIR)/$(KERNEL)/.kernel
	@make -C $(PACKAGES_DIR)/$(KERNEL) ARCH=arm CROSS_COMPILE=$(HOST)- INSTALL_PATH=$(STAGING_DIR)/$(SDROOT)/usr/kernel install
	@touch $@
		
kernel: $(STAGING_DIR)/$(SDROOT)/lib/modules/.install $(STAGING_DIR)/$(SDROOT)/usr/kernel/.install

kernel-clean:
	@make -C $(PACKAGES_DIR)/$(KERNEL) clean mrproper

$(PACKAGES_DIR)/$(RADARE2)/mk/arm-buildroot-linux-uclibcgnueabi-gcc.mk:
	@cp $(ROOT_DIR)/arm-buildroot-linux-uclibcgnueabi-gcc.mk $(PACKAGES_DIR)/$(RADARE2)/mk
	@touch $@

$(PACKAGES_DIR)/$(RADARE2)/plugins.cfg: $(PACKAGES_DIR)/$(RADARE2)/mk/arm-buildroot-linux-uclibcgnueabi-gcc.mk
	@cd $(PACKAGES_DIR)/$(RADARE2); ./configure --prefix=$(SDROOT) --host=$(HOST) --with-static-themes --with-ssl --with-compiler=arm-buildroot-linux-uclibcgnueabi-gcc --datadir=$(SDROOT)/usr/share \
	CFLAGS="-I$(STAGING_DIR)/$(SDROOT)/include -I$(STAGING_DIR)/$(SDROOT)/include/openssl -I$(STAGING_DIR)/$(SDROOT)/usr/include -I$(STAGING_DIR)/$(SDROOT)/sysroot/usr/include -nostdinc" \
	LDFLAGS="-L$(STAGING_DIR)/$(SDROOT)/lib -L$(STAGING_DIR)/$(SDROOT)/usr/lib -L$(STAGING_DIR)/$(SDROOT)/sysroot/lib -L$(STAGING_DIR)/$(SDROOT)/sysroot/usr/lib -lssl -lz -lexecinfo -latomic" \
	CROSS_ROOT=$(TOOLCHAIN_PATH)/bin
	@touch $@

$(PACKAGES_DIR)/$(RADARE2)/libr/include/fenv.h: $(PACKAGES_DIR)/$(RADARE2)/plugins.cfg
	@cp $(ROOT_DIR)/radare2-fenv.h $(PACKAGES_DIR)/$(RADARE2)/libr/include/fenv.h
	@touch $@

$(PACKAGES_DIR)/$(RADARE2)/binr/radare2/radare2: $(PACKAGES_DIR)/$(RADARE2)/libr/include/fenv.h
	@cp $(STAGING_DIR)/$(SDROOT)/include/execinfo.h $(PACKAGES_DIR)/$(RADARE2)/libr/include
	@make -C $(PACKAGES_DIR)/$(RADARE2) -j$(nproc) CROSS_ROOT=$(TOOLCHAIN_PATH)/bin \
	CPPFLAGS="-I$(STAGING_DIR)/$(SDROOT)/include -I$(STAGING_DIR)/$(SDROOT)/include/openssl -I$(STAGING_DIR)/$(SDROOT)/usr/include -I$(STAGING_DIR)/$(SDROOT)/sysroot/usr/include -L$(STAGING_DIR)/$(SDROOT)/lib -L$(STAGING_DIR)/$(SDROOT)/usr/lib -L$(STAGING_DIR)/$(SDROOT)/sysroot/lib -L$(STAGING_DIR)/$(SDROOT)/sysroot/usr/lib -lexecinfo -latomic" 
	
$(STAGING_DIR)/$(SDROOT)/bin/radare2: $(PACKAGES_DIR)/$(RADARE2)/binr/radare2/radare2
	@make -C $(PACKAGES_DIR)/$(RADARE2) install DESTDIR=$(STAGING_DIR) CROSS_ROOT=$(TOOLCHAIN_PATH)/bin
	@rm $(STAGING_DIR)/$(SDROOT)/lib/radare2/5.9.8/5.9.8 || true
	@rm $(STAGING_DIR)/$(SDROOT)/lib/radare2/last/5.9.8 || true
	@touch $@
	
radare2: $(STAGING_DIR)/$(SDROOT)/bin/radare2

radare2-clean:
	@make -C $(PACKAGES_DIR)/$(RADARE2) clean distclean
	@rm $(STAGING_DIR)/$(SDROOT)/bin/radare2

staging: $(STAGING_DIR) libpcap tcpdump openssl zlib joe strace sqlite3 sqlcipher msmtp miniupnpc curl busybox cjson mosquitto gsoap onvif opus openjpeg libilbc libgpg-error gmp libgcrypt ffmpeg libexecinfo glibc radare2

$(BUILD_DIR)/install.ps1: $(BUILD_DIR)
	@cp -aL $(SRC_DIR)/sdcard/* $(BUILD_DIR)
	@make -C $(SRC_DIR)/contrib/motor DESTDIR=$(BUILD_DIR)/mmcblk0p2/HACK install
	@cp -aL $(STAGE_HACK)/lib/* $(BUILD_HACK)/lib
	@cp -aL $(STAGE_HACK)/usr/lib/* $(BUILD_HACK)/lib
	@cp -aL $(STAGE_HACK)/usr/local/lib/* $(BUILD_HACK)/lib
	@touch $@
	
$(BUILD_HACK)/sbin/mosquitto:
	@cp -a $(STAGE_HACK)/etc/mosquitto $(BUILD_HACK)/etc/config
	@cp $(STAGE_HACK)/usr/sbin/mosquitto $@

$(BUILD_HACK)/bin/mosquitto_passwd:
	@cp $(STAGE_HACK)/usr/bin/mosquitto_passwd $@

$(BUILD_HACK)/bin/mosquitto_sub:
	@cp $(STAGE_HACK)/usr/bin/mosquitto_sub $@

$(BUILD_HACK)/bin/mosquitto_pub:
	@cp $(STAGE_HACK)/usr/bin/mosquitto_pub $@

$(BUILD_HACK)/bin/mosquitto_rr:
	@cp $(STAGE_HACK)/usr/bin/mosquitto_rr $@

$(BUILD_HACK)/bin/busybox:
	@cp $(STAGE_HACK)/bin/busybox $@

$(BUILD_HACK)/bin/curl:
	@cp -a $(STATE_HACK)/usr/share/aclocal $(BUILD_HACK)/usr/share
	@cp $(STAGE_HACK)/bin/curl $@

$(BUILD_HACK)/bin/curl-config:
	@cp $(STAGE_HACK)/bin/curl-config $@

$(BUILD_HACK)/bin/joe:
	@cp -aL $(STAGE_HACK)/etc/config/joe $(BUILD_HACK)/etc/config
	@cp -aL $(STATE_HACK)/usr/share/joe $(BUILD_HACK)/usr/share
	@cp $(STAGE_HACK)/bin/joe $(BUILD_HACK)/bin/rjoe
	@cp $(STAGE_HACK)/bin/joe $(BUILD_HACK)/bin/jmacs
	@cp $(STAGE_HACK)/bin/joe $(BUILD_HACK)/bin/jpico
	@cp $(STAGE_HACK)/bin/joe $(BUILD_HACK)/bin/jstar
	@cp $(STAGE_HACK)/bin/joe $@

$(BUILD_HACK)/bin/msmtp:
	@cp -aL $(STATE_HACK)/usr/share/locale $(BUILD_HACK)/usr/share
	@cp $(STAGE_HACK)/bin/msmtp $@

$(BUILD_HACK)/sbin/msmtpd:
	@cp $(STAGE_HACK)/bin/msmtpd $@

$(BUILD_HACK)/bin/openssl:
	@cp -aL $(STAGE_HACK)/etc/config/ssl $(BUILD_HACK)/etc/config
	@cp $(STAGE_HACK)/bin/openssl $@

$(BUILD_HACK)/bin/pcap-config:
	@cp $(STAGE_HACK)/bin/pcap-config $@

$(BUILD_HACK)/bin/sqlcipher:
	@cp $(STAGE_HACK)/bin/sqlcipher $@

$(BUILD_HACK)/bin/sqlite3:
	@cp $(STAGE_HACK)/bin/sqlite3 $@

$(BUILD_HACK)/bin/strace:
	@cp $(STAGE_HACK)/bin/strace $@

$(BUILD_HACK)/bin/strace-log-merge:
	@cp $(STAGE_HACK)/bin/strace-log-merge $@

$(BUILD_HACK)/bin/tcpdump:
	@cp $(STAGE_HACK)/bin/tcpdump $@

$(BUILD_HACK)/bin/tcpdump-static:
	@cp $(STAGE_HACK)/bin/tcpdump.4.99.4 $@

$(BUILD_HACK)/bin/upnpc:
	@cp $(STAGE_HACK)/bin/upnpc-static $@
	
$(BUILD_HACK)/sbin/onvif_srvd:
	@cp $(SRC_DIR)/contrib/binaries/onvif_srvd $@
	@chmod +x $@
	@touch $@
	
$(BUILD_HACK)/bin/ffprobe:
	@cp $(STAGE_HACK)/bin/ffprobe $@

$(BUILD_HACK)/bin/ffmpeg:
	@cp $(STAGE_HACK)/bin/ffmpeg $@

$(BUILD_HACK)/bin/opj_dump:
	@cp $(STAGE_HACK)/bin/opj_dump $@

$(BUILD_HACK)/bin/opj_compress:
	@cp $(STAGE_HACK)/bin/opj_compress $@

$(BUILD_HACK)/bin/opj_decompress:
	@cp $(STAGE_HACK)/bin/opj_decompress $@

$(BUILD_HACK)/bin/radare2:
	@cp -aL $(STATE_HACK)/usr/share/radare2 $(BUILD_HACK)/usr/share
	@cp $(STAGE_HACK)/bin/radare2 $(BUILD_HACK)/bin/r2
	@cp $(STAGE_HACK)/bin/radare2 $(BUILD_HACK)/bin/r2p
	@cp $(STAGE_HACK)/bin/radare2 $@

$(BUILD_HACK)/bin/r2agent:
	@cp $(STAGE_HACK)/bin/r2agent $@

$(BUILD_HACK)/bin/r2r:
	@cp $(STAGE_HACK)/bin/r2r $@

$(BUILD_HACK)/bin/rasign2:
	@cp $(STAGE_HACK)/bin/rasign2 $@

$(BUILD_HACK)/bin/rax2:
	@cp $(STAGE_HACK)/bin/rax2 $@

$(BUILD_HACK)/bin/ragg2:
	@cp $(STAGE_HACK)/bin/ragg2 $@

$(BUILD_HACK)/bin/rarun2:
	@cp $(STAGE_HACK)/bin/rarun2 $@

$(BUILD_HACK)/bin/rabin2:
	@cp $(STAGE_HACK)/bin/rabin2 $@

$(BUILD_HACK)/bin/radiff2:
	@cp $(STAGE_HACK)/bin/radiff2 $@

$(BUILD_HACK)/bin/ravc2:
	@cp $(STAGE_HACK)/bin/ravc2 $@

$(BUILD_HACK)/bin/rahash2:
	@cp $(STAGE_HACK)/bin/rahash2 $@

$(BUILD_HACK)/bin/rafind2:
	@cp $(STAGE_HACK)/bin/rafind2 $@

$(BUILD_HACK)/bin/r2pm:
	@cp $(STAGE_HACK)/bin/r2pm $@

$(BUILD_HACK)/bin/rasm2:
	@cp $(STAGE_HACK)/bin/rasm2 $@

$(BUILD_HACK)/etc/version.txt:
	@find $(BUILD_HACK)/lib -name "*.a" -exec rm {} \;
	@find $(BUILD_HACK)/lib -name "*.la" -exec rm {} \;
	@find $(BUILD_HACK)/lib -name "*.pc" -exec rm {} \;
	@find $(BUILD_HACK)/lib -name "*.cmake" -exec rm {} \;
	@rm -rf $(BUILD_HACK)/usr/share/locale
	@cp version.txt $@

build: $(BUILD_DIR)/install.ps1 $(BUILD_HACK)/bin/radare2 $(BUILD_HACK)/bin/r2agent $(BUILD_HACK)/bin/r2r $(BUILD_HACK)/bin/rasign2 $(BUILD_HACK)/bin/rax2 $(BUILD_HACK)/bin/ragg2 $(BUILD_HACK)/bin/rarun2 $(BUILD_HACK)/bin/rabin2 \
       $(BUILD_HACK)/bin/radiff2 $(BUILD_HACK)/bin/ravc2 $(BUILD_HACK)/bin/rahash2 $(BUILD_HACK)/bin/rafind2 $(BUILD_HACK)/bin/r2pm $(BUILD_HACK)/bin/rasm2 $(BUILD_HACK)/bin/ffmpeg $(BUILD_HACK)/bin/ffprobe $(BUILD_HACK)/bin/opj_dump \
       $(BUILD_HACK)/bin/opj_compress $(BUILD_HACK)/bin/opj_decompress $(BUILD_HACK)/sbin/onvif_srvd $(BUILD_HACK)/bin/upnpc $(BUILD_HACK)/bin/tcpdump-static $(BUILD_HACK)/bin/tcpdump $(BUILD_HACK)/bin/strace-log-merge \
       $(BUILD_HACK)/bin/strace $(BUILD_HACK)/bin/sqlite3 $(BUILD_HACK)/bin/sqlcipher $(BUILD_HACK)/bin/pcap-config $(BUILD_HACK)/bin/openssl $(BUILD_HACK)/sbin/msmtpd $(BUILD_HACK)/bin/msmtp $(BUILD_HACK)/bin/joe \
       $(BUILD_HACK)/bin/curl-config $(BUILD_HACK)/bin/curl $(BUILD_HACK)/bin/busybox $(BUILD_HACK)/bin/mosquitto_rr $(BUILD_HACK)/bin/mosquitto_pub $(BUILD_HACK)/bin/mosquitto_sub $(BUILD_HACK)/bin/mosquitto_passwd \
       $(BUILD_HACK)/sbin/mosquitto $(BUILD_HACK)/etc/version.txt
	
build-clean:
	@rm -rf $(BUILD_DIR)

staging-clean:
	@rm -rf $(STAGING_DIR)
	
packages-clean:
	@rm -rf $(PACKAGES_DIR)

download-clean:
	@rm -rf $(DOWNLOAD_DIR)

toolchain-clean:
	@rm -rf $(TOOLCHAIN_DIR)

mrproper: staging-clean packages-clean download-clean toolchain-clean build-clean
	@rm -f $(ROOT_DIR)/LSCamoflash-*.tar.gz || true
	@rm -f $(ROOT_DIR)/update-*.tgz || true
	
clean: radare2-clean glibc-clean libexecinfo-clean ffmpeg-clean opus-clean openjpeg-clean libilbc-clean libgpg-error-clean gmp-clean libgcrypt-clean onvif-clean gsoap-clean mosquitto-clean cjson-clean busybox-clean curl-clean miniupnpc-clean msmtp-clean sqlcipher-clean sqlite3-clean strace-clean joe-clean zlib-clean openssl-clean tcpdump-clean libpcap-clean

LSCamoflash-$(VERSION).tar.gz: download toolchain packages staging build
	@tar -C $(BUILD_DIR) -cvzf $@ .
	@touch $@
	
update-$(VERSION).tgz: download toolchain packages staging build
	@tar -C $(BUILD_DIR) -cvzf $@ --exclude=mmcblk0p2/HACK/etc --exclude=mmcblk0p2/HACK/var/spool/cron/crontabs/root mmcblk0p1 mmcblk0p2
	@touch $@
	
release: LSCamoflash-$(VERSION).tar.gz

update: update-$(VERSION).tgz

install: all
	@cd $(BUILD_DIR); sh install.sh

.PHONY: all clean

