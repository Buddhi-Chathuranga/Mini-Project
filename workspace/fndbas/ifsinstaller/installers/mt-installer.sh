#!/bin/bash

if [ -z ${namespace+x} ]; then
  echo SEVERE: namespace must be set
  exit 1
fi

if [ "$1" == "delete" ]; then
  echo INFO: Deleting ifs-cloud chart..
  # helm delete ifs-cloud --namespace ${namespace} ${kubeconfigFlag}
  kubectl ${kubeconfigFlag} delete ns ${namespace}
  if [ $? -ne 0 ]; then echo SEVERE: Failed to delete namespace; exit 1; fi
  exit 0
fi

# Create namespace if it doesn't exist
kubectl ${kubeconfigFlag} get namespace ${namespace} -o name > /dev/null 2>&1
if [ $? -ne 0 ]; then 
  echo INFO: Creating namespace
  kubectl ${kubeconfigFlag} create namespace ${namespace}
  if [ $? -ne 0 ]; then echo SEVERE: Failed to create namespace; exit 1; fi
fi

# If namesapce exist but is owned by Helm, then recreate it.
kubectl ${kubeconfigFlag} describe namespace ${namespace} | grep "meta.helm.sh" > /dev/null 2>&1
if [ $? -ne 1 ]; then 
  echo INFO: Recreate namespace owned by Helm
  kubectl ${kubeconfigFlag} delete namespace ${namespace}
  kubectl ${kubeconfigFlag} create namespace ${namespace}
  if [ $? -ne 0 ]; then echo SEVERE: Failed to create namespace; exit 1; fi
fi



if [ "$1" == "create-namespace" ]; then
  exit 0
fi

if [ -z ${helmRepo+x} ]; then
  echo SEVERE: helmRepo must be set
  exit 1
fi

if [ -z ${helmUser+x} ]; then
  echo SEVERE: helmRepo must be set
  exit 1
fi

if [ -z ${helmPwd+x} ]; then
  echo SEVERE: helmRepo must be set
  exit 1
fi

if [ -n "${chartVersion}" ]; then
  chartVersion="--version ${chartVersion}"
fi

helm repo add ifscloud --force-update ${helmRepo} --username ${helmUser} --password ${helmPwd}
helm repo update

nsFound=$(helm list --namespace $(namespace) --short $kubeconfigFlag)
if [ "$1" == "stop" ]; then
  if [ ! "$nsFound" == "" ]; then
    echo INFO: Stopping deployments..
    deployments=$(kubectl get deployment -n ${namespace} ${kubeconfigFlag} -o custom-columns=NAME:.metadata.name)
    for dep in $deployments; do
      if [ ! "$dep" == "NAME" ]; then
        kubectl scale --replicas=0 deployment/${dep} -n ${namespace} ${kubeconfigFlag}
        if [ $? -ne 0 ]; then echo WARNING: Failed to stop deployment; fi
      fi
    done
    # waiting default terminationGracePeriodSeconds
    sleep 30
  fi
  exit 0
fi

if [ "$localChart" == "true" ]; then
  echo INFO: Using local chart.
  chartVersion=
  if [ "$depUpEnabled" == "true" ]; then
    echo INFO: Running dependency update..
    helm dep up ${chart}
  fi
else
  echo INFO: Using chart ${chart} ${chartVersion}
fi

helmArgs="${helmArgs} --reset-values"
if [ "$1" == "dryrun" ]; then
  echo INFO: Doing a dry-run ..
  helmArgs="${helmArgs} --dry-run"
else
  echo INFO: Installing ifs-cloud
fi

echo INFO: Running helm upgrade
helm upgrade --install ifs-cloud ${chart} ${chartVersion} ${helmConfigFlag} --debug --timeout 15m --namespace ${namespace} ${helmArgs}
if [ $? -ne 0 ]; then echo SEVERE: Failed to install ifs-cloud; exit 1; fi

if [ "$1" == "dryrun" ]; then
  echo INFO: Dry run succeeded
else
  echo INFO:IFS Cloud installed
fi

exit 0