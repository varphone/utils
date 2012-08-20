# cloog

CLOOG := cloog
CLOOG_VERSION := 0.17.0
CLOOG_PKG := $(CLOOG)-$(CLOOG_VERSION).tar.gz
CLOOG_URL := ftp://gcc.gnu.org/pub/gcc/infrastructure/$(CLOOG_PKG)
CLOOG_CFG := --target=$(HOST) --prefix=$(PREFIX)/$(HOST) --disable-static --enable-shared \
	--with-gmp=system --with-gmp-prefix=$(PREFIX)/$(HOST) \
	--with-isl=system --with-isl-prefix=$(PREFIX)/$(HOST)

PKGS += $(CLOOG)
ifeq ($(call need_pkg,"cloog"),)
PKGS_FOUND += $(CLOOG)
endif

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
	cd $< && $(HOSTTOOLS) ./configure $(HOSTCONF) $(CLOOG_CFG)
else
	cd $< && $(HOSTTOOLS) ./configure $(HOSTCONF) $(CLOOG_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
