# directfb

DIRECTFB := DirectFB
DIRECTFB_VERSION := 1.6.1
DIRECTFB_PKG := $(DIRECTFB)-$(DIRECTFB_VERSION).tar.gz
DIRECTFB_URL := http://directfb.org/downloads/Core/DirectFB-1.6/$(DIRECTFB_PKG)
DIRECTFB_CFG :=

PKGS += $(DIRECTFB)
ifeq ($(call need_pkg,"directfb"),)
#PKGS_FOUND += $(DIRECTFB)
endif

DEPS_$(DIRECTFB) =

EXTRA_LDFLAGS += -static-libstdc++

$(TARBALLS)/$(DIRECTFB_PKG):
	$(call download,$(DIRECTFB_URL))

.sum-$(DIRECTFB): $(DIRECTFB_PKG)

$(DIRECTFB): $(DIRECTFB_PKG) .sum-$(DIRECTFB)
	$(UNPACK)
	$(APPLY) $(SRC)/$@/DirectFB.patch
	$(MOVE)

.$(DIRECTFB): $(DIRECTFB)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(BUILDVARS) $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(DIRECTFB_CFG)
else
	cd $< && $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(DIRECTFB_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
