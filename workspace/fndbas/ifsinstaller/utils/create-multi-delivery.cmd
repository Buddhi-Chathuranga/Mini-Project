@echo off
pushd %~dp0
setlocal

if "%1"=="?" goto :args
if "%1"=="/?" goto :args
if "%1"=="--help" goto :args
if "%1"=="/help" goto :args

set LIB=../lib
set CLASSPATH=%LIB%/ifs-fnd-dbbuild.jar;%LIB%/snakeyaml-1.26.jar

java -cp %CLASSPATH% -Duser.language=en -Duser.country=US ifs.fnd.dbbuild.CreateMultiDelivery %*
goto :end

:args
echo.
echo.
echo Usage: create-multi-delivery.cmd mergeType="<type>" deliveryPath="<path>" deliveryDestPath="<path>"
echo.
echo       mergeType          maintem or mergetem.
echo                          - maintem:  The database folder in each single delivery will be copied to database folder as a subfolder, named as the single delivery and a new 
echo                                      install.tem (master install.tem) will be created, calling these single deliveries install.tem in the defined copy order.
echo                          - mergetem: The database sub folders will be copied in sequence and the files calling these single files in the subfolders will be regenerated, 
echo                                      as well as the tem files (e.g. install.tem) and install.ini file.
echo       deliveryPath       Path to the folder containing the single deliveries.
echo       deliveryDestPath   Path to the created merged delivery.
echo.
set errorlevel=1

:end
endlocal
popd
