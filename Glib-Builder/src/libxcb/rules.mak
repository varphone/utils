# libxcb

LIBXCB := libxcb
LIBXCB_VERSION := 1.8
LIBXCB_PKG := $(LIBXCB)-$(LIBXCB_VERSION).tar.bz2
LIBXCB_URL := http://xcb.freedesktop.org/dist/$(LIBXCB_PKG)
LIBXCB_CFG := 

PKGS += $(LIBXCB)
ifeq ($(call need_pkg,"libxcb"),)
PKGS_FOUND += $(LIBXCB)
endif

DEPS_$(LIBXCB) := xcb-proto

$(TARBALLS)/$(LIBXCB_PKG):
	$(call download,$(LIBXCB_URL))

.sum-$(LIBXCB): $(LIBXCB_PKG)

$(LIBXCB): $(LIBXCB_PKG) .sum-$(LIBXCB)
	$(UNPACK)
	$(MOVE)

.$(LIBXCB): $(LIBXCB)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(BUILDVARS) $(HOSTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBXCB_CFG)
else
	cd $< && $(HOSTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBXCB_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
