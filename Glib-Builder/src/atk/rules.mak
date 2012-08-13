# atk

ATK := atk
ATK_VERSION := 2.5.4
ATK_PKG := $(ATK)-$(ATK_VERSION).tar.xz
ATK_URL := http://ftp.gnome.org/pub/gnome/sources/atk/2.5/$(ATK_PKG)
ATK_CFG := 

PKGS += $(ATK)
ifeq ($(call need_pkg,"atk"),)
PKGS_FOUND += $(ATK)
endif

DEPS_$(ATK) :=

$(TARBALLS)/$(ATK_PKG):
	$(call download,$(ATK_URL))

.sum-$(ATK): $(ATK_PKG)

$(ATK): $(ATK_PKG) .sum-$(ATK)
	$(UNPACK)
	$(MOVE)

.$(ATK): $(ATK)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(BUILDVARS) $(HOSTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(ATK_CFG)
else
	cd $< && $(HOSTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(ATK_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
