# xextproto

XEXTPROTO := xextproto
XEXTPROTO_VERSION := 7.2.1
XEXTPROTO_PKG := $(XEXTPROTO)-$(XEXTPROTO_VERSION).tar.xz
XEXTPROTO_URL := git://anongit.freedesktop.org/xorg/proto/xextproto --depth=1
XEXTPROTO_CFG := 

PKGS += $(XEXTPROTO)
ifeq ($(call need_pkg,"xextproto"),)
PKGS_FOUND += $(XEXTPROTO)
endif

DEPS_$(XEXTPROTO) =

$(TARBALLS)/$(XEXTPROTO_PKG):
	$(call download_git,$(XEXTPROTO_URL))

.sum-$(XEXTPROTO): $(XEXTPROTO_PKG)

$(XEXTPROTO): $(XEXTPROTO_PKG) .sum-$(XEXTPROTO)
	$(UNPACK)
	$(MOVE)

.$(XEXTPROTO): $(XEXTPROTO)
	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(BUILDVARS) $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(XEXTPROTO_CFG)
else
	cd $< && $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(XEXTPROTO_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
