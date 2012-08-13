# liboggz

LIBOGGZ := liboggz
LIBOGGZ_VERSION :=
LIBOGGZ_PKG := $(LIBOGGZ)-$(LIBOGGZ_VERSION)
LIBOGGZ_URL := $(LIBOGGZ_PKG)
LIBOGGZ_CFG := 

PKGS += $(LIBOGGZ)
ifeq ($(call need_pkg,"liboggz"),)
PKGS_FOUND += $(LIBOGGZ)
endif

DEPS_$(LIBOGGZ) :=

$(TARBALLS)/$(LIBOGGZ_PKG):
	$(call download,$(LIBOGGZ_URL))

.sum-$(LIBOGGZ): $(LIBOGGZ_PKG)

$(LIBOGGZ): $(LIBOGGZ_PKG) .sum-$(LIBOGGZ)
	$(UNPACK)
	$(MOVE)

.$(LIBOGGZ): $(LIBOGGZ)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(BUILDVARS) $(HOSTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBOGGZ_CFG)
else
	cd $< && $(HOSTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBOGGZ_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
