@echo off
setlocal 
cd /d "%~dp0"

Title %~n0

set SCRIPT=%~n0
set CURDIR=%CD%
set ARGS=%*
set _gitcheckout=
set _fromtag=
set _totag=
set _filelistname=
set _deleted=

echo %DATE% %TIME% Start %SCRIPT% %ARGS%

set argsCount=0
:Argloop
if /i "%1"==""		goto :end_args
if /i "%1"=="--gitcheckout"	  set _gitcheckout=%2&set /A argsCount+=1& shift& goto Loopcont 
if /i "%1"=="--fromtag" 	  set _fromtag=%2&set /A argsCount+=1& shift& goto Loopcont 
if /i "%1"=="--totag" 	      set _totag=%2&set /A argsCount+=1& shift& goto Loopcont 
if /i "%1"=="--filelistname"  set _filelistname=%2& shift& goto Loopcont 
if /i "%1"=="--deleted"       set _deleted=true& goto Loopcont 

goto :wrong_args
:Loopcont
shift
goto :Argloop

:wrong_args
echo.
echo Current args: %ARGS%
echo.
echo Usage: cmd %SCRIPT%.cmd --gitcheckout "Path to git checkout" --fromtag "from Tag" --totag "to Tag" [--filelistname "path + filename"] [--deleted]
echo.
echo        --filelistname optional, if not defined, default file list name is ^<--gitcheckout^>\..\diff_file_list.txt.
echo                                 If --onlydeleted is defined, default file list name is ^<--gitcheckout^>\..\deleted_file_list.txt.
echo        --deleted  optional, deleted files between the tags will be spooled to file.
echo.
echo Example:
echo        cmd .\%SCRIPT% --gitcheckout "C:\customer1\workspace" --fromtag "tag delvery1" --totag "tag delivery2"
echo        cmd .\%SCRIPT% --gitcheckout "C:\customer1\workspace" --fromtag "tag delvery1" --totag "tag delivery2" --filelistname "C:\customer1\deleted_files.txt" --deleted
echo.
set RESULT=2
goto :end

:end_args

if not exist "%_gitcheckout%"\fndbas\build\%SCRIPT%.cmd goto :end_restart

fc "%_gitcheckout%"\fndbas\build\%SCRIPT%.cmd %SCRIPT%.cmd > nul 2>&1
if %errorlevel% EQU 0                   goto :end_restart
    
echo %DATE% %TIME% %SCRIPT%.cmd exists in checkout. Copy new version and restart...
echo Restarting: %SCRIPT%.cmd %ARGS%
copy /Y "%_gitcheckout%"\fndbas\build\%SCRIPT%.cmd "%CURDIR%"\%SCRIPT%.cmd && %SCRIPT%.cmd %ARGS%
:end_restart

if NOT "%argsCount%"=="3" goto :wrong_args

git --version >nul 2>&1
set RESULT=%errorlevel%
if %RESULT% NEQ 0 echo ERROR: git command not found! && goto :end

echo %DATE% %TIME% Changes folder to %_gitcheckout%
cd /d "%_gitcheckout%"

set diff_filter=ACMRT&set output_file=..\diff_file_list.txt
if "%_deleted%"=="true" set diff_filter=D&set output_file=..\deleted_file_list.txt
if defined _filelistname set output_file=%_filelistname%
echo %DATE% %TIME% git diff-tree -r --no-commit-id --name-only --diff-filter=%diff_filter% %_fromtag% %_totag% %output_file%
call git diff-tree -r --no-commit-id --name-only --diff-filter=%diff_filter% %_fromtag% %_totag% > %output_file% 2>&1
set RESULT=%errorlevel%
echo %DATE% %TIME% Changes folder back to %CURDIR% 

:end
exit /B %RESULT%

endlocal
