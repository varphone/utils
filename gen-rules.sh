#/bin/bash

[ -n "$1" ] || {
	echo "Usage: $0 <compoment>"
	exit 1
}

[ -d "$1" ] && {
	echo "Error: compoment $1 alreay exists"
	exit 2
}

LNAME=$1
UNAME=$(echo ${LNAME} | tr '[a-z]' '[A-Z]')

mkdir -p ${LNAME}

cat > ${LNAME}/rules.mak << EOF
# ${LNAME}

${UNAME} := ${LNAME}
${UNAME}_VERSION :=
${UNAME}_PKG := \$(${UNAME})-\$(${UNAME}_VERSION)
${UNAME}_URL := \$(${UNAME}_PKG)
${UNAME}_CFG := 

PKGS += \$(${UNAME})
ifeq (\$(call need_pkg,"${LNAME}"),)
PKGS_FOUND += \$(${UNAME})
endif

DEPS_\$(${UNAME}) =

\$(TARBALLS)/\$(${UNAME}_PKG):
	\$(call download,\$(${UNAME}_URL))

.sum-\$(${UNAME}): \$(${UNAME}_PKG)

\$(${UNAME}): \$(${UNAME}_PKG) .sum-\$(${UNAME})
	\$(UNPACK)
	\$(MOVE)

.\$(${UNAME}): \$(${UNAME})
#	cd $< && \$(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd \$< && \$(BUILDVARS) \$(HOSTTOOLS) \$(HOSTVARS) ./configure \$(HOSTCONF) \$(${UNAME}_CFG)
else
	cd \$< && \$(HOSTTOOLS) \$(HOSTVARS) ./configure \$(HOSTCONF) \$(${UNAME}_CFG)
endif
	cd \$< && \$(MAKE) install
	touch \$@
EOF

