#!/bin/sh
set -e
lb config noauto \
 --mode debian \
 --architectures amd64 \
 --debian-installer none \
 --archive-areas "main contrib non-free non-free-firmware" \
 --memtest none \
 --bootappend-live "boot=live components quiet splash" \
 --distribution bookworm \
 --bootloader "grub-efi,syslinux" \
 --bootloaders "grub-efi,syslinux" \
 --firmware-binary true \
 --firmware-chroot true \
 "${@}"
