# libflac

LIBFLAC := libflac
LIBFLAC_VERSION :=
LIBFLAC_PKG := $(LIBFLAC)-$(LIBFLAC_VERSION)
LIBFLAC_URL := $(LIBFLAC_PKG)
LIBFLAC_CFG := 

PKGS += $(LIBFLAC)
ifeq ($(call need_pkg,"libflac"),)
PKGS_FOUND += $(LIBFLAC)
endif

DEPS_$(LIBFLAC) :=

$(TARBALLS)/$(LIBFLAC_PKG):
	$(call download,$(LIBFLAC_URL))

.sum-$(LIBFLAC): $(LIBFLAC_PKG)

$(LIBFLAC): $(LIBFLAC_PKG) .sum-$(LIBFLAC)
	$(UNPACK)
	$(MOVE)

.$(LIBFLAC): $(LIBFLAC)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(BUILDVARS) $(HOSTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBFLAC_CFG)
else
	cd $< && $(HOSTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBFLAC_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
