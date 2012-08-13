# vorbis-tools

VORBIS-TOOLS := vorbis-tools
VORBIS-TOOLS_VERSION := 1.4.0
VORBIS-TOOLS_PKG := $(VORBIS-TOOLS)-$(VORBIS-TOOLS_VERSION).tar.gz
VORBIS-TOOLS_URL := http://downloads.xiph.org/releases/vorbis/$(VORBIS-TOOLS_PKG)
VORBIS-TOOLS_CFG := 

PKGS += $(VORBIS-TOOLS)
ifeq ($(call need_pkg,"vorbis-tools"),)
PKGS_FOUND += $(VORBIS-TOOLS)
endif

DEPS_$(VORBIS-TOOLS) :=

$(TARBALLS)/$(VORBIS-TOOLS_PKG):
	$(call download,$(VORBIS-TOOLS_URL))

.sum-$(VORBIS-TOOLS): $(VORBIS-TOOLS_PKG)

$(VORBIS-TOOLS): $(VORBIS-TOOLS_PKG) .sum-$(VORBIS-TOOLS)
	$(UNPACK)
	$(MOVE)

.$(VORBIS-TOOLS): $(VORBIS-TOOLS)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(BUILDVARS) $(HOSTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(VORBIS-TOOLS_CFG)
else
	cd $< && $(HOSTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(VORBIS-TOOLS_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
