#!/bin/sh
set -e
# Save binary includes before cleaning
echo "Backing up theme files before cleaning..."
mkdir -p .theme_backup
cp -r config/includes.binary .theme_backup/ 2>/dev/null || true

# Clean the build environment
lb clean noauto "${@}"

# Restore only configuration files we want to keep
rm -f config/binary config/bootstrap config/chroot config/common config/source
rm -f build.log

# Restore theme files
echo "Restoring theme files after cleaning..."
mkdir -p config/includes.binary
cp -r .theme_backup/includes.binary/* config/includes.binary/ 2>/dev/null || true
