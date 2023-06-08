@echo off
CALL utils\verify_required_software.cmd --java --kubectl
IF %ERRORLEVEL% NEQ 0 EXIT /B 1
java -cp lib/mtctl.jar ifs.cloud.client.Client %*
EXIT /B %errorlevel%