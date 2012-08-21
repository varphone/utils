# mingw-w64-headers

MINGW-W64-HEADERS := mingw-w64-headers
MINGW-W64-HEADERS_VERSION := svn
MINGW-W64-HEADERS_PKG := mingw-w64-$(MINGW-W64-HEADERS_VERSION).tar.xz
MINGW-W64-HEADERS_URL := https://mingw-w64.svn.sourceforge.net/svnroot/mingw-w64/trunk
MINGW-W64-HEADERS_CFG := --host=$(TARGET) --prefix=$(PREFIX)/$(TARGET)

PKGS += $(MINGW-W64-HEADERS)
ifeq ($(call need_pkg,"mingw-w64-headers"),)
PKGS_FOUND += $(MINGW-W64-HEADERS)
endif

DEPS_$(MINGW-W64-HEADERS) = binutils

$(TARBALLS)/$(MINGW-W64-HEADERS_PKG):
	$(call download_svn,$(MINGW-W64-HEADERS_URL))

.sum-$(MINGW-W64-HEADERS): $(MINGW-W64-HEADERS_PKG)

$(MINGW-W64-HEADERS): $(MINGW-W64-HEADERS_PKG) .sum-$(MINGW-W64-HEADERS)
	$(UNPACK)
	$(MOVE)

.$(MINGW-W64-HEADERS): $(MINGW-W64-HEADERS)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $</mingw-w64-headers && PATH=$(PREFIX)/bin:${PATH} ./configure $(MINGW-W64-HEADERS_CFG)
else
	cd $</mingw-w64-headers && PATH=$(PREFIX)/bin:${PATH} ./configure $(MINGW-W64-HEADERS_CFG)
endif
	cd $</mingw-w64-headers && $(MAKE) install
	touch $@
