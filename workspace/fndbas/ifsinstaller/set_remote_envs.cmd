@echo off

pushd "%~dp0"

echo Setting paths and KUBECONFIG to current Remote environment in this CMD only
echo.

set CURDIR=%CD%
cd ..\..\..
set IFS_ROOT=%CD%
echo IFS_ROOT=%IFS_ROOT%

if not exist %IFS_ROOT%\config\ifscloud-values.yaml echo Can not find %IFS_ROOT%\config\ifscloud-values.yaml & popd & exit /b 1

cd %CURDIR%\..
set BUILD_HOME=%CD%

for /F "tokens=2" %%i in ('findstr "namespace:" %IFS_ROOT%\config\ifscloud-values.yaml') do @set NS=%%i

set KUBECONFIG=%IFS_ROOT%\config\kube\config
echo KUBECONFIG=%IFS_ROOT%\config\kube\config

cd %IFS_ROOT%\bin
echo %CD% + path
echo %path%|find /i "%CD%">nul  || set path=%CD%;%path%

cd jdk*/bin
echo %CD% + path
echo %path%|find /i "%CD%">nul  || set path=%CD%;%path%

kubectl config set-context --current --namespace=%NS% 2>nul

popd
