# buildsystem

BUILDSYSTEM := buildsystem
BUILDSYSTEM_VERSION := git
BUILDSYSTEM_PKG := $(BUILDSYSTEM)-$(BUILDSYSTEM_VERSION).tar.xz
BUILDSYSTEM_URL := git://git.netsurf-browser.org/buildsystem
BUILDSYSTEM_CFG := 

PKGS += $(BUILDSYSTEM)
ifeq ($(call need_pkg,"buildsystem"),)
PKGS_FOUND += $(BUILDSYSTEM)
endif

DEPS_$(BUILDSYSTEM) =

$(TARBALLS)/$(BUILDSYSTEM_PKG):
	$(call download_git,$(BUILDSYSTEM_URL))

.sum-$(BUILDSYSTEM): $(BUILDSYSTEM_PKG)

$(BUILDSYSTEM): $(BUILDSYSTEM_PKG) .sum-$(BUILDSYSTEM)
	$(UNPACK)
	$(APPLY) $(SRC)/$(BUILDSYSTEM)/Makefile.tools.patch
	$(MOVE)

.$(BUILDSYSTEM): $(BUILDSYSTEM)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
#ifndef HAVE_CROSS_COMPILE
#	cd $< && $(BUILDVARS) $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(BUILDSYSTEM_CFG)
#else
#	cd $< && $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(BUILDSYSTEM_CFG)
#endif
	cd $< && $(MAKE) install PREFIX=$(PREFIX)
	touch $@
