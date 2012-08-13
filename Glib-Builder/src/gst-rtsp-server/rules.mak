# gst-rtsp-server

GST-RTSP-SERVER := gst-rtsp-server
GST-RTSP-SERVER_VERSION := 0.11
GST-RTSP-SERVER_PKG := $(GST-RTSP-SERVER)-$(GST-RTSP-SERVER_VERSION).tar.bz2
GST-RTSP-SERVER_URL := http://gstreamer.freedesktop.org/src/gst-rtsp-server/$(GST-RTSP-SERVER_PKG)
GST-RTSP-SERVER_CFG := --disable-gtk-doc GST_LIBS='-lgstreamer-1.0 -lgio-2.0 -lgobject-2.0 -lgthread-2.0 -lgmodule-2.0 -lglib-2.0'

PKGS += $(GST-RTSP-SERVER)
ifeq ($(call need_pkg,"gst-rtsp-server"),)
PKGS_FOUND += $(GST-RTSP-SERVER)
endif

DEPS_$(GST-RTSP-SERVER) := gst-plugins-base $(DEPS_gst-plugins-base)

$(TARBALLS)/$(GST-RTSP-SERVER_PKG):
	$(call download,$(GST-RTSP-SERVER_URL))

.sum-$(GST-RTSP-SERVER): $(GST-RTSP-SERVER_PKG)

$(GST-RTSP-SERVER): $(GST-RTSP-SERVER_PKG) .sum-$(GST-RTSP-SERVER)
	$(UNPACK)
	$(MOVE)

.$(GST-RTSP-SERVER): $(GST-RTSP-SERVER)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(BUILDVARS) $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(GST-RTSP-SERVER_CFG)
else
	cd $< && $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(GST-RTSP-SERVER_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
