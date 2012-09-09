# glibc-headers

GLIBC ?= glibc
GLIBC-HEADERS := glibc-headers
GLIBC-HEADERS_VERSION := 2.16.0
GLIBC-HEADERS_PKG := $(GLIBC)-$(GLIBC-HEADERS_VERSION).tar.xz
GLIBC-HEADERS_URL := http://ftp.gnu.org/gnu/glibc/$(GLIBC-HEADERS_PKG)
GLIBC-HEADERS_CFG := --host=$(HOST) --with-heaers=$(PREFIX)/usr/include

PKGS += $(GLIBC-HEADERS)
ifeq ($(call need_pkg,"glibc-headers"),)
PKGS_FOUND += $(GLIBC-HEADERS)
endif

DEPS_$(GLIBC-HEADERS) =

$(TARBALLS)/$(GLIBC-HEADERS_PKG):
	$(call download,$(GLIBC-HEADERS_URL))

.sum-$(GLIBC-HEADERS): $(GLIBC-HEADERS_PKG)

$(GLIBC): $(GLIBC-HEADERS_PKG) .sum-$(GLIBC-HEADERS)
	$(UNPACK)
	$(MOVE)

.$(GLIBC-HEADERS): $(GLIBC)
	mkdir -p $<-build
	cd $<-build && ../$</configure $(GLIBC-HEADERS_CFG)
	cd $< && $(MAKE) cross-compiling=yes install_root=$(PREFIX) install-headers
	touch $@
