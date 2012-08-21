# mpfr

MPFR := mpfr
MPFR_VERSION := 3.1.1
MPFR_PKG := $(MPFR)-$(MPFR_VERSION).tar.bz2
MPFR_URL := http://www.mpfr.org/mpfr-current/$(MPFR_PKG)
MPFR_CFG := --prefix=$(PREFIX)/$(BUILD) --enable-static --disable-shared \
	--enable-thread-safe --with-gmp=$(PREFIX)/$(BUILD)

PKGS += $(MPFR)
ifeq ($(call need_pkg,"mpfr"),)
PKGS_FOUND += $(MPFR)
endif

DEPS_$(MPFR) = gmp

$(TARBALLS)/$(MPFR_PKG):
	$(call download,$(MPFR_URL))

.sum-$(MPFR): $(MPFR_PKG)

$(MPFR): $(MPFR_PKG) .sum-$(MPFR)
	$(UNPACK)
	$(MOVE)

.$(MPFR): $(MPFR)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && ./configure $(MPFR_CFG)
else
	cd $< && ./configure $(MPFR_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
