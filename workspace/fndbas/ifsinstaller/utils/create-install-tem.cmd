@echo off
pushd %~dp0
setlocal

if "%1"=="?" goto :args
if "%1"=="/?" goto :args
if "%1"=="--help" goto :args
if "%1"=="/help" goto :args

set LIB=../lib
set CLASSPATH=%LIB%/ifs-fnd-dbbuild.jar;%LIB%/ojdbc.jar;%LIB%/snakeyaml-1.26.jar

java -cp %CLASSPATH% -Duser.language=en -Duser.country=US ifs.fnd.dbbuild.CreateInstallTem type=installtem %*
goto :end

:args
echo.
echo.
echo Usage: create-install-tem.cmd deliveryPath="<path>" buildHomePath="<path>" [userName="<user>"] [password="<pwd>"] [connectString="<jdbcurl>"]
echo.
echo       deliveryPath             Path to DELIVERY (can be same as BUILD_HOME)
echo       buildHomePath            Path to BUILD_HOME
echo       userName (optional)      User name for application owner (if not given, install.ini will not be updated according to database information)
echo       password (optional)      Password for applicaton owner (if not given, install.ini will not be updated according to database information)
echo       connectString (optional) Jdbc url (if not given, install.ini will not be updated according to database information)
echo.
set errorlevel=1

:end
endlocal
popd