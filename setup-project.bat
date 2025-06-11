@echo off
REM Create directory structure for TddHelper plugin

REM Create main package directories
mkdir src\main\kotlin\com\danmarshall\tddhelper
mkdir src\main\kotlin\com\danmarshall\tddhelper\actions
mkdir src\main\kotlin\com\danmarshall\tddhelper\services
mkdir src\main\kotlin\com\danmarshall\tddhelper\listeners
mkdir src\main\kotlin\com\danmarshall\tddhelper\util

REM Create resources directories
mkdir src\main\resources
mkdir src\main\resources\META-INF

REM Create test directories
mkdir src\test\kotlin\com\danmarshall\tddhelper

echo Directory structure created successfully!
