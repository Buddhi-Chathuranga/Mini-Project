#!/bin/bash

usage() { 
   echo "This script restores a backed up namespace."
   echo "Params:"
   echo "  -b backupPath (Mandatory): Path to where the backups are stored."
   echo "  -n namespace (Mandatory): Name of the backed up namespace."
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
   echo "backupPath (-n <backupPath>) is mandatory"
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

revision=`cat $backupPath/revision`
kubectl apply -f "$backupPath/namespace_backup.yaml" $kubectlArgs
kubectl apply -f "$backupPath/content_backup.yaml" $kubectlArgs
helm rollback ifs-cloud $revision -n $namespace $helmArgs
