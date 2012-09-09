# netsurf

NETSURF := netsurf
NETSURF_VERSION := git
NETSURF_PKG := $(NETSURF)-$(NETSURF_VERSION).tar.xz
NETSURF_URL := git://git.netsurf-browser.org/netsurf.git
NETSURF_CFG := 

PKGS += $(NETSURF)
ifeq ($(call need_pkg,"netsurf"),)
PKGS_FOUND += $(NETSURF)
endif

DEPS_$(NETSURF) = buildsystem libwapcaplet libparserutils libhubbub libcss libdom libnsbmp libnsgif libnsfb libpng

$(TARBALLS)/$(NETSURF_PKG):
	$(call download_git,$(NETSURF_URL))

.sum-$(NETSURF): $(NETSURF_PKG)

$(NETSURF): $(NETSURF_PKG) .sum-$(NETSURF)
	$(UNPACK)
	$(MOVE)

.$(NETSURF): $(NETSURF)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
#ifndef HAVE_CROSS_COMPILE
#	cd $< && $(BUILDVARS) $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(NETSURF_CFG)
#else
#	cd $< && $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(NETSURF_CFG)
#endif
	cd $< && $(MAKE) install
	touch $@
