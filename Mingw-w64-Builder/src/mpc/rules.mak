# mpc

MPC := mpc
MPC_VERSION := 0.9
MPC_PKG := $(MPC)-$(MPC_VERSION).tar.gz
MPC_URL := http://www.multiprecision.org/mpc/download/$(MPC_PKG)
MPC_CFG := --target=$(HOST) --prefix=$(PREFIX)/$(HOST) --enable-static=no --enable-shared=yes \
	 --with-gmp=$(PREFIX)/$(HOST) --with-mpfr=$(PREFIX)/$(HOST)

PKGS += $(MPC)
ifeq ($(call need_pkg,"mpc"),)
PKGS_FOUND += $(MPC)
endif

DEPS_$(MPC) = gmp mpfr

$(TARBALLS)/$(MPC_PKG):
	$(call download,$(MPC_URL))

.sum-$(MPC): $(MPC_PKG)

$(MPC): $(MPC_PKG) .sum-$(MPC)
	$(UNPACK)
	$(MOVE)

.$(MPC): $(MPC)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(HOSTTOOLS) ./configure $(HOSTCONF) $(MPC_CFG)
else
	cd $< && $(HOSTTOOLS) ./configure $(HOSTCONF) $(MPC_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
