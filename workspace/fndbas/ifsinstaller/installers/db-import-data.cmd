@echo off
pushd %~dp0
setlocal

if "%1"=="?" goto :args
if "%1"=="/?" goto :args
if "%1"=="--help" goto :args
if "%1"=="/help" goto :args

set LIB=../lib
set CLASSPATH=%LIB%/ifs-fnd-import.jar;%LIB%/ojdbc.jar

java -Xmx4096m -cp %CLASSPATH% -Duser.language=en -Duser.country=US ifs.fnd.dataimport.DataImport %*
goto :end

:args
echo.
echo.
echo Usage: db-import-data.cmd deliveryPath="<path>" userName="<user>" password="<pwd>" connectString="<jdbcurl>" logFilePath="<path>"
echo                           [transRuntime="<Y|N>"] [transImportAttributes="<Y|N>"] [transImportTranslations="<Y|N>"]
echo.
echo       deliveryPath             Path to BUILD_HOME or DELIVERY
echo       userName                 User name for application owner
echo       password                 Password for applicaton owner
echo       connectString            Jdbc url
echo       logFilePath              Path to logs folder
echo       transRuntime             Only runtime files should be imported, Y or N, default = Y
echo       transImportAttributes    Import translatable attributes, Y or N, default = Y
echo       transImportTranslations  Import translations, Y or N, default = Y
echo.
set errorlevel=1

:end
endlocal
popd
