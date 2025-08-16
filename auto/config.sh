#!/bin/sh
set -e
lb config noauto \
 --mode debian \
 --distribution bookworm \
 --architectures amd64 \
 --debian-installer none \
 --bootloaders grub-pc grub-efi \
 --bootappend-live "boot=live components quiet splash" \
 --archive-areas "main contrib non-free non-free-firmware" \
 --memtest none \
 "${@}"
