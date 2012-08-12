# gst-rtsp-server

GST-RTSP-SERVER := gst-rtsp-server
GST-RTSP-SERVER_VERSION := 0.10.8
GST-RTSP-SERVER_PKG := rtsp-$(GST-RTSP-SERVER_VERSION).tar.bz2
GST-RTSP-SERVER_URL := http://gstreamer.freedesktop.org/src/gst-rtsp-server/$(GST-RTSP-SERVER_PKG)
GST-RTSP-SERVER_CFG := --build=$(BUILD) --host=$(HOST) --prefix=$(PREFIX) \
	--disable-gtk-doc

PKGS += $(GST-RTSP-SERVER)
ifeq ($(call need_pkg,"gst-rtsp-server"),)
PKGS_FOUND += $(GST-RTSP-SERVER)
endif

$(TARBALLS)/$(GST-RTSP-SERVER_PKG):
	$(call download,$(GST-RTSP-SERVER_URL))
	[ -f $(SRC)/$(GST-RTSP-SERVER)/SHA512SUMS ] || cd $(TARBALLS) && sha512sum $(basename $@) > $(SRC)/$(GST-RTSP-SERVER)/SHA512SUMS

.sum-$(GST-RTSP-SERVER): $(GST-RTSP-SERVER_PKG)

$(GST-RTSP-SERVER): $(GST-RTSP-SERVER_PKG) .sum-$(GST-RTSP-SERVER)
	$(UNPACK)
	$(MOVE)

.$(GST-RTSP-SERVER): $(GST-RTSP-SERVER)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE-1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(HOSTVARS) ./configure $(GST-RTSP-SERVER_CFG)
else
	cd $< && ./configure $(GST-RTSP-SERVER_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
