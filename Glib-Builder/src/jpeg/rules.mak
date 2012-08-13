# jpeg

JPEG := jpeg
JPEG_VERSION := 6b
JPEG_PKG := $(JPEG)-$(JPEG_VERSION).tar.gz
JPEG_URL := http://sourceforge.net/projects/libjpeg/files/libjpeg/6b/jpegsrc.v6b.tar.gz/download?use_mirror=nchc
JPEG_CFG :=

PKGS += $(JPEG)
ifeq ($(call need_pkg,"jpeg"),)
PKGS_FOUND += $(JPEG)
endif

DEPS_$(JPEG) :=

$(TARBALLS)/$(JPEG_PKG):
	$(call download,$(JPEG_URL))

.sum-$(JPEG): $(JPEG_PKG)

$(JPEG): $(JPEG_PKG) .sum-$(JPEG)
	$(UNPACK)
	$(APPLY) $(SRC)/$(JPEG)/jpeg.patch
	$(MOVE)

.$(JPEG): $(JPEG)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(BUILDVARS) $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(JPEG_CFG)
else
	cd $< && $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(JPEG_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
