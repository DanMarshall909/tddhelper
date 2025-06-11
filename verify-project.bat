@echo off
REM Verify TddHelper project structure

echo Verifying TddHelper project structure...
echo.

REM Check core project files
echo Checking core project files...
set MISSING_FILES=0

if not exist "build.gradle.kts" (
    echo [MISSING] build.gradle.kts
    set /a MISSING_FILES+=1
) else (
    echo [OK] build.gradle.kts
)

if not exist "settings.gradle.kts" (
    echo [MISSING] settings.gradle.kts
    set /a MISSING_FILES+=1
) else (
    echo [OK] settings.gradle.kts
)

if not exist "gradlew.bat" (
    echo [MISSING] gradlew.bat
    set /a MISSING_FILES+=1
) else (
    echo [OK] gradlew.bat
)

if not exist "gradle\wrapper\gradle-wrapper.properties" (
    echo [MISSING] gradle\wrapper\gradle-wrapper.properties
    set /a MISSING_FILES+=1
) else (
    echo [OK] gradle\wrapper\gradle-wrapper.properties
)

echo.

REM Check source directories
echo Checking source directories...
set MISSING_DIRS=0

if not exist "src\main\kotlin\com\danmarshall\tddhelper" (
    echo [MISSING] src\main\kotlin\com\danmarshall\tddhelper
    set /a MISSING_DIRS+=1
) else (
    echo [OK] src\main\kotlin\com\danmarshall\tddhelper
)

if not exist "src\main\kotlin\com\danmarshall\tddhelper\actions" (
    echo [MISSING] src\main\kotlin\com\danmarshall\tddhelper\actions
    set /a MISSING_DIRS+=1
) else (
    echo [OK] src\main\kotlin\com\danmarshall\tddhelper\actions
)

if not exist "src\main\kotlin\com\danmarshall\tddhelper\services" (
    echo [MISSING] src\main\kotlin\com\danmarshall\tddhelper\services
    set /a MISSING_DIRS+=1
) else (
    echo [OK] src\main\kotlin\com\danmarshall\tddhelper\services
)

if not exist "src\main\resources\META-INF" (
    echo [MISSING] src\main\resources\META-INF
    set /a MISSING_DIRS+=1
) else (
    echo [OK] src\main\resources\META-INF
)

if not exist "src\test\kotlin\com\danmarshall\tddhelper" (
    echo [MISSING] src\test\kotlin\com\danmarshall\tddhelper
    set /a MISSING_DIRS+=1
) else (
    echo [OK] src\test\kotlin\com\danmarshall\tddhelper
)

echo.

REM Check key source files
echo Checking key source files...
set MISSING_SOURCE=0

if not exist "src\main\resources\META-INF\plugin.xml" (
    echo [MISSING] src\main\resources\META-INF\plugin.xml
    set /a MISSING_SOURCE+=1
) else (
    echo [OK] src\main\resources\META-INF\plugin.xml
)

if not exist "src\main\kotlin\com\danmarshall\tddhelper\services\TestStatusChangeListener.kt" (
    echo [MISSING] src\main\kotlin\com\danmarshall\tddhelper\services\TestStatusChangeListener.kt
    set /a MISSING_SOURCE+=1
) else (
    echo [OK] src\main\kotlin\com\danmarshall\tddhelper\services\TestStatusChangeListener.kt
)

if not exist "src\main\kotlin\com\danmarshall\tddhelper\services\TestResultsTracker.kt" (
    echo [MISSING] src\main\kotlin\com\danmarshall\tddhelper\services\TestResultsTracker.kt
    set /a MISSING_SOURCE+=1
) else (
    echo [OK] src\main\kotlin\com\danmarshall\tddhelper\services\TestResultsTracker.kt
)

if not exist "src\main\kotlin\com\danmarshall\tddhelper\services\UIDecorator.kt" (
    echo [MISSING] src\main\kotlin\com\danmarshall\tddhelper\services\UIDecorator.kt
    set /a MISSING_SOURCE+=1
) else (
    echo [OK] src\main\kotlin\com\danmarshall\tddhelper\services\UIDecorator.kt
)

if not exist "src\main\kotlin\com\danmarshall\tddhelper\actions\GotoNextFailedTestAction.kt" (
    echo [MISSING] src\main\kotlin\com\danmarshall\tddhelper\actions\GotoNextFailedTestAction.kt
    set /a MISSING_SOURCE+=1
) else (
    echo [OK] src\main\kotlin\com\danmarshall\tddhelper\actions\GotoNextFailedTestAction.kt
)

echo.

REM Check documentation files
echo Checking documentation files...
set MISSING_DOCS=0

if not exist "README.md" (
    echo [MISSING] README.md
    set /a MISSING_DOCS+=1
) else (
    echo [OK] README.md
)

if not exist "LICENSE" (
    echo [MISSING] LICENSE
    set /a MISSING_DOCS+=1
) else (
    echo [OK] LICENSE
)

if not exist "CONTRIBUTING.md" (
    echo [MISSING] CONTRIBUTING.md
    set /a MISSING_DOCS+=1
) else (
    echo [OK] CONTRIBUTING.md
)

if not exist "memory-bank" (
    echo [MISSING] memory-bank directory
    set /a MISSING_DOCS+=1
) else (
    echo [OK] memory-bank directory
)

echo.

REM Summary
echo Verification Summary:
echo ---------------------
set /a TOTAL_MISSING=%MISSING_FILES%+%MISSING_DIRS%+%MISSING_SOURCE%+%MISSING_DOCS%
if %TOTAL_MISSING% EQU 0 (
    echo All files and directories are present! Project structure is correct.
) else (
    echo Missing %TOTAL_MISSING% files or directories.
    echo Please run the setup scripts to create the missing files.
)

echo.
echo Verification complete!
