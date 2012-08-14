# kbproto

XKBPROTO := xkbproto
XKBPROTO_VERSION := 1.0.6
XKBPROTO_PKG := $(XKBPROTO)-$(XKBPROTO_VERSION).tar.xz
XKBPROTO_URL := git://anongit.freedesktop.org/xorg/proto/kbproto --depth=1
XKBPROTO_CFG := 

PKGS += $(XKBPROTO)
ifeq ($(call need_pkg,"kbproto"),)
PKGS_FOUND += $(XKBPROTO)
endif

DEPS_$(XKBPROTO) :=

$(TARBALLS)/$(XKBPROTO_PKG):
	$(call download_git,$(XKBPROTO_URL))

.sum-$(XKBPROTO): $(XKBPROTO_PKG)

$(XKBPROTO): $(XKBPROTO_PKG) .sum-$(XKBPROTO)
	$(UNPACK)
	$(MOVE)

.$(XKBPROTO): $(XKBPROTO)
	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(BUILDVARS) $(HOSTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(XKBPROTO_CFG)
else
	cd $< && $(HOSTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(XKBPROTO_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
