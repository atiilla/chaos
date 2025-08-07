#!/bin/bash
# Test script to check the ISO and validate its bootability

ISO_FILE="live-image-amd64.hybrid.iso"

echo "=== ChaOS ISO Test Script ==="

# Check if ISO exists
if [ ! -f "$ISO_FILE" ]; then
    echo "ERROR: ISO file not found. Build may have failed."
    exit 1
fi

echo "ISO file found: $ISO_FILE"
echo "Size: $(du -h "$ISO_FILE" | cut -f1)"

# List contents of the ISO
echo -e "\n=== ISO Contents ==="
isoinfo -l -i "$ISO_FILE" | head -20
echo "... (truncated) ..."

# Check for boot files
echo -e "\n=== Boot File Check ==="
echo "Checking for GRUB boot files..."
isoinfo -l -i "$ISO_FILE" | grep -i "grub" | head -10

echo "Checking for isolinux boot files..."
isoinfo -l -i "$ISO_FILE" | grep -i "isolinux" | head -10

echo -e "\n=== Boot Method Detection ==="
echo "BIOS boot capability: $(isoinfo -d -i "$ISO_FILE" | grep "El Torito" || echo "Not found")"
echo "EFI boot capability: $(isoinfo -l -i "$ISO_FILE" | grep -i "/efi/boot/" || echo "Not found")"

echo -e "\n=== Test Complete ==="
echo "ISO appears to be $([ "$(isoinfo -l -i "$ISO_FILE" | grep -i "/efi/boot/")" ] && [ "$(isoinfo -d -i "$ISO_FILE" | grep "El Torito")" ] && echo "properly bootable with both BIOS and EFI support" || echo "missing some boot components")"
echo "You can now test it in VMware or other virtualization software"
