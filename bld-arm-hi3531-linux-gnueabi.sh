#/bin/bash

BUILD=i686-linux-gnu
HOST=i686-linux-gnu
HOST_SYSROOT=${HOME}/workspace/target/i686-linux-gnu/usr
HOST_CFLAGS="-O2 -I${HOST_SYSROOT}/include"
HOST_CXXFLAGS="-O2 -I${HOST_SYSROOT}/include"
HOST_LDFLAGS="-L${HOST_SYSROOT}/lib"

TARGET=arm-hi3531-linux-gnueabi
TARGET_SYSROOT=${HOME}/workspace/toolchain/${TARGET}
TARGET_CFLAGS="-Os -g -I${TARGET_SYSROOT}/usr/include"
TARGET_CXXFLAGS="-Os -g -I${TARGET_SYSROOT}/usr/include"
TARGET_LDFLAGS="-L${TARGET_SYSROOT}/usr/lib"

build_linux_headers()
{
    [ -d "$1" ] || exit 1
	pushd "$1"
	make headers_install ARCH=$(echo "${TARGET}" | cut -d'-' -f1) INSTALL_HDR_PATH=${TARGET_SYSROOT}/${TARGET} || exit 1
	popd
}

build_host_lib()
{
	[ -d "$1" ] || exit 1
	pushd "$1"
	CFLAGS=${HOST_CFLAGS} CXXFLAGS=${HOST_CXXFLAGS} LDFLAGS=${HOST_LDFLAGS} ./configure --build=${HOST} --host=${HOST} --target=${HOST} --disable-shared --prefix=${HOST_SYSROOT} || exit 1
	make || exit 1
	make install || exit 1
	popd
}

build_binutils()
{
	[ -d "$1" ] || exit 1
	mkdir -p binutils-build
	pushd binutils-build
	 CFLAGS="${HOST_CFLAGS}" CXXFLAGS="${HOST_CXXFLAGS}" LDFLAGS="${HOST_LDFLAGS}" ../$1/configure --build=${HOST} --host=${HOST} --target=${TARGET} --disable-shared --prefix=${TARGET_SYSROOT} || exit 1
	make -j4 || exit 1
	make install || exit 1
	popd
	rm -rf binutils-build
}

build_gcc()
{
	[ -d "$1" ] || exit 1
	mkdir -p build-gcc
	pushd build-gcc
	case "$2" in
		stage1)
			CFLAGS="${HOST_CFLAGS}" CXXFLAGS="${HOST_CXXFLAGS}" LDFLAGS="${HOST_LDFLAGS}" ../$1/configure --build=${HOST} --host=${HOST} --target=${TARGET} --disable-shared --disable-threads --disable-multilib --enable-languages=c --prefix=${TARGET_SYSROOT} --with-newlib --without-headers || exit 1
			make all-gcc all-target-libgcc -j4 || exit 1
			make install-gcc install-target-libgcc || exit 1
			;;
		stage2)
			CFLAGS="${HOST_CFLAGS}" CXXFLAGS="${HOST_CXXFLAGS}" LDFLAGS="${HOST_LDFLAGS}" ../$1/configure --build=${HOST} --host=${HOST} --target=${TARGET} --disable-multilib --enable-languages=c,c++ --prefix=${TARGET_SYSROOT} --with-build-time-tools=${TARGET_SYSROOT}/bin || exit 1
			make -j4 || exit 1
			make install || exit 1
			;;
		stage3)
			CFLAGS="${HOST_CFLAGS}" CXXFLAGS="${HOST_CXXFLAGS}" LDFLAGS="${HOST_LDFLAGS}" ../$1/configure --build=${HOST} --host=${HOST} --target=${TARGET} --disable-multilib --enable-languages=c,c++ --prefix=${TARGET_SYSROOT} --with-build-time-tools=${TARGET_SYSROOT}/bin || exit 1
			make -j4 || exit 1
			make install || exit 1
			;;
		*)
			;;
	esac
	popd
	rm -rf build-gcc
}
#--with-sysroot=${TARGET_SYSROOT}

build_glibc()
{
	[ -d "$1" ] || exit 1
	mkdir -p build-glibc
	pushd build-glibc
	case "$2" in
		stage1)
			PATH_ORIG=${PATH}
			export PATH=${TARGET_SYSROOT}/bin:${PATH}
			cp ../$1/Makeconfig.static ../$1/Makeconfig
			CFLAGS="${TARGET_CFLAGS}" CXXFLAGS="${TARGET_CXXFLAGS}" LDFLAGS="${TARGET_LDFLAGS}" ../$1/configure --host=${TARGET} --prefix=${TARGET_SYSROOT}/${TARGET} --with-headers=${TARGET_SYSROOT}/${TARGET}/include || exit 1
			make -j4 || exit 1
			make install_root="" install|| exit 1
			export PATH=${PATH_ORIG}
			;;
		stage2)
			PATH_ORIG=${PATH}
			export PATH=${TARGET_SYSROOT}/bin:${PATH}
			cp ../$1/Makeconfig.shared ../$1/Makeconfig
			CFLAGS="${TARGET_CFLAGS}" CXXFLAGS="${TARGET_CXXFLAGS}" LDFLAGS="${TARGET_LDFLAGS}" ../$1/configure --host=${TARGET} --prefix=${TARGET_SYSROOT}/${TARGET} --with-headers=${TARGET_SYSROOT}/${TARGET}/include || exit 1
			make -j4 || exit 1
			make install_root="" install|| exit 1
			export PATH=${PATH_ORIG}
			;;
		*)
			;;
	esac
	popd
	rm -rf build-glibc
}

build_linux_headers linux-3.0
build_host_lib gmp-5.1.1
build_host_lib mpfr-3.1.2
build_host_lib mpc-1.0.1
build_host_lib isl-0.11.2
build_host_lib cloog-0.18.0

build_binutils binutils-2.23.2
build_gcc gcc-4.8.0 stage1
build_glibc glibc-2.16.0 stage1
build_gcc gcc-4.8.0 stage2
build_glibc glibc-2.16.0 stage2
build_gcc gcc-4.8.0 stage3
