@echo off

set toolname=File Storage Migration Tool

echo.
echo This script will unpack the Java JRE needed for the %toolname%
echo.

powershell -command "Expand-Archive -Force -Path jre.zip -DestinationPath java"

echo.
echo Done. You now need to read the documentation to understand how to use the %toolname%
echo.

set /p answer="Do you want to read the documentation now? (yes/no): "

set docurl=https://docs.ifs.com/techdocs/21r2/010_overview/760_file_storage_service/fsmigtool/

echo.

if "%answer%" == "yes" (
  echo Opening %docurl% ...
  start %docurl%
  ) else (
  echo The documentation can be found here: %docurl%
)

echo.
pause
