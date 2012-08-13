# glib

GLIB := glib
GLIB_VERSION := 2.33.8
GLIB_PKG := glib-$(GLIB_VERSION).tar.xz
GLIB_URL := http://ftp.gnome.org/pub/gnome/sources/glib/2.33/$(GLIB_PKG)
GLIB_CFG := --enable-debug=no --disable-selinux --disable-fam --disable-libelf --disable-xattr --disable-man
ifdef HAVE_CROSS_COMPILE
GLIB_CFG +=	glib_cv_stack_grows=no glib_cv_uscore=no ac_cv_func_posix_getpwuid_r=yes \
	ac_cv_func_posix_getgrgid_r=yes ac_cv_lib_rt_clock_gettime=no glib_cv_monotonic_clock=yes
endif

PKGS += $(GLIB)
ifeq ($(call need_pkg,"glib-2.0"),)
PKGS_FOUND += $(GLIB)
endif

DEPS_$(GLIB) = zlib $(DEPS_zlib) dbus $(DEPS_dbus) libffi $(DEPS_libffi) \
	libxml2 $(DEPS_libxml2)

$(TARBALLS)/$(GLIB_PKG):
	$(call download,$(GLIB_URL))

.sum-$(GLIB): $(GLIB_PKG)

$(GLIB): $(GLIB_PKG) .sum-$(GLIB)
	$(UNPACK)
	$(MOVE)

.$(GLIB): $(GLIB)
	cd $< NOCONFIGURE=1 ./autogen.sh
ifndef HAVE_CROSS_COMPILE
	cd $< && $(BUILDVARS) $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(GLIB_CFG)
else
	cd $< && $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(GLIB_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
