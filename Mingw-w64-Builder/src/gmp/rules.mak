# gmp

GMP := gmp
GMP_VERSION := 5.0.5
GMP_PKG := $(GMP)-$(GMP_VERSION).tar.bz2
GMP_URL := http://ftp.gnu.org/gnu/gmp/$(GMP_PKG)
GMP_CFG := --prefix=$(PREFIX)/$(BUILD) --enable-static --disable-shared --enable-cxx

PKGS += $(GMP)
ifeq ($(call need_pkg,"gmp"),)
PKGS_FOUND += $(GMP)
endif

DEPS_$(GMP) =

$(TARBALLS)/$(GMP_PKG):
	$(call download,$(GMP_URL))

.sum-$(GMP): $(GMP_PKG)

$(GMP): $(GMP_PKG) .sum-$(GMP)
	$(UNPACK)
	$(MOVE)

.$(GMP): $(GMP)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && ./configure $(GMP_CFG)
else
	cd $< && ./configure $(GMP_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
