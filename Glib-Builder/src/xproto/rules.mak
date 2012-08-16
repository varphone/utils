# xproto

XPROTO := xproto
XPROTO_VERSION := 7.0.23
XPROTO_PKG := $(XPROTO)-$(XPROTO_VERSION).tar.gz
XPROTO_URL := http://cgit.freedesktop.org/xorg/proto/x11proto/snapshot/$(XPROTO_PKG)
XPROTO_CFG := 

PKGS += $(XPROTO)
ifeq ($(call need_pkg,"xproto"),)
PKGS_FOUND += $(XPROTO)
endif

DEPS_$(XPROTO) :=

$(TARBALLS)/$(XPROTO_PKG):
	$(call download,$(XPROTO_URL))

.sum-$(XPROTO): $(XPROTO_PKG)

$(XPROTO): $(XPROTO_PKG) .sum-$(XPROTO)
	$(UNPACK)
	$(MOVE)

.$(XPROTO): $(XPROTO)
	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
#	cd $< && autoreconf -v --install
ifndef HAVE_CROSS_COMPILE
	cd $< && $(BUILDVARS) $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(XPROTO_CFG)
else
	cd $< && $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(XPROTO_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
