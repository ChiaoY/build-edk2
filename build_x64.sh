#!/bin/bash
set -x

export WORKSPACE=$PWD/edk2
export PACKAGES_PATH="${WORKSPACE}"
export EDK_TOOLS_PATH="${WORKSPACE}"/BaseTools

ARCH=X64
TOOLCHAIN=GCC5
DATE=$(shell date "+%Y-%m-%d")
TARGET=DEBUG
DEBUG=1

DSC_FILE=OvmfPkg/OvmfPkgX64.dsc
# List for DSC files
#  OvmfPkg/OvmfPkgX64.dsc

# init submodule
cd "${WORKSPACE}"
git submodule update --init

# Build BaseTools
cd "${PACKAGES_PATH}"
make -C "${EDK_TOOLS_PATH}"

# Run edksetup to generate Conf/target.txt
. "${WORKSPACE}"/edksetup.sh

# Build BIOS
build -a ${ARCH} -t ${TOOLCHAIN} -p ${DSC_FILE} \
		-b ${TARGET}  -D RELEASE_DATE="${DATE}" -D DEBUG=${DEBUG} -D ADD_SHELL_STRING -y Build/report.log