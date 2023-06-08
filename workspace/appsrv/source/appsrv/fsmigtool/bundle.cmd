@echo off
echo.
echo This script will bundle the necessary files for upload to the addon folder in Azure.
echo.
echo IMPORTANT! Before you run this script, make sure you have built the project and that the file
echo fsmigtool.jar exists under the dist folder.
echo.
echo Press enter if this is understood:
echo.

pause >NUL

echo.

echo Logging in to JFrog artifactory...
echo.
set /p un=" >   Username: "
set /p pw=" >   Password (will be visible here): "

set fsmigtmp=%temp%\fsmigtmp

echo Creating temp folder %fsmigtmp%...

rd %fsmigtmp% /s /q 2>NUL
md %fsmigtmp%
md %fsmigtmp%\database

echo.

echo Creating README.txt...
echo.

>  %fsmigtmp%\README.txt echo This is the distribution bundle for the File Storage Mig Tool.
>> %fsmigtmp%\README.txt echo.
>> %fsmigtmp%\README.txt echo The tool is installed in several steps. Start by running the file
>> %fsmigtmp%\README.txt echo install.cmd. Then read the documentation mentioned there.
>> %fsmigtmp%\README.txt echo.

echo.

echo Copying command files...
echo.

copy fsmigtool.cmd %fsmigtmp%\
copy install.cmd %fsmigtmp%\

echo.
echo Copying database files...
echo.

copy database %fsmigtmp%\database\

echo.
echo Copying JAR files...
echo.

md %fsmigtmp%\lib

copy dist\FsMigTool.jar %fsmigtmp%\lib\
copy dist\lib\*.jar %fsmigtmp%\lib\

echo.
echo Downloading Java JRE...
echo.

set jreurl=https://ifsclouddev.jfrog.io/artifactory/binaryartifacts/appsrv/fs-mig-tool/jre.zip

powershell -command "&{$WC = New-Object System.Net.WebClient; $WC.Credentials = New-Object System.Net.NetworkCredential('%un%', '%pw%'); $WC.DownloadFile('%jreurl%','%fsmigtmp%\jre.zip')}"

echo.

echo Creating bundle...

powershell -command "Compress-Archive -Path %fsmigtmp%\* -DestinationPath %fsmigtmp%\FsMigTool.zip"

start %fsmigtmp%

echo.
echo Done.
echo.

pause
