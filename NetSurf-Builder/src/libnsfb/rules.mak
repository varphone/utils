# libnsfb

LIBNSFB := libnsfb
LIBNSFB_VERSION := git
LIBNSFB_PKG := $(LIBNSFB)-$(LIBNSFB_VERSION).tar.xz
LIBNSFB_URL := git://git.netsurf-browser.org/libnsfb
LIBNSFB_CFG := 

PKGS += $(LIBNSFB)
ifeq ($(call need_pkg,"libnsfb"),)
PKGS_FOUND += $(LIBNSFB)
endif

DEPS_$(LIBNSFB) =

$(TARBALLS)/$(LIBNSFB_PKG):
	$(call download_git,$(LIBNSFB_URL))

.sum-$(LIBNSFB): $(LIBNSFB_PKG)

$(LIBNSFB): $(LIBNSFB_PKG) .sum-$(LIBNSFB)
	$(UNPACK)
	$(MOVE)

.$(LIBNSFB): $(LIBNSFB)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
#ifndef HAVE_CROSS_COMPILE
#	cd $< && $(BUILDVARS) $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBNSFB_CFG)
#else
#	cd $< && $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBNSFB_CFG)
#endif
	cd $< && $(MAKE) install TARGET=$(HOST) PREFIX=$(PREFIX)
	touch $@
