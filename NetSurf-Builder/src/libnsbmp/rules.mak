# libnsbmp

LIBNSBMP := libnsbmp
LIBNSBMP_VERSION := git
LIBNSBMP_PKG := $(LIBNSBMP)-$(LIBNSBMP_VERSION).tar.xz
LIBNSBMP_URL := git://git.netsurf-browser.org/libnsbmp
LIBNSBMP_CFG := 

PKGS += $(LIBNSBMP)
ifeq ($(call need_pkg,"libnsbmp"),)
PKGS_FOUND += $(LIBNSBMP)
endif

DEPS_$(LIBNSBMP) =

$(TARBALLS)/$(LIBNSBMP_PKG):
	$(call download_git,$(LIBNSBMP_URL))

.sum-$(LIBNSBMP): $(LIBNSBMP_PKG)

$(LIBNSBMP): $(LIBNSBMP_PKG) .sum-$(LIBNSBMP)
	$(UNPACK)
	$(MOVE)

.$(LIBNSBMP): $(LIBNSBMP)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
#ifndef HAVE_CROSS_COMPILE
#	cd $< && $(BUILDVARS) $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBNSBMP_CFG)
#else
#	cd $< && $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBNSBMP_CFG)
#endif
	cd $< && $(MAKE) install TARGET=$(HOST) PREFIX=$(PREFIX)
	touch $@
