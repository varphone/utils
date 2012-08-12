# gstreamer

GSTREAMER := gstreamer
GSTREAMER_VERSION := 0.11.93
GSTREAMER_PKG := $(GSTREAMER)-$(GSTREAMER_VERSION).tar.xz
GSTREAMER_URL := http://gstreamer.freedesktop.org/src/gstreamer/$(GSTREAMER_PKG)
GSTREAMER_CFG := --build=$(BUILD) --host=$(HOST) --prefix=$(PREFIX) \
	--quiet --enable-static=yes --disable-debug --disable-gst-debug --disable-nls \
	--disable-rpath --disable-gtk-doc --disable-tests --disable-valgrind
ifdef HAVE_CROSS_COMPILE
$(GSTREAMER)_CFG += --enable-introspection=no
endif

PKGS += $(GSTREAMER)
ifeq ($(call need_pkg,"gstreamer"),)
PKGS_FOUND += $(GSTREAMER)
endif

$(TARBALLS)/$(GSTREAMER_PKG):
	$(call download,$(GSTREAMER_URL))
	[ -f $(SRC)/$(GSTREAMER)/SHA512SUMS ] || cd $(TARBALLS) && sha512sum $(basename $@) > $(SRC)/$(GSTREAMER)/SHA512SUMS

.sum-$(GSTREAMER): $(GSTREAMER_PKG)

$(GSTREAMER): $(GSTREAMER_PKG) .sum-$(GSTREAMER)
	$(UNPACK)
	$(MOVE)

.$(GSTREAMER): $(GSTREAMER)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE-1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(HOSTVARS) ./configure $(GSTREAMER_CFG)
else
	cd $< && ./configure $(GSTREAMER_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
