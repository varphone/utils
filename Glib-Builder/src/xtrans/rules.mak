# xtrans

XTRANS := xtrans
XTRANS_VERSION := 1.2.7
XTRANS_PKG := $(XTRANS)-$(XTRANS_VERSION).tar.xz
XTRANS_URL := git://anongit.freedesktop.org/xorg/lib/libxtrans --depth=1
XTRANS_CFG := 

PKGS += $(XTRANS)
ifeq ($(call need_pkg,"xtrans"),)
PKGS_FOUND += $(XTRANS)
endif

DEPS_$(XTRANS) :=

$(TARBALLS)/$(XTRANS_PKG):
	$(call download_git,$(XTRANS_URL))

.sum-$(XTRANS): $(XTRANS_PKG)

$(XTRANS): $(XTRANS_PKG) .sum-$(XTRANS)
	$(UNPACK)
	$(MOVE)

.$(XTRANS): $(XTRANS)
	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(BUILDVARS) $(HOSTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(XTRANS_CFG)
else
	cd $< && $(HOSTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(XTRANS_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
