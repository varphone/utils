# mingw-w64-crt

MINGW-W64 ?= mingw-w64
MINGW-W64-CRT := mingw-w64-crt
MINGW-W64-CRT_VERSION := svn
MINGW-W64-CRT_PKG := mingw-w64-$(MINGW-W64-CRT_VERSION).tar.xz
MINGW-W64-CRT_URL := $(MINGW-W64-CRT_PKG)
MINGW-W64-CRT_CFG := --host=$(TARGET) --with-sysroot=$(PREFIX) --prefix=$(PREFIX)/$(TARGET)

ifeq ($(TARGET),i686-w64-mingw32)
PKGS += $(MINGW-W64-CRT)
endif
ifeq ($(TARGET),x86_64-w64-mingw32)
PKGS += $(MINGW-W64-CRT)
endif
#ifeq ($(call need_pkg,"mingw-w64-crt"),)
#PKGS_FOUND += $(MINGW-W64-CRT)
#endif

DEPS_$(MINGW-W64-CRT) = binutils mingw-w64-headers gcc-core

export PATH := $(PREFIX)/bin:$(PATH)

$(TARBALLS)/$(MINGW-W64-CRT_PKG):
	$(call download,$(MINGW-W64-CRT_URL))

.sum-$(MINGW-W64-CRT): $(MINGW-W64-CRT_PKG)

$(MINGW-W64): $(MINGW-W64-CRT_PKG) .sum-$(MINGW-W64-CRT)
	$(UNPACK)
	$(MOVE)

.$(MINGW-W64-CRT): $(MINGW-W64)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $</mingw-w64-crt && ./configure $(MINGW-W64-CRT_CFG)
else
	cd $</mingw-w64-crt && ./configure $(MINGW-W64-CRT_CFG)
endif
	cd $</mingw-w64-crt && $(MAKE) install
	touch $@
