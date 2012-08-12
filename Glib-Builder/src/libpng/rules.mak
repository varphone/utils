# libpng

LIBPNG := libpng
LIBPNG_VERSION := 1.5.12
LIBPNG_PKG := $(LIBPNG)-$(LIBPNG_VERSION).tar.xz
LIBPNG_URL := ftp://ftp.simplesystems.org/pub/libpng/png/src/$(LIBPNG_PKG)
LIBPNG_CFG := --with-sysroot=$(PREFIX)

PKGS += $(LIBPNG)
ifeq ($(call need_pkg,"libpng"),)
PKGS_FOUND += $(LIBPNG)
endif

DEPS_libpng = zlib $(DEPS_zlib)

$(TARBALLS)/$(LIBPNG_PKG):
	$(call download,$(LIBPNG_URL))
	[ -f $(SRC)/$(LIBPNG)/SHA512SUMS ] || (cd $(TARBALLS); sha512sum $(LIBPNG_PKG) > $(SRC)/$(LIBPNG)/SHA512SUMS)

.sum-$(LIBPNG): $(LIBPNG_PKG)

$(LIBPNG): $(LIBPNG_PKG) .sum-$(LIBPNG)
	$(UNPACK)
	$(MOVE)

.$(LIBPNG): $(LIBPNG)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE-1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(HOSTTOOLS) $(HOSTVARS) ./configure $(LIBPNG_CFG)
else
	cd $< && $(HOSTVARS) ./configure $(HOSTCONF) $(LIBPNG_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
