#!/bin/bash

help_args ()
{
echo
echo
echo Usage: db-deploy.sh deliveryPath="<path>" fileName="<fullpath>" userName="<user>" password="<pwd>" [sysPassword="<pwd>"] [ialOwner="<ialowner>"]
echo                     connectString="<jdbcurl>" logFilePath="<path>" [extLogging="<Y|N>"] [waitingTime="<value>"] [initialPasswords="<value>"]
echo
echo "      deliveryPath      Path to BUILD_HOME or DELIVERY"
echo "      fileName          Full path name of a file to deploy. The file will be deployed in userName schema."
echo "      userName          User name" 
echo "      password          Password"
echo "      sysPassword       Password for SYS user. If not given, prepare.sql as SYS will not be run"
echo "      ialOwner          IAL schema owner. If not given, ial.tem will not be run."
echo "      connectString     Jdbc url"
echo "      logFilePath       Path to logs folder"
echo "      extLogging        Extended logging Y|N, default = N"
echo "      waitingTime       Waiting time if locked processes, default = 3600 (one hour)"
echo "      initialPasswords  Only used when running as SYS and new internal users are created requiring custom passwords."
echo
exit 1
}

if [[ $1 == "?" ]] || [[ $1 == "/?" ]] || [[ $1 == "--help" ]] || [[ $1 == "/help" ]]; then	
	help_args 
fi
pushd `dirname $0`
LIB="$(dirname $(pwd))/lib"
CLASSPATH=$LIB/ifs-fnd-dbbuild.jar:$LIB/snakeyaml-1.26.jar:$LIB/ojdbc.jar:$LIB/databaseInstaller/org-netbeans-modules-editor-util.jar
CLASSPATH=$CLASSPATH:$LIB/databaseInstaller/org-netbeans-modules-lexer.jar:$LIB/databaseInstaller/org-openide-util.jar

java -Xmx4096m -cp $CLASSPATH -Djava.awt.headless=true -Duser.language=en -Duser.country=US ifs.fnd.dbbuild.DatabaseInstaller "$@"
popd
