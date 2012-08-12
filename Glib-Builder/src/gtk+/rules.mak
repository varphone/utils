# gtk+

GTK+ := gtk+
GTK+_VERSION := 3.5.10
GTK+_PKG := $(GTK+)-$(GTK+_VERSION).tar.xz
GTK+_URL := http://ftp.gnome.org/pub/gnome/sources/gtk+/3.5/$(GTK+_PKG)
GTK+_CFG := --build=$(BUILD) --host=$(HOST) --prefix=$(PREFIX) \
	--enable-debug=no --enable-static=yes \
	--disable-selinux --disable-fam --disable-libelf --disable-xattr --disable-man

PKGS += $(GTK+)
ifeq ($(call need_pkg,"gtk+"),)
PKGS_FOUND += $(GTK+)
endif

$(TARBALLS)/$(GTK+_PKG):
	$(call download,$(GTK+_URL))
	[ -f $(SRC)/$(GTK+)/SHA512SUMS ] || cd $(TARBALLS) && sha512sum $(basename $@) > $(SRC)/$(GTK+)/SHA512SUMS

.sum-$(GTK+): $(GTK+_PKG)

$(GTK+): $(GTK+_PKG) .sum-$(GTK+)
	$(UNPACK)
	$(MOVE)

.$(GTK+): $(GTK+)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE-1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(HOSTVARS) ./configure $(GTK+_CFG)
else
	cd $< && ./configure $(GTK+_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
