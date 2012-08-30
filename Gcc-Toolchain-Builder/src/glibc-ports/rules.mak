# glibc-ports

GLIBC-PORTS := glibc-ports
GLIBC-PORTS_VERSION := 2.16.0
GLIBC-PORTS_PKG := $(GLIBC-PORTS)-$(GLIBC-PORTS_VERSION).tar.xz
GLIBC-PORTS_URL := http://ftp.gnu.org/gnu/glibc/$(GLIBC-PORTS_PKG)
GLIBC-PORTS_CFG := 

PKGS += $(GLIBC-PORTS)
ifeq ($(call need_pkg,"glibc-ports"),)
PKGS_FOUND += $(GLIBC-PORTS)
endif

DEPS_$(GLIBC-PORTS) =

$(TARBALLS)/$(GLIBC-PORTS_PKG):
	$(call download,$(GLIBC-PORTS_URL))

.sum-$(GLIBC-PORTS): $(GLIBC-PORTS_PKG)

$(GLIBC-PORTS): $(GLIBC-PORTS_PKG) .sum-$(GLIBC-PORTS)
	$(UNPACK)
	$(MOVE)

.$(GLIBC-PORTS): $(GLIBC-PORTS)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(BUILDVARS) $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(GLIBC-PORTS_CFG)
else
	cd $< && $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(GLIBC-PORTS_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
