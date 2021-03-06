# libxml2

LIBXML2 := libxml2
LIBXML2_VERSION := 2.8.0
LIBXML2_PKG := $(LIBXML2)-$(LIBXML2_VERSION).tar.gz
LIBXML2_URL := http://xmlsoft.org/sources/$(LIBXML2_PKG)
LIBXML2_CFG := --with-minimal --with-catalog --with-reader --with-tree --with-push --with-xptr --with-valid --with-xpath --with-xinclude --with-sax1 --without-zlib --without-iconv --without-http --without-ftp  --without-debug --without-docbook --without-regexps --without-python

PKGS += $(LIBXML2)
ifeq ($(call need_pkg,"libxml-2.0"),)
#PKGS_FOUND += $(LIBXML2)
endif

DEPS_$(LIBXML2) =

$(TARBALLS)/$(LIBXML2_PKG):
	$(call download,$(LIBXML2_URL))

.sum-$(LIBXML2): $(LIBXML2_PKG)

$(LIBXML2): $(LIBXML2_PKG) .sum-$(LIBXML2)
	$(UNPACK)
	$(MOVE)

.$(LIBXML2): $(LIBXML2)
#	$(RECONF)
ifndef HAVE_CROSS_COMPILE
	cd $< && $(BUILDVARS) $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBXML2_CFG)
else
	cd $< && $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBXML2_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
