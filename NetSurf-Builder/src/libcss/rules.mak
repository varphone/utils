# libcss

LIBCSS := libcss
LIBCSS_VERSION := git
LIBCSS_PKG := $(LIBCSS)-$(LIBCSS_VERSION).tar.xz
LIBCSS_URL := git://git.netsurf-browser.org/libcss
LIBCSS_CFG := 

PKGS += $(LIBCSS)
ifeq ($(call need_pkg,"libcss"),)
PKGS_FOUND += $(LIBCSS)
endif

DEPS_$(LIBCSS) = libparserutils libwapcaplet

$(TARBALLS)/$(LIBCSS_PKG):
	$(call download_git,$(LIBCSS_URL))

.sum-$(LIBCSS): $(LIBCSS_PKG)

$(LIBCSS): $(LIBCSS_PKG) .sum-$(LIBCSS)
	$(UNPACK)
	$(MOVE)

.$(LIBCSS): $(LIBCSS)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
#ifndef HAVE_CROSS_COMPILE
#	cd $< && $(BUILDVARS) $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBCSS_CFG)
#else
#	cd $< && $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBCSS_CFG)
#endif
	cd $< && $(MAKE) install PREFIX=$(PREFIX)
	touch $@
