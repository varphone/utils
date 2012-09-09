# libffi

LIBFFI := libffi
LIBFFI_VERSION := 3.0.11
LIBFFI_PKG := $(LIBFFI)-$(LIBFFI_VERSION).tar.gz
LIBFFI_URL := ftp://sourceware.org/pub/libffi/$(LIBFFI_PKG)
LIBFFI_CFG = --build=$(BUILD) --host=$(HOST) --prefix=$(PREFIX) \
	--disable-builddir --disable-shared

PKGS += $(LIBFFI)
ifeq ($(call need_pkg,"libffi"),)
#PKGS_FOUND += $(LIBFFI)
endif

$(TARBALLS)/$(LIBFFI_PKG):
	$(call download,$(LIBFFI_URL))

.sum-$(LIBFFI): $(LIBFFI_PKG)

$(LIBFFI): $(LIBFFI_PKG) .sum-$(LIBFFI)
	$(UNPACK)
	$(MOVE)

.$(LIBFFI): $(LIBFFI)
	cd $< && ./configure $(LIBFFI_CFG)
	cd $< && $(MAKE) install
	touch $@
