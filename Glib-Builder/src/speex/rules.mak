# speex

SPEEX := speex
SPEEX_VERSION := 1.2rc1
SPEEX_PKG := $(SPEEX)-$(SPEEX_VERSION).tar.gz
SPEEX_URL := http://downloads.xiph.org/releases/speex/$(SPEEX_PKG)
SPEEX_CFG := 

PKGS += $(SPEEX)
ifeq ($(call need_pkg,"speex"),)
PKGS_FOUND += $(SPEEX)
endif

DEPS_$(SPEEX) :=

$(TARBALLS)/$(SPEEX_PKG):
	$(call download,$(SPEEX_URL))

.sum-$(SPEEX): $(SPEEX_PKG)

$(SPEEX): $(SPEEX_PKG) .sum-$(SPEEX)
	$(UNPACK)
	$(MOVE)

.$(SPEEX): $(SPEEX)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(BUILDVARS) $(HOSTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(SPEEX_CFG)
else
	cd $< && $(HOSTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(SPEEX_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
