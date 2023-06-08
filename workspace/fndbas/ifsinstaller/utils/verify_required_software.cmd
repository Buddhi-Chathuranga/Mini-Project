@echo off
SETLOCAL EnableDelayedExpansion

IF NOT DEFINED supported_jdk_versions ( 
    SET supported_jdk_versions=11.0 14.0
)
IF NOT DEFINED supported_helm_versions ( 
    SET supported_helm_versions=3.3 3.4 3.5 3.6 3.7
)
IF NOT DEFINED supported_k8s_client_versions ( 
    SET supported_k8s_client_versions=1.18 1.19 1.20 1.21
)
GOTO :main

::
:: return:
:: 0 - not a required version
:: 1 - a required version
:: 2 - installed, version ignored
:: 127 - not installed
::
:compare_installed_version
    SET _cmd=%~2
    :: check if software is installed
    %_cmd%
    if %ERRORLEVEL%==9009 (
        EXIT /B 127
    )
    :: when no versions are listed any installed version is supported
    IF "%~4"=="" (
        EXIT /B 2
    )

    :: execuite the command and get current version string 
    FOR /F "usebackq delims=" %%a IN (`%_cmd% 2^>^&1`) DO SET _result=!_result!%%a
    SET _result=!_result:"=$QUOTE$!
    SET _header=%~3
    SET _version_ok=0
    SET _version_not_ok=0
    :: trim left
    for /f "tokens=* delims= " %%a in ("!_result!") do set _result=%%a
    :loop
    SET _version=%~4
    IF NOT "!_version!"=="" (
        :: when first character is a '-' that version should not be supported
        SET _flag=!_version:~0,1!
        IF "!_flag!"=="-" (
            SET _search_pattern=!_header!!_version:~1!
            SET _found=
            FOR /F "tokens=* USEBACKQ" %%F IN (`echo !_result!^| FINDSTR /i /C:"!_search_pattern!"`) DO (
                SET _found=%%F
                IF "!_found!"=="!_result!" (
                    SET _version_not_ok=1
                )
            )
        ) ELSE (
            SET _search_pattern=!_header!!_version!
            SET _found=
            FOR /F "tokens=* USEBACKQ" %%F IN (`echo !_result!^| FINDSTR /i /C:"!_search_pattern!"`) DO (
                SET _found=%%F
                IF "!_found!"=="!_result!" (
                    SET _version_ok=1
                )
            )
        )
        SHIFT
        GOTO :loop
    )
    IF !_version_not_ok!==1 (
        :: current version is in unsupported list
        SET _version_ok=0
    )
    EXIT /B !_version_ok!

:: 
:: args:
:: 1. description for display purposes
::     ex: "Java JDK"
:: 2. command to fetch the current installed version
::     ex: "javac.exe -version"
:: 3. The start boundary text of the returned version string
::     ex: "javac " -> jdk version format is "javac x.xx.xx"
:: 4. List of versions to check for
::     each item in this list is checked against the installed version, and if the 
::     installed version starts with pattern given in param3 + verion, it is matched.
::     ex: 1.1 1.2.1 -> when installed version is "javac 1.1??" or "javac 1.2.1?" they 
::     are treated compatible. if a version item has a minus in front those matching 
::     versions are treated as non compatibles. 
::
:check_version
    SET _app=%~1
    ECHO Checking !_app!...
    CALL :compare_installed_version %*
    SET _result=!ERRORLEVEL!
    SET _ret=0
    IF !_result!==1 (
        ECHO !_app! - compatible version found.
    ) ELSE (
        IF !_result!==2 (
            ECHO !_app! - found.
        ) ELSE (
            IF !_result!==127 (
                ECHO !_app! - not found.
                SET _ret=1
            ) ELSE (
                echo !_app! - version not compatible.
                SET _ret=1
            )
        )
    )
    EXIT /B !_ret!

:: main
:: args
:: any combination of the following args are accepted.
:: repeated if so
:: --jdk     check for Java JDK
:: --java    check for Java JRE
:: --helm    check for Helm
:: --kubectl check for kubectl
::
:main
    SET _return=0
    :args_loop
    IF NOT "%1"=="" (
        IF /I "%1"=="--jdk" (
            CALL :check_version "OpenJDK Development Kit" "javac.exe -version" "javac " !supported_jdk_versions!
            SET /a _return=!_return!+!ERRORLEVEL!
        )
        IF /I "%1"=="--java" (
            :: JRE returns different signatures
            CALL :check_version "OpenJDK Java Runtime Environment" "java.exe -version" "openjdk version $QUOTE$" !supported_jdk_versions!
                SET /a _return=!_return!+!ERRORLEVEL!
        )
        IF /I "%1"=="--helm" (
            CALL :check_version "Helm" "helm version --short" "v" %supported_helm_versions%
            SET /a _return=!_return!+!ERRORLEVEL!
        )
        IF /I "%1"=="--kubectl" (
            CALL :check_version "K8S Client (kubectl)" "kubectl version --short --client true" "Client Version: v" %supported_k8s_client_versions%
            SET /a _return=!_return!+!ERRORLEVEL!
        )
        SHIFT
        GOTO :args_loop
    )
    IF NOT !_return!==0 (
        ENDLOCAL
        EXIT /B 1
    )
    ENDLOCAL