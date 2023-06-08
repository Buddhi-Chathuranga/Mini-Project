@echo off
::
::
::
::	Create a project_root from BUILD_HOME contents
::
::
::
cls
pushd %~dp0
setlocal
set CURDIR="%CD%"
Title %~n0

set RESULT=0
set STATUS=0
set MESSAGE=
set SCRIPT=%~n0
set PROJECT_ROOT=%CD%\..\..
cd /d "%PROJECT_ROOT%"
set PROJECT_ROOT=%CD%\project_root
cd /d "%CURDIR%\.."
set BUILD_HOME=%CD%
cd /d "%CURDIR%"
:: Default Home for Java and Ant on the current Client
set WORK_HOME=%CD%\..\..
cd /d "%WORK_HOME%"
set WORK_HOME=%CD%\Tools
cd /d "%CURDIR%"

set XCOPY_FLAGS=/D /S /R /Y /I /Q
:: /D:m-d-y     Copies files changed on or after the specified date.
::              If no date is given, copies only those files whose
::              source time is newer than the destination time.
:: /S           Copies directories and subdirectories except empty ones.
:: /R           Overwrites read-only files.
:: /Y           Suppresses prompting to confirm you want to overwrite an
::              existing destination file.
:: /I           If destination does not exist and copying more than one file,
::              assumes that destination must be a directory.
:: /Q           Does not display file names while copying.
:: /F           Displays full source and destination file names while copying.


set PATH=%WORK_HOME%\java\bin;%PATH%
set PATH=%WORK_HOME%\ant\bin;%PATH%


echo %DATE% %TIME% %COMPUTERNAME% Start %SCRIPT%

if not exist ..\server\apps\main (
  set MESSAGE=Error! No ..\server\apps\main found. _ant_generatedb has to be run before %SCRIPT%
  goto :end
)

set IFS_HOME_ARG=%1
if defined IFS_HOME_ARG set IFS_HOME=%IFS_HOME_ARG:"=%

set PROJECT_ROOT_ARG=%2
if defined PROJECT_ROOT_ARG set PROJECT_ROOT=%PROJECT_ROOT_ARG:"=%

:ask_project_root
echo.
set /P PROJECT_ROOT= Enter PROJECT_ROOT ( [%PROJECT_ROOT%] /Q(uit) ) 
IF "%PROJECT_ROOT%"=="" goto :ask_project_root
IF /I "%PROJECT_ROOT%"=="Q" goto :quit

goto :begin


:wrong_args
echo.
echo Help script for running creating a project root.
echo.
echo Usage: %SCRIPT%.cmd [top folder for project root]
echo.
pause
set RESULT=1
goto :quit


:begin



set MODE=CREATE
if exist "%PROJECT_ROOT%" (
  echo.
  echo  %PROJECT_ROOT% exist!
  set MODE=RECREATE
)


:ask_run
set RUN=Y
echo.
set /P RUN= Do you want to %MODE% the project root "%PROJECT_ROOT%" ? (Y/N [Y])
IF /i "%RUN%"=="Y" goto run
IF /i "%RUN%"=="N" goto quit
goto ask_run

:run

if "%MODE%"=="RECREATE" (
   echo.
   echo Deleting %PROJECT_ROOT%...
   rd /q /s "%PROJECT_ROOT%"
   ping -n 10 localhost >nul
   if exist "%PROJECT_ROOT%" (
     echo.
     echo Error when removing old %PROJECT_ROOT%
     echo.
     set RESULT=1
     goto end
   )
)

mkdir "%PROJECT_ROOT%\server" 2>nul
if not exist "%PROJECT_ROOT%" (
   echo.
   echo Cannot create directory "%PROJECT_ROOT%"!
   set RESULT=1 
   goto end
)

:server

cd /d %BUILD_HOME%\build
echo.
echo Creating %PROJECT_ROOT%
echo ant create-project-root -Dproject.root="%PROJECT_ROOT%"

call ant create-project-root -Dproject.root="%PROJECT_ROOT%"

:end

if %RESULT% GTR 0 set MESSAGE=Error!
echo %DATE% %TIME% %COMPUTERNAME% Stop %SCRIPT% %MESSAGE%


echo.
if not defined PROJECT_ROOT_ARG pause

:quit
endlocal
popd
