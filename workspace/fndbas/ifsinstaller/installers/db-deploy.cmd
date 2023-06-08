@echo off
pushd %~dp0
setlocal

if "%1"=="?" goto :args
if "%1"=="/?" goto :args
if "%1"=="--help" goto :args
if "%1"=="/help" goto :args

set LIB=../lib
set CLASSPATH=%LIB%/ifs-fnd-dbbuild.jar;%LIB%/snakeyaml-1.26.jar;%LIB%/ojdbc.jar;%LIB%/databaseInstaller/org-netbeans-modules-editor-util.jar
set CLASSPATH=%CLASSPATH%;%LIB%/databaseInstaller/org-netbeans-modules-lexer.jar;%LIB%/databaseInstaller/org-openide-util.jar

java -Xmx4096m -cp %CLASSPATH% -Duser.language=en -Duser.country=US ifs.fnd.dbbuild.DatabaseInstaller %*
goto :end

:args
echo.
echo.
echo Usage: db-deploy.cmd deliveryPath="<path>" fileName="<fullpath>" userName="<user>" password="<pwd>" [sysPassword="<pwd>"] [ialOwner="<ialowner>"]
echo                      connectString="<jdbcurl>" logFilePath="<path>" [extLogging="<Y|N>"] [waitingTime="<value>"] [initialPasswords="<value>"]
echo.
echo       deliveryPath      Path to BUILD_HOME or DELIVERY
echo       fileName          Full path name of a file to deploy. The file will be deployed in userName schema.
echo       userName          User name
echo       password          Password
echo       sysPassword       Password for SYS user. If not given, prepare.sql as SYS will not be run.
echo       ialOwner          IAL schema owner. If not given, ial.tem will not be run.
echo       connectString     Jdbc url
echo       logFilePath       Path to logs folder
echo       extLogging        Extended logging Y or N
echo       waitingTime       Waiting time if locked processes, default = 3600 (one hour)
echo       initialPasswords  Only used when running as SYS and new internal users are created requiring custom passwords.
echo.
set errorlevel=1

:end
endlocal
popd
