@echo %verbose%

setlocal

if "%namespace%"=="" (
  echo SEVERE: namespace must be set
  goto exit_error
)

if "%1"=="delete" (
  goto delete
)

:: Check if namespace exists, otherwise create it
kubectl %kubeconfigFlag% get namespace %namespace% -o name > nul 2> nul

if errorlevel 1 (
  echo INFO: Creating namespace
  kubectl %kubeconfigFlag% create namespace %namespace%
  if errorlevel 1 (
    echo SEVERE: Failed to create namespace
    goto exit_error
  )
)

:: If namesapce exist but is owned by Helm, then recreate it.
kubectl %kubeconfigFlag% describe namespace %namespace% | findstr "meta.helm.sh" > nul 2> nul

if "%errorlevel%"=="0" (
  echo INFO: Recreate namespace owned by Helm
  kubectl %kubeconfigFlag% delete namespace %namespace%
  kubectl %kubeconfigFlag% create namespace %namespace%
  if errorlevel 1 (
    echo SEVERE: Failed to create namespace
    goto exit_error
  )
)



if "%1"=="create-namespace" (
  goto exit
)

if "%helmRepo%"=="" (
  echo SEVERE: helmRepo must be set
  goto exit_error
)

if "%helmUser%"=="" (
  echo SEVERE: helmUser must be set
  goto exit_error
)

if "%helmPwd%"=="" (
  echo SEVERE: helmPwd must be set
  goto exit_error
)

if "%chart%"=="" (
  echo SEVERE: Chart to use must be set
  goto exit_error
)

if not "%chartVersion%"=="" (
  set chartVersion=--version %chartVersion%
)

helm repo add ifscloud --force-update %helmRepo% --username %helmUser% --password %helmPwd%
helm repo update

if "%1"=="stop" (
  :: only stop if chart is installed
  for /f "tokens=*" %%a in ('helm list --namespace %namespace% --short %kubeconfigFlag%') do (
    echo INFO: Stopping deployments..
    goto stop_pods
  )
  goto exit
)

echo INFO: Installing ifs-cloud
if "%localChart%"=="true" (
  echo INFO: Using local chart.
  set chartVersion=
  if "%depUpEnabled%"=="true" (
    echo INFO: Running dependency update..
    helm dep up %chart%
  )
) else (
  echo INFO: Using chart %chart% %chartVersion%
)

set helmArgs=%helmArgs% --reset-values
if not "%1"=="dryrun" echo INFO: Installing ifs-cloud & goto :helm
echo INFO: Doing a dry-run ..
set helmArgs=%helmArgs% --dry-run

:helm

echo INFO: Running helm upgrade
helm upgrade --install ifs-cloud %chart% %chartVersion% %helmConfigFlag% --debug --timeout 15m --namespace %namespace% %helmArgs%
:: helm template %chart% %chartVersion% %helmConfigFlag% --debug  --timeout 15m  --namespace %namespace% %helmArgs%
if errorlevel 1 (
  echo SEVERE: Failed to install ifs-cloud
  goto exit_error
)
if "%1"=="dryrun" (
  echo INFO: dry-run succeeded
) else (
  echo INFO:IFS Cloud installed
)
goto exit

:stop_pods
kubectl get deployment -n %namespace% %kubeconfigFlag% -o custom-columns=NAME:.metadata.name > tmpFile 
for /F "tokens=*" %%a in (tmpFile) do (
  if not "%%a"=="NAME" (
    kubectl scale --replicas=0 deployment/%%a -n %namespace% %kubeconfigFlag%
  )
)
if errorlevel 1 (
  echo SEVERE: Failed to stop running containers
  goto exit_error
)
del tmpFile
:: waiting default terminationGracePeriodSeconds
ping -n 30 127.0.0.1 >nul 2>nul
goto exit

:delete
echo INFO:Deleting ifs-cloud chart..
:: helm delete ifs-cloud --namespace %namespace% %helmConfigFlag%
kubectl delete ns %namespace% %kubeconfigFlag%
goto exit

:exit
endlocal
exit /B 0

:exit_error
endlocal
exit /B 1