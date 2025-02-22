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

# Exportiere die Variablen für alle Ziele
export TOOLCHAIN_PATH PKG_CONFIG_PATH PATH C CC GCC CXX CPP AR RANLIB CROSS_PREFIX

# Liste der zu ladenden Pakete
URLS := \
    https://toolchains.bootlin.com/downloads/releases/toolchains/armv5-eabi/tarballs/armv5-eabi--uclibc--stable-2020.08-1.tar.bz2 \
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
	@echo -e "all:\n\ninstall\n" > $(PACKAGES_DIR)/$(GSOAP)/gsoap/wsdl/Makefile

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

$(PACKAGES_DIR)/$(ONVIF)/src/onvif_srvd: $(PACKAGES_DIR)/$(ONVIF)/Makefile.new
	@make -C $(PACKAGES_DIR)/$(ONVIF) -j$(nproc) release
	@touch $@

$(STAGING_DIR)/$(SDROOT)/sbin/onvif_srvd: $(PACKAGES_DIR)/$(ONVIF)/src/onvif_srvd
	@mkdir -p $(STAGING_DIR)/$(SDROOT)/sbin/ || true
	@cp $(PACKAGES_DIR)/$(ONVIF)/src/onvif_srvd $@
	@touch $@

onvif: $(STAGING_DIR)/$(SDROOT)/sbin/onvif_srvd

onvif-clean:
	@rm -rf $(PACKAGES_DIR)/$(ONVIF)/build
	@rm $(PACKAGES_DIR)/$(ONVIF)/onvif-config

staging: $(STAGING_DIR) libpcap tcpdump openssl zlib joe strace sqlite3 sqlcipher msmtp miniupnpc curl busybox cjson mosquitto gsoap onvif

$(BUILD_DIR)/install.ps1: $(BUILD_DIR)
	@cp -a $(SRC_DIR)/sdcard/* $(BUILD_DIR)
	@make -C $(SRC_DIR)/contrib/motor DESTDIR=$(BUILD_DIR)/mmcblk0p2/HACK install
	@cp -a $(STAGE_HACK)/lib/* $(BUILD_HACK)/lib
	@cp -a $(STAGE_HACK)/usr/lib/* $(BUILD_HACK)/lib
	@cp -a $(STAGE_HACK)/usr/local/lib/* $(BUILD_HACK)/lib
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

$(BUILD_HACK)/bin/c_rehash:
	@cp $(STAGE_HACK)/bin/c_rehash $@

$(BUILD_HACK)/bin/curl:
	@cp -a $(STATE_HACK)/usr/share/aclocal $(BUILD_HACK)/usr/share
	@cp $(STAGE_HACK)/bin/curl $@

$(BUILD_HACK)/bin/curl-config:
	@cp $(STAGE_HACK)/bin/curl-config $@

$(BUILD_HACK)/bin/joe:
	@cp -a $(STAGE_HACK)/etc/config/joe $(BUILD_HACK)/etc/config
	@cp -a $(STATE_HACK)/usr/share/joe $(BUILD_HACK)/usr/share
	@cp $(STAGE_HACK)/bin/joe $(BUILD_HACK)/bin/rjoe
	@cp $(STAGE_HACK)/bin/joe $(BUILD_HACK)/bin/jmacs
	@cp $(STAGE_HACK)/bin/joe $(BUILD_HACK)/bin/jpico
	@cp $(STAGE_HACK)/bin/joe $(BUILD_HACK)/bin/jstar
	@cp $(STAGE_HACK)/bin/joe $@

$(BUILD_HACK)/bin/msmtp:
	@cp -a $(STATE_HACK)/usr/share/locale $(BUILD_HACK)/usr/share
	@cp $(STAGE_HACK)/bin/msmtp $@

$(BUILD_HACK)/sbin/msmtpd:
	@cp $(STAGE_HACK)/bin/msmtpd $@

$(BUILD_HACK)/bin/openssl:
	@cp -a $(STAGE_HACK)/etc/config/ssl $(BUILD_HACK)/etc/config
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
	@cp $(STAGE_HACK)/sbin/onvif_srvd $@
	@chmod +x $@
	@touch $@
	
$(BUILD_HACK)/etc/version.txt: 
	@cp version.txt $@

build: $(BUILD_DIR)/install.ps1 $(BUILD_HACK)/sbin/onvif_srvd $(BUILD_HACK)/bin/upnpc $(BUILD_HACK)/bin/tcpdump-static $(BUILD_HACK)/bin/tcpdump $(BUILD_HACK)/bin/strace-log-merge $(BUILD_HACK)/bin/strace $(BUILD_HACK)/bin/sqlite3 $(BUILD_HACK)/bin/sqlcipher $(BUILD_HACK)/bin/pcap-config $(BUILD_HACK)/bin/openssl $(BUILD_HACK)/sbin/msmtpd $(BUILD_HACK)/bin/msmtp $(BUILD_HACK)/bin/joe $(BUILD_HACK)/bin/curl-config $(BUILD_HACK)/bin/curl $(BUILD_HACK)/bin/c_rehash $(BUILD_HACK)/bin/busybox $(BUILD_HACK)/bin/mosquitto_rr $(BUILD_HACK)/bin/mosquitto_pub $(BUILD_HACK)/bin/mosquitto_sub $(BUILD_HACK)/bin/mosquitto_passwd $(BUILD_HACK)/sbin/mosquitto $(BUILD_HACK)/etc/version.txt
	
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
	@rm .unpack || true
	
clean: onvif-clean gsoap-clean mosquitto-clean cjson-clean busybox-clean curl-clean miniupnpc-clean msmtp-clean sqlcipher-clean sqlite3-clean strace-clean joe-clean zlib-clean openssl-clean tcpdump-clean libpcap-clean

install: all
	@cd $(BUILD_DIR); sh install.sh

.PHONY: all clean

