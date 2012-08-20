# binutils

BINUTILS := binutils
BINUTILS_VERSION := 2.22
BINUTILS_PKG := $(BINUTILS)-$(BINUTILS_VERSION).tar.bz2
BINUTILS_URL := $(BINUTILS_PKG)
BINUTILS_CFG := --target=$(TARGET) --disable-multilib --disable-static --enable-shared \
	--enable-lto --enable-cloog-backend=isl --disable-ppl-version-check \
	--disable-cloog-version-check --with-sysroot=$(PREFIX)/$(HOST) --prefix=$(PREFIX) \
	--with-gmp=$(PREFIX)/$(HOST) --with-mpfr=$(PREFIX)/$(HOST) --with-mpc=$(PREFIX)/$(HOST) \
	--with-ppl=$(PREFIX)/$(HOST) --with-cloog=$(PREFIX)/$(HOST) 

PKGS += $(BINUTILS)
ifeq ($(call need_pkg,"binutils"),)
PKGS_FOUND += $(BINUTILS)
endif

DEPS_$(BINUTILS) = gmp mpfr mpc ppl cloog

$(TARBALLS)/$(BINUTILS_PKG):
	$(call download,$(BINUTILS_URL))

.sum-$(BINUTILS): $(BINUTILS_PKG)

$(BINUTILS): $(BINUTILS_PKG) .sum-$(BINUTILS)
	$(UNPACK)
	$(MOVE)

.$(BINUTILS): $(BINUTILS)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(HOSTTOOLS) ./configure $(HOSTCONF) $(BINUTILS_CFG)
else
	cd $< && $(HOSTTOOLS) ./configure $(HOSTCONF) $(BINUTILS_CFG)
endif
	cd $< && $(MAKE) && $(MAKE) install
	touch $@
