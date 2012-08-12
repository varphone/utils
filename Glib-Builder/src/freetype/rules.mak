# freetype

FREETYPE := freetype
FREETYPE_VERSION := 2.4.10
FREETYPE_PKG := $(FREETYPE)-$(FREETYPE_VERSION).tar.bz2
FREETYPE_URL := http://download.savannah.gnu.org/releases/freetype/$(FREETYPE_PKG)
FREETYPE_CFG := --build=$(BUILD) --host=$(HOST) --prefix=$(PREFIX) \
	--silent --enable-silent-rules

PKGS += $(FREETYPE)
ifeq ($(call need_pkg,"freetype"),)
PKGS_FOUND += $(FREETYPE)
endif

$(TARBALLS)/$(FREETYPE_PKG):
	$(call download,$(FREETYPE_URL))
	[ -f $(SRC)/$(FREETYPE)/SHA512SUMS ] || cd $(TARBALLS) && sha512sum $(basename $@) > $(SRC)/$(FREETYPE)/SHA512SUMS

.sum-$(FREETYPE): $(FREETYPE_PKG)

$(FREETYPE): $(FREETYPE_PKG) .sum-$(FREETYPE)
	$(UNPACK)
	$(MOVE)

.$(FREETYPE): $(FREETYPE)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE-1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(HOSTVARS) ./configure $(FREETYPE_CFG)
else
	cd $< && ./configure $(FREETYPE_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
