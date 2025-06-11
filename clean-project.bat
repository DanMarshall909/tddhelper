@echo off
REM Clean up TddHelper project

echo TddHelper Project Cleanup
echo ========================
echo.
echo This script will remove all generated files and directories.
echo Your source code and configuration files will remain intact.
echo.
echo Press any key to continue or Ctrl+C to cancel...
pause > nul

echo.
echo Cleaning up build artifacts...
if exist "build" (
    rmdir /s /q build
    echo [REMOVED] build directory
) else (
    echo [SKIPPED] build directory (not found)
)

if exist ".gradle" (
    rmdir /s /q .gradle
    echo [REMOVED] .gradle directory
) else (
    echo [SKIPPED] .gradle directory (not found)
)

if exist ".idea" (
    rmdir /s /q .idea
    echo [REMOVED] .idea directory
) else (
    echo [SKIPPED] .idea directory (not found)
)

echo.
echo Cleanup complete!
echo.
echo To rebuild the project:
echo 1. Run .\gradlew buildPlugin
echo.
