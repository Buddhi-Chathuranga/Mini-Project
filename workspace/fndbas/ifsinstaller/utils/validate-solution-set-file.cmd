@echo off
pushd %~dp0
setlocal

if "%1"=="?" goto :args
if "%1"=="/?" goto :args
if "%1"=="--help" goto :args
if "%1"=="/help" goto :args

set LIB=../lib
set CLASSPATH=%LIB%/ifs-fnd-dbbuild.jar;%LIB%/snakeyaml-1.26.jar

java -cp %CLASSPATH% -Duser.language=en -Duser.country=US ifs.fnd.dbbuild.CreateInstallTem type=validate %*
goto :end

:args
echo.
echo.
echo Usage: validate-solution-set-file.cmd deliveryPath="<path>" buildHomePath="<path>"
echo.
echo      deliveryPath   Path to DELIVERY
echo      buildHomePath  Path to BUILD_HOME
echo.
set errorlevel=1

:end
endlocal
popd
