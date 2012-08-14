# libXext

LIBXEXT := libXext
LIBXEXT_VERSION := 1.3.1
LIBXEXT_PKG := $(LIBXEXT)-$(LIBXEXT_VERSION).tar.xz
LIBXEXT_URL := git://anongit.freedesktop.org/xorg/lib/libXext --depth=1
LIBXEXT_CFG := 

PKGS += $(LIBXEXT)
ifeq ($(call need_pkg,"libXext"),)
PKGS_FOUND += $(LIBXEXT)
endif

DEPS_$(LIBXEXT) := libX11

$(TARBALLS)/$(LIBXEXT_PKG):
	$(call download_git,$(LIBXEXT_URL))

.sum-$(LIBXEXT): $(LIBXEXT_PKG)

$(LIBXEXT): $(LIBXEXT_PKG) .sum-$(LIBXEXT)
	$(UNPACK)
	$(MOVE)

.$(LIBXEXT): $(LIBXEXT)
	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(BUILDVARS) $(HOSTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBXEXT_CFG)
else
	cd $< && $(HOSTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBXEXT_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
