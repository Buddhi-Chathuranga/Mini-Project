@echo off
pushd "%~dp0"
set PKG=--java
echo %* | findstr /C:"action=" >nul 2>nul
IF %ERRORLEVEL% NEQ 0 set PKG=%PKG% --kubectl --helm
echo %* | findstr /C:"action=mtinstaller" /C:"action=delete" >nul 2>nul
IF %ERRORLEVEL% EQU 0 set PKG=%PKG% --kubectl --helm
CALL utils\verify_required_software.cmd %PKG%
IF %ERRORLEVEL% NEQ 0 EXIT /B 1
java -cp .;lib/ifsinstaller.jar;lib/snakeyaml-1.26.jar;lib/ojdbc.jar ifs.installer.Installer --values version.yaml %*
popd
