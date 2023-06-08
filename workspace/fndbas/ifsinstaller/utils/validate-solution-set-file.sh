#!/bin/bash

help_args ()
{
echo
echo
echo Usage: validate-solution-set-file.sh deliveryPath="<path>" buildHomePath="<path>" 
echo
echo "      deliveryPath   Path location for DELIVERY"
echo "      buildHomePath  Path location for BUILD_HOME"
echo
exit 1
}

if [[ $1 == "?" ]] || [[ $1 == "/?" ]] || [[ $1 == "--help" ]] || [[ $1 == "/help" ]]; then	
	help_args 
fi
pushd `dirname $0` >/dev/null
LIB="$(dirname $(pwd))/lib"
CLASSPATH=$LIB/ifs-fnd-dbbuild.jar:$LIB/snakeyaml-1.26.jar

java -cp $CLASSPATH -Duser.language=en -Duser.country=US ifs.fnd.dbbuild.CreateInstallTem type=validate "$@"
RESULT=$?
popd >/dev/null
exit $RESULT
