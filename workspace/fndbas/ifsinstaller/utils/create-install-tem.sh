#!/bin/bash

help_args ()
{
echo
echo
echo Usage: create-install-tem.sh deliveryPath="<path>" buildHomePath="<path>" [userName="<user>"] [password="<pwd>"] [connectString="<jdbcurl>"]
echo
echo "      deliveryPath             Path to DELIVERY (can be same as BUILD_HOME)"
echo "      buildHomePath            Path to BUILD_HOME"
echo "      userName (optional)      User name for application owner (if not given, install.ini will not be updated according to database information)"
echo "      password (optional)      Password for applicaton owner (if not given, install.ini will not be updated according to database information)"
echo "      connectString (optional) Jdbc url (if not given, install.ini will not be updated according to database information)"
echo
exit 1
}

if [[ $1 == "?" ]] || [[ $1 == "/?" ]] || [[ $1 == "--help" ]] || [[ $1 == "/help" ]]; then	
	help_args 
fi
pushd `dirname $0` >/dev/null
LIB="$(dirname $(pwd))/lib"
CLASSPATH=$LIB/ifs-fnd-dbbuild.jar:$LIB/ojdbc.jar:$LIB/snakeyaml-1.26.jar

java -cp $CLASSPATH  -Duser.language=en -Duser.country=US ifs.fnd.dbbuild.CreateInstallTem type=installtem "$@"
RESULT=$?
popd >/dev/null
exit $RESULT
