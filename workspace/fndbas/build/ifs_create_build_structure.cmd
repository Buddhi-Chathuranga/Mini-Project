@ECHO OFF
SETLOCAL EnableDelayedExpansion
SET _all_args=%*
SET _pwd=%~dp0
SET _script=%~n0
PUSHD %_pwd%
REM name of the script
SET _ifs_mtcbs=create build structure
ECHO IFS Cloud Applications - %_ifs_mtcbs%
SET _components=
SET _buildhome=
SET _delivery=

:args_loop
IF NOT "%1"=="" (
	REM components folder defined
	IF /I "%1"=="--components" (
		SET _components=%2
		SHIFT
    )
	REM delivery folder defined
	IF /I "%1"=="--delivery" (
		SET _delivery=%2
		SHIFT
    )
	SHIFT
    GOTO :args_loop
)

if not defined _components goto :end_restart
if not exist "%_components%"\fndbas\build\%_script%.cmd goto :end_restart

fc "%_components%"\fndbas\build\%_script%.cmd %_script%.cmd > nul 2>&1
if %errorlevel% EQU 0                   goto :end_restart
    
echo %DATE% %TIME% %_script%.cmd exists in %_components%. Copy new version and restart...
echo Restarting: %_script%.cmd %_all_args%
copy /Y "%_components%"\fndbas\build\%_script%.cmd "%_pwd%"%_script%.cmd && %_script%.cmd %_all_args%
:end_restart

ECHO Preparing !_ifs_mtcbs! tools...
REM find out where the source files are
call ..\ifsinstaller\utils\verify_required_software.cmd --jdk
IF !ERRORLEVEL! NEQ 0 GOTO :end

REM compile and package in a temp folder
SET _workspace=%TEMP%\_ifs_mtcbs_%RANDOM%_%RANDOM%
FOR %%I IN ("%_pwd%\..") DO SET "_mtcbs_src=%%~fI"

REM copy the source files from component-struct.
ROBOCOPY /MIR /NP /NJH /NJS /NFL /NDL !_mtcbs_src!\source\fndbas\mtcbs\src !_workspace!\src
IF DEFINED _components (
  REM possible changes in components folder
  IF exist !_components!\fndbas\source\fndbas\mtcbs\src (
    ROBOCOPY /S /NP /NJH /NJS /NFL /NDL !_components!\fndbas\source\fndbas\mtcbs\src !_workspace!\src
	IF DEFINED _delivery (
		ROBOCOPY /S /NP /NJH /NJS /NFL /NDL !_components!\fndbas\source\fndbas\mtcbs\src !_mtcbs_src!\source\fndbas\mtcbs\src
	)
  )
)
REM java compile
javac -d !_workspace!\binx -sourcepath !_workspace!\src !_workspace!\src\ifs\cloud\build\Builder.java
IF NOT !ERRORLEVEL!==0 (
	ECHO Compilation error found in !_ifs_mtcbs! tools.
	GOTO :end
)
REM jar package
jar --create --main-class ifs.cloud.build.Builder --file !_workspace!\_ifs_mtcbs.jar -C !_workspace!\binx .
SET _el=!ERRORLEVEL!
RD /S /Q !_workspace!\src
RD /S /Q !_workspace!\binx
IF NOT !_el!==0 (
	ECHO Error packaging !_ifs_mtcbs! tools.
	GOTO :end
)
REM Java exec
java -jar !_workspace!\_ifs_mtcbs.jar create !_all_args!
IF !ERRORLEVEL!==0 (
	POPD
	ENDLOCAL
	EXIT /B 0	
)

:end
POPD
ENDLOCAL
EXIT /B 1