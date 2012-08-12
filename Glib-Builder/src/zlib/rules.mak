# zlib

ZLIB := zlib
ZLIB_VERSION := 1.2.7
ZLIB_PKG := zlib-$(ZLIB_VERSION).tar.bz2
ZLIB_URL := http://zlib.net/$(ZLIB_PKG)
ZLIB_CFG = --static --prefix=$(PREFIX)

PKGS += $(ZLIB)
ifeq ($(call need_pkg,"zlib"),)
PKGS_FOUND += $(ZLIB)
endif

$(TARBALLS)/$(ZLIB_PKG):
	$(call download,$(ZLIB_URL))

.sum-$(ZLIB): $(ZLIB_PKG)

$(ZLIB): $(ZLIB_PKG) .sum-$(ZLIB)
	$(UNPACK)
	$(MOVE)

.$(ZLIB): $(ZLIB)
#	$(RECONF)
	cd $< && $(HOSTVARS) ./configure $(ZLIB_CFG)
	cd $< && $(MAKE) install
	touch $@
