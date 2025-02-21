# Definiere Pfade
ROOT_DIR := $(shell pwd)
DOWNLOAD_DIR := $(ROOT_DIR)/download
TOOLCHAIN_DIR := $(ROOT_DIR)/toolchain
PACKAGES_DIR := $(ROOT_DIR)/packages
STAGING_DIR := $(ROOT_DIR)/staging

# SD card
SDCARD := /tmp/sd
SDROOT := $(SDCARD)/HACK

# Definiere die Toolchain-Pfade
TOOLCHAIN_PATH := $(TOOLCHAIN_DIR)
PKG_CONFIG_PATH := $(TOOLCHAIN_PATH)/lib/pkgconfig:$(TOOLCHAIN_PATH)/share/pkgconfig
PATH := $(TOOLCHAIN_PATH)/bin:$(PATH)

# Definiere die Cross-Compiler Variablen
HOST := arm-buildroot-linux-uclibcgnueabi
CC := $(TOOLCHAIN_PATH)/bin/$(HOST)-gcc
CXX := $(TOOLCHAIN_PATH)/bin/$(HOST)-g++
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

# Exportiere die Variablen für alle Ziele
export TOOLCHAIN_PATH PKG_CONFIG_PATH PATH CC CXX AR RANLIB CROSS_PREFIX

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
    https://github.com/sqlcipher/sqlcipher/archive/refs/tags/v4.5.5.tar.gz \
    https://curl.se/download/$(CURL).tar.gz \
    https://curl.se/ca/cacert.pem \
    https://marlam.de/msmtp/releases/$(MSMTP).tar.xz \
    https://github.com/miniupnp/miniupnp/archive/refs/tags/$(MINIUPNPC).tar.gz

# Ziele definieren
all: fetch unpack compile

fetch: $(DOWNLOAD_DIR) $(patsubst %,$(DOWNLOAD_DIR)/%,$(notdir $(URLS)))

unpack: $(TOOLCHAIN_DIR) $(PACKAGES_DIR) $(STAGING_DIR)
	@tar -xf $(DOWNLOAD_DIR)/armv5-eabi--uclibc--stable-2020.08-1.tar.bz2 -C $(TOOLCHAIN_DIR) --strip-components=1
	@for file in $(DOWNLOAD_DIR)/*; do \
	  if [ "$$file" != "$(DOWNLOAD_DIR)/armv5-eabi--uclibc--stable-2020.08-1.tar.bz2" -a "$$file" != "$(DOWNLOAD_DIR)/cacert.pem" ]; then \
	    tar -xf $$file -C $(PACKAGES_DIR) || echo "Skipping $$file"; \
	  fi; \
	done

$(DOWNLOAD_DIR):
	@mkdir -p $@

$(TOOLCHAIN_DIR):
	@mkdir -p $@

$(PACKAGES_DIR):
	@mkdir -p $@

$(STAGING_DIR):
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

staging-clean:
	@rm -rf $(STAGING_DIR)
	
packages-clean:
	@rm -rf $(PACKAGES_DIR)

download-clean:
	@rm -rf $(DOWNLOAD_DIR)

toolchain-clean:
	@rm -rf $(TOOLCHAIN_DIR)
	
mr-proper: staging-clean packages-clean download-clean toolchain-clean
	
clean: busybox-clean curl-clean miniupnpc-clean msmtp-clean sqlcipher-clean sqlite3-clean strace-clean joe-clean zlib-clean openssl-clean tcpdump-clean libpcap-clean

compile: libpcap tcpdump openssl zlib joe strace sqlite3 sqlcipher msmtp miniupnpc curl busybox

.PHONY: all fetch unpack clean
