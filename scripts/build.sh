#!/bin/sh
set -e

# Display current configuration
echo "=== ChaOS Build Configuration ==="
cat config/binary
echo "=== End Configuration ==="

# Build with verbosity for troubleshooting
lb build noauto --verbose "${@}" 2>&1 | tee build.log

# Check if build was successful
if [ -f "live-image-amd64.hybrid.iso" ]; then
    echo "=== ChaOS ISO built successfully ==="
    echo "ISO file: live-image-amd64.hybrid.iso"
    ls -lh live-image-amd64.hybrid.iso
else
    echo "=== ERROR: ISO build failed ==="
    echo "Check build.log for details"
fi
