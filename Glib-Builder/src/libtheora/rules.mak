# libtheora

LIBTHEORA := libtheora
LIBTHEORA_VERSION :=
LIBTHEORA_PKG := $(LIBTHEORA)-$(LIBTHEORA_VERSION)
LIBTHEORA_URL := $(LIBTHEORA_PKG)
LIBTHEORA_CFG := 

PKGS += $(LIBTHEORA)
ifeq ($(call need_pkg,"libtheora"),)
PKGS_FOUND += $(LIBTHEORA)
endif

DEPS_$(LIBTHEORA) :=

$(TARBALLS)/$(LIBTHEORA_PKG):
	$(call download,$(LIBTHEORA_URL))

.sum-$(LIBTHEORA): $(LIBTHEORA_PKG)

$(LIBTHEORA): $(LIBTHEORA_PKG) .sum-$(LIBTHEORA)
	$(UNPACK)
	$(MOVE)

.$(LIBTHEORA): $(LIBTHEORA)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(BUILDVARS) $(HOSTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBTHEORA_CFG)
else
	cd $< && $(HOSTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBTHEORA_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
