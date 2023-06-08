@ECHO OFF
SETLOCAL EnableDelayedExpansion
SET _all_args=%*
SET _pwd=%~dp0
SET _script=%~n0
PUSHD %_pwd%
REM name of the script
SET _ifs_mtcbs=delete obsolete files
ECHO IFS Cloud Applications - %_ifs_mtcbs%

ECHO Preparing !_ifs_mtcbs! tools...
REM find out where the source files are
call ..\ifsinstaller\utils\verify_required_software.cmd --jdk
IF !ERRORLEVEL! NEQ 0 GOTO :end

REM compile and package in a temp folder
SET _workspace=%TEMP%\_ifs_mtcbs_%RANDOM%_%RANDOM%
FOR %%I IN ("%_pwd%\..") DO SET "_mtcbs_src=%%~fI"

REM copy the source files from component-struct.
ROBOCOPY /MIR /NP /NJH /NJS /NFL /NDL !_mtcbs_src!\source\fndbas\mtcbs\src !_workspace!\src

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
java -jar !_workspace!\_ifs_mtcbs.jar delete !_all_args! 
IF !ERRORLEVEL!==0 (
	POPD
	ENDLOCAL
	EXIT /B 0	
)

:end
POPD
ENDLOCAL
EXIT /B 1