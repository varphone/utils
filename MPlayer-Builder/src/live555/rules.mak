# live555

LIVE555 := live555
LIVE555_VERSION := 2012.08.12
LIVE555_PKG := live.2012.08.12.tar.gz
LIVE555_URL := http://www.live555.com/liveMedia/public/$(LIVE555_PKG)
LIVE555_CFG := 

PKGS += $(LIVE555)
ifeq ($(call need_pkg,"live555"),)
PKGS_FOUND += $(LIVE555)
endif

DEPS_$(LIVE555) =

$(TARBALLS)/$(LIVE555_PKG):
	$(call download,$(LIVE555_URL))

.sum-$(LIVE555): $(LIVE555_PKG)

$(LIVE555): $(LIVE555_PKG) .sum-$(LIVE555)
	$(UNPACK)
	$(MOVE)

.$(LIVE555): $(LIVE555)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(BUILDVARS) $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIVE555_CFG)
else
	cd $< && $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIVE555_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
