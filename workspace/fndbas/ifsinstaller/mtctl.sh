#!/bin/bash
bash utils/verify_required_software.sh --java --kubectl
if ! [ $? -eq 0 ]; then
    exit 1
fi
java -cp lib/mtctl.jar ifs.cloud.client.Client $*
exit $?