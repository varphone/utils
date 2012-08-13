# tiff

TIFF := tiff
TIFF_VERSION := 4.0.2
TIFF_PKG := $(TIFF)-$(TIFF_VERSION).tar.gz
TIFF_URL := ftp://ftp.remotesensing.org/libtiff/$(TIFF_PKG)
TIFF_CFG := 

PKGS += $(TIFF)
ifeq ($(call need_pkg,"tiff"),)
PKGS_FOUND += $(TIFF)
endif

DEPS_$(TIFF) :=

$(TARBALLS)/$(TIFF_PKG):
	$(call download,$(TIFF_URL))

.sum-$(TIFF): $(TIFF_PKG)

$(TIFF): $(TIFF_PKG) .sum-$(TIFF)
	$(UNPACK)
	$(MOVE)

.$(TIFF): $(TIFF)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(BUILDVARS) $(HOSTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(TIFF_CFG)
else
	cd $< && $(HOSTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(TIFF_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
