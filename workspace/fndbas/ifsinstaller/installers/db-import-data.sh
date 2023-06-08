#!/bin/bash

help_args ()
{
echo
echo
echo Usage: db-import_data.sh deliveryPath="<path>" userName="<user>" password="<pwd>" connectString="<jdbcurl>" logFilePath="<path>"
echo                          [transRuntime="<Y|N>"] [transImportAttributes="<Y|N>"] [transImportTranslations="<Y|N>"]
echo
echo "      deliveryPath             Path to BUILD_HOME or DELIVERY"
echo "      userName                 User name for application owner" 
echo "      password                 Password for applicaton owner"
echo "      connectString            Jdbc url"
echo "      logFilePath              Path to logs folder"
echo "      transRuntime             Only runtime files should be imported, Y/N, default = Y"
echo "      transImportAttributes    Import translatable attributes, Y/N, default = Y"
echo "      transImportTranslations  Import translations, Y/N, default = Y"
echo
exit 1
}

if [[ $1 == "?" ]] || [[ $1 == "/?" ]] || [[ $1 == "--help" ]] || [[ $1 == "/help" ]]; then	
	help_args 
fi
pushd `dirname $0`
LIB="$(dirname $(pwd))/lib"
CLASSPATH=$LIB/ifs-fnd-import.jar:$LIB/ojdbc.jar

java -Xmx4096m -cp $CLASSPATH -Djava.awt.headless=true -Duser.language=en -Duser.country=US ifs.fnd.dataimport.DataImport "$@"
popd
