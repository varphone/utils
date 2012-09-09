# libwapcaplet

LIBWAPCAPLET := libwapcaplet
LIBWAPCAPLET_VERSION := git
LIBWAPCAPLET_PKG := $(LIBWAPCAPLET)-$(LIBWAPCAPLET_VERSION).tar.xz
LIBWAPCAPLET_URL := git://git.netsurf-browser.org/libwapcaplet
LIBWAPCAPLET_CFG := 

PKGS += $(LIBWAPCAPLET)
ifeq ($(call need_pkg,"libwapcaplet"),)
PKGS_FOUND += $(LIBWAPCAPLET)
endif

DEPS_$(LIBWAPCAPLET) =

$(TARBALLS)/$(LIBWAPCAPLET_PKG):
	$(call download_git,$(LIBWAPCAPLET_URL))

.sum-$(LIBWAPCAPLET): $(LIBWAPCAPLET_PKG)

$(LIBWAPCAPLET): $(LIBWAPCAPLET_PKG) .sum-$(LIBWAPCAPLET)
	$(UNPACK)
	$(MOVE)

.$(LIBWAPCAPLET): $(LIBWAPCAPLET)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
#ifndef HAVE_CROSS_COMPILE
#	cd $< && $(BUILDVARS) $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBWAPCAPLET_CFG)
#else
#	cd $< && $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBWAPCAPLET_CFG)
#endif
	cd $< && $(MAKE) install TARGET=$(HOST) PREFIX=$(PREFIX)
	touch $@
