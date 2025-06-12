#!/bin/bash
# Verify TddHelper project structure

echo "Verifying TddHelper project structure..."
echo

missing_files=0
missing_dirs=0
missing_source=0
missing_docs=0

check_file() {
    if [ ! -f "$1" ]; then
        echo "[MISSING] $1"
        eval "$2=$(( $2 + 1 ))"
    else
        echo "[OK] $1"
    fi
}

check_dir() {
    if [ ! -d "$1" ]; then
        echo "[MISSING] $1"
        eval "$2=$(( $2 + 1 ))"
    else
        echo "[OK] $1"
    fi
}

echo "Checking core project files..."
check_file "build.gradle.kts" missing_files
check_file "settings.gradle.kts" missing_files
check_file "gradlew.bat" missing_files
check_file "gradle/wrapper/gradle-wrapper.properties" missing_files

echo

echo "Checking source directories..."
check_dir "src/main/kotlin/com/danmarshall/tddhelper" missing_dirs
check_dir "src/main/kotlin/com/danmarshall/tddhelper/actions" missing_dirs
check_dir "src/main/kotlin/com/danmarshall/tddhelper/services" missing_dirs
check_dir "src/main/resources/META-INF" missing_dirs
check_dir "src/test/kotlin/com/danmarshall/tddhelper" missing_dirs

echo

echo "Checking key source files..."
check_file "src/main/resources/META-INF/plugin.xml" missing_source
check_file "src/main/kotlin/com/danmarshall/tddhelper/services/TestStatusChangeListener.kt" missing_source
check_file "src/main/kotlin/com/danmarshall/tddhelper/services/TestResultsTracker.kt" missing_source
check_file "src/main/kotlin/com/danmarshall/tddhelper/services/UIDecorator.kt" missing_source
check_file "src/main/kotlin/com/danmarshall/tddhelper/actions/GotoNextFailedTestAction.kt" missing_source

echo

echo "Checking documentation files..."
check_file "README.md" missing_docs
check_file "LICENSE" missing_docs
check_file "CONTRIBUTING.md" missing_docs
if [ ! -d "memory-bank" ]; then
    echo "[MISSING] memory-bank directory"
    missing_docs=$((missing_docs+1))
else
    echo "[OK] memory-bank directory"
fi

echo

total_missing=$((missing_files + missing_dirs + missing_source + missing_docs))

echo "Verification Summary:"
echo "---------------------"
if [ "$total_missing" -eq 0 ]; then
    echo "All files and directories are present! Project structure is correct."
else
    echo "Missing $total_missing files or directories."
    echo "Please run the setup scripts to create the missing files."
fi

echo

echo "Verification complete!"

