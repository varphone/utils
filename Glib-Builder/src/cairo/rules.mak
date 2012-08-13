# cairo

CAIRO := cairo
CAIRO_VERSION := 1.12.2
CAIRO_PKG := $(CAIRO)-$(CAIRO_VERSION).tar.xz
CAIRO_URL := http://cairographics.org/releases/$(CAIRO_PKG)
CAIRO_CFG := --enable-silent-rules --enable-gtk-doc-html=no \
	--enable-xlib=no --enable-xlib-xrender=no --enable-xcb=no --enable-xlib-xcb=no \
	--enable-xcb-shm=no --enable-skia=no --enable-os2=no --enable-drm=no \
	--enable-gallium=no --enable-gobject=yes

PKGS += $(CAIRO)
ifeq ($(call need_pkg,"cairo"),)
PKGS_FOUND += $(CAIRO)
endif

DEPS_$(CAIRO) = freetype $(DEPS_freetype) fontconfig $(DEPS_fontconfig) libpng $(DEPS_libpng) pixman $(DEPS_pixman)

$(TARBALLS)/$(CAIRO_PKG):
	$(call download,$(CAIRO_URL))

.sum-$(CAIRO): $(CAIRO_PKG)

$(CAIRO): $(CAIRO_PKG) .sum-$(CAIRO)
	$(UNPACK)
	$(MOVE)

.$(CAIRO): $(CAIRO)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(BUILDVARS) $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(CAIRO_CFG)
else
	cd $< && $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(CAIRO_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
