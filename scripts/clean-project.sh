#!/bin/bash
# Clean up TddHelper project

echo "TddHelper Project Cleanup"
echo "========================="
echo

echo "This script will remove all generated files and directories."
echo "Your source code and configuration files will remain intact."
echo

read -rp "Press Enter to continue or Ctrl+C to cancel..."

echo

echo "Cleaning up build artifacts..."

# Change to project root directory
cd "$(dirname "$0")/.." || exit 1

if [ -d "build" ]; then
    rm -rf build
    echo "[REMOVED] build directory"
else
    echo "[SKIPPED] build directory (not found)"
fi

if [ -d ".gradle" ]; then
    rm -rf .gradle
    echo "[REMOVED] .gradle directory"
else
    echo "[SKIPPED] .gradle directory (not found)"
fi

if [ -d ".idea" ]; then
    rm -rf .idea
    echo "[REMOVED] .idea directory"
else
    echo "[SKIPPED] .idea directory (not found)"
fi

if [ -d ".intellijPlatform" ]; then
    rm -rf .intellijPlatform
    echo "[REMOVED] .intellijPlatform directory"
else
    echo "[SKIPPED] .intellijPlatform directory (not found)"
fi

echo

echo "Cleanup complete!"
echo

echo "To rebuild the project:"
echo "1. Run ./gradlew buildPlugin"
