# pango

PANGO := pango
PANGO_VERSION := 1.30.1
PANGO_PKG := $(PANGO)-$(PANGO_VERSION).tar.xz
PANGO_URL := http://ftp.gnome.org/pub/GNOME/sources/pango/1.30/$(PANGO_PKG)
PANGO_CFG := --disable-gtk-doc-html --without-x
ifdef HAVE_CROSS_COMPILE
PANGO_CFG += -enable-introspection=no 
endif

PKGS += $(PANGO)
ifeq ($(call need_pkg,"pango"),)
PKGS_FOUND += $(PANGO)
endif

DEPS_$(PANGO) = freetype $(DEPS_freetype) cairo $(DEPS_cairo)

$(TARBALLS)/$(PANGO_PKG):
	$(call download,$(PANGO_URL))

.sum-$(PANGO): $(PANGO_PKG)

$(PANGO): $(PANGO_PKG) .sum-$(PANGO)
	$(UNPACK)
	$(MOVE)

.$(PANGO): $(PANGO)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(BUILDVARS) $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(PANGO_CFG)
else
	cd $< && $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(PANGO_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
