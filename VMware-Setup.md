# VMware Configuration Guide for ChaOS

This guide will help you properly configure VMware to boot your ChaOS ISO.

## Creating a New VM

1. Open VMware and select "Create a New Virtual Machine"
2. Choose "Custom (advanced)" and click "Next"
3. Select hardware compatibility (latest is recommended) and click "Next"
4. Select "I will install the operating system later" and click "Next"
5. For Guest OS, select "Linux" and "Debian 11.x 64-bit" from the dropdown menus
6. Name your VM "ChaOS" and choose a location to store it
7. Configure with:
   - 2+ CPU cores
   - 4+ GB RAM
   - Network: NAT
   - I/O Controller: LSI Logic
   - Disk Type: SCSI
   - Create a new virtual disk (at least 20GB)
   
## Critical Boot Configuration

After creating the VM, before starting it, modify these settings:

1. Right-click the VM and select "Settings"
2. Go to the "Options" tab, then "Advanced" → "Boot Options"
3. **IMPORTANT**: Make sure "Firmware type" is set to "BIOS" (not UEFI) for initial testing
4. Set the boot delay to 5000ms (5 seconds) to give you time to access boot options
5. Go to the "Hardware" tab and select "CD/DVD"
6. Select "Use ISO image file" and browse to your ChaOS ISO
7. Ensure "Connect at power on" is checked

## Testing Both Boot Methods

To test BIOS boot (legacy):
- Use the settings above with "BIOS" firmware type
- Start the VM - it should boot directly from the ISO

To test EFI boot (after confirming BIOS boot works):
- Shut down the VM
- Change "Firmware type" to "UEFI"
- Start the VM again

## Troubleshooting

If you see the PXE/Network boot screen:
1. Verify the ISO is properly connected
2. Press ESC when VMware starts to enter the boot menu
3. Manually select the CD-ROM to boot

If neither BIOS nor EFI boot methods work:
1. Check the ISO with the test-iso.sh script
2. Review build.log for errors
3. Try regenerating the ISO with ./scripts/clean.sh and ./scripts/build.sh
