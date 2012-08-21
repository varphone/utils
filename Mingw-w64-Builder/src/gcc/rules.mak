# gcc

GCC := gcc
GCC_VERSION := git
GCC_PKG := $(GCC)-$(GCC_VERSION).tar.xz
GCC_URL := git://gcc.gnu.org/git/gcc.git --depth=1
GCC_CFG := --target=$(TARGET) --disable-multilib --enable-languages=c,c++ \
	--disable-ppl-version-check --disable-cloog-version-check --disable-isl-version-check \
    --enable-lto --enable-cloog-backend=isl --enable-static --disable-shared \
    --with-sysroot=$(PREFIX) --prefix=$(PREFIX) --with-gmp=$(PREFIX)/$(BUILD) \
    --with-mpfr=$(PREFIX)/$(BUILD) --with-mpc=$(PREFIX)/$(BUILD) \
	--with-isl=$(PREFIX)/$(BUILD) --with-cloog=$(PREFIX)/$(BUILD)

PKGS += $(GCC)
ifeq ($(call need_pkg,"gcc"),)
PKGS_FOUND += $(GCC)
endif

DEPS_$(GCC) = binutils gcc-core mingw-w64-crt

$(TARBALLS)/$(GCC_PKG):
	$(call download_git,$(GCC_URL))

.sum-$(GCC): $(GCC_PKG)

$(GCC): $(GCC_PKG) .sum-$(GCC)
	$(UNPACK)
	$(MOVE)

.$(GCC): $(GCC)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
	 -mkdir $<-build
ifndef HAVE_CROSS_COMPILE
	cd $<-build && ../$</configure $(GCC_CFG)
else
	cd $<-build && ../$</configure $(GCC_CFG)
endif
	cd $<-build && $(MAKE) && $(MAKE) install
	touch $@
