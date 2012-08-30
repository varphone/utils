# cloog

CLOOG := cloog
CLOOG_VERSION := 0.17.0
CLOOG_PKG := $(CLOOG)-$(CLOOG_VERSION).tar.gz
CLOOG_URL := ftp://gcc.gnu.org/pub/gcc/infrastructure/$(CLOOG_PKG)
CLOOG_CFG := --prefix=$(PREFIX)/$(BUILD) --enable-static --disable-shared \
	--with-gmp=system --with-gmp-prefix=$(PREFIX)/$(BUILD) \
	--with-isl=system --with-isl-prefix=$(PREFIX)/$(BUILD)

PKGS += $(CLOOG)
#ifeq ($(call need_pkg,"cloog"),)
#PKGS_FOUND += $(CLOOG)
#endif

DEPS_$(CLOOG) = gmp isl

$(TARBALLS)/$(CLOOG_PKG):
	$(call download,$(CLOOG_URL))

.sum-$(CLOOG): $(CLOOG_PKG)

$(CLOOG): $(CLOOG_PKG) .sum-$(CLOOG)
	$(UNPACK)
	$(MOVE)

.$(CLOOG): $(CLOOG)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && ./configure $(CLOOG_CFG)
else
	cd $< && ./configure $(CLOOG_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
