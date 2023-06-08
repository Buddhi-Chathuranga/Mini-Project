@echo off

if "%1"=="?" goto :args
if "%1"=="/?" goto :args
if "%1"=="--help" goto :args
if "%1"=="/help" goto :args

set LIB=../../mx-database/install/upgrade/lib
set CLASSPATH=%LIB%/*

java -cp %CLASSPATH% com.mxi.mx.am.db.installer.Main -v %*

goto :end

:args
echo.
echo.
echo Usage: mtx-db-upgrade.cmd "-f <logFilePath>" "-b <bundlePath>" "-c <dbHost>" "-p <dbPort>" "-S <dbService>" "-u <userName>" "-P <passWord>"
echo.
echo       logFilePath    Path to log file
echo       bundlePath     Path to bundle folder containing liquibase upgrade files
echo       dbHost         Database hostname
echo       dbPort         Database port
echo       dbService      Database service
echo       userName       Database schema username
echo       passWord       Username password
echo.
set errorlevel=1

:end
