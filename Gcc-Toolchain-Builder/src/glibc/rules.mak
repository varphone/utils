# glibc

GLIBC := glibc
GLIBC_VERSION := 2.16.0
GLIBC_PKG := $(GLIBC)-$(GLIBC_VERSION).tar.xz
GLIBC_URL := http://ftp.gnu.org/gnu/glibc/$(GLIBC_PKG)
GLIBC_CFG := 

PKGS += $(GLIBC)
ifeq ($(call need_pkg,"glibc"),)
PKGS_FOUND += $(GLIBC)
endif

DEPS_$(GLIBC) = gcc-core $(DEPS_gcc-core)

$(TARBALLS)/$(GLIBC_PKG):
	$(call download,$(GLIBC_URL))

.sum-$(GLIBC): $(GLIBC_PKG)

$(GLIBC): $(GLIBC_PKG) .sum-$(GLIBC)
	$(UNPACK)
	$(MOVE)

.$(GLIBC): $(GLIBC)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(BUILDVARS) $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(GLIBC_CFG)
else
	cd $< && $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(GLIBC_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
