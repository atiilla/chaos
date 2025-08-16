#!/bin/sh
set -e
# Full clean to remove caches, config, and build artifacts
lb clean --purge noauto || true