# renderproto

RENDERPROTO := renderproto
RENDERPROTO_VERSION := 0.11.1
RENDERPROTO_PKG := $(RENDERPROTO)-$(RENDERPROTO_VERSION).tar.xz
RENDERPROTO_URL := git://anongit.freedesktop.org/xorg/proto/renderproto --depth=1
RENDERPROTO_CFG := 

PKGS += $(RENDERPROTO)
ifeq ($(call need_pkg,"renderproto"),)
PKGS_FOUND += $(RENDERPROTO)
endif

DEPS_$(RENDERPROTO) :=

$(TARBALLS)/$(RENDERPROTO_PKG):
	$(call download_git,$(RENDERPROTO_URL))

.sum-$(RENDERPROTO): $(RENDERPROTO_PKG)

$(RENDERPROTO): $(RENDERPROTO_PKG) .sum-$(RENDERPROTO)
	$(UNPACK)
	$(MOVE)

.$(RENDERPROTO): $(RENDERPROTO)
	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(BUILDVARS) $(HOSTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(RENDERPROTO_CFG)
else
	cd $< && $(HOSTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(RENDERPROTO_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
