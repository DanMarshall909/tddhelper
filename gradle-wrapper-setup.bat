@echo off
REM Create Gradle Wrapper files

echo Creating Gradle Wrapper...

REM Create gradle/wrapper directory
mkdir gradle\wrapper

REM Create gradle-wrapper.properties
echo distributionBase=GRADLE_USER_HOME > gradle\wrapper\gradle-wrapper.properties
echo distributionPath=wrapper/dists >> gradle\wrapper\gradle-wrapper.properties
echo distributionUrl=https\://services.gradle.org/distributions/gradle-8.1.1-bin.zip >> gradle\wrapper\gradle-wrapper.properties
echo zipStoreBase=GRADLE_USER_HOME >> gradle\wrapper\gradle-wrapper.properties
echo zipStorePath=wrapper/dists >> gradle\wrapper\gradle-wrapper.properties

REM Create gradlew.bat
echo @rem >> gradlew.bat
echo @rem Copyright 2015 the original author or authors. >> gradlew.bat
echo @rem >> gradlew.bat
echo @rem Licensed under the Apache License, Version 2.0 (the "License"); >> gradlew.bat
echo @rem you may not use this file except in compliance with the License. >> gradlew.bat
echo @rem You may obtain a copy of the License at >> gradlew.bat
echo @rem >> gradlew.bat
echo @rem      https://www.apache.org/licenses/LICENSE-2.0 >> gradlew.bat
echo @rem >> gradlew.bat
echo @rem Unless required by applicable law or agreed to in writing, software >> gradlew.bat
echo @rem distributed under the License is distributed on an "AS IS" BASIS, >> gradlew.bat
echo @rem WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. >> gradlew.bat
echo @rem See the License for the specific language governing permissions and >> gradlew.bat
echo @rem limitations under the License. >> gradlew.bat
echo @rem >> gradlew.bat
echo. >> gradlew.bat
echo @if "%%DEBUG%%" == "" @echo off >> gradlew.bat
echo @rem ##########################################################################  >> gradlew.bat
echo @rem >> gradlew.bat
echo @rem  Gradle startup script for Windows >> gradlew.bat
echo @rem >> gradlew.bat
echo @rem ##########################################################################  >> gradlew.bat
echo. >> gradlew.bat
echo @rem Set local scope for the variables with windows NT shell >> gradlew.bat
echo if "%%OS%%"=="Windows_NT" setlocal >> gradlew.bat
echo. >> gradlew.bat
echo set DIRNAME=%%~dp0 >> gradlew.bat
echo if "%%DIRNAME%%" == "" set DIRNAME=. >> gradlew.bat
echo set APP_BASE_NAME=%%~n0 >> gradlew.bat
echo set APP_HOME=%%DIRNAME%% >> gradlew.bat
echo. >> gradlew.bat
echo @rem Resolve any "." and ".." in APP_HOME to make it shorter. >> gradlew.bat
echo for %%%%i in ("%%APP_HOME%%") do set APP_HOME=%%%%~fi >> gradlew.bat
echo. >> gradlew.bat
echo @rem Add default JVM options here. You can also use JAVA_OPTS and GRADLE_OPTS to pass JVM options to this script. >> gradlew.bat
echo set DEFAULT_JVM_OPTS="-Xmx64m" "-Xms64m" >> gradlew.bat
echo. >> gradlew.bat
echo @rem Find java.exe >> gradlew.bat
echo if defined JAVA_HOME goto findJavaFromJavaHome >> gradlew.bat
echo. >> gradlew.bat
echo set JAVA_EXE=java.exe >> gradlew.bat
echo %JAVA_EXE% -version >NUL 2>&1 >> gradlew.bat
echo if "%%ERRORLEVEL%%" == "0" goto execute >> gradlew.bat
echo. >> gradlew.bat
echo echo. >> gradlew.bat
echo echo ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH. >> gradlew.bat
echo echo. >> gradlew.bat
echo echo Please set the JAVA_HOME variable in your environment to match the >> gradlew.bat
echo echo location of your Java installation. >> gradlew.bat
echo. >> gradlew.bat
echo goto fail >> gradlew.bat
echo. >> gradlew.bat
echo :findJavaFromJavaHome >> gradlew.bat
echo set JAVA_HOME=%%JAVA_HOME:"=%% >> gradlew.bat
echo set JAVA_EXE=%%JAVA_HOME%%/bin/java.exe >> gradlew.bat
echo. >> gradlew.bat
echo if exist "%%JAVA_EXE%%" goto execute >> gradlew.bat
echo. >> gradlew.bat
echo echo. >> gradlew.bat
echo echo ERROR: JAVA_HOME is set to an invalid directory: %%JAVA_HOME%% >> gradlew.bat
echo echo. >> gradlew.bat
echo echo Please set the JAVA_HOME variable in your environment to match the >> gradlew.bat
echo echo location of your Java installation. >> gradlew.bat
echo. >> gradlew.bat
echo goto fail >> gradlew.bat
echo. >> gradlew.bat
echo :execute >> gradlew.bat
echo @rem Setup the command line >> gradlew.bat
echo. >> gradlew.bat
echo set CLASSPATH=%%APP_HOME%%\gradle\wrapper\gradle-wrapper.jar >> gradlew.bat
echo. >> gradlew.bat
echo @rem Execute Gradle >> gradlew.bat
echo "%%JAVA_EXE%%" %%DEFAULT_JVM_OPTS%% %%JAVA_OPTS%% %%GRADLE_OPTS%% "-Dorg.gradle.appname=%%APP_BASE_NAME%%" -classpath "%%CLASSPATH%%" org.gradle.wrapper.GradleWrapperMain %%* >> gradlew.bat
echo. >> gradlew.bat
echo :fail >> gradlew.bat
echo rem Set variable GRADLE_EXIT_CONSOLE if you need the _script_ return code instead of >> gradlew.bat
echo rem the _cmd.exe /c_ return code! >> gradlew.bat
echo if not "" == "%%GRADLE_EXIT_CONSOLE%%" exit 1 >> gradlew.bat
echo exit /b 1 >> gradlew.bat
echo. >> gradlew.bat
echo :mainEnd >> gradlew.bat
echo if "%%OS%%"=="Windows_NT" endlocal >> gradlew.bat
echo. >> gradlew.bat
echo :omega >> gradlew.bat

echo Gradle Wrapper setup completed successfully!
