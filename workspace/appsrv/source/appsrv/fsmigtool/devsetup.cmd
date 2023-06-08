@echo off

echo.
echo This script will download the necessary Java libs for the FS Mig Tool to be built in IFS Developer Studio.
echo.
echo Logging in to JFrog artifactory...
echo.

set /p un=" >   Username: "
set /p pw=" >   Password (will be visible here): "

set root=https://ifsclouddev.jfrog.io/artifactory/binaryartifacts/appsrv/fs-mig-tool

echo.

call :download javax.json-1.1.2.jar
call :download javax.json-api-1.1.2.jar
call :download javax.ws.rs-api-2.1.1.jar
call :download ojdbc6.jar

goto :done

:download
echo Downloading %1 to lib\...
powershell -command "&{$WC = New-Object System.Net.WebClient; $WC.Credentials = New-Object System.Net.NetworkCredential('%un%', '%pw%'); $WC.DownloadFile('%root%/%1','lib\%1')}"
exit /b

:done

echo.
echo Done. You can now open the project and build it.
echo.

pause
