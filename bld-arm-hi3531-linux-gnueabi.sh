#/bin/bash
#
# Script for create custom cross toolchain for hi3531 platform
# Author: Varphone Wong, varphone@foxmail.com
# Require:
#   Host: gcc >= 4.5, autotools, flex, bison, gmp-5.1.1, mpfr-3.1.2, mpc-1.0.1,
#         isl-0.11.2, cloog-0.18.0, libelf-0.8.13
#   Target: linux-3.0.y, binutils-2.23.2, gcc-4.8.0, glibc-2.16, gdb-4.6, qt-4.8.4, ncurses-5.9
#
# Usage:
#   $ mkdir xxx
#   $ cd xxx
#   $ bld-arm-hi3531-linux-gnueabi.sh
#

[ "$1" = "rebuild" ] && rm -f .*.ok

BUILD=i686-linux-gnu

HOST=i686-linux-gnu
HOST_ROOT=${HOME}/workspace/target/i686-linux-gnu
HOST_SYSROOT=${HOST_ROOT}/usr
HOST_CFLAGS="-O2 -pipe"
HOST_CXXFLAGS="-O2 -pipe"
HOST_LDFLAGS=""
HOST_HEADERS="-I${HOST_SYSROOT}/include"
HOST_LIBS="-L${HOST_SYSROOT}/lib"
HOST_VARS="CC=${HOST}-gcc CXX=${HOST}-g++ AR=${HOST}-ar AS=${HOST}-as LD=${HOST}-ld RANLIB=${HOST}-ranlib STRIP=${HOST}-strip"

TARGET=arm-hi3531-linux-gnueabi
TARGET_ROOT=${HOME}/workspace/toolchain/${TARGET}
TARGET_SYSROOT=${TARGET_ROOT}/${TARGET}/sysroot
#TARGET_CFLAGS="-Os -g -pipe -mlittle-endian -march=armv7-a -mcpu=cortex-a9 -mfloat-abi=softfp -mfpu=vfpv3-d16"
#TARGET_CXXFLAGS="-Os -g -pipe -mlittle-endian -march=armv7-a -mcpu=cortex-a9 -mfloat-abi=softfp -mfpu=vfpv3-d16"
#TARGET_LDFLAGS="-Wl,-EL"
TARGET_CFLAGS="-Os -g -pipe"
TARGET_CXXFLAGS="-Os -g -pipe"
TARGET_LDFLAGS="-Wl,-EL"
TARGET_HEADERS="-I${TARGET_SYSROOT}/usr/include"
TARGET_LIBS="-L${TARGET_SYSROOT}/usr/lib"
TARGET_VARS="CC=${TARGET}-gcc CXX=${TARGET}-g++ AR=${TARGET}-ar AS=${TARGET}-as LD=${TARGET}-ld RANLIB=${TARGET}-ranlib STRIP=${TARGET}-strip"
TARGET_TARBALLS=${TARGET_ROOT}/${TARGET}/tarballs

PKG_VERSION="VCT v100 for Hi3531(gcc-4.8.0,glibc-2.16,eabi,ntpl)"
BUGURL="mailto://varphone@foxmail.com"
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

check_dirs()
{
	[ -d "${TARGET_TARBALLS}" ] || mkdir -p "${TARGET_TARBALLS}"
}

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
    [ -f .$1.${HOST}.ok ] || {
		mkdir -p "build-$1" || exit 1
    	pushd "build-$1"
	    CFLAGS="${HOST_CFLAGS} ${HOST_HEADERS}" CXXFLAGS="${HOST_CXXFLAGS} ${HOST_HEADERS}" LDFLAGS="${HOST_LDFLAGS} ${HOST_LIBS}" ../$1/configure --build=${HOST} --host=${HOST} --target=${HOST} --disable-shared --prefix=${HOST_SYSROOT} || exit 1
	    make || exit 1
    	make install || exit 1
	    popd
		rm -rf "build-$1"
        touch .$1.${HOST}.ok
    }
}

build_target_app()
{
	[ -d "$1" ] || exit 1
    [ -f .$1.${TARGET}.ok ] || {
		mkdir -p "build-$1" || exit 1
    	pushd "build-$1"
   		PATH_ORIG=${PATH}
   		export PATH=${TARGET_ROOT}/bin:${PATH}
		[ "${AUTORECONF}" = "y" ] && {
			pushd ../$1/
			[ -x autogen.sh ] && ./autogen.sh || autoreconf -fiv
			popd
		}
	    CFLAGS="${TARGET_CFLAGS} ${TARGET_HEADERS} ${EXTRA_CFLAGS}" CXXFLAGS="${TARGET_CXXFLAGS} ${TARGET_HEADERS} ${EXTRA_CXXFLAGS}" LDFLAGS="${TARGET_LDFLAGS} ${TARGET_LIBS} ${EXTRA_LDFLAGS}" ../$1/configure --host=${TARGET} --prefix=${TARGET_SYSROOT}/usr ${EXTRA_CONF} || exit 1
	    make -j1 || exit 1
    	make install || exit 1
	    popd
   		export PATH=${PATH_ORIG}
		rm -rf "build-$1"
        touch .$1.${TARGET}.ok
    }
}

build_target_lib()
{
	[ -d "$1" ] || exit 1
    [ -f .$1.${TARGET}.ok ] || {
		mkdir -p "build-$1" || exit 1
    	pushd "build-$1"
   		PATH_ORIG=${PATH}
   		export PATH=${TARGET_ROOT}/bin:${PATH}
	    CFLAGS="${TARGET_CFLAGS} ${TARGET_HEADERS}" CXXFLAGS="${TARGET_CXXFLAGS} ${TARGET_HEADERS}" LDFLAGS="${TARGET_LDFLAGS} ${TARGET_LIBS}" ../$1/configure --host=${TARGET} --prefix=${TARGET_SYSROOT}/usr --enable-shared --enable-static ${EXTRA_CONF} || exit 1
	    make -j4 || exit 1
    	make install || exit 1
	    popd
   		export PATH=${PATH_ORIG}
		rm -rf "build-$1"
        touch .$1.${TARGET}.ok
    }
}

build_target_lib_qt()
{
	[ -d "$1" ] || exit 1
    [ -f .$1.${TARGET}.ok ] || {
		mkdir -p "build-$1" || exit 1
    	pushd "build-$1"
   		PATH_ORIG=${PATH}
   		export PATH=${TARGET_ROOT}/bin:${PATH}
	    CFLAGS="${TARGET_HEADERS}" CXXFLAGS="${TARGET_HEADERS}" LDFLAGS="${TARGET_LDFLAGS} ${TARGET_LIBS}" ../$1/configure -opensource -confirm-license -embedded arm -xplatform qws/linux-arm-hi3531-gnueabi-g++ -release -fast -little-endian -qt-sql-sqlite -plugin-sql-sqlite -qt-gfx-linuxfb -qt-zlib -qt-libtiff -qt-libpng -qt-libjpeg -no-rpath -no-pch -no-glib -no-webkit -no-qt3support -no-phonon -no-script -no-scripttools -no-declarative -no-declarative-debug -no-3dnow -no-avx -no-neon -no-openssl -no-nis -no-cups -no-dbus -no-opengl -no-libmng -nomake demos -nomake examples -nomake docs ${EXTRA_CONF} || exit 1
	    make -j4 || exit 1
    	make install || exit 1
	    popd
   		export PATH=${PATH_ORIG}
		rm -rf "build-$1"
        touch .$1.${TARGET}.ok
    }
}

build_binutils()
{
	[ -d "$1" ] || exit 1
    [ -f .$1.ok ] || {
    	mkdir -p build-binutils
	    pushd build-binutils
	    CFLAGS="${HOST_CFLAGS} ${HOST_HEADERS}" CXXFLAGS="${HOST_CXXFLAGS} ${HOST_HEADERS}" LDFLAGS="${HOST_LDFLAGS} ${HOST_LIBS}" ../$1/configure --build=${HOST} --host=${HOST} --target=${TARGET} --disable-shared --prefix=${TARGET_ROOT} --disable-multilib --disable-ppl-version-check --disable-cloog-version-check --enable-cloog-backend=isl --with-float=softfp --with-sysroot=${TARGET_SYSROOT} || exit 1
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
	    		CC_FOR_BUILD=${HOST}-gcc CFLAGS="${HOST_CFLAGS} ${HOST_HEADERS}" CXXFLAGS="${HOST_CXXFLAGS} ${HOST_HEADERS}" LDFLAGS="${HOST_LDFLAGS} ${HOST_LIBS}" ../$1/configure --build=${HOST} --host=${HOST} --target=${TARGET} --prefix=${TARGET_ROOT} --disable-shared --disable-threads --disable-multilib --disable-isl-version-check --enable-languages=c,c++ --enable-__cxa_atexit --enable-target-optspace --with-float=softfp --with-newlib --with-libelf=${HOST_SYSROOT} --with-local-prefix=${TARGET_SYSROOT} --with-sysroot=${TARGET_SYSROOT} --with-host-libstdcxx="-static-libgcc -Wl,-Bstatic,-lstdc++,-Bdynamic -lm" --without-headers || exit 1
	    		make -j4 -l all-gcc all-target-libgcc || exit 1
	    		make -j4 -l install-gcc install-target-libgcc || exit 1
	    		;;
	    	stage2)
	    		CC_FOR_BUILD=${HOST}-gcc CFLAGS="${HOST_CFLAGS} ${HOST_HEADERS}" CXXFLAGS="${HOST_CXXFLAGS} ${HOST_HEADERS}" LDFLAGS="${HOST_LDFLAGS} ${HOST_LIBS}" ../$1/configure --build=${HOST} --host=${HOST} --target=${TARGET} --prefix=${TARGET_ROOT} --enable-shared --enable-threads=posix --disable-multilib --disable-isl-version-check --enable-languages=c,c++ --enable-__cxa_atexit --with-arch=armv7-a --with-cpu=cortex-a9 --with-float=softfp --with-fpu=vfpv3-d16 --with-mode=thumb --with-local-prefix=${TARGET_SYSROOT} --with-sysroot=${TARGET_SYSROOT} --with-host-libstdcxx="-static-libgcc -Wl,-Bstatic,-lstdc++,-Bdynamic -lm" --with-pkgversion="${PKG_VERSION}" --with-bugurl="${BUGURL}" --without-newlib || exit 1
	    		make -j4 -l all-gcc all-target-libgcc || exit 1
	    		make -j4 -l install-gcc install-target-libgcc || exit 1
	    		;;
	    	stage3)
	    		CC_FOR_BUILD=${HOST}-gcc CFLAGS="${HOST_CFLAGS} ${HOST_HEADERS}" CXXFLAGS="${HOST_CXXFLAGS} ${HOST_HEADERS}" LDFLAGS="${HOST_LDFLAGS} ${HOST_LIBS}" CFLAGS_FOR_TARGET="${TARGET_CFLAGS} " CXXFLAGS_FOR_TARGET="${TARGET_CXXFLAGS}" LDFLAGS_FOR_TARGET="${TARGET_LDFLAGS}" ../$1/configure --build=${HOST} --host=${HOST} --target=${TARGET} --prefix=${TARGET_ROOT} --disable-multilib --disable-isl-version-check --enable-shared --enable-threads=posix --enable-target-optspace --enable-languages=c,c++ --enable-__cxa_atexit --with-arch=armv7-a --with-cpu=cortex-a9 --with-float=softfp --with-fpu=vfpv3-d16 --with-mode=thumb --with-local-prefix=${TARGET_SYSROOT} --with-sysroot=${TARGET_SYSROOT} --with-host-libstdcxx="-static-libgcc -Wl,-Bstatic,-lstdc++,-Bdynamic -lm" --with-pkgversion="${PKG_VERSION}" --with-bugurl="${BUGURL}" --without-newlib || exit 1
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
	    		CFLAGS="${TARGET_CFLAGS}" CXXFLAGS="${TARGET_CXXFLAGS}" LDFLAGS="${TARGET_LDFLAGS}" ../$1/configure --prefix=/usr --host=${TARGET} --enable-add-ons --with-headers=${TARGET_SYSROOT}/usr/include || exit 1
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

build_target_busybox()
{
	[ -d "$1" ] || exit 1
    [ -f .$1.$2.ok ] || {
	    pushd $1
	    PATH_ORIG=${PATH}
	    export PATH=${TARGET_ROOT}/bin:${PATH}
		make $2
		make -j4 -l || exit 1
		make install || exit 1
		pushd _install
		fakeroot tar zcvf "${TARGET_TARBALLS}/$1.tgz" *
		popd
		make distclean
  		export PATH=${PATH_ORIG}
		popd
		touch .$1.$2.ok
	}
}

pack_runtime_libs()
{
    # tar glibc libs
	pushd "${TARGET_SYSROOT}"
	cp -aP ../lib/libgcc_s.so* lib/
	chmod a+x lib/libgcc_s.so*
	fakeroot tar zcvf "${TARGET_TARBALLS}/lib.glibc.tgz" lib
	rm lib/libgcc_s.so*
	popd
    # tar stdc++ libs
	pushd "${TARGET_ROOT}/${TARGET}"
	fakeroot tar zcvf "${TARGET_TARBALLS}/lib.stdc++.tgz" lib/libstdc++.so.6.0.18 lib/libstdc++.so.6 lib/libstdc++.so
	popd
    # tar qt libs
    pushd "${TARGET_SYSROOT}/usr/local/qt-4.8.4"
    cp -aP plugins lib/
    fakeroot tar --transform 's,^,/usr/,S' -zcvf "${TARGET_TARBALLS}/lib.qt.tgz" lib/lib*.so* lib/fonts lib/plugins
    rm -rf lib/plugins
    popd
    # tar sqlite3, lua, ... tools & libs
    pushd "${TARGET_SYSROOT}"
    fakeroot tar -zcvf "${TARGET_TARBALLS}/luajit2.tgz" usr/bin/luajit* usr/lib/libluajit*.so* usr/share/lua usr/share/luajit-2.0.1
    fakeroot tar -zcvf "${TARGET_TARBALLS}/sqlite3.tgz" usr/bin/sqlite3 usr/lib/libsqlite3.so*
    popd    
}

echo "========================================================================="
echo "Checking environments ..."
check_dirs

echo "========================================================================="
echo "Preparing kernel headers ..."
build_linux_headers linux-3.0.y

echo "========================================================================="
echo "Building host libs ..."
build_host_lib gmp-5.1.1
build_host_lib mpfr-3.1.2
build_host_lib mpc-1.0.1
build_host_lib isl-0.11.2
build_host_lib cloog-0.18.0
build_host_lib libelf-0.8.13

echo "========================================================================="
echo "Building cross toolchain ..."
build_binutils binutils-2.23.2
build_gcc gcc-4.8.0 stage1
build_glibc glibc-2.16.0 stage1
build_gcc gcc-4.8.0 stage2
build_glibc glibc-2.16.0 stage2
build_gcc gcc-4.8.0 stage3
build_glibc glibc-2.16.0 stage3

echo "========================================================================="
echo "Building libelf for target ..."
(
	export ${TARGET_VARS} EXTRA_CONF="--enable-elf64";
	build_target_lib libelf-0.8.13
)

echo "========================================================================="
echo "Building ncurses for target ..."
build_target_lib ncurses-5.9

echo "========================================================================="
echo "Building gdb for target ..."
(
	EXTRA_CFLAGS="-I${TARGET_SYSROOT}/usr/include/ncurses"
	build_target_app gdb-7.6
)

echo "========================================================================="
echo "Building ltrace for target ..."
#EXTRA_CFLAGS="-D__LIBELF64=1" EXTRA_CONF="--enable-werror=no" build_target_app ltrace-0.7.2

echo "========================================================================="
echo "Building qt for target ..."
(
	EXTRA_CONF="-shared -prefix ${TARGET_SYSROOT}/usr/local/qt-4.8.4"
	build_target_lib_qt qt-everywhere-opensource-src-4.8.4
    fix_install=${TARGET_SYSROOT}/usr/local/qt-4.8.4/fix_install.sh
    echo "/bin/bash" > ${fix_install}
    echo "echo \"/bin/bash\" > bin/qt.conf" >> ${fix_install}
    echo "echo \"[Paths]\" >> bin/qt.conf" >> ${fix_install}
    echo "echo \"Prefix=\$(pwd)\" >> bin/qt.conf" >> ${fix_install}
    chmod a+x ${fix_install}
) || exit 1

echo "========================================================================="
echo "Building freetype2 for target ..."
build_target_lib freetype-2.4.12

echo "========================================================================="
echo "Building gdbm for target ..."
build_target_lib gdbm-1.10

echo "========================================================================="
echo "Building gettext for target ..."
build_target_lib gettext-0.18.2

echo "========================================================================="
echo "Building libpcap for target ..."
EXTRA_CONF="--with-pcap=linux" build_target_lib libpcap-1.3.0

echo "========================================================================="
echo "Building readline for target ..."
build_target_lib readline-6.2

echo "========================================================================="
echo "Building pcre for target ..."
build_target_lib pcre-8.32

echo "========================================================================="
echo "Building sqlite3 for target ..."
build_target_lib sqlite-autoconf-3071602

echo "========================================================================="
echo "Building zlib for target ..."
(
    src=zlib-1.2.8
	[ -d "${src}" ] || exit 1
    [ -f .${src}.${TARGET}.ok ] || {
        pushd ${src}
        export ${TARGET_VARS}
	    PATH_ORIG=${PATH}
	    export PATH=${TARGET_ROOT}/bin:${PATH}
        ./configure --prefix=${TARGET_SYSROOT}/usr
        make -j4 -l || exit 1
        make install || exit 1
        make clean
   		export PATH=${PATH_ORIG}
        popd
        touch .${src}.${TARGET}.ok
    }
) || exit 1

echo "========================================================================="
echo "Building busybox for target ..."
build_target_busybox busybox-1.21.0 hi3531_defconfig

echo "========================================================================="
echo "Building bash for target ..."
(
    export ${TARGET_VARS} EXTRA_CFLAGS="-static" EXTRA_CONF="--enable-job-control --enable-static-link --disable-nls --disable-rpath --without-bash-malloc"
    #build_target_app bash-4.2
) || exit 1

echo "========================================================================="
echo "Building e2fsprogs for target ..."
EXTRA_CONF="--enable-symlink-install --enable-relative-symlinks --enable-symlink-build --disable-debugfs --disable-imager --disable-tls --disable-uuidd --disable-nls --disable-rpath" build_target_app e2fsprogs-1.42.7

echo "========================================================================="
echo "Building iperf for target ..."
build_target_app iperf-3.0b5

echo "========================================================================="
echo "Building Luajit for target ..."
(
    src=LuaJIT-2.0.1
	[ -d "${src}" ] || exit 1
    [ -f .${src}.${TARGET}.ok ] || {
        pushd ${src}
        export ${TARGET_VARS}
	    PATH_ORIG=${PATH}
	    export PATH=${TARGET_ROOT}/bin:${PATH}
        make HOST_CC="gcc -m32" CROSS=${TARGET}-
        make install PREFIX=/usr DESTDIR="${TARGET_SYSROOT}"
        make clean
   		export PATH=${PATH_ORIG}
        popd
        touch .${src}.${TARGET}.ok
    }
) || exit 1

echo "========================================================================="
echo "Building tcpdump for target ..."
ac_cv_linux_vers=3.0 build_target_app tcpdump-4.3.0

echo "========================================================================="
echo "Make links for arm-linux ..."
(
    pushd "${TARGET_ROOT}/bin"
    find . -type f -exec bash -c "ln -s {} \$(echo {} | sed 's/${TARGET}/arm-linux/')" \; || exit 1
    popd
) || exit 1

echo "========================================================================="
echo "Strip all target binaries ..."
${TARGET_ROOT}/bin/${TARGET}-strip ${TARGET_SYSROOT}/usr/bin/*
${TARGET_ROOT}/bin/${TARGET}-strip ${TARGET_SYSROOT}/usr/sbin/*

echo "========================================================================="
echo "Packing for glibc and stdc++ runtime libraries ..."
pack_runtime_libs

echo "========================================================================="
echo "Every things build ok"
