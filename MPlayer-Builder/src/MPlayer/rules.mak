# MPlayer

MPLAYER := MPlayer
MPLAYER_VERSION := 1.1
MPLAYER_PKG := $(MPLAYER)-$(MPLAYER_VERSION).tar.xz
MPLAYER_URL := http://www.mplayerhq.hu/MPlayer/releases/$(MPLAYER_PKG)
MPLAYER_CFG := --target=i686-mingw32 --prefix=$(PREFIX) --enable-cross-compile \
	--cc=$(HOST)-gcc --host-cc=$(BUILD)-gcc --cxx=$(HOST)-g++ --as=$(HOST)-as \
	--nm=$(HOST)-nm --ar=$(HOST)-ar --ranlib=$(HOST)-ranlib \
	--windres=$(HOST)-windres --enable-static --enable-w32threads --enable-live \
	--extra-cflags="-march=k8-sse3 -msse3 -mfpmath=sse $(EXTRA_CFLAGS)" \
	--extra-ldflags="$(EXTRA_LDFLAGS)" \
	--extra-libs="-lliveMedia -lgroupsock -lBasicUsageEnvironment -lUsageEnvironment -lstdc++"

PKGS += $(MPLAYER)
ifeq ($(call need_pkg,"mplayer"),)
PKGS_FOUND += $(MPLAYER)
endif

DEPS_$(MPLAYER) = live555 $(DEPS_live555)

$(TARBALLS)/$(MPLAYER_PKG):
	$(call download,$(MPLAYER_URL))

.sum-$(MPLAYER): $(MPLAYER_PKG)

$(MPLAYER): $(MPLAYER_PKG) .sum-$(MPLAYER)
	$(UNPACK)
	$(MOVE)

.$(MPLAYER): $(MPLAYER)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && ./configure $(MPLAYER_CFG)
else
	cd $< && ./configure $(MPLAYER_CFG)
endif
	cd $< && $(MAKE)
	touch $@
