# polylib

POLYLIB := polylib
POLYLIB_VERSION := 5.22.5
POLYLIB_PKG := $(POLYLIB)-$(POLYLIB_VERSION).tar.gz
POLYLIB_URL := http://icps.u-strasbg.fr/polylib/polylib_src/$(POLYLIB_PKG)
POLYLIB_CFG := --target=$(HOST) --prefix=$(PREFIX)/$(HOST) --disable-static --enable-shared \
	--enable-int-lib --enable-longint-lib --enable-longlongint-lib

PKGS += $(POLYLIB)
ifeq ($(call need_pkg,"polylib"),)
PKGS_FOUND += $(POLYLIB)
endif

DEPS_$(POLYLIB) =

$(TARBALLS)/$(POLYLIB_PKG):
	$(call download,$(POLYLIB_URL))

.sum-$(POLYLIB): $(POLYLIB_PKG)

$(POLYLIB): $(POLYLIB_PKG) .sum-$(POLYLIB)
	$(UNPACK)
	$(MOVE)

.$(POLYLIB): $(POLYLIB)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(HOSTTOOLS) ./configure $(HOSTCONF) $(POLYLIB_CFG)
else
	cd $< && $(HOSTTOOLS) ./configure $(HOSTCONF) $(POLYLIB_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
