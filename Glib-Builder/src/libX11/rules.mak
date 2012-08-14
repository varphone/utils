# libX11

LIBX11 := libX11
LIBX11_VERSION := 1.5.0
LIBX11_PKG := $(LIBX11)-$(LIBX11_VERSION).tar.xz
LIBX11_URL := git://anongit.freedesktop.org/xorg/lib/libX11 --depth=1
LIBX11_CFG := 

PKGS += $(LIBX11)
ifeq ($(call need_pkg,"libX11"),)
PKGS_FOUND += $(LIBX11)
endif

DEPS_$(LIBX11) := libxcb

$(TARBALLS)/$(LIBX11_PKG):
	$(call download_git,$(LIBX11_URL))

.sum-$(LIBX11): $(LIBX11_PKG)

$(LIBX11): $(LIBX11_PKG) .sum-$(LIBX11)
	$(UNPACK)
	$(MOVE)

.$(LIBX11): $(LIBX11)
	cd $< && autoreconf -v --install
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(BUILDVARS) $(HOSTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBX11_CFG)
else
	cd $< && $(HOSTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBX11_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
