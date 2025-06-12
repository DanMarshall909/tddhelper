#!/bin/bash
# Master setup script for TddHelper Rider plugin

echo "TddHelper Rider Plugin Setup"
echo "==========================="
echo

echo "This script will set up the complete project structure for the TddHelper Rider plugin."
echo

read -rp "Press Enter to continue or Ctrl+C to cancel..."

echo

echo "Step 1: Creating directory structure..."
./setup-project.sh
echo

echo "Step 2: Creating Kotlin source files..."
./create-kotlin-files.bat
echo

echo "Step 3: Setting up Gradle wrapper..."
./gradle-wrapper-setup.bat
echo

echo "Step 4: Verifying project structure..."
./verify-project.sh
echo

echo "Setup complete!"
echo

echo "Next steps:"
echo "1. Open the project in IntelliJ IDEA"
echo "2. Build the plugin with: ./gradlew buildPlugin"
echo "3. Run the plugin in a development instance with: ./gradlew runIde"
echo

echo "For more information, see CONTRIBUTING.md"
echo

