# gcc-core

GCC-CORE := gcc-core
GCC-CORE_VERSION := git
GCC-CORE_PKG := gcc-$(GCC-CORE_VERSION).tar.xz
GCC-CORE_URL := git://gcc-core.gnu.org/git/gcc-core.git --depth=1
GCC-CORE_CFG := 

PKGS += $(GCC-CORE)
ifeq ($(call need_pkg,"gcc-core"),)
PKGS_FOUND += $(GCC-CORE)
endif

DEPS_$(GCC-CORE) = mingw-w64-headers

$(TARBALLS)/$(GCC-CORE_PKG):
	$(call download_git,$(GCC-CORE_URL))

.sum-$(GCC-CORE): $(GCC-CORE_PKG)

$(GCC-CORE): $(GCC-CORE_PKG) .sum-$(GCC-CORE)
	$(UNPACK)
	$(MOVE)

.$(GCC-CORE): $(GCC-CORE)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(BUILDVARS) $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(GCC-CORE_CFG)
else
	cd $< && $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(GCC-CORE_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
