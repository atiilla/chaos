#!/bin/bash
# Script to verify theme files in the ISO

ISO_FILE="live-image-amd64.hybrid.iso"
echo "=== ChaOS Theme Verification ==="

# Check if ISO exists
if [ ! -f "$ISO_FILE" ]; then
    echo "ERROR: ISO file not found. Build may have failed."
    exit 1
fi

echo "Checking ISOLINUX theme files..."
isoinfo -J -i "$ISO_FILE" -x "/isolinux/splash.png" > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✓ ISOLINUX splash.png found"
else
    echo "✗ ISOLINUX splash.png missing"
fi

echo "Checking GRUB theme files..."
isoinfo -J -i "$ISO_FILE" -x "/boot/grub/themes/chaos/theme.txt" > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✓ GRUB theme.txt found"
else
    echo "✗ GRUB theme.txt missing"
fi

isoinfo -J -i "$ISO_FILE" -x "/boot/grub/themes/chaos/background.png" > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✓ GRUB background.png found"
else
    echo "✗ GRUB background.png missing"
fi

echo -e "\nISO Theme Files Summary:"
isoinfo -J -i "$ISO_FILE" | grep -i "isolinux/.*\.png" || echo "No ISOLINUX PNG files found"
isoinfo -J -i "$ISO_FILE" | grep -i "grub/themes" || echo "No GRUB theme files found"
