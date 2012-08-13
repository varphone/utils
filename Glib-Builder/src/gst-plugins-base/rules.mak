# gst-plugins-base

GST-PLUGINS-BASE := gst-plugins-base
GST-PLUGINS-BASE_VERSION := 0.11.93
GST-PLUGINS-BASE_PKG := $(GST-PLUGINS-BASE)-$(GST-PLUGINS-BASE_VERSION).tar.xz
GST-PLUGINS-BASE_URL := http://gstreamer.freedesktop.org/src/gst-plugins-base/$(GST-PLUGINS-BASE_PKG)
GST-PLUGINS-BASE_CFG := --disable-gtk-doc --disable-nls --disable-rpath \
	--disable-debug --disable-valgrind --disable-x --disable-xvideo --disable-xshm \
	--disable-cdparanoia --without-x
ifdef HAVE_CROSS_COMPILE
$(GST-PLUGINS-BASE)_CFG += --enable-introspection=no
endif

PKGS += $(GST-PLUGINS-BASE)
ifeq ($(call need_pkg,"gst-plugins-base"),)
PKGS_FOUND += $(GST-PLUGINS-BASE)
endif

DEPS_$(GST-PLUGINS-BASE) := gstreamer $(DEPS_gstreamer) libogg $(DEPS_libogg) libvorbis $(DEPS_libvorbis)

$(TARBALLS)/$(GST-PLUGINS-BASE_PKG):
	$(call download,$(GST-PLUGINS-BASE_URL))

.sum-$(GST-PLUGINS-BASE): $(GST-PLUGINS-BASE_PKG)

$(GST-PLUGINS-BASE): $(GST-PLUGINS-BASE_PKG) .sum-$(GST-PLUGINS-BASE)
	$(UNPACK)
	$(MOVE)

.$(GST-PLUGINS-BASE): $(GST-PLUGINS-BASE)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(BUILDVARS) $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(GST-PLUGINS-BASE_CFG)
else
	cd $< && $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(GST-PLUGINS-BASE_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
