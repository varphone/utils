# libdom

LIBDOM := libdom
LIBDOM_VERSION := git
LIBDOM_PKG := $(LIBDOM)-$(LIBDOM_VERSION).tar.xz
LIBDOM_URL := git://git.netsurf-browser.org/libdom
LIBDOM_CFG := 

PKGS += $(LIBDOM)
ifeq ($(call need_pkg,"libdom"),)
PKGS_FOUND += $(LIBDOM)
endif

DEPS_$(LIBDOM) = libxml2

$(TARBALLS)/$(LIBDOM_PKG):
	$(call download_git,$(LIBDOM_URL))

.sum-$(LIBDOM): $(LIBDOM_PKG)

$(LIBDOM): $(LIBDOM_PKG) .sum-$(LIBDOM)
	$(UNPACK)
	$(MOVE)

.$(LIBDOM): $(LIBDOM)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
#ifndef HAVE_CROSS_COMPILE
#	cd $< && $(BUILDVARS) $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBDOM_CFG)
#else
#	cd $< && $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBDOM_CFG)
#endif
	cd $< && $(MAKE) install TARGET=$(HOST) PREFIX=$(PREFIX)
	touch $@
