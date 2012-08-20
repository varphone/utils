# isl

ISL := isl
ISL_VERSION := 0.10
ISL_PKG := $(ISL)-$(ISL_VERSION).tar.bz2
ISL_URL := ftp://gcc.gnu.org/pub/gcc/infrastructure/$(ISL_PKG)
ISL_CFG := --target=$(HOST) --prefix=$(PREFIX)/$(HOST) --disable-static --enable-shared \
	--with-gmp=system --with-gmp-prefix=$(PREFIX)/$(HOST)

PKGS += $(ISL)
ifeq ($(call need_pkg,"isl"),)
PKGS_FOUND += $(ISL)
endif

DEPS_$(ISL) = gmp

$(TARBALLS)/$(ISL_PKG):
	$(call download,$(ISL_URL))

.sum-$(ISL): $(ISL_PKG)

$(ISL): $(ISL_PKG) .sum-$(ISL)
	$(UNPACK)
	$(MOVE)

.$(ISL): $(ISL)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(HOSTTOOLS) ./configure $(HOSTCONF) $(ISL_CFG)
else
	cd $< && $(HOSTTOOLS) ./configure $(HOSTCONF) $(ISL_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
