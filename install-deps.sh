#!/bin/bash
# install-deps.sh - Install dependencies for building ChaOS

echo "Installing required packages for building ChaOS..."
sudo apt update
sudo apt install -y live-build squashfs-tools live-boot live-config xorriso isolinux netselect-apt

echo "Dependencies installed successfully!"
echo "You can now build ChaOS using the following commands:"
echo "./scripts/clean.sh"
echo "./scripts/config.sh"
echo "./scripts/build.sh"
