# mingw-w64

MINGW-W64 := mingw-w64
MINGW-W64_VERSION := svn
MINGW-W64_PKG := $(MINGW-W64)-$(MINGW-W64_VERSION).tar.xz
MINGW-W64_URL := https://mingw-w64.svn.sourceforge.net/svnroot/mingw-w64/trunk
MINGW-W64_CFG := 

PKGS += $(MINGW-W64)
ifeq ($(call need_pkg,"mingw-w64"),)
PKGS_FOUND += $(MINGW-W64)
endif

DEPS_$(MINGW-W64) =

$(TARBALLS)/$(MINGW-W64_PKG):
	$(call download_svn,$(MINGW-W64_URL))

.sum-$(MINGW-W64): $(MINGW-W64_PKG)

$(MINGW-W64): $(MINGW-W64_PKG) .sum-$(MINGW-W64)
	$(UNPACK)
	$(MOVE)

.$(MINGW-W64): $(MINGW-W64)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(BUILDVARS) $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(MINGW-W64_CFG)
else
	cd $< && $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(MINGW-W64_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
