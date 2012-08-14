# libXau

LIBXAU := libXau
LIBXAU_VERSION := 1.0.7
LIBXAU_PKG := $(LIBXAU)-$(LIBXAU_VERSION).tar.xz
LIBXAU_URL := git://anongit.freedesktop.org/xorg/lib/libXau --depth=1
LIBXAU_CFG := 

PKGS += $(LIBXAU)
ifeq ($(call need_pkg,"libXau"),)
PKGS_FOUND += $(LIBXAU)
endif

DEPS_$(LIBXAU) :=

$(TARBALLS)/$(LIBXAU_PKG):
	$(call download_git,$(LIBXAU_URL))

.sum-$(LIBXAU): $(LIBXAU_PKG)

$(LIBXAU): $(LIBXAU_PKG) .sum-$(LIBXAU)
	$(UNPACK)
	$(MOVE)

.$(LIBXAU): $(LIBXAU)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
	cd $< && autoreconf -v --install
ifndef HAVE_CROSS_COMPILE
	cd $< && $(BUILDVARS) $(HOSTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBXAU_CFG)
else
	cd $< && $(HOSTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBXAU_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
