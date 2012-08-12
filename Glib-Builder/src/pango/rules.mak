# pango

PANGO := pango
PANGO_VERSION := 1.30.1
PANGO_PKG := $(PANGO)-$(PANGO_VERSION).tar.xz
PANGO_URL := http://ftp.gnome.org/pub/GNOME/sources/pango/1.30/$(PANGO_PKG)
PANGO_CFG := --build=$(BUILD) --host=$(HOST) --prefix=$(PREFIX) \
	--prefix=$(stage_dir) -enable-introspection=no --disable-gtk-doc-html \
	--without-x

PKGS += $(PANGO)
ifeq ($(call need_pkg,"pango"),)
PKGS_FOUND += $(PANGO)
endif

$(TARBALLS)/$(PANGO_PKG):
	$(call download,$(PANGO_URL))
	[ -f $(SRC)/$(PANGO)/SHA512SUMS ] || (cd $(TARBALLS) && sha512sum $(basename $@)) > $(SRC)/$(PANGO)/SHA512SUMS

.sum-$(PANGO): $(PANGO_PKG)

$(PANGO): $(PANGO_PKG) .sum-$(PANGO)
	$(UNPACK)
	$(MOVE)

.$(PANGO): $(PANGO)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE-1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(HOSTVARS) ./configure $(PANGO_CFG)
else
	cd $< && ./configure $(PANGO_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
