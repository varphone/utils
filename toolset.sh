#!/bin/bash

echo "================ 编译工具链初始化脚本, v2.0 =================="
echo "Bug report: Varphone Wong [varphone@gmail.com]"
echo "=============================================================="
echo ""

echo "$0" | grep "toolset.sh" > /dev/null && {
    echo "出错: toolset.sh 必须通过 'source' 或 '.' 来调用方可工作"
    exit 1
}

# Global settings
[ -z "${WORKSPACE_ROOT}" ] && WORKSPACE_ROOT=${HOME}/workspace

[ -z "${TARGET_ROOT}" ] && TARGET_ROOT=${WORKSPACE_ROOT}/target
[ -z "${TOOLCHAIN_ROOT}" ] && TOOLCHAIN_ROOT=${WORKSPACE_ROOT}/toolchain

# Save original PATH
if [ "${_ORIGNAL_PATH_-null}" = "null" ]; then
    export _ORIGNAL_PATH_=${PATH}
fi

# Save original LD_LIBRARY_PATH
if [ "${_ORIGNAL_LD_LIBRARY_PATH_-null}" = "null" ]; then
    export _ORIGNAL_LD_LIBRARY_PATH_=${LD_LIBRARY_PATH}
fi

tsel=${1}
tidx=0

show_menu() {
    echo "所支持的工具链:"
    echo ""
    for f in $(find ${TOOLCHAIN_ROOT}/*/ -maxdepth 2 -type f -name "toolchain.env")
    do
        source ${f}
        sha1=$(sha1sum ${f}|cut -d' ' -f1)
        tprefix=toolchain_${sha1:0:8}
        export ${tprefix}=${f}
        export toolchain_idx_${tidx}=${tprefix}
        printf " %4s ) %-40s v%s\n" ${tidx} ${TOOLSET_NAME} ${TOOLSET_VERSION}
        [ -n "${TOOLSET_NOTES}" ] && echo "        (${TOOLSET_NOTES})"
        tidx=$((${tidx}+1))
    done
    echo ""
    [ -z "${tsel}" ] && read -p "请输入你要使用工具链编号: " tsel
    echo ""
    cv_key=toolchain_idx_${tsel}
    [ -z "${!cv_key}" ] && {
        echo "你输入了一个不存在的编号: ${tsel}"
    } || {
        echo "你选择使用的工具链编号为: ${tsel}"
        echo ""
        export_env
    }
}

export_env() {
    cv_idx=toolchain_idx_${tsel}
    cv_uid=${!cv_idx}
    cv_env=${!cv_uid}
    source ${cv_env}

    export TOOLSET_NAME=${TOOLSET_NAME}
    export TOOLSET_ROOT=$(dirname ${cv_env})
    export TOOLSET_VERSION=${TOOLSET_VERSION}
    export CROSS_COMPILER_NAME=${CROSS_COMPILER_NAME}
    export CROSS_COMPILER_PREFIX=${CROSS_COMPILER_PREFIX:=${CROSS_COMPILER_NAME}-}
    export CROSS_STAGE_DIR=${CROSS_STAGE_DIR:=${TARGET_ROOT}/${TOOLSET_NAME}}
    export INSTALL_PREFIX=${INSTALL_PREFIX:=${TARGET_ROOT}/${TOOLSET_NAME}/usr}
    ORIG_IFS=${IFS}
    IFS=','
    cv_path=
    for d in ${EXECUTABLE_DIRS}; do
        cv_path=${cv_path}${TOOLSET_ROOT}/${d}:
    done
    export PATH=${cv_path}${_ORIGNAL_PATH_}:
    cv_pah=
    for d in ${LD_LIBRARY_DIRS}; do
        cv_path=${cv_path}${TOOLSET_ROOT}/${d}:
    done
    export LD_LIBRARY_PATH=${cv_path}${_ORIGNAL_LD_LIBRARY_PATH_}
    IFS=${ORIG_IFS}

    echo "===================== 设定后的环境变量 ======================="
    echo " PATH                  : ${PATH}"
    echo " TOOLSET_NAME          : ${TOOLSET_NAME}"
    echo " TOOLSET_ROOT          : ${TOOLSET_ROOT}"
    echo " TOOLSET_VERSION       : ${TOOLSET_VERSION}"
    echo " CROSS_COMPILER_NAME   : ${CROSS_COMPILER_NAME}"
    echo " CROSS_COMPILER_PREFIX : ${CROSS_COMPILER_PREFIX}"
    echo " CROSS_STAGE_DIR       : ${CROSS_STAGE_DIR}"
    echo " INSTALL_PREFIX        : ${INSTALL_PREFIX}"
    echo " LD_LIBRARY_PATH       : ${LD_LIBRARY_PATH}"
    echo "=============================================================="
}

show_menu
