#!/bin/bash
set -e

echo "=== ChaOS Build Process ==="
echo "1. Cleaning the workspace..."
./scripts/clean.sh

echo "2. Configuring the build environment..."
./scripts/config.sh

echo "3. Fixing theme files..."
./scripts/fix-background.sh

echo "4. Building the ISO..."
./scripts/build.sh

echo "Build process complete!"
