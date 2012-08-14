# libXi

LIBXI := libXi
LIBXI_VERSION := 1.6.1
LIBXI_PKG := $(LIBXI)-$(LIBXI_VERSION).tar.xz
LIBXI_URL := git://anongit.freedesktop.org/xorg/lib/libXi --depth=1
LIBXI_CFG := 

PKGS += $(LIBXI)
ifeq ($(call need_pkg,"libXi"),)
PKGS_FOUND += $(LIBXI)
endif

DEPS_$(LIBXI) := libX11 libXext

$(TARBALLS)/$(LIBXI_PKG):
	$(call download_git,$(LIBXI_URL))

.sum-$(LIBXI): $(LIBXI_PKG)

$(LIBXI): $(LIBXI_PKG) .sum-$(LIBXI)
	$(UNPACK)
	$(MOVE)

.$(LIBXI): $(LIBXI)
	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(BUILDVARS) $(HOSTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBXI_CFG)
else
	cd $< && $(HOSTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBXI_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
