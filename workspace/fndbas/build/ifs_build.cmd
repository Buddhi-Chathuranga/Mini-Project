@echo off
setlocal 
cd /d "%~dp0"

Title %~n0

set RESULT=0
set CURDIR=%CD%
set SCRIPT=%~n0
set SERVER=true
set DB=true
set DB_OPTION=
set OPTS=
set ECHO_OPTS=
set ARGS=
set XML_FILE=delivery.xml
set CLEAN=
set ARGS=%*
 
cd /d ..
set BUILD_HOME=%CD%
cd /D %CURDIR%

echo %DATE% %TIME% Start %SCRIPT% %*

if defined DELIVERY (
echo %DATE% %TIME% DELIVERY=%DELIVERY%
set DELIVERY=%DELIVERY:"=%
)

:: Default Home for Ant on the current Client
set WORK_HOME=%CD%\..
cd /d "%WORK_HOME%"
set WORK_HOME=%CD%\tools
cd /d "%CURDIR%"

set PATH=%WORK_HOME%\ant\bin;%PATH%

set optsArgCount=0
:Argloop
if /i "%1"==""		goto :end_args
if /i "%1"=="--nodb" 		  set DB=false& goto Loopcont 
if /i "%1"=="--clean" 		  set CLEAN=CLEAN& goto Loopcont 
if /i "%1"=="--validate" 	  set DB_OPTION=VALIDATE& goto Loopcont 
if /i "%1"=="--username" 	  set OPTS=%OPTS% %1=%2&set ECHO_OPTS=%ECHO_OPTS% %1=%2&set /A optsArgCount+=1& shift& goto Loopcont
if /i "%1"=="--password" 	  set OPTS=%OPTS% %1=%2&set ECHO_OPTS=%ECHO_OPTS% %1=password&set /A optsArgCount+=1& shift& goto Loopcont
if /i "%1"=="--connectString" set OPTS=%OPTS% %1=%2&set ECHO_OPTS=%ECHO_OPTS% %1=%2&set /A optsArgCount+=1& shift& goto Loopcont

goto :wrong_args
:Loopcont
shift
goto :Argloop


:wrong_args
echo.
echo Current args: %*
echo Help script for running 'build'.
echo.
echo Usage: cmd %SCRIPT%.cmd [--username="userName" --password="password" --connectString="connectString" ] [--clean] [--nodb] [--validate]
echo.
echo        start .\_ant_compile.cmd %CLEAN%     ^> %BUILD_HOME%\_ifs_ant_compile.log
echo        start .\_ant_generatedb.cmd %CLEAN%  ^> %BUILD_HOME%\_ifs_ant_generatedb.log
echo.
echo        userName, password, connectString, optional arguments to connect to database and create install_tem
echo        --clean    adds CLEAN as argument
echo        --nodb     skip start ./_ifs_ant_generatedb.sh
echo        --validate start ./_ifs_ant_generatedb.sh VALIDATE and exit
echo.
echo        set DELIVERY with environment variable
echo Example:
echo.
echo        set DELIVERY=c:\ifs\delivery
echo        cmd .\%SCRIPT% --userName="ifsapp" --password="IFSAPP" --connectString="jdbc:oracle:thin:@(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=1.2.3.4)(PORT=1521)))(CONNECT_DATA=(SERVICE_NAME=sb)))
echo.
set RESULT=2
goto :end

:end_args
call ..\ifsinstaller\utils\verify_required_software.cmd --jdk
IF %ERRORLEVEL% NEQ 0 (
    SET RESULT=1
    GOTO :end
)

if not defined DELIVERY                 goto :end_restart
if not exist "%DELIVERY%"\build\%SCRIPT%.cmd goto :end_restart

fc "%DELIVERY%"\build\%SCRIPT%.cmd %SCRIPT%.cmd > nul 2>&1
if %errorlevel% EQU 0                   goto :end_restart
    
echo %DATE% %TIME% %SCRIPT%.cmd exists in delivery. Copy new version and restart...
  
echo Restarting: %SCRIPT%.cmd %ARGS%
copy /Y "%DELIVERY%"\build\%SCRIPT%.cmd "%BUILD_HOME%"\build\%SCRIPT%.cmd & %SCRIPT%.cmd %ARGS%
:end_restart

if not defined OPTS goto :opt_check_end
if "%optsArgCount%"=="3" goto :opt_check_end
echo Error: userName and password and connectString are required if used
set RESULT=1&goto :end
:opt_check_end

:install_tools
@REM set COUNT=0
@REM call :ant
@REM if %RESULT% GTR 0 echo %DATE% %TIME% ant installation failed.  & goto :quit

call :create_xml

if defined DELIVERY (set ZIP_UNPACK_FOLDER=%DELIVERY%) else (set ZIP_UNPACK_FOLDER=%BUILD_HOME%)
del /F /Q unpack_zip.log 2>nul
echo %DATE% %TIME% call ant -f %XML_FILE% unpack_zip...
call ant -v -f %XML_FILE% unpack_zip -Dzipunpack.folder=%ZIP_UNPACK_FOLDER% > unpack_zip.log 2>&1
set RESULT=%errorlevel%
type unpack_zip.log | findstr /B "BUILD SUCCESSFUL" 
if %RESULT% GTR 0 goto :quit 

if not defined DELIVERY goto :delivery_end

:delivery
echo %DATE% %TIME% Copy %DELIVERY% to %BUILD_HOME%...
del /F /Q delivery.log 2>nul
call ant -f %XML_FILE% > delivery.log 2>&1
set RESULT=%errorlevel%
type delivery.log | findstr /V /B "BUILD SUCCESSFUL" 
if %RESULT% GTR 0 goto :quit 
echo.

echo %DATE% %TIME% call ant -f %XML_FILE% copy-ifsinstaller-to-delivery...
call ant -v -f %XML_FILE% copy-ifsinstaller-to-delivery > copy-ifsinstaller-to-delivery.log 2>&1
set RESULT=%errorlevel%
type copy-ifsinstaller-to-delivery.log | findstr /B "BUILD SUCCESSFUL" 
if %RESULT% GTR 0 goto :quit 
:delivery_end

set _ifs_ant_compile_RESULT=0
set _ifs_ant_generatedb_RESULT=0
set _ifs_ant_generatedb_validate_RESULT=0

:start_server
:: SERVER always set to true in script
if not "%SERVER%"=="true" goto :start_server_end
echo %DATE% %TIME% .\_ifs_ant_compile %CLEAN% %ECHO_OPTS%    ^> %BUILD_HOME%\_ifs_ant_compile.log
call .\_ifs_ant_compile.cmd %CLEAN% %OPTS% > "%BUILD_HOME%"\_ifs_ant_compile.log 2>&1
set _ifs_ant_compile_RESULT=%errorlevel%
:start_server_end

:start_validate
if not "%DB_OPTION%"=="VALIDATE" goto :start_validate_end
echo %DATE% %TIME% .\_ifs_ant_generatedb   ^> %BUILD_HOME%\_ifs_ant_generatedb.log
call .\_ifs_ant_generatedb.cmd > "%BUILD_HOME%"\_ifs_ant_generatedb.log 2>&1
set _ifs_ant_generatedb_validate_RESULT=%errorlevel%
if %_ifs_ant_generatedb_validate_RESULT% GTR 0 echo %DATE% %TIME% _ifs_ant_generatedb %DB_OPTION% Failed. Check logfile %BUILD_HOME%\_ifs_ant_generatedb.log.
if %_ifs_ant_generatedb_validate_RESULT% EQU 0 echo %DATE% %TIME% _ifs_ant_generatedb %DB_OPTION% Successful.
goto :start_db_end
:start_validate_end

:start_db
if not "%DB%"=="true" goto :start_db_end
echo %DATE% %TIME% .\_ifs_ant_generatedb %CLEAN% %ECHO_OPTS% ^> %BUILD_HOME%\_ifs_ant_generatedb.log
call .\_ifs_ant_generatedb.cmd %CLEAN% %OPTS% > "%BUILD_HOME%"\_ifs_ant_generatedb.log 2>&1
set _ifs_ant_generatedb_RESULT=%errorlevel%
:start_db_end

echo.
echo %DATE% %TIME% Build done

if not "%SERVER%"=="true" goto :no_server
if %_ifs_ant_compile_RESULT% EQU 0 echo %DATE% %TIME% _ifs_ant_compile Successful
if not %_ifs_ant_compile_RESULT% EQU 0 echo %DATE% %TIME% _ifs_ant_compile Failed. Check logfile %BUILD_HOME%\_ifs_ant_compile.log
:no_server

if not "%DB%"=="true" goto :no_db
if %_ifs_ant_generatedb_RESULT% EQU 0 echo %DATE% %TIME% _ifs_ant_generatedb Successful
if not %_ifs_ant_generatedb_RESULT% EQU 0 echo %DATE% %TIME% _ifs_ant_generatedb Failed. Check logfile %BUILD_HOME%\_ifs_ant_generatedb.log
:no_db

if not %_ifs_ant_compile_RESULT% EQU 0 set RESULT=%_ifs_ant_compile_RESULT%
if not %_ifs_ant_generatedb_RESULT% EQU 0 set RESULT=%_ifs_ant_generatedb_RESULT%
if not %_ifs_ant_generatedb_validate_RESULT% EQU 0 set RESULT=%_ifs_ant_generatedb_validate_RESULT%

echo.

:quit
set MSG=BUILD SUCCESSFUL 
if %RESULT% GTR 0 set MSG=BUILD FAILED& set RESULT=1
echo %MSG%

echo %DATE% %TIME% Stop  %SCRIPT% %MSG%	
goto :end


:create_xml
> %XML_FILE% echo ^<?xml version="1.0" encoding="UTF-8"?^>
>>%XML_FILE% echo ^<project name="build" basedir="." default="copy-from-delivery"^>

>>%XML_FILE% echo	^<target name="copy-from-delivery"^>
>>%XML_FILE% echo	  ^<parallel^>
>>%XML_FILE% echo	  ^<copy todir="%BUILD_HOME%" preservelastmodified="false" overwrite="true" failonerror="false" force="true"^>
>>%XML_FILE% echo	    ^<fileset dir="%DELIVERY%"^>
>>%XML_FILE% echo	      ^<include name="source/**"/^>
>>%XML_FILE% echo	      ^<exclude name="source/*/client/**"/^>
>>%XML_FILE% echo	    ^</fileset^>
>>%XML_FILE% echo	   ^</copy^>
>>%XML_FILE% echo	  ^<copy todir="%BUILD_HOME%" preservelastmodified="false" overwrite="true" failonerror="false" force="true"^>
>>%XML_FILE% echo	    ^<fileset dir="%DELIVERY%"^>
>>%XML_FILE% echo	      ^<include name="model/**"/^>
>>%XML_FILE% echo	    ^</fileset^>
>>%XML_FILE% echo	  ^</copy^>
>>%XML_FILE% echo	  ^<copy todir="%BUILD_HOME%" preservelastmodified="false" overwrite="true" failonerror="false" force="true"^>
>>%XML_FILE% echo	    ^<fileset dir="%DELIVERY%"^>
>>%XML_FILE% echo	      ^<exclude name="model/**"/^>
>>%XML_FILE% echo	      ^<exclude name="source/**"/^>
>>%XML_FILE% echo	      ^<exclude name="client/runtime/**"/^>
>>%XML_FILE% echo	      ^<exclude name="*.log"/^>
>>%XML_FILE% echo	      ^<exclude name="*.ini"/^>
>>%XML_FILE% echo	    ^</fileset^>
>>%XML_FILE% echo	  ^</copy^>
>>%XML_FILE% echo	  ^<copy todir="%BUILD_HOME%" preservelastmodified="false" overwrite="true" failonerror="false" force="true"^>
>>%XML_FILE% echo	    ^<fileset dir="%DELIVERY%"^>
>>%XML_FILE% echo	      ^<include name="layers.ini"/^>
>>%XML_FILE% echo	      ^<include name="solutionset.yaml"/^>
>>%XML_FILE% echo	    ^</fileset^>
>>%XML_FILE% echo	  ^</copy^>
>>%XML_FILE% echo	  ^</parallel^>
>>%XML_FILE% echo	^</target^>


>>%XML_FILE% echo	^<target name="copy-ifsinstaller-to-delivery"^>
>>%XML_FILE% echo	  ^<copy todir="%DELIVERY%" preservelastmodified="true" overwrite="false" failonerror="false" force="true"^>
>>%XML_FILE% echo	    ^<fileset dir="%BUILD_HOME%"^>
>>%XML_FILE% echo	      ^<include name="ifsinstaller/**"/^>
>>%XML_FILE% echo	      ^<exclude name="ifsinstaller/image-versions/**"/^>
>>%XML_FILE% echo	      ^<exclude name="ifsinstaller/utils/validate-solution-set-file.*"/^>
>>%XML_FILE% echo	      ^<exclude name="ifsinstaller/utils/create-install-tem.*"/^>
>>%XML_FILE% echo	    ^</fileset^>
>>%XML_FILE% echo	  ^</copy^>
>>%XML_FILE% echo	^</target^>


>>%XML_FILE% echo		^<target name="unpack_zip"^>
>>%XML_FILE% echo			^<taskdef resource="net/sf/antcontrib/antlib.xml"/^>
>>%XML_FILE% echo			^<echo message="starting" level="info"/^>
>>%XML_FILE% echo			^<echo message="zipunpack.folder: ${zipunpack.folder}" level="info"/^>

>>%XML_FILE% echo	      		^<fileset id="ref.zips" dir="${zipunpack.folder}"^>
>>%XML_FILE% echo	         		^<include name="/source/*/zip/*.zip"/^>
>>%XML_FILE% echo	      		^</fileset^>
>>%XML_FILE% echo	      		^<pathconvert pathsep="," property="zips" refid="ref.zips" setonempty="false"/^>
>>%XML_FILE% echo	      		^<echo^>zips: ${zips} ^</echo^>

>>%XML_FILE% echo		        ^<foreach list="${zips}" param="zipfile.name" target="do-unzip" inheritall="true"/^>
>>%XML_FILE% echo		^</target^>

>>%XML_FILE% echo		^<target name="do-unzip" if="zips"^>
>>%XML_FILE% echo		    ^<echo message="${zipfile.name}" level="info"/^>
>>%XML_FILE% echo			^<unzip src="${zipfile.name}" dest="${zipunpack.folder}/temp_unzip"/^>
>>%XML_FILE% echo			^<copy todir="${zipunpack.folder}" overwrite="true" preservelastmodified="true"^>
>>%XML_FILE% echo				^<fileset dir="${zipunpack.folder}/temp_unzip/build_home"/^>
>>%XML_FILE% echo			^</copy^>

>>%XML_FILE% echo		        ^<subant failonerror="false"^>
>>%XML_FILE% echo	        	    ^<fileset dir="${zipunpack.folder}/temp_unzip" includes="build.xml"/^>
>>%XML_FILE% echo	        	^</subant^>
		
>>%XML_FILE% echo			^<delete dir="${zipunpack.folder}/temp_unzip"/^>
>>%XML_FILE% echo		^</target^>

>>%XML_FILE% echo ^</project^>

goto :eof

:end
%PAUSE%
echo exit with: %RESULT%
exit /B %RESULT%

endlocal