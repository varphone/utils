# libxspf

LIBXSPF := libxspf
LIBXSPF_VERSION := 1.2.0
LIBXSPF_PKG := $(LIBXSPF)-$(LIBXSPF_VERSION).tar.bz2
LIBXSPF_URL := http://downloads.xiph.org/releases/xspf/$(LIBXSPF_PKG)
LIBXSPF_CFG := 

PKGS += $(LIBXSPF)
ifeq ($(call need_pkg,"libxspf"),)
PKGS_FOUND += $(LIBXSPF)
endif

DEPS_$(LIBXSPF) :=

$(TARBALLS)/$(LIBXSPF_PKG):
	$(call download,$(LIBXSPF_URL))

.sum-$(LIBXSPF): $(LIBXSPF_PKG)

$(LIBXSPF): $(LIBXSPF_PKG) .sum-$(LIBXSPF)
	$(UNPACK)
	$(MOVE)

.$(LIBXSPF): $(LIBXSPF)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(BUILDVARS) $(HOSTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBXSPF_CFG)
else
	cd $< && $(HOSTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBXSPF_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
