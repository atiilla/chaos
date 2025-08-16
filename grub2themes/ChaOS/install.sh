#!/bin/bash

# ChaOS GRUB Theme Installation Script
# This script installs the ChaOS GRUB theme

set -e

THEME_DIR="/boot/grub/themes/ChaOS"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BRANDING_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")/branding_assets"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   print_error "This script must be run as root (use sudo)"
   exit 1
fi

print_status "Installing ChaOS GRUB theme..."

# Create theme directory
print_status "Creating theme directory: $THEME_DIR"
mkdir -p "$THEME_DIR"

# Copy theme files
print_status "Copying theme files..."
cp "$SCRIPT_DIR/theme.txt" "$THEME_DIR/"

# Copy background from branding assets
if [ -f "$BRANDING_DIR/grub_background.png" ]; then
    cp "$BRANDING_DIR/grub_background.png" "$THEME_DIR/"
    print_status "Copied GRUB background from branding assets"
elif [ -f "$SCRIPT_DIR/background.png" ]; then
    cp "$SCRIPT_DIR/background.png" "$THEME_DIR/grub_background.png"
    print_warning "Using fallback background image"
else
    print_error "No background image found!"
    exit 1
fi

# Set proper permissions
chmod 644 "$THEME_DIR"/*
chmod 755 "$THEME_DIR"

# Backup existing GRUB configuration
if [ -f /etc/default/grub ]; then
    print_status "Backing up existing GRUB configuration..."
    cp /etc/default/grub /etc/default/grub.backup.$(date +%Y%m%d-%H%M%S)
fi

# Update GRUB configuration
print_status "Updating GRUB configuration..."

# Remove existing GRUB_THEME line if it exists
sed -i '/^GRUB_THEME=/d' /etc/default/grub

# Add ChaOS theme
echo "GRUB_THEME=\"$THEME_DIR/theme.txt\"" >> /etc/default/grub

# Ensure other necessary GRUB settings
# Remove existing GRUB_GFXMODE line if it exists
sed -i '/^GRUB_GFXMODE=/d' /etc/default/grub
# Add new GRUB_GFXMODE with multiple resolution support
echo "GRUB_GFXMODE=1920x1080,1680x1050,1600x1200,1440x900,1366x768,1280x1024,1024x768,800x600,auto" >> /etc/default/grub

# Remove existing GRUB_GFXPAYLOAD_LINUX line if it exists  
sed -i '/^GRUB_GFXPAYLOAD_LINUX=/d' /etc/default/grub
echo "GRUB_GFXPAYLOAD_LINUX=keep" >> /etc/default/grub

# Ensure terminal output is disabled to show graphics properly
sed -i '/^GRUB_TERMINAL=/d' /etc/default/grub
echo "#GRUB_TERMINAL=console" >> /etc/default/grub

# Update GRUB
print_status "Updating GRUB bootloader..."
if command -v update-grub >/dev/null 2>&1; then
    update-grub
elif command -v grub-mkconfig >/dev/null 2>&1; then
    grub-mkconfig -o /boot/grub/grub.cfg
else
    print_error "Could not find update-grub or grub-mkconfig command"
    exit 1
fi

print_success "ChaOS GRUB theme installed successfully!"
print_status "Theme location: $THEME_DIR"
print_status "Reboot to see the new theme in action."
