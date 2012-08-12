# fontconfig

FONTCONFIG := fontconfig
FONTCONFIG_VERSION := 2.10.1
FONTCONFIG_PKG := $(FONTCONFIG)-$(FONTCONFIG_VERSION).tar.bz2
FONTCONFIG_URL := http://www.freedesktop.org/software/fontconfig/release/$(FONTCONFIG_PKG)
FONTCONFIG_CFG := --build=$(BUILD) --host=$(HOST) --prefix=$(PREFIX) \
	--silent --enable-silent-rules --disable-docs

PKGS += $(FONTCONFIG)
ifeq ($(call need_pkg,"fontconfig"),)
PKGS_FOUND += $(FONTCONFIG)
endif

$(TARBALLS)/$(FONTCONFIG_PKG):
	$(call download,$(FONTCONFIG_URL))
	[ -f $(SRC)/$(FONTCONFIG)/SHA512SUMS ] || cd $(TARBALLS) && sha512sum $(basename $@) > $(SRC)/$(FONTCONFIG)/SHA512SUMS

.sum-$(FONTCONFIG): $(FONTCONFIG_PKG)

$(FONTCONFIG): $(FONTCONFIG_PKG) .sum-$(FONTCONFIG)
	$(UNPACK)
	$(MOVE)

.$(FONTCONFIG): $(FONTCONFIG)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE-1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(HOSTVARS) ./configure $(FONTCONFIG_CFG)
else
	cd $< && ./configure $(FONTCONFIG_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
