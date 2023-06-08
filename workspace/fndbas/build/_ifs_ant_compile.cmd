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
set ANT_OPTS=-Xms1024m -Xmx2560m

:: Default Home for Ant on the current server
set WORK_HOME=%CD%\..\..
cd /d "%WORK_HOME%"
set WORK_HOME=%CD%\Tools
cd /d "%CURDIR%"

set PATH=%WORK_HOME%\ant\bin;%PATH%

call ant -version >nul 2>&1
set RESULT=%errorlevel%
if %RESULT% GTR 0 set MSG=No ant found in PATH& goto :end

if "%1"=="CLEAN"	set CLEAN=clean-build

echo %DATE% %TIME% %COMPUTERNAME% Start %SCRIPT% %CLEAN%

::
:: Delivery folder for patching = %DELIVERY%
::
if not defined DELIVERY goto :delivery_end
set DELIVERY=%DELIVERY:"=%
set DELIVERY_PROP=-Ddelivery="%DELIVERY%"
echo DELIVERY="%DELIVERY%"
:delivery_end

echo.
echo call ant %CLEAN% %DELIVERY_PROP%
call ant %CLEAN% %DELIVERY_PROP%
set RESULT=%errorlevel% 
if %RESULT% GTR 0 set MSG=ant failed.

:end
echo %DATE% %TIME% %COMPUTERNAME% Stop %SCRIPT% %MSG% 

:quit
exit /B %RESULT%
 
endlocal