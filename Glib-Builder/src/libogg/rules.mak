# libogg

LIBOGG := libogg
LIBOGG_VERSION := 1.3.0
LIBOGG_PKG := $(LIBOGG)-$(LIBOGG_VERSION).tar.xz
LIBOGG_URL := http://downloads.xiph.org/releases/ogg/$(LIBOGG_PKG)
LIBOGG_CFG := 

PKGS += $(LIBOGG)
ifeq ($(call need_pkg,"libogg"),)
PKGS_FOUND += $(LIBOGG)
endif

DEPS_$(LIBOGG) :=

$(TARBALLS)/$(LIBOGG_PKG):
	$(call download,$(LIBOGG_URL))

.sum-$(LIBOGG): $(LIBOGG_PKG)

$(LIBOGG): $(LIBOGG_PKG) .sum-$(LIBOGG)
	$(UNPACK)
	$(MOVE)

.$(LIBOGG): $(LIBOGG)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(BUILDVARS) $(HOSTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBOGG_CFG)
else
	cd $< && $(HOSTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBOGG_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
