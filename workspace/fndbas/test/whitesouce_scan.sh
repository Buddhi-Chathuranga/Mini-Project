#!/usr/bin/env bash
chmod -R 760 *
#echo "docker.includes=.*ifs/$IMAGE.*" >> wss-unified-agent.config
docker login -u 56295112-62e8-4b06-aa62-96aabdcbe33d -p $AZURE_SCA_PASSWORD rnddockerdev.azurecr.io
docker pull rnddockerdev.azurecr.io/ifs/ifsapp-amm:21.1.0.0.0
docker pull rnddockerdev.azurecr.io/ifs/ifsapp-application-svc:21.1.0.2.0
docker pull rnddockerdev.azurecr.io/ifs/ifsapp-busmod:21.1.0.1.0
docker pull rnddockerdev.azurecr.io/ifs/ifsapp-client:21.1.0.20210302103457.0
docker pull rnddockerdev.azurecr.io/ifs/ifsapp-client-services:21.1.0.20210302103457.0
docker pull rnddockerdev.azurecr.io/ifs/ifsapp-connect:21.1.0.1.0
docker pull rnddockerdev.azurecr.io/ifs/ifsapp-crt:21.E1.1.1006.0
docker pull rnddockerdev.azurecr.io/ifs/ifsapp-crtsvc:21.E1.1.1001.0
docker pull rnddockerdev.azurecr.io/ifs/ifsapp-doc:21.1.0.20210302034153.0
docker pull rnddockerdev.azurecr.io/ifs/ifsapp-iam:21.1.0.1.0
docker pull rnddockerdev.azurecr.io/ifs/ifsapp-native-odata:21.1.0-20210302135109.0
docker pull rnddockerdev.azurecr.io/ifs/ifsapp-native-server:21.1.0-20210302135109.0
docker pull rnddockerdev.azurecr.io/ifs/ifsapp-odata:21.1.0.20210302121136.0
docker pull rnddockerdev.azurecr.io/ifs/ifsapp-proxy:21.1.0.2.0
docker pull rnddockerdev.azurecr.io/ifs/ifsapp-rem:21.1E.3.1000.0
docker pull rnddockerdev.azurecr.io/ifs/ifsapp-reporting:21.1.0.2.0
docker pull rnddockerdev.azurecr.io/ifs/ifsapp-rmpanel:21.2E.0.2.0
docker pull rnddockerdev.azurecr.io/ifs/ifsapp-scim:21.1E.0.1002.0
docker pull rnddockerdev.azurecr.io/ifs/ifs-db-init:21.1.0.1.0
docker pull rnddockerdev.azurecr.io/ifs/ifs-forecast:21.1E.0.20210301182727.0
docker pull rnddockerdev.azurecr.io/ifs/ifsmaintenix-appserver:21.1E.2.8342.0
docker pull rnddockerdev.azurecr.io/ifs/ifsmaintenix-reportserver:21.1E.2.8342.0

java -jar /ifs/whitesource/wss-unified-agent.jar -c wss-unified-agent.config