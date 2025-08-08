#!/bin/bash
# This script copies the background.svg file to the expected location for the theme installation hook

# Create directory if it doesn't exist
mkdir -p config/includes.chroot/usr/share/chaos-theme-files/

# Copy the background.svg file from chaos-theme to the chroot directory
cp ../chaos-theme/background.svg config/includes.chroot/usr/share/chaos-theme-files/

echo "Background file copied successfully!"
