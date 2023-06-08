@ECHO OFF
SETLOCAL EnableDelayedExpansion
SET _all_args=%*
SET _user_pass=0
SET _delivery=
SET _workspace=
FOR %%A IN ("%~dp0.") DO SET _build_home=%%~dpA
:args_loop
IF NOT "%1"=="" (
	:: jfrog user id ex: --user jfrog_ifs_user
	IF /I "%1"=="--user" (
        SET /a _user_pass=!_user_pass!+1
		SHIFT
    )
    :: jfrog password ex: --password jfrog1234
	IF /I "%1"=="--password" (
		SET /a _user_pass=!_user_pass!+1
		SHIFT
    )
	:: folder containing delivery strcuture ex: --delivery c:\ifs\del01
	IF /I "%1"=="--delivery" (
		SET _delivery=%2
		SHIFT
    )
	:: folder containing build home strcuture ex: --delivery c:\ifs\build-home
	IF /I "%1"=="--build-home" (
		SET _build_home=%2
		SHIFT
    )
	:: internal - will only be set by the script when an update is found
	IF /I "%1"=="--workspace" (
		SET _workspace=%2
		SHIFT
    )
	SHIFT
    GOTO :args_loop
)
IF %_user_pass% LSS 2 (
	ECHO Argument error.
	ECHO.
	ECHO Usage:
	ECHO ifs_fetch --user user-id --password password [other-options]
	ECHO user-id:  jfrog repo user
	ECHO password: password for user-id
	ECHO other-options:
	ECHO --build-home path      folder path to the build home - default is one level up from current
	ECHO --delivery path        folder path to the delivery - no default, fetch run in fresh home mode
	ECHO --force-download flag  force downloading archives even if they are not modified - flag is one of true or false
	ECHO --host host-name       host name for jfrog artifactory - default is ifscloud.jfrog.io
	ECHO                        NOTE: for DEV provide a host with dev artifacts 
	ECHO --log-level level      log level is one of OFF, SEVERE, WARNING, INFO, CONFIG, FINE, FINER, FINEST, ALL
	ECHO --repo-name repo-name  repo-name of the jfrog artifactory - default binaryartifacts
	ECHO.
	GOTO :end
)
call ..\ifsinstaller\utils\verify_required_software.cmd --jdk
IF %ERRORLEVEL% NEQ 0 GOTO :end

SET _src_path=%_build_home%\source\fndbas\fetch\src
SET _work_dir=%TEMP%\ifs_fetch_%RANDOM%_%RANDOM%
IF NOT DEFINED _workspace (
	:: still in script in build_home
	ROBOCOPY /MIR /NP /NJH /NJS /NFL /NDL !_src_path! !_work_dir!\src
) ELSE (
	SET _work_dir=!_workspace!
)
IF DEFINED _delivery (
	:: in delivery mode
	IF EXIST !_delivery! (
		IF NOT DEFINED _workspace (
			:: still in script in build_home
			SET _script=!_delivery!\build\ifs_fetch.cmd
			IF EXIST !_script! (
				ECHO Updated ifs_fetch script available. Switching...
				:: run the updated script in delivery
				CALL !_script! !_all_args! --build-home !_build_home! --workspace !_work_dir!
				ENDLOCAL
				EXIT /B !ERRORLEVEL!
			)
		)
		SET _updated_src=!_delivery!\source\fndbas\fetch\src
		IF EXIST !_updated_src! (
			ECHO Updated ifs_fetch available. Copying...
			ROBOCOPY /E /NP /NJH /NJS /NFL /NDL !_updated_src! !_work_dir!\src
		)
		:: fecth will run in delivery folder
		SET _build_home=!_delivery!
		SET _extra_args=--ignore-cache

	)
)
ECHO Compiling ifs_fetch tool...
javac -d %_work_dir%\binx -sourcepath %_work_dir%\src %_work_dir%\src\ifs\cloud\fetch\Fetch.java
IF NOT %ERRORLEVEL%==0 (
	ECHO ifs_fetch failed while compiling.
	GOTO :end
)
ECHO Creating executable ifs_fetch package...
jar --create --main-class ifs.cloud.fetch.Fetch --file %_work_dir%\ifs_fetch.jar -C %_work_dir%\binx .
SET _el=%ERRORLEVEL%
RD /S /Q %_work_dir%\src
RD /S /Q %_work_dir%\binx
IF NOT %_el%==0 (
	ECHO ifs_fetch failed while packaging executable.
	GOTO :end
)
ECHO Starting ifs_fetch tool...
SET FETCH_LOG=%_build_home%/ifs_fetch.log
java -jar %_work_dir%\ifs_fetch.jar --build-home %_build_home% %_extra_args% %_all_args% --repo-name binaryartifacts --host ifscloud.jfrog.io --workspace %_work_dir%
IF %ERRORLEVEL%==0 (
	ENDLOCAL
	EXIT /B 0	
)
:end
ENDLOCAL
EXIT /B 1