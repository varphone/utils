# Gstreamer builder, v1.0
#
# Copyright (C) 2012 Varphone Wong <varphone@qq.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public Licens
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-
#
SHELL := /bin/bash

build ?= $(shell gcc -dumpmachine)
host ?= $(build)
target ?= $(host)

ifneq ($(build),$(host))
COMPILER_PREFIX := $(host)-
endif

top_dir := $(shell pwd)
stage_dir := $(top_dir)/build/stage/$(host)
target_dir := $(top_dir)/$(target)

PKG_CONFIG_PATH := $(stage_dir)/lib/pkgconfig/
XDG_DATA_DIRS := $(stage_dir)/share

PC_ENV := PKG_CONFIG_PATH=$(PKG_CONFIG_PATH)

DBUS1_CFLAGS := $(shell $(PC_ENV) pkg-config --cflags dbus-1)
DBUS1_LIBS := $(shell $(PC_ENV) pkg-config --libs dbus-1)
EXPAT_CFLAGS := $(shell $(PC_ENV) pkg-config --cflags expat)
EXPAT_LIBS := $(shell $(PC_ENV) pkg-config --libs expat)
GIO_CFLAGS := $(shell $(PC_ENV) pkg-config --cflags gio-2.0)
GIO_LIBS := $(shell $(PC_ENV) pkg-config --libs gio-2.0)
GLIB_CFLAGS := $(shell $(PC_ENV) pkg-config --cflags glib-2.0)
GLIB_LIBS := $(shell $(PC_ENV) pkg-config --libs glib-2.0)
LIBFFI_CFLAGS := $(shell $(PC_ENV) pkg-config --cflags libffi)
LIBFFI_LIBS := $(shell $(PC_ENV) pkg-config --libs libffi)
ZLIB_CFLAGS := $(shell $(PC_ENV) pkg-config --cflags zlib)
ZLIB_LIBS := $(shell $(PC_ENV) pkg-config --libs zlib)

#export EXPAT_CFLAGS EXPAT_LIBS LIBFFI_CFLAGS LIBFFI_LIBS ZLIB_CFLAGS ZLIB_LIBS

cairo := cairo
cairo_PKG := $(cairo).tar.bz2
cairo_GET :=
cairo_CFG := $(top_dir)/sources/$(cairo)/configure --build=$(build) --host=$(host) --prefix=$(stage_dir) \
	--enable-silent-rules --enable-gtk-doc-html=no \
	--enable-xlib=no --enable-xlib-xrender=no --enable-xcb=no --enable-xlib-xcb=no \
	--enable-xcb-shm=no --enable-skia=no --enable-os2=no --enable-drm=no \
	--enable-gallium=no $(PC_ENV) \
	CFLAGS="$(EXPAT_CFLAGS)" LDFLAGS="$(EXPAT_LIBS)"

dbus := dbus
dbus_PKG := $(dbus).tar.bz2
dbus_GET :=
dbus_CFG := $(top_dir)/sources/$(dbus)/configure --build=$(build) --host=$(host) --prefix=$(stage_dir) \
	--enable-static=yes --enable-abstract-sockets \
	--disable-selinux --disable-libaudit --disable-dnotify --disable--inotify \
	--disable-launchd --disable-systemd --disable-modular-tests --disable-tests \
	--disable-installed-tests --disable-doxygen-docs \
	--without-x --without-valgrind \
	CFLAGS="$(EXPAT_CFLAGS)" LDFLAGS="$(EXPAT_LIBS)"

expat := expat
expat_PKG := $(expat).tar.bz2
expat_GET :=
expat_CFG := $(top_dir)/sources/$(expat)/configure --build=$(build) --host=$(host) --prefix=$(stage_dir) \
	--enable-static=yes --enable-debug=no
#	CFLAGS=-I$(stage_dir)/include LDFLAGS=-L$(stage_dir)/lib

freetype := freetype2
freetype_PKG := $(freetype).tar.bz2
freetype_GET :=
freetype_CFG := $(top_dir)/sources/$(freetype)/configure --build=$(build) --host=$(host) \
	--prefix=$(stage_dir) --silent --enable-silent-rules $(PC_ENV) \
	CFLAGS="-I$(stage_dir)/include" LDFLAGS="-L$(stage_dir)/lib"

fontconfig := fontconfig
fontconfig_PKG := $(fontconfig).tar.bz2
fontconfig_GET :=
fontconfig_CFG := $(top_dir)/sources/$(fontconfig)/configure --build=$(build) --host=$(host) \
	--prefix=$(stage_dir) --silent --enable-silent-rules --disable-docs $(PC_ENV) \
	--with-arch=arm \
	CFLAGS="-I$(stage_dir)/include" LDFLAGS="-L$(stage_dir)/lib"

libffi := libffi
libffi_PKG := $(libffi).tar.bz2
libffi_GET :=
libffi_CFG := $(top_dir)/sources/$(libffi)/configure --build=$(build) --host=$(host) --prefix=$(stage_dir) \
	--disable-builddir --disable-shared
#	CFLAGS=-I$(stage_dir)/include LDFLAGS=-L$(stage_dir)/lib

libpng := libpng12
libpng_PKG := $(libpng).tar.bz2
libpng_GET :=
libpng_CFG := $(top_dir)/sources/$(libpng)/configure --build=$(build) --host=$(host) \
	--prefix=$(stage_dir) $(PC_ENV) \
	CFLAGS="-I$(stage_dir)/include" CPPFLAGS="-I$(stage_dir)/include" \
	LDFLAGS="-L$(stage_dir)/lib"

pango := pango
pango_PKG := $(pango).tar.bz2
pango_GET :=
pango_CFG := $(top_dir)/sources/$(pango)/configure --build=$(build) --host=$(host) \
	--prefix=$(stage_dir) -enable-introspection=no --disable-gtk-doc-html \
	--without-x $(PC_ENV) \
	CFLAGS="-I$(stage_dir)/include" LDFLAGS="-L$(stage_dir)/lib"

pixman := pixman
pixman_PKG := $(pixman).tar.bz2
pixman_GET :=
pixman_CFG := $(top_dir)/sources/$(pixman)/configure --build=$(build) --host=$(host) \
	--prefix=$(stage_dir) --disable-gtk $(PC_ENV) \
	CFLAGS="-I$(stage_dir)/include" LDFLAGS="-L$(stage_dir)/lib"

zlib := zlib
zlib_PKG := $(zlib).tar.bz2
zlib_GET :=
zlib_CFG := $(top_dir)/sources/$(zlib)/configure --static --prefix=$(stage_dir)
ifneq ($(COMPILER_PREFIX),)
zlib_CFG := CC=$(COMPILER_PREFIX)gcc LD=$(COMPILER_PREFIX)ld $(zlib_CFG)
endif

glib := glib
glib_PKG := $(glib).tar.bz2
glib_GET :=
glib_CFG := $(top_dir)/sources/$(glib)/configure --build=$(build) --host=$(host) --prefix=$(stage_dir) \
	--enable-debug=no --enable-static=yes \
	--disable-selinux --disable-fam --disable-libelf --disable-xattr --disable-man \
	glib_cv_stack_grows=no glib_cv_uscore=no ac_cv_func_posix_getpwuid_r=yes \
	ac_cv_func_posix_getgrgid_r=yes ac_cv_lib_rt_clock_gettime=no glib_cv_monotonic_clock=yes \
	DBUS1_CFLAGS="$(DBUS1_CFLAGS)" DBUS1_LIBS="$(DBUS1_LIBS)" \
	LIBFFI_CFLAGS="$(LIBFFI_CFLAGS)" LIBFFI_LIBS="$(LIBFFI_LIBS)" \
	ZLIB_CFLAGS="$(ZLIB_CFLAGS)" ZLIB_LIBS="$(ZLIB_LIBS)"

gstreamer = gstreamer
gstreamer_PKG = $(gstreamer).tar.bz2
gstreamer_GET =
gstreamer_CFG = $(top_dir)/sources/$(gstreamer)/configure --build=$(build) \
	--host=$(host) --prefix=$(stage_dir) --quiet \
	--enable-static=yes --disable-debug --disable-gst-debug --disable-nls \
	--disable-rpath --disable-gtk-doc --disable-tests --disable-valgrind \
	$(PC_ENV)
ifneq ($(COMPILER_PREFIX),)
gstreamer_CFG += --enable-introspection=no
endif

gst-plugins-base := gst-plugins-base
gst-plugins-base_PKG := $(gst-plugins-base).tar.bz2
gst-plugins-base_GET :=
gst-plugins-base_CFG := $(top_dir)/sources/$(gst-plugins-base)/configure --build=$(build) --host=$(host) \
	--prefix=$(stage_dir) --disable-gtk-doc --disable-nls --disable-rpath \
	--disable-debug --disable-valgrind --disable-x --disable-xvideo --disable-xshm \
	--disable-cdparanoia --without-x $(PC_ENV)
#	CFLAGS=-I$(stage_dir)/include LDFLAGS=-L$(stage_dir)/lib
ifneq ($(COMPILER_PREFIX),)
gst-plugins-base_CFG += --enable-introspection=no
endif
gst-rtsp-server := gst-rtsp-server
gst-rtsp-server_PKG := $(gst-rtsp-server).tar.bz2
gst-rtsp-server_GET :=
gst-rtsp-server_CFG := $(top_dir)/sources/$(gst-rtsp-server)/configure --build=$(build) --host=$(host) \
	--prefix=$(stage_dir) --disable-gtk-doc \
	PKG_CONFIG_PATH=$(stage_dir)/lib/pkgconfig
#	CFLAGS=-I$(stage_dir)/include LDFLAGS=-L$(stage_dir)/lib

gtk := gtk-3.4
gtk_PKG := $(gtk).tar.bz2
gtk_GET :=
gtk_CFG := $(top_dir)/sources/$(gtk)/configure --build=$(build) --host=$(host) \
	--prefix=$(stage_dir) --enable-debug=no --enable-static=yes \
	--disable-selinux --disable-fam --disable-libelf --disable-xattr --disable-man
#	glib_cv_stack_grows=no glib_cv_uscore=no ac_cv_func_posix_getpwuid_r=yes \
#	ac_cv_func_posix_getgrgid_r=yes ac_cv_lib_rt_clock_gettime=no glib_cv_monotonic_clock=yes \
#	DBUS1_CFLAGS="$(DBUS1_CFLAGS)" DBUS1_LIBS="$(DBUS1_LIBS)" \
#	LIBFFI_CFLAGS="$(LIBFFI_CFLAGS)" LIBFFI_LIBS="$(LIBFFI_LIBS)" \
#	ZLIB_CFLAGS="$(ZLIB_CFLAGS)" ZLIB_LIBS="$(ZLIB_LIBS)"


.PHONY: %.md5

all: expat dbus libffi zlib freetype2 fontconfig libpng12 glib pixman cairo pango \
	gstreamer gst-plugins-base gst-rtsp-server

bootstrap:
	mkdir -p build build/stage packages sources

fetch: packages/.$(dbus) packages/.$(zlib) packages/.$(libffi) \
	packages/.$(glib) packages/.$(gstreamer) packages/.$(gst-plugins-base) \
	packages/.$(gst-rtsp-server)

###############################################################################
# Compoment source fetching rules
###############################################################################
packages/.$(cairo):
	[ ! -d sources/$(cairo) ] || rm -rf sources/$(cairo)
	git clone --depth=1 git://anongit.freedesktop.org/git/cairo sources/$(cairo)
	(cd sources/$(cairo) && NOCONFIGURE=1 ./autogen.sh)
	(cd sources && tar jcvf ../packages/$(cairo_PKG) $(cairo) --exclude=.git)
	cd packages && md5sum $(cairo_PKG) > $(cairo_PKG).md5 && sha1sum $(cairo_PKG) > $(cairo_PKG).sha1
	rm -rf sources/$(cairo)

packages/.$(dbus):
	[ ! -d sources/$(dbus) ] || rm -rf sources/$(dbus)
	git clone --depth=1 git://anongit.freedesktop.org/dbus/dbus.git sources/$(dbus)
	cd sources/$(dbus) && ./autogen.sh --no-configure
	cd sources && tar jcvf ../packages/$(dbus_PKG) $(dbus) --exclude=.git
	cd packages && md5sum $(dbus_PKG) > $(dbus_PKG).md5 && sha1sum $(dbus_PKG) > $(dbus_PKG).sha1
	rm -rf sources/$(dbus)

packages/.$(expat):
	[ ! -d sources/$(expat) ] || rm -rf sources/$(expat)
	cvs -z3 -d:pserver:anonymous@expat.cvs.sourceforge.net:/cvsroot/expat co -N -d sources expat
	cd sources/$(expat) && ./buildconf.sh
	cd sources && tar jcvf ../packages/$(expat_PKG) $(expat) --exclude=CVS
	cd packages && md5sum $(expat_PKG) > $(expat_PKG).md5 && sha1sum $(expat_PKG) > $(expat_PKG).sha1
	rm -rf sources/$(expat)

packages/.$(freetype):
	[ ! -d sources/$(freetype) ] || rm -rf sources/$(freetype)
	git clone --depth=1 git://git.sv.gnu.org/freetype/freetype2.git sources/$(freetype)
	cd sources/$(freetype) && ./autogen.sh
	cd sources && tar jcvf ../packages/$(freetype_PKG) $(freetype) --exclude=.git
	cd packages && md5sum $(freetype_PKG) > $(freetype_PKG).md5 && sha1sum $(freetype_PKG) > $(freetype_PKG).sha1
	rm -rf sources/$(freetype)

packages/.$(fontconfig):
	[ ! -d sources/$(fontconfig) ] || rm -rf sources/$(fontconfig)
	git clone --depth=1 git://anongit.freedesktop.org/fontconfig sources/$(fontconfig)
	cd sources/$(fontconfig) && ./autogen.sh --noconfigure
	cd sources && tar jcvf ../packages/$(fontconfig_PKG) $(fontconfig) --exclude=.git
	cd packages && md5sum $(fontconfig_PKG) > $(fontconfig_PKG).md5 && sha1sum $(fontconfig_PKG) > $(fontconfig_PKG).sha1
	rm -rf sources/$(fontconfig)

packages/.$(libffi):
	[ ! -d sources/$(libffi) ] || rm -rf sources/$(libffi)
	git clone --depth=1 git://github.com/atgreen/libffi.git sources/$(libffi)
	(cd sources && tar jcvf ../packages/$(libffi_PKG) $(libffi) --exclude=.git)
	rm -rf sources/$(libffi)

packages/.$(libpng):
	[ ! -d sources/$(libpng) ] || rm -rf sources/$(libpng)
	git clone --depth=1 -b $(libpng) git://libpng.git.sourceforge.net/gitroot/libpng/libpng sources/$(libpng)
#	(cd sources/$(libpng) && NOCONFIGURE=1 ./autogen.sh)
	(cd sources && tar jcvf ../packages/$(libpng_PKG) $(libpng) --exclude=.git)
	cd packages && md5sum $(libpng_PKG) > $(libpng_PKG).md5 && sha1sum $(libpng_PKG) > $(libpng_PKG).sha1
	rm -rf sources/$(libpng)

packages/.$(pango):
	[ ! -d sources/$(pango) ] || rm -rf sources/$(pango)
	git clone --depth=1 git://git.gnome.org/pango.git sources/$(pango)
	(cd sources/$(pango) && NOCONFIGURE=1 ./autogen.sh)
	(cd sources && tar jcvf ../packages/$(pango_PKG) $(pango) --exclude=.git)
	cd packages && md5sum $(pango_PKG) > $(pango_PKG).md5 && sha1sum $(pango_PKG) > $(pango_PKG).sha1
	rm -rf sources/$(pango)

packages/.$(pixman):
	[ ! -d sources/$(pixman) ] || rm -rf sources/$(pixman)
	git clone --depth=1 git://anongit.freedesktop.org/git/pixman.git sources/$(pixman)
	(cd sources/$(pixman) && NOCONFIGURE=1 ./autogen.sh)
	(cd sources && tar jcvf ../packages/$(pixman_PKG) $(pixman) --exclude=.git)
	cd packages && md5sum $(pixman_PKG) > $(pixman_PKG).md5 && sha1sum $(pixman_PKG) > $(pixman_PKG).sha1
	rm -rf sources/$(pixman)

packages/.$(zlib):
	[ ! -d sources/$(zlib) ] || rm -rf sources/$(zlib)
	git clone --depth=1 git://github.com/madler/zlib.git sources/$(zlib)
	(cd sources && tar jcvf ../packages/$(zlib_PKG) $(zlib) --exclude=.git)
	rm -rf sources/$(zlib)

packages/.$(glib):
	[ ! -d sources/$(glib) ] || rm -rf sources/$(glib)
	git clone --depth=1 git://git.gnome.org/glib sources/glib
	(cd sources/$(glib) && NOCONFIGURE=1 ./autogen.sh)
	(cd sources && tar jcvf ../packages/$(glib_PKG) $(glib) --exclude=.git)
	rm -rf sources/$(glib)

packages/.$(gstreamer):
	[ ! -d sources/$(gstreamer) ] || rm -rf sources/$(gstreamer)
	git clone --depth=1 git://anongit.freedesktop.org/gstreamer/gstreamer sources/$(gstreamer)
	(cd sources/$(gstreamer) && ./autogen.sh --noconfigure)
	(cd sources && tar jcvf ../packages/$(gstreamer_PKG) $(gstreamer) --exclude=.git && md5sum $(gstreamer_PKG) > $(gstreamer_PKG).md5)
	rm -rf packages/$(gstreamer)

packages/.$(gst-plugins-base):
	[ -d sources/$(gst-plugins-base) ] || git clone --depth=1 git://anongit.freedesktop.org/gstreamer/gst-plugins-base sources/$(gst-plugins-base)
#	[ ! -d sources/$(gst-plugins-base)/.git ] || (cd sources/$(gst-plugins-base) && git clean -xdf && git pull)
	(cd sources/$(gst-plugins-base) && ./autogen.sh --noconfigure)
	(cd sources && tar jcvf ../packages/$(gst-plugins-base_PKG) $(gst-plugins-base) --exclude=.git)
	rm -rf sources/$(gst-plugins-base)

packages/.$(gst-rtsp-server):
	[ -d sources/$(gst-rtsp-server) ] || git clone --depth=1 git://anongit.freedesktop.org/gstreamer/gst-rtsp-server sources/$(gst-rtsp-server)
	(cd sources/$(gst-rtsp-server) && ./autogen.sh --noconfigure)
	(cd sources && tar jcvf ../packages/$(gst-rtsp-server_PKG) $(gst-rtsp-server) --exclude=.git)
	rm -rf sources/$(gst-rtsp-server)

packages/.$(gtk):
#	[ ! -d sources/$(gtk) ] || rm -rf sources/$(gtk)
	[ -d sources/$(gtk) ] || git clone --depth=1 -b $(gtk) git://git.gnome.org/gtk+ sources/$(gtk)
	[ ! -d sources/$(gtk)/.git ] || (cd source/$(gtk) && git clean -xdf && git pull)
	(cd sources/$(gtk) && NOCONFIGURE=1 ./autogen.sh)
	(cd sources && tar jcvf ../packages/$(gtk_PKG) $(gtk) --exclude=.git && md5sum $(gtk_PKG) > $(gtk_PKG).md5)
#	rm -rf sources/$(gtk)

###############################################################################
# Compoment building rules
###############################################################################
$(cairo): build/$(cairo)/Makefile
	cd build/$(cairo) && \
	make -j4 && make install-strip

build/.$(cairo)_cfg: packages/$(cairo_PKG)
	[ -d sources/$(cairo) ] || tar xvf packages/$(cairo_PKG) -Csources/
	[ -d build/$(cairo) ] || mkdir -p build/$(cairo)
	cd build/$(cairo) && \
	[ ! -f Makefile ] || make distclean && \
	$(cairo_CFG)

$(dbus): build/$(dbus)/Makefile
	cd build/$(dbus) && \
	make -j4 && make install-strip

build/.$(dbus)_cfg: packages/$(dbus_PKG)
	[ -d sources/$(dbus) ] || tar xvf packages/$(dbus_PKG) -Csources/
	[ -d build/$(dbus) ] || mkdir -p build/$(dbus)
	cd build/$(dbus) && \
	[ ! -f Makefile ] || make distclean && \
	$(dbus_CFG)

$(expat): build/$(expat)/Makefile
	cd build/$(expat) && \
	make -j4 && make install

build/.$(expat)_cfg: packages/$(expat_PKG)
	[ -d sources/$(expat) ] || tar xvf packages/$(expat_PKG) -Csources/
	[ -d build/$(expat) ] || mkdir -p build/$(expat)
	cd build/$(expat) && \
	[ ! -f Makefile ] || make distclean && \
	$(expat_CFG)

$(freetype): build/$(freetype)/Makefile
	cd build/$(freetype) && \
	make -j4 && make install

build/.$(freetype)_cfg: packages/$(freetype_PKG)
	[ -d sources/$(freetype) ] || tar xvf packages/$(freetype_PKG) -Csources/
	[ -d build/$(freetype) ] || mkdir -p build/$(freetype)
	cd build/$(freetype) && { \
		[ ! -f Makefile ] || make distclean; \
		$(freetype_CFG); \
	}

$(fontconfig): build/$(fontconfig)/Makefile
	cd build/$(fontconfig) && \
	make -j4 && make install

build/.$(fontconfig)_cfg: packages/$(fontconfig_PKG)
	[ -d sources/$(fontconfig) ] || tar xvf packages/$(fontconfig_PKG) -Csources/
	[ -d build/$(fontconfig) ] || mkdir -p build/$(fontconfig)
	cd build/$(fontconfig) && { \
		[ ! -f Makefile ] || make distclean; \
		$(fontconfig_CFG); \
	}

$(libffi): build/$(libffi)/Makefile
	cd build/$(libffi) && \
	make -j4 && make install-strip
#	cp -aP $(stage_dir)/lib/libffi-3.0.11/include $(stage_dir)/ && \
#	rm -rf $(stage_dir)/lib/libffi-3.0.11

build/.$(libffi)_cfg: packages/$(libffi_PKG)
	[ -d sources/$(libffi) ] || tar xvf packages/$(libffi_PKG) -Csources/
	[ -d build/$(libffi) ] || mkdir -p build/$(libffi)
	cd build/$(libffi) && \
	[ ! -f Makefile ] || make distclean && \
	$(libffi_CFG)

$(libpng): build/$(libpng)/Makefile
	cd build/$(libpng) && \
	make -j4 && make install-strip

build/.$(libpng)_cfg: packages/$(libpng_PKG)
	[ -d sources/$(libpng) ] || tar xvf packages/$(libpng_PKG) -Csources/
	[ -d build/$(libpng) ] || mkdir -p build/$(libpng)
	cd build/$(libpng) && { \
		[ ! -f Makefile ] || make distclean; \
		$(libpng_CFG); \
	}

$(pango): build/$(pango)/Makefile
	cd build/$(pango) && \
	make -j4 && make install-strip

build/.$(pango)_cfg: packages/$(pango_PKG)
	[ -d sources/$(pango) ] || tar xvf packages/$(pango_PKG) -Csources/
	[ -d build/$(pango) ] || mkdir -p build/$(pango)
	cd build/$(pango) && \
	[ ! -f Makefile ] || make distclean && \
	$(pango_CFG)

$(pixman): build/$(pixman)/Makefile
	cd build/$(pixman) && \
	make -j4 && make install-strip

build/.$(pixman)_cfg: packages/$(pixman_PKG)
	[ -d sources/$(pixman) ] || tar xvf packages/$(pixman_PKG) -Csources/
	[ -d build/$(pixman) ] || mkdir -p build/$(pixman)
	cd build/$(pixman) && \
	[ ! -f Makefile ] || make distclean && \
	$(pixman_CFG)

$(zlib): sources/$(zlib)/Makefile
	cd sources/$(zlib) && \
	make -j4 && make install

build/.$(zlib)_cfg: packages/$(zlib_PKG)
	[ -d sources/$(zlib) ] || tar xvf packages/$(zlib_PKG) -Csources/
	cd sources/$(zlib) && \
	[ ! -f Makefile ] || make distclean && \
	$(zlib_CFG)

$(glib): build/$(glib)/Makefile
#ifneq ($(COMPILER_PREFIX),)
#	cd build/$(glib) && \
#	make -j4 -C glib install-strip && \
#	make -j4 -C gmodule install-strip && \
#	make -j4 -C gthread install-strip && \
#	make -j4 && make install-strip
#else
	cd build/$(glib) && \
	make -j4 && make install-strip
#endif

build/.$(glib)_cfg: packages/$(glib_PKG)
	[ -d sources/$(glib) ] || tar xvf packages/$(glib_PKG) -Csources/
	[ -d build/$(glib) ] || mkdir -p build/$(glib)
	cd build/$(glib) && \
	[ ! -f Makefile ] || make distclean && \
	$(glib_CFG)

$(gstreamer): build/$(gstreamer)/Makefile
	cd build/$(gstreamer) && \
	make -j4 && make install-strip

build/.$(gstreamer)_cfg: packages/$(gstreamer_PKG)
	[ -d sources/$(gstreamer) ] || tar xvf packages/$(gstreamer_PKG) -Csources/
	[ -d build/$(gstreamer) ] || mkdir -p build/$(gstreamer)
	cd build/$(gstreamer) && \
	[ ! -f Makefile ] || make distclean && \
	$(gstreamer_CFG)

$(gst-plugins-base): build/$(gst-plugins-base)/Makefile
	cd build/$(gst-plugins-base) && \
	make -j4 && make install-strip

build/.$(gst-plugins-base)_cfg: packages/$(gst-plugins-base_PKG)
	[ -d sources/$(gst-plugins-base) ] || tar xvf packages/$(gst-plugins-base_PKG) -Csources/
	[ -d build/$(gst-plugins-base) ] || mkdir -p build/$(gst-plugins-base)
	cd build/$(gst-plugins-base) && \
	[ ! -f Makefile ] || make distclean && \
	$(gst-plugins-base_CFG)

$(gst-rtsp-server): build/$(gst-rtsp-server)/Makefile
	cd build/$(gst-rtsp-server) && \
	make -j4 && make install-strip

build/.$(gst-rtsp-server)_cfg: packages/$(gst-rtsp-server_PKG)
	[ -d sources/$(gst-rtsp-server) ] || tar xvf packages/$(gst-rtsp-server_PKG) -Csources/
	[ -d build/$(gst-rtsp-server) ] || mkdir -p build/$(gst-rtsp-server)
	cd build/$(gst-rtsp-server) && \
	[ ! -f Makefile ] || make distclean && \
	$(gst-rtsp-server_CFG)

$(gtk): build/$(gtk)/Makefile
	cd build/$(gtk) && \
	make -j4 && make install-strip

build/.$(gtk)_cfg: packages/$(gtk_PKG)
	[ -d sources/$(gtk) ] || tar xvf packages/$(gtk_PKG) -Csources/
	[ -d build/$(gtk) ] || mkdir -p build/$(gtk)
	cd build/$(gtk) && \
	[ ! -f Makefile ] || make distclean && \
	$(gtk_CFG)

build/%/Makefile: sources/%
	@echo ""

sources/%/Makefile: sources/%
	@echo ""

packages/%.tar.bz2: packages/.%
	@touch $^

sources/%: build/.%_cfg
	@touch $^

re-build:
	@rm -f build/.*_cfg

package-bz2:
	cd $(stage_dir) && tar jcvf $(top_dir)/$(host)-$(shell date +%Y%m%d).tar.bz2 *

