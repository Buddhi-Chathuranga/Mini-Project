#!/bin/bash
PKG="--java"
echo $* | grep -q 'action=' || PKG="$PKG --kubectl --helm"
echo $* | grep -q 'action=mtinstaller\|action=delete' && PKG="$PKG --kubectl --helm"
bash utils/verify_required_software.sh $PKG
if ! [ $? -eq 0 ]; then
    exit 1
fi
java -cp .:lib/ifsinstaller.jar:lib/snakeyaml-1.26.jar:lib/ojdbc.jar ifs.installer.Installer --values version.yaml $*