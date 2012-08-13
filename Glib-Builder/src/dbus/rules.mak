# dbus

DBUS := dbus
DBUS_VERSION := 1.6.4
DBUS_PKG := $(DBUS)-$(DBUS_VERSION).tar.gz
DBUS_URL := http://cgit.freedesktop.org/dbus/dbus/snapshot/$(DBUS_PKG)
DBUS_CFG := --enable-static=yes --enable-abstract-sockets \
	--disable-selinux --disable-libaudit --disable-dnotify --disable--inotify \
	--disable-launchd --disable-systemd --disable-modular-tests --disable-tests \
	--disable-installed-tests --disable-doxygen-docs \
	--with-xml=libxml --without-x --without-valgrind

PKGS += $(DBUS)
ifeq ($(call need_pkg,"dbus-1"),)
PKGS_FOUND += $(DBUS)
endif

$(TARBALLS)/$(DBUS_PKG):
	$(call download,$(DBUS_URL))

.sum-$(DBUS): $(DBUS_PKG)

$(DBUS): $(DBUS_PKG) .sum-$(DBUS)
	$(UNPACK)
	$(MOVE)

.$(DBUS): $(DBUS)
	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(BUILDVARS) $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(DBUS_CFG)
else
	cd $< && $(HOSTTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(DBUS_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
