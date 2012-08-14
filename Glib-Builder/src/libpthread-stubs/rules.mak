# libpthread-stubs

LIBPTHREAD-STUBS := libpthread-stubs
LIBPTHREAD-STUBS_VERSION := 0.3
LIBPTHREAD-STUBS_PKG := $(LIBPTHREAD-STUBS)-$(LIBPTHREAD-STUBS_VERSION).tar.bz2
LIBPTHREAD-STUBS_URL := http://xcb.freedesktop.org/dist/$(LIBPTHREAD-STUBS_PKG)
LIBPTHREAD-STUBS_CFG := 

PKGS += $(LIBPTHREAD-STUBS)
ifeq ($(call need_pkg,"libpthread-stubs"),)
PKGS_FOUND += $(LIBPTHREAD-STUBS)
endif

DEPS_$(LIBPTHREAD-STUBS) :=

$(TARBALLS)/$(LIBPTHREAD-STUBS_PKG):
	$(call download,$(LIBPTHREAD-STUBS_URL))

.sum-$(LIBPTHREAD-STUBS): $(LIBPTHREAD-STUBS_PKG)

$(LIBPTHREAD-STUBS): $(LIBPTHREAD-STUBS_PKG) .sum-$(LIBPTHREAD-STUBS)
	$(UNPACK)
	$(MOVE)

.$(LIBPTHREAD-STUBS): $(LIBPTHREAD-STUBS)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(BUILDVARS) $(HOSTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBPTHREAD-STUBS_CFG)
else
	cd $< && $(HOSTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBPTHREAD-STUBS_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
