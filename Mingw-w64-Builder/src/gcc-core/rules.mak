# gcc-core

GCC-CORE := gcc-core
GCC-CORE_VERSION := git
GCC-CORE_PKG := gcc-$(GCC-CORE_VERSION).tar.xz
GCC-CORE_URL := git://gcc.gnu.org/git/gcc.git --depth=1
GCC-CORE_CFG := --target=$(TARGET) --disable-multilib --enable-languages=c,c++ \
	--disable-ppl-version-check --disable-cloog-version-check --disable-isl-version-check \
    --enable-lto --enable-cloog-backend=isl --enable-static --disable-shared \
    --with-sysroot=$(PREFIX) --prefix=$(PREFIX) --with-gmp=$(PREFIX)/$(BUILD) \
    --with-mpfr=$(PREFIX)/$(BUILD) --with-mpc=$(PREFIX)/$(BUILD) \
	--with-isl=$(PREFIX)/$(BUILD) --with-cloog=$(PREFIX)/$(BUILD)

PKGS += $(GCC-CORE)
ifeq ($(call need_pkg,"gcc-core"),)
PKGS_FOUND += $(GCC-CORE)
endif

DEPS_$(GCC-CORE) = gmp mpfr mpc isl cloog binutils mingw-w64-headers

$(TARBALLS)/$(GCC-CORE_PKG):
	$(call download_git,$(GCC-CORE_URL))

.sum-$(GCC-CORE): $(GCC-CORE_PKG)

$(GCC-CORE): $(GCC-CORE_PKG) .sum-$(GCC-CORE)
	$(UNPACK)
	$(MOVE)

.$(GCC-CORE): $(GCC-CORE)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && ./configure $(GCC-CORE_CFG)
else
	cd $< && ./configure $(GCC-CORE_CFG)
endif
	cd $< && $(MAKE) all-gcc install-gcc
	touch $@
