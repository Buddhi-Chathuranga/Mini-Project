#!/bin/bash

usage() { 
   echo "This script creates a backup of a namespace."
   echo "Params:"
   echo "  -b backupPath (Mandatory): Path to where to store the backups."
   echo "  -n namespace (Mandatory): Namespace to backup."
   echo "  -k kubeconfig (Optional): Path to kubeconfig file."
   echo "  -c context (Optional): Context (or kube-context) to use."
   exit 1
}

while getopts :b:n:k:c: flag
do
    case "${flag}" in
        b) backupPath=${OPTARG};;
        n) namespace=${OPTARG};;
        k) kubeconfig=${OPTARG};;
        c) context=${OPTARG};;
        *) usage
    esac
done

jq --version > /dev/null 2>&1
if [ $? -ne 0 ]; then echo Please install jq, then re-run this script.; exit 1; fi

if [ -z ${namespace+x} ]; then 
   echo "namespace (-n <namespace>) is mandatory"
   exit 1
fi

if [ -z ${backupPath+x} ]; then 
   echo "backupPath (-b <backupPath>) is mandatory"
   exit 1
fi

if [ ! -z ${kubeconfig+x} ]; then 
   kubectlArgs="$kubectlArgs --kubeconfig $kubeconfig"
   helmArgs="$helmArgs --kubeconfig $kubeconfig"
fi
   
if [ ! -z ${context+x} ]; then 
   kubectlArgs="$kubectlArgs --context $context"
   helmArgs="$helmArgs --kube-context $context"
fi

helmHistory=$(helm history ifs-cloud -n $namespace -o json $helmArgs)
revision=$(echo $helmHistory | jq '.[] | select(.status=="deployed")' | jq '.revision')

mkdir -p $backupPath
echo $revision > $backupPath/revision
kubectl get secrets -n $namespace -o yaml $kubectlArgs > $backupPath/content_backup.yaml
kubectl get ns $namespace -o yaml $kubectlArgs > $backupPath/namespace_backup.yaml
