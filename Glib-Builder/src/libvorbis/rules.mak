# libvorbis

LIBVORBIS := libvorbis
LIBVORBIS_VERSION := 1.3.3
LIBVORBIS_PKG := $(LIBVORBIS)-$(LIBVORBIS_VERSION).tar.xz
LIBVORBIS_URL := http://downloads.xiph.org/releases/vorbis/$(LIBVORBIS_PKG)
LIBVORBIS_CFG := 

PKGS += $(LIBVORBIS)
ifeq ($(call need_pkg,"libvorbis"),)
PKGS_FOUND += $(LIBVORBIS)
endif

DEPS_$(LIBVORBIS) :=

$(TARBALLS)/$(LIBVORBIS_PKG):
	$(call download,$(LIBVORBIS_URL))

.sum-$(LIBVORBIS): $(LIBVORBIS_PKG)

$(LIBVORBIS): $(LIBVORBIS_PKG) .sum-$(LIBVORBIS)
	$(UNPACK)
	$(MOVE)

.$(LIBVORBIS): $(LIBVORBIS)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(BUILDVARS) $(HOSTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBVORBIS_CFG)
else
	cd $< && $(HOSTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(LIBVORBIS_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
