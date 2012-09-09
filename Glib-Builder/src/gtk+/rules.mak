# gtk+

GTK+ := gtk+
GTK+_VERSION := 2.24.12
GTK+_PKG := $(GTK+)-$(GTK+_VERSION).tar.xz
GTK+_URL := http://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/$(GTK+_PKG)
#GTK+_CFG := --enable-debug=no --enable-static=yes --enable-gtk-doc-html=no \
#    --enable-man=no --disable-xkb --disable-xinerama --disable-xrandr \
#	--disable-xfiles --disable-xcomposite --disable-xdamage --disable-x11-backend \
#	--disable-wayland-backend --without-x
GTK+_CFG := --enable-debug=no --enable-static=yes --enable-gtk-doc-html=no \
    --enable-man=no --disable-xkb --disable-xinerama disable-cups --disable-papi \
	-with-xinput=no --with-gdktarget=directfb --without-x

PKGS += $(GTK+)
#ifeq ($(call need_pkg,"gtk+"),)
#PKGS_FOUND += $(GTK+)
#endif

DEPS_$(GTK+) = atk cairo gdk-pixbuf glib pango DirectFB

$(TARBALLS)/$(GTK+_PKG):
	$(call download,$(GTK+_URL))

.sum-$(GTK+): $(GTK+_PKG)

$(GTK+): $(GTK+_PKG) .sum-$(GTK+)
	$(UNPACK)
	$(MOVE)

.$(GTK+): $(GTK+)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(BUILDVARS) $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(GTK+_CFG)
else
	cd $< && $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(GTK+_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
