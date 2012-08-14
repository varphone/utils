#!/bin/bash

SRC=$(pwd)
TARBALLS=${SRC}/../tarballs
CHKSUM=sha512sum

for d in $(find . -maxdepth 1 -type d); do
	dn=$(basename ${d})
	[ "${dn}" != "." ] && {
		for f in $(find ${TARBALLS} -maxdepth 1 -type f -name "${dn}*"); do
			fn=$(basename ${f})
			grep "${fn}" ${SRC}/${dn}/SHA512SUMS >& /dev/null || (
				echo "${CHKSUM} $fn" &&
				cd ${TARBALLS} &&
				${CHKSUM} ${fn} > ${SRC}/${dn}/SHA512SUMS
			) && echo "skip ${fn}"
		done
	}
done
