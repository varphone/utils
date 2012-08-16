# libXdmcp

LIBXDMCP := libXdmcp
LIBXDMCP_VERSION := 1.1.1
LIBXDMCP_PKG := $(LIBXDMCP)-$(LIBXDMCP_VERSION).tar.xz
LIBXDMCP_URL := git://anongit.freedesktop.org/xorg/lib/libXdmcp --depth=1
LIBXDMCP_CFG := 

PKGS += $(LIBXDMCP)
ifeq ($(call need_pkg,"libXdmcp"),)
PKGS_FOUND += $(LIBXDMCP)
endif

DEPS_$(LIBXDMCP) := xproto

$(TARBALLS)/$(LIBXDMCP_PKG):
	$(call download_git,$(LIBXDMCP_URL))

.sum-$(LIBXDMCP): $(LIBXDMCP_PKG)

$(LIBXDMCP): $(LIBXDMCP_PKG) .sum-$(LIBXDMCP)
	$(UNPACK)
	$(MOVE)

.$(LIBXDMCP): $(LIBXDMCP)
	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(BUILDVARS) $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBXDMCP_CFG)
else
	cd $< && $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBXDMCP_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
