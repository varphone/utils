#/bin/bash

[ "$1" = "rebuild" ] && rm -f .*.ok

BUILD=i686-linux-gnu
HOST=i686-linux-gnu
HOST_ROOT=${HOME}/workspace/target/i686-linux-gnu
HOST_SYSROOT=${HOST_ROOT}/usr
HOST_CFLAGS="-O2 -pipe"
HOST_CXXFLAGS="-O2 -pipe"
HOST_LDFLAGS=""
HOST_INCLUDE="-I${HOST_SYSROOT}/include"
HOST_LIBS="-L${HOST_SYSROOT}/lib"

TARGET=arm-hi3531-linux-gnueabi
TARGET_ROOT=${HOME}/workspace/toolchain/${TARGET}
TARGET_SYSROOT=${TARGET_ROOT}/${TARGET}/sysroot
#TARGET_CFLAGS="-Os -g -pipe -mlittle-endian -march=armv7-a -mcpu=cortex-a9 -mfloat-abi=softfp -mfpu=vfpv3-d16"
#TARGET_CXXFLAGS="-Os -g -pipe -mlittle-endian -march=armv7-a -mcpu=cortex-a9 -mfloat-abi=softfp -mfpu=vfpv3-d16"
#TARGET_LDFLAGS="-Wl,-EL"
TARGET_CFLAGS="-Os -g -pipe"
TARGET_CXXFLAGS="-Os -g -pipe"
TARGET_LDFLAGS="-Wl,-EL"

PKG_VERSION="VCT v100 for Hi3531(gcc-4.8.0,glibc-2.16,eabi,ntpl)"
BUGURL="mailto://varphone@foxmail.com"

build_linux_headers()
{
	[ -d "$1" ] || exit 1
    [ -f .$1.ok ] || {
    	pushd "$1"
	    make headers_install ARCH=$(echo "${TARGET}" | cut -d'-' -f1) INSTALL_HDR_PATH=${TARGET_SYSROOT}/usr || exit 1
	    popd
        touch .$1.ok
    }
}

build_host_lib()
{
	[ -d "$1" ] || exit 1
    [ -f .$1.ok ] || {
    	pushd "$1"
	    CFLAGS="${HOST_CFLAGS} ${HOST_INCLUDE}" CXXFLAGS="${HOST_CXXFLAGS} ${HOST_INCLUDE}" LDFLAGS="${HOST_LDFLAGS} ${HOST_LIBS}" ./configure --build=${HOST} --host=${HOST} --target=${HOST} --disable-shared --prefix=${HOST_SYSROOT} || exit 1
	    make || exit 1
    	make install || exit 1
	    popd
        touch .$1.ok
    }
}

build_binutils()
{
	[ -d "$1" ] || exit 1
    [ -f .$1.ok ] || {
    	mkdir -p build-binutils
	    pushd build-binutils
	    CFLAGS="${HOST_CFLAGS}" CXXFLAGS="${HOST_CXXFLAGS}" LDFLAGS="${HOST_LDFLAGS}" ../$1/configure --build=${HOST} --host=${HOST} --target=${TARGET} --disable-shared --prefix=${TARGET_ROOT} --disable-multilib --disable-ppl-version-check --disable-cloog-version-check --enable-cloog-backend=isl --with-float=softfp --with-gmp=${HOST_SYSROOT} --with-mpc=${HOST_SYSROOT} --with-mpfr=${HOST_SYSROOT} --with-isl=${HOST_SYSROOT} --with-cloog=${HOST_SYSROOT} --with-sysroot=${TARGET_SYSROOT} --with-pkgversion=${PKG_VERSION} || exit 1
	    make -j4 || exit 1
	    make install || exit 1
	    popd
	    rm -rf build-binutils
        touch .$1.ok
    }
}

build_gcc()
{
	[ -d "$1" ] || exit 1
    [ -f .$1.$2.ok ] || {
    	mkdir -p build-gcc
	    pushd build-gcc
    	case "$2" in
	    	stage1)
	    		CC_FOR_BUILD=${HOST}-gcc CFLAGS="${HOST_CFLAGS}" CXXFLAGS="${HOST_CXXFLAGS}" LDFLAGS="${HOST_LDFLAGS}" ../$1/configure --build=${HOST} --host=${HOST} --target=${TARGET} --prefix=${TARGET_ROOT} --disable-shared --disable-threads --disable-multilib --disable-isl-version-check --enable-languages=c,c++ --enable-__cxa_atexit --enable-target-optspace --with-float=softfp --with-newlib --with-gmp=${HOST_SYSROOT} --with-mpc=${HOST_SYSROOT} --with-mpfr=${HOST_SYSROOT} --with-isl=${HOST_SYSROOT} --with-cloog=${HOST_SYSROOT} --with-libelf=${HOST_SYSROOT} --with-local-prefix=${TARGET_SYSROOT} --with-sysroot=${TARGET_SYSROOT} --with-host-libstdcxx="-static-libgcc -Wl,-Bstatic,-lstdc++,-Bdynamic -lm -L${HOST_SYSROOT}/lib" --without-headers || exit 1
	    		make -j4 -l all-gcc all-target-libgcc || exit 1
	    		make -j4 -l install-gcc install-target-libgcc || exit 1
	    		;;
	    	stage2)
	    		CC_FOR_BUILD=${HOST}-gcc CFLAGS="${HOST_CFLAGS}" CXXFLAGS="${HOST_CXXFLAGS}" LDFLAGS="${HOST_LDFLAGS}" ../$1/configure --build=${HOST} --host=${HOST} --target=${TARGET} --prefix=${TARGET_ROOT} --enable-shared --enable-threads=posix --disable-multilib --disable-isl-version-check --enable-languages=c,c++ --enable-__cxa_atexit --with-arch=armv7-a --with-cpu=cortex-a9 --with-float=softfp --with-fpu=vfpv3-d16 --with-mode=thumb --with-gmp=${HOST_SYSROOT} --with-mpc=${HOST_SYSROOT} --with-mpfr=${HOST_SYSROOT} --with-isl=${HOST_SYSROOT} --with-cloog=${HOST_SYSROOT} --with-libelf=${HOST_SYSROOT} --with-local-prefix=${TARGET_SYSROOT} --with-sysroot=${TARGET_SYSROOT} --with-host-libstdcxx="-static-libgcc -Wl,-Bstatic,-lstdc++,-Bdynamic -lm -L${HOST_SYSROOT}/lib" --with-pkgversion="${PKG_VERSION}" --with-bugurl="${BUGURL}" --without-newlib || exit 1
	    		make -j4 -l all-gcc all-target-libgcc || exit 1
	    		make -j4 -l install-gcc install-target-libgcc || exit 1
	    		;;
	    	stage3)
	    		CC_FOR_BUILD=${HOST}-gcc CFLAGS="${HOST_CFLAGS}" CXXFLAGS="${HOST_CXXFLAGS}" LDFLAGS="${HOST_LDFLAGS}" CFLAGS_FOR_TARGET="${TARGET_CFLAGS} " CXXFLAGS_FOR_TARGET="${TARGET_CXXFLAGS}" LDFLAGS_FOR_TARGET="${TARGET_LDFLAGS}" ../$1/configure --build=${HOST} --host=${HOST} --target=${TARGET} --prefix=${TARGET_ROOT} --disable-multilib --disable-isl-version-check --enable-shared --enable-threads=posix --enable-target-optspace --enable-languages=c,c++ --enable-__cxa_atexit --with-arch=armv7-a --with-cpu=cortex-a9 --with-float=softfp --with-fpu=vfpv3-d16 --with-mode=thumb --with-gmp=${HOST_SYSROOT} --with-mpc=${HOST_SYSROOT} --with-mpfr=${HOST_SYSROOT} --with-isl=${HOST_SYSROOT} --with-cloog=${HOST_SYSROOT} --with-libelf=${HOST_SYSROOT} --with-local-prefix=${TARGET_SYSROOT} --with-sysroot=${TARGET_SYSROOT} --with-host-libstdcxx="-static-libgcc -Wl,-Bstatic,-lstdc++,-Bdynamic -lm -L${HOST_SYSROOT}/lib" --with-pkgversion="${PKG_VERSION}" --with-bugurl="${BUGURL}" --without-newlib || exit 1
	    		make -j4 -l || exit 1
	    		make -j4 -l install || exit 1
	    		;;
	    	*)
	    		;;
	    esac
    	popd
	    rm -rf build-gcc
        touch .$1.$2.ok
    }
}
#--with-sysroot=${TARGET_SYSROOT}

build_glibc()
{
	[ -d "$1" ] || exit 1
    [ -f .$1.$2.ok ] || {
    	mkdir -p build-glibc
	    pushd build-glibc
	    case "$2" in
	    	stage1)
	    		PATH_ORIG=${PATH}
	    		export PATH=${TARGET_ROOT}/bin:${PATH}
	    		cp ../$1/Makeconfig.static ../$1/Makeconfig
	    		CFLAGS="${TARGET_CFLAGS}" CXXFLAGS="${TARGET_CXXFLAGS}" LDFLAGS="${TARGET_LDFLAGS}" ../$1/configure --prefix=/usr --host=${TARGET} --enable-add-ons --with-headers=${TARGET_SYSROOT}/usr/include --with-pkgversion="${PKG_VERSION}" --with-bugurl="${BUGURL}" || exit 1
	    		make -j4 -l || exit 1
	    		make -j4 -l install_root=${TARGET_SYSROOT} install || exit 1
	    		export PATH=${PATH_ORIG}
    			;;
	    	stage2)
	    		PATH_ORIG=${PATH}
	    		export PATH=${TARGET_ROOT}/bin:${PATH}
	    		cp ../$1/Makeconfig.shared ../$1/Makeconfig
	    		CFLAGS="${TARGET_CFLAGS}" CXXFLAGS="${TARGET_CXXFLAGS}" LDFLAGS="${TARGET_LDFLAGS}" ../$1/configure --host=${TARGET} --prefix=/usr --enable-add-ons --enable-obsolete-rpc --with-headers=${TARGET_SYSROOT}/usr/include --with-pkgversion="${PKG_VERSION}" --with-bugurl="${BUGURL}" || exit 1
	    		make -j4 -l || exit 1
	    		make -j4 -l install_root=${TARGET_SYSROOT} install || exit 1
	    		export PATH=${PATH_ORIG}
	    		;;
	    	stage3)
	    		PATH_ORIG=${PATH}
	    		export PATH=${TARGET_ROOT}/bin:${PATH}
	    		cp ../$1/Makeconfig.shared ../$1/Makeconfig
	    		CFLAGS="${TARGET_CFLAGS}" CXXFLAGS="${TARGET_CXXFLAGS}" LDFLAGS="${TARGET_LDFLAGS}" ../$1/configure --host=${TARGET} --prefix=/usr --enable-add-ons --enable-obsolete-rpc --with-headers=${TARGET_SYSROOT}/usr/include || exit 1
	    		make -j4 -l || exit 1
	    		make -j4 -l install_root=${TARGET_SYSROOT} install || exit 1
	    		export PATH=${PATH_ORIG}
	    		;;
	    	*)
	    		;;
	    esac
	    popd
	    rm -rf build-glibc
        touch .$1.$2.ok
    }
}

build_linux_headers linux-3.0.y
build_host_lib gmp-5.1.1
build_host_lib mpfr-3.1.2
build_host_lib mpc-1.0.1
build_host_lib isl-0.11.2
build_host_lib cloog-0.18.0
build_host_lib libelf-0.8.13

build_binutils binutils-2.23.2
build_gcc gcc-4.8.0 stage1
build_glibc glibc-2.16.0 stage1
build_gcc gcc-4.8.0 stage2
build_glibc glibc-2.16.0 stage2
build_gcc gcc-4.8.0 stage3
build_glibc glibc-2.16.0 stage3
