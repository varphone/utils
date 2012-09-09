# cairo

CAIRO := cairo
CAIRO_VERSION := 1.12.2
CAIRO_PKG := $(CAIRO)-$(CAIRO_VERSION).tar.xz
CAIRO_URL := http://cairographics.org/releases/$(CAIRO_PKG)
CAIRO_CFG := --enable-silent-rules --enable-shared=no --enable-static=yes \
	--disable-gtk-doc --enable-interpreter=no --enable-trace=no \
	--enable-skia=no --enable-os2=no --enable-drm=no --enable-gallium=no \
	--enable-qt=no --enable-quartz=no --enable-win32=no \
	--enable-gl=yes --enable-glesv2=no --enable-gobject=yes \
	--enable-test-surfaces=no

PKGS += $(CAIRO)
ifeq ($(call need_pkg,"cairo"),)
#PKGS_FOUND += $(CAIRO)
endif

DEPS_$(CAIRO) = freetype fontconfig libpng pixman

ifdef HAVE_LINUX
CAIRO_CFG += --enable-xlib-xrender=no -enable-pthread=yes --enable-directfb=yes
DEPS_$(CAIRO) += DirectFB
endif

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
