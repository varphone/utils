# gstreamer

GSTREAMER := gstreamer
GSTREAMER_VERSION := 0.11.93
GSTREAMER_PKG := $(GSTREAMER)-$(GSTREAMER_VERSION).tar.xz
GSTREAMER_URL := http://gstreamer.freedesktop.org/src/gstreamer/$(GSTREAMER_PKG)
GSTREAMER_CFG := --quiet --enable-static=yes --disable-debug --disable-gst-debug --disable-nls \
	--disable-rpath --disable-gtk-doc --disable-tests --disable-valgrind
ifdef HAVE_CROSS_COMPILE
$(GSTREAMER)_CFG += --enable-introspection=no
endif

PKGS += $(GSTREAMER)
ifeq ($(call need_pkg,"gstreamer"),)
PKGS_FOUND += $(GSTREAMER)
endif

DEPS_$(GSTREAMER) := glib

$(TARBALLS)/$(GSTREAMER_PKG):
	$(call download,$(GSTREAMER_URL))

.sum-$(GSTREAMER): $(GSTREAMER_PKG)

$(GSTREAMER): $(GSTREAMER_PKG) .sum-$(GSTREAMER)
	$(UNPACK)
	$(MOVE)

.$(GSTREAMER): $(GSTREAMER)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(BUILDVARS) $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(GSTREAMER_CFG)
else
	cd $< && $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(GSTREAMER_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
