# cloog-ppl

CLOOG-PPL := cloog-ppl
CLOOG-PPL_VERSION := 0.15.11
CLOOG-PPL_PKG := $(CLOOG-PPL)-$(CLOOG-PPL_VERSION).tar.gz
CLOOG-PPL_URL := ftp://gcc.gnu.org/pub/gcc/infrastructure/$(CLOOG-PPL_PKG)
CLOOG-PPL_CFG := --prefix=$(PREFIX)/$(BUILD) --enable-static --disable-shared \
	--with-gmp=$(PREFIX)/$(BUILD) --with-ppl=$(PREFIX)/$(BUILD) \
	--with-host-libstdcxx="-lstdc++"

PKGS += $(CLOOG-PPL)
ifeq ($(call need_pkg,"cloog-ppl"),)
PKGS_FOUND += $(CLOOG-PPL)
endif

DEPS_$(CLOOG-PPL) = gmp ppl polylib

$(TARBALLS)/$(CLOOG-PPL_PKG):
	$(call download,$(CLOOG-PPL_URL))

.sum-$(CLOOG-PPL): $(CLOOG-PPL_PKG)

$(CLOOG-PPL): $(CLOOG-PPL_PKG) .sum-$(CLOOG-PPL)
	$(UNPACK)
	$(APPLY) $(SRC)/$(CLOOG-PPL)/configure.patch
	$(MOVE)

.$(CLOOG-PPL): $(CLOOG-PPL)
#	cd $< && $(RECONF)
	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && ./configure $(CLOOG-PPL_CFG)
else
	cd $< && ./configure $(CLOOG-PPL_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
