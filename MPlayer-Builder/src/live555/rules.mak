# live555

LIVE555 := live555
LIVE555_VERSION := latest
LIVE555_PKG := live555-latest.tar.gz
LIVE555_URL := http://www.live555.com/liveMedia/public/$(LIVE555_PKG)
LIVE555_CFG := 

MACHINE = $(shell $(CC) -dumpmachine)
ifneq ($(findstring mingw,$(MACHINE)),)
LIVE555_CFG += mingw
endif
ifneq ($(findstring i686*linux,$(MACHINVE)),)
LIVE555_CFG += linux
endif

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
	mv live $@

.$(LIVE555): $(LIVE555)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && ./genMakefiles $(LIVE555_CFG) 
else
	cd $< && ./genMakefiles $(LIVE555_CFG)
endif
	cd $< && $(MAKE) $(HOSTTOOLS) $(HOSTVARS)
	mkdir -p -- "$(PREFIX)/lib" "$(PREFIX)/include"
	cp \
		$</groupsock/libgroupsock.a \
		$</liveMedia/libliveMedia.a \
		$</UsageEnvironment/libUsageEnvironment.a \
		$</BasicUsageEnvironment/libBasicUsageEnvironment.a \
		"$(PREFIX)/lib/"
	cp \
		$</groupsock/include/*.hh \
		$</groupsock/include/*.h \
		$</liveMedia/include/*.hh \
        	$</UsageEnvironment/include/*.hh \
        	$</BasicUsageEnvironment/include/*.hh \
		"$(PREFIX)/include/"
	touch $@
