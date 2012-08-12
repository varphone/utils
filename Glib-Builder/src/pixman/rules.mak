# pixman

PIXMAN := pixman
PIXMAN_VERSION := 0.27.2
PIXMAN_PKG := $(PIXMAN)-$(PIXMAN_VERSION).tar.gz
PIXMAN_URL := http://cgit.freedesktop.org/pixman/snapshot/$(PIXMAN_PKG)
PIXMAN_CFG := --build=$(BUILD) --host=$(HOST) --prefix=$(PREFIX) \
	--disable-gtk

PKGS += $(PIXMAN)
ifeq ($(call need_pkg,"pixman"),)
PKGS_FOUND += $(PIXMAN)
endif

$(TARBALLS)/$(PIXMAN_PKG):
	$(call download,$(PIXMAN_URL))
	[ -f $(SRC)/$(PIXMAN)/SHA512SUMS ] || cd $(TARBALLS) && sha512sum $(basename $@) > $(SRC)/$(PIXMAN)/SHA512SUMS

.sum-$(PIXMAN): $(PIXMAN_PKG)

$(PIXMAN): $(PIXMAN_PKG) .sum-$(PIXMAN)
	$(UNPACK)
	$(MOVE)

.$(PIXMAN): $(PIXMAN)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE-1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(HOSTVARS) ./configure $(PIXMAN_CFG)
else
	cd $< && ./configure $(PIXMAN_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
