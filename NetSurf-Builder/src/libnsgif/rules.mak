# libnsgif

LIBNSGIF := libnsgif
LIBNSGIF_VERSION := git
LIBNSGIF_PKG := $(LIBNSGIF)-$(LIBNSGIF_VERSION).tar.xz
LIBNSGIF_URL := git://git.netsurf-browser.org/libnsgif
LIBNSGIF_CFG := 

PKGS += $(LIBNSGIF)
ifeq ($(call need_pkg,"libnsgif"),)
PKGS_FOUND += $(LIBNSGIF)
endif

DEPS_$(LIBNSGIF) =

$(TARBALLS)/$(LIBNSGIF_PKG):
	$(call download_git,$(LIBNSGIF_URL))

.sum-$(LIBNSGIF): $(LIBNSGIF_PKG)

$(LIBNSGIF): $(LIBNSGIF_PKG) .sum-$(LIBNSGIF)
	$(UNPACK)
	$(MOVE)

.$(LIBNSGIF): $(LIBNSGIF)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
#ifndef HAVE_CROSS_COMPILE
#	cd $< && $(BUILDVARS) $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBNSGIF_CFG)
#else
#	cd $< && $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBNSGIF_CFG)
#endif
	cd $< && $(MAKE) install TARGET=$(HOST) PREFIX=$(PREFIX)
	touch $@
