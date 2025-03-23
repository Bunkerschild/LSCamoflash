# Projekt URLs
PROJECT_URL := https://github.com/Bunkerschild/LSCamoflash
DOWNLOAD_URL := $(PROJECT_URL)/raw/refs/heads/main/SOURCE/download/

# Optional packages
WITH_RADARE2 := 0
WITH_GLIBC := 0
WITH_FFMPEG := 1
WITH_KERNEL := 0
WITH_OPUS := 0
WITH_OPENJPEG := 0
WITH_LIBILBC := 0
WITH_LIBGPG_ERROR := 0
WITH_LIBGCRYPT := 0
WITH_LIBEXECINFO := 0
WITH_GMP := 0
WITH_PHP := 1
WITH_PYTHON := 2
ifeq ($(WITH_RADARE2), 1)
	RADARE2_BUILD = radare2
	RADARE2_CLEAN = radare2-clean
	WITH_LIBEXECINFO = 1
else
	RADARE2_BUILD = without-radare2
	RADARE2_CLEAN= = without-radare2-clean
endif
ifeq ($(WITH_LIBEXECINFO), 1)
	LIBEXECINFO_BUILD = libexecinfo
	LIBEXECINFO_CLEAN = libexecinfo-clean
else
	LIBEXECINFO_BUILD = without-libexecinfo
	LIBEXECINFO_CLEAN = without-libexecinfo-clean
endif
ifeq ($(WITH_GLIBC), 1)
	GLIBC_BUILD = glibc
	GLIBC_CLEAN = glibc-clean
else
	GLIBC_BUILD = without-glibc
	GLIBC_CLEAN = without-glibc-clean
endif
ifeq ($(WITH_FFMPEG), 1)
	FFMPEG_BUILD = ffmpeg
	FFMPEG_CLEAN = ffmpeg-clean
	WITH_OPUS = 1
	WITH_OPENJPEG = 1
	WITH_LIBILBC = 1
	WITH_LIBGPG_ERROR = 1
	WITH_LIBGCRYPT = 1
	WITH_GMP = 1
else
	FFMPEG_BUILD = without-ffmpeg
	FFMPEG_CLEAN = without-ffmpeg-clean
endif
ifeq ($(WITH_KERNEL), 1)
	KERNEL_BUILD = kernel
	KERNEL_CLEAN = kernel-clean
else
	KERNEL_BUILD = without-kernel
	KERNEL_CLEAN = without-kernel-clean
endif
ifeq ($(WITH_OPUS), 1)
	OPUS_BUILD = opus
	OPUS_CLEAN = opus-clean
else
	OPUS_BUILD = without-opus
	OPUS_CLEAN = without-opus-clean
endif
ifeq ($(WITH_OPENJPEG), 1)
	OPENJPEG_BUILD = openjpeg
	OPENJPEG_CLEAN = openjpeg-clean
else
	OPENJPEG_BUILD = without-openjpeg
	OPENJPEG_CLEAN = without-openjpeg-clean
endif
ifeq ($(WITH_LIBILBC), 1)
	LIBILBC_BUILD = libilbc
	LIBILBC_CLEAN = libilbc-clean
else
	LIBILBC_BUILD = without-libilbc
	LIBILBC_CLEAN = without-libilbc-clean
endif
ifeq ($(WITH_LIBGPG_ERROR), 1)
	LIBGPG_ERROR_BUILD = libgpg-error
	LIBGPG_ERROR_CLEAN = libgpg-error-clean
else
	LIBGPG_ERROR_BUILD = without-libgpg-error
	LIBGPG_ERROR_CLEAN = without-libgpg-error-clean
endif
ifeq ($(WITH_LIBGCRYPT), 1)
	LIBGCRYPT_BUILD = libgcrypt
	LIBGCRYPT_CLEAN = libgcrypt-clean
else
	LIBGCRYPT_BUILD = without-libgcrypt
	LIBGCRYPT_CLEAN = without-libgcrypt-clean
endif
ifeq ($(WITH_GMP), 1)
	GMP_BUILD = gmp
	GMP_CLEAN = gmp-clean
else
	GMP_BUILD = without-gmp
	GMP_CLEAN = without-gmp-clean
endif
ifeq ($(WITH_PHP), 1)
	PHP_BUILD = php
	PHP_CLEAN = php-clean
else
	PHP_BUILD = without-php
	PHP_CLEAN = without-php-clean
endif
ifeq ($(WITH_PYTHON), 1)
	PYTHON_BUILD = python
	PYTHON_CLEAN = python-clean
else
	PYTHON_BUILD = without-python
	PYTHON_CLEAN = without-python-clean
endif

# Zu verwendende LIBC (uclibc => default, glibc => not working currently, musl => not tested)
USE_LIBC ?= uclibc

# Definiere Pfade
ROOT_DIR := $(shell pwd)
DOWNLOAD_DIR := $(ROOT_DIR)/download
TOOLCHAIN_BASE_DIR := $(ROOT_DIR)/toolchain
TOOLCHAIN_UCLIBC_DIR := $(TOOLCHAIN_BASE_DIR)/uclibc
TOOLCHAIN_GLIBC_DIR := $(TOOLCHAIN_BASE_DIR)/glibc
TOOLCHAIN_MUSL_DIR := $(TOOLCHAIN_BASE_DIR)/musl
TOOLCHAIN_HOST_DIR := /usr
ifeq ($(USE_LIBC), glibc)
	TOOLCHAIN_DIR := $(TOOLCHAIN_GLIBC_DIR)
else ifeq ($(USE_LIBC), uclibc)
	TOOLCHAIN_DIR := $(TOOLCHAIN_UCLIBC_DIR)
else ifeq ($(USE_LIBC), musl)
	TOOLCHAIN_DIR := $(TOOLCHAIN_MUSL_DIR)
endif 
PACKAGES_DIR := $(ROOT_DIR)/packages
STAGING_DIR := $(ROOT_DIR)/staging
BUILD_DIR := $(ROOT_DIR)/build
HOST_DIR := $(ROOT_DIR)/host
SRC_DIR := $(ROOT_DIR)/src

# Hack paths
BUILD_HACK := $(BUILD_DIR)/mmcblk0p2/HACK
STAGE_HACK := $(STAGING_DIR)/tmp/sd/HACK

# SD card
SDCARD := /tmp/sd
SDROOT := $(SDCARD)/HACK

# Version
VERSION = $(shell cat version.txt)

# Host configuration
HOST_UCLIBC := arm-buildroot-linux-uclibcgnueabi
HOST_MUSL := arm-buildroot-linux-musleabi
HOST_GLIBC := arm-buildroot-linux-gnueabi

# Definiere die Toolchain-Pfade
TOOLCHAIN_UCLIBC_PATH := $(TOOLCHAIN_UCLIBC_DIR)
TOOLCHAIN_GLIBC_PATH := $(TOOLCHAIN_GLIBC_DIR)
TOOLCHAIN_MUSL_PATH := $(TOOLCHAIN_MUSL_DIR)
TOOLCHAIN_HOST_PATH := $(TOOLCHAIN_HOST_DIR)
ifeq ($(USE_LIBC), glibc)
	TOOLCHAIN_PATH := $(TOOLCHAIN_GLIBC_PATH)
else ifeq ($(USE_LIBC), uclibc)
	TOOLCHAIN_PATH := $(TOOLCHAIN_UCLIBC_PATH)
else ifeq ($(USE_LIBC), musl)
	TOOLCHAIN_PATH := $(TOOLCHAIN_MUSL_PATH)
endif
PKG_CONFIG_PATH := $(TOOLCHAIN_PATH)/lib/pkgconfig:$(TOOLCHAIN_PATH)/share/pkgconfig
PATH := $(HOST_DIR)/bin:$(TOOLCHAIN_PATH)/bin:$(TOOLCHAIN_UCLIBC_PATH)/bin:$(TOOLCHAIN_GLIBC_PATH)/bin:$(TOOLCHAIN_MUSL_PATH)/bin:$(PATH)

# GLIBC toolchain
C_UCLIBC := $(TOOLCHAIN_UCLIBC_PATH)/bin/$(HOST_UCLIBC)-gcc
CC_UCLIBC := $(TOOLCHAIN_UCLIBC_PATH)/bin/$(HOST_UCLIBC)-gcc
GCC_UCLIBC := $(TOOLCHAIN_UCLIBC_PATH)/bin/$(HOST_UCLIBC)-g++
CXX_UCLIBC := $(TOOLCHAIN_UCLIBC_PATH)/bin/$(HOST_UCLIBC)-g++
CPP_UCLIBC := $(TOOLCHAIN_UCLIBC_PATH)/bin/$(HOST_UCLIBC)-cpp
AR_UCLIBC := $(TOOLCHAIN_UCLIBC_PATH)/bin/$(HOST_UCLIBC)-ar
NM_UCLIBC := $(TOOLCHAIN_UCLIBC_PATH)/bin/$(HOST_UCLIBC)-nm
LD_UCLIBC := $(TOOLCHAIN_UCLIBC_PATH)/bin/$(HOST_UCLIBC)-ld
RANLIB_UCLIBC := $(TOOLCHAIN_UCLIBC_PATH)/bin/$(HOST_UCLIBC)-ranlib
STRIP_UCLIBC := $(TOOLCHAIN_UCLIBC_PATH)/bin/$(HOST_UCLIBC)-strip
AUTOCONF_UCLIBC := $(TOOLCHAIN_UCLIBC_PATH)/bin/autoconf
AUTOHEADER_UCLIBC := $(TOOLCHAIN_UCLIBC_PATH)/bin/autoheader
AUTOM4TE_UCLIBC := $(TOOLCHAIN_UCLIBC_PATH)/bin/autom4te
AUTORECONF_UCLIBC := $(TOOLCHAIN_UCLIBC_PATH)/bin/autoreconf
AUTOSCAN_UCLIBC := $(TOOLCHAIN_UCLIBC_PATH)/bin/autoscan
AUTOUPDATE_UCLIBC := $(TOOLCHAIN_UCLIBC_PATH)/bin/autoupdate
ACLOCAL_UCLIBC := $(TOOLCHAIN_UCLIBC_PATH)/bin/aclocal
IFNAMES_UCLIBC := $(TOOLCHAIN_UCLIBC_PATH)/bin/ifnames
FORCE_TOOLCHAIN_UCLIBC = PKG_CONFIG_PATH=$(TOOLCHAIN_UCLIBC_PATH)/lib/pkgconfig:$(TOOLCHAIN_UCLIBC_PATH)/share/pkgconfig PATH=$(TOOLCHAIN_UCLIBC_PATH)/bin:$(PATH) TOOLCHAIN_PATH=$(TOOLCHAIN_UCLIBC_PATH) C=$(C_UCLIBC) CC=$(CC_UCLIBC) GCC=$(GCC_UCLIBC) CXX=$(CXX_UCLIBC) CPP=$(CPP_UCLIBC) AR=$(AR_UCLIBC) NM=$(NM_UCLIBC) LD=$(LD_UCLIBC) RANLIB=$(RANLIB_UCLIBC) STRIP=$(STRIP_UCLIBC) AUTOCONF=$(AUTOCONF_UCLIBC) AUTOHEADER=$(AUTOHEADER_UCLIBC) AUTOM4TE=$(AUTOM4TE_UCLIBC) AUTORECONF=$(AUTORECONF_UCLIBC) AUTOSCAN=$(AUTOSCAN_UCLIBC) AUTOUPDATE=$(AUTOUPDATE_UCLIBC) ACLOCAL=$(ACLOCAL_UCLIBC) IFNAMES=$(IFNAMES_UCLIBC) HOST=$(HOST_UCLIBC) CROSS_PREFIX=$(HOST_UCLIBC)

# MUSL toolchain
C_MUSL := $(TOOLCHAIN_MUSL_PATH)/bin/$(HOST_MUSL)-gcc
CC_MUSL := $(TOOLCHAIN_MUSL_PATH)/bin/$(HOST_MUSL)-gcc
GCC_MUSL := $(TOOLCHAIN_MUSL_PATH)/bin/$(HOST_MUSL)-g++
CXX_MUSL := $(TOOLCHAIN_MUSL_PATH)/bin/$(HOST_MUSL)-g++
CPP_MUSL := $(TOOLCHAIN_MUSL_PATH)/bin/$(HOST_MUSL)-cpp
AR_MUSL := $(TOOLCHAIN_MUSL_PATH)/bin/$(HOST_MUSL)-ar
NM_MUSL := $(TOOLCHAIN_MUSL_PATH)/bin/$(HOST_MUSL)-nm
LD_MUSL := $(TOOLCHAIN_MUSL_PATH)/bin/$(HOST_MUSL)-ld
RANLIB_MUSL := $(TOOLCHAIN_MUSL_PATH)/bin/$(HOST_MUSL)-ranlib
STRIP_MUSL := $(TOOLCHAIN_MUSL_PATH)/bin/$(HOST_MUSL)-strip
AUTOCONF_MUSL := $(TOOLCHAIN_MUSL_PATH)/bin/autoconf
AUTOHEADER_MUSL := $(TOOLCHAIN_MUSL_PATH)/bin/autoheader
AUTOM4TE_MUSL := $(TOOLCHAIN_MUSL_PATH)/bin/autom4te
AUTORECONF_MUSL := $(TOOLCHAIN_MUSL_PATH)/bin/autoreconf
AUTOSCAN_MUSL := $(TOOLCHAIN_MUSL_PATH)/bin/autoscan
AUTOUPDATE_MUSL := $(TOOLCHAIN_MUSL_PATH)/bin/autoupdate
ACLOCAL_MUSL := $(TOOLCHAIN_MUSL_PATH)/bin/aclocal
IFNAMES_MUSL := $(TOOLCHAIN_MUSL_PATH)/bin/ifnames
FORCE_TOOLCHAIN_MUSL = PKG_CONFIG_PATH=$(TOOLCHAIN_MUSL_PATH)/lib/pkgconfig:$(TOOLCHAIN_MUSL_PATH)/share/pkgconfig PATH=$(TOOLCHAIN_MUSL_PATH)/bin:$(PATH) TOOLCHAIN_PATH=$(TOOLCHAIN_MUSL_PATH) C=$(C_MUSL) CC=$(CC_MUSL) GCC=$(GCC_MUSL) CXX=$(CXX_MUSL) CPP=$(CPP_MUSL) AR=$(AR_MUSL) NM=$(NM_MUSL) LD=$(LD_MUSL) RANLIB=$(RANLIB_MUSL) STRIP=$(STRIP_MUSL) AUTOCONF=$(AUTOCONF_MUSL) AUTOHEADER=$(AUTOHEADER_MUSL) AUTOM4TE=$(AUTOM4TE_MUSL) AUTORECONF=$(AUTORECONF_MUSL) AUTOSCAN=$(AUTOSCAN_MUSL) AUTOUPDATE=$(AUTOUPDATE_MUSL) ACLOCAL=$(ACLOCAL_MUSL) IFNAMES=$(IFNAMES_MUSL) HOST=$(HOST_MUSL) CROSS_PREFIX=$(HOST_MUSL)

# GLIBC toolchain
C_GLIBC := $(TOOLCHAIN_GLIBC_PATH)/bin/$(HOST_GLIBC)-gcc
CC_GLIBC := $(TOOLCHAIN_GLIBC_PATH)/bin/$(HOST_GLIBC)-gcc
GCC_GLIBC := $(TOOLCHAIN_GLIBC_PATH)/bin/$(HOST_GLIBC)-g++
CXX_GLIBC := $(TOOLCHAIN_GLIBC_PATH)/bin/$(HOST_GLIBC)-g++
CPP_GLIBC := $(TOOLCHAIN_GLIBC_PATH)/bin/$(HOST_GLIBC)-cpp
AR_GLIBC := $(TOOLCHAIN_GLIBC_PATH)/bin/$(HOST_GLIBC)-ar
NM_GLIBC := $(TOOLCHAIN_GLIBC_PATH)/bin/$(HOST_GLIBC)-nm
LD_GLIBC := $(TOOLCHAIN_GLIBC_PATH)/bin/$(HOST_GLIBC)-ld
RANLIB_GLIBC := $(TOOLCHAIN_GLIBC_PATH)/bin/$(HOST_GLIBC)-ranlib
STRIP_GLIBC := $(TOOLCHAIN_GLIBC_PATH)/bin/$(HOST_GLIBC)-strip
AUTOCONF_GLIBC := $(TOOLCHAIN_GLIBC_PATH)/bin/autoconf
AUTOHEADER_GLIBC := $(TOOLCHAIN_GLIBC_PATH)/bin/autoheader
AUTOM4TE_GLIBC := $(TOOLCHAIN_GLIBC_PATH)/bin/autom4te
AUTORECONF_GLIBC := $(TOOLCHAIN_GLIBC_PATH)/bin/autoreconf
AUTOSCAN_GLIBC := $(TOOLCHAIN_GLIBC_PATH)/bin/autoscan
AUTOUPDATE_GLIBC := $(TOOLCHAIN_GLIBC_PATH)/bin/autoupdate
ACLOCAL_GLIBC := $(TOOLCHAIN_GLIBC_PATH)/bin/aclocal
IFNAMES_GLIBC := $(TOOLCHAIN_GLIBC_PATH)/bin/ifnames
FORCE_TOOLCHAIN_GLIBC = PKG_CONFIG_PATH=$(TOOLCHAIN_GLIBC_PATH)/lib/pkgconfig:$(TOOLCHAIN_GLIBC_PATH)/share/pkgconfig PATH=$(TOOLCHAIN_GLIBC_PATH)/bin:$(PATH) TOOLCHAIN_PATH=$(TOOLCHAIN_GLIBC_PATH) C=$(C_GLIBC) CC=$(CC_GLIBC) GCC=$(GCC_GLIBC) CXX=$(CXX_GLIBC) CPP=$(CPP_GLIBC) AR=$(AR_GLIBC) NM=$(NM_GLIBC) LD=$(LD_GLIBC) RANLIB=$(RANLIB_GLIBC) STRIP=$(STRIP_GLIBC) AUTOCONF=$(AUTOCONF_GLIBC) AUTOHEADER=$(AUTOHEADER_GLIBC) AUTOM4TE=$(AUTOM4TE_GLIBC) AUTORECONF=$(AUTORECONF_GLIBC) AUTOSCAN=$(AUTOSCAN_GLIBC) AUTOUPDATE=$(AUTOUPDATE_GLIBC) ACLOCAL=$(ACLOCAL_GLIBC) IFNAMES=$(IFNAMES_GLIBC) HOST=$(HOST_GLIBC) CROSS_PREFIX=$(HOST_GLIBC)

# HOST toolchain
C_HOST := $(TOOLCHAIN_HOST_PATH)/bin/gcc
CC_HOST := $(TOOLCHAIN_HOST_PATH)/bin/gcc
GCC_HOST := $(TOOLCHAIN_HOST_PATH)/bin/g++
CXX_HOST := $(TOOLCHAIN_HOST_PATH)/bin/g++
CPP_HOST := $(TOOLCHAIN_HOST_PATH)/bin/cpp
AR_HOST := $(TOOLCHAIN_HOST_PATH)/bin/ar
NM_HOST := $(TOOLCHAIN_HOST_PATH)/bin/nm
LD_HOST := $(TOOLCHAIN_HOST_PATH)/bin/ld
RANLIB_HOST := $(TOOLCHAIN_HOST_PATH)/bin/ranlib
STRIP_HOST := $(TOOLCHAIN_HOST_PATH)/bin/strip
AUTOCONF_HOST := $(TOOLCHAIN_HOST_PATH)/bin/autoconf
AUTOHEADER_HOST := $(TOOLCHAIN_HOST_PATH)/bin/autoheader
AUTOM4TE_HOST := $(TOOLCHAIN_HOST_PATH)/bin/autom4te
AUTORECONF_HOST := $(TOOLCHAIN_HOST_PATH)/bin/autoreconf
AUTOSCAN_HOST := $(TOOLCHAIN_HOST_PATH)/bin/autoscan
AUTOUPDATE_HOST := $(TOOLCHAIN_HOST_PATH)/bin/autoupdate
ACLOCAL_HOST := $(TOOLCHAIN_HOST_PATH)/bin/aclocal
IFNAMES_HOST := $(TOOLCHAIN_HOST_PATH)/bin/ifnames
FORCE_TOOLCHAIN_HOST = PKG_CONFIG_PATH=$(TOOLCHAIN_HOST_PATH)/lib/pkgconfig:$(TOOLCHAIN_HOST_PATH)/share/pkgconfig PATH=$(TOOLCHAIN_HOST_PATH)/bin:$(PATH) TOOLCHAIN_PATH=$(TOOLCHAIN_HOST_PATH) C=$(C_HOST) CC=$(CC_HOST) GCC=$(GCC_HOST) CXX=$(CXX_HOST) CPP=$(CPP_HOST) AR=$(AR_HOST) NM=$(NM_HOST) LD=$(LD_HOST) RANLIB=$(RANLIB_HOST) STRIP=$(STRIP_HOST) AUTOCONF=$(AUTOCONF_HOST) AUTOHEADER=$(AUTOHEADER_HOST) AUTOM4TE=$(AUTOM4TE_HOST) AUTORECONF=$(AUTORECONF_HOST) AUTOSCAN=$(AUTOSCAN_HOST) AUTOUPDATE=$(AUTOUPDATE_HOST) ACLOCAL=$(ACLOCAL_HOST) IFNAMES=$(IFNAMES_HOST) HOST=$(HOST_HOST) CROSS_PREFIX=$(HOST_HOST)

# Definiere die Cross-Compiler Variablen
ifeq ($(USE_LIBC), glibc)
	HOST := $(HOST_GLIBC)
	C := $(C_GLIBC)
	CC := $(CC_GLIBC)
	GCC := $(GCC_GLIBC)
	CXX := $(CXX_GLIBC)
	CPP := $(CPP_GLIBC)
	AR := $(AR_GLIBC)
	NM := $(NM_GLIBC)
	LD := $(LD_GLIBC)
	RANLIB := $(RANLIB_GLIBC)
	STRIP := $(STRIP_GLIBC)
	AUTOCONF := $(AUTOCONF_GLIBC)
	AUTOHEADER := $(AUTOHEADER_GLIBC)
	AUTOM4TE := $(AUTOM4TE_GLIBC)
	AUTORECONF := $(AUTORECONF_GLIBC)
	ACLOCAL := $(ACLOCAL_GLIBC)
	AUTOSCAN := $(AUTOSCAN_GLIBC)
	AUTOUPDATE := $(AUTOUPDATE_GLIBC)
	IFNAMES := $(IFNAMES_GLIBC)
	CROSS_PREFIX := $(HOST_GLIBC)
else ifeq ($(USE_LIBC), uclibc)
	HOST := $(HOST_UCLIBC)
	C := $(C_UCLIBC)
	CC := $(CC_UCLIBC)
	GCC := $(GCC_UCLIBC)
	CXX := $(CXX_UCLIBC)
	CPP := $(CPP_UCLIBC)
	AR := $(AR_UCLIBC)
	NM := $(NM_UCLIBC)
	LD := $(LD_UCLIBC)
	RANLIB := $(RANLIB_UCLIBC)
	STRIP := $(STRIP_UCLIBC)
	AUTOCONF := $(AUTOCONF_UCLIBC)
	AUTOHEADER := $(AUTOHEADER_UCLIBC)
	AUTOM4TE := $(AUTOM4TE_UCLIBC)
	AUTORECONF := $(AUTORECONF_UCLIBC)
	ACLOCAL := $(ACLOCAL_UCLIBC)
	AUTOSCAN := $(AUTOSCAN_UCLIBC)
	AUTOUPDATE := $(AUTOUPDATE_UCLIBC)
	IFNAMES := $(IFNAMES_UCLIBC)
	CROSS_PREFIX := $(HOST_UCLIBC)
else ifeq ($(USE_LIBC), musl)
	HOST := $(HOST_MUSL)
	C := $(C_MUSL)
	CC := $(CC_MUSL)
	GCC := $(GCC_MUSL)
	CXX := $(CXX_MUSL)
	CPP := $(CPP_MUSL)
	AR := $(AR_MUSL)
	NM := $(NM_MUSL)
	LD := $(LD_MUSL)
	RANLIB := $(RANLIB_MUSL)
	STRIP := $(STRIP_MUSL)
	AUTOCONF := $(AUTOCONF_MUSL)
	AUTOHEADER := $(AUTOHEADER_MUSL)
	AUTOM4TE := $(AUTOM4TE_MUSL)
	AUTORECONF := $(AUTORECONF_MUSL)
	ACLOCAL := $(ACLOCAL_MUSL)
	AUTOSCAN := $(AUTOSCAN_MUSL)
	AUTOUPDATE := $(AUTOUPDATE_MUSL)
	IFNAMES := $(IFNAMES_MUSL)
	CROSS_PREFIX := $(HOST_MUSL)
endif

# Kernel version
KERNEL_VERSION := 4.4.192V2.1

# Toolchain version
TOOLCHAIN_VERSION := 2020.08-1

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
ONVIF := onvif_srvd-2.0
GMP := gmp-6.3.0
LIBGPG_ERROR := libgpg-error-1.51
LIBGCRYPT := libgcrypt-1.11.0
LIBILBC := libilbc-3.0.4
OPENJPEG := openjpeg-2.5.3
OPUS := opus-1.5.2
FFMPEG := ffmpeg-7.1
LIBEXECINFO := libexecinfo-1.1-rc2
RADARE2 := radare2-5.9.8
GLIBC := glibc-2.32
PHP := php-8.4.4
PYTHON := Python-3.13.2
KERNEL := linux-4.4.192
TOOLCHAIN_UCLIBC := armv5-eabi--uclibc--stable-$(TOOLCHAIN_VERSION)
TOOLCHAIN_GLIBC := armv5-eabi--glibc--stable-$(TOOLCHAIN_VERSION)
TOOLCHAIN_MUSL := armv5-eabi--musl--stable-$(TOOLCHAIN_VERSION)
ifeq ($(USE_LIBC), glibc)
	TOOLCHAIN := $(TOOLCHAIN_GLIBC)
else ifeq ($(USE_LIBC), uclibc)
	TOOLCHAIN := $(TOOLCHAIN_UCLIBC)
else ifeq ($(USE_LIBC), musl)
	TOOLCHAIN := $(TOOLCHAIN_MUSL)
endif

# Exportiere die Variablen für alle Ziele
export TOOLCHAIN_PATH PKG_CONFIG_PATH PATH C CC GCC CXX CPP AR RANLIB AUTOCONF AUTOHEADER AUTOM4TE AUTORECONF ACLOCAL AUTOSCAN AUTOUPDATE IFNAMES CROSS_PREFIX

# Liste der zu ladenden Pakete
URLS := \
    $(DOWNLOAD_URL)/$(TOOLCHAIN_UCLIBC).tar.bz2?download=\#/$(TOOLCHAIN_UCLIBC).tar.bz2 \
    $(DOWNLOAD_URL)/$(TOOLCHAIN_GLIBC).tar.bz2?download=\#/$(TOOLCHAIN_GLIBC).tar.bz2 \
    $(DOWNLOAD_URL)/$(TOOLCHAIN_MUSL).tar.bz2?download=\#/$(TOOLCHAIN_MUSL).tar.bz2 \
    $(DOWNLOAD_URL)/$(KERNEL).tar.gz?download=\#/$(KERNEL).tar.gz \
    $(DOWNLOAD_URL)/$(LIBPCAP).tar.gz?download=\#/$(LIBPCAP).tar.gz \
    $(DOWNLOAD_URL)/$(TCPDUMP).tar.gz?download=\#/$(TCPDUMP).tar.gz \
    $(DOWNLOAD_URL)/$(OPENSSL).tar.gz?download=\#/$(OPENSSL).tar.gz \
    $(DOWNLOAD_URL)/$(BUSYBOX).tar.bz2?download=\#/$(BUSYBOX).tar.bz2 \
    $(DOWNLOAD_URL)/$(JOE).tar.gz?download=\#/$(JOE).tar.gz \
    $(DOWNLOAD_URL)/$(STRACE).tar.xz?download=\#/$(STRACE).tar.xz \
    $(DOWNLOAD_URL)/$(ZLIB).tar.gz?download=\#/$(ZLIB).tar.gz \
    $(DOWNLOAD_URL)/$(SQLITE3).tar.gz?download=\#/$(SQLITE3).tar.gz \
    $(DOWNLOAD_URL)/$(SQLCIPHER).tar.gz?download=\#/$(SQLCIPHER).tar.gz \
    $(DOWNLOAD_URL)/$(CURL).tar.gz?download=\#/$(CURL).tar.gz \
    $(DOWNLOAD_URL)/cacert.pem?download=\#/cacert.pem \
    $(DOWNLOAD_URL)/$(MSMTP).tar.xz?download=\#/$(MSMTP).tar.xz \
    $(DOWNLOAD_URL)/$(CJSON).tar.gz?download=\#/$(CJSON).tar.gz \
    $(DOWNLOAD_URL)/$(MOSQUITTO).tar.gz?download=\#/$(MOSQUITTO).tar.gz \
    $(DOWNLOAD_URL)/$(GSOAP).zip?download=\#/$(GSOAP).zip \
    $(DOWNLOAD_URL)/$(ONVIF).tar.gz?download=\#/$(ONVIF).tar.gz \
    $(DOWNLOAD_URL)/$(FFMPEG).tar.xz?download=\#/$(FFMPEG).tar.xz \
    $(DOWNLOAD_URL)/$(GMP).tar.xz?download=\#/$(GMP).tar.xz \
    $(DOWNLOAD_URL)/$(LIBGPG_ERROR).tar.bz2?download=\#/$(LIBGPG_ERROR).tar.bz2 \
    $(DOWNLOAD_URL)/$(LIBGCRYPT).tar.bz2?download=\#/$(LIBGCRYPT).tar.bz2 \
    $(DOWNLOAD_URL)/$(LIBILBC).tar.gz?download=\#/$(LIBILBC).tar.gz \
    $(DOWNLOAD_URL)/$(OPENJPEG).tar.gz?download=\#/$(OPENJPEG).tar.gz \
    $(DOWNLOAD_URL)/$(OPUS).tar.gz?download=\#/$(OPUS).tar.gz \
    $(DOWNLOAD_URL)/$(RADARE2).tar.gz?download=\#/$(RADARE2).tar.gz \
    $(DOWNLOAD_URL)/$(LIBEXECINFO).tar.gz?download=\#/$(LIBEXECINFO).tar.gz \
    $(DOWNLOAD_URL)/$(GLIBC).tar.gz?download=\#/$(GLIBC).tar.gz \
    $(DOWNLOAD_URL)/$(PHP).tar.gz?download=\#/$(PHP).tar.gz \
    $(DOWNLOAD_URL)/$(PYTHON).tar.xz?download=\#/$(PYTHON).tar.xz \
    $(DOWNLOAD_URL)/$(MINIUPNPC).tar.gz?download=\#/$(MINIUPNPC).tar.gz

# Ziele definieren
all: download toolchain packages staging host build

download: $(DOWNLOAD_DIR) $(patsubst %,$(DOWNLOAD_DIR)/%,$(notdir $(URLS)))

$(TOOLCHAIN_UCLIBC_DIR)/buildroot.config: $(TOOLCHAIN_UCLIBC_DIR)
	@echo "Extracting toolchain $(TOOLCHAIN_UCLIBC)"
	@tar -xf $(DOWNLOAD_DIR)/$(TOOLCHAIN_UCLIBC).tar.bz2 -C $(TOOLCHAIN_UCLIBC_DIR) --strip-components=1
	@cp /usr/bin/autom4te $(AUTOM4TE_UCLIBC)
	@cp /usr/bin/aclocal $(ACLOCAL_UCLIBC)
	@cp /usr/bin/autoheader $(AUTOHEADER_UCLIBC)
	@cp /usr/bin/autoreconf $(AUTORECONF_UCLIBC)
	@cp /usr/bin/autoscan $(AUTOSCAN_UCLIBC)
	@cp /usr/bin/autoupdate $(AUTOUPDATE_UCLIBC)
	@cp /usr/bin/ifnames $(IFNAMES_UCLIBC)
	@touch $@
	
$(TOOLCHAIN_GLIBC_DIR)/buildroot.config: $(TOOLCHAIN_GLIBC_DIR)
	@echo "Extracting toolchain $(TOOLCHAIN_GLIBC)"
	@tar -xf $(DOWNLOAD_DIR)/$(TOOLCHAIN_GLIBC).tar.bz2 -C $(TOOLCHAIN_GLIBC_DIR) --strip-components=1
	@cp /usr/bin/autom4te $(AUTOM4TE_GLIBC)
	@cp /usr/bin/aclocal $(ACLOCAL_GLIBC)
	@cp /usr/bin/autoheader $(AUTOHEADER_GLIBC)
	@cp /usr/bin/autoreconf $(AUTORECONF_GLIBC)
	@cp /usr/bin/autoscan $(AUTOSCAN_GLIBC)
	@cp /usr/bin/autoupdate $(AUTOUPDATE_GLIBC)
	@cp /usr/bin/ifnames $(IFNAMES_GLIBC)
	@touch $@
	
$(TOOLCHAIN_MUSL_DIR)/buildroot.config: $(TOOLCHAIN_MUSL_DIR)
	@echo "Extracting toolchain $(TOOLCHAIN_MUSL)"
	@tar -xf $(DOWNLOAD_DIR)/$(TOOLCHAIN_MUSL).tar.bz2 -C $(TOOLCHAIN_MUSL_DIR) --strip-components=1
	@cp /usr/bin/autom4te $(AUTOM4TE_MUSL)
	@cp /usr/bin/aclocal $(ACLOCAL_MUSL)
	@cp /usr/bin/autoheader $(AUTOHEADER_MUSL)
	@cp /usr/bin/autoreconf $(AUTORECONF_MUSL)
	@cp /usr/bin/autoscan $(AUTOSCAN_MUSL)
	@cp /usr/bin/autoupdate $(AUTOUPDATE_MUSL)
	@cp /usr/bin/ifnames $(IFNAMES_MUSL)
	@touch $@
	
toolchain-uclibc: $(TOOLCHAIN_UCLIBC_DIR)/buildroot.config

toolchain-glibc: $(TOOLCHAIN_GLIBC_DIR)/buildroot.config

toolchain-musl: $(TOOLCHAIN_MUSL_DIR)/buildroot.config

toolchain: toolchain-uclibc toolchain-glibc toolchain-musl

$(PACKAGES_DIR)/cacert.pem: $(PACKAGES_DIR)
	@for file in $(DOWNLOAD_DIR)/*; do \
	  if [ "$$file" != "$(DOWNLOAD_DIR)/$(TOOLCHAIN_UCLIBC).tar.bz2" -a "$$file" != "$(DOWNLOAD_DIR)/$(TOOLCHAIN_GLIBC).tar.bz2" -a "$$file" != "$(DOWNLOAD_DIR)/$(TOOLCHAIN_MUSL).tar.bz2" -a "$$file" != "$(DOWNLOAD_DIR)/cacert.pem" ]; then \
	  	cd $(PACKAGES_DIR); \
	  	echo  "Extracting package $$file"; \
	  	unzip -oqq $$file 2>/dev/null || tar -xf $$file -C $(PACKAGES_DIR) || echo "skipped"; \
	  fi; \
	done
	@touch $@
	
packages: $(PACKAGES_DIR)/cacert.pem

$(DOWNLOAD_DIR):
	@mkdir -p $@

$(TOOLCHAIN_UCLIBC_DIR):
	@mkdir -p $@

$(TOOLCHAIN_GLIBC_DIR):
	@mkdir -p $@

$(TOOLCHAIN_MUSL_DIR):
	@mkdir -p $@

$(PACKAGES_DIR):
	@mkdir -p $@

$(STAGING_DIR):
	@mkdir -p $@

$(BUILD_DIR):
	@make update-version-revision
	@mkdir -p $@
	
$(HOST_DIR):
	@mkdir -p $@

$(DOWNLOAD_DIR)/%:
	@echo "Downloading $(@F)..."
	@wget -c -O $@ $(filter %$(@F),$(URLS))
	
$(PACKAGES_DIR)/$(LIBPCAP)/config.status:
	@cd $(PACKAGES_DIR)/$(LIBPCAP); ./configure --host=$(HOST) CC=$(CC) --prefix=$(SDROOT) --sysconfdir=$(SDROOT)/etc/config --datarootdir=$(SDROOT)/usr/share
	
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
	@make -C $(PACKAGES_DIR)/$(TCPDUMP) -j$(nproc)
	@touch $@
	
$(STAGING_DIR)/$(SDROOT)/bin/tcpdump: $(PACKAGES_DIR)/$(TCPDUMP)/tcpdump
	@make -C $(PACKAGES_DIR)/$(TCPDUMP) install DESTDIR=$(STAGING_DIR)
	@rm $(STAGING_DIR)/$(SDROOT)/bin/tcpdump.4.99.4 || true
	@$(STRIP) $(STAGING_DIR)/$(SDROOT)/bin/tcpdump
	@touch $@

tcpdump: $(STAGING_DIR)/$(SDROOT)/bin/tcpdump

tcpdump-clean:
	@make -C $(PACKAGES_DIR)/$(TCPDUMP) clean distclean

$(PACKAGES_DIR)/$(OPENSSL)/configdata.pm:
	@cd $(PACKAGES_DIR)/$(OPENSSL); ./Configure linux-generic32 no-shared no-dso no-tests no-threads no-zlib no-async no-comp --prefix=$(SDROOT) --openssldir=$(SDROOT)/etc/config/ssl CC=$(CC) AR=$(AR) RANLIB=$(RANLIB)
	
$(PACKAGES_DIR)/$(OPENSSL)/apps/openssl: $(PACKAGES_DIR)/$(OPENSSL)/configdata.pm
	@make -C $(PACKAGES_DIR)/$(OPENSSL) -j$(nproc) build_sw
	
$(STAGING_DIR)/$(SDROOT)/bin/openssl: $(PACKAGES_DIR)/$(OPENSSL)/apps/openssl
	@make -C $(PACKAGES_DIR)/$(OPENSSL) install_sw install_ssldirs DESTDIR=$(STAGING_DIR)
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
	@cd $(PACKAGES_DIR)/$(SQLCIPHER); ./configure --host=$(HOST) --prefix=$(SDROOT) --sysconfdir=$(SDROOT)/etc/config --datarootdir=$(SDROOT)/usr/share --with-sysroot=$(STAGING_DIR)/$(SDROOT) CFLAGS="-I$(STAGING_DIR)/$(SDROOT)/include -DSQLITE_HAS_CODEC -DSQLCIPHER_CRYPTO_OPENSSL" LDFLAGS="-L$(STAGING_DIR)/$(SDROOT)/lib -lssl -lcrypto"

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

$(PACKAGES_DIR)/miniupnp-$(MINIUPNPC)/miniupnpc/build/upnpc-shared:
	@INSTALLPREFIX=$(SDROOT) make -C $(PACKAGES_DIR)/miniupnp-$(MINIUPNPC)/miniupnpc -j$(nproc) 
	
$(STAGING_DIR)/$(SDROOT)/bin/upnpc: $(PACKAGES_DIR)/miniupnp-$(MINIUPNPC)/miniupnpc/build/upnpc-shared
	@make -C $(PACKAGES_DIR)/miniupnp-$(MINIUPNPC)/miniupnpc install DESTDIR=$(STAGING_DIR)/$(SDROOT) INSTALLDIRINC=$(STAGING_DIR)/$(SDROOT)/include INSTALLDIRLIB=$(STAGING_DIR)/$(SDROOT)/lib INSTALLDIRBIN=$(STAGING_DIR)/$(SDROOT)/bin
	@cp $(PACKAGES_DIR)/miniupnp-$(MINIUPNPC)/miniupnpc/build/upnpc-shared $(STAGING_DIR)/$(SDROOT)/bin/upnpc
	@cp $(PACKAGES_DIR)/miniupnp-$(MINIUPNPC)/miniupnpc/build/upnp-listdevices-shared $(STAGING_DIR)/$(SDROOT)/bin/upnp-listdevices
	@cp $(PACKAGES_DIR)/miniupnp-$(MINIUPNPC)/miniupnpc/build/libminiupnpc.so $(STAGING_DIR)/$(SDROOT)/lib/libminiupnpc.so.19
	@ln -sf $(STAGING_DIR)/$(SDROOT)/lib/libminiupnpc.so.19 $(STAGING_DIR)/$(SDROOT)/lib/libminiupnpc.so
	@$(STRIP) $(STAGING_DIR)/$(SDROOT)/bin/upnpc
	@$(STRIP) $(STAGING_DIR)/$(SDROOT)/bin/upnp-listdevices
		
miniupnpc: $(STAGING_DIR)/$(SDROOT)/bin/upnpc

miniupnpc-clean:
	@make -C $(PACKAGES_DIR)/$(MINIUPNPC) clean

$(PACKAGES_DIR)/$(CURL)/config.status:
	@cd $(PACKAGES_DIR)/$(CURL); ./configure --host=$(HOST) --prefix=$(SDROOT) --sysconfdir=$(SDROOT)/etc/config --datarootdir=$(SDROOT)/usr/share --with-ssl=$(STAGING_DIR)/$(SDROOT) --with-zlib --disable-ldap --enable-rtsp --disable-dict --enable-file --enable-telnet --enable-tftp --disable-pop3 --disable-imap --disable-smtp --disable-gopher --enable-ftp --enable-hsts --enable-headers-api --enable-websockets --with-ca-path=$(SDROOT)/etc/config/ssl --with-ca-bundle=$(SDROOT)/etc/config/ssl/ca-bundle --with-nghttp2 --enable-mqtt --enable-unix-sockets --enable-cookies --enable-socketpair --enable-http-auth --enable-bearer-auth --enable-digest-auth --enable-negotiate-auth --enable-verbose --disable-docs --enable-dnsshuffle --enable-doh --enable-mime --enable-bindlocal --enable-form-api --enable-dateparse --enable-netrc --enable-progress-meter --enable-get-easy-options --disable-manual LDFLAGS="-L$(STAGING_DIR)/$(SDROOT)/lib -lssl -lcrypto" CFLAGS="-I$(STAGING_DIR)/$(SDROOT)/include"

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

# Force busybox to use uclibc
$(PACKAGES_DIR)/$(BUSYBOX)/.config:
	@make -C $(PACKAGES_DIR)/$(BUSYBOX) defconfig
	@cp $(SRC_DIR)/patches/$(BUSYBOX)/uclibc-config $(PACKAGES_DIR)/$(BUSYBOX)/.config

$(PACKAGES_DIR)/$(BUSYBOX)/busybox: $(PACKAGES_DIR)/$(BUSYBOX)/.config
	@$(FORCE_TOOLCHAIN_UCLIBC) make -C $(PACKAGES_DIR)/$(BUSYBOX) -j$(nproc) 
	
$(STAGING_DIR)/$(SDROOT)/bin/busybox: $(PACKAGES_DIR)/$(BUSYBOX)/busybox
	@make -C $(PACKAGES_DIR)/$(BUSYBOX) install
	@cp $(PACKAGES_DIR)/$(BUSYBOX)/_install/bin/busybox $(STAGING_DIR)/$(SDROOT)/bin
	@$(STRIP_UCLIBC) $(STAGING_DIR)/$(SDROOT)/bin/busybox
	
busybox: $(STAGING_DIR)/$(SDROOT)/bin/busybox

busybox-clean:
	@make -C $(PACKAGES_DIR)/$(BUSYBOX) clean distclean

$(PACKAGES_DIR)/$(CJSON)/CMakeLists.txt.patch:
	@cp $(SRC_DIR)/patches/$(CJSON)/CMakeLists.txt $(PACKAGES_DIR)/$(CJSON)/CMakeLists.txt
	@touch $@

$(PACKAGES_DIR)/$(CJSON)/build/Makefile: $(PACKAGES_DIR)/$(CJSON)/CMakeLists.txt.patch
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

$(PACKAGES_DIR)/$(MOSQUITTO)/config.mk.patch: $(STAGING_DIR)/$(SDROOT)/bin/openssl $(STAGING_DIR)/$(SDROOT)/lib/libz.a
	@cp $(SRC_DIR)/patches/$(MOSQUITTO)/config.mk $(PACKAGES_DIR)/$(MOSQUITTO)/config.mk
	@touch $@

$(PACKAGES_DIR)/$(MOSQUITTO)/build/Makefile: $(PACKAGES_DIR)/$(MOSQUITTO)/config.mk.patch
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
	@cd $(PACKAGES_DIR)/$(GSOAP); ac_cv_func_malloc_0_nonnull=yes ./configure --host=$(HOST) --prefix=$(SDROOT) --sysconfdir=$(SDROOT)/etc/config --datarootdir=$(SDROOT)/usr/share --with-zlib=$(STAGING_DIR)/$(SDROOT) --with-openssl=$(STAGING_DIR)/$(SDROOT) LDFLAGS="-L$(STAGING_DIR)/$(SDROOT)/lib -lssl -lcrypto" CFLAGS="-I$(STAGING_DIR)/$(SDROOT)/include"
	@echo -e "all:\n\ninstall:\n" > $(PACKAGES_DIR)/$(GSOAP)/gsoap/wsdl/Makefile

$(PACKAGES_DIR)/$(GSOAP)/gsoap/libgsoap.a: $(PACKAGES_DIR)/$(GSOAP)/config.status
	@make -C $(PACKAGES_DIR)/$(GSOAP) -j$(nproc)
	
$(STAGING_DIR)/$(SDROOT)/lib/libgsoap.a: $(PACKAGES_DIR)/$(GSOAP)/gsoap/libgsoap.a
	@make -C $(PACKAGES_DIR)/$(GSOAP) install DESTDIR=$(STAGING_DIR)
		
gsoap: $(STAGING_DIR)/$(SDROOT)/lib/libgsoap.a

gsoap-clean:
	@make -C $(PACKAGES_DIR)/$(GSOAP) clean distclean
	
$(PACKAGES_DIR)/$(ONVIF)/CMakeLists.patch:
	@cd $(PACKAGES_DIR)/$(ONVIF); patch -p1 < $(SRC_DIR)/patches/$(ONVIF)/CMakeLists.patch
	@touch $@

$(PACKAGES_DIR)/$(ONVIF)/build/Makefile: $(PACKAGES_DIR)/$(ONVIF)/CMakeLists.patch
	@mkdir -p $(PACKAGES_DIR)/$(ONVIF)/build
	@cd $(PACKAGES_DIR)/$(ONVIF)/build; cmake ..

$(PACKAGES_DIR)/$(ONVIF)/build/onvif_srvd: $(PACKAGES_DIR)/$(ONVIF)/build/Makefile
	@cd $(PACKAGES_DIR)/$(ONVIF)/build; make

$(STAGING_DIR)/$(SDROOT)/sbin/onvif_srvd: $(PACKAGES_DIR)/$(ONVIF)/build/onvif_srvd
	@mkdir -p $(STAGING_DIR)/$(SDROOT)/sbin/ || true
	@cp $(PACKAGES_DIR)/$(ONVIF)/build/onvif_srvd $@
	@touch $@
	
$(STAGING_DIR)/$(SDROOT)/etc/onvif.token: $(STAGING_DIR)/$(SDROOT)/sbin/onvif_srvd
	@dd if=/dev/urandom count=32 2>/dev/null | sha512sum | awk '{print $1}' > $(STAGING_DIR)/$(SDROOT)/etc/onvif.token

onvif: $(STAGING_DIR)/$(SDROOT)/etc/onvif.token

onvif-clean:
	@rm -rf $(PACKAGES_DIR)/$(ONVIF)/build

$(PACKAGES_DIR)/$(LIBGPG_ERROR)/Makefile:
	@ln -sf $(PACKAGES_DIR)/$(LIBGPG_ERROR)/src/syscfg/lock-obj-pub.arm-unknown-linux-gnueabi.h $(PACKAGES_DIR)/$(LIBGPG_ERROR)/src/syscfg/lock-obj-pub.linux-uclibcgnueabi.h
	@ln -sf $(PACKAGES_DIR)/$(LIBGPG_ERROR)/src/syscfg/lock-obj-pub.arm-unknown-linux-gnueabi.h $(PACKAGES_DIR)/$(LIBGPG_ERROR)/src/syscfg/lock-obj-pub.linux-gnueabi.h
	@ln -sf $(PACKAGES_DIR)/$(LIBGPG_ERROR)/src/syscfg/lock-obj-pub.arm-unknown-linux-gnueabi.h $(PACKAGES_DIR)/$(LIBGPG_ERROR)/src/syscfg/lock-obj-pub.linux-musleabi.h
	@cd $(PACKAGES_DIR)/$(LIBGPG_ERROR); ./configure --prefix=$(SDROOT) --with-gnu-ld --host=$(HOST) --disable-nls \
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
	@cd $(PACKAGES_DIR)/$(LIBGCRYPT); ./configure --prefix=$(SDROOT) --enable-cxx --with-gnu-ld --host=$(HOST) --disable-asm \
	 --disable-jent-support --disable-padlock-support --disable-aesni-support --disable-shaext-support --disable-pclmul-support --disable-sse41-support \
	 --disable-drng-support --disable-avx-support --disable-avx2-support --disable-avx512-support --disable-gfni-support --disable-sve-support --disable-sve2-support --disable-ppc-crypto-support \
 	 --disable-doc --disable-optimization --disable-amd64-as-feature-detection --disable-instrumentation-munging --disable-O-flag-munging \
	 --with-libgpg-error-prefix=$(STAGING_DIR)/$(SDROOT) CFLAGS="-I$(STAGING_DIR)/$(SDROOT)/include -I$(STAGING_DIR)/$(SDROOT)/usr/include" LDFLAGS="-L$(STAGING_DIR)/$(SDROOT)/lib -L$(STAGING_DIR)/$(SDROOT)/usr/lib -lgpg-error"
	
$(PACKAGES_DIR)/$(LIBGCRYPT)/src/libgcrypt.la: $(PACKAGES_DIR)/$(LIBGCRYPT)/Makefile
	@make -C $(PACKAGES_DIR)/$(LIBGCRYPT) -j$(nproc)
	
$(STAGING_DIR)/$(SDROOT)/lib/libgcrypt.la: $(PACKAGES_DIR)/$(LIBGCRYPT)/src/libgcrypt.la
	@make -C $(PACKAGES_DIR)/$(LIBGCRYPT) install DESTDIR=$(STAGING_DIR)
	
libgcrypt: $(STAGING_DIR)/$(SDROOT)/lib/libgcrypt.la

libgcrypt-clean:
	@make -C $(PACKAGES_DIR)/$(LIBGCRYPT) clean distclean

$(PACKAGES_DIR)/$(GMP)/Makefile:
	@cd $(PACKAGES_DIR)/$(GMP); ./configure --prefix=$(SDROOT) --enable-cxx --with-gnu-ld --host=$(HOST)
	
$(PACKAGES_DIR)/$(GMP)/libgmp.la: $(PACKAGES_DIR)/$(GMP)/Makefile
	@make -C $(PACKAGES_DIR)/$(GMP) -j$(nproc)
	
$(STAGING_DIR)/$(SDROOT)/lib/libgmp.la: $(PACKAGES_DIR)/$(GMP)/libgmp.la
	@make -C $(PACKAGES_DIR)/$(GMP) install DESTDIR=$(STAGING_DIR)
	
gmp: $(STAGING_DIR)/$(SDROOT)/lib/libgmp.la

gmp-clean:
	@make -C $(PACKAGES_DIR)/$(GMP) clean distclean

$(PACKAGES_DIR)/$(LIBILBC)/build/Makefile:
	@mkdir -p $(PACKAGES_DIR)/$(LIBILBC)/build
	@cd $(PACKAGES_DIR)/$(LIBILBC)/build; cmake .. -DBUILD_SHARED_LIBS=on -DCMAKE_INSTALL_PREFIX=$(STAGING_DIR)/$(SDROOT)
		
$(PACKAGES_DIR)/$(LIBILBC)/build/libilbc.pc: $(PACKAGES_DIR)/$(LIBILBC)/build/Makefile
	@make -C $(PACKAGES_DIR)/$(LIBILBC)/build -j$(nproc)
	@touch $@
	
$(STAGING_DIR)/$(SDROOT)/lib/libilbc.pc: $(PACKAGES_DIR)/$(LIBILBC)/build/libilbc.pc
	@make -C $(PACKAGES_DIR)/$(LIBILBC)/build install
	@touch $@
			
libilbc: $(STAGING_DIR)/$(SDROOT)/lib/libilbc.pc

libilbc-clean:
	@rm -rf $(PACKAGES_DIR)/$(LIBILBC)/build

$(PACKAGES_DIR)/$(OPENJPEG)/build/Makefile:
	@mkdir -p $(PACKAGES_DIR)/$(OPENJPEG)/build
	@cd $(PACKAGES_DIR)/$(OPENJPEG)/build; cmake .. -DCMAKE_INSTALL_PREFIX=$(STAGING_DIR)/$(SDROOT)
	
$(PACKAGES_DIR)/$(OPENJPEG)/libopenjp2.so: $(PACKAGES_DIR)/$(OPENJPEG)/build/Makefile
	@make -C $(PACKAGES_DIR)/$(OPENJPEG)/build -j$(nproc)
	@touch $@
	
$(STAGING_DIR)/$(SDROOT)/lib/libopenjp2.so: $(PACKAGES_DIR)/$(OPENJPEG)/libopenjp2.so
	@make -C $(PACKAGES_DIR)/$(OPENJPEG)/build install
	@touch $@
	
openjpeg: $(STAGING_DIR)/$(SDROOT)/lib/libopenjp2.so

openjpeg-clean:
	@make -C $(PACKAGES_DIR)/$(OPENJPEG) clean distclean

$(PACKAGES_DIR)/$(OPUS)/Makefile:
	@cd $(PACKAGES_DIR)/$(OPUS); ./configure --prefix=$(SDROOT) --with-gnu-ld --host=$(HOST)
	
$(PACKAGES_DIR)/$(OPUS)/libopus.la: $(PACKAGES_DIR)/$(OPUS)/Makefile
	@make -C $(PACKAGES_DIR)/$(OPUS) -j$(nproc)
	
$(STAGING_DIR)/$(SDROOT)/lib/libopus.la: $(PACKAGES_DIR)/$(OPUS)/libopus.la
	@make -C $(PACKAGES_DIR)/$(OPUS) install DESTDIR=$(STAGING_DIR)
	
opus: $(STAGING_DIR)/$(SDROOT)/lib/libopus.la

opus-clean:
	@make -C $(PACKAGES_DIR)/$(OPUS) clean distclean

$(PACKAGES_DIR)/$(FFMPEG)/ffbuild/config.mak:
	@cp $(SRC_DIR)/patches/$(FFMPEG)/configure $(PACKAGES_DIR)/$(FFMPEG)/configure
	@cd $(PACKAGES_DIR)/$(FFMPEG); ./configure --prefix=$(SDROOT) --arch=arm --cross-prefix=$(HOST)- --target-os=linux \
	--extra-cflags="-Dstatic_assert=_Static_assert -I$(STAGING_DIR)/$(SDROOT)/include -I$(STAGING_DIR)/$(SDROOT)/usr/include" \
	--extra-ldflags="-L$(STAGING_DIR)/$(SDROOT)/lib -L$(STAGING_DIR)/$(SDROOT)/usr/lib" \
	--disable-static --enable-shared --enable-cross-compile --stdc=c11 --enable-gpl --enable-version3 --enable-small --enable-avcodec --enable-avformat --enable-swresample --enable-swscale \
	--disable-network --disable-filters --disable-indevs --disable-outdevs --disable-zlib --disable-bzlib --disable-doc --disable-encoders --disable-decoders --disable-protocols --disable-debug \
	--enable-decoder=h264,mpeg4,mp3,mjpeg --enable-encoder=h264,mpeg4,mp3,mjpeg --enable-muxer=h264,mpeg4,mp3,mjpeg,ts --enable-demuxer=h264,mpeg4,mp3,mjpeg,ts --enable-protocol=file,pipe --enable-filter=scale

$(PACKAGES_DIR)/$(FFMPEG)/ffprobe: $(PACKAGES_DIR)/$(FFMPEG)/ffbuild/config.mak
	@make -C $(PACKAGES_DIR)/$(FFMPEG) -j$(nproc)
	
$(STAGING_DIR)/$(SDROOT)/bin/ffprobe: $(PACKAGES_DIR)/$(FFMPEG)/ffprobe
	@make -C $(PACKAGES_DIR)/$(FFMPEG) install DESTDIR=$(STAGING_DIR)
	@touch $@
	
ffmpeg: $(STAGING_DIR)/$(SDROOT)/bin/ffprobe

ffmpeg-clean:
	@make -C $(PACKAGES_DIR)/$(FFMPEG) clean distclean

$(PACKAGES_DIR)/$(LIBEXECINFO)/libexecinfo.so:
	@make -C $(PACKAGES_DIR)/$(LIBEXECINFO) -j$(nproc) libexecinfo.so
	@touch $@

$(STAGING_DIR)/$(SDROOT)/lib/libexecinfo.so: $(PACKAGES_DIR)/$(LIBEXECINFO)/libexecinfo.so
	@make -C $(PACKAGES_DIR)/$(LIBEXECINFO) install PREFIX=$(SDROOT) DESTDIR=$(STAGING_DIR)
	@touch $@
		
libexecinfo: $(STAGING_DIR)/$(SDROOT)/lib/libexecinfo.so

libexecinfo-clean:
	@make -C $(PACKAGES_DIR)/$(LIBEXECINFO) clean

$(PACKAGES_DIR)/$(KERNEL)/.config:
	@make -C $(PACKAGES_DIR)/$(KERNEL) ARCH=arm CROSS_COMPILE=$(HOST)- defconfig
	@cp $(SRC_DIR)/patches/$(KERNEL)/.config $(PACKAGES_DIR)/$(KERNEL)/.config
	@touch $@

$(PACKAGES_DIR)/$(KERNEL)/.kernelmodules: $(PACKAGES_DIR)/$(KERNEL)/.config
	@make -C $(PACKAGES_DIR)/$(KERNEL) ARCH=arm CROSS_COMPILE=$(HOST)- HOSTCFLAGS="-fcommon" modules
	@touch $@
		
$(PACKAGES_DIR)/$(KERNEL)/.kernel: $(PACKAGES_DIR)/$(KERNEL)/.config
	@make -C $(PACKAGES_DIR)/$(KERNEL) ARCH=arm CROSS_COMPILE=$(HOST)- HOSTCFLAGS="-fcommon" zImage
	@touch $@
		
$(STAGING_DIR)/$(SDROOT)/.kernelmodules: $(PACKAGES_DIR)/$(KERNEL)/.kernelmodules
	@make -C $(PACKAGES_DIR)/$(KERNEL) ARCH=arm CROSS_COMPILE=$(HOST)- INSTALL_MOD_PATH=$(STAGING_DIR)/$(SDROOT) modules_install
	@touch $@
		
$(STAGING_DIR)/$(SDROOT)/.kernel: $(PACKAGES_DIR)/$(KERNEL)/.kernel
	@mkdir -p $(STAGING_DIR)/$(SDROOT)/usr/kernel || true
	@make -C $(PACKAGES_DIR)/$(KERNEL) ARCH=arm CROSS_COMPILE=$(HOST)- INSTALL_PATH=$(STAGING_DIR)/$(SDROOT)/usr/kernel install
	@touch $@
		
$(STAGING_DIR)/$(SDROOT)/.kernelheaders: $(PACKAGES_DIR)/$(KERNEL)/.config
	@make -C $(PACKAGES_DIR)/$(KERNEL) ARCH=arm CROSS_COMPILE=$(HOST)- INSTALL_HDR_PATH=$(STAGING_DIR)/$(SDROOT)/usr headers_install
	@touch $@
		
kernel: $(STAGING_DIR)/$(SDROOT)/.kernelmodules $(STAGING_DIR)/$(SDROOT)/.kernel $(STAGING_DIR)/$(SDROOT)/.kernelheaders

kernel-clean:
	@make -C $(PACKAGES_DIR)/$(KERNEL) clean mrproper

$(PACKAGES_DIR)/$(PHP)/config.status:
	@cd $(PACKAGES_DIR)/$(PHP); PKG_CONFIG_PATH=$(STAGING_DIR)/$(SDROOT)/lib/pkgconfig:$(TOOLCHAIN_PATH)/lib/pkgconfig:$(TOOLCHAIN_PATH)/share/pkgconfig ./configure --prefix=$(SDROOT) --host=$(HOST) \
	--datarootdir=$(SDROOT)/usr/share --disable-all --enable-sockets --enable-sysvmsg --enable-sysvsem --enable-sysvshm \
	--with-zlib=$(STAGING_DIR)/$(SDROOT)/include --with-openssl=$(STAGING_DIR)/$(SDROOT)/include/openssl \
	--with-openssl-legacy-provider --with-sqlite3=$(STAGING_DIR)/$(SDROOT)/include --with-curl=$(STAGING_DIR)/$(SDROOT)/include/curl \
	--disable-phpdbg --disable-short-tags --disable-ipv6 --disable-ctype --disable-flatfile --disable-dom --disable-mbregex --disable-opcache --disable-huge-code-pages --disable-opcache-jit \
	--disable-pdo --disable-phar --disable-tokenizer --disable-xml --disable-xmlreader --disable-xmlwriter --disable-mysqlnd-compression-support --disable-fiber-asm \
	--disable-zend-signals --without-libxml --without-cdb --without-iconv --without-pdo-sqlite \
	CFLAGS="-I$(STAGING_DIR)/$(SDROOT)/include --sysroot=$(TOOLCHAIN_PATH)/$(HOST)/sysroot -L$(STAGING_DIR)/$(SDROOT)/lib"
	@touch $@

$(PACKAGES_DIR)/$(PHP)/sapi/cli/php: $(PACKAGES_DIR)/$(PHP)/config.status
	@make -C $(PACKAGES_DIR)/$(PHP) -j$(nproc)
	@touch $@
	
$(STAGING_DIR)/$(SDROOT)/bin/php: $(PACKAGES_DIR)/$(PHP)/sapi/cli/php
	@make -C $(PACKAGES_DIR)/$(PHP) install INSTALL_ROOT=$(STAGING_DIR)
	@touch $@
	
php: $(STAGING_DIR)/$(SDROOT)/bin/php

php-clean:
	@make $(PACKAGES_DIR)/$(PHP) clean
	
$(PACKAGES_DIR)/$(PYTHON)/config.status.host:
	@cd $(PACKAGES_DIR)/$(PYTHON); $(FORCE_TOOLCHAIN_HOST) ./configure --prefix=/
	@touch $@

$(PACKAGES_DIR)/$(PYTHON)/python.host: $(PACKAGES_DIR)/$(PYTHON)/config.status.host
	@$(FORCE_TOOLCHAIN_HOST) make -C $(PACKAGES_DIR)/$(PYTHON) -j$(nproc)
	@touch $@
	
$(HOST_DIR)/bin/python3: $(PACKAGES_DIR)/$(PYTHON)/python.host
	@$(FORCE_TOOLCHAIN_HOST) make -C $(PACKAGES_DIR)/$(PYTHON) install DESTDIR=$(HOST_DIR)
	@touch $@

$(PACKAGES_DIR)/$(PYTHON)/python.host.clean:		
	@$(FORCE_TOOLCHAIN_HOST) make -C $(PACKAGES_DIR)/$(PYTHON) clean
	@touch $@
	
$(PACKAGES_DIR)/$(PYTHON)/config.status: $(HOST_DIR)/bin/python3 $(PACKAGES_DIR)/$(PYTHON)/python.host.clean
	@cd $(PACKAGES_DIR)/$(PYTHON); PKG_CONFIG_PATH=$(STAGING_DIR)/$(SDROOT)/lib/pkgconfig:$(TOOLCHAIN_PATH)/lib/pkgconfig:$(TOOLCHAIN_PATH)/share/pkgconfig ac_cv_file__dev_ptmx=no ac_cv_file__dev_ptc=no \
	./configure --disable-ipv6 --prefix=$(SDROOT) --host=$(HOST) --build=arm --datarootdir=$(SDROOT)/usr/share --with-openssl=$(STAGING_DIR)/$(SDROOT)/include/openssl --with-build-python=$(HOST_DIR)/bin/python3.13 \
	CFLAGS="-I$(STAGING_DIR)/$(SDROOT)/include --sysroot=$(TOOLCHAIN_PATH)/$(HOST)/sysroot -L$(STAGING_DIR)/$(SDROOT)/lib"
	@touch $@

$(PACKAGES_DIR)/$(PYTHON)/python: $(PACKAGES_DIR)/$(PYTHON)/config.status
	@make -C $(PACKAGES_DIR)/$(PYTHON) -j$(nproc) LDFLAGS="-L$(STAGING_DIR)/$(SDROOT)/lib -L$(STAGING_DIR)/$(SDROOT)/usr/lib -L$(STAGING_DIR)/$(SDROOT)/usr/local/lib"
	@touch $@
	
$(STAGING_DIR)/$(SDROOT)/bin/python: $(PACKAGES_DIR)/$(PYTHON)/python
	@make -C $(PACKAGES_DIR)/$(PYTHON) install PREFIX=$(SDROOT) DESTDIR=$(STAGING_DIR)
	@touch $@
	
python: $(STAGING_DIR)/$(SDROOT)/bin/python

python-clean:
	@make $(PACKAGES_DIR)/$(PYTHON) clean
	
# Force radare2 to use uclibc
$(PACKAGES_DIR)/$(RADARE2)/mk/$(HOST_UCLIBC)-gcc.mk:
	@cp $(SRC_DIR)/patches/$(RADARE2)/$(HOST_UCLIBC)-gcc.mk $(PACKAGES_DIR)/$(RADARE2)/mk
	@touch $@

$(PACKAGES_DIR)/$(RADARE2)/plugins.cfg: $(PACKAGES_DIR)/$(RADARE2)/mk/$(HOST_UCLIBC)-gcc.mk
	@cd $(PACKAGES_DIR)/$(RADARE2); $(FORCE_TOOLCHAIN_UCLIBC) ./configure --host=$(HOST_UCLIBC) --with-compiler=$(HOST_UCLIBC)-gcc --with-capstone-next --without-gperf \
	--prefix=$(SDROOT) --etcdir=$(SDROOT)/etc/config --includedir=$(SDROOT)/usr/include --datadir=$(SDROOT)/usr/share --with-ssl CROSS_ROOT=$(TOOLCHAIN_UCLIBC_PATH)/bin
	@touch $@

$(PACKAGES_DIR)/$(RADARE2)/libr/include/fenv.h: $(PACKAGES_DIR)/$(RADARE2)/plugins.cfg
	@cd $(PACKAGES_DIR)/$(RADARE2)/binr/r2r; patch < $(SRC_DIR)/patches/$(RADARE2)/_binr_r2r.c.patch
	@cp $(SRC_DIR)/patches/$(RADARE2)/fenv.h $(PACKAGES_DIR)/$(RADARE2)/libr/include/fenv.h
	@touch $@

$(PACKAGES_DIR)/$(RADARE2)/binr/radare2/radare2: $(PACKAGES_DIR)/$(RADARE2)/libr/include/fenv.h
	@cp $(STAGING_DIR)/$(SDROOT)/include/execinfo.h $(PACKAGES_DIR)/$(RADARE2)/libr/include
	@$(FORCE_TOOLCHAIN_UCLIBC) make -C $(PACKAGES_DIR)/$(RADARE2) -j$(nproc) CROSS_ROOT=$(TOOLCHAIN_UCLIBC_PATH)/bin \
	XTRA_LDFLAGS="-L$(STAGING_DIR)/$(SDROOT)/lib -lexecinfo -latomic"
	
$(STAGING_DIR)/$(SDROOT)/bin/radare2: $(PACKAGES_DIR)/$(RADARE2)/binr/radare2/radare2
	@make -C $(PACKAGES_DIR)/$(RADARE2) install DESTDIR=$(STAGING_DIR) CROSS_ROOT=$(TOOLCHAIN_UCLIBC_PATH)/bin
	@touch $@
	
radare2: $(STAGING_DIR)/$(SDROOT)/bin/radare2

radare2-clean:
	@make -C $(PACKAGES_DIR)/$(RADARE2) mrproper || true
	@rm $(STAGING_DIR)/$(SDROOT)/bin/radare2 || true

$(PACKAGES_DIR)/$(GLIBC)/build/config.status: $(STAGING_DIR)/$(SDROOT)/.kernelheaders
	@mkdir $(PACKAGES_DIR)/$(GLIBC)/build || true
	@cd $(PACKAGES_DIR)/$(GLIBC)/build; ../configure --prefix=$(SDROOT) --host=$(HOST) --disable-timezone-tools --enable-kernel=4.4.192 \
	--disable-crypt --disable-build-nscd --with-bugurl=https://github.com/Bunkerschild/LSCamoflash --with-arch=armv5te --with-tune=arm926ej-s \
	--with-headers=$(STAGING_DIR)/$(SDROOT)/usr/include --with-default-link --disable-multi-arch \
	CFLAGS="-nostdinc -I$(STAGING_DIR)/$(SDROOT)/usr/include -O2 --sysroot=$(TOOLCHAIN_PATH)/$(HOST)/sysroot" LDFLAGS="-nostdlib"
	@touch $@

$(PACKAGES_DIR)/$(GLIBC)/build/libc.a: $(PACKAGES_DIR)/$(GLIBC)/build/config.status
	@make -C $(PACKAGES_DIR)/$(GLIBC)/build -j$(nproc) CFLAGS="-I$(STAGING_DIR)/$(SDROOT)/usr/include -O2"
	@touch $@
	
$(STAGING_DIR)/$(SDROOT)/lib/libc.a: $(PACKAGES_DIR)/$(GLIBC)/build/libc.a
	@make -C $(PACKAGES_DIR)/$(GLIBC)/build install PREFIX=$(SDROOT) DESTDIR=$(STAGING_DIR)
	@touch $@
	
glibc: $(STAGING_DIR)/$(SDROOT)/lib/libc.a

glibc-clean:
	@rm -rf $(PACKAGES_DIR)/$(GLIBC)/build
	
$(STAGING_DIR)/$(SDROOT)/lib/libuClibc-1.0.34.so:
	@cp -aL $(TOOLCHAIN_UCLIBC_PATH)/$(HOST_UCLIBC)/sysroot/lib/* $(STAGING_DIR)/$(SDROOT)/lib/
	@cp -aL $(TOOLCHAIN_UCLIBC_PATH)/$(HOST_UCLIBC)/sysroot/usr/lib/* $(STAGING_DIR)/$(SDROOT)/lib/
	@cp -f $(STAGING_DIR)/$(SDROOT)/lib/libc.so.1 $(STAGING_DIR)/$(SDROOT)/lib/libc.so
	@cp -f $(STAGING_DIR)/$(SDROOT)/lib/libgcc_s.so.1 $(STAGING_DIR)/$(SDROOT)/lib/libgcc_s.so
	@touch $@
	
staging: $(STAGING_DIR) libpcap tcpdump openssl zlib joe strace sqlite3 sqlcipher msmtp miniupnpc curl busybox cjson mosquitto gsoap onvif $(OPUS_BUILD) $(OPENJPEG_BUILD) $(LIBILBC_BUILD) $(LIBGPG_ERROR_BUILD) $(GMP_BUILD) $(LIBGCRYPT_BUILD) $(FFMPEG_BUILD) $(LIBEXECINFO_BUILD) $(PHP_BUILD) $(PYTHON_BUILD) $(KERNEL_BUILD) $(RADARE2_BUILD) $(GLIBC_BUILD) $(STAGING_DIR)/$(SDROOT)/lib/libuClibc-1.0.34.so

host: $(HOST_DIR)

$(BUILD_DIR)/install.ps1: $(BUILD_DIR)
	@cp -aL $(SRC_DIR)/sdcard/* $(BUILD_DIR) >/dev/null 2>&1 || true
	@make -C $(SRC_DIR)/contrib/motor DESTDIR=$(BUILD_DIR)/mmcblk0p2/HACK install
	@cp -aL $(STAGE_HACK)/lib/* $(BUILD_HACK)/lib >/dev/null 2>&1 || true
	@cp -aL $(STAGE_HACK)/usr/lib/* $(BUILD_HACK)/lib >/dev/null 2>&1 || true
	@cp -aL $(STAGE_HACK)/usr/local/lib/* $(BUILD_HACK)/lib >/dev/null 2>&1 || true
	@find $(BUILD_HACK)/lib -name "*.c" -exec rm {} \;
	@find $(BUILD_HACK)/lib -name "*.o" -exec rm {} \;
	@find $(BUILD_HACK)/lib -name "*.a" -exec rm {} \;
	@find $(BUILD_HACK)/lib -name "*.la" -exec rm {} \;
	@find $(BUILD_HACK)/lib -name "*.pc" -exec rm {} \;
	@find $(BUILD_HACK)/lib -name "*.cmake" -exec rm {} \;
	@rm -rf $(BUILD_HACK)/usr/share/locale >/dev/null 2>&1 || true
	@rm -rf $(BUILD_HACK)/lib/modules/$(KERNEL_VERSION)/build >/dev/null 2>&1 || true
	@rm -rf $(BUILD_HACK)/lib/modules/$(KERNEL_VERSION)/source >/dev/null 2>&1 || true
	@touch $@
	
$(BUILD_HACK)/sbin/mosquitto:
	@cp -a $(STAGE_HACK)/etc/mosquitto $(BUILD_HACK)/etc/config >/dev/null 2>&1 || true
	@cp $(STAGE_HACK)/usr/sbin/mosquitto $@ >/dev/null 2>&1 || true

$(BUILD_HACK)/bin/mosquitto_passwd:
	@cp $(STAGE_HACK)/usr/bin/mosquitto_passwd $@ >/dev/null 2>&1 || true

$(BUILD_HACK)/bin/mosquitto_sub:
	@cp $(STAGE_HACK)/usr/bin/mosquitto_sub $@ >/dev/null 2>&1 || true

$(BUILD_HACK)/bin/mosquitto_pub:
	@cp $(STAGE_HACK)/usr/bin/mosquitto_pub $@ >/dev/null 2>&1 || true

$(BUILD_HACK)/bin/mosquitto_rr:
	@cp $(STAGE_HACK)/usr/bin/mosquitto_rr $@ >/dev/null 2>&1 || true

$(BUILD_HACK)/bin/busybox:
	@cp $(STAGE_HACK)/bin/busybox $@ >/dev/null 2>&1 || true

$(BUILD_HACK)/bin/curl:
	@cp -a $(STATE_HACK)/usr/share/aclocal $(BUILD_HACK)/usr/share >/dev/null 2>&1 || true
	@cp $(STAGE_HACK)/bin/curl $@ >/dev/null 2>&1 || true

$(BUILD_HACK)/bin/curl-config:
	@cp $(STAGE_HACK)/bin/curl-config $@ >/dev/null 2>&1 || true

$(BUILD_HACK)/bin/joe:
	@cp -aL $(STAGE_HACK)/etc/config/joe $(BUILD_HACK)/etc/config >/dev/null 2>&1 || true
	@cp -aL $(STAGE_HACK)/usr/share/joe $(BUILD_HACK)/usr/share >/dev/null 2>&1 || true
	@cp $(STAGE_HACK)/bin/joe $(BUILD_HACK)/bin/rjoe >/dev/null 2>&1 || true
	@cp $(STAGE_HACK)/bin/joe $(BUILD_HACK)/bin/jmacs >/dev/null 2>&1 || true
	@cp $(STAGE_HACK)/bin/joe $(BUILD_HACK)/bin/jpico >/dev/null 2>&1 || true
	@cp $(STAGE_HACK)/bin/joe $(BUILD_HACK)/bin/jstar >/dev/null 2>&1 || true
	@cp $(STAGE_HACK)/bin/joe $@ >/dev/null 2>&1 || true

$(BUILD_HACK)/bin/python:
	@cp $(STAGE_HACK)/bin/python3.13 $(BUILD_HACK)/bin >/dev/null 2>&1 || true
	@cp $(STAGE_HACK)/bin/python3.13 $@ >/dev/null 2>&1 || true

$(BUILD_HACK)/bin/idle:
	@cp $(STAGE_HACK)/bin/idle3.13 $@ >/dev/null 2>&1 || true

$(BUILD_HACK)/bin/pydoc:
	@cp $(STAGE_HACK)/bin/pydoc3.13 $@ >/dev/null 2>&1 || true

$(BUILD_HACK)/bin/pip:
	@cp -aL $(STAGING_DIR)/$(HOST_DIR)/lib/python3.13/site-packages/* $(BUILD_HACK)/lib/python3.13/site-packages/ >/dev/null 2>&1 || true
	@cp $(STAGING_DIR)/$(HOST_DIR)/bin/pip3.13 $@ >/dev/null 2>&1 || true

$(BUILD_HACK)/bin/php:
	@cp $(STAGE_HACK)/bin/php $@ >/dev/null 2>&1 || true

$(BUILD_HACK)/bin/php-cgi:
	@cp $(STAGE_HACK)/bin/php-cgi $@ >/dev/null 2>&1 || true

$(BUILD_HACK)/bin/phpize:
	@cp $(STAGE_HACK)/bin/phpize $@ >/dev/null 2>&1 || true

$(BUILD_HACK)/bin/msmtp:
	@cp $(STAGE_HACK)/bin/msmtp $@ >/dev/null 2>&1 || true

$(BUILD_HACK)/sbin/msmtpd:
	@cp $(STAGE_HACK)/bin/msmtpd $@ >/dev/null 2>&1 || true

$(BUILD_HACK)/bin/openssl:
	@cp -aL $(STAGE_HACK)/etc/config/ssl $(BUILD_HACK)/etc/config >/dev/null 2>&1 || true
	@cp $(STAGE_HACK)/bin/openssl $@ >/dev/null 2>&1 || true

$(BUILD_HACK)/bin/pcap-config:
	@cp $(STAGE_HACK)/bin/pcap-config $@ >/dev/null 2>&1 || true

$(BUILD_HACK)/bin/sqlcipher:
	@cp $(STAGE_HACK)/bin/sqlcipher $@ >/dev/null 2>&1 || true

$(BUILD_HACK)/bin/sqlite3:
	@cp $(STAGE_HACK)/bin/sqlite3 $@ >/dev/null 2>&1 || true

$(BUILD_HACK)/bin/strace:
	@cp $(STAGE_HACK)/bin/strace $@ >/dev/null 2>&1 || true

$(BUILD_HACK)/bin/strace-log-merge:
	@cp $(STAGE_HACK)/bin/strace-log-merge $@ >/dev/null 2>&1 || true

$(BUILD_HACK)/bin/tcpdump:
	@cp $(STAGE_HACK)/bin/tcpdump $@ >/dev/null 2>&1 || true

$(BUILD_HACK)/bin/upnpc:
	@cp $(STAGE_HACK)/bin/upnpc $@ >/dev/null 2>&1 || true
	
$(BUILD_HACK)/sbin/onvif_srvd:
	@cp $(STAGE_HACK)/sbin/onvif_srvd $@ >/dev/null 2>&1 || true
	
$(BUILD_HACK)/bin/ffprobe:
	@cp $(STAGE_HACK)/bin/ffprobe $@ >/dev/null 2>&1 || true

$(BUILD_HACK)/bin/ffmpeg:
	@cp $(STAGE_HACK)/bin/ffmpeg $@ >/dev/null 2>&1 || true

$(BUILD_HACK)/bin/opj_dump:
	@cp $(STAGE_HACK)/bin/opj_dump $@ >/dev/null 2>&1 || true

$(BUILD_HACK)/bin/opj_compress:
	@cp $(STAGE_HACK)/bin/opj_compress $@ >/dev/null 2>&1 || true

$(BUILD_HACK)/bin/opj_decompress:
	@cp $(STAGE_HACK)/bin/opj_decompress $@ >/dev/null 2>&1 || true

$(BUILD_HACK)/bin/radare2:
	@mkdir -p $(BUILD_HACK)/share/radare2/5.9.8 >/dev/null 2>&1 || true
	@cp -aL $(STATE_HACK)/usr/share/radare2/5.9.4/* $(BUILD_HACK)/share/radare2/5.9.8/ >/dev/null 2>&1 || true
	@cp $(STAGE_HACK)/bin/radare2 $(BUILD_HACK)/bin/r2 >/dev/null 2>&1 || true
	@cp $(STAGE_HACK)/bin/radare2 $(BUILD_HACK)/bin/r2p >/dev/null 2>&1 || true
	@cp $(STAGE_HACK)/bin/radare2 $@ >/dev/null 2>&1 || true

$(BUILD_HACK)/bin/r2agent:
	@cp $(STAGE_HACK)/bin/r2agent $@ >/dev/null 2>&1 || true

$(BUILD_HACK)/bin/r2r:
	@cp $(STAGE_HACK)/bin/r2r $@ >/dev/null 2>&1 || true

$(BUILD_HACK)/bin/rasign2:
	@cp $(STAGE_HACK)/bin/rasign2 $@ >/dev/null 2>&1 || true

$(BUILD_HACK)/bin/rax2:
	@cp $(STAGE_HACK)/bin/rax2 $@ >/dev/null 2>&1 || true

$(BUILD_HACK)/bin/ragg2:
	@cp $(STAGE_HACK)/bin/ragg2 $@ >/dev/null 2>&1 || true

$(BUILD_HACK)/bin/rarun2:
	@cp $(STAGE_HACK)/bin/rarun2 $@ >/dev/null 2>&1 || true

$(BUILD_HACK)/bin/rabin2:
	@cp $(STAGE_HACK)/bin/rabin2 $@ >/dev/null 2>&1 || true

$(BUILD_HACK)/bin/radiff2:
	@cp $(STAGE_HACK)/bin/radiff2 $@ >/dev/null 2>&1 || true

$(BUILD_HACK)/bin/ravc2:
	@cp $(STAGE_HACK)/bin/ravc2 $@ >/dev/null 2>&1 || true

$(BUILD_HACK)/bin/rahash2:
	@cp $(STAGE_HACK)/bin/rahash2 $@ >/dev/null 2>&1 || true

$(BUILD_HACK)/bin/rafind2:
	@cp $(STAGE_HACK)/bin/rafind2 $@ >/dev/null 2>&1 || true

$(BUILD_HACK)/bin/r2pm:
	@cp $(STAGE_HACK)/bin/r2pm $@ >/dev/null 2>&1 || true

$(BUILD_HACK)/bin/rasm2:
	@cp $(STAGE_HACK)/bin/rasm2 $@ >/dev/null 2>&1 || true

$(BUILD_HACK)/etc/version.txt:
	@cp $(ROOT_DIR)/version.txt $@ >/dev/null 2>&1 || true
	@touch $@
	
$(BUILD_DIR)/LICENSE.md:
	@cp $(ROOT_DIR)/LICENSE.MIT $(BUILD_DIR)/LICENSE.MIT
	@cp $(ROOT_DIR)/LICENSE.md $@
	@touch $@

build: $(BUILD_DIR)/install.ps1 $(BUILD_HACK)/bin/radare2 $(BUILD_HACK)/bin/r2agent $(BUILD_HACK)/bin/r2r $(BUILD_HACK)/bin/rasign2 $(BUILD_HACK)/bin/rax2 $(BUILD_HACK)/bin/ragg2 $(BUILD_HACK)/bin/rarun2 $(BUILD_HACK)/bin/rabin2 \
       $(BUILD_HACK)/bin/radiff2 $(BUILD_HACK)/bin/ravc2 $(BUILD_HACK)/bin/rahash2 $(BUILD_HACK)/bin/rafind2 $(BUILD_HACK)/bin/r2pm $(BUILD_HACK)/bin/rasm2 $(BUILD_HACK)/bin/ffmpeg $(BUILD_HACK)/bin/ffprobe $(BUILD_HACK)/bin/opj_dump \
       $(BUILD_HACK)/bin/opj_compress $(BUILD_HACK)/bin/opj_decompress $(BUILD_HACK)/sbin/onvif_srvd $(BUILD_HACK)/bin/upnpc $(BUILD_HACK)/bin/tcpdump $(BUILD_HACK)/bin/strace-log-merge \
       $(BUILD_HACK)/bin/strace $(BUILD_HACK)/bin/sqlite3 $(BUILD_HACK)/bin/sqlcipher $(BUILD_HACK)/bin/pcap-config $(BUILD_HACK)/bin/openssl $(BUILD_HACK)/sbin/msmtpd $(BUILD_HACK)/bin/msmtp $(BUILD_HACK)/bin/joe \
       $(BUILD_HACK)/bin/curl-config $(BUILD_HACK)/bin/curl $(BUILD_HACK)/bin/busybox $(BUILD_HACK)/bin/mosquitto_rr $(BUILD_HACK)/bin/mosquitto_pub $(BUILD_HACK)/bin/mosquitto_sub $(BUILD_HACK)/bin/mosquitto_passwd \
       $(BUILD_HACK)/sbin/mosquitto $(BUILD_HACK)/bin/php $(BUILD_HACK)/bin/php-cgi $(BUILD_HACK)/bin/phpize $(BUILD_HACK)/bin/python $(BUILD_HACK)/bin/pydoc \
       $(BUILD_HACK)/bin/idle $(BUILD_HACK)/bin/pip $(BUILD_HACK)/etc/version.txt $(BUILD_DIR)/LICENSE.md
	
build-clean:
	@rm -rf $(BUILD_DIR)

staging-clean:
	@rm -rf $(STAGING_DIR)
	
host-clean:
	@rm -rf $(HOST_DIR)
	
packages-clean:
	@rm -rf $(PACKAGES_DIR)

download-clean:
	@rm -rf $(DOWNLOAD_DIR)

toolchain-uclibc-clean:
	@rm -rf $(TOOLCHAIN_UCLIBC_DIR)

toolchain-glibc-clean:
	@rm -rf $(TOOLCHAIN_GLIBC_DIR)

toolchain-clean: toolchain-uclibc-clean toolchain-glibc-clean
	@rm -rf $(TOOLCHAIN_BASE_DIR)
	
mrproper: mrproper-phase1 mrproper-phase2

mrproper-phase2: staging-clean build-clean
	@rm -f $(ROOT_DIR)/LSCamoflash-*.tar.gz || true
	@rm -f $(ROOT_DIR)/update-*.tgz || true

mrproper-phase1: packages-clean toolchain-clean host-clean

mrproper-full: download-clean mrproper
	
clean: $(GLIBC_CLEAN) $(RADARE2_CLEAN) $(KERNEL_CLEAN) $(PYTHON_CLEAN) $(PHP_CLEAN) $(LIBEXECINFO_CLEAN) $(FFMPEG_CLEAN) $(OPUS_CLEAN) $(OPENJPEG_CLEAN) $(LIBILBC_CLEAN) $(LIBGPG_ERROR_CLEAN) $(GMP_CLEAN) $(LIBGCRYPT_CLEAN) onvif-clean gsoap-clean mosquitto-clean cjson-clean busybox-clean curl-clean miniupnpc-clean msmtp-clean sqlcipher-clean sqlite3-clean strace-clean joe-clean zlib-clean openssl-clean tcpdump-clean libpcap-clean

update-version-major:
	@$(SRC_DIR)/bin/update-version.sh --major

update-version-minor:
	@$(SRC_DIR)/bin/update-version.sh --minor

update-version-revision:
	@$(SRC_DIR)/bin/update-version.sh --revision
	
version:
	@cat $(ROOT_DIR)/version.txt

LSCamoflash-$(VERSION)-$(USE_LIBC).tar.gz: download toolchain packages staging host build
	@tar -C $(BUILD_DIR) -cvzf $@ .
	@touch $@
	
update-$(VERSION)-$(USE_LIBC).tgz: download toolchain packages staging host build
	@tar -C $(BUILD_DIR) -cvzf $@ --exclude=mmcblk0p2/HACK/etc --exclude=mmcblk0p2/HACK/var/spool/cron/crontabs/root mmcblk0p1 mmcblk0p2
	@touch $@
	
release: LSCamoflash-$(VERSION)-$(USE_LIBC).tar.gz

update: update-$(VERSION)-$(USE_LIBC).tgz

build-test-glibc:
	@make USE_LIBC=glibc WITH_GLIBC=1 WITH_FFMPEG=1 WITH_KERNEL=1 WITH_PHP=1 mrproper download toolchain packages staging host

build-test-uclibc:
	@make USE_LIBC=uclibc WITH_RADARE2=1 WITH_FFMPEG=1 WITH_KERNEL=1 WITH_PHP=1 WITH_PYTHON=1mrproper download toolchain packages staging host

build-test-musl:
	@make USE_LIBC=musl mrproper download toolchain packages staging host

without-radare2:

without-radare2-clean:

without-glibc:

without-glibc-clean:

without-ffmpeg:

without-ffmpeg-clean:

without-libexecinfo:

without-libexecinfo-clean:

without-kernel:

without-kernel-clean:

without-gmp:

without-gmp-clean:

without-libgcrypt:

without-libgcrypt-clean:

without-libgpg-error:

without-libgpg-error-clean:

without-libilbc:

without-libilbc-clean:

without-openjpeg:

without-openjpeg-clean:

without-opus:

without-opus-clean:

without-php:

without-php-clean:

without-python:

without-python-clean:

all-and-optionals:
	@make all WITH_RADARE2=1 WITH_FFMPEG=1 WITH_KERNEL=1 WITH_PHP=1 WITH_PYTHON=1

install: all
	@cd $(BUILD_DIR); sh install.sh

.PHONY: all clean

