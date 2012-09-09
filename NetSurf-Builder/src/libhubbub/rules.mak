# libhubbub

LIBHUBBUB := libhubbub
LIBHUBBUB_VERSION := git
LIBHUBBUB_PKG := $(LIBHUBBUB)-$(LIBHUBBUB_VERSION).tar.xz
LIBHUBBUB_URL := git://git.netsurf-browser.org/libhubbub
LIBHUBBUB_CFG := 

PKGS += $(LIBHUBBUB)
ifeq ($(call need_pkg,"libhubbub"),)
PKGS_FOUND += $(LIBHUBBUB)
endif

DEPS_$(LIBHUBBUB) =

$(TARBALLS)/$(LIBHUBBUB_PKG):
	$(call download_git,$(LIBHUBBUB_URL))

.sum-$(LIBHUBBUB): $(LIBHUBBUB_PKG)

$(LIBHUBBUB): $(LIBHUBBUB_PKG) .sum-$(LIBHUBBUB)
	$(UNPACK)
	$(MOVE)

.$(LIBHUBBUB): $(LIBHUBBUB)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
#ifndef HAVE_CROSS_COMPILE
#	cd $< && $(BUILDVARS) $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBHUBBUB_CFG)
#else
#	cd $< && $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBHUBBUB_CFG)
#endif
	cd $< && $(MAKE) install TARGET=$(HOST) PREFIX=$(PREFIX)
	touch $@
