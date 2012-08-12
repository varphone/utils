# cairo

CAIRO := cairo
CAIRO_VERSION := 1.12.2
CAIRO_PKG := $(CAIRO)-$(CAIRO_VERSION).tar.xz
CAIRO_URL := http://cairographics.org/releases/$(CAIRO_PKG)
CAIRO_CFG := --build=$(BUILD) --host=$(HOST) --prefix=$(PREFIX) \
	--enable-silent-rules --enable-gtk-doc-html=no \
	--enable-xlib=no --enable-xlib-xrender=no --enable-xcb=no --enable-xlib-xcb=no \
	--enable-xcb-shm=no --enable-skia=no --enable-os2=no --enable-drm=no \
	--enable-gallium=no

PKGS += $(CAIRO)
ifeq ($(call need_pkg,"cairo"),)
PKGS_FOUND += $(CAIRO)
endif

DEPS_$(CAIRO) = libpng $(DEPS_libpng)

$(TARBALLS)/$(CAIRO_PKG):
	$(call download,$(CAIRO_URL))
	[ -f $(SRC)/$(CAIRO)/SHA512SUMS ] || (cd $(TARBALLS) && sha512sum $(CAIRO_PKG) > $(SRC)/SHA512SUMS)

.sum-$(CAIRO): $(CAIRO_PKG)

$(CAIRO): $(CAIRO_PKG) .sum-$(CAIRO)
	$(UNPACK)
	$(MOVE)

.$(CAIRO): $(CAIRO)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE-1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(HOSTVARS) ./configure $(CAIRO_CFG)
else
	cd $< && ./configure $(CAIRO_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
