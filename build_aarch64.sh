#!/bin/bash

# Ref: https://cloud-atlas.readthedocs.io/zh-cn/latest/kvm/arm_kvm/build_qemu_ovmf.html

set -x

export WORKSPACE=$PWD/edk2
export PACKAGES_PATH="${WORKSPACE}"
export EDK_TOOLS_PATH="${WORKSPACE}"/BaseTools

ARCH=AARCH64
TOOLCHAIN=GCC5
export CROSS_COMPILE=aarch64-linux-gnu-
export ${TOOLCHAIN}"_"${ARCH}"_PREFIX="${CROSS_COMPILE}
DATE=$(shell date "+%Y-%m-%d")
TARGET=DEBUG
DEBUG=1

DSC_FILE=ArmVirtPkg/ArmVirtQemu.dsc
# List for DSC files
#  ArmVirtPkg/ArmVirtQemu.dsc

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
		-b ${TARGET}  -D RELEASE_DATE="${DATE}" -D DEBUG=${DEBUG} -y Build/report.log
# build -a ${ARCH} -t ${TOOLCHAIN} -p ${DSC_FILE} \
# 		-b ${TARGET}  -D RELEASE_DATE="${DATE}" -D DEBUG=${DEBUG} -y Build/report.log
cd -

cd "${WORKSPACE}"/Build/ArmVirtQemu-AARCH64/DEBUG_GCC5/FV
dd of="QEMU_EFI-pflash.raw" if="/dev/zero" bs=1M count=64
dd of="QEMU_EFI-pflash.raw" if="QEMU_EFI.fd" conv=notrunc
dd of="QEMU_VARS-pflash.raw" if="/dev/zero" bs=1M count=64
dd of="QEMU_VARS-pflash.raw" if="QEMU_VARS.fd" conv=notrunc
cd -