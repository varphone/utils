# gcc

GCC := gcc
GCC_VERSION := git
GCC_PKG := $(GCC)-$(GCC_VERSION).tar.xz
GCC_URL := git://gcc.gnu.org/git/gcc.git --depth=1
GCC_CFG := 

PKGS += $(GCC)
ifeq ($(call need_pkg,"gcc"),)
PKGS_FOUND += $(GCC)
endif

DEPS_$(GCC) = mingw-w64

$(TARBALLS)/$(GCC_PKG):
	$(call download_git,$(GCC_URL))

.sum-$(GCC): $(GCC_PKG)

$(GCC): $(GCC_PKG) .sum-$(GCC)
	$(UNPACK)
	$(MOVE)

.$(GCC): $(GCC)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(BUILDVARS) $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(GCC_CFG)
else
	cd $< && $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(GCC_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
