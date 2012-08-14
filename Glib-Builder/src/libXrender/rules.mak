# libXrender

LIBXRENDER := libXrender
LIBXRENDER_VERSION := 0.9.7
LIBXRENDER_PKG := $(LIBXRENDER)-$(LIBXRENDER_VERSION).tar.xz
LIBXRENDER_URL := git://anongit.freedesktop.org/xorg/lib/libXrender --depth=1
LIBXRENDER_CFG := 

PKGS += $(LIBXRENDER)
ifeq ($(call need_pkg,"libXrender"),)
PKGS_FOUND += $(LIBXRENDER)
endif

DEPS_$(LIBXRENDER) := libX11 renderproto

$(TARBALLS)/$(LIBXRENDER_PKG):
	$(call download_git,$(LIBXRENDER_URL))

.sum-$(LIBXRENDER): $(LIBXRENDER_PKG)

$(LIBXRENDER): $(LIBXRENDER_PKG) .sum-$(LIBXRENDER)
	$(UNPACK)
	$(MOVE)

.$(LIBXRENDER): $(LIBXRENDER)
	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(BUILDVARS) $(HOSTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBXRENDER_CFG)
else
	cd $< && $(HOSTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBXRENDER_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
