@echo off
setlocal
cls
cd /d "%~dp0"

Title %~n0

set CURDIR=%CD%
set RESULT=0
set MSG=
set CLEAN=
set SCRIPT=%~n0
set ANT_OPTS=-Xms1000M -Xmx3800M -Djava.util.concurrent.ForkJoinPool.common.parallelism=4
set ARGS=%*
set ECHO_ARGS=

:: Build home
cd /d %CURDIR%\..
set BUILD_HOME=%CD%
cd /d %CURDIR%

:: Default Home for Ant on the current server
cd /d %CURDIR%\..\..
set TOOL_HOME=%CD%\Tools
cd /d %CURDIR%

set PATH=%TOOL_HOME%\ant\bin;%PATH%

if "%1"=="CLEAN"	set CLEAN=clean

:Argloop
if /i "%1"==""		goto :end_args
if /i "%1"=="--username" 	  set ECHO_ARGS=%ECHO_ARGS% %1=%2& shift& goto Loopcont
if /i "%1"=="--password" 	  set ECHO_ARGS=%ECHO_ARGS% %1=password& shift& goto Loopcont
if /i "%1"=="--connectString" set ECHO_ARGS=%ECHO_ARGS% %1=%2& shift& goto Loopcont

:Loopcont
shift
goto :Argloop

:end_args

call ant -version >nul 2>&1
set RESULT=%errorlevel%
if %RESULT% GTR 0 set MSG=No ant found in PATH& goto :end

echo %DATE% %TIME% %COMPUTERNAME% Start %SCRIPT% %CLEAN%

::
:: Delivery folder for patching = %DELIVERY%
::
:delivery
if not defined DELIVERY goto :delivery_end
set DELIVERY=%DELIVERY:"=%
set DELIVERY_PROP=-Ddelivery="%DELIVERY%"
echo DELIVERY="%DELIVERY%"
:delivery_end

:: If DELIVERY not defined, set to BUILD_HOME, used in validation and in create-install tem
if not defined DELIVERY (set DELIVERY_LOCAL=%BUILD_HOME%) else (set DELIVERY_LOCAL=%DELIVERY%)

:validate
echo.
echo call %BUILD_HOME%/ifsinstaller/utils/validate-solution-set-file.cmd deliveryPath=%DELIVERY_LOCAL% buildHomePath=%BUILD_HOME%
call "%BUILD_HOME%"/ifsinstaller/utils/validate-solution-set-file.cmd deliveryPath="%DELIVERY_LOCAL%" buildHomePath="%BUILD_HOME%"
set RESULT=%errorlevel%
if %RESULT% GTR 0 set MSG=ant failed.& goto :end

:: If DB_OPTION set to "VALIDATE", only validation of solutionset files should be executed.
if "%DB_OPTION%"=="VALIDATE" goto :end

echo.
echo call ant -f build_generate_db.xml %CLEAN% generate %DELIVERY_PROP%
call ant -f build_generate_db.xml %CLEAN% generate %DELIVERY_PROP%
set RESULT=%errorlevel% 
if %RESULT% GTR 0 set MSG=ant failed.& goto :end

echo.
echo call %BUILD_HOME%/ifsinstaller/utils/create-install-tem.cmd deliveryPath=%DELIVERY_LOCAL% buildHomePath=%BUILD_HOME% %ECHO_ARGS%
call "%BUILD_HOME%"/ifsinstaller/utils/create-install-tem.cmd deliveryPath="%DELIVERY_LOCAL%" buildHomePath="%BUILD_HOME%" %ARGS%
set RESULT=%errorlevel%
if %RESULT% GTR 0 set MSG=ant failed.& goto :end

set DELIVERY_PROP=%DELIVERY_PROP% -DbuildhomePath="%BUILD_HOME%/database" -DdeliveryPath="%DELIVERY_LOCAL%/database"
echo.
echo call ant -f build_generate_db.xml copy-CreateInstallTem-files-to-build %DELIVERY_PROP%
call ant -f build_generate_db.xml copy-CreateInstallTem-files-to-build %DELIVERY_PROP%
set RESULT=%errorlevel% 
if %RESULT% GTR 0 set MSG=ant failed.

:end
echo %DATE% %TIME% %COMPUTERNAME% Stop %SCRIPT% %MSG% 

:quit
exit /B %RESULT%
 
endlocal