# libpng

LIBPNG := libpng
LIBPNG_VERSION := 1.5.12
LIBPNG_PKG := $(LIBPNG)-$(LIBPNG_VERSION).tar.xz
LIBPNG_URL := ftp://ftp.simplesystems.org/pub/libpng/png/src/$(LIBPNG_PKG)
LIBPNG_CFG :=

PKGS += $(LIBPNG)
ifeq ($(call need_pkg,"libpng"),)
PKGS_FOUND += $(LIBPNG)
endif

DEPS_$(LIBPNG) = zlib $(DEPS_zlib)

$(TARBALLS)/$(LIBPNG_PKG):
	$(call download,$(LIBPNG_URL))

.sum-$(LIBPNG): $(LIBPNG_PKG)

$(LIBPNG): $(LIBPNG_PKG) .sum-$(LIBPNG)
	$(UNPACK)
	$(MOVE)

.$(LIBPNG): $(LIBPNG)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE-1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(BUILDVARS) $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBPNG_CFG)
else
	cd $< && $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBPNG_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
