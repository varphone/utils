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

build ?= $(shell gcc -dumpmachine) 
host ?= $(build)
target ?= $(host)

ifneq ($(build),$(host))
COMPILER_PREFIX := $(host)-
endif

top_dir := $(shell pwd)
stage_dir := $(top_dir)/build/stage
target_dir := $(top_dir)/$(target)

libffi := libffi
libffi_PKG := $(libffi).tar.bz2
libffi_GET :=
libffi_CFG := $(top_dir)/sources/$(libffi)/configure --build=$(build) --host=$(host) --prefix=$(stage_dir) \
	--disable-builddir --disable-shared \
	CFLAGS=-I$(stage_dir)/include LDFLAGS=-L$(stage_dir)/lib

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
	--disable-selinux \
	glib_cv_stack_grows=no glib_cv_uscore=no ac_cv_func_posix_getpwuid_r=yes \
	ac_cv_func_posix_getgrgid_r=yes ac_cv_lib_rt_clock_gettime=no glib_cv_monotonic_clock=yes \
	CFLAGS=-I$(stage_dir)/include LDFLAGS=-L$(stage_dir)/lib

gstreamer = gstreamer
gstreamer_PKG = $(gstreamer).tar.bz2
gstreamer_GET =
gstreamer_CFG = $(top_dir)/sources/$(gstreamer)/configure --build=$(build) --host=$(host) --prefix=$(stage_dir) \
	--disable-loadsave --disable-gtk-doc --disable-tests --disable-valgrind \
	CFLAGS=-I$(stage_dir)/include LDFLAGS=-L$(stage_dir)/lib

gst-plugins-base := gst-plugins-base
gst-plugins-base_PKG := $(gst-plugins-base).tar.bz2
gst-plugins-base_GET :=
gst-plugins-base_CFG := $(top_dir)/sources/$(gst-plugins-base)/configure --build=$(build) --host=$(host) \
	--prefix=$(stage_dir) --disable-gtk-doc \
	CFLAGS=-I$(stage_dir)/include LDFLAGS=-L$(stage_dir)/lib PKG_CONFIG_PATH=$(stage_dir)/lib/pkgconfig

gst-rtsp-server := gst-rtsp-server
gst-rtsp-server_PKG := $(gst-rtsp-server).tar.bz2
gst-rtsp-server_GET :=
gst-rtsp-server_CFG := $(top_dir)/sources/$(gst-rtsp-server)/configure --build=$(build) --host=$(host) \
	--prefix=$(stage_dir) --disable-gtk-doc \
	CFLAGS=-I$(stage_dir)/include LDFLAGS=-L$(stage_dir)/lib PKG_CONFIG_PATH=$(stage_dir)/lib/pkgconfig

all: zlib_cfg zlib libffi_cfg libffi glib_cfg glib gstreamer_cfg gstreamer gst-plugins-base_cfg \
	gst-plugins-base gst-rtsp-server_cfg gst-rtsp-server

bootstrap:
	mkdir -p build build/stage packages sources

fetch: fetch_zlib fetch_libffi fetch_glib fetch_gstreamer fetch_gst-plugins-base fetch_gst-rtsp-server

fetch_libffi:
	[ ! -d sources/$(libffi) ] || rm -rf sources/$(libffi)
	git clone --depth=1 git://github.com/atgreen/libffi.git sources/$(libffi)
	(cd sources && tar jcvf ../packages/$(libffi_PKG) $(libffi) --exclude=.git)
	rm -rf sources/$(libffi)

fetch_zlib:
	[ ! -d sources/$(zlib) ] || rm -rf sources/$(zlib)
	git clone --depth=1 git://github.com/madler/zlib.git sources/$(zlib)
	(cd sources && tar jcvf ../packages/$(zlib_PKG) $(zlib) --exclude=.git)
	rm -rf sources/$(zlib)

fetch_glib:
	[ ! -d sources/$(glib) ] || rm -rf sources/$(glib)
	git clone --depth=1 git://git.gnome.org/glib sources/glib
	(cd sources/$(glib) && NOCONFIGURE=1 ./autogen.sh)
	(cd sources && tar jcvf ../packages/$(glib_PKG) $(glib) --exclude=.git)
	rm -rf sources/$(glib)

fetch_gstreamer:
	[ ! -d sources/$(gstreamer) ] || rm -rf sources/$(gstreamer)
	git clone --depth=1 git://anongit.freedesktop.org/gstreamer/gstreamer sources/$(gstreamer)
	(cd sources/$(gstreamer) && ./autogen.sh --noconfigure)
	(cd sources && tar jcvf ../packages/$(gstreamer_PKG) $(gstreamer) --exclude=.git)
	rm -rf packages/$(gstreamer)

fetch_gst-plugins-base:
	[ -d sources/$(gst-plugins-base) ] || git clone --depth=1 git://anongit.freedesktop.org/gstreamer/gst-plugins-base sources/$(gst-plugins-base)
#	[ ! -d sources/$(gst-plugins-base)/.git ] || (cd sources/$(gst-plugins-base) && git clean -xdf && git pull)
	(cd sources/$(gst-plugins-base) && ./autogen.sh --noconfigure)
	(cd sources && tar jcvf ../packages/$(gst-plugins-base_PKG) $(gst-plugins-base) --exclude=.git)
	rm -rf sources/$(gst-plugins-base)

fetch_gst-rtsp-server:
	[ -d sources/$(gst-rtsp-server) ] || git clone --depth=1 git://anongit.freedesktop.org/gstreamer/gst-rtsp-server sources/$(gst-rtsp-server)
	(cd sources/$(gst-rtsp-server) && ./autogen.sh --noconfigure)
	(cd sources && tar jcvf ../packages/$(gst-rtsp-server_PKG) $(gst-rtsp-server) --exclude=.git)
	rm -rf sources/$(gst-rtsp-server)

libffi:
	cd build/$(libffi) && \
	make -j4 && make install-strip && make clean && \
	cp -aP $(stage_dir)/lib/libffi-3.0.11/include $(stage_dir)/ && \
	rm -rf $(stage_dir)/lib/libffi-3.0.11

libffi_cfg:
	[ -d sources/$(libffi) ] || tar xvf packages/$(libffi_PKG) -Csources/
	[ -d build/$(libffi) ] || mkdir -p build/$(libffi)
	cd build/$(libffi) && \
	$(libffi_CFG)

zlib:
	cd sources/$(zlib) && \
	make -j4 && make install && make clean

zlib_cfg:
	[ -d sources/$(zlib) ] || tar xvf packages/$(zlib_PKG) -Csources/
	cd sources/$(zlib) && \
	$(zlib_CFG)

glib:
	cd build/$(glib) && \
	make -j4 && make install-strip && make clean

glib_cfg:
	[ -d sources/$(glib) ] || tar xvf packages/$(glib_PKG) -Csources/
	[ -d build/$(glib) ] || mkdir -p build/$(glib)
	cd build/$(glib) && \
	$(glib_CFG)

gstreamer:
	cd build/$(gstreamer) && \
	make -j4 && make install-strip && make clean

gstreamer_cfg:
	[ -d sources/$(gstreamer) ] || tar xvf packages/$(gstreamer_PKG) -Csources/
	[ -d build/$(gstreamer) ] || mkdir -p build/$(gstreamer)
	cd build/$(gstreamer) && \
	$(gstreamer_CFG)

gst-plugins-base:
	cd build/$(gst-plugins-base) && \
	make -j4 && make install-strip && make clean

gst-plugins-base_cfg:
	[ -d sources/$(gst-plugins-base) ] || tar xvf packages/$(gst-plugins-base_PKG) -Csources/
	[ -d build/$(gst-plugins-base) ] || mkdir -p build/$(gst-plugins-base)
	cd build/$(gst-plugins-base) && \
	$(gst-plugins-base_CFG)

gst-rtsp-server:
	cd build/$(gst-rtsp-server) && \
	make -j4 && make install-strip && make clean

gst-rtsp-server_cfg:
	[ -d sources/$(gst-rtsp-server) ] || tar xvf packages/$(gst-rtsp-server_PKG) -Csources/
	[ -d build/$(gst-rtsp-server) ] || mkdir -p build/$(gst-rtsp-server)
	cd build/$(gst-rtsp-server) && \
	$(gst-rtsp-server_CFG)

