# mpc

MPC := mpc
MPC_VERSION := 0.9
MPC_PKG := $(MPC)-$(MPC_VERSION).tar.gz
MPC_URL := http://www.multiprecision.org/mpc/download/$(MPC_PKG)
MPC_CFG := --prefix=$(PREFIX)/$(BUILD) --enable-static --disable-shared \
	 --with-gmp=$(PREFIX)/$(BUILD) --with-mpfr=$(PREFIX)/$(BUILD)

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
	cd $< && ./configure $(MPC_CFG)
else
	cd $< && ./configure $(MPC_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
