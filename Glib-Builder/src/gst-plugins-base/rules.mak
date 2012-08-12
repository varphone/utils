# gst-plugins-base

GST-PLUGINS-BASE := gst-plugins-base
GST-PLUGINS-BASE_VERSION := 0.11.93
GST-PLUGINS-BASE_PKG := $(GST-PLUGINS-BASE)-$(GST-PLUGINS-BASE_VERSION).tar.xz
GST-PLUGINS-BASE_URL := http://gstreamer.freedesktop.org/src/gst-plugins-base/$(GST-PLUGINS-BASE_PKG)
GST-PLUGINS-BASE_CFG := --build=$(BUILD) --host=$(HOST) --prefix=$(PREFIX) \
	--disable-gtk-doc --disable-nls --disable-rpath \
	--disable-debug --disable-valgrind --disable-x --disable-xvideo --disable-xshm \
	--disable-cdparanoia --without-x
ifdef HAVE_CROSS_COMPILE
$(GST-PLUGINS-BASE)_CFG += --enable-introspection=no
endif

PKGS += $(GST-PLUGINS-BASE)
ifeq ($(call need_pkg,"gst-plugins-base"),)
PKGS_FOUND += $(GST-PLUGINS-BASE)
endif

$(TARBALLS)/$(GST-PLUGINS-BASE_PKG):
	$(call download,$(GST-PLUGINS-BASE_URL))
	[ -f $(SRC)/$(GST-PLUGINS-BASE)/SHA512SUMS ] || cd $(TARBALLS) && sha512sum $(basename $@) > $(SRC)/$(GST-PLUGINS-BASE)/SHA512SUMS

.sum-$(GST-PLUGINS-BASE): $(GST-PLUGINS-BASE_PKG)

$(GST-PLUGINS-BASE): $(GST-PLUGINS-BASE_PKG) .sum-$(GST-PLUGINS-BASE)
	$(UNPACK)
	$(MOVE)

.$(GST-PLUGINS-BASE): $(GST-PLUGINS-BASE)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE-1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(HOSTVARS) ./configure $(GST-PLUGINS-BASE_CFG)
else
	cd $< && ./configure $(GST-PLUGINS-BASE_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
