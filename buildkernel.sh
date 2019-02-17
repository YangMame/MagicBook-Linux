#!/bin/bash

# Just for my own use

KERNEL_VERSION="$(readlink /usr/src/linux | grep -o '[0-9].*')"
KERNEL_DIR="/usr/src/linux-${KERNEL_VERSION}"
KERNEL_CMDLINE="dolvm crypt_root=/dev/nvme0n1p2 resume=/dev/mapper/system-swap root=/dev/mapper/system-root root_trim=yes rw quite loglevel=0 iommu=off amd_iommu=off idle=nomwait acpi_backlight=vendor amdgpu.dc=1"
KERNEL="kernel-genkernel-x86_64-${KERNEL_VERSION}"
INITRAMFS="initramfs-genkernel-x86_64-${KERNEL_VERSION}"
KERNEL_CONFIG="/etc/kernels/config"

BOOTCTL_CONF="/boot/loader/entries/gentoo.conf"

build(){
    cd "${KERNEL_DIR}"
    cp -v "${KERNEL_CONFIG}" .config
    make oldconfig
    cp -v .config /etc/kernels/kernel-config-x86_64-${KERNEL_VERSION}
    cp -v .config /etc/kernels/config
    genkernel all
}

update(){
    cat << EOF > ${BOOTCTL_CONF}
title   Gentoo Linux
linux   /${KERNEL}
initrd  /${INITRAMFS}
options ${KERNEL_CMDLINE}
EOF
}

main(){
    build
    update
}

main
