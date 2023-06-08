@echo off
setlocal 
cd /d "%~dp0"

Title %~n0

set RESULT=0
set CURDIR=%CD%
set SCRIPT=%~n0
set JAVA_HOME=

cd /d ../..
set BUILD_HOME=%CD%

cd /d %CURDIR%
           
echo %DATE% %TIME% Start %SCRIPT% %*

:process_params
if not "%~1"=="" (
    if "%~1"=="-DELIVERY" (
        set DELIVERY=%~2
    )
    if "%~1"=="-BUILD_HOME" (
        set BUILD_HOME=%~2
    )
    if "%~1"=="-FORCE_TRANSLATIONS_DOWNLOAD" (
        set FORCE_TRANSLATIONS_DOWNLOAD=%~2
    )
    if "%~1"=="-IFS_COMPONENTS_LIST" (
        set JAR_ARGS=%JAR_ARGS% -DIFS_COMPONENTS_LIST=%~2
    )
    if "%~1"=="-IFS_LANGUAGES_LIST" (
        set JAR_ARGS=%JAR_ARGS% -DIFS_LANGUAGES_LIST=%~2
    )
    if "%~1"=="-IFS_TRANSLATION_VERSION" (
        set JAR_ARGS=%JAR_ARGS% -DIFS_TRANSLATION_VERSION=%~2
    )
    shift
    goto :process_params
)

if defined DELIVERY (
echo %DATE% %TIME% DELIVERY=%DELIVERY%
set DELIVERY=%DELIVERY:"=%
)

if not defined DELIVERY (
echo "DELIVERY path has to be defined" & PAUSE & exit
)

call ..\..\ifsinstaller\utils\verify_required_software.cmd --jdk
IF %ERRORLEVEL% NEQ 0 PAUSE & exit


:read_config_properties
cd %~dp0
IF NOT EXIST "%~dp0config.properties" echo config.properties cannot be found. & PAUSE & exit
goto :download_translations

:download_translations
if not defined FORCE_TRANSLATIONS_DOWNLOAD (
set FORCE_TRANSLATIONS_DOWNLOAD=N
)
java %JAR_ARGS% -jar translation-downloader.jar
exit

endlocal
