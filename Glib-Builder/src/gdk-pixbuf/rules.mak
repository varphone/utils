# gdk-pixbuf

GDK-PIXBUF := gdk-pixbuf
GDK-PIXBUF_VERSION := 2.26.2
GDK-PIXBUF_PKG := $(GDK-PIXBUF)-$(GDK-PIXBUF_VERSION).tar.xz
GDK-PIXBUF_URL := http://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/2.26/$(GDK-PIXBUF_PKG)
GDK-PIXBUF_CFG := --disable-nls --disable-rpath -disable-gtk-doc-html --disable-glibtest
ifdef HAVE_CROSS_COMPILE
GDK-PIXBUF_CFG += --disable-introspection gio_can_sniff=no
endif

PKGS += $(GDK-PIXBUF)
ifeq ($(call need_pkg,"gdk-pixbuf"),)
PKGS_FOUND += $(GDK-PIXBUF)
endif

DEPS_$(GDK-PIXBUF) := jpeg tiff

$(TARBALLS)/$(GDK-PIXBUF_PKG):
	$(call download,$(GDK-PIXBUF_URL))

.sum-$(GDK-PIXBUF): $(GDK-PIXBUF_PKG)

$(GDK-PIXBUF): $(GDK-PIXBUF_PKG) .sum-$(GDK-PIXBUF)
	$(UNPACK)
	$(MOVE)

.$(GDK-PIXBUF): $(GDK-PIXBUF)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(BUILDVARS) $(HOSTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(GDK-PIXBUF_CFG)
else
	cd $< && $(HOSTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(GDK-PIXBUF_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
