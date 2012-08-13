# Mingw-w64 builder, v1.0
#
# Webpage: https://github.com/varphone/utils.git
# Contact: Varphone Wong, varphone@qq.com
# 

build := i686-pc-linux-gnu
host := $(build)
target := i686-w64-mingw32

top_dir := $(shell pwd)
stage_dir := $(top_dir)/build/stage
target_dir := $(top_dir)/$(target)

extra_LDFLAGS := '-Wl,-rpath,[[PLACEHOLDER:PLACEHOLDER:PLACEHOLDER:PLACEHOLDER:PLACEHOLDER:PLACEHOLDER:PLACEHOLDER]]'

###############################################################################
### compoments defines
###############################################################################
binutils := binutils-2.22
binutils_PKG := $(binutils).tar.bz2
binutils_GET := wget http://ftp.gnu.org/gnu/binutils/$(binutils_PKG) -O packages/$(binutils_PKG)
binutils_CFG := LDFLAGS=$(extra_LDFLAGS) ../../source/$(binutils)/configure\
	--target=$(target) --disable-multilib\
	--disable-static --enable-shared --enable-lto --enable-cloog-backend=isl\
	--disable-ppl-version-check --disable-cloog-version-check\
	--with-sysroot=$(target_dir) --prefix=$(target_dir)\
	--with-gmp=$(stage_dir) --with-mpfr=$(stage_dir) --with-mpc=$(stage_dir)\
	--with-ppl=$(stage_dir) --with-cloog=$(stage_dir) 

gcc := gcc-4.8-20120708
gcc_PKG := $(gcc).tar.bz2
gcc_GET := wget ftp://gcc.gnu.org/pub/gcc/snapshots/4.8-20120708/gcc-4.8-20120708.tar.bz2
#gcc_GET := wget http://ftp.gnu.org/gnu/gcc/$(gcc)/$(gcc_PKG) -O packages/$(gcc_PKG)
#gcc_CFG := LDFLAGS= $(extra_LDFLAGS) ../../source/$(gcc)/configure\
	--target=$(target) --disable-multilib --enable-languages=c,c++\
	--with-sysroot=$(target_dir) --prefix=$(target_dir)\
	--with-gmp=$(stage_dir) --with-mpfr=$(stage_dir) --with-mpc=$(stage_dir)
gcc_CFG := LDFLAGS=$(extra_LDFLAGS) ../../source/$(gcc)/configure\
	--target=$(target) --disable-multilib --enable-languages=c,c++\
	--disable-ppl-version-check --disable-cloog-version-check\
	--enable-lto --enable-cloog-backend=isl\
	--with-sysroot=$(target_dir) --prefix=$(target_dir)\
	--with-gmp=$(stage_dir) --with-mpfr=$(stage_dir) --with-mpc=$(stage_dir)\
	--with-ppl=$(stage_dir) --with-isl=$(stage_dir) --with-cloog=$(stage_dir)
gcc-core_CFG := $(gcc_CFG)

gmp := gmp-5.0.5
gmp_PKG := $(gmp).tar.bz2
gmp_GET := wget http://ftp.gnu.org/gnu/gmp/$(gmp_PKG) -O packages/$(gmp_PKG)
gmp_CFG := ../../source/$(gmp)/configure\
	--build=$(build) --host=$(host) --prefix=$(stage_dir)\
	--disable-static --enable-shared --enable-cxx

mpfr := mpfr-3.1.1
mpfr_PKG := $(mpfr).tar.bz2
mpfr_GET := wget http://www.mpfr.org/mpfr-current/$(mpfr_PKG) -O packages/$(mpfr_PKG)
mpfr_CFG := ../../source/$(mpfr)/configure\
	--build=$(build) --host=$(host) --prefix=$(stage_dir)\
	--disable-static --enable-shared --enable-thread-safe\
	--with-gmp=$(stage_dir)

mpc := mpc-0.9
mpc_PKG := $(mpc).tar.gz
mpc_GET := wget http://www.multiprecision.org/mpc/download/$(mpc_PKG) -O packages/$(mpc_PKG)
mpc_CFG := ../../source/$(mpc)/configure\
	--build=$(build) --host=$(host) --prefix=$(stage_dir)\
	--disable-static --enable-shared\
	--with-gmp=$(stage_dir) --with-mpfr=$(stage_dir)

isl := isl-0.10
isl_PKG := $(isl).tar.bz2
isl_GET := wget ftp://gcc.gnu.org/pub/gcc/infrastructure/$(isl_PKG) -O packages/$(isl_PKG)
isl_CFG := ../../source/$(isl)/configure\
	--build=$(build) --host=$(host) --prefix=$(stage_dir)\
	--disable-static --enable-shared\
	--with-gmp=system --with-gmp-prefix=$(stage_dir)

cloog := cloog-0.17.0
cloog_PKG := $(cloog).tar.gz
cloog_GET := wget ftp://gcc.gnu.org/pub/gcc/infrastructure/$(cloog_PKG) -O packages/$(cloog_PKG)
cloog_CFG := ../../source/$(cloog)/configure\
	--build=$(build) --host=$(host) --prefix=$(stage_dir)\
	--disable-static --enable-shared\
	--with-gmp=system --with-gmp-prefix=$(stage_dir)\
	--with-isl=system --with-isl-prefix=$(stage_dir)

ppl := ppl-1.0
ppl_PKG := $(ppl).tar.bz2
ppl_GET := wget http://bugseng.com/products/ppl/download/ftp/releases/1.0/$(ppl_PKG) -O packages/$(ppl_PKG)
ppl_CFG := ../../source/$(ppl)/configure\
	--build=$(build) --host=$(host) --prefix=$(stage_dir)\
	--disable-static --enable-shared --enable-pch --disable-documentation\
	--with-gmp=$(stage_dir) 

cloog-ppl := cloog-ppl-0.15.11
cloog-ppl_PKG := $(cloog-ppl).tar.gz
cloog-ppl_GET := wget ftp://gcc.gnu.org/pub/gcc/infrastructure/$(cloog-ppl_PKG) -O packages/$(cloog-ppl_PKG)
cloog-ppl_CFG := ../../source/$(cloog-ppl)/configure\
	--build=$(build) --host=$(host) --prefix=$(stage_dir)\
	--disable-static --enable-shared\
	--with-gmp=$(stage_dir) --with-ppl=$(stage_dir)\
	--with-host-libstdcxx="-lstdc++"

polylib := polylib-5.22.5
polylib_PKG := $(polylib).tar.gz
polylib_GET := wget http://icps.u-strasbg.fr/polylib/polylib_src/$(polylib_PKG) -O packages/$(polylib_PKG)
polylib_CFG := ../../source/$(polylib)/configure\
	--build=$(build) --host=$(host) --prefix=$(stage_dir)\
	--disable-static --enable-shared\
	--enable-int-lib --enable-longint-lib --enable-longlongint-lib

mingw-w64 := mingw-w64-latest
mingw-w64_PKG := $(mingw-w64).tar.gz
mingw-w64_GET := wget http://mingw-w64.svn.sourceforge.net/viewvc/mingw-w64/trunk/?view=tar -O packages/$(mingw-w64_PKG)
mingw-w64_CFG := ../../source/$(mingw-w64)/configure\
	--host=$(target)\
	--with-sysroot=$(target_dir) --prefix=$(target_dir)\
	--without-headers --with-libraries=no --with-tools=no
mingw-w64-crt_CFG := ../../../source/$(mingw-w64)/mingw-w64-crt/configure\
	--host=$(target) --with-sysroot=$(target_dir) --prefix=$(target_dir)
mingw-w64-headers_CFG := ../../../source/$(mingw-w64)/mingw-w64-headers/configure\
	--build=$(build) --host=$(target)\
	--prefix=$(target_dir)/$(target)

export PATH := $(top_dir)/$(target)/bin:$(PATH)
export LD_LIBRARY_PATH := $(top_dir)/build/stage/lib

###############################################################################
### rules
###############################################################################
all:

###############################################################################
### prepare rules
###############################################################################
bootstrap:
	@mkdir -p build build/stage packages source $(target)

configure: binutils_cfg gcc-core_cfg gmp_cfg mpfr_cfg mpc_cfg ppl_cfg cloog-ppl_cfg mingw-w64-headers_cfg


fetch:
	@[ -f "packages/$(binutils_PKG)" ] || $(binutils_GET)
	@[ -f "packages/$(gcc_PKG)" ] || $(gcc_GET)
	@[ -f "packages/$(gmp_PKG)" ] || $(gmp_GET)
	@[ -f "packages/$(mpfr_PKG)" ] || $(mpfr_GET)
	@[ -f "packages/$(mpc_PKG)" ] || $(mpc_GET)
	@[ -f "packages/$(isl_PKG)" ] || $(isl_GET)
	@[ -f "packages/$(cloog_PKG)" ] || $(cloog_GET)
	@[ -f "packages/$(ppl_PKG)" ] || $(ppl_GET)
	@[ -f "packages/$(cloog-ppl_PKG)" ] || $(cloog-ppl_GET)
	@[ -f "packages/$(polylib_PKG)" ] || $(polylib_GET)
	@[ -f "packages/$(mingw-w64_PKG)" ] || $(mingw-w64_GET)


###############################################################################
### binutils build rules
###############################################################################
binutils:
	@cd build/$(binutils) || exit 1;\
	make && make install-strip;

binutils_cfg:
	@[ -d build/$(binutils) ] || mkdir -p build/$(binutils)
	@[ -d source/$(binutils) ] || tar jxvf packages/$(binutils_PKG) -Csource
	cd build/$(binutils) || exit 1;\
	$(binutils_CFG);\


###############################################################################
### gcc build rules
###############################################################################
gcc:
	cd build/$(gcc) || exit 1;\
	make && make install-strip;

gcc_cfg:
	@[ -d "build/$(gcc)" ] || mkdir -p build/$(gcc)
	@[ -d "source/$(gcc)" ] || tar jxvf packages/$(gcc_PKG) -Csource
	cd build/$(gcc) || exit 1;\
	$(gcc_CFG);

gcc-core:
	cd build/$(gcc) || exit 1;\
	make all-gcc && make install-gcc;

gcc-core_cfg:
	@[ -d "build/$(gcc)" ] || mkdir -p build/$(gcc)
	@[ -d "source/$(gcc)" ] || tar jxvf packages/$(gcc_PKG) -Csource
	cd build/$(gcc) || exit 1;\
	$(gcc-core_CFG);

###############################################################################
### mingw-w64 build rules
###############################################################################
mingw-w64: 
	cd build/$(mingw-w64) || exit 1;\
	make && make install;

mingw-w64_src:
	@[ -d "source/$(mingw-w64)" ] || (tar xvf packages/$(mingw-w64_PKG) -Csource && [ -d "source/trunk" ] && mv source/trunk source/$(mingw-w64))
	@[ -d "source/$(mingw-w64)" ] || svn co http://mingw-w64.svn.sourceforge.net/svnroot/mingw-w64/trunk source/mingw-w64
	@[ ! -d "source/$(mingw-w64)/.svn" ] || (cd source/$(mingw-w64); svn up)

mingw-w64_cfg:
	@[ -d "source/$(mingw-w64)" ] || (tar xvf packages/$(mingw-w64_PKG) -Csource && [ -d "source/trunk" ] && mv source/trunk source/$(mingw-w64))
	@[ -d "source/$(mingw-w64)" ] || svn co http://mingw-w64.svn.sourceforge.net/svnroot/mingw-w64/trunk source/mingw-w64
	@[ ! -d "source/$(mingw-w64)/.svn" ] || (cd source/$(mingw-w64); svn up)
	@[ -d "build/$(mingw-w64)" ] || mkdir -p build/$(mingw-w64)
	cd build/$(mingw-w64) || exit 1;\
	$(mingw-w64_CFG);

mingw-w64-crt:
	cd build/$(mingw-w64)/mingw-w64-crt || exit 1;\
	make && make install;

mingw-w64-crt_cfg:
	@[ -d "source/$(mingw-w64)" ] || (tar xvf packages/$(mingw-w64_PKG) -Csource && [ -d "source/trunk" ] && mv source/trunk source/$(mingw-w64))
	@[ -d "source/$(mingw-w64)" ] || svn co http://mingw-w64.svn.sourceforge.net/svnroot/mingw-w64/trunk source/mingw-w64
	@[ ! -d "source/$(mingw-w64)/.svn" ] || (cd source/$(mingw-w64); svn up)
	@[ -d "build/$(mingw-w64)/mingw-w64-crt" ] || mkdir -p build/$(mingw-w64)/mingw-w64-crt
	cd build/$(mingw-w64)/mingw-w64-crt || exit 1;\
	$(mingw-w64-crt_CFG);

mingw-w64-headers:
	cd build/$(mingw-w64)/mingw-w64-headers || exit 1;\
	make install;

mingw-w64-headers_cfg:
	@[ -d "build/$(mingw-w64)/mingw-w64-headers" ] || mkdir -p build/$(mingw-w64)/mingw-w64-headers
	cd build/$(mingw-w64)/mingw-w64-headers || exit 1;\
	$(mingw-w64-headers_CFG);

###############################################################################
### gmp build rules
###############################################################################
gmp:
	cd build/$(gmp) || exit 1;\
	make && make install-strip;

gmp_cfg:
	@[ -d "build/$(gmp)" ] || mkdir -p build/$(gmp)
	@[ -d "source/$(gmp)" ] || tar jxvf packages/$(gmp_PKG) -Csource
	cd build/$(gmp) || exit 1;\
	$(gmp_CFG);

###############################################################################
### mpfr build rules
###############################################################################
mpfr:
	cd build/$(mpfr) || exit 1;\
	make && make install-strip;

mpfr_cfg:
	@[ -d "build/$(mpfr)" ] || mkdir -p build/$(mpfr)
	@[ -d "source/$(mpfr)" ] || tar xvf packages/$(mpfr_PKG) -Csource
	cd build/$(mpfr) || exit 1;\
	$(mpfr_CFG);

###############################################################################
### mpc build rules
###############################################################################
mpc:
	cd build/$(mpc) || exit 1;\
	make && make install-strip;

mpc_cfg:
	@[ -d "build/$(mpc)" ] || mkdir -p build/$(mpc)
	@[ -d "source/$(mpc)" ] || tar xvf packages/$(mpc_PKG) -Csource
	cd build/$(mpc) || exit 1;\
	$(mpc_CFG);

###############################################################################
### isl build rules
###############################################################################
isl:
	cd build/$(isl) || exit 1;\
	make && make install-strip;

isl_cfg: 
	@[ -d "build/$(isl)" ] || mkdir -p build/$(isl)
	@[ -d "source/$(isl)" ] || tar xvf packages/$(isl_PKG) -Csource
	cd build/$(isl) || exit 1;\
	$(isl_CFG);

###############################################################################
### cloog build rules
###############################################################################
cloog:
	cd build/$(cloog) || exit 1;\
	make && make install-strip;

cloog_cfg:
	@[ -d "build/$(cloog)" ] || mkdir -p build/$(cloog)
	@[ -d "source/$(cloog)" ] || tar xvf packages/$(cloog_PKG) -Csource
	cd build/$(cloog) || exit 1;\
	$(cloog_CFG);

###############################################################################
### ppl build rules
###############################################################################
ppl:
	cd build/$(ppl) || exit 1;\
	make && make install-strip;

ppl_cfg: 
	@[ -d "build/$(ppl)" ] || mkdir -p build/$(ppl)
	@[ -d "source/$(ppl)" ] || tar xvf packages/$(ppl_PKG) -Csource
	cd build/$(ppl) || exit 1;\
	$(ppl_CFG);

###############################################################################
### cloog-ppl build rules
###############################################################################
cloog-ppl:
	cd build/$(cloog-ppl) || exit 1;\
	make && make install-strip;

cloog-ppl_cfg:
	@[ -d "build/$(cloog-ppl)" ] || mkdir -p build/$(cloog-ppl)
	@[ -d "source/$(cloog-ppl)" ] || tar xvf packages/$(cloog-ppl_PKG) -Csource
	cd build/$(cloog-ppl) || exit 1;\
	$(cloog-ppl_CFG);

###############################################################################
### polylib build rules
###############################################################################
polylib:
	cd build/$(polylib) || exit 1;\
	make && make install-strip;

polylib_cfg:
	[ -d "build/$(polylib)" ] || mkdir -p build/$(polylib)
	[ -d "source/$(polylib)" ] || tar xvf packages/$(polylib_PKG) -Csource
	cd build/$(polylib) || exit 1;\
	$(polylib_CFG);

###############################################################################
### install all builted files
###############################################################################

.PHONY: clean distclean fixrpath install package

install:
	$(MAKE) -C build/$(binutils) $@
	$(MAKE) -C build/$(mingw-w64) $@

fixrpath:
	@echo "Fixing RPATH on executable file(s) in $(target)"
	@./fixrpath $(target)

package: fixrpath
	[ ! -d "$(target)/$(build)/$(target)" ] || (mv -aP $(target)/$(build)/$(target)/* $(target)/; rm -rf $(target)/$(build))
	[ ! -d "build/stage/lib" ] || cp -aP build/stage/lib/lib* $(target)/libexec/gcc/$(target)/*/
	tar jcvf $(target)-$$(uname)-$$(date +%Y%m%d).tar.bz2 $(target)

