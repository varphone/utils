# Mingw-w64 builder, v1.0
#
# Webpage: https://github.com/varphone/Mingw-w64-Builder.git
# Contact: Varphone Wong, varphone@qq.com
# 

host := i686-pc-linux-gnu
target := i686-w64-mingw32

top_dir := $(shell pwd)
stage_dir := $(top_dir)/build/stage
target_dir := $(top_dir)/$(target)

binutils := binutils-2.22
pkg_binutils := $(binutils).tar.bz2
cfg_binutils := ../../source/$(binutils)/configure\
	--target=$(target) --disable-multilib\
	--with-sysroot=$(target_dir) --prefix=$(target_dir)

gcc := gcc-4.7.1
pkg_gcc = $(gcc).tar.bz2
cfg_gcc :=
cfg_gcc-core := ../../source/$(gcc)/configure\
	--target=$(target) --disable-multilib\
	--with-sysroot=$(target_dir) --prefix=$(target_dir)\
	--with-gmp=$(stage_dir) --with-mpfr=$(stage_dir) --with-mpc=$(stage_dir)

gmp := gmp-5.0.5
pkg_gmp := $(gmp).tar.bz2
cfg_gmp := ../../source/$(gmp)/configure\
	--build=$(host) --prefix=$(stage_dir)\
	--disable-shared --enable-static --enable-cxx

mpfr := mpfr-3.1.1
pkg_mpfr := $(mpfr).tar.bz2
cfg_mpfr := ../../source/$(mpfr)/configure\
	--build=$(host) --prefix=$(stage_dir)\
	--disable-shared --enable-static --with-gmp=$(stage_dir)

mpc := mpc-0.9
pkg_mpc := $(mpc).tar.gz
cfg_mpc := ../../source/$(mpc)/configure\
	--build=$(host) --prefix=$(stage_dir)\
	--disable-shared --enable-static\
	--with-gmp=$(stage_dir) --with-mpfr=$(stage_dir) 

ppl := ppl-1.0
pkg_ppl := $(ppl).tar.bz2
get_ppl := wget http://bugseng.com/products/ppl/download/ftp/releases/1.0/$(pkg_ppl) -O packages/$(pkg_ppl)
cfg_ppl := ../../source/$(ppl)/configure\
	--build=$(host) --prefix=$(stage_dir)\
	--disable-shared --enable-static\
	--with-gmp=$(stage_dir) 

cloog-ppl := cloog-ppl-0.15.11
pkg_cloog-ppl := $(cloog-ppl).tar.gz
cfg_cloog-ppl := ../../source/$(cloog-ppl)/configure\
	--build=$(host) --prefix=$(stage_dir)\
	--disable-shared --enable-static\
	--with-gmp=$(stage_dir) --with-ppl=$(stage_dir)\
	--with-host-libstdcxx="-lstdc++"

polylib := polylib-5.22.5
pkg_polylib := $(polylib).tar.gz
uri_polylib := http://icps.u-strasbg.fr/polylib/polylib_src/$(pkg_polylib)
cfg_polylib := ../../source/$(polylib)/configure\
	--build=$(host) --prefix=$(stage_dir)\
	--disable-shared --enable-static\
	--enable-int-lib --enable-longint-lib --enable-longlongint-lib

mingw-w64 := mingw-w64
pkg_mingw-w64 := mingw-w64-latest.tar.gz
uri_mingw-w64 := http://mingw-w64.svn.sourceforge.net/viewvc/mingw-w64/trunk/?view=tar
cfg_mingw-w64 := ../../source/$(mingw-w64)/configure\
	--build=i$(host) --host=$(target)\
	--prefix=$(target_dir)
cfg_mingw-w64-headers := ../../source/$(mingw-w64)/configure\
	--build=$(host) --host=$(target) --prefix=$(target_dir)

all:

bootstrap:
	@mkdir -p build build/stage packages source $(target)

configure: binutils_cfg gcc-core_cfg gmp_cfg mpfr_cfg mpc_cfg ppl_cfg cloog-ppl_cfg mingw-w64-headers_cfg


fetch:
	[ -f "packages/$(pkg_binutils)" ] || wget http://ftp.gnu.org/gnu/binutils/$(pkg_binutils) -O packages/$(pkg_binutils)
	[ -f "packages/$(pkg_gcc)" ] || wget http://ftp.gnu.org/gnu/gcc/$(gcc)/$(pkg_gcc) -O packages/$(pkg_gcc)
	[ -f "packages/$(pkg_gmp)" ] || wget http://ftp.gnu.org/gnu/gmp/$(pkg_gmp) -O packages/$(pkg_gmp)
	[ -f "packages/$(pkg_mpfr)" ] || wget http://www.mpfr.org/mpfr-current/$(pkg_mpfr) -O packages/$(pkg_mpfr)
	[ -f "packages/$(pkg_mpc)" ] || wget http://www.multiprecision.org/mpc/download/$(pkg_mpc) -O packages/$(pkg_mpc)
#	[ -f "packages/$(pkg_ppl)" ] || wget ftp://ftp.cs.unipr.it/pub/ppl/releases/0.12.1/$(pkg_ppl) -O packages/$(pkg_ppl)
	@[ -f "packages/$(pkg_ppl)" ] || $(get_ppl)
	[ -f "packages/$(pkg_cloog-ppl)" ] || wget ftp://gcc.gnu.org/pub/gcc/infrastructure/$(pkg_cloog-ppl) -O packages/$(pkg_cloog-ppl)
	[ -f "packages/$(pkg_polylib)" ] || wget $(uri_polylib) -O packages/$(pkg_polylib)
	[ -f "packages/$(pkg_mingw-w64)" ] || wget $(uri_mingw-w64) -O packages/$(pkg_mingw-w64)

binutils:
	cd build/$(binutils);\
	make && make install;

binutils_cfg:
	[ -d build/$(binutils) ] || mkdir -p build/$(binutils)
	[ -d source/$(binutils) ] || tar jxvf packages/$(pkg_binutils) -Csource
	cd build/$(binutils);\
	$(cfg_binutils);\

gcc:

mingw-w64: gcc-core

mingw-w64-src:
	[ -d "source/$(mingw-w64)" ] || (tar jxvf packages/$(pkg_mingw-w64) -Csource && [ -d "source/trunk" ] && mv source/trunk source/$(mingw-w64))
	[ -d "source/$(mingw-w64)" ] || svn co http://mingw-w64.svn.sourceforge.net/svnroot/mingw-w64/trunk source/mingw-w64
	[ -d "source/$(mingw-w64)/.svn" ] && (cd source/$(mingw-w64); svn up)
	[ -d "build/$(mingw-w64)" ] || mkdir -p build/$(mingw-w64)
	cd build/$(mingw-w64);\
#	$(cfg_mingw-w64);\
	make;

mingw-w64-headers: mingw-w64-src binutils
	cd build$(mingw-w64)/mingw-w64-headers;\
	make && make install;

mingw-w64-headers_cfg:
	[ -d "build/$(mingw-w64)/mingw-w64-headers" ] || mkdir -p build/$(mingw-w64)/mingw-w64-headers
	cd build$(mingw-w64)/mingw-w64-headers;\
	$(cfg_mingw-w64-headers);


gcc-core: mpc cloog-ppl mingw-w64-headers
	cd build/$(gcc);\
	make all-gcc && make install-gcc;

gcc-core_cfg:
	[ -d "build/$(gcc)" ] || mkdir -p build/$(gcc)
	[ -d "source/$(gcc)" ] || tar jxvf packages/$(pkg_gcc) -Csource
	cd build/$(gcc);\
	$(cfg_gcc-core);

gmp:
	cd build/$(gmp);\
	make && make install;

gmp_cfg:
	[ -d "build/$(gmp)" ] || mkdir -p build/$(gmp)
	[ -d "source/$(gmp)" ] || tar jxvf packages/$(pkg_gmp) -Csource
	cd build/$(gmp);\
	$(cfg_gmp);

mpfr: gmp
	cd build/$(mpfr);\
	make && make install;

mpfr_cfg:
	[ -d "build/$(mpfr)" ] || mkdir -p build/$(mpfr)
	[ -d "source/$(mpfr)" ] || tar xvf packages/$(pkg_mpfr) -Csource
	cd build/$(mpfr);\
	$(cfg_mpfr);

mpc: mpfr
	cd build/$(mpc);\
	make && make install;

mpc_cfg:
	[ -d "build/$(mpc)" ] || mkdir -p build/$(mpc)
	[ -d "source/$(mpc)" ] || tar xvf packages/$(pkg_mpc) -Csource
	cd build/$(mpc);\
	$(cfg_mpc);

ppl: gmp
	cd build/$(ppl);\
	make && make install;

ppl_cfg: 
	[ -d "build/$(ppl)" ] || mkdir -p build/$(ppl)
	[ -d "source/$(ppl)" ] || tar xvf packages/$(pkg_ppl) -Csource
	cd build/$(ppl);\
	$(cfg_ppl);

cloog-ppl: ppl
	cd build/$(cloog-ppl);\
	make && make install;

cloog-ppl_cfg:
	[ -d "build/$(cloog-ppl)" ] || mkdir -p build/$(cloog-ppl)
	[ -d "source/$(cloog-ppl)" ] || tar xvf packages/$(pkg_cloog-ppl) -Csource
	cd build/$(cloog-ppl);\
	$(cfg_cloog-ppl);

polylib:
	cd build/$(polylib);\
	make && make install;

polylib_cfg:
	[ -d "build/$(polylib)" ] || mkdir -p build/$(polylib)
	[ -d "source/$(polylib)" ] || tar xvf packages/$(pkg_polylib) -Csource
	cd build/$(polylib);\
	$(cfg_polylib);

install:
	$(MAKE) -C build/$(binutils) $@
	$(MAKE) -C build/$(mingw-w64) $@

