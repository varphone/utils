# fontconfig

FONTCONFIG := fontconfig
FONTCONFIG_VERSION := 2.10.1
FONTCONFIG_PKG := $(FONTCONFIG)-$(FONTCONFIG_VERSION).tar.bz2
FONTCONFIG_URL := http://www.freedesktop.org/software/fontconfig/release/$(FONTCONFIG_PKG)
FONTCONFIG_CFG := --silent --enable-silent-rules --enable-libxml2 --disable-docs

PKGS += $(FONTCONFIG)
ifeq ($(call need_pkg,"fontconfig"),)
PKGS_FOUND += $(FONTCONFIG)
endif

DEPS_$(FONTCONFIG) = libxml2 $(DEPS_libxml2)

$(TARBALLS)/$(FONTCONFIG_PKG):
	$(call download,$(FONTCONFIG_URL))

.sum-$(FONTCONFIG): $(FONTCONFIG_PKG)

$(FONTCONFIG): $(FONTCONFIG_PKG) .sum-$(FONTCONFIG)
	$(UNPACK)
	$(MOVE)

.$(FONTCONFIG): $(FONTCONFIG)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(BUILDVARS) $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(FONTCONFIG_CFG)
else
	cd $< && $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(FONTCONFIG_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
