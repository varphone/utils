# binutils

BINUTILS := binutils
BINUTILS_VERSION := 2.22
BINUTILS_PKG := $(BINUTILS)-$(BINUTILS_VERSION).tar.bz2
BINUTILS_URL := http://ftp.gnu.org/gnu/binutils/$(BINUTILS_PKG)
BINUTILS_CFG := --target=$(TARGET) --disable-multilib --enable-static --disable-shared \
	--enable-lto --enable-cloog-backend=isl --disable-ppl-version-check \
	--disable-cloog-version-check --with-sysroot=$(PREFIX)/$(BUILD) --prefix=$(PREFIX) \
	--with-gmp=$(PREFIX)/$(BUILD) --with-mpfr=$(PREFIX)/$(BUILD) --with-mpc=$(PREFIX)/$(BUILD) \
	--with-ppl=$(PREFIX)/$(BUILD) --with-cloog=$(PREFIX)/$(BUILD) 

PKGS += $(BINUTILS)
#ifeq ($(call need_pkg,"binutils"),)
#PKGS_FOUND += $(BINUTILS)
#endif

DEPS_$(BINUTILS) = gmp $(DEPS_gmp) mpfr $(DEPS_mpfr) mpc $(DEPS_mpc) ppl $(DEPS_ppl) cloog $(DEPS_cloog)

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
	cd $< && ./configure $(BINUTILS_CFG)
else
	cd $< && ./configure $(BINUTILS_CFG)
endif
	cd $< && $(MAKE) && $(MAKE) install
	touch $@
