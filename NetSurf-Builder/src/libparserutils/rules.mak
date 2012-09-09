# libparserutils

LIBPARSERUTILS := libparserutils
LIBPARSERUTILS_VERSION := git
LIBPARSERUTILS_PKG := $(LIBPARSERUTILS)-$(LIBPARSERUTILS_VERSION).tar.xz
LIBPARSERUTILS_URL := git://git.netsurf-browser.org/libparserutils
LIBPARSERUTILS_CFG := 

PKGS += $(LIBPARSERUTILS)
ifeq ($(call need_pkg,"libparserutils"),)
PKGS_FOUND += $(LIBPARSERUTILS)
endif

DEPS_$(LIBPARSERUTILS) =

$(TARBALLS)/$(LIBPARSERUTILS_PKG):
	$(call download_git,$(LIBPARSERUTILS_URL))

.sum-$(LIBPARSERUTILS): $(LIBPARSERUTILS_PKG)

$(LIBPARSERUTILS): $(LIBPARSERUTILS_PKG) .sum-$(LIBPARSERUTILS)
	$(UNPACK)
	$(MOVE)

.$(LIBPARSERUTILS): $(LIBPARSERUTILS)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
#ifndef HAVE_CROSS_COMPILE
#	cd $< && $(BUILDVARS) $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBPARSERUTILS_CFG)
#else
#	cd $< && $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBPARSERUTILS_CFG)
#endif
	cd $< && $(MAKE) install TARGET=$(HOST) PREFIX=$(PREFIX)
	touch $@
