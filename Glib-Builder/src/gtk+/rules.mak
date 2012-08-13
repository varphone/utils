# gtk+

GTK+ := gtk+
GTK+_VERSION := 3.5.10
GTK+_PKG := $(GTK+)-$(GTK+_VERSION).tar.xz
GTK+_URL := http://ftp.gnome.org/pub/gnome/sources/gtk+/3.5/$(GTK+_PKG)
GTK+_CFG := --enable-debug=no --enable-static=yes --enable-gtk-doc-html=no \
    --enable-man=no --without-x PKG_CONFIG_PATH=$(PREFIX)/lib/pkgconfig \
    PKG_CONFIG_LIBDIR=$(PREFIX)/lib

PKGS += $(GTK+)
ifeq ($(call need_pkg,"gtk+"),)
PKGS_FOUND += $(GTK+)
endif

DEPS_$(GTK+) := atk $(DEPS_atk) cairo $(DEPS_cairo) gdk-pixbuf $(DEPS_gdk-pixbuf) glib $(DEPS_glib) pango $(DEPS_pango)

$(TARBALLS)/$(GTK+_PKG):
	$(call download,$(GTK+_URL))

.sum-$(GTK+): $(GTK+_PKG)

$(GTK+): $(GTK+_PKG) .sum-$(GTK+)
	$(UNPACK)
	$(MOVE)

.$(GTK+): $(GTK+)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE-1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(BUILDVARS) $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(GTK+_CFG)
else
	cd $< && $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(GTK+_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
