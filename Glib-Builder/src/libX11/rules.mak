# libX11

LIBX11 := libX11
LIBX11_VERSION := 1.5.0
LIBX11_PKG := $(LIBX11)-$(LIBX11_VERSION).tar.xz
LIBX11_URL := git://anongit.freedesktop.org/xorg/lib/libX11 --depth=1
LIBX11_CFG := --enable-silent-rules --disable-xcms --disable-xlocale --disable-xkb

PKGS += $(LIBX11)
ifeq ($(call need_pkg,"libX11"),)
PKGS_FOUND += $(LIBX11)
endif

DEPS_$(LIBX11) = libxcb $(DEPS_libxcb) xextproto $(DEPS_xextproto) \
	xkbproto $(DEPS_xkbproto) xtrans $(DEPS_xtrans)

$(TARBALLS)/$(LIBX11_PKG):
	$(call download_git,$(LIBX11_URL))

.sum-$(LIBX11): $(LIBX11_PKG)

$(LIBX11): $(LIBX11_PKG) .sum-$(LIBX11)
	$(UNPACK)
	$(MOVE)

.$(LIBX11): $(LIBX11)
	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(BUILDVARS) $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBX11_CFG)
else
	cd $< && $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBX11_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
