# ppl

PPL := ppl
PPL_VERSION := 1.0
PPL_PKG := $(PPL)-$(PPL_VERSION).tar.bz2
PPL_URL := http://bugseng.com/products/ppl/download/ftp/releases/1.0/$(PPL_PKG)
PPL_CFG := --target=$(HOST) --prefix=$(PREFIX)/$(HOST) --disable-static --enable-shared \
	--enable-pch --disable-documentation --with-gmp=$(PREFIX)/$(HOST)

PKGS += $(PPL)
ifeq ($(call need_pkg,"ppl"),)
PKGS_FOUND += $(PPL)
endif

DEPS_$(PPL) = gmp

$(TARBALLS)/$(PPL_PKG):
	$(call download,$(PPL_URL))

.sum-$(PPL): $(PPL_PKG)

$(PPL): $(PPL_PKG) .sum-$(PPL)
	$(UNPACK)
	$(MOVE)

.$(PPL): $(PPL)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(HOSTTOOLS) ./configure $(HOSTCONF) $(PPL_CFG)
else
	cd $< && $(HOSTTOOLS) ./configure $(HOSTCONF) $(PPL_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
